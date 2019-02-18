### Script pour installer l'agent fusioninventory pour machine linux 
apt-key adv --keyserver keyserver.ubuntu.com --recv 049ED9B94765572E
wget -O - http://debian.fusioninventory.org/debian/archive.key | apt-key add -
apt-get install lsb-release -y

echo "deb http://debian.fusioninventory.org/debian/ `lsb_release -cs` main" >> /etc/apt/sources.list
apt-get update -y && apt-get upgrade -y
apt-get install fusioninventory-agent -y

read -p "Quel est le FQDN ou l'@IP de votre serveur glpi [exemple : frmanglpi] " fqdn
read -p "Quel est le nom de votre machine [exemple : test] " nom
read -p "Quel est le réseau du serveur [exemple : 172.16.0.0/16] " reseau

echo "# fusioninventory agent configuration

# all defined values match default
# all commented values are examples


#
# Target definition options
#

# send tasks results to an OCS server
# server = http://$fqdn/glpi/plugins/fusioninventory/
# send tasks results to a FusionInventory for GLPI server
server = http://$fqdn/glpi/plugins/fusioninventory/
# write tasks results in a directory
#local = /tmp

#
# Task definition options
#

# disable software deployment tasks
#no-task = deploy

#
# Target scheduling options
#

# maximum delay before first target, in seconds
delaytime = 3600
# do not contact the target before next scheduled time
lazy = 0

#
# Inventory task specific options
#

# do not list local printers
# no-category = printer
# allow to scan user home directories
scan-homedirs = 1
# allow to scan user profiles
scan-profiles = 0
# save the inventory as HTML
html = 0
# timeout for inventory modules execution
backend-collect-timeout = 30
# always send data to server
force = 0
# additional inventory content file
additional-content =

#
# Package deployment task specific options
#

# do not use peer to peer to download files
no-p2p = 0

#
# Network options
#

# proxy address
proxy =
# user name for server authentication
user =
# password for server authentication
password =
# CA certificates directory
ca-cert-dir =
# CA certificates file
ca-cert-file =
# do not check server SSL certificate
no-ssl-check = 0
# connection timeout, in seconds
timeout = 180

#
# Web interface options
#

# disable embedded web server
no-httpd = 0
# network interface to listen to
httpd-ip = $fqdn
# network port to listen to
httpd-port = 62354
# trust requests without authentication token
httpd-trust = $reseau

#
# Logging options
#

# Logger backend, either Stderr, File or Syslog (Stderr)
logger = stderr
# log file
#logfile = /var/log/fusioninventory.log
# maximum log file size, in MB
#logfile-maxsize = 0
# Syslog facility
logfacility = LOG_USER
# Use color in the console
color = 0

#
# Execution mode options
#

# add given tag to inventory results
tag = $nom
# debug mode
debug = 0 " > /etc/fusioninventory/agent.cfg

echo '# FusionInventory Agent Options
#
# MODE can be either "daemon" or "cron"
MODE=daemon
# You need to set the server in
# /etc/fusioninventory/agent.cfg
' > /etc/default/fusioninventory-agent

/etc/init.d/fusioninventory-agent stop
/etc/init.d/fusioninventory-agent start

rm *

echo "
Vous pouvez faire 'fusioninventory-agent' pour faire remonter l'information"
