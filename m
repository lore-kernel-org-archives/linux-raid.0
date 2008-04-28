From: "Joshua Johnson" <enigma2175@gmail.com>
Subject: Help recovering from failed disk on RAID 6
Date: Sun, 27 Apr 2008 20:16:39 -0600
Message-ID: <e59c37290804271916t13c7cf4rb45e1c70f6ca9bfd@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I am running a linux server with an 8 disk IDE/SATA RAID 6 array.  One
of the disks is having a problem which caused the machine to freeze.
If I boot the machine without the problem disk the array fails to
start.  If I boot with the problem disk the array starts correctly and
begins syncing, but the machine will soon freeze up again when the
disk drops out.  My number one question is how to get the array back
online.  It has a spare disk, but since the OS is freezing rather than
failing the disk that is having the problem, it never switched to the
new disk.  When I try to start the array without the problem disk, I
get:

#mdadm --manage --run /dev/md0
raid5: device hda2 operational as raid disk 0
raid5: device sdb2 operational as raid disk 7
raid5: device sda1 operational as raid disk 6
raid5: device hdi2 operational as raid disk 5
raid5: device hdg2 operational as raid disk 3
raid5: device hde2 operational as raid disk 2
raid5: device hdk2 operational as raid disk 1
raid5: cannot start dirty degraded array for md0
RAID5 conf printout:
 --- rd:8 wd:7
 disk 0, o:1, dev:hda2
 disk 1, o:1, dev:hdk2
 disk 2, o:1, dev:hde2
 disk 3, o:1, dev:hdg2
 disk 5, o:1, dev:hdi2
 disk 6, o:1, dev:sda1
 disk 7, o:1, dev:sdb2
raid5: failed to run raid set md0
md: pers->run() failed ...
mdadm: failed to run array /dev/md0: Input/output error

/proc/mdstat contains:
Personalities : [raid1] [raid6] [raid5] [raid4]
md1 : active raid1 hdg1[1] hda1[0]
      4200896 blocks [2/2] [UU]

md0 : inactive hda2[0] sdc2[8](S) sdb2[7] sda1[6] hdi2[5] hdg2[3]
hde2[2] hdk2[1]
      1529265920 blocks


So how do I get this array to run?  I can't start it without the
problem disk and I can't sync it with the problem disk.  I am running
RAID 6 to be able to recover from multiple disk failures so it is a
little vexing that a single disk going offline renders my array
unrunnable.  Any help with this issue is greatly appreciated.
