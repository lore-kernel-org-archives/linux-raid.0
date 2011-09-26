From: NeilBrown <neilb@suse.de>
Subject: Re:
Date: Mon, 26 Sep 2011 18:04:01 +1000
Message-ID: <20110926180401.29b9a6bd@notabene.brown>
References: <09f356fa46129bd08dd45752c0f736de.squirrel@www.maxstr.com>
	<20110926145248.6ffc5f02@notabene.brown>
	<c3985537eaf1fc639fa8bfb7c8d0aa21.squirrel@www.maxstr.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/yjowbMgSt.79SwnpE+a+V7u"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <c3985537eaf1fc639fa8bfb7c8d0aa21.squirrel@www.maxstr.com>
Sender: linux-raid-owner@vger.kernel.org
To: kenn@kenn.us
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/yjowbMgSt.79SwnpE+a+V7u
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 26 Sep 2011 00:42:23 -0700 "Kenn" <kenn@kenn.us> wrote:

> Replying.  I realize and I apologize I didn't create a subject.  I hope
> this doesn't confuse majordomo.
>=20
> > On Sun, 25 Sep 2011 21:23:31 -0700 "Kenn" <kenn@kenn.us> wrote:
> >
> >> I have a raid5 array that had a drive drop out, and resilvered the wro=
ng
> >> drive when I put it back in, corrupting and destroying the raid.  I
> >> stopped the array at less than 1% resilvering and I'm in the process of
> >> making a dd-copy of the drive to recover the files.
> >
> > I don't know what you mean by "resilvered".
>=20
> Resilvering -- Rebuilding the array.  Lesser used term, sorry!

I see..

I guess that looking-glass mirrors have a silver backing and when it becomes
tarnished you might re-silver the mirror to make it better again.
So the name works as a poor pun for RAID1.  But I don't see how it applies
to RAID5....
No matter.

Basically you have messed up badly.
Recreating arrays should only be done as a last-ditch attempt to get data
back, and preferably with expert advice...

When you created the array with all devices present it effectively started
copying the corruption that you had deliberately (why??) placed on device 2
(sde) onto device 4 (counting from 0).
So now you have two devices that are corrupt in the early blocks.
There is not much you can do to fix that.

There is some chance that 'fsck' could find a backup superblock somewhere a=
nd
try to put the pieces back together.  But the 'mkfs' probably made a
substantial mess of important data structures so I don't consider you chanc=
es
very high.
Keeping sde out and just working with the remaining 4 is certainly your best
bet.

What made you think it would be a good idea to re-create the array when all
you wanted to do was trigger a resync/recovery??

NeilBrown


