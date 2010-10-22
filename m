From: =?utf-8?Q?Jes=C3=BAs_Berm=C3=BAdez?= <jbermudez@iten.es>
Subject: Help!
Date: Fri, 22 Oct 2010 16:51:20 +0200 (CEST)
Message-ID: <17967393.126.1287759080545.JavaMail.root@asterisk>
References: <1494909.124.1287759012019.JavaMail.root@asterisk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1494909.124.1287759012019.JavaMail.root@asterisk>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello all,

if you could help us, for we are completely desperated...

We have a raid5 with 3 disks that got out of sync due to a power failure. After tried to assemble (with mdadm --assemble --force /dev/md0) it says:

md: md0 stopped mdbind sdb2 bind sda2 bind sdc2

md: md0: array is not clean starting background reconstruction

raid 5  device sdc2 operational as raid disk 0
    device sda2 operational as raid disk 2
    device sdb2 operational as raid disk 1

allocated 32kb for md0

raid level 5 set md0 active with 3 out 3 devices algorithm 0

raid 5 conf printout

rd:3 wd:3

disk 0,0:1 /dev/sdc2
disk 1,0:1 /dev/sdb2
disk 2,0:1 /dev/sda2

md0: bitmap file is out of date 892893
forcing full recovery

md0: bitmap file is out of date doing full recovery

md0: bitmap initialisation failed: -5

md0: failed to create bitmap (-5)

md: pers->run() failed

mdadm: failed to run _array /dev/md0: input / output error

Tried to stop the array and reassemble it with:

mdadm --assemble --force --scan
mdadm --assemble --force --scan /dev/md0 /dev/sda2 /dev/sdb2 /dev/sdc2
mdadm --assemble --force --run /dev/md0 /dev/sda2 /dev/sdb2
mdadm --assemble --force --run /dev/md0 /dev/sda2 /dev/sdc2
mdadm --assemble --force --run /dev/md0 /dev/sdb2 /dev/sdc2

Tried to solve the bitmap problem with:

mdadm --grow /dev/md0 --bitmap=none
mdadm --grow /dev/md0 --bitmap=internal
mdadm --grow /dev/md0 --bitmap=none --force
mdadm --grow /dev/md0 --bitmap=internal --force

Tried to fake the 'clean' status of the array with:

echo "clean" > /sys/block/md0/md/array_state

Tried to boot the array from grub with:

    md-mod.start_dirty_degraded=1

None of these commands have worked. Here are the details of the array and everyone of the disks:

-----------------------------------------------------------------------------------------------------------------------------------
mdadm -D /dev/md0

dev/md0
version: 01.00.03
creation time: august 28 18:58:39 2009
raid level: raid5
used dev size 83891328 (80:01 hid 85:90 gdb)
raid devices: 3
total drives: 3
preferred minor: 0
persistent: superblock is persistent
update time: tue oct 19 15:09 2010
Status: active, not started
Active devices: 3
Working devices: 3
Failed devices: 0
Spare device: 0
layout: left assimetric
chunk size: 128k
name: 0

UUID: ae9bd4fe:994ce882:4fa035e6:8094fc1a
events: 893

    Number   Major   Minor   RaidDevice State
    0    8    34    0    active sync /dev/sdc2
    1    8    18    1    active sync /dev/sdb2
    3    8    2    2    active sync /dev/sda2

-----------------------------------------------------------------------------------------------------------------------------------
mdadm --examine /dev/sd[abc]2


/dev/sda2:

Magic:a92b4efc
Version:1,0
Featura Map:0x1
Array UUID:ae9bd4fe:994ce882:4fa035e6:8094fc1a
Name:0
Creation Time:Fri Aug 28 18:58:39 2009
Raid Level:Raid5
Raid Devices:3:Avail Dev Size:167782712 (80,01GIB 85,90 GB)
Array Size:335565312 (160,01 GIB 171,81 GB)
Used Dev Size:167782656 (80,01 GIB 85,90GB)
Super Offset:167782840 Sectors
State:Active
Device UUID:bbc156a7:6f3af82d:94714923:e212967a
Internal Bitmap:-81 sectors from superblock
Update Time:re Oct 19 15:49:08 2010
Checksum:54a35562 - correct
Events:893
Layout:left-asymmetric
Chunk Size:128K
Array Slot:3 (0. 1, failed, 2)
Array State:uuU 1 failed



