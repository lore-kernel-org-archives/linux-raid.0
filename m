From: Karl Wilbur <karl@karlwilbur.net>
Subject: Recovering RAID-6 from a Failed Grow
Date: Wed, 26 Feb 2014 02:14:47 -0500
Message-ID: <CAMuGJSm2EtoMja5dEchFERW0-Mj1Cj0UjU4n55ETeegLkpT_cw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello all,

I have, well had, a RAID-6 with 8 drives. I went to add an additional
drive. At about 98% complete the system locked up completely and had
to be rebooted. One of the SATA controllers seems to have failed and
the 3 drives connected to it were relocated to different
controllers.As a result, those 3 drives were marked as failed.

The new drive being added was sdg. It was added successfully, but I
wanted to --grow the array to include it as an array device rather
than a space.

Here is the --explain output for all the drives, post reboot. (prior
to removing them from the failing controller).

#################
/dev/sdb:
          Magic : a92b4efc
        Version : 0.91.00
           UUID : 2390bb2c:13899501:227fac17:e5d68dde
  Creation Time : Tue Jun 25 01:53:47 2013
     Raid Level : raid6
  Used Dev Size : 976762496 (931.51 GiB 1000.20 GB)
     Array Size : 6837337472 (6520.59 GiB 7001.43 GB)
   Raid Devices : 9
  Total Devices : 9
Preferred Minor : 0

  Reshape pos'n : 6743555840 (6431.16 GiB 6905.40 GB)
  Delta Devices : 1 (8->9)

    Update Time : Sun Feb 23 21:29:06 2014
          State : active
 Active Devices : 6
Working Devices : 6
 Failed Devices : 3
  Spare Devices : 0
       Checksum : eb8f49b9 - correct
         Events : 22704

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     0       8       16        0      active sync   /dev/sdb

   0     0       8       16        0      active sync   /dev/sdb
   1     1       0        0        1      faulty removed
   2     2       8      112        2      active sync   /dev/sdh
   3     3       0        0        3      faulty removed
   4     4       8      144        4      active sync   /dev/sdj
   5     5       8      128        5      active sync   /dev/sdi
   6     6       0        0        6      faulty removed
   7     7       8       32        7      active sync   /dev/sdc
   8     8       8       96        8      active sync   /dev/sdg
/dev/sdc:
          Magic : a92b4efc
        Version : 0.91.00
           UUID : 2390bb2c:13899501:227fac17:e5d68dde
  Creation Time : Tue Jun 25 01:53:47 2013
     Raid Level : raid6
  Used Dev Size : 976762496 (931.51 GiB 1000.20 GB)
     Array Size : 6837337472 (6520.59 GiB 7001.43 GB)
   Raid Devices : 9
  Total Devices : 9
Preferred Minor : 0

  Reshape pos'n : 6743555840 (6431.16 GiB 6905.40 GB)
  Delta Devices : 1 (8->9)

    Update Time : Sun Feb 23 21:29:06 2014
          State : active
 Active Devices : 6
Working Devices : 6
 Failed Devices : 3
  Spare Devices : 0
       Checksum : eb8f49d7 - correct
         Events : 22704

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     7       8       32        7      active sync   /dev/sdc

   0     0       8       16        0      active sync   /dev/sdb
   1     1       0        0        1      faulty removed
   2     2       8      112        2      active sync   /dev/sdh
   3     3       0        0        3      faulty removed
   4     4       8      144        4      active sync   /dev/sdj
   5     5       8      128        5      active sync   /dev/sdi
   6     6       0        0        6      faulty removed
   7     7       8       32        7      active sync   /dev/sdc
   8     8       8       96        8      active sync   /dev/sdg
/dev/sdd:
          Magic : a92b4efc
        Version : 0.91.00
           UUID : 2390bb2c:13899501:227fac17:e5d68dde
  Creation Time : Tue Jun 25 01:53:47 2013
     Raid Level : raid6
  Used Dev Size : 976762496 (931.51 GiB 1000.20 GB)
     Array Size : 6837337472 (6520.59 GiB 7001.43 GB)
   Raid Devices : 9
  Total Devices : 9
Preferred Minor : 0

  Reshape pos'n : 6743555840 (6431.16 GiB 6905.40 GB)
  Delta Devices : 1 (8->9)

    Update Time : Sun Feb 23 21:25:57 2014
          State : clean
 Active Devices : 9
