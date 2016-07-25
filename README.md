# checkip
check ip address of a host for web server type and open index listing (IIS and NGINX)

##Description
I have created a docker file to help build dependencies (for ruby) - can also bee used as a requirements doc.
Approach here is a script that could be expanded and reused.
We check the passed ip's check the headers for server types , test against a word value (iis or nginx) and then check via curl if the Index is open on that server.

##TODO - What could we do better
Add unit tests
Take a list iof ip from file / json / xml
Have the program run as a Service on a port and input / output json results
Better Error handling
Move core functions into a classes rather then one big script
Move ubuntu to alpine or use RVM ruby native docker file
Support Vagrant

##Usage -help -n (for addition nmap of the host)
check-host.rb IP IP IP IP
check-host.rb IP -n (for nmap)

via docker
(to build - docker build -t checkhost ,)
docker run -it checkhost IP IP IP

##Notes - 
To make this a bit easier to run I created a docker file with the ubuntu and all the requirements.
I used rvm for ruby 2.0 which is a pain in a container, could be a lot cleaner.

##Do the whole thing via bash
for i in `seq -f "192.168.1.%g" 70 80`
  do
     echo " "
     echo "Checking IP[$i]"
     if curl -s -I -L -m 3 $i |grep -e nginx -e iis; then
       echo "Checking for open directory index"
       if curl -s $i -m 3|grep -i "index of"; then
         echo -n ":[FOUND]"
       else
         echo -n ":[NOT FOUND]"
         echo " "
       fi 
     else
       echo "Not Nginx or IIS - moving ON"
     fi
done


##Examples
docker run -it test 192.168.1.76 192.168.1.150   
Using /usr/local/rvm/gems/ruby-2.0.0-p648
IP: [192.168.1.76]	=> Valid IP address Found
IP: [192.168.1.76] 	=> [NGINX] -> :nginx/1.9.3 (Ubuntu) Server Found
IP: [192.168.1.76] 	=> Directory Index Closed for host
IP: [192.168.1.150]	=> Valid IP address Found
IP: [192.168.1.150] 	=> [NGINX] -> :nginx Server Found
IP: [192.168.1.150] 	=> Directory Index Closed for host

docker run -it test 192.168.1.76 192.168.1.150 -n
Using /usr/local/rvm/gems/ruby-2.0.0-p648
IP: [192.168.1.76]	=> Valid IP address Found
IP: [192.168.1.76] 	=> [NGINX] -> :nginx/1.9.3 (Ubuntu) Server Found
IP: [192.168.1.76] 	=> Directory Index Closed for host

Starting Nmap 6.40 ( http://nmap.org ) at 2016-07-25 13:29 UTC
Initiating Ping Scan at 13:29
Scanning 192.168.1.76 [4 ports]
Completed Ping Scan at 13:29, 0.22s elapsed (1 total hosts)
Initiating Parallel DNS resolution of 1 host. at 13:29
Completed Parallel DNS resolution of 1 host. at 13:29, 0.02s elapsed
Initiating SYN Stealth Scan at 13:29
Scanning 192.168.1.76 [1000 ports]
Discovered open port 139/tcp on 192.168.1.76
Discovered open port 22/tcp on 192.168.1.76
Discovered open port 25/tcp on 192.168.1.76
Discovered open port 445/tcp on 192.168.1.76
Discovered open port 111/tcp on 192.168.1.76
Discovered open port 80/tcp on 192.168.1.76
Completed SYN Stealth Scan at 13:29, 7.51s elapsed (1000 total ports)
Initiating OS detection (try #1) against 192.168.1.76
Retrying OS detection (try #2) against 192.168.1.76

