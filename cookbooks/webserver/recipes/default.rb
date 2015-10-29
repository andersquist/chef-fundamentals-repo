#
# Cookbook Name:: webserver
# Recipe:: default
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

# Enable the IIS role.
dsc_script 'Web-Server' do
  code <<-EOH
  WindowsFeature InstallWebServer
  {
    Name = "Web-Server"
    Ensure = "Present"
  }
  EOH
end

# Install the IIS Management Console.
dsc_script 'Web-Mgmt-Console' do
  code <<-EOH
  WindowsFeature InstallIISConsole
  {
    Name = "Web-Mgmt-Console"
    Ensure = "Present"
  }
  EOH
end

# Remove the default web site.
include_recipe 'iis::remove_default_site'

# Iterate over attributes
node["iis"]["sites"].each do |site_name, site_data|
  site_directory = "#{ENV['SYSTEMDRIVE']}\\inetpub\\sites\\#{site_name}"

  # Create the site directory and give IIS_IUSRS read rights.
  directory site_directory do
    rights :read, 'IIS_IUSRS'
    recursive true
    action :create
  end

  # Create the app pool.
  iis_pool site_name do
    runtime_version '4.0'
    action :add
  end

  # Create the site.
  iis_site site_name do
    protocol :http
    port site_data["port"]
    path site_directory
    application_pool site_name
    action [:add, :start]
  end

  # Add a template resource for Default.htm
  template "#{site_directory}\\Default.htm" do
    source "Default.htm.erb"
    variables(
      :site_name => site_name,
      :port => site_data["port"]
    )
  end
end

# Add firewall rule for bear site...
windows_firewall_rule 'bear' do 
  localport '81'
  protocol 'TCP'
  firewall_action :allow
end
