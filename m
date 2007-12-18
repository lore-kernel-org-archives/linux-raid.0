From: "Erich Newell" <erich.newell@gmail.com>
Subject: Cannot re-assemble Degraded RAID6 after crash
Date: Mon, 17 Dec 2007 19:40:28 -0700
Message-ID: <d39ad6430712171840t554927dat8df327531348d6b9@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

My system has crashed a couple of times, each time the two drives have
dropped off of the RAID.

Previously I simply did the following, which would take all night:

mdadm -a --re-add /dev/md2 /dev/sde3
mdadm -a --re-add /dev/md2 /dev/sdf3
mdadm -a --re-add /dev/md3 /dev/sde5
mdadm -a --re-add /dev/md3 /dev/sde5

When I woke up in the morning, everything was happy...until it crashed
again yesterday. This time, I get a message: "/dev/md3 assembled from
4 drives - not enough to start the array while not clean - consider
--force."

I can re-assemble /dev/md3 (sda5, sdb5, sdc5, sdd5, sde5 and sdf5) if
I use -f, although all the other sets seem fine. I cannot "--re-add"
the other partitions. I'm afraid of losing data and would like advice
before I proceed. Below I've detailed my geometry and included the
data from "mdadm --detail /dev/md2" (showing happy root partition),
"mdadm --detail /dev/md3" (showing unhappy /srv partition) as well as
"mdadm --examine /dev/sdX5" where "X" is the drive letter. It seems
that "sde5" and "sdf5" are somehow confused. They think of themselves
as: "/dev/.static/dev/sdj5" and "/dev/.static/dev/sdk5" as revealed by
"mdadm --examine /dev/sde5"

I have 4 raid partitions per disk: swap, tmp, root and srv (sda6 is
extra...result of adding 300gb disk into group of 250gb)

                          cfdisk (util-linux-ng 2.13)

                              Disk Drive: /dev/sda
                       Size: 300090728448 bytes, 300.0 GB
             Heads: 255   Sectors per Track: 63   Cylinders: 36483

    Name        Flags      Part Type  FS Type          [Label]        Size (MB)
 ------------------------------------------------------------------------------
    sda1                    Primary   Linux raid autodetect              501.75
    sda2                    Primary   Linux raid autodetect             1003.49
    sda3                    Primary   Linux raid autodetect            10001.95
    sda5                    Logical   Linux raid autodetect           239503.71
    sda6                    Logical   Linux raid autodetect            49072.03

/dev/md2:
        Version : 00.90.03
  Creation Time : Sun Dec  3 20:30:54 2006
     Raid Level : raid6
     Array Size : 39069696 (37.26 GiB 40.01 GB)
  Used Dev Size : 9767424 (9.31 GiB 10.00 GB)
   Raid Devices : 6
  Total Devices : 6
Preferred Minor : 2
    Persistence : Superblock is persistent

    Update Time : Mon Dec 17 19:39:30 2007
          State : clean
 Active Devices : 6
Working Devices : 6
 Failed Devices : 0
  Spare Devices : 0

     Chunk Size : 64K

           UUID : 3bc78325:00787a3d:645931e8:f69b1082
         Events : 0.5781192

    Number   Major   Minor   RaidDevice State
       0       8        3        0      active sync   /dev/sda3
       1       8       19        1      active sync   /dev/sdb3
       2       8       35        2      active sync   /dev/sdc3
       3       8       51        3      active sync   /dev/sdd3
       4       8       67        4      active sync   /dev/sde3
       5       8       83        5      active sync   /dev/sdf3

/dev/md3:
        Version : 00.90.03
  Creation Time : Sun Dec  3 20:31:16 2006
     Raid Level : raid6
     Array Size : 935496448 (892.16 GiB 957.95 GB)
  Used Dev Size : 233874112 (223.04 GiB 239.49 GB)
   Raid Devices : 6
  Total Devices : 4
