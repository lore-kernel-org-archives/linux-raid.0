From: <martin@hack.org>
Subject: BSD disklabel and autodetection
Date: Tue, 23 Jul 2002 14:04:37 +0000 (GMT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.32.0207231350400.978-100000@dope.pingdynasty.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


hi all,

i'm trying to get autodetection to work on a RAID 5 raiddevice made up
from three devices. two of them reside on disks with DOS-style partition
tables, the third is on a disk with a BSD disklabel. all of them have the
partition type set to 0xfd, but only the first two devices are configured
at boot time.
the unit, which happens to be my root fs, still comes up but with only
two devices working.
i also have swap space configured as RAID1 over two BSD disklabel disks
which doesn't come up at all, and another RAID5 (/home) that doesn't
autodetect, so this is a bit of a problem to me.
if i run raidstart everything works fine, but that isn't an option for
root.
the same thing happens with kernel 2.4.4 and 2.4.18 - the BSD disklabel
partitions are not considered as autodetectable at boot time.

any ideas? i've tried to find information about this from the FAQ and
kernel mailinglists but can't figure out how to do it.

here's some output i get - md1 should consist of sdb5, sdd2 and sdc2 and
md0 of sda2 and sdb2:

md: autorun ...
md: considering sdd2 ...
md:  adding sdd2 ...
md:  adding sdc2 ...
md: created md1
md: bind<sdc2,1>
md: bind<sdd2,2>
md: running: <sdd2><sdc2>


many thanks in advance,

/m

