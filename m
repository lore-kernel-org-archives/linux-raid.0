From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RAID 1 Disk added as faulty
Date: Sat, 26 Dec 2009 01:33:05 -0600
Message-ID: <78.6E.04641.43CB53B4@cdptpa-omtalb.mail.rr.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: 'linux-raid' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


Merry Christmas all,

	I have a bit of a puzzling problem.  I have a set of three
partitions on a SATA hard drive all set up as second members of three RAID 1
arrays with the first members missing.  I have a PATA drive partitioned in
precisely the same way as the SATA drive, and I am attempting to add the
PATA drive's partitions to the respective existing RAID 1 arrays.  I can add
the partitions with `mdadm /dev/mdx --add  /dev/hdax` (x = 1, 2, 3), and
everything works just fine.  The thing is, however, for rather obvious
reasons I would prefer the PATA partitions to be write-mostly.  If I add the
partitions to the array and then try to make the PATA partitions
write-mostly with the command `mdadm /dev/mdx -W /dev/hdax`, mdadm doesn't
complain, but it also doesn't appear to make the hdax partitions
write-mostly.  (Or at least it does not report them as such.)  OTOH, if I
start with a fresh partition with no existing superblock and use the command
`mdadm /dev/mdx --add -W /dev/hdax`, mdadm adds the partition and marks it
as write-mostly, but immediately fails the partition.  If I remove the
partition and re-add it without zeroing the superblock, it again adds it as
a faulty spare:

/dev/md1:
        Version : 01.00
  Creation Time : Wed Dec 23 23:46:28 2009
     Raid Level : raid1
     Array Size : 401580 (392.23 MiB 411.22 MB)
  Used Dev Size : 401580 (392.23 MiB 411.22 MB)
   Raid Devices : 2
  Total Devices : 2
Preferred Minor : 1
    Persistence : Superblock is persistent

  Intent Bitmap : Internal

    Update Time : Sat Dec 26 01:12:41 2009
          State : active, degraded
 Active Devices : 1
Working Devices : 1
 Failed Devices : 1
  Spare Devices : 0

           Name : 'RAID-Server':1
           UUID : 76e8e11d:e0183c3c:404cb86a:19a7cb3d
         Events : 188

    Number   Major   Minor   RaidDevice State
       0       0        0        0      removed
       1       8        1        1      active sync   /dev/sda1

       2       3        1        -      faulty writemostly spare   /dev/hda1


	How can I add these partitions as write-mostly members of the RAID 1
arrays?

