From: NeilBrown <neilb@suse.de>
Subject: Re: Reshape Shrink Hung Again
Date: Thu, 9 May 2013 16:16:01 +1000
Message-ID: <20130509161601.5804059f@notabene.brown>
References: <96A49024-A8A7-4ED9-82B1-5AE430374EBE@bingner.com>
	<20130422072414.3e30882c@notabene.brown>
	<7A4C666A-D95E-41AB-96B2-5E75097D8BBB@bingner.com>
	<20130506152926.067d3459@notabene.brown>
	<F83D995D-967D-4D89-9CE9-46A0305290C6@bingner.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/_0.rW8Dar3454.WTuW/1hJy"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <F83D995D-967D-4D89-9CE9-46A0305290C6@bingner.com>
Sender: linux-raid-owner@vger.kernel.org
To: Sam Bingner <sam@bingner.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/_0.rW8Dar3454.WTuW/1hJy
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 6 May 2013 06:36:29 +0000 Sam Bingner <sam@bingner.com> wrote:

> On May 5, 2013, at 7:29 PM, NeilBrown <neilb@suse.de> wrote:
>=20
> > On Wed, 1 May 2013 02:00:30 +0000 Sam Bingner <sam@bingner.com> wrote:
> >=20
> >> On Apr 21, 2013, at 11:24 AM, NeilBrown <neilb@suse.de> wrote:
> >>=20
> >>> On Fri, 19 Apr 2013 08:29:37 +0000 Sam Bingner <sam@bingner.com> wrot=
e:
> >>>=20
> >>>> I'll start this off by saying that no data is in jeopardy, but I wou=
ld like to track down the cause of this problem and fix it.  I originally t=
hought it must have been due to the incorrect backup-file size with a raid =
array shrunk to smaller than the final size when it happened to me last tim=
e but this time this was not the case.
> >>>>=20
> >>>> I initiated a shrink from a 4-drive RAID5 to a 3-drive RAID5, this s=
hrink had no problems except that a drive failed right at the end of the re=
shape... then it hung at 99.9% and does not allow me to remove the failed d=
rive from the array because it is "rebuilding".  I am not sure if the drive=
 failed at the end, or if it was after it had gotten to 99.9% because I did=
n't see this until the next morning as it ran overnight.
> >>>>=20
> >>>> Sam
> >>>>=20
> >>>> root@fs:/var/log# uname -a
> >>>> Linux fs 2.6.32-5-686 #1 SMP Mon Jan 16 16:04:25 UTC 2012 i686 GNU/L=
inux
> >>>>=20
> >>>> Apr 17 22:37:41 fs kernel: [25860779.639762] md1: detected capacity =
change from 749122093056 to 499414728704
> >>>> Apr 17 22:38:40 fs kernel: [25860837.912441] md: reshape of RAID arr=
ay md1
> >>>> Apr 17 22:38:40 fs kernel: [25860837.912447] md: minimum _guaranteed=
_  speed: 1000 KB/sec/disk.
> >>>> Apr 17 22:38:40 fs kernel: [25860837.912452] md: using maximum avail=
able idle IO bandwidth (but not more than 200000 KB/sec) for reshape.
> >>>> Apr 17 22:38:40 fs kernel: [25860837.912459] md: using 128k window, =
over a total of 243854848 blocks.
> >>>> Apr 18 07:51:09 fs kernel: [25893987.273813] raid5: Disk failure on =
sda2, disabling device.
> >>>> Apr 18 07:51:09 fs kernel: [25893987.273815] raid5: Operation contin=
uing on 2 devices.
> >>>> Apr 18 07:51:09 fs kernel: [25893987.287168] md: super_written gets =
error=3D-5, uptodate=3D0
> >>>> Apr 18 07:51:10 fs kernel: [25893987.657039] md: md1: reshape done.
> >>>> Apr 18 07:51:10 fs kernel: [25893987.781599] md: reshape of RAID arr=
ay md1
> >>>> Apr 18 07:51:10 fs kernel: [25893987.781607] md: minimum _guaranteed=
_  speed: 100 KB/sec/disk.
> >>>> Apr 18 07:51:10 fs kernel: [25893987.781613] md: using maximum avail=
able idle IO bandwidth (but not more than 200000 KB/sec) for reshape.
> >>>> Apr 18 07:51:10 fs kernel: [25893987.781620] md: using 128k window, =
over a total of 243854848 blocks.
> >>>>=20
> >>>>=20
> >>>> md1 : active raid5 sdd2[3] sda2[0](F) sdc2[2] sdb2[4]
> >>>>     487709696 blocks super 1.2 level 5, 512k chunk, algorithm 2 [3/2=
] [_UU]
> >>>>     [=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D>.]  r=
eshape =3D 99.9% (243853824/243854848) finish=3D343.6min speed=3D0K/sec
> >>>>=20
> >>>=20
> >>> Looks like a bug - probably in mdadm.
> >>> mdadm needs to help the reshape over the last little bit, and md is p=
robably
> >>> waiting for it to do that.  This will be the only time in the whole p=
rocess
> >>> when the backup file is used.
> >>>=20
> >>> I would try stopping the array and re-assembling it.  That might requ=
ire a
> >>> reboot.  If that doesn't fix it, let me know and I'll prioritise this.
> >>> Otherwise - I've put it on my to-do list.  I'll try to reproduce and =
fix it
> >>> in due course.
> >>>=20
> >>> Thanks for the report,
> >>> NeilBrown
> >>=20
> >> Sorry for the delay in responding, the server was at a remote location=
 and didn't have a remote console.  My attempt to make an initrd that provi=
