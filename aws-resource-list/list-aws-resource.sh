#!/bin/bash

###############################################################################
# Author: ONEIL KIMBI
# Version: v1.2.0

# Script to automate the process of listing all the resources in an AWS account
#
# Below are the services that are supported by this script:
# 1. EC2
# 2. RDS
# 3. S3
# 4. CloudFront
# 5. VPC
# 6. IAM
# 7. Route53
# 8. CloudWatch
# 9. CloudFormation
# 10. Lambda
# 11. SNS
# 12. SQS
# 13. DynamoDB
# 14. EBS
# 15. EKS
# 16. ECS
# 17. ECR
# 18. CodePipeline
# 19. CodeBuild
# 20. CodeDeploy
# 21. ElastiCache
# 22. ALB (Application Load Balancer)
# 23. Auto Scaling
# 24. Secrets Manager
# 25. SSM (Systems Manager Parameter Store)
# 26. KMS
# 27. WAF
# 28. Backup
# 29. Config
# 30. GuardDuty
#
# The script will prompt the user to enter the AWS region and the service
# for which the resources need to be listed.
#
# Usage:   ./list-aws-resource.sh <aws_region> <aws_service>
# Example: ./list-aws-resource.sh us-east-1 ec2
###############################################################################

# Check if the required number of arguments are passed in the cli before execution
if [ $# -ne 2 ]; then
    echo "Usage: ./list-aws-resource.sh <aws_region> <aws_service>"
    echo "Example: ./list-aws-resource.sh us-east-1 ec2"
    exit 1 #script failed to execute
fi

# Assign the arguments to variables and convert the service to lowercase
aws_region=$1
aws_service=$(echo "$2" | tr '[:upper:]' '[:lower:]')

# Check if the AWS CLI is installed
if ! command -v aws &> /dev/null; then
    echo "AWS CLI is not installed. Please install the AWS CLI and try again."
    exit 1 #if it is not installed then the script fils
fi

# Check if the AWS CLI is configured
if [ ! -f ~/.aws/credentials ]; then
    echo "AWS CLI is not configured. Please configure the AWS CLI and try again."
    exit 1 #fail if not configured
fi

# List the resources based on the service
#instead of using if else lets use switch case because it is less complex
case $aws_service in
    ec2)
        echo "Listing EC2 Instances in $aws_region"
        aws ec2 describe-instances --region "$aws_region"
        ;;
    rds)
        echo "Listing RDS Instances in $aws_region"
        aws rds describe-db-instances --region "$aws_region"
        ;;
    s3)
        echo "Listing S3 Buckets in $aws_region"
        aws s3api list-buckets
        ;;
    cloudfront)
        echo "Listing CloudFront Distributions in $aws_region"
        aws cloudfront list-distributions
        ;;
    vpc)
        echo "Listing VPCs in $aws_region"
        aws ec2 describe-vpcs --region "$aws_region"
        ;;
    iam)
        echo "Listing IAM Users in $aws_region"
        aws iam list-users
        ;;
    route53)
        echo "Listing Route53 Hosted Zones in $aws_region"
        aws route53 list-hosted-zones
        ;;
    cloudwatch)
        echo "Listing CloudWatch Alarms in $aws_region"
        aws cloudwatch describe-alarms --region "$aws_region"
        ;;
    cloudformation)
        echo "Listing CloudFormation Stacks in $aws_region"
        aws cloudformation describe-stacks --region "$aws_region"
        ;;
    lambda)
        echo "Listing Lambda Functions in $aws_region"
        aws lambda list-functions --region "$aws_region"
        ;;
    sns)
        echo "Listing SNS Topics in $aws_region"
        aws sns list-topics --region "$aws_region"
        ;;
    sqs)
        echo "Listing SQS Queues in $aws_region"
        aws sqs list-queues --region "$aws_region"
        ;;
    dynamodb)
        echo "Listing DynamoDB Tables in $aws_region"
        aws dynamodb list-tables --region "$aws_region"
        ;;
    ebs)
        echo "Listing EBS Volumes in $aws_region"
        aws ec2 describe-volumes --region "$aws_region"
        ;;

    # Container & Kubernetes services — core to modern DevOps workflows
    eks)
        echo "Listing EKS Clusters in $aws_region"
        aws eks list-clusters --region "$aws_region"
        ;;
    ecs)
        echo "Listing ECS Clusters in $aws_region"
        aws ecs list-clusters --region "$aws_region"
        ;;
    ecr)
        echo "Listing ECR Repositories in $aws_region"
        aws ecr describe-repositories --region "$aws_region"
        ;;

    # CI/CD services — used daily for pipeline management and deployments
    codepipeline)
        echo "Listing CodePipeline Pipelines in $aws_region"
        aws codepipeline list-pipelines --region "$aws_region"
        ;;
    codebuild)
        echo "Listing CodeBuild Projects in $aws_region"
        aws codebuild list-projects --region "$aws_region"
        ;;
    codedeploy)
        echo "Listing CodeDeploy Applications in $aws_region"
        aws deploy list-applications --region "$aws_region"
        ;;

    # Caching service — used for performance optimization
    elasticache)
        echo "Listing ElastiCache Clusters in $aws_region"
        aws elasticache describe-cache-clusters --region "$aws_region"
        ;;

    # Load balancing — used for traffic distribution across services
    alb)
        echo "Listing Application Load Balancers in $aws_region"
        aws elbv2 describe-load-balancers --region "$aws_region"
        ;;

    # Auto Scaling — used for managing dynamic workloads
    autoscaling)
        echo "Listing Auto Scaling Groups in $aws_region"
        aws autoscaling describe-auto-scaling-groups --region "$aws_region"
        ;;

    # Secrets & configuration management — used for secure credential storage
    secretsmanager)
        echo "Listing Secrets in Secrets Manager in $aws_region"
        aws secretsmanager list-secrets --region "$aws_region"
        ;;
    ssm)
        echo "Listing SSM Parameter Store Parameters in $aws_region"
        aws ssm describe-parameters --region "$aws_region"
        ;;

    # Encryption — used for managing encryption keys across services
    kms)
        echo "Listing KMS Keys in $aws_region"
        aws kms list-keys --region "$aws_region"
        ;;

    # Security & compliance services — used for auditing and threat detection
    waf)
        echo "Listing WAF Web ACLs in $aws_region"
        aws wafv2 list-web-acls --scope REGIONAL --region "$aws_region"
        ;;
    backup)
        echo "Listing AWS Backup Vaults in $aws_region"
        aws backup list-backup-vaults --region "$aws_region"
        ;;
    config)
        echo "Listing AWS Config Rules in $aws_region"
        aws configservice describe-config-rules --region "$aws_region"
        ;;
    guardduty)
        echo "Listing GuardDuty Detectors in $aws_region"
        aws guardduty list-detectors --region "$aws_region"
        ;;

    *)
        echo "Invalid service. Please enter a valid service."
        exit 1
        ;;
esac