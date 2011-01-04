From: Hank Barta <hbarta@gmail.com>
Subject: RAID for USB flash drives
Date: Tue, 4 Jan 2011 13:40:53 -0600
Message-ID: <AANLkTi=kcbanFit5x27ccS_1RChxC=Dn+Hs4Ak+FbKsX@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi folks,
This is going to be one of those corner cases and I'm sure some of you
won't even think it a good idea. But I won;t let that stop me from
asking your opinion.

I'm building a NAS based on a micro-ATX Atom based board (D525MW.) The
board has two SATA ports to which I will attach two mirrored 2TB
drives form another system. There are 8 USB ports but no other ports
to which to attach a boot drive and I had not partitioned the 2 TB
drives for another partition. Rather than muck with them, I sought USB
boot devices and found prior art on RAIDing USB devices. I purchased
4x 4GB USB flash drives for a grand total of $27 (US)

I plan to operate them as a stripe set. I'm not too concerned about
reliability, thinking that the USB drives should be pretty reliable if
thery're not subject to going through the wash in my pocket.

I've done some initial testing (on another PC) and found that striping
provides increasing performance even if all of the sticks are on the
same USB bus. That surprised me a bit because I expected the USB bus
to be a bottleneck, but that does not happen until there are several
USB devices active.

The particular items that I'd appreciate opinions on are the
parameters used to construct the RAID and file system. The guidance
I've used so far is found in the following two articles:
http://www.analogbit.com/node/4 http://www.analogbit.com/node/13 (I
would feel a lot better if the folks here agreed that their selections
made sense.)

First is partitioning. I used fdisk and default partitioning of one
primary partition:
===============================================================
root@cypress:~# fdisk -l -c -u /dev/sdb

Disk /dev/sdb: 4009 MB, 4009754624 bytes
8 heads, 4 sectors/track, 244736 cylinders, total 7831552 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0xf924b0d3

   Device Boot      Start         End      Blocks   Id  System
/dev/sdb1            2048     7831551     3914752   fd  Linux raid autodetect
===============================================================

Next will be to create the RAID using:
# mdadm --create /dev/md0 -e 0.9 -n 6 --chunk=64 --level=raid0 /dev/sd[abcd]1


For the file system I saw arguments for and against journaling
filesystems for SSD drives. I decided to go with EXT4

Recalculating from the formula in the second article:
'stride' size is numDevice*chunkSize/blockSize => 4*64K/4k => 64

# mkfs.ext4 /dev/md0 -b 4096 -E stride=64

I plan to add noatime to the mount options. (Would relatime be
better?) I also plan to put active directories like /tmp and /var/log
into RAM via tmpfs. I'll use an OS w/out graphics and have purchased a
2GB RAM stick. I don't plan to use any swap.

Alternatives? I could probably boot off the network but that would be
less interesting. ;) I could also use RAID5 over the 4 USB drives to
guard against a single drive failure. I did try that nut it seemed to
sacrifice some throughput.

OS will be Ubuntu Server 10.04 (LTS) 32 bit.

So... Anything you would do differently?

Thanks for your comments.

best,
hank

-- 
'03 BMW F650CS - hers
'98 Dakar K12RS - "BABY K" grew up.
'93 R100R w/ Velorex 700 (MBD starts...)
'95 Miata - "OUR LC"
polish visor: apply squashed bugs, rinse, repeat
Beautiful Sunny Winfield, Illinois
