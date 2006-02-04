From: "Oren Ben-Menachem" <oren@kcbbs.gen.nz>
Subject: Help on rebuilding an array that had a massive failure.
Date: Sat, 4 Feb 2006 16:28:26 +1300 (NZDT)
Message-ID: <3984.192.203.83.7.1139023706.squirrel@192.203.83.14>
Reply-To: oren@kcbbs.gen.nz
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all,

I recently had a machine (Debian 2.6.7) with a raid array have a failure,
the disk controller card died partially ( so a couple of disks went
offline) then died permantly taking a further two drives out of the array.

The array (/dev/md1) was made up of /dev/hda3, /dev/hdi3, /dev/hdk3,
/dev/hdl3 and /dev/hdj3) the array was made up of the first three and then
the fourth was added (I believe).

Mdadm.conf looks like:
ARRAY /dev/md1 level=raid5 num-devices=5
UUID=aeb44e5d:14388f60:8c2f39ec:9488facd
   devices=/dev/hda3,/dev/hdc3,/dev/hdd3,/dev/hde3,/dev/hdf3

Due to the controller death I've moved the disks across to another
machine, which has relabelled the disks as hda, hdc, hdd, hde, hdf.

I've attached the output of mdadm -E, below and have at least worked out
what the mapping is from old to new. (ie hda-hda, hdi-hdc, hdk-hde,
hdl-hdf, hdj-hdd).

When I try to assemble the drives I either get a 3 disk array mounted or
the following output:
phineas:/etc# mdadm --assemble /dev/md1 /dev/hda3 /dev/hdc3 /dev/hde3
/dev/hdf3 /dev/hdd3
mdadm: failed to add /dev/hdf3 to /dev/md1: Invalid argument
mdadm: failed to add /dev/hdd3 to /dev/md1: Invalid argument
mdadm: /dev/md1 assembled from 3 drives - not enough to start the array.

Has anyone got any thoughts on how to rebuild this array, the disks should
be ok, with data intact, with XFS on top, so I should be able to get the
drive back on line with at least most of the data able to be taken off.

Thoughts??? Comments????

much thanks in advance....

phineas:/etc# mdadm -E /dev/hda3
/dev/hda3:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : aeb44e5d:14388f60:8c2f39ec:9488facd
  Creation Time : Mon Aug 16 07:37:26 2004
     Raid Level : raid5
    Device Size : 104494720 (99.65 GiB 107.00 GB)
   Raid Devices : 5
  Total Devices : 5
Preferred Minor : 1

    Update Time : Wed Feb  1 16:21:38 2006
          State : clean
 Active Devices : 5
Working Devices : 5
 Failed Devices : 0
  Spare Devices : 0
       Checksum : 185b3736 - correct
         Events : 0.2571312

         Layout : left-symmetric
     Chunk Size : 128K

      Number   Major   Minor   RaidDevice State
this     0       3        3        0      active sync   /dev/hda3
   0     0       3        3        0      active sync   /dev/hda3
   1     1      56        3        1      active sync   /dev/hdi3
   2     2      57        3        2      active sync   /dev/hdk3
   3     3      57       67        3      active sync   /dev/hdl3
   4     4      56       67        4      active sync   /dev/hdj3

phineas:/etc# mdadm -E /dev/hdc3
/dev/hdc3:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : aeb44e5d:14388f60:8c2f39ec:9488facd
  Creation Time : Mon Aug 16 07:37:26 2004
     Raid Level : raid5
    Device Size : 104494720 (99.65 GiB 107.00 GB)
   Raid Devices : 5
  Total Devices : 5
Preferred Minor : 1

    Update Time : Wed Feb  1 16:21:38 2006
          State : clean
 Active Devices : 5
Working Devices : 5
 Failed Devices : 0
  Spare Devices : 0
       Checksum : 185b376d - correct
         Events : 0.2571312

         Layout : left-symmetric
     Chunk Size : 128K

      Number   Major   Minor   RaidDevice State
this     1      56        3        1      active sync   /dev/hdi3
   0     0       3        3        0      active sync   /dev/hda3
   1     1      56        3        1      active sync   /dev/hdi3
   2     2      57        3        2      active sync   /dev/hdk3
   3     3      57       67        3      active sync   /dev/hdl3
   4     4      56       67        4      active sync   /dev/hdj3



phineas:/etc# mdadm -E /dev/hdd3
/dev/hdd3:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : aeb44e5d:14388f60:8c2f39ec:9488facd
  Creation Time : Mon Aug 16 07:37:26 2004
     Raid Level : raid5
    Device Size : 104494720 (99.65 GiB 107.00 GB)
   Raid Devices : 5
  Total Devices : 5
Preferred Minor : 1

    Update Time : Wed Feb  1 16:21:38 2006
          State : clean
 Active Devices : 5
Working Devices : 5
 Failed Devices : 0
  Spare Devices : 0
       Checksum : 185b37b3 - expected 18bb3813
         Events : 0.2571312

         Layout : left-symmetric
     Chunk Size : 128K

      Number   Major   Minor   RaidDevice State
this     4      56       67        4      active sync   /dev/hdj3
   0     0       3        3        0      active sync   /dev/hda3
   1     1      56        3        1      active sync   /dev/hdi3
   2     2      57        3        2      active sync   /dev/hdk3
   3     3      57       67        3      active sync   /dev/hdl3
   4     4      56       67        4      active sync   /dev/hdj3


phineas:/etc# mdadm -E /dev/hde3
/dev/hde3:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : aeb44e5d:14388f60:8c2f39ec:9488facd
  Creation Time : Mon Aug 16 07:37:26 2004
     Raid Level : raid5
    Device Size : 104494720 (99.65 GiB 107.00 GB)
   Raid Devices : 5
  Total Devices : 5
Preferred Minor : 1

    Update Time : Wed Feb  1 16:21:38 2006
          State : clean
 Active Devices : 5
Working Devices : 5
 Failed Devices : 0
  Spare Devices : 0
       Checksum : 185b3770 - correct
         Events : 0.2571312

         Layout : left-symmetric
     Chunk Size : 128K

      Number   Major   Minor   RaidDevice State
this     2      57        3        2      active sync   /dev/hdk3
   0     0       3        3        0      active sync   /dev/hda3
   1     1      56        3        1      active sync   /dev/hdi3
   2     2      57        3        2      active sync   /dev/hdk3
   3     3      57       67        3      active sync   /dev/hdl3
   4     4      56       67        4      active sync   /dev/hdj3


phineas:/etc# mdadm -E /dev/hdf3
/dev/hdf3:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : aeb44e5d:14388f60:8c2f39ec:9488facd
  Creation Time : Mon Aug 16 07:37:26 2004
     Raid Level : raid5
    Device Size : 104494720 (99.65 GiB 107.00 GB)
   Raid Devices : 5
  Total Devices : 5
Preferred Minor : 1

    Update Time : Wed Feb  1 16:21:38 2006
          State : clean
 Active Devices : 5
Working Devices : 5
 Failed Devices : 0
  Spare Devices : 0
       Checksum : 185b37b2 - expected 186837be
         Events : 0.2571312

         Layout : left-symmetric
     Chunk Size : 128K

      Number   Major   Minor   RaidDevice State
this     3      57       67        3      active sync   /dev/hdl3
   0     0       3        3        0      active sync   /dev/hda3
   1     1      56        3        1      active sync   /dev/hdi3
   2     2      57        3        2      active sync   /dev/hdk3
   3     3      57       67        3      active sync   /dev/hdl3
   4     4      56       67        4      active sync   /dev/hdj3



