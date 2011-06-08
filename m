From: "Dragon" <Sunghost@gmx.de>
Subject: Re: SRaid with 13 Disks crashed
Date: Wed, 08 Jun 2011 22:02:46 +0200
Message-ID: <20110608200246.135930@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: philip@turmel.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Dragon,

On 06/08/2011 10:24 AM, Dragon wrote:
> SRaid with 13 Disks crashed
> Hello,
> 
> 
> this seems to be my last chance to get back all of my data from a sw-raid5 with
12-13 disks.
> i use debian ( 2.6.32-bpo.5-amd64) and last i wanted to grow the raid from 12 to
13 disk with a size at all of 18tb. after run mke2fs i must see that the tool on
ext4 allow a maximum size of 16tb. after that i wanted to shrink the size back to
12 disk and now the raid is gone.

Did you actually mean "mke2fs" ?  It destroys existing data.  I hope you meant
"resize2fs".

> i tried some assemble and examine things but without success.
> 
> here some information:
>  cat /proc/mdstat
> Personalities : [raid6] [raid5] [raid4]
> md0 : inactive sdh[0](S) sda[13](S) sdg[12](S) sdf[11](S) sde[10](S) sdd[9](S)
sdc[8](S) sdb[6](S) sdm[5](S) sdl[4](S) sdj[3](S) sdi[2](S)
>       17581661952 blocks
> 
> unused devices: <none>
> 
> mdadm --detail /dev/md0
> mdadm: md device /dev/md0 does not appear to be active.
> 
>  mdadm --assemble --force -v /dev/md0 /dev/sdh /dev/sda /dev/sdg /dev/sdf /dev/sde
/dev/sdd /dev/sdc /dev/sdb /dev/sdm /dev/sdl /dev/sdj /dev/sdi
--update=super-minor /dev/sdh

Was /dev/sdk supposed to be in this list?

> mdadm: looking for devices for /dev/md0
> mdadm: updating superblock of /dev/sdh with minor number 0
> mdadm: /dev/sdh is identified as a member of /dev/md0, slot 0.
> mdadm: updating superblock of /dev/sda with minor number 0
> mdadm: /dev/sda is identified as a member of /dev/md0, slot 13.

This is suspicious.  Looks like sda was added as a spare?

> mdadm: updating superblock of /dev/sdg with minor number 0
> mdadm: /dev/sdg is identified as a member of /dev/md0, slot 12.
> mdadm: updating superblock of /dev/sdf with minor number 0
> mdadm: /dev/sdf is identified as a member of /dev/md0, slot 11.
> mdadm: updating superblock of /dev/sde with minor number 0
> mdadm: /dev/sde is identified as a member of /dev/md0, slot 10.
> mdadm: updating superblock of /dev/sdd with minor number 0
> mdadm: /dev/sdd is identified as a member of /dev/md0, slot 9.
> mdadm: updating superblock of /dev/sdc with minor number 0
> mdadm: /dev/sdc is identified as a member of /dev/md0, slot 8.
> mdadm: updating superblock of /dev/sdb with minor number 0
> mdadm: /dev/sdb is identified as a member of /dev/md0, slot 6.
> mdadm: updating superblock of /dev/sdm with minor number 0
> mdadm: /dev/sdm is identified as a member of /dev/md0, slot 5.
> mdadm: updating superblock of /dev/sdl with minor number 0
> mdadm: /dev/sdl is identified as a member of /dev/md0, slot 4.
> mdadm: updating superblock of /dev/sdj with minor number 0
> mdadm: /dev/sdj is identified as a member of /dev/md0, slot 3.
> mdadm: updating superblock of /dev/sdi with minor number 0
> mdadm: /dev/sdi is identified as a member of /dev/md0, slot 2.
> mdadm: updating superblock of /dev/sdh with minor number 0
> mdadm: /dev/sdh is identified as a member of /dev/md0, slot 0.
> mdadm: no uptodate device for slot 1 of /dev/md0
> mdadm: added /dev/sdi to /dev/md0 as 2
> mdadm: added /dev/sdj to /dev/md0 as 3
> mdadm: added /dev/sdl to /dev/md0 as 4
> mdadm: added /dev/sdm to /dev/md0 as 5
> mdadm: added /dev/sdb to /dev/md0 as 6
> mdadm: no uptodate device for slot 7 of /dev/md0
> mdadm: added /dev/sdc to /dev/md0 as 8
> mdadm: added /dev/sdd to /dev/md0 as 9
> mdadm: added /dev/sde to /dev/md0 as 10
> mdadm: added /dev/sdf to /dev/md0 as 11
> mdadm: added /dev/sdg to /dev/md0 as 12
> mdadm: added /dev/sda to /dev/md0 as 13
> mdadm: added /dev/sdh to /dev/md0 as 0
> mdadm: /dev/md0 assembled from 11 drives and 1 spare - not enough to start the array.