Working Devices : 9
 Failed Devices : 0
  Spare Devices : 0
       Checksum : eb8fa18e - correct
         Events : 22701

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     6       8       48        6      active sync   /dev/sdd

   0     0       8       16        0      active sync   /dev/sdb
   1     1       8       80        1      active sync   /dev/sdf
   2     2       8      112        2      active sync   /dev/sdh
   3     3       8       64        3      active sync   /dev/sde
   4     4       8      144        4      active sync   /dev/sdj
   5     5       8      128        5      active sync   /dev/sdi
   6     6       8       48        6      active sync   /dev/sdd
   7     7       8       32        7      active sync   /dev/sdc
   8     8       8       96        8      active sync   /dev/sdg
/dev/sde:
          Magic : a92b4efc
        Version : 0.91.00
           UUID : 2390bb2c:13899501:227fac17:e5d68dde
  Creation Time : Tue Jun 25 01:53:47 2013
     Raid Level : raid6
  Used Dev Size : 976762496 (931.51 GiB 1000.20 GB)
     Array Size : 6837337472 (6520.59 GiB 7001.43 GB)
   Raid Devices : 9
  Total Devices : 9
Preferred Minor : 0

  Reshape pos'n : 6743555840 (6431.16 GiB 6905.40 GB)
  Delta Devices : 1 (8->9)

    Update Time : Sun Feb 23 21:25:57 2014
          State : clean
 Active Devices : 9
Working Devices : 9
 Failed Devices : 0
  Spare Devices : 0
       Checksum : eb8fa198 - correct
         Events : 22701

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     3       8       64        3      active sync   /dev/sde

   0     0       8       16        0      active sync   /dev/sdb
   1     1       8       80        1      active sync   /dev/sdf
   2     2       8      112        2      active sync   /dev/sdh
   3     3       8       64        3      active sync   /dev/sde
   4     4       8      144        4      active sync   /dev/sdj
   5     5       8      128        5      active sync   /dev/sdi
   6     6       8       48        6      active sync   /dev/sdd
   7     7       8       32        7      active sync   /dev/sdc
   8     8       8       96        8      active sync   /dev/sdg
/dev/sdf:
          Magic : a92b4efc
        Version : 0.91.00
           UUID : 2390bb2c:13899501:227fac17:e5d68dde
  Creation Time : Tue Jun 25 01:53:47 2013
     Raid Level : raid6
  Used Dev Size : 976762496 (931.51 GiB 1000.20 GB)
     Array Size : 6837337472 (6520.59 GiB 7001.43 GB)
   Raid Devices : 9
  Total Devices : 9
Preferred Minor : 0

  Reshape pos'n : 6743555840 (6431.16 GiB 6905.40 GB)
  Delta Devices : 1 (8->9)

    Update Time : Sun Feb 23 21:25:57 2014
          State : clean
 Active Devices : 9
Working Devices : 9
 Failed Devices : 0
  Spare Devices : 0
       Checksum : eb8fa1a4 - correct
         Events : 22701

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     1       8       80        1      active sync   /dev/sdf

   0     0       8       16        0      active sync   /dev/sdb
   1     1       8       80        1      active sync   /dev/sdf
   2     2       8      112        2      active sync   /dev/sdh
   3     3       8       64        3      active sync   /dev/sde
   4     4       8      144        4      active sync   /dev/sdj
   5     5       8      128        5      active sync   /dev/sdi
   6     6       8       48        6      active sync   /dev/sdd
   7     7       8       32        7      active sync   /dev/sdc
   8     8       8       96        8      active sync   /dev/sdg
/dev/sdg:
          Magic : a92b4efc
        Version : 0.91.00
           UUID : 2390bb2c:13899501:227fac17:e5d68dde
  Creation Time : Tue Jun 25 01:53:47 2013
     Raid Level : raid6
  Used Dev Size : 976762496 (931.51 GiB 1000.20 GB)
     Array Size : 6837337472 (6520.59 GiB 7001.43 GB)
   Raid Devices : 9
  Total Devices : 9
Preferred Minor : 0

  Reshape pos'n : 6743555840 (6431.16 GiB 6905.40 GB)
  Delta Devices : 1 (8->9)

    Update Time : Sun Feb 23 21:29:06 2014
          State : active
 Active Devices : 6
