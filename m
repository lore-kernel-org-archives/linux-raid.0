From: Andrea Gelmini <andrea.gelmini@gmail.com>
Subject: Unable to assemble a multi-degraded Raid5...
Date: Wed, 24 Nov 2010 11:36:05 +0100
Message-ID: <AANLkTim21s=48i6hbFfmf5RZYaRv-0KiGOkDA2NpQUKn@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.de, bluca@comedia.it
List-Id: linux-raid.ids

Goodmorning,
   thanks a lot for your daily support on the mailing list.
   I've got a problem. Not a big deal (all the important data are
daily backuped), but
   I ask your help 'cause I would like to understand what I do wrong.

   Well, I have an old raid5 made by 4 disks (it has growed and
reshaped, time to time,
   without problem). You can find detail at the end.

   I want copy/clone data on a new set of drive.
   Because number-of-sata-ports-problem I unplagged one of the four.
   So I run a degraded raid, but forcing (from now on) the mount of the
   filesystem in readonly mode.
   After hours of copy, two disks failed (so, 3 degraded minus 2 faults!).

   That's a problem, of course.

   So I try to force an assemble, but it always miss, even re-plugging
the first one.
   I just use the --assemble in such way (as in recipes):
mdadm --assemble --auto=yes --force /dev/md0 /dev/sd[abdf]
mdadm: failed to add /dev/sdd to /dev/md0: Invalid argument
mdadm: failed to add /dev/sda to /dev/md0: Invalid argument
mdadm: /dev/md0 assembled from 2 drives - not enough to start the array.

    And in dmesg:
[  610.072698] md: md0 stopped.
[  610.080432] md: bind<sdb>
[  610.080576] md: bind<sdf>
[  610.080710] md: sdd has same UUID but different superblock to sdf
[  610.080714] md: sdd has different UUID to sdf
[  610.080716] md: export_rdev(sdd)
[  610.080885] md: sda has same UUID but different superblock to sdf
[  610.080888] md: sda has different UUID to sdf
[  610.080890] md: export_rdev(sda)

   Well. I can read the discs with dd to /dev/null (to be sure about
no hardware failure).

   Now, playing with the set of --assemble, --run and --force I had
some note from
   mdadm about shame-on-me-I-didn't-write-down-what-it-did
   something like a forced advance in events numbers, maybe?
   (ok, you can hate me).

   Also, I'm using latest Ubuntu server. I also try mdadm from git repository.

Thanks a lot for your precious help and time,
Andrea

---------------------------------------------------


/dev/sda:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 9969bb23:1ed5d50b:af41a831:27732f7b
  Creation Time : Fri Mar 21 02:33:34 2008
     Raid Level : raid5
  Used Dev Size : 976762368 (931.51 GiB 1000.20 GB)
     Array Size : 2930287104 (2794.54 GiB 3000.61 GB)
   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 0

    Update Time : Tue Nov 23 01:51:39 2010
          State : clean
Internal Bitmap : present
 Active Devices : 4
Working Devices : 4
 Failed Devices : 0
  Spare Devices : 0
       Checksum : 72bd657 - correct
         Events : 58218

         Layout : left-symmetric
     Chunk Size : 256K

      Number   Major   Minor   RaidDevice State
this     0       8        0        0      active sync   /dev/sda

   0     0       8        0        0      active sync   /dev/sda
   1     1       8       16        1      active sync   /dev/sdb
   2     2       8       48        2      active sync   /dev/sdd
   3     3       8       32        3      active sync   /dev/sdc

/dev/sdb:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 9969bb23:1ed5d50b:af41a831:27732f7b
  Creation Time : Fri Mar 21 02:33:34 2008
     Raid Level : raid5
  Used Dev Size : 976762368 (931.51 GiB 1000.20 GB)
     Array Size : 2930287104 (2794.54 GiB 3000.61 GB)


   Raid Devices : 4
  Total Devices : 3
Preferred Minor : 1

    Update Time : Wed Nov 24 02:39:56 2010
          State : clean
Internal Bitmap : present
 Active Devices : 2
Working Devices : 2
 Failed Devices : 1
  Spare Devices : 0
       Checksum : 72d336d - correct
         Events : 58218

         Layout : left-symmetric
     Chunk Size : 256K

      Number   Major   Minor   RaidDevice State
this     1       8       16        1      active sync   /dev/sdb

   0     0       0        0        0      removed
   1     1       8       16        1      active sync   /dev/sdb
   2     2       8       80        2      active sync   /dev/sdf
   3     3       0        0        3      active sync
/dev/sdd:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 9969bb23:1ed5d50b:af41a831:27732f7b
  Creation Time : Fri Mar 21 02:33:34 2008
     Raid Level : raid5
  Used Dev Size : 976762368 (931.51 GiB 1000.20 GB)
     Array Size : 2930287104 (2794.54 GiB 3000.61 GB)
   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 0

    Update Time : Tue Nov 23 01:51:39 2010
          State : clean
Internal Bitmap : present
 Active Devices : 4

Working Devices : 4
 Failed Devices : 0
  Spare Devices : 0
       Checksum : 72bd67d - correct
         Events : 58218

         Layout : left-symmetric
     Chunk Size : 256K

      Number   Major   Minor   RaidDevice State
this     3       8       32        3      active sync   /dev/sdc

   0     0       8        0        0      active sync   /dev/sda
   1     1       8       16        1      active sync   /dev/sdb
   2     2       8       48        2      active sync   /dev/sdd
   3     3       8       32        3      active sync   /dev/sdc

/dev/sdf:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 9969bb23:1ed5d50b:af41a831:27732f7b
  Creation Time : Fri Mar 21 02:33:34 2008
     Raid Level : raid5
  Used Dev Size : 976762368 (931.51 GiB 1000.20 GB)
     Array Size : 2930287104 (2794.54 GiB 3000.61 GB)
   Raid Devices : 4
  Total Devices : 3
Preferred Minor : 1

    Update Time : Wed Nov 24 02:39:56 2010
          State : clean
Internal Bitmap : present
 Active Devices : 2
Working Devices : 2
 Failed Devices : 1
  Spare Devices : 0
       Checksum : 72d33b2 - correct
         Events : 58218

         Layout : left-symmetric
     Chunk Size : 256K

      Number   Major   Minor   RaidDevice State
this     2       8       80        2      active sync   /dev/sdf

   0     0       0        0        0      removed
   1     1       8       16        1      active sync   /dev/sdb
   2     2       8       80        2      active sync   /dev/sdf
   3     3       0        0        3      faulty removed
