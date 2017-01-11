# load balancer ---------------------------------------------------------------

resource "aws_elb" "aftp-elb" {
  name                   = "${var.env}-${var.stack}-${var.name}"

  availability_zones     = "${split(",", lookup(var.availability_zones, var.region))}"
  security_groups        = ["${aws_security_group.elb.id}"]

  listener {
    instance_port       = "${var.elb_instance_port}"
    instance_protocol   = "${var.elb_instance_protocol}"
    lb_port             = "${var.elb_lb_port}"
    lb_protocol         = "${var.elb_lb_protocol}"
  }

  health_check {
    healthy_threshold   = "${var.elb_healthy_threshold}"
    unhealthy_threshold = "${var.elb_unhealthy_threshold}"
    timeout             = "${var.elb_timeout}"
    target              = "${var.elb_target}"
    interval            = "${var.elb_interval}"
  }
}