Working Devices : 6
 Failed Devices : 3
  Spare Devices : 0
       Checksum : eb8f4a19 - correct
         Events : 22704

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     8       8       96        8      active sync   /dev/sdg

   0     0       8       16        0      active sync   /dev/sdb
   1     1       0        0        1      faulty removed
   2     2       8      112        2      active sync   /dev/sdh
   3     3       0        0        3      faulty removed
   4     4       8      144        4      active sync   /dev/sdj
   5     5       8      128        5      active sync   /dev/sdi
   6     6       0        0        6      faulty removed
   7     7       8       32        7      active sync   /dev/sdc
   8     8       8       96        8      active sync   /dev/sdg
/dev/sdh:
          Magic : a92b4efc
        Version : 0.91.00
           UUID : 2390bb2c:13899501:227fac17:e5d68dde
  Creation Time : Tue Jun 25 01:53:47 2013
     Raid Level : raid6
  Used Dev Size : 976762496 (931.51 GiB 1000.20 GB)
     Array Size : 6837337472 (6520.59 GiB 7001.43 GB)
   Raid Devices : 9
  Total Devices : 9
Preferred Minor : 0

  Reshape pos'n : 6743555840 (6431.16 GiB 6905.40 GB)
  Delta Devices : 1 (8->9)

    Update Time : Sun Feb 23 21:29:06 2014
          State : active
 Active Devices : 6
Working Devices : 6
 Failed Devices : 3
  Spare Devices : 0
       Checksum : eb8f4a1d - correct
         Events : 22704

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     2       8      112        2      active sync   /dev/sdh

   0     0       8       16        0      active sync   /dev/sdb
   1     1       0        0        1      faulty removed
   2     2       8      112        2      active sync   /dev/sdh
   3     3       0        0        3      faulty removed
   4     4       8      144        4      active sync   /dev/sdj
   5     5       8      128        5      active sync   /dev/sdi
   6     6       0        0        6      faulty removed
   7     7       8       32        7      active sync   /dev/sdc
   8     8       8       96        8      active sync   /dev/sdg
/dev/sdi:
          Magic : a92b4efc
        Version : 0.91.00
           UUID : 2390bb2c:13899501:227fac17:e5d68dde
  Creation Time : Tue Jun 25 01:53:47 2013
     Raid Level : raid6
  Used Dev Size : 976762496 (931.51 GiB 1000.20 GB)
     Array Size : 6837337472 (6520.59 GiB 7001.43 GB)
   Raid Devices : 9
  Total Devices : 9
Preferred Minor : 0

  Reshape pos'n : 6743555840 (6431.16 GiB 6905.40 GB)
  Delta Devices : 1 (8->9)

    Update Time : Sun Feb 23 21:29:06 2014
          State : active
 Active Devices : 6
Working Devices : 6
 Failed Devices : 3
  Spare Devices : 0
       Checksum : eb8f4a33 - correct
         Events : 22704

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     5       8      128        5      active sync   /dev/sdi

   0     0       8       16        0      active sync   /dev/sdb
   1     1       0        0        1      faulty removed
   2     2       8      112        2      active sync   /dev/sdh
   3     3       0        0        3      faulty removed
   4     4       8      144        4      active sync   /dev/sdj
   5     5       8      128        5      active sync   /dev/sdi
   6     6       0        0        6      faulty removed
   7     7       8       32        7      active sync   /dev/sdc
   8     8       8       96        8      active sync   /dev/sdg
/dev/sdj:
          Magic : a92b4efc
        Version : 0.91.00
           UUID : 2390bb2c:13899501:227fac17:e5d68dde
  Creation Time : Tue Jun 25 01:53:47 2013
     Raid Level : raid6
  Used Dev Size : 976762496 (931.51 GiB 1000.20 GB)
     Array Size : 6837337472 (6520.59 GiB 7001.43 GB)
   Raid Devices : 9
  Total Devices : 9
Preferred Minor : 0

  Reshape pos'n : 6743555840 (6431.16 GiB 6905.40 GB)
  Delta Devices : 1 (8->9)

    Update Time : Sun Feb 23 21:29:06 2014
          State : active
 Active Devices : 6
