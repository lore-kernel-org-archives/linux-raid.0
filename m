From: NeilBrown <neilb@suse.de>
Subject: Re: [patch]raid5: get_active_stripe avoids device_lock
Date: Wed, 9 Apr 2014 12:17:29 +1000
Message-ID: <20140409121729.18955461@notabene.brown>
References: <20140408040553.GB20886@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/U7dvuhDIB1f.+x7ywHtJAOj"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140408040553.GB20886@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/U7dvuhDIB1f.+x7ywHtJAOj
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 8 Apr 2014 12:05:53 +0800 Shaohua Li <shli@kernel.org> wrote:

>=20
> For sequential workload (or request size big workload), get_active_stripe=
 can
> find cached stripe. In this case, we always hold device_lock, which expos=
es a
> lot of lock contention for such workload. If stripe count isn't 0, we don=
't
> need hold the lock actually, since we just increase its count. And this i=
s the
> hot code path for such workload. Unfortunately we must delete the BUG_ON.
>=20
> Signed-off-by: Shaohua Li <shli@fusionio.com>
> ---
>  drivers/md/raid5.c |    9 ++-------
>  1 file changed, 2 insertions(+), 7 deletions(-)
>=20
> Index: linux/drivers/md/raid5.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux.orig/drivers/md/raid5.c	2014-04-08 09:16:39.377536607 +0800
> +++ linux/drivers/md/raid5.c	2014-04-08 09:16:39.369536607 +0800
> @@ -679,14 +679,9 @@ get_active_stripe(struct r5conf *conf, s
>  				init_stripe(sh, sector, previous);
>  				atomic_inc(&sh->count);
>  			}
> -		} else {
> +		} else if (!atomic_add_unless(&sh->count, 1, 0)) {

Can I be really fussy and ask you to use "atomic_inc_not_zero" rather than
"atomic_add_unless" ??
I feel it makes the code a bit clearer.

Otherwise it's good - thanks.

NeilBrown

>  			spin_lock(&conf->device_lock);
> -			if (atomic_read(&sh->count)) {
> -				BUG_ON(!list_empty(&sh->lru)
> -				    && !test_bit(STRIPE_EXPANDING, &sh->state)
> -				    && !test_bit(STRIPE_ON_UNPLUG_LIST, &sh->state)
> -					);
> -			} else {
> +			if (!atomic_read(&sh->count)) {
>  				if (!test_bit(STRIPE_HANDLE, &sh->state))
>  					atomic_inc(&conf->active_stripes);
>  				BUG_ON(list_empty(&sh->lru) &&


--Sig_/U7dvuhDIB1f.+x7ywHtJAOj
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBU0StuTnsnt1WYoG5AQL17Q/9EZhlFvDjgIdF3lWbAlrLBszAtrT2ckky
nS6OPTf3U2VOPIikNCxnUw74jgjc8nwJxYpjAR6hjPu0QLPOpF5X73ulywyZRPwk
Fq70orVESPO8NBklxd/fMLKrLotTLpK3BUchPcrZxJYfApUiN027RLxGW+TdjOsX
mOlAfVgF5ncqZMAON8KSCMjfiB+FZ3mQslludofhK7RCPGfC758YRxR21WKR+ucf
MKzghBPsTjQhIu9PupH//ZQAVx+yRaATcG+az8svDKFJtN1x9juQncugRocHmv88
pgY9c5xNxloAIDDA/Tg2fk/xqunU/tV2/OpYLjt8inPCPsaBaGjFjltnb0lbXgI6
T4L38J2ACuWsBEjJL9Vz0LdcNX+wsMkwvt++xcTVx4RxGROT9SeZZE6sIdQe9kch
KGRNfKIAFNRpxXh8LvH+ErmMV2kY2NVFi4zMhpZfEfsBaG45jU3u7QsxA8yShmeE
j/gAWBKEXgnqakK1XNbaA9KxYeAqPvrW8BongHnf1FV2CyLA52xsMiJS3Wpn8p9N
p47ZR16WErUHI0y4i2FbZYe07LgyG3yBXzXW3uOXELCwkbMcvfBrOsVV3FWycs+b
ed6loJR5uMU9OGKQ97lwFR3GatDc/flLhJfk6CHe1vnGgphfswJat+f6czNpziC6
zfiXBOWLc6Y=
=hYp7
-----END PGP SIGNATURE-----

--Sig_/U7dvuhDIB1f.+x7ywHtJAOj--
