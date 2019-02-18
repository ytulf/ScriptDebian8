echo "
####################################################################
### Installation du service DHCP avec le script install_dhcp.sh  ###
###                     par Thomas SAVIO                         ###
####################################################################
"
### Changer les sources listes de wheezy vers jessie
DIALOG=${DIALOG=dialog}
fichtemp=`tempfile 2>/dev/null` || fichtemp=/tmp/test$$
trap "rm -f $fichtemp" 0 1 2 5 15

$DIALOG --backtitle "Que voulez-vous faire ?" \
	--title "Choix" --clear \
        --radiolist "Vous pouvez choisir parmi la liste ci-dessous : \n
Pour sélectionner faites défiler puis 'espace' pour choisir " 20 61 5 \
	"1" "Mettre les sources lists sous jessie" ON\
	  "2" "Rien de tout ça" off 2> $fichtemp
valret=$?
choix=`cat $fichtemp`
case $choix in 
        "1")
clear
echo "deb http://ftp.fr.debian.org/debian/ jessie main non-free contrib
deb-src http://ftp.fr.debian.org/debian/ jessie main non-free contrib
deb http://security.debian.org/ jessie/updates main contrib non-free
deb-src http://security.debian.org/ jessie/updates main contrib non-free" > /etc/apt/sources.list
;;
        *)
;;
esac

### Mise à jour des répertoires
DIALOG=${DIALOG=dialog}
fichtemp=`tempfile 2>/dev/null` || fichtemp=/tmp/test$$
trap "rm -f $fichtemp" 0 1 2 5 15

$DIALOG --backtitle "Que voulez-vous faire ?" \
	--title "Choix" --clear \
        --radiolist "Vous pouvez choisir parmi la liste ci-dessous :\n
Pour sélectionner faites défiler puis 'espace' pour choisir " 20 61 5 \
	"1" "Apt-get update" ON\
         "2" "apt-get upgrade" off\
          "3" "Les deux" off\
	    "4" "Rien de tout ça" off 2> $fichtemp
valret=$?
choix=`cat $fichtemp`
case $choix in
        "1")
                clear
		apt-get update -y
                ;;
        "2")
                clear
		apt-get upgrade -y
                ;;
        "3")
                clear
		apt-get update && apt-get upgrade -y
		apt-get dist-upgrade -y
                ;;
        *)
                clear
		echo "Ok poursuite du script"
                ;;
esac
### Installation du service DHCP
apt-get install -y isc-dhcp-server

