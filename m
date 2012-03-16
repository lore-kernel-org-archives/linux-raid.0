From: "Carl Engstrom" <engstrom@cox.net>
Subject: FW: mdadm raid can't set proper devices in super-block
Date: Fri, 16 Mar 2012 16:37:02 -0700
Message-ID: <004501cd03cd$b6f4d4d0$24de7e70$@cox.net>
References: <loom.20120312T183628-941@post.gmane.org> <4F5E416B.9020003@anonymous.org.uk> <003901cd0204$87ea81f0$97bf85d0$@cox.net>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <003901cd0204$87ea81f0$97bf85d0$@cox.net>
Content-Language: en-us
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


...
> 0 0 8 1 0 active sync /dev/sda1
>   1 1 8 17 1 active sync /dev/sdb1
>   --------
>
> the array will start with:
>   mdadm -A --update=super-minor /dev/md0 /dev/sdb1 /dev/sdc1

Q:  So it starts just fine if you specify the devices...

A:  Yes  the array starts fine when I put the parameters in.  There is also
an issue where the expected /dev/md0 shows up as md_d0, but I can live with
that.

> Anyone know what's going on?

--update=super-minor is working fine; both devices have a preferred minor
device number of zero, as they should for the array to be /dev/md0.

Q: What happens if you
   mdadm --stop /dev/md0
   mdadm --assemble --scan --verbose /dev/md0 ?

A: The device isn't identified in the config file.  I generally don't put
anything in the config file and it's always seemed to work.

Q: Where do you want to mount /dev/md0?
A: /backup

What messages do you get during boot-up (dmesg) about why md0 isn't being
assembled?

