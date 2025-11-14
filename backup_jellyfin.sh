#!/bin/bash
#
# to backup metadata and config of jellyfish
# from: https://jellyfin.org/docs/general/administration/backup-and-restore/
#
# need to stop jellyfish first:
# systemctl stop jellyfin
#
BASENAME_SCRIPT=$(basename $0)
HOSTNAME=$(hostname)

log() {
    echo -e "$BASENAME_SCRIPT, $1"
}

log "--started"

TIMESTAMP=$(date +%Y%m%d%H%M%S)
VERSION=10.10.7
BACKUP_DIR=/home/chris/backups/jellyfin.${TIMESTAMP}_${VERSION}
EXT_BACKUP_DIR=/media/chris/T9/backup_jellyfin/

#stop jellyfin
log "--stopping jellyfin"
systemctl stop jellyfin
sleep 1

log "--starting taking backup"
#echo ${BACKUP_DIR}
sudo mkdir -p ${BACKUP_DIR}
sudo cp -a /var/lib/jellyfin ${BACKUP_DIR}/data
sudo cp -a /etc/jellyfin ${BACKUP_DIR}/config
#

log "--copying .tar.gz to external drive"

#check if the $EXT_BACKUP_DIR exists
if [ ! -d "$EXT_BACKUP_DIR" ]; then
    log "\nERROR - EXT_BACKUP_DIR: $EXT_BACKUP_DIR does not exist. Exiting script."; exit 1;
fi

# create a tar file from backed-up jellyfin files, needs sudo to be able to access all files
# and copy the resulting .tar.gz to an external T9 drive
sudo tar cvzf $BACKUP_DIR.tar.gz $BACKUP_DIR
cp $BACKUP_DIR.tar.gz $EXT_BACKUP_DIR

#start jellyfin
log "--starting jellyfin"
systemctl start jellyfin

log "--end"

# Manual commands to make tar and to copy to external drive
# sudo tar cvzf jellyfin.20250706210205_10.10.7.tar.gz ./jellyfin.20250706210205_10.10.7
#cp jellyfin.20250706210205_10.10.7.tar.gz /media/chris/T9/backup_jellyfin/



# Restoring a Backup
#
# This process assumes you followed the steps above to take the backup.
#
#     Stop the running Jellyfin server process.
#
#     Move your current data and configuration directories out of the way (e.g. by appending .bak to them).
#     For example, sudo mv /var/lib/jellyfin /var/lib/jellyfin.bak and sudo mv /etc/jellyfin /etc/jellyfin.bak.
#
#     Copy - do not move or rename - your backup to the existing name.
#     For example, sudo cp -a /media/backups/jellyfin.2024-10-27_10.9.11/data /var/lib/jellyfin and sudo cp -a /media/backups/jellyfin.2024-10-27_10.9.11/config /etc/jellyfin.
#
#     If required, downgrade Jellyfin to the same version as your backup now.
#
#     Start up Jellyfin again. It should start cleanly with the old data, assuming versions are correct. If you downgraded this may happen automatically.
#