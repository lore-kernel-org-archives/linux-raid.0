From: <lilha@legend.com.cn>
Subject: md and lvm
Date: Thu, 30 May 2002 09:44:27 +0800
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <OF5BD3342B.53CED801-ON48256BC9.00097D87@legend.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

i try extend a LV with md, but failed,why?
Can a LV of md extend ?
follow is my VG information.

[root@snap /root]# vgdisplay -v
--- Volume group ---
VG Name               raid-lvm
VG Access             read/write
VG Status             available/resizable
VG #                  0
MAX LV                256
Cur LV                1
Open LV               0
MAX LV Size           255.99 GB
Max PV                256
Cur PV                2
Act PV                2
VG Size               2.52 GB
PE Size               4 MB
Total PE              646
Alloc PE / Size       231 / 924 MB
Free  PE / Size       415 / 1.62 GB
VG UUID               eiP2xh-pesL-Rbo0-EUL5-tOsM-eEma-yVd3qZ

--- Logical volume ---
LV Name                /dev/raid-lvm/lv_raid
VG Name                raid-lvm
LV Write Access        read/write
LV Status              available
LV #                   1
# open                 0
LV Size                924 MB
Current LE             231
Allocated LE           231
Allocation             next free
Read ahead sectors     120
Block device           58:0


--- Physical volumes ---
PV Name (#)           /dev/md2 (1)
PV Status             available / allocatable
Total PE / Free PE    398 / 167

PV Name (#)           /dev/md4 (2)
PV Status             available / allocatable
Total PE / Free PE    248 / 248

[root@snap /root]# cat /proc/mdstat
Personalities : [linear] [raid0] [raid1] [raid5] [multipath]
read_ahead 1024 sectors
md1 : active raid1 hda9[1]
      272960 blocks [2/1] [_U]

md2 : active raid5 hda12[2] hda11[1] hda10[0]
      1638400 blocks level 5, 32k chunk, algorithm 0 [3/3] [UUU]

md4 : active raid5 hdc7[2] hdc6[1] hdc5[0]
      1023872 blocks level 5, 32k chunk, algorithm 0 [3/3] [UUU]

unused devices: <none>

and now is the error information(i didn't use lvextend before):

[root@snap /root]# e2fsadm -L+1G /dev/raid-lvm/lv_raid
e2fsck 1.18, 11-Nov-1999 for EXT2 FS 0.5b, 95/08/09
The filesystem size (according to the superblock) is 338944 blocks
The physical size of the device is 236544 blocks
Either the superblock or the partition table is likely to be corrupt!
Abort<y>? yes

[root@snap /root]# e2fsadm -L+1G /dev/raid-lvm/lv_raid
e2fsck 1.18, 11-Nov-1999 for EXT2 FS 0.5b, 95/08/09
The filesystem size (according to the superblock) is 338944 blocks
The physical size of the device is 236544 blocks
Either the superblock or the partition table is likely to be corrupt!
Abort<y>? no

Pass 1: Checking inodes, blocks, and sizes
Error reading block 262148 (Invalid argument) while doing inode scan.
Ignore error<y>? yes
Error reading block 262149 (Invalid argument) while doing inode scan.
Ignore error<y>?  no
Error while scanning inodes (135680): Can't read next inode

and last is the error information of useing lvextend before:
[root@snap /root]# lvextend -L+1G /dev/raid-lvm/lv_raid
lvextend -- extending logical volume "/dev/raid-lvm/lv_raid" to 1.90 GB
lvextend -- doing automatic backup of volume group "raid-lvm"
lvextend -- logical volume "/dev/raid-lvm/lv_raid" successfully extended
[root@snap /root]# e2fsadm -L+1G /dev/raid-lvm/lv_raid
e2fsadm -- new size too large for "raid-lvm"
e2fsadm -- size of "/dev/raid-lvm/lv_raid" would  be invalid



TIA for your help and sorry for my poor English.

Echo




