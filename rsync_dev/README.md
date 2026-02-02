# rsync_since.sh  
- source /media/chris/T9_2/media

- https://serverfault.com/questions/538767/how-to-rsync-files-folders-from-a-specific-date-forward



# More Info:
#
# This puts folder A into folder B:
#
# rsync -avu --delete "/home/user/A" "/home/user/B"
#
# If you want the contents of folders A and B to be the same, put /home/user/A/ (with the slash)
# as the source. This takes not the folder A but all of its content and puts it into folder B. Like this:
#
# rsync -avu --delete "/home/user/A/" "/home/user/B"
#
#     -a archive mode; equals -rlptgoD (no -H, -A, -X)
#     -v run verbosely
#     -u only copy files with a newer modification time (or size difference if the times are equal)
#     -h human readable
#     --progress
#     --partial
#     --delete delete the files in target folder that do not exist in the source
#
# Manpage: https://download.samba.org/pub/rsync/rsync.html
#
# From tldr rsync:
#  archive, display verbose and human-readable progress, and keep partially transferred files if interrupted:
#   rsync -avhP|--compress --verbose --human-readable --partial --progress path/to/source path/to/destination