Indeed.  Your problem is likely to be /dev/sda.

> mdadm.conf
> #old=ARRAY /dev/md0 level=raid5 num-devices=13 metadata=0.90
UUID=975d6eb2:285eed11:021df236:c2d05073
> ARRAY /dev/md0 UUID=975d6eb2:285eed11:021df236:c2d05073
> 
> Hope some can help. Thx

Please share the output of "mdadm -E /dev/sd[abcdefghijklm]"

Phil
-------------------
Sorry my misstake, of course "resize2fs".
"Was /dev/sdk supposed to be in this list?"
->yes was a part of the raid, but i think something happends with the uuid and now its the system and boot disk. for explanation the raid is stand alone 
"This is suspicious.  Looks like sda was added as a spare?"
->last i wanted to downgrade the raid from 13 to 12 and there for take a disk and marked it as spare, but it was the sda, uuid problem?
->
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
 mdadm -E /dev/sdc
/dev/sdc:
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
 mdadm -E /dev/sdk
mdadm: No md superblock detected on /dev/sdk.
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
 mdadm -E /dev/sdo
mdadm: No md superblock detected on /dev/sdo.
nassrv01:~# fdisk -l |grep sd
Disk /dev/sda: 1500.3 GB, 1500301910016 bytes
Disk /dev/sdb: 1500.3 GB, 1500301910016 bytes
Disk /dev/sdc: 1500.3 GB, 1500301910016 bytes
Disk /dev/sdd: 1500.3 GB, 1500301910016 bytes
Disk /dev/sde: 1500.3 GB, 1500301910016 bytes
Disk /dev/sdf: 1500.3 GB, 1500301910016 bytes
Disk /dev/sdg: 1500.3 GB, 1500301910016 bytes
Disk /dev/sdh: 1500.3 GB, 1500301910016 bytes
Disk /dev/sdi: 1500.3 GB, 1500301910016 bytes
Disk /dev/sdj: 1500.3 GB, 1500301910016 bytes
Disk /dev/sdk: 20.4 GB, 20409532416 bytes
/dev/sdk1   *           1        2372    19053058+  83  Linux
/dev/sdk2            2373        2481      875542+   5  Extended
/dev/sdk5            2373        2481      875511   82  Linux swap / Solaris
Disk /dev/sdl: 1500.3 GB, 1500301910016 bytes
Disk /dev/sdm: 1500.3 GB, 1500301910016 bytes
Disk /dev/sdn: 1500.3 GB, 1500301910016 bytes
Disk /dev/sdo: 1500.3 GB, 1500301910016 bytes
/dev/sdo1               1      182401  1465136001   83  Linux

Hope that helps. thx
-- 
Empfehlen Sie GMX DSL Ihren Freunden und Bekannten und wir
belohnen Sie mit bis zu 50,- Euro! https://freundschaftswerbung.gmx.de
