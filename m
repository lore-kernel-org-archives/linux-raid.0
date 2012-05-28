From: Jeff Johnson <jeff.johnson@aeoncomputing.com>
Subject: Recovering from two raid superblocks on the same disks
Date: Mon, 28 May 2012 00:14:55 -0700
Message-ID: <4FC325EF.4020103@aeoncomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Greetings,

I am looking at a very unique situation and trying to successfully 1TB 
of very critical data.

The md raid in question is a 12-drive RAID-10 sitting between two 
identical nodes via a shared SAS link. Originally the 12 drives were 
configured as two six drive RAID-10 volumes using the entire disk device 
(no partitions on member drives). That configuration was later scrapped 
in favor of a single 12-drive RAID-10 but in this configuration a single 
partition was created and the partition was used as the RAID member 
device instead of the entire disk (sdb1 vs sdb).

One of the systems had the old two six-drive RAID-10 mdadm.conf file 
left in /etc. Due to a power outage both systems went down and then 
rebooted. When one system, the one with the old mdadm.conf file, came up 
md referenced the file, saw the intact old superblocks at the beginning 
of the drive and started an assemble and resync of those two six-drive 
RAID-10 volumes. The resync process got to 40% before it was stopped.

The other system managed to enumerate the drives and see the partition 
maps prior to the other node assembling the old superblock config. I can 
still see the newer md superblocks that start on the partition boundary 
rather than the beginning of the physical drive.

It appears that md overwrite protection was in a way circumvented by the 
old superblocks matching the old mdadm.conf file and not seeing 
conflicting superblocks at the beginning of the partition boundaries.

Both versions, old and new, were RAID-10. It appears that the errant 
resync of the old configuration didn't corrupt the newer RAID config 
since the drives were allocated in the same order and the same drives 
were paired (mirrors) in both old and new configs. I am guessing that 
since the striping method was RAID-0 the absence of stripe parity to 
check kept the data on the drives from being corrupted. This is 
conjecture on my part.

Old config:
RAID-10, /dev/md0, /dev/sd[bcdefg]
RAID-10, /dev/md1, /dev/sd[hijklm]

New config:
RAID-10, /dev/md0, /dev/sd[bcdefghijklm]1

It appears that the old superblock remained in that ~17KB gap between 
physical start of disk and the start boundary of partition 1 where the 
new superblock was written.

I was able to still see the partitions on the other node. I was able to 
read the new config superblocks from 11 of the 12 drives. UUIDs, state, 
all seem to be correct.

Three questions:

1) Has anyone seen a situation like this before?
2) Is it possible that since the mirrored pairs were allocated in the 
same order that the data was not overwritten?
3) What is the best way to assemble and run a 12-drive RAID-10 with 
member drive 0 (sdb1) seemingly blank (no superblock)?

The current state of the 12-drive volume is:  (note: sdb1 has no 
superblock but the drive is physically fine)

/dev/sdc1:
           Magic : a92b4efc
         Version : 0.90.00
            UUID : 852267e0:095a343c:f4f590ad:3333cb43
   Creation Time : Tue Feb 14 18:56:08 2012
      Raid Level : raid10
   Used Dev Size : 586059136 (558.91 GiB 600.12 GB)
      Array Size : 3516354816 (3353.46 GiB 3600.75 GB)
    Raid Devices : 12
   Total Devices : 12
Preferred Minor : 0

     Update Time : Sat May 26 12:05:11 2012
           State : clean
  Active Devices : 12
Working Devices : 12
  Failed Devices : 0
   Spare Devices : 0
        Checksum : 21bca4ce - correct
          Events : 26

          Layout : near=2
      Chunk Size : 32K

       Number   Major   Minor   RaidDevice State
this     1       8       33        1      active sync   /dev/sdc1

    0     0       8       17        0      active sync
    1     1       8       33        1      active sync   /dev/sdc1
    2     2       8       49        2      active sync   /dev/sdd1
    3     3       8       65        3      active sync   /dev/sde1
    4     4       8       81        4      active sync   /dev/sdf1
    5     5       8       97        5      active sync   /dev/sdg1
    6     6       8      113        6      active sync   /dev/sdh1
    7     7       8      129        7      active sync   /dev/sdi1
    8     8       8      145        8      active sync   /dev/sdj1
    9     9       8      161        9      active sync   /dev/sdk1
   10    10       8      177       10      active sync   /dev/sdl1
   11    11       8      193       11      active sync   /dev/sdm1

I could just run 'mdadm -A --uuid=852267e0095a343cf4f590ad3333cb43 
/dev/sd[bcdefghijklm]1 --run' but I feel better seeking advice and 
consensus before doing anything.

I have never seen a situation like this before. It seems like there 
might be one correct way to get the data back and many ways of losing 
the data for good. Any advice or feedback is greatly appreciated!

--Jeff

-- 
------------------------------
Jeff Johnson
Manager
Aeon Computing

jeff.johnson@aeoncomputing.com
www.aeoncomputing.com
t: 858-412-3810 x101   f: 858-412-3845
m: 619-204-9061

4905 Morena Boulevard, Suite 1313 - San Diego, CA 92117

