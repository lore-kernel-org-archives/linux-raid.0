From: Jeroen Baten <jbaten@i2rs.nl>
Subject: Re: question regarding a raid-1 set
Date: Tue, 26 Aug 2003 18:00:28 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200308261800.28078.jbaten@i2rs.nl>
References: <200308261637.08588.jbaten@i2rs.nl> <yq13cfov4g7.fsf@wilson.mkp.net> <3F4B8076.5CF468D5@SteelEye.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <3F4B8076.5CF468D5@SteelEye.com>
Content-Disposition: inline
To: Paul Clements <Paul.Clements@SteelEye.com>, "Martin K. Petersen" <mkp@mkp.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Op dinsdag 26 augustus 2003 17:44, schreef Paul Clements:
> "Martin K. Petersen" wrote:
> > >>>>> "Jeroen" == Jeroen Baten <jbaten@i2rs.nl> writes:
> >
> > Jeroen> md2 : active raid1 sdb6[1] sda6[0] 31848704 blocks [2/1] [U_]
> >                            ^^^^^^^                                ^
> >
> > Jeroen> when he types 'raidhotadd /dev/md2 /dev/sdb6' it generates:
> > Jeroen> "dev/md2: can not hot-add disk: disk busy"
> >
> > sdb6 *is* busy.  It's sda6 that's out of sync.
>
> Nope. Actually sdb6 is disk 1, sda6 is disk 0, which means that sdb6 is
> the one that is non-operational, as Jeroen originally said.
>
>
> Jeroen, in order to be able to hot-add, you must first raidsetfaulty,
> then hot-remove the disk, then hot-add it. But, you should probably
> first check your system log to see why the array is not syncing. The
> hot-add may not help, depending on what the problem is.
>
> --
> Paul

Well.... If you really like to know (I would really apreciate it!) this is the 
bootlog (bare in mind there are 3 raid-1 arrays):


