From: pgn14@fastmail.co.uk
Subject: swapping a single drive with a RAID-1 array.  At array boot,
 "No Boot Device found".  What've I missed?
Date: Sat, 04 Aug 2012 11:26:17 -0700
Message-ID: <1344104777.11555.140661110687569.3DB8F4E5@webmail.messagingengine.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


I'm currently running my linux system off a single drive, /dev/sda

The drive's starting to act up a bit.  I intend to replace it with a new
2-drive RAID-1 array.

I'm trying to
	-- migrate everything from the current single-drive to the array
	-- modify the grub entries correctly
	-- switch to booting from the array

I get as far as the 'switch' to booting from the array instead of the
single drive.

Booting from the array, the system gets to

		"No Boot Device found.

and halts.  I supsect I've missed something simple/obvious.


Here's what I've done:

The single/current drive's partitioned as:

	/dev/sda1   1G   ext4   "/boot"
	/dev/sda2   *    lvm
		/dev/VG0/lvROOT   *   ext4   "/"

Its grub boot entry is:

	title Main
		root (hd0,0)
		kernel /vmlinuz root=/dev/VG0/LVROOT rootfstype=ext4
		rootflags=journal_checksum noresume
		initrd /initrd

To prepare the array, I

(1) Identically formatted the two new drives, /dev/sdb & /dev/sdc, for
RAID use, making sure the 'bootable' flag is set on the 1st partition:

	fdisk -u -c -l /dev/sd[bc]
		Disk /dev/sdb: 500.1 GB, 500107862016 bytes
		255 heads, 63 sectors/track, 60801 cylinders, total
		976773168 sectors
		Units = sectors of 1 * 512 = 512 bytes
		Sector size (logical/physical): 512 bytes / 512 bytes
		I/O size (minimum/optimal): 512 bytes / 512 bytes
		Disk identifier: 0x4170c717

		   Device Boot      Start         End      Blocks   Id 
		   System
		/dev/sdb1   *        2048     2099199     1048576   fd 
		Linux raid autodetect
		/dev/sdb2         2099200   976773167   487336984   fd 
		Linux raid autodetect

		Disk /dev/sdc: 500.1 GB, 500107862016 bytes
		255 heads, 63 sectors/track, 60801 cylinders, total
		976773168 sectors
		Units = sectors of 1 * 512 = 512 bytes
		Sector size (logical/physical): 512 bytes / 4096 bytes
		I/O size (minimum/optimal): 4096 bytes / 4096 bytes
		Disk identifier: 0x76a841ea

		   Device Boot      Start         End      Blocks   Id 
		   System
		/dev/sdc1   *        2048     2099199     1048576   fd 
		Linux raid autodetect
		/dev/sdc2         2099200   976773167   487336984   fd 
		Linux raid autodetect

(2) Created the RAID arrays

	mdadm --create /dev/md0 --name=md0 --homehost=cattail \
	  --level=raid1 --raid-devices=2 --metadata=0.90 \
	  --verbose --bitmap=internal \
	  /dev/sdb1 /dev/sdc1

	mdadm --create /dev/md1 --name=md1 --homehost=cattail \
	  --level=raid1 --raid-devices=2 --metadata=1.2 \
	  --verbose --bitmap=internal \
	  /dev/sdb2 /dev/sdc2

(3) Waited until they're synced

	cat /proc/mdstat
		...
		Personalities : [raid0] [raid1] [raid10] [raid6] [raid5]
		[raid4] [linear]
		md1 : active raid1 sdc2[1] sdb2[0]
		      487335824 blocks super 1.2 [2/2] [UU]
		      bitmap: 0/4 pages [0KB], 65536KB chunk

		md0 : active raid1 sdc1[1] sdb1[0]
		      1048512 blocks [2/2] [UU]
		      bitmap: 0/1 pages [0KB], 65536KB chunk

		unused devices: <none>

(4) Formatted the RAID partitions

	mkfs.ext4 -v -L BOOT /dev/md0

	pvcreate -ff --metadatacopies 2 /dev/md1
	vgcreate -v -s 32M VG1 /dev/md1
	lvcreate -L  100% -n LVROOT     /dev/VG1
	vgchange -ay
	mkfs.ext4 -v /dev/VG1/LVROOT

