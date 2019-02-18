echo "
####################################################################
### Test de la connectivité avec le script test_connectivite.sh  ###
###                        par Thomas SAVIO                      ###
####################################################################
"
echo "
Voulez-vous voir quel interface sont branchés ? [Y/N]"
read validation
case $validation in 
"Y")
mii-tool
;;
"y")
mii-tool
;;
*)
echo "
Ok continuation du script"
;;
esac

echo "
Ping vers 8.8.8.8 "

ping -c5 8.8.8.8

echo "
Ping vers www.google.fr ..."

echo "
"

ping -c5 www.google.fr

echo "
Fin du test"

echo "
Suite à ces pings quel erreur avait vous eu ? 
DNS ? [Pas de ping vers www.google.fr qui n'a fonctionné : 1]
Network is unreachable ? [2]
Tout marche ? [3] "
read test
case $test in 
"1")
echo "nameserver 8.8.8.8 8.8.4.4" > /etc/resolv.conf
ping -c5 www.google.fr
echo "
Est-ce que maintenant cela marche ? [Y/N]"
read validation
case $validation in
"N")
echo "
Quel est la passerelle de votre réseau ?[Exemple : 192.168.0.1]"
read passerelle
route add default gw $passerelle
ping -c5 www.google.fr
echo "
Et maintenant, le problème est-il réglé ? [Y/N]"
read validation
case $validation in
"y")
echo "
Parfait, fin du script"
;;
"Y")
echo "
Parfait, fin du script"
;;
*)
dig google.com
echo " 
Vérifiez le problème et chercher la solution sur internet "
;;
esac
;;
"n")
echo "
Quel est la passerelle de votre réseau ?[Exemple : 192.168.0.1]"
read passerelle
route add default gw $passerelle
ping -c5 www.google.fr
echo "
Et maintenant, le problème est-il réglé ? [Y/N]"
read validation
case $validation in
"y")
echo "
Parfait, fin du script"
;;
"Y")
echo "
Parfait, fin du script"
;;
*)
dig google.com
echo " 
Vérifiez le problème et chercher la solution sur internet "
;;
esac
;;
*)
echo "Fin du script"
;;
esac
;;
"2")
echo "
Quel est la passerelle de votre réseau ?[Exemple : 192.168.0.1]"
read passerelle
route add default gw $passerelle
ping -c5 8.8.8.8
echo "
Les pings ont-ils aboutis ? [Y/N]"
read validation 
case $validation in
"N")
echo "Regarder la configuration de votre machine virtuelle, regarder aussi si la passerelle est active"
;;
"n")
echo "Regarder la configuration de votre machine virtuelle, regarder aussi si la passerelle est active"
;;
*)
echo "Parfait, fin du script"
;;
esac
;;
*)
;;
esac

echo "Voulez-vous voir en temps réel le trafic vers vos interfaces réseau ? [Y/N]"
read validation
case $validation in
"y")
apt-get install iftop -y
clear
iftop
;;
"Y")
apt-get install iftop -y
clear
iftop
;;
*)
echo "Pas de problème"
;;
esac


echo "Voulez-vous voir les ports ouverts sur votre postes ? [Y/N]"
read validation
case $validation in
"y")
netstat -lp --inet
;;
"Y")
netstat -lp --inet
;;
*)
;;
esac

echo "Voulez-vous déterminer la route prise par un paquet pour atteindre la cible sur internet ? [Y/N]"
read validation
case $validation in 
"Y")
echo "
Vers quel distination voulez-vous aller [exemple : google.com]? "
read choix
traceroute $choix
;;
"y")
echo "
Vers quel distination voulez-vous aller [exemple : google.com]? "
read choix
traceroute $choix
;;
*)
;;
esac
