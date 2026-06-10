# AWS Resource Lister

A Bash script that automates the process of listing AWS active resources across **30 services** commonly used by DevOps engineers — using the AWS CLI and a simple command-line interface.

---

## Table of Contents

- [Overview](#overview)
- [Supported Services](#supported-services)
- [Prerequisites](#prerequisites)
- [Setup & Configuration](#setup--configuration)
- [Usage](#usage)
- [Expected Output](#expected-output)
- [Troubleshooting](#troubleshooting)
- [Security Notes](#security-notes)
- [Contributing](#contributing)

---

## Overview

Managing AWS infrastructure across multiple services can be time-consuming. This script provides a single, unified command to quickly list resources for any supported AWS service in a given region — saving time during audits, debugging sessions, and infrastructure reviews.

---

## Supported Services

### Compute & Networking
| # | Service | Input Key | Scope |
|---|---------|-----------|-------|
| 1 | EC2 Instances | `ec2` | Regional |
| 2 | VPC | `vpc` | Regional |
| 3 | EBS Volumes | `ebs` | Regional |
| 4 | Auto Scaling Groups | `autoscaling` | Regional |
| 5 | Application Load Balancer | `alb` | Regional |

### Storage & Database
| # | Service | Input Key | Scope |
|---|---------|-----------|-------|
| 6 | S3 Buckets | `s3` | Global |
| 7 | RDS Instances | `rds` | Regional |
| 8 | DynamoDB Tables | `dynamodb` | Regional |
| 9 | ElastiCache Clusters | `elasticache` | Regional |

### Containers & Serverless
| # | Service | Input Key | Scope |
|---|---------|-----------|-------|
| 10 | EKS Clusters | `eks` | Regional |
| 11 | ECS Clusters | `ecs` | Regional |
| 12 | ECR Repositories | `ecr` | Regional |
| 13 | Lambda Functions | `lambda` | Regional |

### CI/CD & DevOps
| # | Service | Input Key | Scope |
|---|---------|-----------|-------|
| 14 | CodePipeline | `codepipeline` | Regional |
| 15 | CodeBuild | `codebuild` | Regional |
| 16 | CodeDeploy | `codedeploy` | Regional |

### Messaging & Notifications
| # | Service | Input Key | Scope |
|---|---------|-----------|-------|
| 17 | SNS Topics | `sns` | Regional |
| 18 | SQS Queues | `sqs` | Regional |

### Monitoring & Infrastructure as Code
| # | Service | Input Key | Scope |
|---|---------|-----------|-------|
| 19 | CloudWatch Alarms | `cloudwatch` | Regional |
| 20 | CloudFormation Stacks | `cloudformation` | Regional |

### CDN & DNS
| # | Service | Input Key | Scope |
|---|---------|-----------|-------|
| 21 | CloudFront Distributions | `cloudfront` | Global |
| 22 | Route53 Hosted Zones | `route53` | Global |

### Identity & Access
| # | Service | Input Key | Scope |
|---|---------|-----------|-------|
| 23 | IAM Users | `iam` | Global |

### Security & Compliance
| # | Service | Input Key | Scope |
|---|---------|-----------|-------|
| 24 | KMS Keys | `kms` | Regional |
| 25 | Secrets Manager | `secretsmanager` | Regional |
| 26 | SSM Parameter Store | `ssm` | Regional |
| 27 | WAF Web ACLs | `waf` | Regional |
| 28 | AWS Backup Vaults | `backup` | Regional |
| 29 | AWS Config Rules | `config` | Regional |
| 30 | GuardDuty Detectors | `guardduty` | Regional |

> **Note:** Global services (S3, IAM, CloudFront, Route53) do not require a region flag and will list resources across all regions.

---

## Prerequisites

Ensure the following tools are installed before running the script:

| Tool | Purpose | Install Command |
|------|---------|-----------------|
| `bash` | Script interpreter | Pre-installed on Linux/macOS |
| `aws cli` | Communicates with AWS APIs | See [AWS CLI Install Guide](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html) |

### Verify Installation

```bash
aws --version
```

Expected output:
```
aws-cli/2.x.x Python/3.x.x ...
```

---

## Setup & Configuration

### Step 1 — Configure the AWS CLI

If you have not already configured the AWS CLI, run:

```bash
aws configure
```

You will be prompted for:

```
AWS Access Key ID:      your-access-key-id
AWS Secret Access Key:  your-secret-access-key
Default region name:    us-east-1
Default output format:  json
```

This creates the `~/.aws/credentials` file that the script checks for before execution.

### Step 2 — Getting AWS Access Keys

1. Log in to the **AWS Management Console**
2. Click your **account name** (top-right) → **Security Credentials**
3. Scroll to **Access Keys** → click **Create Access Key**
4. Download or copy the **Access Key ID** and **Secret Access Key**

> ⚠️ **Important:** Store your credentials securely. Never commit them to version control.

### Step 3 — Grant Execute Permission to the Script

```bash
chmod 755 list-aws-resource.sh
```

---

## Usage

### Syntax

```bash
./list-aws-resource.sh <aws_region> <aws_service>
```

Or alternatively:

```bash
sh list-aws-resource.sh <aws_region> <aws_service>
```

### Arguments

| Argument | Description | Example |
|----------|-------------|---------|
| `aws_region` | The AWS region to query | `us-east-1`, `eu-west-1` |
| `aws_service` | The AWS service to list (case-insensitive) | `ec2`, `s3`, `eks` |

### Examples

```bash
# List all EC2 instances in US East
./list-aws-resource.sh us-east-1 ec2

# List all S3 buckets (global service — region still required as argument)
./list-aws-resource.sh us-east-1 s3

# List all EKS clusters in EU West
./list-aws-resource.sh eu-west-1 eks

# List all Lambda functions in AP Southeast
./list-aws-resource.sh ap-southeast-1 lambda

# List all CodePipeline pipelines
./list-aws-resource.sh us-east-1 codepipeline

# List all Secrets Manager secrets
./list-aws-resource.sh us-east-1 secretsmanager

# Service names are case-insensitive
./list-aws-resource.sh us-east-1 EC2
./list-aws-resource.sh us-east-1 Ec2
./list-aws-resource.sh us-east-1 ec2
```

---

## Expected Output

### Successful Output

```bash
$ ./list-aws-resource.sh us-east-1 ec2

Listing EC2 Instances in us-east-1
{
    "Reservations": [
        {
            "InstanceId": "i-0abc123def456",
            "InstanceType": "t3.micro",
            "State": { "Name": "running" },
            ...
        }
    ]
}
```

### No Resources Found

```bash
Listing Lambda Functions in us-east-1
{
    "Functions": []
}
```

### Invalid Service

```bash
$ ./list-aws-resource.sh us-east-1 invalidservice

Invalid service. Please enter a valid service.
```

### Missing Arguments

```bash
$ ./list-aws-resource.sh

Usage: ./list-aws-resource.sh <aws_region> <aws_service>
Example: ./list-aws-resource.sh us-east-1 ec2
```

---

## Troubleshooting

| Error | Cause | Fix |
|-------|-------|-----|
| `AWS CLI is not installed` | AWS CLI missing | Install via `pip install awscli` or [official guide](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html) |
| `AWS CLI is not configured` | `~/.aws/credentials` file missing | Run `aws configure` |
| `Invalid service` | Unsupported or misspelled service name | Check the [Supported Services](#supported-services) table |
| `Could not connect to endpoint` | Wrong region or network issue | Verify the region name is valid (e.g. `us-east-1`) |
| `Access Denied` | IAM permissions insufficient | Ensure your IAM user/role has `ReadOnly` or relevant permissions |
| `Missing arguments` | No arguments passed to the script | Provide both `aws_region` and `aws_service` |

---

## Security Notes

- **Never hardcode** AWS credentials inside the script
- **Never commit** your `~/.aws/credentials` file to version control — add it to `.gitignore`
- Use **IAM roles** instead of access keys when running this script on EC2 or other AWS services
- Apply the **principle of least privilege** — grant only the read permissions needed
- **Rotate access keys** regularly and revoke unused ones
- For team environments, consider using **AWS SSO** or **IAM Identity Center** instead of static credentials

---

## Contributing

1. Fork this repository
2. Create a new branch: `git checkout -b feature/add-new-service`
3. Add your changes and test them
4. Commit: `git commit -m "feat: add support for <service-name>"`
5. Push: `git push origin feature/add-new-service`
6. Open a Pull Request

---

## Author

**ONEIL KIMBI**
Version: v1.2.0

---

## License

This project is open-source and available under the [MIT License](LICENSE).
