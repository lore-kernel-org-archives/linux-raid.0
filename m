From: "kaltar" <kaltar@kaltar.org>
Subject: Software Raid: raidhotadd No Resyncing Array
Date: Wed, 24 Sep 2003 14:34:42 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <004501c382ca$85ecd000$991f43c7@Ricardo>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Guys,

I'm Running A Software Raid5 on RH9, and After A Fault On A Disc, I
raidhotremove it, shutdown, Replace The Disc, start again and raidhotadd it,
but There Is No Resync Of The Array. I've Done It before And There Was No
Problem. What Can Be Happening Now?
Is There Any Way I Launch The resync Manually?

Thanks

Heres More Info If You need To See It.

mdstat says that The Third Disk (hdi1) Is Down (the One I Replaced), But I
Try raidhotremoving it and adding it again, and still the same. no
rebuilding of the raid. But I Can See That Is Added As An Spare (Altought
There Is No Specification Of That On /etc/raidtab)

****************
 /proc/mdstat
****************
Personalities : [raid5]
read_ahead 1024 sectors
md0 : active raid5 hdi1[4] hdk1[3] hdg1[1] hde1[0]
      480238656 blocks level 5, 64k chunk, algorithm 0 [4/3] [UU_U]

unused devices: <none>
**********************




**************
/etc/raidtab
**************
raiddev             /dev/md0
raid-level                  5
nr-raid-disks               4
chunk-size                  64k
persistent-superblock       1
nr-spare-disks              0
    device          /dev/hde1
    raid-disk     0
    device          /dev/hdg1
    raid-disk     1
    device          /dev/hdi1
    raid-disk     2
    device          /dev/hdk1
    raid-disk     3

**************************
mdadm --examine /dev/hdi1
**************************
/dev/hdi1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : b3fee143:124cf455:c8e8f602:057999ae
  Creation Time : Mon Apr 28 14:40:14 2003
     Raid Level : raid5
    Device Size : 160079552 (152.66 GiB 163.92 GB)
   Raid Devices : 4
  Total Devices : 3
Preferred Minor : 0

    Update Time : Wed Sep 24 15:05:29 2003
          State : dirty, no-errors
 Active Devices : 3
Working Devices : 3
 Failed Devices : 0
  Spare Devices : 0
       Checksum : c584b5da - correct
         Events : 0.97

         Layout : left-asymmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     4      56        1        4        /dev/hdi1
   0     0      33        1        0      active sync   /dev/hde1
   1     1      34        1        1      active sync   /dev/hdg1
   2     2       0        0        2      faulty removed
   3     3      57        1        3      active sync   /dev/hdk1

***********************************
dmesg
***********************************
.
.
.
.
Partition check:
 hda: hda1 hda2
 hde: hde1
 hdg: hdg1
 hdi: hdi1
 hdk: hdk1
Floppy drive(s): fd0 is 1.44M
FDC 0 is a post-1991 82077
NET4: Frame Diverter 0.46
RAMDISK driver initialized: 16 RAM disks of 4096K size 1024 blocksize
ide-floppy driver 0.99.newide
md: md driver 0.90.0 MAX_MD_DEVS=256, MD_SB_DISKS=27
md: Autodetecting RAID arrays.
 [events: 0000005c]
 [events: 0000005c]
 [events: 0000005c]
 [events: 0000005c]
md: autorun ...
md: considering hdk1 ...
md:  adding hdk1 ...
md:  adding hdi1 ...
md:  adding hdg1 ...
md:  adding hde1 ...
md: created md0
md: bind<hde1,1>
md: bind<hdg1,2>
md: bind<hdi1,3>
md: bind<hdk1,4>
md: running: <hdk1><hdi1><hdg1><hde1>
md: hdk1's event counter: 0000005c
md: hdi1's event counter: 0000005c
md: hdg1's event counter: 0000005c
md: hde1's event counter: 0000005c
kmod: failed to exec /sbin/modprobe -s -k md-personality-4, errno = 2
md: personality 4 is not loaded!
md :do_md_run() returned -22
md: md0 stopped.
md: unbind<hdk1,3>
md: export_rdev(hdk1)
md: unbind<hdi1,2>
md: export_rdev(hdi1)
md: unbind<hdg1,1>
md: export_rdev(hdg1)
md: unbind<hde1,0>
md: export_rdev(hde1)
md: ... autorun DONE.
.
.
.
.
raid5: measuring checksumming speed
   8regs     :   829.440 MB/sec
   32regs    :   423.936 MB/sec
   pII_mmx   :  1003.520 MB/sec
   p5_mmx    :  1050.624 MB/sec
raid5: using function: p5_mmx (1050.624 MB/sec)
md: raid5 personality registered as nr 4
Journalled Block Device driver loaded
md: Autodetecting RAID arrays.
 [events: 0000005c]
 [events: 0000005c]
 [events: 0000005c]
 [events: 0000005c]
md: autorun ...
md: considering hde1 ...
md:  adding hde1 ...
md:  adding hdg1 ...
md:  adding hdi1 ...
md:  adding hdk1 ...
md: created md0
md: bind<hdk1,1>
md: bind<hdi1,2>
md: bind<hdg1,3>
md: bind<hde1,4>
md: running: <hde1><hdg1><hdi1><hdk1>
md: hde1's event counter: 0000005c
md: hdg1's event counter: 0000005c
md: hdi1's event counter: 0000005c
md: hdk1's event counter: 0000005c
md0: max total readahead window set to 768k
md0: 3 data-disks, max readahead per data-disk: 256k
raid5: device hde1 operational as raid disk 0
raid5: device hdg1 operational as raid disk 1
raid5: spare disk hdi1
raid5: device hdk1 operational as raid disk 3
raid5: md0, not all disks are operational -- trying to recover array
raid5: allocated 4334kB for md0
raid5: raid level 5 set md0 active with 3 out of 4 devices, algorithm 0
RAID5 conf printout:
 --- rd:4 wd:3 fd:1
 disk 0, s:0, o:1, n:0 rd:0 us:1 dev:hde1
 disk 1, s:0, o:1, n:1 rd:1 us:1 dev:hdg1
 disk 2, s:0, o:0, n:2 rd:2 us:1 dev:[dev 00:00]
 disk 3, s:0, o:1, n:3 rd:3 us:1 dev:hdk1
RAID5 conf printout:
 --- rd:4 wd:3 fd:1
 disk 0, s:0, o:1, n:0 rd:0 us:1 dev:hde1
 disk 1, s:0, o:1, n:1 rd:1 us:1 dev:hdg1
 disk 2, s:0, o:0, n:2 rd:2 us:1 dev:[dev 00:00]
 disk 3, s:0, o:1, n:3 rd:3 us:1 dev:hdk1
md: updating md0 RAID superblock on device
md: hde1 [events: 0000005d]<6>(write) hde1's sb offset: 160079552
md: recovery thread got woken up ...
md0: no spare disk to reconstruct array! -- continuing in degraded mode
md: recovery thread finished ...
md: hdg1 [events: 0000005d]<6>(write) hdg1's sb offset: 160079552
md: hdi1 [events: 0000005d]<6>(write) hdi1's sb offset: 160079552
md: hdk1 [events: 0000005d]<6>(write) hdk1's sb offset: 160079552
md: ... autorun DONE.
raid5: switching cache buffer size, 4096 --> 1024



