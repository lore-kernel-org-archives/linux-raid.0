From: NeilBrown <neilb@suse.de>
Subject: Re: md/linear: If md_integrity_register() failed,linear_run() must
  free the mem.
Date: Tue, 27 Mar 2012 13:17:38 +1100
Message-ID: <20120327131738.5766f47f@notabene.brown>
References: <201203231029159680193@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/=aj7AnhmU2hI_6IK4n8uOr6"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201203231029159680193@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: majianpeng <majianpeng@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/=aj7AnhmU2hI_6IK4n8uOr6
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 23 Mar 2012 10:29:19 +0800 "majianpeng" <majianpeng@gmail.com> wrot=
e:

> >From df3b2e15fb325def8f5eaa076b328084dd86c421 Mon Sep 17 00:00:00 2001
> From: majianpeng <majianpeng@gmail.com>
> Date: Fri, 23 Mar 2012 10:09:18 +0800
> Subject: [PATCH] md/linear: If md_integrity_register() failed,linear_run()
>  must  free the mem.
>=20
>=20
> Signed-off-by: majianpeng <majianpeng@gmail.com>
> ---
>  drivers/md/linear.c |    9 ++++++++-
>  1 files changed, 8 insertions(+), 1 deletions(-)
>=20
> diff --git a/drivers/md/linear.c b/drivers/md/linear.c
> index b0fcc7d..fa211d8 100644
> --- a/drivers/md/linear.c
> +++ b/drivers/md/linear.c
> @@ -198,6 +198,7 @@ out:
>  static int linear_run (struct mddev *mddev)
>  {
>  	struct linear_conf *conf;
> +	int ret;
> =20
>  	if (md_check_no_bitmap(mddev))
>  		return -EINVAL;
> @@ -211,7 +212,13 @@ static int linear_run (struct mddev *mddev)
>  	blk_queue_merge_bvec(mddev->queue, linear_mergeable_bvec);
>  	mddev->queue->backing_dev_info.congested_fn =3D linear_congested;
>  	mddev->queue->backing_dev_info.congested_data =3D mddev;
> -	return md_integrity_register(mddev);
> +
> +	ret =3D  md_integrity_register(mddev);
> +	if (ret) {
> +		kfree(conf);
> +		mddev->private =3D NULL;
> +	}
> +	return ret;
>  }
> =20
>  static int linear_add(struct mddev *mddev, struct md_rdev *rdev)


Applied, thanks.

NeilBrown

--Sig_/=aj7AnhmU2hI_6IK4n8uOr6
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT3EjQjnsnt1WYoG5AQJ8LBAAmFgQZyYgdUmlGSIuo9i0OdY0BzED8A9T
gNeDk93Hq+QIYHw4i3ICHo0yZgD+JU+pDPkDXvZ0T1bawOYxcD7C8o88XzcbPD/+
HjkumUDIrTQTGqKCHv/fvDVVXnd7fPP+WLusR3EqsBCf0MtvAeLvE3hsyPL9i2tp
wiEVNazFhCUzXmiI31MRxFeBhuJ2EnHSR4IEXEfeSax6jZkqZ7XKF1VnKaA44RWq
7A5xnnqgxqRiesYpQPvlCPIl6y9eTeQJf6ekX7gVIEGPAT5sqvZvGJxrAI8mHn97
A4lMXutVhRvDz1r10v1B6auyekq6Z9H80OUS1U92Xw7sZw+X8H1hsdvfqxH6MUDQ
v7b8L/tpmPSL1G/3S3TLSOLhRvhZa8x65/dwiKI1+9Y81S0QrVBdUPHwSWsiB59W
V9jU1cB5QG06EppTMprRn8TZAR8iYxazK22YgJBPDddsUxGuI0ApzoabSa1V1m+5
JEWgDDbBzndsda2nO2icQ977RSpTWlbVpHJw0p6bkUB32qe1V00NJ+F+pGsYN93K
llxXQg1TuAWhTHXt57bVL94ZzXR4GE2cA5GJdQIuwXpD5eUuEvubJ5odOXT+OpF6
enA4GlFXmHuylKmjlEHWkHjI7yKVRv7xqkCzkt2nC+WmDkjahQl51b2SDhSkpZGO
PT+Zc4nCyIg=
=CD+U
-----END PGP SIGNATURE-----

--Sig_/=aj7AnhmU2hI_6IK4n8uOr6--
