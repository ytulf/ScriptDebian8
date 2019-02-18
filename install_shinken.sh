echo "
##################################################################
### Installation de Shinken avec le script install_shinken.sh  ###
###                   par Thomas SAVIO                         ###
##################################################################
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
### Installation des dépendances
apt-get install python -y 
apt-get install python-pycurl python-setuptools -y

apt-get install -y git sudo
clear
### Installation des dépots shinken
cd ~
git clone https://github.com/naparuba/shinken.git 
cd shinken

### Création de l'utilisateur shinken
read -p "Avez-vous déjà créer un utilisateur :'Shinken' ? [Y/N]" oui
case $oui in
"n")
adduser shinken
;;
"N")
adduser shinken
;;
*)
;;
esac
### Installation de shinken
cd ~/shinken
python setup.py install

###Installation des dépendances souhaités par shinken et de webui2
apt-get install -y python-cherrypy3
update-rc.d shinken defaults
/etc/init.d/shinken start
sudo -u shinken shinken --init
sudo -u shinken shinken install webui2 

apt-get install python-pip mongodb -y
pip install pymongo>=3.0.3 requests arrow bottle==0.12.8
### Modification du broker dans le fichier/etc/shinken/brokers/broker-master.cfg
echo "#===============================================================================
# BROKER (S1_Broker)
#===============================================================================
# Description: The broker is responsible for:
# - Exporting centralized logs of all Shinken daemon processes
# - Exporting status data
# - Exporting performance data
# - Exposing Shinken APIs:
#   - Status data
#   - Performance data
#   - Configuration data
#   - Command interface
# https://shinken.readthedocs.org/en/latest/08_configobjects/broker.html
#===============================================================================
define broker {
    broker_name     broker-master
    address         localhost
    port            7772
    spare           0

    ## Optional
    manage_arbiters     1   ; Take data from Arbiter. There should be only one
                            ; broker for the arbiter.
    manage_sub_realms   1   ; Does it take jobs from schedulers of sub-Realms?
    timeout             3   ; Ping timeout
    data_timeout        120 ; Data send timeout
    max_check_attempts  3   ; If ping fails N or more, then the node is dead
    check_interval      60  ; Ping node every N seconds

    ## Modules
    # Default: None
    # Interesting modules that can be used:
    # - simple-log              = just all logs into one file
    # - livestatus              = livestatus listener
    # - tondodb-mysql           = NDO DB support (deprecated)
    # - npcdmod                 = Use the PNP addon
    # - graphite                = Use a Graphite time series DB for perfdata
    # - webui                   = Shinken Web interface
    # - glpidb                  = Save data in GLPI MySQL database
    modules                     webui2

    # Enable https or not
    use_ssl	          0
    # enable certificate/hostname check, will avoid man in the middle attacks
    hard_ssl_name_check   0
    
    ## Advanced
    realm   All
} " > /etc/shinken/brokers/broker-master.cfg

/etc/init.d/shinken restart 
echo " "
echo " "
read -p "Quel est le mot de passe que vous souhaitez utiliser pour vous connecter à shinken ? " mdp
read -p "Quel est l'@IP que vous souhaitez utiliser pour shinken ? [exemple : your_mail@hotmail.fr] " mail
echo "define contact{
    use             generic-contact
    contact_name    admin
    email           $mail
    pager           0600000000   ; contact phone number
    password        $mdp
    is_admin        1
    expert          1
} " > /etc/shinken/contacts/admin.cfg
### Installation de plugins nagios
cd ~
wget http://www.nagios-plugins.org/download/nagios-plugins-2.1.1.tar.gz
tar -xzvf nagios-plugins-2.1.1.tar.gz
cd nagios-plugins-2.1.1/
./configure --with-nagios-user=shinken --with-nagios-group=shinken
make
make install
clear
whereis nagios
echo "Où se trouve nagios ? /usr/local/nagios [1] ou /usr/lib/nagios/ [2] ?"
read choix 
case $choix in
"1")
echo "# Nagios legacy macros
$USER1$=$NAGIOSPLUGINSDIR$
# $NAGIOSPLUGINSDIR$=/usr/lib/nagios/plugins
$NAGIOSPLUGINSDIR$=/usr/local/nagios/libexec

#-- Location of the plugins for Shinken
$PLUGINSDIR$=/var/lib/shinken/libexec" > /etc/shinken/resource.d/paths.cfg
;;
*)
;;
esac
sudo -u shinken shinken install linux-ssh
sudo -u shinken shinken install linux-snmp
/etc/init.d/shinken restart
apt-get install nmap -y 
clear
read -p "Quel réseau souhaitez vous écouter ? [exemple : 192.168.1.0/24]" res
echo "#-- Discovery
# default snmp community
$SNMPCOMMUNITYREAD$=public
# what to discover by default
$NMAPTARGETS$= $res
# If your scans are too slow, try to increase minrate (number of packet in parallel
# and reduce the number of retries.
$NMAPMINRATE$=1000
$NMAPMAXRETRIES$=0 " > /etc/shinken/resource.cfg
shinken-discovery -c /etc/shinken/discovery/discovery.cfg -o /etc/shinken/objects/discovery -r nmap
apt-get install snmp -y
/etc/init.d/shinken restart

echo "Il ne vous reste plus qu'à vous connecter sur http://@IP:7767
http://www.ophyde.com/shinken-monitoring-systeme-et-reseau/
http://sysadmin.cool/2016/03/shinken-installation
https://wiki.kogite.fr/index.php/Paramétrage_de_Shinken"
