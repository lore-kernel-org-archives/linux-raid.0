From: Mark Knecht <markknecht@gmail.com>
Subject: RAID6 chunk size change?
Date: Sun, 23 Jan 2011 10:53:03 -0800
Message-ID: <AANLkTimzLwmtMsrUdsLe9svywTFLbs_pZ8SXTCSyG4f4@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi,
   I've got an existing (and well backed up as of a couple of minutes
ago) 5-drive RAID6 shown here:

c2stable ~ # mdadm --detail /dev/md7
/dev/md7:
        Version : 1.2
  Creation Time : Sun Jan 16 17:02:24 2011
     Raid Level : raid6
     Array Size : 395387904 (377.07 GiB 404.88 GB)
  Used Dev Size : 131795968 (125.69 GiB 134.96 GB)
   Raid Devices : 5
  Total Devices : 5
    Persistence : Superblock is persistent

    Update Time : Sun Jan 23 10:25:41 2011
          State : clean
 Active Devices : 5
Working Devices : 5
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 512K

           Name : c2stable:7  (local to host c2stable)
           UUID : ded5e0c6:1a5a73ad:01949557:bb4e015a
         Events : 17

    Number   Major   Minor   RaidDevice State
       0       8        7        0      active sync   /dev/sda7
       1       8       23        1      active sync   /dev/sdb7
       2       8       39        2      active sync   /dev/sdc7
       3       8       50        3      active sync   /dev/sdd2
       4       8       66        4      active sync   /dev/sde2
c2stable ~ #

   I would like to change this RAID to a smaller chunk size. (16K for
now) What is the right command to use?

   From Google and the mdadm man pages I'm coming up with something like:

mdadm --grow /dev/md7 --level=6 --chunk=16 --backup-file=/root/backup-md7

Maybe I don't need --level because the level isn't changing? Neither
is the number of drives.

Thanks in advance,
Mark
