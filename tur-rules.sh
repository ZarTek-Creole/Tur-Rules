#!/bin/bash
VER=1.0
#---------------------------------------------------#
#                                                   #
# Tur-Rules. A script to display rules in irc chan. #
# Made by request from ApocT. Thanks for the idea =)#
#                                                   #  
#-[ Setup ]-----------------------------------------#
#                                                   #
# Copy tur-rules.sh to /glftpd/bin.                 #
# chmod 755 /glftpd/bin/tur-rules.sh                #
# Copy tur-rules.tcl to your bots config folder and #
# load it in the bots config file. Rehash bot.      #
#                                                   #
#-[ Settings ]--------------------------------------#
#                                                   #
# rules    = Path to your rules file.               #
#                                                   #
# sections = The sections you can display, followed #
#            with what that section starts with..   #
#            For example. If you have a rules file: #
#            General rules:                         #
#            0.1 : No dual downloading..            #
#            DIVX rules:                            #
#            1.0 : No uploading bla bla.            #
#            1.1 : Limited not allowed..            #
#            SVCD rules:                            #
#            2.0 : Limited allowed.                 #
#            2.1 : Only 5.0+ on iMDB.               #
#            etc..                                  #
#                                                   #
#            One setup for the above would be:      #
#            sections="                             #
#            DIVX:1.                                #
#            SVCD:2.                                #
#            GENERAL:0.                             #
#            "                                      #
#                                                   #
#            You may also select more then one      #
#            thing to trigger on. Perhaps you want  #
#            to show the "0.1 : No dual downloading"#
#            when someone checks SVCD rules?. Do:   #
#            SVCD:2.|0.1                            #
#            You can add as many |'s as you like    #
#            behind each section.                   #
#            The order in which you add these does  #
#            not matter. They will be shown in the  #
#            order in which they appear in the file.#
#                                                   #
#            Note that only the first "word" in the #
#            rules list can be added here, so if    #
#            your rules look like:                  #
#            # 1.0 blabla, you cant use this, cause #
#            "#" is the first word.                 #
#                                                   #
#            . really means "anything", so if you   #
#            want a ALL rules display, just do:     #
#            ALL:.                                  #
#                                                   #
# compress = This should be one character. If your  #
#            rules look like:                       #
#            1.0 : No stv...............[ 3x nuke ] #
#            you can set this to "." and it will    #
#            display:                               #
#            1.0 : No stv.[ 3x nuke ]               #
#            Yes, you can use a space here too.     #
#            Make it "" to show the line exactly    #
#            like they appear in the rules file.    #
#                                                   #
#            Basically, it will compress matching   #
#            following chars down to one (tr -s).   #
#                                                   #
# Anyway, "!rules svcd" will display the svcd rules #
# but you may also include a search word.           #
# "!rules svcd limited" will only show any rules in #
# svcd that includes the word "limited".            #
#                                                   #
# Simply using !rules will display the sections.    #
#                                                   #
# You can try this script from shell by executing   #
# tur-rules.sh itself.                              #
#                                                   #
#-[ Contact ]---------------------------------------#
#                                                   #
# Turranius on efnet/linknet. Usually in #glftpd    #
# http://www.grandis.nu or http://grandis.mine.nu   #
#                                                   #
#-[ Settings ]--------------------------------------#

rules=/glftpd/ftp-data/misc/site.rules

sections="
GENERAL:1.
DIVX:5.|1.14
SVCD:7.|1.14
VCD:6.|1.14
XBOX:8.
UTILS:4.
0DAYS:2.
UPDATED:Last
"

compress="."


######################################################
# No changes below here. Can change the "echo" parts #
# if you like though.                                #
######################################################

## Can we read the rules file ?
if [ ! -r $rules ]; then
  echo "Cant read rules file. Check path and permissions."
  exit 0
fi

## Procedure for listing all defined sections.
proc_listsections() {
  for section in $sections; do
    name="$( echo $section | cut -d':' -f1 )"
    if [ "$names" ]; then
      names="$names $name"
    else
      names="$name"
    fi
  done
  echo "Tur-Rules $VER."
  echo "Usage: !rules <section> (searchword)"
  echo "Defined sections are: $names"
  echo "Example !rules $name limited"
}

## If no argument, run the above proc.
if [ -z "$1" ]; then
  proc_listsections
  exit 0
fi

## Got inputs correct. Lets go searching.
for section in $sections; do

  ## Grab section name from data.
  name="$( echo $section | cut -d':' -f1 )"

  ## Check if this section is what the user asked for..
  if [ "$( echo $name | grep -wi "$1" )" ]; then
    
    ## Get the searchwords defined for this section. 
    search="$( echo $section | cut -d':' -f2 | tr -s '|' ' ' )"

    ## Add each searchword up, adding a ^ infront.
    for each in $search; do
      if [ "$searchline" ]; then
        searchline="^$each|$searchline"
      else
        searchline="^$each"
      fi
    done

    ## Do a different search if a searchword was included.
    if [ "$2" ]; then
      if [ "$compress" ]; then
        ## If we have something to compress...
        OUTPUT="$( egrep $searchline $rules | grep -i "$2" | tr -s "$compress" | tr -s ' ' '^' )"
      else
        ## If compress is ""
        OUTPUT="$( egrep $searchline $rules | grep -i "$2" | tr -s ' ' '^' )"
      fi
      msg=", containing '$2'"
    else
      if [ "$compress" ]; then
        ## If we have something to compress...
        OUTPUT="$( egrep $searchline $rules | tr -s "$compress" | tr -s ' ' '^' )"
      else
        ## If compress is ""
        OUTPUT="$( egrep $searchline $rules | tr -s ' ' '^' )"
      fi
    fi

    ## Output the text we found.
    if [ "$OUTPUT" ]; then
      echo "Rules for section $name$msg:"
      for each in $OUTPUT; do
        echo $each | tr -s '^' ' '
      done
    fi

    ## Set GOTONE so we know we found a section.
    GOTONE="TRUE"

  fi
done

## User did not enter a defined section.
if [ -z "$GOTONE" ]; then
  proc_listsections
  exit 0
fi

## User entered a defined section but no rules found.
if [ -z "$OUTPUT" ]; then
  echo "No rule found so... its allowed !!"
  exit 0
fi

exit 0