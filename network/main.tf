# ---------------------------------------------------------------------------------------------------------------------
#  create vpc
# ---------------------------------------------------------------------------------------------------------------------
resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name    = "VPC-faq-chatbot"
    Project = "${var.project_naam}"
  }
}

data "aws_region" "current" {}

# ---------------------------------------------------------------------------------------------------------------------
#  create subnets
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_subnet" "prv_subnet_a" {
  vpc_id            = "${aws_vpc.vpc.id}"
  cidr_block        = "10.0.1.0/24"
  availability_zone = "${data.aws_region.current.name}a"

  tags = {
    Name    = "prv_subnet_a"
    Project = "${var.project_naam}"
  }
}

resource "aws_subnet" "prv_subnet_b" {
  vpc_id            = "${aws_vpc.vpc.id}"
  cidr_block        = "10.0.2.0/24"
  availability_zone = "${data.aws_region.current.name}b"

  tags = {
    Name    = "prv_subnet_b"
    Project = "${var.project_naam}"
  }
}

resource "aws_subnet" "pbl_subnet_a" {
  vpc_id            = "${aws_vpc.vpc.id}"
  cidr_block        = "10.0.100.0/24"
  availability_zone = "${data.aws_region.current.name}a"

  tags = {
    Name    = "pbl_subnet_a"
    Project = "${var.project_naam}"
  }
}

resource "aws_subnet" "pbl_subnet_b" {
  vpc_id            = "${aws_vpc.vpc.id}"
  cidr_block        = "10.0.101.0/24"
  availability_zone = "${data.aws_region.current.name}b"

  tags = {
    Name    = "pbl_subnet_b"
    Project = "${var.project_naam}"
  }
}

# ---------------------------------------------------------------------------------------------------------------------
#  create route tables
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_route_table" "route-table-pbl" {
  vpc_id = "${aws_vpc.vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.gw.id}"
  }

  tags = {
    Name    = "route_table_public"
    Project = "${var.project_naam}"
  }
}

resource "aws_route_table" "route-table-prv-sub-a" {
  vpc_id = "${aws_vpc.vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_nat_gateway.nat-gw-sub-a.id}"
  }

  tags = {
    Name    = "route_table_private_sub_a"
    Project = "${var.project_naam}"
  }
}

resource "aws_route_table" "route-table-prv-sub-b" {
  vpc_id = "${aws_vpc.vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_nat_gateway.nat-gw-sub-b.id}"
  }

  tags = {
    Name    = "route_table_private_sub_b"
    Project = "${var.project_naam}"
  }
}

# ---------------------------------------------------------------------------------------------------------------------
#  associat route tables
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_route_table_association" "ass-pbl-sub-a" {
  subnet_id      = "${aws_subnet.pbl_subnet_a.id}"
  route_table_id = "${aws_route_table.route-table-pbl.id}"
}

resource "aws_route_table_association" "ass-pbl-sub-b" {
  subnet_id      = "${aws_subnet.pbl_subnet_b.id}"
  route_table_id = "${aws_route_table.route-table-pbl.id}"
}

resource "aws_route_table_association" "ass-prv-sub-a" {
  subnet_id      = "${aws_subnet.prv_subnet_a.id}"
  route_table_id = "${aws_route_table.route-table-prv-sub-a.id}"
}

resource "aws_route_table_association" "ass-prv-sub-b" {
  subnet_id      = "${aws_subnet.prv_subnet_b.id}"
  route_table_id = "${aws_route_table.route-table-prv-sub-b.id}"
}

# ---------------------------------------------------------------------------------------------------------------------
#  create internet gateways
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_internet_gateway" "gw" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags = {
    Name    = "prv_subnet_a"
    Project = "${var.project_naam}"
  }
}

resource "aws_nat_gateway" "nat-gw-sub-a" {
  allocation_id = "${aws_eip.eip-nat-gw-sub-a.id}"
  subnet_id     = "${aws_subnet.pbl_subnet_a.id}"

  tags = {
    Name    = "nat_public_sub_a"
    Project = "${var.project_naam}"
  }
}

resource "aws_nat_gateway" "nat-gw-sub-b" {
  allocation_id = "${aws_eip.eip-nat-gw-sub-b.id}"
  subnet_id     = "${aws_subnet.pbl_subnet_b.id}"

  tags = {
    Name    = "nat_public_sub_b"
    Project = "${var.project_naam}"
  }
}

# ---------------------------------------------------------------------------------------------------------------------
#  create elastic ip
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_eip" "eip-nat-gw-sub-a" {
  vpc        = true
  depends_on = ["aws_internet_gateway.gw"]
}

resource "aws_eip" "eip-nat-gw-sub-b" {
  vpc        = true
  depends_on = ["aws_internet_gateway.gw"]
}
