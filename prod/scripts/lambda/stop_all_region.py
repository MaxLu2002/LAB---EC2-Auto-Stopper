import boto3
from botocore.exceptions import ClientError, BotoCoreError
import json

event = {
  "region": "ap-northeast-1",
  "instance_ids": ["i-032163faca41c7531"]
}

def lambda_handler(event, context):
    try:
        region = event.get('region')
        if not region:
            return {
                'statusCode': 400,
                'body': json.dumps({
                    'message': 'No region provided',
                    'instances': None,
                    'event': event
                })
            }

        ec2 = boto3.client('ec2', region_name=region)
        print("階段一：從 API 接收 Instance IDs 和 Region")

        instance_ids = event.get('instance_ids')

        if not instance_ids:
            return {
                'statusCode': 400,
                'body': json.dumps({
                    'message': 'No instance IDs provided',
                    'instances': None,
                    'event': event
                })
            }

        instance_ids = list(instance_ids) if isinstance(instance_ids, set) else instance_ids
        
        print(f"階段二：收到的 EC2 IDs：{instance_ids}")
        
        ec2_resource = boto3.resource('ec2', region_name=region)
        
        stopped_instances = []
        failed_instances = []

        for instance_id in instance_ids:
            print(f"Checking if instance {instance_id} exists...")
            instance = ec2_resource.Instance(instance_id)

            try:
                instance.load()  # This will fail if instance doesn't exist
                print(f"階段三：開始更新 {instance_id} 的 tag：instance-state-name => stop")
                instance.create_tags(Tags=[{'Key': 'instance-state-name', 'Value': 'stop'}])

                print(f"階段四：開始停止 EC2 {instance_id}")
                ec2.stop_instances(InstanceIds=[instance_id])
                stopped_instances.append(instance_id)

            except ClientError as e:
                if e.response['Error']['Code'] == 'InvalidInstanceID.NotFound':
                    print(f"Instance {instance_id} not found")
                    failed_instances.append({'id': instance_id, 'error': 'Instance not found'})
                else:
                    print(f"Error with instance {instance_id}: {str(e)}")
                    failed_instances.append({'id': instance_id, 'error': str(e)})

            except BotoCoreError as e:
                print(f"BotoCore error with instance {instance_id}: {str(e)}")
                failed_instances.append({'id': instance_id, 'error': str(e)})

        print("階段五：停止命令已全部發出")

        return {
            'statusCode': 200,
            'body': json.dumps({
                'message': 'EC2 stop operation completed',
                'stopped_instances': stopped_instances,
                'failed_instances': failed_instances
            })
        }

    except Exception as e:
        return {
            'statusCode': 400,
            'body': json.dumps({
                'message': 'EC2 stop operation completed',
                'stopped_instances': stopped_instances,
                'failed_instances': failed_instances
            })
        }
