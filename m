From: <me@heyjay.com>
Subject: Building my first software raid
Date: Fri, 9 Apr 2004 16:50:39 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <00e201c41e7c$b40ee6f0$6405a8c0@a30>
Reply-To: <me@heyjay.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I've read all the linux raid how-tos, and thought I was ready to take the
plunge on implementing software raid.  I've got a fresh install of Debian
Sarge, 2 disks.  3 partitions (/boot, /, swap).  So I installed Sarge,
partitioned hda during the installer with regular partitions:

abba:/usr/src# sfdisk -l /dev/hda

Disk /dev/hda: 2491 cylinders, 255 heads, 63 sectors/track
Units = cylinders of 8225280 bytes, blocks of 1024 bytes, counting from 0

   Device Boot Start     End   #cyls    #blocks   Id  System
/dev/hda1   *      0+     11      12-     96358+  83  Linux
/dev/hda2         12     133     122     979965   82  Linux swap
/dev/hda3        134    1957    1824   14651280   83  Linux
/dev/hda4          0       -       0          0    0  Empty

I wanted to do a raid 1.  So, then I went and partitioned hdc like:

abba:/usr/src# sfdisk -l /dev/hdc

Disk /dev/hdc: 1870 cylinders, 255 heads, 63 sectors/track
Units = cylinders of 8225280 bytes, blocks of 1024 bytes, counting from 0

   Device Boot Start     End   #cyls    #blocks   Id  System
/dev/hdc1   *      0+     12      13-    104391   fd  Linux raid autodetect
/dev/hdc2         13     137     125    1004062+  fd  Linux raid autodetect
/dev/hdc3        138    1756    1619   13004617+  fd  Linux raid autodetect
/dev/hdc4          0       -       0          0    0  Empty

So now I'd build my raid set:

abba:/usr/src# mdadm --create /dev/md0 --level=1 --raid-devices=2 /dev/hda1
/dev/hdc1
mdadm: /dev/hda1 appears to contain an ext2fs file system
    size=96358K  mtime=Thu Apr  8 12:50:04 2004
mdadm: /dev/hdc1 appears to contain an ext2fs file system
    size=96358K  mtime=Wed Dec 31 18:00:00 1969
mdadm: largest drive (/dev/hdc1) exceed size (96256K) by more than 1%
Continue creating array? n
mdadm: create aborted.

I've google for that "mdadm: largest drive...than 1%" error with no results

Any help?

Thanks
Jay

