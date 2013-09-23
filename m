From: Karl Kiniger <karl.kiniger@med.ge.com>
Subject: reboot during raid1 resync considered harmful?
Date: Mon, 23 Sep 2013 20:54:46 +0200
Message-ID: <20130923185446.GA3626@kipc2.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

..it seems, at least for me.

[ disclaimer: this is written from memory and also consulting the
  systemd kernel log which is still available ]

During migration from a non-RAID Fedora 19  to RAID1 I observed this:

Steps performed:

* boot with original disk (/dev/sda1) and one additional empty disk
  (/dev/sdb) connected  (2 TB Western Digital RED - SATA disks)

* set up partition table on /dev/sdb

* create two raid 1 devices (1GB for boot, the rest for LVM physical
  Volume) in degraded mode using the "missing" keyword

* add an internal bitmap for the almost 2TB big raid

* create LVM physical volume, vg, lv's etc. all fine

* reboot using /bin/bash as shell and dd the boot and root filesystem
  for speed reason, resize2fs those as well

* reboot into KDE,  copy /home and an additionsal LV called "u"
  adjust grub2, initrd etc

* remove original disk and reboot using the new RAID1

* hot plug second disk, partition, add to the RAID

* resync begins. tuning some speed params I get about 100MB/sec
  resync speed, so it will take about 5 hours....

* after about 2 hours (progress in /proc/mdstat seems right) I was
  told (dont ask by whom :-) to put the computer to some
  other place so I shut down the machine.
  (I was unable to pause the initial sync, so I set both min and max
  resync speed values to zero and observed the desired effect in
  /proc/mdstat)

------

* power on and goto KDE

* curious what /proc/mdstat will tell, interestingly it told me
  that the array was in sync [UU] which clearly was wrong.

* even more curious I mounted the "u" LV which was located
  behind the already synced range and /bin/ls /u showed
  garbage, accompanied by system log entries like this:

  EXT4-fs error (device dm-8): ext4_iget:4025: inode #8257537: comm ls:
             bad extra_isize (56361 != 256)

* argh.. it reads from the new incomplete synced disk.
  immediately unmount /u

* fail /dev/sdb, remove and re-add it. /u seems OK again...

* wait 5 hours, raid is now fully synced. All seems OK.
  Data on /u is a bup archive, git fsck does not show
  problems.

Conclusion: this should not have happened...

Perhaps the Fedora 19 initrd code is to blame, no idea so far.

I just want to understand how this could happen. There was
a lot of chance to silently corrupt data and I am still glad
I noticed the unexpected [UU] in /proc/mdstat

opinions/explanations very much appreciated,

Karl


--------------------------------------------

the interesting  part of the log during initial ram disk part of
F19 boot process: (see the marked lines - <===========)

Sep 21 20:48:38 rl2.localdomain systemd[1]: Starting Load Kernel Modules...
Sep 21 20:48:38 rl2.localdomain systemd[1]: Starting Swap.
Sep 21 20:48:38 rl2.localdomain systemd[1]: Reached target Swap.
Sep 21 20:48:38 rl2.localdomain systemd[1]: Starting Local File Systems.
Sep 21 20:48:38 rl2.localdomain systemd[1]: Reached target Local File Systems.
Sep 21 20:48:38 rl2.localdomain kernel: Switched to clocksource tsc
Sep 21 20:48:38 rl2.localdomain systemd-udevd[160]: starting version 204
Sep 21 20:48:38 rl2.localdomain kernel: md: bind<sdb1>
Sep 21 20:48:38 rl2.localdomain kernel: md: bind<sdb2>
Sep 21 20:48:38 rl2.localdomain kernel: md: bind<sda1>
Sep 21 20:48:38 rl2.localdomain kernel: md: raid1 personality registered for level 1
Sep 21 20:48:38 rl2.localdomain kernel: md/raid1:md127: active with 2 out of 2 mirrors <==== the 1GB /boot raid
Sep 21 20:48:38 rl2.localdomain kernel: md127: detected capacity change from 0 to 1073676288
Sep 21 20:48:38 rl2.localdomain kernel: md: bind<sda2>
Sep 21 20:48:38 rl2.localdomain kernel: md/raid1:md126: active with 1 out of 2 mirrors <======= correct so far
Sep 21 20:48:38 rl2.localdomain kernel: created bitmap (15 pages) for device md126
Sep 21 20:48:38 rl2.localdomain kernel: md126: bitmap initialized from disk: read 1 pages, set 2 of 29791 bits
Sep 21 20:48:38 rl2.localdomain kernel:  md127: unknown partition table
Sep 21 20:48:38 rl2.localdomain kernel: md126: detected capacity change from 0 to 1999189770240
Sep 21 20:48:38 rl2.localdomain kernel: RAID1 conf printout:
Sep 21 20:48:38 rl2.localdomain kernel:  --- wd:1 rd:2
Sep 21 20:48:38 rl2.localdomain kernel:  disk 0, wo:0, o:1, dev:sda2
Sep 21 20:48:38 rl2.localdomain kernel:  disk 1, wo:1, o:1, dev:sdb2
Sep 21 20:48:38 rl2.localdomain kernel: RAID1 conf printout:
Sep 21 20:48:38 rl2.localdomain kernel:  --- wd:1 rd:2
Sep 21 20:48:38 rl2.localdomain kernel:  disk 0, wo:0, o:1, dev:sda2
Sep 21 20:48:38 rl2.localdomain kernel:  disk 1, wo:1, o:1, dev:sdb2 <==== seems still ok, /dev/sdb=write-only
Sep 21 20:48:38 rl2.localdomain kernel: RAID1 conf printout:
Sep 21 20:48:38 rl2.localdomain kernel:  --- wd:2 rd:2
Sep 21 20:48:38 rl2.localdomain kernel:  disk 0, wo:0, o:1, dev:sda2
Sep 21 20:48:38 rl2.localdomain kernel:  disk 1, wo:0, o:1, dev:sdb2 <====== seems wrong to me
Sep 21 20:48:38 rl2.localdomain kernel:  md126: unknown partition table
Sep 21 20:48:39 rl2.localdomain kernel: bio: create slab <bio-1> at 1
Sep 21 20:48:39 rl2.localdomain kernel: EXT4-fs (dm-0): mounted filesystem with ordered data mode. Opts: (null)
Sep 21 20:48:42 rl2.localdomain systemd-journald[67]: Received SIGTERM
Sep 21 20:48:42 rl2.localdomain kernel: SELinux: 2048 avtab hash slots, 95511 rules.
Sep 21 20:48:42 rl2.localdomain kernel: SELinux: 2048 avtab hash slots, 95511 rules.
Sep 21 20:48:42 rl2.localdomain kernel: SELinux:  8 users, 82 roles, 4543 types, 259 bools, 1 sens, 1024 cats
Sep 21 20:48:42 rl2.localdomain kernel: SELinux:  83 classes, 95511 rules
Sep 21 20:48:42 rl2.localdomain kernel: SELinux:  Completing initialization.
Sep 21 20:48:42 rl2.localdomain kernel: SELinux:  Setting up existing superblocks.

