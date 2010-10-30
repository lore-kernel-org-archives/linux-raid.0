From: Jon Hardcastle <jonathan.hardcastle@gmail.com>
Subject: argh!
Date: Sat, 30 Oct 2010 12:56:53 +0100
Message-ID: <AANLkTin6huEzOP7FktRRMT7UMVqxxv7aHwXPRE9NjUXs@mail.gmail.com>
Reply-To: Jon@eHardcastle.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Guys,

a new HDD has failed on me during a scrub.... i tried to remove/fail it but
it kept saying the device was busy. so i forced a reboot.

I have physically disconnected the drive..

can anyone take alook at the examine below and tell me if it is should
assemble ok?

I tried

mdadm --assemble /dev/md4 /dev/sda1 /dev/sdb1 /dev/sdd1 /dev/sde1 /dev/sdf1
/dev/sdg1

is that the correct command as it won't assemble and when i --force it still
is right.

hlep!
--- examine starts


/dev/sda1:
         Magic : a92b4efc
       Version : 0.90.00
          UUID : 7438efd1:9e6ca2b5:d6b88274:7003b1d3
 Creation Time : Thu Oct 11 00:01:49 2007
    Raid Level : raid6
 Used Dev Size : 732571904 (698.64 GiB 750.15 GB)
    Array Size : 3662859520 (3493.18 GiB 3750.77 GB)
  Raid Devices : 7
 Total Devices : 7
Preferred Minor : 4

   Update Time : Sat Oct 30 05:10:12 2010
         State : active
 Active Devices : 6
Working Devices : 6
 Failed Devices : 1
 Spare Devices : 0
      Checksum : c22df0a0 - correct
        Events : 1882828

        Layout : left-symmetric
    Chunk Size : 64K

     Number   Major   Minor   RaidDevice State
this     1       8        1        1      active sync   /dev/sda1

  0     0       8       97        0      active sync   /dev/sdg1
  1     1       8        1        1      active sync   /dev/sda1
  2     2       8       65        2      active sync   /dev/sde1
  3     3       0        0        3      faulty removed
  4     4       8       49        4      active sync   /dev/sdd1
  5     5       8       17        5      active sync   /dev/sdb1
  6     6       8       81        6      active sync   /dev/sdf1
/dev/sdb1:
         Magic : a92b4efc
       Version : 0.90.00
          UUID : 7438efd1:9e6ca2b5:d6b88274:7003b1d3
 Creation Time : Thu Oct 11 00:01:49 2007
    Raid Level : raid6
 Used Dev Size : 732571904 (698.64 GiB 750.15 GB)
    Array Size : 3662859520 (3493.18 GiB 3750.77 GB)
  Raid Devices : 7
 Total Devices : 7
Preferred Minor : 4

   Update Time : Sat Oct 30 05:10:12 2010
         State : active
 Active Devices : 6
Working Devices : 6
 Failed Devices : 1
 Spare Devices : 0
      Checksum : c22df0b8 - correct
        Events : 1882828

        Layout : left-symmetric
    Chunk Size : 64K

     Number   Major   Minor   RaidDevice State
this     5       8       17        5      active sync   /dev/sdb1

  0     0       8       97        0      active sync   /dev/sdg1
  1     1       8        1        1      active sync   /dev/sda1
  2     2       8       65        2      active sync   /dev/sde1
  3     3       0        0        3      faulty removed
  4     4       8       49        4      active sync   /dev/sdd1
  5     5       8       17        5      active sync   /dev/sdb1
  6     6       8       81        6      active sync   /dev/sdf1
/dev/sdd1:
         Magic : a92b4efc
       Version : 0.90.00
          UUID : 7438efd1:9e6ca2b5:d6b88274:7003b1d3
 Creation Time : Thu Oct 11 00:01:49 2007
    Raid Level : raid6
 Used Dev Size : 732571904 (698.64 GiB 750.15 GB)
    Array Size : 3662859520 (3493.18 GiB 3750.77 GB)
  Raid Devices : 7
 Total Devices : 7
Preferred Minor : 4

   Update Time : Sat Oct 30 05:10:12 2010
         State : active
 Active Devices : 6
Working Devices : 6
 Failed Devices : 1
 Spare Devices : 0
      Checksum : c22df0d6 - correct
        Events : 1882828

        Layout : left-symmetric
    Chunk Size : 64K

     Number   Major   Minor   RaidDevice State