============
[    0.481723] ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0x30a0 irq
14
[    0.481730] ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x30a8 irq
15
[    0.806077] md: linear personality registered for level -1
[    0.824006] md: multipath personality registered for level -4
[    0.965715] md: raid0 personality registered for level 0
[    0.993103] md: raid1 personality registered for level 1
[    1.518611] mdadm: sending ioctl 1261 to a partition!
[    1.518618] mdadm: sending ioctl 1261 to a partition!
[    1.518830] mdadm: sending ioctl 1261 to a partition!
[    1.518835] mdadm: sending ioctl 1261 to a partition!
[    1.519733] mdadm: sending ioctl 1261 to a partition!
[    1.519738] mdadm: sending ioctl 1261 to a partition!
[    1.522247] mdadm: sending ioctl 1261 to a partition!
[    1.522254] mdadm: sending ioctl 1261 to a partition!
[    1.523580] mdadm: sending ioctl 1261 to a partition!
[    1.523587] mdadm: sending ioctl 1261 to a partition!
[    1.524944] mdadm: sending ioctl 1261 to a partition!
[    1.524949] mdadm: sending ioctl 1261 to a partition!
[    1.525971] mdadm: sending ioctl 1261 to a partition!
[    1.525978] mdadm: sending ioctl 1261 to a partition!
[    2.080886] md: raid6 personality registered for level 6
[    2.080892] md: raid5 personality registered for level 5
[    2.080897] md: raid4 personality registered for level 4
[    2.092484] md: raid10 personality registered for level 10
[   16.430546] mdadm: sending ioctl 1261 to a partition!
[   16.430551] mdadm: sending ioctl 1261 to a partition!
[   16.440763] mdadm: sending ioctl 1261 to a partition!
[   16.440769] mdadm: sending ioctl 1261 to a partition!
[   16.441262] mdadm: sending ioctl 1261 to a partition!
[   16.441267] mdadm: sending ioctl 1261 to a partition!
[   16.442125] mdadm: sending ioctl 1261 to a partition!
[   16.442130] mdadm: sending ioctl 1261 to a partition!
[   16.442710] mdadm: sending ioctl 1261 to a partition!
[   16.442715] mdadm: sending ioctl 1261 to a partition!
[   16.442915] mdadm: sending ioctl 1261 to a partition!
[   16.442919] mdadm: sending ioctl 1261 to a partition!
[   16.443693] mdadm: sending ioctl 1261 to a partition!
[   16.443709] mdadm: sending ioctl 1261 to a partition!
[   16.458427] md: bind<sdc1>
[   16.458843] mdadm: sending ioctl 1261 to a partition!
[   16.458848] mdadm: sending ioctl 1261 to a partition!
[   16.465101] mdadm: sending ioctl 1261 to a partition!
[   16.465107] mdadm: sending ioctl 1261 to a partition!
[   16.465621] mdadm: sending ioctl 1261 to a partition!
[   16.465627] mdadm: sending ioctl 1261 to a partition!
[   16.466434] mdadm: sending ioctl 1261 to a partition!
[   16.466439] mdadm: sending ioctl 1261 to a partition!
[   16.467033] mdadm: sending ioctl 1261 to a partition!
[   16.467037] mdadm: sending ioctl 1261 to a partition!
[   16.468037] mdadm: sending ioctl 1261 to a partition!
[   16.468043] mdadm: sending ioctl 1261 to a partition!
[   16.468447] mdadm: sending ioctl 1261 to a partition!
[   16.468463] mdadm: sending ioctl 1261 to a partition!
[   16.474276] mdadm: sending ioctl 1261 to a partition!
[   16.474282] mdadm: sending ioctl 1261 to a partition!
[   16.475038] mdadm: sending ioctl 1261 to a partition!
[   16.475043] mdadm: sending ioctl 1261 to a partition!
[   16.476065] mdadm: sending ioctl 1261 to a partition!
[   16.476070] mdadm: sending ioctl 1261 to a partition!
[   16.476843] mdadm: sending ioctl 1261 to a partition!
[   16.476848] mdadm: sending ioctl 1261 to a partition!
[   16.478447] mdadm: sending ioctl 1261 to a partition!
[   16.478453] mdadm: sending ioctl 1261 to a partition!
[   16.478865] mdadm: sending ioctl 1261 to a partition!
[   16.478869] mdadm: sending ioctl 1261 to a partition!
[ 3885.067642] mdadm: sending ioctl 1261 to a partition!
[ 3885.067648] mdadm: sending ioctl 1261 to a partition!
[ 3885.068683] mdadm: sending ioctl 1261 to a partition!
[ 3885.068687] mdadm: sending ioctl 1261 to a partition!
[ 3885.088444] mdadm: sending ioctl 1261 to a partition!
[ 3885.088450] mdadm: sending ioctl 1261 to a partition!
[ 3886.446271] mdadm: sending ioctl 1261 to a partition!
[ 3886.446277] mdadm: sending ioctl 1261 to a partition!
[ 3886.470887] mdadm: sending ioctl 1261 to a partition!
[ 3886.470893] mdadm: sending ioctl 1261 to a partition!
[ 3886.473206] mdadm: sending ioctl 1261 to a partition!
========================
Q: What's in your /etc/mdadm.conf?
==============

# mdadm.conf
#
# Please refer to mdadm.conf(5) for information about this file.
#

# by default, scan all partitions (/proc/partitions) for MD superblocks.
# alternatively, specify devices to scan, using wildcards if desired.
DEVICE partitions

# auto-create devices with Debian standard permissions CREATE owner=root
group=disk mode=0660 auto=yes

# automatically tag new arrays as belonging to the local system HOMEHOST
<system>

# instruct the monitoring daemon where to send mail alerts MAILADDR root

# definitions of existing MD arrays

# This file was auto-generated on Fri, 03 Oct 2008 07:40:26 -0700 # by
mkconf $Id$ ==================

If /etc/mdadm.conf says sda1 and sdb1, fix it and do whatever you need to do
on Ubuntu to rebuild your initrd/initramfs (so that your edited mdadm.conf
goes into it), then reboot.

I'll look up mdadm.conf and figure out how to add the lines that aren't
there.

Hope something somewhere in amongst this lot helps...

Cheers,

John.


