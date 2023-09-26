# Karpenter 컨트롤러를 위한 IAM 역할 및 정책 설정
module "iam_assumable_role_karpenter" {
  source                        = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version                       = "4.7.0"
  create_role                   = true
  role_name                     = "karpenter-controller-${var.cluster_name}"  # IAM 역할 이름
  provider_url                  = module.eks.cluster_oidc_issuer_url            # OIDC 공급자 URL
  oidc_fully_qualified_subjects = ["system:serviceaccount:karpenter:karpenter"]  # OIDC 주체 설정
}

# Karpenter 컨트롤러를 위한 IAM 역할 정책 설정
resource "aws_iam_role_policy" "karpenter_controller" {
  name = "karpenter-policy-${var.cluster_name}"  # IAM 정책 이름
  role = module.iam_assumable_role_karpenter.iam_role_name  # 관련 IAM 역할 이름
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ec2:CreateLaunchTemplate",  # EC2 인스턴스용 론칭 템플릿 생성 허용
          "ec2:CreateFleet",          # EC2 플리트 생성 허용
          "ec2:RunInstances",         # EC2 인스턴스 실행 허용
          "ec2:CreateTags",           # EC2 리소스에 태그 생성 허용
          "iam:PassRole",             # 다른 IAM 역할에 롤 부여 허용
          "ec2:TerminateInstances",   # EC2 인스턴스 종료 허용
          "ec2:DescribeLaunchTemplates",         # 시작 템플릿 정보 조회 허용
          "ec2:DescribeInstances",              # EC2 인스턴스 정보 조회 허용
          "ec2:DescribeSecurityGroups",         # 보안 그룹 정보 조회 허용
          "ec2:DescribeSubnets",                # 서브넷 정보 조회 허용
          "ec2:DescribeInstanceTypes",          # 인스턴스 유형 정보 조회 허용
          "ec2:DescribeInstanceTypeOfferings",  # 인스턴스 유형 오퍼링 정보 조회 허용
          "ec2:DescribeAvailabilityZones",      # 가용 영역 정보 조회 허용
          "ssm:GetParameter"                    # 파라미터 스토어 서비스에서 파라미터 정보 조회 허용
        ]
        Effect   = "Allow"
        Resource = "*"  # 모든 리소스에 대한 권한 부여
      },
    ]
  })
}

# Karpenter를 위한 Helm 릴리스 정의
resource "helm_release" "karpenter" {
  depends_on       = [module.eks.kubeconfig]
  namespace        = "karpenter"  # 네임스페이스 설정
  create_namespace = true         # 네임스페이스 생성 여부

  name       = "karpenter"         # Helm 릴리스 이름
  repository = "https://charts.karpenter.sh"  # Helm 차트 저장소 URL
  chart      = "karpenter"         # 배포할 Helm 차트 이름
  version    = "v0.16.0"           # Helm 차트 버전

  set {
    name  = "replicas"
    value = 2  # 복제본 수
  }

  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = module.iam_assumable_role_karpenter.iam_role_arn  # 서비스 계정 주석에 IAM 역할 ARN 추가
  }

  set {
    name  = "clusterName"
    value = local.cluster_name  # 클러스터 이름 설정
  }

  set {
    name  = "clusterEndpoint"
    value = module.eks.cluster_endpoint  # 클러스터 엔드포인트 설정
  }

  set {
    name  = "aws.defaultInstanceProfile"
    value = aws_iam_instance_profile.karpenter.name  # 기본 인스턴스 프로필 설정
  }
}

