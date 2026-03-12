# Terraform AWS Infrastructure Project

## 💼 Why This Project Matters

> **Problem:** Manual server provisioning across dev/QA environments introduced configuration drift, inconsistent security policies, and wasted engineering hours on repetitive tasks.
> 
> **Solution:** Designed a modular Terraform architecture with reusable modules, remote state management in S3, and parameterized configurations that eliminate manual infrastructure provisioning entirely.
> 
> **Impact:**
> - Eliminated manual server provisioning by implementing fully declarative IaC with reusable Terraform modules
> - Enforced environment parity between dev and QA through parameterized, version-controlled configurations
> - Secured infrastructure state by configuring S3 remote backend with encryption, preventing state corruption in team workflows
> - Reduced security attack surface by implementing Security Groups that restrict access to only required ports (SSH/HTTP), with documented guidance for IP-based restriction in production environments
> - Automated web server bootstrapping via EC2 user_data scripts, ensuring Nginx is installed, enabled, and running at instance launch without manual intervention
> - Protected sensitive outputs (private IPs, instance IDs) using Terraform's `sensitive` flag to prevent accidental exposure in logs

## 🏷️ Keywords & Technologies

`Terraform` · `AWS EC2` · `AWS S3` · `Infrastructure as Code (IaC)` · `Remote State Management` · `Terraform Modules` · `Security Groups` · `SSH Key Management` · `IAM` · `Nginx` · `Multi-Environment Deployment` · `HCL` · `AWS CLI` · `DevOps` · `Cloud Infrastructure` · `user_data Bootstrapping` · `ED25519 SSH Keys`

---

## 🎯 Purpose

This project provides a complete AWS infrastructure using Terraform as an Infrastructure as Code (IaC) tool. The solution provides a scalable and reproducible environment for hosting client web applications.

## 🏗️ Architecture Diagram

```
┌─────────────────────────────────────────────────────────┐
│                    Terraform CLI                         │
│              (terraform init/plan/apply)                 │
└────────────────────┬────────────────────────────────────┘
                     │
          ┌──────────┴──────────┐
          ▼                     ▼
┌──────────────────┐  ┌──────────────────┐
│   nginx_server   │  │   nginx_server   │
│     module       │  │     module       │
│   (dev env)      │  │   (qa env)       │
├──────────────────┤  ├──────────────────┤
│ • EC2 Instance   │  │ • EC2 Instance   │
│ • user_data:     │  │ • user_data:     │
│   Nginx auto-    │  │   Nginx auto-    │
│   install+start  │  │   install+start  │
│ • Security Group │  │ • Security Group │
│ • SSH Key Pair   │  │ • SSH Key Pair   │
│   (ED25519)      │  │   (ED25519)      │
└──────────────────┘  └──────────────────┘
          │                     │
          └──────────┬──────────┘
                     ▼
          ┌──────────────────┐
          │   S3 Backend     │
          │ (Remote State)   │
          │  + Encryption    │
          └──────────────────┘
```

## 🏗️ Project Architecture

### Main Components

1. **EC2 Instances**

   - Creation of 2 independent EC2 instances
   - Names: `nginx-server-dev` and `nginx_server_qa`
   - Operating system: Amazon Linux 2023 / Ubuntu
   - Automatic Nginx installation as web server

2. **SSH Access Management**

   - SSH key pair generation/configuration
   - Secure access implementation for remote administration
   - Appropriate user permissions configuration

3. **Security Configuration**

   - **Security Groups** configured with specific rules:
     - **Port 80 (HTTP)**: Public access for web traffic
     - **Port 22 (SSH)**: Restricted access for administration
   - Least privilege principle implementation

4. **Tagging and Organization**

   - Consistent tag implementation for:
     - Resource identification
     - Cost management
     - Environment organization
     - Operational traceability

5. **S3 Bucket**

   - Manually create and configure the S3 bucket
   - Configures the Terraform "backend" to store the state file (`tfstate`) in a specific S3 bucket

