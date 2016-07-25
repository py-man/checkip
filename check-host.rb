#!/usr/bin/ruby

###Install Required Gems for Nmap and IP valaidation 
require 'nmap/program'
require "ipaddress"
require 'curb'

###Parse in a simple way - Command line Args - help and nmap options
input_arguments = ARGV
if input_arguments.include? "-help" 
  puts "Provide a list of IP address seperated by space, add -n if you also want NMAP of a host"
elsif input_arguments.empty?
  puts "Provide a list of IP address seperated by space, add -n if you also want NMAP of a host"
end

###For each ip in the array - do some stuff
input_arguments.each do |ip_address|
  ##Check if the IP is a valid IP address (and not some random number)
  if IPAddress.valid? (ip_address)
    puts  "IP: [#{ip_address}]	=> Valid IP address Found"  

    ##Check Web Server Version via the http header
    curl = Curl::Easy.http_get(ip_address)
    http_response, *http_headers = curl.header_str.split(/[\r\n]+/).map(&:strip)
    http_headers = Hash[http_headers.flat_map{ |s| s.scan(/^(\S+): (.+)/) }]
    if http_headers['Server'].include? "nginx" 
      puts "IP: [#{ip_address}] 	=> [NGINX] -> :#{http_headers['Server']} Server Found"
    elsif http_headers['Server'].include? "IIS" 
      puts "IP: [#{ip_address}]       => [IIS] -> :#{http_headers['Server']} Server Found"
    else 
      puts "IP: [#{ip_address}]     => IIS OR Nginx Host Not Found - Moving to next IP"
      ###move to next ip if Nginx or IIS is not found
      next 
    end

    ##Check if INDEX is open on each of the IP's
    http = Curl.get(ip_address)
    if http.body_str.include? "Index of"
      puts "IP: [#{ip_address}] 	=> Directory Index Open for host"
    else
      puts "IP: [#{ip_address}] 	=> Directory Index Closed for host" 
    end
    
    ###Do an Nmap of a valid host if -n is used
    if input_arguments.include? "-n"
    ##Using thr Nmap gem, scan each host in the provided rang (* - wildcard)
      Nmap::Program.scan do |nmap|
        nmap.os_fingerprint = true
        nmap.verbose =  true
        nmap.targets = ip_address
      end
    end
  ###display error on bad ip or non ip used
  else
    puts  "IP: [#{ip_address}]  => Bad IP address Found"
  end
end