>=20
> >
> >>
> >> (1) Is there anything diagnostic I can contribute to add more
> >> wrong-drive-resilvering protection to mdadm?  I have the command histo=
ry
> >> showing everything I did, I have the five drives available for reading
> >> sectors, I haven't touched anything yet.
> >
> > Yes, report the command history, and any relevant kernel logs, and the
> > output
> > of "mdadm --examine" on all relevant devices.
> >
> > NeilBrown
>=20
> Awesome!  I hope this is useful.  It's really long, so I edited down the
> logs and command history to what I thought were the important bits.  If
> you want more, I can post unedited versions, please let me know.
>=20
> ### Command History ###
>=20
> # The start of the sequence, removing sde from array
> mdadm --examine /dev/sde
> mdadm --detail /dev/md3
> cat /proc/mdstat
> mdadm /dev/md3 --remove /dev/sde1
> mdadm /dev/md3 --remove /dev/sde
> mdadm /dev/md3 --fail /dev/sde1
> cat /proc/mdstat
> mdadm --examine /dev/sde1
> fdisk -l | grep 750
> mdadm --examine /dev/sde1
> mdadm --remove /dev/sde
> mdadm /dev/md3 --remove /dev/sde
> mdadm /dev/md3 --fail /dev/sde
> fdisk /dev/sde
> ls
> vi /var/log/syslog
> reboot
> vi /var/log/syslog
> reboot
> mdadm --detail /dev/md3
> mdadm --examine /dev/sde1
> # Wiping sde
> fdisk /dev/sde
> newfs -t ext3 /dev/sde1
> mkfs -t ext3 /dev/sde1
> mkfs -t ext3 /dev/sde2
> fdisk /dev/sde
> mdadm --stop /dev/md3
> # Putting sde back into array
> mdadm --examine /dev/sde
> mdadm --help
> mdadm --misc --help
> mdadm --zero-superblock /dev/sde
> mdadm --query /dev/sde
> mdadm --examine /dev/sde
> mdadm --detail /dev/sde
> mdadm --detail /dev/sde1
> fdisk /dev/sde
> mdadm --assemble --no-degraded /dev/md3  /dev/hde1 /dev/hdi1 /dev/sde1
> /dev/hdk1 /dev/hdg1
> cat /proc/mdstat
> mdadm --stop /dev/md3
> mdadm --create /dev/md3 --level=3D5 --raid-devices=3D5  /dev/hde1 /dev/hd=
i1
> missing /dev/hdk1 /dev/hdg1
> mount -o ro /raid53
> ls /raid53
> umount /raid53
> mdadm --stop /dev/md3
> # The command that did the bad rebuild
> mdadm --create /dev/md3 --level=3D5 --raid-devices=3D5  /dev/hde1 /dev/hd=
i1
> /dev/sde1 /dev/hdk1 /dev/hdg1
> cat /proc/mdstat
> mdadm --examine /dev/md3
> mdadm --query /dev/md3
> mdadm --detail /dev/md3
> mount /raid53
> mdadm --stop /dev/md3
> # Trying to get the corrupted disk back up
> mdadm --create /dev/md3 --level=3D5 --raid-devices=3D5  /dev/hde1 /dev/hd=
i1
> missing /dev/hdk1 /dev/hdg1
> cat /proc/mdstat
> mount /raid53
> fsck -n /dev/md3
>=20
>=20
>=20
> ### KERNEL LOGS ###
>=20
> # Me messing around with fdisk and mdadm creating new partitions to wipe
> out sde
> Sep 22 15:56:39 teresa kernel: [ 7897.778204] sd 5:0:0:0: [sde] 1465149168
> 512-byte hardware sectors (750156 MB)
> Sep 22 15:56:39 teresa kernel: [ 7897.778204] sd 5:0:0:0: [sde] Write
> Protect is off
> Sep 22 15:56:39 teresa kernel: [ 7897.778204] sd 5:0:0:0: [sde] Mode
> Sense: 00 3a 00 00
> Sep 22 15:56:39 teresa kernel: [ 7897.778204] sd 5:0:0:0: [sde] Write
> cache: enabled, read cache: enabled, doesn't support DPO or FUA
> Sep 22 15:56:39 teresa kernel: [ 7897.778204]  sde: sde1 sde2
> Sep 22 15:56:41 teresa kernel: [ 7899.848026] sd 5:0:0:0: [sde] 1465149168
> 512-byte hardware sectors (750156 MB)
> Sep 22 15:56:41 teresa kernel: [ 7899.848026] sd 5:0:0:0: [sde] Write
> Protect is off
> Sep 22 15:56:41 teresa kernel: [ 7899.848026] sd 5:0:0:0: [sde] Mode
> Sense: 00 3a 00 00
> Sep 22 15:56:41 teresa kernel: [ 7899.848026] sd 5:0:0:0: [sde] Write
> cache: enabled, read cache: enabled, doesn't support DPO or FUA
> Sep 22 15:56:41 teresa kernel: [ 7899.848026]  sde: sde1 sde2
> Sep 22 16:01:49 teresa kernel: [ 8207.733821] sd 5:0:0:0: [sde] 1465149168
> 512-byte hardware sectors (750156 MB)
> Sep 22 16:01:49 teresa kernel: [ 8207.733919] sd 5:0:0:0: [sde] Write
> Protect is off
> Sep 22 16:01:49 teresa kernel: [ 8207.733943] sd 5:0:0:0: [sde] Mode
> Sense: 00 3a 00 00
> Sep 22 16:01:49 teresa kernel: [ 8207.734039] sd 5:0:0:0: [sde] Write
> cache: enabled, read cache: enabled, doesn't support DPO or FUA
> Sep 22 16:01:49 teresa kernel: [ 8207.734083]  sde: sde1
> Sep 22 16:01:51 teresa kernel: [ 8209.777260] sd 5:0:0:0: [sde] 1465149168
> 512-byte hardware sectors (750156 MB)
> Sep 22 16:01:51 teresa kernel: [ 8209.777260] sd 5:0:0:0: [sde] Write
> Protect is off
> Sep 22 16:01:51 teresa kernel: [ 8209.777260] sd 5:0:0:0: [sde] Mode
> Sense: 00 3a 00 00
> Sep 22 16:01:51 teresa kernel: [ 8209.777260] sd 5:0:0:0: [sde] Write
> cache: enabled, read cache: enabled, doesn't support DPO or FUA
> Sep 22 16:01:51 teresa kernel: [ 8209.777260]  sde: sde1
> Sep 22 16:02:09 teresa mdadm[2694]: DeviceDisappeared event detected on md
> device /dev/md3
> Sep 22 16:02:09 teresa kernel: [ 8227.781860] md: md3 stopped.
> Sep 22 16:02:09 teresa kernel: [ 8227.781908] md: unbind<hde1>
> Sep 22 16:02:09 teresa kernel: [ 8227.781937] md: export_rdev(hde1)
> Sep 22 16:02:09 teresa kernel: [ 8227.782261] md: unbind<hdg1>
> Sep 22 16:02:09 teresa kernel: [ 8227.782292] md: export_rdev(hdg1)
> Sep 22 16:02:09 teresa kernel: [ 8227.782561] md: unbind<hdk1>
> Sep 22 16:02:09 teresa kernel: [ 8227.782590] md: export_rdev(hdk1)
> Sep 22 16:02:09 teresa kernel: [ 8227.782855] md: unbind<hdi1>
> Sep 22 16:02:09 teresa kernel: [ 8227.782885] md: export_rdev(hdi1)
> Sep 22 16:15:32 teresa smartd[2657]: Device: /dev/hda, Failed SMART usage
> Attribute: 194 Temperature_Celsius.
> Sep 22 16:15:33 teresa smartd[2657]: Device: /dev/hdk, SMART Usage
> Attribute: 194 Temperature_Celsius changed from 110 to 111
> Sep 22 16:15:33 teresa smartd[2657]: Device: /dev/sdb, SMART Usage
> Attribute: 194 Temperature_Celsius changed from 113 to 116
> Sep 22 16:15:33 teresa smartd[2657]: Device: /dev/sdc, SMART Usage
> Attribute: 190 Airflow_Temperature_Cel changed from 52 to 51
> Sep 22 16:17:01 teresa /USR/SBIN/CRON[2965]: (root) CMD (   cd / &&
> run-parts --report /etc/cron.hourly)
> Sep 22 16:18:42 teresa kernel: [ 9220.400915] md: md3 stopped.
> Sep 22 16:18:42 teresa kernel: [ 9220.411525] md: bind<hdi1>
> Sep 22 16:18:42 teresa kernel: [ 9220.411884] md: bind<sde1>
> Sep 22 16:18:42 teresa kernel: [ 9220.412577] md: bind<hdk1>
> Sep 22 16:18:42 teresa kernel: [ 9220.413162] md: bind<hdg1>
> Sep 22 16:18:42 teresa kernel: [ 9220.413750] md: bind<hde1>
> Sep 22 16:18:42 teresa kernel: [ 9220.413855] md: kicking non-fresh sde1
> from array!
> Sep 22 16:18:42 teresa kernel: [ 9220.413887] md: unbind<sde1>
> Sep 22 16:18:42 teresa kernel: [ 9220.413915] md: export_rdev(sde1)
> Sep 22 16:18:42 teresa kernel: [ 9220.477393] raid5: device hde1
> operational as raid disk 0
> Sep 22 16:18:42 teresa kernel: [ 9220.477420] raid5: device hdg1
> operational as raid disk 4
> Sep 22 16:18:42 teresa kernel: [ 9220.477438] raid5: device hdk1
> operational as raid disk 3
> Sep 22 16:18:42 teresa kernel: [ 9220.477456] raid5: device hdi1
> operational as raid disk 1
> Sep 22 16:18:42 teresa kernel: [ 9220.478236] raid5: allocated 5252kB for=
 md3
