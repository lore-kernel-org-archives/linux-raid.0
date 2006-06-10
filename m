From: osk@admin.swisscom-mobile.ch
Subject: RAID5 troubles
Date: Sat, 10 Jun 2006 22:28:13 +0200 (MEST)
Message-ID: <200606102028.k5AKSD86022209@mrz.swissptt.ch>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
List-Id: linux-raid.ids

Hi

I have three SATA 250 GB disks with two partitions on each one. 
The first partition  from each disk form a RAID1 array which is my root 
partition. The second partition of each disk form a RAID5.
Everything was working fine, then I had to power off/on the machine as it 
was hanging. At next boot the RAID1 array was degraded but running,
mdadm /dev/md0--add /dev/sdc2 fixed it.

The RAID5 array is still a problem, dmesg says:

md: created md1
md: bind<sda2>
md: bind<sdb2>
md: bind<sdc2>
md: running: <sdc2><sdb2><sda2>
md: kicking non-fresh sdc2 from array!
md: unbind<sdc2>
md: export_rdev(sdc2)
md: md1: raid array is not clean -- starting background reconstruction
raid5: device sdb2 operational as raid disk 0
raid5: device sda2 operational as raid disk 1
raid5: cannot start dirty degraded array for md1
RAID5 conf printout:
 --- rd:3 wd:2 fd:1
 disk 0, o:1, dev:sdb2
 disk 1, o:1, dev:sda2
raid5: failed to run raid set md1
md: pers->run() failed ...
md: do_md_run() returned -5
md: md1 stopped.
md: unbind<sdb2>
md: export_rdev(sdb2)
md: unbind<sda2>
md: export_rdev(sda2)

mdadm --examine for those three partions:

/dev/sda2:
          Magic : a92b4efc
        Version : 00.90.03
           UUID : 1e721d7b:1ed2152e:1f8e55e3:a881163a
  Creation Time : Fri May 12 21:36:04 2006
     Raid Level : raid5
   Raid Devices : 3
  Total Devices : 3
Preferred Minor : 1

    Update Time : Fri Jun  2 23:41:26 2006
          State : active
 Active Devices : 2
Working Devices : 2
 Failed Devices : 2
  Spare Devices : 0
       Checksum : 45e5f094 - correct
         Events : 0.67315

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     1       8        2        1      active sync   /dev/sda2

   0     0       8       18        0      active sync   /dev/sdb2
   1     1       8        2        1      active sync   /dev/sda2
   2     2       0        0        2      faulty removed

/dev/sdb2:
          Magic : a92b4efc
        Version : 00.90.03
           UUID : 1e721d7b:1ed2152e:1f8e55e3:a881163a
  Creation Time : Fri May 12 21:36:04 2006
     Raid Level : raid5
   Raid Devices : 3
  Total Devices : 3
Preferred Minor : 1

    Update Time : Fri Jun  2 23:41:26 2006
          State : active
 Active Devices : 2
Working Devices : 2
 Failed Devices : 2
  Spare Devices : 0
       Checksum : 45e5f0a2 - correct
         Events : 0.67315

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     0       8       18        0      active sync   /dev/sdb2

   0     0       8       18        0      active sync   /dev/sdb2
   1     1       8        2        1      active sync   /dev/sda2
   2     2       0        0        2      faulty removed

/dev/sdc2:
          Magic : a92b4efc
        Version : 00.90.03
           UUID : 1e721d7b:1ed2152e:1f8e55e3:a881163a
  Creation Time : Fri May 12 21:36:04 2006
     Raid Level : raid5
   Raid Devices : 3
  Total Devices : 3
Preferred Minor : 1

    Update Time : Fri Jun  2 20:36:31 2006
          State : clean
 Active Devices : 3
Working Devices : 3
 Failed Devices : 0
  Spare Devices : 0
       Checksum : 45e6cc45 - correct
         Events : 0.67313

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     2       8       34        2      active sync   /dev/sdc2

   0     0       8       18        0      active sync   /dev/sdb2
   1     1       8        2        1      active sync   /dev/sda2
   2     2       8       34        2      active sync   /dev/sdc2


Is there any way to recover?

I'm using
Kernel: 2.6.16.16
mdadm: v1.12.0

Thanks for your time.

Regards,
Chris
