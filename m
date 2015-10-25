From: andras@tantosonline.com
Subject: Re: How to recover after md crash during =?UTF-8?Q?reshape=3F?=
Date: Sun, 25 Oct 2015 09:15:52 -0500
Message-ID: <72dc24dd30c19517d19887d794fd341b@tantosonline.com>
References: <04cdcd6bd69b3aa1f8f24465f8485c90@tantosonline.com>
 <5626464D.9000502@turmel.org>
 <3baf849321d819483c5d20c005a31844@tantosonline.com>
 <562660EE.9020504@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <562660EE.9020504@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Phil,

Thanks for all the help. I finally have some progress (and new 
problems).

> Now to your big array.  It is vital that it also be cleaned of UREs
> after re-creation before you do anything else.  Which means it must
> *not* be created degraded (the redundancy is needed to fix UREs).
> 
> According to lsdrv and your "mdadm -E" reports, the creation order you
> need is:
> 
> raid device 0 /dev/sdf2 {WD-WMAZA0209553}
> raid device 1 /dev/sdd2 {WD-WMAZA0348342}
> raid device 2 /dev/sdg1 {9VS1EFFD}
> raid device 3 /dev/sde1 {5XW05FFV}
> raid device 4 /dev/sdc1 {6XW0BQL0}
> raid device 5 /dev/sdh1 {ML2220F30TEBLE}
> raid device 6 /dev/sdi2 {WD-WMAY01975001}
> 
> Chunk size is 64k.
> 
> Make sure your partially assembled array is stopped:
> 
> mdadm --stop /dev/md1
> 
> Re-create your array as follows:
> 
> mdadm --create --assume-clean --verbose \
>     --metadata=1.0 --raid-devices=7 --chunk=64 --level=6 \
>     /dev/md1 /dev/sd{f2,d2,g1,e1,c1,h1,i2}

Being very paranoid at this stage, instead of trying to re-create the 
array on the original drives, I dd-ed their content to a different set 
of (bigger) drives, and issued the command on them.
The array assembled fine:

md1 : active raid6 sdc2[6] sdd1[5] sdg1[4] sdb1[3] sdf1[2] sdh2[1] 
sda2[0]
       7325679040 blocks super 1.0 level 6, 64k chunk, algorithm 2 [7/7] 
[UUUUUUU]
       bitmap: 0/11 pages [0KB], 65536KB chunk

> Use "fsck -n" to check your array's filesystem (expect some damage at
> the very begining).  If it look reasonable, use fsck to fix any damage.

fsck -n run to completion but reported a ton of errors, mostly stemming 
from the initial (ext4) superblock being damaged.

     e2fsck 1.42.12 (29-Aug-2014)
     ext2fs_check_desc: Corrupt group descriptor: bad block for block 
bitmap
     fsck.ext4: Group descriptors look bad... trying backup blocks...
     Superblock needs_recovery flag is clear, but journal has data.
     Recovery flag not set in backup superblock, so running journal 
anyway.
     Clear journal? no

     The filesystem size (according to the superblock) is 1831419920 
blocks
     The physical size of the device is 1831419760 blocks
     Either the superblock or the partition table is likely to be 
corrupt!
     Abort? no

     data contains a file system with errors, check forced.
     Resize inode not valid.  Recreate? no

     Pass 1: Checking inodes, blocks, and sizes
     Inode 7 has illegal block(s).  Clear? no

     Illegal block #448536 (4285956422) in inode 7.  IGNORED.
     Illegal block #448537 (4292313414) in inode 7.  IGNORED.
     Illegal block #448538 (3675619654) in inode 7.  IGNORED.
     Illegal block #448539 (3686760774) in inode 7.  IGNORED.
     Illegal block #448541 (1880654150) in inode 7.  IGNORED.
     Illegal block #448542 (3636035910) in inode 7.  IGNORED.
     Illegal block #448543 (2516877638) in inode 7.  IGNORED.
     Illegal block #448544 (2920513862) in inode 7.  IGNORED.
     Illegal block #449560 (4285956537) in inode 7.  IGNORED.
     Illegal block #449561 (4292313529) in inode 7.  IGNORED.
     Illegal block #449562 (3675619769) in inode 7.  IGNORED.
     Too many illegal blocks in inode 7.
     Clear inode? no

     Suppress messages? no
     ...
     and so on...

