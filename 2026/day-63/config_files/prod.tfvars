# prod.tfvars - Use with -var-file="prod.tfvars"
project_name   = "terraweek"
environment    = "prod"
instance_type  = "t3.small"
vpc_cidr       = "10.1.0.0/16"
subnet_cidr    = "10.1.1.0/24"
region         = "us-east-1"
allowed_ports  = [22, 80, 443, 8080]

