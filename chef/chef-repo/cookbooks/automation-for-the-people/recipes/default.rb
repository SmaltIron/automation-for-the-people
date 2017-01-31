#
# Cookbook Name:: automation-for-the-people
# Recipe:: default
#
# Copyright 2017, smaltiron
#
# MIT License
#

include_recipe 'nginx'

remote_directory '/var/www' do
  source 'www'
  owner 'nginx'
  group 'nginx'
  mode '0755'
  action :create
end

remote_directory '/etc/nginx/conf.d' do
  source 'nginx/conf.d'
  owner 'nginx'
  group 'nginx'
  mode '0755'
  action :create
end
