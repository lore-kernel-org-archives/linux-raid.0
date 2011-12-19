From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] imsm: make messages more understandable
Date: Tue, 20 Dec 2011 10:37:37 +1100
Message-ID: <20111220103737.4248f3cb@notabene.brown>
References: <20111216140452.20625.63109.stgit@gklab-128-085.igk.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/=gB_Xio8_Rq2_D.m8pqjKpP"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20111216140452.20625.63109.stgit@gklab-128-085.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Lukasz Dorau <lukasz.dorau@intel.com>
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, marcin.labun@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

--Sig_/=gB_Xio8_Rq2_D.m8pqjKpP
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 16 Dec 2011 15:04:53 +0100 Lukasz Dorau <lukasz.dorau@intel.com>
wrote:

> The printed messages should be more appropriate and understandable
> for user. If maxsize is equal 0, this means there is no free space left
> on device. If size is greater than maxsize, this means there is not enough
> space to create a new volume of given size.
>=20
> Signed-off-by: Lukasz Dorau <lukasz.dorau@intel.com>
> ---
>  super-intel.c |   13 ++++++++++---
>  1 files changed, 10 insertions(+), 3 deletions(-)
>=20
> diff --git a/super-intel.c b/super-intel.c
> index 3c10d29..3990d58 100644
> --- a/super-intel.c
> +++ b/super-intel.c
> @@ -5466,9 +5466,16 @@ static int validate_geometry_imsm_volume(struct su=
pertype *st, int level,
>  	}
> =20
>  	if (maxsize < size || maxsize =3D=3D 0) {
> -		if (verbose)
> -			fprintf(stderr, Name ": not enough space after merge (%llu < %llu)\n",
> -				maxsize, size);
> +		if (verbose) {
> +			if (maxsize =3D=3D 0)
> +				fprintf(stderr, Name ": no free space"
> +						" left on device. Aborting...\n");
> +			else
> +				fprintf(stderr, Name ": not enough space"
> +						" to create volume of given size"
> +						" (%llu < %llu). Aborting...\n",
> +						maxsize, size);
> +		}
>  		return 0;
>  	}

Applied.  Thanks.

NeilBrown


--Sig_/=gB_Xio8_Rq2_D.m8pqjKpP
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTu/KwTnsnt1WYoG5AQLU0BAAon0yYijy1DrZfsObTwKurkdZXDTAeTcR
O3e6klspBwpALtxN9Lc8Dz7Q8wzk63g/palTt073lHp/knGu/eW1QlDTn+3JZl0o
qq9ZkJ3aHm0mBhtxgAqQXPJRYipTGwpuAd3dLNP4ePe7ciOFTpXGT9COD4Bc08HF
+takvOdKaf/w6cejJa+IZyXvosEPOG76miMHxTeasdg62qA0PXfJPaGSXG5FMZkc
+Wfcef47GBfjLJIAQhXiSeZ7/6kjBlJa0E8b87a0fR7XhZT7dG/zChzxSXHNN8OJ
AbFmb1LyfdUSP6K4EYhiSJZiBKQw3V51L/IhIopAfECI4TTa/Q+T7vHXjGbfvW5w
+jd5P8zEovOwZ5CW1qIpX+TtMLmIL0gAkMwrwG1iwsJbefqhJOBLJT2eTfNRl1Iq
d4BOZ6+ocN3PCTmMf31kvhL53cH+scZOmPOGvDcMo4qmnbjF1za4u7O6BiNk12gy
lHTBc6jDK5gPbOApmEEJpkMPn0S7A5TGXaCRAIM9gARh729mBBe14eWzYRlVU5VB
pzd7GE5EzpNeFh/H1cW/7S5xCY+BBT82YpwDFEYCRKB4iCz90LeQpr9QoZpUTWlK
NgdoDPyWCMOGjKwIEagf3FbF5OOb/2pCmU+lq5tMIwHWvEfs0Hq/1rXuO1VB04+B
rz14YlPZWVo=
=pjgc
-----END PGP SIGNATURE-----

--Sig_/=gB_Xio8_Rq2_D.m8pqjKpP--
