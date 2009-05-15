From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: Starting RAID 5
Date: Thu, 14 May 2009 21:15:19 -0500
Message-ID: <20090515021521914.KSFT13751@cdptpa-omta01.mail.rr.com>
Reply-To: <lrhorer@satx.rr.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: 'Linux RAID' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


OK, I've torn down the LVM backup arraqy and am rebuilding it as a RAID 5.
I've had problems with this before, and I'm having them, again.  I created
the array with:

mdadm --create /dev/md0 --raid-devices=7 --metadata=1.2 --chunk=256
--level=5 /dev/sd[a-g]

whereupon it creates the array and then immediately removes /dev/sdg and
makes it a spare.  I think I may have read where this is normal behavior.
Mdadm reports:

Backup:/# mdadm -Dt /dev/md0
/dev/md0:
        Version : 01.02
  Creation Time : Thu May 14 21:08:39 2009
     Raid Level : raid5
     Array Size : 8790830592 (8383.59 GiB 9001.81 GB)
  Used Dev Size : 2930276864 (2794.53 GiB 3000.60 GB)
   Raid Devices : 7
  Total Devices : 7
Preferred Minor : 0
    Persistence : Superblock is persistent

    Update Time : Thu May 14 21:08:39 2009
          State : clean, degraded
 Active Devices : 6
Working Devices : 7
 Failed Devices : 0
  Spare Devices : 1

         Layout : left-symmetric
     Chunk Size : 256K

           Name : Backup:0  (local to host Backup)
           UUID : 7014c2f4:04c56e86:b453d0be:9c49d0e2
         Events : 0

    Number   Major   Minor   RaidDevice State
       0       8        0        0      active sync   /dev/sda
       1       8       16        1      active sync   /dev/sdb
       2       8       32        2      active sync   /dev/sdc
       3       8       48        3      active sync   /dev/sdd
       4       8       64        4      active sync   /dev/sde
       5       8       80        5      active sync   /dev/sdf
       6       0        0        6      removed

       7       8       96        -      spare   /dev/sdg

I can't get it to do an initial resync or promote the spare, however.  What
do I do?

