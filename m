From: linuxraid@valli.org
Subject: 2010S issues
Date: Wed, 14 Jan 2004 13:43:28 +0100 (CET)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <36903.194.153.178.110.1074084208.squirrel@mail.valli.org>
References: <400518E8.1060409@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <400518E8.1060409@xs4all.nl>
To: Jasper Slits <slits@xs4all.nl>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Jasper,
I have installed debian via the gentoo livecd 1.
(gentoo is another great distro. www.gentoo.org)
The kernel of this CD detects your raid.

Do the following steps to install debian via the gentoo CD:
- Boot with the gentoo LiveCD
- Create partitions with fdisk
  # fdisk /dev/sda
- Create filesystems like
  # mke2fs -j /dev/sda1
  # mkswap /dev/sda2
  # mkreiserfs /dev/sda3
- Mount partitions
  # swapon /dev/sda2
  # mount /dev/sda3 /mnt/gentoo
  # mkdir /mnt/gentoo/boot
  # mount /dev/sda1 /mnt/gentoo/boot
- Do the following on a already installed debian-machine
  # apt-get --download-only install debootstrap
- On the new machine do
  # mkdir /root/work
  # cd /root/work
  # scp debianmachine:/var/cache/apt/archives/debootstrap_0.1.17_i386.deb .
  # ar -xf debootstrap_0.1.17_i386.deb
  # cd /mnt/gentoo
  # mkdir tmp
  # cd tmp
  # mkdir debinst
  # cp -a /mnt/cloop/usr .
  # tar zxvf /root/work/data.tar.gz
  # cd /
  # rm usr
  # ln -s /mnt/gentoo/tmp/debinst/usr .
  # /usr/sbin/sbin/debootstrap --arch i386 woody /mnt/gentoo
http://http.us.debian.org/debian
  # chroot /mnt/gentoo /bin/bash
- debian base dirs are now installed. edit now the /etc/fstab
  # vi /etc/fstab
  # mount -a
  # mount -t proc proc /proc
  # dpkg-reconfigure console-data
- configure the net
  # vi /etc/network/interfaces
  # vi /etc/resolve.conf
  # vi /etc/hostname
- do now the debian base-config
  # /usr/sbin/base-config
- install packages desired for kernel-compile
  # apt-get update
  # apt-get upgrade
  # apt-get install perl
  # apt-get install make
  # apt-get install gcc
  # apt-get install ssh
  # apt-get install wget
  # apt-get install bzip2
  # apt-get install libncurses5-dev
- compile the kernel
  # wget http://www.kernel.org/pub/linux/v2.4/linux-2.4.24.tar.bz2
  # tar jxvf linux-2.4.24.tar.bz2
  # ln -s linux-2.4.24 linux
  # cd linux
  # make mrproper
  # make menuconfig
- kernel configuration
  - DO NOT include 79xx support.
  - include Adaptec i20 RAID support (in scsi menu) i2o_dpt
  - DO NOT include i2o device support
- know compile
  # make dep
  # make clean
  # make bzImage
  # make modules
  # make modules_install
  # cp arch/i386/boot/bzImage /boot/vmlinuz-2.4.24
  # cp System.map /boot/System.map-2.4.24
  # cp .config /boot/config-2.4.24
- configure lilo
  # vi /etc/lilo.conf
  # vi /boot/bootmess.txt
  # /sbin/lilo -v
- Create bootdisks (insert an empty floppy)
  # mkboot /boot/vmlinuz-2.4.24

FINISH
- try to reboot
  unfortunatelly we can only boot from the bootdisk
  booting from the RAID doesn't work

Good luck
Regards valli


> hi valli,
>
> I am sorry to bother you, but i have the same RAID1 card as you and i
> going to run Debian on my server (Supermicro, Intel Xeon, Adaptec 7902
> dual-channel Ultra320 SCSI onboard and Zero-channel RAID support using
> Adaptec 2010S).
>
> I havent tried to install it yet but i read you managed to get it
> working
> (http://marc.theaimsgroup.com/?l=linux-raid&m=107403841015538&w=2).
>
> That's a big relieve because i have read some stories of people who
> didnt get it working with Debian. Adaptec seems to think that there
> arent any other distros besides SuSE & RedHat :)
>
> Can you give me any tips on installing it succesfully? I have two 36GB
> discs and no IDE disc to boot from, but a floppy will do i hope ;)
>
> My approach will be:
> - config 2.4.24 (2.6.1 seems to have a broken Adaptec i2o_dpt)
> - include 790x support and Adaptec i20 support.
> - compile the kernel
> - create a new Debian bootdisk using this newly created kernel
> - boot the new server and install debian using net-install
> - boot from floppy
>
> Are there any steps i forgot?
>
> I already tested that dpt_util on a spare Debian box and it runs, of
> course it can't detect scsi-adapters though.
>
> Kind regards,
>
> Jasper
>
