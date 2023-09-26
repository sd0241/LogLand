# vpc 이름
resource "aws_vpc" "vpc" {
  # dns 허용
  # 변수의 cidr 값 사용
  cidr_block           = var.cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name                                   = "${var.name}-vpc"
    "kubernetes.io/cluster/${var.cluname}" = "shared"
  }
}

# 인터넷 게이트웨이
resource "aws_internet_gateway" "ig" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.name}-ig"
  }
}

# nat 게이트웨이
resource "aws_nat_gateway" "natgw" {
  # 퍼블릭 서브넷 수에 맞춰서 생성
  count         = var.count_pub_subnets
  allocation_id = element(aws_eip.eip.*.id, count.index)
  subnet_id     = element(aws_subnet.public.*.id, count.index)
  ## ig에 의존성 부여
  depends_on = [aws_internet_gateway.ig]

  tags = {
    Name = "${var.name}-natgw-${format("%03d", count.index + 1)}"
  }
}
# 탄력적 ip
resource "aws_eip" "eip" {
  # 프라이빗 서브넷에 개수에 맞춰서 생성
  count = var.count_pri_subnets
  vpc   = true

  tags = {
    Name = "${var.name}-eip-${format("%03d", count.index + 1)}"
  }
}

# 퍼블릭 서브넷
resource "aws_subnet" "public" {
  count  = var.count_pub_subnets
  vpc_id = aws_vpc.vpc.id
  # cidr 주소 값 0부터 1까지의 값을 가짐
  cidr_block = "10.0.${count.index + 100}.0/24"
  # az -> index가 0일 경우 us-east-2a, 아닐 경우 us-east-2c
  availability_zone = "${var.region}${count.index == 0 ? "a" : "c"}"

  tags = {
    Name                                   = "${var.name}-pub-${format("%03d", count.index + 1)}"
    "kubernetes.io/cluster/${var.cluname}" = "shared"
    "kubernetes.io/role/elb"               = "1"
  }
}

# 프라이빗 서브넷
resource "aws_subnet" "private" {
  # variable.tf의 프라이빗 서브넷 변수 갯수 만큼 생성(2개)
  count  = var.count_pri_subnets
  vpc_id = aws_vpc.vpc.id
  # 퍼블릭 서브넷과 다른 cidr값을 위해 +2(서브넷 수 변경되면 재변경 필요)
  cidr_block        = "10.0.${count.index}.0/24"
  availability_zone = "${var.region}${count.index == 0 ? "a" : "c"}"

  tags = {
    Name                                   = "${var.name}-pri-${format("%03d", count.index + 1)}"
    "kubernetes.io/cluster/${var.cluname}" = "shared"
    "kubernetes.io/role/internal-elb"      = "1"
  }
}

# RDS의 서브넷
resource "aws_subnet" "db" {
  count             = var.count_db_subnets
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.${count.index + 4}.0/24"
  availability_zone = "${var.region}${count.index == 0 ? "a" : "c"}"

  tags = {
    Name = "${var.name}-db-${format("%03d", count.index + 1)}"
  }
}

resource "aws_elasticache_subnet_group" "elasticache" {
  name       = "${var.name}-elasticache"
  subnet_ids = concat(aws_subnet.private[*].id)
}

# 퍼블릭 서브넷의 라우팅 테이블
resource "aws_route_table" "public" {
  count  = var.count_pub_subnets
  vpc_id = aws_vpc.vpc.id
  # 퍼블릭 서브넷의 라우팅 테이블에는 igw 연결
  route {
    cidr_block = var.rocidr
    gateway_id = aws_internet_gateway.ig.id
  }

  tags = {
    Name = "${var.name}-pub-rt"
  }
}

# 프라이빗 서브넷의 라우팅 테이블
resource "aws_route_table" "private" {
  count  = var.count_pri_subnets
  vpc_id = aws_vpc.vpc.id
  # 프라이빗 서브넷의 라우팅 테이블에는 natgw 연결
  route {
    cidr_block     = var.rocidr
    nat_gateway_id = element(aws_nat_gateway.natgw.*.id, count.index)
  }

  tags = {
    Name = "${var.name}-pri-rt-${format("%03d", count.index + 1)}"
  }
}

# 퍼블릭 서브넷을 퍼블릭 라우팅 테이블에 연결
resource "aws_route_table_association" "public" {
  count          = var.count_pub_subnets
  subnet_id      = element(aws_subnet.public.*.id, count.index)
  route_table_id = element(aws_route_table.public.*.id, count.index)
}


# 프라이빗 서브넷을 프라이빗 라우팅 테이블에 연결
resource "aws_route_table_association" "private" {
  count          = var.count_pri_subnets
  subnet_id      = element(aws_subnet.private.*.id, count.index)
  route_table_id = element(aws_route_table.private.*.id, count.index)
}


