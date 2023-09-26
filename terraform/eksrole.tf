resource "aws_iam_policy" "AmazonEKSClusterALBPolicy" {
  name   = "AmazonEKSClusterALBPolicy"
  policy = <<EOF
{
	"Version": "2012-10-17",
	"Statement": [{
		"Action": [
			"elasticfilesystem:DescribeMountTargets",
			"elasticfilesystem:DescribeFileSystems",
			"elasticfilesystem:DescribeAccessPoints",
			"elasticfilesystem:CreateAccessPoint",
			"elasticfilesystem:DeleteAccessPoint",
			"elasticloadbalancing:*",
			"ec2:CreateSecurityGroup",
			"ec2:Describe*",
			"cloudfront:GetDistribution",
			"cloudfront:GetDistributionConfig",
			"s3:GetObject",
			"s3:PutObject",
			"s3:DeleteObject",
			"rds-db:*",
			"cloudwatch:*"
		],
		"Resource": "*",
		"Effect": "Allow"
	}]
}
EOF
}


resource "aws_iam_role" "eks_cluster_role" {
  name                  = "${var.name}-eks-cluster-role"
  force_detach_policies = true

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": [
          "eks.amazonaws.com",
          "eks-fargate-pods.amazonaws.com"
          ]
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}


resource "aws_iam_role_policy_attachment" "AmazonEKSCluserALBPolicy" {
  policy_arn = aws_iam_policy.AmazonEKSClusterALBPolicy.arn
  role       = aws_iam_role.eks_cluster_role.name
}





resource "aws_iam_role" "eks_node_group_role" {
  name                  = "${var.name}-eks-node-group-role"
  force_detach_policies = true

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": [
          "ec2.amazonaws.com"
          ]
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role" "s3_access_role" {
  name = "s3-access-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = ["ec2.amazonaws.com", "eks.amazonaws.com"] # Allow both EKS and EC2 to assume the role
        }
      }
    ]
  })
}


resource "aws_iam_role_policy_attachment" "AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks_node_group_role.name
}

resource "aws_iam_role_policy_attachment" "AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks_node_group_role.name
}

resource "aws_iam_role_policy_attachment" "AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks_node_group_role.name
}

resource "aws_iam_role_policy_attachment" "CloudWatchAgentServerPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
  role       = aws_iam_role.eks_node_group_role.name
}