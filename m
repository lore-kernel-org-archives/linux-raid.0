From: Dmitry Teytelman <dim@dimtel.com>
Subject: Can this setup be saved?
Date: Fri, 12 Feb 2010 17:56:08 -0800
Message-ID: <c98f60c41002121756j5e8cd32fwdc2cd22ba553d241@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

I've made a mess of my raid setup and am desperately trying to save
it. The setup is RAID-5 on 3 SATA disks. Problems started with one of
the disks getting unrecoverable read errors. Unfortunately I was away
on a trip and the machine was used by my family while this was going
on :(

Array consists of three devices: /dev/sda2, /dev/sdc2, and /dev/sdd2.
When I got back from the trip I found the following:

1. Two disks were removed from the array, leaving only /dev/sda2;
2. When either of the two was added, the array would start;
3. One combination of two disks (/dev/sda2 + /dev/sdd2) aproduced a
running /dev/md0 with a proper ext3 filesystem seen on the drive (even
passing fsck);

At this point I added /dev/sdc2 and the reconstruction started.
However did not complete, since /dev/sdd2 has unrecoverable errors.
Reading the list archives I figured I need another drive to ddrescue
/dev/sdd2, then perform the reconstruction.

However at some point during/after the reconstruction the situation
has changed. Now both /dev/sdc2 and /dev/sdd2 are marked as spare
drives (see mdadm -E output below) and I cannot start the array. I
think /dev/sdd2 should be in sync with /dev/sda2, but how can I bring
it back (it used to be device 2)?

/dev/sda2:
          Magic : a92b4efc
        Version : 0.90.01
           UUID : bd5c2dc0:f76e5f10:a98c4de7:f2020715
  Creation Time : Fri Jun 17 11:47:44 2005
     Raid Level : raid5
  Used Dev Size : 486375808 (463.84 GiB 498.05 GB)
     Array Size : 972751616 (927.69 GiB 996.10 GB)
   Raid Devices : 3
  Total Devices : 1
Preferred Minor : 0

    Update Time : Fri Feb 12 14:07:35 2010
          State : active
 Active Devices : 1
Working Devices : 1
 Failed Devices : 2
  Spare Devices : 0
       Checksum : a4cd0c48 - correct
         Events : 2125155

         Layout : left-symmetric
     Chunk Size : 128K

      Number   Major   Minor   RaidDevice State
this     0       8        2        0      active sync   /dev/sda2

   0     0       8        2        0      active sync   /dev/sda2
   1     1       0        0        1      faulty removed
   2     2       0        0        2      faulty removed

/dev/sdc2:
          Magic : a92b4efc
        Version : 0.90.01
           UUID : bd5c2dc0:f76e5f10:a98c4de7:f2020715
  Creation Time : Fri Jun 17 11:47:44 2005
     Raid Level : raid5
  Used Dev Size : 486375808 (463.84 GiB 498.05 GB)
     Array Size : 972751616 (927.69 GiB 996.10 GB)
   Raid Devices : 3
  Total Devices : 1
Preferred Minor : 0

    Update Time : Fri Feb 12 10:30:00 2010
          State : active
 Active Devices : 1
Working Devices : 1
 Failed Devices : 2
  Spare Devices : 0
       Checksum : a4ccd973 - correct
         Events : 2125153

         Layout : left-symmetric
     Chunk Size : 128K

      Number   Major   Minor   RaidDevice State
this     4       8        2       -1      spare   /dev/sdc2

   0     0       8       34        0      active sync   /dev/sda2
   1     1       0        0        1      faulty removed
   2     2       0        0        2      faulty removed

/dev/sdd2:
          Magic : a92b4efc
        Version : 0.90.01
           UUID : bd5c2dc0:f76e5f10:a98c4de7:f2020715
  Creation Time : Fri Jun 17 11:47:44 2005
     Raid Level : raid5
  Used Dev Size : 486375808 (463.84 GiB 498.05 GB)
     Array Size : 972751616 (927.69 GiB 996.10 GB)
   Raid Devices : 3
  Total Devices : 2
Preferred Minor : 0

    Update Time : Fri Feb 12 10:36:05 2010
          State : active
 Active Devices : 1
Working Devices : 2
 Failed Devices : 2
  Spare Devices : 1
       Checksum : a4ccdb48 - correct
         Events : 2125154

         Layout : left-symmetric
     Chunk Size : 128K

      Number   Major   Minor   RaidDevice State
this     3       8       50        3      spare   /dev/sdd2

   0     0       8       34        0      active sync   /dev/sda2
   1     1       0        0        1      faulty removed
   2     2       0        0        2      faulty removed
   3     3       8       50        3      spare   /dev/sdd2


-- 
Dmitry Teytelman
