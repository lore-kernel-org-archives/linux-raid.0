From: Mike <mikee@mikee.ath.cx>
Subject: FailSpare event?
Date: Thu, 11 Jan 2007 22:11:52 +0000 (UTC)
Message-ID: <eo6cn8$5se$1@sea.gmane.org>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Can someone tell me what this means please? I just received this in
an email from one of my servers:


From: mdadm monitoring [root@$DOMAIN.com]
To: root@$DOMAIN.com
Subject: FailSpare event on /dev/md2:$HOST.$DOMAIN.com

This is an automatically generated mail message from mdadm
running on $HOST.$DOMAIN.com

A FailSpare event had been detected on md device /dev/md2.

It could be related to component device /dev/sde2.

Faithfully yours, etc.

On this machine I execute:

$ cat /proc/mdstat
Personalities : [raid5] [raid4] [raid1] 
md0 : active raid1 sdf1[2](S) sde1[3](S) sdd1[4](S) sdc1[5](S) sdb1[1] sda1[0]
104320 blocks [2/2] [UU]

md1 : active raid1 sdf3[2](S) sde3[3](S) sdd3[4](S) sdc3[5](S) sdb3[1] sda3[0]
3068288 blocks [2/2] [UU]

md2 : active raid5 sdf2[4] sde2[5](F) sdd2[3] sdc2[2] sdb2[1] sda2[0]
560732160 blocks level 5, 256k chunk, algorithm 2 [5/5] [UUUUU]

unused devices: <none>


Does the email message mean drive sde2[5] has failed? I know the sde2 refers
to the second partition of /dev/sde. Here is the partition table

# fdisk -l /dev/sde
[root@elo ~]# fdisk -l /dev/sde

Disk /dev/sde: 146.8 GB, 146815733760 bytes
255 heads, 63 sectors/track, 17849 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes

   Device Boot      Start         End      Blocks   Id  System
   /dev/sde1   *           1          13      104391   fd  Linux raid autodetect
   /dev/sde2              14       17465   140183190   fd  Linux raid autodetect
   /dev/sde3           17466       17847     3068415   fd  Linux raid autodetect

I have partition 2 of drive sde as one of the raid devices for md. Does the (S)
on sde3[2](S) mean the device is a spare for md1 and the same for md0?

Mike

