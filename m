From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] imsm: FIX: Use first map only in migration record disk
 operations
Date: Mon, 12 Dec 2011 16:19:07 +1100
Message-ID: <20111212161907.0b35fc80@notabene.brown>
References: <20111209115720.5396.83087.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/PkNTzK2RO2616H2Ud86CVIu"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20111209115720.5396.83087.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Kwolek <adam.kwolek@intel.com>
Cc: linux-raid@vger.kernel.org, ed.ciechanowski@intel.com, marcin.labun@intel.com, dan.j.williams@intel.com
List-Id: linux-raid.ids

--Sig_/PkNTzK2RO2616H2Ud86CVIu
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 09 Dec 2011 12:57:20 +0100 Adam Kwolek <adam.kwolek@intel.com> wrot=
e:

> This patch is addition to patch:
>     "imsm: FIX: Limit migration record operation by disk slot not by inde=
x"
> Location of migration record (2 first slots) should be taken on up to date
> information. It is in first map.
> Change slot verification to use first map only.
>=20
> Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
> ---
>=20
>  super-intel.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
>=20
> diff --git a/super-intel.c b/super-intel.c
> index 879f4c4..92ff79c 100644
> --- a/super-intel.c
> +++ b/super-intel.c
> @@ -1185,7 +1185,7 @@ void examine_migr_rec_imsm(struct intel_super *supe=
r)
>  		printf("\nMigration Record Information:");
> =20
>  		/* map under migration */
> -		map =3D get_imsm_map(dev, MAP_1);
> +		map =3D get_imsm_map(dev, MAP_0);
>  		if (map)
>  			slot =3D get_imsm_disk_slot(map, super->disks->index);
>  		if ((map =3D=3D NULL) || (slot > 1) || (slot < 0)) {
> @@ -2138,7 +2138,7 @@ static int load_imsm_migr_rec(struct intel_super *s=
uper, struct mdinfo *info)
>  	*/
>  	if (dev =3D=3D NULL)
>  		return 0;
> -	map =3D get_imsm_map(dev, MAP_1);
> +	map =3D get_imsm_map(dev, MAP_0);
> =20
>  	if (info) {
>  		for (sd =3D info->devs ; sd ; sd =3D sd->next) {
> @@ -2269,7 +2269,7 @@ static int write_imsm_migr_rec(struct supertype *st)
>  			vol =3D 0;
>  		dev =3D get_imsm_dev(super, super->current_vol);
>  	}
> -	map =3D get_imsm_map(dev, MAP_X);
> +	map =3D get_imsm_map(dev, MAP_0);
> =20
>  	for (sd =3D super->disks ; sd ; sd =3D sd->next) {
>  		int slot =3D -1;
                ^^^^^^^^^^^^^^^^

Patch doesn't apply (Without fuzz) as in my code this is just
                int slot;

It doesn't need to be initialised from what I can see, so I've left it as it
is.

Pending confirmation of the earlier patch (vol not used), I've applied these
last 3:

Subject: [PATCH] imsm: FIX: Limit migration record operation by disk slot n=
ot by index
Subject: [PATCH] imsm: FIX: Use definitions for migration record disk opera=
tions
Subject: [PATCH] imsm: FIX: Use first map only in migration record disk ope=
rations

NeilBrown


--Sig_/PkNTzK2RO2616H2Ud86CVIu
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTuWOyznsnt1WYoG5AQJy6w//W6SJjXjw78PomwsKbElluwuq2b/MMQ8R
vwHEcbMKP8QaTicsg/o+XX/i6HDMXTUIdv/oEvkNWi8jdPh5eOvlc5WYwl/ieU87
RC3y4dBL5pT+eNUHWUwl1gbip6p8a+ke4cZhwi9zVwOFrCQqb2+nmk+yqdL69+Oq
EI13apB/mG3z8hTWKemx+21gwuoXTyinndxYUGPbm2ONsmXMrRrkiabOPR1cscWq
rUj/savt0WVb7gy8qxr9FbB9+DBPyAF8Rhk4mms9NiTHl2jJ4hEHJV83/1cUalHM
j+UIEP2WIP03F0jnXCHyDuHtcT+wIQj2leIHePHPrv9vOdhmz8biSUSyLa2h93F9
feC4HH9JW99bh8jyx7naeKGf13OthkbLHTWSU94O75pAPa+jLVDBaAInv78ol/L9
qNYcr1l93/3vXHSqZ3wGD2zJKndfLEQ1ot8iS94A3+LOHaImsGEl5BG+iV1ISolf
lQ1kC/yKz/0GshqpF/FwCyAroHXhFcr5F8Ar80fFc2TyteiF4cQ0C9mXhDOpYVsA
g9JoiNSdi+7TrTArEpiGFim5u2etYG4BGA5xTWwWF8nVMe3i6ketOr80/ml9wqvP
PbjSqHDJxEpKLt6m/wLykrrzyLgDgfksg41XNQHsC2pp9HKYjRR7CDCHd1bcR6XN
Ny7WOMhKlvk=
=Jp1m
-----END PGP SIGNATURE-----

--Sig_/PkNTzK2RO2616H2Ud86CVIu--
