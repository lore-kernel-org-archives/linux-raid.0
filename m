From: Rainer Fuegenstein <rfu@kaneda.iguw.tuwien.ac.at>
Subject: raid5: cannot start dirty degraded array
Date: Wed, 23 Dec 2009 12:50:23 +0100
Message-ID: <579884013.20091223125023@kaneda.iguw.tuwien.ac.at>
Reply-To: Rainer Fuegenstein <rfu@kaneda.iguw.tuwien.ac.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

hi,

got a "nice" early christmas present this morning: after a crash, the raid5
(consisting of 4*1.5TB WD caviar green SATA disks) won't start :-(

the history:
sometimes, the raid kicked out one disk, started a resync (which
lasted for about 3 days) and was fine after that. a few days ago I
replaced drive sdd (which seemed to cause the troubles) and synced the
raid again which finished yesterday in the early afternoon. at 10am
today the system crashed and the raid won't start:

OS is Centos 5
mdadm - v2.6.9 - 10th March 2009
Linux alfred 2.6.18-164.6.1.el5xen #1 SMP Tue Nov 3 17:53:47 EST 2009 i686 athlon i386 GNU/Linux


Dec 23 12:30:19 alfred kernel: md: Autodetecting RAID arrays.
Dec 23 12:30:19 alfred kernel: md: autorun ...
Dec 23 12:30:19 alfred kernel: md: considering sdd1 ...
Dec 23 12:30:19 alfred kernel: md:  adding sdd1 ...
Dec 23 12:30:19 alfred kernel: md:  adding sdc1 ...
Dec 23 12:30:19 alfred kernel: md:  adding sdb1 ...
Dec 23 12:30:19 alfred kernel: md:  adding sda1 ...
Dec 23 12:30:19 alfred kernel: md: created md0
Dec 23 12:30:19 alfred kernel: md: bind<sda1>
Dec 23 12:30:19 alfred kernel: md: bind<sdb1>
Dec 23 12:30:19 alfred kernel: md: bind<sdc1>
Dec 23 12:30:19 alfred kernel: md: bind<sdd1>
Dec 23 12:30:19 alfred kernel: md: running: <sdd1><sdc1><sdb1><sda1>
Dec 23 12:30:19 alfred kernel: md: kicking non-fresh sda1 from array!
Dec 23 12:30:19 alfred kernel: md: unbind<sda1>
Dec 23 12:30:19 alfred kernel: md: export_rdev(sda1)
Dec 23 12:30:19 alfred kernel: md: md0: raid array is not clean -- starting background reconstruction
    (no reconstruction is actually started, disks are idle)
Dec 23 12:30:19 alfred kernel: raid5: automatically using best checksumming function: pIII_sse
Dec 23 12:30:19 alfred kernel:    pIII_sse  :  7085.000 MB/sec
Dec 23 12:30:19 alfred kernel: raid5: using function: pIII_sse (7085.000 MB/sec)
Dec 23 12:30:19 alfred kernel: raid6: int32x1    896 MB/s
Dec 23 12:30:19 alfred kernel: raid6: int32x2    972 MB/s
Dec 23 12:30:19 alfred kernel: raid6: int32x4    893 MB/s
Dec 23 12:30:19 alfred kernel: raid6: int32x8    934 MB/s
Dec 23 12:30:19 alfred kernel: raid6: mmxx1     1845 MB/s
Dec 23 12:30:19 alfred kernel: raid6: mmxx2     3250 MB/s
Dec 23 12:30:19 alfred kernel: raid6: sse1x1    1799 MB/s
Dec 23 12:30:19 alfred kernel: raid6: sse1x2    3067 MB/s
Dec 23 12:30:19 alfred kernel: raid6: sse2x1    2980 MB/s
Dec 23 12:30:19 alfred kernel: raid6: sse2x2    4015 MB/s
Dec 23 12:30:19 alfred kernel: raid6: using algorithm sse2x2 (4015 MB/s)
Dec 23 12:30:19 alfred kernel: md: raid6 personality registered for level 6
Dec 23 12:30:19 alfred kernel: md: raid5 personality registered for level 5
Dec 23 12:30:19 alfred kernel: md: raid4 personality registered for level 4
Dec 23 12:30:19 alfred kernel: raid5: device sdd1 operational as raid disk 1
Dec 23 12:30:19 alfred kernel: raid5: device sdc1 operational as raid disk 3
Dec 23 12:30:19 alfred kernel: raid5: device sdb1 operational as raid disk 0
Dec 23 12:30:19 alfred kernel: raid5: cannot start dirty degraded array for md0
Dec 23 12:30:19 alfred kernel: RAID5 conf printout:
Dec 23 12:30:19 alfred kernel:  --- rd:4 wd:3 fd:1
Dec 23 12:30:19 alfred kernel:  disk 0, o:1, dev:sdb1
Dec 23 12:30:19 alfred kernel:  disk 1, o:1, dev:sdd1
Dec 23 12:30:19 alfred kernel:  disk 3, o:1, dev:sdc1
Dec 23 12:30:19 alfred kernel: raid5: failed to run raid set md0
Dec 23 12:30:19 alfred kernel: md: pers->run() failed ...
Dec 23 12:30:19 alfred kernel: md: do_md_run() returned -5
Dec 23 12:30:19 alfred kernel: md: md0 stopped.
Dec 23 12:30:19 alfred kernel: md: unbind<sdd1>
Dec 23 12:30:19 alfred kernel: md: export_rdev(sdd1)
Dec 23 12:30:19 alfred kernel: md: unbind<sdc1>
Dec 23 12:30:19 alfred kernel: md: export_rdev(sdc1)
Dec 23 12:30:19 alfred kernel: md: unbind<sdb1>
Dec 23 12:30:19 alfred kernel: md: export_rdev(sdb1)
Dec 23 12:30:19 alfred kernel: md: ... autorun DONE.
Dec 23 12:30:19 alfred kernel: device-mapper: multipath: version 1.0.5 loaded

# cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4]
unused devices: <none>

filesystem used on top of md0 is xfs.

please advice what to do next and let me know if you need further
information. really don't want to lose 3TB worth of data :-(


tnx in advance.

