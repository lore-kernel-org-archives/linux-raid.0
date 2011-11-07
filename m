From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 2/2] FIX: Do not continue container reshape when mdmon
 is absent
Date: Mon, 7 Nov 2011 11:47:13 +1100
Message-ID: <20111107114713.622fee19@notabene.brown>
References: <20111103165532.8864.80753.stgit@gklab-128-013.igk.intel.com>
	<20111103165541.8864.66189.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/U9HgQvbvmYa+beegOxcT4jJ"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20111103165541.8864.66189.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Kwolek <adam.kwolek@intel.com>
Cc: linux-raid@vger.kernel.org, ed.ciechanowski@intel.com, marcin.labun@intel.com, dan.j.williams@intel.com
List-Id: linux-raid.ids

--Sig_/U9HgQvbvmYa+beegOxcT4jJ
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 03 Nov 2011 17:55:41 +0100 Adam Kwolek <adam.kwolek@intel.com> wrot=
e:

> When mdmon is absent metadata is not updated, and container_reshape()
> can fall in to endless loop. This can cause user data corruption.
>=20
> In case when mdmon is absent do not continue container reshape process.
>=20
> Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
> ---
>=20
>  Grow.c |    6 ++++++
>  1 files changed, 6 insertions(+), 0 deletions(-)
>=20
> diff --git a/Grow.c b/Grow.c
> index e7fd7c4..184a973 100644
> --- a/Grow.c
> +++ b/Grow.c
> @@ -2562,6 +2562,12 @@ int reshape_container(char *container, char *devna=
me,
>  		restart =3D 0;
>  		if (rv)
>  			break;
> +		rv =3D !mdmon_running(devname2devnum(container));
> +		if (rv) {
> +			printf(Name ": Mdmon is not found. "
> +			       "Cannot continue container reshape.\n");
> +			break;
> +		}
>  	}
>  	if (!rv)
>  		unfreeze(st);
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Applied-  thanks.

NeilBrown


--Sig_/U9HgQvbvmYa+beegOxcT4jJ
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTrcqkTnsnt1WYoG5AQJYLg/+MpZP1oeYorH8Mx4J6JDv3ZFZYIPzs9Fp
I66Z5ovGRxbFVHYkU2ZoRKv4pwvgBUQx1Ab8GsULxdSrvmJV9dW0rvZMksujXUe8
0wd83vzqAjmM0EBsjVxqIgVGiYEURt0qjlCtxOtXw8fJvzic56SHBh+yMdkgcdKF
CvC+2uorJg6bLgZ5N4crE4os5owQqyDNoXB6YAh7PjgbUsQGAmS2Y+8pGoqohe+b
tjXGgvqduUIJZ0H0Ewz1weUUA0ZSAQ68yrKz+ibqKPVlU6hADpGz85Bs0t61WNDj
608kBFgMiK6cOM6hYNt7kDsMnwqpZ2sfGkavg60b2G5kd3veL6lDWHZMRVQDFHf4
BpVbWiqsGyfv2jwfjkR3YasEgQUCV+1iIrpUr0F9JfRCiUKutAgxgaXc870/j+mG
083kNP+f7eEdLsk7xC3vdxc0rVCZRNV9gCczMULNr6IPrjaznQjTY2ho+Ytuw/wE
UQ+Zm1yR/xb0r5fiyyKMUHLh8GzdZQO1RMqJ5v42/Xdz27QEdDeD48mnyOkkIG2n
h2nYfKfjOCcmlgRMrwWqV/0X7DVCiLggDXr+bhrlLAJELsK1m0aVzmCu2hSZwN+A
bdxlxlNdd3ZqCm4R3gdtTxxOY3rHiP82nZO5hgmvQtKaAZr7g89tWZYeiTY55dz/
WUvAUM1hT4k=
=3Cw5
-----END PGP SIGNATURE-----

--Sig_/U9HgQvbvmYa+beegOxcT4jJ--
