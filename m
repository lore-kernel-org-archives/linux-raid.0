From: Jim Faulkner <jfaulkne@ccs.neu.edu>
Subject: PROBLEM: software RAID breakage under 2.6.1-mm4
Date: Sat, 17 Jan 2004 13:41:06 -0500 (EST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.GSO.4.58.0401171318560.10877@denali.ccs.neu.edu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
Cc: akpm@osdl.org
List-Id: linux-raid.ids


I have what is probably a weird RAID setup.  I have one plain RAID-0
array (/dev/md1), one plain linear array (/dev/md0), and another RAID-0
array (/dev/md2) consisting of a disk and the linear array.

It appears that what is happening is that linux tries to initialize
/dev/md2 before /dev/md0 is fully initialized.  Of course, since
/dev/md0 doesn't exist yet, linux says "too few disks (1 of 2) -
aborting!"

After a boot, I have to run "raidstop /dev/md2 ; raidstart /dev/md2" in
order to make md2 work properly.  I have never had to do this before under
any 2.6 kernel.  The last working kernel I used was 2.6.1-mm2.  BTW, I
compile everything into the kernel and don't use modules for RAID.

Below is my /etc/raidtab and the relevant parts of my dmesg output.
Please let me know if you need any more information.

thanks,
Jim Faulkner

my /etc/raidtab
-------------------------------------
raiddev /dev/md0
        raid-level linear
        nr-raid-disks 2
        chunk-size 128
        persistent-superblock 1
        device /dev/hdg1
        raid-disk 0
        device /dev/hdh1
        raid-disk 1

raiddev /dev/md1
        raid-level 0
        nr-raid-disks 2
        chunk-size 8
        persistent-superblock 1
        device /dev/hda1
        raid-disk 0
        device /dev/hde1
        raid-disk 1

raiddev /dev/md2
        raid-level 0
        nr-raid-disks 2
        chunk-size 4
        persistent-superblock 1
        device /dev/hdc1
        raid-disk 0
        device /dev/md0
        raid-disk 1
-------------------------------------

kernel output during boot-time raid detection
---------------------------------------------
md: Autodetecting RAID arrays.
md: autorun ...
md: considering hdh1 ...
md:  adding hdh1 ...
md:  adding hdg1 ...
md: hde1 has different UUID to hdh1
md: hdc1 has different UUID to hdh1
md: hda1 has different UUID to hdh1
md: created md0
md: bind<hdg1>
md: bind<hdh1>
md: running: <hdh1><hdg1>
md: considering hde1 ...
md:  adding hde1 ...
md: hdc1 has different UUID to hde1
md:  adding hda1 ...
md: created md1
md: bind<hda1>
md: bind<hde1>
md: running: <hde1><hda1>
md1: setting max_sectors to 16, segment boundary to 4095
raid0: looking at hde1
raid0:   comparing hde1(117218176) with hde1(117218176)
raid0:   END
raid0:   ==> UNIQUE
raid0: 1 zones
raid0: looking at hda1
raid0:   comparing hda1(117218176) with hde1(117218176)
raid0:   EQUAL
raid0: FINAL 1 zones
raid0: done.
raid0 : md_size is 234436352 blocks.
raid0 : conf->hash_spacing is 234436352 blocks.
raid0 : nb_zone is 1.
raid0 : Allocating 4 bytes for hash.
md: considering hdc1 ...
md:  adding hdc1 ...
md: created md2
md: bind<hdc1>
md: running: <hdc1>
md2: setting max_sectors to 8, segment boundary to 2047
blk_queue_segment_boundary: set to minimum fff
raid0: looking at hdc1
raid0:   comparing hdc1(60026752) with hdc1(60026752)
raid0:   END
raid0:   ==> UNIQUE
raid0: 1 zones
raid0: FINAL 1 zones
raid0: too few disks (1 of 2) - aborting!
md: pers->run() failed ...
md :do_md_run() returned -22
md: ... autorun DONE.
---------------------------------------------------

kernel output from when I run "raidstop /dev/md2 ; raidstart /dev/md2"
after boot-up
------------------------------------------------------
md: md2 stopped.
md: unbind<hdc1>
md: export_rdev(hdc1)
md: autorun ...
md: considering md0 ...
md:  adding md0 ...
md:  adding hdc1 ...
md: created md2
md: bind<hdc1>
md: bind<md0>
md: running: <md0><hdc1>
md2: setting max_sectors to 8, segment boundary to 2047
blk_queue_segment_boundary: set to minimum fff
raid0: looking at md0
raid0:   comparing md0(63512640) with md0(63512640)
raid0:   END
raid0:   ==> UNIQUE
raid0: 1 zones
raid0: looking at hdc1
raid0:   comparing hdc1(60026752) with md0(63512640)
raid0:   NOT EQUAL
raid0:   comparing hdc1(60026752) with hdc1(60026752)
raid0:   END
raid0:   ==> UNIQUE
raid0: 2 zones
raid0: FINAL 2 zones
raid0: zone 1
raid0: checking hdc1 ... nope.
raid0: checking md0 ... contained as device 0
  (63512640) is smallest!.
raid0: zone->nb_dev: 1, size: 3485888
raid0: current zone offset: 63512640
raid0: done.
raid0 : md_size is 123539392 blocks.
raid0 : conf->hash_spacing is 120053504 blocks.
raid0 : nb_zone is 2.
raid0 : Allocating 8 bytes for hash.
md: ... autorun DONE.
----------------------------------------------------

