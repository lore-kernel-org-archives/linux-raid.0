From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: Booting from RAID1
Date: Wed, 23 Dec 2009 02:21:01 -0600
Message-ID: <10.B5.01567.4F2D13B4@cdptpa-omtalb.mail.rr.com>
References: <67.C8.01567.DC44E2B4@cdptpa-omtalb.mail.rr.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <67.C8.01567.DC44E2B4@cdptpa-omtalb.mail.rr.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


	Well, after a bent pin on a tray connector prevented drive in the
tray being recognized, and then a memory stick poppingt out of its socket
unbeknownst to me, I tried rebooting the system, but the primary drive had
its file systems locked, and none of the boot CDs I have on hand have
reiserfs on them.  The secondary drive also would no longer boot.  I loaded
a brand new Debina install on a spare disk, but when I tried to load mdadm
or reiserfsprogs (or anything else), the system could not reach the outside
world.  I could download files from any server on my LAN, but anything on
the internet was no-go.  So I installed Debian again from scratch, and
finally I have a working system, again.  Phew!!  (Sorry, I just had to
vent.)

	Anyway, now that my original drive is back in good shape, I want to
get the secondary RAID drive working so I can then copy everything to a
primary RAID drive and have a fully functional RAID boot system.  The
problem is, when I boot from the disc, during the boot mdadm complains: "No
devices listed in conf file were found", and then the system hangs.
Clearly, the boot loader is finding the kernel in md1 / sdx1, but it seems
the md2 / sdx2 array is not being properly loaded by the kernel.  Here are
the contents of /etc/mdadm/mdadm.conf:

# mdadm.conf
#
# Please refer to mdadm.conf(5) for information about this file.
#

# by default, scan all partitions (/proc/partitions) for MD superblocks.
# alternatively, specify devices to scan, using wildcards if desired.
DEVICE partitions
DEVICE /dev/hda* /dev/sd[a-i]*

# auto-create devices with Debian standard permissions
CREATE owner=root group=disk mode=0660 auto=yes

# automatically tag new arrays as belonging to the local system
HOMEHOST <system>

# instruct the monitoring daemon where to send mail alerts
MAILADDR lrhorer@satx.rr.com

# definitions of existing MD arrays

# This file was auto-generated on Thu, 14 May 2009 20:25:57 -0500
# by mkconf $Id$
PROGRAM /usr/bin/mdadm_notify
ARRAY /dev/md0 level=raid5 metadata=1.2 num-devices=7
UUID=940ae4e4:04057ffc:5e92d2fb:63e3efb7 name='Backup':0
ARRAY /dev/md3 level=raid1 num-devices=2 metadata=01.02 name='Backup':3
UUID=3615c4a2:33786b6d:b13863d9:458cd054
ARRAY /dev/md2 level=raid1 num-devices=2 metadata=01.02 name='Backup':2
UUID=d45ff663:9e53774c:6fcf9968:21692025
ARRAY /dev/md1 level=raid1 num-devices=2 metadata=01.00 name='Backup':1
UUID=d6a2c60b:7345e957:05aefe0b:f8d1527f

	And here are the contents of the /boot/grub/menu.lst file:

# menu.lst - See: grub(8), info grub, update-grub(8)
#            grub-install(8), grub-floppy(8),
#            grub-md5-crypt, /usr/share/doc/grub
#            and /usr/share/doc/grub-legacy-doc/.

## default num
# Set the default entry to the entry number NUM. Numbering starts from 0,
and
# the entry number 0 is the default if the command is not used.
#
# You can specify 'saved' instead of a number. In this case, the default
entry
# is the entry saved with the command 'savedefault'.
# WARNING: If you are using dmraid do not change this entry to 'saved' or
your
# array will desync and will not let you boot your system.
default         0

## timeout sec
# Set a timeout, in SEC seconds, before automatically booting the default
entry
# (normally the first entry defined).
timeout         5

# Pretty colours
color cyan/blue white/blue

## password ['--md5'] passwd
# If used in the first section of a menu file, disable all interactive
editing
# control (menu entry editor and command-line)  and entries protected by the
# command 'lock'
# e.g. password topsecret
#      password --md5 $1$gLhU0/$aW78kHK1QfV3P2b2znUoe/
# password topsecret

#
# examples
#
# title         Windows 95/98/NT/2000
# root          (hd0,0)
# makeactive
# chainloader   +1
#
# title         Linux
# root          (hd0,1)
# kernel        /vmlinuz root=/dev/hda2 ro
#

#
# Put static boot stanzas before and/or after AUTOMAGIC KERNEL LIST

### BEGIN AUTOMAGIC KERNELS LIST
## lines between the AUTOMAGIC KERNELS LIST markers will be modified
## by the debian update-grub script except for the default options below

## DO NOT UNCOMMENT THEM, Just edit them to your needs

## ## Start Default Options ##
## default kernel options
## default kernel options for automagic boot options
## If you want special options for specific kernels use kopt_x_y_z
## where x.y.z is kernel version. Minor versions can be omitted.
## e.g. kopt=root=/dev/hda1 ro
##      kopt_2_6_8=root=/dev/hdc1 ro
##      kopt_2_6_8_2_686=root=/dev/hdc2 ro
# kopt=root=/dev/hda2 ro

## default grub root device
## e.g. groot=(hd0,0)
# groot=(hd0,0)

## should update-grub create alternative automagic boot options
## e.g. alternative=true
##      alternative=false
# alternative=true

## should update-grub lock alternative automagic boot options
## e.g. lockalternative=true
##      lockalternative=false
# lockalternative=false

## additional options to use with the default boot option, but not with the
## alternatives
## e.g. defoptions=vga=791 resume=/dev/hda5
# defoptions=quiet

## should update-grub lock old automagic boot options
## e.g. lockold=false
##      lockold=true
# lockold=false

## Xen hypervisor options to use with the default Xen boot option
# xenhopt=

## Xen Linux kernel options to use with the default Xen boot option
# xenkopt=console=tty0

## altoption boot targets option
## multiple altoptions lines are allowed
## e.g. altoptions=(extra menu suffix) extra boot options
##      altoptions=(single-user) single
# altoptions=(single-user mode) single

## controls how many kernels should be put into the menu.lst
## only counts the first occurence of a kernel, not the
## alternative kernel options
## e.g. howmany=all
##      howmany=7
# howmany=all

## should update-grub create memtest86 boot option
## e.g. memtest86=true
##      memtest86=false
# memtest86=true

## should update-grub adjust the value of the default booted system
## can be true or false
# updatedefaultentry=false

## should update-grub add savedefault to the default options
## can be true or false
# savedefault=false

## ## End Default Options ##

title           Debian GNU/Linux, kernel 2.6.26-1-amd64  Disk 1
root            (hd0,0)
kernel          /vmlinuz-2.6.26-1-amd64 root=/dev/md2 ro quiet
initrd          /initrd.img-2.6.26-1-amd64

title           Debian GNU/Linux, kernel 2.6.26-1-amd64  Disk 2
root            (hd11,0)
kernel          /vmlinuz-2.6.26-1-amd64 root=/dev/md2 ro quiet
initrd          /initrd.img-2.6.26-1-amd64


title           Debian GNU/Linux, kernel 2.6.26-1-amd64 (single-user mode)
root            (hd0,0)
kernel          /vmlinuz-2.6.26-1-amd64 root=/dev/hda2 ro single
initrd          /initrd.img-2.6.26-1-amd64

### END DEBIAN AUTOMAGIC KERNELS LIST

