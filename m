From: dick.streefland@xs4all.nl (Dick Streefland)
Subject: resync on every raidstart
Date: Sun, 21 Sep 2003 18:05:40 -0000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <7e6d.3f6de874.1ece7@altium.nl>
Reply-To: dick.streefland@xs4all.nl (Dick Streefland)
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Every time I stop a RAID1 device with raidstop, and start it again
with raidstart, it resyncs. Is this normal, or am I doing something
wrong? Here is an example with a RAID1 device on two loopback devices:

# cat /etc/raidtab
raiddev /dev/md0
	raid-level	1
	nr-raid-disks	2
	nr-spare-disks	0
	chunk-size	4
	device		/dev/loop1
	raid-disk	0
	device		/dev/loop2
	raid-disk	1
# mkraid /dev/md0
handling MD device /dev/md0
analyzing super-block
disk 0: /dev/loop1, 10240kB, raid superblock at 10176kB
disk 1: /dev/loop2, 10240kB, raid superblock at 10176kB

Sep 21 19:30:16 zaphod kernel: md: bind<loop1>
Sep 21 19:30:16 zaphod kernel: md: bind<loop2>
Sep 21 19:30:16 zaphod kernel: raid1: raid set md0 active with 2 out of 2 mirrors
Sep 21 19:30:16 zaphod kernel: md: syncing RAID array md0
Sep 21 19:30:16 zaphod kernel: md: minimum _guaranteed_ reconstruction speed: 1000 KB/sec/disc.
Sep 21 19:30:16 zaphod kernel: md: using maximum available idle IO bandwith (but not more than 200000 KB/sec) for reconstruction.
Sep 21 19:30:16 zaphod kernel: md: using 128k window, over a total of 10176 blocks.
Sep 21 19:30:17 zaphod kernel: md: md0: sync done.

# raidstop /dev/md0

Sep 21 19:30:31 zaphod kernel: md: md0 stopped.
Sep 21 19:30:31 zaphod kernel: md: unbind<loop2>
Sep 21 19:30:31 zaphod kernel: md: export_rdev(loop2)
Sep 21 19:30:31 zaphod kernel: md: unbind<loop1>
Sep 21 19:30:31 zaphod kernel: md: export_rdev(loop1)

# raidstart /dev/md0

Sep 21 19:30:46 zaphod kernel: md: autorun ...
Sep 21 19:30:46 zaphod kernel: md: considering loop2 ...
Sep 21 19:30:46 zaphod kernel: md:  adding loop2 ...
Sep 21 19:30:46 zaphod kernel: md:  adding loop1 ...
Sep 21 19:30:46 zaphod kernel: md: created md0
Sep 21 19:30:46 zaphod kernel: md: bind<loop1>
Sep 21 19:30:46 zaphod kernel: md: bind<loop2>
Sep 21 19:30:46 zaphod kernel: md: running: <loop2><loop1>
Sep 21 19:30:46 zaphod kernel: raid1: raid set md0 active with 2 out of 2 mirrors
Sep 21 19:30:46 zaphod kernel: md: ... autorun DONE.
Sep 21 19:30:46 zaphod kernel: md: syncing RAID array md0
Sep 21 19:30:46 zaphod kernel: md: minimum _guaranteed_ reconstruction speed: 1000 KB/sec/disc.
Sep 21 19:30:46 zaphod kernel: md: using maximum available idle IO bandwith (but not more than 200000 KB/sec) for reconstruction.
Sep 21 19:30:46 zaphod kernel: md: using 128k window, over a total of 10176 blocks.
Sep 21 19:30:47 zaphod kernel: md: md0: sync done.

I'm using raidtools2 version 1.00.3, and kernel 2.6.0-test5 with the
following configuration:

CONFIG_MD=y
CONFIG_BLK_DEV_MD=y
# CONFIG_MD_LINEAR is not set
# CONFIG_MD_RAID0 is not set
CONFIG_MD_RAID1=y
# CONFIG_MD_RAID5 is not set
# CONFIG_MD_MULTIPATH is not set
CONFIG_BLK_DEV_DM=y
# CONFIG_DM_IOCTL_V4 is not set

-- 
Dick Streefland                    ////               De Bilt
dick.streefland@xs4all.nl         (@ @)       The Netherlands
------------------------------oOO--(_)--OOo------------------