Working Devices : 6
 Failed Devices : 3
  Spare Devices : 0
       Checksum : eb8f4a41 - correct
         Events : 22704

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     4       8      144        4      active sync   /dev/sdj

   0     0       8       16        0      active sync   /dev/sdb
   1     1       0        0        1      faulty removed
   2     2       8      112        2      active sync   /dev/sdh
   3     3       0        0        3      faulty removed
   4     4       8      144        4      active sync   /dev/sdj
   5     5       8      128        5      active sync   /dev/sdi
   6     6       0        0        6      faulty removed
   7     7       8       32        7      active sync   /dev/sdc
   8     8       8       96        8      active sync   /dev/sdg

#################

I have retried to --assemble --force with no success.
$ sudo mdadm --assemble --force /dev/md0 /dev/sd[bcdefghij]

I have even tried to re-create the array with both:
mdadm --create /dev/md0 --level=6 --chunk=64 --size=976762496
--assume-clean --raid-devices=8 --metadata=0.9 /dev/sdb /dev/sdc
/dev/sdd /dev/sde /dev/sdf /dev/sdh /dev/sdi /dev/sdj

and:
mdadm --create /dev/md0 --level=6 --chunk=64 --size=976762496
--assume-clean --raid-devices=9 --metadata=0.9 /dev/sdb /dev/sdc
/dev/sdd /dev/sde /dev/sdf /dev/sdg /dev/sdh /dev/sdi /dev/sdj

These both seem to successfully recreate the array but something is
not right since md0 will not mount. I get this from e2fsck:

$ sudo e2fsck /dev/md0
e2fsck 1.42 (29-Nov-2011)
e2fsck: Superblock invalid, trying backup blocks...
e2fsck: Bad magic number in super-block while trying to open /dev/md0

The superblock could not be read or does not describe a correct ext2
filesystem.  If the device is valid and it really contains an ext2
filesystem (and not swap or ufs or something else), then the superblock
is corrupt, and you might try running e2fsck with an alternate superblock:
    e2fsck -b 8193 <device>

Here is the new output from --explain after the re-create:

#################
/dev/sdb:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : a4579ef8:46442acc:8c8edc15:65cb0b9e (local to host
media-server.perceivers.net)
  Creation Time : Mon Feb 24 00:52:34 2014
     Raid Level : raid6
  Used Dev Size : 976762496 (931.51 GiB 1000.20 GB)
     Array Size : 5860574976 (5589.08 GiB 6001.23 GB)
   Raid Devices : 8
  Total Devices : 8
Preferred Minor : 0

    Update Time : Mon Feb 24 00:52:34 2014
          State : clean
 Active Devices : 8
Working Devices : 8
 Failed Devices : 0
  Spare Devices : 0
       Checksum : 666ff6f4 - correct
         Events : 1

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     0       8       16        0      active sync   /dev/sdb

   0     0       8       16        0      active sync   /dev/sdb
   1     1       8       32        1      active sync   /dev/sdc
   2     2       8       48        2      active sync   /dev/sdd
   3     3       8       64        3      active sync   /dev/sde
   4     4       8       80        4      active sync   /dev/sdf
   5     5       8      112        5      active sync   /dev/sdh
   6     6       8      128        6      active sync   /dev/sdi
   7     7       8      144        7      active sync   /dev/sdj
/dev/sdc:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : a4579ef8:46442acc:8c8edc15:65cb0b9e (local to host
media-server.perceivers.net)
  Creation Time : Mon Feb 24 00:52:34 2014
     Raid Level : raid6
  Used Dev Size : 976762496 (931.51 GiB 1000.20 GB)
     Array Size : 5860574976 (5589.08 GiB 6001.23 GB)
   Raid Devices : 8
  Total Devices : 8
Preferred Minor : 0

    Update Time : Mon Feb 24 00:52:34 2014
          State : clean
 Active Devices : 8
Working Devices : 8
 Failed Devices : 0
  Spare Devices : 0
       Checksum : 666ff706 - correct
         Events : 1

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     1       8       32        1      active sync   /dev/sdc

   0     0       8       16        0      active sync   /dev/sdb
   1     1       8       32        1      active sync   /dev/sdc
   2     2       8       48        2      active sync   /dev/sdd
   3     3       8       64        3      active sync   /dev/sde
   4     4       8       80        4      active sync   /dev/sdf
   5     5       8      112        5      active sync   /dev/sdh
   6     6       8      128        6      active sync   /dev/sdi
   7     7       8      144        7      active sync   /dev/sdj
