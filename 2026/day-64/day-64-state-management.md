# Day 64 — Terraform State Management and Remote Backends

## Overview

The Terraform state file is the **single source of truth** mapping your `.tf` configuration to real-world infrastructure.

- Lose it → Terraform forgets everything  
- Corrupt it → Risk destroying production  
- Mismanage it → Team conflicts, drift, outages  

Today focuses on:
- State inspection
- Remote backends (S3)
- State locking (DynamoDB)
- Importing existing resources
- State surgery (`mv`, `rm`)
- Handling drift

---

# Task 1: Inspect Your Current State

## Step 1: Create `main.tf`

```hcl
provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  tags = { Name = "day64-vpc" }
}

resource "aws_subnet" "public" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"

  tags = { Name = "day64-subnet" }
}

resource "aws_instance" "web" {
  ami           = "ami-0c02fb55956c7d316"
  instance_type = "t3.micro"
  subnet_id     = aws_subnet.public.id

  tags = { Name = "day64-ec2" }
}
```

---

### `versions.tf`

```hcl
terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}
```

---

## Step 2: Apply

```bash
terraform init
terraform apply
```

---

## Step 3: Explore State

```bash
terraform show
terraform state list
terraform state show aws_instance.web
terraform state show aws_vpc.main
```

![T1](screenshots/T1.JPG)


---

## Answers

1. How many resources does Terraform track?**
``
* aws_vpc.main
* aws_subnet.public
* aws_instance.web
``
- **Total: 3 resources**

---

2. What attributes does state store for EC2?**

Terraform stores:
``
* id, arn
* ami, instance_type
* private_ip, public_ip
* availability_zone
* security_groups
* root_block_device
* network_interface
* tags
``
- State contains **full infrastructure metadata**, not just defined fields

---

3. What is `serial` in terraform.tfstate?**

* Incremented on every state change
* Represents **state version**
* Helps detect updates and conflicts

---

# Task 2: Set Up S3 Remote Backend

## Step 1: Create Backend Infrastructure (CLI)

```bash
aws s3api create-bucket --bucket terraweek-state-<your name> --region us-east-1
aws s3api put-bucket-versioning --bucket terraweek-state-<your name> --versioning-configuration Status=Enabled

aws dynamodb create-table \
  --table-name terraweek-state-lock \
  --attribute-definitions AttributeName=LockID,AttributeType=S \
  --key-schema AttributeName=LockID,KeyType=HASH \
  --billing-mode PAY_PER_REQUEST \
  --region us-east-1
```

---

## Step 2: Configure Backend

Update `versions.tf`:

```hcl
terraform {
  backend "s3" {
    bucket         = "terraweek-state-<yourname>"
    key            = "dev/terraform.tfstate"
    region         = "us-east-1" 
    dynamodb_table = "terraweek-state-lock"
    encrypt        = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}
```

![T2](screenshots/T2.JPG)


---

## Step 3: Initialize & Migrate

```bash
terraform init
```

- Type **yes** when prompted:

> Do you want to copy existing state to the new backend?

---

## Step 4: Verify

* Check S3 → `dev/terraform.tfstate` exists
* Local state removed
* Run:

```bash
terraform plan
```

- Output: **No changes**

![T2b](screenshots/T2b.JPG)


---

# Task 3: Test State Locking

## Steps

Terminal 1:

```bash
terraform apply
```

Terminal 2:

```bash
terraform plan
```

---

## Observed Error

```
Error acquiring the state lock
Lock Info:
  ID: <LOCK_ID>
```

---

## Why Locking is Critical

* Prevents concurrent modifications
* Avoids state corruption
* Essential for team workflows

---

## Fix Stale Lock

```bash
terraform force-unlock <LOCK_ID>
```

![T3](screenshots/T3.JPG)

---

# Task 4: Import Existing Resource

## Step 1: Create Manually

Create the S3 bucket manually (via AWS CLI or Console)

```bash
aws s3api create-bucket --bucket terraweek-import-test-<your name> --region us-east-1
```

---

## Step 2: Add Terraform resource in your config `main.tf`

```hcl
resource "aws_s3_bucket" "imported" {
  bucket = "terraweek-import-test-<yourname>"
}
```

---

## Step 3: Import

```bash
terraform import aws_s3_bucket.imported terraweek-import-test-<yourname>
```

---

## Step 4: Validate

```bash
terraform plan
```

* No changes → correct import
* Changes → fix config

---

## Step 5: Confirm

```bash
terraform state list
```

---

## Key Difference

| Action | Meaning                    |
| ------ | -------------------------- |
| apply  | creates resource           |
| import | attaches existing resource |

---

# Task 5: State Surgery

## Rename Resource

```bash
terraform state list
terraform state mv aws_s3_bucket.imported aws_s3_bucket.logs_bucket
```

- Update your .tf file to match the new name. Run terraform plan -- it should show no changes

- Open main.tf and add:

```hcl
resource "aws_s3_bucket" "logs_bucket" {
  bucket = "terraweek-import-test-sabir"
}
```

---

## Remove from State

```bash
terraform state rm aws_s3_bucket.logs_bucket
```

---

## Re-import

```bash
terraform import aws_s3_bucket.logs_bucket terraweek-import-test-<yourname>
```

## Validate
```bash
terraform plan
terraform state list
```

- terraform plan → No changes
- terraform state list → shows:
``
aws_s3_bucket.logs_bucket
``
---

## When to Use

* `state mv` → refactoring
* `state rm` → stop managing resource


![T5](screenshots/T5.JPG)

---

# Task 6: Simulate and Fix State Drift

## Step 1: Manual Change

In AWS Console:

* Change EC2 tag → `"ManuallyChanged"`

![T6.1](screenshots/T6.1.JPG)

---

## Step 2: Detect Drift

```bash
terraform plan
```

- Shows difference

![T6.2](screenshots/T6.2.JPG)


---

## Step 3: Fix Drift

```bash
terraform apply
```

![T6.3](screenshots/T6.3.JPG)

---

## Step 4: Verify

```bash
terraform plan
```

- No changes

---

## Drift Prevention

* Restrict console access
* Use CI/CD pipelines
* Enforce Terraform-only changes

---

# When to Use What

| Command                | Use Case             |
| ---------------------- | -------------------- |
| terraform import       | Bring existing infra |
| terraform state mv     | Rename resource      |
| terraform state rm     | Remove from state    |
| terraform force-unlock | Fix stale lock       |
| terraform refresh      | Sync state           |

---


# Key Takeaways

* State = Terraform’s brain
* Remote backend = safety
* Locking = consistency
* Import = real-world necessity
* Drift = hidden risk

---
