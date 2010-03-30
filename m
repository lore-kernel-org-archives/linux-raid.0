From: "Kwolek, Adam" <adam.kwolek@intel.com>
Subject: Problem with changing array_size
Date: Tue, 30 Mar 2010 14:53:40 +0100
Message-ID: <905EDD02F158D948B186911EB64DB3D11C584B56@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>
List-Id: linux-raid.ids

I found that setting new raid volume size using array_size entry in sysfs causes that inode references in vfs can be lost.

Conditions:
  SLES 11 (32bit) machine with
  	kernel: 2.6.33
  	mdadm : 3.1.2
  5 SATA hdds in system:
	SLES 11 on   /dev/sda 
	4 test disks /dev/hdb - /dev/hde

Reproduction:
1. Configure:
	# create native raid5 volume, with specified size (relatively small)
	mdadm -C /dev/md/raid5vol_0 -amd -l 5 --chunk 64 --size 104857 -n 3 /dev/sdb /dev/sdc /dev/sde -R

	# Create file system
	mkfs /dev/md/raid5vol_0

	# mount it and copy some files there
	mount /dev/md/raid5vol_0 /mnt/vol
	cp * /mnt/vol

2. Try to change volume size. This should affect volume, but not vfs
	echo "157285" >/sys/block/md127/md/array_size

3. Try ls command on mounted volume
	ls /mnt/vol

In the few tries (maybe at first shot) you would probably find that when you are trying to execute ls command on mounted volume message in user space appears:
	ls: cannot access 'copied file name': Input/output error

In kernel space messages can be found:
  In response to size change:
	Mar 30 16:27:03 linux kernel: md127: detected capacity change from 214695936 to 161059840
	Mar 30 16:27:03 linux kernel: VFS: busy inodes on changed media or resized disk md127

  In response to ls command:
	Mar 30 16:28:32 linux kernel: EXT2-fs (md127): error: ext2_lookup: deleted inode referenced: 12
	Mar 30 16:28:32 linux kernel: EXT2-fs (md127): error: ext2_lookup: deleted inode referenced: 13
	Mar 30 16:28:32 linux kernel: EXT2-fs (md127): error: ext2_lookup: deleted inode referenced: 14
	...

If the defined array is bigger (aprox. 10 times more than in example above) problem is harder to reproduce, but it is possible also.

If in the md.c in array_size_store() I've used older vfs notification method (i_size_write()) and problem almost disappears for me. For some time, I've thought that this workaround resolves problem, but from time to time array goes to the same situation, so it is clue only.

Best Regards
Adam

