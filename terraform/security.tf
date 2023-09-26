# EKS 보안그룹
resource "aws_security_group" "eks_secu" {
  name   = "${var.name}-cluster"
  vpc_id = aws_vpc.vpc.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.rocidr]
  }


  ingress = [
    {
      description      = "ssh"
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = [var.rocidr]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids  = null
      security_groups  = null
      self             = null
    },
    {
      description      = "https"
      from_port        = 443
      to_port          = 443
      protocol         = "tcp"
      cidr_blocks      = [var.rocidr]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids  = null
      security_groups  = null
      self             = null
    }
  ]

  tags = {
    Name = "${var.name}-cluster"
  }
}


resource "aws_security_group" "elasticache_secu" {
  name   = "${var.name}-elasticache"
  vpc_id = aws_vpc.vpc.id
  ingress {
    description = "elasticache"
    from_port   = 6379
    to_port     = 6379
    protocol    = "tcp"
    cidr_blocks = [var.rocidr]
  }
}

# DB 보안그룹
resource "aws_security_group" "db_secu" {
  name   = "${var.name}-db"
  vpc_id = aws_vpc.vpc.id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = [var.rocidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.rocidr]
  }
  tags = {
    Name = "${var.name}-db"
  }
}

# # NACL 구성 
# resource "aws_network_acl" "public" {
#   vpc_id = aws_vpc.vpc.id

#   # Inbound rule to allow SSH traffic
#   ingress {
#     protocol   = "tcp"
#     rule_no    = 100
#     action     = "allow"
#     cidr_block = var.rocidr
#     from_port  = 22
#     to_port    = 22
#   }

#   # Inbound rule to allow HTTP traffic (port 80)
#   ingress {
#     protocol   = "tcp"
#     rule_no    = 110
#     action     = "allow"
#     cidr_block = var.rocidr
#     from_port  = 80
#     to_port    = 80
#   }

#   # Inbound rule to allow HTTPS traffic (port 443)
#   ingress {
#     protocol   = "tcp"
#     rule_no    = 120
#     action     = "allow"
#     cidr_block = var.rocidr
#     from_port  = 443
#     to_port    = 443
#   }

#   # Inbound rule to allow custom port 3000
#   ingress {
#     protocol   = "tcp"
#     rule_no    = 130
#     action     = "allow"
#     cidr_block = var.rocidr
#     from_port  = 3000
#     to_port    = 3000
#   }

#   # Inbound rule to allow custom port 8080
#   ingress {
#     protocol   = "tcp"
#     rule_no    = 140
#     action     = "allow"
#     cidr_block = var.rocidr
#     from_port  = 8080
#     to_port    = 8080
#   }

#   # Outbound rule to allow necessary outbound traffic
#   egress {
#     protocol   = "tcp"
#     rule_no    = 100
#     action     = "allow"
#     cidr_block = var.rocidr
#     from_port  = 0
#     to_port    = 65535
#   }

#   tags = {
#     Name = "${var.name}-public-nacl"
#   }
# }