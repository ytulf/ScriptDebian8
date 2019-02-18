echo "
###########################################################
### Installation de GLPI avec le script install_GLPI.sh ###
###                par Thomas SAVIO                     ###
###########################################################
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

### Installation des services
apt-get install mysql-server mysql-client -y && apt-get install glpi -y

### Installation du plugins fusioninventory 
cd /usr/share/glpi/plugins
wget http://forge.fusioninventory.org/attachments/download/1665/fusioninventory-for-glpi_0.84+3.5.tar.gz
tar zxvf fusioninventory-for-glpi_0.84+3.5.tar.gz
rm -f fusioninventory-for-glpi_0.84+3.5.tar.gz

read -p "Voulez-vous installer l'agent sur votre machine ? [press 'non' if you doesn't, press any key for continue]" confirmation
case $confirmation in
"non")
;;
*)
wget https://raw.githubusercontent.com/keijix/script/master/config_fusioninventoryagentlinux.sh
chmod 777 config_fusioninventoryagentlinux.sh
./config_fusioninventoryagentlinux.sh
;;
esac
