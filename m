From: Steve Kwee <skwee@itw.de>
Subject: Re: raid1 boots with one disk only
Date: Mon, 7 Mar 2005 16:04:42 +0000 (UTC)
Message-ID: <loom.20050307T165958-113@post.gmane.org>
References: <2263802DEDF02046B82EB18DE91725ED17A3E7@usahm236.amer.corp.eds.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Bailey, Scott <scott.bailey <at> eds.com> writes:

> 
> I think you need to tweak your kernel lines in /boot/grub/menu.lst to
> include the following clause:
> 
> 	md=1,/dev/sda2,/dev/sdc2
> 
> ...assuming I didn't misinterpret your configuration information.  You
> should be able to append this right onto the end of the existing options.
> This tells the RAID module explicitly to assemble device /dev/md1 from the
> listed physical devices.
> 
> This works fine for me on an x86 system at home and an alpha system at work.
> 
> 
> Cheers,
> 
> 	Scott
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo <at> vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 

Thank you for the hint, but unfortunatly it does not change the behaviour
I now boot with a grub entry like 1.)
But still get 2. in dmesg after boot.

As one can see md0 is fine while md1 is not. Does this possibly have something
to do with the fact that /dev/md1 is also used as the root device ?

1. /boot/grub/menu.lst
----------------------------------------------
title Ubuntu Linux (Kernel hd0, Root /dev/md1)
        kernel  (hd0,0)/vmlinuz-2.6.8.1-3-386 root=/dev/md1
md=1,/dev/hda2,/dev/hdc2 ro splash
        initrd  (hd0,0)/initrd.img-2.6.8.1-3-386
        savedefault
        boot


2. dmesg after boot
----------------------------------------------
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
hda: max request size: 128KiB
hda: 120103200 sectors (61492 MB) w/1916KiB Cache, CHS=65535/16/63, UDMA(33)
 /dev/ide/host0/bus0/target0/lun0: p1 p2 p3
hdc: IBM-DTLA-307060, ATA DISK drive
ide1 at 0x170-0x177,0x376 on irq 15
hdc: max request size: 128KiB
hdc: 120103200 sectors (61492 MB) w/1916KiB Cache, CHS=65535/16/63, UDMA(100)
 /dev/ide/host0/bus1/target0/lun0: p1 p2 p3
md: md1 stopped.
md: bind<hdc2>
raid1: raid set md1 active with 1 out of 2 mirrors
VFS: Can't find ext3 filesystem on dev md1.
VFS: Can't find ext2 filesystem on dev md1.
ReiserFS: md1: found reiserfs format "3.6" with standard journal
ReiserFS: md1: using ordered data mode
ReiserFS: md1: journal params: device md1, size 8192, journal first block 18,
max trans len 1024
, max batch 900, max commit age 30, max trans age 30
ReiserFS: md1: checking transaction log (md1)
ReiserFS: md1: Using r5 hash to sort names
Adding 2336536k swap on /dev/hda3.  Priority:-1 extents:1
mice: PS/2 mouse device common for all mice
parport: PnPBIOS parport detected.
parport0: PC-style at 0x378, irq 7 [PCSPP]
lp0: using parport0 (interrupt-driven).
Capability LSM initialized
device-mapper: 4.1.0-ioctl (2003-12-10) initialised: dm@uk.sistina.com
md: md0 stopped.
md: bind<hdc1>
md: bind<hda1>
raid1: raid set md0 active with 2 out of 2 mirrors
ReiserFS: md0: found reiserfs format "3.6" with standard journal
ReiserFS: md0: using ordered data mode
ReiserFS: md0: journal params: device md0, size 8192, journal first block 18,
max trans len 1024
, max batch 900, max commit age 30, max trans age 30
ReiserFS: md0: checking transaction log (md0)
ReiserFS: md0: Using r5 hash to sort names



