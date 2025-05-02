import boto3
import os
from datetime import datetime, timedelta

api_url = os.environ['API_URL']
sns_topic = os.environ['SNS_TOPIC']

def lambda_handler(event, context):
    regions = [r['RegionName'] for r in boto3.client('ec2').describe_regions()['Regions']]
    sns = boto3.client('sns')
    threshold = 0.1
    Low_cpu_instances = []

    for region in regions:
        print(f"Checking region: {region}")
        ec2 = boto3.client('ec2', region_name=region)
        cw = boto3.client('cloudwatch', region_name=region)

        ids = [
            i['InstanceId']
            for r in ec2.describe_instances(Filters=[
                {'Name': 'tag:AutoStop', 'Values': ['true']},
                {'Name': 'instance-state-name', 'Values': ['running']}
            ])['Reservations']
            for i in r['Instances']
        ]

        if not ids:
            print(f"No AutoStop instances running in {region}")
            continue

        print(f"Instances to check in {region}:", ids)
        now = datetime.utcnow()
        start = now - timedelta(minutes=15)

        for instance_id in ids:
            info = ec2.describe_instances(InstanceIds=[instance_id])['Reservations'][0]['Instances'][0]
            itype = info['InstanceType']
            iname = next((tag['Value'] for tag in info.get('Tags', []) if tag['Key'] == 'Name'), 'No Name')

            dpts = cw.get_metric_statistics(
                Namespace='AWS/EC2',
                MetricName='CPUUtilization',
                Dimensions=[{'Name': 'InstanceId', 'Value': instance_id}],
                StartTime=start,
                EndTime=now,
                Period=900,
                Statistics=['Average']
            )['Datapoints']

            if not dpts:
                print(f"{instance_id} No metrics data")
                continue

            for d in dpts:
                if d['Average'] < threshold:
                    Low_cpu_instances.append({
                        'instance_id': instance_id,
                        'cpu': round(d['Average'], 2),
                        'instance_type': itype,
                        'instance_name': iname,
                        'timestamp': d['Timestamp'],
                        'region': region
                    })
                    print(f"{instance_id} CPU usage {round(d['Average'], 2)} at {d['Timestamp']} below threshold {threshold}")
                    break
            else:
                print(f"{instance_id} Below threshold")

    if Low_cpu_instances:
        try:
            details = "\n".join([
                f"\n• Instance ---{i['instance_name']} ({i['instance_type']})---"
                f"\n  - ID: {i['instance_id']}"
                f"\n  - Region: {i['region']}"
                f"\n  - CPU Usage: {i['cpu'] * 100}%"
                f"\n  - Stop Instance Link: {api_url}/stop/{i['region']}/{i['instance_id']}"
                for i in Low_cpu_instances
            ])

            msg = f"""
Warning: Low CPU Usage Detected
---------------------------------------------------------

{details}

---------------------------------------------------------
*Threshold: {threshold * 100}%
*Check Time: {datetime.utcnow()}
            """

            sns.publish(
                TopicArn=sns_topic,
                Message=msg,
                Subject=f'EC2 Instance Low CPU Alert - {len(Low_cpu_instances)} instances affected'
            )
            print(f"Notification sent for {len(Low_cpu_instances)} instances")

        except Exception as e:
            print(f"Error sending notification: {e}")

    print("------------------------------------------------")
    return {'statusCode': 200, 'body': 'Processing complete'}
