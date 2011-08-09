From: Michal Soltys <soltys@ziu.info>
Subject: questions regarding few corner cases of mdadm usage
Date: Wed, 10 Aug 2011 00:12:04 +0200
Message-ID: <4E41B0B4.2050400@ziu.info>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi

I've been doing some tests, mostly for "what would happen if" scenarios
of incremental / foreign metadata assembly - as I avoid those if
possible, still a few things I noticed:

1)

With native metadata, 'mdadm -IRs' can be used to force-run partially
assembled arrays. With external metadata (tested with ddf) though, the
command has no effect. The subarray can be forced into degraded / active
mode through regular 'mdadm -R' - though it also requires manual start
of mdmon (otherwise further operations might end in D state, until the
one is started). For example:

mdadm -C /dev/md/ddf0 -e ddf -n4 /dev/sd[b-e]
mdadm -C /dev/md/test -l5 -n4 /dev/md/ddf0
mdadm -S /dev/md/test /dev/md/ddf0

mdadm -I /dev/sdb
mdadm -I /dev/sdc
mdadm -I /dev/sdd
mdadm -R /dev/md/test

At this point, if the remaining component is added, e.g.
mdadm -I /dev/sde

Then mdmon will have to be started, or any process trying to write will
hang (though mdmon can be started at any moment).

So in short:

- shouldn't -IRs also consider foreign metadata subarrays ?
- shouldn't mdmon be started automatically for run-forced subarrays ?

2) mixing 'mdadm -I' and 'mdadm -As'

If part of an array (possibly runnable) is assembled through 'mdadm -I',
and then 'mdadm -As' is called, it will cause creation of a duplicate
array from the remaining disks. This was true for both native and
external metadata formats. For example:

mdadm -C /dev/md/ddf0 -e ddf -n4 /dev/sd[b-e]
mdadm -C /dev/md/test -l1 -n4 /dev/md/ddf0
mdadm -S /dev/md/test /dev/md/ddf0

mdadm -I /dev/sdb
mdadm: container /dev/md/ddf0 now has 1 devices
mdadm: /dev/md/test assembled with 1 devices but not started

mdadm -I /dev/sdc
mdadm: container /dev/md/ddf0 now has 2 devices
mdadm: /dev/md/test assembled with 1 devices but not started

mdadm -As
mdadm: Container /dev/md/ddf1 has been assembled with 2 drives (out of 4)
mdadm: /dev/md/test_0 assembled with 2 devices but not started

At this point, there're 2 containers + 2 subarrays created, both of
which can be started with 'mdadm -R' to operate independently:

md124 : active raid1 sdd[1] sde[0]
      13312 blocks super external:/md125/0 [4/2] [__UU]

md125 : inactive sdd[1](S) sde[0](S)
      65536 blocks super external:ddf

md126 : active raid1 sdc[1] sdb[0]
      13312 blocks super external:/md127/0 [4/2] [UU__]

md127 : inactive sdc[1](S) sdb[0](S)
      65536 blocks super external:ddf


I realize that mixing normal and incremental assembly is at least asking
for problems, though I don't know if the above results fall into "bug"
or "don't do really weird things" scenario.
