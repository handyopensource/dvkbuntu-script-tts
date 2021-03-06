#!/bin/bash

# Ajout du dépôt de nocomprendo un assistant vocal  
sh -c "echo 'deb http://download.opensuse.org/repositories/home:/be-root:/nocomprendo/xUbuntu_20.04/ /' | sudo tee /etc/apt/sources.list.d/home:be-root:nocomprendo.list"    
wget -nv https://download.opensuse.org/repositories/home:be-root:nocomprendo/xUbuntu_20.04/Release.key -O "/etc/apt/trusted.gpg.d/home:be-root:nocomprendo.asc"    

# Mise à jour du système 
apt update    
apt upgrade   

# Installation des dépendances :    
apt install nocomprendo espeak wmctrl dvkbuntu xdotool tesseract-ocr-fra scrot imagemagick libnotify-bin sox lame libsox-fmt-mp3 xbacklight lemonbar git python3-pip mbrola-fr1 espeak-ng
pip3 install google_speech

# Ajout des Wrappers (alternative en français de tts).
cat << FIN > "/usr/local/bin/google_speech-multilanguage"
#!/bin/bash
if [ -f "$3" ];then
 google_speech -l "$2" "$1" -o "$3"
else
 if [ ! -f "$2" ]; then
  google_speech -l "$2" "$1"
 else
  google_speech -l "fr-fr" "$1"
 fi
fi
FIN
chmod +x /usr/local/bin/google_speech-multilanguage

cat << FIN > "/usr/bin/espeak-ng-multilanguage"
#!/bin/bash
if [ -f "$3" ];then
  espeak-ng -v "$2" "$1" -w "$3"
else
 if [ ! -f "$2" ]; then
  espeak-ng -v "$2" "$1"
 else
  espeak-ng -v "fr-fr" "$1"
 fi
fi 
FIN
chmod +x /usr/bin/espeak-ng-multilanguage

# Ajout des Alternatives (choix possible) de toutes les voix différentes de tts
sudo update-alternatives --install /etc/alternatives/tts.gz tts "/usr/local/bin/google_speech-multilanguage" 20
sudo update-alternatives --install /etc/alternatives/tts.gz tts "/usr/bin/espeak-ng-multilanguage" 15

# Installation des scripts dans le système
cp ScreenReader /usr/bin/ScreenReader
cp Power /usr/bin/Power
cp ListeFenetresOuvertes /usr/bin/ListeFenetresOuvertes
cp LectureNotifs /usr/bin/LectureNotifs
cp LectureHeure /usr/bin/LectureHeure
cp KillFenetre /usr/bin/KillFenetre
cp FenetreCourante /usr/bin/FenetreCourante
cp FacteurEchelle /usr/bin/FacteurEchelle
cp ChangerFenetre /usr/bin/ChangerFenetre
cp KillLastScript /usr/bin/KillLastScript

# Paramétrages de NoComprendo
repertoire="/home/"$SUDO_USER"/.config/nocomprendo/"
[[ -d "$repertoire" ]] && rm -rf "$repertoire"
repertoire="/home/"$SUDO_USER"/.config/BeRoot/"
[[ -d "$repertoire" ]] && rm -rf "$repertoire"
tar xvzf fr_FR.tar.gz -C /usr/share/nocomprendo/defsets/

mkdir -p "/home/$SUDO_USER/.config/BeRoot/"

cat << FIN > "/home/$SUDO_USER/.config/BeRoot/NoComprendo.conf"
[General]
ask2Quit=false
autoStart=true
comPos=@Point(199 269)
comSize=@Size(613 369)
confPos=@Point(99 69)
confSize=@Size(511 519)
defLang=fr_FR
glideRate=20
glideStep=2
hideInTaskBar=false
mainPos=@Point(199 169)
mainSize=@Size(600 450)
mouseStep=10
osdAll=true
osdDuration=3000
osdOn=true
osdPosition=@Point(100 250)
osdSize=@Size(450 40)
rFontSize=18
rInvertColor=true
removeBadUtterance=false
selPos=@Point(300 300)
selSize=@Size(500 426)
setPos=@Point(350 150)
setSize=@Size(951 720)
setSplit=@ByteArray(\0\0\0\xff\0\0\0\x1\0\0\0\x2\0\0\x1\0\0\0\x1\0\x1\xff\xff\xff\xff\x1\0\0\0\x1\0)
speak=true
splitter=@ByteArray(\0\0\0\xff\0\0\0\x1\0\0\0\x2\0\0\x1\0\0\0\x1\x1a\x1\xff\xff\xff\xff\x1\0\0\0\x1\0)
useSysTray=true
vocPos=@Point(250 250)
vocSize=@Size(920 640)
wordsToLM=true

[fr]
base=base.cmd
dvkbuntu=dvkbuntu.cmd
kde=kde.cmd
konsole=konsole.cmd
metas=metas.cmd
navigateur=navigateur.cmd
souris=souris.cmd

[fr_FR]
age=20
gender=1
voiceVariant=2
FIN

chown -R $SUDO_USER "/home/$SUDO_USER/.config/BeRoot/"

mkdir -p "/etc/skel/.config/BeRoot/"

cat << FIN > "/etc/skel/.config/BeRoot/NoComprendo.conf"
[General]
ask2Quit=false
autoStart=true
comPos=@Point(199 269)
comSize=@Size(613 369)
confPos=@Point(99 69)
confSize=@Size(511 519)
defLang=fr_FR
glideRate=20
glideStep=2
hideInTaskBar=false
mainPos=@Point(199 169)
mainSize=@Size(600 450)
mouseStep=10
osdAll=true
osdDuration=3000
osdOn=true
osdPosition=@Point(100 250)
osdSize=@Size(450 40)
rFontSize=18
rInvertColor=true
removeBadUtterance=false
selPos=@Point(300 300)
selSize=@Size(500 426)
setPos=@Point(350 150)
setSize=@Size(951 720)
setSplit=@ByteArray(\0\0\0\xff\0\0\0\x1\0\0\0\x2\0\0\x1\0\0\0\x1\0\x1\xff\xff\xff\xff\x1\0\0\0\x1\0)
speak=true
splitter=@ByteArray(\0\0\0\xff\0\0\0\x1\0\0\0\x2\0\0\x1\0\0\0\x1\x1a\x1\xff\xff\xff\xff\x1\0\0\0\x1\0)
useSysTray=true
vocPos=@Point(250 250)
vocSize=@Size(920 640)
wordsToLM=true

[fr]
base=base.cmd
dvkbuntu=dvkbuntu.cmd
kde=kde.cmd
konsole=konsole.cmd
metas=metas.cmd
navigateur=navigateur.cmd
souris=souris.cmd

[fr_FR]
age=20
gender=1
voiceVariant=2
FIN
