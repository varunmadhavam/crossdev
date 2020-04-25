#!/bin/bash

bins="bash  cat  ls  make  mkdir  rm  sed  sh"

if [ "$#" -ne 2 ]; then
    echo "Usage ./install.sh ARCH TARGET_PATH"
    echo "ARCH can be AVR,ARM or XTENSA"
    echo "TARGET_PATH is where the cross tools will be installed"
    echo "Tools will be installed at the path under TARGET_PATH/crosstools/ARCH"
    echo "Eg: ./install.sh ARM /home/user/Tools"
    exit 1
fi

if [ -d "$2" ]; then
    if [ "$1"=="ARM" ]; then
        wget https://developer.arm.com/-/media/Files/downloads/gnu-rm/9-2019q4/gcc-arm-none-eabi-9-2019-q4-major-x86_64-linux.tar.bz2 -O tars/armtool.tar.bz2
	if [ $? -ne 0 ]; then

	TOOL="arm-none-eabi"
    elif [ "$1" == "AVR" ]; then
        echo "AVR choosen"
        exit 0
    elif [ "$1" == "XTENSA" ]; then
        echo "Xtensa choosen"
        exit 0
    else
        echo "Unsuported architecture " $1
        exit 1
    fi
    CROSS_TOOLS="$2"/crosstools/"$1"/"$TOOL"/bin
    for x in $bins; do allbins+="$(which $x) "; done
    for x in $(ls -ltr "$CROSS_TOOLS"/* | awk {'print $9'}); do allbins+="$x "; done
    for y in $(for x in $allbins; do ldd $x; done| grep "=>" | awk {'print $3'} | uniq); do libs+="$y ";done
    for y in $(for x in $allbins; do ldd $x; done | grep -v "=>" | grep -i "/lib" | awk {'print $1'}|uniq); do libs+="$y ";done
    echo $libs
else	
    echo "Path " $2 " doesnot exist"
    exit 1
fi
