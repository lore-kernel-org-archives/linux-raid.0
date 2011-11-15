From: Mark Knecht <markknecht@gmail.com>
Subject: Reshape 3-drive RAID1 into 3-drive RAID-5
Date: Tue, 15 Nov 2011 07:13:23 -0800
Message-ID: <CAK2H+ed1M=_N5rW5Y72Cm0_74ii=-9dCMsB7xJR4FGMST4rCjA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi all,
   I have an existing 3-drive RAID-1 (md6) that I use as a short term
backup device for a 5-drive RAID-6 (md7) on this machine. The _only_
purpose of this internal backup RAID-1 is to protect against a
fat-finger 'oops' event when using VMWare or Virtualbox VMs on md7.
Real data backups happen over the network to other machines but that's
slow and only gets done about once a week. With this local storage I
can do it in just a few minutes every day.

   I recently reshaped the RAID-6 from a 5-drive RAID-1and now it's
larger than this local backup so I can't get everything backed up any
more. I.e. - I need /dev/md6 large enough to back up /dev/md7. With 3
existing 235GB partitions I believe the RAID-5 will be about 470GB
when complete and therefore large enough to hold my 400GB RAID-6 data.

   I would like to verify that the right commands to do this would be:

umount /dev/md6
mdadm --stop /dev/md6
mdadm --create /dev/md6 --level=5 --raid-devices=3 /dev/sda6 /dev/sdb6 /dev/sdc6

   If these commands are wrong or anyone thinks there are other things
I should be doing at this time please speak up as I'm interested.

   The data that's currently on the backup is not terribly important
but if possible I'd like to keep it through this process unless doing
so makes things more difficult. The time it takes to do this reshape
is not terribly important to me.

Thanks,
Mark


c2stable ~ # cat /proc/mdstat
Personalities : [linear] [raid0] [raid1] [raid10] [raid6] [raid5]
[raid4]
md6 : active raid1 sdc6[2] sdb6[1] sda6[0]
      247416933 blocks super 1.1 [3/3] [UUU]

md7 : active raid6 sdc7[2] sdb7[1] sda7[0] sdd2[3] sde2[4]
      395387904 blocks super 1.2 level 6, 16k chunk, algorithm 2 [5/5]
[UUUUU]

unused devices: <none>
c2stable ~ #


c2stable ~ # mdadm -D /dev/md6
/dev/md6:
        Version : 1.1
  Creation Time : Thu Apr 15 10:45:35 2010
     Raid Level : raid1
     Array Size : 247416933 (235.96 GiB 253.35 GB)
  Used Dev Size : 247416933 (235.96 GiB 253.35 GB)
   Raid Devices : 3
  Total Devices : 3
    Persistence : Superblock is persistent

    Update Time : Tue Nov 15 06:20:06 2011
          State : clean
 Active Devices : 3
Working Devices : 3
 Failed Devices : 0
  Spare Devices : 0

           Name : c2stable:6  (local to host c2stable)
           UUID : 249c7331:a8203540:c8f3b020:fb30a66b
         Events : 1034

    Number   Major   Minor   RaidDevice State
       0       8        6        0      active sync   /dev/sda6
       1       8       22        1      active sync   /dev/sdb6
       2       8       38        2      active sync   /dev/sdc6
c2stable ~ #
