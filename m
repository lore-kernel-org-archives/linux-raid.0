From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH] drivers/md/md.c: ignore recovery_offset if bitmap exists
Date: Sat, 31 Oct 2015 11:26:36 +1100
Message-ID: <87y4ejvq6b.fsf@notabene.neil.brown.name>
References: <1438111733-17778-1-git-send-email-nate.dailey@stratus.com> <55B93B9D.5000103@stratus.com> <55CE0207.1020707@stratus.com> <87r3kdvzl5.fsf@notabene.neil.brown.name> <563370F8.3070100@stratus.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <563370F8.3070100@stratus.com>
Sender: linux-raid-owner@vger.kernel.org
To: Nate Dailey <nate.dailey@stratus.com>, linux-raid@vger.kernel.org
Cc: Jes.Sorensen@redhat.com
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, Oct 31 2015, Nate Dailey wrote:

> I first tested 4.3-rc6 that I already had laying around, and verified tha=
t the=20
> bug still happens.
>
> Then I reverted 7eb418851f3278de67126ea0c427641ab4792c57, rebuilt & insta=
lled,=20
> and tested again. Reverting this patch did indeed fix the bug.
>
> Thank you!
>
> Nate
>

Thanks a lot for testing.
The following with go to Linus soon, hopefully in time for 4.3-final.
It should then be picked up by stable.

If anyone wants to try their hand at the "future patch" I mentioned, I
wouldn't object. MD_FEATURE_RECOVERY_BITMAP is an important part of the
picture.  I won't have an opportunity to work on it until December.

Thanks,
NeilBrown


commit d01552a76d71f9879af448e9142389ee9be6e95b
Author: NeilBrown <neilb@suse.com>
Date:   Sat Oct 31 11:00:56 2015 +1100

    Revert "md: allow a partially recovered device to be hot-added to an ar=
ray."
=20=20=20=20
    This reverts commit 7eb418851f3278de67126ea0c427641ab4792c57.
=20=20=20=20
    This commit is poorly justified, I can find not discusison in email,
    and it clearly causes a problem.
=20=20=20=20
    If a device which is being recovered fails and is subsequently
    re-added to an array, there could easily have been changes to the
    array *before* the point where the recovery was up to.  So the
    recovery must start again from the beginning.
=20=20=20=20
    If a spare is being recovered and fails, then when it is re-added we
    really should do a bitmap-based recovery up to the recovery-offset,
    and then a full recovery from there.  Before this reversion, we only
    did the "full recovery from there" which is not corect.  After this
    reversion with will do a full recovery from the start, which is safer
    but not ideal.
=20=20=20=20
    It will be left to a future patch to arrange the two different styles
    of recovery.
=20=20=20=20
    Reported-and-tested-by: Nate Dailey <nate.dailey@stratus.com>
    Signed-off-by: NeilBrown <neilb@suse.com>
    Cc: stable@vger.kernel.org (3.14+)
    Fixes: 7eb418851f32 ("md: allow a partially recovered device to be hot-=
added to an array.")

diff --git a/drivers/md/md.c b/drivers/md/md.c
index c702de18207a..3fe3d04a968a 100644
=2D-- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -8040,8 +8040,7 @@ static int remove_and_add_spares(struct mddev *mddev,
 		       !test_bit(Bitmap_sync, &rdev->flags)))
 			continue;
=20
=2D		if (rdev->saved_raid_disk < 0)
=2D			rdev->recovery_offset =3D 0;
+		rdev->recovery_offset =3D 0;
 		if (mddev->pers->
 		    hot_add_disk(mddev, rdev) =3D=3D 0) {
 			if (sysfs_link_rdev(mddev, rdev))

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWNAq8AAoJEDnsnt1WYoG54Z4P/3Km+CW6e/Qcd3dqS1ute7XV
1dp+Fj+xexgHvARjxki1a0jQ6n4exqQ4QTuOL9ajgSmXUbju44hD1RCBCdygOShF
QryLvzXJGjcLjjYF18Zw8+XtnoXlOh+mwpEQVznd5SfyaiC5nnsxnSfJrVt2yGqY
sp62JKXVLh83CocwozhjZqsuoHJs+7H0Q8Svx6I13LZcxTFDHid3OAYUAUagatya
ABohfvm+T9Aa35yvLSu0sR398Jw+jR4WD53KMyYdey8usU00Q9Sl1D9CWloOGH2R
BgL9jFnXKyRruFB4eeAXJAgluhwmkQFpJ4O/UO+w2PiAWU1q1KCXBfy1hb0k+FTi
VsiEo+KeXgjuZitzNw9Xqv7vHSf7ni7ZkWXogH6TMpiK4ATyCdeQh948Yp+IcviR
pkIsD+6L9n31ylC0tm9yT67QMR4HeVo5dciTmB75R/dN5rOKHZunlbUmepGGsLBB
DWxrWZPR0lz8HpXNZfNwt6t6da84bKlnCsUbuCua8A29T6wp6vaNHn3CFvFm/2Ff
PK4F+z7u+ihTZSWzBO7bfcVvS+V01hXcIPzGhyT+QcKiywUA0BEkg5gz/8G8pyAn
pNliyLMjDfNt10Ws/YHhYhWS3JxxbaJpVhRdoi1znOep+jKLYQGSlpFYpF4OQ/3G
N6XXtK9Q8EKT/J5VVXbN
=39AF
-----END PGP SIGNATURE-----
--=-=-=--
