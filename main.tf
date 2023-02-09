
resource "random_id" "suffix" {
  byte_length = 2
}

resource "aws_security_group" "additional_security_group" {
  name   = "${lower(local.cluster_name)}-sg-${random_id.suffix.hex}"
  vpc_id = data.aws_vpc.selected.id

  ingress = [
    {
      description      = "Additional Security group to allow VPN access to EKS cluster"
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = var.cluster_endpoint_private_access_cidrs
      self             = false
      security_groups  = []
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
    }
  ]

  egress = [
    {
      description      = "EKS Cluster Access Egress"
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      self             = false
      security_groups  = []
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
    }
  ]

  tags = local.tags
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "18.26.6"

  cluster_name                          = "${local.cluster_name}-${random_id.suffix.hex}"
  cluster_endpoint_private_access       = true
  cluster_endpoint_public_access        = true
  cluster_additional_security_group_ids = [aws_security_group.additional_security_group.id]

  cluster_addons = {
    coredns = {
      resolve_conflicts = "OVERWRITE"
    }
    kube-proxy = {}
    vpc-cni = {
      resolve_conflicts = "OVERWRITE"
    }
  }

  # Encryption key
  create_kms_key = false

  vpc_id                   = data.aws_vpc.selected.id
  subnet_ids               = data.aws_subnet_ids.subnets.ids
  control_plane_subnet_ids = data.aws_subnet_ids.subnets.ids

  #EKS Managed node group
  eks_managed_node_group_defaults = {
    ami_type = "AL2_x86_64"

    attach_cluster_primary_security_group = true
    vpc_security_group_ids                = [aws_security_group.additional_security_group.id]
  }

  eks_managed_node_groups = {
    general_purpose = {
      min_size     = var.gp_node_group_min_capacity
      max_size     = var.gp_node_group_max_capacity
      desired_size = var.gp_node_group_desired_capacity

      instance_types = var.gp_node_group_instance_types
      capacity_type  = "ON_DEMAND"

      update_config = {
        max_unavailable_percentage = 50
      }
      disk_encrypted  = true
      disk_kms_key_id = data.aws_kms_key.cluster_kms_key.arn

    }
  }


  manage_aws_auth_configmap = true

  aws_auth_roles = [
    {
      rolearn  = "arn:aws:iam::66666666666:role/role1"
      username = "role1"
      groups   = ["system:masters"]
    },
  ]

  aws_auth_users = [
    {
      userarn  = "arn:aws:iam::66666666666:user/user1"
      username = "user1"
      groups   = ["system:masters"]
    },
    {
      userarn  = "arn:aws:iam::66666666666:user/user2"
      username = "user2"
      groups   = ["system:masters"]
    },
  ]

  tags = local.tags
}

 