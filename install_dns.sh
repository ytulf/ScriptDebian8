clear
echo "
##################################################################
### Installation du service DNS avec le script install_dns.sh  ###
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

### Installation du service DNS
apt-get install -y bind9

# On réinitialise l'interface 
service networking restart

### Modification des zones et création des fichiers de recherche
clear
echo "
Quel est la zone que vous souhaitez mettre ? [exemple : btssio.com]"
read domaine
echo "
Est-ce bien ce domaine que vous souhaitez '$domaine' ? [Y/N]"
read validation
case $validation in 
"Y")
echo "zone '$domaine' {
type master;
file '/etc/bind/db.$domaine';
forwarders{};
};" > /etc/bind/named.conf
;;
"y")
echo "zone '$domaine' {
type master;
file '/etc/bind/db.$domaine';
forwarders{};
};" > /etc/bind/named.conf
;;	
*)
echo "Pas de problème, va falloir relancer le script"
;;
	esac	
clear
# On créer le fichier /etc/bind/db.$domaine
touch "/etc/bind/db.$domaine" && touch "/etc/bind/db.$domaine.inv"
echo "
Quel est le nom du serveur dns primaire que vous voulez rentrer ? [exemple : dns]"
read serveur
read -p "Quel est son adresse IP ? [exemple : 192.168.0.3] " ipd
echo "
Est-ce bien ce serveur que vous souhaitez rentrer '$serveur' ? [Y/N]"
read validation
case $validation in
	"Y")
echo '$TTL    604800' > /etc/bind/db.$domaine
echo "
@ IN SOA $serveur.$domaine. root.$domaine.  (
20041122   ; Serial  
604800     ; Refresh 
86400      ; Retry
2419200    ; Expire
604800 )   ; Minimum
@		IN		NS      $serveur.$domaine.     ;Nom du serveur
$serveur        A       	$ipd          ;@IP du DNS ">> /etc/bind/db.$domaine
;;
"y")
echo '$TTL    604800' > /etc/bind/db.$domaine
echo "
@ IN SOA $serveur.$domaine. root.$domaine.  (
20041122   ; Serial  
604800     ; Refresh 
86400      ; Retry
2419200    ; Expire
604800 )   ; Minimum
@		IN		NS      $serveur.$domaine.     ;Nom du serveur
$serveur        A      		$ipd           ;@IP du DNS ">> /etc/bind/db.$domaine
		;;
	*)
echo "Par défaut ca sera donc le nom du serveur 'dns', il faudra modifier le fichier dans /etc/bind/db.btssio.com"
echo '$TTL    604800' > /etc/bind/db.$domaine
echo "
@ IN SOA 	dns.$domaine. root.$domaine.  (
20041122   ; Serial  
604800     ; Refresh 
86400      ; Retry
2419200    ; Expire
604800 )   ; Minimum
@		IN	NS      dns.$domaine.     ;Nom du serveur
dns        	A       192.168.0.3           ;@IP du DNS ">> /etc/bind/db.$domaine
;;
	esac
	
### Résolution inverse
# On défini la nouvelle zone dans /etc/bind/db.$domaine
clear
echo "
Voulez-vous faire une résolution inverse ? [Y/N]"
read validation
case $validation in
	"Y")
echo "
Quel sera l'adresse IP inverse ? [Exemple : le réseau 192.168.0.x deviendra 0.168.192]"
read inverse
echo "
Est-ce que c'est bien cette adresse IP inverse que vous voulez '$inverse' [Y/N]"
read validation
case $validation in
"Y")
echo "
zone '$inverse.ind-addr-arpa' {
type master;
file '/etc/bind/db.$domaine.inv';
forwarders{};
}; " >> /etc/bind/db.$domaine
echo '$TTL    604800' > /etc/bind/db.$domaine.inv
echo "
@       IN      SOA     $serveur.$domaine.
root.$domaine.  (
20041122         
604800        
86400         
2419200        
604800 )      
@	IN	 NS      $serveur.$domaine.
$ipd	IN	PTR	$serveur.$domaine." >> /etc/bind/db.$domaine.inv
;;
"y")		
echo "
zone '$inverse.ind-addr-arpa' {
type master;
file '/etc/bind/db.$domaine.inv';
forwarders{};
}; " >> /etc/bind/db.$domaine
echo '$TTL    604800' > /etc/bind/db.$domaine.inv
echo "
@       IN      SOA     $serveur.$domaine.
root.$domaine.  (
20041122         
604800        
86400         
2419200        
604800 )      
@	IN	 NS      $serveur.$domaine.
$ipd	IN	PTR	$serveur.$domaine." >> /etc/bind/db.$domaine.inv
;;
*)
echo "Tant pis pour vous .. "
;;
esac
;;
	"y")
echo "
Quel sera l'adresse IP inverse ? [Exemple : le réseau 192.168.0.x deviendra 0.168.192]"
read inverse
echo "
Est-ce que c'est bien cette adresse IP inverse que vous voulez '$inverse' [Y/N]"
read validation
case $validation in
			"Y")
echo "
zone '$inverse.ind-addr-arpa' {
type master;
file '/etc/bind/db.$domaine.inv';
forwarders{};
}; " >> /etc/bind/db.$domaine
echo '$TTL    604800' > /etc/bind/db.$domaine.inv
echo "
@       IN      SOA     $serveur.$domaine.
root.$domaine.  (
20041122         
604800        
86400         
2419200        
604800 )      
@	IN	 NS      $serveur.$domaine.
$ipd	IN	PTR	$serveur.$domaine." >> /etc/bind/db.$domaine.inv
;;
			"y")		
echo "
zone '$inverse.ind-addr-arpa' {
type master;
file '/etc/bind/db.$domaine.inv';
forwarders{};
}; " >> /etc/bind/db.$domaine
echo '$TTL    604800' > /etc/bind/db.$domaine.inv
echo "
@       IN      SOA     $serveur.$domaine.
root.$domaine.  (
20041122         
604800        
86400         
2419200        
604800 )      
@	IN	 NS      $serveur.$domaine.
1	IN	PTR	$serveur.$domaine." >> /etc/bind/db.$domaine.inv
;;
			*)
echo "Tant pis pour vous .. "
;;
esac
;;
	*)
echo "Tant pis pour vous .. "
;;
	esac
clear
### Lancer le service DNS
service bind9 restart
### Changer le nom de la machine au cas où que cela ne soit pas fait avant 
clear
echo "
Voulez-vous changer le nom de l'hôte ? [Y/N] "
read validation
case $validation in 
	"y")
echo "$serveur.$domaine." > /etc/hostname
		;;
	"Y")
echo "$serveur.$domaine." > /etc/hostname
		;;
	*)
echo "Pas de problème veuillez le faire manuellement dans le fichier /etc/hostname"
		;;
	esac
	
# Le lancer au démarrage
update-rc.d bind9 defaults
# Rédemarrage de la machine pour prendre en compte changement nom
echo "
Voulez-vous redémarrer l'hôte ? [Y/N]"
read validation
case $validation in 
	"Y")
		reboot
		;;
	"y")
		reboot
		;;
	*)
		echo "Pas de problème "
		;;
esac
