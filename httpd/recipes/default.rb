#
# Cookbook:: httpd
# Recipe:: default
#
# Copyright:: 2020, The Authors, All Rights Reserved.


package 'httpd'

service 'httpd' do
  supports :status => true
  action [:enable, :start]
end


template '/var/www/html/index.html' do
  source 'index.html.erb'
end
