#!/usr/bin/bash

BIMODE=

if [ -z "$1" ]; then
  echo "ERROR: NO FOLDER_PATH SPECIFIED"
  echo "USAGE:"
  echo "$0 <folder_path> [<percentage_threshold> [<tmp_folder_path>]]"
  exit
else
  FOLDERPATH=$(readlink -f $1)
fi

if [ ! -d "$FOLDERPATH" ]; then
  echo "ERROR: FOLDER \`$FOLDERPATH' NOT FOUND"
  exit
fi

if [ -z "$2" ]; then
  PERCENTAGE_THRESHOLD=70
else
  PERCENTAGE_THRESHOLD=$2
fi

if [ -z "$3" ]; then
  TMPNAME="/tmp/"$FOLDERPATH
else
  TMPNAME=$3
fi

if [ ! -z "$BIMODE" ]; then
  MB=1048576
  THRESHOLD=$((1024*$MB))
else
  THRESHOLD=1000000000
fi

BACKUPNAME="BACKUP.tar.gz"

FILES=($(ls $FOLDERPATH -lht | tail -n +2 | tr -s ' ' | cut --delimiter=' ' --fields=9))

# Calculating current percentage
VOLUME=$(du -sb $1 | cut -f -1)
PERCENTAGE=$(bc <<< "100 * $VOLUME / $THRESHOLD")

if [ ! -d $TMPNAME ]; then
  ITER=0
  WAS=0
  mkdir -p $TMPNAME
  while [[ $PERCENTAGE -ge $PERCENTAGE_THRESHOLD ]]
  do
    if [[ ! -z ${FILES[ITER]} ]]
    then
      echo "$PERCENTAGE"
      echo ${FILES[ITER]}
      mv $FOLDERPATH"/"${FILES[ITER]} $TMPNAME
  
      
      # Calculating current percentage
      VOLUME=$(du -sb $1 | cut -f -1)
      PERCENTAGE=$(bc <<< "100 * $VOLUME / $THRESHOLD") 
    else
      echo "ERROR["$ITER"]: \`"$(FILES[ITER])"'"
      exit
    fi
    ITER=$((ITER+1))
    WAS=1
  done

  if [ $WAS -eq 1 ]
  then
    tar -czvf $FOLDERPATH$BACKUPNAME -C $TMPNAME .
  fi
  rm -rf $TMPNAME
else
  echo "ERROR: NAME $TMPNAME ALREADY TAKEN AND CANNOT BE USED AS TEMPORARY FOLDER NAME"
  if [ -z "$3" ]; then
    echo "PLEASE SPECIFY TEMPORARY FOLDER NAME BY EXECUTING FOLLOWING COMMAND"
    echo "$0 $1 $PERCENTAGE_THRESHOLD <tmp_folder_path>"
  else
    echo "SPECIFIED TEMPORARY FOLDER PATH IS ALREADY TAKEN"
  fi
fi
