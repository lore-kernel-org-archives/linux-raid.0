From: Jim Faulkner <jfaulkne@ccs.neu.edu>
Subject: Re: PROBLEM: software RAID breakage under 2.6.1-mm4
Date: Sat, 17 Jan 2004 19:29:04 -0500 (EST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.GSO.4.58.0401171919250.10717@denali.ccs.neu.edu>
References: <Pine.GSO.4.58.0401171318560.10877@denali.ccs.neu.edu>
 <16393.46697.630398.566295@notabene.cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <16393.46697.630398.566295@notabene.cse.unsw.edu.au>
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: linux-raid@vger.kernel.org, akpm@osdl.org
List-Id: linux-raid.ids


On Sun, 18 Jan 2004, Neil Brown wrote:

> I don't see how your configuration can have ever worked.
> You appear to be using auto-detect to start your arrays.
> Auto-detect will only include partitions which are of type "Linux
> RAID" into an array.
> A linear array is *not* a partition (of any type), so autodetect will
> never try to incorporate it into an MD array.
>
> Are you *sure* this worked before?  Using auto-detect to start the
> arrays rather than "raidstart" or "mdadm" ??
>

Oops, sorry about that, you are right, on older kernels md2 is setup
using raidstart in the Gentoo boot scripts, not during the autodetection
phase.  As a matter of fact, the dmesg output for older kernels (included
below) is very similar to what I posted earlier.

However, there is still a behavioral change here.  On 2.6.1-mm2 and below,
I did not have to run "raidstop /dev/md2" before running "raidstart
/dev/md2".  On 2.6.1-mm4 I do.  I'm not sure if this change is intentional
or not, and of course its not a big deal for me to modify my boot scripts.

thanks,
Jim Faulkner

2.6.1-mm2 dmesg output during boot-time autodetection phase
------------------------------------------------------
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
md: md2 stopped.
md: unbind<hdc1>
md: export_rdev(hdc1)
md: ... autorun DONE.

2.6.1-mm2 dmesg output during Gentoo raid boot script (notice I do not
have to stop md2)
------------------------------------------------------
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

