From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH 2/2] md: update comment for md_allow_write
Date: Wed, 09 Dec 2015 08:17:52 +1100
Message-ID: <878u54skqn.fsf@notabene.neil.brown.name>
References: <1449253972-26997-1-git-send-email-gqjiang@suse.com> <1449253972-26997-2-git-send-email-gqjiang@suse.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1449253972-26997-2-git-send-email-gqjiang@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: Guoqing Jiang <gqjiang@suse.com>gqjiang@suse.com
Cc: linux-raid@vger.kernel.org, rgoldwyn@suse.com
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, Dec 05 2015, Guoqing Jiang wrote:

> MD_CHANGE_CLEAN had been replaced with MD_CHANGE_PENDING after
> commit 070dc6 ("md: resolve confusion of MD_CHANGE_CLEAN"),
> so make the change accordingly.
>
> Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
> ---
>  drivers/md/md.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 5ee18a0..0feff1c 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -7701,7 +7701,7 @@ EXPORT_SYMBOL(md_write_end);
>   * attempting a GFP_KERNEL allocation while holding the mddev lock.
>   * Must be called with mddev_lock held.
>   *
> - * In the ->external case MD_CHANGE_CLEAN can not be cleared until mddev=
->lock
> + * In the ->external case MD_CHANGE_PENDING can not be cleared until mdd=
ev->lock
>   * is dropped, so return -EAGAIN after notifying userspace.
>   */
>  int md_allow_write(struct mddev *mddev)
> --=20
> 2.1.4

Applied, thanks.
NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWZ0kAAAoJEDnsnt1WYoG549wQAIbDYBCR/Le2cY6ifx9sVHiP
qpyR/7mBiVbRQulqDK0r8ktHtsKspVJkQ0+xquYsl2v1Bil+b5qQvY4kakK4xnaG
aUeDJczv8eaJJLijaHea3+bplWOj92yaIpe1E37ITs4IcAf8W4t2fYiHTKjITycf
VCrVCd3f40i7n0rUSM6NHJKRq0//Pxu0EVrOw+EsLpSzwui2mAxOAaxhT54hLYXW
GaOt0SHxQU+U3Zfr547wTpRfn6oK1amgNdADxqzBC37fwe2Kojsq+vEQG7ZLzJ1Z
CMcg/gFbjoXb7t25VIlybnHyd0rEupb0TtDxKMzKmmdobzH8m4okwNWD5lHPGN7h
M9mzHFFICeo4TcjIpPtfEmzAMcsw6GCkP5MjhQHMB5ndDOOEahzGl6NcO/iwg9Yb
v7SnNKgD4ACTjtoTvwfFLGqzpE7WR3B/N+gPhkTP4W0+k/1e9R2JjyuPKokypjZn
iT9074xTdHqjq01OOXJJYuYxxp0DQ3tHk+TVE/6bKy6rUbiQ0vFGinAirg3jmbuP
AQzWeSg1nvpnPOSAP+wlDUsgxdDfl9eqPaGwV2JfC8NWRdBvxg+f5Td/XFaTpvTf
DZljqLc2+ys58KrxQNowegLpwV40pp3055yMNgbKTG146Mo7njp4dLWHsAGdG/gz
gtXqQNVAOlndIOFZcSE3
=wng4
-----END PGP SIGNATURE-----
--=-=-=--
