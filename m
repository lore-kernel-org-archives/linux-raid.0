From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] imsm: FIX: Just created redundant array is not in
 uninitialized state
Date: Tue, 6 Dec 2011 11:56:36 +1100
Message-ID: <20111206115636.1282d44e@notabene.brown>
References: <20111205082652.18395.98414.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/2B1e=sHpL0zJ7lcKPeQO8Ha"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20111205082652.18395.98414.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Kwolek <adam.kwolek@intel.com>
Cc: linux-raid@vger.kernel.org, ed.ciechanowski@intel.com, marcin.labun@intel.com, dan.j.williams@intel.com
List-Id: linux-raid.ids

--Sig_/2B1e=sHpL0zJ7lcKPeQO8Ha
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 05 Dec 2011 09:26:52 +0100 Adam Kwolek <adam.kwolek@intel.com> wrot=
e:

> When redundant array (e.g. raid5) is created metadata shows it is in
> normal state. Initialization process is showed in metadata as rebuild fro=
m normal
> to normal state. Redundant array should be initially in uninitialized sta=
te
> before it's initialization.
>=20
> Add code to put array in uninitialized state upon array creation.
>=20
> Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
> ---
>=20
>  super-intel.c |    6 +++++-
>  1 files changed, 5 insertions(+), 1 deletions(-)
>=20
> diff --git a/super-intel.c b/super-intel.c
> index a0672bf..b8abea0 100644
> --- a/super-intel.c
> +++ b/super-intel.c
> @@ -4289,7 +4289,11 @@ static int init_super_imsm_volume(struct supertype=
 *st, mdu_array_info_t *info,
>  	map->blocks_per_member =3D __cpu_to_le32(info_to_blocks_per_member(info=
));
>  	map->blocks_per_strip =3D __cpu_to_le16(info_to_blocks_per_strip(info));
>  	map->failed_disk_num =3D ~0;
> -	map->map_state =3D info->failed_disks ? IMSM_T_STATE_DEGRADED : IMSM_T_=
STATE_NORMAL;
> +	if (info->level > 0)
> +		map->map_state =3D IMSM_T_STATE_UNINITIALIZED;
> +	else
> +		map->map_state =3D info->failed_disks ? IMSM_T_STATE_FAILED :
> +						      IMSM_T_STATE_NORMAL;
>  	map->ddf =3D 1;
> =20
>  	if (info->level =3D=3D 1 && info->raid_disks > 2) {

Applied, thanks.

NeilBrown


--Sig_/2B1e=sHpL0zJ7lcKPeQO8Ha
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTt1oRDnsnt1WYoG5AQLdpw/+N24b6a2Kh8u8fGNFvi1RS6oCHSgjRdO1
nq/TTVKEyOGJ0yTp9DHDR5W1/DOyWQLx2saltiWjZekJLrVnp62aw9sjTIO+OPQe
imNlysbFzwve7a4m5AhzNAry1k5NTH2DMbyC3nXQ7n6OnSlbLKW2SQlOXiDyVmUI
cobga4dMesjZoe5cfOxLi6crvOxDO2z8eIZr74/AZXdmUOg9HtrvsrWG3J5E70+F
4OAqYzeN5OjDc1vf12sfs9wWAgI3IEdJrrbAjcFGj2eRP6kH4IDBWlq5nsxkDz4G
cW4PGpquY65WAsp45+4KWzrw0Rm2R5akFebNvtsNBQYQ7Y0erQqf7uETKtkBZSPe
Iuke6kRS+7i6uhBxW+Bgc4DcDQhc9qmsnbJefkWb/z78aFrXER2U/PMb63iuJhxo
We+khrNO966CiXPTwaiOCnVjp0nvaSgZKgTMcTTxbxmRU4M3DAfZeWN6+vxjF00s
qPbvPfhc9ODsiGyaTBopfZVfNMqOvEWM/jyqSK2hIVkU3kU50tIWvNtzvmoGHqNB
z3RP1W4DZFWu3CpVrIT2I8boQ3/qQLFSvT1FPS1lzg7nygmW1vnQZfqHNouEpnrw
NFpzhC8qULKGEUdw/seWp34JzMGHn4hall8MZTSJxXOKj/dCrj/7EwDaSsOpTSqY
h/JryhMXtng=
=RKA/
-----END PGP SIGNATURE-----

--Sig_/2B1e=sHpL0zJ7lcKPeQO8Ha--
