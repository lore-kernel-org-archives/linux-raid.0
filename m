From: NeilBrown <neilb@suse.de>
Subject: Re: md/raid5:Fix a bug about judging the operation is syncing or
 replaing in analyse_stripe().
Date: Mon, 2 Apr 2012 11:17:56 +1000
Message-ID: <20120402111756.5b7c0bae@notabene.brown>
References: <201203291122488286296@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/CxYkIGBVymI_OU3GN1vFu9+"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201203291122488286296@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: majianpeng <majianpeng@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/CxYkIGBVymI_OU3GN1vFu9+
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 29 Mar 2012 11:22:52 +0800 "majianpeng" <majianpeng@gmail.com> wrot=
e:

> >From 4d79586ebffac308ba11b363d81525882fdf6abe Mon Sep 17 00:00:00 2001
> From: majianpeng <majianpeng@gmail.com>
> Date: Thu, 29 Mar 2012 11:12:59 +0800
> Subject: [PATCH] md/raid5:Fix a bug about judging the operation is syncin=
g or
>  replaing in analyse_stripe().
>=20
> When create a raid5 using assume-clean and echo check or repair to
> sync_action.Then component disks did not operated IO but the raid
> check/resync faster than normal.
> Because the judgement in function analyse_stripe():
> 		if (do_recovery ||
> 		    sh->sector >=3D conf->mddev->recovery_cp)
> 			s->syncing =3D 1;
> 		else
> 			s->replacing =3D 1;
> When check or repair,the recovery_cp =3D=3D MaxSectore,so syncing equal z=
ero
> not one.

Thanks for the detailed description!

This fixes a bug in 3.3 so I'll queue it for 3.3-stable.

Thanks,
NeilBrown


>=20
> Signed-off-by: majianpeng <majianpeng@gmail.com>
> ---
>  drivers/md/raid5.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
>=20
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 23ac880..4d43ad3 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -3276,12 +3276,14 @@ static void analyse_stripe(struct stripe_head *sh=
, struct stripe_head_state *s)
>  		/* If there is a failed device being replaced,
>  		 *     we must be recovering.
>  		 * else if we are after recovery_cp, we must be syncing
> +		 * else if MD_RECOVERY_REQUESTED is set,we all in syning.
>  		 * else we can only be replacing
>  		 * sync and recovery both need to read all devices, and so
>  		 * use the same flag.
>  		 */
>  		if (do_recovery ||
> -		    sh->sector >=3D conf->mddev->recovery_cp)
> +		    sh->sector >=3D conf->mddev->recovery_cp ||
> +		    test_bit(MD_RECOVERY_REQUESTED, &(conf->mddev->recovery)))
>  			s->syncing =3D 1;
>  		else
>  			s->replacing =3D 1;


--Sig_/CxYkIGBVymI_OU3GN1vFu9+
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT3j+RDnsnt1WYoG5AQJEoQ//ca9UBGFnjlGxgEZKQ9LyRKhJvoGbRDEX
eFHFyB72rA+eeggDp0XOmGD/8rgs5M3HbUzpA0zuyCsSDBKXvEUlBDZ5zllOxkKp
LmppKYqEKzo9qeTl0gVan1hTtNp5bmBnP0VqIwdHTd2C3HOzDPi14kgXj82aBC4Y
7OILqA8L5oNZSS7VTjDAfXTyOEiUnREjnrWWAM19Gizq9D296ONxYdrSooHASfIH
rvnhFRdI8j9NJ0MSVMd2wMln70zjBDsdAGTL6tJRT1+HxFvBKQXBtUgfqFHfPSAw
R9dwCt6WIeLi02SSE7ZQtPEcagC2V/RtDL3s5Qqurr1aZM5Mu4+ddZHcdO3w+Qhl
7GFG3fy6a1dmDisnvsKnc9veU1Li0Kso4zYa1aV2e764UkBMBK1ty/oMSQHH9aRz
ogVdV6mjd7frQtNIBgjKZFTvq6l4pLGgkqdXyefFK0qHFDQ/w4F8Bw1lcqdSy54y
4XCdFXxOsr9G7B8RWGm4dwDiiD6FvLRWC3r4orB1swAeg0ILXfsMdXcvT1uS5Eq5
OFBkSq3JzIktIKaspd6CYRpnpK3PoU8u7NQTajRaFzkfioVl/V1dVykGk6MtEuBs
KR4jKY1nU30PrsoKbFgGbuMru2QSs/wO98AGnGPUPuNQdbSNIX9HmtrngL1vCL5T
+4hz9h80LOo=
=Ff7C
-----END PGP SIGNATURE-----

--Sig_/CxYkIGBVymI_OU3GN1vFu9+--
