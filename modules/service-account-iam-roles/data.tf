
data "terraform_remote_state" "eks" {
  backend = "s3"
  config = {
    bucket         = var.bucket
    key            = format("env:/%s/%s/%s", var.workspace, "eks", "terraform.tfstate")
    region         = var.bucket_region
    dynamodb_table = var.dynamodb
  }
}

data "terraform_remote_state" "dynamodb" {
  backend = "s3"
  config = {
    bucket         = var.bucket
    key            = format("env:/%s/%s/%s", var.workspace, "dynamodb", "terraform.tfstate")
    region         = var.bucket_region
    dynamodb_table = var.dynamodb
  }
}

data "aws_eks_cluster" "cluster" {
  name = data.terraform_remote_state.eks.outputs.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = data.terraform_remote_state.eks.outputs.cluster_id
}

data "aws_availability_zones" "available" {}

data "aws_caller_identity" "current" {}

data "aws_region" "current" {}
