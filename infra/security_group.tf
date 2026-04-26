# ---------------------------------------------
# Security Group
# ---------------------------------------------

# ---------------------------------------------
# Frontend security group
# ---------------------------------------------
resource "aws_security_group" "frontend" {
  name        = "${var.project}-${var.environment}-frontend-sg"
  description = "Allow HTTP and HTTPS inbound traffic, and all outbound traffic"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "${var.project}-${var.environment}-frontend-sg"
  }
}

resource "aws_security_group_rule" "frontend_in_http" {
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 80
  to_port           = 80
  security_group_id = aws_security_group.frontend.id
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "frontend_in_https" {
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 443
  to_port           = 443
  security_group_id = aws_security_group.frontend.id
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "frontend_out_all" {
  type              = "egress"
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  security_group_id = aws_security_group.frontend.id
  cidr_blocks       = ["0.0.0.0/0"]
}

# ---------------------------------------------
# WebApp Security Group
# ---------------------------------------------
resource "aws_security_group" "webapp" {
  name        = "${var.project}-${var.environment}-webapp-sg"
  description = "Allow tcp3000 inbound traffic, and all outbound traffic"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "${var.project}-${var.environment}-webapp-sg"
  }
}

resource "aws_security_group_rule" "webapp_in_tcp3000" {
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 3000
  to_port           = 3000
  security_group_id = aws_security_group.webapp.id
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "webapp_out_all" {
  type              = "egress"
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  security_group_id = aws_security_group.webapp.id
  cidr_blocks       = ["0.0.0.0/0"]
}

# ---------------------------------------------
# Database Security Group
# ---------------------------------------------
resource "aws_security_group" "database" {
  name        = "${var.project}-${var.environment}-database-sg"
  description = "Allow tcp3306 inbound traffic from webapp security group"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "${var.project}-${var.environment}-database-sg"
  }
}

resource "aws_security_group_rule" "database_in_tcp3306" {
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 3306
  to_port                  = 3306
  security_group_id        = aws_security_group.database.id
  source_security_group_id = aws_security_group.webapp.id
}

# ---------------------------------------------
# VPC Endpoint security group
# ---------------------------------------------
resource "aws_security_group" "vpc_endpoint" {
  name        = "${var.project}-${var.environment}-vpc-endpoint-sg"
  vpc_id      = aws_vpc.main.id
  description = "Allow HTTPS inbound traffic, and HTTPS outbound traffic."
  tags = {
    Name = "${var.project}-${var.environment}-vpc-endpoint-sg"
  }
}

resource "aws_security_group_rule" "vpcep_in_https" {
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 443
  to_port           = 443
  security_group_id = aws_security_group.vpc_endpoint.id
  cidr_blocks       = [aws_vpc.main.cidr_block]
}

resource "aws_security_group_rule" "vpcep_out_https" {
  type              = "egress"
  protocol          = "tcp"
  from_port         = 443
  to_port           = 443
  security_group_id = aws_security_group.vpc_endpoint.id
  cidr_blocks       = [aws_vpc.main.cidr_block]
}