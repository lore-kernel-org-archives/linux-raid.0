From: "Greg Nicholson" <d0gz.net@gmail.com>
Subject: Raid5 Reshape gone wrong, please help
Date: Fri, 17 Aug 2007 20:26:26 -0500
Message-ID: <c92bcddf0708171826n5991b3ffw1094e0e8c44c97e8@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I was trying to resize a Raid 5 array of 4 500G drives to 5.  Kernel
version 2.6.23-rc3 was the kernel I STARTED on this.

  I added the device to the array :
mdadm --add /dev/md0 /dev/sdb1

Then I started to grow the array :
 mdadm --grow /dev/md0 --raid-devices=5

At this point the machine locked up.  Not good.

I ended up having to hard reboot.  Now, I have the following in dmesg :

md: md0: raid array is not clean -- starting background reconstruction
raid5: reshape_position too early for auto-recovery - aborting.
md: pers->run() failed ...

/proc/mdstat is :

Personalities : [raid6] [raid5] [raid4]
md0 : inactive sdf1[0] sdb1[4] sdc1[3] sdd1[2] sde1[1]
      2441918720 blocks super 0.91

unused devices: <none>


It doesn't look like it actually DID anything besides update the raid
count to 5 from 4. (I think.)

How do I do a manual recovery on this?


Examining the disks:

 mdadm -E /dev/sdb1
/dev/sdb1:
          Magic : a92b4efc
        Version : 00.91.00
           UUID : a9a472d3:9586c602:9207b56b:a5185bd3
  Creation Time : Thu Dec 21 09:42:27 2006
     Raid Level : raid5
  Used Dev Size : 488383744 (465.76 GiB 500.10 GB)
     Array Size : 1953534976 (1863.04 GiB 2000.42 GB)
   Raid Devices : 5
  Total Devices : 5
Preferred Minor : 0

  Reshape pos'n : 0
  Delta Devices : 1 (4->5)

    Update Time : Fri Aug 17 19:49:43 2007
          State : active
 Active Devices : 5
Working Devices : 5
 Failed Devices : 0
  Spare Devices : 0
       Checksum : c8ebb87b - correct
         Events : 0.2795

         Layout : left-symmetric
     Chunk Size : 256K

      Number   Major   Minor   RaidDevice State
this     4       8       17        4      active sync   /dev/sdb1

   0     0       8       81        0      active sync   /dev/sdf1
   1     1       8       65        1      active sync   /dev/sde1
   2     2       8       49        2      active sync   /dev/sdd1
   3     3       8       33        3      active sync   /dev/sdc1
   4     4       8       17        4      active sync   /dev/sdb1

 mdadm -E /dev/sdc1
/dev/sdc1:
          Magic : a92b4efc
        Version : 00.91.00
           UUID : a9a472d3:9586c602:9207b56b:a5185bd3
  Creation Time : Thu Dec 21 09:42:27 2006
     Raid Level : raid5
  Used Dev Size : 488383744 (465.76 GiB 500.10 GB)
     Array Size : 1953534976 (1863.04 GiB 2000.42 GB)
   Raid Devices : 5
  Total Devices : 5
Preferred Minor : 0

  Reshape pos'n : 0
  Delta Devices : 1 (4->5)

    Update Time : Fri Aug 17 19:49:43 2007
          State : active
 Active Devices : 5
Working Devices : 5
 Failed Devices : 0
  Spare Devices : 0
       Checksum : c8ebb889 - correct
         Events : 0.2795

         Layout : left-symmetric
     Chunk Size : 256K

      Number   Major   Minor   RaidDevice State
this     3       8       33        3      active sync   /dev/sdc1

   0     0       8       81        0      active sync   /dev/sdf1
   1     1       8       65        1      active sync   /dev/sde1
   2     2       8       49        2      active sync   /dev/sdd1
   3     3       8       33        3      active sync   /dev/sdc1
   4     4       8       17        4      active sync   /dev/sdb1

 mdadm -E /dev/sdd1
