From: Mike Viau <viaum@sheridanc.on.ca>
Subject: Removed drive from mdadm raid 5 array after reboot
Date: Fri, 18 Feb 2011 15:08:14 -0500
Message-ID: <BAY148-w245C4F3B070F5743631EA9EFD40@phx.gbl>
References: <BAY148-w38CAE450FEC67644025E33EFD40@phx.gbl>,<BAY148-w4658B4D2C63A5B2ADAEDBEFD40@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BAY148-w4658B4D2C63A5B2ADAEDBEFD40@phx.gbl>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Hello,

I was wondering if anyone had come across an issue where after rebooting the system, mdadm fails to reassemble an entire raid 5 array with all the drives. I am getting the array up with just /dev/sda and /dev/sdb, but the array is degraded as a consequence to missing /dev/sdd (which I assume has become the parity drive). 

I also posted the question over at the debian-user list: http://lists.debian.org/debian-user/2011/02/msg01898.html
No action yet over there, so I thought I should ask here :)

Below is some information that I believe will help display my situation. Your help is greatly appreciated, TIA!

mdadm -V
mdadm - v3.1.4 - 31st August 2010
(Debian Version: Version: 3.1.4-1+8efb9d1)


uname -a
Linux XEN-HOST 2.6.32.26-xen-amd64 #1 SMP Thu Dec 2 00:20:03 EST 2010 x86_64 GNU/Linux


mdadm --detail /dev/md0
/dev/md0:
Version : 1.2
Creation Time : Mon Dec 20 09:48:07 2010
Raid Level : raid5
Array Size : 1953517568 (1863.02 GiB 2000.40 GB)
Used Dev Size : 976758784 (931.51 GiB 1000.20 GB)
Raid Devices : 3
Total Devices : 2
Persistence : Superblock is persistent

Update Time : Fri Feb 18 12:27:09 2011
State : clean, degraded
Active Devices : 2
Working Devices : 2
Failed Devices : 0
Spare Devices : 0

Layout : left-symmetric
Chunk Size : 512K

Name : XEN-HOST:0 (local to host XEN-HOST)
UUID : 7d8a7c68:95a230d0:0a8f6e74:4c8f81e9
Events : 32122

Number Major Minor RaidDevice State
0 8 1 0 active sync /dev/sda1
1 8 17 1 active sync /dev/sdb1
2 0 0 2 removed <-------- Missing drive



fdisk -luc /dev/sda

Disk /dev/sda: 1000.2 GB, 1000204886016 bytes
255 heads, 63 sectors/track, 121601 cylinders, total 1953525168 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x411fb12e

Device Boot Start End Blocks Id System
/dev/sda1 63 1953520064 976760001 fd Linux raid autodetect



fdisk -luc /dev/sdb

Disk /dev/sdb: 1000.2 GB, 1000204886016 bytes
255 heads, 63 sectors/track, 121601 cylinders, total 1953525168 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x02f65de3

Device Boot Start End Blocks Id System
/dev/sdb1 63 1953520064 976760001 fd Linux raid autodetect



fdisk -luc /dev/sdd

Disk /dev/sdd: 1000.2 GB, 1000204886016 bytes
81 heads, 63 sectors/track, 382818 cylinders, total 1953525168 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x8b0c29c7

Device Boot Start End Blocks Id System
/dev/sdd1 2048 1953525167 976761560 fd Linux raid autodetect




cat /etc/mdadm/mdadm.conf
# mdadm.conf
#
# Please refer to mdadm.conf(5) for information about this file.
#

# by default, scan all partitions (/proc/partitions) for MD superblocks.
# alternatively, specify devices to scan, using wildcards if desired.
DEVICE partitions

# auto-create devices with Debian standard permissions
CREATE owner=root group=disk mode=0660 auto=yes

# automatically tag new arrays as belonging to the local system
HOMEHOST

# instruct the monitoring daemon where to send mail alerts
MAILADDR root

# definitions of existing MD arrays
ARRAY /dev/md/0 metadata=1.2 UUID=7d8a7c68:95a230d0:0a8f6e74:4c8f81e9 name=XEN-HOST:0



cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4]
md0 : active raid5 sda1[0] sdb1[1]
1953517568 blocks super 1.2 level 5, 512k chunk, algorithm 2 [3/2] [UU_]

unused devices:


Then after:

mdadm --add /dev/md0 /dev/sdd1
mdadm: re-added /dev/sdd1


cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4]
md0 : active raid5 sdd1[3] sda1[0] sdb1[1]
1953517568 blocks super 1.2 level 5, 512k chunk, algorithm 2 [3/2] [UU_]
[....................] recovery = 0.0% (121732/976758784) finish=534.8min speed=30433K/sec



Thanks.


 		 	   		  