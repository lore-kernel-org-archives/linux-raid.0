From: krause@mogli-soft.de
Subject: recover short-time-power-failure of raid 5?
Date: Sun, 24 Nov 2002 21:03:19 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <E18G2yN-0001VC-00@config7.kundenserver.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

hi folks!

i am using a small 3-disk software raid on a linux redhat 7.3 system for
my home directory. 
never had any problems since today, somehow the power cable of to two of
my disks dropped (a fan in the case got loose which was connected to the
same cable!). only some seconds later i shut down the system, switched
it off and reconneceted the disks. the raid device /dev/md0 was not used
by the time the power failure happend (i was not logged in, /dev/md0
only contains /home), so actually there should be no loss of data.
but how do i tell the system just to reuse the disks? 
i read some howtos and articles in the mailing archiv but found no 
instruction for this case or (completely ?) different ways (one said
just use "mkraid --create", others "raidhotadd") 
so what is the correct way? the data on /home is quite important to me
and the last backup a week ago unfortunately does not include some
relevant changes! because of this i dared not to try things out.

attached are the contents/output of /etc/raidtab, mdadm --examine and
/var/log/messages.

i hope you can help me to reuse my data!

thanks in advance for your hints!

   markus


my config:
---8<---
[root@merlin root]# cat /etc/raidtab
raiddev             /dev/md0
raid-level                  5
nr-raid-disks               3
chunk-size                  64k
persistent-superblock       1
nr-spare-disks              0
    device          /dev/sda1
    raid-disk     0
    device          /dev/sdb1
    raid-disk     1
    device          /dev/sdc2
    raid-disk     2
[root@merlin root]#
--->8---

some other output:
---8<---
[root@merlin root]# mdadm --examine /dev/sda1
/dev/sda1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 396dcf37:a40fe0d4:c6d72718:8dd3f5d6
  Creation Time : Thu Jun 20 17:13:01 2002
     Raid Level : raid5
    Device Size : 4192832 (3.100 GiB 4.34 GB)
   Raid Devices : 3
  Total Devices : 3
Preferred Minor : 0

    Update Time : Sun Nov 24 12:30:33 2002
          State : clean, no-errors
 Active Devices : 1
Working Devices : 1
 Failed Devices : 2
  Spare Devices : 0
       Checksum : 5687c1bf - correct
         Events : 0.254

         Layout : left-asymmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     0       8        1        0      active sync   /dev/sda1
   0     0       8        1        0      active sync   /dev/sda1
   1     1       8       17        1      faulty   /dev/sdb1
   2     2       8       34        2      faulty   /dev/sdc2
[root@merlin root]#
[root@merlin root]# mdadm --examine /dev/sdb1
/dev/sdb1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 396dcf37:a40fe0d4:c6d72718:8dd3f5d6
  Creation Time : Thu Jun 20 17:13:01 2002
     Raid Level : raid5
    Device Size : 4192832 (3.100 GiB 4.34 GB)
   Raid Devices : 3
  Total Devices : 3
Preferred Minor : 0

    Update Time : Sun Nov 24 12:27:53 2002
          State : dirty, no-errors
 Active Devices : 3
Working Devices : 3
 Failed Devices : 0
  Spare Devices : 0
       Checksum : 5687c139 - correct
         Events : 0.251

         Layout : left-asymmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     1       8       17        1      active sync   /dev/sdb1
   0     0       8        1        0      active sync   /dev/sda1
   1     1       8       17        1      active sync   /dev/sdb1
   2     2       8       34        2      active sync   /dev/sdc2
[root@merlin root]#
[root@merlin root]# mdadm --examine /dev/sdc2
/dev/sdc2:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 396dcf37:a40fe0d4:c6d72718:8dd3f5d6
  Creation Time : Thu Jun 20 17:13:01 2002
     Raid Level : raid5
    Device Size : 4192832 (3.100 GiB 4.34 GB)
   Raid Devices : 3
  Total Devices : 3
Preferred Minor : 0

    Update Time : Sun Nov 24 12:27:53 2002
          State : dirty, no-errors
 Active Devices : 3
