From: Andre Noll <maan@systemlinux.org>
Subject: Re: [PATCH] md: Protecting mddev with barriers to avoid races
Date: Fri, 22 May 2009 10:36:41 +0200
Message-ID: <20090522083641.GQ11504@skl-net.de>
References: <37d33d830905220118o1c5d6518l49b3dd1177d0a25e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="b6Y3a1uK/7FdRsLm"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <37d33d830905220118o1c5d6518l49b3dd1177d0a25e@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: SandeepKsinha <sandeepksinha@gmail.com>
Cc: Neil Brown <neilb@suse.de>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


--b6Y3a1uK/7FdRsLm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 13:48, SandeepKsinha wrote:
> Signed-off-by: Sandeep K Sinha <sandeepksinha@gmail.com>
> Date:   Fri May 22 13:46:56 2009 +0530
>=20
>     Protecting mddev with barriers to avoid races.
>=20
> diff --git a/drivers/md/linear.c b/drivers/md/linear.c
> index 9ad6ec4..e2dbda8 100644
> --- a/drivers/md/linear.c
> +++ b/drivers/md/linear.c
> @@ -28,10 +28,12 @@
>  static inline dev_info_t *which_dev(mddev_t *mddev, sector_t sector)
>  {
>         int lo, mid, hi;
> -       linear_conf_t *conf =3D mddev_to_conf(mddev);
> +       linear_conf_t *conf;
>=20
>         lo =3D 0;
>         hi =3D mddev->raid_disks - 1;
> +       barrier();
> +       conf =3D mddev_to_conf(mddev);

Are you sure that a compiler barrier is sufficient here? Maybe we
need smp_mb(), but I'm not familar with all the different memory
barrier types that exist in the kernel.

And please do not use mddev_to_conf() any more.

Thanks
Andre
--=20
The only person who always got his work done by Friday was Robinson Crusoe

--b6Y3a1uK/7FdRsLm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFKFmQZWto1QDEAkw8RAireAKCOdKJS7bu83QkkKJpnbLmzupXrjwCfYoZM
yodUrZ5J88w4tO+fHAdfL3I=
=IQr1
-----END PGP SIGNATURE-----

--b6Y3a1uK/7FdRsLm--
