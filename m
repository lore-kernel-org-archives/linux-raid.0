From: "christian (private)" <chr.graf@gmx.de>
Subject: corrupted UUID or superblock prohibits assemby of prior created raid6
Date: Sun, 02 May 2010 09:33:03 +0200
Message-ID: <4BDD2AAF.9070800@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Dear all,

I am kindly asking for help please.

The issue is the following:
I am creating an mdadm raid6-array and after successful sync all looks 
fine. However after rebooting the raid6 refuses to start due to missing 
disks.
To my understanding this is all related to incorrect UUID's, however I 
am kindly asking the experts to have alook into it:

The error-message (similiar for all my 1TB-drives /dev/sd[abi]1)
======================================
keeper:~# mdadm --assemble /dev/md10 /dev/sd[abi]1 /dev/md[1-3]
mdadm: cannot open device /dev/sda1: Device or resource busy
mdadm: /dev/sda1 has no superblock - assembly aborted


systems basics
==========
keeper:~# uname -a
Linux keeper 2.6.30-2-amd64 #1 SMP Fri Dec 4 03:31:05 UTC 2009 x86_64 
GNU/Linux

distro: debian testing

ii  mdadm                                                   
3.0.3-2                    tool to administer Linux MD arrays (software
ii  e2fslibs                                                
1.41.11-1                  ext2/ext3/ext4 file system libraries
ii  e2fsprogs                                               
1.41.11-1                  ext2/ext3/ext4 file system utilities



creating the array (hint, after reboot its /dev/sd[abi]1 instead of 
/dev/sdb1 /dev/sdc1 /dev/sdi1)
===========================================================
387  mdadm --create /dev/md10 --name=10 --metadata=1.0  --level=6 
--raid-devices=6 /dev/sdb1 /dev/sdc1 /dev/sdi1 /dev/md[1-3]

the array gets created  - verifying after resync without  rebooting
=========================================
/dev/md10:
         Version : 1.00
   Creation Time : Sat May  1 19:41:39 2010
      Raid Level : raid6
      Array Size : 3907039232 (3726.04 GiB 4000.81 GB)
   Used Dev Size : 976759808 (931.51 GiB 1000.20 GB)
    Raid Devices : 6
   Total Devices : 6
     Persistence : Superblock is persistent

     Update Time : Sun May  2 03:44:29 2010
           State : active
  Active Devices : 6
Working Devices : 6
  Failed Devices : 0
   Spare Devices : 0

      Chunk Size : 64K

            Name : keeper:10  (local to host keeper)
*UUID : d9b9e76d:0113d173:39173474:7f43de08*
          Events : 35

     Number   Major   Minor   RaidDevice State
        0       8       17        0      active sync   /dev/sdb1
        1       8       33        1      active sync   /dev/sdc1
        2       8      129        2      active sync   /dev/sdi1
        3       9        1        3      active sync   /dev/md1
        4       9        2        4      active sync   /dev/md2
        5       9        3        5      active sync   /dev/md3


keeper:~# cat /proc/mdstat
This is looking fine as well
==================
Personalities : [raid6] [raid5] [raid4] [multipath] [faulty] [raid0]
md10 : active raid6 md3[5] md2[4] md1[3] sdi1[2] sdc1[1] sdb1[0]
       3907039232 blocks super 1.0 level 6, 64k chunk, algorithm 2 [6/6] 
[UUUUUU]

md1 : active raid0 sdf1[0] sdg1[1]
       976767872 blocks 64k chunks

md2 : active raid0 sdh1[1] sda1[0]
       976767872 blocks 64k chunks

md3 : active raid0 sdd1[1] sde1[0]
       976767872 blocks 64k chunks


To my understanding all member-drives of md10 should have the same UUID, 
but after a reboot this is not any longer the case. Please notice that I 
created the array with "/dev/sd[bci]1 /dev/md[1-3]" and after reboot its 
/dev/sd[abi]1 and /dev/md[1-3].
But as you can see, the UUID's are not identical anyhow:
=============================================================
keeper:~# blkid
/dev/hda1: UUID="3A60F2845E1B3C0F" TYPE="ntfs"
/dev/hda2: UUID="e9a9b276-0530-42eb-8317-cd3999ff8b90" TYPE="swap"
/dev/hda3: UUID="738eeb2f-fae4-40a0-b0de-fc188837e44c" TYPE="ext3"
/dev/sdb1: UUID="d9b9e76d-0113-d173-3917-34747f43de08" LABEL="keeper:10" 
TYPE="linux_raid_member" << looks good
/dev/sdc1: UUID="f45cfa44-1770-7e1c-3e3a-de9f30eaa984" 
TYPE="linux_raid_member" LABEL="keeper:10"
/dev/sdd1: UUID="f45cfa44-1770-7e1c-3e3a-de9f30eaa984" 
TYPE="linux_raid_member" LABEL="keeper:11"
/dev/sde1: UUID="0805c25a-cf77-4fb6-3e3a-de9f30eaa984" 
TYPE="linux_raid_member"
/dev/sdf1: UUID="0805c25a-cf77-4fb6-3e3a-de9f30eaa984" 
TYPE="linux_raid_member"
/dev/sdg1: UUID="13d13245-3c7d-8682-3e3a-de9f30eaa984" 
TYPE="linux_raid_member"
/dev/sdh1: UUID="13d13245-3c7d-8682-3e3a-de9f30eaa984" 
TYPE="linux_raid_member"
/dev/sdi1: UUID="d9b9e76d-0113-d173-3917-34747f43de08" 
TYPE="linux_raid_member" LABEL="keeper:10" << looks good
/dev/sda1: UUID="c6f73dbb-528d-aa64-3e3a-de9f30eaa984" 
TYPE="linux_raid_member" << should be *d9b9e76d:0113d173:39173474:7f43de08*
/dev/md1: UUID="058e47cd-e3ff-0fb9-3e3a-de9f30eaa984" 
TYPE="linux_raid_member" << should be *d9b9e76d:0113d173:39173474:7f43de08*
/dev/md2: UUID="058e47cd-e3ff-0fb9-3e3a-de9f30eaa984" 
TYPE="linux_raid_member" << should be *d9b9e76d:0113d173:39173474:7f43de08*
/dev/md3: UUID="058e47cd-e3ff-0fb9-3e3a-de9f30eaa984" 
TYPE="linux_raid_member" << should be *d9b9e76d:0113d173:39173474:7f43de08*


Can please anyone help me digging out whats going on here?

What I can say, that if I create 2 * raid5 (/dev/sd[abi]1 and 
/dev/md[1-3]) instead of combining them into a single raid6, then all is 
perfect.
Maybe I should say, that /dev/md[1-3] are 2* striped 500G disks and 
/dev/sd[abi]1 are 1TB drives.


any help is very much appreciated. The next step I am doing is manually 
setting the UUID to have it matched...


further more I thoughts setting the UUID manually could solve the issue

keeper:~# tune2fs -U d9b9e76d-0113-d173-3917-34747f43de08 /dev/sda1
tune2fs 1.41.11 (14-Mar-2010)
tune2fs: Filesystem revision too high while trying to open /dev/sda1
Couldn't find valid filesystem superblock. <<< does not look good to me


keeper:~# fdisk -l /dev/sda

Disk /dev/sda: 1000.2 GB, 1000204886016 bytes
255 heads, 63 sectors/track, 121601 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes
Disk identifier: 0x00000000

    Device Boot      Start         End      Blocks   Id  System
/dev/sda1               1      121601   976760001   83  Linux

keeper:~# blkid /dev/sda
keeper:~# blkid /dev/sda1
/dev/sda1: UUID="c6f73dbb-528d-aa64-3e3a-de9f30eaa984" 
TYPE="linux_raid_member"

keeper:~# tune2fs -l /dev/sda1
tune2fs 1.41.11 (14-Mar-2010)
tune2fs: Filesystem revision too high while trying to open /dev/sda1
Couldn't find valid filesystem superblock.


Any idea why the superblock is giving me trouble here?


many thanks

christian





