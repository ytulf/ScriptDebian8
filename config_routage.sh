echo "
#######################################################################
### Configuration du routage avec le script config_routage.sh       ###
###                        par Thomas SAVIO                         ###
#######################################################################
"
echo "
Configuration du routage pour une machine debian avec minimum 2 interfaces avec install_routage.sh par Thomas SAVIO"
echo 1 >  /proc/sys/net/ipv4/ip_forward

### On reload la conf
sysctl -p /etc/sysctl.conf

### Modification iptables 
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE

### Vérification 
iptables -L -t nat
iptables-save > /etc/iptables_rules.save
echo "post-up iptables-restore < /etc/iptables_rules.save" >> /etc/network/interfaces
