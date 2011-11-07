From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] imsm: fix: add support for OLCE and migration to
 imsm_count_failed
Date: Mon, 7 Nov 2011 12:30:27 +1100
Message-ID: <20111107123027.04b9925a@notabene.brown>
References: <20111104135214.13558.65725.stgit@gklab-128-085.igk.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/aXPomFMiKjUm1.8G4H43KV7"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20111104135214.13558.65725.stgit@gklab-128-085.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Lukasz Dorau <lukasz.dorau@intel.com>
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, marcin.labun@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

--Sig_/aXPomFMiKjUm1.8G4H43KV7
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 04 Nov 2011 14:52:14 +0100 Lukasz Dorau <lukasz.dorau@intel.com>
wrote:

> The problem occurs when array under OLCE (from 3 to 6 disks)
> is assembled incrementally. Mdadm tries to start array
> just after adding the third disk (this is equal to the number of disks
> before the start of reshape). It does not succeed,
> the volume does not assembly correctly.
>=20
> The function counting failed disks (imsm_count_failed())
> was fixed for migration case. Now all disk members in both maps
> are checked when failed disks are counted correctly.
>=20
> Signed-off-by: Lukasz Dorau <lukasz.dorau@intel.com>
> ---
>  super-intel.c |   18 ++++++++++++------
>  1 files changed, 12 insertions(+), 6 deletions(-)
>=20
> diff --git a/super-intel.c b/super-intel.c
> index f776be9..215679d 100644
> --- a/super-intel.c
> +++ b/super-intel.c
> @@ -5943,6 +5943,7 @@ static int imsm_count_failed(struct intel_super *su=
per, struct imsm_dev *dev)
>  	struct imsm_disk *disk;
>  	struct imsm_map *map =3D get_imsm_map(dev, 0);
>  	struct imsm_map *prev =3D get_imsm_map(dev, dev->vol.migr_state);
> +	struct imsm_map *map_for_loop;
>  	__u32 ord;
>  	int idx;
> =20
> @@ -5951,13 +5952,18 @@ static int imsm_count_failed(struct intel_super *=
super, struct imsm_dev *dev)
>  	 * map[0].  So we look through all the disks we started with and
>  	 * see if any failures are still present, or if any new ones
>  	 * have arrived
> -	 *
> -	 * FIXME add support for online capacity expansion and
> -	 * raid-level-migration
>  	 */
> -	for (i =3D 0; i < prev->num_members; i++) {
> -		ord =3D __le32_to_cpu(prev->disk_ord_tbl[i]);
> -		ord |=3D __le32_to_cpu(map->disk_ord_tbl[i]);
> +	map_for_loop =3D prev;
> +	if (is_gen_migration(dev))
> +		if (prev && (map->num_members > prev->num_members))
> +			map_for_loop =3D map;
> +
> +	for (i =3D 0; i < map_for_loop->num_members; i++) {
> +		ord =3D 0;
> +		if (i < prev->num_members)
> +			ord |=3D __le32_to_cpu(prev->disk_ord_tbl[i]);
> +		if (i < map->num_members)
> +			ord |=3D __le32_to_cpu(map->disk_ord_tbl[i]);
>  		idx =3D ord_to_idx(ord);
> =20
>  		disk =3D get_imsm_disk(super, idx);


applied - thanks.

NeilBrown

--Sig_/aXPomFMiKjUm1.8G4H43KV7
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTrc0sznsnt1WYoG5AQIXQg/+LCp6Ty6FuF/rCiZlUGb7Mkji3ewg7BUA
Ifc90DWZqWh0ZPqyumIERyPDD4ThwcWMNh/yvhLQa3n+pl8xNJJ2sLwd6Vln0no8
CvU2K1IBwruEe3ngwE+LI2E1+nxMmvqT0ZnqBJBYDK86BERL6nHBtIcqKOWieF0u
mmA6juAw9k+QgUn64hn4ywRO6OEv37+ohGNdKS/4fvMxjzDVwPBTH6kw6ihwtSrO
BXiEl7wtI50Q83vRE28sioBUzCs30JzNVF9D48ZNTiGjxmRTo82352MNVLX3gtqo
mLJJNO+5y4ceKa5dkLcAiF+dEfNoUHcAVWeF8CoUFiEYFDKjEoHMcMrnDtixLjy5
gGYjhuG2Odwbow2KLF/bFBSFYNbkNzmDD96WOYPXPeV0iOYOpgO6KFRlgETZc/yo
YEhSyTvle+IyRhWmDc5TY0b19wNYqraHdvhhaCAymV1ufc64e48b/NMN6SoSaSrj
oXbuIFcSanqzlT7zGRKyd0t/8lPXOMtOYdUxQDblsGJfxF9qy7BTWHv5MzRrWYFJ
NnCBEEp6F1HC8pzvdPkCOYFUyKFyk90u44kq4ofa+Fbp9oWDE3YYtWxNnAEUrrK8
czF1l/cJUT5Eat8IQw1MZP7upf8DLkogl6BrkTEiFaPchkRidN1qWx7J1/XcKip4
YO/lQgR2MQ0=
=1vXP
-----END PGP SIGNATURE-----

--Sig_/aXPomFMiKjUm1.8G4H43KV7--
