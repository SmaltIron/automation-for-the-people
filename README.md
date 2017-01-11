# Terraform + Docker + Bash + Auto Scaling

This version of the infrastructure scripts creates a scalable/ephemeral version of the web application. Terraform is used for infrastructure creation. Docker is used as a deployment container. Bash is used to script the bootstrapping of EC2 & Docker. This implementation depends on deployment within a region that uses a default VPC (not classic EC2).

Note: AMIs used are Amazon Linux OS, pre-built with Docker installed.

Deployment:
* To deploy the env run `./scripts/deploy-dev-01.sh`.
* To destroy the env run `./scripts/destroy-dev-01.sh`. (and enter 'yes' when prompted.)

After a successful deployment, you should see:

```
Apply complete! Resources: 5 added, 0 changed, 0 destroyed.

The state of your infrastructure has been saved to the path
below. This state is required to modify and destroy your
infrastructure, so keep it safe. To inspect the complete state
use the `terraform show` command.

State path: ./states/state_dev.tfstate

Outputs:

elb-dns = App ELB can be accessed via: dev-01-automation-for-the-people-#########.us-west-2.elb.amazonaws.com
```

It may take just a few minutes for the application instances to come into service with the ELB.

The web server instances service requests through this ELB. You will find the "Automation for the People" page at `/` and additional file at `/_env.json`.

# _env.json

There is an additional file served by the app at: `http://dev-01-automation-for-the-people-#########.eu-west-1.elb.amazonaws.com/_env.json`. It is intended to expose a few configuration values for the purpose of debugging etc. For prod deployments this file should not be included.

Here is an example of the contents:

```
{
  "name" : "automation-for-the-people",
  "env" : "dev",
  "stack" : "01",
  "created" : "Wed Jan 11 19:45:28 UTC 2017",
  "ip" : "172.31.24.17",
  "az" : "eu-west-1b"
}
```

`ip` is the local machine IP of the instance serving the file. This IP should rotate between the instances which service the cluster. (You may need to load from different browsers to see a change.)

`az` is the Availability Zone which the instance lives.

# Configuration

In the `./terraform/conf/` directory there is a basic config for a `dev` environment. This config pattern is intended to be used as a starting point a multi-environment ecosystem. (I.E. dev, test, stage, prod). There is also an additional file which is intended to be "stack" specific. With this addition multiple stacks, per environment are supported. (I.E `dev` could have stacks, 01, 02, 03... `test` could have stacks 01, 02, etc.)

# Security

Due to the default VPC style deployment, the app instances have a higher degree of security as compared to a single EC2 instance which is exposed to the internet. The app instances are secured via AWS Security Groups. So, although they may be in a public zone (if the default subnet assigns public IPs), their access is limited to incoming connections from the ELB only. This helps prevent DDOS attacks and adds several other layers of security.

Outbound access on 53 (to allow DNS to resolve) and 443 is open on the instances to allow the docker image to be pulled. Ideally these would be locked down more narrowly, but for the purposes of the exercise they have been implemented with a bit wider security than necessary.

# AWS Region Selection

This version automation-for-the-people can be built and deployed into `eu-west-1` or `us-west-2` (editable in the configuration). However, to support additional regions only a compatible AMI and list of Availability Zones for the region would need to be added to the config (in addition to the requirement of a default VPC).

# Multi-AZ Support

For both Oregon and Ireland regions the implementation supports deployment of up to 3 AZs. (Although the default is set to 2 instance.)