<6>md: autorun ...
<6>md: considering sdb6 ...
<6>md:  adding sdb6 ...
<6>md:  adding sda6 ...
<6>md: created md2
<6>md: bind<sda6,1>
<6>md: bind<sdb6,2>
<6>md: running: <sdb6><sda6>
<6>md: sdb6's event counter: 00000028
<6>md: sda6's event counter: 00000028
<6>md: RAID level 1 does not need chunksize! Continuing anyway.
<6>md2: max total readahead window set to 508k
<6>md2: 1 data-disks, max readahead per data-disk: 508k
<3>raid1: disabled mirror sdb6 (not in sync)
<6>raid1: device sda6 operational as mirror 0
<1>raid1: md2, not all disks are operational -- trying to recover array
<6>raid1: raid set md2 active with 1 out of 2 mirrors
<6>md: recovery thread got woken up ...
<3>md2: no spare disk to reconstruct array! -- continuing in degraded mode
<6>md: recovery thread finished ...
<6>md: updating md2 RAID superblock on device
<6>md: sdb6 [events: 00000029]
<6>(write) sdb6's sb offset: 31848704
<6>md: sda6 [events: 00000029]
<6>(write) sda6's sb offset: 31848704
<6> [events: 00000000]
<3>md: invalid raid superblock magic on md2
<4>md: md2 has invalid sb, not importing!
<4>md: no nested md device found
<6>md: considering sdb5 ...
<6>md:  adding sdb5 ...
<6>md:  adding sda5 ...
<6>md: created md1
<6>md: bind<sda5,1>
<6>md: bind<sdb5,2>
<6>md: running: <sdb5><sda5>
<6>md: sdb5's event counter: 0000001e
<6>md: sda5's event counter: 0000001e
<3>md: md1: raid array is not clean -- starting background reconstruction
<6>md: RAID level 1 does not need chunksize! Continuing anyway.
<6>md1: max total readahead window set to 508k
<6>md1: 1 data-disks, max readahead per data-disk: 508k
<3>raid1: disabled mirror sdb5 (not in sync)
<6>raid1: device sda5 operational as mirror 0
<1>raid1: md1, not all disks are operational -- trying to recover array
<6>raid1: raid set md1 active with 1 out of 2 mirrors
<6>md: recovery thread got woken up ...
<3>md1: no spare disk to reconstruct array! -- continuing in degraded mode
<3>md2: no spare disk to reconstruct array! -- continuing in degraded mode
<6>md: recovery thread finished ...
<6>md: updating md1 RAID superblock on device
<6>md: sdb5 [events: 0000001f]
<6>(write) sdb5's sb offset: 3148608
<6>md: sda5 [events: 0000001f]
<6>(write) sda5's sb offset: 3148608
<6> [events: 00000000]
<3>md: invalid raid superblock magic on md1
<4>md: md1 has invalid sb, not importing!
<4>md: no nested md device found
<6>md: considering sdb1 ...
<6>md:  adding sdb1 ...
<6>md:  adding sda2 ...
<6>md: created md0
<6>md: bind<sda2,1>
<6>md: bind<sdb1,2>
<6>md: running: <sdb1><sda2>
<6>md: sdb1's event counter: 00000029
<6>md: sda2's event counter: 00000029
<3>kmod: failed to exec /sbin/modprobe -s -k md-personality-2, errno = 2
<3>md: personality 2 is not loaded!
<4>md :do_md_run() returned -22
<6>md: md0 stopped.
<6>md: unbind<sdb1,1>
<6>md: export_rdev(sdb1)
<6>md: unbind<sda2,0>
<6>md: export_rdev(sda2)
<6>md: ... autorun DONE.
<4>md: swapper(pid 1) used obsolete MD ioctl, upgrade your software to use new 
ictls.
<4>reiserfs: found format "3.6" with standard journal
<4>reiserfs: checking transaction log (md(9,1)) for (md(9,1))
<4>reiserfs: using ordered data mode
<4>Using r5 hash to sort names
<4>VFS: Mounted root (reiserfs filesystem) readonly.
<5>Trying to move old root to /initrd ... failed
<5>Unmounting old root
<5>Trying to free ramdisk memory ... okay
<6>Freeing unused kernel memory: 184k freed
<6> [events: 00000029]
<6> [events: 00000029]
<6>md: autorun ...
<6>md: considering sdb1 ...
<6>md:  adding sdb1 ...
<6>md:  adding sda2 ...
<6>md: created md0
<6>md: bind<sda2,1>
<6>md: bind<sdb1,2>
<6>md: running: <sdb1><sda2>
<6>md: sdb1's event counter: 00000029
<6>md: sda2's event counter: 00000029
<6>md: raid0 personality registered as nr 2
<6>md0: max total readahead window set to 496k
<6>md0: 2 data-disks, max readahead per data-disk: 248k
<4>raid0: looking at sda2
<4>raid0:   comparing sda2(530048) with sda2(530048)
<4>raid0:   END
<4>raid0:   ==> UNIQUE
<4>raid0: 1 zones
<4>raid0: looking at sdb1
<4>raid0:   comparing sdb1(562176) with sda2(530048)
<4>raid0:   NOT EQUAL
<4>raid0:   comparing sdb1(562176) with sdb1(562176)
<4>raid0:   END
<4>raid0:   ==> UNIQUE
<4>raid0: 2 zones
<4>raid0: FINAL 2 zones
<4>raid0: zone 0
<4>raid0: checking sda2 ... contained as device 0
<4>  (530048) is smallest!.
<4>raid0: checking sdb1 ... contained as device 1
<4>raid0: zone->nb_dev: 2, size: 1060096
<4>raid0: current zone offset: 530048
<4>raid0: zone 1
<4>raid0: checking sda2 ... nope.
<4>raid0: checking sdb1 ... contained as device 0
<4>  (562176) is smallest!.
<4>raid0: zone->nb_dev: 1, size: 32128
<4>raid0: current zone offset: 562176
<4>raid0: done.
<4>raid0 : md_size is 1092224 blocks.
<4>raid0 : conf->smallest->size is 32128 blocks.
<4>raid0 : nb_zone is 34.
<4>raid0 : Allocating 272 bytes for hash.
<6>md: updating md0 RAID superblock on device
<6>md: sdb1 [events: 0000002a]
<6>(write) sdb1's sb offset: 562176
<6>md: sda2 [events: 0000002a]
<6>(write) sda2's sb offset: 530048
<6> [events: 91909090]
<3>md: invalid raid superblock magic on md0
<4>md: md0 has invalid sb, not importing!
<4>md: no nested md device found
<6>md: ... autorun DONE.
<4>md: array md1 already exists!
<4>md: array md2 already exists!
<6>md: Autodetecting RAID arrays.
<1>md: could not import sdb1!
<1>md: could not import sda2!
<6>md: autorun ...
<6>md: ... autorun DONE.
--

  Jeroen Baten            | EMAIL :  JBATEN@I2RS.NL
 ____  _  __              | web   :  www.i2rs.nl
  |  )|_)(_               | tel   :  +31 (0)30 221 00 11
 _|_/_| \__)              | fax   :  +31 (0)30 220 31 91
  Kometenlaan 26, 3721 JT, Bilthoven, the Netherlands