ded me SSH failed for unknown reasons (it works now that I've got physical =
access to the server).  Based on the results below, it looks like the drive=
 that did drop out was pretty much at the very end and I really don't think=
 it was related to the error.  I can leave the system in this state and get=
 you access to it to see if you desire.  This system was in the process of =
being decommissioned and soon after the failure the replacement came in.  T=
his same error happened to me twice, but I also did another reshape where i=
t didn't happen.  I can play with this system and try to duplicate it again=
 also.  As I said, I'll be happy to do anything to help find the source of =
this.=20
> >>=20
> >> In any case, here is what happened from initramfs:
> >=20
> > Thanks.
> > It looks like sda2 (first device in array) failed shortly after Thu Apr=
 18
> > 11:49:51 2013 when there was still 13MB to be reshaped.
> > Then the reshape froze with only 2MB to go.  Don't know why yet.
> >=20
> > Could yo retry the assemble command with --verbose added?
> > i.e.
> >  mdadm.static --assemble /dev/md0 --backup-file=3D/boot/backup.md --ver=
bose
> >=20
> > The=20
> >   export MDADM_GROW_ALLOW_OLD=3D1
> > and try again.
> > If that doesn't start the array, try adding
> >   --invalid-backup
> >=20
> > and report the results.
> >=20
> > Thanks.
> >=20
> > NeilBrown
> >=20
>=20
> The backup.md file is all zeroes (and seems to have always been since it =
only uses it at the end?)  The --invalid-backup option seemed to work, but =
I guess then the question is why it was expecting valid data if it never pu=
t anything there to start with?  It seems to have actually happily backed u=
p the 3MB after being told to accept an invalid backup...
>=20
> I'm thinking it somehow froze originally trying to restore a backup that =
it never made?
>=20
> Sam
>=20
> # ./mdadm.static --assemble --force --verbose /dev/md1 --backup-file=3D/b=
oot/backup.md
> mdadm: looking for devices for /dev/md1
> mdadm: /dev/sdd2 is identified as a member of /dev/md1, slot 3.
> mdadm: /dev/sdc2 is identified as a member of /dev/md1, slot 2.
> mdadm: /dev/sdb2 is identified as a member of /dev/md1, slot 1.
> mdadm: /dev/sda2 is identified as a member of /dev/md1, slot 0.
> mdadm:/dev/md1 has an active reshape - checking if critical section needs=
 to be restored
> mdadm: No backup metadata on /boot/backup.md
> mdadm: Failed to find backup of critical section
> mdadm: Failed to restore critical section for reshape, sorry.
>=20
> # export MDADM_GROW_ALLOW_OLD=3D1
> # ./mdadm.static --assemble --force --verbose /dev/md1 --backup-file=3D/b=
oot/backup.md=20
> mdadm: looking for devices for /dev/md1
> mdadm: /dev/sdd2 is identified as a member of /dev/md1, slot 3.
> mdadm: /dev/sdc2 is identified as a member of /dev/md1, slot 2.
> mdadm: /dev/sdb2 is identified as a member of /dev/md1, slot 1.
> mdadm: /dev/sda2 is identified as a member of /dev/md1, slot 0.
> mdadm:/dev/md1 has an active reshape - checking if critical section needs=
 to be restored
