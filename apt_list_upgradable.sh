#! /usr/bin/bash
#
# show info for packages that are upgradable (=for packages listed by: apt list --upgradable)
#
# 9/11/2024

BASENAME_SCRIPT=$(basename $0)
HOSTNAME=$(hostname)

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color
#echo example:
#echo -e "I ${RED}love${NC} Stack Overflow"


log() {
    echo -e "$BASENAME_SCRIPT: $1"
}

#get list of package names from  "apt list --upgradable"
#package_names_list=$(apt list --upgradable 2>/dev/null|cut -d'/' -f1|grep "Listing..." --invert-match|sed -z 's/\n/ /g')
package_names_list=$(apt list --upgradable 2>/dev/null|cut -d'/' -f1|grep "Listing..." --invert-match)

if [ -z "$package_names_list" ] ; then
	log "No packages in: apt list --upgradable"
	exit 0
fi

# example:
#names=("Bob" "Peter" "$USER" "Big Bad John")
#$ for name in "${names[@]}"; do echo "$name"; done

#for package_name in ${package_names_list[@]} ; do #remark: no quotes around ${package_names_list[@]} to ensure splitting on spaces or \n
for package_name in $package_names_list ; do #remark: no quotes around $package_names_list to ensure splitting on spaces or \n
	#echo "$package_name" | od -c
	package_info=$(dpkg-query --show --showformat='${binary:Package}\t${Version}\t${source:Package}: ${binary:Synopsis}\n' "$package_name") 
	package_name=$(echo "$package_info" | cut -f1) #\t is the default delimiter of cut
	package_info_rest=$(echo "$package_info" | cut -f2-) #\t is the default delimiter of cut
	#echo -e "${GREEN}${package_name}${NC}" 
	echo -e "${GREEN}${package_name}/${NC}${package_info_rest}" 
done