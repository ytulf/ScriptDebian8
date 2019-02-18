echo "
###############################################################
### Installation de la GED avec le script install_pydio.sh  ###
###                    par Thomas SAVIO                     ###
###############################################################
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

# Mettre à jour les dépots pour pydio & Importer la clé publique du dépôt
clear
echo "deb http://dl.ajaxplorer.info/repos/apt stable main
deb-src http://dl.ajaxplorer.info/repos/apt stable main " >> /etc/apt/sources.list
wget -O - http://dl.ajaxplorer.info/repos/charles@ajaxplorer.info.gpg.key | apt-key add -
apt-get update -y && apt-get upgrade -y

# Téléchargement de pydio
apt-get install pydio -y && apt-get install mysql-server php5-mysql -y

# Copie du fichier de configuration pré-fait fournit par Pydio dans la configuration d’Apache2.
cp /usr/share/doc/pydio/apache2.sample.conf /etc/apache2/sites-enabled/pydio.conf
/etc/init.d/apache2 restart
clear
echo "
Création de la base de données et d'un utilisateur pour Pydio et rédemarrage d'apache "

read -p "Veuillez entrer votre mot de passe root de MySQL : " rootpass
read -p "Nom de votre base de donnée : " dbname
read -p "Nom de l'utilisateur de la base de donnée que vous souhaitez créer : " dbuser
read -p "Enter a password for user '$dbuser' : " userpass
echo "CREATE DATABASE $dbname;" | mysql -u root -p$rootpass
echo "CREATE USER '$dbuser'@'localhost' IDENTIFIED BY '$userpass';" | mysql -u root -p$rootpass
echo "ALTER DATABASE $dbname charset=utf8;" | mysql -u root -p$rootpass
echo "GRANT ALL PRIVILEGES ON $dbname.* TO '$dbuser'@'localhost';" | mysql -u root -p$rootpass
echo "FLUSH PRIVILEGES;" | mysql -u root -p$rootpass
echo "
Votre nouvelle base de donnée MySQL a été créer"

echo "
<VirtualHost *:80>
	# The ServerName directive sets the request scheme, hostname and port that
	# the server uses to identify itself. This is used when creating
	# redirection URLs. In the context of virtual hosts, the ServerName
	# specifies what hostname must appear in the request's Host: header to
	# match this virtual host. For the default virtual host (this file) this
	# value is not decisive as it is used as a last resort host regardless.
	# However, you must set it for any further virtual host explicitly.
	#ServerName www.example.com

	ServerAdmin webmaster@localhost
	DocumentRoot /usr/share/pydio

	# Available loglevels: trace8, ..., trace1, debug, info, notice, warn,
	# error, crit, alert, emerg.
	# It is also possible to configure the loglevel for particular
	# modules, e.g.
	#LogLevel info ssl:warn

	ErrorLog ${APACHE_LOG_DIR}/error.log
	CustomLog ${APACHE_LOG_DIR}/access.log combined

	# For most configuration files from conf-available/, which are
	# enabled or disabled at a global level, it is possible to
	# include a line for only one particular virtual host. For example the
	# following line enables the CGI configuration for this host only
	# after it has been globally disabled with "a2disconf".
	#Include conf-available/serve-cgi-bin.conf
</VirtualHost>

# vim: syntax=apache ts=4 sw=4 sts=4 sr noet
" > /etc/apache2/sites-enabled/000-default.conf 
# Redémarrage de apache pour prendre en compte 
/etc/init.d/apache2 restart

ifconfig eth0 | grep 'inet adr:' | cut -d: -f2 | awk '{ print $1}' > ip.txt
echo "
Vous pouvez vous connecter sur http://`cat ip.txt`/ ou sur http://`cat ip.txt`/pydio"
