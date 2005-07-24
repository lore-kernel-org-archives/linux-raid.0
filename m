From: "J. Ali Harlow" <ali@juiblex.co.uk>
Subject: Can't work out how to recover after multiple failures
Date: Sun, 24 Jul 2005 17:22:21 +0100
Message-ID: <1122222141.13200.239118760@webmail.messagingengine.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Can anyone please help me get my raid 1 device back up and running? I
had a chipset failure which took out one disk and then just after
replacing the disk and resyncing, the original disk lost power due to a
loose connection. mdadm seems to think that both devices are fine, but I
can't seem to fine the magic vodoo to get the raid array working again.
Sorry if this is a really stupid question. I did read the documentation
for mdadm pretty carefully, but I'm obviously missing something. Many
thanks,

Ali.

# dmseg | fgrep md
md: md driver 0.90.1 MAX_MD_DEVS=256, MD_SB_DISKS=27
md: raid1 personality registered as nr 3
md: Autodetecting RAID arrays.
md: autorun ...
md: considering hde2 ...
md:  adding hde2 ...
md:  adding hda2 ...
md: created md0
md: bind<hda2>
md: bind<hde2>
md: running: <hde2><hda2>
md: kicking non-fresh hda2 from array!
md: unbind<hda2>
md: export_rdev(hda2)
raid1: no operational mirrors for md0
md: pers->run() failed ...
md: do_md_run() returned -22
md: md0 stopped.
md: unbind<hde2>
md: export_rdev(hde2)
md: ... autorun DONE.
md: Autodetecting RAID arrays.
md: autorun ...
md: considering hde2 ...
md:  adding hde2 ...
md:  adding hda2 ...
md: created md0
md: bind<hda2>
md: bind<hde2>
md: running: <hde2><hda2>
md: kicking non-fresh hda2 from array!
md: unbind<hda2>
md: export_rdev(hda2)
raid1: no operational mirrors for md0
md: pers->run() failed ...
md: do_md_run() returned -22
md: md0 stopped.
md: unbind<hde2>
md: export_rdev(hde2)
md: ... autorun DONE.
md: md0 stopped.
md: bind<hda2>
md: bind<hde2>
md: kicking non-fresh hda2 from array!
md: unbind<hda2>
md: export_rdev(hda2)
raid1: no operational mirrors for md0
md: pers->run() failed ...
# mdadm --assemble /dev/md0 /dev/hda2 /dev/hde2
# more /proc/mdstat
Personalities : [raid1]
md0 : inactive hde2[2]
      23535104 blocks
unused devices: <none>
# mdadm -D /dev/md0
/dev/md0:
        Version : 00.90.01
  Creation Time : Sat May  7 00:03:45 2005
     Raid Level : raid1
    Device Size : 23535104 (22.44 GiB 24.10 GB)
   Raid Devices : 2
  Total Devices : 2
Preferred Minor : 0
    Persistence : Superblock is persistent

    Update Time : Sat Jul 23 08:25:16 2005
          State : dirty, degraded
 Active Devices : 0
Working Devices : 2
 Failed Devices : 0
  Spare Devices : 2


    Number   Major   Minor   RaidDevice State
       0       3        2        0      spare   /dev/hda2
       1       0        0       -1      removed
       2      33        2       -1      spare   /dev/hde2
# mdadm -E /dev/hda2
/dev/hda2:
          Magic : a92b4efc
        Version : 00.90.01
           UUID : aeff1135:511fe13c:e598e943:0907531e
  Creation Time : Sat May  7 00:03:45 2005
     Raid Level : raid1
    Device Size : 23535104 (22.44 GiB 24.10 GB)
   Raid Devices : 2
  Total Devices : 2
Preferred Minor : 0

    Update Time : Sat Jul 23 08:24:15 2005
          State : clean
 Active Devices : 1
Working Devices : 2
 Failed Devices : 1
  Spare Devices : 1
       Checksum : 1ebddac8 - correct
         Events : 0.469741


      Number   Major   Minor   RaidDevice State
this     0       3        2        0      active sync   /dev/hda2
   0     0       3        2        0      active sync   /dev/hda2
   1     1       0        0        1      faulty removed
   2     2      33        2        1      spare   /dev/hde2
# mdadm -E /dev/hde2
/dev/hde2:
          Magic : a92b4efc
        Version : 00.90.01
           UUID : aeff1135:511fe13c:e598e943:0907531e
  Creation Time : Sat May  7 00:03:45 2005
     Raid Level : raid1
    Device Size : 23535104 (22.44 GiB 24.10 GB)
   Raid Devices : 2
  Total Devices : 2
Preferred Minor : 0

    Update Time : Sat Jul 23 08:25:16 2005
          State : clean
 Active Devices : 1
Working Devices : 2
 Failed Devices : 1
  Spare Devices : 1
       Checksum : 1ec3a142 - correct
         Events : 0.658941


      Number   Major   Minor   RaidDevice State
this     2      33        2        2      spare   /dev/hde2
   0     0       3        2        0      active sync   /dev/hda2
   1     1       0        0        1      faulty removed
   2     2      33        2        2      spare   /dev/hde2

-- 
http://www.fastmail.fm - Choose from over 50 domains or use your own