Preferred Minor : 3
    Persistence : Superblock is persistent

    Update Time : Mon Dec 17 19:29:53 2007
          State : clean, degraded
 Active Devices : 4
Working Devices : 4
 Failed Devices : 0
  Spare Devices : 0

     Chunk Size : 64K

           UUID : ae3b47bd:ac100bfe:1bed3458:8d6915d8
         Events : 0.992402

    Number   Major   Minor   RaidDevice State
       0       8        5        0      active sync   /dev/sda5
       1       8       21        1      active sync   /dev/sdb5
       2       8       37        2      active sync   /dev/sdc5
       3       8       53        3      active sync   /dev/sdd5
       4       0        0        4      removed
       5       0        0        5      removed

/dev/sda5:
          Magic : a92b4efc
        Version : 00.90.03
           UUID : ae3b47bd:ac100bfe:1bed3458:8d6915d8
  Creation Time : Sun Dec  3 20:31:16 2006
     Raid Level : raid6
  Used Dev Size : 233874112 (223.04 GiB 239.49 GB)
     Array Size : 935496448 (892.16 GiB 957.95 GB)
   Raid Devices : 6
  Total Devices : 4
Preferred Minor : 3

    Update Time : Mon Dec 17 19:33:55 2007
          State : clean
 Active Devices : 4
Working Devices : 4
 Failed Devices : 2
  Spare Devices : 0
       Checksum : 47b7a255 - correct
         Events : 0.992404

     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     0       8        5        0      active sync   /dev/sda5

   0     0       8        5        0      active sync   /dev/sda5
   1     1       8       21        1      active sync   /dev/sdb5
   2     2       8       37        2      active sync   /dev/sdc5
   3     3       8       53        3      active sync   /dev/sdd5
   4     4       0        0        4      faulty removed
   5     5       0        0        5      faulty removed

/dev/sdb5:
          Magic : a92b4efc
        Version : 00.90.03
           UUID : ae3b47bd:ac100bfe:1bed3458:8d6915d8
  Creation Time : Sun Dec  3 20:31:16 2006
     Raid Level : raid6
  Used Dev Size : 233874112 (223.04 GiB 239.49 GB)
     Array Size : 935496448 (892.16 GiB 957.95 GB)
   Raid Devices : 6
  Total Devices : 4
Preferred Minor : 3

    Update Time : Mon Dec 17 19:33:55 2007
          State : clean
 Active Devices : 4
Working Devices : 4
 Failed Devices : 2
  Spare Devices : 0
       Checksum : 47b7a267 - correct
         Events : 0.992404

     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     1       8       21        1      active sync   /dev/sdb5

   0     0       8        5        0      active sync   /dev/sda5
   1     1       8       21        1      active sync   /dev/sdb5
   2     2       8       37        2      active sync   /dev/sdc5
   3     3       8       53        3      active sync   /dev/sdd5
   4     4       0        0        4      faulty removed
   5     5       0        0        5      faulty removed

/dev/sdc5:
          Magic : a92b4efc
        Version : 00.90.03
           UUID : ae3b47bd:ac100bfe:1bed3458:8d6915d8
  Creation Time : Sun Dec  3 20:31:16 2006
     Raid Level : raid6
  Used Dev Size : 233874112 (223.04 GiB 239.49 GB)
     Array Size : 935496448 (892.16 GiB 957.95 GB)
   Raid Devices : 6
  Total Devices : 4
Preferred Minor : 3

    Update Time : Mon Dec 17 19:33:55 2007
          State : clean
 Active Devices : 4
Working Devices : 4
 Failed Devices : 2
  Spare Devices : 0
       Checksum : 47b7a279 - correct
         Events : 0.992404

     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     2       8       37        2      active sync   /dev/sdc5

   0     0       8        5        0      active sync   /dev/sda5
   1     1       8       21        1      active sync   /dev/sdb5
   2     2       8       37        2      active sync   /dev/sdc5
   3     3       8       53        3      active sync   /dev/sdd5
   4     4       0        0        4      faulty removed
   5     5       0        0        5      faulty removed

