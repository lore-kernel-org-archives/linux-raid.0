From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH 2/2] md: Replace get_seconds with ktime_get_seconds
Date: Wed, 23 Dec 2015 09:36:58 +1100
Message-ID: <87io3q2jqt.fsf@notabene.neil.brown.name>
References: <1450789602-31162-1-git-send-email-shraddha.6596@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1450789602-31162-1-git-send-email-shraddha.6596@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
Cc: linux-raid@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, Shraddha Barke <shraddha.6596@gmail.com>, Deepa Dinamani <deepa.kernel@gmail.com>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 23 2015, Shraddha Barke wrote:

> 32-bit systems using function get_seconds will break in year 2038,
> in order to avoid that replace the code with more appropriate function
> ktime_get_seconds which is y2038 safe. Function ktime_get_seconds use
> monotonic instead of real time and therefore will not cause overflow
>
> Signed-off-by: Shraddha Barke <shraddha.6596@gmail.com>
> ---
>  drivers/md/md.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 807095f..8dd74bb 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -2333,7 +2333,7 @@ repeat:
>=20=20
>  	spin_lock(&mddev->lock);
>=20=20
> -	mddev->utime =3D get_seconds();
> +	mddev->utime =3D ktime_get_seconds();
>=20=20
>  	if (test_and_clear_bit(MD_CHANGE_DEVS, &mddev->flags))
>  		force_change =3D 1;
> @@ -6347,13 +6347,13 @@ static int set_array_info(struct mddev *mddev, md=
u_array_info_t *info)
>  		/* ensure mddev_put doesn't delete this now that there
>  		 * is some minimal configuration.
>  		 */
> -		mddev->ctime         =3D get_seconds();
> +		mddev->ctime         =3D ktime_get_seconds();
>  		return 0;
>  	}
>  	mddev->major_version =3D MD_MAJOR_VERSION;
>  	mddev->minor_version =3D MD_MINOR_VERSION;
>  	mddev->patch_version =3D MD_PATCHLEVEL_VERSION;
> -	mddev->ctime         =3D get_seconds();
> +	mddev->ctime         =3D ktime_get_seconds();
>=20=20
>  	mddev->level         =3D info->level;
>  	mddev->clevel[0]     =3D 0;
> --=20
> 2.1.4

Thanks for splitting this off.
However I tried to apply it and it doesn't apply.

I already have a patch (in linux-next) from
  Deepa Dinamani <deepa.kernel@gmail.com>
which uses ktime_get_real_seconds().

http://git.neil.brown.name/?p=3Dmd.git;a=3Dcommitdiff;h=3D195e0e2726a7f9329=
5b28ebf277876d5a7c6cf2d

Which should it be?  ktime_get_seconds or ktime_get_real_seconds?

Thanks,
NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWedCKAAoJEDnsnt1WYoG5s6QP/RFFKJeBuDtlme4aXvTelNez
Q710vmUFuqtFkhovb1MmM4+dytyitd3KnXMxRvLGMQvpiRtO2qzCEq0ThVViCgmG
oawOk/17kjUQOaCGnbia+ZvgpiPi96Ktgl1N2nRru+OiSvjQRvr18rjIZ+JX5DoX
Fe9S10wYz4g41H+/E48iRfKIUaSNBHp7guxjnDoCXAl9NiE+V+JDOW7rxeSTastB
08W3at/cH6y4h/oXtjUIlJMtOnlkfuVW7gwj8MlU9O51ltWUeJrKV05GJk607QxU
MP1NE/xK8DCBABhNBP6jJ4T0DsR8ztSINBLSTiN8OrYcR+ERsT9QJ9H4YOI6nGP/
MdYWgiu4AhmtiQC5cAn69M99U9FvEM/dvUJVByJ7f6k+UKkXYRRrUxSHTbe/LR0Q
w7x+ELbeUHRaztf7D3Y6LsLDcdnYZ/v+aUIRpArmcg01jGoEU8sZ3wkmMHnyVnic
uyaZx5VW8sxBr1WOOaUmZ5vfQHEKs9amEQmnWK1QLi3DA3ZxbBbiIoVDDPAnwsxn
ZU6qxoo8BeVe6zXbbODTsFTiEOp0nvbjeXf8B1nQBkRY3gnIxt55NVgBZ4FE3Och
4+X0AldUzyU2v0PV9TaVcxJSeDaT/nJJ4K0CfEfTkkFG42LNSIrfoEt62+W8fO7B
pb1u2NTs4qkgs0YIoR0S
=asK8
-----END PGP SIGNATURE-----
--=-=-=--
