From: Tejas Rao <raot@bnl.gov>
Subject: scsi_debug support
Date: Thu, 14 Jan 2016 19:22:05 -0500
Message-ID: <56983BAD.9040308@bnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Are scsi_debug devices supported with linux raid. I cannot seem to 
create a basic array.

[root@temp01 ~]# modprobe scsi_debug add_host=2 max_luns=3 num_tgts=4 
dev_size_mb=10240

[root@temp01 ~]# lsscsi | grep -e sda -e sdb
[8:2:0:0]    disk    IBM      ServeRAID M5110e 3.34  /dev/sdbm
[8:2:1:0]    disk    IBM      ServeRAID M5110e 3.34  /dev/sdbn
[52:0:0:0]   disk    Linux    scsi_debug       0004  /dev/sda
[52:0:0:1]   disk    Linux    scsi_debug       0004  /dev/sdb
[root@temp01 ~]# fdisk -l /dev/sda

Disk /dev/sda: 10.7 GB, 10737418240 bytes
255 heads, 63 sectors/track, 1305 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 32768 bytes
Disk identifier: 0x00000000

[root@temp01 ~]# mdadm --create --verbose /dev/md0 --level=0 
--raid-devices=2 /dev/sda /dev/sdb
mdadm: super1.x cannot open /dev/sda: Device or resource busy
mdmon: ddf: Cannot use /dev/sda: Device or resource busy
mdmon: Cannot use /dev/sda: It is busy
mdadm: cannot open /dev/sda: Device or resource busy
[root@temp01 ~]#

[root@temp01 ~]# mdadm -V
mdadm - v3.3 - 3rd September 2013
[root@temp01 ~]# uname -a
Linux temp01.rcf.bnl.gov 2.6.32-573.12.1.el6.x86_64 #1 SMP Mon Nov 23 
12:55:32 EST 2015 x86_64 x86_64 x86_64 GNU/Linux
[root@temp01 ~]#
