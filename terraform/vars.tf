# global aws config ------------------------------------------------------------

variable "name" {
  type = "string"
}

variable "env" {
  type = "string"
}

variable "stack" {
  type = "string"
}

variable "region" {
  type = "string"
}

variable "amis" {
  type = "map"
  default = {}
}

variable "instance_type" {
  type = "string"
}

variable "availability_zones" {
  type = "map"
  default = {}
}


# auto scaling group config ----------------------------------------------------

variable "asg_max_size" {
  type = "string"
}

variable "asg_min_size" {
  type = "string"
}

variable "docker_image" {
  type = "string"
}


# load balancer config ---------------------------------------------------------

variable "elb_instance_port" {
  type = "string"
}

variable "elb_instance_protocol" {
  type = "string"
}

variable "elb_lb_port" {
  type = "string"
}

variable "elb_lb_protocol" {
  type = "string"
}

variable "elb_healthy_threshold" {
  type = "string"
}

variable "elb_unhealthy_threshold" {
  type = "string"
}

variable "elb_timeout" {
  type = "string"
}

variable "elb_target" {
  type = "string"
}

variable "elb_interval" {
  type = "string"
}
