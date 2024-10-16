#!/usr/bin/bash

if [ ! -z $1 ]; then
  ID=$1
else
  ID="00"
fi

if [ ! -d ./test_folder ]; then
  mkdir ./test_folder$ID
fi

NFILES=$((1000 + $RANDOM % 1000))
for ((i = 0 ; i < $NFILES; i++))
do
  touch test_folder$ID/test_$i
  NLINES=$((10000 + $RANDOM % 10000))
  RES=""
  for ((j = 0; j < $NLINES; j++))
  do
    RES+="12345676543234567543adfv;kajnvlknjasdclnsakjdnlkasndkjlfanlkjdsfnlsakdnflksajdfnlkasjn\n"
  done
  echo $RES > test_folder$ID/test_$i
done