/dev/sdd1:
          Magic : a92b4efc
        Version : 00.91.00
           UUID : a9a472d3:9586c602:9207b56b:a5185bd3
  Creation Time : Thu Dec 21 09:42:27 2006
     Raid Level : raid5
  Used Dev Size : 488383744 (465.76 GiB 500.10 GB)
     Array Size : 1953534976 (1863.04 GiB 2000.42 GB)
   Raid Devices : 5
  Total Devices : 5
Preferred Minor : 0

  Reshape pos'n : 0
  Delta Devices : 1 (4->5)

    Update Time : Fri Aug 17 19:49:43 2007
          State : active
 Active Devices : 5
Working Devices : 5
 Failed Devices : 0
  Spare Devices : 0
       Checksum : c8ebb897 - correct
         Events : 0.2795

         Layout : left-symmetric
     Chunk Size : 256K

      Number   Major   Minor   RaidDevice State
this     2       8       49        2      active sync   /dev/sdd1

   0     0       8       81        0      active sync   /dev/sdf1
   1     1       8       65        1      active sync   /dev/sde1
   2     2       8       49        2      active sync   /dev/sdd1
   3     3       8       33        3      active sync   /dev/sdc1
   4     4       8       17        4      active sync   /dev/sdb1

/dev/sde1:
          Magic : a92b4efc
        Version : 00.91.00
           UUID : a9a472d3:9586c602:9207b56b:a5185bd3
  Creation Time : Thu Dec 21 09:42:27 2006
     Raid Level : raid5
  Used Dev Size : 488383744 (465.76 GiB 500.10 GB)
     Array Size : 1953534976 (1863.04 GiB 2000.42 GB)
   Raid Devices : 5
  Total Devices : 5
Preferred Minor : 0

  Reshape pos'n : 0
  Delta Devices : 1 (4->5)

    Update Time : Fri Aug 17 19:49:43 2007
          State : active
 Active Devices : 5
Working Devices : 5
 Failed Devices : 0
  Spare Devices : 0
       Checksum : c8ebb8a5 - correct
         Events : 0.2795

         Layout : left-symmetric
     Chunk Size : 256K

      Number   Major   Minor   RaidDevice State
this     1       8       65        1      active sync   /dev/sde1

   0     0       8       81        0      active sync   /dev/sdf1
   1     1       8       65        1      active sync   /dev/sde1
   2     2       8       49        2      active sync   /dev/sdd1
   3     3       8       33        3      active sync   /dev/sdc1
   4     4       8       17        4      active sync   /dev/sdb1

/dev/sdf1:
          Magic : a92b4efc
        Version : 00.91.00
           UUID : a9a472d3:9586c602:9207b56b:a5185bd3
  Creation Time : Thu Dec 21 09:42:27 2006
     Raid Level : raid5
  Used Dev Size : 488383744 (465.76 GiB 500.10 GB)
     Array Size : 1953534976 (1863.04 GiB 2000.42 GB)
   Raid Devices : 5
  Total Devices : 5
Preferred Minor : 0

  Reshape pos'n : 0
  Delta Devices : 1 (4->5)

    Update Time : Fri Aug 17 19:49:43 2007
          State : active
 Active Devices : 5
Working Devices : 5
 Failed Devices : 0
  Spare Devices : 0
       Checksum : c8ebb8b3 - correct
         Events : 0.2795

         Layout : left-symmetric
     Chunk Size : 256K

      Number   Major   Minor   RaidDevice State
this     0       8       81        0      active sync   /dev/sdf1

   0     0       8       81        0      active sync   /dev/sdf1
   1     1       8       65        1      active sync   /dev/sde1
   2     2       8       49        2      active sync   /dev/sdd1
   3     3       8       33        3      active sync   /dev/sdc1
   4     4       8       17        4      active sync   /dev/sdb1
