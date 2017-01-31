# instance security group --------------------------------------------------------

resource "aws_security_group" "instance" {
  name                     = "${var.env}.${var.stack}.${var.name}.instance"
  description              = "The default security group for the ${var.name} instances."
  tags {
    Name                   = "${var.env}.${var.stack}.${var.name}.instance"
    env                    = "${var.env}"
    stack                  = "${var.stack}"
  }
}

resource "aws_security_group_rule" "allow_all_inbound_80_from_elb" {
  type                     = "ingress"
  from_port                = "${var.elb_instance_port}"
  to_port                  = "${var.elb_instance_port}"
  protocol                 = "tcp"
  source_security_group_id = "${aws_security_group.elb.id}"
  security_group_id        = "${aws_security_group.instance.id}"
}

resource "aws_security_group_rule" "allow_all_outbound_53_tcp" {
  type                     = "egress"
  from_port                = 53
  to_port                  = 53
  protocol                 = "tcp"
  cidr_blocks              = ["0.0.0.0/0"]
  security_group_id        = "${aws_security_group.instance.id}"
}

resource "aws_security_group_rule" "allow_all_outbound_53_udp" {
  type                     = "egress"
  from_port                = 53
  to_port                  = 53
  protocol                 = "udp"
  cidr_blocks              = ["0.0.0.0/0"]
  security_group_id        = "${aws_security_group.instance.id}"
}

resource "aws_security_group_rule" "allow_all_outbound_443" {
  type                     = "egress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  cidr_blocks              = ["0.0.0.0/0"]
  security_group_id        = "${aws_security_group.instance.id}"
}

resource "aws_security_group_rule" "allow_all_outbound_80" {
  type                     = "egress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  cidr_blocks              = ["0.0.0.0/0"]
  security_group_id        = "${aws_security_group.instance.id}"
}

# elb security group -----------------------------------------------------------

resource "aws_security_group" "elb" {
  name                     = "${var.env}.${var.stack}.${var.name}.elb"
  description              = "The default security group for the ${var.name} elb."
  tags {
    Name                   = "${var.env}.${var.stack}.${var.name}.elb"
    env                    = "${var.env}"
    stack                  = "${var.stack}"
  }
}

resource "aws_security_group_rule" "elb_allow_all_inbound_80" {
  type                     = "ingress"
  from_port                = "${var.elb_lb_port}"
  to_port                  = "${var.elb_lb_port}"
  protocol                 = "tcp"
  cidr_blocks              = ["0.0.0.0/0"]
  security_group_id        = "${aws_security_group.elb.id}"
}

resource "aws_security_group_rule" "elb_allow_all_outbound_80" {
  type                     = "egress"
  from_port                = "${var.elb_instance_port}"
  to_port                  = "${var.elb_instance_port}"
  protocol                 = "tcp"
  cidr_blocks              = ["0.0.0.0/0"]
  security_group_id        = "${aws_security_group.elb.id}"
}