> Sep 22 16:18:42 teresa kernel: [ 9220.478265] raid5: raid level 5 set md3
> active with 4 out of 5 devices, algorithm 2
> Sep 22 16:18:42 teresa kernel: [ 9220.478294] RAID5 conf printout:
> Sep 22 16:18:42 teresa kernel: [ 9220.478309]  --- rd:5 wd:4
> Sep 22 16:18:42 teresa kernel: [ 9220.478324]  disk 0, o:1, dev:hde1
> Sep 22 16:18:42 teresa kernel: [ 9220.478339]  disk 1, o:1, dev:hdi1
> Sep 22 16:18:42 teresa kernel: [ 9220.478354]  disk 3, o:1, dev:hdk1
> Sep 22 16:18:42 teresa kernel: [ 9220.478369]  disk 4, o:1, dev:hdg1
> # Me stopping md3
> Sep 22 16:18:53 teresa mdadm[2694]: DeviceDisappeared event detected on md
> device /dev/md3
> Sep 22 16:18:53 teresa kernel: [ 9231.572348] md: md3 stopped.
> Sep 22 16:18:53 teresa kernel: [ 9231.572394] md: unbind<hde1>
> Sep 22 16:18:53 teresa kernel: [ 9231.572423] md: export_rdev(hde1)
> Sep 22 16:18:53 teresa kernel: [ 9231.572728] md: unbind<hdg1>
> Sep 22 16:18:53 teresa kernel: [ 9231.572758] md: export_rdev(hdg1)
> Sep 22 16:18:53 teresa kernel: [ 9231.572988] md: unbind<hdk1>
> Sep 22 16:18:53 teresa kernel: [ 9231.573015] md: export_rdev(hdk1)
> Sep 22 16:18:53 teresa kernel: [ 9231.573243] md: unbind<hdi1>
> Sep 22 16:18:53 teresa kernel: [ 9231.573270] md: export_rdev(hdi1)
> # Me creating md3 with sde1 missing
> Sep 22 16:19:51 teresa kernel: [ 9289.621646] md: bind<hde1>
> Sep 22 16:19:51 teresa kernel: [ 9289.665268] md: bind<hdi1>
> Sep 22 16:19:51 teresa kernel: [ 9289.695676] md: bind<hdk1>
> Sep 22 16:19:51 teresa kernel: [ 9289.726906] md: bind<hdg1>
> Sep 22 16:19:51 teresa kernel: [ 9289.809030] raid5: device hdg1
> operational as raid disk 4
> Sep 22 16:19:51 teresa kernel: [ 9289.809057] raid5: device hdk1
> operational as raid disk 3
> Sep 22 16:19:51 teresa kernel: [ 9289.809075] raid5: device hdi1
> operational as raid disk 1
> Sep 22 16:19:51 teresa kernel: [ 9289.809093] raid5: device hde1
> operational as raid disk 0
> Sep 22 16:19:51 teresa kernel: [ 9289.809821] raid5: allocated 5252kB for=
 md3
