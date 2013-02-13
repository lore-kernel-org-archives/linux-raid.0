From: NeilBrown <neilb@suse.de>
Subject: Re: Set disk faulty / hot disk remove ioctl bug for read-only MD?
Date: Wed, 13 Feb 2013 13:38:20 +1100
Message-ID: <20130213133820.6496b074@notabene.brown>
References: <alpine.DEB.2.02.1302121559540.11804@jlaw-desktop.mno.stratus.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/5VNkmRB1Sa5.Z+xhAXPeRat"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.02.1302121559540.11804@jlaw-desktop.mno.stratus.com>
Sender: linux-raid-owner@vger.kernel.org
To: Joe Lawrence <Joe.Lawrence@stratus.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/5VNkmRB1Sa5.Z+xhAXPeRat
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 12 Feb 2013 16:05:18 -0500 (EST) Joe Lawrence
<Joe.Lawrence@stratus.com> wrote:

> Hi Neil,
>=20
> I believe I found a bug when failing and removing component devices from=
=20
> read-only and auto-read-only MD RAID devices.

Thanks for reporting them!

>=20
> Prior to commit 1ca69c4b "md: avoid taking the mutex on some ioctls", when
> failing a read-only MD device component via mdadm --fail, EROFS was
> returned.  Failing (and removing) auto-read-only components was permitted.

I wonder what we really want here....
Given that a read error on a read-only array will mark the device as faulty,
it seems fair to allow "--fail" to also mark a device as faulty on a
read-only array.
Do you have a particular preference for having "mdadm --fail" fail with ERO=
FS
on a readonly array?


>=20
> After the change, MD allows the failure of component devices for both
> read-only and auto-read-only RAID devices.  Running mdadm --remove will
> return EROFS when attempted on a read-only device.

I suspect this is preferred behaviour.

>=20
> It gets a little interesting when trying to remove a component from an
> auto-read-only MD.  The *first* attempt will fail with EBUSY as the rdev
> was left in the Blocked state by the SET_DISK_FAULTY ioctl.  However,
> because the HOT_REMOVE_DISK ioctl made it through to the "switch to rw mo=
de
> if started auto-readonly" code, it has been transitioned to read-write.=20
> Subsequent trips through the device's mddev->thread may clear the Blocked
> flag via md_update_sb (should the reconfig_mutex be available).  A second=
 or
> third attempt at removing the failed component from the auto-read-only MD
> would then succeed.

This definitely a bit odd.
In general "--remove" can fail with EBUSY for a short while after the
failure, but this happens after an arbitrary delay.

I think we just want to allow the "set to read-write" process to complete
cleanly before trying the actual removal.  Patch below seems to work for me.
Can you confirm please?

Thanks,
NeilBrown


diff --git a/drivers/md/md.c b/drivers/md/md.c
index 8b557d2..292cc2f 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -6529,7 +6529,17 @@ static int md_ioctl(struct block_device *bdev, fmode=
_t mode,
 			mddev->ro =3D 0;
 			sysfs_notify_dirent_safe(mddev->sysfs_state);
 			set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
-			md_wakeup_thread(mddev->thread);
+			/* mddev_unlock will wake thread */
+			/* If a device failed while we were read-only, we
+			 * need to make sure the metadata is updated now.
+			 */
+			if (test_bit(MD_CHANGE_DEVS, &mddev->flags)) {
+				mddev_unlock(mddev);
+				wait_event(mddev->sb_wait,
+					   !test_bit(MD_CHANGE_DEVS, &mddev->flags) &&
+					   !test_bit(MD_CHANGE_PENDING, &mddev->flags));
+				mddev_lock(mddev);
+			}
 		} else {
 			err =3D -EROFS;
 			goto abort_unlock;

--Sig_/5VNkmRB1Sa5.Z+xhAXPeRat
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBURr8nDnsnt1WYoG5AQKqdxAAxKgEtG9enXy2VpntFmvI2Oag+pe9GdkB
U2rMhJ7PCQWr1eqwAx5nRf8LuK0Ca/kNsdbPsqDsqLKmJTQfGmg2tT6b7/w4BjmW
L4T/G5nwOddktpy8KCci1Cp8w+dGhcE+wJPaz80plsDaOZomc5ipgk3/x2vU7xeu
D6+JQKa42LWesmWXO9SLPzlGfviiA1ZeLPw1pPruc5zTqiPkz/VAc475iW55utgx
1jbFTC5d1FVpP3/KwiEYjtgGcpBN/+plJvj96pAgU5wWRBIjpKeokFkJZ+amkFpS
5nokP2WBIqJJYt27nS0OrqU0L7b/V9kcQBSwZWoH9D2mwtOJrkaz3tZc0dKH8wgs
MYt2VLRSGuKQweD4rA9kG3Cu7JuosPRA68ppG6w1Ekn7oJrv9FEjYLN7p4hBl4/b
vYBTUtKYW6ZEu/lo88R/K26b7O+Z6V8uK62mc+6miZbERIjzwIeLAJm2oWtMn+pe
V4JDQ/s3diZCgjTLOQxV4x2aVV35Pe+W3xwTqwO3vPptpu2zjDxyzAwdt74uKoAv
C3P0AcSxA84zvpww+p5sTA2SsfHZq5d62HQ0jX+X7htRBnNrYcscQpzur/k/jQBy
W+S3yp5qr+Nv5X7k9qlju9S6Ps0Smj3x31SQcC3T9Mt4nT+1y3Sbu5fiZ7nxogGI
JWrn02ijvZo=
=lcfW
-----END PGP SIGNATURE-----

--Sig_/5VNkmRB1Sa5.Z+xhAXPeRat--
