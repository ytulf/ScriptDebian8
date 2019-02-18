<h1> Script </h1>
<h2> <a href="#Installation">Installation</a>, <a href="#Configuration"> Configuration</a>, <a href="#Test"> Test</a></h2>
Regroupement de tous les scripts avec l'installeur : setup.sh :<br>

• Pour télécharger l'installateur : <br>
wget https://raw.githubusercontent.com/keijix/script/master/setup.sh ou wget --no-check-certificate https://raw.githubusercontent.com/keijix/script/master/setup.sh <br>

• Mettre tout les droits : <br>
chmod +x setup.sh <br>

• Lancer le script : <br>
./setup.sh <br>

<h2> <h2 id="Installation">Installation : </h2><a href="#Apache">Apache</a>, <a href="#DHCP">DHCP</a>, <a href="#DNS">DNS</a>, <a href="#Proxy">Proxy</a>, <a href="#Pydio">Pydio</a>, <a href="#Moodle"> Moodle</a>, <a href="#GLPI"> GLPI</a>, <a href="#Heartbeat"> Heartbeat</a>, <a href="#Shinken"> Shinken </a>, <a href="#Samba"> Samba </a>, <a href="#eZ"> eZ server Monitor </a></h2>

<h3 id="Apache">Apache : serveur web </h3>
<h4>Fichier : install_apache.sh</h4>

• Pour modifier le fichier index.html de http://@IP/ : <br>
nano /var/www/html/index.html <br>

• Pour hébergé plusieurs site sur le même serveur : <br>
cp /etc/apache2/sites-available/000-default.conf /etc/apache2/sites-available/nouveau-site-web.conf <br>

Ensuite modifier le fichier virtual host dedans et créer le dossier répertoire au bon endroit <br>

• Pour activer le nouveau site : <br>
a2ensite nouveau-site-web <br>

