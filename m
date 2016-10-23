From: Dan Kortschak <dan.kortschak@adelaide.edu.au>
Subject: query re: resync not persisting over reboot in rescue mode
Date: Mon, 24 Oct 2016 10:20:40 +1030
Message-ID: <1477266640.7137.13.camel@adelaide.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

First, I'll start with an apology - I have little (~nothing) in the way
of hard data to back up this question, but it is now just a matter of
personal interest as the problem appears to be fixed.


Background:

Last week I tried to upgrade a kernel (ubuntu distro 16.04) but that
failed due to out of space (the system was originally built when
kernels were much smaller and I have now got to the point where it is
not possible to have two kernels on the /boot partitian).

On reboot the boot failed with a great deal of disk noise which
persisted. Booting into recovery worked, and the noise was now knowable
to be coming from a RAID resync of /dev/md0 (RAID10) after I dropped
into a root shell. I allowed this to complete and then went back to
resume the normal boot. This failed as before.

Repeating the process above, I found that the RAID was again unsynced
an doing a resync.

This has now resolved - I again allowed the resync to complete and then
did a /sbin/reboot from the CLI rather than going back to the recovery
menu and continuing the boot from the menu.


Question:

What is a/are likely cause(s) for a resync to not persist over a
reboot?


Thanks and apologies for the dearth of information (if more will be
helpful I can add in a follow-up, but since the RAID is now working I
am not sure what will be helpful).

Dan


Current detail (now all working):

$ sudo mdadm --detail /dev/md0
/dev/md0:
        Version : 0.90
  Creation Time : Tue Sep 29 17:41:02 2009
     Raid Level : raid10
     Array Size : 974558208 (929.41 GiB 997.95 GB)
  Used Dev Size : 974558208 (929.41 GiB 997.95 GB)
   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 0
    Persistence : Superblock is persistent

    Update Time : Mon Oct 24 09:47:52 2016
          State : active 
 Active Devices : 4
Working Devices : 4
 Failed Devices : 0
  Spare Devices : 0

         Layout : far=4
     Chunk Size : 256K

           UUID : xxxxxxxx:xxxxxxxx:xxxxxxxx:xxxxxxxx
         Events : 0.48263

    Number   Major   Minor   RaidDevice State
       0       8       18        0      active sync   /dev/sdb2
       1       8        2        1      active sync   /dev/sda2
       2       8       34        2      active sync   /dev/sdc2
       3       8       50        3      active sync   /dev/sdd2

$ cat /proc/mdstat 
Personalities : [raid10] [raid1] [linear] [multipath] [raid0] [raid6]
[raid5] [raid4] 
md1 : active raid1 sdd1[3] sdc1[2] sdb1[1] sda1[0]
      152512 blocks [4/4] [UUUU]
      
md0 : active raid10 sdd2[3] sdc2[2] sda2[1] sdb2[0]
      974558208 blocks 256K chunks 4 far-copies [4/4] [UUUU]
      
unused devices: <none>
