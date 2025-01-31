#!/bin/bash

source /home/joinmarket/_functions.sh

# BASIC MENU INFO
HEIGHT=14
WIDTH=60
CHOICE_HEIGHT=5
TITLE="Advanced update options"
MENU="
Current JoininBox version: $currentJBcommit
Current JoinMarket version: $currentJMversion"
OPTIONS=()
BACKTITLE="JoininBox GUI"

# Basic Options
OPTIONS+=(\
  JBRESET "Reinstall the JoininBox scripts and menu" \
  JBCOMMIT "Update JoininBox to the latest commit" \
  JMPR "Test a JoinMarket pull request" \
  JMCOMMIT "Update JoinMarket to the latest commit" \
  TOR "Update Tor to the latest alpha"
)

CHOICE=$(dialog --clear \
                --backtitle "$BACKTITLE" \
                --title "$TITLE" \
                --ok-label "Select" \
                --cancel-label "Back" \
                --menu "$MENU" \
                $HEIGHT $WIDTH $CHOICE_HEIGHT \
                "${OPTIONS[@]}" \
                2>&1 >/dev/tty)

case $CHOICE in
  JBRESET)
      updateJoininBox reset
      errorOnInstall $?
      echo
      echo "Press ENTER to return to the menu"
      read key
      ;;
  JBCOMMIT)
      updateJoininBox commit
      errorOnInstall $?
      echo
      echo "Press ENTER to return to the menu"
      read key
      ;;
  JMPR)
      read -p "Enter the number of the pull request to be tested: " PRnumber
      read -p "Continue to install the PR:
https://github.com/JoinMarket-Org/joinmarket-clientserver/pull/$PRnumber
(Y/N)? " confirm && [[ $confirm == [yY]||$confirm == [yY][eE][sS] ]]||exit 1
      stopYG
      installJoinMarket testPR $PRnumber
      errorOnInstall $?
      echo
      echo "Press ENTER to return to the menu"
      read key
      ;;
  JMCOMMIT)
      installJoinMarket commit
      errorOnInstall $?
      echo
      echo "Press ENTER to return to the menu"
      read key
      ;;
  TOR)
      updateTor
      errorOnInstall $?
      echo
      echo "Press ENTER to return to the menu"
      read key
      ;;
esac
