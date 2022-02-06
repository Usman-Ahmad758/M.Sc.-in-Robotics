#!/bin/bash


l=n
u=n
re=n
s=n
hp=n
declare -a posarg=()

#print usage

if [ -z $1 ];then
        echo "Usage :$(basename $0) parent-directory"
        exit 1
fi


while test "x$1" != "x"
do
	case "$1" in
				-l|--lowercase) l=y;;
				-u|--uppercase) u=y;;
				-r|--recursive)	re=q;;
				-s|--subdirectories) s=w;;
				-h|--help) hp=y;;
				*)  posarg=(${posarg[@]} $1)
				;;
				    

	esac
	shift
done

echo -e "Following Files and Directories are selected to change:\n : ${posarg[@]} :\n "
echo "Further Looking with respect to Trees"
for items in ${posarg[@]}; do
# echo $elements

        declare -a allfiles=()

        #process all subdirectories and files in parent directory
        IFS=$'\n' eval 'for i in `find $items -name "*"`;do
		allfiles=(${allfiles[@]} "$i")
        done'
        echo ${allfiles[@]}

done
echo -e "\n"


#Error Calls

#If none of the arguments is seleted
if test $hp != "y" && test $l != "y" && test $u != "y" && test $re != "q" && test $s != "w"
then
	echo -e "\n(UWAGA): Error: None of the Argument is chosen to process...."
	echo "Do not worry, and take a deep breath. We have a service to guide you...."
	echo -e "Type './chname.sh -h' or './chname.sh --help' for guidance....\n"
fi

