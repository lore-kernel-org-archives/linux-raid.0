From: Nick DeClario <nick@guardiandigital.com>
Subject: RAID auto start issue
Date: Fri, 12 Sep 2003 17:27:17 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3F623A35.1020808@guardiandigital.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

It appears I am having a problem with RAID auto starting.  I have a RAID 
1 array consisting of two disks that mounts on '/home' (/dev/md0).  It 
was working fine for some time then after some package upgrades '/home' 
stopped mounting at boot time and I would get fsck problems when it 
tried to scan the drive and drop me to a prompt.

I noticed that at that point the RAID array was not being started and 
issuing 'raidstart /dev/md0' would bring it up fine.  I came up with a 
temporary solution by adding 'raidstart /dev/md0' to my 'checkfs' init 
script.  However this is very temporary and I need to come up with a 
permament solution.

'md' is compiled into the kernel with raid1 as a module.  I have it 
loading xor.o and raid.o from the initrd script.  After the raid1.o 
module loads up I can see from the dmesg output that it auto detects the 
array just fine.  I will attach that portion to this e-mail.  Does 
anyone have any suggestions?

Thanks,
	-Nick


VFS: Mounted root (ext3 filesystem) readonly.
Trying to free ramdisk memory ... okay
Linux Intrusion Detection System 1.1.2rc4 *not* started
Freeing unused kernel memory: 112k freed
Adding Swap: 514068k swap-space (priority 0)
EXT3 FS 2.4-0.9.19, 19 August 2002 on ide0(3,6), internal journal
  [events: 00000030]
  [events: 00000030]
md: autorun ...
md: considering hdb1 ...
md:  adding hdb1 ...
md:  adding hda5 ...
md: created md0
md: bind<hda5,1>
md: bind<hdb1,2>
md: running: <hdb1><hda5>
md: hdb1's event counter: 00000030
md: hda5's event counter: 00000030
md: RAID level 1 does not need chunksize! Continuing anyway.
md0: max total readahead window set to 124k
md0: 1 data-disks, max readahead per data-disk: 124k
raid1: device hdb1 operational as mirror 1
raid1: device hda5 operational as mirror 0
raid1: raid set md0 active with 2 out of 2 mirrors
md: updating md0 RAID superblock on device
md: hdb1 [events: 00000031]<6>(write) hdb1's sb offset: 20354240
md: hda5 [events: 00000031]<6>(write) hda5's sb offset: 20354240
md: ... autorun DONE.

