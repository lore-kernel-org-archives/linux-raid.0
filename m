From: Santiago DIEZ <santiago.diez@caoba.fr>
Subject: How to fix mistake on raid: mdadm create instead of assemble?
Date: Fri, 7 Oct 2016 17:37:32 +0200
Message-ID: <CAJh8RqUaT_D3GEkj9dWGY5d4e4icUKzyidV2JTVToKN=MpCRyQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux Raid LIST <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi guys,

I'm new to RAID although I've had a server running raid5 for a while.
It was delivered preinstalled like this and I never really wondered
how to monitor and maintain it. This quick introduction just to let
you understand why I'm such an idiot asking such a silly question.

Now what happened?

I have a server with 4 disks and raid5 configured. /dev/md10 is made
of sda10 , sdb10 , sdc10 and sdd10 .

Unfortunately, /dev/sdd died, the server crashed, etc. After restart,
md10 did not rebuilt. I understood sdd was dead and did not try to
force rebuild or even touch the existing system.

First thing I did is ddrescue the remaining partitions sd[abc]10 .
ddrescue did not stumble into any read error so I assume all remaining
partitions are perfectly safe.

Then I examined the partitions with :

================================================================================
# mdadm --examine /dev/loop[012]

/dev/loop0:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : 9d37bc89:711887ae:a4d2adc2:26fd5302
  Creation Time : Wed Jan 25 09:08:11 2012
     Raid Level : raid5
  Used Dev Size : 1926247296 (1837.01 GiB 1972.48 GB)
     Array Size : 5778741888 (5511.04 GiB 5917.43 GB)
   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 10

    Update Time : Mon Sep  5 23:29:23 2016
          State : clean
 Active Devices : 3
Working Devices : 3
 Failed Devices : 1
  Spare Devices : 0
       Checksum : 9d0ce26d - correct
         Events : 81589

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     0       8       10        0      active sync

   0     0       8       10        0      active sync
   1     1       8       26        1      active sync
   2     2       8       42        2      active sync
   3     3       0        0        3      faulty removed
/dev/loop1:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : 9d37bc89:711887ae:a4d2adc2:26fd5302
  Creation Time : Wed Jan 25 09:08:11 2012
     Raid Level : raid5
  Used Dev Size : 1926247296 (1837.01 GiB 1972.48 GB)
     Array Size : 5778741888 (5511.04 GiB 5917.43 GB)
   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 10

    Update Time : Mon Sep  5 23:36:23 2016
          State : clean
 Active Devices : 1
Working Devices : 1
 Failed Devices : 2
  Spare Devices : 0
       Checksum : 9d0ce487 - correct
         Events : 81626

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     1       8       26        1      active sync

   0     0       0        0        0      removed
   1     1       8       26        1      active sync
   2     2       0        0        2      faulty removed
   3     3       0        0        3      faulty removed
/dev/loop2:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : 9d37bc89:711887ae:a4d2adc2:26fd5302
  Creation Time : Wed Jan 25 09:08:11 2012
     Raid Level : raid5
  Used Dev Size : 1926247296 (1837.01 GiB 1972.48 GB)
     Array Size : 5778741888 (5511.04 GiB 5917.43 GB)
   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 10

    Update Time : Mon Sep  5 23:29:23 2016
          State : clean
 Active Devices : 3
Working Devices : 3
 Failed Devices : 1
  Spare Devices : 0
       Checksum : 9d0ce291 - correct
         Events : 81589

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     2       8       42        2      active sync

   0     0       8       10        0      active sync
   1     1       8       26        1      active sync
   2     2       8       42        2      active sync
   3     3       0        0        3      faulty removed
================================================================================

There comes my mistake: I ran the --create command instead of --assemble :

================================================================================
# mdadm --create --verbose /dev/md1 --raid-devices=4 --level=raid5
--run --readonly /dev/loop0 /dev/loop1 /dev/loop2 missing

mdadm: layout defaults to left-symmetric
mdadm: layout defaults to left-symmetric
mdadm: chunk size defaults to 512K
mdadm: /dev/loop0 appears to contain an ext2fs file system
       size=5778741888K  mtime=Sat Sep  3 11:00:22 2016
mdadm: /dev/loop0 appears to be part of a raid array:
       level=raid5 devices=4 ctime=Wed Jan 25 09:08:11 2012
