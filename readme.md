# EC2_Auto-Stopper
## About this repo.
This repository provides a solution for automatically stopping underutilized EC2 instances during non-working hours (e.g., 20:00 to 08:00). The goal is to address the issue of low utilization, which is defined in this lab as 10% CPU usage. The solution leverages AWS EventBridge to trigger a Lambda function based on a cron schedule. The Lambda function scans for EC2 instances that meet specific tag policies and low CPU utilization criteria. Once identified, the solution sends an email notification to the user, providing an API link to easily stop the underutilized EC2 instances. This approach ensures efficient resource management and cost optimization while offering users a simple way to take action through the provided email notifications.

![archtecture image] (./image/architecture.png)

## Prerequisites
- Terraform installation (optional)
- AWS IAM user credentials with access and secret keys (optional)
- Terraform configuration setup (optional)

## Deployment Steps
1. Navigate to AWS CloudFormation console
2. Upload the `./cloudformation/main.yaml` template
3. Configure parameters:
    - Stack name
    - Resource Prefix
    - Email address
    - Cron schedule
4. Deploy stack with default settings
5. Confirm SNS subscription via email
6. Receive scan results according to configured schedule

## Important Notes
- Lambda scanner filters EC2 instances by tags (configurable)
- EC2 instances can be stopped via API links in notification emails
- Provided Terraform configuration is for testing purposes only

