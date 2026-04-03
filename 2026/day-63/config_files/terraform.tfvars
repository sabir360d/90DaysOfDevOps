project_name   = "terraweek"
environment    = "dev"
instance_type  = "t3.micro"
region         = "us-east-1"
vpc_cidr       = "10.0.0.0/16"
subnet_cidr    = "10.0.1.0/24"
allowed_ports  = [22, 80, 443]