> Sep 22 16:19:51 teresa kernel: [ 9289.809850] raid5: raid level 5 set md3
> active with 4 out of 5 devices, algorithm 2
> Sep 22 16:19:51 teresa kernel: [ 9289.809877] RAID5 conf printout:
> Sep 22 16:19:51 teresa kernel: [ 9289.809891]  --- rd:5 wd:4
> Sep 22 16:19:51 teresa kernel: [ 9289.809907]  disk 0, o:1, dev:hde1
> Sep 22 16:19:51 teresa kernel: [ 9289.809922]  disk 1, o:1, dev:hdi1
> Sep 22 16:19:51 teresa kernel: [ 9289.809937]  disk 3, o:1, dev:hdk1
> Sep 22 16:19:51 teresa kernel: [ 9289.809953]  disk 4, o:1, dev:hdg1
> Sep 22 16:20:20 teresa kernel: [ 9318.486512] kjournald starting.  Commit
> interval 5 seconds
> Sep 22 16:20:20 teresa kernel: [ 9318.486512] EXT3-fs: mounted filesystem
> with ordered data mode.
> # Me stopping md3 again
> Sep 22 16:20:42 teresa mdadm[2694]: DeviceDisappeared event detected on md
> device /dev/md3
> Sep 22 16:20:42 teresa kernel: [ 9340.300590] md: md3 stopped.
> Sep 22 16:20:42 teresa kernel: [ 9340.300639] md: unbind<hdg1>
> Sep 22 16:20:42 teresa kernel: [ 9340.300668] md: export_rdev(hdg1)
> Sep 22 16:20:42 teresa kernel: [ 9340.300921] md: unbind<hdk1>
> Sep 22 16:20:42 teresa kernel: [ 9340.300950] md: export_rdev(hdk1)
> Sep 22 16:20:42 teresa kernel: [ 9340.301183] md: unbind<hdi1>
> Sep 22 16:20:42 teresa kernel: [ 9340.301211] md: export_rdev(hdi1)
> Sep 22 16:20:42 teresa kernel: [ 9340.301438] md: unbind<hde1>
> Sep 22 16:20:42 teresa kernel: [ 9340.301465] md: export_rdev(hde1)
> # This is me doing the fatal create, that recovers the wrong disk
> Sep 22 16:21:39 teresa kernel: [ 9397.609864] md: bind<hde1>
> Sep 22 16:21:39 teresa kernel: [ 9397.652426] md: bind<hdi1>
> Sep 22 16:21:39 teresa kernel: [ 9397.673203] md: bind<sde1>
> Sep 22 16:21:39 teresa kernel: [ 9397.699373] md: bind<hdk1>
> Sep 22 16:21:39 teresa kernel: [ 9397.739372] md: bind<hdg1>
> Sep 22 16:21:39 teresa kernel: [ 9397.801729] raid5: device hdk1
> operational as raid disk 3
> Sep 22 16:21:39 teresa kernel: [ 9397.801756] raid5: device sde1
> operational as raid disk 2
> Sep 22 16:21:39 teresa kernel: [ 9397.801774] raid5: device hdi1
> operational as raid disk 1
> Sep 22 16:21:39 teresa kernel: [ 9397.801793] raid5: device hde1
> operational as raid disk 0
> Sep 22 16:21:39 teresa kernel: [ 9397.802531] raid5: allocated 5252kB for=
 md3
