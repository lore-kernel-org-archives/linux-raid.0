From: Max Eaves <max@maxeaves.co.uk>
Subject: Problems with RAID6 array mdadm 2.6.9
Date: Tue, 04 May 2010 13:31:40 +0100
Message-ID: <4BE013AC.6070104@maxeaves.co.uk>
Reply-To: max@maxeaves.co.uk
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi there,

I have a problem with one of my RAIDs that has dropped out.

There are 15 drives in my RAID6 structure [/dev/md10].  mdadm kicked out 
three of the drives /dev/sd[jkl]1, and marked them as dirty in dmesg 
[shown at startup].

No problems, so I check out the drives using mdadm --examine /dev/sdj1  
/dev/sdk1 /dev/sdl1.  Sure enough all of the drives are shown.

All seem to have the same magic number; and all look clean.  I am now 
scratching my head a little.  I stop the array using mdadm --stop 
/dev/md10 and then try and an assemble using mdadm --assemble /dev/md10 
/dev/sd[c-q]1  - thats 15 drives, but the system says that it can only 
start 12 drives in the array - not enough devices.

Trying to get these three drives into /dev/md10 says that the drives are 
not valid raid devices.

I have done an fdisk -l /dev/sd[jkl]1 to display the drives - they are 
sure enough autoraid partitions, and seem to be recognised correctly.

fdisk output:

WARNING: GPT (GUID Partition Table) detected on '/dev/sdj'! The util fdisk doesn't support GPT. Use GNU Parted.


Disk /dev/sdj: 1500.3 GB, 1500301910016 bytes
255 heads, 63 sectors/track, 182401 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes

    Device Boot      Start         End      Blocks   Id  System
/dev/sdj1               1      182402  1465138583+  fd  Linux raid autodetect

WARNING: GPT (GUID Partition Table) detected on '/dev/sdk'! The util fdisk doesn't support GPT. Use GNU Parted.


Disk /dev/sdk: 1500.3 GB, 1500301910016 bytes
255 heads, 63 sectors/track, 182401 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes

    Device Boot      Start         End      Blocks   Id  System
/dev/sdk1               1      182402  1465138583+  fd  Linux raid autodetect

WARNING: GPT (GUID Partition Table) detected on '/dev/sdl'! The util fdisk doesn't support GPT. Use GNU Parted.


Disk /dev/sdl: 1500.3 GB, 1500301910016 bytes
255 heads, 63 sectors/track, 182401 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes

    Device Boot      Start         End      Blocks   Id  System
/dev/sdl1               1      182402  1465138583+  fd  Linux raid autodetect


mdadm --examine output of the three effected drives

mdadm --examine /dev/sd[jkl]1

/dev/sdj1:

           Magic : a92b4efc

         Version : 0.90.00

            UUID : 889b595b:90133fa5:8f7588d4:1fb63874

   Creation Time : Fri Feb  5 18:15:53 2010

      Raid Level : raid6

   Used Dev Size : 1465138496 (1397.26 GiB 1500.30 GB)

      Array Size : 19046800448 (18164.44 GiB 19503.92 GB)

    Raid Devices : 15

   Total Devices : 15

Preferred Minor : 10


     Update Time : Wed Apr 28 13:13:39 2010

           State : active

  Active Devices : 15

Working Devices : 15

  Failed Devices : 0

   Spare Devices : 0

        Checksum : 5f9f7818 - correct

          Events : 10


      Chunk Size : 64K


       Number   Major   Minor   RaidDevice State

this     7       8      145        7      active sync   /dev/sdj1


    0     0       8       33        0      active sync   /dev/sdc1

    1     1       8       49        1      active sync   /dev/sdd1

    2     2       8       65        2      active sync   /dev/sde1

    3     3       8       81        3      active sync   /dev/sdf1

    4     4       8       97        4      active sync   /dev/sdg1

    5     5       8      113        5      active sync   /dev/sdh1

    6     6       8      129        6      active sync   /dev/sdi1

    7     7       8      145        7      active sync   /dev/sdj1

    8     8       8      161        8      active sync   /dev/sdk1

    9     9       8      177        9      active sync   /dev/sdl1

   10    10       8      193       10      active sync   /dev/sdm1

   11    11       8      209       11      active sync   /dev/sdn1

   12    12       8      225       12      active sync   /dev/sdo1

   13    13       8      241       13      active sync   /dev/sdp1

   14    14      65        1       14      active sync   /dev/sdq1

