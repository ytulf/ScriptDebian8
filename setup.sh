clear
### Setup.sh avec interface graphique
apt-get install dialog -y

DIALOG=${DIALOG=dialog}
fichtemp=`tempfile 2>/dev/null` || fichtemp=/tmp/test$$
trap "rm -f $fichtemp" 0 1 2 5 15

$DIALOG --backtitle "Que voulez-vous faire ?" \
	--title "Choix" --clear \
        --radiolist "Vous pouvez choisir parmi la liste ci-dessous :\n
	Pour sélectionner faites défiler puis 'espace' pour choisir " 20 61 5 \
	"1" "Voir la configuration de votre interface réseau " ON\
	  "2" "Passer directement au choix d'installation" off 2> $fichtemp
valret=$?
choix=`cat $fichtemp`
case $choix in 
        "1")
clear
ip -4 -o addr show
read -p "
Pour continuer taper sur n'importe quel touche " touche
DIALOG=${DIALOG=dialog}
fichtemp=`tempfile 2>/dev/null` || fichtemp=/tmp/test$$
trap "rm -f $fichtemp" 0 1 2 5 15

$DIALOG --backtitle "Que voulez-vous faire ?" \
	--title "Choix" --clear \
        --radiolist "Vous pouvez choisir parmi la liste ci-dessous : \n
		     Pour sélectionner faites défiler puis 'espace' pour choisir " 20 61 5 \
	"1" "Voir la configuration des routes" ON\
	  "2" "La configuration plus précise des interfaces" off\
	    "3" "Rien de tout ça" off 2> $fichtemp
valret=$?
choix=`cat $fichtemp`
case $choix in 
"1")
clear
route -n
read -p "
Appuyez sur n'importe quel touche pour continuer" tou
;;
"2")
clear
DIALOG=${DIALOG=dialog}
fichtemp=`tempfile 2>/dev/null` || fichtemp=/tmp/test$$
trap "rm -f $fichtemp" 0 1 2 5 15
$DIALOG --title "Choix" --clear \
        --inputbox "Saissisez l'interface que vous souhaitez afficher :" 16 51 2> $fichtemp
valret=$?
int = `cat $fichtemp`
case $valret in
  0)
    clear
    echo `cat $fichtemp`> interfaces.txt
    ifconfig `cat interfaces.txt`
    read -p "
    Appuyez sur n'importe quel touche pour continuer" go
    rm interfaces.txt
    ;;
  *)
  clear 
  echo "
  Poursuite du script"
    ;;
esac
;;
*)
;;
esac
;;
*)
;;
esac
clear

echo "
Poursuite du script vers l'installation"

DIALOG=${DIALOG=dialog}
fichtemp=`tempfile 2>/dev/null` || fichtemp=/tmp/test$$
trap "rm -f $fichtemp" 0 1 2 5 15

$DIALOG --backtitle "Que voulez-vous faire ?" \
	--title "Choix" --clear \
        --radiolist "Vous pouvez choisir parmi la liste ci-dessous :\n
	Pour sélectionner faites défiler puis 'espace' pour choisir" 20 61 5 \
	"1" "Installer" ON\
         "2" "Configurer" off\
          "3" "Faire des tests" off\
	   "4" "Rien de tout ça" off 2> $fichtemp
valret=$?
choix=`cat $fichtemp`
case $choix in
  "1")
DIALOG=${DIALOG=dialog}
fichtemp=`tempfile 2>/dev/null` || fichtemp=/tmp/test$$
trap "rm -f $fichtemp" 0 1 2 5 15
$DIALOG --backtitle "Que souhaitez-vous installer ?" \
--title "Installation" --clear \
--radiolist "Vous pouvez choisir parmi la liste ci-dessous :\n
Pour sélectionner faites défiler puis 'espace' pour choisir " 20 61 5 \
"1" "Apache" ON\
 "2" "DHCP" off\
  "3" "DNS"  off\
   "4" "Pydio" off\
    "5" "Proxy" off\
     "6" "Docker" off\
      "7" "Moodle" off\
       "8" "GLPI" off\
        "9" "Heartbeat" off\
	 "10" "Shinken" off\
	  "11" "eZ server Monitor" off\
	   "12" "Samba" off\
	    "13" "Rien de tout ça" off 2> $fichtemp