this     4       8       49        4      active sync   /dev/sdd1

  0     0       8       97        0      active sync   /dev/sdg1
  1     1       8        1        1      active sync   /dev/sda1
  2     2       8       65        2      active sync   /dev/sde1
  3     3       0        0        3      faulty removed
  4     4       8       49        4      active sync   /dev/sdd1
  5     5       8       17        5      active sync   /dev/sdb1
  6     6       8       81        6      active sync   /dev/sdf1
/dev/sde1:
         Magic : a92b4efc
       Version : 0.90.00
          UUID : 7438efd1:9e6ca2b5:d6b88274:7003b1d3
 Creation Time : Thu Oct 11 00:01:49 2007
    Raid Level : raid6
 Used Dev Size : 732571904 (698.64 GiB 750.15 GB)
    Array Size : 3662859520 (3493.18 GiB 3750.77 GB)
  Raid Devices : 7
 Total Devices : 7
Preferred Minor : 4

   Update Time : Sat Oct 30 05:10:12 2010
         State : active
 Active Devices : 6
Working Devices : 6
 Failed Devices : 1
 Spare Devices : 0
      Checksum : c22df0e2 - correct
        Events : 1882828

        Layout : left-symmetric
    Chunk Size : 64K

     Number   Major   Minor   RaidDevice State
this     2       8       65        2      active sync   /dev/sde1

  0     0       8       97        0      active sync   /dev/sdg1
  1     1       8        1        1      active sync   /dev/sda1
  2     2       8       65        2      active sync   /dev/sde1
  3     3       0        0        3      faulty removed
  4     4       8       49        4      active sync   /dev/sdd1
  5     5       8       17        5      active sync   /dev/sdb1
  6     6       8       81        6      active sync   /dev/sdf1
/dev/sdf1:
         Magic : a92b4efc
       Version : 0.90.00
          UUID : 7438efd1:9e6ca2b5:d6b88274:7003b1d3
 Creation Time : Thu Oct 11 00:01:49 2007
    Raid Level : raid6
 Used Dev Size : 732571904 (698.64 GiB 750.15 GB)
    Array Size : 3662859520 (3493.18 GiB 3750.77 GB)
  Raid Devices : 7
 Total Devices : 7
Preferred Minor : 4

   Update Time : Sat Oct 30 05:10:12 2010
         State : active
 Active Devices : 6
Working Devices : 6
 Failed Devices : 1
 Spare Devices : 0
      Checksum : c22df0fa - correct
        Events : 1882828

        Layout : left-symmetric
    Chunk Size : 64K

     Number   Major   Minor   RaidDevice State
this     6       8       81        6      active sync   /dev/sdf1

  0     0       8       97        0      active sync   /dev/sdg1
  1     1       8        1        1      active sync   /dev/sda1
  2     2       8       65        2      active sync   /dev/sde1
  3     3       0        0        3      faulty removed
  4     4       8       49        4      active sync   /dev/sdd1
  5     5       8       17        5      active sync   /dev/sdb1
  6     6       8       81        6      active sync   /dev/sdf1
/dev/sdg1:
         Magic : a92b4efc
       Version : 0.90.00
          UUID : 7438efd1:9e6ca2b5:d6b88274:7003b1d3
 Creation Time : Thu Oct 11 00:01:49 2007
    Raid Level : raid6
 Used Dev Size : 732571904 (698.64 GiB 750.15 GB)
    Array Size : 3662859520 (3493.18 GiB 3750.77 GB)
  Raid Devices : 7
 Total Devices : 7
Preferred Minor : 4

   Update Time : Sat Oct 30 05:10:12 2010
         State : active
 Active Devices : 6
Working Devices : 6
 Failed Devices : 1
 Spare Devices : 0
      Checksum : c22df0fe - correct
        Events : 1882828

        Layout : left-symmetric
    Chunk Size : 64K

     Number   Major   Minor   RaidDevice State
this     0       8       97        0      active sync   /dev/sdg1

  0     0       8       97        0      active sync   /dev/sdg1
  1     1       8        1        1      active sync   /dev/sda1
  2     2       8       65        2      active sync   /dev/sde1
  3     3       0        0        3      faulty removed
  4     4       8       49        4      active sync   /dev/sdd1
  5     5       8       17        5      active sync   /dev/sdb1
  6     6       8       81        6      active sync   /dev/sdf1
