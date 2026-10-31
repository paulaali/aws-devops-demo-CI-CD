# AWS DevOps Demo: Infrastructure as Code & CI/CD Pipelines

A practical, hands-on demonstration of Infrastructure as Code (IaC), automated deployments, security checks, infrastructure drift detection and blue/green deployment using Terraform, AWS and GitHub Actions.

**Session:** AWS SBG UB – Infrastructure as Code and CI/CD Pipelines

## Table of Contents

1. Project Overview
2. Learning Objectives
3. Architecture and Technology Stack
4. Prerequisites
5. AWS Account Preparation
6. Installing Required Tools
7. Verifying Your Environment
8. AWS Authentication
9. Getting Started: Clone the Repository
10. Understanding the Project Structure
11. Understanding Terraform
12. Initializing Terraform
13. Formatting and Validating Configuration
14. Generating and Reviewing an Execution Plan
15. Provisioning AWS Infrastructure
16. Understanding Terraform State
17. Git and GitHub Integration
18. CI/CD with GitHub Actions
19. Secure AWS Authentication with OIDC
20. Infrastructure Security and Policy Checks
21. Infrastructure Drift Detection
22. Blue/Green Deployment
23. Testing and Troubleshooting
24. Cost Management and Cleanup
25. Expected Project Outcome
26. Additional Learning Resources

---

# 1. Project Overview

Traditional infrastructure management often involves manually creating and configuring cloud resources through a cloud provider's management console.

This approach can become difficult to maintain, reproduce and scale.

Infrastructure as Code addresses this challenge by allowing infrastructure to be defined, version-controlled and managed through configuration files.

In this project, we use Terraform to define AWS infrastructure and GitHub Actions to automate validation, security checks and deployment.

We will also demonstrate infrastructure drift detection and blue/green deployment strategies.

Our application will be a simple static website hosted on Amazon S3 and delivered through Amazon CloudFront.

### Project scenario

Imagine a development team responsible for maintaining a web application.

The team needs to:

- Provision cloud infrastructure consistently.
- Avoid manually creating resources.
- Validate infrastructure configurations before deployment.
- Automate application deployments.
- Identify unauthorized infrastructure changes.
- Deploy new application versions with minimal disruption.

We will implement a simplified version of this workflow.

# 2. Learning Objectives

By completing this project, participants should be able to:

1. Explain Infrastructure as Code and its benefits.
2. Understand Terraform providers, resources, variables, outputs and state.
3. Provision AWS infrastructure using Terraform.
4. Use Terraform commands to initialize, format, validate, plan and apply infrastructure.
5. Understand Git version control and repository management.
6. Build automated CI/CD workflows using GitHub Actions.
7. Authenticate GitHub Actions securely with AWS using OIDC.
8. Integrate security and policy checks into CI/CD pipelines.
9. Detect and understand infrastructure drift.
10. Explain and demonstrate blue/green deployment.
11. Understand deployment rollback strategies.
12. Manage and clean up cloud resources responsibly.

# 3. Architecture and Technology Stack

| Technology | Purpose |
|---|---|
| Amazon Web Services | Cloud infrastructure |
| Terraform | Infrastructure as Code |
| Git | Version control |
| GitHub | Source code repository |
| GitHub Actions | CI/CD automation |
| AWS IAM | Identity and access management |
| AWS OIDC | Secure GitHub Actions authentication |
| Amazon S3 | Static website storage |
| Amazon CloudFront | Content delivery |
| Checkov | Infrastructure security scanning |

### Intended workflow

1. A developer modifies Terraform configuration.
2. Changes are pushed to GitHub.
3. GitHub Actions starts automatically.
4. Terraform formatting and validation checks run.
5. Security policies are checked using Checkov.
6. Terraform generates an execution plan.
7. Approved infrastructure changes are applied.
8. Application files are deployed to AWS.
9. Drift detection checks for unexpected changes.
10. Blue/green deployment allows application versions to be switched.

# 4. Prerequisites

Participants should have the following before starting.

### Accounts

- An active AWS account.
- A GitHub account.
- An AWS identity with the permissions required to provision the demonstration resources.

### Software

Install the following:

**1. Visual Studio Code**

https://code.visualstudio.com/

Recommended extensions:
- HashiCorp Terraform
- GitHub Actions

**2. Terraform**

https://developer.hashicorp.com/terraform/install

**3. Git**