> Sep 22 16:21:39 teresa kernel: [ 9397.802559] raid5: raid level 5 set md3
> active with 4 out of 5 devices, algorithm 2
> Sep 22 16:21:39 teresa kernel: [ 9397.802586] RAID5 conf printout:
> Sep 22 16:21:39 teresa kernel: [ 9397.802600]  --- rd:5 wd:4
> Sep 22 16:21:39 teresa kernel: [ 9397.802615]  disk 0, o:1, dev:hde1
> Sep 22 16:21:39 teresa kernel: [ 9397.802631]  disk 1, o:1, dev:hdi1
> Sep 22 16:21:39 teresa kernel: [ 9397.802646]  disk 2, o:1, dev:sde1
> Sep 22 16:21:39 teresa kernel: [ 9397.802661]  disk 3, o:1, dev:hdk1
> Sep 22 16:21:39 teresa kernel: [ 9397.838429] RAID5 conf printout:
> Sep 22 16:21:39 teresa kernel: [ 9397.838454]  --- rd:5 wd:4
> Sep 22 16:21:39 teresa kernel: [ 9397.838471]  disk 0, o:1, dev:hde1
> Sep 22 16:21:39 teresa kernel: [ 9397.838486]  disk 1, o:1, dev:hdi1
> Sep 22 16:21:39 teresa kernel: [ 9397.838502]  disk 2, o:1, dev:sde1
> Sep 22 16:21:39 teresa kernel: [ 9397.838518]  disk 3, o:1, dev:hdk1
> Sep 22 16:21:39 teresa kernel: [ 9397.838533]  disk 4, o:1, dev:hdg1
> Sep 22 16:21:39 teresa mdadm[2694]: RebuildStarted event detected on md
> device /dev/md3
> Sep 22 16:21:39 teresa kernel: [ 9397.841822] md: recovery of RAID array =
md3
> Sep 22 16:21:39 teresa kernel: [ 9397.841848] md: minimum _guaranteed_=20
> speed: 1000 KB/sec/disk.
> Sep 22 16:21:39 teresa kernel: [ 9397.841868] md: using maximum available
> idle IO bandwidth (but not more than 200000 KB/sec) for recovery.
> Sep 22 16:21:39 teresa kernel: [ 9397.841908] md: using 128k window, over
> a total of 732571904 blocks.
> Sep 22 16:22:33 teresa kernel: [ 9451.640192] EXT3-fs error (device md3):
> ext3_check_descriptors: Block bitmap for group 3968 not in group (block
> 0)!
> Sep 22 16:22:33 teresa kernel: [ 9451.750241] EXT3-fs: group descriptors
> corrupted!
> Sep 22 16:22:39 teresa kernel: [ 9458.079151] md: md_do_sync() got signal
> ... exiting
> Sep 22 16:22:39 teresa kernel: [ 9458.114590] md: md3 stopped.
> Sep 22 16:22:39 teresa kernel: [ 9458.114590] md: unbind<hdg1>
> Sep 22 16:22:39 teresa kernel: [ 9458.114590] md: export_rdev(hdg1)
> Sep 22 16:22:39 teresa kernel: [ 9458.114590] md: unbind<hdk1>
> Sep 22 16:22:39 teresa kernel: [ 9458.114590] md: export_rdev(hdk1)
> Sep 22 16:22:39 teresa kernel: [ 9458.114590] md: unbind<sde1>
> Sep 22 16:22:39 teresa kernel: [ 9458.114590] md: export_rdev(sde1)
> Sep 22 16:22:39 teresa kernel: [ 9458.114590] md: unbind<hdi1>
> Sep 22 16:22:39 teresa kernel: [ 9458.114590] md: export_rdev(hdi1)
> Sep 22 16:22:39 teresa kernel: [ 9458.114590] md: unbind<hde1>
> Sep 22 16:22:39 teresa kernel: [ 9458.114590] md: export_rdev(hde1)
> Sep 22 16:22:39 teresa mdadm[2694]: DeviceDisappeared event detected on md
> device /dev/md3
> # Me trying to recreate md3 without sde
> Sep 22 16:23:50 teresa kernel: [ 9529.065477] md: bind<hde1>
> Sep 22 16:23:50 teresa kernel: [ 9529.107767] md: bind<hdi1>
> Sep 22 16:23:50 teresa kernel: [ 9529.137743] md: bind<hdk1>
> Sep 22 16:23:50 teresa kernel: [ 9529.177990] md: bind<hdg1>
> Sep 22 16:23:51 teresa mdadm[2694]: RebuildFinished event detected on md
> device /dev/md3
> Sep 22 16:23:51 teresa kernel: [ 9529.240814] raid5: device hdg1
> operational as raid disk 4
> Sep 22 16:23:51 teresa kernel: [ 9529.241734] raid5: device hdk1
> operational as raid disk 3
> Sep 22 16:23:51 teresa kernel: [ 9529.241752] raid5: device hdi1
> operational as raid disk 1
> Sep 22 16:23:51 teresa kernel: [ 9529.241770] raid5: device hde1
> operational as raid disk 0
> Sep 22 16:23:51 teresa kernel: [ 9529.242520] raid5: allocated 5252kB for=
 md3
