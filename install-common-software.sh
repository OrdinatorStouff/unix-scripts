#!/bin/sh
#
# Must-have packages 
#
#
# mostly for my own record-keeping
# not meant to be an objective reference
#
# WORK IN PROGRESS

# Make sure apt and dpkg are up-to-date first
    sudo apt-get install --upgrade apt aptitude dpkg apt-transport-https apt-utils
    
# Default keyring packages
    sudo apt install --upgrade debian-archive-keyring 
    sudo apt install --upgrade debian-keyring 
    sudo apt install --upgrade debian-ports-archive-keyring 
    sudo apt install --upgrade kali-archive-keyring 
    sudo apt install --upgrade pkg-mozilla-archive-keyring 
    sudo apt install --upgrade ubuntu-archive-keyring 
    sudo apt install --upgrade ubuntu-cloud-keyring 
    sudo apt install --upgrade ubuntu-dbgsym-keyring 
    sudo apt install --upgrade ubuntu-keyring
    sudo apt install --upgrade ca-certificates

# CLI Basics
    sudo apt-get install coreutils # consider Busybox if low disk space
    sudo apt-get install console-setup 
    sudo apt-get install psmisc
    sudo apt-get install cat tac
    sudo apt-get install initramfs-tools
    sudo apt-get install man-db
    sudo apt-get install gawk
    sudo apt-get install htop
    sudo apt-get install grep
    sudo apt-get install locate
    sudo apt-get install screen
    sudo apt-get install mailutils
    sudo apt-get install sudo
    sudo apt-get install sed
    sudo apt-get install grep
    sudo apt-get install tmux #TMux if that's your thing
    
# CLI web fetch tools
    sudo apt-get install curl
    sudo apt-get install wget

# SSH server/client
    sudo apt-get install openssh-server
    sudo apt-get install openssh-client
    sudo apt-get install openssh-sftp-server
    sudo apt-get install openssh-sftp-client
    # Dropbear if space concern?

# CLI Text editors
    sudo apt-get install nano # or nano-tiny if necessary
    sudo apt-get install vim # or vim-tiny if necessary
    
# PGP keys
    sudo apt-get install gnupg2 
    sudo apt-get install gnupg 
    sudo apt-get install gnupg-utils

# Other / Misc
    sudo apt-get install bc # CLI floating-point math https://www.gnu.org/software/bc/
    sudo apt-get install atftpd # TFTP server
    sudo apt-get install git # GIT for repo clone/fetch (can be large size on disk)
    sudo apt-get install netkit-ftp
    sudo apt-get install ftp
    sudo apt-get install pure-ftpd


# TODO 

# look into busybox?
# look into https://github.com/luong-komorebi/Awesome-Linux-Software#command-line-utilities

# logic to check for different package managers ?
# pacman -S 
# yum install
# apt install
# apt-get install
# dnf install