> mdadm: No backup metadata on /boot/backup.md
> mdadm: Failed to find backup of critical section
> mdadm: Failed to restore critical section for reshape, sorry.
>=20
> # ./mdadm.static --assemble --force --verbose /dev/md1 --backup-file=3D/b=
oot/backup.md --invalid-backup
> mdadm: looking for devices for /dev/md1
> mdadm: /dev/sdd2 is identified as a member of /dev/md1, slot 3.
> mdadm: /dev/sdc2 is identified as a member of /dev/md1, slot 2.
> mdadm: /dev/sdb2 is identified as a member of /dev/md1, slot 1.
> mdadm: /dev/sda2 is identified as a member of /dev/md1, slot 0.
> mdadm:/dev/md1 has an active reshape - checking if critical section needs=
 to be restored
> mdadm: No backup metadata on /boot/backup.md
> mdadm: Failed to find backup of critical section
> mdadm: continuing without restoring backup
> mdadm: added /dev/sda2 to /dev/md1 as 0 (possibly out of date)
> mdadm: added /dev/sdc2 to /dev/md1 as 2
> mdadm: added /dev/sdd2 to /dev/md1 as 3
> mdadm: added /dev/sdb2 to /dev/md1 as 1
> mdadm: Need to backup 3072K of critical section..
> mdadm: /dev/md1 has been started with 3 drives (out of 4).
>=20
> # cat /proc/mdstat=20
> Personalities : [raid1] [raid6] [raid5] [raid4]=20
> md1 : active raid5 sdb2[4] sdd2[3] sdc2[2]
>       487709696 blocks super 1.2 level 5, 512k chunk, algorithm 2 [3/2] [=
_UU]
>       [>....................]  recovery =3D  0.0% (167432/243854848) fini=
sh=3D121.2min speed=3D33486K/sec


The backup.md file really should not have been empty.
Assuming you are sure it was the right file something must have gone wrong.
Not overly surprising as it is hard to test that particular stage of reshap=
e:
an interruption to the reshape very late in a shrink could get messy.

I've made a note to try testing it when I next spend some time on mdadm.

Thanks,
NeilBrown


--Sig_/_0.rW8Dar3454.WTuW/1hJy
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUYs/ITnsnt1WYoG5AQIeZQ//USpovh43zxEQy6fr0JW7Kx3RjkS0naSJ
zdwi18OAjcY7hULXohbOT/uGKZ1wrR1zKdN2JXy7ORCoZ2DY8GzCnQhqE+gRlps4
ISAApoNgZzNlEbTgRTRG8/i5mfwtuur6vQZvUIRQdObbG4Yk5GyiUvzq70qeDU4p
Ia8gR4rvTCzG8wOdqOzX7eDRxwlpKabSn5wQFxjI3ppQKQCmWlRxILKdkbp3L7Uc
+YN5npl9F+QabQdZxodjE5CM4u23a5XyD1WsAOttZjpkHdeP26TLbXsESq1PVF9F
NcOILXuiqUv+I/w2KOO2jvaiPQtDhdf0cd1Byq+keVbtGsb5wGDwwnklPZlPmovj
3PagQYfRFHa2szFwDRJCSF08mXEuoAkT6EyZS3m5YEU/cH++afr3zyoTvghgMyOG
i8JCd+JoepmYjJf09EFW7BfYvoAQu2b1TN9A0pfK7726QgoFHN8fA6iZ09nDqpDt
Hy3F2ZzL4Ox3zA0PU6WIyGUsGLs3K1TT+O22JQmlpQKoGYyoJIcJTJbB805ivpua
6ggBRjNkwu2lvGqL3+3qyrDN+XZF6gY5oJrA2axDwFpuIewWWXu5hD/S2PrRHxQH
6bz/69aoCQe3H1JtSN+Qe7rDFJicg9mec+ZA8rMALB1gggAP746SK+wnPcta0G8P
oe6h9iSG+qY=
=EDs9
-----END PGP SIGNATURE-----

--Sig_/_0.rW8Dar3454.WTuW/1hJy--
