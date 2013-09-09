From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] Manage.c: fix small memory leak
Date: Tue, 10 Sep 2013 09:33:28 +1000
Message-ID: <20130910093328.76ba5449@notabene.brown>
References: <20130905091634.4986.72835.stgit@gklab-154-244.igk.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/GYB0PYb=3rzbJxoShzJPPv3"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130905091634.4986.72835.stgit@gklab-154-244.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Lukasz Dorau <lukasz.dorau@intel.com>
Cc: linux-raid@vger.kernel.org, pawel.baldysiak@intel.com
List-Id: linux-raid.ids

--Sig_/GYB0PYb=3rzbJxoShzJPPv3
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 05 Sep 2013 11:16:34 +0200 Lukasz Dorau <lukasz.dorau@intel.com>
wrote:

> 'avail' is dynamically allocated, so it should be freed.
>=20
> Signed-off-by: Lukasz Dorau <lukasz.dorau@intel.com>
> ---
>  Manage.c |    1 +
>  1 file changed, 1 insertion(+)
>=20
> diff --git a/Manage.c b/Manage.c
> index afa9b42..910caa6 100644
> --- a/Manage.c
> +++ b/Manage.c
> @@ -853,6 +853,7 @@ int Manage_add(int fd, int tfd, struct mddev_dev *dv,
>  			}
>  			array_failed =3D !enough(array->level, array->raid_disks,
>  					       array->layout, 1, avail);
> +			free(avail);
>  		} else
>  			array_failed =3D 0;
>  		if (array_failed) {

Applied. Thanks.

NeilBrown

--Sig_/GYB0PYb=3rzbJxoShzJPPv3
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUi5ayDnsnt1WYoG5AQJsHhAApet21/Slo+Y4UdCFNkLFz2YSXeS04jqc
OuK2bEQ8aI/+K/DJWDt6GYIDyZJVcPsABDHJ1wQYYyPfL7PB4D6f9rNBlzx5EO3N
F0ry2ezBxkrC34LGBIhsSMlNUJ2J9SuI4APohjgLShWJCzdqsbNhV3wljfK7Ddza
2fy6d1gQtrakMcdFF7Hemid33sEBof4dvnHcub0WKNG/qCrbm0Qk4ZwhTx8b9j02
Qnl332HNieYsqgysbQzGSulFVspglax6UgGTQSkVezxrgZ79WldM7kPu5tEUoSUq
Z/6Qp0XVn70rYNN3hY6u6VfHrpV5ckdbLW3kmkeDbkf52RCZ2Tybs8thxtstf7oT
V/8YmD+g5eO+ZkAJUaOXScazsWJYKmYJSqM3MJEXbXWTvufaeFBhy4VCOAHB2r4H
fOILIgnG+Y8ISKuTBIMamRvjpY4BUC363q8rMCudwPK1NSG1Ib3GhDa/BTB9zzI2
0h+U9GcDEIc7shvsQz7aJpQIjfIsXtR4mXuv1GUMCH25sTKO9VH6KGr/rV4KFW6a
OUpUDoR6eIti0qcl8GrwP0zAUjkwYIr37z3USD0Au1kXrLdY/PW3rht35bZlC7ct
4bhDSK908SERaEaAF7ATkG6LktFDfS12ffkxL1c7xeO6VxgJTFPfX1zfcCIj8wLo
TnZxWs4WU9g=
=ul2r
-----END PGP SIGNATURE-----

--Sig_/GYB0PYb=3rzbJxoShzJPPv3--
