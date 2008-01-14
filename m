From: "Greg Cormier" <gcormier@gmail.com>
Subject: Replacing an active drive.
Date: Mon, 14 Jan 2008 10:26:02 -0500
Message-ID: <29a863790801140726j5c99a82bo494730e91a0ed871@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hey guys.

I've got a 1TB RAID5 array with 3x500gb drives. I just RMA'd a drive.
Can someone help me properly swap out /dev/sdd for the new drive?

I've done this before but I've had issues that bugged me. Everything
worked fine, but if I would examine details on drives, I'd have FOUR
drives listed with the old drive always missing. So I guess I wasn't
properly removing the current drive? Or maybe I marked it as failed
but didn't remove it?

In any case it drove me nuts having that array working but having that
phantom old drive haunting me in the details of the array.


Thanks,
Greg


[root@zeus ~]# mdadm --detail /dev/md0
/dev/md0:
        Version : 00.90.03
  Creation Time : Sun Oct 28 20:26:45 2007
     Raid Level : raid5
     Array Size : 976767872 (931.52 GiB 1000.21 GB)
  Used Dev Size : 488383936 (465.76 GiB 500.11 GB)
   Raid Devices : 3
  Total Devices : 3
Preferred Minor : 0
    Persistence : Superblock is persistent

    Update Time : Mon Jan 14 00:28:13 2008
          State : clean
 Active Devices : 3
Working Devices : 3
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 64K

           UUID : 3b024473:fc22d99a:c7b2647e:3a22292c
         Events : 0.16

    Number   Major   Minor   RaidDevice State
       0       8       17        0      active sync   /dev/sdb1
       1       8       33        1      active sync   /dev/sdc1
       2       8       49        2      active sync   /dev/sdd1