(5) mounted the RAID partitions

	mkdir -p /mnt/migrate/BOOT
	mkdir -p /mnt/migrate/LVROOT
	mount /dev/md0        /mnt/migrate_temp/BOOT
	mount /dev/VG1/LVROOT /mnt/migrate/LVROOT

(6) synced the current drive to the new array

	rsync -xavH -z --compress-level=1 /boot/*      /mnt/migrate/BOOT
	rsync -xavH -z --compress-level=1 /           
	/mnt/migrate/LVROOT

(7) got the UUID of the array '/boot' partition

	tune2fs -l /dev/md0 | grep UUID
		Filesystem UUID:         
		1d2d9f26-b3b4-4561-a2de-b6e3fe6bb065

(8) modified the /etc/fstab on the array so it boots from the array

	cat /mnt/migrate/LVROOT/etc/fstab
		UUID=1d2d9f26-b3b4-4561-a2de-b6e3fe6bb065   /boot   ext4
		  noatime,acl,user_xattr,barrier=1   1 2
		/dev/VG1/LVROOT   /       ext4  
		noatime,acl,user_xattr,journal_checksum,barrier=1   1 1
		proc      /proc              proc    defaults           
		      0 0
		sysfs     /sys               sysfs   noauto             
		      0 0
		debugfs   /sys/kernel/debug  debugfs noauto             
		      0 0
		devpts    /dev/pts           devpts  mode=0620,gid=5    
		      0 0
		none      /tmp               tmpfs  
		nosuid,nodev,size=1024m   1 2

(9) modified /boot/grub/menu.lst on BOTH the local drive and the array

	cat /boot/grub/menu.lst
	cat /mnt/migrate/BOOT/grub/menu.lst
		...
		title Main
			root (hd0,0)
			kernel /vmlinuz root=/dev/VG0/LVROOT
			rootfstype=ext4 rootflags=journal_checksum
			noresume
			initrd /initrd

		title Array1
			root (hd1,0)
			kernel /vmlinuz root=/dev/VG1/LVROOT
			rootfstype=ext4 rootflags=journal_checksum
			noresume
			initrd /initrd

		title Array2
			root (hd2,0)
			kernel /vmlinuz root=/dev/VG1/LVROOT
			rootfstype=ext4 rootflags=journal_checksum
			noresume
			initrd /initrd
		...

(10) Identified the drive aliases

	cd /dev/disk/by-id/
	ls -al \
	 ata-ST3500418AS_9RYC7TD8 \
	 ata-ST3500418AS_9ODK9DH6 \
	 ata-ST3500418AS_9VKF6MF4
		lrwxrwxrwx 1 root root 9 Aug  3 13:11
		ata-ST3500418AS_9RYC7TD8 -> ../../sda
		lrwxrwxrwx 1 root root 9 Aug  3 13:11
		ata-ST3500418AS_9ODK9DH6 -> ../../sdb
		lrwxrwxrwx 1 root root 9 Aug  3 13:11
		ata-ST3500418AS_9VKF6MF4 -> ../../sdc

(11) updated /boot/grub/device.map on the current/active drive

	cat /boot/grub/device.map
		(hd0)   /dev/disk/by-id/ata-ST3500418AS_9RYC7TD8
		(hd1)   /dev/disk/by-id/ata-ST3500418AS_9ODK9DH6
		(hd2)   /dev/disk/by-id/ata-ST3500418AS_9VKF6MF4

(12) setup a grub batch file

	cat /etc/grub.conf
		setup --stage2=/boot/grub/stage2 --force-lba (hd0)
		(hd0,0)
		setup --stage2=/boot/grub/stage2 --force-lba (hd1)
		(hd1,0)
		setup --stage2=/boot/grub/stage2 --force-lba (hd2)
		(hd2,0)
		quit

(13) wrote updated info to the boot record of all three drives

	grub --batch --device-map=/boot/grub/device.map < /etc/grub.conf


At this point, if I reboot from the "Main" grub record, everything still
works.

But, if I reboot from either "Array1" or "Array2", the system gets as
far as

		"No Boot Device found.

and just sits.

As I said -- I suspect I've missed or misconfigured something
simple/obvious.

Any suggestions as to what?
