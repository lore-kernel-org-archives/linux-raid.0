From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 2/2 V1] raid5: For odirect-write performance, not set
 STRIPE_PREREAD_ACTIVE.
Date: Tue, 17 Jul 2012 12:02:09 +1000
Message-ID: <20120717120209.6b9591ce@notabene.brown>
References: <2012071616325740688511@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/AUpcoV3Nq/_=1l26TgxdctW"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <2012071616325740688511@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: majianpeng <majianpeng@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>, viro <viro@ZenIV.linux.org.uk>
List-Id: linux-raid.ids

--Sig_/AUpcoV3Nq/_=1l26TgxdctW
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 16 Jul 2012 16:33:02 +0800 majianpeng <majianpeng@gmail.com> wrote:

> Using flag REQ_NOIDLE to difference odirect-write and sync_write.
>=20
> Signed-off-by: Jianpeng Ma <majianpeng@gmail.com>
> ---
>  drivers/md/raid5.c |    5 ++++-
>  1 files changed, 4 insertions(+), 1 deletions(-)
>=20
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 04348d7..29edaf0 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -4113,7 +4113,10 @@ static void make_request(struct mddev *mddev, stru=
ct bio * bi)
>  			finish_wait(&conf->wait_for_overlap, &w);
>  			set_bit(STRIPE_HANDLE, &sh->state);
>  			clear_bit(STRIPE_DELAYED, &sh->state);
> -			if ((bi->bi_rw & REQ_SYNC) &&
> +			/* Difference odirect-write between regular file
> +			 * and block-device
> +			 */
> +			if ((bi->bi_rw & REQ_NOIDLE) &&
>  			    !test_and_set_bit(STRIPE_PREREAD_ACTIVE, &sh->state))
>  				atomic_inc(&conf->preread_active_stripes);
>  			mddev_check_plugged(mddev);


Thanks.
I've improved that patch description and remove the code comment and I don't
think it is helpful.

NeilBrown


=46rom c6e353648f062901f435f67b91e9438897d42ddf Mon Sep 17 00:00:00 2001
From: majianpeng <majianpeng@gmail.com>
Date: Tue, 17 Jul 2012 12:00:35 +1000
Subject: [PATCH] md/raid5: For odirect-write performance, do not set
 STRIPE_PREREAD_ACTIVE.

'sync' writes set both REQ_SYNC and REQ_NOIDLE.
O_DIRECT writes set REQ_SYNC but not REQ_NOIDLE.

We currently assume that a REQ_SYNC request will not be followed by
more requests and so set STRIPE_PREREAD_ACTIVE to expedite the
request.
This is appropriate for sync requests, but not for O_DIRECT requests.

So make the setting of STRIPE_PREREAD_ACTIVE conditional on REQ_NOIDLE
rather than REQ_SYNC.  This is consistent with the documented meaning
of REQ_NOIDLE:

        __REQ_NOIDLE,           /* don't anticipate more IO after this one =
*/

Signed-off-by: Jianpeng Ma <majianpeng@gmail.com>
Signed-off-by: NeilBrown <neilb@suse.de>

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 0e4439e..ee492a8 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -4187,7 +4187,7 @@ static void make_request(struct mddev *mddev, struct =
bio * bi)
 			finish_wait(&conf->wait_for_overlap, &w);
 			set_bit(STRIPE_HANDLE, &sh->state);
 			clear_bit(STRIPE_DELAYED, &sh->state);
-			if ((bi->bi_rw & REQ_SYNC) &&
+			if ((bi->bi_rw & REQ_NOIDLE) &&
 			    !test_and_set_bit(STRIPE_PREREAD_ACTIVE, &sh->state))
 				atomic_inc(&conf->preread_active_stripes);
 			release_stripe_plug(mddev, sh);

--Sig_/AUpcoV3Nq/_=1l26TgxdctW
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUATHoTnsnt1WYoG5AQIvgBAAnQZ/2CdSwXfsfF1SLz1yCsOH0k9Fe67L
Nz1q9MpuDD/UH7bt7ntyUeiXRJM1dM5oOsI26loQsl1OjnO+2zhzYYiuYynnt1bA
9J8GZO92w1cQFM6v1DEbeuLMC44lKW9qvZciL5HGKyCoyQTMC2CiWV9gfpk+pUiQ
i1p4Uvubb0WWx4jRAqVKVofIsq9eolJ8oG+jsQSQKCideSyAdgotoZ1e6lKRaylS
rGondvR2hGoxWbagYsQa1L+hhu9hBEwjhDMjjRb+VuIluZ72XZJLj6aGZbdivYcC
MYUt/MkdlMOdrvu7SAsMS+82e2PleX2MLNzwBPF4FXGHqorWufZE24iv3rDUn1GP
vY22y9mKODo1Vd5aBXN39nHcJXpoqmD7H57iSH7VI0TBp0LCniAVsf1dWmTyEFFe
rtDkKw/i0+GK8upOtHBZZEXINVAk1nkU8/UZidKr7yxYpx2GJN8fN7Xy39opwKsC
hKxagUV7N2jnP8Cg/CRZyRp5VVPZ3fz4hxn4+3IYTHUlshkFUOmaoxwE9gvAgQYo
Sf1aYbLRo3uIy60PZpOxDnGbASpppZpgYqmVuxX6GaR8wuZkUVCl+MS0KmdfMO77
9xKtHea+Ff5iuuKGvBGMN818cMlThUaYeI5KQlNfk0cUv/1vKcP7rq2jk4lFfpBZ
XfY7oHlm+50=
=Ma4G
-----END PGP SIGNATURE-----

--Sig_/AUpcoV3Nq/_=1l26TgxdctW--
