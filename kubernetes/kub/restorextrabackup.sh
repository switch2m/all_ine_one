#!/bin/bash

MY_BACKUP_PATH="${BACKUP_PATH:-/xtrabackup}"
MY_BACKUP_DAY="${BACKUP_DAY:-20200610}"
MY_BACKUP_HOUR="${BACKUP_HOUR:-06}"

TEMP_DIR="$MY_BACKUP_PATH/temp/$MY_BACKUP_DAY-$MY_BACKUP_HOUR"
RESTORE_LOG_FILE="$MY_BACKUP_PATH/temp/restore_log_$MY_BACKUP_DAY-$MY_BACKUP_HOUR".txt

SCRIPT_START=$(date +"%Y-%m-%d_%H-%M-%S")

if [ -d "$TEMP_DIR" ]; then
  exit 1
fi

mkdir -p "$TEMP_DIR"

cp -R $MY_BACKUP_PATH/$MY_BACKUP_DAY $TEMP_DIR
xtrabackup --prepare --apply-log-only --target-dir="$TEMP_DIR/$MY_BACKUP_DAY/full" >>$RESTORE_LOG_FILE 2>&1

if [ ! -d "$TEMP_DIR/$MY_BACKUP_DAY/$MY_BACKUP_HOUR" ]; then
  echo "No inc Backup for this Hour $MY_BACKUP_HOUR"
else
  INT_MY_BACKUP_HOUR=$(expr $MY_BACKUP_HOUR + 0)
  i=1
  while [ $i -le $INT_MY_BACKUP_HOUR ]
  do
    DIR=$(printf "%02d\n" $i )
  
    if [ -d "$TEMP_DIR/$MY_BACKUP_DAY/$DIR" ]; then
      xtrabackup --prepare --apply-log-only --target-dir="$TEMP_DIR/$MY_BACKUP_DAY/full" --incremental-dir="$TEMP_DIR/$MY_BACKUP_DAY/$DIR" >> $RESTORE_LOG_FILE 2>&1
    fi
  
    i=$(($i+1))
  done
  
  xtrabackup --prepare --target-dir="$TEMP_DIR/$MY_BACKUP_DAY/full" >>$RESTORE_LOG_FILE 2>&1
  
  rsync -avrP $TEMP_DIR/$MY_BACKUP_DAY/full/ /var/lib/mysql/ >> $RESTORE_LOG_FILE 2>&1
  
  SCRIPT_END=$(date +"%Y-%m-%d_%H-%M-%S")
fi
