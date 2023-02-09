variable "region" {
  type = string
}

variable "project_name" {
}


variable "vpc_tag_name" {
}

variable "owner" {
  description = "Project Owner."
  type        = string
}

variable "environment" {
  description = "Project Environment."
  type        = string
}

variable "cost_center" {
  description = "Project Cost Center"
  type        = string
}

variable "cluster_subnet_names" {
  description = "Subnet names used to pull the subnets for EKS cluster."
  type        = list(string)
}

# variable "cluster_subnet_ids" {
#   description = "Subnet ids to deploy EKS cluster. Used since there is issue with pulling the us-east-1e az subnet"
#   type        = list(string)
# }

variable "cluster_kms_key_alias" {
  description = "KMS key for encrypting data in EKS cluster EBS volumes"
  type        = string
}

variable "cluster_version" {
  description = "Version of Kubernetes to run on EKS cluster"
  type        = string
}

variable "cluster_endpoint_private_access_cidrs" {
  description = "CIDRS used to allow access to EKS cluster when public access is disabled on cluster. 'cluster_endpoint_public_access=false'"
  type        = list(string)
}

variable "create_vpc_endpoints" {
  description = "If true then vpc endpoints for DynamoDB and S3"
  # This allows direct access to these resources from the private subnet, thus reducing nat gateway traffic.
  type    = bool
  default = true
}


variable "gp_node_group_instance_types" {
  type = list(string)
}

variable "gp_node_group_desired_capacity" {
  type = number
}

variable "gp_node_group_max_capacity" {
  type = number
}

variable "gp_node_group_min_capacity" {
  type = number
}

variable "gp_node_group_capacity_type" {
  description = "Instance capacity_type. Accepted values 'ON_DEMAND' and 'SPOT'"
  default     = "ON_DEMAND"
}

variable "gp_node_group_disk_size" {
  type        = number
  description = "Instance ebs volume size"
}

