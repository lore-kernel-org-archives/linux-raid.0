From: "Dragon" <Sunghost@gmx.de>
Subject: (unknown)
Date: Thu, 09 Jun 2011 08:50:59 +0200
Message-ID: <20110609065059.298530@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: philip@turmel.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Phil,
i know that there is something odd with the raid, thats why i need help.
No i didnt scamble the report. thats what the system output. Sorry for confusing with sdo, this is my usb disk and doesnt belong to the raid. because of the size i didnt have any backup ;(

I do not let the system run 24/7 and as i started at in the morning the sequence has changed.
 fdisk -l |grep sd
Disk /dev/sda: 1500.3 GB, 1500301910016 bytes
Disk /dev/sdc: 20.4 GB, 20409532416 bytes
/dev/sdc1   *           1        2372    19053058+  83  Linux
/dev/sdc2            2373        2481      875542+   5  Extended
/dev/sdc5            2373        2481      875511   82  Linux swap / Solaris
Disk /dev/sdd: 1500.3 GB, 1500301910016 bytes
Disk /dev/sde: 1500.3 GB, 1500301910016 bytes
Disk /dev/sdg: 1500.3 GB, 1500301910016 bytes
Disk /dev/sdf: 1500.3 GB, 1500301910016 bytes
Disk /dev/sdh: 1500.3 GB, 1500301910016 bytes
Disk /dev/sdi: 1500.3 GB, 1500301910016 bytes
Disk /dev/sdj: 1500.3 GB, 1500301910016 bytes
Disk /dev/sdk: 1500.3 GB, 1500301910016 bytes
Disk /dev/sdl: 1500.3 GB, 1500301910016 bytes
Disk /dev/sdm: 1500.3 GB, 1500301910016 bytes
Disk /dev/sdn: 1500.3 GB, 1500301910016 bytes
Disk /dev/sdb: 1500.3 GB, 1500301910016 bytes
Yesterday was the system on disk sdk. now its on sdc?! the system is now and up to the evening online.
here the actual data of the drives again:
mdadm -E /dev/sda
/dev/sda:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : 975d6eb2:285eed11:021df236:c2d05073
  Creation Time : Tue Oct 13 23:26:17 2009
     Raid Level : raid5
  Used Dev Size : 1465138496 (1397.26 GiB 1500.30 GB)
     Array Size : 17581661952 (16767.18 GiB 18003.62 GB)
   Raid Devices : 13
  Total Devices : 12
Preferred Minor : 0

    Update Time : Fri Jun  3 23:47:53 2011
          State : clean
 Active Devices : 11
Working Devices : 12
 Failed Devices : 2
  Spare Devices : 1
       Checksum : 1dee4232 - correct
         Events : 156864

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     4       8      176        4      active sync   /dev/sdl

   0     0       8      112        0      active sync   /dev/sdh
   1     1       0        0        1      faulty removed
   2     2       8      128        2      active sync   /dev/sdi
   3     3       8      144        3      active sync   /dev/sdj
   4     4       8      176        4      active sync   /dev/sdl
   5     5       8      192        5      active sync   /dev/sdm
   6     6       8       16        6      active sync   /dev/sdb
   7     7       0        0        7      faulty removed
   8     8       8       32        8      active sync   /dev/sdc
   9     9       8       48        9      active sync   /dev/sdd
  10    10       8       64       10      active sync   /dev/sde
  11    11       8       80       11      active sync   /dev/sdf
  12    12       8       96       12      active sync   /dev/sdg
  13    13       8        0       13      spare   /dev/sda
mdadm -E /dev/sdb
/dev/sdb:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : 975d6eb2:285eed11:021df236:c2d05073
  Creation Time : Tue Oct 13 23:26:17 2009
     Raid Level : raid5
  Used Dev Size : 1465138496 (1397.26 GiB 1500.30 GB)
     Array Size : 17581661952 (16767.18 GiB 18003.62 GB)
   Raid Devices : 13
  Total Devices : 12
Preferred Minor : 0

    Update Time : Fri Jun  3 23:47:53 2011
          State : clean
 Active Devices : 11
Working Devices : 12
 Failed Devices : 2
  Spare Devices : 1
       Checksum : 1dee4244 - correct
         Events : 156864

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     5       8      192        5      active sync   /dev/sdm

   0     0       8      112        0      active sync   /dev/sdh
   1     1       0        0        1      faulty removed
   2     2       8      128        2      active sync   /dev/sdi
   3     3       8      144        3      active sync   /dev/sdj
   4     4       8      176        4      active sync   /dev/sdl
   5     5       8      192        5      active sync   /dev/sdm
   6     6       8       16        6      active sync   /dev/sdb
   7     7       0        0        7      faulty removed
   8     8       8       32        8      active sync   /dev/sdc
   9     9       8       48        9      active sync   /dev/sdd
  10    10       8       64       10      active sync   /dev/sde
  11    11       8       80       11      active sync   /dev/sdf
  12    12       8       96       12      active sync   /dev/sdg
  13    13       8        0       13      spare   /dev/sda
 mdadm -E /dev/sdd
/dev/sdd:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : 975d6eb2:285eed11:021df236:c2d05073
  Creation Time : Tue Oct 13 23:26:17 2009
     Raid Level : raid5
  Used Dev Size : 1465138496 (1397.26 GiB 1500.30 GB)
     Array Size : 17581661952 (16767.18 GiB 18003.62 GB)
   Raid Devices : 13
  Total Devices : 12
Preferred Minor : 0

    Update Time : Fri Jun  3 23:47:53 2011
          State : clean
 Active Devices : 11
Working Devices : 12
 Failed Devices : 2
  Spare Devices : 1
       Checksum : 1dee418e - correct
         Events : 156864

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this    13       8        0       13      spare   /dev/sda

   0     0       8      112        0      active sync   /dev/sdh
   1     1       0        0        1      faulty removed
   2     2       8      128        2      active sync   /dev/sdi
   3     3       8      144        3      active sync   /dev/sdj
   4     4       8      176        4      active sync   /dev/sdl
   5     5       8      192        5      active sync   /dev/sdm
   6     6       8       16        6      active sync   /dev/sdb
   7     7       0        0        7      faulty removed
   8     8       8       32        8      active sync   /dev/sdc
   9     9       8       48        9      active sync   /dev/sdd
  10    10       8       64       10      active sync   /dev/sde
  11    11       8       80       11      active sync   /dev/sdf
  12    12       8       96       12      active sync   /dev/sdg
  13    13       8        0       13      spare   /dev/sda
mdadm -E /dev/sde
/dev/sde:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : 975d6eb2:285eed11:021df236:c2d05073
  Creation Time : Tue Oct 13 23:26:17 2009
     Raid Level : raid5
  Used Dev Size : 1465138496 (1397.26 GiB 1500.30 GB)
     Array Size : 17581661952 (16767.18 GiB 18003.62 GB)
   Raid Devices : 13
  Total Devices : 12
Preferred Minor : 0

    Update Time : Fri Jun  3 23:47:53 2011
          State : clean
 Active Devices : 11
Working Devices : 12
 Failed Devices : 2
  Spare Devices : 1
       Checksum : 1dee4196 - correct
         Events : 156864

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     6       8       16        6      active sync   /dev/sdb

   0     0       8      112        0      active sync   /dev/sdh
   1     1       0        0        1      faulty removed
   2     2       8      128        2      active sync   /dev/sdi
   3     3       8      144        3      active sync   /dev/sdj
   4     4       8      176        4      active sync   /dev/sdl
   5     5       8      192        5      active sync   /dev/sdm
   6     6       8       16        6      active sync   /dev/sdb
   7     7       0        0        7      faulty removed
   8     8       8       32        8      active sync   /dev/sdc
   9     9       8       48        9      active sync   /dev/sdd
  10    10       8       64       10      active sync   /dev/sde
  11    11       8       80       11      active sync   /dev/sdf
  12    12       8       96       12      active sync   /dev/sdg
  13    13       8        0       13      spare   /dev/sda
mdadm -E /dev/sdf
/dev/sdf:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : 975d6eb2:285eed11:021df236:c2d05073
  Creation Time : Tue Oct 13 23:26:17 2009
     Raid Level : raid5
  Used Dev Size : 1465138496 (1397.26 GiB 1500.30 GB)
     Array Size : 17581661952 (16767.18 GiB 18003.62 GB)
   Raid Devices : 13
  Total Devices : 12
Preferred Minor : 0

    Update Time : Fri Jun  3 23:47:53 2011
          State : clean
 Active Devices : 11
Working Devices : 12
 Failed Devices : 2
  Spare Devices : 1
       Checksum : 1dee41aa - correct
         Events : 156864

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     8       8       32        8      active sync   /dev/sdc

   0     0       8      112        0      active sync   /dev/sdh
   1     1       0        0        1      faulty removed
   2     2       8      128        2      active sync   /dev/sdi
   3     3       8      144        3      active sync   /dev/sdj
   4     4       8      176        4      active sync   /dev/sdl
   5     5       8      192        5      active sync   /dev/sdm
   6     6       8       16        6      active sync   /dev/sdb
   7     7       0        0        7      faulty removed
   8     8       8       32        8      active sync   /dev/sdc
   9     9       8       48        9      active sync   /dev/sdd
  10    10       8       64       10      active sync   /dev/sde
  11    11       8       80       11      active sync   /dev/sdf
  12    12       8       96       12      active sync   /dev/sdg
  13    13       8        0       13      spare   /dev/sda
mdadm -E /dev/sdg
/dev/sdg:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : 975d6eb2:285eed11:021df236:c2d05073
  Creation Time : Tue Oct 13 23:26:17 2009
     Raid Level : raid5
  Used Dev Size : 1465138496 (1397.26 GiB 1500.30 GB)
     Array Size : 17581661952 (16767.18 GiB 18003.62 GB)
   Raid Devices : 13
  Total Devices : 12
Preferred Minor : 0

    Update Time : Fri Jun  3 23:47:53 2011
          State : clean
 Active Devices : 11
Working Devices : 12
 Failed Devices : 2
  Spare Devices : 1
       Checksum : 1dee41bc - correct
         Events : 156864

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     9       8       48        9      active sync   /dev/sdd

   0     0       8      112        0      active sync   /dev/sdh
   1     1       0        0        1      faulty removed
   2     2       8      128        2      active sync   /dev/sdi
   3     3       8      144        3      active sync   /dev/sdj
   4     4       8      176        4      active sync   /dev/sdl
   5     5       8      192        5      active sync   /dev/sdm
   6     6       8       16        6      active sync   /dev/sdb
   7     7       0        0        7      faulty removed
   8     8       8       32        8      active sync   /dev/sdc
   9     9       8       48        9      active sync   /dev/sdd
  10    10       8       64       10      active sync   /dev/sde
  11    11       8       80       11      active sync   /dev/sdf
  12    12       8       96       12      active sync   /dev/sdg
  13    13       8        0       13      spare   /dev/sda
mdadm -E /dev/sdh
/dev/sdh:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : 975d6eb2:285eed11:021df236:c2d05073
  Creation Time : Tue Oct 13 23:26:17 2009
     Raid Level : raid5
  Used Dev Size : 1465138496 (1397.26 GiB 1500.30 GB)
     Array Size : 17581661952 (16767.18 GiB 18003.62 GB)
   Raid Devices : 13
  Total Devices : 12
Preferred Minor : 0

    Update Time : Fri Jun  3 23:47:53 2011
          State : clean
 Active Devices : 11
Working Devices : 12
 Failed Devices : 2
  Spare Devices : 1
       Checksum : 1dee41ce - correct
         Events : 156864

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this    10       8       64       10      active sync   /dev/sde

   0     0       8      112        0      active sync   /dev/sdh
   1     1       0        0        1      faulty removed
   2     2       8      128        2      active sync   /dev/sdi
   3     3       8      144        3      active sync   /dev/sdj
   4     4       8      176        4      active sync   /dev/sdl
   5     5       8      192        5      active sync   /dev/sdm
   6     6       8       16        6      active sync   /dev/sdb
   7     7       0        0        7      faulty removed
   8     8       8       32        8      active sync   /dev/sdc
   9     9       8       48        9      active sync   /dev/sdd
  10    10       8       64       10      active sync   /dev/sde
  11    11       8       80       11      active sync   /dev/sdf
  12    12       8       96       12      active sync   /dev/sdg
  13    13       8        0       13      spare   /dev/sda
mdadm -E /dev/sdi
/dev/sdi:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : 975d6eb2:285eed11:021df236:c2d05073
  Creation Time : Tue Oct 13 23:26:17 2009
     Raid Level : raid5
  Used Dev Size : 1465138496 (1397.26 GiB 1500.30 GB)
     Array Size : 17581661952 (16767.18 GiB 18003.62 GB)
   Raid Devices : 13
  Total Devices : 12
Preferred Minor : 0

    Update Time : Fri Jun  3 23:47:53 2011
          State : clean
 Active Devices : 11
Working Devices : 12
 Failed Devices : 2
  Spare Devices : 1
       Checksum : 1dee41e0 - correct
         Events : 156864

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this    11       8       80       11      active sync   /dev/sdf

   0     0       8      112        0      active sync   /dev/sdh
   1     1       0        0        1      faulty removed
   2     2       8      128        2      active sync   /dev/sdi
   3     3       8      144        3      active sync   /dev/sdj
   4     4       8      176        4      active sync   /dev/sdl
   5     5       8      192        5      active sync   /dev/sdm
   6     6       8       16        6      active sync   /dev/sdb
   7     7       0        0        7      faulty removed
   8     8       8       32        8      active sync   /dev/sdc
   9     9       8       48        9      active sync   /dev/sdd
  10    10       8       64       10      active sync   /dev/sde
  11    11       8       80       11      active sync   /dev/sdf
  12    12       8       96       12      active sync   /dev/sdg
  13    13       8        0       13      spare   /dev/sda
mdadm -E /dev/sdj
/dev/sdj:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : 975d6eb2:285eed11:021df236:c2d05073
  Creation Time : Tue Oct 13 23:26:17 2009
     Raid Level : raid5
  Used Dev Size : 1465138496 (1397.26 GiB 1500.30 GB)
     Array Size : 17581661952 (16767.18 GiB 18003.62 GB)
   Raid Devices : 13
  Total Devices : 12
Preferred Minor : 0

    Update Time : Fri Jun  3 23:47:53 2011
          State : clean
 Active Devices : 11
Working Devices : 12
 Failed Devices : 2
  Spare Devices : 1
       Checksum : 1dee41f2 - correct
         Events : 156864

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this    12       8       96       12      active sync   /dev/sdg

   0     0       8      112        0      active sync   /dev/sdh
   1     1       0        0        1      faulty removed
   2     2       8      128        2      active sync   /dev/sdi
   3     3       8      144        3      active sync   /dev/sdj
   4     4       8      176        4      active sync   /dev/sdl
   5     5       8      192        5      active sync   /dev/sdm
   6     6       8       16        6      active sync   /dev/sdb
   7     7       0        0        7      faulty removed
   8     8       8       32        8      active sync   /dev/sdc
   9     9       8       48        9      active sync   /dev/sdd
  10    10       8       64       10      active sync   /dev/sde
  11    11       8       80       11      active sync   /dev/sdf
  12    12       8       96       12      active sync   /dev/sdg
  13    13       8        0       13      spare   /dev/sda
mdadm -E /dev/sdk
/dev/sdk:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : 975d6eb2:285eed11:021df236:c2d05073
  Creation Time : Tue Oct 13 23:26:17 2009
     Raid Level : raid5
  Used Dev Size : 1465138496 (1397.26 GiB 1500.30 GB)
     Array Size : 17581661952 (16767.18 GiB 18003.62 GB)
   Raid Devices : 13
  Total Devices : 12
Preferred Minor : 0

    Update Time : Fri Jun  3 23:47:53 2011
          State : clean
 Active Devices : 11
Working Devices : 12
 Failed Devices : 2
  Spare Devices : 1
       Checksum : 1dee41ea - correct
         Events : 156864

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     0       8      112        0      active sync   /dev/sdh

   0     0       8      112        0      active sync   /dev/sdh
   1     1       0        0        1      faulty removed
   2     2       8      128        2      active sync   /dev/sdi
   3     3       8      144        3      active sync   /dev/sdj
   4     4       8      176        4      active sync   /dev/sdl
   5     5       8      192        5      active sync   /dev/sdm
   6     6       8       16        6      active sync   /dev/sdb
   7     7       0        0        7      faulty removed
   8     8       8       32        8      active sync   /dev/sdc
   9     9       8       48        9      active sync   /dev/sdd
  10    10       8       64       10      active sync   /dev/sde
  11    11       8       80       11      active sync   /dev/sdf
  12    12       8       96       12      active sync   /dev/sdg
  13    13       8        0       13      spare   /dev/sda
mdadm -E /dev/sdl
/dev/sdl:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : 975d6eb2:285eed11:021df236:c2d05073
  Creation Time : Tue Oct 13 23:26:17 2009
     Raid Level : raid5
  Used Dev Size : 1465138496 (1397.26 GiB 1500.30 GB)
     Array Size : 17581661952 (16767.18 GiB 18003.62 GB)
   Raid Devices : 13
  Total Devices : 12
Preferred Minor : 0

    Update Time : Fri Jun  3 23:47:53 2011
          State : clean
 Active Devices : 11
Working Devices : 12
 Failed Devices : 2
  Spare Devices : 1
       Checksum : 1dee41fe - correct
         Events : 156864

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     2       8      128        2      active sync   /dev/sdi

   0     0       8      112        0      active sync   /dev/sdh
   1     1       0        0        1      faulty removed
   2     2       8      128        2      active sync   /dev/sdi
   3     3       8      144        3      active sync   /dev/sdj
   4     4       8      176        4      active sync   /dev/sdl
   5     5       8      192        5      active sync   /dev/sdm
   6     6       8       16        6      active sync   /dev/sdb
   7     7       0        0        7      faulty removed
   8     8       8       32        8      active sync   /dev/sdc
   9     9       8       48        9      active sync   /dev/sdd
  10    10       8       64       10      active sync   /dev/sde
  11    11       8       80       11      active sync   /dev/sdf
  12    12       8       96       12      active sync   /dev/sdg
  13    13       8        0       13      spare   /dev/sda
mdadm -E /dev/sdm
/dev/sdm:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : 975d6eb2:285eed11:021df236:c2d05073
  Creation Time : Tue Oct 13 23:26:17 2009
     Raid Level : raid5
  Used Dev Size : 1465138496 (1397.26 GiB 1500.30 GB)
     Array Size : 17581661952 (16767.18 GiB 18003.62 GB)
   Raid Devices : 13
  Total Devices : 12
Preferred Minor : 0

    Update Time : Fri Jun  3 23:47:53 2011
          State : clean
 Active Devices : 11
Working Devices : 12
 Failed Devices : 2
  Spare Devices : 1
       Checksum : 1dee4210 - correct
         Events : 156864

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     3       8      144        3      active sync   /dev/sdj

   0     0       8      112        0      active sync   /dev/sdh
   1     1       0        0        1      faulty removed
   2     2       8      128        2      active sync   /dev/sdi
   3     3       8      144        3      active sync   /dev/sdj
   4     4       8      176        4      active sync   /dev/sdl
   5     5       8      192        5      active sync   /dev/sdm
   6     6       8       16        6      active sync   /dev/sdb
   7     7       0        0        7      faulty removed
   8     8       8       32        8      active sync   /dev/sdc
   9     9       8       48        9      active sync   /dev/sdd
  10    10       8       64       10      active sync   /dev/sde
  11    11       8       80       11      active sync   /dev/sdf
  12    12       8       96       12      active sync   /dev/sdg
  13    13       8        0       13      spare   /dev/sda
mdadm -E /dev/sdn
/dev/sdn:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : 975d6eb2:285eed11:021df236:c2d05073
  Creation Time : Tue Oct 13 23:26:17 2009
     Raid Level : raid5
  Used Dev Size : 1465138496 (1397.26 GiB 1500.30 GB)
     Array Size : 17581661952 (16767.18 GiB 18003.62 GB)
   Raid Devices : 13
  Total Devices : 12
Preferred Minor : 0

    Update Time : Fri Jun  3 22:49:22 2011
          State : clean
 Active Devices : 11
Working Devices : 12
 Failed Devices : 2
  Spare Devices : 1
       Checksum : 1dee3313 - correct
         Events : 156606

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this    13       8      160       13      spare   /dev/sdk

   0     0       8      112        0      active sync   /dev/sdh
   1     1       0        0        1      faulty removed
   2     2       8      128        2      active sync   /dev/sdi
   3     3       8      144        3      active sync   /dev/sdj
   4     4       8      176        4      active sync   /dev/sdl
   5     5       8      192        5      active sync   /dev/sdm
   6     6       8       16        6      active sync   /dev/sdb
   7     7       0        0        7      faulty removed
   8     8       8       32        8      active sync   /dev/sdc
   9     9       8       48        9      active sync   /dev/sdd
  10    10       8       64       10      active sync   /dev/sde
  11    11       8       80       11      active sync   /dev/sdf
  12    12       8       96       12      active sync   /dev/sdg
  13    13       8      160       13      spare   /dev/sdk

as far as i can see, now there is no error with a missing superblock of one disk.

how can i download lsdrv with "wget"? Yes the way backwards by shrinking lead to the actual problem.
-- 
Empfehlen Sie GMX DSL Ihren Freunden und Bekannten und wir
belohnen Sie mit bis zu 50,- Euro! https://freundschaftswerbung.gmx.de
