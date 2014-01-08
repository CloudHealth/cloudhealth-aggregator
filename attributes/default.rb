override['java']['jdk_version'] = '7'
override['java']['install_flavor'] = 'openjdk'
default['java']['accept_license_agreement'] = true

# This is the only setting the cookbook needs outside the defaults, 
# please set in an environment, or here.
#default['cloudhealth']['aggregator']['token'] = "my_token"

default['cloudhealth']['aggregator']['user'] = 'cloudhealth'
default['cloudhealth']['aggregator']['group'] = 'cloudhealth'
default['cloudhealth']['aggregator']['install_path'] = '/opt/cloudhealth-aggregator/'
default['cloudhealth']['aggregator']['jruby_version'] = '1.7.3'
default['cloudhealth']['aggregator']['jruby_url'] = "http://jruby.org.s3.amazonaws.com/downloads/#{node.cloudhealth.aggregator.jruby_version}/jruby-complete-#{node.cloudhealth.aggregator.jruby_version}.jar"
default['cloudhealth']['aggregator']['jruby_sha'] = "fafe20bce6f70ce295f24160a1e470823edba3e7"
default['cloudhealth']['aggregator']['bucket_url'] = "https://s3.amazonaws.com/remote-collector/1.4/"
default['cloudhealth']['aggregator']['endpoint'] = "https://api.cloudhealthtech.com"
default['cloudhealth']['aggregator']['sha'] = "70063fd246efdd61427cf5e165b6beecbea4fad6"
default['cloudhealth']['aggregator']['filename'] = "cht_aggregator-1.4.3.26-linux.jar"
default['cloudhealth']['aggregator']['run_as_service'] = true
