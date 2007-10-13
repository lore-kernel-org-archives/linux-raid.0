From: Marko Berg <marko.berg@iki.fi>
Subject: RAID 5: weird size results after Grow
Date: Sat, 13 Oct 2007 11:11:33 +0300
Message-ID: <47107DB5.10103@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi folks,

I added a fourth drive to a RAID 5 array. After some complications 
related to adding a new HD controller at the same time, and thus 
changing some device names, I re-created the array and got it working 
(in the sense "nothing degraded"). But size results are weird. Each 
component partition is 320 G, does anyone have an explanation for the 
"Used Dev Size" field value below? The 960 G total size is as it should 
be, but in practice Linux reports the array only having 625,019,608 
blocks. How can this be, even though the array should be clean with 4 
active devices?

$  mdadm -D /dev/md0
/dev/md0:
        Version : 01.02.03
  Creation Time : Sat Oct 13 01:25:26 2007
     Raid Level : raid5
     Array Size : 937705344 (894.27 GiB 960.21 GB)
  Used Dev Size : 625136896 (298.09 GiB 320.07 GB)
   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 0
    Persistence : Superblock is persistent
 
    Update Time : Sat Oct 13 05:11:38 2007
          State : clean
 Active Devices : 4
Working Devices : 4
 Failed Devices : 0
  Spare Devices : 0
 
         Layout : left-symmetric
     Chunk Size : 64K
 
           Name : 0
           UUID : 9bf903f8:7fc9eec1:2ff25011:37e9607b
         Events : 2
 
    Number   Major   Minor   RaidDevice State
       0     253        2        0      active sync   
/dev/VolGroup01/LogVol02
       1       8       33        1      active sync   /dev/sdc1
       2       8       49        2      active sync   /dev/sdd1
       3       8       17        3      active sync   /dev/sdb1


Results for mdadm -E <partition> on all devices appear like this one, 
with positions changed:

$ mdadm -E /dev/sdc1
/dev/sdc1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 9bf903f8:7fc9eec1:2ff25011:37e9607b
           Name : 0
  Creation Time : Sat Oct 13 01:25:26 2007
     Raid Level : raid5
   Raid Devices : 4
 
  Used Dev Size : 625137010 (298.09 GiB 320.07 GB)
     Array Size : 1875410688 (894.27 GiB 960.21 GB)
      Used Size : 625136896 (298.09 GiB 320.07 GB)
    Data Offset : 272 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 9b2037fb:231a8ebf:1aaa5577:140795cc
 
    Update Time : Sat Oct 13 10:56:02 2007
       Checksum : c729f5a1 - correct
         Events : 2
 
         Layout : left-symmetric
     Chunk Size : 64K
 
    Array Slot : 1 (0, 1, 2, 3)
   Array State : uUuu


Particularly, "Used Dev Size" and "Used Size" report an amount twice the 
size of the partition (and device). Array size is here twice the actual 
size, even though shown correctly within parentheses.

Finally, mdstat shows the block count as it should be.

$ cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4]
md0 : active raid5 sdb1[3] sdd1[2] sdc1[1] dm-2[0]
      937705344 blocks super 1.2 level 5, 64k chunk, algorithm 2 [4/4] 
[UUUU]
     
unused devices: <none>


Any suggestions on how to fix this, or what to investigate next, would 
be appreciated!

-- 
Marko
