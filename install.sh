#!/bin/sh
SYSTEMD_USR_DIR=~/.config/systemd/user
if [[ -z "$SYSTEMD_USR_DIR" ]]; then
	>&2 echo Unable to install. Directory $SYSTEMD_USR_DIR does not exist.
	exit 1
else
	printf "$(cat TarBackupFiles.service.template)\n" "$(pwd)" > TarBackupFiles.service #Replace %s in template to create TarBackupFiles.service
	cp TarBackupFiles.{service,timer} $SYSTEMD_USR_DIR
	systemctl --user start TarBackupFiles.timer
	systemctl --user enable TarBackupFiles.timer
	rm TarBackupFiles.service #Keep TarBackupFiles.service.template for reinstallations
fi
