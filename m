From: =?ISO-8859-1?Q?Rudolf_B=F6rner?= <rb@knoepfle.de>
Subject: device-mapper: : dm-linear: Device lookup failed
Date: Mon, 31 Jan 2005 20:12:45 +0100
Message-ID: <41FE832D.6000600@knoepfle.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

since my Update 9.1. --> 9.2 SUSE I've get a lot of Error/Information in 
boot.msg and it is impossible
to mount my Disk hhd1 an RAID 1.

What is to do?  Have anybody an Idea?

Thanks

Regards

Rudolf


Device
mount /dev/hdd1 /mnt
mount: /dev/hdd1 already mounted or /mnt busy

RoteZora:/var/log # mount
/dev/md0 on / type reiserfs (rw)
proc on /proc type proc (rw)
tmpfs on /dev/shm type tmpfs (rw)
devpts on /dev/pts type devpts (rw,mode=0620,gid=5)
/dev/md1 on /opt type reiserfs (rw)
/dev/md2 on /usr type reiserfs (rw)

RoteZora:/var/log # df -T
Filesystem    Type   1K-blocks      Used Available Use% Mounted on
/dev/md0  reiserfs    20972088    380952  20591136   2% /
tmpfs        tmpfs      517912        12    517900   1% /dev/shm
/dev/md1  reiserfs    10490040    928404   9561636   9% /opt
/dev/md2  reiserfs    81543360   5082620  76460740   7% /usr
RoteZora:/var/log #                                                

boot.msg

<6>device-mapper: 4.1.0-ioctl (2003-12-10) initialised: dm@uk.sistina.com
<3>device-mapper: : dm-linear: Device lookup failed
<4>device-mapper: error adding target to table
<3>device-mapper: : dm-linear: Device lookup failed



.... and more