> Sep 22 16:23:51 teresa kernel: [ 9529.242547] raid5: raid level 5 set md3
> active with 4 out of 5 devices, algorithm 2
> Sep 22 16:23:51 teresa kernel: [ 9529.242574] RAID5 conf printout:
> Sep 22 16:23:51 teresa kernel: [ 9529.242588]  --- rd:5 wd:4
> Sep 22 16:23:51 teresa kernel: [ 9529.242603]  disk 0, o:1, dev:hde1
> Sep 22 16:23:51 teresa kernel: [ 9529.242618]  disk 1, o:1, dev:hdi1
> Sep 22 16:23:51 teresa kernel: [ 9529.242633]  disk 3, o:1, dev:hdk1
> Sep 22 16:23:51 teresa kernel: [ 9529.242649]  disk 4, o:1, dev:hdg1
> # And me trying a fsck -n or a mount
> Sep 22 16:24:07 teresa kernel: [ 9545.326343] EXT3-fs error (device md3):
> ext3_check_descriptors: Block bitmap for group 3968 not in group (block
> 0)!
> Sep 22 16:24:07 teresa kernel: [ 9545.369071] EXT3-fs: group descriptors
> corrupted!
>=20
>=20
> ### EXAMINES OF PARTITIONS ###
>=20
> =3D=3D=3D --examine /dev/hde1 =3D=3D=3D
> /dev/hde1:
>           Magic : a92b4efc
>         Version : 00.90.00
>            UUID : ed1e6357:74e32684:47f7b12e:9c2b2218 (local to host tere=
sa)
>   Creation Time : Thu Sep 22 16:23:50 2011
>      Raid Level : raid5
>   Used Dev Size : 732571904 (698.64 GiB 750.15 GB)
>      Array Size : 2930287616 (2794.54 GiB 3000.61 GB)
>    Raid Devices : 5
>   Total Devices : 4
> Preferred Minor : 3
>=20
>     Update Time : Sun Sep 25 22:11:22 2011
>           State : clean
>  Active Devices : 4
> Working Devices : 4
>  Failed Devices : 1
>   Spare Devices : 0
>        Checksum : b7f6a3c0 - correct
>          Events : 10
>=20
>          Layout : left-symmetric
>      Chunk Size : 64K
>=20
>       Number   Major   Minor   RaidDevice State
> this     0      33        1        0      active sync   /dev/hde1
>=20
>    0     0      33        1        0      active sync   /dev/hde1
>    1     1      56        1        1      active sync   /dev/hdi1
>    2     2       0        0        2      faulty removed
>    3     3      57        1        3      active sync   /dev/hdk1
>    4     4      34        1        4      active sync   /dev/hdg1
>=20
> =3D=3D=3D --examine /dev/hdi1 =3D=3D=3D
> /dev/hdi1:
>           Magic : a92b4efc
>         Version : 00.90.00
>            UUID : ed1e6357:74e32684:47f7b12e:9c2b2218 (local to host tere=
sa)
>   Creation Time : Thu Sep 22 16:23:50 2011
>      Raid Level : raid5
>   Used Dev Size : 732571904 (698.64 GiB 750.15 GB)
>      Array Size : 2930287616 (2794.54 GiB 3000.61 GB)
>    Raid Devices : 5
>   Total Devices : 4
> Preferred Minor : 3
>=20
>     Update Time : Sun Sep 25 22:11:22 2011
>           State : clean
>  Active Devices : 4
> Working Devices : 4
>  Failed Devices : 1
>   Spare Devices : 0
>        Checksum : b7f6a3d9 - correct
>          Events : 10
>=20
>          Layout : left-symmetric
>      Chunk Size : 64K
>=20
>       Number   Major   Minor   RaidDevice State
> this     1      56        1        1      active sync   /dev/hdi1
>=20
>    0     0      33        1        0      active sync   /dev/hde1
>    1     1      56        1        1      active sync   /dev/hdi1
>    2     2       0        0        2      faulty removed
>    3     3      57        1        3      active sync   /dev/hdk1
>    4     4      34        1        4      active sync   /dev/hdg1
>=20
> =3D=3D=3D --examine /dev/sde1 =3D=3D=3D
> /dev/sde1:
>           Magic : a92b4efc
>         Version : 00.90.00
>            UUID : e6e3df36:1195239f:47f7b12e:9c2b2218 (local to host tere=
sa)
>   Creation Time : Thu Sep 22 16:21:39 2011
>      Raid Level : raid5
>   Used Dev Size : 732571904 (698.64 GiB 750.15 GB)
>      Array Size : 2930287616 (2794.54 GiB 3000.61 GB)
>    Raid Devices : 5
>   Total Devices : 5
> Preferred Minor : 3
>=20
>     Update Time : Thu Sep 22 16:22:39 2011
>           State : clean
>  Active Devices : 4
> Working Devices : 5
>  Failed Devices : 1
>   Spare Devices : 1
>        Checksum : 4e69d679 - correct
>          Events : 8
>=20
>          Layout : left-symmetric
>      Chunk Size : 64K
>=20
>       Number   Major   Minor   RaidDevice State
> this     2       8       65        2      active sync   /dev/sde1
>=20
>    0     0      33        1        0      active sync   /dev/hde1
>    1     1      56        1        1      active sync   /dev/hdi1
>    2     2       8       65        2      active sync   /dev/sde1
>    3     3      57        1        3      active sync   /dev/hdk1
>    4     4       0        0        4      faulty removed
>    5     5      34        1        5      spare   /dev/hdg1
>=20
> =3D=3D=3D --examine /dev/hdk1 =3D=3D=3D
> /dev/hdk1:
>           Magic : a92b4efc
>         Version : 00.90.00
>            UUID : ed1e6357:74e32684:47f7b12e:9c2b2218 (local to host tere=
sa)
>   Creation Time : Thu Sep 22 16:23:50 2011
>      Raid Level : raid5
>   Used Dev Size : 732571904 (698.64 GiB 750.15 GB)
>      Array Size : 2930287616 (2794.54 GiB 3000.61 GB)
>    Raid Devices : 5
>   Total Devices : 4
> Preferred Minor : 3
>=20
>     Update Time : Sun Sep 25 22:11:22 2011
>           State : clean
>  Active Devices : 4
> Working Devices : 4
>  Failed Devices : 1
>   Spare Devices : 0
>        Checksum : b7f6a3de - correct
>          Events : 10
>=20
>          Layout : left-symmetric
>      Chunk Size : 64K
>=20
>       Number   Major   Minor   RaidDevice State
> this     3      57        1        3      active sync   /dev/hdk1
>=20
>    0     0      33        1        0      active sync   /dev/hde1
>    1     1      56        1        1      active sync   /dev/hdi1
>    2     2       0        0        2      faulty removed
>    3     3      57        1        3      active sync   /dev/hdk1
>    4     4      34        1        4      active sync   /dev/hdg1
>=20
> =3D=3D=3D --examine /dev/hdg1 =3D=3D=3D
> /dev/hdg1:
>           Magic : a92b4efc
>         Version : 00.90.00
>            UUID : ed1e6357:74e32684:47f7b12e:9c2b2218 (local to host tere=
sa)
>   Creation Time : Thu Sep 22 16:23:50 2011
>      Raid Level : raid5
>   Used Dev Size : 732571904 (698.64 GiB 750.15 GB)
>      Array Size : 2930287616 (2794.54 GiB 3000.61 GB)
>    Raid Devices : 5
>   Total Devices : 4
> Preferred Minor : 3
>=20
>     Update Time : Sun Sep 25 22:11:22 2011
>           State : clean
>  Active Devices : 4
> Working Devices : 4
>  Failed Devices : 1
>   Spare Devices : 0
>        Checksum : b7f6a3c9 - correct
>          Events : 10
>=20
>          Layout : left-symmetric
>      Chunk Size : 64K
>=20
>       Number   Major   Minor   RaidDevice State
> this     4      34        1        4      active sync   /dev/hdg1
>=20
>    0     0      33        1        0      active sync   /dev/hde1
>    1     1      56        1        1      active sync   /dev/hdi1
>    2     2       0        0        2      faulty removed
>    3     3      57        1        3      active sync   /dev/hdk1
>    4     4      34        1        4      active sync   /dev/hdg1
>=20
>=20
>=20
>=20
> >
> >
> >>
> >> (2) Can I suggest improvements into resilvering?  Can I contribute code
> >> to
> >> implement them?  Such as resilver from the end of the drive back to the
> >> front, so if you notice the wrong drive resilvering, you can stop and
> >> not
> >> lose the MBR and the directory format structure that's stored in the
> >> first
> >> few sectors?  I'd also like to take a look at adding a raid mode where
> >> there's checksum in every stripe block so the system can detect
> >> corrupted
> >> disks and not resilver.  I'd also like to add a raid option where a
> >> resilvering need will be reported by email and needs to be started
> >> manually.  All to prevent what happened to me from happening again.
> >>
> >> Thanks for your time.
> >>
> >> Kenn Frank
> >>
> >> P.S.  Setup:
> >>
> >> # uname -a
> >> Linux teresa 2.6.26-2-686 #1 SMP Sat Jun 11 14:54:10 UTC 2011 i686
> >> GNU/Linux
> >>
> >> # mdadm --version
> >> mdadm - v2.6.7.2 - 14th November 2008
> >>
> >> # mdadm --detail /dev/md3
> >> /dev/md3:
> >>         Version : 00.90
> >>   Creation Time : Thu Sep 22 16:23:50 2011
> >>      Raid Level : raid5
> >>      Array Size : 2930287616 (2794.54 GiB 3000.61 GB)
> >>   Used Dev Size : 732571904 (698.64 GiB 750.15 GB)
> >>    Raid Devices : 5
> >>   Total Devices : 4
> >> Preferred Minor : 3
> >>     Persistence : Superblock is persistent
> >>
> >>     Update Time : Thu Sep 22 20:19:09 2011
> >>           State : clean, degraded
> >>  Active Devices : 4
> >> Working Devices : 4
> >>  Failed Devices : 0
> >>   Spare Devices : 0
> >>
> >>          Layout : left-symmetric
> >>      Chunk Size : 64K
> >>
> >>            UUID : ed1e6357:74e32684:47f7b12e:9c2b2218 (local to host
> >> teresa)
> >>          Events : 0.6
> >>
> >>     Number   Major   Minor   RaidDevice State
> >>        0      33        1        0      active sync   /dev/hde1
> >>        1      56        1        1      active sync   /dev/hdi1
> >>        2       0        0        2      removed
> >>        3      57        1        3      active sync   /dev/hdk1
> >>        4      34        1        4      active sync   /dev/hdg1
> >>
> >>
> >
> >
>=20


--Sig_/yjowbMgSt.79SwnpE+a+V7u
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iD8DBQFOgDHxG5fc6gV+Wb0RAkT9AKCQcFBgQ30+PUm6+QnWNB5tuvvSkwCggor7
jT420lqcq27WJ+VYa6zDa20=
=fFbA
-----END PGP SIGNATURE-----

--Sig_/yjowbMgSt.79SwnpE+a+V7u--
