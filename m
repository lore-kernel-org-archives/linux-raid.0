From: Ian Dall <ian@beware.dropbear.id.au>
Subject: raid=noautodetect is apparently ignored?
Date: Tue, 26 Jun 2007 15:22:25 +0930
Message-ID: <1182837145.3627.27.camel@sibyl.beware.dropbear.id.au>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

When I try and disable auto detection, with kernel boot parameters, it
goes ahead and auto assembles and runs anyway. The md= parameters seem
to be noticed, but don't seem to have any other effect (beyond resulting
in a dmesg).

Here is the result

        $ dmesg | egrep 'raid|md:'
        Kernel command line: ro root=/dev/sda8 raid=noautodetect md=1,/dev/sdb2,/dev/sdc2,/dev/sdd2 md=2,/dev/sdb3,/dev/sdc3,/dev/sdd3 md=3,/dev/md1,/dev/hda2 md=4,/dev/md2,/dev/hda3 single
        md: Will configure md1 (super-block) from /dev/sdb2,/dev/sdc2,/dev/sdd2, below.
        md: Will configure md2 (super-block) from /dev/sdb3,/dev/sdc3,/dev/sdd3, below.
        md: Will configure md3 (super-block) from /dev/md1,/dev/hda2, below.
        md: Will configure md4 (super-block) from /dev/md2,/dev/hda3, below.
        md: Autodetecting RAID arrays.
        md: autorun ...
        md: considering sdd4 ...
        md:  adding sdd4 ...
        md: sdd2 has different UUID to sdd4
        md: sdd1 has different UUID to sdd4
        md:  adding sdc4 ...
        md: sdc2 has different UUID to sdd4
        md: sdc1 has different UUID to sdd4
        md:  adding sdb4 ...
        md: sdb2 has different UUID to sdd4
        md: sdb1 has different UUID to sdd4
        md: hda3 has different UUID to sdd4
        md: hda2 has different UUID to sdd4
        md: created md2
        md: bind<sdb4>
        md: bind<sdc4>
        md: bind<sdd4>
        md: running: <sdd4><sdc4><sdb4>
        md: raid0 personality registered for level 0
        raid0: looking at sdd4
        raid0:   comparing sdd4(8409856) with sdd4(8409856)
        raid0:   END
        raid0:   ==> UNIQUE
        raid0: 1 zones
        raid0: looking at sdc4
        raid0:   comparing sdc4(8409856) with sdd4(8409856)
        raid0:   EQUAL
        raid0: looking at sdb4
        raid0:   comparing sdb4(8409856) with sdd4(8409856)
        raid0:   EQUAL
        raid0: FINAL 1 zones
        raid0: done.
        raid0 : md_size is 25229568 blocks.
        raid0 : conf->hash_spacing is 25229568 blocks.
        raid0 : nb_zone is 1.
        raid0 : Allocating 4 bytes for hash.
        md: considering sdd2 ...
        md:  adding sdd2 ...
        md: sdd1 has different UUID to sdd2
        md:  adding sdc2 ...
        md: sdc1 has different UUID to sdd2
        md:  adding sdb2 ...
        md: sdb1 has different UUID to sdd2
        md: hda3 has different UUID to sdd2
        md: hda2 has different UUID to sdd2
        md: created md1
        md: bind<sdb2>
        md: bind<sdc2>
        md: bind<sdd2>
        md: running: <sdd2><sdc2><sdb2>
        raid0: looking at sdd2
        raid0:   comparing sdd2(8409856) with sdd2(8409856)
        raid0:   END
        raid0:   ==> UNIQUE
        raid0: 1 zones
        raid0: looking at sdc2
        raid0:   comparing sdc2(8409856) with sdd2(8409856)
        raid0:   EQUAL
        raid0: looking at sdb2
        raid0:   comparing sdb2(8409856) with sdd2(8409856)
        raid0:   EQUAL
        raid0: FINAL 1 zones
        raid0: done.
        raid0 : md_size is 25229568 blocks.
        raid0 : conf->hash_spacing is 25229568 blocks.
        raid0 : nb_zone is 1.
        raid0 : Allocating 4 bytes for hash.
        md: considering sdd1 ...
        md:  adding sdd1 ...
        md:  adding sdc1 ...
        md:  adding sdb1 ...
        md: hda3 has different UUID to sdd1
        md: hda2 has different UUID to sdd1
        md: created md0
        md: bind<sdb1>
        md: bind<sdc1>
        md: bind<sdd1>
        md: running: <sdd1><sdc1><sdb1>
        md: raid1 personality registered for level 1
        raid1: raid set md0 active with 3 out of 3 mirrors
        md: considering hda3 ...
        md:  adding hda3 ...
        md: hda2 has different UUID to hda3
        md: created md4
        md: bind<hda3>
        md: running: <hda3>
        raid1: raid set md4 active with 1 out of 2 mirrors
        md: considering hda2 ...
        md:  adding hda2 ...
        md: created md3
        md: bind<hda2>
        md: running: <hda2>
        raid1: raid set md3 active with 1 out of 2 mirrors
        md: ... autorun DONE.

By way of context, this is kernel 2.6.20. I have set two striped (raid0)
arrays, md1 and md2. Each of these is mirrored by with a single
partition (hda2 and hda3) to form two raid 1 devices md3 and md4. This
works perfectly if I start and stop the md3 and md4 arrays from mdadm.
However the boot time autodetection always assembles degraded arrays
(see the 1 out of 2 messages above). I presume this is because it only
considers real physical partitions of type "Linux raid autodetect" and
is not considering md1 and md2 as candidate devices to form further
arrays. 

This is why I am trying to disable the autodetection, to see if directly
specifying the raid configuration would help.

This is driving me nuts. Maybe changing the type of the hda partitions
would help?

Any clues appreciated.

Ian

-- 
Ian Dall <ian@beware.dropbear.id.au>
