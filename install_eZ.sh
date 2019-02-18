### eZ server monitor
echo "
########################################################
### Installation de eZ avec le script install_eZ.sh  ###
###                    par Thomas SAVIO              ###
########################################################
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
		apt-get update -y && apt-get upgrade -y
		apt-get dist-upgrade -y
                ;;
        *)
                clear
		echo "Ok poursuite du script"
                ;;
esac
### Installation de eZ
DIALOG=${DIALOG=dialog}
fichtemp=`tempfile 2>/dev/null` || fichtemp=/tmp/test$$
trap "rm -f $fichtemp" 0 1 2 5 15

$DIALOG --backtitle "Que voulez-vous faire ?" \
	--title "Choix" --clear \
        --radiolist "Vous pouvez choisir parmi la liste ci-dessous :\n
	Pour sélectionner faites défiler puis 'espace' pour choisir " 20 61 5 \
	"1" "Accès via interface graphique" ON\
	  "2" "Accès via terminal" off\
           "3" "Rien de tout ça" off 2> $fichtemp
valret=$?
choix=`cat $fichtemp`
case $choix in 
        "1")
clear
### Installation des dépôts 
apt-get install apache2 php5 unzip -y

cd /var/www/html
wget https://www.ezservermonitor.com/esm-web/downloads/version/2.5
unzip /var/www/html/2.5

mv /var/www/html/eZServerMonitor-2.5 /var/www/html/ez
chown www-data:www-data -Rf /var/www/html/ez/

ifconfig eth0 | grep 'inet adr:' | cut -d: -f2 | awk '{ print $1}' > ip.txt
read -p "
Aller maintenant sur http://`cat ip.txt`/ez, une fois fait appuyer sur n'importe quel touche pour retourner sur l'hôte" pause
rm -rf ip.txt
;;
"2")
clear
apt-get install -y unzip
wget https://www.ezservermonitor.com/esm-sh/downloads/version/2.2
unzip  2.2
chmod u+x eZServerMonitor.sh
./eZServerMonitor.sh -a
read -p "
Pour relancer le script quand vous voulez il suffit de faire ./eZserverMonitor.sh -a
appuyez sur n'importe quel touche pour continuer" pause
;;
*)
clear
echo "
Vous n'avez rien selectionné donc redémarrer le script "
;;
esac
