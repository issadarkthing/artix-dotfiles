#!/bin/bash

PACKAGES=$(pacman -Qu | wc -l)
TEMPFILE=/tmp/package-update
CHECK=0

# check if temp file exists, returns true if not check tempfile content is lower than $PACKAGES
[[ ! -f $TEMPFILE ]] && CHECK=1
[[ $(cat $TEMPFILE 2> /dev/null) -lt $PACKAGES ]] && CHECK=1

if [[ $PACKAGES -gt 0 ]] && [[ $CHECK -eq 1 ]]; then 
	dunstify -i /usr/share/icons/Adwaita/24x24/mimetypes/package-x-generic-symbolic.symbolic.png \
		"Package update" "$PACKAGES new package update"

	echo "$PACKAGES" > "$TEMPFILE"
	echo "$PACKAGES"
elif [[ $PACKAGES -eq 0 ]] && [[ $(cat $TEMPFILE 2> /dev/null) -gt 0 ]]; then
	rm "$TEMPFILE"
	echo "$PACKAGES"
elif [[ ! -f $TEMPFILE ]]; then
	echo "$PACKAGES" > "$TEMPFILE"
	echo "$PACKAGES"
else
	echo "$PACKAGES"
fi
