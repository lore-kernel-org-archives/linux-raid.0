From: Robert LeBlanc <robert@leblancnet.us>
Subject: RAID without dev size prevents adding a new member
Date: Mon, 19 Dec 2016 18:01:09 -0700
Message-ID: <CAANLjFo09x0VMj2KbPZzWwpgXebS0d1ZGNTwDqi7fiVsKvFJ+g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I have an array that failed to readd a member saying that the new
member was too small. After trying a few things including "--add",
"--force", zeroing out the superblock, clearing out the first 100 MB
to get rid of the partition table, I found that mdadm thinks the Used
Dev Size is unknown. I looked at the superblock and it appears to have
a valid used dev size. Both disks are exactly the same size. I'm not
sure how fix this.

# mdadm --version
mdadm - v3.3.2 - 21st August 2014

# mdadm --detail /dev/md_root
/dev/md_root:
       Version : 1.0
 Creation Time : Wed Sep  7 15:58:30 2016
    Raid Level : raid1
    Array Size : 5368708928 (5120.00 GiB 5497.56 GB)
 Used Dev Size : unknown
  Raid Devices : 2
 Total Devices : 1
   Persistence : Superblock is persistent

 Intent Bitmap : Internal

   Update Time : Mon Dec 19 17:05:29 2016
         State : clean, degraded
Active Devices : 1
Working Devices : 1
Failed Devices : 0
 Spare Devices : 0

          Name : 10.91.0.11-volume
          UUID : 2ea91e32:59b7806d:956803c6:00c410eb
        Events : 3691225

   Number   Major   Minor   RaidDevice State
      0       8       16        0      active sync   /dev/sdb
      2       0        0        2      removed

# mdadm --detail /dev/md_root
/dev/md_root:
       Version : 1.0
 Creation Time : Wed Sep  7 15:58:30 2016
    Raid Level : raid1
    Array Size : 5368708928 (5120.00 GiB 5497.56 GB)
 Used Dev Size : unknown
  Raid Devices : 2
 Total Devices : 1
   Persistence : Superblock is persistent

 Intent Bitmap : Internal

   Update Time : Mon Dec 19 17:05:29 2016
         State : clean, degraded
Active Devices : 1
Working Devices : 1
Failed Devices : 0
 Spare Devices : 0

          Name : 10.91.0.11-volume
          UUID : 2ea91e32:59b7806d:956803c6:00c410eb
        Events : 3691225

   Number   Major   Minor   RaidDevice State
      0       8       16        0      active sync   /dev/sdb
      2       0        0        2      removed

# hexdump -C -s 5497558130688 /dev/sdb
4ffffffe000  fc 4e 2b a9 01 00 00 00  01 00 00 00 00 00 00 00
|.N+.............|
4ffffffe010  2e a9 1e 32 59 b7 80 6d  95 68 03 c6 00 c4 10 eb
|...2Y..m.h......|
4ffffffe020  31 30 2e 39 31 2e 30 2e  31 31 2d 76 6f 6c 75 6d
|10.91.0.11-volum|
4ffffffe030  65 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00
|e...............|
4ffffffe040  86 8d d0 57 00 00 00 00  01 00 00 00 00 00 00 00
|...W............|
4ffffffe050  80 fe ff 7f 02 00 00 00  00 00 00 00 02 00 00 00
|................|
4ffffffe060  a0 ff ff ff 00 00 00 00  00 00 00 00 00 00 00 00
|................|
4ffffffe070  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00
|................|
4ffffffe080  00 00 00 00 00 00 00 00  e8 fe ff 7f 02 00 00 00
|................|
4ffffffe090  f0 ff ff 7f 02 00 00 00  00 00 00 00 00 00 00 00
|................|
4ffffffe0a0  00 00 00 00 00 00 00 00  4c 6c 99 5a bd 1a 4c 7d
|........Ll.Z..L}|
4ffffffe0b0  32 29 7a bc e2 45 89 dd  00 00 08 00 f8 ff ff ff
|2)z..E..........|
4ffffffe0c0  4f 66 58 58 00 00 00 00  7b 33 38 00 00 00 00 00
|OfXX....{38.....|
4ffffffe0d0  ff ff ff ff ff ff ff ff  33 f3 f0 e6 80 00 00 00
|........3.......|
4ffffffe0e0  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00
|................|
*
4ffffffe100  00 00 fe ff fe ff fe ff  fe ff fe ff fe ff fe ff
|................|
4ffffffe110  fe ff fe ff fe ff fe ff  fe ff fe ff fe ff fe ff
|................|
*
4ffffffe200  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00
|................|
*
50000000000

# blockdev --report /dev/sd[a,b]
RO    RA   SSZ   BSZ   StartSec            Size   Device
rw   256   512  4096          0   5497558138880   /dev/sda
rw   256   512  4096          0   5497558138880   /dev/sdb

# mdadm /dev/md_root --add /dev/sda
mdadm: /dev/sda not large enough to join array

----------------
Robert LeBlanc
PGP Fingerprint 79A2 9CA4 6CC4 45DD A904  C70E E654 3BB2 FA62 B9F1
