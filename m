From: NeilBrown <neilb@suse.de>
Subject: Re: Set disk faulty / hot disk remove ioctl bug for read-only MD?
Date: Thu, 14 Feb 2013 08:55:21 +1100
Message-ID: <20130214085521.6efe814e@notabene.brown>
References: <alpine.DEB.2.02.1302121559540.11804@jlaw-desktop.mno.stratus.com>
	<20130213133820.6496b074@notabene.brown>
	<511B7CE6.5060806@profitbricks.com>
	<511BA386.30304@profitbricks.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/vIu_y+2yp8Lhme/H.vRyUGL"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <511BA386.30304@profitbricks.com>
Sender: linux-raid-owner@vger.kernel.org
To: Sebastian Riemer <sebastian.riemer@profitbricks.com>
Cc: Joe Lawrence <Joe.Lawrence@stratus.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/vIu_y+2yp8Lhme/H.vRyUGL
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 13 Feb 2013 15:30:30 +0100 Sebastian Riemer
<sebastian.riemer@profitbricks.com> wrote:

> On 13.02.2013 12:45, Sebastian Riemer wrote:
> > On 13.02.2013 03:38, NeilBrown wrote:
> >> diff --git a/drivers/md/md.c b/drivers/md/md.c
> >> index 8b557d2..292cc2f 100644
> >> --- a/drivers/md/md.c
> >> +++ b/drivers/md/md.c
> >> @@ -6529,7 +6529,17 @@ static int md_ioctl(struct block_device *bdev, =
fmode_t mode,
> >>  			mddev->ro =3D 0;
> >>  			sysfs_notify_dirent_safe(mddev->sysfs_state);
> >>  			set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
> >> -			md_wakeup_thread(mddev->thread);
> >> +			/* mddev_unlock will wake thread */
> >> +			/* If a device failed while we were read-only, we
> >> +			 * need to make sure the metadata is updated now.
> >> +			 */
> >> +			if (test_bit(MD_CHANGE_DEVS, &mddev->flags)) {
> >> +				mddev_unlock(mddev);
> >> +				wait_event(mddev->sb_wait,
> >> +					   !test_bit(MD_CHANGE_DEVS, &mddev->flags) &&
> >> +					   !test_bit(MD_CHANGE_PENDING, &mddev->flags));
> >> +				mddev_lock(mddev);
> >> +			}
> >>  		} else {
> >>  			err =3D -EROFS;
> >>  			goto abort_unlock;
> >>
> >=20
> > Thanks, Neil!
> >=20
> > I can confirm the issue on 3.4.y and that your patch fixes it reliably.
> >=20
> > Acked-by: Sebastian Riemer <sebastian.riemer@profitbricks.com>
> >=20
>=20
> Damn, I've got a kernel which still crashes in
> reap_sync_thread->raid1_spare_active() with NULL pointer dereference
> although this patch is applied. So the fix isn't correct, yet.
>=20
> I did some "objdump -S" on raid1.ko and found the issue at the following
> code location in raid1_spare_active():
> #	for (i =3D 0; i < conf->raid_disks; i++) {
> #		struct md_rdev *rdev =3D conf->mirrors[i].rdev;
> #		struct md_rdev *repl =3D conf->mirrors[conf->raid_disks + i].rdev;
>=20
> A resync was pending (create without --assume-clean).
> For me it looks like the faulty setting races with the syncer. The rdev
> isn't registered in the personality anymore but the syncer tries to
> access it for immediate resync.
>=20

Where exactly is it crashing?  Can I see the complete Oops message?
The code you have identified cannot crash unless conf->raid_disks has become
inconsistent with the allocation of ->mirrors, and that is very unlikely.
Both 'rdev' and 'repl' are tested for NULL before they are used...

If you can get me the Oops message I can probably narrow it down.

Thanks,
NeilBrown


--Sig_/vIu_y+2yp8Lhme/H.vRyUGL
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBURwLyTnsnt1WYoG5AQJU+g//VSnjS2ty2NuMscl7zMUshhrC/z+g6MTJ
tBStoZ0XYjsx3TP4NL/WVSVqsuSKqUb8cbn1gKnLn0w0ZUTBnFrE0sgajKih1jA+
pTUzYuN4uymrC3Sby5pOErAKtCllCaI3WRJqgUIObbJG1qJKy7Z7A/TLsQIaZe63
4tD/8fIEFgLRbfJ5GSV+UfvDBZTGwhIiI/H1YiYNivrudg7P+dV4rkVZ4/glSy2U
epcwVaFRk+0+NLZKVvvUb+eq0fNFspIdTaYYNbZtGO1yV8eAGOg6dLuQ+gBobdoO
/UA3oODk+Hi1NpDZy9BU0BbwRJObma5VMNXPxz5ThczhX8nFmchXFJG+i342gnvA
Q84feLRiXt6+a8i/w6j5N/IxpcbQ2qGg36IPl1ow/yhbW9beLa3sXzgU5A7mHYuq
ktlxmqBPLKYixCPUuLxnnMejZI/K8l7Bh3qF8yp5PDl+q4tfdG12zSBrkm6rfs0w
PeaGO0+TSTB31k33/2ZJrIMhYcmZAcyePLoiKW7bQ50ER80hWTToo3RJwvUF8YSW
cGwpidiuTufi5wQaX2XZK2TCzYhDmUfzY/z/1gW2tacFrmVvjesLgTcFWpp+Z27J
GuihcQeZlOPyt2M4xzoKqnR0cUlIt6jY0tlMeUwbdoriz7gBvNx7qIdtgMGV671M
+Fn9SNpi3Sw=
=WxoW
-----END PGP SIGNATURE-----

--Sig_/vIu_y+2yp8Lhme/H.vRyUGL--
