From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] raid6check.c: reduce verbosity
Date: Tue, 4 Feb 2014 16:10:25 +1100
Message-ID: <20140204161025.579257b1@notabene.brown>
References: <20140201160334.GA9378@lazy.lzy>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/vAY.LOwpJmwW1Jz2SaYl.GO"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140201160334.GA9378@lazy.lzy>
Sender: linux-raid-owner@vger.kernel.org
To: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/vAY.LOwpJmwW1Jz2SaYl.GO
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 1 Feb 2014 17:03:34 +0100 Piergiorgio Sartor
<piergiorgio.sartor@nexgo.de> wrote:

> This patch removes some printouts, which
> are not really useful here.
> These could be re-added later, in case a
> verbosity parameter will be provided.
>=20
> Signed off: piergiorgio.sartor@nexgo.de
>=20
> diff -uNrp a/raid6check.c b/raid6check.c
> --- a/raid6check.c	2014-01-23 19:36:23.151837870 +0100
> +++ b/raid6check.c	2014-02-01 16:56:14.123771170 +0100
> @@ -188,8 +188,6 @@ int check_stripes(struct mdinfo *info, i
>  	while (length > 0) {
>  		int disk[chunk_size >> CHECK_PAGE_BITS];
> =20
> -		printf("pos --> %llu\n", start);
> -
>  		err =3D lock_stripe(info, start, chunk_size, data_disks, sig);
>  		if(err !=3D 0) {
>  			if (err !=3D 2)
> @@ -221,7 +219,6 @@ int check_stripes(struct mdinfo *info, i
>  			int disk =3D geo_map(i, start, raid_disks, level, layout);
>  			blocks[i] =3D stripes[disk];
>  			block_index_for_slot[disk] =3D i;
> -			printf("%d->%d\n", i, disk);
>  		}
> =20
>  		qsyndrome(p, q, (uint8_t**)blocks, data_disks, chunk_size);
>=20
>=20

This and other 3 all applied - thanks.

NeilBrown

--Sig_/vAY.LOwpJmwW1Jz2SaYl.GO
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBUvB2QTnsnt1WYoG5AQKvDg/9EGCaUPxCc0SwdXQXsX3CYb12KsTfzWKH
PL022RpDbsBBGFPA/8wahSU1ekCq5XhYZQx5ZVrrYFnvOQoNX5oJ+lz9amLtkdeG
q89MxFvRjmIQT7CcDsBRMt7f0DwIyoBh2Cr45M4/FZzqbqFPh8IABWl4T8U0UvUz
7YxbfVQujOf1ViHaQjkryvmQCbP6FxnYkohOV1K+5rDhQWxCfbrkL8AaNiHxeKHp
izdUMRqj2MIlT2tumOFY9Pbb2hchcv9N35N3tCNs1IfQT1LWwo/JQri6PlVdd1to
d42TDzjWlNHKN89BxAa+0ArYO5Ux9I47vLGn6O2vCh32M6zLx/9FvRqJU9wWaUM6
mDsqrUI2I2KSSayIzP8eaX0a2MVcp60M8VoXSkXKzS+TNFR7qCF73hAj7WSRtr7a
JJFF7OHlVK1bQ8Fzi6D2GijSCzWGGMoMCk6RZihycgbqBKvyku5rflbX7KSiNplS
OdVzjkVuEE6B+5hbp6REbsFXwnKa8gm3bmHTVShDw5JUZGqcp1TgYEL3yc/E9Gke
P6Y7cVwBPsgYrGIuC4vdS6VkgX427+zsOOz5TdbfNLRHR7gra5pqEXDpQq7GeJtg
UR+xpqb7ZUYkSPInsBH2a5p/zJw3vh40660eezMjaN4PAg63HEPfz+NoRdqUGBJE
+uDWTuIsRs0=
=ijPR
-----END PGP SIGNATURE-----

--Sig_/vAY.LOwpJmwW1Jz2SaYl.GO--
