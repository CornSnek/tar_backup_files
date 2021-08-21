#!/bin/bash
cd TarBackups
rm FileBackup_*.tar.gz.gpg #Remove any old .tar.gz.gpg
GET_TAR_FILES(){
	TAR_FILE_BACKUPS=$(find . -maxdepth 1 -type f | grep FileBackup_)
	NUM_TARS=$(printf "%s\n" $TAR_FILE_BACKUPS | wc -l)
}
GET_TAR_FILES
newest_file=$(printf "%s\n" $TAR_FILE_BACKUPS | head -n 1)
for file in $TAR_FILE_BACKUPS; do
	if [[ "$file" -nt "$newest_file" ]]; then #Find newest tar (-nt) to encrypt
		newest_file=$file
	fi
done
gpg --no-symkey-cache -c $newest_file
