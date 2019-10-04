#!/bin/bash

#Développeurs : Paullux, U_Bren

# create work folder
workDir="/tmp/OCR"
[ ! -d "$workDir" ] && mkdir "$workDir"

# Initialisation des variables
unset MOUSE
unset CURRENT_WINDOW
unset SELECTION
MOUSE=false
CURRENT_WINDOW=false
SELECTION=false

# Initialisation curseur
eval $(xdotool getmouselocation --shell)
Xo=$X
Yo=$Y

#Options choice
case $1 in
    souris)
        MOUSE=true;;

    fenCourante)
        CURRENT_WINDOW=true;;

    selection)
        SELECTION=true;;

    *) 
        #Quit if non choice
        a="Vous devez préciser une option"
        google_speech -l fr-fr  "$a" 
        exit 0;;
esac

#Make screenshots
if $MOUSE; then
    #Rectangle notation :
    # (0,1); (1,1)
    # (0,0); (1,0)

    #Offset the screenshot rectangle to the upper-left corner (0,1) by this amount in the X/Y direction
    #Might be a problem for i18n & RTL languages but... Oh, well
    NegX01Offset=300
    NegY01Offset=75
    #Size of the rectangle
    posX10=600
    posY10=150
    #Set X,Y to the Cursor position.
    eval $(xdotool getmouselocation --shell)
    posX01=$(($X-$NegX01Offset))
    posY01=$(($Y-$NegY01Offset))
    #Drawing Rectangle
    lemonbar -n my_lemonbar -d -g "$posX10"x"$posY10"+"$posX01"+"$posY01" -B '#88000000' &
    #ScreenShot
    scrot -a "$posX01","$posY01","$posX10","$posY10" -o "$workDir"/OCR.png
fi

if $CURRENT_WINDOW; then
    # To prepare the commande
    a="La fenêtre courante est"
    b=$(cat /proc/"$(xdotool getwindowpid $(xdotool getactivewindow))"/comm)
    c="La fenêtre courante contient"
    d="${a} ${b} ${c}"
    google_speech -l fr-fr "$d"
    #ScreenShot
    scrot -u -o "$workDir"/OCR.png
fi

if $SELECTION; then
    #To prepare the commande
    google_speech -l fr-fr  "sélectionnez la zone à lire"
    #ScreenShot
    import "$workDir"/OCR.png
fi


#Déchiffrement de la capture par OCR
tesseract "$workDir"/OCR.png "$workDir"/text -l fra
#Lecture du texte déchiffrer par OCR grâce au TTS
google_speech -l fr-fr "$(cat "$workDir"/text.txt)"

#kill rectangle
sleep 3
kill $(pgrep -f "lemonbar -n my_lemonbar")
kill $(pgrep -f "lemonbar -n my_lemonbar")

#delete work folder
rm -rf "$workDir"
