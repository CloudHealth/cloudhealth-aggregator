#
# Cookbook Name:: cloudhealth-aggregator
# Recipe:: default
#
# Copyright 2014, CloudHealthTech.com
#
# MIT License
# Copyright 2014 CloudHealthTech Inc
#

# Note: Aggregator requires Java OpenJDK 7, so this installs 7.
include_recipe "java"

group node.cloudhealth.aggregator.group do
  system true
end

user node.cloudhealth.aggregator.user do
  comment "CloudHealth Aggregator user"
  home node.cloudhealth.aggregator.install_path
  gid node.cloudhealth.aggregator.group
  shell "/bin/bash"
  system true
end

directory "#{node.cloudhealth.aggregator.install_path}lib/java" do
  owner node.cloudhealth.aggregator.user
  group node.cloudhealth.aggregator.group
  mode "0755"
  recursive true
end

ruby_block "Validate jRuby Checksum" do
  action :nothing
  block do
    require 'digest'
    checksum = Digest::SHA1.file("#{node.cloudhealth.aggregator.install_path}lib/java/jruby-complete-#{node.cloudhealth.aggregator.jruby_version}.jar").hexdigest
    if checksum != node.cloudhealth.aggregator.jruby_sha
      raise "Downloaded jruby file does not match sha of #{node.cloudhealth.aggregator.jruby_sha}, Either something funny is going on or jruby was upgraded in place."
    end
  end
end

ruby_block "Validate Aggregator Checksum" do
  action :nothing
  block do
    require 'digest'
    checksum = Digest::SHA1.file("#{node.cloudhealth.aggregator.install_path}#{node.cloudhealth.aggregator.filename}").hexdigest
    if checksum != node.cloudhealth.aggregator.sha
      raise "Downloaded aggregator file does not match sha of #{node.cloudhealth.aggregator.jruby_sha}, Either something funny is going on or jruby was upgraded in place."
    end
  end
end

remote_file "#{node.cloudhealth.aggregator.install_path}lib/java/jruby-complete-#{node.cloudhealth.aggregator.jruby_version}.jar" do
  source node.cloudhealth.aggregator.jruby_url
  mode "0755"
  action :create_if_missing
   notifies :create, "ruby_block[Validate jRuby Checksum]", :immediately
end

remote_file "#{node.cloudhealth.aggregator.install_path}#{node.cloudhealth.aggregator.filename}" do
  source node.cloudhealth.aggregator.bucket_url + node.cloudhealth.aggregator.filename
  mode "0755"
  action :create_if_missing
  notifies :create, "ruby_block[Validate Aggregator Checksum]", :immediately
end

execute "Setup Cloudhealth Aggregator" do
  command "java -jar #{node.cloudhealth.aggregator.filename} setup --endpoint='#{node.cloudhealth.aggregator.endpoint}' --token='#{node.cloudhealth.aggregator.token}' --output=cht_aggregator"
  cwd node.cloudhealth.aggregator.install_path
  not_if "test -e #{node.cloudhealth.aggregator.install_path}.vault"
end

execute "Setup Cloudhealth Aggregator Service" do
  command "cp cht_aggregator /etc/init.d/"
  cwd node.cloudhealth.aggregator.install_path
  not_if "test -e /etc/init.d/cht_aggregator"
  only_if { node.cloudhealth.aggregator.run_as_service }
end

file "/etc/init.d/cht_aggregator" do
  mode "0770"
end

service "cht_aggregator" do
  action [:enable, :start]
  only_if { node.cloudhealth.aggregator.run_as_service }
end
