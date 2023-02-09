project_name = "wiz-tech"
environment  = "development"
owner        = "divine"
aws_region = "us-east-1"
vpc_cidr     = "193.10.0.0/16"
subnet_cidrs = {
  "private1" = "193.10.5.0/27"
  "private2" = "193.10.11.0/27"
  "public1"  = "193.10.30.0/27"
  "public2"  = "193.10.50.0/27"
}