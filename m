From: NeilBrown <neilb@suse.de>
Subject: Re: RAD1 doesn't fail WRITE that was written only on a rebuilding
 drive
Date: Tue, 4 Jun 2013 10:04:03 +1000
Message-ID: <20130604100403.2052b5ce@notabene.brown>
References: <CAGRgLy6tHN7ZPwxxRM4pzVbKP5fS0PLeXrhKoeZ0XJqVrb0pVQ@mail.gmail.com>
	<CAGRgLy6qAmn8Fx08BPoAp7uYqWdO4KHuTqkmbTGHAGkWhWF9sg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/TVP5J17R/kNncvAxfha3Vpx"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGRgLy6qAmn8Fx08BPoAp7uYqWdO4KHuTqkmbTGHAGkWhWF9sg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Alexander Lyakas <alex.bolshoy@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/TVP5J17R/kNncvAxfha3Vpx
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 28 May 2013 23:12:38 +0300 Alexander Lyakas <alex.bolshoy@gmail.com>
wrote:

> Hi Neil,
> I have found why recovery is triggered again and again.
>=20
> After initial recovery aborts, raid1d() calls md_check_recovery(),
> which calls remove_and_add_spares().
> So remove_and_add_spares wants to eject the rebuilding drive from the
> array, but cannot because rdev->nr_pending>0:
> 		if (rdev->raid_disk >=3D 0 &&
> 		    !test_bit(Blocked, &rdev->flags) &&
> 		    (test_bit(Faulty, &rdev->flags) ||
> 		     ! test_bit(In_sync, &rdev->flags)) &&
> 		    atomic_read(&rdev->nr_pending)=3D=3D0) {
> if (mddev->pers->hot_remove_disk(
> ...
>=20
> So instead it goes ahead and triggers another recovery in the
> following condition (by incrementing "spares"):
> 	rdev_for_each(rdev, mddev) {
> 		if (rdev->raid_disk >=3D 0 &&
> 		    !test_bit(In_sync, &rdev->flags) &&
> 		    !test_bit(Faulty, &rdev->flags))
> 			spares++;
>=20
> So another recovery starts, aborts, is triggered again, aborts and so for=
th.
>=20
> Because conditions:
> test_bit(Faulty, &rdev->flags) || ! test_bit(In_sync, &rdev->flags)
> and
> !test_bit(In_sync, &rdev->flags) &&  !test_bit(Faulty, &rdev->flags))
> can both be true at the same time.
>=20
> Problem is that IOs keep coming in, because MD does not fail them as I
> discussed in the previous email. So nr_pending never gets to zero, or
> it takes it a long time to get to zero (totally racy), and we keep
> triggering and aborting recovery.
>=20
> Can we fix remove_and_add_spares() the following way:
>=20
> "if a drive qualifies for being removed from array, but cannot be
> removed because of nr_pending, don't try to trigger another recovery
> on it by returning doing spares++".

I'm not sure...  While that approach would address this particular problem
I'm not convinced that it would always be correct.

The 'recovery_disabled' field is supposed to stop this sort of thing, but it
doesn't get activated here because it only stops the adding of devices to t=
he
array, and we never add a device.

I would probably remove the nr_pending test from remove_add_and_spares and
leave it to the personality routine to do that test (I think they already d=
o).
Then get ->hot_remove_disk to have a particular error status which means
"don't try any recovery", which is returned if the ->recovery_disabled fiel=
ds
match.
Then remove_and_add_spares need to check for this return value and act
accordingly.
Something like that.

Do you think that would  work?

Thanks,
NeilBrown


--Sig_/TVP5J17R/kNncvAxfha3Vpx
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUa0u8znsnt1WYoG5AQIYDw/9HJ6KdT2gDFz1o89mPlddHpV9vIfMycD6
lrLRIoKyamheYjrToW9Ok9Xiqbh86rAQ4CGwB85/WaZ5iFwyMO6NRbilPKvxFMle
SEfMlLxJ/0oCtGV7NF13nJwMSB6JJmhMqaGnH7zj6EOegOQDh76yS+ZZvFQE4q9u
7fORWx5+7SXTA62UsJaEhYIOx5VykEXrx9udtH/lGpi3toImzmhsAk1qvOUhdhFB
xMsgUG+WCl+MA6rI3y8ih7hTthtgDb4dSVcsznlfUhsTmegZFeG8Cl37SDiYGXmr
B5v0xmNVhjjjPTeDBJHPlm/a06r6hlSrz9YB9KF8dDRSPxTCyC3rIxIRJ876nXhx
FmRL0LS78I/uAGrI8PIhbUV0bzc/7rtof2s/9Fnt5hKxVhuqo3VgGG4Q2rnEUYe7
PoM9B3/Ew6cuAiR3b5hpWCASNJpjCeAIzBw03fdM/iKgewSVpnkJmGz0hNmLPvAV
UCZPbdMi3h3OmKLTTk00oYZ3sv8nFCsHijetCCA3RWcrGhL5CJap1Vs9JYeuzJXZ
qxe3WZI9YDGfr9bpYDL3WkCMLJsdFOkJjVu40MdqMM7Og/NIMeZVmTP+2RUjyMNU
0TvCsx44Y2fNwL4eea3Y9ajSGBKmeVCDobBTDJ5azIH5FTtvrBt+bzjtlKPDVknE
zZGIK5hhpJY=
=mKIx
-----END PGP SIGNATURE-----

--Sig_/TVP5J17R/kNncvAxfha3Vpx--
