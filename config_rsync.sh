echo "
#####################################################################
### Configuration de la sauvegarde avec le script config_rsync.sh ###
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
                ;;
        *)
                clear
		echo "Ok poursuite du script"
                ;;
esac
### Installation des dépendances
apt-get autoremove -y
apt-get install rsync ssh -y
read -p "Quel dossier voulez-vous sauvegarder [exemple : /usr/share/pydio] ? " choix1
read -p "Vers où voulez-vous l'envoyer [exemple : frmannas:/chemin/vers/cible ou 192.168.16.20:/chemin] ? " choix2
echo "
Voulez-vous faire une sauvegarde du dossier '$choix1' vers '$choix2' [Y/N] "
read validation
case $validation in
"N") read -p "Redémarrage du script, appuyer sur n'importe quel touche" go
./config_rsync.sh
;;
"n") read -p "Redémarrage du script, appuyer sur n'importe quel touche" go
./config_rsync.sh
;;
"y")
rsync -e ssh -avz `$choix1` `$choix2`
;;
"Y")
rsync -e ssh -avz `$choix1` `$choix2`
;;
*)
echo "Fin du script "
;;
esac
rm config_rsync.sh
