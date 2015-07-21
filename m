From: Jimmie Mayfield <jimmie@sackheads.org>
Subject: MDADM RAID5 mismatch_cnt > 0.  Any way to identify which blocks disagree?
Date: Tue, 21 Jul 2015 13:28:00 -0400
Message-ID: <55AE8120.3090505@sackheads.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi.  After a routine weekly scrub of my 4-drive RAID5 array, MDADM is 
reporting mismatch_cnt = 16.  As I understand, this means that while no 
device reported a read error, there are 16 blocks for which the data and 
parity do not agree.

(I should mention that I've only run the scrub with the 'check' option 
since 'repair' seems dangerous in cases like this where MDADM doesn't 
know whether the data or the parity is lying)

Question #1: Near as I can tell, the only log output from the scrub 
operation occurs when it begins and completes.  Can one obtain the list 
of blocks that disagree?  If this were RAID1, I suppose I could take the 
array offline and cmp drive #1 against drive #2.  Is there an analog for 
RAID5?

Question #2: (I realize this is probably the wrong mailing list for this 
question) Assuming #1 is possible and given that the filesystem sitting 
on top of the array is EXT4, is it possible to identify the files 
associated with these blocks?  I do have nearline backups and, in an 
ideal world, I could just cmp the live array against the backup data to 
identify corrupted files but the reality is recalling several TB of 
backups would be both slow and expensive.  Knowing where to look and 
what might need to be recovered would help immensely.

Question #3: Let's say I tell MDADM to repair these blocks.  Since MDADM 
doesn't know whether data or parity is correct, I figure at least some 
of these repaired blocks will be wrong.  Let's say at that point I fsck 
the filesystem and use the answer to question #2 to identify and restore 
any files that are still corrupt.  Should I be concerned about 
incorrectly-repaired blocks that don't correspond to files?  Presumably, 
a successful fsck will ensure that the filesystem itself is consistent 
but are there any other lurking time bombs?  I assume that an 
incorrectly-repaired block corresponding to unused space within the 
filesystem is of no concern since the block will be rewritten once it's 
allocated for a file?

Relevant info:
OS: CentOS 6.6 (kernel 2.6.32-504.23.4.el6.centos.plus.x86_64)

/dev/md0:
         Version : 1.1
   Creation Time : Tue Jun  7 17:12:55 2011
      Raid Level : raid5
      Array Size : 5860535808 (5589.04 GiB 6001.19 GB)
   Used Dev Size : 1953511936 (1863.01 GiB 2000.40 GB)
    Raid Devices : 4
   Total Devices : 4
     Persistence : Superblock is persistent

   Intent Bitmap : Internal

     Update Time : Tue Jul 21 13:24:14 2015
           State : active
  Active Devices : 4
Working Devices : 4
  Failed Devices : 0
   Spare Devices : 0

          Layout : left-symmetric
      Chunk Size : 512K

            Name : raiden:0
            UUID : d40a8260:a62151d3:4949844a:2a0cfc53
          Events : 141606

     Number   Major   Minor   RaidDevice State
        0       8       65        0      active sync   /dev/sde1
        1       8       33        1      active sync   /dev/sdc1
        2       8       49        2      active sync   /dev/sdd1
        4       8       17        3      active sync   /dev/sdb1

Apologies if my questions seem naive.


