
if test -e ../clover2_3.6.5-1_i386.deb
then
    if dpkg -l | egrep ^clover2
    then
        sudo apt-get remove clover2
    fi

    sudo dpkg -i ../clover2_3.6.5-1_i386.deb
fi

if test -e ../clover2_3.6.5-1_amd64.deb
then
    if dpkg -l | egrep ^clover2
    then
        sudo apt-get remove clover2
    fi

    sudo dpkg -i ../clover2_3.6.5-1_amd64.deb
fi