Working Devices : 3
 Failed Devices : 0
  Spare Devices : 0
       Checksum : 5687c14c - correct
         Events : 0.251

         Layout : left-asymmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     2       8       34        2      active sync   /dev/sdc2
   0     0       8        1        0      active sync   /dev/sda1
   1     1       8       17        1      active sync   /dev/sdb1
   2     2       8       34        2      active sync   /dev/sdc2
[root@merlin root]#
--->8---


the info in /var/log/messages when running "raidstart /dev/md0":
---8<---
Nov 24 21:02:08 merlin kernel:  [events: 000000fe]
Nov 24 21:02:08 merlin kernel:  [events: 000000fb]
Nov 24 21:02:08 merlin kernel:  [events: 000000fb]
Nov 24 21:02:08 merlin kernel: md: autorun ...
Nov 24 21:02:08 merlin kernel: md: considering sdc2 ...
Nov 24 21:02:08 merlin kernel: md:  adding sdc2 ...
Nov 24 21:02:08 merlin kernel: md:  adding sdb1 ...
Nov 24 21:02:08 merlin kernel: md:  adding sda1 ...
Nov 24 21:02:08 merlin kernel: md: created md0
Nov 24 21:02:08 merlin kernel: md: bind<sda1,1>
Nov 24 21:02:08 merlin kernel: md: bind<sdb1,2>
Nov 24 21:02:08 merlin kernel: md: bind<sdc2,3>
Nov 24 21:02:08 merlin kernel: md: running: <sdc2><sdb1><sda1>
Nov 24 21:02:08 merlin kernel: md: sdc2's event counter: 000000fb
Nov 24 21:02:08 merlin kernel: md: sdb1's event counter: 000000fb
Nov 24 21:02:08 merlin kernel: md: sda1's event counter: 000000fe
Nov 24 21:02:08 merlin kernel: md: superblock update time inconsistency
-- using the most recent one
Nov 24 21:02:08 merlin kernel: md: freshest: sda1
Nov 24 21:02:08 merlin kernel: md: kicking non-fresh sdc2 from array!
Nov 24 21:02:08 merlin kernel: md: unbind<sdc2,2>
Nov 24 21:02:08 merlin kernel: md: export_rdev(sdc2)
Nov 24 21:02:08 merlin kernel: md: kicking non-fresh sdb1 from array!
Nov 24 21:02:08 merlin kernel: md: unbind<sdb1,1>
Nov 24 21:02:08 merlin kernel: md: export_rdev(sdb1)
Nov 24 21:02:08 merlin kernel: md0: removing former faulty sdb1!
Nov 24 21:02:08 merlin kernel: md0: removing former faulty sdc2!
Nov 24 21:02:08 merlin kernel: md0: max total readahead window set to
512k
Nov 24 21:02:08 merlin kernel: md0: 2 data-disks, max readahead per
data-disk: 256k
Nov 24 21:02:08 merlin kernel: raid5: device sda1 operational as raid
disk 0
Nov 24 21:02:08 merlin kernel: raid5: not enough operational devices for
md0 (2/3 failed)
Nov 24 21:02:08 merlin kernel: RAID5 conf printout:
Nov 24 21:02:08 merlin kernel:  --- rd:3 wd:1 fd:2
Nov 24 21:02:08 merlin kernel:  disk 0, s:0, o:1, n:0 rd:0 us:1 dev:sda1
Nov 24 21:02:08 merlin kernel:  disk 1, s:0, o:0, n:1 rd:1 us:1 dev:[dev
00:00]
Nov 24 21:02:08 merlin kernel:  disk 2, s:0, o:0, n:2 rd:2 us:1 dev:[dev
00:00]
Nov 24 21:02:08 merlin kernel: raid5: failed to run raid set md0
Nov 24 21:02:08 merlin kernel: md: pers->run() failed ...
Nov 24 21:02:08 merlin kernel: md :do_md_run() returned -22
Nov 24 21:02:08 merlin kernel: md: md0 stopped.
Nov 24 21:02:08 merlin kernel: md: unbind<sda1,0>
Nov 24 21:02:08 merlin kernel: md: export_rdev(sda1)
Nov 24 21:02:08 merlin kernel: md: ... autorun DONE.
---8<---
