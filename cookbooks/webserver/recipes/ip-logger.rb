search("node", "platform:windows").each do |server|
  log("The Windows servers in your organization have the following FQDN/IP Addresses:- #{server['fqdn']}/#{server[ipadress]}")
end