https://git-scm.com/downloads

**4. AWS CLI**

https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html

**5. Python and pip**

Required for installing Checkov during the security scanning stage.

https://www.python.org/downloads/

**6. GitHub account**

https://github.com/

### Recommended environment

- Windows, macOS or Linux.
- Internet connectivity.
- Access to an AWS account.
- Basic familiarity with command-line operations.

Windows participants can use PowerShell. macOS and Linux participants can use their terminal.

# 5. AWS Account Preparation

Before starting, prepare your AWS account.

### Step 1: Create an AWS account

https://aws.amazon.com/

### Step 2: Secure your account

- Enable MFA on the root account.
- Avoid using root credentials for everyday development.
- Configure an AWS Budget and billing alerts.
- Keep credentials private.

### Step 3: Configure development access

For local development, AWS IAM Identity Center is recommended where available.

An appropriately permissioned IAM user can also be used for the introductory local demonstration.

For GitHub Actions, we will use an IAM role with OIDC rather than storing permanent AWS access keys in GitHub.

### Step 4: Select an AWS region

Our demonstration uses:

**US East (N. Virginia): `us-east-1`**

Participants should use the same region unless instructed otherwise.

# 6. Installing the Required Tools

Install the software listed in the prerequisites.

For Windows, open PowerShell.

For macOS or Linux, open your terminal.

Verify each installation:

```powershell
terraform -version
git --version
aws --version
```

Verify Python:

```powershell
python --version
```

Or:

```powershell
py --version
```

If the commands return version information, the installations are successful.

# 7. Verifying Your Environment

Before cloning the project, confirm that the tools are working.

### Check Terraform

```powershell
terraform -version
```

### Check Git

```powershell
git --version
```

### Check AWS CLI

```powershell
aws --version
```

### Check Python

```powershell
python --version
```

### Check your current directory

```powershell
pwd
```

# 8. AWS Authentication

Terraform needs AWS credentials to communicate with AWS APIs.

There are different authentication methods.

## Option A: AWS IAM Identity Center

For local development, this is the recommended approach where available.

Configure a profile:

```powershell
aws configure sso --profile dev
```

Follow the prompts.

Log in:

```powershell
aws sso login --profile dev
```

Set the profile for your PowerShell session:

```powershell
$env:AWS_PROFILE = "dev"
```

Verify authentication:

```powershell
aws sts get-caller-identity
```

## Option B: Existing IAM credentials

If you already have a configured IAM identity:

```powershell
aws sts get-caller-identity
```

Inspect your configuration:

```powershell
aws configure list
```

Check your default region:

```powershell
aws configure get region
```

Configure the region if necessary:

```powershell
aws configure set region us-east-1
```

### Understanding get-caller-identity

This command:

```powershell
aws sts get-caller-identity
```

returns information about the identity currently making the AWS request.

Example:

```json
{
  "UserId": "AIDXXXXXXXXXXXX",
  "Account": "123456789012",
  "Arn": "arn:aws:iam::123456789012:user/example"
}
```

It helps confirm which AWS account and identity you are accessing.

It does not create or modify AWS resources.

**Security:** Never share AWS access keys, secret keys or credentials in your repository.

# 9. Getting Started: Clone the Repository

The repository already contains the project files, Terraform configuration, application source code, workflow definitions and documentation.

Participants do not need to create these files manually.

### Step 1: Clone the repository

Replace the URL with the actual workshop repository URL.

```powershell
git clone https://github.com/YOUR_USERNAME/aws-devops-demo.git
```

### Step 2: Navigate into the project

```powershell
cd aws-devops-demo
```

### Step 3: Open the project in VS Code

```powershell
code .
```

### Step 4: Inspect the project files

```powershell
ls
```

You should see the project folders and README.

### Step 5: Navigate into Terraform

```powershell
cd terraform
```

We will execute the initial Terraform commands from this directory.

**Important:** Do not create another project folder or recreate the Terraform files. They are already included in the repository.

# 10. Understanding the Project Structure

The completed repository will have the following structure:

```text
aws-devops-demo/
│
├── app/
│   ├── index.html
│   └── style.css
│
├── terraform/
│   ├── providers.tf
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   ├── iam.tf
│   ├── terraform.tfvars.example
│   └── .terraform.lock.hcl
│
├── .github/
│   └── workflows/
│       ├── terraform.yml
│       ├── deploy.yml
│       └── drift-detection.yml
│
├── .gitignore
└── README.md
```

