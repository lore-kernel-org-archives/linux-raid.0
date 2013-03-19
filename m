From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] RAID10: Allow skipping recovery when clean arrays are
 assembled
Date: Wed, 20 Mar 2013 10:46:57 +1100
Message-ID: <20130320104657.3d3d6bf0@notabene.brown>
References: <20130318103510.45bdd4a8@notabene.brown>
	<1363718133-7180-1-git-send-email-mwilck@arcor.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/ul+cYQzZP2a6M6Z4RSeb/UI"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1363718133-7180-1-git-send-email-mwilck@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: mwilck@arcor.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/ul+cYQzZP2a6M6Z4RSeb/UI
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 19 Mar 2013 19:35:33 +0100 mwilck@arcor.de wrote:

> When an array is assembled incrementally with mdadm -I -R
> and the array switches to "active" mode, md starts a recovery.
>=20
> If the array was clean, the "fullsync" flag will be 0. Skip
> the full recovery in this case, as RAID1 does (the code was
> actually copied from the sync_request() method of RAID1).
>=20
> Signed-off-by: Martin Wilck <mwilck@arcor.de>
>=20
> ---
>  drivers/md/raid10.c |   16 ++++++++++++++++
>  1 files changed, 16 insertions(+), 0 deletions(-)
>=20
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index 64d4824..e373d88 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -2863,6 +2863,22 @@ static sector_t sync_request(struct mddev *mddev, =
sector_t sector_nr,
>  		if (init_resync(conf))
>  			return 0;
> =20
> +	/*
> +	 * Allow skipping a full rebuild for incremental assembly
> +	 * of a clean array, like RAID1 does.
> +	 */
> +	if (mddev->bitmap =3D=3D NULL &&
> +	    mddev->recovery_cp =3D=3D MaxSector &&
> +	    !test_bit(MD_RECOVERY_REQUESTED, &mddev->recovery) &&
> +	    conf->fullsync =3D=3D 0) {
> +		*skipped =3D 1;
> +		max_sector =3D mddev->dev_sectors;
> +		if (test_bit(MD_RECOVERY_SYNC, &mddev->recovery) ||
> +		    test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery))
> +			max_sector =3D mddev->resync_max_sectors;
> +		return max_sector - sector_nr;
> +	}
> +
>   skipped:
>  	max_sector =3D mddev->dev_sectors;
>  	if (test_bit(MD_RECOVERY_SYNC, &mddev->recovery) ||

applied, thanks.

NeilBrown

--Sig_/ul+cYQzZP2a6M6Z4RSeb/UI
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUUj48Tnsnt1WYoG5AQLAhA/+IFlyabnhRXTx4o1nOF26gwRkUk8BUatB
EkREaWVP5uT7G6LGAn6TdQSAwVu5YpRUg1ATyi+R44oDHvungMZMetKeXf1TYmck
bkhGe1W5hFyn15P3yVCc7sx9MTPNZ6m6r1ktjTqnMkw19Ux8ZnQthC7FGm2Oc6gJ
a6C020mnEgTmIkAzhRkEZaBClDWOq9s21B7yVscciomoQRKqKubRv1DpDXVFRuis
SRnIrNR/4HfG1S1mUd2HGQvvcui2CVi/Dtt6Az5YcGH7fNxmAtjCQXWvFCPJ8H0T
q3toaIzMVUD7JOHSAb7tLuKHTQoVS6dPISIdL/aAweWu2Xvu8I4+fcLRrGIJFyY0
XSk0yDPxwHN4HcKhJ1L6coschNytRK+PLtnwLDqjC8+WhyAHHEXolOI5rvBx3NSC
9XLSO2/SPO0taLipCLqyCcw0S/rfS9d/ro90a8Ur6bYWWv90TKQGpyYa7Qp8sWNu
s58F/pjSYYoHmmBPm3MwY8hKsNeKy7JWt4rChLtL7fsCzwrUpJpdgC9X5WQYShyy
rvR7xuGiesSQIbO2fjHftOg3WeXaowI8dJWQMABqCmRIx6Hv9ilIrTPMGk/LaNl4
BWZx/1a5zktU4nSLXQl4xqaK10WMcELrkRpbm+W4SmVVBF+f92JpBtwUoI/+HVCT
J47ONDYhdkk=
=B67s
-----END PGP SIGNATURE-----

--Sig_/ul+cYQzZP2a6M6Z4RSeb/UI--
