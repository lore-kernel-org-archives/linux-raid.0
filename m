From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: Bootable Raid-1
Date: Tue, 1 Feb 2011 14:43:13 -0600
Message-ID: <8B.08.07087.360784D4@cdptpa-omtalb.mail.rr.com>
References: <4D486B2B.6030609@faccat.br>
Reply-To: <lrhorer@satx.rr.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D486B2B.6030609@faccat.br>
Sender: linux-raid-owner@vger.kernel.org
To: naira@faccat.br, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> I have read several articles on the internet and researched in the
> messages list, but I'm still having trouble configuring a raid level 1
> array that is bootable.
> 
> I configured a server some time agowith Gentoo Linux, Kernel
> 2.6.28-hardened-r9, mdadm - v3.0 and 2 IDE hard drives, this is working
> correctly. For this installation iused as a basis for consultation
> Article http://en.gentoo-wiki.com/wiki/Migrate_to_RAID
> 
> Now, I want to use two SATA drives in raid level 1,
> 
> Now i have Gentoo Linux with kernel  2.6.36-hardened-r6 and mdadm -
> v3.1.4 and the instructions of Article dont work. The kernel was
> configured with support for disks raid autodetect and supported the raid
> level 1. But in the logs of dmesg does not run the auto-detection of the
> disks to the array, so in the boot when mounting the root device /
> dev/md2 the system can not find the device.
> 
> When I run mdadm - auto-detect the array are found somewhere but still
> displays message indicating that the raid device is not a valid
> partition table.
> 
> How can you configure a raid level 1 with bootable disks / dev / sda and
> / dev / sdb?
> I want three partitions:
>      /dev/md1  - swap  - /dev/sda1, /dev/sdb1
>      /dev/md2  - boot   - /dev/sda2, /dev/sdb2
>      /dev/md3  - / - /dev/sda3, /dev/sdb3
> 
> I am using grub as bootloader.

	This is very similar to my boot configuration on my two servers.  I
suspect your problem is the metadata.  What version of superblock are you
using for /dev/md2?  GRUB2 does not recognize a version 1.x superblock.
Since the boot images are quite small, and don't require an array of many
disks, there is nothing wrong with the 0.90 superblock, however.  If your
/dev/md2 array is not a 0.9 version superblock, try converting it.  Here is
my configuration from one of the servers:

ARRAY /dev/md0 level=raid6 num-devices=10 metadata=01.2 name=Backup:0
UUID=431244d6:45d9635a:e88b3de5:92f30255
ARRAY /dev/md1 level=raid1 num-devices=2 metadata=0.90
UUID=4cde286c:0687556a:4d9996dd:dd23e701
ARRAY /dev/md2 level=raid1 num-devices=2 metadata=01.2 name=Backup:2
UUID=d45ff663:9e53774c:6fcf9968:21692025
ARRAY /dev/md3 level=raid1 num-devices=2 metadata=01.2 name=Backup:3
UUID=51d22c47:10f58974:0b27ef04:5609d357

	Where md0 is a large (11T) data array, md1 is boot, md2 is root, and
md3 is swap.  The partitioning layout of the boot drives is the same as
yours.

