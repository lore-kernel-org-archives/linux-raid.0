From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH 2/3] MD: hold mddev lock to change bitmap location
Date: Wed, 03 Aug 2016 10:03:05 +1000
Message-ID: <87vazipvly.fsf@notabene.neil.brown.name>
References: <515fa68e5c4784b08f2ce99c082c923f6b02a3c9.1469922791.git.shli@fb.com> <13390282c96961ddd675199c2826f36a44bfa8aa.1469922791.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <13390282c96961ddd675199c2826f36a44bfa8aa.1469922791.git.shli@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: shli@kernel.org, linux-raid@vger.kernel.org
Cc: Shaohua Li <shli@fb.com>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, Jul 31 2016, shli@kernel.org wrote:

> From: Shaohua Li <shli@fb.com>
>
> Changing the location changes a lot of things. Holding the lock to avoid =
race.
> This makes the .quiesce called with mddev lock hold too.
>
> Cc: NeilBrown <neilb@suse.com>
> Signed-off-by: Shaohua Li <shli@fb.com>

Acked-by: NeilBrown <neilb@suse.com>

Yes, I think this is justified.  As you say, location_store is a fairly
significant change.

Thanks,
NeilBrown

> ---
>  drivers/md/bitmap.c | 47 +++++++++++++++++++++++++++++++++--------------
>  1 file changed, 33 insertions(+), 14 deletions(-)
>
> diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
> index 6fff794..13041ee 100644
> --- a/drivers/md/bitmap.c
> +++ b/drivers/md/bitmap.c
> @@ -2183,19 +2183,29 @@ location_show(struct mddev *mddev, char *page)
>  static ssize_t
>  location_store(struct mddev *mddev, const char *buf, size_t len)
>  {
> +	int rv;
>=20=20
> +	rv =3D mddev_lock(mddev);
> +	if (rv)
> +		return rv;
>  	if (mddev->pers) {
> -		if (!mddev->pers->quiesce)
> -			return -EBUSY;
> -		if (mddev->recovery || mddev->sync_thread)
> -			return -EBUSY;
> +		if (!mddev->pers->quiesce) {
> +			rv =3D -EBUSY;
> +			goto out;
> +		}
> +		if (mddev->recovery || mddev->sync_thread) {
> +			rv =3D -EBUSY;
> +			goto out;
> +		}
>  	}
>=20=20
>  	if (mddev->bitmap || mddev->bitmap_info.file ||
>  	    mddev->bitmap_info.offset) {
>  		/* bitmap already configured.  Only option is to clear it */
> -		if (strncmp(buf, "none", 4) !=3D 0)
> -			return -EBUSY;
> +		if (strncmp(buf, "none", 4) !=3D 0) {
> +			rv =3D -EBUSY;
> +			goto out;
> +		}
>  		if (mddev->pers) {
>  			mddev->pers->quiesce(mddev, 1);
>  			bitmap_destroy(mddev);
> @@ -2214,21 +2224,25 @@ location_store(struct mddev *mddev, const char *b=
uf, size_t len)
>  			/* nothing to be done */;
>  		else if (strncmp(buf, "file:", 5) =3D=3D 0) {
>  			/* Not supported yet */
> -			return -EINVAL;
> +			rv =3D -EINVAL;
> +			goto out;
>  		} else {
> -			int rv;
>  			if (buf[0] =3D=3D '+')
>  				rv =3D kstrtoll(buf+1, 10, &offset);
>  			else
>  				rv =3D kstrtoll(buf, 10, &offset);
>  			if (rv)
> -				return rv;
> -			if (offset =3D=3D 0)
> -				return -EINVAL;
> +				goto out;
> +			if (offset =3D=3D 0) {
> +				rv =3D -EINVAL;
> +				goto out;
> +			}
>  			if (mddev->bitmap_info.external =3D=3D 0 &&
>  			    mddev->major_version =3D=3D 0 &&
> -			    offset !=3D mddev->bitmap_info.default_offset)
> -				return -EINVAL;
> +			    offset !=3D mddev->bitmap_info.default_offset) {
> +				rv =3D -EINVAL;
> +				goto out;
> +			}
>  			mddev->bitmap_info.offset =3D offset;
>  			if (mddev->pers) {
>  				struct bitmap *bitmap;
> @@ -2245,7 +2259,7 @@ location_store(struct mddev *mddev, const char *buf=
, size_t len)
>  				mddev->pers->quiesce(mddev, 0);
>  				if (rv) {
>  					bitmap_destroy(mddev);
> -					return rv;
> +					goto out;
>  				}
>  			}
>  		}
> @@ -2257,6 +2271,11 @@ location_store(struct mddev *mddev, const char *bu=
f, size_t len)
>  		set_bit(MD_CHANGE_DEVS, &mddev->flags);
>  		md_wakeup_thread(mddev->thread);
>  	}
> +	rv =3D 0;
> +out:
> +	mddev_unlock(mddev);
> +	if (rv)
> +		return rv;
>  	return len;
>  }
>=20=20
> --=20
> 2.7.4

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJXoTS5AAoJEDnsnt1WYoG5jBgQAIWmfkD0wnDM8bSBNMgnUZAj
oelQ6EPv8Ha4ayIJNfRkUIbpZL+mW2gDfcpMRjQEmfarc4Jwx4P9OtKNYJCTA+tg
+daYKHeefkVbMtUj8G5ogF5Cc1SuN65L5ALWQwtxpTC2v9IyEoqMjfXnsAeV9TbX
tKKezBfReCLPAKqmfn0zLVu5Ee5fmJE72aKp7r+y1uq5C4AAo/63Q7d9Y0uayZTX
GML4xb9BL5/Ydt3mz7vi0b0qmEQovAjGxsDkyzBueDiwz6oYOXGkU+mWF1d2Jp4k
2vu17ll42vnuO8OS1pVoEOefwKooA9tVu9p15YN3G03Jzkq0kHcwTC3zvvayI8o7
kXTsRJ1x6I/ICL0DwagwAZo69dC5vGuAuzDCR10WBwGAfZ2dwOoyWQ+OJeiO+7Ua
HAy9+Z+IFgb7lboa4Xp9pQcNhzRxCLXaK3nPx8Mbj1ubLmT8g+Z9lZDPUvLxJOwm
puBBXtEtk43PXZAr+xj5pgkQby/crfJySDJF3Z6XtFnsXCTQfFkEIcTREvEN6txc
bhAo/CFV9RuCo/jQ6qyxhPwPJ7EsnE1IyadXuQTdIZ75Lo5NYc/SuOp451qrNWFE
KAmah2cRGjqb4xgszcfEcIbAOZqVfGMS4HdtwGm2vccayw9tf/GJWOs/rXCOM10J
xBZ/HAzWsFY7i2j72alU
=QJz5
-----END PGP SIGNATURE-----
--=-=-=--
