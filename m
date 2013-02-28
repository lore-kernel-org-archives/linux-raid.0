From: Hans-Peter Jansen <hpj@urpla.net>
Subject: Re: Persistent failures with simple md setup
Date: Thu, 28 Feb 2013 11:49:53 +0100
Message-ID: <2305721.Vu0zK2o09g@xrated>
References: <1565063.1kpR7lz4Ph@xrated> <4993918.JF2cWAHTeM@xrated> <20130228144013.61dcfe6b@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130228144013.61dcfe6b@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Am Donnerstag, 28. Februar 2013, 14:40:13 schrieb NeilBrown:
> On Wed, 27 Feb 2013 18:01:29 +0100 Hans-Peter Jansen <hpj@urpla.net> wrote:
> 
> > [I intentionally switched off line wrapping, since it renders the given information
> >  inedible]
> > 
> > Hi Neil,
> > 
> > sorry for the delay. Meanwhile, I updated to mdadm 3.2.6, and recreated the initrd.
> > Since I do the recreation on a regular base, no data salad appeared, but the initial
> > issue persists. I trigger checking the related md on each manual intervention.
> > 
> > Hence approaching this again. 
> > 
> > That's a typical boot sequence:
> 
> BTW, you aren't the only one to hit this issue .... I think I'm starting to
> get closer to the problem.

Nice to hear, will do my best to assist.

> 
> > 
> > Feb 27 08:35:48 zaphkiel kernel: [    0.000000] Kernel command line: PROFILE=ibk root=/dev/disk/by-uuid/782b24f2-26f6-4ea9-ab8b-d377cd2ac97b console=ttyS0,19200 console=tty0 resume=/dev/md127 splash=silent  console=ttyS0,115200n8 vga=791
> > Feb 27 08:35:48 zaphkiel kernel: [    6.816164] sd 0:0:0:0: [sda] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
> > Feb 27 08:35:48 zaphkiel kernel: [    6.862240] sd 1:0:0:0: [sdb] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
> > Feb 27 08:35:48 zaphkiel kernel: [    6.983157] sd 0:0:0:0: [sda] Write Protect is off
> > Feb 27 08:35:48 zaphkiel kernel: [    7.011914] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
> > Feb 27 08:35:48 zaphkiel kernel: [    7.011932] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> > Feb 27 08:35:48 zaphkiel kernel: [    7.159045] sd 1:0:0:0: [sdb] Write Protect is off
> > Feb 27 08:35:48 zaphkiel kernel: [    7.187766] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
> > Feb 27 08:35:48 zaphkiel kernel: [    7.187783] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> > Feb 27 08:35:48 zaphkiel kernel: [    7.319637]  sda: sda1 sda2 sda3 sda4
> > Feb 27 08:35:48 zaphkiel kernel: [    7.386469] sd 0:0:0:0: [sda] Attached SCSI disk
> > Feb 27 08:35:48 zaphkiel kernel: [    7.414335]  sdb: sdb1 sdb2 sdb3 sdb4
> > Feb 27 08:35:48 zaphkiel kernel: [    7.470597] sd 1:0:0:0: [sdb] Attached SCSI disk
> > Feb 27 08:35:48 zaphkiel kernel: [    9.676078] PM: Checking hibernation image partition /dev/md127
> > Feb 27 08:35:48 zaphkiel kernel: [    9.956010] sd 6:0:0:0: [sdc] Attached SCSI removable disk
> > Feb 27 08:35:48 zaphkiel kernel: [   10.175875] sd 6:0:0:1: [sdd] Attached SCSI removable disk
> > Feb 27 08:35:48 zaphkiel kernel: [   10.262999] sd 6:0:0:2: [sde] Attached SCSI removable disk
> > Feb 27 08:35:48 zaphkiel kernel: [   10.299000] sd 6:0:0:3: [sdf] Attached SCSI removable disk
> > Feb 27 08:35:48 zaphkiel kernel: [   10.618022] md: raid1 personality registered for level 1
> > Feb 27 08:35:48 zaphkiel kernel: [   11.139833] md: bind<sda3>
> > Feb 27 08:35:48 zaphkiel kernel: [   11.158438] md: bind<sdb3>
> > Feb 27 08:35:48 zaphkiel kernel: [   11.200897] md/raid1:md124: active with 2 out of 2 mirrors
> 
> Presumably this is md124 being assembled in the initrd as it contains the
> root filesystem.

Correct.