The final structure may be extended as additional resources and workflows are introduced.

### Directory explanations

**app/**

Contains the static website files.

**terraform/**

Contains infrastructure definitions and configuration.

**.github/workflows/**

Contains GitHub Actions automation workflows.

**.gitignore**

Prevents sensitive and unnecessary files from being committed.

**README.md**

Contains project documentation and setup instructions.

**.terraform.lock.hcl**

Records selected Terraform provider versions and checksums.

# 11. Understanding Terraform

Terraform is an Infrastructure as Code tool developed by HashiCorp.

It allows infrastructure to be defined using configuration files.

Instead of manually creating AWS resources, we describe the desired infrastructure in Terraform.

### Important Terraform concepts

**Provider:** A plugin that enables Terraform to communicate with a platform such as AWS.

**Resource:** An infrastructure component managed by Terraform, such as an S3 bucket.

**Variables:** Reusable configuration values.

**Outputs:** Information displayed after Terraform operations.

**State:** Records the infrastructure Terraform manages and helps determine required changes.

# 12. Initializing Terraform

Make sure you are inside the Terraform directory:

```powershell
cd terraform
```

Initialize the project:

```powershell
terraform init
```

### What happens?

1. Terraform reads the configuration.
2. It identifies required providers.
3. It downloads the AWS provider.
4. It creates the `.terraform` working directory.
5. It creates or updates `.terraform.lock.hcl`.

Expected result:

```text
Terraform has been successfully initialized!
```

### Understanding the dependency lock file

The lock file records the selected provider version and checksums.

It helps ensure consistent provider selection across environments.

Commit the lock file to GitHub. Do not commit the `.terraform` working directory.

# 13. Formatting and Validating Configuration

### Format Terraform files

```powershell
terraform fmt
```

This automatically formats Terraform configuration files.

To check formatting without changing files:

```powershell
terraform fmt -check
```

### Validate Terraform configuration

```powershell
terraform validate
```

Expected result:

```text
Success! The configuration is valid.
```

Validation checks configuration syntax and internal consistency. It does not confirm that the active AWS identity has all required permissions.

# 14. Generating and Reviewing an Execution Plan

Generate an execution plan:

```powershell
terraform plan
```

Terraform compares the desired configuration with the current infrastructure and identifies the changes required.

Our initial configuration should propose creating:

1. S3 bucket.
2. S3 public access block.
3. S3 encryption configuration.
4. S3 bucket versioning.

Expected summary:

```text
Plan: 4 to add, 0 to change, 0 to destroy.
```

The exact output may differ depending on the environment.

### Understanding Terraform symbols

| Symbol | Meaning |
|---|---|
| `+` | Create |
| `-` | Destroy |
| `~` | Update in place |
| `-/+` | Destroy and recreate |

### Save a plan

```powershell
terraform plan -out=tfplan
```

Inspect it:

```powershell
terraform show tfplan
```

Review the plan before applying.

Saved plan files can contain sensitive information and must not be committed to GitHub.

# 15. Provisioning AWS Infrastructure

After reviewing the plan, deploy the infrastructure.

```powershell
terraform apply
```

Review the proposed changes and confirm when prompted.

Alternatively, apply a previously reviewed saved plan:

```powershell
terraform apply tfplan
```

### Verify the deployment

Display Terraform outputs:

```powershell
terraform output
```

List S3 buckets:

```powershell
aws s3 ls
```

Check the specific bucket:

```powershell
aws s3api head-bucket --bucket YOUR_BUCKET_NAME
```

Replace `YOUR_BUCKET_NAME` with the bucket name returned by Terraform.

# 16. Understanding Terraform State

Terraform state records the resources Terraform manages.

List managed resources:

```powershell
terraform state list
```

Inspect a resource:

```powershell
terraform state show aws_s3_bucket.demo
```

### State management

This introductory project uses local Terraform state.

Local state is suitable for an isolated learning environment, but collaborative deployments should use a secure remote backend with state locking and appropriate access controls.

State files can contain sensitive information.

Never commit Terraform state to GitHub.

# 17. Git and GitHub Integration

The workshop repository is already hosted on GitHub.

Participants do not need to create a new repository just to follow the initial Terraform exercises.

However, participants who want to run their own GitHub Actions pipelines should fork the repository into their own GitHub account.

### Fork the repository

1. Open the workshop GitHub repository.
2. Select Fork.
3. Create a fork under your GitHub account.
4. Clone your fork if you have not already cloned the original repository.

### Understand Git operations

Check repository status:

```powershell
git status
```

Stage changes:

```powershell
git add .
```

Commit changes:

```powershell
git commit -m "Update Terraform configuration"
```

Push changes:

```powershell
git push
```

Git allows us to track infrastructure configuration changes just as we track application code.

# 18. CI/CD with GitHub Actions

GitHub Actions automates development and deployment workflows.

Our pipeline will:

1. Trigger when relevant files change.
2. Check out the repository.
3. Install Terraform.
4. Initialize Terraform.
5. Check formatting.
6. Validate configuration.
7. Run Checkov.
8. Generate an execution plan.
9. Require appropriate approval before infrastructure deployment.
10. Deploy approved changes.

### Workflow files

| File | Responsibility |
|---|---|
| terraform.yml | Terraform formatting, validation, scanning and planning |
| deploy.yml | Application deployment |
| drift-detection.yml | Scheduled drift detection |

Pull requests should run checks and generate plans.

Infrastructure deployment should use a protected workflow with the required approvals and permissions.

# 19. Secure AWS Authentication with OIDC

GitHub Actions needs an identity to communicate with AWS.

We will use OpenID Connect (OIDC) rather than storing long-lived AWS access keys in GitHub.

### Why OIDC?

- Uses temporary credentials.
- Avoids storing permanent AWS access keys in GitHub.
- Allows repository-specific trust restrictions.
- Supports least-privilege access.

### Implementation steps

1. Create an AWS IAM OIDC identity provider for GitHub.
2. Create an IAM role for GitHub Actions.
3. Configure its trust policy.
4. Restrict access to the intended repository and branch.
5. Attach the required IAM permissions.
6. Configure the GitHub workflow to request an OIDC token.
7. Test authentication using AWS STS.

The workflow will use:

```yaml
permissions:
  id-token: write
  contents: read
```

Official documentation:

https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_providers_create_oidc.html

https://docs.github.com/en/actions/security-for-github-actions/security-hardening-your-deployments/about-security-hardening-with-openid-connect

Participants running their own deployment pipelines must configure their own AWS IAM role and GitHub repository settings. They must not use the presenter's credentials.

# 20. Infrastructure Security and Policy Checks

We will use Checkov to scan Terraform configurations for potential security issues.

### Install Checkov

For Windows:

```powershell
py -m pip install checkov
```

Verify:

```powershell
checkov --version
```

### Scan Terraform configuration

From the project root:

```powershell
checkov -d terraform
```

### Demonstration

We will:

1. Introduce a controlled insecure configuration.
2. Run Checkov.
3. Examine the security findings.
4. Correct the configuration.
5. Run the scan again.
6. Integrate security checks into GitHub Actions.

Documentation:

https://www.checkov.io/

# 21. Infrastructure Drift Detection

Infrastructure drift occurs when actual infrastructure differs from the configuration Terraform expects to manage.

For example, someone manually changes an AWS resource through the AWS Console without updating Terraform.

### Demonstration

1. Provision the S3 bucket using Terraform.
2. Make a controlled external configuration change.
3. Run Terraform plan.
4. Inspect the detected difference.
5. Decide whether to update Terraform or restore the original configuration.
6. Apply the appropriate correction.

Commands:

```powershell
terraform plan
```

Refresh-only plan:

```powershell
terraform plan -refresh-only
```

A refresh-only plan previews state updates based on the actual infrastructure. It does not automatically reconcile configuration.

### Automated drift detection

We will configure GitHub Actions to run scheduled Terraform plans.

The workflow will authenticate with AWS using OIDC, initialize Terraform and identify unexpected changes.

Drift detection will report changes rather than automatically applying potentially destructive corrections.

# 22. Blue/Green Deployment

Blue/green deployment is a release strategy involving two application environments.

- Blue: Current active application version.
- Green: New application version being prepared.

The new version is deployed and tested in the inactive environment before traffic is switched.

### Our demonstration architecture

We will use two S3 buckets and CloudFront.

```text
                 Users
                   |
                   v
              CloudFront
                   |
                   v
              Active Origin
                /       \
               /         \
          Blue S3       Green S3
          Bucket         Bucket
```

### Deployment process

1. Deploy application version 1 to Blue.
2. Configure CloudFront to serve Blue.
3. Prepare application version 2.
4. Deploy version 2 to Green.
5. Validate Green.
6. Change the active CloudFront origin.
7. Verify the new application version.
8. Keep Blue available for rollback.

### Rollback

If the new application version has an issue:

1. Restore Blue as the active origin.
2. Verify application availability.
3. Investigate the issue with Green.

CloudFront configuration changes take time to propagate globally, so traffic switching is not instantaneous.

A production implementation should also account for health checks, caching, application compatibility and deployment coordination.

# 23. Testing and Troubleshooting

### Issue: Terraform command not recognized

Possible solutions:

- Verify Terraform installation.
- Check the system PATH.
- Restart the terminal.
- Run `terraform -version`.

### Issue: AWS credentials not configured

Example:

```text
Unable to locate credentials
```

Possible solutions:

- Verify the AWS CLI profile.
- Check your authentication method.
- Run `aws sso login` if using IAM Identity Center.
- Run `aws sts get-caller-identity`.

### Issue: Missing required provider

Run:

```powershell
terraform init
```

### Issue: Invalid Terraform configuration

Run:

```powershell
terraform fmt
terraform validate
```

Inspect the reported file and line number.

### Issue: AWS AccessDenied

Possible causes:

- Insufficient IAM permissions.
- Incorrect identity.
- Incorrect IAM policy.
- Incorrect role trust policy.

Verify the active identity:

```powershell
aws sts get-caller-identity
```

### Issue: S3 bucket name already exists

S3 bucket names must be globally unique within the AWS partition.

Use a unique project naming strategy.

### Issue: Unexpected Terraform changes

Run:

```powershell
terraform plan
```

Review the proposed changes before applying.

# 24. Cost Management and Cleanup

AWS resources may incur charges.

Pay particular attention to:

- S3 storage and requests.
- CloudFront requests and data transfer.
- CloudFront distribution usage.
- Any additional resources introduced during the workshop.

### Cost management

- Use a dedicated demonstration environment.
- Configure AWS Budgets.
- Monitor AWS Billing.
- Avoid unnecessary resources.
- Clean up after the demonstration.

### Review resources before destruction

```powershell
terraform plan -destroy
```

When ready:

```powershell
terraform destroy
```

Review the destruction plan and confirm when prompted.

### Important: S3 versioning

Our bucket has versioning enabled.

Before destroying the bucket, remove its current objects and noncurrent versions.

The bucket is configured with `force_destroy = false`, so Terraform will not automatically empty it.

Inspect and clean up the demonstration bucket deliberately before destruction.

After cleanup:

- Verify the AWS resources have been removed.
- Review remaining AWS resources.
- Check the Billing Dashboard for outstanding charges.

# 25. Expected Project Outcome

By completing this project, participants will have learned how to:

- Define infrastructure using Terraform.
- Provision AWS resources.
- Validate and review infrastructure changes.
- Manage code using Git and GitHub.
- Automate infrastructure checks using GitHub Actions.
- Authenticate securely using AWS OIDC.
- Scan infrastructure configurations for security issues.
- Detect infrastructure drift.
- Implement blue/green deployment.
- Clean up AWS resources responsibly.

### Final takeaway

Infrastructure as Code is not simply about creating cloud resources through code.

It is about making infrastructure repeatable, consistent, version-controlled, secure and easier to manage.

Combining Terraform with GitHub Actions helps teams improve collaboration, automate infrastructure management and establish safer deployment processes.

# 26. Additional Learning Resources

### Terraform

- https://developer.hashicorp.com/terraform/docs
- https://developer.hashicorp.com/terraform/tutorials

### AWS

- https://docs.aws.amazon.com/
- https://aws.amazon.com/training/

### GitHub Actions

- https://docs.github.com/en/actions

### AWS IAM and OIDC

- https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_providers_oidc.html

### Checkov

- https://www.checkov.io/

---

## Project Information

**Project:** AWS DevOps Demo

**Session:** Infrastructure as Code and CI/CD Pipelines

**Tools:** Terraform | AWS | GitHub | GitHub Actions | Checkov

**Repository:** Add the workshop repository URL.

**Documentation:** This README is the participant's primary setup and implementation guide.

**Note:** Participants should use their own AWS accounts and GitHub forks for deployment exercises. Never use another participant's credentials or commit AWS secrets to the repository.