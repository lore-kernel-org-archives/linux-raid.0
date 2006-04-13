From: =?ISO-8859-15?Q?Martin_M=FCller_-_Rudolf_Hausstein_OHG?=
	<m.mueller@hausstein.at>
Subject: Softraid wont be restarting
Date: Thu, 13 Apr 2006 15:49:51 +0200
Message-ID: <443E56FF.4040805@hausstein.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi!

Since two weeks im trying to remount a Sofraid (Level1) which I created 
with

mdadm -Cv /dev/md3 -l1 -2 /dev/sdc1 /dev/sdd1


When I boot the system, debian (3.1, kernel 2.6.16.1) tells me, that the 
reiserfs on the raid has a bad superblock.


When I recrate the raid and check it by mdadm I get the following 
different messeges:

bash:~# mdadm -Q /dev/md3
/dev/md3: 186.31GiB raid1 2 devices, 0 spares. Use mdadm --detail for 
more detail.
/dev/md3: No md super block found, not an md component.


bash:~# mdadm --detail /dev/md3
/dev/md3:
Version : 00.90.03
Creation Time : Wed Apr 12 15:49:28 2006
Raid Level : raid1
Array Size : 195358336 (186.31 GiB 200.05 GB)
Device Size : 195358336 (186.31 GiB 200.05 GB)
Raid Devices : 2
Total Devices : 2
Preferred Minor : 3
Persistence : Superblock is persistent

Update Time : Wed Apr 12 15:49:46 2006
State : active, resyncing
Active Devices : 2
Working Devices : 2
Failed Devices : 0
Spare Devices : 0

Rebuild Status : 4% complete

UUID : 2cb624fd:38e44c54:716ab7c2:c6c0e8c3
Events : 0.2

Number Major Minor RaidDevice State
0 8 33 0 active sync /dev/sdc1
1 8 49 1 active sync /dev/sdd1

----------


I?m having other softraids, wich are created by the installationsroutine 
of sarge. These raids are working properly.
My /etc/mdadm/mdadm.cong looks like this:

DEVICE partitions
ARRAY /dev/md2 level=raid1 num-devices=1 spares=1 
UUID=fd3f5565:700efa41:9c649802:f9165970
devices=/dev/sda4,/dev/sdb4
ARRAY /dev/md1 level=raid1 num-devices=1 spares=1 
UUID=ce956e77:bb6dfc5c:052c5d48:90ccc5a5
devices=/dev/sda3,/dev/sdb3
ARRAY /dev/md0 level=raid1 num-devices=1 spares=1 
UUID=5f5bc322:fe00157d:7f574758:88afc009
devices=/dev/sda2,/dev/sdb2

ARRAY /dev/md3 level=raid1 num-devices=1 spares=1
devices=/dev/sdc1,/dev/sdd1


A part of the bootlog in /var/log/messages :

Apr 12 15:36:39 localhost kernel: ReiserFS: md3: warning: sh-2006: 
read_super_block: bread failed (dev md3, block 2, size 4096)

Apr 12 15:36:39 localhost kernel: ReiserFS: md3: warning: sh-2006: 
read_super_block: bread failed (dev md3, block 16, size 4096)

Apr 12 15:36:39 localhost kernel: ReiserFS: md3: warning: sh-2021: 
reiserfs_fill_super: can not find reiserfs on md3


I have surely created a reiserfs on the raid, and I have waited till the 
sync is done before I restarted the machine.


Details of fdisk:

fdisk /dev/sdc

p

Disk /dev/sdc: 200.0 GB, 200049647616 bytes
255 heads, 63 sectors/track, 24321 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes

Device Boot Start End Blocks Id System
/dev/sdc1 1 24321 195358401 fd Linux raid autodetect


fdisk /dev/sdd
p

Disk /dev/sdd: 200.0 GB, 200049647616 bytes
255 heads, 63 sectors/track, 24321 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes

Device Boot Start End Blocks Id System
/dev/sdd1 1 24321 195358401 fd Linux raid autodetect



--- Can anyone help me with this? On the raid, there are no necessary data.
What have to do, to mount the raid during startup.


THX, Martin

