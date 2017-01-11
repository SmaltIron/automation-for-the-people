# global aws config ------------------------------------------------------------

name                    = "automation-for-the-people"
env                     = "dev"

region                  = "us-west-2" # or eu-west-1
amis                    = { "us-west-2" = "ami-b0d466d0"   # Amazon Linux AMI 2016.09.d x86_64 ECS HVM GP2
                            "eu-west-1" = "ami-3a311949" } # Amazon Linux AMI 2016.09.d x86_64 ECS HVM GP2
instance_type           = "t2.micro"
availability_zones      = { "us-west-2" = "us-west-2a,us-west-2b,us-west-2c"
                            "eu-west-1" = "eu-west-1a,eu-west-1b,eu-west-1c" }


# auto scaling group config ----------------------------------------------------

asg_max_size            = 4
asg_min_size            = 2
docker_image            = "nginx:1.11.8"

# load balancer config ---------------------------------------------------------

elb_instance_port       = 80
elb_instance_protocol   = "http"
elb_lb_port             = 80
elb_lb_protocol         = "http"
elb_healthy_threshold   = 2
elb_unhealthy_threshold = 2
elb_timeout             = 3
elb_target              = "HTTP:80/"
elb_interval            = 5
