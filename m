From: Armen Babikyan <armenb@static.net>
Subject: overwrote boot sector, advice requested!
Date: Mon, 29 Nov 2004 13:38:01 -0500
Message-ID: <CC40D80C-4235-11D9-8E13-003065F94C4C@static.net>
Mime-Version: 1.0 (Apple Message framework v619)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I accidently hosed my RAID1 and 5 systems by overwriting the first 512 
bytes of each physical disk participating in the RAID.  Needless to 
say, I am past kicking myself in the pants, and am trying to retrieve 
my data and get my RAID1 and RAID5 disks functional again.  My setup 
was four 160GB IDE disks, indentical in size and partitioned 
identically (1024MB 0xfd, 256MB 0x82, rest of drive being 0xfd).  The 
1st partition was setup as RAID1 with 2 mirrors and 2 spares, and the 
3rd partition was setup as RAID5.

I noticed my array was broken when fsck tried checking my LVM disk, 
which had previously failed mount because the raid driver couldn't find 
RAID partitions.  So I regenerated the partition tables to (what I 
thought) were the actual sizes and locations of the partitions on the 
disk previously.  I recall choosing "nice" easy-to-remember numbers for 
the sizes of the physical partition (like 1024MB, 256MB, "rest of 
disk").  I use standard linux fdisk to partition drives.

I then edited my /etc/raidtab and changed all the "raid-disk" 
directives to "failed-disk" and ran "mkraid --force /dev/md0" to see 
what It would do.  Lo and behold, it failed to find the md superblock 
on each one of the four newly created partitions (one on each disk).  
This surprised me, because to my knowledge, nothing else on the disk 
had been overwritten:

# mkraid --really-force /dev/md0
DESTROYING the contents of /dev/md0 in 5 seconds, Ctrl-C if unsure!
handling MD device /dev/md0
analyzing super-block
disk 0: /dev/hde1, failed
disk 1: /dev/hdi1, failed
disk 2: /dev/hdg1, 102384kB, raid superblock at 102272kB
disk 3: /dev/hdk1, 102384kB, raid superblock at 102272kB
mkraid: aborted.
(In addition to the above messages, see the syslog and /proc/mdstat as 
well
  for potential clues.)
#

(afaict, you can ignore the 102384kB raid superblock markers...those 
were created in my first attempt at making a raid a couple months 
ago...I didnt bother zeroing the disks before remaking my raid 
partitions).  I am actually quite surprised that my ancient raid 
superblock from a 100MB partition coincidently ended up exactly where 
mkraid was looking for the raid superblock for my 1024MB partition!)

Though gpart and rescuept don't look for RAID partitions, I attempted 
using them anyway and found traces of my partitions all over the disks 
(I used ext3 on top of LVM on top of the RAID5).  I read 
linux-2.6.9/drivers/md/md.c and linux-2.6.9/include/linux/raid/md_p.h 
and modified rescuept to look for RAID superblocks.  I found them, and 
they were completely intact, and located in the "general" area of where 
I expected them to be (i.e. near the end of each physical partition).  
However, my attempts at trying to determine the exact location of the 
physical partition from the location of the raid superblock and the 
size of the "enclosed partition" (sb->size) has not given me much luck 
(I probably am making erroneous assumptions about where exactly the 
raid superblocks are located).

Is there any kind of software setting or tool that those in-the-know 
can recommend that I use for determining the locations of the physical 
partitions based on the location of the RAID superblock? (or anything 
else for that matter!)

The information on my RAID5 array is much more important to me than the 
data on my RAID1 array (used only to boot the RAID), so I have not 
attempted to use mkraid --force on /dev/md1 until I successfully 
retrieve data from /dev/md0. (It is not clear to me whether mkraid 
--force writes anything to the physical disk or not).

It doesn't feel like the time to throw in the towel and 
repartition/recreate my RAID, so any and all help and advice is greatly 
appreciated!

Thanks,

   - Armen

