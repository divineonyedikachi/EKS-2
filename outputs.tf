output "cluster_endpoint" {
  description = "Endpoint for EKS control plane."
  value       = module.eks.cluster_endpoint
}

output "cluster_name" {
  description = "EKS cluster name."
  value       = module.eks.cluster_id
}

output "cluster_version" {
  description = "EKS cluster name."
  value       = module.eks.cluster_version
}

output "cluster_certificate_authority_data" {
  description = "EKS cluster oidc issuer url."
  value       = module.eks.cluster_certificate_authority_data
  sensitive   = true
}

output "cluster_oidc_issuer_url" {
  description = "EKS cluster oidc issuer url."
  value       = module.eks.cluster_oidc_issuer_url
}

output "cluster_kms_key_id" {
  description = "EKS cluster KMS key id."
  value       = data.aws_kms_key.cluster_kms_key.id
}

output "cluster_kms_key_arn" {
  description = "EKS cluster KMS key arn."
  value       = data.aws_kms_key.cluster_kms_key.arn
}

output "cluster_security_group_id" {
  description = "Security group ids attached to the cluster control plane."
  value       = module.eks.cluster_security_group_id
}

output "region" {
  description = "AWS region."
  value       = var.region
}
