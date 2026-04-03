output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.main.id
}

output "subnet_id" {
  description = "ID of the public subnet"
  value       = aws_subnet.public.id
}

output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.main.id
}

output "instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.main.public_ip
}

output "instance_public_dns" {
  description = "Public DNS name of the EC2 instance"
  value       = aws_instance.main.public_dns
}

output "security_group_id" {
  description = "ID of the security group"
  value       = aws_security_group.sg.id
}

# Additional useful outputs
output "availability_zone" {
  description = "Availability zone used"
  value       = data.aws_availability_zones.available.names[0]
}

output "ami_id" {
  description = "AMI ID used for EC2 instance"
  value       = data.aws_ami.amazon_linux_2.id
}

output "s3_bucket_name" {
  description = "Name of the S3 bucket"
  value       = aws_s3_bucket.logs.bucket
}

output "full_config_summary" {
  description = "Summary of configuration"
  value = {
    project     = var.project_name
    environment = var.environment
    region      = var.region
    instance    = local.instance_type
    vpc_cidr    = var.vpc_cidr
    subnet_cidr = var.subnet_cidr
  }
}

