#!/usr/bin/env bash

# # ---- Update Yum ----
#
# yum update -y


# ---- Install Chef ----

yum install -y ruby
curl -L https://www.opscode.com/chef/install.sh | bash


# -- Install Ruby 2.2.2 / Berkshelf

yum install -y git-core zlib zlib-devel gcc-c++ patch readline readline-devel libyaml-devel libffi-devel openssl-devel make bzip2 autoconf automake libtool bison curl sqlite-devel

git clone https://github.com/rbenv/rbenv.git ~/.rbenv
cd ~/.rbenv && src/configure && make -C src
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bash_profile
~/.rbenv/bin/rbenv init
echo 'eval "$(rbenv init -)"' >> ~/.bash_profile
source /root/.bash_profile

git clone https://github.com/sstephenson/ruby-build.git $HOME/.rbenv/plugins/ruby-build
echo 'export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"' >> $HOME/.bash_profile
source /root/.bash_profile

rbenv install -v 2.2.2
rbenv global 2.2.2

gem install berkshelf


# ---- Chef Configure ----

cd /root/
mkdir -p .chef
echo "cookbook_path [ '/root/chef-repo/cookbooks' ]" > .chef/knife.rb


# ---- Install Chef Repo ----

cd /root/
curl -O https://github.com/SmaltIron/automation-for-the-people/tree/feature/terraform-chef-asg/chef/chef-repo.tar.gz
tar -xf chef-repo.tar.gz


# ---- Install Chef Deps with Berkshelf ----

berksIns() {
  cd /root/chef-repo/cookbooks/automation-for-the-people/
  rm -f Berksfile.lock
  berks vendor /root/chef-repo/cookbooks/
}
berksIns;


# ---- Chef Run ----

runChef() {
  cd /root/chef-repo/
  chef-solo -c solo.rb -j web.json
}
runChef;


# -- Write env data data

tee /var/www/_env.json <<-EOF
{
  "name" : "${name}",
  "env" : "${env}",
  "stack" : "${stack}",
  "created" : "$(date)",
  "ip" : "$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4)",
  "az" : "$(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone)"
}
EOF
