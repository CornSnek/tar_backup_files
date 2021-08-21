Tar Backup Files
=
The purpose of this is to make automatic tar file backups using [systemd](https://systemd.io/) .service and .timer files instead of executing the script manually. There is also an optional to encrypt the latest file backup with [gpg](https://gnupg.org/) (EncryptLatest.sh)

The following lists the following files and shell scripts used.

## TarBackupFiles.sh, TarBackupFiles.conf, and TarBackupFileNames.txt
TarBackupFiles.sh can just be executed manually to create file backups in the folder TarBackups. It is used alongside with the systemd files (TarBackupFiles.timer and TarBackupFiles.service) to create automatic backups.

TarBackupFiles.conf can be configured to change the directory of which the names in TarBackupFileNames.txt will use to create backup file names (Default is ~ or /home/your_username). The config file can also be used to create a maximum number of file backups (MAX_FILES) until it deletes the oldest files automatically. TarBackupFileNames.txt shows some examples of files and directories formats.

## install.sh and uninstall.sh
These create the .service and .timer systemd files as TarBackupFiles.timer and TarBackupFiles.service. Using install.sh executes the shell script TarBackupFiles.sh automatically. The .service/.timer files would be copied and moved in ~/.config/systemd/user, and the .timer file is started/enabled to do the automatic backups (systemctl --user start TarBackupFiles.timer and systemctl --user enable TarBackupFiles.timer).

Using uninstall.sh just undoes the install and removes TarBackupFiles.timer and TarBackupFiles.service from ~/.config/systemd/user (systemctl --user stop TarBackupFiles.timer and systemctl --user disable TarBackupFiles.timer).

In the TarBackupFiles.timer file, the OnCalendar parameter can be edited to make backups to your preferred time. The default is to create backups every 30 minutes starting at :00 and :30 (OnCalendar=\*-\*-\* \*:0,30:00). More information [here](https://www.freedesktop.org/software/systemd/man/systemd.timer.html).
## EncryptLatest.sh (optional)
Will use gpg on the latest backup (With passphrase prompt and with --no-symkey-cache). It also removes any other old *.tar.gz.gpg inside the TarBackups folder.
