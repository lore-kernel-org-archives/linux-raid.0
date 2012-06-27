From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] md/raid5:When exec md_wait_for_blocked_rdev in
 ops_run_io,we must atomic_inc(&rdev->nr_pending).
Date: Wed, 27 Jun 2012 12:21:29 +1000
Message-ID: <20120627122129.720f6021@notabene.brown>
References: <201206111123534849890@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/HplJJ8sZYb+I_.F1VgYTXc7"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201206111123534849890@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: majianpeng <majianpeng@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/HplJJ8sZYb+I_.F1VgYTXc7
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 11 Jun 2012 11:23:56 +0800 majianpeng <majianpeng@gmail.com> wrote:

> In ops_run_io(), if call md_wait_for_blocked_rdev which it dec
> nr_pending, the rdev->nr_pending will dec again in else-statement.
> So the nr_penging is error and we can't remove this device.
>=20
> Signed-off-by: majianpeng <majianpeng@gmail.com>
> ---
>  drivers/md/raid5.c |    6 ++++++
>  1 files changed, 6 insertions(+), 0 deletions(-)
>=20
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index d267672..995b2de 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -607,6 +607,12 @@ static void ops_run_io(struct stripe_head *sh, struc=
t stripe_head_state *s)
>  					md_check_recovery(conf->mddev);
>  				}
>  				md_wait_for_blocked_rdev(rdev, conf->mddev);
> +				/*
> +				 * Because md_wait_for_blocked_rdev will dec
> +				 * nr_pending,we must add.The real dec is in
> +				 * else statement.
> +				 */
> +				atomic_inc(&rdev->nr_pending);
>  			} else {
>  				/* Acknowledged bad block - skip the write */
>  				rdev_dec_pending(rdev, conf->mddev);

Thanks for catching this.

I have moved the 'atomic_inc' to before 'md_wait_for_blocked_rdev'
to make sure that the nr_pending count never goes to zero, and I tidied
up the comment a little.

Thanks,
NeilBrown


--Sig_/HplJJ8sZYb+I_.F1VgYTXc7
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT+puKTnsnt1WYoG5AQLGkQ/+PGhiY5mdEus4QrW1tKrBGikt5V7wPQQA
jjnMYTp7+8uB+hUoeLV0VOPO9kAP5NThdGNlgmVJRkOXA1F4I+mFtfWU1qTbEWcn
5INomKXVcrmD5inmWwunNAWcfLwTIxgMzd/dUuilNlocahopkWawUj/NIUfU0Chp
dife9V7S14Km7jFXRTIBpBxWZyxWwqARLHLgxVJh1pVkIhjvzVgI/w16J1Z1fI2N
yS2b8qwFQpHd2hQOb2Msi+Rd/Hnh3EeSrrOjxTOuyRcxfCSsJ6BLLl4RDJfTUwMZ
Fx3K0gAScLaVS9My2UKN/JaSBWOUnVhRDG/qxVJjEFZleSjbo/x3N+nRvvnQaeKn
lxODv8MLVm1gqNgODnIB1k13cXKe0Xy8/DhiIiq09NH9ym5bDB97BhKnWeU7L5TJ
tE0FgNxOJ7+QEgCjVE3z9Sg504raC+DV8EMxdNdNBVJXpC4w1ZVbksXycVAAnHvp
dlD7FjBEs6uVODCFvvWTLxvkIgowUHwFEhN1WMhoa0qMFs8i88GBqNq5igz5bfop
UAAjWSTE2GO+sSfv/+Fz6vkmZA4iZYS6L2SBMUtJjHxcS1pP3ihrqXh+ZWSDT0mI
JnPUkEm9GsnzKmpou4zjL3wSwuRolRtx1ANllm7eTSvVrX3OwRN+DSGtH+nkDU2K
hA0aPZJ2dK0=
=ro7r
-----END PGP SIGNATURE-----

--Sig_/HplJJ8sZYb+I_.F1VgYTXc7--
