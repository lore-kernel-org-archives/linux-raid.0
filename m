From: "Tom 'spot' Callaway" <tcallawa@redhat.com>
Subject: sparc64 raid issues
Date: 18 Nov 2002 16:56:49 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1037656609.9166.60.camel@zorak.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I'm having an odd problem with RAID 0 on Linux/sparc64. My kernel is
2.4.20-rc1.

I created a RAID 0 partition with two identical partitions, /dev/hda2
and /dev/hdb2, then set it as /, formatted ext3 (this was all done in
the Aurora SPARC Linux installer (RHL 7.3 equivalent) with parted). All
seems to go properly.

Upon rebooting, the machine refuses to boot.

Here are the md config settings for the default Aurora kernel:

CONFIG_MD=y
CONFIG_BLK_DEV_MD=m
CONFIG_MD_LINEAR=m
CONFIG_MD_RAID0=m
CONFIG_MD_RAID1=m
CONFIG_MD_RAID5=m
CONFIG_MD_MULTIPATH=m

 Here is the relevant section of dmesg:

Red Hat nash version 3.3.10 starting
Loading md module
md: md driver 0.90.0 MAX_MD_DEVS=256, MD_SB_DISKS=27
Loading raid0 module
md: raid0 personality registered as nr 2
Loading lbd module
Journalled Block Device driver loaded
Loading ext3 module
Mounting /proc filesystem
Creating root device
raidautorun: RAID_AUTORUN failed: 19
Mounting root filesystem
EXT3-fs: unable to read superblock
mount: error 22 mounting ext3
pivotroot: pivot_root(/sysroot, /sysroot/initrd) failed: 2

At this point, I booted the CD into rescue mode to try to figure out
what happened, and that kernel gave me a slightly more interesting
dmesg. 

The Aurora rescue kernel has the following MD config settings:

CONFIG_MD=y
CONFIG_BLK_DEV_MD=y
CONFIG_MD_LINEAR=m
CONFIG_MD_RAID0=m
CONFIG_MD_RAID1=m
CONFIG_MD_RAID5=m
CONFIG_MD_MULTIPATH=m

Here is the md section from its dmesg:

md: autorun...
md: considering hdb2...
md:   adding hdb2 ...
md:   adding hda2 ...
md: created md0
md: bind<hda2,1>
md: bind<hdb2,2>
md: running: <hdb2><hda2>
md: hdb2's event counter: 00000004
md: hda2's event counter: 00000004
md: personality 2 is not loaded!
md :do_md_run() returned -22
md: md0 stopped
md: unbind<hdb2,1>
md: export_rdev(hdb2)
md: unbind<hda2,0>
md: export_rdev(hda2)

I double checked to make sure that raid0.o is in both initrds, and it
is.

Now, I figure either one of two things is happening:

1. I'm building something wrong in my Aurora kernels, e.g. the md
modules need to be compiled in to work.
2. There's a bug in the RAID drivers on sparc64.

But I'm no RAID expert. Any assistance is appreciated.

~spot
---
Tom "spot" Callaway <tcallawa(a)redhat*com> Red Hat Sales Engineer
Sair Linux and GNU Certified Administrator (LCA)
Red Hat Certified Engineer (RHCE)
GPG: D786 8B22 D9DB 1F8B 4AB7  448E 3C5E 99AD 9305 4260

The words and opinions reflected in this message do not necessarily
reflect those of my employer, Red Hat, and belong solely to me.

"Immature poets borrow, mature poets steal." --- T. S. Eliot

