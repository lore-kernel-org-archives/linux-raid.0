From: Ken Causey <ken@ineffable.com>
Subject: Initrd and persistent-superblock
Date: 21 Jun 2002 10:11:30 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1024672290.517.37.camel@temp>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I'm trying to setup a system with all filesystem, including boot and
root, on software raid.  I'm installing Debian testing and am using
http://www.1u-raid5.net/HowTo/raid_debian.txt as a guide.  I've setup
boot and swap as raid1 and root, home, and var as raid5.  My hope is to
be able to use stock debian kernels (currently 2.4.18-686) and simply
build my own initrd as necessary.  The hope is that I can let apt
happily upgrade my kernel as necessary and at worst use mkinitrd to
build a custom initrd image, in fact I shouldn't even have to worry
about this since if I get mkinitrd properly configured an appropriate
image should be built whenever a new kernel is installed.

At any rate, I'm running in to trouble.  My problem seems to be that
autostart is not working.  I have persistent-superblock set to 1, but
I've found that if I move raidtab out of /etc and reboot, then the raid
is not autostarted.  Shouldn't persistent-superblock take care of that? 
Or am I misunderstanding?

Here's some info, let me know if you need anything more:

temp:~# cat ~/raidtab 
#
# Boot /boot RAID1
#

raiddev /dev/md0
	raid-level		1
	nr-raid-disks		3
	nr-spare-disks		0
	persistent-superblock	1
	chunk-size		4
	
	device			/dev/sda1
	raid-disk		0
	device			/dev/sdb1
	raid-disk		1
	device			/dev/sdc1
	failed-disk		2

#
# Swap RAID1
#

raiddev /dev/md1
	raid-level		1
	nr-raid-disks		3
	nr-spare-disks		0
	persistent-superblock	1
	chunk-size		4

	device			/dev/sda2
	raid-disk		0
	device			/dev/sdb2
	raid-disk		1
	device			/dev/sdc2
	failed-disk		2

#
# Root / RAID5
#

raiddev /dev/md2
	raid-level		5
	nr-raid-disks		3
	nr-spare-disks		0
	persistent-superblock	1
	chunk-size		32

	device			/dev/sda3
	raid-disk		0
	device			/dev/sdb3
	raid-disk		1
	device			/dev/sdc3
	failed-disk		2

#
# Home /home RAID5
#

raiddev /dev/md3
	raid-level		5
	nr-raid-disks		3
	nr-spare-disks		0
	persistent-superblock	1
	chunk-size		32

	device			/dev/sda5
	raid-disk		0
	device			/dev/sdb5
	raid-disk		1
	device			/dev/sdc5
	failed-disk		2

#
# Var /var RAID5

raiddev /dev/md4
	raid-level		5
	nr-raid-disks		3
	nr-spare-disks		0
	persistent-superblock	1
	chunk-size		32

	device			/dev/sda6
	raid-disk		0
	device			/dev/sdb6
	raid-disk		1
	device			/dev/sdc6
	failed-disk		2

temp:~# fdisk -ul /dev/sda

Disk /dev/sda: 255 heads, 63 sectors, 2233 cylinders
Units = sectors of 1 * 512 bytes

   Device Boot    Start       End    Blocks   Id  System
/dev/sda1            63     32129     16033+  fd  Linux raid autodetect
/dev/sda2         32130   2024189    996030   82  Linux swap
/dev/sda3       2024190  10024559   4000185   fd  Linux raid autodetect
/dev/sda4      10024560  35873144  12924292+   5  Extended
/dev/sda5      10024623  26025299   8000338+  fd  Linux raid autodetect
/dev/sda6      26025363  35873144   4923891   fd  Linux raid autodetect
temp:~# fdisk -ul /dev/sdb

Disk /dev/sdb: 255 heads, 63 sectors, 2233 cylinders
Units = sectors of 1 * 512 bytes

   Device Boot    Start       End    Blocks   Id  System
/dev/sdb1            63     32129     16033+  fd  Linux raid autodetect
/dev/sdb2         32130   2024189    996030   82  Linux swap
/dev/sdb3       2024190  10024559   4000185   fd  Linux raid autodetect
/dev/sdb4      10024560  35873144  12924292+   5  Extended
/dev/sdb5      10024623  26025299   8000338+  fd  Linux raid autodetect
/dev/sdb6      26025363  35873144   4923891   fd  Linux raid autodetect

My initrd.img includes the raid modules and raid1 and raid5 do indeed
start during the initrd stage.

All help is appreciated,

Ken Causey