#If none of the file is chosen
if !((${#posarg[@]})); then
  echo -e "\nError: No File or Directory is Chosen"
fi

#If both lowercase and upercase argumetns are given
if test $u = "y" && test $l = "y"
then
        echo -e "\nAttention: Two comparative arguments are selected, Choose either -u or -l...."
        echo "The Algorithm  will Apply Whichever is Applicable...."
	echo -e "Type './chname.sh -h' or './chname.sh --help' for guidance....\n"
fi


#MAIN CODE

#Code for lower casing simple
if test $l = "y" && test $re != "q" && test $s != "w"
then
for elements in ${posarg[@]}; do

	new_elements="$(basename "${elements}" | tr '[A-Z]' '[a-z]')"

	if [ "${elements}" != "${new_elements}" ]
	then
        	mv -T "${elements}" "${new_elements}";
        	echo "${elements} is renamed to ${new_elements}"
	elif [ "${elements}" == "${new_elements}" ]
       	then
        	echo "${elements} is already in lower case "
	fi

	done
fi

#Code for upper casing simple
if test $u = "y" && test $re != "q" && test $s != "w"
then
for elements in ${posarg[@]}; do

	new_elements="$(basename "${elements}" | tr '[a-z]' '[A-Z]')"

        if [ "${elements}" != "${new_elements}" ] 
	then
                mv -T "${elements}" "${new_elements}";
                echo "${elements} is renamed to ${new_elements}"
	elif [ "${elements}" == "${new_elements}" ]
	then
                echo "${elements} is already in upper case "
	fi

        done

fi

#Code for recursive lower casing
if test $l = "y" && test $re = "q" && test $s != "w"
then

for elements in ${posarg[@]}; do
# echo $elements

	declare -a all=()

	#process all subdirectories and files in parent directory
	IFS=$'\n' eval 'for i in `find $elements -type f -name "*"`;do
		all=(${all[@]} "$i")
		

	done'
	# echo ${all[@]}


	for q in $(seq 1 ${#all[@]});
	do

		h=${all[$q-1]}
		name=`echo $h`
		# echo name=  $name

		#set new name in lower case for files and directories
		new_name="$(dirname "${name}")/$(basename "${name}" | tr '[A-Z]' '[a-z]')"
		
		#check if new name already exists
		if [ "${name}" != "${new_name}" ]; then

                        mv -T "${name}" "${new_name}";
                        echo "${name} is renamed to ${new_name}"
                else
                        echo "The file ${name} is already in lower case "
                fi
		
	done
	
done
fi

#Code for recursive upper casing
if test $u = "y" && test $re = "q" && test $s != "w"
then

for elements in ${posarg[@]}; do
# echo $elements

        declare -a all=()

        #process all subdirectories and files in parent directory
        IFS=$'\n' eval 'for i in `find $elements -type f -name "*"`;do
                all=(${all[@]} "$i")
        done'
        # echo ${all[@]}


        for q in $(seq 1 ${#all[@]});	
        do

                h=${all[$q-1]}
                name=`echo $h`
               # echo name=  $name

                #set new name in lower case for files and directories
                new_name="$(dirname "${name}")/$(basename "${name}" | tr '[a-z]' '[A-Z]')"

                #check if new name already exists
                if [ "${name}" != "${new_name}" ]; then

			mv -T "${name}" "${new_name}";
                	echo "${name} was renamed to ${new_name}"
		else 
			echo "The file ${name} is already in lower case "
		fi

        done
    	
done
fi

#Code for lowercasing with recursive and subdirectories mode together
if test $l = "y" && test $re = "q" && test $s = "w"
then

for elements in ${posarg[@]}; do
# echo $elements

	declare -a all=()

	#process all subdirectories and files in parent directory
	IFS=$'\n' eval 'for i in `find $elements -name "*"`;do
		all=(${all[@]} "$i")
	done'
	# echo ${all[@]}


	for q in $(seq 1 ${#all[@]});
	do
		p=${#all[@]}-$q
		# echo $p
		h=${all[$p]}
		name=`echo $h`
		# echo name=  $name

		#set new name in lower case for files and directories
		new_name="$(dirname "${name}")/$(basename "${name}" | tr '[A-Z]' '[a-z]')"

		#check if new name already exists
		if [ "${name}" != "${new_name}" ]; then

                        mv -T "${name}" "${new_name}";
                        echo "${name} is renamed to ${new_name}"
                else
                        echo "The file ${name} is already in lower case "
                fi

	done
done 
fi

#Code for uppercasing recursive and subdirectories mode together
if test $u = "y" && test $re = "q" && test $s = "w"
then

for elements in ${posarg[@]}; do
# echo $elements

        declare -a all=()

        #process all subdirectories and files in parent directory
        IFS=$'\n' eval 'for i in `find $elements -name "*"`;do
                all=(${all[@]} "$i")
                

        done'
        # echo ${all[@]}


        for q in $(seq 1 ${#all[@]});
        do
                p=${#all[@]}-$q
                # echo $p
                h=${all[$p]}
                name=`echo $h`
                #echo name=  $name

                #set new name in lower case for files and directories
                new_name="$(dirname "${name}")/$(basename "${name}" | tr '[a-z]' '[A-Z]')"

		#check if new name already exists
		if [ "${name}" != "${new_name}" ]; then

                        mv -T "${name}" "${new_name}";
                        echo "${name} is renamed to ${new_name}"
                else
                        echo "The file ${name} is already in lower case "
                fi

	done
done
fi

#Code to lowercase  the subdirectories only
if test $l = "y" && test $re != "q" && test $s = "w"
then

for elements in ${posarg[@]}; do
# echo $elements

        declare -a all=()

        #process all subdirectories and files in parent directory
        IFS=$'\n' eval 'for i in `find $elements -type d -name "*"`;do
                all=(${all[@]} "$i")
                

        done'
        # echo ${all[@]}


        for q in $(seq 1 ${#all[@]});
        do
                p=${#all[@]}-$q
                # echo $p
                h=${all[$p]}
                name=`echo $h`
                # echo name=  $name

		#set new name in lower case for files and directories
                new_name="$(dirname "${name}")/$(basename "${name}" | tr '[A-Z]' '[a-z]')"

		#check if new name already exists
		if [ "${name}" != "${new_name}" ]; then

                        mv -T "${name}" "${new_name}";
                        echo "${name} is renamed to ${new_name}"
                else
                        echo "The file ${name} is already in lower case "
                fi

	done
done
fi


#Code to uppercase  the subdirectories only
if test $u = "y" && test $re != "q" && test $s = "w"
then

for elements in ${posarg[@]}; do
# echo $elements

        declare -a all=()

        #process all subdirectories and files in parent directory
        IFS=$'\n' eval 'for i in `find $elements -type d -name "*"`;do
                all=(${all[@]} "$i")
                

        done'
        # echo ${all[@]}


        for q in $(seq 1 ${#all[@]});
        do
                p=${#all[@]}-$q
                # echo $p
                h=${all[$p]}
                name=`echo $h`
                # echo name=  $name

                #set new name in lower case for files and directories
                new_name="$(dirname "${name}")/$(basename "${name}" | tr '[a-z]' '[A-Z]')"

		#check if new name already exists
		if [ "${name}" != "${new_name}" ]; then

                        mv -T "${name}" "${new_name}";
                        echo "${name} is renamed to ${new_name}"
                else
                        echo "The file ${name} is already in lower case "
                fi

	done
done
fi

#Code to provide the help
if test $hp = "y"
then
	./help.sh
fi



#Code to show which options are selected
echo -e "\nYou have chosen the following options:"

if test $l = "y"
then
	echo "lower case senario"
fi
if test $u = "y"
then
	echo "upper case senario"
fi
if test $re = "q"
then
	echo "recursive senario"
fi
if test $s = "w"
then
	echo "subdirectories senario"
fi


