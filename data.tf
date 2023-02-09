data "aws_region" "current" {}


data "aws_availability_zones" "available" {}

data "aws_vpc" "selected" {
  filter {
    name   = "tag:Name"
    values = var.vpc_tag_name
  }
}

data "aws_subnet_ids" "all" {
  vpc_id = data.aws_vpc.selected.id

}

data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}

data "aws_kms_key" "cluster_kms_key" {
  key_id = "alias/${var.cluster_kms_key_alias}"
}

data "aws_subnet_ids" "subnets" {
  vpc_id = data.aws_vpc.selected.id
  filter {
    name   = "tag:Name"
    values = var.cluster_subnet_names
  }
}

// data "aws_subnet" "subnet_list" {
//   for_each = data.aws_subnet_ids.subnets.ids
//   id       = each.value
// }

locals {
  cluster_name = "aws${lower(var.environment)}${var.project_name}eks22"
  tags = {
    "Owner"       = var.owner
    "Environment" = upper(var.environment)
    "Cost Center" = var.cost_center
  }
  additional_node_group_tags = merge(
    local.tags,
    {
      "Name"             = "${local.cluster_name}-nodes",
      "Operating System" = "Linux"
    }
  )
}

# additional policy document to attach to eks nodes
data "aws_iam_policy_document" "eks_node_policy_document" {
  statement {
    actions = [
      "elasticfilesystem:DescribeAccessPoints",
      "elasticfilesystem:DescribeFileSystems",
      "elasticfilesystem:DescribeAccessPoints",
      "elasticfilesystem:DescribeFileSystems",
      "elasticfilesystem:DescribeMountTargets",
      "elasticfilesystem:CreateAccessPoint",
    ]

    resources = [
      "*",
    ]
  }

  statement {
    actions = [
      "elasticfilesystem:DeleteAccessPoint",
      "ec2:DescribeSubnets",
      "ec2:CreateNetworkInterface",
      "ec2:DescribeAvailabilityZones",
      "ec2:DescribeNetworkInterfaces",
      "ec2:DeleteNetworkInterface",
      "ec2:ModifyNetworkInterfaceAttribute",
      "ec2:DescribeNetworkInterfaceAttribute",
      "ec2:DescribeAvailabilityZones",
      "ec2:DescribeSecurityGroups",
      "ec2:DescribeVpcs",
      "ec2:DescribeVpcAttribute",
    ]

    resources = [
      "*",
    ]
  }
}

