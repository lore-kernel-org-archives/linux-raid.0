From: "Marcus Williams" <marcus@quintic.co.uk>
Subject: Replacing failed drives in RAID1
Date: Fri, 13 Feb 2003 13:23:04 -0000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <b2g6qd$f9e$1@main.gmane.org>
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

[excuse strange formatting - posting from a new news client]
I have a problem trying to replace a failed drive in a RAID1 setup 
under Debian (woody).

Background: I have a 2 disk mirror, RAID 1 setup. It is made up of 
two 180Gb Western Digital WD1800JB drives. Both are partitioned as:

Partition Table for /dev/hda

            First    Last
 # Type     Sector   Sector   Offset  Length    Filesystem Type (ID)   Flags
-- ------- -------- --------- ------ ---------  ---------------------- ---------
 1 Primary        0  4000184      63  4000185   Linux raid autode (FD) Boot (80)
 2 Primary  4000185  5992244       0  1992060   Linux swap (82)        None (00)
 3 Primary  5992245 351646784      0  345654540 Linux (83)             None (00)
 

Partition Table for /dev/hdc

            First    Last
 # Type     Sector   Sector   Offset  Length    Filesystem Type (ID)   Flags
-- ------- -------- --------- ------ ---------  ---------------------- ---------
 1 Primary        0  4000184      63  4000185   Linux raid autode (FD) Boot (80)
 2 Primary  4000185  5992244       0  1992060   Linux swap (82)        None (00)
 3 Primary  5992245 351646784      0  345654540 Linux (83)             None (00)

Output of /proc/mdstat (when both devices are running):

Personalities : [linear] [raid0] [raid1]
read_ahead 1024 sectors
md1 : active raid1 hdc3[1] hda3[0]
      172827200 blocks [2/2] [UU]
md0 : active raid1 hdc1[1] hda1[0]
      1999936 blocks [2/2] [UU]
unused devices: <none>

Both raid devices have ext3 filesystems on them.

The problem: hda has now failed, and I have tried to put in a new 
drive. However, when the failed drive is replaced with the new 
drive, the raid device md1 will not restart and produces the 
following errors:

Feb 12 14:09:59 bart kernel: md: invalid raid superblock magic on hda3
Feb 12 14:09:59 bart kernel: md: hda3 has invalid sb, not importing!
Feb 12 14:09:59 bart kernel: md: could not import hda3!
Feb 12 14:09:59 bart kernel: md: autostart hda3 failed!
Feb 12 14:09:59 bart kernel: EXT3-fs: unable to read superblock

whereas, the md0 device auto-recovers - presumably because the 
auto-detect flag is set and the kernel is dealing with the rebuild:

Feb 12 14:09:59 bart kernel: md: linear personality registered as nr 1
Feb 12 14:09:59 bart kernel: md: raid0 personality registered as nr 2
Feb 12 14:09:59 bart kernel: md: raid1 personality registered as nr 3
Feb 12 14:09:59 bart kernel: md: md driver 0.90.0 MAX_MD_DEVS=256, MD_SB_DISKS=27
Feb 12 14:09:59 bart kernel: md: Autodetecting RAID arrays.
Feb 12 14:09:59 bart kernel:  [events: 00000000]
Feb 12 14:09:59 bart kernel: md: invalid raid superblock magic on hda1
Feb 12 14:09:59 bart kernel: md: hda1 has invalid sb, not importing!
Feb 12 14:09:59 bart kernel: md: could not import hda1!
Feb 12 14:09:59 bart kernel:  [events: 000000ce]
Feb 12 14:09:59 bart kernel: md: autorun ...
Feb 12 14:09:59 bart kernel: md: considering hdc1 ...
Feb 12 14:09:59 bart kernel: md:  adding hdc1 ...
Feb 12 14:09:59 bart kernel: md: created md0
Feb 12 14:09:59 bart kernel: md: bind<hdc1,1>
Feb 12 14:09:59 bart kernel: md: running: <hdc1>
Feb 12 14:09:59 bart kernel: md: hdc1's event counter: 000000ce
Feb 12 14:09:59 bart kernel: md0: removing former faulty hda1!
Feb 12 14:09:59 bart kernel: md: md0: raid array is not clean -- starting background reconstruction
Feb 12 14:09:59 bart kernel: md: RAID level 1 does not need chunksize! Continuing anyway.
Feb 12 14:09:59 bart kernel: md0: max total readahead window set to 124k
Feb 12 14:09:59 bart kernel: md0: 1 data-disks, max readahead per data-disk: 124k
Feb 12 14:09:59 bart kernel: raid1: device hdc1 operational as mirror 1
Feb 12 14:09:59 bart kernel: raid1: md0, not all disks are operational -- trying to recover array
Feb 12 14:09:59 bart kernel: raid1: raid set md0 active with 1 out of 2 mirrors
Feb 12 14:09:59 bart kernel: md: updating md0 RAID superblock on device
Feb 12 14:09:59 bart kernel: md: hdc1 [events: 000000cf]<6>(write) hdc1's sb offset: 1999936
Feb 12 14:09:59 bart kernel: md: recovery thread got woken up ...
Feb 12 14:09:59 bart kernel: md0: no spare disk to reconstruct array! -- continuing in degraded mode
Feb 12 14:09:59 bart kernel: md: recovery thread finished ...
Feb 12 14:09:59 bart kernel: md: ... autorun DONE.

From everything I have read, all I should have to do is replace
the drive when it fails with a correctly partitioned spare, 
reboot. Wait for the raid to autostart (in degraded mode) and 
raidhotadd the partitions back in to get them resynced. Is this 
correct? If not, where am I going wrong?

Thanks
Marcus
-- 
Marcus Williams - http://www.onq2.com
Quintic Ltd, 39 Newnham Road, Cambridge, UK

-- 
Composed with Newz Crawler 1.3 http://www.newzcrawler.com/


