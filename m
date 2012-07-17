From: "Stefan G. Weichinger" <lists@xunil.at>
Subject: What to do with this RAID6 ...
Date: Tue, 17 Jul 2012 10:17:52 +0200
Message-ID: <50051FB0.4020502@xunil.at>
Reply-To: lists@xunil.at
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


Greets again, you mdadm-users ...

I am sorry to bug you again with another RAID-crisis.

RAID6 in a gentoo-linux-box, 4 disks:

# cat /proc/mdstat
Personalities : [raid1] [raid6] [raid5] [raid4]
md4 : active raid6 sda4[4](F) sdd4[3] sdb4[5](F) sdc4[2]
      448598912 blocks level 6, 64k chunk, algorithm 18 [4/2] [__UU]

md1 : active raid1 sda1[0] sdb1[1]
      104320 blocks [2/2] [UU]

md3 : active raid6 sda3[4](F) sdd3[3] sdb3[5](F) sdc3[2]
      39085952 blocks level 6, 64k chunk, algorithm 18 [4/2] [__UU]


history:

sda got flaky and fell out of the arrays, so yesterday I went there shut
down the box and put in a new sda. Back then the raid6s were running on
three partitions (e.g. md3=/dev/sd[bcd]3).

Booted from a live-cd as the MBR of sdb didn't boot, mounted stuff,
re-added /dev/sda1 and /dev/sdb3. Both md1 and md3 synced successfully
within minutes. Fine. Installed GRUB, booted the system. Re-added sdb4
to md4, watched for some time, tested availability of server in network
and left.

Hours later I checked back via ssh and saw that md3 amd md4 run on TWO
partitions instead of FOUR. *SIGH*

Now I wonder how to go on.

Buy another disk and swap sdb as well?


Look at that:

# smartctl -a /dev/sdb
smartctl 5.42 2011-10-20 r3458 [i686-linux-3.3.8-gentoo] (local build)
Copyright (C) 2002-11 by Bruce Allen, http://smartmontools.sourceforge.net

Vendor:               uV
Product:
User Capacity:        600.332.565.813.390.450 bytes [600 PB]
Logical block size:   774843950 bytes
scsiModePageOffset: raw_curr too small, offset=121 resp_len=98 bd_len=117
>> Terminate command early due to bad response to IEC mode page
A mandatory SMART command failed: exiting. To continue, add one or more
'-T permissive' options.

# smartctl -a /dev/sda
smartctl 5.42 2011-10-20 r3458 [i686-linux-3.3.8-gentoo] (local build)
Copyright (C) 2002-11 by Bruce Allen, http://smartmontools.sourceforge.net

Short INQUIRY response, skip product id
A mandatory SMART command failed: exiting. To continue, add one or more
'-T permissive' options.

*maybe* this would be reset somehow via reboot, I don't know.

I mean, sda is completely new ...


Additionally this is a productive samba-server, there are ~15 users
working on it right now. So my steps should be well planned as I have to
explain and plan the downtime, if needed (I also have to plan to go
there, just in case).

The good news: there is a 2nd server on site, I rsync data every 15
minutes right now, we have backups, etc.

So I maybe could go the path of stopping and rebuilding arrays as well.

Enough written:

What would you guys recommend to do?

Thanks a lot, Stefan!


Update:

sda1 failed now as well as I tried to mount /boot (md1=/boot)

sigh

and md1 on one disk doesn't mount anymore.

Just wanted to tell you the fact that I also upgrade kernel yesterday,
from old 2.6.32 to 3.3.8 ... maybe that is important as well.

------>

# mdadm -D /dev/md3
/dev/md3:
        Version : 0.90
  Creation Time : Wed Mar  3 01:26:30 2010
     Raid Level : raid6
     Array Size : 39085952 (37.28 GiB 40.02 GB)
  Used Dev Size : 19542976 (18.64 GiB 20.01 GB)
   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 3
    Persistence : Superblock is persistent

    Update Time : Tue Jul 17 10:09:28 2012
          State : clean, degraded
 Active Devices : 2
Working Devices : 2
 Failed Devices : 2
  Spare Devices : 0

         Layout : left-symmetric-6
     Chunk Size : 64K

           UUID : e2d6bcbb:ae01bb62:fe1319c4:e3928d1b
         Events : 0.9093166

    Number   Major   Minor   RaidDevice State
       0       0        0        0      removed
       1       0        0        1      removed
       2       8       35        2      active sync   /dev/sdc3
       3       8       51        3      active sync   /dev/sdd3

       4       8        3        -      faulty spare   /dev/sda3
       5       8       19        -      faulty spare   /dev/sdb3


# mdadm -D /dev/md4
/dev/md4:
        Version : 0.90
  Creation Time : Wed Mar  3 01:27:09 2010
     Raid Level : raid6
     Array Size : 448598912 (427.82 GiB 459.37 GB)
  Used Dev Size : 224299456 (213.91 GiB 229.68 GB)
   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 4
    Persistence : Superblock is persistent

    Update Time : Tue Jul 17 10:09:37 2012
          State : clean, degraded
 Active Devices : 2
Working Devices : 2
 Failed Devices : 2
  Spare Devices : 0

         Layout : left-symmetric-6
     Chunk Size : 64K

           UUID : 29764e32:6519686d:6c254e43:24ac4fbd
         Events : 0.956082

    Number   Major   Minor   RaidDevice State
       0       0        0        0      removed
       1       0        0        1      removed
       2       8       36        2      active sync   /dev/sdc4
       3       8       52        3      active sync   /dev/sdd4

       4       8        4        -      faulty spare   /dev/sda4
       5       8       20        -      faulty spare   /dev/sdb4


