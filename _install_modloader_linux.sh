#!/bin/bash

MODLOADERDIR="ppr-modloader"

EXECNAME="psychopatrolr"

if [ ! -d "$MODLOADERDIR" ]
then
	printf "\u001b[91m[PPR-ModLoader Installer] \u001b[0m"
	echo "The ppr-modloader folder is missing!"
	echo "Please make sure to follow the install instructions correctly!"

	exit
fi

EXECPATH=""

for dir in \
	"." \
	"$HOME/.steam/steam/steamapps/common/Psycho Patrol R" \
	".." \
	"Psycho Patrol R"
do
	for filename in \
		"$EXECNAME" \
		"$EXECNAME"".x86_64" \
		"$EXECNAME"".64"
	do
		execpath="$dir""/""$filename"

		if [ -f "$execpath" ]
		then
			EXECPATH="$execpath"
		fi
	done

	if [ -n "$EXECPATH" ]
	then
		realdir="$(realpath "$dir")"

		printf "\u001b[95m[PPR-ModLoader Installer] \u001b[0m"
		echo "Successfully found game in \"$realdir\""

		break
	fi
done

if [ -z "$EXECPATH" ]
then
	printf "\u001b[91m[PPR-ModLoader Installer] \u001b[0m"
	echo "Failed to find the game folder!"
	echo "Please make sure to follow the install instructions correctly!"

	exit
fi

BASEDIR="$(dirname "$EXECPATH")"

MODLOADERDIR="$(realpath "$MODLOADERDIR")"

cd "$BASEDIR" || exit

if [ ! -x "$EXECPATH" ]
then
	chmod u+x "$EXECPATH"
fi

"$EXECPATH" --quit --no-window --script "$MODLOADERDIR/install_modloader.gd"
