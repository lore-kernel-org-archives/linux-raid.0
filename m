From: Andre Noll <maan@systemlinux.org>
Subject: Re: Subject:[PATCH 001:013]: md: Raid0 reshape
Date: Wed, 17 Jun 2009 10:12:38 +0200
Message-ID: <20090617081238.GB6403@skl-net.de>
References: <1245189112.3478.94.camel@raz>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0B3PZ1+h5f4cFxHi"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1245189112.3478.94.camel@raz>
Sender: linux-raid-owner@vger.kernel.org
To: raz ben yehuda <raziebe@gmail.com>
Cc: linux raid <linux-raid@vger.kernel.org>, Neil Brown <neilb@suse.de>
List-Id: linux-raid.ids


--0B3PZ1+h5f4cFxHi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 00:51, raz ben yehuda wrote:
> md assumes that personality has all its membes of the same
> size,A fact that is incorrect for raid0.
>=20
>  md.c |   11 +++++++++--
>  1 file changed, 9 insertions(+), 2 deletions(-)
>=20
> Signed-off-by: razb <raziebe@gmail.com>
> ---
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 0f11fd1..e14fb90 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -5683,7 +5683,8 @@ static void status_resync(struct seq_file *seq, mdd=
ev_t * mddev)
>  		max_sectors =3D mddev->resync_max_sectors;
>  	else
>  		max_sectors =3D mddev->dev_sectors;
> -
> +	if (mddev->level =3D=3D 0)
> +		max_sectors =3D mddev->resync_max_sectors;
>  	/*
>  	 * Should not happen.
>  	 */
> @@ -6280,7 +6281,13 @@ void md_do_sync(mddev_t *mddev)
>  			    rdev->recovery_offset < j)
>  				j =3D rdev->recovery_offset;
>  	}
> -
> +	/*
> +	* raid0 members may not be of the same size,use array_size.
> +	*/
> +	if (mddev->level =3D=3D 0) {
> +		max_sectors =3D mddev->array_sectors;
> +		j =3D mddev->recovery_cp;
> +	}
>  	printk(KERN_INFO "md: %s of RAID array %s\n", desc, mdname(mddev));
>  	printk(KERN_INFO "md: minimum _guaranteed_  speed:"
>  		" %d KB/sec/disk.\n", speed_min(mddev));

Hm, we want to get rid of personality-dependent code in md.c, so new
code should never check mddev->level. In the first hunk I think it
would be possible to check if pers->sync_request is NULL.

Is the second hunk really necessary? AFAICS md_do_sync() won't be
called for raid0 anyway.

Regards
Andre
--=20
The only person who always got his work done by Friday was Robinson Crusoe

--0B3PZ1+h5f4cFxHi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFKOKV2Wto1QDEAkw8RAtweAJ9Zub5oTgEFomNsPQUAY4onGnZzDACfdkD1
WxZ1hdqoMz4p+BNQ8uH5+PY=
=txka
-----END PGP SIGNATURE-----

--0B3PZ1+h5f4cFxHi--
