From: "George Spelvin" <linux@horizon.com>
Subject: Re: want-replacement got stuck?
Date: 22 Nov 2012 01:45:58 -0500
Message-ID: <20121122064558.27465.qmail@science.horizon.com>
References: <20121122164751.3eba2706@notabene.brown>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20121122164751.3eba2706@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux@horizon.com, neilb@suse.de
Cc: joystick@shiftmail.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> Yes, that looks right.

Well, testing now (replacing sde)...

md5 : active raid10 sdc2[4](R) sdd2[3] sda2[0] sde2[2] sdb2[1]
      725591552 blocks 256K chunks 2 near-copies [4/4] [UUUU]
      [>....................]  recovery =  0.6% (2505344/362795776) finish=107.4min speed=55909K/sec
      bitmap: 5/173 pages [20KB], 2048KB chunk

One noteworthy thing is that the array didn't come up completely on boot...

Nov 22 06:14:54 science kernel: md:  adding sda2 ...
Nov 22 06:14:54 science kernel: md: sda1 has different UUID to sda2
Nov 22 06:14:54 science kernel: md:  adding sde2 ...
Nov 22 06:14:54 science kernel: md: sde1 has different UUID to sda2
Nov 22 06:14:54 science kernel: md: sdd3 has different UUID to sda2
Nov 22 06:14:54 science kernel: md:  adding sdd2 ...
Nov 22 06:14:54 science kernel: md: sdd1 has different UUID to sda2
Nov 22 06:14:54 science kernel: md: sdc3 has different UUID to sda2
Nov 22 06:14:54 science kernel: md:  adding sdb2 ...
Nov 22 06:14:54 science kernel: md: sdb1 has different UUID to sda2
Nov 22 06:14:54 science kernel: md:  adding sdc2 ...
Nov 22 06:14:54 science kernel: md: sdc1 has different UUID to sda2
Nov 22 06:14:54 science kernel: md: created md5
Nov 22 06:14:54 science kernel: md: bind<sdc2>
Nov 22 06:14:54 science kernel: md: bind<sdb2>
Nov 22 06:14:54 science kernel: md: export_rdev(sdd2)
Nov 22 06:14:54 science kernel: md: bind<sde2>
Nov 22 06:14:54 science kernel: md: bind<sda2>
Nov 22 06:14:54 science kernel: md: running: <sda2><sde2><sdb2><sdc2>
Nov 22 06:14:54 science kernel: md: kicking non-fresh sdc2 from array!
Nov 22 06:14:54 science kernel: md: unbind<sdc2>
Nov 22 06:14:54 science kernel: md: export_rdev(sdc2)
Nov 22 06:14:54 science kernel: md/raid10:md5: active with 3 out of 4 devices
Nov 22 06:14:54 science kernel: created bitmap (173 pages) for device md5
Nov 22 06:14:54 science kernel: md5: bitmap initialized from disk: read 11 pages, set 0 of 354293 bits
Nov 22 06:14:54 science kernel: md5: detected capacity change from 0 to 743005749248

It came up with neither sdd2 nor sdc2 in the array, even though the rebuild of sdd2 (from
--zero-superblock) had finished before.

Adding sdd2 was a re-add and went smoothly, though.


Oh, if you think you need my S-o-b to send that 3.6.x patch to stable@
(personally, I dont't; all the original work is yours and all I did was
mechanical), feel free to add it.
