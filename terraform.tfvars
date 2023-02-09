region               = "us-east-1"
project_name         = "wiz-tech"
environment          = "dev"
owner                = "Divine"
cost_center          = "1234"
cluster_version      = "1.22"
cluster_subnet_names = ["wiz-tech-private-development*"]
cluster_endpoint_private_access_cidrs = [
  "0.0.0.0/0"
]

gp_node_group_disk_size        = 100
gp_node_group_instance_types   = ["t3.medium"]
gp_node_group_desired_capacity = 2
gp_node_group_max_capacity     = 5
gp_node_group_min_capacity     = 2
gp_node_group_capacity_type    = "ON_DEMAND"
cluster_kms_key_alias          = "aws/ebs"
vpc_tag_name                   = ["wiz-tech-vpc-development*"]
