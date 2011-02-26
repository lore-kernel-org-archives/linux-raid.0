From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: OK, Now this is really weird
Date: Sat, 26 Feb 2011 01:00:42 -0600
Message-ID: <7A.41.13137.815A86D4@cdptpa-omtalb.mail.rr.com>
Reply-To: <lrhorer@satx.rr.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: 'Linux RAID' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


	I have a pair of drives each of whose 3 partitions are members of a
set of 3 RAID arrays.  One of the two drives had a flaky power connection
which I thought I had fixed, but I guess not, because the drive was taken
offline again on Tuesday.  The significant issue, however, is that both
times the drive failed, mdadm behaved really oddly.  The first time I
thought it might just be some odd anomaly, but the second time it did
precisely the same thing.  Both times, when the drive was de-registered by
udev, the first two arrays properly responded to the failure, but the third
array did not.  Here is the layout:

ARRAY /dev/md1 metadata=0.90 UUID=4cde286c:0687556a:4d9996dd:dd23e701
ARRAY /dev/md2 metadata=1.2 name=Backup:2
UUID=d45ff663:9e53774c:6fcf9968:21692025
ARRAY /dev/md3 metadata=1.2 name=Backup:3
UUID=51d22c47:10f58974:0b27ef04:5609d357


	Here is the result from examining the live parttions:

/dev/sdl1:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : 4cde286c:0687556a:4d9996dd:dd23e701 (local to host Backup)
  Creation Time : Fri Jun 11 20:45:51 2010
     Raid Level : raid1
  Used Dev Size : 6144704 (5.86 GiB 6.29 GB)
     Array Size : 6144704 (5.86 GiB 6.29 GB)
   Raid Devices : 2
  Total Devices : 2
Preferred Minor : 1

    Update Time : Sat Feb 26 00:47:19 2011
          State : clean
Internal Bitmap : present
 Active Devices : 1
Working Devices : 1
 Failed Devices : 0
  Spare Devices : 0
       Checksum : c127a1bf - correct
         Events : 1014


      Number   Major   Minor   RaidDevice State
this     1       8      177        1      active sync   /dev/sdl1

   0     0       0        0        0      removed
   1     1       8      177        1      active sync   /dev/sdl1


/dev/sdl2:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : d45ff663:9e53774c:6fcf9968:21692025
           Name : Backup:2  (local to host Backup)
  Creation Time : Sat Dec 19 22:59:43 2009
     Raid Level : raid1
   Raid Devices : 2

 Avail Dev Size : 554884828 (264.59 GiB 284.10 GB)
     Array Size : 554884828 (264.59 GiB 284.10 GB)
    Data Offset : 272 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : e0896263:c0f95d43:9c0cb92a:79a95210

Internal Bitmap : 8 sectors from superblock
    Update Time : Sat Feb 26 00:47:18 2011
       Checksum : 41881e60 - correct
         Events : 902752


   Device Role : Active device 1
   Array State : .A ('A' == active, '.' == missing)


/dev/sdl3:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : 51d22c47:10f58974:0b27ef04:5609d357
           Name : Backup:3  (local to host Backup)
  Creation Time : Sat May 29 14:16:22 2010
     Raid Level : raid1
   Raid Devices : 2

 Avail Dev Size : 409593096 (195.31 GiB 209.71 GB)
     Array Size : 409593096 (195.31 GiB 209.71 GB)
    Data Offset : 144 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 982c9519:48d21940:3720b6d5:dfb0a312

Internal Bitmap : 8 sectors from superblock
    Update Time : Wed Feb  9 20:02:26 2011
       Checksum : 6c78f4a2 - correct
         Events : 364740


   Device Role : Active device 1
   Array State : AA ('A' == active, '.' == missing)


	Here are the array details:

/dev/md1:
        Version : 0.90
  Creation Time : Fri Jun 11 20:45:51 2010
     Raid Level : raid1
     Array Size : 6144704 (5.86 GiB 6.29 GB)
  Used Dev Size : 6144704 (5.86 GiB 6.29 GB)
   Raid Devices : 2
  Total Devices : 2
Preferred Minor : 1
    Persistence : Superblock is persistent

  Intent Bitmap : Internal

    Update Time : Sat Feb 26 00:53:23 2011
          State : active, degraded
 Active Devices : 1
Working Devices : 1
 Failed Devices : 1
  Spare Devices : 0

           UUID : 4cde286c:0687556a:4d9996dd:dd23e701 (local to host Backup)
         Events : 0.1016

    Number   Major   Minor   RaidDevice State
       0       0        0        0      removed
       1       8      177        1      active sync   /dev/sdl1

       2       8      161        -      faulty spare
/dev/md2:
        Version : 1.2
  Creation Time : Sat Dec 19 22:59:43 2009
     Raid Level : raid1
     Array Size : 277442414 (264.59 GiB 284.10 GB)
  Used Dev Size : 277442414 (264.59 GiB 284.10 GB)
   Raid Devices : 2
  Total Devices : 2
    Persistence : Superblock is persistent

  Intent Bitmap : Internal

    Update Time : Sat Feb 26 00:53:47 2011
          State : active, degraded
 Active Devices : 1
Working Devices : 1
 Failed Devices : 1
  Spare Devices : 0

           Name : Backup:2  (local to host Backup)
           UUID : d45ff663:9e53774c:6fcf9968:21692025
         Events : 902890

    Number   Major   Minor   RaidDevice State
       0       0        0        0      removed
       3       8      178        1      active sync   /dev/sdl2

       2       8      162        -      faulty spare
/dev/md3:
        Version : 1.2
  Creation Time : Sat May 29 14:16:22 2010
     Raid Level : raid1
     Array Size : 204796548 (195.31 GiB 209.71 GB)
  Used Dev Size : 204796548 (195.31 GiB 209.71 GB)
   Raid Devices : 2
  Total Devices : 2
    Persistence : Superblock is persistent

  Intent Bitmap : Internal

    Update Time : Wed Feb  9 20:02:26 2011
          State : active, degraded
 Active Devices : 1
Working Devices : 1
 Failed Devices : 1
  Spare Devices : 0

           Name : Backup:3  (local to host Backup)
           UUID : 51d22c47:10f58974:0b27ef04:5609d357
         Events : 364740

    Number   Major   Minor   RaidDevice State
       2       8      163        0      faulty spare rebuilding
       3       8      179        1      active sync   /dev/sdl3

	So what gives?  /dev/sdk3 no longer even exists, so why hasn't it
been failed and removed on /dev /md3 like it has on /dev/md1 and /dev/md2?