### On met l'interface où l'on veut écouter dans le fichier de isc-dhcp-server
echo "
Quel interface souhaitez-vous écouter [pour le fichier de isc-dhcp-server] eth0[0] ? eth1[1]? eth2[2] ?"
read interface
case $interface in 
"0")
echo "INTERFACES='eth0'" > /etc/default/isc-dhcp-server
;;
"1")
echo "INTERFACES='eth1'" > /etc/default/isc-dhcp-server
;;
"2")
echo "INTERFACES='eth2'" > /etc/default/isc-dhcp-server
;;
*)
echo "Par défault on va mettre eth0 alors"
echo "INTERFACES='eth0'" > /etc/default/isc-dhcp-server
;;
esac
### On configure le fichier de configuration : dhcpd.conf
clear
echo "
Début de la configuration de dhcpd.conf"
echo "
Quel est le réseau que vous souhaitez utiliser pour le dhcp ? [exemple 192.168.20.0]"
read reseau
echo "
C'est bien ce réseau la que vous souhaitez rentrer dans la configuration '$reseau' ? [Y/N]"
read validation
case $validation in 
"Y")
echo "
Quel masque souhaitez-vous pour votre réseau ? [exemple 255.255.255.0]"
read masque
echo "
C'est bien ce masque la que vous souhaitez rentrer dans la configuration '$masque' ? [Y/N]"
read validation
case $validation in 
"Y")
echo "
Quel range souhaitez-vous pour votre réseau ? [exemple 192.168.20.20 192.168.20.30]"
read range
echo "
C'est bien cet range la que vous souhaitez rentrer dans la configuration '$range' ? [Y/N]"
read validation
case $validation in
"Y")
echo "
Quel domain-name-server souhaitez-vous pour votre réseau ? [exemple 8.8.8.8]"
read dns
echo "
C'est bien ce masque la que vous souhaitez rentrer dans la configuration '$dns' ? [Y/N]"
read validation
case $validation in
"Y")
echo "# Notre configuration pour le réseau $reseau
subnet $reseau netmask $masque {
range $range;
option domain-name-servers $dns;
default-lease-time 600;
max-lease-time 7200;
} " > /etc/dhcp/dhcpd.conf
;;
"y")
echo "# Notre configuration pour le réseau $reseau
subnet $reseau netmask $masque {
range $range;
option domain-name-servers $dns;
default-lease-time 600;
max-lease-time 7200;
} " > /etc/dhcp/dhcpd.conf
;;
*)
echo "Tant pis pour vous .."
;;
esac
;;	
"y")
echo "
Quel domain-name-server souhaitez-vous pour votre réseau ? [exemple 8.8.8.8]"
read dns
echo "
C'est bien ce masque la que vous souhaitez rentrer dans la configuration '$dns' ? [Y/N]"
read validation
case $validation in
"Y")
echo "# Notre configuration pour le réseau $reseau
subnet $reseau netmask $masque {
range $range;
option domain-name-servers $dns;
default-lease-time 600;
max-lease-time 7200;
} " > /etc/dhcp/dhcpd.conf
;;
"y")
echo "# Notre configuration pour le réseau $reseau
subnet $reseau netmask $masque {
range $range;
option domain-name-servers $dns;
default-lease-time 600;
max-lease-time 7200;
} " > /etc/dhcp/dhcpd.conf
;;
*)
echo "Tant pis pour vous .."
;;
esac
;;
*)
echo "Tant pis pour vous .. "
;;
esac
;;
"y")
echo "
Quel range souhaitez-vous pour votre réseau ? [exemple 192.168.20.20 192.168.20.30]"
read range
echo "
C'est bien cet range la que vous souhaitez rentrer dans la configuration '$range' ? [Y/N]"
read validation
case $validation in
"Y")
echo "
Quel domain-name-server souhaitez-vous pour votre réseau ? [exemple 8.8.8.8]"
read dns
echo "
C'est bien ce masque la que vous souhaitez rentrer dans la configuration '$dns' ? [Y/N]"
read validation
case $validation in
"Y")
echo "# Notre configuration pour le réseau $reseau
subnet $reseau netmask $masque {
range $range;
option domain-name-servers $dns;
default-lease-time 600;
max-lease-time 7200;
} " > /etc/dhcp/dhcpd.conf
;;
"y")
echo "# Notre configuration pour le réseau $reseau
subnet $reseau netmask $masque {
range $range;
option domain-name-servers $dns;
default-lease-time 600;
max-lease-time 7200;
} " > /etc/dhcp/dhcpd.conf
;;
*)
echo "Tant pis pour vous .."
;;
esac
;;	
"y")
echo "
Quel domain-name-server souhaitez-vous pour votre réseau ? [exemple 8.8.8.8]"
read dns
echo "
C'est bien ce masque la que vous souhaitez rentrer dans la configuration '$dns' ? [Y/N]"
read validation
case $validation in
"Y")
echo "# Notre configuration pour le réseau $reseau
subnet $reseau netmask $masque {
range $range;
option domain-name-servers $dns;
default-lease-time 600;
max-lease-time 7200;
} " > /etc/dhcp/dhcpd.conf
;;
"y")
echo "# Notre configuration pour le réseau $reseau
subnet $reseau netmask $masque {
range $range;
option domain-name-servers $dns;
default-lease-time 600;
max-lease-time 7200;
} " > /etc/dhcp/dhcpd.conf
;;
*)
echo "Tant pis pour vous .."
;;
esac
;;
*)
echo "Tant pis pour vous .. "
;;
esac
;;
*)
echo "Tant pis pour vous .."
;;
esac
;;
"y")
echo "
Quel masque souhaitez-vous pour votre réseau ? [exemple 255.255.255.0]"
read masque
echo "
C'est bien ce masque la que vous souhaitez rentrer dans la configuration '$masque' ? [Y/N]"
read validation
case $validation in 
"Y")
echo "
Quel range souhaitez-vous pour votre réseau ? [exemple 192.168.20.20 192.168.20.30]"
read range
echo "
C'est bien cet range la que vous souhaitez rentrer dans la configuration '$range' ? [Y/N]"
read validation
case $validation in
"Y")
echo "
Quel domain-name-server souhaitez-vous pour votre réseau ? [exemple 8.8.8.8]"
read dns
echo "
C'est bien ce masque la que vous souhaitez rentrer dans la configuration '$dns' ? [Y/N]"
read validation
case $validation in
"Y")
echo "# Notre configuration pour le réseau $reseau
subnet $reseau netmask $masque {
range $range;
option domain-name-servers $dns;
default-lease-time 600;
max-lease-time 7200;
} " > /etc/dhcp/dhcpd.conf
;;
"y")
echo "# Notre configuration pour le réseau $reseau
subnet $reseau netmask $masque {
range $range;
option domain-name-servers $dns;
default-lease-time 600;
max-lease-time 7200;
} " > /etc/dhcp/dhcpd.conf
;;
*)
echo "Tant pis pour vous .."
;;
esac
;;	
"y")
echo "
Quel domain-name-server souhaitez-vous pour votre réseau ? [exemple 8.8.8.8]"
read dns
echo "
C'est bien ce masque la que vous souhaitez rentrer dans la configuration '$dns' ? [Y/N]"
read validation
case $validation in
"Y")
echo "# Notre configuration pour le réseau $reseau
subnet $reseau netmask $masque {
range $range;
option domain-name-servers $dns;
default-lease-time 600;
max-lease-time 7200;
} " > /etc/dhcp/dhcpd.conf
;;
"y")
echo "# Notre configuration pour le réseau $reseau
subnet $reseau netmask $masque {
range $range;
option domain-name-servers $dns;
default-lease-time 600;
max-lease-time 7200;
} " > /etc/dhcp/dhcpd.conf
;;
*)
echo "Tant pis pour vous .."
;;
esac
;;
*)
echo "Tant pis pour vous .. "
;;
esac
;;
"y")
echo "
Quel range souhaitez-vous pour votre réseau ? [exemple 192.168.20.20 192.168.20.30]"
read range
echo "
C'est bien cet range la que vous souhaitez rentrer dans la configuration '$range' ? [Y/N]"
read validation
case $validation in
"Y")
echo "
Quel domain-name-server souhaitez-vous pour votre réseau ? [exemple 8.8.8.8]"
read dns
echo "
C'est bien ce masque la que vous souhaitez rentrer dans la configuration '$dns' ? [Y/N]"
read validation
case $validation in
"Y")
echo "# Notre configuration pour le réseau $reseau
subnet $reseau netmask $masque {
range $range;
option domain-name-servers $dns;
default-lease-time 600;
max-lease-time 7200;
} " > /etc/dhcp/dhcpd.conf
;;
"y")
echo "# Notre configuration pour le réseau $reseau
subnet $reseau netmask $masque {
range $range;
option domain-name-servers $dns;
default-lease-time 600;
max-lease-time 7200;
} " > /etc/dhcp/dhcpd.conf
;;
*)
echo "Tant pis pour vous .."
;;
esac
;;	
"y")
echo "
Quel domain-name-server souhaitez-vous pour votre réseau ? [exemple 8.8.8.8]"
read dns
echo "
C'est bien ce masque la que vous souhaitez rentrer dans la configuration '$dns' ? [Y/N]"
read validation
case $validation in
"Y")
echo "# Notre configuration pour le réseau $reseau
subnet $reseau netmask $masque {
range $range;
option domain-name-servers $dns;
default-lease-time 600;
max-lease-time 7200;
} " > /etc/dhcp/dhcpd.conf
;;
"y")
echo "# Notre configuration pour le réseau $reseau
subnet $reseau netmask $masque {
range $range;
option domain-name-servers $dns;
default-lease-time 600;
max-lease-time 7200;
} " > /etc/dhcp/dhcpd.conf
;;
*)
echo "Tant pis pour vous .."
;;
esac
;;
*)
echo "Tant pis pour vous .. "
;;
esac
;;
*)
echo "Tant pis pour vous .."
;;
esac
;;
*)
echo "Tant pis pour vous .."
;;
esac
clear
### Lancer le service DHCP
service isc-dhcp-server restart