## 🎯 Specific Objectives

### Technical

- ✅ Automate web infrastructure deployment
- ✅ Implement security best practices
- ✅ Create a scalable foundation for multiple clients
- ✅ Establish reproducible configuration across environments

### Operational

- ✅ Reduce server provisioning time
- ✅ Minimize manual configuration errors
- ✅ Facilitate infrastructure management and maintenance
- ✅ Provide clear process documentation

## 🏢 Use Case

**Scenario**: Web server deployment for hosting client websites in dev and QA environments.

**Benefits**:

- Deployment time reduced from hours to minutes
- Consistent configuration across environments
- Easy replication for new clients
- Centralized infrastructure management

## 📋 Deliverables

- Fully functional AWS infrastructure
- Configured and running Nginx web servers
- Secure SSH access configured
- Documentation of endpoints and credentials
- Versioned and documented Terraform code

## 🛠️ Technologies Used

- **Terraform** >= 1.0
- **AWS CLI** >= 2.0
- **AWS Provider** Terraform

## 📋 Prerequisites

### Required Software

1. **Terraform** (version 1.0 or higher)

   ```bash
   # Verify installation
   terraform version
   ````

2. **AWS CLI** configured

   ```bash
   # Install AWS CLI
   curl "https://awscli.amazonaws.com/awscliv2-exe-linux-x86_64.zip" -o "awscliv2.zip"
   unzip awscliv2.zip
   sudo ./aws/install

   # Verify installation
   aws --version
   ```

3. **Git** to clone the repository
   ```bash
   git --version
   ```

### AWS Configuration

1. **AWS Credentials**

   ```bash
   # Configure credentials
   aws configure
   ```

   Or set environment variables:

   ```bash
   export AWS_ACCESS_KEY_ID="your-access-key"
   export AWS_SECRET_ACCESS_KEY="your-secret-key"
   export AWS_DEFAULT_REGION="us-east-1"
   ```

2. **Required IAM Permissions**

   - EC2FullAccess
   - VPCFullAccess
   - IAMFullAccess
   - S3FullAccess (for remote backend)
   - CloudFormationFullAccess

3. **Requires an S3 Bucket created for later use in the backend**
   ```bash
   terraform {
   backend "s3" {
    bucket  = "infrastructure-automatization-with-terraform" # S3 bucket name
    key     = "infrastructure-automatization-with-terraform/terraform.tfstate" # file path and name
    region  = "us-east-1"
    #encrypt = true # Enable SSE-S3 encryption
   }
   }
   ```

## 🚀 Installation and Usage

### 1. Clone the Repository

```bash
git clone https://github.com/horus0523/Infrastructure-Automation-with-Terraform-and-AWS.git
cd Infrastructure-Automation-with-Terraform-and-AWS
```

### 2. Create the necessary SSH keys to configure the nginx-server

**Create SSH key to nginx-server-dev**

```bash
ssh-keygen -t ed25519 -C "dev@nginx-server" -f ssh-keys/nginx-server-dev.key -N ""
```

**Create SSH key to nginx-server-qa**

```bash
ssh-keygen -t ed25519 -C "qa@nginx-server" -f ssh-keys/nginx-server-qa.key -N ""
```

### 3. Initialize Terraform

```bash
# Initialize working directory
terraform init
```

### 4. Validate Configuration

```bash
# Validate syntax
terraform validate

# Format code
terraform fmt
```

### 5. Plan Deployment

```bash
# View execution plan
terraform plan
```

**Or use**

```bash
# You can generate an execution plan and save it in a binary file called server_qa.tfplan
terraform plan -out=server_qa.tfplan
```

### 6. Apply Changes

```bash
# Apply configuration
terraform apply

# Apply automatically (without confirmation)
terraform apply -auto-approve
```

**Or use**

```bash
# Applies the previously saved plan
terraform apply server_qa.tfplan
```

### 7. Verify Resources

```bash
# View outputs
terraform output

