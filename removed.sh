#!/bin/env bash

usage ()
{
	msg="\
 usage: removed base-dir(file) second-dir(file) ..
  first argument is the file/folder that you want to keep. rest will get deleted If they matched the sum of the file(s) in the first argument. empty files are ignored.
"

echo -ne "$msg"
exit 0

}

config ()
{
	if [ -z "$1" ]; then
		usage
	fi
}

sum ()
{
		tc="0"
		ta="0"
		tr="0"
		tf="0"
		echo "making:" ~/removed.sum
		echo "">~/removed.sum
		echo "target: $@\n">>~/removed.log
	while read x; do
		if [ -s "$x" ]; then
				echo -ne "checking: '$x'\n"
				r="$(md5sum "$x")"
				tc=$((tc+1))
				h="$(printf "$r" | awk '{print $1}')"
				m="$(grep -cm1 "$h" ~/removed.sum)"
			if [ "$m" = "1" ]; then
				f="$(grep "$h" ~/removed.sum | awk '{$1=""; print}')"
			else
				m="0"
			fi
			if [ "$m" = "0" ]; then
				echo -ne "adding: '$x'\n"
				echo "$r">>~/removed.sum
				ta=$((ta+1))
			elif [ "$m" = "1" ]; then
				echo -ne "removing: '$x' because matches with: '$f'\n"
				echo -ne "removing: '$x' because matches with: '$f'\n">>~/removed.log
				rm "$x" >>~/removed.log 2>&1
				if [ "$?" = "0" ]; then
					tr=$((tr+1))
				else
					tf=$((tr+1))
				fi
			fi
		fi
	done< <( find $@ -type f )
	echo -ne "\n\n">>~/removed.log
}

stats ()
{
	printf "total checked: $tc\n"
	printf "total added: $ta\n"
	printf "total removed: $tr\n"
	printf "total failed remove: $tf\n"
}


config $@
sum $@
stats