/dev/sdd5:
          Magic : a92b4efc
        Version : 00.90.03
           UUID : ae3b47bd:ac100bfe:1bed3458:8d6915d8
  Creation Time : Sun Dec  3 20:31:16 2006
     Raid Level : raid6
  Used Dev Size : 233874112 (223.04 GiB 239.49 GB)
     Array Size : 935496448 (892.16 GiB 957.95 GB)
   Raid Devices : 6
  Total Devices : 4
Preferred Minor : 3

    Update Time : Mon Dec 17 19:33:55 2007
          State : clean
 Active Devices : 4
Working Devices : 4
 Failed Devices : 2
  Spare Devices : 0
       Checksum : 47b7a28b - correct
         Events : 0.992404

     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     3       8       53        3      active sync   /dev/sdd5

   0     0       8        5        0      active sync   /dev/sda5
   1     1       8       21        1      active sync   /dev/sdb5
   2     2       8       37        2      active sync   /dev/sdc5
   3     3       8       53        3      active sync   /dev/sdd5
   4     4       0        0        4      faulty removed
   5     5       0        0        5      faulty removed

/dev/sde5:
          Magic : a92b4efc
        Version : 00.90.03
           UUID : ae3b47bd:ac100bfe:1bed3458:8d6915d8
  Creation Time : Sun Dec  3 20:31:16 2006
     Raid Level : raid6
  Used Dev Size : 233874112 (223.04 GiB 239.49 GB)
     Array Size : 935496448 (892.16 GiB 957.95 GB)
   Raid Devices : 6
  Total Devices : 6
Preferred Minor : 3

    Update Time : Tue Dec 11 18:09:09 2007
          State : active
 Active Devices : 6
Working Devices : 6
 Failed Devices : 0
  Spare Devices : 0
       Checksum : 47a082b7 - correct
         Events : 0.992393

     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     4       8      149        4      active sync   /dev/.static/dev/sdj5

   0     0       8        5        0      active sync   /dev/sda5
   1     1       8       21        1      active sync   /dev/sdb5
   2     2       8       37        2      active sync   /dev/sdc5
   3     3       8       53        3      active sync   /dev/sdd5
   4     4       8      149        4      active sync   /dev/.static/dev/sdj5
   5     5       8      165        5      active sync   /dev/.static/dev/sdk5

/dev/sdf5:
          Magic : a92b4efc
        Version : 00.90.03
           UUID : ae3b47bd:ac100bfe:1bed3458:8d6915d8
  Creation Time : Sun Dec  3 20:31:16 2006
     Raid Level : raid6
  Used Dev Size : 233874112 (223.04 GiB 239.49 GB)
     Array Size : 935496448 (892.16 GiB 957.95 GB)
   Raid Devices : 6
  Total Devices : 6
Preferred Minor : 3

    Update Time : Tue Dec 11 18:09:09 2007
          State : active
 Active Devices : 6
Working Devices : 6
 Failed Devices : 0
  Spare Devices : 0
       Checksum : 47a082c9 - correct
         Events : 0.992393

     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     5       8      165        5      active sync   /dev/.static/dev/sdk5

   0     0       8        5        0      active sync   /dev/sda5
   1     1       8       21        1      active sync   /dev/sdb5
   2     2       8       37        2      active sync   /dev/sdc5
   3     3       8       53        3      active sync   /dev/sdd5
   4     4       8      149        4      active sync   /dev/.static/dev/sdj5
   5     5       8      165        5      active sync   /dev/.static/dev/sdk5


Cheers and Best Regards,


-- 
"A man is defined by the questions that he asks; and the way he goes
about finding the answers to those questions is the way he goes
through life."
