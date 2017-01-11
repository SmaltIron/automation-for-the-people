# output ----------------------------------------------------------------------

output "elb-dns" {
    value = "App ELB can be accessed via: ${aws_elb.aftp-elb.dns_name}"
}
