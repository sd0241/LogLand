resource "aws_db_parameter_group" "ssac_pg" {
  name   = "${var.name}-mysql-pg"
  family = "mysql8.0" # MySQL 8.0 버전에 맞춰 설정

  parameter {
    name  = "character_set_server"
    value = "utf8mb4" # MySQL의 경우 utf8mb4를 사용
  }

  parameter {
    name  = "character_set_client"
    value = "utf8mb4"
  }

  parameter {
    name  = "character_set_connection"
    value = "utf8mb4"
  }

  parameter {
    name  = "character_set_database"
    value = "utf8mb4"
  }

  parameter {
    name  = "character_set_filesystem"
    value = "utf8mb4"
  }

  parameter {
    name  = "character_set_results"
    value = "utf8mb4"
  }

  parameter {
    name  = "collation_server"
    value = "utf8mb4_general_ci"
  }

  parameter {
    name  = "collation_connection"
    value = "utf8mb4_general_ci"
  }

  parameter {
    name  = "time_zone"
    value = "Asia/Seoul"
  }
}

# RDS의 옵션도 그룹으로 설정 가능함
resource "aws_db_option_group" "ssac_og" {
  name                 = "${var.name}-mysql-og"
  engine_name          = "mysql"
  major_engine_version = "8.0" # MySQL 8.0 버전
}

# RDS의 서브넷 그룹
resource "aws_db_subnet_group" "ssac_dbsg" {
  name       = "${var.name}-dbsg"
  subnet_ids = aws_subnet.db[*].id
}

# RDS의 정보
resource "aws_db_instance" "ssac-db" {
  engine                     = "mysql"
  engine_version             = "8.0.33"
  auto_minor_version_upgrade = false
  identifier                 = "${var.name}db"
  username                   = "ssac"
  password                   = ""

  instance_class        = "db.t3.micro"
  allocated_storage     = 20
  max_allocated_storage = 100
  storage_type          = "gp2"

  multi_az = true
  # 외부 접속 여부
  publicly_accessible = true
  network_type        = "IPV4"

  vpc_security_group_ids = [aws_security_group.db_secu.id]
  db_subnet_group_name   = aws_db_subnet_group.ssac_dbsg.name
  port                   = 3306

  db_name              = "${var.name}db"
  parameter_group_name = aws_db_parameter_group.ssac_pg.name
  option_group_name    = aws_db_option_group.ssac_og.name

  # 종료할 때 스냅샷 기능 스킵
  skip_final_snapshot = true
  # 백업 기간
  backup_retention_period = 7

  tags = {
    Name = "${var.name}db"
  }
}
  