# View current state
terraform show
```

### 8. Connect to EC2 Instances

**Connect to nginx-server-dev**

```bash
ssh -i ./ssh-keys/nginx-server-dev.key ec2-user@publicIP # Replace `publicIP` with your actual public IP. This is shown in the output
```

**Connect to nginx-server-qa**

```bash
ssh -i ./ssh-keys/nginx-server-qa.key ec2-user@publicIP # Replace `publicIP` with your actual public IP. This is shown in the output
```

## 📁 Project Structure

```
infrastructure-automation-with-terraform-and-aws/
├── main.tf                   # Main configuration
├── nginx_server_module/      # Reusable modules
│   ├── 00.variables.tf       # Variable definitions
│   ├── 01.provider.tf        # Provider definition
│   ├── 02.ec2.tf             # EC2 instance definition
│   ├── 03.key.tf             # Key definition
│   ├── 04.sg.tf              # Security groups definition
│   └── 05.outputs.tf         # Output definitions
└── README.md                 # README file
```

## ⚙️ Configuration Variables

### Main Variables

| Variable        | Description            | Type     | Default Value           | Required |
| --------------- | ---------------------- | -------- | ----------------------- | -------- |
| `environment`   | Deployment environment | `string` | `test`                  | ❌       |
| `instance_type` | EC2 instance type      | `string` | `t3.micro`              | ❌       |
| `server_name`   | Server name            | `string` | `nginx-server`          | ❌       |
| `ami_id`        | AMI ID                 | `string` | `ami-0440d3b780d96b29d` | ❌       |

## 🔧 Useful Commands

### State Management

```bash
# List resources in state
tfstate list

# Show specific resource
tfstate show aws_instance.example

# Import existing resource
tfstate import aws_instance.example i-123450abcde0
```

**To import the resource you must uncomment the code block in the `main.tf` file**

```hcl
####### import #######
# Import resources to terraform `ec2 instance`
resource "aws_instance" "server-web" {
  # (resource arguments)
}
```

**Execute the import command**

```bash
terraform import aws_instance.example i-123450abcde0
```

### Workspace Management

```bash
# Create workspace
terraform workspace new production

# Switch workspace
tfworkspace select development

# List workspaces
terraform workspace list
```

### Destroy Infrastructure

```bash
# Destroy all resources
tfstate destroy
```

**Or use**

```bash
# Destroy specific resource
tfstate destroy -target=aws_instance.example
```

## 🔒 Security

### Implemented Best Practices

- ✅ Use of variables for sensitive data
- ✅ Remote backend for shared state
- ✅ State encryption in S3 (enable encryption)
- ✅ Security groups with minimal rules
- ✅ IAM roles with limited permissions
- ✅ Tags for traceability
- ✅ Sensitive outputs protected from log exposure

## 🐛 Troubleshooting

### Common Errors

1. **AWS Credentials Error**

   ```bash
   # Verify configuration
   aws sts get-caller-identity
   ```

2. **Locked State**

   ```bash
   # Force unlock (use with caution)
   terraform force-unlock LOCK_ID
   ```

3. **Permission Error**

   ```bash
   # Verify required IAM permissions
   aws iam list-attached-user-policies --user-name your-username
   ```

## 📚 Additional Resources

- [Official Terraform Documentation](https://www.terraform.io/docs)
- [AWS Provider Guide](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [Terraform Best Practices](https://www.terraform.io/docs/cloud/guides/recommended-practices/index.html)

## 👤 Author

**Horus Chourio** — Cloud DevOps Engineer | AWS Certified Cloud Practitioner | CKA Candidate

- Specializing in Infrastructure as Code, CI/CD pipeline design, and cloud automation on AWS
- [LinkedIn](https://linkedin.com/in/horus-chourio) · [GitHub](https://github.com/horus0523)
