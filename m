From: Maxim Frolov <wrungel@web.de>
Subject: RAID1 failure recovery
Date: Fri, 10 May 2002 13:33:46 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200205101133.g4ABXjX28795@mailgate5.cinetic.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



I have the following RAID1 configuration:

raiddev /dev/md0
   raid-level        1
   nr-raid-disks     2
   nr-spare-disks    0
   persistent-superblock 1
   chunk-size        4
   device   /dev/hda1
   raid-disk 0
   device   /dev/hdc1
   raid-disk 1

The only one partition on my system is "root"-Partition.
It's mounted on /dev/md0.

Linux-Kernel: 2.4.18
Linux-Distribution: S.U.S.E 8 Prof.



Everything works fine beside of error recovery of hda1:
After hda1 has failed I tried to install a new disk instead of hda1 in the following way:

1. plug in a new disk on the place of hda1.
2. raidhotadd /dev/md0 /dev/hda1
3. install LILO

After the data on /dev/hda1 was synced with the data on /dev/hdc1 the /proc/mdstat contained:

Personalities : [raid1] 
read_ahead 1024 sectors
md0 : active raid1 hda1[1] hdc1[0]
      614784 blocks [2/2] [UU]
      
unused devices: <none>


!!! After system reboot, RAID didn't found hda1 !!!

Here is the output of dmesg while rebooting:
//////////////// DMESG OUTPUT BEGIN ////////////////
md: md driver 0.90.0 MAX_MD_DEVS=256, MD_SB_DISKS=27
md: Autodetecting RAID arrays.
 [events: 00000015]
md: autorun ...
md: considering hdc1 ...
md:  adding hdc1 ...
md: created md0
md: bind<hdc1,1>
md: running: <hdc1>
md: hdc1's event counter: 00000015
md0: former device hda1 is unavailable, removing from array!
md: RAID level 1 does not need chunksize! Continuing anyway.
request_module[md-personality-3]: Root fs not mounted
md: personality 3 is not loaded!
md :do_md_run() returned -22
md: md0 stopped.
md: unbind<hdc1,0>
md: export_rdev(hdc1)
md: ... autorun DONE.

....

md: raid1 personality registered as nr 3
md: Autodetecting RAID arrays.
 [events: 00000015]
md: autorun ...
md: considering hdc1 ...
md:  adding hdc1 ...
md: created md0
md: bind<hdc1,1>
md: running: <hdc1>
md: hdc1's event counter: 00000015
md0: former device hda1 is unavailable, removing from array!
md: RAID level 1 does not need chunksize! Continuing anyway.
md0: max total readahead window set to 124k
md0: 1 data-disks, max readahead per data-disk: 124k
raid1: device hdc1 operational as mirror 0
raid1: md0, not all disks are operational -- trying to recover array
raid1: raid set md0 active with 1 out of 2 mirrors
md: updating md0 RAID superblock on device
md: hdc1 [events: 00000016]<6>(write) hdc1's sb offset: 614784
md: recovery thread got woken up ...
md0: no spare disk to reconstruct array! -- continuing in degraded mode
md: recovery thread finished ...
md: ... autorun DONE.
md: swapper(pid 1) used obsolete MD ioctl, upgrade your software to use new ictls.
reiserfs: checking transaction log (device 09:00) ...
Using r5 hash to sort names
ReiserFS version 3.6.25
VFS: Mounted root (reiserfs filesystem) readonly.
change_root: old root has d_count=2
Trying to unmount old root ... okay
Freeing unused kernel memory: 120k freed
md: Autodetecting RAID arrays.
md: autorun ...
md: ... autorun DONE.
//////////////// DMESG OUTPUT END ////////////////



/proc/mdstat contained after reboot:

Personalities : [raid1] 
read_ahead 1024 sectors
md0 : active raid1 hdc1[0]
      614784 blocks [2/1] [U_]
      
unused devices: <none>



My questions is: How do I recover the failed RAID1 disk (dev/hda1)?
What I did wrong?


------------
Max Frolov.
e-mail: wrungel@web.de
________________________________________________________________
Keine verlorenen Lotto-Quittungen, keine vergessenen Gewinne mehr! 
Beim WEB.DE Lottoservice: http://tippen2.web.de/?x=13


