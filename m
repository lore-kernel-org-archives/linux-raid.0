From: Frank Baumgart <frank.baumgart@gmx.net>
Subject: RAID5 superblocks partly messed up after degradation
Date: Mon, 09 Apr 2007 20:04:39 +0200
Message-ID: <461A8037.7050300@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

hopefully someone can help me.

MD RAID 5 with 4 disks (3x SATA, 1x PATA) of 300 GB each; Kernel
2.6.19.5, openSUSE 10.2

One of the SATA disks had incoverable read errors when copying data so
the disk was marked "bad" by MD
and the array as degraded.

As I had no spare but the array was supposed to be upgraded to 4 x 500
GB anyway I chose to install two
additional SATA controllers, attach 4 SATA 500 GB disks to them and
create a new MD RAID 5 on these
(using openSUSE 10.2 (kernel 2.6.18.x) as rescue disk) to copy over the
data from the degraded one.
I only touched those blank 500 GB disks but maybe SUSE messed up things
because the kernel recognized
one of the disks twice (once as SATA (/dev/sd..) and once as PATA
"shadow" (/dev/hd..; not really accessible
and not a duplicate of any existing driver)). This may have caused the
problem I now have:

The 4 x 300 RAID can not be assembled anymore.

mdadm --assemble --verbose --no-degraded /dev/md5 /dev/hdc1 /dev/sdb1
/dev/sdc1 /dev/sdd1

mdadm: looking for devices for /dev/md5
mdadm: /dev/hdc1 is identified as a member of /dev/md5, slot 2.
mdadm: /dev/sdb1 is identified as a member of /dev/md5, slot 3.
mdadm: /dev/sdc1 is identified as a member of /dev/md5, slot 0.
mdadm: /dev/sdd1 is identified as a member of /dev/md5, slot 1.
mdadm: added /dev/sdd1 to /dev/md5 as 1
mdadm: failed to add /dev/hdc1 to /dev/md5: Invalid argument
mdadm: failed to add /dev/sdb1 to /dev/md5: Invalid argument
mdadm: failed to add /dev/sdc1 to /dev/md5: Invalid argument
mdadm: /dev/md5 assembled from 0 drives (out of 4), but not started.

Detaching sdb (the faulty disk) does not make any difference.

When looking at the superblocks only the sdd1 superblock looks ok but
sdb1, sdc1 and hdc1 look
weird:

/dev/hdc1:
          Magic : a92b4efc
        Version : 00.90.03
           UUID : 5bf2ddc1:c64ab6ba:7364bdad:c081d4e6
  Creation Time : Fri Jan 20 23:24:21 2006
     Raid Level : raid5
    Device Size : 281145408 (268.12 GiB 287.89 GB)
     Array Size : 843436224 (804.36 GiB 863.68 GB)
   Raid Devices : 4
  Total Devices : 3
Preferred Minor : 0

    Update Time : Tue Mar 27 22:00:53 2007
          State : clean
Active Devices : 3
Working Devices : 3
Failed Devices : 1
  Spare Devices : 0
       Checksum : 9a0111e7 - correct
         Events : 0.649118

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     2      22        1        2      active sync   /dev/hdc1

   0     0       8       65        0      active sync
   1     1       0        0        1      faulty removed
   2     2      22        1        2      active sync   /dev/hdc1
   3     3       8       49        3      active sync   /dev/sdd1


/dev/sdb1:
          Magic : a92b4efc
        Version : 00.90.03
           UUID : 5bf2ddc1:c64ab6ba:7364bdad:c081d4e6
  Creation Time : Fri Jan 20 23:24:21 2006
     Raid Level : raid5
    Device Size : 281145408 (268.12 GiB 287.89 GB)
     Array Size : 843436224 (804.36 GiB 863.68 GB)
   Raid Devices : 4
  Total Devices : 3
Preferred Minor : 0

    Update Time : Tue Mar 27 22:00:53 2007
          State : clean
Active Devices : 3
Working Devices : 3
Failed Devices : 1
  Spare Devices : 0
       Checksum : 9a01120b - correct
         Events : 0.649118

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     3       8       49        3      active sync
/dev/sdd1         <- what's this? why "SDD"? This is "SDB"! also, this
is the faulty device!

   0     0       8       65        0      active sync
   1     1       0        0        1      faulty removed
   2     2      22        1        2      active sync   /dev/hdc1
   3     3       8       49        3      active sync   /dev/sdd1



/dev/sdc1:
          Magic : a92b4efc
        Version : 00.90.03
           UUID : 5bf2ddc1:c64ab6ba:7364bdad:c081d4e6
  Creation Time : Fri Jan 20 23:24:21 2006
     Raid Level : raid5
    Device Size : 281145408 (268.12 GiB 287.89 GB)
     Array Size : 843436224 (804.36 GiB 863.68 GB)
   Raid Devices : 4
  Total Devices : 3
Preferred Minor : 0

    Update Time : Tue Mar 27 22:00:53 2007
          State : clean
Active Devices : 3
Working Devices : 3
Failed Devices : 1
  Spare Devices : 0
       Checksum : 9a011215 - correct
         Events : 0.649118

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     0       8       65        0      active
sync                            <- where is the device name?

   0     0       8       65        0      active sync
   1     1       0        0        1      faulty removed
   2     2      22        1        2      active sync   /dev/hdc1
   3     3       8       49        3      active sync   /dev/sdd1


/dev/sdd1:
          Magic : a92b4efc
        Version : 00.90.03
           UUID : 5bf2ddc1:c64ab6ba:7364bdad:c081d4e6
  Creation Time : Fri Jan 20 23:24:21 2006
     Raid Level : raid5
    Device Size : 281145408 (268.12 GiB 287.89 GB)
     Array Size : 843436224 (804.36 GiB 863.68 GB)
   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 3

    Update Time : Mon Mar 26 23:24:00 2007
          State : clean
Active Devices : 4                            <- only here we have 4
active and working devices (claimed)
Working Devices : 4
Failed Devices : 0
  Spare Devices : 0
       Checksum : 99ffd155 - correct
         Events : 0.648778

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     1       8       49        1      active sync   /dev/sdd1

   0     0       8       33        0      active sync   /dev/sdc1
   1     1       8       49        1      active sync   /dev/sdd1
   2     2      22        1        2      active sync   /dev/hdc1
   3     3       8       17        3      active sync   /dev/sdb1


Thanks for any help.

Frank