<4>RoteZora:/var/log # cat boot.msg |grep md|more
<6>md: md driver 0.90.0 MAX_MD_DEVS=256, MD_SB_DISKS=27
<7>PM: Reading pmdisk image.
<7>pmdisk: Error -22 resuming
<6>md: Autodetecting RAID arrays.
<6>md: autorun ...
<6>md: considering hdb4 ...
<6>md:  adding hdb4 ...
<4>md: hdb3 has different UUID to hdb4
<4>md: hdb1 has different UUID to hdb4
<6>md:  adding hda4 ...
<4>md: hda3 has different UUID to hdb4
<4>md: hda1 has different UUID to hdb4
<6>md: created md2
<6>md: bind<hda4>
<6>md: bind<hdb4>
<6>md: running: <hdb4><hda4>
<4>md: personality 3 is not loaded!
<4>md :do_md_run() returned -22
<6>md: md2 stopped.
<6>md: unbind<hdb4>
<6>md: export_rdev(hdb4)
<6>md: unbind<hda4>
<6>md: export_rdev(hda4)
<6>md: considering hdb3 ...
<6>md:  adding hdb3 ...
<4>md: hdb1 has different UUID to hdb3
<6>md:  adding hda3 ...
<4>md: hda1 has different UUID to hdb3
<6>md: created md1
<6>md: bind<hda3>
<6>md: bind<hdb3>
<6>md: running: <hdb3><hda3>
<4>md: personality 3 is not loaded!
<4>md :do_md_run() returned -22
<6>md: md1 stopped.
<6>md: unbind<hdb3>
<6>md: export_rdev(hdb3)
<6>md: unbind<hda3>
<6>md: export_rdev(hda3)
<6>md: considering hdb1 ...
<6>md:  adding hdb1 ...
<6>md:  adding hda1 ...
<6>md: created md0
<6>md: bind<hda1>
<6>md: bind<hdb1>
<6>md: running: <hdb1><hda1>
<4>md: personality 3 is not loaded!
<4>md :do_md_run() returned -22
<6>md: md0 stopped.
<6>md: unbind<hdb1>
<6>md: export_rdev(hdb1)
<6>md: unbind<hda1>
<6>md: export_rdev(hda1)
<6>md: ... autorun DONE.
<6>md: raid1 personality registered as nr 3
<6>md: Autodetecting RAID arrays.
<6>md: autorun ...
<6>md: considering hda1 ...
<6>md:  adding hda1 ...
<6>md:  adding hdb1 ...
<4>md: hda3 has different UUID to hda1
<4>md: hdb3 has different UUID to hda1
<4>md: hda4 has different UUID to hda1
<4>md: hdb4 has different UUID to hda1
<6>md: created md0
<6>md: bind<hdb1>
<6>md: bind<hda1>
<6>md: running: <hda1><hdb1>
<6>raid1: raid set md0 active with 2 out of 2 mirrors
<6>md: considering hda3 ...
<6>md:  adding hda3 ...
<6>md:  adding hdb3 ...
<4>md: hda4 has different UUID to hda3
<4>md: hdb4 has different UUID to hda3
<6>md: created md1
<6>md: bind<hdb3>
<6>md: bind<hda3>
<6>md: running: <hda3><hdb3>
<6>raid1: raid set md1 active with 2 out of 2 mirrors
<6>md: considering hda4 ...
<6>md:  adding hda4 ...
<6>md:  adding hdb4 ...
<6>md: created md2
<6>md: bind<hdb4>
<6>md: bind<hda4>
<6>md: running: <hda4><hdb4>
<6>raid1: raid set md2 active with 2 out of 2 mirrors
<6>md: ... autorun DONE.
<5>ReiserFS: md0: found reiserfs format "3.6" with standard journal
<5>ReiserFS: md0: using ordered data mode
<5>ReiserFS: md0: journal params: device md0, size 8192, journal first 
block 18, max trans len 1024, max batch
900, max commit age 30, max trans age 30
<5>ReiserFS: md0: checking transaction log (md0)
<5>ReiserFS: md0: Using r5 hash to sort names
<5>Trying to free ramdisk memory ... okay
<4>md: raidstart(pid 2285) used deprecated START_ARRAY ioctl. This will 
not be supported beyond 2.6
<3>md: could not bd_claim hda1.
<4>md: autostart failed!
<6>md: Autodetecting RAID arrays.
<6>md: autorun ...
<6>md: ... autorun DONE.
<5>ReiserFS: md1: found reiserfs format "3.6" with standard journal
<5>ReiserFS: md1: using ordered data mode
<5>ReiserFS: md1: journal params: device md1, size 8192, journal first 
block 18, max trans len 1024, max batch
900, max commit age 30, max trans age 30
<5>ReiserFS: md1: checking transaction log (md1)
<5>ReiserFS: md1: Using r5 hash to sort names
<5>ReiserFS: md2: found reiserfs format "3.6" with standard journal
<5>ReiserFS: md2: using ordered data mode
<5>ReiserFS: md2: journal params: device md2, size 8192, journal first 
block 18, max trans len 1024, max batch
900, max commit age 30, max trans age 30
<5>ReiserFS: md2: checking transaction log (md2)
<5>ReiserFS: md2: Using r5 hash to sort names
Mounting shared memory FS on /dev/shmdone
<notice>run boot scripts (boot.md boot.device-mapper)
considering /dev/md0...
/dev/md0 is not a RAID0 or LINEAR array, skipping.
/dev/md0: Invalid argument
<notice>exit status of (boot.md boot.device-mapper) is (0 0)
Reiserfs journal '/dev/md1' in blocks [18..8211]: 0 transactions replayed
Reiserfs journal '/dev/md2' in blocks [18..8211]: 0 transactions replayed
/dev/md1 on /opt type reiserfs (rw)
/dev/md2 on /usr type reiserfs (rw)
Disk /dev/md2 doesn't contain a valid partition table
Disk /dev/md1 doesn't contain a valid partition table





-- 
\ Rudolf Boerner
=> Klarastr. 96 a	...-- 	 __@
|>  79106 Freiburg    ....---   _\<,_
\!^  email: rb@knoepfle.de     (_) (_)