/dev/sdd:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : a4579ef8:46442acc:8c8edc15:65cb0b9e (local to host
media-server.perceivers.net)
  Creation Time : Mon Feb 24 00:52:34 2014
     Raid Level : raid6
  Used Dev Size : 976762496 (931.51 GiB 1000.20 GB)
     Array Size : 5860574976 (5589.08 GiB 6001.23 GB)
   Raid Devices : 8
  Total Devices : 8
Preferred Minor : 0

    Update Time : Mon Feb 24 00:52:34 2014
          State : clean
 Active Devices : 8
Working Devices : 8
 Failed Devices : 0
  Spare Devices : 0
       Checksum : 666ff718 - correct
         Events : 1

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     2       8       48        2      active sync   /dev/sdd

   0     0       8       16        0      active sync   /dev/sdb
   1     1       8       32        1      active sync   /dev/sdc
   2     2       8       48        2      active sync   /dev/sdd
   3     3       8       64        3      active sync   /dev/sde
   4     4       8       80        4      active sync   /dev/sdf
   5     5       8      112        5      active sync   /dev/sdh
   6     6       8      128        6      active sync   /dev/sdi
   7     7       8      144        7      active sync   /dev/sdj
/dev/sde:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : a4579ef8:46442acc:8c8edc15:65cb0b9e (local to host
media-server.perceivers.net)
  Creation Time : Mon Feb 24 00:52:34 2014
     Raid Level : raid6
  Used Dev Size : 976762496 (931.51 GiB 1000.20 GB)
     Array Size : 5860574976 (5589.08 GiB 6001.23 GB)
   Raid Devices : 8
  Total Devices : 8
Preferred Minor : 0

    Update Time : Mon Feb 24 00:52:34 2014
          State : clean
 Active Devices : 8
Working Devices : 8
 Failed Devices : 0
  Spare Devices : 0
       Checksum : 666ff72a - correct
         Events : 1

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     3       8       64        3      active sync   /dev/sde

   0     0       8       16        0      active sync   /dev/sdb
   1     1       8       32        1      active sync   /dev/sdc
   2     2       8       48        2      active sync   /dev/sdd
   3     3       8       64        3      active sync   /dev/sde
   4     4       8       80        4      active sync   /dev/sdf
   5     5       8      112        5      active sync   /dev/sdh
   6     6       8      128        6      active sync   /dev/sdi
   7     7       8      144        7      active sync   /dev/sdj
/dev/sdf:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : a4579ef8:46442acc:8c8edc15:65cb0b9e (local to host
media-server.perceivers.net)
  Creation Time : Mon Feb 24 00:52:34 2014
     Raid Level : raid6
  Used Dev Size : 976762496 (931.51 GiB 1000.20 GB)
     Array Size : 5860574976 (5589.08 GiB 6001.23 GB)
   Raid Devices : 8
  Total Devices : 8
Preferred Minor : 0

    Update Time : Mon Feb 24 00:52:34 2014
          State : clean
 Active Devices : 8
Working Devices : 8
 Failed Devices : 0
  Spare Devices : 0
       Checksum : 666ff73c - correct
         Events : 1

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     4       8       80        4      active sync   /dev/sdf

   0     0       8       16        0      active sync   /dev/sdb
   1     1       8       32        1      active sync   /dev/sdc
   2     2       8       48        2      active sync   /dev/sdd
   3     3       8       64        3      active sync   /dev/sde
   4     4       8       80        4      active sync   /dev/sdf
   5     5       8      112        5      active sync   /dev/sdh
   6     6       8      128        6      active sync   /dev/sdi
   7     7       8      144        7      active sync   /dev/sdj
/dev/sdg:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : 9b62f547:c2a7c361:8c8edc15:65cb0b9e (local to host
media-server.perceivers.net)
  Creation Time : Mon Feb 24 00:51:33 2014
     Raid Level : raid6
  Used Dev Size : 976762496 (931.51 GiB 1000.20 GB)
     Array Size : 6837337472 (6520.59 GiB 7001.43 GB)
   Raid Devices : 9
  Total Devices : 9
Preferred Minor : 0

    Update Time : Mon Feb 24 00:51:33 2014
          State : clean
 Active Devices : 9
