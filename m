From: "Robin Bowes" <robin-lists@robinbowes.com>
Subject: Re: Is my RAID 5 array working OK?
Date: Sun, 4 Jul 2004 21:51:23 +0100 (BST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1638.192.168.1.2.1088974283.squirrel@192.168.1.2>
References: <1483.192.168.1.2.1088970622.squirrel@192.168.1.2>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1483.192.168.1.2.1088970622.squirrel@192.168.1.2>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, July 4, 2004 20:50, Robin Bowes said:
> Number   Major   Minor   RaidDevice State
> 0       8        2        0      active sync   /dev/sda2 1       8       18        1
> active sync   /dev/sdb2 2       8       34        2      active sync   /dev/sdc2
> 3       8       50        3      active sync   /dev/sdd2
> 4       8       66        4      active sync   /dev/sde2
> 5       0        0       -1      removed
> 6       8       82        5      spare   /dev/sdf2
> UUID : 2950b4e7:893db3f0:090135ec:f9ca1574
> Events : 0.177301

OK, so I guess I just need to wait until it finishes!

Unfortunately, I now see this:

# mdadm --detail /dev/md5
/dev/md5:
        Version : 00.90.01
  Creation Time : Sun Jul  4 21:24:57 2004
     Raid Level : raid5
     Array Size : 1218208000 (1161.77 GiB 1247.44 GB)
    Device Size : 243641600 (232.35 GiB 249.49 GB)
   Raid Devices : 6
  Total Devices : 6
Preferred Minor : 5
    Persistence : Superblock is persistent

    Update Time : Sun Jul  4 21:57:13 2004
          State : clean, no-errors
 Active Devices : 4
Working Devices : 5
 Failed Devices : 1
  Spare Devices : 1

         Layout : left-symmetric
     Chunk Size : 128K

    Number   Major   Minor   RaidDevice State
       0       8        2        0      active sync   /dev/sda2
       1       0        0       -1      removed
       2       8       34        2      active sync   /dev/sdc2
       3       8       50        3      active sync   /dev/sdd2
       4       8       66        4      active sync   /dev/sde2
       5       0        0       -1      removed
       6       8       82        5      spare   /dev/sdf2
       7       8       18       -1      faulty   /dev/sdb2
           UUID : 2464f7cb:7f57ffdb:fe2dcd80:fc896946
         Events : 0.819771

Checking the logs shows this in /var/log/messages:

Jul  4 21:43:09 dude kernel: scsi1: ERROR on channel 0, id 0, lun 0, CDB: Read (
10) 00 01 c6 1f f7 00 03 00 00
Jul  4 21:43:09 dude kernel: Current sdb: sense key Medium Error
Jul  4 21:43:09 dude kernel: Additional sense: Unrecovered read error - auto rea
llocate failed
Jul  4 21:43:09 dude kernel: end_request: I/O error, dev sdb, sector 29761527
Jul  4 21:43:10 dude kernel: scsi1: ERROR on channel 0, id 0, lun 0, CDB: Read (
10) 00 01 c6 1f f8 00 02 ff 00
Jul  4 21:43:10 dude kernel: Current sdb: sense key Medium Error
Jul  4 21:43:10 dude kernel: Additional sense: Unrecovered read error - auto rea
llocate failed
Jul  4 21:43:10 dude kernel: end_request: I/O error, dev sdb, sector 29761528
Jul  4 21:43:11 dude kernel: scsi1: ERROR on channel 0, id 0, lun 0, CDB: Read (
10) 00 01 c6 1f f9 00 02 fe 00
Jul  4 21:43:11 dude kernel: Current sdb: sense key Medium Error
Jul  4 21:43:11 dude kernel: Additional sense: Unrecovered read error - auto rea
llocate failed
Jul  4 21:43:11 dude kernel: end_request: I/O error, dev sdb, sector 29761529
Jul  4 21:43:13 dude kernel: scsi1: ERROR on channel 0, id 0, lun 0, CDB: Read (
10) 00 01 c6 1f fa 00 02 fd 00
Jul  4 21:43:13 dude kernel: Current sdb: sense key Medium Error
Jul  4 21:43:13 dude kernel: Additional sense: Unrecovered read error - auto rea
llocate failed
Jul  4 21:43:13 dude kernel: end_request: I/O error, dev sdb, sector 29761530
Jul  4 21:43:14 dude kernel: scsi1: ERROR on channel 0, id 0, lun 0, CDB: Read (
10) 00 01 c6 1f fb 00 02 fc 00
Jul  4 21:43:14 dude kernel: Current sdb: sense key Medium Error
Jul  4 21:43:14 dude kernel: Additional sense: Unrecovered read error - auto rea
llocate failed
Jul  4 21:43:14 dude kernel: end_request: I/O error, dev sdb, sector 29761531
Jul  4 21:43:15 dude kernel: scsi1: ERROR on channel 0, id 0, lun 0, CDB: Read (
10) 00 01 c6 1f fc 00 02 fb 00
Jul  4 21:43:15 dude kernel: Current sdb: sense key Medium Error
Jul  4 21:43:15 dude kernel: Additional sense: Unrecovered read error - auto rea
llocate failed
Jul  4 21:43:15 dude kernel: end_request: I/O error, dev sdb, sector 29761532
Jul  4 21:43:17 dude kernel: scsi1: ERROR on channel 0, id 0, lun 0, CDB: Read (
10) 00 01 c6 1f fd 00 02 fa 00
Jul  4 21:43:17 dude kernel: Current sdb: sense key Medium Error
Jul  4 21:43:17 dude kernel: Additional sense: Unrecovered read error - auto rea
llocate failed
Jul  4 21:43:17 dude kernel: end_request: I/O error, dev sdb, sector 29761533
Jul  4 21:43:18 dude kernel: scsi1: ERROR on channel 0, id 0, lun 0, CDB: Read (
10) 00 01 c6 1f fe 00 02 f9 00
Jul  4 21:43:18 dude kernel: Current sdb: sense key Medium Error
Jul  4 21:43:18 dude kernel: Additional sense: Unrecovered read error - auto rea
llocate failed
Jul  4 21:43:18 dude kernel: end_request: I/O error, dev sdb, sector 29761534
Jul  4 21:43:18 dude kernel: raid5: Disk failure on sdb2, disabling device. Oper
ation continuing on 4 devices
Jul  4 21:43:20 dude kernel: scsi1: ERROR on channel 0, id 0, lun 0, CDB: Read (
10) 00 01 c6 1f ff 00 02 f8 00
Jul  4 21:43:20 dude kernel: Current sdb: sense key Medium Error
Jul  4 21:43:20 dude kernel: Additional sense: Unrecovered read error - auto rea
llocate failed
Jul  4 21:43:20 dude kernel: end_request: I/O error, dev sdb, sector 29761535
Jul  4 21:43:21 dude kernel: scsi1: ERROR on channel 0, id 0, lun 0, CDB: Read (
10) 00 01 c6 20 00 00 02 f7 00
Jul  4 21:43:21 dude kernel: Current sdb: sense key Medium Error
Jul  4 21:43:21 dude kernel: Additional sense: Unrecovered read error - auto rea
llocate failed
Jul  4 21:43:21 dude kernel: end_request: I/O error, dev sdb, sector 29761536
Jul  4 21:43:23 dude kernel: md: md5: sync done.
Jul  4 21:43:23 dude kernel: RAID5 conf printout:
Jul  4 21:43:23 dude kernel:  --- rd:6 wd:4 fd:2
Jul  4 21:43:23 dude kernel:  disk 0, o:1, dev:sda2
Jul  4 21:43:23 dude kernel:  disk 1, o:0, dev:sdb2
Jul  4 21:43:23 dude kernel:  disk 2, o:1, dev:sdc2
Jul  4 21:43:23 dude kernel:  disk 3, o:1, dev:sdd2
Jul  4 21:43:23 dude kernel:  disk 4, o:1, dev:sde2
Jul  4 21:43:23 dude kernel:  disk 5, o:1, dev:sdf2
Jul  4 21:43:23 dude kernel: RAID5 conf printout:
Jul  4 21:43:23 dude kernel:  --- rd:6 wd:4 fd:2
Jul  4 21:43:23 dude kernel:  disk 0, o:1, dev:sda2
Jul  4 21:43:23 dude kernel:  disk 2, o:1, dev:sdc2
Jul  4 21:43:23 dude kernel:  disk 3, o:1, dev:sdd2
Jul  4 21:43:23 dude kernel:  disk 4, o:1, dev:sde2
Jul  4 21:43:23 dude kernel:  disk 5, o:1, dev:sdf2

Is this likely to be anything other than a bad disk?

R.
-- 
http://robinbowes.com

