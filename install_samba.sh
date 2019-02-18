echo "
##############################################################
### Installation de samba avec le script install_samba.sh  ###
###                    par Thomas SAVIO                    ###
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
### Création des répértoires
read -p "Quel dossier voulez-vous créer comme premier dossier de partage [exemple : comptabilite] " choix1
read -p "Quel dossier voulez-vous créer comme deuxième dossier de partage [exemple : comptabilite] " choix2

cd /home/
mkdir partage
cd partage/
mkdir $choix1
mkdir $choix2

### Création des utilisateurs 
echo " Création de deux utilisateur : "
read -p "Quel premier utilisateur voulez vous créer ? " user1
read -p "Quel second utilisateur voulez vous créer ? " user2

useradd $user1
useradd $user2


### Création des groupes 
echo "Création des groupes, '$choix1' et '$choix2', correspondants au dossier "
groupadd $choix1
groupadd $choix2

### Attributions des utilisateurs aux groupes
read -p "L'utilisateur '$user1' est l'utilisateur de quel groupe [exemple : '$choix1' [1] ou '$choix2' [2] ]? " gro
case $gro in 
"1")
gpasswd –a `$user1` `$choix1`
;;
"2")
gpasswd –a `$user1` `$choix2`

;;
*)
;;
esac
read -p "L'utilisateur '$user2' est l'utilisateur de quel groupe [exemple : '$choix1' [1] ou '$choix2' [2] ]? " gro
case $gro in 
"1")
gpasswd –a `$user2` `$choix1`
;;
"2")
gpasswd –a `$user2` `$choix2`
;;
*)
;;
esac
### Attribution des droits au groupe 
chgrp $choix1 /home/partage/$choix1/ 
chgrp $choix2 /home/partage/$choix2/

### Téléchargement des paquets
apt-get install samba smbclient -y

### Ajout dans le fichier de configuration de samba
echo "[partage]

comment = 'Partage Windows'
path = /usr/partage
browseable = yes
valid users = $user1, $user2
public = yes
writeable = yes
printable = no " >> /etc/samba/smb.conf

### Redémarrage du service
service samba restart
