From: NeilBrown <neilb@suse.de>
Subject: Re: Disk identity crisis on RAID10 recovery (3.1.0)
Date: Tue, 22 Nov 2011 22:15:22 +1100
Message-ID: <20111122221522.3f525fc6@notabene.brown>
References: <4ECB7649.6080505@dentonet.pl>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/YFTFqfpmT6eeoI2XhwnB8z_"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4ECB7649.6080505@dentonet.pl>
Sender: linux-raid-owner@vger.kernel.org
To: krzepecki@dentonet.pl
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/YFTFqfpmT6eeoI2XhwnB8z_
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 22 Nov 2011 11:15:37 +0100 Konrad Rzepecki <krzepecki@dentonet.pl>
wrote:

>     Hi
>=20
> My system is Slackware-current x86_64 with 3.1.0 kernel

You'll be wanting 3.1.2.   It fixes the bug.

> Gigabyte GA-880GA-UD3H/GA-880GA-UD3H Mainboard
> 8 x Seagate ST1500DL003-9VT16L 1.5TB disks
> ext4 on LVM on RAID10
>=20
>=20
>=20
> I have 8 devices RADI10 (2 near) and huge problem with its recovery.
>=20
> It contain partitions from sda2 to sdh2 in this order.
>=20
> Some days ago i found that sdc2 is inactive from some reason [UU_UUUUU],=
=20
> so I decided to readd (zero, add) it to the RAID since smart shows no=20
> problems at it. RAID begin to resync but device status looks strange=20
> [_U_UUUUU]. I ignore this then, but after resync raid still have=20
> incomplete status [UU_UUUUU]. I try to do it again but, system claims=20
> that sdc2 is busy - so I restart machine. This lead me to BIG problem.=20
> System did not stand up. It claims that superblock on sda2 and sdc2 are=20
> this same. So I zero sdc2 and reboot. In that moment BIOS smart check=20
> found that sdb disk is failing. System starts up but /var partition=20
> occurs broken beyond repair. I think then that this sdb failure cause=20
> /var crash, but I doubt in it now. I fail and remove sdb2 and have=20
> following status raid [U__UUUUU].
>=20
> Broken sdb is now removed so it cause device renaming, so strange=20
> working sdc2 become now sdb2, and so on.
>=20
> I recover, all important data and try to fix raid further. So I try to=20
> zero and add sdb2 (previously sdc2) again. This was big mistake. It was=20
> add as spare but raid status starts looks that [___UUUUU]. In this=20
> moment filesystems begins to failing. Removing it (sdb2) from array not=20
> help. After restart no filesystem are mounted. When I disconnect this=20
> sdb drive and reset, even raid doesn't stand up it claims that it have 5=
=20
> working and 1 spare device.
>=20
> Now I have there only very limited initrd busysbox system so I cannot=20
> provide detailed logs. Only thing I have is dmesg left on my xterm:
>=20
> [    3.916469] md: md1 stopped.
> [    3.918847] md: bind<sdc2>
> [    3.920380] md: bind<sdd2>
> [    3.921886] md: bind<sde2>
> [    3.923158] md: bind<sdf2>
> [    3.924603] md: bind<sdg2>
> [    3.926060] md: bind<sda2>
> [    3.927876] md/raid10:md1: active with 6 out of 8 devices
> [    3.928958] md1: detected capacity change from 0 to 5996325896192
> [    3.932456]  md1: unknown partition table
> [249638.274101] md: bind<sdb2>
> [249638.309805] RAID10 conf printout:
> [249638.309807]  --- wd:6 rd:8
> [249638.309814]  disk 0, wo:1, o:1, dev:sdb2
> [249638.309816]  disk 3, wo:0, o:1, dev:sdc2
> [249638.309817]  disk 4, wo:0, o:1, dev:sdd2
> [249638.309818]  disk 5, wo:0, o:1, dev:sde2
> [249638.309820]  disk 6, wo:0, o:1, dev:sdf2
> [249638.309821]  disk 7, wo:0, o:1, dev:sdg2
> [249638.309826] ------------[ cut here ]------------
> [249638.309831] WARNING: at fs/sysfs/dir.c:455 sysfs_add_one+0x8c/0xa1()
> [249638.309832] Hardware name: GA-880GA-UD3H
> [249638.309834] sysfs: cannot create duplicate filename=20
> '/devices/virtual/block/md1/md/rd0'
> [249638.309835] Modules linked in: it87_wdt it87 hwmon_vid k10temp
> [249638.309840] Pid: 1126, comm: md1_raid10 Not tainted 3.1.0-Slackware #1
> [249638.309841] Call Trace:
> [249638.309845]  [<ffffffff81030852>] ? warn_slowpath_common+0x78/0x8c
> [249638.309848]  [<ffffffff81030907>] ? warn_slowpath_fmt+0x45/0x4a
> [249638.309850]  [<ffffffff8110929d>] ? sysfs_add_one+0x8c/0xa1
> [249638.309857]  [<ffffffff8110997f>] ? sysfs_do_create_link+0xef/0x187
> [249638.309860]  [<ffffffff812155d2>] ? sprintf+0x43/0x48
> [249638.309863]  [<ffffffff813b4a49>] ? sysfs_link_rdev+0x36/0x3f
> [249638.309866]  [<ffffffff813b007a>] ? raid10_add_disk+0x145/0x151
> [249638.309869]  [<ffffffff813baf9d>] ? md_check_recovery+0x3af/0x502
> [249638.309871]  [<ffffffff813b0c86>] ? raid10d+0x27/0x8f4
> [249638.309874]  [<ffffffff81025a4e>] ? need_resched+0x1a/0x23
> [249638.309877]  [<ffffffff814dd795>] ? __schedule+0x5b2/0x5c9
> [249638.309879]  [<ffffffff814ddc84>] ? schedule_timeout+0x1d/0xce
> [249638.309882]  [<ffffffff814deadc>] ? _raw_spin_lock_irqsave+0x9/0x1f
> [249638.309884]  [<ffffffff813b8506>] ? md_thread+0xfa/0x118
> [249638.309887]  [<ffffffff81046793>] ? wake_up_bit+0x23/0x23
> [249638.309889]  [<ffffffff813b840c>] ? md_rdev_init+0xef/0xef
> [249638.309891]  [<ffffffff813b840c>] ? md_rdev_init+0xef/0xef
> [249638.309893]  [<ffffffff8104637c>] ? kthread+0x7a/0x82
> [249638.309896]  [<ffffffff814e07f4>] ? kernel_thread_helper+0x4/0x10
> [249638.309898]  [<ffffffff81046302>] ? kthread_worker_fn+0x135/0x135
> [249638.309900]  [<ffffffff814e07f0>] ? gs_change+0xb/0xb
> [249638.309902] ---[ end trace 71d9cf6e5c21d5f2 ]---
> [249638.309938] md: recovery of RAID array md1
> [249638.309941] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
> [249638.309943] md: using maximum available idle IO bandwidth (but not=20
> more than 200000 KB/sec) for recovery.
> [249638.309947] md: using 128k window, over a total of 1463946752k.
> [249638.310044] md/raid10:md1: insufficient working devices for recovery.
> [249638.310110] md: md1: recovery done.
> [249638.544763] RAID10 conf printout:
> [249638.544765]  --- wd:6 rd:8
> [249638.544767]  disk 0, wo:1, o:1, dev:sdb2
> [249638.544768]  disk 3, wo:0, o:1, dev:sdc2
> [249638.544770]  disk 4, wo:0, o:1, dev:sdd2
> [249638.544771]  disk 5, wo:0, o:1, dev:sde2
> [249638.544772]  disk 6, wo:0, o:1, dev:sdf2
> [249638.544773]  disk 7, wo:0, o:1, dev:sdg2
> [249638.552051] RAID10 conf printout:
> [249638.552053]  --- wd:6 rd:8
> [249638.552055]  disk 3, wo:0, o:1, dev:sdc2
> [249638.552056]  disk 4, wo:0, o:1, dev:sdd2
> [249638.552057]  disk 5, wo:0, o:1, dev:sde2
> [249638.552058]  disk 6, wo:0, o:1, dev:sdf2
> [249638.552060]  disk 7, wo:0, o:1, dev:sdg2
> [249702.798860] ------------[ cut here ]------------
> [249702.798865] WARNING: at fs/buffer.c:1150 mark_buffer_dirty+0x25/0x80()
> [249702.798867] Hardware name: GA-880GA-UD3H
> [249702.798868] Modules linked in: it87_wdt it87 hwmon_vid k10temp
> [249702.798873] Pid: 1530, comm: jbd2/dm-5-8 Tainted: G        W=20
> 3.1.0-Slackware #1
> [249702.798874] Call Trace:
> [249702.798879]  [<ffffffff81030852>] ? warn_slowpath_common+0x78/0x8c
> [249702.798881]  [<ffffffff810d80c7>] ? mark_buffer_dirty+0x25/0x80
> [249702.798884]  [<ffffffff8116bd81>] ?=20
> __jbd2_journal_unfile_buffer+0x9/0x1a
> [249702.798887]  [<ffffffff8116e628>] ?=20
> jbd2_journal_commit_transaction+0xbb6/0xe3a
> [249702.798891]  [<ffffffff8103a8c6>] ? lock_timer_base.clone.23+0x25/0x4c
> [249702.798893]  [<ffffffff81170dab>] ? kjournald2+0xc0/0x20d
> [249702.798896]  [<ffffffff81046793>] ? wake_up_bit+0x23/0x23
> [249702.798898]  [<ffffffff81170ceb>] ? commit_timeout+0xd/0xd
> [249702.798900]  [<ffffffff81170ceb>] ? commit_timeout+0xd/0xd
> [249702.798902]  [<ffffffff8104637c>] ? kthread+0x7a/0x82
> [249702.798904]  [<ffffffff814e07f4>] ? kernel_thread_helper+0x4/0x10
> [249702.798907]  [<ffffffff81046302>] ? kthread_worker_fn+0x135/0x135
> [249702.798909]  [<ffffffff814e07f0>] ? gs_change+0xb/0xb
> [249702.798910] ---[ end trace 71d9cf6e5c21d5f3 ]---
> [250297.275053] md/raid10:md1: Disk failure on sdb2, disabling device.
> [250297.275054] md/raid10:md1: Operation continuing on 6 devices.
> [250350.689633] md: unbind<sdb2>
> [250350.705066] md: export_rdev(sdb2)
>=20
> I've deleted from it ext4 and lvm i/o errors.
>=20
>=20
> All this leads me to conclusion that from some strange reason drive sdb=20
> (named earlier sdc) when added shadows sda. It seems zeroing sdb=20
> superblock have no effect on this issue.
>=20
> Probaly this is not controller error because smartctl shows different=20
> data on both devices. Also other RAID1 (md0: sda1 - sdh1) behaves correct=
ly.
>=20
> Similar problem described Brad Campbell in "2 drive RAID10 rebuild=20
> issue" on 14 Oct.
>=20
>=20

