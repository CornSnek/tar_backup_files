#!/bin/sh
cd $(dirname $0) #Change directory to this shell script's directory (required). Because systemd uses a different directory.
mkdir -p TarBackups
THIS_SHELL_SCRIPT_DIR=$(pwd)
BACKUP_FILES_FOLDER=$(pwd)/TarBackups
source $THIS_SHELL_SCRIPT_DIR/TarBackupFiles.conf
if [[ -z "$MAX_FILES" ]] || [[ -z "$START_DIRECTORY" ]]; then
	>&2 echo Unable to source from TarBackupFiles.conf. Exiting script.
	exit 1
fi
cd $START_DIRECTORY
BACKUP_FILES_FILE=$THIS_SHELL_SCRIPT_DIR/TarBackupFileNames.txt
BACKUP_FILES=$(cat $BACKUP_FILES_FILE)
BACKUP_FOLDER=FileBackup_
BACKUP_FOLDER+=$(date +"D%F_T%H-%M-%S")
BACKUP_FOLDER+=.tar.gz
echo Creating Backups/$BACKUP_FOLDER \(Contents: $BACKUP_FILES\)
tar -czf $BACKUP_FILES_FOLDER/$BACKUP_FOLDER $BACKUP_FILES #Tar file backups are created in the folder TarBackups.
cd $BACKUP_FILES_FOLDER
GET_TAR_FILES(){
	TAR_FILE_BACKUPS=$(find . -maxdepth 1 -type f | grep FileBackup_)
	NUM_TARS=$(printf "%s\n" $TAR_FILE_BACKUPS | wc -l)
}
GET_TAR_FILES
while [[ "$NUM_TARS" -gt "1" ]] && [[ "$NUM_TARS" -gt "$MAX_FILES" ]]; do
	oldest_file=$(printf "%s\n" $TAR_FILE_BACKUPS | head -n 1)
	for file in $TAR_FILE_BACKUPS; do
		if [[ "$file" -ot "$oldest_file" ]]; then #Find oldest tar (-ot) to delete if there's more than MAX_FILES
			oldest_file=$file
		fi
	done
	echo Removing $oldest_file \(MAX_FILES=$MAX_FILES. Backup file count was $NUM_TARS.\)
	rm $oldest_file
	GET_TAR_FILES
done