So I issued the real fsck command. It interestingly reported a 
completely different set of issues, my guess is that after fixing the 
superblock, the inconsistencies that fsck -n was talking about went way, 
and the real ones started to show up. At any rate, now the file system 
seems to be clean, expect for this message:

     The filesystem size (according to the superblock) is 1831419920 
blocks
     The physical size of the device is 1831419760 blocks
     Either the superblock or the partition table is likely to be 
corrupt!

This problem prevents me from mounting the FS:

     mount -o ro /dev/md1 /mnt -v
     mount: wrong fs type, bad option, bad superblock on /dev/md1,
            missing codepage or helper program, or other error

            In some cases useful info is found in syslog - try
            dmesg | tail or so.

And dmesg reports:

     [ 5859.527778] EXT4-fs (md1): bad geometry: block count 1831419920 
exceeds size of device (1831419760 blocks)

So here I am right now. I can see a few paths forward, but first a 
question:

Why is it that the re-created MD device is different in size (ever so 
slightly) then the ext4 filesystem that it used to contain? I doubt it 
has anything to do with the grow operation as I didn't get far enough to 
actually resize the filesystem...

One side-effect of using different drives (and dd) is that the partition 
table is now misaligned with the new disk geometry. For example:

     fdisk -l /dev/sdb

     Disk /dev/sdb: 2.7 TiB, 3000592982016 bytes, 5860533168 sectors
     Units: sectors of 1 * 512 = 512 bytes
     Sector size (logical/physical): 512 bytes / 4096 bytes
     I/O size (minimum/optimal): 4096 bytes / 4096 bytes
     Disklabel type: dos
     Disk identifier: 0x3e6b39b9

     Device     Boot Start        End    Sectors  Size Id Type
     /dev/sdb1          63 2930272064 2930272002  1.4T fd Linux raid 
autodetect

     Partition 2 does not start on physical sector boundary.

Could this be the route cause?

Here's the sizes of all the other relevant partitions:

     /dev/sda2   976752064 3907029167 2930277104  1.4T fd Linux raid 
autodetect
     /dev/sdb1          63 2930272064 2930272002  1.4T fd Linux raid 
autodetect
     /dev/sdc2   976752064 3907029167 2930277104  1.4T fd Linux raid 
autodetect
     /dev/sdd1          63 3907024064 3907024002  1.8T fd Linux raid 
autodetect
     /dev/sdf1          63 2930272064 2930272002  1.4T fd Linux raid 
autodetect
     /dev/sdg1          63 2930272064 2930272002  1.4T fd Linux raid 
autodetect
     /dev/sdh2   976752064 3907029167 2930277104  1.4T fd Linux raid 
autodetect

If I look at the size reported by fdisk above, on a 7-disk raid6, with 
each partition of that size, I should have 1831420000 sectors available. 
I'm sure mdadm takes some sectors for management, but I don't know how 
much?

So, I thought of three ways of fixing it:
1. Re-create the array again, but this time force the array size to the 
one reported by the filesystem, using -size. What is the unit for -size? 
Is that bytes?
2. Re-create the array again, but this time use the original 
super-blocks version (0.91 I think). Could that make a difference in the 
size of the array?
3. Instead of DD-ing whole drives, dd just the raid6 partitions so the 
partition table is correct for the drives. Maybe the misalignment trips 
mdadm off and makes it to create the array in the incorrect size?

Thanks for all the help again,
Andras