> 
> > Feb 27 08:35:48 zaphkiel kernel: [   11.233921] created bitmap (200 pages) for device md124
> > Feb 27 08:35:48 zaphkiel kernel: [   11.276742] md124: bitmap initialized from disk: read 13/13 pages, set 0 of 409595 bits
> > Feb 27 08:35:48 zaphkiel kernel: [   11.356796] md124: detected capacity change from 0 to 107372728320
> > Feb 27 08:35:48 zaphkiel kernel: [   11.395610]  md124: unknown partition table
> > Feb 27 08:35:48 zaphkiel kernel: [   11.543579] md: raid0 personality registered for level 0
> > Feb 27 08:35:48 zaphkiel kernel: [   11.583994] md: raid10 personality registered for level 10
> > Feb 27 08:35:48 zaphkiel kernel: [   12.188576] md: raid6 personality registered for level 6
> > Feb 27 08:35:48 zaphkiel kernel: [   12.220473] md: raid5 personality registered for level 5
> > Feb 27 08:35:48 zaphkiel kernel: [   12.252320] md: raid4 personality registered for level 4
> > Feb 27 08:35:48 zaphkiel kernel: [   12.318865] XFS (md124): Mounting Filesystem
> > Feb 27 08:35:48 zaphkiel kernel: [   12.535666] XFS (md124): Ending clean mount
> 
> And now XFS has mounted that, so presumably about there the boot sequence
> switches from initrd to real-root.  You have obviously removed some lines,
> presumably because you thought brevity would help.  For future reference: it
> doesn't.  I much prefer to see complete logs so I can correlate various parts
> of the sequence and be sure I understand what I'm seeing.  But I probably
> have enough here.

Sorry, I grepped for 'md|sd' and removed some lines triggered from pata_amd, 
which doesn't have any business in this scenario anyway (all sata). 

Will remove this dangling driver from initrd later.

We're leaving initrd here.

> > Feb 27 08:35:48 zaphkiel kernel: [   22.720866] sd 0:0:0:0: Attached scsi generic sg0 type 0
> > Feb 27 08:35:48 zaphkiel kernel: [   23.126126] sd 1:0:0:0: Attached scsi generic sg1 type 0
> > Feb 27 08:35:48 zaphkiel kernel: [   23.203876] sd 6:0:0:0: Attached scsi generic sg2 type 0
> > Feb 27 08:35:48 zaphkiel kernel: [   23.402184] sd 6:0:0:1: Attached scsi generic sg3 type 0
> > Feb 27 08:35:48 zaphkiel kernel: [   23.725330] sd 6:0:0:2: Attached scsi generic sg4 type 0
> > Feb 27 08:35:48 zaphkiel kernel: [   23.917899] sd 6:0:0:3: Attached scsi generic sg5 type 0
> > Feb 27 08:35:48 zaphkiel kernel: [   24.492587] md: bind<sda2>
> > Feb 27 08:35:48 zaphkiel kernel: [   24.711804] md: bind<sda1>
> > Feb 27 08:35:48 zaphkiel kernel: [   24.821071] md: bind<sda4>
> 
> These are parts of 3 different arrays that are starting to be assembled in
> parallel.  That must be udev running "mdadm -I /dev/sdaX" which will partly
> assemble each array.  when the 'sdb' bits come along "mdadm -I /dev/sdbX"
> should complete the assembly.

Yes, exactly.

> 
> > Feb 27 08:35:48 zaphkiel kernel: [   25.607192] md: bind<sdb2>
> > Feb 27 08:35:48 zaphkiel kernel: [   25.672335] md/raid1:md1: active with 2 out of 2 mirrors
> > Feb 27 08:35:48 zaphkiel kernel: [   25.723678] created bitmap (8 pages) for device md1
> > Feb 27 08:35:48 zaphkiel kernel: [   25.771764] md1: bitmap initialized from disk: read 1/1 pages, set 0 of 16379 bits
> 
> And there is the first one:  mdadm -I /dev/sdb2 must have been run by udev so
> md1 got fully assembled.
> 
> 
> > Feb 27 08:35:48 zaphkiel kernel: [   25.854963] md/raid1:md0: active with 1 out of 2 mirrors
> 
> But now md0 got assembled with waiting for sdb1.  This must have been the
>    mdadm -IRs
> in /etc/init.d/boot.md.  The purpose of this is to find any partially
> assembled arrays and complete the assembly.  This is needed if, for example,
> sdb has failed complete and would never be found.  However it shouldn't
> happen yet.  It should wait until all the devices that have been discovered
> have been processed.
> A little early in the boot.md file you will see:
>         if [ "$MDADM_DEVICE_TIMEOUT" -gt 0 ] ; then
>             /sbin/udevadm settle --timeout="$MDADM_DEVICE_TIMEOUT"
>         fi
> 
> so unless you have MDADM_DEVICE_TIMEOUT=0 in /etc/sysconfig/mdadm (which I
> very much doubt) it should have already waited.  But there is no sign that it
> did.  So maybe "udevadm settle" is broken?

