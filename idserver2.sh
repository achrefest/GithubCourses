#!/bin/bash 

fichierRes="Infos_Systeme.html"

echo "<html><head></head><body><div>" >> $fichierRes
function ecrireTitreSection {
	echo  "<b><center><font color="green">==============================$1==============================</font></center></b>" >> $fichierRes        
}
echo "</div></br></body></html>" >> $fichierRes


echo "<html><head></head><body><div><center>" >> $fichierRes
function ecrireDescription {
	echo  "<b><center><font color="red">------------------------------------- $1 -------------------------------------</font></center></b>" >> $fichierRes
	echo  "</br>" >> $fichierRes       
}
echo "</center></div></br></body></html>" >> $fichierRes

function ecrire {
	echo "-- $1 --" >> $fichierRes
	
}


function rec {
	echo  "?RECOMMENDATION? " >> $fichierRes
	
} 


# verifier que l on est root 
uid=`id | sed -n 's/.*uid=\([0-9][0-9]*\)(.*/\1/p'`
if test "$uid" -ne 0 
then
	echo "Ce script necessite les droits d'administateur"
	echo "Voulez-vous continuer ? (o/N)"
	read rep
	if test "$rep" != "o"S
	then
		exit 0
	fi
fi

# renice du processus pour ne pas affecter les autres services
echo "Souhaitez-vous diminuer la priorite du processus afin de ne pas impacter les autres services ? (o/N)"
read rep
if test "$rep" = "o"
then
	renice 19 -p $$
fi

# suppression éventuelle du parcours de l'arborescence (gain de temps)
parcours=1
echo "Le parcours de l'arborescence permet d'évaluer les propriétés et permissions sur les fichiers et repertoires. Cela peut prendre un long moment. Souhaitez-vous tout de même un 
parcours automatique par le script ? (O/n)"
read rep
if test "$rep" = "n"
then
  let parcours=0
fi

#collecte de quelques paamètres que l'auditeur doit 
#les demandé de l'administarateur du systèmes 
echo "                                                         "
echo "on est besoin de quelques autres informations pour l'audit .. veuillez entrer la liste de partitions sur lesquelles les programmes peuvent être exécutés depuis votre système 
séparé par un espace exemple: /dev/sda1 /dev/sda2"
read rep1
echo "                                               "
#echo "veuillez entrer le nom de l'utiliser du Comptes"
#read rep2

echo "on va séléctionner par défaut pour l'audit des paramètres réseau .. Voulez-vous changer l'interfaces  ? (o/N) "
read rep3
if test "$rep" = "o
"
then
  intr=$rep3
else 
  intr=$(ifconfig | sed -n '1p' | awk -F ":" '{printf $1'})
fi

echo "Création du Fichier Infos_Systeme.html"

# debut main

rm -fr $fichierRes


# recherche info

ecrireTitreSection "IDENTIFICATION DU SERVEUR"
   
ecrireDescription "Hostname"
hostnamectl | grep hostname >> $fichierRes 2>&1


ecrireDescription "Version noyau et version OS"
hostnamectl status | grep Kernel >> $fichierRes 2>&1

ecrireDescription "Liste des cartes reseau"
lspci | grep "Ethernet controller"  >> $fichierRes 2>&1

ecrireDescription "Configuration reseau"
#ifconfig >> $fichierRes 2>&1
./modifconf.sh >> $fichierRes 2>&1

ecrireDescription "Passerelle par defaut"
#route >> $fichierRes 2>&1
./modifgateway.sh >> $fichierRes 2>&1

ecrireDescription "Serveurs DNS"
#cat /etc/resolv.conf >> $fichierRes 2>&1
./modifdns.sh >> $fichierRes 2>&1

ecrireDescription "Information Memoire"
#cat /proc/meminfo >> $fichierRes 2>&1
./modifmeminfo.sh >> $fichierRes 2>&1

ecrireDescription "Information CPU"
#cat /proc/cpuinfo >> $fichierRes 2>&1
./modifcpu.sh >> $fichierRes 2>&1

ecrireDescription "Partitionnement"
df -k >> $fichierRes 2>&1

ecrireDescription "Les Services Actives"
systemctl list-units -l | grep service -s >> $fichierRes 2>&1
