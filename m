From: Paul Menzel <pm.debian@googlemail.com>
Subject: Re: [PATCH 12/12] Detail.c: call load_container for container
 subarrays
Date: Sat, 02 Mar 2013 08:47:45 +0100
Message-ID: <1362210465.7752.3.camel@mattotaupa>
References: <1362176913-6804-1-git-send-email-mwilck@arcor.de>
	 <1362176913-6804-13-git-send-email-mwilck@arcor.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-UDTaP3bNdUv4IHqxw0Ea"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1362176913-6804-13-git-send-email-mwilck@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: mwilck@arcor.de
Cc: neilb@suse.de, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--=-UDTaP3bNdUv4IHqxw0Ea
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Dear Martin,


thank you for your patches?


Am Freitag, den 01.03.2013, 23:28 +0100 schrieb mwilck@arcor.de:
> Without calling load_container at this point, the
> info structure may be missing some important information.
> In particular, information about secondary DDF RAID levels
> may be wrong if information is only read from a single disk.
>=20
> If this fails, fall back to the previous code.
>=20
> Signed-off-by: Martin Wilck <mwilck@arcor.de>
> ---
>  Detail.c |   10 +++++++++-
>  1 files changed, 9 insertions(+), 1 deletions(-)
>=20
> diff --git a/Detail.c b/Detail.c
> index ab49803..9e52de8 100644
> --- a/Detail.c
> +++ b/Detail.c
> @@ -103,13 +103,21 @@ int Detail(char *dev, struct context *c)
>  		 * We want the name of the container, and the member
>  		 */
>  		int dn =3D st->container_dev;
> +		int cfd, err;
> =20
>  		member =3D subarray;
>  		container =3D map_dev_preferred(dev2major(dn), dev2minor(dn), 1, c->pr=
efer);
> +		cfd =3D open_dev(st->container_dev);
> +		if (cfd >=3D 0) {
> +			err =3D st->ss->load_container(st, cfd, NULL);
> +			close(cfd);
> +			if (err =3D=3D 0)
> +				info =3D st->ss->container_content(st, subarray);
> +		}
>  	}
> =20
>  	/* try to load a superblock */
> -	if (st) for (d =3D 0; d < max_disks; d++) {
> +	if (st && !info) for (d =3D 0; d < max_disks; d++) {

Is it ensured that `info` has been always NULL without your patch? Maybe
also add a comment too.

>  		mdu_disk_info_t disk;
>  		char *dv;
>  		int fd2;


Thanks,

Paul

--=-UDTaP3bNdUv4IHqxw0Ea
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEABECAAYFAlExrqEACgkQPX1aK2wOHVgKeACfS159ltu/N0F8PpQSz5x/HkKX
MYIAnRljmp+kO84PEEudcfmsw0BrjCnN
=3eeF
-----END PGP SIGNATURE-----

--=-UDTaP3bNdUv4IHqxw0Ea--