Working Devices : 9
 Failed Devices : 0
  Spare Devices : 0
       Checksum : d9dee63a - correct
         Events : 1

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     5       8       96        5      active sync   /dev/sdg

   0     0       8       16        0      active sync   /dev/sdb
   1     1       8       32        1      active sync   /dev/sdc
   2     2       8       48        2      active sync   /dev/sdd
   3     3       8       64        3      active sync   /dev/sde
   4     4       8       80        4      active sync   /dev/sdf
   5     5       8       96        5      active sync   /dev/sdg
   6     6       8      112        6      active sync   /dev/sdh
   7     7       8      128        7      active sync   /dev/sdi
   8     8       8      144        8      active sync   /dev/sdj
/dev/sdh:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : a4579ef8:46442acc:8c8edc15:65cb0b9e (local to host
media-server.perceivers.net)
  Creation Time : Mon Feb 24 00:52:34 2014
     Raid Level : raid6
  Used Dev Size : 976762496 (931.51 GiB 1000.20 GB)
     Array Size : 5860574976 (5589.08 GiB 6001.23 GB)
   Raid Devices : 8
  Total Devices : 8
Preferred Minor : 0

    Update Time : Mon Feb 24 00:52:34 2014
          State : clean
 Active Devices : 8
Working Devices : 8
 Failed Devices : 0
  Spare Devices : 0
       Checksum : 666ff75e - correct
         Events : 1

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     5       8      112        5      active sync   /dev/sdh

   0     0       8       16        0      active sync   /dev/sdb
   1     1       8       32        1      active sync   /dev/sdc
   2     2       8       48        2      active sync   /dev/sdd
   3     3       8       64        3      active sync   /dev/sde
   4     4       8       80        4      active sync   /dev/sdf
   5     5       8      112        5      active sync   /dev/sdh
   6     6       8      128        6      active sync   /dev/sdi
   7     7       8      144        7      active sync   /dev/sdj
/dev/sdi:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : a4579ef8:46442acc:8c8edc15:65cb0b9e (local to host
media-server.perceivers.net)
  Creation Time : Mon Feb 24 00:52:34 2014
     Raid Level : raid6
  Used Dev Size : 976762496 (931.51 GiB 1000.20 GB)
     Array Size : 5860574976 (5589.08 GiB 6001.23 GB)
   Raid Devices : 8
  Total Devices : 8
Preferred Minor : 0

    Update Time : Mon Feb 24 00:52:34 2014
          State : clean
 Active Devices : 8
Working Devices : 8
 Failed Devices : 0
  Spare Devices : 0
       Checksum : 666ff770 - correct
         Events : 1

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     6       8      128        6      active sync   /dev/sdi

   0     0       8       16        0      active sync   /dev/sdb
   1     1       8       32        1      active sync   /dev/sdc
   2     2       8       48        2      active sync   /dev/sdd
   3     3       8       64        3      active sync   /dev/sde
   4     4       8       80        4      active sync   /dev/sdf
   5     5       8      112        5      active sync   /dev/sdh
   6     6       8      128        6      active sync   /dev/sdi
   7     7       8      144        7      active sync   /dev/sdj
/dev/sdj:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : a4579ef8:46442acc:8c8edc15:65cb0b9e (local to host
media-server.perceivers.net)
  Creation Time : Mon Feb 24 00:52:34 2014
     Raid Level : raid6
  Used Dev Size : 976762496 (931.51 GiB 1000.20 GB)
     Array Size : 5860574976 (5589.08 GiB 6001.23 GB)
   Raid Devices : 8
  Total Devices : 8
Preferred Minor : 0

    Update Time : Mon Feb 24 00:52:34 2014
          State : clean
 Active Devices : 8
Working Devices : 8
 Failed Devices : 0
  Spare Devices : 0
       Checksum : 666ff782 - correct
         Events : 1

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     7       8      144        7      active sync   /dev/sdj

   0     0       8       16        0      active sync   /dev/sdb
   1     1       8       32        1      active sync   /dev/sdc
   2     2       8       48        2      active sync   /dev/sdd
   3     3       8       64        3      active sync   /dev/sde
   4     4       8       80        4      active sync   /dev/sdf
   5     5       8      112        5      active sync   /dev/sdh
   6     6       8      128        6      active sync   /dev/sdi
   7     7       8      144        7      active sync   /dev/sdj

#################

I have spent several hours now searching Google, reading list
archives, as well as trying a few things from the wiki (like the
attempts to re-create the array).

I feel fairly certain that the filesystem is still intact and should
mountable, I'm just as a loss as to where to go next. Any ideas or
suggestions?

--
Karl Wilbur
513-322-2481
karl@karlwilbur.net
