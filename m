From: "Erik Boettcher" <tehfoo@gmail.com>
Subject: Raid 5 Recovery
Date: Sun, 28 Dec 2008 01:21:14 -0500
Message-ID: <125ed8800812272221y44e77849l886a80f32cbcfbec@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello everyone, I'm trying to recover a raid-5 array that suffered
from a powerloss (and possibly de-seating of a SATA card that 3 out of
the 5 drives were on).
As far as I can tell, the drives themselves are still okay.
At first this is what happened when I tried mounting it from a livecd:

md: Autodetecting RAID arrays.
Bad version number 0.88 on sda3
md: sda3 does not have a valid v0.90 superblock, not importing!
Bad version number 0.88 on sdb3
md: sdb3 does not have a valid v0.90 superblock, not importing!
Bad version number 0.88 on sdc3
md: sdc3 does not have a valid v0.90 superblock, not importing!
md: Scanned 5 and added 2 devices.
md: autorun ...
md: considering sde3 ...
md:  adding sde3 ...
md:  adding sdd3 ...
md: created md0
md: bind<sdd3>
md: bind<sde3>
md: running: <sde3><sdd3>
raid5: device sde3 operational as raid disk 2
raid5: device sdd3 operational as raid disk 1
raid5: not enough operational devices for md0 (3/5 failed)
RAID5 conf printout:
 --- rd:5 wd:2
 disk 1, o:1, dev:sdd3
 disk 2, o:1, dev:sde3
raid5: failed to run raid set md0
md: pers->run() failed ...
md: do_md_run() returned -5
md: md0 stopped.
md: unbind<sde3>
md: export_rdev(sde3)
md: unbind<sdd3>
md: export_rdev(sdd3)
md: ... autorun DONE.

At this point I sought help on ##linux on freenode, running this:
mack ~ # mdadm -D /dev/md0
mdadm: md device /dev/md0 does not appear to be active.
mack ~ # mdadm --assemble /dev/md0 --scan
mdadm: superblock on /dev/sdc3 doesn't match others - assembly aborted
mack ~ # mdadm -A --force /dev/md0
mdadm: superblock on /dev/sdc3 doesn't match others - assembly aborted
mack ~ # mdadm -A --force /dev/md0 /dev/sd{a,b,c,d,e}3
mdadm: superblock on /dev/sdd3 doesn't match others - assembly aborted

At this point I said WOAH -- time to stop with the freenode help --
I'm hoping I didn't cause too much more damage there...

I'm trying to get this array up and any help would be greatly
appreciated -- I don't want to do anything more to write to the drive
without expert advice.
Many thanks,
Erik Boettcher
