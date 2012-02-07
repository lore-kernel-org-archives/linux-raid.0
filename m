From: NeilBrown <neilb@suse.de>
Subject: Re: Please Help! RAID5 -> 6 reshapre gone bad
Date: Tue, 7 Feb 2012 13:39:47 +1100
Message-ID: <20120207133947.5c4b9a59@notabene.brown>
References: <CAOANJV-V8ZTXBvQxxMnEnv24p8A-fAas-6x65ifW5yp35ZqHnA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/DDolHabNEN=OXKyXFMDttIv"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAOANJV-V8ZTXBvQxxMnEnv24p8A-fAas-6x65ifW5yp35ZqHnA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Richard Herd <2001oddity@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/DDolHabNEN=OXKyXFMDttIv
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Tue, 7 Feb 2012 12:34:48 +1100 Richard Herd <2001oddity@gmail.com> wrote:

> Hey guys,
>=20
> I'm in a bit of a pickle here and if any mdadm kings could step in and
> throw some advice my way I'd be very grateful :-)
>=20
> Quick bit of background - little NAS based on an AMD E350 running
> Ubuntu 10.04. Running a software RAID 5 from 5x2TB disks. =C2=A0Every few
> months one of the drives would fail a request and get kicked from the
> array (as is becoming common for these larger multi TB drives they
> tolerate the occasional bad sector by reallocating from a pool of
> spares (but that's a whole other story)). =C2=A0This happened across a
> variety of brands and two different controllers. I'd simply add the
> disk that got popped back in and let it re-sync. =C2=A0SMART tests always
> in good health.
>=20
> It did make me nervous though. =C2=A0So I decided I'd add a second disk f=
or
> a bit of extra redundancy, making the array a RAID 6 - the thinking
> was the occasional disk getting kicked and re-added from a RAID 6
> array wouldn't present as much risk as a single disk getting kicked
> from a RAID 5.
>=20
> So first off, I added the 6th disk as a hotspare to the RAID5 array.
> So I now had my 5 disk RAID 5 + hotspare.
>=20
> I then found that mdadm 2.6.7 (in the repositories) isn't actually
> capable of a 5->6 reshape. =C2=A0So I pulled the latest 3.2.3 sources and
> compiled myself a new version of mdadm.
>=20
> With the newer version of mdadm, it was happy to do the reshape - so I
> set it off on it's merry way, using an esata HD (mounted at /usb :-P)
> for the backupfile:
>=20
> root@raven:/# mdadm --grow /dev/md0 --level=3D6 --raid-devices=3D6
> --backup-file=3D/usb/md0.backup
>=20
> It would take a week to reshape, but it was ona UPS & happily ticking
> along. =C2=A0The array would be online the whole time so I was in no rush.
> Content, I went to get some shut-eye.
>=20
> I got up this morning and took a quick look in /proc/mdstat to see how
> things were going and saw things had failed spectacularly. =C2=A0At least
> two disks had been kicked from the array and the whole thing had
> crumbled.
>=20
> Ouch.
>=20
> I tried to assembe the array, to see if it would continue the reshape:
>=20
> root@raven:/# mdadm -Avv --backup-file=3D/usb/md0.backup /dev/md0
> /dev/sda1 /dev/sdb1 /dev/sdc1 /dev/sdd1 /dev/sdf1 /dev/sdg1
>=20
> Unfortunately mdadm had decided that the backup-file was out of date
> (timestamps didn't match) and was erroring with: Failed to restore
> critical section for reshape, sorry..
>=20
> Chances are things were in such a mess that backup file wasn't going
> to be used anyway, so I blocked the timestamp check with: export
> MDADM_GROW_ALLOW_OLD=3D1
>=20
> That allowed me to assemble the array, but not run it as there were
> not enough disks to start it.

You probably just need to add "--force" to the assemble line.
So stop the array (mdamd -S /dev/md0) and assemble again with --force as we=
ll
as the other options.... or maybe don't.

I just tested that and I didn't do what it should.  I've hacked the code a
bit and can see what the problem is and think I can fix it.

So leave it a bit.  I'll let you know when you should  grab my latest code
and try that.


>=20
> This is the current state of the array:
>=20
> Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5]
> [raid4] [raid10]
> md0 : inactive sdb1[1] sdd1[5] sdf1[4] sda1[2]
> =C2=A0 =C2=A0 =C2=A0 7814047744 blocks super 0.91
>=20
> unused devices: <none>
>=20
> root@raven:/# mdadm --detail /dev/md0
> /dev/md0:
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 Version : 0.91
> =C2=A0 Creation Time : Tue Jul 12 23:05:01 2011
> =C2=A0 =C2=A0 =C2=A0Raid Level : raid6
> =C2=A0 Used Dev Size : 1953511936 (1863.01 GiB 2000.40 GB)
> =C2=A0 =C2=A0Raid Devices : 6
> =C2=A0 Total Devices : 4
> Preferred Minor : 0
> =C2=A0 =C2=A0 Persistence : Superblock is persistent
>=20
> =C2=A0 =C2=A0 Update Time : Tue Feb =C2=A07 09:32:29 2012
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 State : active, FAILED, Not Started
> =C2=A0Active Devices : 3
> Working Devices : 4
> =C2=A0Failed Devices : 0
> =C2=A0 Spare Devices : 1
>=20
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Layout : left-symmetric-6
> =C2=A0 =C2=A0 =C2=A0Chunk Size : 64K
>=20
> =C2=A0 =C2=A0 =C2=A0New Layout : left-symmetric
>=20
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0UUID : 9a76d1bd:2aabd685:1fc5fe0=
e:7751cfd7 (local to host raven)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Events : 0.1848341
>=20
> =C2=A0 =C2=A0 Number =C2=A0 Major =C2=A0 Minor =C2=A0 RaidDevice State
> =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0 0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A00 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0removed
> =C2=A0 =C2=A0 =C2=A0 =C2=A01 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0 =
17 =C2=A0 =C2=A0 =C2=A0 =C2=A01 =C2=A0 =C2=A0 =C2=A0active sync =C2=A0 /dev=
/sdb1
> =C2=A0 =C2=A0 =C2=A0 =C2=A02 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0 =
=C2=A01 =C2=A0 =C2=A0 =C2=A0 =C2=A02 =C2=A0 =C2=A0 =C2=A0active sync =C2=A0=
 /dev/sda1
> =C2=A0 =C2=A0 =C2=A0 =C2=A03 =C2=A0 =C2=A0 =C2=A0 0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A00 =C2=A0 =C2=A0 =C2=A0 =C2=A03 =C2=A0 =C2=A0 =C2=A0removed
> =C2=A0 =C2=A0 =C2=A0 =C2=A04 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0 =
81 =C2=A0 =C2=A0 =C2=A0 =C2=A04 =C2=A0 =C2=A0 =C2=A0active sync =C2=A0 /dev=
/sdf1
> =C2=A0 =C2=A0 =C2=A0 =C2=A05 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0 =
49 =C2=A0 =C2=A0 =C2=A0 =C2=A05 =C2=A0 =C2=A0 =C2=A0spare rebuilding =C2=A0=
 /dev/sdd1
>=20
> The two removed disks:
> [ 3020.998529] md: kicking non-fresh sdc1 from array!
> [ 3021.012672] md: kicking non-fresh sdg1 from array!
>=20
> Attempted to re-add the disks (same for both):
> root@raven:/# mdadm /dev/md0 --add /dev/sdg1
> mdadm: /dev/sdg1 reports being an active member for /dev/md0, but a
> --re-add fails.
> mdadm: not performing --add as that would convert /dev/sdg1 in to a spare.

Gee I'm glad I put that check in!


> mdadm: To make this a spare, use "mdadm --zero-superblock /dev/sdg1" firs=
t.
>=20
> With a failed array the last thing we want to do is add spares and
> trigger a resync so obviously I haven't zeroed the superblocks and
> added yet.

Excellent!

>=20
> Checked and two disks really are out of sync:
> root@raven:/# mdadm --examine /dev/sd[a-h]1 | grep Event
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Events : 1848341
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Events : 1848341
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Events : 1848333
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Events : 1848341
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Events : 1848341
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Events : 1772921

sdg1 failed first shortly after 01:06:46.  The reshape should have just
continued.  However every device has the same:

> =C2=A0 Reshape pos'n : 307740672 (293.48 GiB 315.13 GB)

including sdg1.  That implied that it didn't continue.  Confused.

Anyway, around 07:12:01, sdc1 failed. This will definitely have stopped the
reshape and everything else.

>=20
> I'll post the output of --examine on all the disks below - if anyone
> has any advice I'd really appreciate it (Neil Brown doesn't read these
> forums does he?!?). =C2=A0I would usually move next to recreating the arr=
ay
> and using assume-clean but since it's right in the middle of a reshape
> I'm not inclined to try.

Me?  No, I don't hang out here much...

>=20
> Critical stuff is of course backed up, but there is some user data not
> covered by backups that I'd like to try and restore if at all
> possible.

"backups" - music to my ears.

I definitely recommend an 'fsck' after we get it going again and there
could be minor corruption, but you will probably have everything back.

Of course I cannot promise that it won't just happen again when it hits
another read error.  Not sure what you can do about that.


So - stay tuned.

NeilBrown


--Sig_/DDolHabNEN=OXKyXFMDttIv
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTzCO8znsnt1WYoG5AQJM8A/6AsD6gnrsq+iKHzUdIfzVLFC6JvJ/TcjA
EzHR4aQ4U8om3azaBk3pfe1fkJYB/JcnHkRlJsCZVfbjDQQajVN40I92lZNPJn8o
GiyGELY10w/vwiXV/jOV/PzfD4Zw3l9terioK09lxW+Cs8EavBjqx5b2UsGvTXW/
/WDxi71DS/mnmLRL00s04aB2GX/GU7fCue1jKkIJJqEXP7/Mbxzf41htQmi14CC/
NnWUSiKw3bLUN2sPlSjZl5R+QEZ/INe5enSAL0qMd/LjNbgYap49j0sbB3HmUm7P
tQF2P8dkjTXhTkhKdK0hkQEVvha7QcJ9F9p7wd90bcHVqWR7qcS/3uenPsqjY0Ct
sUhg4xbI966CCfA0dTeT6SBSE3xM9WKPwirAlesTEdG4Gv4CBg/9thpgtFASamLM
7hhgcprP96h5dZIUpmi8KQhgyD8aKIEAPPU61EjB3vAcLqlYm+GE/ubGJ4pfv++H
LnkfWcue7inoxdtCAYq898r+wOcBjz5ho+jUp+ZatdcUhDOzoMVRM5YtwstaVgxF
4fKqprghPVJDGGdyGyw1srdiVCFCRmIV7QEj+3gP7mbo7t8GtqMfEot5YxHNia4E
dMVp4JgspKEsSiuZVVCdhhurSJoik8gnMIYfOdrmHLAxdzFZzY8LOHgsAe4PeSNc
5l7gUQEvb44=
=zHPr
-----END PGP SIGNATURE-----

--Sig_/DDolHabNEN=OXKyXFMDttIv--
