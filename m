From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 03/14] FIX: Do not unblock array accidentally
Date: Wed, 21 Sep 2011 12:19:27 +1000
Message-ID: <20110921121927.59a97037@notabene.brown>
References: <20110916115229.5201.42794.stgit@gklab-128-013.igk.intel.com>
	<20110916115409.5201.37690.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/oI.MeND65t.Kh.3ljUu9qXB"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110916115409.5201.37690.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Kwolek <adam.kwolek@intel.com>
Cc: linux-raid@vger.kernel.org, ed.ciechanowski@intel.com, marcin.labun@intel.com
List-Id: linux-raid.ids

--Sig_/oI.MeND65t.Kh.3ljUu9qXB
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 16 Sep 2011 13:54:09 +0200 Adam Kwolek <adam.kwolek@intel.com> wrot=
e:

> When sysfs_set_array() function is called, it tests if array
> can be configured using sysfs. Setting metadata_version entry
> can accidentally unblock mdmon when array is under reshape.
> To avoid this, blocking character '-' is checked and if is is set,
> it is used for array test.
>=20
> Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
> ---
>=20
>  sysfs.c |   10 ++++++++++
>  1 files changed, 10 insertions(+), 0 deletions(-)
>=20
> diff --git a/sysfs.c b/sysfs.c
> index 2146264..903202d 100644
> --- a/sysfs.c
> +++ b/sysfs.c
> @@ -541,7 +541,17 @@ int sysfs_set_array(struct mdinfo *info, int vers)
>  	ver[0] =3D 0;
>  	if (info->array.major_version =3D=3D -1 &&
>  	    info->array.minor_version =3D=3D -2) {
> +		char buf[1024];
>  		strcat(strcpy(ver, "external:"), info->text_version);
> +		if (sysfs_get_str(info, NULL, "metadata_version",
> +						  buf, 1024) > 0) {
> +			/* Testing string should not affect
> +			 * monitor blocking functionality
> +			 * Set blocking character if present in sysfs already
> +			 */
> +			if (buf[9] =3D=3D '-')
> +				ver[9] =3D '-';
> +		}
> =20
>  		if ((vers % 100) < 2 ||
>  		    sysfs_set_str(info, NULL, "metadata_version",
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

I have applied this patch, though I rewrote the comment a bit.

thanks,
NeilBrown


--Sig_/oI.MeND65t.Kh.3ljUu9qXB
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iD8DBQFOeUmwG5fc6gV+Wb0RAgp/AJ9vHljilApwpV/jEN74EQwLNTw3xgCgyFvj
bdTfOZffFhVQazBgXiWatqE=
=L2B9
-----END PGP SIGNATURE-----

--Sig_/oI.MeND65t.Kh.3ljUu9qXB--
