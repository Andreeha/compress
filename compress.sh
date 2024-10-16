#!/usr/bin/bash

# Add check if the default tmp_folder_path is accessible

if [ -z "$1" ]; then
  echo "ERROR: NO FOLDER_PATH SPECIFIED"
  echo "USAGE:"
  echo "$0 <folder_path> [<percentage_threshold> [<tmp_file_path>]]"
  exit
else
  FOLDERPATH=$(readlink -f $1)
fi

if [ -z "$2" ]; then
  PERCENTAGE_THRESHOLD=70
else
  PERCENTAGE_THRESHOLD=$2
fi

TMP_FILE_PATH="/tmp/files_to_compress"
if [ -z "$3" ]; then
  LIST_ID=$RANDOM
  TMP_FILE_PATH=$TMP_FILE_PATH$LIST_ID
else
  TMP_FILE_PATH=$3
fi

BACKUPNAME="BACKUP.tar.gz"

FILES=($(ls $FOLDERPATH -lht | tail -n +2 | tr -s ' ' | cut --delimiter=' ' --fields=9))

# Calculating current percentage
CURRENT_PERCENTAGE=$(df -k . | tr -s ' ' | cut --delimiter=" " --fields=5 | sed -n 2p | tr -cd "0-9")

if [ ! -f $TMP_FILE_PATH ]; then
  touch $TMP_FILE_PATH
  ITER=0
  WAS=0
  while [[ $CURRENT_PERCENTAGE -ge $PERCENTAGE_THRESHOLD ]]
  do
    if [[ ! -z ${FILES[ITER]} ]]
    then
      echo "Current percentage: $CURRENT_PERCENTAGE%"
      echo ${FILES[ITER]}
      echo $FOLDERPATH"/"${FILES[ITER]} > $TMP_FILE_PATH
  
      
      # Calculating current percentage
      CURRENT_PERCENTAGE=$(df -k . | tr -s ' ' | cut --delimiter=" " --fields=5 | sed -n 2p | tr -cd "0-9")
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
  rm $TMP_FILE_PATH
else
  echo "ERROR: NAME $TMP_FILE_PATH ALREADY TAKEN AND CANNOT BE USED AS TEMPORARY FILE NAME"
  if [ -z "$3" ]; then
    echo "PLEASE SPECIFY TEMPORARY FILE NAME BY EXECUTING FOLLOWING COMMAND"
    echo "$0 $1 $PERCENTAGE_THRESHOLD <tmp_file_path>"
  else
    echo "SPECIFIED TEMPORARY FOLDER PATH IS ALREADY TAKEN"
  fi
fi
echo "Done."
