From: "Timothy D. Lenz" <tlenz@vorgon.com>
Subject: Re: Converting system to raid
Date: Sat, 11 Apr 2009 17:53:04 -0700
Message-ID: <001201c9bb09$3161e9d0$0a00a8c0@vorg>
References: <003801c9b96d$21a0f420$0a00a8c0@vorg> <49DF0D06.8030705@musmo.com> <20090410195303.GB21242@cthulhu.home.robinhill.me.uk> <00cc01c9ba1d$3aefecf0$0a00a8c0@vorg> <20090410205942.GC21242@cthulhu.home.robinhill.me.uk> <00f301c9ba23$032025f0$0a00a8c0@vorg> <20090410215129.GD21242@cthulhu.home.robinhill.me.uk> <019701c9ba66$aeed5630$0a00a8c0@vorg> <f19d625d0904110729y30e8bc80m41fcd8f2c3298d49@mail.gmail.com> <007001c9bad6$2525c610$0a00a8c0@vorg>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I used a grml x86-64 boot cd and it seemed to create hda as sdc. I mounted sdc1 and md0 to /mnt and used:

rsync -cavHh --progress --delete /mnt/sdc1 /mnt/md0

After rebooting back to hda1 I changed fstab to put root on /dev/md0 and changed menu.lst on /mnt/md0. Rebooted and moved the ide to
the bottom of the boot list in cmos so the 2 sata drives are listed first. It seems to have booted to md0 ok. Now I need to confirm
everything is set correct.

Before when at the grub boot menu when booting with the ide moved below the sata drives, droping to command line for grub showed
that the ide drive only moved down 1, not 2. It seemed to have:
  hd0 = sda
  hd1 = hda
  hd2 = sdb

Now with the array booted, going to the grub command line and using auto complete for "root (hd0," it seems to be using the device
map at this point which is no longer correct:
(hd0) /dev/hda
(hd1) /dev/sda
(hd2) /dev/sdb

Note that in the other system, because linux was installed with only the ide and 1 sata drive, it doesn't even list the other two in
it's device map. So what is the best/safest way to update/correct this to what ever it should be?
=============================================

Moving swap:
I have used "sudo mkswap /dev/md1" so if I read info correct, I should be able to just change fstab:
  /dev/md1       none            swap    sw              0       0

and reboot to start using md1 array for swap?
=============================================
menu.lst updates:
The guides all call for assorted changes to menu.lst Some of the guides call for adding the line savedefault to kernel entries but
the people in #grub said not to do that with a raid system as it would corrupt the array and I thought I saw something about that
reading about grub but can't find it.

Some guides call for adding "fallback 1" after "default 0". And all call for adding duplicating the first kernel entry but changing
root to (1,0) for the second entry. But some have said it's not needed. Sorry of some of these questions have been answered before,
But I want to make sure everything is updated/corrected as needed before moving on to the other stuff I need to do. Don't want to
get nearly done and have a nasty suprise down the road or the next time I build/install a new kernel because something was missed.

menu.lst as it is now:
# menu.lst - See: grub(8), info grub, update-grub(8)
#            grub-install(8), grub-floppy(8),
#            grub-md5-crypt, /usr/share/doc/grub
#            and /usr/share/doc/grub-legacy-doc/.

## default num
# Set the default entry to the entry number NUM. Numbering starts from 0, and
# the entry number 0 is the default if the command is not used.
#
# You can specify 'saved' instead of a number. In this case, the default entry
# is the entry saved with the command 'savedefault'.
# WARNING: If you are using dmraid do not change this entry to 'saved' or your
# array will desync and will not let you boot your system.
default  0

## timeout sec
# Set a timeout, in SEC seconds, before automatically booting the default entry
# (normally the first entry defined).
timeout  5

# Pretty colours
color cyan/red yellow/black

## password ['--md5'] passwd
# If used in the first section of a menu file, disable all interactive editing
# control (menu entry editor and command-line)  and entries protected by the
# command 'lock'
# e.g. password topsecret
#      password --md5 $1$gLhU0/$aW78kHK1QfV3P2b2znUoe/
# password topsecret

#
# examples
#
# title  Windows 95/98/NT/2000
# root  (hd0,0)
# makeactive
# chainloader +1
#
# title  Linux
# root  (hd0,1)
# kernel /vmlinuz root=/dev/hda2 ro
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
# kopt=root=/dev/md0 ro

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

title  Debian GNU/Linux, kernel 2.6.26.8.20090311.1
root  (hd0,0)
kernel  /boot/vmlinuz-2.6.26.8.20090311.1 root=/dev/md0 ro quiet

title  Debian GNU/Linux, kernel 2.6.26.8.20090311.1 (single-user mode)
root  (hd0,0)
kernel  /boot/vmlinuz-2.6.26.8.20090311.1 root=/dev/md0 ro single

title  Debian GNU/Linux, kernel 2.6.26-1-686
root  (hd0,0)
kernel  /boot/vmlinuz-2.6.26-1-686 root=/dev/hda1 ro quiet
initrd  /boot/initrd.img-2.6.26-1-686

title  Debian GNU/Linux, kernel 2.6.26-1-686 (single-user mode)
root  (hd0,0)
kernel  /boot/vmlinuz-2.6.26-1-686 root=/dev/hda1 ro single
initrd  /boot/initrd.img-2.6.26-1-686

### END DEBIAN AUTOMAGIC KERNELS LIST

