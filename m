From: John Lange <john.lange@bighostbox.com>
Subject: Problem getting RAID 1 to resync
Date: Wed, 05 May 2004 10:32:54 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1083771173.10224.33.camel@ws101.darkcore.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I am experimenting with a RAID 1 array which is comprised of 3 scsi
disks. raidtab looks as follows:

raiddev /dev/md0
raid-level      1
nr-raid-disks   2
nr-spare-disks  1
chunk-size     4
persistent-superblock 1
device          /dev/sdb1
raid-disk       0
device          /dev/sdc1
raid-disk       1
device          /dev/sdd1
spare-disk      0

----

Following the instructions in the Linux Raid how-to I simulated a
failure on /dev/sdc using raidsetfaulty  and everything was great. The
spare was brought up and synced nicely. So far so good.

I then re-added /dev/sdc1 into the array and it appeared as the new
spare as it should.

Next, to simulate a hardware failure I tried physically removing
/dev/sdd from the system while it was running. This is a dell poweredge
6300 which I believe (but I'm not positive) has hot-swappable drive
bays.

Now the problems start. It did recognize /dev/sdd as failed but did not
bring up /dev/sdc1 as expected. Maybe you have to manually tell it to
sync in the spare? I figured I'd remove the failed disk first with
raidhotremove /dev/md0 /dev/sdd1 . Ok.... still not syncing.

Next I physically added /dev/sdd back into the drive bay and did
raidhotadd /dev/md0 /dev/sdd1 . That seemed fine but still no sync. Here
is some output:

# cat /proc/mdstat 
Personalities : [linear] [raid0] [raid1] [raid5] 
md0 : active raid1 sdd1[2] sdc1[3] sdb1[0]
      7815488 blocks [2/1] [U_]
        resync=DELAYED
unused devices: <none>

# mdadm --detail /dev/md0
/dev/md0:
        Version : 00.90.01
  Creation Time : Tue May  4 10:47:37 2004
     Raid Level : raid1
     Array Size : 7815488 (7.45 GiB 8.00 GB)
    Device Size : 7815488 (7.45 GiB 8.00 GB)
   Raid Devices : 2
  Total Devices : 3
Preferred Minor : 0
    Persistence : Superblock is persistent

    Update Time : Wed May  5 08:23:53 2004
          State : clean, no-errors
 Active Devices : 1
Working Devices : 3
 Failed Devices : 0
  Spare Devices : 2


    Number   Major   Minor   RaidDevice State
       0       8       17        0      active sync   /dev/sdb1
       1       0        0       -1      removed
       2       8       49       -1      spare   /dev/sdd1
       3       8       33        1      spare   /dev/sdc1
           UUID : 030d10fc:deb3ef17:7df6451f:6887fe8a
         Events : 0.611

-------------

Worse still, I tried to cat a file from that RAID array and it just
locks up the shell. So it isn't even running from the one good disk. I
know hot-swapping devices did not cause the scsi controller to go down
because /dev/sda  (the root and boot disk) which is not part of any raid
set in the same drive bay is still working perfectly fine.

What have I done wrong here?

-- 
John Lange
BigHostBox.com
(204) 885 0872

