#!/bin/bash
echo "the script is running now"
df -h | grep xtrabackup | awk '{print $4}'

MY_BACKUP_SRC_HOST="${BACKUP_SRC_HOST:-mysql-slave}"
MY_BACKUP_SRC_PORT="${BACKUP_SRC_PORT:-3306}"
MY_BACKUP_TYPE="${BACKUP_TYPE:-full}"
MY_BACKUP_PATH="${BACKUP_PATH:-/xtrabackup}"
MY_BACKUP_USER="${BACKUP_USER:-root}"
MY_BACKUP_PASSWORD="${BACKUP_PASSWORD:-password}"
MY_BACKUP_DAY_RETENTION="${BACKUP_DAY_RETENTION:-7}"

DAY=$(date '+%Y%m%d')
HOUR=$(date '+%H')
START=$(date +"%Y-%m-%d_%H-%M-%S")
LOGFILE="$MY_BACKUP_PATH/backup_log-$DAY.txt"

if [ "$MY_BACKUP_TYPE" = "full" ]; then
  FULL_PATH=$MY_BACKUP_PATH/$DAY/full/
  if [ ! -d "$FULL_PATH" ]; then
    echo "creating full backup FULL_PATH:$FULL_PATH" | tee -a $LOGFILE
    sleep 600s
    echo "sleeping for 600s zzzZZzzzZZ"
    mkdir -p $FULL_PATH
    xtrabackup --no-lock --user=$MY_BACKUP_USER --password=$MY_BACKUP_PASSWORD --host=$MY_BACKUP_SRC_HOST --port=$MY_BACKUP_SRC_PORT --backup --target-dir=$FULL_PATH >>$LOGFILE 2>&1
    if [ $? -eq 0 ]; then
      ENDSCRIPT=$(date +"%Y-%m-%d_%H-%M-%S")
      echo "full backup Successfully terminated START:$START   END:$ENDSCRIPT" | tee -a $LOGFILE
      echo "find $MY_BACKUP_PATH -maxdepth 1 -type d -ctime +$MY_BACKUP_DAY_RETENTION -exec rm -rf {} \;"
      echo "find $MY_BACKUP_PATH -maxdepth 1 -type d -ctime +$MY_BACKUP_DAY_RETENTION -exec rm -rf {} \;" | tee -a $LOGFILE
      find $MY_BACKUP_PATH -maxdepth 1 -type d -ctime +7 -exec rm -vrf {} \;
      echo "folders deleted successfully"
    else
      echo "failed" | tee -a $LOGFILE
      exit 1
    fi
  else
    echo "Failed full backup - FULL_PATH:$FULL_PATH already exists" | tee -a $LOGFILE
  fi
fi

if [ "$MY_BACKUP_TYPE" = "inc" ]; then
  NEWEST_DIR=$(ls -t $MY_BACKUP_PATH/$DAY/ | head -1)
  PREVIOUS_INC_PATH=$MY_BACKUP_PATH/$DAY/$NEWEST_DIR
  NEW_INC_PATH=$MY_BACKUP_PATH/$DAY/$HOUR/
  if [ ! -d "$NEW_INC_PATH" ]; then
    echo "creating incremental backup PREVIOUS_INC_PATH:$PREVIOUS_INC_PATH  NEW_INC_PATH:$NEW_INC_PATH" | tee -a $LOGFILE
    mkdir $NEW_INC_PATH
    xtrabackup --no-lock --user=$MY_BACKUP_USER --password=$MY_BACKUP_PASSWORD --host=$MY_BACKUP_SRC_HOST --port=$MY_BACKUP_SRC_PORT --backup --target-dir=$NEW_INC_PATH --incremental-basedir=$PREVIOUS_INC_PATH >> $LOGFILE 2>&1
    if [ $? -eq 0 ]; then
      ENDSCRIPT=$(date +"%Y-%m-%d_%H-%M-%S")
      echo "incremental backup Successfully terminated START:$START   END:$ENDSCRIPT" | tee -a $LOGFILE
    else
      echo "failed incremental backup" | tee -a $LOGFILE
      exit
    fi
  else
    echo "Failed incremental backup - NEW_INC_PATH:$NEW_INC_PATH already exists" | tee -a $LOGFILE
  fi
fi
