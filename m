From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] md/raid5:Add "BlockedBadBlocks" flag when waitting rdev
 to be unlocked.
Date: Wed, 27 Jun 2012 13:45:13 +1000
Message-ID: <20120627134513.2a67fbb0@notabene.brown>
References: <201206181113442039690@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/PNYVlCmnyg+m+LCH.Bx.VpC"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201206181113442039690@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: majianpeng <majianpeng@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/PNYVlCmnyg+m+LCH.Bx.VpC
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 18 Jun 2012 11:13:48 +0800 majianpeng <majianpeng@gmail.com> wrote:

> If rdev became blocked because the unack badblocks, it did not exec=20
> md_wait_for_blocked_rdev in handle_stripe().So the rdev->nr_pending did
> not decrease.So rdev did not remove because the wrong nr_pending.
> Signed-off-by: majianpeng <majianpeng@gmail.com>
> ---
>  drivers/md/raid5.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
>=20
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index d267672..ed63261 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -3582,7 +3582,8 @@ static void handle_stripe(struct stripe_head *sh)
> =20
>  finish:
>  	/* wait for this device to become unblocked */
> -	if (conf->mddev->external && unlikely(s.blocked_rdev))
> +	if (unlikely(s.blocked_rdev) && (conf->mddev->external ||
> +		test_bit(BlockedBadBlocks, &(s.blocked_rdev->flags))))
>  		md_wait_for_blocked_rdev(s.blocked_rdev, conf->mddev);
> =20
>  	if (s.handle_bad_blocks)


Thanks for finding this.  However I don't think your patch is quite correct.
It would re-introduce a hang fixed by commit 43220aa0f22cd3ce5b3.

I've applied the following instead.

Thanks,
NeilBrown

=46rom 0cee6aeb02b1ef947be62bb455f64720ecba2b4c Mon Sep 17 00:00:00 2001
From: NeilBrown <neilb@suse.de>
Date: Wed, 27 Jun 2012 13:43:54 +1000
Subject: [PATCH] md/raid5: fix refcount problem when blocked_rdev is set.

commit 43220aa0f22cd3ce5b30246d50ccd696d119edea
    md/raid5: fix a hang on device failure.

fixed a hang, but introduced a refcounting in balance so
that if the presence of bad-blocks ever caused an rdev to
be 'blocked' we would increment the refcount on the rdev and
never decrement it.

So added the needed rdev_dec_pending when md_wait_for_blocked_rdev
is not called.

Reported-by: majianpeng <majianpeng@gmail.com>
Signed-off-by: NeilBrown <neilb@suse.de>

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index befadb4..e23cd59 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -3588,8 +3588,17 @@ static void handle_stripe(struct stripe_head *sh)
=20
 finish:
 	/* wait for this device to become unblocked */
-	if (conf->mddev->external && unlikely(s.blocked_rdev))
-		md_wait_for_blocked_rdev(s.blocked_rdev, conf->mddev);
+	if (unlikely(s.blocked_rdev)) {
+		if (conf->mddev->external)
+			md_wait_for_blocked_rdev(s.blocked_rdev,
+						 conf->mddev);
+		else
+			/* Internal metadata will immediately
+			 * be written by raid5d, so we don't
+			 * need to wait here.
+			 */
+			rdev_dec_pending(rdev, mddev);
+	}
=20
 	if (s.handle_bad_blocks)
 		for (i =3D disks; i--; ) {

--Sig_/PNYVlCmnyg+m+LCH.Bx.VpC
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT+qByTnsnt1WYoG5AQJfGg//c+sTuZxZowsMyECytL/npU/zOv8kHjFP
1o2BcO63B0Z/JjuKwzqBqAmWu4tnrmxHdjlnGCXFWHpz+LRoeGbjRvrTFEfW75Rm
kRw5SbG9krIXvEmnquz6pC22H0HZ1Ar7S1xTKUR4N76bkJmad7tiFbGwrq9TMCgh
VedBKlFObcs3GNQoN4e0EvdQ6jjmzo80hRgCFyF5VDxeT+Jmv0Nmz08HUHgcR7l3
SkA8zp5nY6DqLtR8saLkLVcjZ30XBXUoPAzHzk/mFI/indvBtzD580DzzmCfISnt
P1u5tMWKK/3YmejM4WNf0O6zqXUygmQLlHUDuQXdl1cSnksEZy8eR8pox1l9tW6T
WH3h/Bo4oR1UOXYVNwsvVSGZIevxs3tFYTQaybZklpooVJ90dQ7JPnwlmlCNozG3
CpVgzF4eN4iyYqzFUOu1ISNP8BAFTKHrewxbMVqaBm3tzloiAJOXd/Mbr4I449YM
QFNBo/s9i/PIQFy0dtY6hK5iBwM84E65RqJC6Lpo81FfNwftSuisf6OR6YJH6Aq+
OuwGDqd/t7AWWFkfw51A7vrrwcfnRYAH004QVMnwaOXau/XeuVRTMlFMNkItmhbz
ZjfZo8JrLJLjvUxm0JcO2j4C9fg8HenJcBeA8s0RiW5x/NLNWVWi0QZGgGoJjgYz
wVdzoBwgPks=
=U212
-----END PGP SIGNATURE-----

--Sig_/PNYVlCmnyg+m+LCH.Bx.VpC--
