echo "
#####################################################################
### Installation de Heartbeat avec le script install_heartbeat.sh ###
###                      par Thomas SAVIO                         ###
#####################################################################
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

### On installe heartbeat et apache
echo "
Installation des services nécessaires "
apt-get install apache2 -y
apt-get install heartbeat -y

### Modification des fichiers 
## Fichier authkeys
echo "auth 3
3 md5 password" > /etc/ha.d/authkeys
chmod 600 /etc/ha.d/authkeys

## Fichier ha.cf
read -p "Quel est votre le nom de votre machine [exemple : www1] ? " www1
read -p "Quel est votre le nom de la deuxième machine [exemple : www2]? " www2
read -p "Quel est votre l'interface de liaison entre les deux routers [exemple : eth0] ? " eth

echo "logfile /var/log/ha-log 
logfacility   local0
keepalive     2
deadtime      10
bcast         $eth
node          $www1 $www2
auto_failback  on
respawn        hacluster /usr/lib/heartbeat/ipfail
apiauth        ipfail gid=haclient uid=hacluster" > /etc/ha.d/ha.cf

## Fichier haresources
echo "Combien d'interface souhaitez-vous utiliser : [1], [2], [3], [4], [5] ?"
read choix
case $choix in 
"1")
read -p "Quel est l'adresse IP de votre interface [exemple : 192.168.0.254]? " ip1
read -p "Quel est le masque que vous souhaitez utiliser ? [exemple : 24 ne pas utilisez le '/'] " mask
read -p "Quel est votre le nom de la première machine [exemple : www1] ? " www1
read -p "Quel est nom du service que vous voulez utiliser [exemple : apache2] ? " service

echo "$www1 IPaddr::$ip1/$mask/$eth $service" > /etc/ha.d/haresources
;;
"2")
read -p "Quel est l'adresse IP de votre première interface [exemple : 192.168.0.254] ? " ip1
read -p "Quel est le masque que vous souhaitez utiliser pour la première interface ? [exemple : 24 ne pas utilisez le '/']" mask1
read -p "Quel est le nom de l'interface de la première adresse IP  [exemple : eth1] ?" eth1
read -p "Quel est votre le nom de la première machine [exemple : www1] ? " www1

read -p "Quel est l'adresse IP de votre deuxième interface [exemple : 192.168.0.254] ? " ip2
read -p "Quel est le masque que vous souhaitez utiliser pour la deuxième interface ? [exemple : 24 ne pas utilisez le '/']" mask2
read -p "Quel est le nom de l'interface de la deuxième adresse IP  [exemple : eth1] ? " eth2

read -p "Quel est nom du service que vous voulez utiliser [exemple : apache2] ?" service
echo "$ww1 IPaddr::$ip1/$mask1/$eth1 $service
$ww1 IPaddr::$ip2/$mask2/$eth2 $service" > /etc/ha.d/haresources
;;
"3")
read -p "Quel est l'adresse IP de votre première interface [exemple : 192.168.0.254] ? " ip1
read -p "Quel est le masque que vous souhaitez utiliser pour la première interface ? [exemple : 24 ne pas utilisez le '/']" mask1
read -p "Quel est le nom de l'interface de la première adresse IP  [exemple : eth1] ?" eth1
read -p "Quel est votre le nom de la première machine [exemple : www1] ? " www1

read -p "Quel est l'adresse IP de votre deuxième interface [exemple : 192.168.0.254] ? " ip2
read -p "Quel est le masque que vous souhaitez utiliser pour la deuxième interface ? [exemple : 24 ne pas utilisez le '/']" mask2
read -p "Quel est le nom de l'interface de la deuxième adresse IP  [exemple : eth1] ?" eth2

read -p "Quel est l'adresse IP de votre troisième interface [exemple : 192.168.0.254] ? " ip3
read -p "Quel est le masque que vous souhaitez utiliser pour la troisième interface ? [exemple : 24 ne pas utilisez le '/']" mask3
read -p "Quel est le nom de l'interface de la troisième adresse IP  [exemple : eth1] ?" eth3

read -p "Quel est le nom du service que vous voulez utiliser [exemple : apache2] ?" service

echo "$ww1 IPaddr::$ip1/$mask1/$eth1 $service
$ww1 IPaddr::$ip2/$mask2/$eth2 $service
$ww1 IPaddr::$ip3/$mask3/$eth3 $service" > /etc/ha.d/haresources
;;
"4")
read -p "Quel est l'adresse IP de votre première interface [exemple : 192.168.0.254] ? " ip1
read -p "Quel est le masque que vous souhaitez utiliser pour la première interface ? [exemple : 24 ne pas utilisez le '/']" mask1
read -p "Quel est le nom de l'interface de la première adresse IP  [exemple : eth1] ?" eth1
read -p "Quel est votre le nom de la première machine [exemple : www1] ? " www1

