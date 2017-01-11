# auto scaling group -----------------------------------------------------------

resource "aws_autoscaling_group" "aftp-asg" {
  availability_zones   = "${split(",", lookup(var.availability_zones, var.region))}"

  name                 = "${var.env}.${var.stack}.${var.name}"

  max_size             = "${var.asg_max_size}"
  min_size             = "${var.asg_min_size}"
  desired_capacity     = "${var.asg_min_size}"

  launch_configuration = "${aws_launch_configuration.aftp-lc.name}"
  load_balancers       = ["${aws_elb.aftp-elb.name}"]

  tag {
    key                 = "Name"
    value               = "${var.env}.${var.stack}.${var.name}"
    propagate_at_launch = "true"
  }

  tag {
    key                 = "env"
    value               = "${var.env}"
    propagate_at_launch = "true"
  }
}

# launch config ----------------------------------------------------------------

resource "aws_launch_configuration" "aftp-lc" {
  name                  = "${var.env}.${var.stack}.${var.name}"
  image_id              = "${lookup(var.amis, var.region)}"
  instance_type         = "${var.instance_type}"

  security_groups       = ["${aws_security_group.instance.id}"]
  user_data             = "${data.template_file.userdata.rendered}"
  associate_public_ip_address = "false"
  #key_name = "tacit-general"
}

# userdata template ------------------------------------------------------------

data "template_file" "userdata" {
  template              = "${file("userdata.sh")}"

  vars {
    docker_image        = "${var.docker_image}"
    name                = "${var.name}"
    env                 = "${var.env}"
    stack               = "${var.stack}"
  }
}