/dev/sdb2:
	

Magic:a92b4efc
Version:1,0
Feature Map:0x1
Array UUID:ae9bd4fe:994ce882:4fa035e6:8094fc1a
Name:0
Creation Time:Fri Aug 28 18:58:39 2009
Raid Level:raid5
Raid Devices:3
Avail Dev Size:167782712 (80,01 GIB 85,90 GB)
Array Size:335565312 (160,01 GIB 171,81 GB)
Used Dev Size:167782656 (80,01 GIB 85,90 GB)
Super Offset:167782840 sectors
State:Active
Device UUID:d067101e:19056fdd:6b6e58fc:92128788
Internal Bimap:-81 sectors from superblock
Update Time:Tue Oct 19 15:49:08 2010
Checksum:61d3c2bf
Events:893
Layout:left-asymmetric
Chunk Size:128k
Array Slot:1 (0,  1, failed, 2)
Array State:uUu 1 failed

/dev/sdc2:
	
Magic:a92b4efc
Version:1,0
Featura Map:0x1
Array UUID:ae9bd4fe:994ce882:4fa035e6:8094fc1a
Name:0
Creation Time:Fri Aug 28 18:58:39 2009
Raid Level:raid5
Raid Devices:3
Avail Dev Size:167782712 (80,01 GIB 85,90 GB)
Array Size:335565312 (160,01 GIB 171,81 GB)
Used Dev Size:167782656 (80,01 GIB 85,90 GB)
Super Offset:167782840 sectors
State:active
Device UUID:0a1c2c74:04b9187f:6ab6b5cb:894d8b38
Internal Bimap:-81 sectos from superblock
Update Time:Tue Oct 19 15:49:08 2010
Checksum:d8faadc0 - correct
Events:893
Layout:left-asymmetric
Chunk Size:128K
Array Slot:0 (0, 1, failed, 2)
Array State:Uuu 1 failed

-----------------------------------------------------------------------------------------------------------------------------------

mdadm --examine-bitmap /dev/sd[abc]2
	
Filename /dev/sda2

Magic 6d746962
Version 4
UUID ae9bd4fe:994ce882:4fa035e6:8094fc1a
Events 892
Events Cleared 892
State Out of date
Chunksize 256KB
Daemon 5s flush period
Write Mode Normal
Sync Size 83891328 (80,01 GIB 85,90 GB)
Bitmap 327701 BITS (CHUNKS), 325633 DIRTY (99,4%)

Filename /dev/sdb2

Magic 6d746962
Version 4
UUID ae9bd4fe:994ce882:4fa035e6:8094fc1a
Events 892
Events Cleared 892
State Out of date
Chunksize 256KB
Daemon 5s flush period
Write Mode Normal
Sync Size 83891328 (80,01 GIB 85,90 GB)
Bitmap 327701 BITS (CHUNKS), 325633 DIRTY (99,4%)

Filename /dev/sdc2
Magic 6d746962
Version 4
UUID ae9bd4fe:994ce882:4fa035e6:8094fc1a
events 892
Events Cleared 892

State Out of date
Chunksize 256 KB
Daemon 5s flush period
Write Mode Normal
Sync Size 83891328 (80,01 GIB 85,90 GB)
Bitmap 327701 BITS (CHUNKS), 325633 DIRTY (99,4%)

-----------------------------------------------------------------------------------------------------------------------------------

cat /sys/bplock/md0/md/array_state

inactive


cat /sys/block/md0/md/degraded

cat /sys/block/md0/md/degraded: No such file or directory


cat /sys/block/md0/md/dev-sda2/errors

0

cat /sys/block/md0/md/dev-sda2/state

in_sync


cat /sys/block/md0/md/dev-sdb2/errors

24


cat /sys/block/md0/md/dev-sdb2/state

in_sync


cat /sys/block/md0/md/dev-sdc2/errors

0


cat /sys/block/md0/md/dev-sdc2/state

in_sync
-----------------------------------------------------------------------------------------------------------------------------------

Thanks in advance.

-- 
Jesus Bermudez Riquelme 


Iten, S.L. 
