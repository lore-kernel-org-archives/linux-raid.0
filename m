From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH v3] mdadm: monitor: fix nullptr dereference when
 get_md_name() returns NULL
Date: Wed, 20 May 2015 13:16:51 +1000
Message-ID: <20150520131651.2f184086@notabene.brown>
References: <1531453.K804EMet0W@sergeyv_box>
	<CAGRSmLuzqwn=7LQZx_CA1VE4SsGTHMEWU-TJkuHUeeaa8XUQ1Q@mail.gmail.com>
	<1916694.4Z1o92rJfN@sergeyv_box>
	<7486089.5E28xkmWcx@sergeyv_box>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/OOi=huM6w3a2/_=DjT8A1.r"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <7486089.5E28xkmWcx@sergeyv_box>
Sender: linux-raid-owner@vger.kernel.org
To: Sergey Vidishev <sergeyv@yandex-team.ru>
Cc: "David F." <df7729@gmail.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/OOi=huM6w3a2/_=DjT8A1.r
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 19 May 2015 22:02:46 +0300 Sergey Vidishev <sergeyv@yandex-team.ru>
wrote:

> >From fce3be7200e84665cdae58ba44d5c61af094af3b Mon Sep 17 00:00:00 2001
> From: Sergey Vidishev <sergeyv@yandex-team.ru>
> Date: Tue, 19 May 2015 20:34:58 +0300
> Subject: [PATCH] mdadm: monitor: fix nullptr dereference when get_md_name=
()
>  returns NULL
>=20
> Function add_new_arrays() expects that function get_md_name() should
> return pointer to devname, but also get_md_name() may return NULL. So
> check the pointer before use it in add_new_arrays().
>=20
> Signed-off-by: Sergey Vidishev <sergeyv@yandex-team.ru>
> ---
>=20
> v2 -> v3: - continue instead of return
>           - avoid mem leak (thanks to David F.)
> v1 -> v2: more verbose commit message
>=20
>  Monitor.c | 10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
>=20
> diff --git a/Monitor.c b/Monitor.c
> index 1cd378b..a530032 100644
> --- a/Monitor.c
> +++ b/Monitor.c
> @@ -687,6 +687,7 @@ static int add_new_arrays(struct mdstat_ent *mdstat, =
struct state **statelist,
>  {
>  	struct mdstat_ent *mse;
>  	int new_found =3D 0;
> +	char *name;
> =20
>  	for (mse=3Dmdstat; mse; mse=3Dmse->next)
>  		if (mse->devnm[0] &&
> @@ -697,7 +698,14 @@ static int add_new_arrays(struct mdstat_ent *mdstat,=
 struct state **statelist,
>  			struct state *st =3D xcalloc(1, sizeof *st);
>  			mdu_array_info_t array;
>  			int fd;
> -			st->devname =3D xstrdup(get_md_name(mse->devnm));
> +
> +			name =3D get_md_name(mse->devnm);
> +			if (!name) {
> +				free(st);
> +				continue;
> +			}
> +
> +			st->devname =3D xstrdup(name);
>  			if ((fd =3D open(st->devname, O_RDONLY)) < 0 ||
>  			    ioctl(fd, GET_ARRAY_INFO, &array)< 0) {
>  				/* no such array */


Applied, thanks.
And thanks David for the review help!

NeilBrown


--Sig_/OOi=huM6w3a2/_=DjT8A1.r
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVVv8oznsnt1WYoG5AQKTPxAAl15XVFTYSQsZqKJX5kRpT4JnJNpWfD9i
jYw0Q/EO274H/CcdiMuBDN+rvYQsZuDiRMaENcKE/X1kJHnSZdCu+t257YCY3dRH
xyBALTxEAaBAY7nK5w76WG0tgAQGGry0ovo7OMtDPUa3Q20fBvBvJr8MRBmmwBu+
4ZEIsJJsHITsyi/PRuJJl/v/U5+35OVUqHawCh8lnYle+vxvczEk66FnRJZ0MpCK
MFDGA9zR0lgS50fuf7K9sehfQI7wRdWkujm/zIoxtgBwXDslNLcaCRHuD7NvTvLo
0PL/CJHPGHlj1Qe/HpfMZ1INBnD5WJYoZIeSiAEgRKvTAO0qY6oJNcaNKZrq4yQ7
uQJqYT7bB4aZC/gGzvD7r2wZM3Z3eWYA8HfxPpkuohBVRZWwH4ys5Y79quy5J6lR
uMUo664iCNH1wafP/Yw/OXZ8+aJzcxiCVzbFKYDfy9Tj2nTJAthFD8SmaY1nSTj3
X+x1DzcVMfWTZiNz7ZhG7TBq0L0zc8W6wA/0NEOz9KCnz2WmJvy7caS6RiPM8uvG
9kzhAvcVibsQIkRTLM6d8ljJ0Ugry3XS6mVuPzIivWBKfyclKWEXaReoLtSvVQdk
Bl6P0dKZ3iza8lky2a2cxzcBfeqB3wlGklQSURwxkCVc2Hnd340BiUjIGn7FaCsG
mP7NkyMHWMI=
=qvmt
-----END PGP SIGNATURE-----

--Sig_/OOi=huM6w3a2/_=DjT8A1.r--
