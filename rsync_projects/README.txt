use ./rsync_projects_to_backup.sh --help
Script will do by default, if no params are given:

rsync -azvv --dry-run /home/chris/projects/ /home/chris/backups/projects_[YYYYmmdd]
               creating a new target-dir /home/chris/backups/projects_[YYYYmmdd] if it doesn't exist yet
               if the source-dir does not exist the script shows an ERROR and exits.
               if the target-dir already exists the script shows an ERROR and exits.
               NO other checks are done ...

If --execute is given than the --dry-run is omitted. If no other params are given than rsync is executed as:

rsync -azvv /home/chris/projects/ /home/chris/backups/projects_[YYYYmmdd]


Script params:
-h --help: help
-s <dir> --source <dir>: use the <dir> as the source dir for the rsync
-t <dir> --target <dir>: use the <dir> as the target dir for the rsync
-v --verbose: show more info on script execution
-y --yes -e --execute: run the rsync command without the dry-run param