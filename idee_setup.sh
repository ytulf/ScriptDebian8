apt-get install dialog -y
#!/bin/bash
DIALOG=${DIALOG=dialog}

$DIALOG --title "test d'affichage" --clear \
	--yesno "Bonjour, ceci est mon premier programme dialog pour tester si cela marche" 10 30

case $? in
	0)	echo "Oui choisi. ";;
	1)	echo "Non choisi. ";;
	255)	echo "Appuyé sur Echap. ";;
esac

#!/bin/sh
DIALOG=${DIALOG=dialog}
fichtemp=`tempfile 2>/dev/null` || fichtemp=/tmp/test$$
trap "rm -f $fichtemp" 0 1 2 5 15
$DIALOG --title "Ma fenêtre d'entrée" --clear \
        --inputbox "Bonjour, voici un exemple de fenêtre d'entrée\n
Essayez de saisir votre nom ci-dessous:" 16 51 2> $fichtemp

valret=$?

case $valret in
  0)
    echo "La chaîne d'entrée est `cat $fichtemp`";;
  1)
    echo "Appuyé sur Annuler.";;
  255)
    if test -s $fichtemp ; then
        cat $fichtemp
    else
        echo "Appuyé sur Echap."
    fi
    ;;
esac

### Choix multiple : 

#! /bin/sh
DIALOG=${DIALOG=dialog}
fichtemp=`tempfile 2>/dev/null` || fichtemp=/tmp/test$$
trap "rm -f $fichtemp" 0 1 2 5 15

$DIALOG --backtitle "Choisissez ce que vous voulez installer" \
	--title "Installation" --clear \
        --radiolist "Vous pouvez choisir votre installation  " 20 61 5 \
	"1" "Apache" off\
         "2" "DNS" off\
          "3" "DHCP" off\
           "4" "Pydio" ON\
            "5" "GLPI" off\
             "6" "Moodle" off\
	       "7" "Heartbeat" off\
		 "8" "Proxy" off 2> $fichtemp
valret=$?
choix=`cat $fichtemp`
case $valret in
  0)
   echo "Vous avez choisi d'installer : '$choix' ";;
  1)
   echo "Appuyé sur Annuler.";;
  255)
   echo "Appuyé sur Echap.";;
esac
