From: "Mehrdad Ziaei" <subscriber@ziaei.com>
Subject: How to change RAID1 to NON_RAID (lilo problem)
Date: Fri, 28 Nov 2003 10:18:50 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <011501c3b5c5$49d6bb20$b4d3cc8e@ziaei.com>
References: <Pine.LNX.4.44.0311280110270.1140-100000@redhat1.mmaero.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I have Linux Redhat 7.3 configured with software raid1.
I removed second disk from all mirror raids.
Now, lilo quits without showing any error messaes.
If I add second disk to raid for /boot, then lilo will start working fine
again.

My questions are:
1. How can I change my raid1 configuration to have only 1 disk and working
without any problem?
2. How can I change raid1 to non-raid?

Thank you for your help
Mehrdad.

==========================
[root@linux ]# strace lilo -t
execve("/sbin/lilo", ["lilo", "-t"], [/* 27 vars */]) = 0
uname({sys="Linux", node="linux", ...}) = 0
brk(0)                                  = 0x8058b04
....
....
open("/dev/md0", 0x4)                   = 4
fstat64(4, {st_mode=S_IFBLK|0660, st_rdev=makedev(9, 0), ...}) = 0
ioctl(4, 0x80480911, 0xbfffea40)        = 0
ioctl(4, 0x80140912, 0xbfffea20)        = 0
_exit(0)                                = ?
=====================
[root@linux ]# cat /proc/mdstat
Personalities : [raid1]
read_ahead 1024 sectors
md0 : active raid1 sda1[1]
      513984 blocks [2/1] [_U]

md1 : active raid1 sda2[1]
      34828800 blocks [2/1] [_U]

md2 : active raid1 sda3[1]
      570240 blocks [2/1] [_U]
=====================
[root@linux ]# cat /etc/raidtab
raiddev             /dev/md1
raid-level                  1
nr-raid-disks               1
chunk-size                  64k
persistent-superblock       1
nr-spare-disks              0
    device          /dev/sda2
    raid-disk     0
raiddev             /dev/md0
raid-level                  1
nr-raid-disks               1
chunk-size                  64k
persistent-superblock       1
nr-spare-disks              0
    device          /dev/sda1
    raid-disk     0
raiddev             /dev/md2
raid-level                  0
nr-raid-disks               1
chunk-size                  64k
persistent-superblock       1
nr-spare-disks              0
    device          /dev/sda3
    raid-disk     0
====================
