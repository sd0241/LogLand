## test ec2 -> bastion으로 사용할 예정
## 추후 eks에 접속할 ssh 기능만 남기고 아예 막을 예정
## 즉 아무것도 안되고 ssh 기능만 적용

## ec2의 key pair 등록
## 개인 publickey 생성 후 사용
resource "aws_key_pair" "ssac_key" {
  key_name   = "${var.name}-key"
  public_key = file("./ssacbest.pub")
}

## ec2 instance(bastion)
resource "aws_instance" "ssac_bastion" {
  ami                    = var.ami
  instance_type          = var.instance_type
  key_name               = "${var.name}-key"
  vpc_security_group_ids = [aws_security_group.eks_secu.id]
  availability_zone      = "${var.region}a"
  # eks 접속을 위한 region 등록 
  user_data = templatefile("./test.sh", {
    region                = var.region,
    cluname               = var.cluname,
    access_key            = var.access_key,
    secret_key            = var.secret_key,
    ACM_ARN               = var.ACM_ARN,
    FluentBitHttpPort     = var.FluentBitHttpPort,
    FluentBitReadFromHead = var.FluentBitReadFromHead,
    FluentBitHttpServer   = var.FluentBitHttpServer,
    FluentBitReadFromTail = var.FluentBitReadFromTail,
  })
  # 퍼블릭 ip 접속 허용
  associate_public_ip_address = true
  subnet_id                   = aws_subnet.public[0].id
  tags = {
    Name = "${var.name}-bastion"
  }
  depends_on = [
    module.eks.eks_managed_node_groups
  ]
}

# bastion 접속시 연결할 private key를 등록
resource "null_resource" "name" {
  depends_on = [aws_instance.ssac_bastion]

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("./ssacbest")
    host        = aws_instance.ssac_bastion.public_ip
  }
}

output "pub_ip" {
  value = aws_instance.ssac_bastion.public_ip
}