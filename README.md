# Terraform AWS Infrastructure Project

## Purpose

This project provisions a simple AWS lab environment with Terraform. The current root module creates two EC2 instances with Nginx plus the related key pairs, security groups, and outputs.

## Project Architecture

### Main Components

1. **EC2 Instances**

   - Creation of 2 independent EC2 instances
   - Names: `nginx-server-dev` and `nginx-server-qa`
   - AMI selected through the `ami_id` variable in the module call
   - Automatic Nginx installation as web server

2. **SSH Access Management**

   - SSH key pair configuration is part of the Terraform root/module setup
   - Separate key pair resource per module instance

3. **Security Configuration**

    - **Security Groups** configured with specific rules:
      - **Port 80 (HTTP)**: Public access for web traffic
      - **Port 22 (SSH)**: Restricted according to the input values used at plan/apply time
   - Outbound traffic is currently open to all destinations

4. **Tagging and Organization**

   - Consistent tag implementation for:
     - Resource identification
     - Cost management
     - Environment organization
     - Operational traceability

5. **S3 Backend**

   - Uses a pre-existing S3 bucket for Terraform state
   - The tracked backend block sets `bucket`, `key`, `region`, `encrypt`, and `use_lockfile`

## Specific Objectives

### Technical

- Automate web infrastructure deployment
- Establish reproducible configuration across environments
- Keep the example small enough to inspect and learn from

### Operational

- Reduce server provisioning time
- Minimize manual configuration errors
- Provide clear process documentation

## Use Case

**Scenario**: Web server deployment for hosting client websites in dev and QA environments.

**Benefits**:

- Standardized Terraform workflow for repeatable provisioning
- Consistent configuration across environments
- Easy replication for experiments
- Centralized infrastructure management

## Deliverables

- AWS infrastructure defined in Terraform
- Nginx bootstrap on both EC2 instances
- SSH access configured through input public key values
- Versioned Terraform code with outputs for inspection

## Technologies Used

- **Terraform**
- **AWS CLI**
- **AWS Provider** for Terraform

## Prerequisites

### Required Software

1. **Terraform**

   ```bash
   terraform version
   ```

2. **AWS CLI** configured

   ```bash
   aws --version
   ```

3. **Git** to clone the repository

   ```bash
   git --version
   ```

### AWS Configuration

1. **AWS Credentials**

   ```bash
   aws configure
   ```

   Or set environment variables:

   ```bash
   export AWS_ACCESS_KEY_ID="your-access-key"
   export AWS_SECRET_ACCESS_KEY="your-secret-key"
   export AWS_DEFAULT_REGION="us-east-1"
   ```

2. **AWS Access Scope**

   Use AWS credentials that can manage the EC2, key pair, security group, and S3 backend resources referenced by this configuration.

3. **Pre-existing S3 Backend Bucket**

    ```hcl
    terraform {
      backend "s3" {
        bucket       = "infrastructure-automatization-with-terraform"
        key          = "infrastructure-automatization/terraform.tfstate"
        region       = "us-east-1"
        encrypt      = true
        use_lockfile = true
      }
    }
    ```

## Installation and Usage

### 1. Clone the Repository

```bash
git clone https://github.com/horus0523/Infrastructure-Automation-with-Terraform-and-AWS.git
cd Infrastructure-Automation-with-Terraform-and-AWS
```

### 2. Prepare input values

Before planning or applying, provide the input values required by the current
root module using your normal Terraform workflow. The repository includes
`terraform.tfvars.example` as a template with safe placeholder values.

Copy that file to a local ignored file such as `local.tfvars` or
`<your-local-file>.tfvars`, replace the placeholders with your real values, and
keep that local file outside version control.

### 3. Initialize Terraform

```bash
terraform init
```

### 4. Validate Configuration

```bash
terraform validate
terraform fmt
```

### 5. Plan Deployment

```bash
cp terraform.tfvars.example local.tfvars
# Edit local.tfvars with real values before planning.
terraform plan -var-file=local.tfvars
```

Terraform automatically loads `terraform.tfvars` and `*.auto.tfvars` files from the working directory. Other `.tfvars` files require `-var-file`. Remember that `-var-file` only changes input values for the same root module. It does not select a single environment module.

```bash
terraform plan -var-file=<your-local-file>.tfvars
```

On an empty state, the current root module still plans both `nginx_server_dev` and `nginx_server_qa`, so the expected summary is **6 resources to add**.

### 6. Apply Changes

```bash
terraform apply -var-file=local.tfvars

# or use your own ignored filename
terraform apply -var-file=<your-local-file>.tfvars
```

### 7. Verify Resources

```bash
terraform output
terraform show
```

To validate the deployed Nginx instances after a real apply:

```bash
curl http://<nginx_dev_ip>
curl http://<nginx_qa_ip>
```

Treat the HTTP 200 response as expected runtime evidence, not as evidence already captured in this repository.

### 8. Connect to EC2 Instances

**Connect to `nginx-server-dev`**

```bash
ssh -i /path/to/private-key ec2-user@publicIP
```

**Connect to `nginx-server-qa`**

```bash
ssh -i /path/to/private-key ec2-user@publicIP
```

## Project Structure

```text
infrastructure-automation-with-terraform-and-aws/
├── main.tf                   # Main configuration
├── nginx_server_module/      # Reusable modules
│   ├── 00.variables.tf       # Variable definitions
│   ├── 01.provider.tf        # Provider definition
│   ├── 02.ec2.tf             # EC2 instance definition
│   ├── 03.key.tf             # Key pair definition
│   ├── 04.sg.tf              # Security group definition
│   └── 05.outputs.tf         # Output definitions
└── README.md                 # README file
```

## Configuration Variables

### Main Variables

| Variable | Description | Default Value |
| -------- | ----------- | ------------- |
| `aws_region` | AWS region for the root module | `us-east-1` |
| `allowed_ssh_cidr` | Trusted IPv4 CIDR allowed to reach SSH on both instances | `127.0.0.1/32` |
| `nginx_dev_public_key` | SSH public key contents for the dev key pair | Required |
| `nginx_qa_public_key` | SSH public key contents for the qa key pair | Required |
| `common_tags` | Optional extra tags merged into all resources | `{}` |

## Useful Commands

### State Management

```bash
terraform state list
terraform state show aws_instance.example
terraform import aws_instance.example i-123450abcde0
```

### Workspace Management

```bash
terraform workspace new production
terraform workspace select development
terraform workspace list
```

### Destroy Infrastructure

```bash
terraform destroy -var-file="local.tfvars"
```

## Security

### Current Tracked Posture

- Uses a remote S3 backend for shared state
- Uses explicit security group ingress rules for SSH and HTTP
- Uses tags for traceability
- Does not currently attach IAM roles to the EC2 instances
- SSH ingress depends on the input values supplied at plan/apply time

## Troubleshooting

### Common Errors

1. **AWS Credentials Error**

   ```bash
   aws sts get-caller-identity
   ```

2. **Locked State**

   ```bash
   terraform force-unlock LOCK_ID
   ```

## Additional Resources

- [Official Terraform Documentation](https://www.terraform.io/docs)
- [AWS Provider Guide](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [Terraform Best Practices](https://www.terraform.io/docs/cloud/guides/recommended-practices/index.html)
