#!/bin/bash

bins="bash  cat  ls  make  mkdir  rm  sed  sh"
TOOL=""
URL=""
if [ "$#" -ne 2 ]; then
    echo "Usage ./install.sh ARCH TARGET_PATH"
    echo "ARCH can be avr,arm or xtensa"
    echo "TARGET_PATH is where the cross tools will be installed"
    echo "Tools will be installed at the path under TARGET_PATH/crosstools/ARCH"
    echo "Eg: ./install.sh arm /home/user/Tools"
    exit 1
fi

if [ -d "$2" ]; then
    rm -rf tars;mkdir tars
    if [ "$1"=="arm" ]; then
        TOOL="arm-none-eabi"
        URL="https://developer.arm.com/-/media/Files/downloads/gnu-rm/9-2019q4/gcc-arm-none-eabi-9-2019-q4-major-x86_64-linux.tar.bz2"
    
    elif [ "$1" == "avr" ]; then
        echo "AVR choosen"
        exit 0
    
    elif [ "$1" == "xtensa" ]; then
        echo "Xtensa choosen"
        exit 0
    
    else
        echo "Unsuported architecture " $1
        exit 1
    fi

    mkdir -p "$2"/crosstools/"$1"/crosscompiler/"$TOOL"
    if [ $? -ne 0 ]; then
        echo "Error while creating target directoy"
        exit 1
    fi
    
    wget $URL -O tars/"$TOOL".tar.bz2
    if [ $? -ne 0 ]; then
        echo "Error while downloading tools"
        exit 1
    fi
    
    tar --strip-components=1 -xvf  tars/"$TOOL".tar.bz2 -C "$2"/crosstools/"$1"/crosscompiler/"$TOOL"
    if [ $? -ne 0 ]; then
        echo "Error while untarring tools"
        exit 1
    fi

    CROSS_TOOLS="$2"/crosstools/"$1"/crosscompiler/"$TOOL"/bin
    for x in $bins; do allbins+="$(which $x) "; done
    for x in $(ls -ltr "$CROSS_TOOLS"/* | awk {'print $9'}); do allbins+="$x "; done
    for y in $(for x in $allbins; do ldd $x; done| grep "=>" | awk {'print $3'} | uniq); do libs+="$y ";done
    for y in $(for x in $allbins; do ldd $x; done | grep -v "=>" | grep -i "/lib" | awk {'print $1'}|uniq); do libs+="$y ";done
    
    for x in $libs; do mkdir -p /tmp/crosstools/arm/"`dirname $x`";cp $x /tmp/crosstools/arm/"`dirname $x`"/.;done
else	
    echo "Path " $2 " doesnot exist"
    exit 1
fi
