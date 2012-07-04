From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] MD RAID10:  Fix compiler warning.
Date: Wed, 4 Jul 2012 11:12:56 +1000
Message-ID: <20120704111256.6c1cea87@notabene.brown>
References: <1340700013.19015.7.camel@f16>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/3nIbx7uv/ZWDPp3FDEXbB98"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1340700013.19015.7.camel@f16>
Sender: linux-raid-owner@vger.kernel.org
To: Jonathan Brassow <jbrassow@redhat.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/3nIbx7uv/ZWDPp3FDEXbB98
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 26 Jun 2012 03:40:13 -0500 Jonathan Brassow <jbrassow@redhat.com>
wrote:

> MD RAID10:  Fix compiler warning.
>=20
> Initialize variable to prevent compiler warning.
>=20
> Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>
>=20
> Index: linux-upstream/drivers/md/raid10.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-upstream.orig/drivers/md/raid10.c
> +++ linux-upstream/drivers/md/raid10.c
> @@ -717,7 +717,7 @@ static struct md_rdev *read_balance(stru
>  	int sectors =3D r10_bio->sectors;
>  	int best_good_sectors;
>  	sector_t new_distance, best_dist;
> -	struct md_rdev *rdev, *best_rdev;
> +	struct md_rdev *best_rdev, *rdev =3D NULL;
>  	int do_balance;
>  	int best_slot;
>  	struct geom *geo =3D &conf->geo;
>=20

Applied, thanks.
I'm fairly sure it is a bogus warning, but initializing to NULL won't hurt.

Thanks,
NeilBrown

--Sig_/3nIbx7uv/ZWDPp3FDEXbB98
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT/OYmDnsnt1WYoG5AQIMTg/8DhiLIdAbstl48yGrcAHP/iAGXZVWHBHq
6qAHQb9hw44E3S15JxSZDDUcRO1NsTS/TZuYxNLZjJ+V9wgwuKrm7tkYOgJqs8fP
30UOneio9nahPHIiWAdPyId9B6rY7sgzcBxhD+MeFuYKS1hvarRsMGt3MGmAlmfA
fc52Er5C7zmhENJkNFkxKFrP6FK3QCwmANNw2Tg/KnKBIcz4IztI2EYNdWMpLq8G
PxCj10dMJa7U9iPkAwdw+kdaNjT3cD8TmYdd6lptBtpFnjO3zDrHwfVV4Pr++sBp
+wEk4fh77hLeA466Q3SU1YldKYYPI3If/kycaNf19ry1VrGwSQ880ylm1pqB4BgD
Xd7x617h/bmeDZdyZf//Su6b+Z3ZjCrfiMAfQPlxevrEdOLkqE23MUOvryoRdsVy
vKBV6a317TyFv27XKxklRrjrAIXeUX+stEfDiwvlyaj0DAFeuujjvtGb0PA5z9+9
5sPNWxUGeytb/6EypqA3diUJjEbSFyr9o4FWE7u33Nc55/lcoJSkUqsHW8ooe0Zf
FQHgx5KSrCl4kimKCrySX43MoG5WiBfb4tyOq7wzByp8Pexkvsf/KZDTNeYBfdPX
7nTElK5kBYplg0NhGHRhcpfMhfexM0a7S4G+wiG2pun+AbGJncf+plnEeGSvVciM
9s31nX+l8lQ=
=9GRy
-----END PGP SIGNATURE-----

--Sig_/3nIbx7uv/ZWDPp3FDEXbB98--
