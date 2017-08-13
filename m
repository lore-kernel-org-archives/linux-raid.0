From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH] MD: not clear ->safemode for external metadata array
Date: Mon, 14 Aug 2017 09:11:47 +1000
Message-ID: <8760droyfg.fsf@notabene.neil.brown.name>
References: <a34d31891470e5c0c16e1eb0b05398e2b30f6c23.1502509111.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <a34d31891470e5c0c16e1eb0b05398e2b30f6c23.1502509111.git.shli@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 11 2017, Shaohua Li wrote:

> From: Shaohua Li <shli@fb.com>
>
> ->safemode should be triggered by mdadm for external metadaa array, other=
wise
> array's state confuses mdadm.
>
> Fixes: 33182d15c6bf(md: always clear ->safemode when md_check_recovery ge=
ts the mddev lock.)
> Cc: NeilBrown <neilb@suse.com>
> Signed-off-by: Shaohua Li <shli@fb.com>

Yes, of course.
Thanks!

NeilBrown


> ---
>  drivers/md/md.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index f8840ef1aafd..a74dc9963822 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -8658,7 +8658,7 @@ void md_check_recovery(struct mddev *mddev)
>  	if (mddev_trylock(mddev)) {
>  		int spares =3D 0;
>=20=20
> -		if (mddev->safemode =3D=3D 1)
> +		if (!mddev->external && mddev->safemode =3D=3D 1)
>  			mddev->safemode =3D 0;
>=20=20
>  		if (mddev->ro) {
> --=20
> 2.11.0
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlmQ3LUACgkQOeye3VZi
gbmKrA//SiQZ7glS9a3AFK3Z+LpRPPUg0ywCfRTtwn6gsXDZ74jKzLAqAPmposbL
DBzB8Ot9WsSUZSpEBj/tZmNnf2ZTFUte4z4NAprrA3KF+IttMYZHr4zXOUsa19OG
4RtQsO2B4Gscyzt9XQ7RkCGi71qfGKUInRwnxfkKyGpcTPh0CDSdketOL2/QIIae
dOr8eeEwzA97x5f1UbWmSqaxoZrJgs/CqWI7BEwTGjJcxnvu14WkMWGs8yrIUDnU
XkQdOlPFpo3pMu31xKGLUEEcNTDbhgpBIfk4oJ8sc/UQ5kwBc9rsB9Tlx8teKXHP
jlSwLWY06YbKzWvJTcLIFFW1gU3RK9HVIBxpMMoqR6anryYDhxTSE4EKTYF4+3Wb
CoKk5f/DWvzfJiZ/Ep0wl0QiBsSYwpQ2BIz7jyDYKXs7OyRTAisurzBkF+PUyEgb
ZpQBW1yrlcFkM8BYaN0XGws/+8HrkbB7/l8ZA7xz3dowQ+F4MEWSbhraGxQ+GNuX
TO5yFUGpbb23F0rMdjH83VWZ7TM36zLVoZ6ru4geuMmJMKvK29XauSj7zsHVnA5g
A8DY2c3D/at7vxO3sR9RBpBmmDbL+BTdwhMYT/raZzZjClQdWVb+eVZFE98yKy+N
DvBzDW+jgemNKzdvvPdXgO8R2+bWFZuqPJWnSU3IoS99lJi8XxY=
=XWlR
-----END PGP SIGNATURE-----
--=-=-=--