/dev/sdk1:

           Magic : a92b4efc

         Version : 0.90.00

            UUID : 889b595b:90133fa5:8f7588d4:1fb63874

   Creation Time : Fri Feb  5 18:15:53 2010

      Raid Level : raid6

   Used Dev Size : 1465138496 (1397.26 GiB 1500.30 GB)

      Array Size : 19046800448 (18164.44 GiB 19503.92 GB)

    Raid Devices : 15

   Total Devices : 15

Preferred Minor : 10


     Update Time : Wed Apr 28 13:13:39 2010

           State : active

  Active Devices : 15

Working Devices : 15

  Failed Devices : 0

   Spare Devices : 0

        Checksum : 5f9f782a - correct

          Events : 10


      Chunk Size : 64K


       Number   Major   Minor   RaidDevice State

this     8       8      161        8      active sync   /dev/sdk1


    0     0       8       33        0      active sync   /dev/sdc1

    1     1       8       49        1      active sync   /dev/sdd1

    2     2       8       65        2      active sync   /dev/sde1

    3     3       8       81        3      active sync   /dev/sdf1

    4     4       8       97        4      active sync   /dev/sdg1

    5     5       8      113        5      active sync   /dev/sdh1

    6     6       8      129        6      active sync   /dev/sdi1

    7     7       8      145        7      active sync   /dev/sdj1

    8     8       8      161        8      active sync   /dev/sdk1

    9     9       8      177        9      active sync   /dev/sdl1

   10    10       8      193       10      active sync   /dev/sdm1

   11    11       8      209       11      active sync   /dev/sdn1

   12    12       8      225       12      active sync   /dev/sdo1

   13    13       8      241       13      active sync   /dev/sdp1

   14    14      65        1       14      active sync   /dev/sdq1

/dev/sdl1:

           Magic : a92b4efc

         Version : 0.90.00

            UUID : 889b595b:90133fa5:8f7588d4:1fb63874

   Creation Time : Fri Feb  5 18:15:53 2010

      Raid Level : raid6

   Used Dev Size : 1465138496 (1397.26 GiB 1500.30 GB)

      Array Size : 19046800448 (18164.44 GiB 19503.92 GB)

    Raid Devices : 15

   Total Devices : 15

Preferred Minor : 10


     Update Time : Wed Apr 28 13:13:39 2010

           State : active

  Active Devices : 15

Working Devices : 15

  Failed Devices : 0

   Spare Devices : 0

        Checksum : 5f9f783c - correct

          Events : 10


      Chunk Size : 64K


       Number   Major   Minor   RaidDevice State

this     9       8      177        9      active sync   /dev/sdl1


    0     0       8       33        0      active sync   /dev/sdc1

    1     1       8       49        1      active sync   /dev/sdd1

    2     2       8       65        2      active sync   /dev/sde1

    3     3       8       81        3      active sync   /dev/sdf1

    4     4       8       97        4      active sync   /dev/sdg1

    5     5       8      113        5      active sync   /dev/sdh1

    6     6       8      129        6      active sync   /dev/sdi1

    7     7       8      145        7      active sync   /dev/sdj1

    8     8       8      161        8      active sync   /dev/sdk1

    9     9       8      177        9      active sync   /dev/sdl1

   10    10       8      193       10      active sync   /dev/sdm1

   11    11       8      209       11      active sync   /dev/sdn1

   12    12       8      225       12      active sync   /dev/sdo1

   13    13       8      241       13      active sync   /dev/sdp1

   14    14      65        1       14      active sync   /dev/sdq1


Trying to get the /dev/md10 to start again - not a valid superblock.

Could somebody please point me the right direction to try and make drive 
/dev/sdj1 /dev/sdk1 /dev/sdl1 not dirty.  Trying to assemble with -A 
--force doesn't seem to cut the mustard either.

Thanks




Max