MDADM_DEVICE_TIMEOUT="60"

As far as I can see, udevadm settle doesn't pick up all devices under some 
circumstances. The man page says, it waits up to --timeout seconds for the
event queue to become empty. Obviously, the event queue must be incomplete
then, given, that one md is assembled already in initrd (12 seconds ago),
and all other parts physically exist since then.

Probably, the events got eaten already in initrd already, given that timing.

> 
> > Feb 27 08:35:48 zaphkiel kernel: [   25.886903] md1: detected capacity change from 0 to 2146783232
> > Feb 27 08:35:48 zaphkiel kernel: [   25.929142] created bitmap (6 pages) for device md0
> > Feb 27 08:35:48 zaphkiel kernel: [   25.958684]  md1: unknown partition table
> > Feb 27 08:35:48 zaphkiel kernel: [   25.995737] md: bind<sdb4>
> > Feb 27 08:35:48 zaphkiel kernel: [   26.012500] md0: bitmap initialized from disk: read 1/1 pages, set 0 of 12047 bits
> > Feb 27 08:35:48 zaphkiel kernel: [   26.077270] md0: detected capacity change from 0 to 98689024
> > Feb 27 08:35:48 zaphkiel kernel: [   26.168097] md/raid1:md3: active with 2 out of 2 mirrors
> 
> And here comes sdb4, so "mdadm -I /dev/sdb4" must have been run by udev.  And
> it got in before the  "mdadm -IRs" managed to find that md0 was incomplete,
> and started it.
> 
> 
> > Feb 27 08:35:48 zaphkiel kernel: [   26.205258]  md0: unknown partition table
> > Feb 27 08:35:48 zaphkiel kernel: [   26.242295] created bitmap (415 pages) for device md3
> > Feb 27 08:35:48 zaphkiel kernel: [   26.304271] md3: bitmap initialized from disk: read 26/26 pages, set 1465 of 849320 bits
> > Feb 27 08:35:48 zaphkiel kernel: [   26.392578] md3: detected capacity change from 0 to 890575601664
> > Feb 27 08:35:48 zaphkiel kernel: [   26.575527]  md3: unknown partition table
> > Feb 27 08:35:48 zaphkiel kernel: [   26.763091] Adding 2096464k swap on /dev/md1.  Priority:0 extents:1 across:2096464k 
> > Feb 27 08:35:48 zaphkiel kernel: [   29.268318] XFS (md3): Mounting Filesystem
> > Feb 27 08:35:48 zaphkiel kernel: [   29.521844] EXT4-fs (md0): mounting ext2 file system using the ext4 subsystem
> > Feb 27 08:35:48 zaphkiel kernel: [   29.684176] EXT4-fs (md0): mounted filesystem without journal. Opts: acl,user_xattr
> > Feb 27 08:35:48 zaphkiel kernel: [   30.356255] XFS (md3): Ending clean mount
> > 
> > Today, /dev/sdb1 of /dev/md0 vanished. Re-adding and checking doesn't revealed 
> > any error, but it would be cool to get to the bottom of this, as re-adding some
> > lost partitions to the md every second day *is* a real PITA.
> > 
> > What could I do to help resolving this issue? 
> 
> It really feels like a udev bug, but it is hard to be sure.
> Could you edit /etc/init.d/boot.md and add
>    echo BEFORE mdadm -IRs > /dev/kmsg
> just before the call the "$mdadm_BIN -IRs",
>    echo AFTER mdadm -IRs > /dev/kmsg
> just after that call, and
>    echo AFTER mdadm -Asc > /dev/mksg
> just after the call to "$mdadm_BIN -A -s -c $mdadm_CONFIG"
> 
> And maybe put similar messages just before and after the  
>     /sbin/udevadm settle ....
> call.
> 
> If you can then reproduce the problem, the extra logging might tell us
> something useful.

I've enabled initrd (linuxrc=trace) and boot.md (#!/bin/sh -x) debugging, hence 
we should see the full story next time.

Thanks,
Pete
