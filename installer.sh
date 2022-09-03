#!/bin/sh
echo welcome to standenboys arch installer for new users
echo welcome to arch
echo you are a giga chad now
echo to start we are going to test your network
sleep 3
rm -rf index*
wget -q google.com
networktest=$(ls | grep -Eo html)
if [ $networktest == html ]
then
	echo networking gud
else
	echo networking bad
	echo please fix this
	echo check your cables
	echo use nmcli to use wifi
	sleep 3
	killall sh
fi
sleep 3
answer="n"
while [ $answer == n ]
do
	echo now we will set up drives
	lsblk
	echo this is a list of all drives
	echo "which drive do you want to use (ie sda nvme0n1)"
	read drive
	echo "$drive is this right? (y/n)"
	read answer
done
sleep 3
echo now we will open cfdisk
echo this lets you set up drives
echo you will need to do a few things
echo first if prompted to select a label you to select a label then pick dos
echo if it *doesnt* prompt you to do this please press quit and say when this installer asks
echo if it *does* prompt you to pick dos, then do it
echo then delete any existing partions
echo then select create new partion
echo set its size to 200M
echo make it a primary partion
echo then use the rest of your free space for a second partion
echo you need to make the 200M partion have a bootable mark
echo when this is all done press write
echo then press quit
echo opening cfdisk
sleep 15
cfdisk /dev/$drive
echo did you create the partions with a dos lable (y/n)
read answer
if [ $answer == n ]
then
	echo im sorry i cant be asked to write the code to fix this just use the archinstall command its probably better
	killall sh
fi

echo im so glad this has worked for you
echo now the drives will be formated

mkfs.ext4 /dev/${drive}1
mkfs.ext4 /dev/${drive}2

echo wow it worked, lucky you
sleep 3
echo now we are gonna mount the drives
mount /dev/${drive}2 /mnt
mkdir /mnt/boot
mount /dev/${drive1}1 /mnt/boot

echo wow that worked too
echo you are very lucky

sleep 3

echo now we will install the base system
echo you will need to select a kernel to use
echo they have different pros and cons so use the one thats best for you
echo "1) linux, the default kernel, its very good, you cant go wrong"
echo "2) linux-zen, this is the stock linux kernel but trying to be a bit faster, it works well but i've found it uses a bit more ram"
echo "3) linux-lts, this is the stock linux kernel but it has some older hardware support, if your pc is 15 years+ old then use this"
echo "4) linux-hardened, use this on servers, this is not for general use"
sleep 2
echo "which do you wish to use (1,2,3,4)"
read kernel
if [ $kernel == 1 ]
then
	echo you have chosen linux
	echo the main system will be installed via pacstrap
	sleep 1
	echo this could take a while
	pacstrap /mnt base linux linux-firmware
fi
if [ $kernel == 2 ]
then
	echo you have chosen linux-zen
	echo the main system will be installed via pacstrap
	sleep 1
	echo this could take a while
	pacstrap /mnt base linux-zen linux-firmware
fi
if [ $kernel == 3 ]
then
	echo you have chosen linux-lts
	echo the main system will be installed via pacstrap
	sleep 1
	echo this could take a while
	pacstrap /mnt base linux-lts linux-firmware
fi
if [ $kernel == 4 ]
then
	echo you have chosen linux-hardened
	echo the main system will be installed via pacstrap
	sleep 1
	echo this could take a while
	pacstrap /mnt base linux-hardened linux-firmware
fi
sleep 3
echo in theory everything is installed now
echo lets hope that
echo now lets generate an fstab file
echo this is a file that make sure everything works with drives when your pc turns on
sleep 1
genfstab /mnt >> /mnt/etc/fstab
echo all done 
sleep 3
echo now we will enter a chroot
echo this is basically like logging into the new install
arch-chroot /mnt
echo chrooted
echo now we need to set a time zone
echo "where are you in the world (please give like this Europe/London the capitals are important)"
read timezone
ln -sf /usr/share/zoneinfo/$timezone /etc/localtime
hwclock --systohc
echo time zone set
sleep 3
echo "now we must set the locale's, these will make sure everything is in the correct language"
echo to do this you must edit the file /etc/locale.gen
echo to do this we will open the nano text editor
echo "you must remove the '#' infront of the locale relevent to your zone"
echo "you should remove the '#' from both the utf-8 and the iso"
echo when you are done press ctrl o and ctrl x to write to the file and exit
sleep 7
nano /etc/locale.gen
echo now we will create the local
locale-gen
echo all done
sleep 3
echo now we must do the same thing for the keyboard layout
echo "which keyboard layout do you use? (ie us, uk, de-latin1)"
read keylayout
echo KEYMAP=$keylayout > /etc/vconsole.conf
echo all done
sleep 3

echo your doing really good
echo "now we need to give your computer a name (this isn't a username, this is a system name)"
echo what do you want to call it?
read hostname
echo $hostname > /etc/hostname
echo now thats all done too
sleep 3

echo "now we need to set a root (admin) password"
passwd
echo password set
sleep 3

echo now we are going to create a user for you
echo what are you going to be called?
read username
echo creating user, $username
useradd -m $username
echo created user
echo "now please give your user a password (this can be the same as the root/admin password)"
passwd $username
echo pasword set
sleep 3

echo now we are going to install a couple required apps for your system to work
pacman -S networkmanager sudo
echo now we are going to activate network manager to ensure it will work
systemctl enable NetworkManager
echo all done
sleep 3
echo now we need to give your user access to the root account so the can access system files
echo "${username} ALL=(ALL:ALL) ALL" >> /etc/sudoers 
echo "if you saw an error from that then please try and use visudo to add ${username} ALL=(ALL:ALL) ALL"
echo hopefull all that works
sleep 3

echo now we need to install a boot loader
echo we are going to use grub
pacman -S grub
echo okay its now downloaded lets install it
grub-install /dev/$drive
grub-mkconfig -o /boot/grub/grub.cfg
echo "hopefully that doesn't do anything wrong"
sleep 3

echo in theory this should work
echo if it does then you are a lucky sod
echo goodluck
echo please reboot your pc and remove the usb drive/dvd that you are curently running off





