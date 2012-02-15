From: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Subject: mdadm dropped disk, won't re-add
Date: Wed, 15 Feb 2012 14:58:42 +0100
Message-ID: <1329314322.3574.16.camel@z6>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-2zKLvRJ+bBY2uIBiSvL3"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--=-2zKLvRJ+bBY2uIBiSvL3
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

Hello,

I have a rather big problem with my Linux software RAID5.

It consists of 4 SATA disks each 1 TB in size, resulting in a 3 TB RAID5
volume (/dev/md0 assembled from /dev/sd{b,c,d,e}1.

Today, mdadm kicked disk sde1 from the RAID since the cable seemed to
make problems. I shutdown the machine, replaced the cable and tried
re-adding the disk, however, mdadm refused to add the drive.

So I re-partioned sde1 and added it as a new devices, mdadm instantly
started rebuilding the raid. Unfortunately, during the rebuild, mdadm
decided to kick sdc1 and I have now ended up with two drives failing.

I have tried re-adding sdc1 with the --re-add command, but mdadm again
refuses to re-add the drive.

I haven't changed anything since as I don't know what to do further. I
don't want to make any further damage to the raid and hope that someone
knows how to restore it.

My primary question is whether mdadm actually deletes any important data
on the remaining disks (sd{b,c,d}1) while rebuilding or whether it just
writes data to the newly added disk sde1.

mdadm is version 3.2.3, kernel is Linux 3.2.0 on Debian Wheezy.

Can anyone give further advise?

I'm attaching the output of mdadm -E /dev/sd{b,c,d,e}1.

Kind Regards,

Adrian

--=-2zKLvRJ+bBY2uIBiSvL3
Content-Disposition: attachment; filename="mddata.txt"
Content-Type: text/plain; name="mddata.txt"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

/dev/sdb1:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : 6db22c7b:7d9287e2:d01e5766:86e12a40 (local to host z6)
  Creation Time : Fri Apr 23 13:53:33 2010
     Raid Level : raid5
  Used Dev Size : 976759936 (931.51 GiB 1000.20 GB)
     Array Size : 2930279808 (2794.53 GiB 3000.61 GB)
   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 0

    Update Time : Wed Feb 15 13:27:31 2012
          State : clean
 Active Devices : 2
Working Devices : 3
 Failed Devices : 2
  Spare Devices : 1
       Checksum : c0bf6492 - correct
         Events : 311622

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     1       8       17        1      active sync   /dev/sdb1

   0     0       8       49        0      active sync   /dev/sdd1
   1     1       8       17        1      active sync   /dev/sdb1
   2     2       0        0        2      faulty removed
   3     3       0        0        3      faulty removed
   4     4       8       65        4      spare   /dev/sde1
/dev/sdc1:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : 6db22c7b:7d9287e2:d01e5766:86e12a40 (local to host z6)
  Creation Time : Fri Apr 23 13:53:33 2010
     Raid Level : raid5
  Used Dev Size : 976759936 (931.51 GiB 1000.20 GB)
     Array Size : 2930279808 (2794.53 GiB 3000.61 GB)
   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 0

    Update Time : Wed Feb 15 13:25:25 2012
          State : clean
 Active Devices : 3
Working Devices : 4
 Failed Devices : 1
  Spare Devices : 1
       Checksum : c0bf6411 - correct
         Events : 311617

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     3       8       33        3      active sync   /dev/sdc1

   0     0       8       49        0      active sync   /dev/sdd1
   1     1       8       17        1      active sync   /dev/sdb1
   2     2       0        0        2      faulty removed
   3     3       8       33        3      active sync   /dev/sdc1
   4     4       8       65        4      spare   /dev/sde1
/dev/sdd1:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : 6db22c7b:7d9287e2:d01e5766:86e12a40 (local to host z6)
  Creation Time : Fri Apr 23 13:53:33 2010
     Raid Level : raid5
  Used Dev Size : 976759936 (931.51 GiB 1000.20 GB)
     Array Size : 2930279808 (2794.53 GiB 3000.61 GB)
   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 0

    Update Time : Wed Feb 15 13:27:31 2012
          State : clean
 Active Devices : 2
Working Devices : 3
 Failed Devices : 2
  Spare Devices : 1
       Checksum : c0bf64b0 - correct
         Events : 311622

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     0       8       49        0      active sync   /dev/sdd1

   0     0       8       49        0      active sync   /dev/sdd1
   1     1       8       17        1      active sync   /dev/sdb1
   2     2       0        0        2      faulty removed
   3     3       0        0        3      faulty removed
   4     4       8       65        4      spare   /dev/sde1
/dev/sde1:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : 6db22c7b:7d9287e2:d01e5766:86e12a40 (local to host z6)
  Creation Time : Fri Apr 23 13:53:33 2010
     Raid Level : raid5
  Used Dev Size : 976759936 (931.51 GiB 1000.20 GB)
     Array Size : 2930279808 (2794.53 GiB 3000.61 GB)
   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 0

    Update Time : Wed Feb 15 13:27:31 2012
          State : clean
 Active Devices : 2
Working Devices : 3
 Failed Devices : 2
  Spare Devices : 1
       Checksum : c0bf64c2 - correct
         Events : 311622

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     4       8       65        4      spare   /dev/sde1

   0     0       8       49        0      active sync   /dev/sdd1
   1     1       8       17        1      active sync   /dev/sdb1
   2     2       0        0        2      faulty removed
   3     3       0        0        3      faulty removed
   4     4       8       65        4      spare   /dev/sde1

--=-2zKLvRJ+bBY2uIBiSvL3--

