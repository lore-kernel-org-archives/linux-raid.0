From: Claudio Fleiner <raid@fleiner.com>
Subject: problems with raidhotgenerateerror
Date: Wed, 18 Dec 2002 02:22:30 GMT
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200212180222.gBI2MUD23542@ars.net>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I was playing around with raid1 using two loopback devices of 4M each.
The config file I'm using looks like this:

raiddev /dev/md0
          raid-level      1
          nr-raid-disks   2
          nr-spare-disks  0
          chunk-size     4
          persistent-superblock 1
          device          /dev/loop0
          raid-disk       0
          device          /dev/loop1
          raid-disk       1


Everything works as expected, except that I cannot simulate an error using
raidhotgenerateerror. The command runs just fine (as confirmed by the following strace,
(all unnecessary stuff removed):

execve("/home/cfl/prog/raidtools-20010914/raidhotgenerateerror", ["/home/cfl/prog/raidtools-20010914/raidhotgenerateerror", "-c", "c", "/dev/md0", "/dev/loop0"], [/* 58 vars */]) = 0
open("/dev/md0", O_RDONLY)              = 4
ioctl(4, 0x800c0910, 0x804f948)         = 0
open("/dev/md0", O_RDWR)                = 5
fstat64(5, {st_mode=S_IFBLK|0660, st_rdev=makedev(9, 0), ...}) = 0
stat64("/dev/loop0", {st_mode=S_IFBLK|0660, st_rdev=makedev(7, 0), ...}) = 0
ioctl(5, 0x92a, 0x700)                  = 0
_exit(0)                                = ?

but /proc/mdstat shows that loop0 is still OK (writing to the md0 device
does not make a difference) and removing the drive using raidhotremove
fails):

Personalities : [raid0] [raid1] [raid5] 
read_ahead 1024 sectors
md0 : active raid1 [dev 07:01][1] [dev 07:00][0]
      4032 blocks [2/2] [UU]
      

I'm using Redhat 7.2 with a 2.4.19 kernel.

Any idea why this is not working?

Thanks, Claudio



