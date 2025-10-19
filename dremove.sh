#!/bin/bash


_usage()
{
	msg="\
usage: dremove somedir/ anotherdir/

Logic:
This utility works by Iterating over all passed files. \
Every file is hashed and their hash are stored until execution ends. \
If current file has same hash of previous file then current file will be removed.
"

echo -ne "$msg"
exit 0

}

_config()
{

	if [ -n "$1" ]; then
		_sum "$@"
	elif [ "$mode" = "test" ]; then
		_test; _sum "./test"
	else
		_usage
	fi

}


_sum()
{

				local m g tf="0" tu="0" tr="0" te="0"
				g=~/dremove.log
			if [ ! -s "$g" ]; then
				echo "creating log file: $g"
				echo >>"$g" || { echo "failed creating log file: $g"; exit 1; }
			fi
				echo -e "execution date: $(date) targets: $@">>"$g"
	while read x; do
			if [ -s "$x" ]; then
				echo "generating hash: '$x'"
				h=($(md5sum "$x")); tf=$((tf+1))
			else
				echo "error cannot read: $x" | tee -a "$g"
				te=$((te+1)); continue
			fi
			if [[ "$m" = *"${h[0]}"* ]]; then
				echo -e "found duplicated file: '$x' ${h[0]}" | tee -a "$g" && \
				rm "$x" >>"$g" 2>&1 && tr=$((tr+1)) || te=$((te+1))
			else
				m+="found unique file: '$x' ${h[0]}\n"
				tu=$((tu+1))
			fi
	done< <(find "$@" -type f)
	echo -e "$m">>"$g"
	echo -e "total files: $tf\ntotal unique: $tu\ntotal removed: $tr\ntotal errors: $te"

}

_test()
{

	echo "generating test..."
	mkdir -p "test"
	f=("file 1 of 3.txt" "file 2 of 3.txt" "file 3 of 3.txt")
for x in "${f[@]}"; do
	echo "writting into: ./test/$x"
	shuf -ren 500 "dummy text">"./test/$x"
done

}

_config "$@"
