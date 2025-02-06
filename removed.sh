#!/bin/env bash


_usage()
{
	msg="\
 usage: removed base-dir(file) second-dir(file) more-dir(file)
  first argument is the file/folder that you want to keep.\
 rest will get deleted If they matched the sum of the file(s) in the first argument.\
 empty files are ignored. Pass the word 'test' for generating a test files.
"

echo -ne "$msg"
exit 0

}

_config()
{

	if [ -z "$1" ]; then
		_usage
	else
		[[ "$@" = *"test"* ]] && _test
		_sum "$@"
		_stats
	fi

}


_sum()
{

		tc="0"; ta="0"
		tr="0"; tf="0"
		echo "making:" ~/removed.sum
		echo "">~/removed.sum
		[ ! -f ~/removed.sum ] && { echo "failed creating the state file:" ~/removed.sum; exit 1; }
		echo -e "date: $(date) targets: $@">>~/removed.log
	while read x; do
		if [ -s "$x" ]; then
				echo -ne "checking: '$x'\n"
				h=($(md5sum "$x")); tc=$((tc+1))
				d=($(grep -Fm1 "${h[0]}" ~/removed.sum))
			if [ -n "$d" ]; then
				echo -e "removing: '$x'(${h[0]}) because matches with: '${d[@]:1}'(${d[0]})"
				echo -e "removing: '$x'(${h[0]}) because matches with: '${d[@]:1}'(${d[0]})">>~/removed.log
				rm "$x" >>~/removed.log 2>&1
				[ "$?" = "0" ] && tr=$((tr+1)) || tf=$((tr+1))
			elif [ -z "$d" ]; then
				echo -ne "adding: '$x'\n"
				echo "${h[@]}">>~/removed.sum
				ta=$((ta+1))
			fi
		fi
	done< <(find "$@" -type f)
	echo -ne "\n\n">>~/removed.log

}

_stats()
{

	echo -e "total checked: $tc\ntotal added: $ta\ntotal removed: $tr\ntotal failed remove: $tf"

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
