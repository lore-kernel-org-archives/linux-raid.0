From: Ruth Ivimey-Cook <Ruth.Ivimey-Cook@ivimey.org>
Subject: Why does my drive get set readonly?
Date: Wed, 29 Jun 2005 14:37:30 +0100 (BST)
Message-ID: <Pine.LNX.4.61.0506291431530.7208@filestore.ivimey.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Hi,

I'm hoping someone can help suggest where I might look to sort a problem. even 
a pointer is useful!

I have three raid arrays, two raid1 and one raid5 called md2. Basically they 
run fine, but something is switching md2 readonly during the boot process; the 
only way I can get the machine to reboot is to remove md2 from fstab, boot 
single-user, do an "mdadm -w /dev/md2", then "init 5".

I'm running Fedora 3 in a very standard configuration.

Here's the dmesg output (with the new printk timestamp option enabled). Note 
the line just after the block of selinux calls.

What could be setting it readonly?

Ruth

[4294694.350000] md: running: <sdb1><sda1><hdg1><hdf1><hde1>
[4294694.350000] raid5: device sdb1 operational as raid disk 4
[4294694.350000] raid5: device sda1 operational as raid disk 3
[4294694.350000] raid5: device hdg1 operational as raid disk 2
[4294694.350000] raid5: device hdf1 operational as raid disk 1
[4294694.350000] raid5: device hde1 operational as raid disk 0
[4294694.351000] raid5: allocated 5248kB for md2
[4294694.351000] raid5: raid level 5 set md2 active with 5 out of 5 devices, 
algorithm 2
[4294694.351000] RAID5 conf printout:
[4294694.351000]  --- rd:5 wd:5 fd:0
[4294694.351000]  disk 0, o:1, dev:hde1
[4294694.351000]  disk 1, o:1, dev:hdf1
[4294694.351000]  disk 2, o:1, dev:hdg1
[4294694.351000]  disk 3, o:1, dev:sda1
[4294694.351000]  disk 4, o:1, dev:sdb1
[4294694.351000] md: considering hdb3 ...
[4294694.351000] md:  adding hdb3 ...
[4294694.351000] md: hdb1 has different UUID to hdb3
[4294694.351000] md:  adding hda3 ...
[4294694.351000] md: hda1 has different UUID to hdb3
[4294694.352000] md: created md1
[4294694.352000] md: bind<hda3>
[4294694.352000] md: bind<hdb3>
[4294694.352000] md: running: <hdb3><hda3>
[4294694.352000] raid1: raid set md1 active with 2 out of 2 mirrors
[4294694.352000] md: considering hdb1 ...
[4294694.352000] md:  adding hdb1 ...
[4294694.352000] md:  adding hda1 ...
[4294694.352000] md: created md0
[4294694.352000] md: bind<hda1>
[4294694.352000] md: bind<hdb1>
[4294694.352000] md: running: <hdb1><hda1>
[4294694.352000] raid1: raid set md0 active with 2 out of 2 mirrors
[4294694.352000] md: ... autorun DONE.
[4294694.352000] md: Autodetecting RAID arrays.
[4294694.352000] md: autorun ...
[4294694.352000] md: ... autorun DONE.
[4294694.352000] md: Autodetecting RAID arrays.
[4294694.352000] md: autorun ...
[4294694.352000] md: ... autorun DONE.
[4294694.405000] EXT3-fs: mounted filesystem with ordered data mode.
[4294694.405000] kjournald starting.  Commit interval 5 seconds
[4294695.126000] security:  3 users, 4 roles, 320 types, 23 bools
[4294695.126000] security:  53 classes, 10952 rules
[4294695.127000] SELinux:  Completing initialization.
[4294695.127000] SELinux:  Setting up existing superblocks.
[4294695.141000] SELinux: initialized (dev md1, type ext3), uses xattr
[4294695.320000] SELinux: initialized (dev tmpfs, type tmpfs), uses transition 
SIDs
[4294695.320000] SELinux: initialized (dev selinuxfs, type selinuxfs), uses 
genfs_contexts
[4294695.320000] SELinux: initialized (dev mqueue, type mqueue), not 
configured for labeling
[4294695.320000] SELinux: initialized (dev hugetlbfs, type hugetlbfs), not 
configured for labeling
[4294695.320000] SELinux: initialized (dev devpts, type devpts), uses 
transition SIDs
[4294695.320000] SELinux: initialized (dev eventpollfs, type eventpollfs), 
uses genfs_contexts
[4294695.320000] SELinux: initialized (dev tmpfs, type tmpfs), uses transition 
SIDs
[4294695.320000] SELinux: initialized (dev futexfs, type futexfs), uses 
genfs_contexts
[4294695.320000] SELinux: initialized (dev pipefs, type pipefs), uses task 
SIDs
[4294695.320000] SELinux: initialized (dev sockfs, type sockfs), uses task 
SIDs
[4294695.320000] SELinux: initialized (dev proc, type proc), uses 
genfs_contexts
[4294695.320000] SELinux: initialized (dev bdev, type bdev), uses 
genfs_contexts
[4294695.320000] SELinux: initialized (dev rootfs, type rootfs), uses 
genfs_contexts
[4294695.320000] SELinux: initialized (dev sysfs, type sysfs), uses 
genfs_contexts
[4294696.855000] SELinux: initialized (dev usbfs, type usbfs), uses 
genfs_contexts
[4294696.943000] md: md2 switched to read-only mode.
[4294699.578000] st: Version 20050312, fixed bufsize 32768, s/g segs 256
[4294699.680000] Attached scsi tape st0 at scsi0, channel 0, id 3, lun 0


-- 
Ruth Ivimey-Cook
Software engineer and technical writer.
