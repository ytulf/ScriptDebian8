echo "
#########################################################################
### Configuration de l'interface avec le script config_interfaces.sh  ###
###                          par Thomas SAVIO                         ###
#########################################################################
"
echo "
Voulez-vous mettre l'interface en static [1] ou en DHCP [2]? "
read interface
case $interface in
"1")
echo "
Quel adresse IP souhaitez-vous donner a eth0 ? [exemple @IP : 192.168.16.20]" 
read IP
echo "
C'est bien cette @IP que vous souhaitez mettre : '$IP' [Y/N] ?"
read validation
case $validation in
"y")
echo "
Quel masque souhaitez-vous donner ? [exemple : 255.255.255.0]"
read masque
echo "
C'est bien ce masque que vous souhaitez mettre : '$masque' [Y/N] ?"
read validation
case $validation in 
"y")
echo "
Quel gateway souhaitez-vous donner ? [exemple : 10.30.40.254]"
read gateway
echo "
C'est bien cette gateway que vous souhaitez mettre : '$gateway' [Y/N] ?"
read validation
case $validation in 
"y")
echo "
Quel DNS souhaitez-vous donner ? [exemple : 8.8.8.8]"
read dns
echo "
C'est bien ce[s] DNS que vous souhaitez mettre : '$dns' [Y/N] ?"
read validation
case $validation in 
"y")
echo "auto lo
iface lo inet loopback
# The primary network interface
allow-hotplug eth0
auto eth0
iface eth0 inet static 
address $IP
netmask $masque
gateway $gateway
dns-nameservers $dns
" > /etc/network/interfaces 
;;
"Y")
echo "auto lo
iface lo inet loopback
# The primary network interface
allow-hotplug eth0
auto eth0
iface eth0 inet static 
address $IP
netmask $masque
gateway $gateway
dns-nameservers $dns
" > /etc/network/interfaces 
;;
*)
echo "Fallait pas faire d'erreur tant pis pour vous ... "
;;
esac
;;
"Y")
echo "
Quel DNS souhaitez-vous donner ? [exemple : 8.8.8.8]"
read dns
echo "
C'est bien ce[s] DNS que vous souhaitez mettre : '$dns' [Y/N] ?"
read validation
case $validation in	
"y")
echo "auto lo
iface lo inet loopback
# The primary network interface
allow-hotplug eth0
auto eth0
iface eth0 inet static 
address $IP
netmask $masque
gateway $gateway
dns-nameservers $dns
" > /etc/network/interfaces 
;;
"Y")
echo "auto lo
iface lo inet loopback
# The primary network interface
allow-hotplug eth0
auto eth0
iface eth0 inet static 
address $IP
netmask $masque
gateway $gateway
dns-nameservers $dns
" > /etc/network/interfaces 
;;
*)
echo "Fallait pas faire d'erreur tant pis pour vous ... "
;;
esac
;;
*)
echo "Fallait pas faire d'erreur tant pis pour vous ... "
;;
esac
;;
"Y")
echo "
Quel gateway souhaitez-vous donner ? [exemple : 10.30.40.254]"
read gateway
echo "
C'est bien cette gateway que vous souhaitez mettre : '$gateway' [Y/N] ?"
read validation
case $validation in	
"y")
echo "
Quel DNS souhaitez-vous donner ? [exemple : 8.8.8.8]"
read dns
echo "
C'est bien ce[s] DNS que vous souhaitez mettre : '$dns' [Y/N] ?"
read validation
case $validation in	
"y")
echo "auto lo
iface lo inet loopback
# The primary network interface
allow-hotplug eth0
auto eth0
iface eth0 inet static 
address $IP
netmask $masque
gateway $gateway
dns-nameservers $dns
" > /etc/network/interfaces 
;;
"Y")
echo "auto lo
iface lo inet loopback
# The primary network interface
allow-hotplug eth0
auto eth0
iface eth0 inet static 
address $IP
netmask $masque
gateway $gateway
dns-nameservers $dns
" > /etc/network/interfaces 
;;
*)
echo "
Fallait pas faire d'erreur tant pis pour vous ... "
;;
esac
;;
"Y")
echo "
Quel DNS souhaitez-vous donner ? [exemple : 8.8.8.8]"
read dns
echo "
C'est bien ce[s] DNS que vous souhaitez mettre : '$dns' [Y/N] ?"
read validation
case $validation in	
"y")
echo "auto lo
iface lo inet loopback
# The primary network interface
allow-hotplug eth0
auto eth0
iface eth0 inet static 
address $IP
netmask $masque
gateway $gateway
dns-nameservers $dns
" > /etc/network/interfaces 
;;
"Y")
echo "auto lo
iface lo inet loopback
# The primary network interface
allow-hotplug eth0
auto eth0
iface eth0 inet static 
address $IP
netmask $masque
gateway $gateway
dns-nameservers $dns
" > /etc/network/interfaces 
;;
*)
echo "Fallait pas faire d'erreur tant pis pour vous ... "
;;
esac
;;
*)
echo "Fallait pas faire d'erreur tant pis pour vous ... "
;;
esac
;;
*)
echo "Fallait pas faire d'erreur tant pis pour vous ... "
;;
esac
;;
"Y")
echo "
Quel masque souhaitez-vous donner ? [exemple : 255.255.255.0]"
read masque
echo "
C'est bien ce masque que vous souhaitez mettre : '$masque' [Y/N] ?"
read validation
case $validation in 
"y")
echo "
Quel gateway souhaitez-vous donner ? [exemple : 10.30.40.254]"
read gateway
echo "
C'est bien cette gateway que vous souhaitez mettre : '$gateway' [Y/N] ?"
read validation
case $validation in	
"y")
echo "
Quel DNS souhaitez-vous donner ? [exemple : 8.8.8.8]"
read dns
echo "
C'est bien ce[s] DNS que vous souhaitez mettre : '$dns' [Y/N] ?"
read validation
case $validation in	
"y")
echo "auto lo
iface lo inet loopback
# The primary network interface
allow-hotplug eth0
auto eth0
iface eth0 inet static 
address $IP
netmask $masque
gateway $gateway
dns-nameservers $dns
" > /etc/network/interfaces 
;;
"Y")
echo "auto lo
iface lo inet loopback
# The primary network interface
allow-hotplug eth0
auto eth0
iface eth0 inet static 
address $IP
netmask $masque
gateway $gateway
dns-nameservers $dns
" > /etc/network/interfaces 
;;
*)
echo "Fallait pas faire d'erreur tant pis pour vous ... "
;;
esac
;;
"Y")
echo "
Quel DNS souhaitez-vous donner ? [exemple : 8.8.8.8]"
read dns
echo "
C'est bien ce[s] DNS que vous souhaitez mettre : '$dns' [Y/N] ?"
read validation
case $valdiation in	
"y")
echo "auto lo
iface lo inet loopback
# The primary network interface
allow-hotplug eth0
auto eth0
iface eth0 inet static 
address $IP
netmask $masque
gateway $gateway
dns-nameservers $dns
" > /etc/network/interfaces 
;;
"Y")
echo "auto lo
iface lo inet loopback
# The primary network interface
allow-hotplug eth0
auto eth0
iface eth0 inet static 
address $IP
netmask $masque
gateway $gateway
dns-nameservers $dns
" > /etc/network/interfaces 
;;
*)
echo "Fallait pas faire d'erreur tant pis pour vous ... "
;;
esac
;;
*)
echo "Fallait pas faire d'erreur tant pis pour vous ... "
;;
esac
;;
"Y")
echo "
Quel gateway souhaitez-vous donner ? [exemple : 10.30.40.254]"
read gateway
echo "
C'est bien cette gateway que vous souhaitez mettre : '$gateway' [Y/N] ?"
read validation
case $validation in	
"y")
echo "
Quel DNS souhaitez-vous donner ? [exemple : 8.8.8.8]"
read dns
echo "
C'est bien ce[s] DNS que vous souhaitez mettre : '$dns' [Y/N] ?"
read validation
case $validation in	
"y")
echo "auto lo
iface lo inet loopback
# The primary network interface
allow-hotplug eth0
auto eth0
iface eth0 inet static 
address $IP
netmask $masque
gateway $gateway
dns-nameservers $dns
" > /etc/network/interfaces 
;;
"Y")
echo "auto lo
iface lo inet loopback
# The primary network interface
allow-hotplug eth0
auto eth0
iface eth0 inet static 
address $IP
netmask $masque
gateway $gateway
dns-nameservers $dns
" > /etc/network/interfaces
;;
*)
echo "Fallait pas faire d'erreur tant pis pour vous ... "
;;
esac
;;
"Y")
echo "
Quel DNS souhaitez-vous donner ? [exemple : 8.8.8.8]"
read dns
echo "
C'est bien ce[s] DNS que vous souhaitez mettre : '$dns' [Y/N] ?"
read validation
case $validation in	
"y")
echo "auto lo
iface lo inet loopback
# The primary network interface
allow-hotplug eth0
auto eth0
iface eth0 inet static 
address $IP
netmask $masque
gateway $gateway
dns-nameservers $dns
" > /etc/network/interfaces 
;;
"Y")
echo "auto lo
iface lo inet loopback
# The primary network interface
allow-hotplug eth0
auto eth0
iface eth0 inet static 
address $IP
netmask $masque
gateway $gateway
dns-nameservers $dns
" > /etc/network/interfaces 
;;
*)
echo "Fallait pas faire d'erreur tant pis pour vous ... "
;;
esac
;;
*)
echo "Fallait pas faire d'erreur tant pis pour vous ... "
;;
esac
;;
*)
echo "Fallait pas faire d'erreur tant pis pour vous ... "
;;
esac
;;
*)
echo "Fallait pas faire d'erreur tant pis pour vous ... "
;;
esac
;;
"2")
echo "auto lo
iface lo inet loopback
# The primary network interface
allow-hotplug eth0
auto eth0
iface eth0 inet dhcp
" > /etc/network/interfaces
;;
*)
;;
esac

/etc/init.d/networking restart
clear 
echo "
Voulez-vous voir le fichier de configuration des interfaces ? [Y/N]"
read choix
case $choix in 
"y")
cat /etc/network/interfaces
;;
"Y")
cat /etc/network/interfaces
;;
*) 
echo "Pas de problème"
;;
esac