mdadm: /dev/loop1 appears to be part of a raid array:
       level=raid5 devices=4 ctime=Wed Jan 25 09:08:11 2012
mdadm: /dev/loop2 appears to be part of a raid array:
       level=raid5 devices=4 ctime=Wed Jan 25 09:08:11 2012
mdadm: size set to 1926115840K
mdadm: automatically enabling write-intent bitmap on large array
mdadm: creation continuing despite oddities due to --run
mdadm: Defaulting to version 1.2 metadata
mdadm: array /dev/md1 started.
================================================================================

After that, mounting failed:

================================================================================
# mount /dev/md1 /raid/
mount: /dev/md1 is write-protected, mounting read-only
mount: wrong fs type, bad option, bad superblock on /dev/md1,
       missing codepage or helper program, or other error

       In some cases useful info is found in syslog - try
       dmesg | tail or so.
================================================================================

Here's more info about the new raid to be compared with the initial one:

================================================================================
# mdadm --examine /dev/loop[012]

/dev/loop0:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : aa56f42f:bb95fbde:11ce620e:878b2b1c
           Name : tucana.caoba.fr:1  (local to host tucana.caoba.fr)
  Creation Time : Mon Sep 19 23:17:04 2016
     Raid Level : raid5
   Raid Devices : 4

 Avail Dev Size : 3852232703 (1836.89 GiB 1972.34 GB)
     Array Size : 5778347520 (5510.66 GiB 5917.03 GB)
  Used Dev Size : 3852231680 (1836.89 GiB 1972.34 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
   Unused Space : before=262056 sectors, after=1023 sectors
          State : clean
    Device UUID : b4622e59:f0735f5a:825086d1:57f89efb

Internal Bitmap : 8 sectors from superblock
    Update Time : Mon Sep 19 23:17:04 2016
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : 3ec8dda7 - correct
         Events : 0

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 0
   Array State : AAA. ('A' == active, '.' == missing, 'R' == replacing)
/dev/loop1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : aa56f42f:bb95fbde:11ce620e:878b2b1c
           Name : tucana.caoba.fr:1  (local to host tucana.caoba.fr)
  Creation Time : Mon Sep 19 23:17:04 2016
     Raid Level : raid5
   Raid Devices : 4

 Avail Dev Size : 3852232703 (1836.89 GiB 1972.34 GB)
     Array Size : 5778347520 (5510.66 GiB 5917.03 GB)
  Used Dev Size : 3852231680 (1836.89 GiB 1972.34 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
   Unused Space : before=262056 sectors, after=1023 sectors
          State : clean
    Device UUID : 9d42153b:4173aeea:51f41ebc:3789f98a

Internal Bitmap : 8 sectors from superblock
    Update Time : Mon Sep 19 23:17:04 2016
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : 2af1f191 - correct
         Events : 0

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 1
   Array State : AAA. ('A' == active, '.' == missing, 'R' == replacing)
/dev/loop2:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : aa56f42f:bb95fbde:11ce620e:878b2b1c
           Name : tucana.caoba.fr:1  (local to host tucana.caoba.fr)
  Creation Time : Mon Sep 19 23:17:04 2016
     Raid Level : raid5
   Raid Devices : 4

 Avail Dev Size : 3852232703 (1836.89 GiB 1972.34 GB)
     Array Size : 5778347520 (5510.66 GiB 5917.03 GB)
  Used Dev Size : 3852231680 (1836.89 GiB 1972.34 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
   Unused Space : before=262056 sectors, after=1023 sectors
          State : clean
    Device UUID : ada52b0e:f2c4a680:ece59800:6425a9b2

Internal Bitmap : 8 sectors from superblock
    Update Time : Mon Sep 19 23:17:04 2016
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : 2a341a - correct
         Events : 0

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 2
   Array State : AAA. ('A' == active, '.' == missing, 'R' == replacing)
================================================================================

With the help of the initial mdadm --examine , is it possible to
recreate my raid in a way that I can read data out of it?


I also posted the question here:
http://www.unix.com/unix-for-advanced-and-expert-users/268771-how-fix-mistake-raid-mdadm-create-instead-assemble-post302983179.html#post302983179

Regards
-------------------------
Santiago DIEZ
CAOBA Conseil
Paris, France
