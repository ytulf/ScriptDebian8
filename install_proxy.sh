clear
echo "
##############################################################
### Installation de Squid3 et de SquidGuard avec le script ###
###	       install_proxy.sh par Thomas SAVIO               ###
##############################################################
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
clear
### Installation de Squid
apt-get install -y  squid3

### Sauvegarde du fichier de configuration de Squid
cd /etc/squid3/
mv squid.conf squid.conf.defaut

### Créer fichier de configuration vide
touch squid.conf

### Changer le nom de l'hôte
clear
echo "
Quel nom souhaitez-vous comme nom pour le serveur ? [exemple : frmanproxy.btssio.com]"
read hote
case $hote in
echo "
Est-ce que c'est le bon nom pour le serveur que vous souhaitez '$hote' ? [Y/N]"
read validation
case $validation in
"y")
echo "$hote" > /etc/hostname
;;
"Y")
echo "$hote" > /etc/hostname
;;
*)
echo "Du coup ca sera frmanproxy.btssio.com car vous ne savez pas décidé pour changer ce nom modifier le fichier /etc/hostname"
echo "frmanproxy.btssio.com" > /etc/hostname
;;     
esac
clear
echo "
Poursuite du script vers configuration de squid.conf"

touch interfaces.txt
echo "
Quel interface sert pour le réseau local (LAN) : eth0 [0], eth1 [1], eth2[2], eth3 [3], eth4[4] ?"
read int
case $int in 
"0")
echo "`ifconfig eth0 | grep 'inet adr:' | cut -d: -f2 | awk '{ print $1}'`" > interfaces.txt
;;
"1")
echo "IP=`ifconfig eth1 | grep 'inet adr:' | cut -d: -f2 | awk '{ print $1}'`" > interfaces.txt
;;
"2")
echo "IP=`ifconfig eth2 | grep 'inet adr:' | cut -d: -f2 | awk '{ print $1}'`" > interfaces.txt
;;
"3")
echo "IP=`ifconfig eth3 | grep 'inet adr:' | cut -d: -f2 | awk '{ print $1}'`" > interfaces.txt
;;
"4")
echo "IP=`ifconfig eth4 | grep 'inet adr:' | cut -d: -f2 | awk '{ print $1}'`" > interfaces.txt
;;
*)
echo "Ca sera donc l'interface eth0 par défaut"
echo "IP=`ifconfig eth0 | grep 'inet adr:' | cut -d: -f2 | awk '{ print $1}'`" > interfaces.txt
;;
esac
echo "
Votre interface aura donc pour adresse IP : $(cat interfaces.txt)"
echo "
Poursuite du script .."

### Configuration du fichier squid3.conf
echo "# Squid a besoin de savoir le nom de la machine, notre machine s’appelle $hote, donc :
visible_hostname $hote

# Par défaut le proxy écoute sur ses deux interfaces, pour des soucis de sécurité il faut donc le
# restreindre à écouter sur l’interface du réseau local (LAN)

http_port $(cat interfaces.txt):3128

# Changer la taille du cache de squid, changer la valeur 100 par ce que vous voulez (valeur en Mo)

cache_dir ufs /var/spool/squid3 100 16 256

#################################### ACL ####################################
acl all src all # ACL pour autoriser/refuser tous les réseaux (Source = All) – ACL obligatoire
acl lan src 192.168.16.0/24# ACL pour autoriser/refuser le réseau de la lan 192.168.16.0
acl dmz src 172.16.0.0/16 # ACL pour autoriser/refuser le réseau de la dmz 172.16.0.0
acl Safe_ports port 80 # Port HTTP = Port 'sure'
acl Safe_ports port 443 # Port HTTPS = Port 'sure'
acl Safe_ports port 21 # Port FTP = Port 'sure'
############################################################################
# Désactiver tous les protocoles sauf les ports sures

http_access deny !Safe_ports

# Désactiver l'accès pour tous les réseaux sauf les clients de l'ACL Lan
# deny = refuser ; ! = sauf ; lan = nom de l’ACL à laquelle on fait référence.

http_access deny !lan !dmz

# Port utilisé par le Proxy :
# Le port indiqué ici, devra être celui qui est précisé dans votre navigateur.

http_port 3128

# Spécifie le chemin vers les logs d’accès créé pour chaque page visitée
access_log /var/log/squid3/access.log

# voir dans les logs d’accès squid les url complètes des pages visitées par les utilisateurs
strip_query_terms off" > squid.conf

### Lancer le service squid
mkdir -p /home/precise/cache/
chmod 777 /home/precise/cache/
chown proxy:proxy /home/precise/cache/
cp /etc/squid3/squid.conf /etc/squid3/squid.conf.origin
chmod 777 /etc/squid3/squid.conf.origin

service squid3 restart

clear
echo "
Installation de squidguard"
### SquidGuard
apt-get install -y squidguard

cp /etc/squidguard/squidGuard.conf /etc/squidguard/squidGuard.back

echo "#
# CONFIG FILE FOR SQUIDGUARD
dbhome /var/lib/squidguard/db
logdir /var/log/squidguard/squidGuard.log
# domaines bloqués
dest ads {
        domainlist      ads/domains
        urllist         ads/urls
}
dest porn {
        domainlist      porn/domains
        urllist         porn/urls
}
dest warez {
        domainlist      warez/domains
        urllist         warez/urls
}
acl {
        default {
                pass    !ads !porn !warez all
                redirect http://localhost/block.html
                }
}" >> /etc/squidguard/squidGuard.conf
clear
echo "
Téléchargement de la blacklist"
### Téléchargement de la blacklist
wget --no-check-certificate http://squidguard.mesd.k12.or.us/blacklists.tgz
tar xzf blacklists.tgz
cp -R blacklists/* /var/lib/squidguard/db/
chmod 777 /var/lib/squidGuard/db/*
squidGuard -C all

# Création d'un lien symbolique entre squidGuard et squid3
ln -s /etc/squidguard/squidGuard.conf /etc/squid3/

## Vérification de squid 
squid3 -z

# pause.sh : redémarrage pour prendre en compte le hostname
clear
echo "
Voulez-vous redémarrer ? [Y/N]"
read validation
case $validation in 
        "y")
                reboot
                ;;
        "Y")
                reboot
                ;;
        *)
                echo "Pas de reboot"
				;;
	esac