read -p "Quel est l'adresse IP de votre deuxième interface [exemple : 192.168.0.254] ? " ip2
read -p "Quel est le masque que vous souhaitez utiliser pour la deuxième interface ? [exemple : 24 ne pas utilisez le '/']" mask2
read -p "Quel est le nom de l'interface de la deuxième adresse IP  [exemple : eth1] ?" eth2

read -p "Quel est l'adresse IP de votre troisième interface [exemple : 192.168.0.254] ? " ip3
read -p "Quel est le masque que vous souhaitez utiliser pour la troisième interface ? [exemple : 24 ne pas utilisez le '/']" mask3
read -p "Quel est le nom de l'interface de la troisième adresse IP  [exemple : eth1] ?" eth3

read -p "Quel est l'adresse IP de votre quatrième interface [exemple : 192.168.0.254] ? " ip4
read -p "Quel est le masque que vous souhaitez utiliser pour la quatrième interface ? [exemple : 24 ne pas utilisez le '/']" mask4
read -p "Quel est le nom de l'interface de la quatrième adresse IP  [exemple : eth1] ?" eth4

read -p "Quel est le nom du service que vous voulez utiliser [exemple : apache2] ?" service

echo "$ww1 IPaddr::$ip1/$mask1/$eth1 $service
$ww1 IPaddr::$ip2/$mask2/$eth2 $service
$ww1 IPaddr::$ip3/$mask3/$eth3 $service
$ww1 IPaddr::$ip4/$mask4/$eth4 $service" > /etc/ha.d/haresources
;;
"5")
read -p "Quel est l'adresse IP de votre première interface [exemple : 192.168.0.254] ? " ip1
read -p "Quel est le masque que vous souhaitez utiliser pour la première interface ? [exemple : 24 ne pas utilisez le '/']" mask1
read -p "Quel est le nom de l'interface de la première adresse IP  [exemple : eth1] ?" eth1
read -p "Quel est votre le nom de la première machine [exemple : www1] ? " www1

read -p "Quel est l'adresse IP de votre deuxième interface [exemple : 192.168.0.254] ? " ip2
read -p "Quel est le masque que vous souhaitez utiliser pour la deuxième interface ? [exemple : 24 ne pas utilisez le '/']" mask2
read -p "Quel est le nom de l'interface de la deuxième adresse IP  [exemple : eth1] ?" eth2

read -p "Quel est l'adresse IP de votre troisième interface [exemple : 192.168.0.254] ? " ip3
read -p "Quel est le masque que vous souhaitez utiliser pour la troisième interface ? [exemple : 24 ne pas utilisez le '/']" mask3
read -p "Quel est le nom de l'interface de la troisième adresse IP  [exemple : eth1] ?" eth3

read -p "Quel est l'adresse IP de votre quatrième interface [exemple : 192.168.0.254] ? " ip4
read -p "Quel est le masque que vous souhaitez utiliser pour la quatrième interface ? [exemple : 24 ne pas utilisez le '/']" mask4
read -p "Quel est le nom de l'interface de la quatrième adresse IP  [exemple : eth1] ?" eth4

read -p "Quel est l'adresse IP de votre cinquième interface [exemple : 192.168.0.254] ? " ip5
read -p "Quel est le masque que vous souhaitez utiliser pour la cinquième interface ? [exemple : 24 ne pas utilisez le '/']" mask5
read -p "Quel est le nom de l'interface de la cinquième adresse IP [exemple : eth1] ?" eth5

read -p "Quel est le nom du service que vous voulez utiliser [exemple : apache2] ?" service

echo "$ww1 IPaddr::$ip1/$mask1/$eth1 $service
$ww1 IPaddr::$ip2/$mask2/$eth2 $service
$ww1 IPaddr::$ip3/$mask3/$eth3 $service
$ww1 IPaddr::$ip4/$mask4/$eth4 $service
$ww1 IPaddr::$ip5/$mask5/$eth5 $service" > /etc/ha.d/haresources
;;
*)
;;
esac

/etc/init.d/apache2 stop

read -p "Veuillez lancer le script sur l'autre serveur, une fois que vous êtes arrivé ici avec l'autre serveur vous pouvez taper 'Go' 
" depart
case $depart in
"Go")
;;
"go")
;;
*)
read -p "Avez-vous installé le script sur l'autre serveur [Y/N] ?" validation
case $validation in 
"n")
echo 'Faites le alors'
;;
"N")
echo 'Faites le alors'
;;
*)
echo "Ok poursuite du script"
;;
esac
;;
esac

/etc/init.d/heartbeat start

ip -4 -o addr show
