
# 우리가 사용할 리전
variable "region" {
  default = "us-east-1"
}
# vpc cidr 범위 
variable "cidr" {
  default = "10.0.0.0/16"
}
# 외부 CIDR 범위
variable "rocidr" {
  default = "0.0.0.0/0"
}

# 퍼블릭 서브넷
variable "count_pub_subnets" {
  type    = number
  default = 3
}

# 프라이빗 서브넷
variable "count_pri_subnets" {
  type    = number
  default = 3
}

# db 서브넷
variable "count_db_subnets" {
  type    = number
  default = 2
}

variable "count_elasticahe_subnets" {
  type    = number
  default = 2
}

# ami id(우분투)
variable "ami" {
  description = "EC2 bastion AMI"
  default     = "ami-"
}

# 리소스에 붙일 이름
variable "name" {
  default = "prj"
}

# 클러스터 이름
variable "cluname" {
  default = "prj-clu"
}

# 인스턴스 타입
variable "instance_type" {
  default = "t3.medium"
}

variable "kubeconfig_path" {
  default = "~/.kube"
}

variable "ACM_ARN" {
  description = "ACM_ARN"
  default     = ""
}

# 접속 키
variable "access_key" {
  description = "Access_key for AWS CLI"
  type        = string
  default     = ""
}

# 비밀번호 키
variable "secret_key" {
  description = "Secret_key for AWS CLI"
  type        = string
  default     = ""
}

#SNS
variable "email_addresses" {
  description = "Email address for SNS"
  type        = list(string)
  default     = ["didiekdzm16@gmali.com"]
}

#Image
variable "front_image" {
  description = "Image for web service"
  type        = string
  default     = ""
}

variable "back_image" {
  description = "Image for was service"
  type        = string
  default     = ""
}

#cloudwatch
variable "FluentBitHttpPort" {
  type    = string
  default = "2020"
}

variable "FluentBitReadFromHead" {
  type    = string
  default = "Off"
}

variable "FluentBitHttpServer" {
  type    = string
  default = "On"
}

variable "FluentBitReadFromTail" {
  type    = string
  default = "On"
}

variable "IamUser1_Name" {
  type    = string
  default = "Minseok"
}

variable "IamUser1_arn" {
  type    = string
  default = ""
}

variable "IamUser2_Name" {
  type    = string
  default = "Jieun"
}

variable "IamUser2_arn" {
  type    = string
  default = ""
}