valret=$?
choix=`cat $fichtemp`
case $choix in 
"1")
clear
echo "
Installation d'Apache"
wget https://raw.githubusercontent.com/keijix/script/master/install_apache.sh
chmod 777 install_apache.sh
./install_apache.sh
;;
"2")
clear
echo "
Installation du service DHCP"
wget https://raw.githubusercontent.com/keijix/script/master/install_dhcp.sh
chmod 777 install_dhcp.sh
./install_dhcp.sh
;;
"3")
clear
echo "
Installation du service DNS"
wget https://raw.githubusercontent.com/keijix/script/master/install_dns.sh
chmod 777 install_dns.sh
./install_dns.sh
;;
"4")
clear
echo "
Installation d'une GED avec Pydio"
wget https://raw.githubusercontent.com/keijix/script/master/install_pydio.sh
chmod 777 install_pydio.sh
./install_pydio.sh
;;
"5")
clear
echo "
Installation du Proxy avec Squid et SquidGuard"
wget https://raw.githubusercontent.com/keijix/script/master/install_proxy.sh
chmod 777 install_proxy.sh
./install_proxy.sh
;;
"6")
clear
echo "
Installation de Docker"
wget https://raw.githubusercontent.com/keijix/script/master/install_docker.sh
chmod 777 install_docker.sh
./install_docker.sh
;;
"7")
clear
echo "
Installation de Moodle"
wget https://raw.githubusercontent.com/keijix/script/master/install_moodle.sh
chmod 777 install_moodle.sh
./install_moodle.sh
;;
"8")
clear
echo "
Installation de GLPI"
wget https://raw.githubusercontent.com/keijix/script/master/install_glpi.sh
chmod 777 install_glpi.sh
./install_glpi.sh
;;
"9")
clear
echo "
Installation de heartbeat"
wget https://raw.githubusercontent.com/keijix/script/master/install_heartbeat.sh
chmod 777 install_heartbeat.sh
./install_heartbeat.sh
;;
"10")
clear
echo "
Installation de Shinken"
wget https://raw.githubusercontent.com/keijix/script/master/install_shinken.sh
chmod 777 install_shinken.sh
./install_shinken.sh
;;
"11")
clear
echo "
Installation de eZ Server Monitor"
wget https://raw.githubusercontent.com/keijix/script/master/install_eZ.sh
chmod 777 install_eZ.sh
./install_eZ.sh
;;
"12")
clear
echo "
Installation du serveur de fichier Samba"
wget https://raw.githubusercontent.com/keijix/script/master/install_samba.sh
chmod 777 install_samba.sh
./install_samba.sh
;;
*)
clear
echo "
Redémarrer le script pour choisir une autre voie"
;;
esac
;;
  "2")
  DIALOG=${DIALOG=dialog}
fichtemp=`tempfile 2>/dev/null` || fichtemp=/tmp/test$$
trap "rm -f $fichtemp" 0 1 2 5 15
$DIALOG --backtitle "Que souhaitez-vous configurer ?" \
--title "Configuration" --clear \
--radiolist "Vous pouvez choisir parmi la liste ci-dessous :\n
Pour sélectionner faites défiler puis 'espace' pour choisir " 20 61 5 \
"1" "Configuration du routage" ON\
 "2" "Configuration du pare-feu avec Iptables" off\
  "3" "Configuration de l'interfaces en DHCP / static"  off\
   "4" "Configuration de la couleur du terminal" off\
    "5" "Configuration des sources lists" off\
     "6" "Ajout de l'agent fusion inventory pour linux" off\
      "7" "Configuration du ping en mode graphique" off\
       "8" "Configuration de la sauvegarde avec Rsync" off\
        "9" "Rien de tout ça" off 2> $fichtemp
