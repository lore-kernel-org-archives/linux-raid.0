From: "Mike Billings" <mike@carolina.rr.com>
Subject: Using raidreconf to create raid0 from non-raid works, but df is wrong
Date: Wed, 7 Jul 2004 23:03:27 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <07ec01c46498$240dd770$6401010a@stan>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I originally had a 250G ide drive on my system.  I added a second 250G and
used raidreconf to go from non-raid to raid using "raidreconf -i
/dev/hde1 -n /etc/raidtab -m /dev/md0".  The conversion suceeded, mdadm
reports that everything is ok, and the new raid0 works fine but df reports
the wrong size.  Is there any way to get df to report the correct size
without wiping the data?  Could I have done something with raidreconf
differently to avoid this?

Thanks,
Mike

My setup info:

meatwad / # df -k
Filesystem           1K-blocks      Used Available Use% Mounted on
/dev/md0             241263968 222247508   6760876  98% /mnt  <<< that
should be ~500GB

meatwad / # cat /etc/raidtab
raiddev             /dev/md0
raid-level                  0
nr-raid-disks               2
chunk-size                  32
persistent-superblock       1
nr-spare-disks              0
    device          /dev/hde1
    raid-disk     0
    device          /dev/hdg1
    raid-disk     1

meatwad / # mdadm --examine /dev/hde1
/dev/hde1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 12511967:044c5448:e985eb8e:860b9a60
  Creation Time : Wed Jul  7 10:50:53 2004
     Raid Level : raid0
    Device Size : 245111616 (233.76 GiB 250.99 GB)
   Raid Devices : 2
  Total Devices : 2
Preferred Minor : 0

    Update Time : Thu Jul  8 03:50:30 2004
          State : dirty, no-errors
 Active Devices : 2
Working Devices : 2
 Failed Devices : 0
  Spare Devices : 0
       Checksum : bfcfe958 - correct
         Events : 0.13

     Chunk Size : 32K

      Number   Major   Minor   RaidDevice State
this     0      33        1        0      active sync
/dev/ide/host2/bus0/target0/lun0/part1
   0     0      33        1        0      active sync
/dev/ide/host2/bus0/target0/lun0/part1
   1     1      34        1        1      active sync
/dev/ide/host2/bus1/target0/lun0/part1

meatwad / # mdadm --examine /dev/hdg1
/dev/hdg1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 12511967:044c5448:e985eb8e:860b9a60
  Creation Time : Wed Jul  7 10:50:53 2004
     Raid Level : raid0
    Device Size : 245111616 (233.76 GiB 250.99 GB)
   Raid Devices : 2
  Total Devices : 2
Preferred Minor : 0

    Update Time : Thu Jul  8 03:50:30 2004
          State : dirty, no-errors
 Active Devices : 2
Working Devices : 2
 Failed Devices : 0
  Spare Devices : 0
       Checksum : bfcfe95b - correct
         Events : 0.13

     Chunk Size : 32K

      Number   Major   Minor   RaidDevice State
this     1      34        1        1      active sync
/dev/ide/host2/bus1/target0/lun0/part1
   0     0      33        1        0      active sync
/dev/ide/host2/bus0/target0/lun0/part1
   1     1      34        1        1      active sync
/dev/ide/host2/bus1/target0/lun0/part1

meatwad / # mdadm -D /dev/md0
/dev/md0:
        Version : 00.90.00
  Creation Time : Wed Jul  7 10:50:53 2004
     Raid Level : raid0
     Array Size : 490223232 (467.51 GiB 501.99 GB)
   Raid Devices : 2
  Total Devices : 2
Preferred Minor : 0
    Persistence : Superblock is persistent

    Update Time : Thu Jul  8 03:50:30 2004
          State : dirty, no-errors
 Active Devices : 2
Working Devices : 2
 Failed Devices : 0
  Spare Devices : 0

     Chunk Size : 32K

    Number   Major   Minor   RaidDevice State
       0      33        1        0      active sync
/dev/ide/host2/bus0/target0/lun0/part1
       1      34        1        1      active sync
/dev/ide/host2/bus1/target0/lun0/part1
           UUID : 12511967:044c5448:e985eb8e:860b9a60
         Events : 0.13

dmesg output from starting the array:
md: bind<ide/host2/bus0/target0/lun0/part1,2>
md: ide/host2/bus0/target0/lun0/part1's event counter: 0000000c
md: ide/host2/bus1/target0/lun0/part1's event counter: 0000000c
md0: max total readahead window set to 496k
md0: 2 data-disks, max readahead per data-disk: 248k
raid0: looking at ide/host2/bus0/target0/lun0/part1
raid0:   comparing ide/host2/bus0/target0/lun0/part1(245111616) with
ide/host2/bus0/target0/lun0/part1(245111616)
raid0:   END
raid0:   ==> UNIQUE
raid0: 1 zones
raid0: looking at ide/host2/bus1/target0/lun0/part1
raid0:   comparing ide/host2/bus1/target0/lun0/part1(245111616) with
ide/host2/bus0/target0/lun0/part1(245111616)
raid0:   EQUAL
raid0: FINAL 1 zones
raid0: zone 0
raid0: checking ide/host2/bus0/target0/lun0/part1 ... contained as device 0
  (245111616) is smallest!.
raid0: checking ide/host2/bus1/target0/lun0/part1 ... contained as device 1
raid0: zone->nb_dev: 2, size: 490223232
raid0: current zone offset: 245111616
raid0: done.
raid0 : md_size is 490223232 blocks.
raid0 : conf->smallest->size is 490223232 blocks.
raid0 : nb_zone is 1.
raid0 : Allocating 8 bytes for hash.
md: updating md0 RAID superblock on device
md: ide/host2/bus0/target0/lun0/part1 [events: 0000000d]<6>(write)
ide/host2/bus0/target0/lun0/part1's sb offset: 245111616
md: ide/host2/bus1/target0/lun0/part1 [events: 0000000d]<6>(write)
ide/host2/bus1/target0/lun0/part1's sb offset: 245111616


