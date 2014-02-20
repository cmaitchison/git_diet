#!/bin/bash
#set -x 
IFS=$'\n'

usage()
{
cat << EOF
usage: $0 options

Show the largest files packed in the current directory's git repository

OPTIONS:
   -h      Show this message
   -n      The number of files to show (default 10)
   -d      Filter out files currently in project (ie. only show deleted files)
   -f      Show file paths only
EOF
}

NO_OF_FILES=10
DELETED_ONLY=false
PATHS_ONLY=false
while getopts “hn:df” OPTION
do
     case $OPTION in
         h)
             usage
             exit 1
             ;;
         n)
             NO_OF_FILES=$OPTARG
             ;;
         d)
             DELETED_ONLY=true
             ;;
         f)
             PATHS_ONLY=true
             ;;
         ?)
             usage
             exit 1
             ;;
     esac
done

n_packs=$(ls .git/objects/pack/pack-*.idx 2> /dev/null | wc -l)
if [ $n_packs -eq 0 ]; then echo "The repo is empty" && exit 1; fi

objects=`git verify-pack -v .git/objects/pack/pack-*.idx | grep -v objects | grep -v commit | sort -k4nr | head -n $NO_OF_FILES`

for y in $objects
do
	size=$((`echo $y | cut -f 5 -d ' '`/1024))
	compressedSize=$((`echo $y | cut -f 6 -d ' '`/1024))
	sha=`echo $y | cut -f 1 -d ' '`
	path=$( git rev-list --all --objects | grep $sha | awk '{ s = ""; for (i = 2; i <= NF; i++) s = s $i " "; print s }' | sed 's/[ \t]*$//' )
	path=$( echo $path | sed 's/ /\\ /g' ) # escape spaces
	[ -e `echo $path` ] && file_exists=true || file_exists=false
	[ ! -z $output ] && output="${output}\n"
	output="${output}${size},${compressedSize},${sha},${path},${file_exists}"
done
if [ $PATHS_ONLY == false ]; then
	output="raw_size(KB),compressed_size(KB),SHA,path,exists\n${output}"
fi
$DELETED_ONLY && $PATHS_ONLY && echo -e $output | awk -F"," '$5 == "false" {print $4}' && exit
$PATHS_ONLY && echo -e $output | awk -F"," '{print $4}' && exit
$DELETED_ONLY && echo -e $output | column -t -s ',' | grep -wv true && exit
echo -e $output | column -t -s ','