You can probably get your data back... but really you should have asked for
help as soon as strange things started happening!

If you have all important data backed up then just upgrade to 3.1.2 and make
the array again  from scratch.
If you want to try to recover the array please report that output of "mdadm
--examine" on all of the devices.

NeilBrown


--Sig_/YFTFqfpmT6eeoI2XhwnB8z_
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTsuEXznsnt1WYoG5AQJMvg//RJeyvykXp80zuLum5obBQcFZMJSslG+g
vjRmsj2+9AtBw3Ymqfz4neshoOeJZuu/jFquoOh23QkZvaR36zFsPRFl2Yj9z+kZ
WdHcVEGFsCfZD91U4cvRuCBuHNXh9PrVWF/UFbJIKLLzZxjG0emx91jyEL2Fgofk
mHPXTpOSzw0RmIM/4Q98cnK0DLQFZ7o83UB4MrIg0fgd3uTvMJYALqPiZ0PLua+0
kHXVGN4o6z7D3j1LV7uwuqNXNSDGcRpLk3SCPAdad8iTsFZiIhqlDN0gYjqK0+rQ
5VNoOAHBgDNFc4+Q8Pz6OosqoAqSS0ecezpqcJi5OKtFkpeLPxwpyvyCH1a/y1Cl
CQakFzhcGuGmXdvUUWeRXxyen7TWyIk1oOrkYhBDUAKpodmeS6lvlvX/b/B0yNQa
uXTBZggkLeOr1K6+8S2BcKDXXyeZUmGmMks0kFex3HpcQYqA/tnhwvHHgXRkBgrI
hakyQ/Yl7mBu2eVUeQWi5nj+nuBI6mQmje/kWTgGrPm//kFqOQj7/+skr7+uV0AI
ySzcdLGwBf4pzw6mOrXrhg9OBxiLvKmm6D/4bjE+8ySm5cQVqXIv172Q7bEIJlXG
nSFVlbVaHl3Xv6muwp6V5KMOm03AnDEcLZ3PjQ3FEsyVh1nuoQGhD3HI81X+Dmik
O0MW1Z1x0Xk=
=elw7
-----END PGP SIGNATURE-----

--Sig_/YFTFqfpmT6eeoI2XhwnB8z_--
