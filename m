From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] FIX: resolve make everything compilation error
Date: Tue, 17 Apr 2012 12:58:18 +1000
Message-ID: <20120417125818.7c12b208@notabene.brown>
References: <20120416141254.23627.54905.stgit@gklab-128-085.igk.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/E3hnlhXPPWvp2oO31u3ed_4"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120416141254.23627.54905.stgit@gklab-128-085.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Lukasz Dorau <lukasz.dorau@intel.com>
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

--Sig_/E3hnlhXPPWvp2oO31u3ed_4
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 16 Apr 2012 16:12:55 +0200 Lukasz Dorau <lukasz.dorau@intel.com>
wrote:

> When mdadm is compiled using e.g. 'everything' option, mdassemble
> compilation is broken.
>=20
> Change code to enable mdassemble compilation.
>=20
> Signed-off-by: Lukasz Dorau <lukasz.dorau@intel.com>
> ---
>  super-intel.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
>=20
> diff --git a/super-intel.c b/super-intel.c
> index ed7792d..3bfeda6 100644
> --- a/super-intel.c
> +++ b/super-intel.c
> @@ -910,6 +910,7 @@ static unsigned long long blocks_per_member(struct im=
sm_map *map)
>  	return join_u32(map->blocks_per_member_lo, map->blocks_per_member_hi);
>  }
> =20
> +#ifndef MDASSEMBLE
>  static unsigned long long num_data_stripes(struct imsm_map *map)
>  {
>  	if (map =3D=3D NULL)
> @@ -921,6 +922,7 @@ static void set_total_blocks(struct imsm_disk *disk, =
unsigned long long n)
>  {
>  	split_ull(n, &disk->total_blocks_lo, &disk->total_blocks_hi);
>  }
> +#endif
> =20
>  static void set_pba_of_lba0(struct imsm_map *map, unsigned long long n)
>  {


applied, thanks.

NeilBrown

--Sig_/E3hnlhXPPWvp2oO31u3ed_4
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT4zcSjnsnt1WYoG5AQKiPg/9HDzXPUSQ/GhIZuw9bTudniB/RWVQWqyt
trOctFG9/j4uwDZHLtCCcN2FkJN+AkIQsAl8BsHPtuXYJSaWv7HHa5U7g16XEBEq
m7IgTKZWSyf/0MgSoW0sXYLG1U9S2PhU4+Dj8mWyD5TZTQmu8yO1K2jGKlluRYp1
baSXQe5r0GIexWTyiGtQIZ2H/rswMbQSqliJHCAcPuMNiLdc+oNMjxP/vFSFIKf2
NumyBPD5pM3RcwJ1mg6n0xcm4VUeRZ+Ca+WOl6UUsIXJHHkA4Good/YiQQFbpvwC
bp+5fOqG7yXnhWAEPpm16Ok2+jIv/P5HtHQtid9Utj3onwqOI+Czt3Zz6JmGaSjP
Gyvs/PFsG8A/VxxOh7VSRCCZwrXMa6JGXzKTylzXQsGp/FDOoXodDgNiwu2xILeI
iExbNtlhbhZZzC/6TSKJAQTJP36KiKPtnAfqPutbZeNj6vg509c+WmzciGwwuLro
rOy3DUnU/cry6t55wWTRai5fLf6XLeAscTzlDP+lZ7jxZ0Retwp3xqSYbK2nO7Jc
uEk6DKEcvk86TcJiwWsFfel+DDfedvyatv+FMZ9IzSEy8ldfvRHlkUHZoUZLncGf
FCyKxMsbsVp90nJlnA+GR59tkxP+AVKWGYtuLtgVYQ8Y83Y37gUkAGwCky35Zcq+
liBS3Q+vuoc=
=8V+w
-----END PGP SIGNATURE-----

--Sig_/E3hnlhXPPWvp2oO31u3ed_4--
