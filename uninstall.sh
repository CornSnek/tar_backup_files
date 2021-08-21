#!/bin/sh
SYSTEMD_USR_DIR=~/.config/systemd/user
if [[ -z "$SYSTEMD_USR_DIR" ]]; then
	>&2 echo Unable to uninstall. Directory $SYSTEMD_USR_DIR does not exist.
	exit 1
else
	systemctl --user stop TarBackupFiles.timer
	systemctl --user disable TarBackupFiles.timer
	rm $SYSTEMD_USR_DIR/TarBackupFiles.{service,timer}
fi
