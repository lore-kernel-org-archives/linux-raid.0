From: Steve Kwee <skwee@itw.de>
Subject: Re: raid1 boots with one disk only
Date: Fri, 4 Mar 2005 14:51:04 +0000 (UTC)
Message-ID: <loom.20050304T154438-950@post.gmane.org>
References: <42286A2C.9010206@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Christian Mueller <christian.mueller1 <at> gmx.de> writes:

> 
> Hi Steve!
> 
> How do you boot this beast (Bootloader)?
> On what partition/md is actually /boot?
> 
> On 03.04.2005 12:03, Steve Kwee wrote:
> > ..
> > mdadm -E results in an error message complaining about a missing
> > superblock (see 4.)
> > ..
> > -----------------------------
> > 4.  mdadm -E /dev/md1
> > -----------------------------
> > mdadm: No super block found on /dev/md1 (Expected magic a92b4efc, got
> > f1800828)
> 'man mdadm' shows the following
> 
>   -E, --examine
>          Print content of md superblock on device(s).
>                                            ^^^^^^^^^
> So, this works not against an md array.
> 
> Cheers, Chris
> 

There is another raid device /dev/md0 on the same set of disks
which has the kernel on it. The kernel is booted with grub 
/dev/md0 works as expected /dev/md1 does not.
I have attached fstab and menu.lst (1., 2.)

I followed the description found at 

  http://nickdafish.com/public/HowToRaid

to set things up.

------------------------------------------------------
1. /etc/fstab
-----------------------------------------------
# /etc/fstab: static file system information.
#
# <file system> <mount point>   <type>  <options>       <dump>  <pass>
proc            /proc           proc    defaults        0       0
/dev/hda3       none            swap    sw              0       0
/dev/md0        /boot           reiserfs defaults        0       2
/dev/md1        /               reiserfs defaults        0       2

------------------------------------------------------
2. less /boot/grub/menu.lst
------------------------------------------------------
timeout 8

# By default, boot the first entry.
default 0

# Fallback to the second entry.
fallback 1

# raid
##########################################
title Ubuntu Linux (Kernel hd0, Root /dev/md1)
        kernel  (hd0,0)/vmlinuz-2.6.8.1-3-386 root=/dev/md1 ro splash
        initrd  (hd0,0)/initrd.img-2.6.8.1-3-386
        savedefault
        boot

title Ubuntu Linux (Kernel hd1, Root /dev/md1)
        kernel  (hd1,0)/vmlinuz-2.6.8.1-3-386 root=/dev/md1 ro splash
        initrd  (hd1,0)/initrd.img-2.6.8.1-3-386
        savedefault
        boot

# single user
##########################################
title Ubuntu Linux single (Kernel hd0, Root /dev/md1)
        kernel  (hd0,0)/vmlinuz-2.6.8.1-3-386 root=/dev/md1 ro single
        initrd  (hd0,0)/initrd.img-2.6.8.1-3-386
        savedefault
        boot

title Ubuntu Linux single (Kernel hd1, Root /dev/md1)
        kernel  (hd1,0)/vmlinuz-2.6.8.1-3-386 root=/dev/md1 ro single
        initrd  (hd1,0)/initrd.img-2.6.8.1-3-386
        savedefault
        boot


