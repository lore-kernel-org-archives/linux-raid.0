From: jeffs_linux@123mail.org
Subject: Why do I get different results for 'mdadm --detail' & 'mdadm --examine'
 for the same array?
Date: Sat, 11 Jun 2011 18:01:11 -0700
Message-ID: <1307840471.18429.1462140465@webmail.messagingengine.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I'm working on setting up my 1st Linux production server with RAID for
our office.

I have four drives, across which I created two arrays.

mdadm --create /dev/md0 --verbose --bitmap=interal --metadata=0.90
--raid-devices=4 --homehost=jeffadm --name=jeffadm0 --level=raid1
/dev/sd[abcd]1

mdadm --create /dev/md1 --verbose --bitmap=interal --metadata=1.2
--raid-devices=4 --homehost=jeffadm --name=jeffadm1 --level=raid10
--layout=f2 --chunk=512 /dev/sd[abcd]2

After letting the arrays build an so on, I check to see:

fdisk -l | grep -i /dev/md | grep bytes
	Disk /dev/md127 doesn't contain a valid partition table
	Disk /dev/md126 doesn't contain a valid partition table
	Disk /dev/md127: 1998.2 GB, 1998231437312 bytes
	Disk /dev/md126: 1085 MB, 1085603840 bytes

cat /proc/mdstat
-----------------------------------
Personalities : [raid10] [raid0] [raid1] [raid6] [raid5] [raid4]
[linear]
md126 : active raid1 sda1[0] sdd1[3] sdc1[2] sdb1[1]
      1060160 blocks [4/4] [UUUU]
      bitmap: 0/130 pages [0KB], 4KB chunk

md127 : active raid10 sda2[0] sdd2[3] sdc2[2] sdb2[1]
      1951397888 blocks super 1.2 512K chunks 2 far-copies [4/4] [UUUU]
      bitmap: 11/466 pages [44KB], 2048KB chunk

unused devices: <none>
-----------------------------------

For assembly at boot-up I created by hand,

cat /etc/mdadm.conf
-----------------------------------
DEVICE /dev/disk/by-id/ata-ST31000528AS_9VP37KJF-part1
/dev/disk/by-id/ata-ST31000528AS_9VP18C2L-part1
/dev/disk/by-id/ata-ST31000528AS_9VP18JXF-part1
/dev/disk/by-id/ata-ST31000528AS_6FD23G3U-part1

DEVICE /dev/disk/by-id/ata-ST31000528AS_9VP37KJF-part2
/dev/disk/by-id/ata-ST31000528AS_9VP18C2L-part2
/dev/disk/by-id/ata-ST31000528AS_9VP18JXF-part2
/dev/disk/by-id/ata-ST31000528AS_6FD23G3U-part2

ARRAY /dev/md/0_0 level=raid1  num-devices=4 metadata=0.90
UUID=19f2b21c:e54f9e1a:be5ad16e:9754ab5e

ARRAY /dev/md/jeffadm:jeffadm1 level=raid10 num-devices=4 metadata=1.02
UUID=d84afb64:e6fa2b64:ff21c975:f9765431 name=name=jeffadm:jeffadm1
-----------------------------------

I installed a Linux system, across the RAID arrays.  It boots up like I
expect.  As far as I can tell, everything seems to work ok.



In case it's helpful,

dmesg | grep md
[    5.312800] md: raid10 personality registered for level 10
[    5.364552] md: raid0 personality registered for level 0
[    5.379499] md: raid1 personality registered for level 1
[    5.649211] md: raid6 personality registered for level 6
[    5.649213] md: raid5 personality registered for level 5
[    5.649214] md: raid4 personality registered for level 4
[    8.450420] md: md127 stopped.
[    8.461620] md: bind<sdb2>
[    8.470479] md: bind<sdc2>
[    8.479231] md: bind<sdd2>
[    8.487931] md: bind<sda2>
[    8.512436] md/raid10:md127: active with 4 out of 4 devices
[    8.529191] created bitmap (466 pages) for device md127
[    8.554742] md127: bitmap initialized from disk: read 30/30 pages,
set 3952 bits
[    8.599314] md127: detected capacity change from 0 to 1998231437312
[    8.621493]  md127: unknown partition table
[    9.645318] md: linear personality registered for level -1
[   12.397689] ata5: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0xff00
irq 14
[   12.397690] ata6: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0xff08
irq 15
[   18.127526] md: md126 stopped.
[   18.138594] md: bind<sdb1>
[   18.147113] md: bind<sdc1>
[   18.155444] md: bind<sdd1>
[   18.163804] md: bind<sda1>
[   18.172913] md/raid1:md126: active with 4 out of 4 mirrors
[   18.186626] created bitmap (130 pages) for device md126
[   18.201996] md126: bitmap initialized from disk: read 9/9 pages, set
0 bits
[   18.225079] md126: detected capacity change from 0 to 1085603840
[   18.240775]  md126: unknown partition table
[   20.429304] EXT4-fs (md126): mounted filesystem with ordered data
mode. Opts: acl,user_xattr,barrier=1
[   84.109701] EXT4-fs (md126): re-mounted. Opts:
acl,user_xattr,barrier=1,commit=0


Now, I'm going about characterizing the arrays, and the Volumes on them,
so I can deal with recovery if & when it's necessary.

When I "look" at the array with these two commands,

mdadm --examine --scan
	ARRAY /dev/md/jeffadm1 metadata=1.2
	UUID=d84afb64:e6fa2b64:ff21c975:f9765431 name=jeffadm:jeffadm1
	ARRAY /dev/md126 UUID=19f2b21c:e54f9e1a:be5ad16e:9754ab5e

mdadm --detail --scan
	ARRAY /dev/md127 metadata=1.2 name=jeffadm:jeffadm1
	UUID=d84afb64:e6fa2b64:ff21c975:f9765431
	ARRAY /dev/md/0_0 metadata=0.90
	UUID=19f2b21c:e54f9e1a:be5ad16e:9754ab5e


I get different results for each one.

From my reading about naming in mdadm.conf, I was expecting to see:

  /dev/md/0_0
  /dev/jeffadm:jeffadm1


Why do I get this mix of different results,

	/dev/md/jeffadm1
	/dev/md126

from the "--detail" output, and

	/dev/md127 metadata=1.2 name=jeffadm:jeffadm1
	/dev/md/0_0

according to the "--examine" output?

Is my mdadm.conf OK?  What really should I expect to see for the names
of my arrays?

Jeff
