From: Wolfram Schlich <lists@schlich.org>
Subject: I just trashed my RAID5 array - recovery possible?
Date: Thu, 20 Mar 2003 01:03:58 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20030320000358.ALLYOURBASEAREBELONGTOUS.A6336@bla.fasel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
To: Linux-RAID mailinglist <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi,

I just trashed my RAID5 array. The Promise IDE driver messed up
sharing IRQs with a network interface card while writing a file to
the array via the mentioned NIC card.
Is any recovery possible? I wouldn't care about some lost
megabytes... really. Thanks in advance!

Here's my raidtab (hde + hdg = controller 1, hdi + hdk = controller 2)
/etc/raidtab:
--8<--
raiddev /dev/md1
        raid-level 5
        nr-raid-disks 4
        nr-spare-disks 0
        persistent-superblock 1
        parity-algorithm left-symmetric
        chunk-size 64
        device /dev/hde1
        raid-disk 0
        device /dev/hdg1
        raid-disk 1
        device /dev/hdi1
        raid-disk 2
        device /dev/hdk1
        raid-disk 3
--8<--

Here are all messages I was able to collect:

Boot:
--8<--
 [events: 00000038]
 [events: 00000039]
 [events: 0000003a]
 [events: 0000003a]
md: autorun ...
md: considering hdk1 ...
md:  adding hdk1 ...
md:  adding hdi1 ...
md:  adding hdg1 ...
md:  adding hde1 ...
md: created md1
md: bind<hde1,1>
md: bind<hdg1,2>
md: bind<hdi1,3>
md: bind<hdk1,4>
md: running: <hdk1><hdi1><hdg1><hde1>
md: hdk1's event counter: 0000003a
md: hdi1's event counter: 0000003a
md: hdg1's event counter: 00000039
md: hde1's event counter: 00000038
md: superblock update time inconsistency -- using the most recent one
md: freshest: hdk1
md: kicking non-fresh hde1 from array!
md: unbind<hde1,3>
md: export_rdev(hde1)
md1: kicking faulty hdg1!
md: unbind<hdg1,2>
md: export_rdev(hdg1)
md1: removing former faulty hde1!
md: md1: raid array is not clean -- starting background
reconstruction
md1: max total readahead window set to 768k
md1: 3 data-disks, max readahead per data-disk: 256k
raid5: device hdk1 operational as raid disk 3
raid5: device hdi1 operational as raid disk 2
raid5: not enough operational devices for md1 (2/4 failed)
RAID5 conf printout:
 --- rd:4 wd:2 fd:2
 disk 0, s:0, o:0, n:0 rd:0 us:1 dev:[dev 00:00]
 disk 1, s:0, o:0, n:1 rd:1 us:1 dev:[dev 00:00]
 disk 2, s:0, o:1, n:2 rd:2 us:1 dev:hdi1
 disk 3, s:0, o:1, n:3 rd:3 us:1 dev:hdk1
raid5: failed to run raid set md1
md: pers->run() failed ...
md :do_md_run() returned -22
md: md1 stopped.
md: unbind<hdk1,1>
md: export_rdev(hdk1)
md: unbind<hdi1,0>
md: export_rdev(hdi1)
md: ... autorun DONE.
--8<--

mdadm --examine /dev/hd[egik]1
--8<--
/dev/hde1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 6c1d7352:fc248a72:f4ef9da6:fa5478c3
  Creation Time : Tue Mar 11 01:16:24 2003
     Raid Level : raid5
    Device Size : 117218176 (111.79 GiB 120.03 GB)
   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 1

    Update Time : Thu Mar 20 01:38:14 2003
          State : dirty, no-errors
 Active Devices : 4
Working Devices : 4
 Failed Devices : 0
  Spare Devices : 0
       Checksum : 84953914 - correct
         Events : 0.56

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     1      33        1        1      active sync   /dev/hde1
   0     0      34        1        0      active sync   /dev/hdg1
   1     1      33        1        1      active sync   /dev/hde1
   2     2      56        1        2      active sync   /dev/hdi1
   3     3      57        1        3      active sync   /dev/hdk1
/dev/hdg1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 6c1d7352:fc248a72:f4ef9da6:fa5478c3
  Creation Time : Tue Mar 11 01:16:24 2003
     Raid Level : raid5
    Device Size : 117218176 (111.79 GiB 120.03 GB)
   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 1

    Update Time : Thu Mar 20 00:43:49 2003
          State : dirty, no-errors
 Active Devices : 3
Working Devices : 3
 Failed Devices : 1
  Spare Devices : 0
       Checksum : 84952c4d - correct
         Events : 0.57

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     0      34        1        0      active sync   /dev/hdg1
   0     0      34        1        0      active sync   /dev/hdg1
   1     1      33        1        1      faulty   /dev/hde1
   2     2      56        1        2      active sync   /dev/hdi1
   3     3      57        1        3      active sync   /dev/hdk1
/dev/hdi1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 6c1d7352:fc248a72:f4ef9da6:fa5478c3
  Creation Time : Tue Mar 11 01:16:24 2003
     Raid Level : raid5
    Device Size : 117218176 (111.79 GiB 120.03 GB)
   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 1

    Update Time : Thu Mar 20 00:43:49 2003
          State : dirty, no-errors
 Active Devices : 2
Working Devices : 2
 Failed Devices : 2
  Spare Devices : 0
       Checksum : 84952c62 - correct
         Events : 0.58

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     2      56        1        2      active sync   /dev/hdi1
   0     0      34        1        0      faulty   /dev/hdg1
   1     1      33        1        1      faulty   /dev/hde1
   2     2      56        1        2      active sync   /dev/hdi1
   3     3      57        1        3      active sync   /dev/hdk1
/dev/hdk1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 6c1d7352:fc248a72:f4ef9da6:fa5478c3
  Creation Time : Tue Mar 11 01:16:24 2003
     Raid Level : raid5
    Device Size : 117218176 (111.79 GiB 120.03 GB)
   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 1

    Update Time : Thu Mar 20 00:43:49 2003
          State : dirty, no-errors
 Active Devices : 2
Working Devices : 2
 Failed Devices : 2
  Spare Devices : 0
       Checksum : 84952c65 - correct
         Events : 0.58

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     3      57        1        3      active sync   /dev/hdk1
   0     0      34        1        0      faulty   /dev/hdg1
   1     1      33        1        1      faulty   /dev/hde1
   2     2      56        1        2      active sync   /dev/hdi1
   3     3      57        1        3      active sync   /dev/hdk1
--8<--

I do really *hope* there's help... *sigh*. Gotta go to bed now.
Thanks again, I'm completely lost at this point.
-- 
Wolfram Schlich; Friedhofstr. 8, D-88069 Tettnang; +49-(0)178-SCHLICH
