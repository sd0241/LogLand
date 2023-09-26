


locals {
  cluster_vpc_name = "eks-vpc-${random_string.suffix.result}"
  efs_name         = "eks-efs-${random_string.suffix.result}"
}

resource "random_string" "suffix" {
  length = 8

  lower   = true
  upper   = false
  numeric = true
  special = false
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.0"

  cluster_name    = var.cluname
  cluster_version = "1.27"

  cluster_endpoint_public_access = true

  cluster_enabled_log_types = [
    "api",
    "audit",
    "authenticator",
    "controllerManager",
    "scheduler"
  ]
  cloudwatch_log_group_retention_in_days = 14

  cluster_addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
  }

  vpc_id                   = aws_vpc.vpc.id
  subnet_ids               = concat(aws_subnet.private[*].id)
  control_plane_subnet_ids = concat(aws_subnet.private[*].id)
  eks_managed_node_group_defaults = {
    ami_type       = "AL2_x86_64"
    instance_types = ["t3.medium", "t3.large", "m5.large"]

    iam_role_additional_policies = {
      AmazonEKSClusterALBPolicy   = aws_iam_policy.AmazonEKSClusterALBPolicy.arn
    }
  }

  eks_managed_node_groups = {
    main_group = {
      name = "node-group-1"

      instance_types = ["t3.large"]

      min_size     = 1
      max_size     = 3
      desired_size = 2
      tags = {
        //For Cluster-Autoscaler Addon
        "k8s.io/cluster-autoscaler/enabled" : "true"
        "k8s.io/cluster-autoscaler/${module.eks.cluster_name}" : "true"
      }
    }
    two = {
      name = "node-group-2"

      instance_types = ["t3.small"]
      capacity_type  = "SPOT"

      min_size     = 1
      max_size     = 5
      desired_size = 1
    }
  }

  # fargate_profiles = {
  #   default = {
  #     name = "fg-1"
  #     selectors = [
  #       {
  #         namespace = "fg-1"
  #       }
  #     ]
  #   }
  # }

  manage_aws_auth_configmap = true

#   aws_auth_users = [
#     {
#       userarn  = "${var.IamUser1_arn}"
#       username = "${var.IamUser1_Name}"
#       groups   = ["system:masters"]
#     },
#     {
#       userarn  = "${var.IamUser2_arn}"
#       username = "${var.IamUser2_Name}"
#       groups   = ["system:masters"]
#     },
#   ]
# }
}