• Pour désactiver le nouveau site (s'il a été déjà activé) : <br>
a2dissite nouveau-site-web <br>

• Pour lancer / relancer / recharger / stop le service : <br>
service apache2 start/reload/restart/stop <br>
ou <br>
/etc/init.d/apache2 start/reload/restart/stop <br>

<h3 id="DHCP"> DHCP : service DHCP </h3>
<h4> Fichier : install_dhcp.sh</h4>

• Pour modifier l'interface : <br>
nano /etc/network/interfaces <br>

• Pour modifier l'interface d'écoute : <br>
nano /etc/default/isc-dhcp-server<br>

• Pour modifier les fichiers de configuration de dhcp : <br>
nano /etc/dhcp/dhcpd.conf <br>

<h3 id="DNS"> DNS : service DNS </h3>
<h4> Fichier : install_dns.sh </h4>
• Pour modifier le fichier de configuration principal : <br>
nano /etc/bind/named.conf <br>

• Pour rajouter des serveurs ou modifier le nom des serveurs ou l'adress IP de votre zone de recherche : <br>
nano /etc/bind/db.$domaine --> Ou $domaine correspond a votre domaine de recherche par exemple btssio.com <br>

• Pour modifier la résolution inverse: <br>
nano /etc/bind/db.$domaine.inv <br>

<h3 id="Proxy"> Proxy : service squid3 et squidGuard</h3>
<h4> Fichier : install_proxy.sh</h4>
• Pour vérifier : <br>
squid3 -z <br>

• Pour modifier la configuration de squidGuard : <br>
Il faut modifier ce fichier : /etc/squidguard/squidGuard.conf <br>

• Pour modifier la configuration de squid3 : <br>
Il faut modifier ce fichier : /etc/squid3/squid.conf <br>

<h3 id="Pydio"> Pydio : serveur GED (Gestion Electronique des Documents)</h3>
<h4> Fichier : install_pydio.sh </h4>

• Pour améliorer les performances de Pydio : <br>
la valeur output_buffering = 4096 par output_buffering = off dans /etc/php5/apache2/php.ini. <br>

• Dans le fichier /etc/pydio/bootstrap_conf.php : <br>
Modifier le charset : //define("AJXP_LOCALE", "en_EN.UTF-8"); en define("AJXP_LOCALE", "fr_FR.UTF-8"); <br>
Supprimer les // sur la ligne : define("AJXP_FORCE_SSL_REDIRECT", true); pour forcer la redirection HTTP vers HTTPS. <br>

• Se connecter sur la base de donnée : <br>
mysql -u root -p : <br>

• Créer la base de données<br>
CREATE DATABASE pydio; <br>

• Créer l'utilisateur <br>
CREATE USER "pydio"@"localhost" IDENTIFIED BY "password"; <br>

• Attribuer les droits <br>
GRANT ALL PRIVILEGES ON pydio.* TO "pydio"@"localhost" <br>

<h3 id="Moodle"> Moodle : serveur de e-learning</h3>
<h4> Fichier : install_moodle.sh </h4>

• Créer la base de données : <br>
mysql> CREATE DATABASE moodle; <br>

• S'assurer que la base de donnée est en UTF-8 (requis par Moodle) : <br>
mysql> ALTER DATABASE moodle charset=utf8;<br>

• Donner tous les privilèges à Moodle : <br>
mysql> GRANT SELECT,INSERT,UPDATE,DELETE,CREATE,CREATE TEMPORARY TABLES, DROP,INDEX,ALTER ON moodle.* TO moodleuser@localhost IDENTIFIED BY 'yourpassword';<br>

• Quitter mysql : <br>
mysql> exit;<br>

<h3 id="Heartbeat"> Heartbeat </h3>
<h4> Fichier : install_heartbeat.sh </h4>

• Modification des fichiers : <br>
Tous les fichiers dans le répertoire /etc/ha.d/<br>
• Redémarrer le service <br>
/etc/init.d/heartbeat restart <br>

<h3 id="GLPI"> GLPI </h3>
<h4> Fichier : install_glpi.sh </h4>

• Modification des fichiers : <br>
Tous les fichiers dans le répertoire /usr/share/glpi <br>
• Redémarrer le service <br>
/etc/init.d/apache2 restart ou /etc/init.d/mysql restart pour la base de donnée<br>

<h3 id="Shinken"> Serveur de supervision : Shinken </h3>
<h4> Fichier : install_shinken.sh </h4>
• Fichiers de configuration du paquet : <br>
/etc/shinken <br>
Le dossier « /etc/shinken » est le dossier créé par défaut lors de l’installation de Shinken.<br>
A l’intérieur se trouvent les fichiers de configuration du serveur en lui-même, mais aussi les commandes disponibles et les fichiers concernant les composants de Shinken (Arbiter, scheduler, poller, reactionner et broker) – Il s’agit d’une nouveauté de la version 2.0 de Shinken.<br>

• Fichiers de configuration des hosts, groups et autres : <br>
/etc/shinken/hosts <br>
/etc/shinken/services <br>
Il est possible de changer ce dossier : les fichiers de configuration des hosts, groupes, services et autres peuvent avoir leur propre dossier respectif. <br>
Il faudra cependant faire les bonnes redirections dans le fichier de configuration de Shinken (/usr/local /shinken/etc/nagios.cfg). <br>

• Fichiers de logs : <br>
/var/log/shinken/ <br>
/var/log/shinken/nagios.log <br>
/var/log/shinken/arbiterd.log <br>
Il existe différent fichiers de logs où sont répertoriés les divers évènements des composants de Shinken, mais aussi les erreurs / bugs possibles de la supervision. <br>

Nagios.log est le fichier de logs principal. Le plus important du fonctionnement de Shinken est écrit dedans. <br>
Arbiterd.log est le fichier de logs concernant le démon « arbiterd » et seulement le démon et est répertorié les événements produits ou qui ont affectés se dernier. <br>

• Fichiers binaires et variables de Shinken :<br>
/var/lib/shinken <br>
/usr/bin <br>
Ces deux dossiers contiennent tous les fichiers nécessaires au bon fonctionnement de Shinken. Ces fichiers sont créés et exploités par Shinken. <br>

<h3 id="Samba"> Serveur de fichier : samba </h3>
<h4> Fichier : install_samba.sh </h4>
• Rajouter utilisateur : <br> 
adduser $users ou useradd $users <br>

• Ajouter utilisateur au groupe <br>
gpasswd –a $user $groupe <br>

• Rajouter utilisateur au partage : <br>
nano /etc/samba/smb.conf <br>

<h3 id="eZ"> Service de monitoring léger : eZ  </h3>
<h4> Fichier : install_eZ.sh </h4>
• En mode shell : <br>
./eZServerMonitor.sh -a <br>
pour relancer le script <br>

• En mode graphique : <br>
http://adresse_IP/ez<br>

<h2> <h2 id="Configuration">Configuration : </h2><a href="#Routage">Routage</a>, <a href="#Firewall">Firewall</a>, <a href="#Interfaces">Interfaces</a>, <a href="#Couleur">Couleur du terminal</a>, <a href="#SourcesList">Configuration des Sources List</a>, <a href="#Agentfusioninventory">Agent linux fusion inventory pour GLPI</a>, <a href="#Gping">Ping graphique</a></h2>

<h3 id="Routage"> Routage </h3>
<h4> Fichier : config_routage.sh</h4>
• Pour autoriser le routage :<br>
echo 1 >  /proc/sys/net/ipv4/ip_forward -- Remettre à 0 pour enlever le routage <br>

• Pour prendre en compte les réglages : <br>
sysctl -p /etc/sysctl.conf <br>

<h3 id="Firewall"> Firewall </h3>
<h4>Fichier : config_firewall.sh</h4>
• Pour modifier le fichier : <br>
nano /etc/init.d/config_interfaces<br>

<h3 id="Interfaces"> Interfaces </h3>
<h4>Fichier : config_interfaces.sh</h4>
• Pour modifier les interfaces : <br>
nano /etc/network/interfaces<br>

• Pour redémarrer le service  : <br>
/etc/init.d/networking restart | start | stop <br>

<h3 id="Couleur"> Couleur du terminal </h3>
<h4>Fichier : config_couleur.sh</h4>

• Pour modifier les couleurs du terminal :<br>
nano /etc/bash.bashrc et choisir en fonction des couleurs définies dans le fichier<br>

<h3 id="SourcesList"> Configuration des sources listes </h3>
<h4>Fichier : config_sourceslist.sh</h4>

• Pour modifier les sources lists :<br>
nano /etc/apt/sources.list <br>

<h3 id="Agentfusioninventory"> Agent linux fusion inventory pour GLPI</h3>
<h4>Fichier : config_fusioninventoryagentlinux.sh</h4>

• Pour modifier les fichiers pris en compte durant le script :<br>
nano /etc/default/fusioninventory-agent & nano /etc/fusioninventory/agent.cfg <br>

<h3 id="Gping"> Le ping graphique</h3>
<h4>Fichier : config_ping_graphique.sh</h4>

• Vous connaissez le dictons, inutile donc indispensable. Gping, un petit utilitaire Python qui vous permettra de représenter votre Ping sous forme de Graph en live <br>

• Pour utilsier l'utilitaire : <br>
gping google.fr <br>

<h2><h2 id="Test">Test : </h2><a href="#Connectivité">Test de connectivité</a>, <a href="#DangerConfig">Test des dangers de la configuration</a>, <a href="#IntegriteUsers">Test de l'intégrité des utilisateurs</a>, <a href="#SecuriteOS">Sécurisation de l'OS</a>,</h2>

<h3 id="Connectivité"> Test de connectivité </h3>
<h4>Fichier : test_connectivite.sh</h4>

• Les fichiers qui seront utilisé par le script : <br>
nano /etc/network/interfaces <br>
nano /etc/resolv.conf <br>
nano /etc/apt/sources.list <br>

<h3 id="DangerConfig"> Test des dangers de la configuration </h3>
<h4>Fichier : test_danger_config.sh</h4>

• Effectue plusieurs dizaines de vérifications dans différents domaines du système pour finir par un rapport final ainsi que des suggestions sur la sécurisation du système. <br>

• Commande pour lancer la vérification : <br>
lynis -c

<h3 id="IntegriteUsers"> Test de l'intégrité des utilisateurs </h3>
<h4>Fichier : test_integrite_user.sh</h4>

• Utilisation de l'utilitaire pour faire le script : <br>
La commande pwck (password check) est utile car elle permet de vérifier l'intégrité, c'est à dire la structure, la validité, des fichiers /etc/passwd, /etc/group et /etc/shadow.<br>

Au gré des utilisations, des créations et des suppressions de compte, ces fichiers peuvent devenir incohérents et contenir des données obsolètes ou mal formatées. <br>

Ces données peuvent par exemple être :<br>
un nombre incorrect de champs dans les fichiers <br>
un nom d’utilisateur unique <br>
un login shell valide <br>
un home déclaré et non existant <br>


<h3 id="SecuriteOS"> Sécurisation de l'OS avec Rkhunter </h3>
<h4>Fichier : config_securite_os.sh</h4>

• Pour voir les base de données des signatures de malware, des ports suspects, des versions de programmes obsolètes et vulnérables, etc :<br>
ls -al /var/lib/rkhunter/db <br>

• Pour update les différentes bases d'informations :<br>
rkhunter --update <br>

• Pour voir la validité de la configuration :<br>
rkhunter -C <br>

• Pour n'afficher que les alertes et les points importants avec l'option "--rwo" (pour "report warnings only") : <br>
rkhunter -c --rwo <br>