valret=$?
choix=`cat $fichtemp`
case $choix in 
"1")
clear
echo "
Configuration du routage"
wget https://raw.githubusercontent.com/keijix/script/master/config_routage.sh
chmod 777 config_routage.sh
./config_routage.sh
;;
"2")
clear
echo "
Configuration du pare-feu avec Iptables"
wget https://raw.githubusercontent.com/keijix/script/master/config_firewall.sh
chmod 777 config_firewall.sh
./config_firewall.sh
;;
"3")
clear
echo "
Configuration de l'interfaces en DHCP ou en interne"
wget https://raw.githubusercontent.com/keijix/script/master/config_interfaces.sh
chmod 777 config_interfaces.sh
./config_interfaces.sh
;;
"4")
clear
echo "
Configuration de la couleur du terminal "
wget https://raw.githubusercontent.com/keijix/script/master/config_couleur.sh
chmod 777 config_couleur.sh
./config_couleur.sh
;;
"5")
clear
echo "
Configuration des sources lists "
wget https://raw.githubusercontent.com/keijix/script/master/config_sourceslist.sh
chmod 777 config_sourceslist.sh
./config_sourceslist.sh
;;
"6")
clear
echo "
Ajout de l'agent fusion inventory pour linux"
wget https://raw.githubusercontent.com/keijix/script/master/config_fusioninventoryagentlinux.sh
chmod 777 config_fusioninventoryagentlinux.sh
./config_fusioninventoryagentlinux.sh
;;
"7")
clear
echo "
Configuration du ping en interface graphique"
wget https://raw.githubusercontent.com/keijix/script/master/config_ping_graphique.sh
chmod 777 config_ping_graphique.sh
./config_ping_graphique.sh
;;
"8")
clear
echo "
Configuration de la sauvegarde avec rsync"
wget https://raw.githubusercontent.com/keijix/script/master/config_rsync.sh
chmod 777 config_rsync.sh
./config_rsync.sh
;;
*)
clear
echo "
Redémarrer le script pour choisir"
;;
esac
;;
  "3")
DIALOG=${DIALOG=dialog}
fichtemp=`tempfile 2>/dev/null` || fichtemp=/tmp/test$$
trap "rm -f $fichtemp" 0 1 2 5 15
$DIALOG --backtitle "Que souhaitez-vous tester ?" \
--title "Test" --clear \
--radiolist "Vous pouvez choisir parmi la liste ci-dessous :\n
Pour sélectionner faites défiler puis 'espace' pour choisir " 20 61 5 \
"1" "Tester la connectivité" ON\
 "2" "Tester les dangers de la config" off\
  "3" "Test de l'intégrité des utilisateurs" off\
   "4" "Test de la sécurité RootKit" off\
    "5" "Rien du tout" off 2> $fichtemp
valret=$?
choix=`cat $fichtemp`
case $choix in 
"1")
clear
echo "
Test de connectivité "
wget https://raw.githubusercontent.com/keijix/script/master/test_connectivite.sh
chmod 777 test_connectivite.sh
./test_connectivite.sh
;;
"2")
clear
echo "
Test des dangers de la configuration"
wget https://raw.githubusercontent.com/keijix/script/master/test_danger_config.sh
chmod 777 test_danger_config.sh
./test_danger_config.sh
;;
"3")
clear
echo "
Test de l'intégrité des utilisateurs"
wget https://raw.githubusercontent.com/keijix/script/master/test_integrite_user.sh
chmod 777 test_integrite_user.sh
./test_integrite_user.sh
;;
"4")
clear
echo "
Test de la sécurité des OS pour les rootkits"
wget https://raw.githubusercontent.com/keijix/script/master/test_securite_os.sh
chmod 777 test_securite_os.sh
./test_securite_os.sh
;;
*)
clear
echo "
Redémarrer le script pour choisir"
;;
esac
;;
   *)
   clear
   echo "
Redémarrer le script pour choisir"
   ;;
esac
