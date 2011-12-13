From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 2/2] imsm: FIX: Use first map only in migration record
 disk operations
Date: Tue, 13 Dec 2011 13:26:32 +1100
Message-ID: <20111213132632.39bfe8aa@notabene.brown>
References: <20111212110745.8849.76773.stgit@gklab-128-013.igk.intel.com>
	<20111212110753.8849.40342.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/9tv9O25w0USC2A37ATsi6W7"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20111212110753.8849.40342.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Kwolek <adam.kwolek@intel.com>
Cc: linux-raid@vger.kernel.org, ed.ciechanowski@intel.com, marcin.labun@intel.com, dan.j.williams@intel.com
List-Id: linux-raid.ids

--Sig_/9tv9O25w0USC2A37ATsi6W7
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 12 Dec 2011 12:07:53 +0100 Adam Kwolek <adam.kwolek@intel.com> wrot=
e:

> This patch is addition to patch:
>     "imsm: FIX: Limit migration record operation by disk slot not by inde=
x"
> Location of migration record (2 first slots) should be taken on up to date
> information. It is in first map.
> Change slot verification to use first map only.
>=20
> Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>

Thanks.

I've applied this and the others, including the "make everything" fix that I
somehow missed before.
I've pushed it all out to the git tree.  Could you please check that I
haven't missed anything.

Thanks,

NeilBrown


> ---
>=20
>  super-intel.c |    8 ++++----
>  1 files changed, 4 insertions(+), 4 deletions(-)
>=20
> diff --git a/super-intel.c b/super-intel.c
> index d90d96b..bfbaf10 100644
> --- a/super-intel.c
> +++ b/super-intel.c
> @@ -1178,8 +1178,8 @@ void examine_migr_rec_imsm(struct intel_super *supe=
r)
> =20
>  		printf("\nMigration Record Information:");
> =20
> -		/* map under migration */
> -		map =3D get_imsm_map(dev, MAP_1);
> +		/* first map under migration */
> +		map =3D get_imsm_map(dev, MAP_0);
>  		if (map)
>  			slot =3D get_imsm_disk_slot(map, super->disks->index);
>  		if ((map =3D=3D NULL) || (slot > 1) || (slot < 0)) {
> @@ -2131,7 +2131,7 @@ static int load_imsm_migr_rec(struct intel_super *s=
uper, struct mdinfo *info)
>  	*/
>  	if (dev =3D=3D NULL)
>  		return 0;
> -	map =3D get_imsm_map(dev, MAP_1);
> +	map =3D get_imsm_map(dev, MAP_0);
> =20
>  	if (info) {
>  		for (sd =3D info->devs ; sd ; sd =3D sd->next) {
> @@ -2257,7 +2257,7 @@ static int write_imsm_migr_rec(struct supertype *st)
>  		dev =3D get_imsm_dev(super, super->current_vol < 0 ? 0 :
>  					  super->current_vol);
> =20
> -	map =3D get_imsm_map(dev, MAP_X);
> +	map =3D get_imsm_map(dev, MAP_0);
> =20
>  	for (sd =3D super->disks ; sd ; sd =3D sd->next) {
>  		int slot;
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/9tv9O25w0USC2A37ATsi6W7
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTua32Dnsnt1WYoG5AQKnmQ/9HUsQ1irtnKY4QXgjiltgTknwGK8082HT
/n0AbmDMlg3BkmJ4+aN/aVnkXo6nzpnA0EA1jUOpOxuus6s1fxTFg+bM+2akdJ7b
duH4ubOAz3QCb8AfO7//dcw72DDsabMcldfUV8lYzbWMDTIhHzm/1qecLpK4tMRB
Cfya4VX3BAbDUaHyCZl/V4XzeEVGHSmNG3EI8UAyYFtg5SXq9Aftf8sN9hptEY9q
W0OvBNIGmBS0pqYkeLyAWm7H80m+br8RZ+SYcwI9uAGXiCvfwsKpAGMfWk56iHa7
BHEOzF1NSVYJl8ot6J4RniDjailk7ZgKd2quFr4JjOsi2wX4SE1MWWf+/uo7XJYV
GldynyWIiR/CraObw+tFGLYHMJnYhPQhrh54A1NbYerN0Wx0HyXV4YBGCx7uLte9
048Yo5r83Gpyd5VaV/wWi4Q2a93RebOmTFgzL+LAj1EkGP3MARabnmyqKS4TLlXX
FaKcq2BdqCxvdwbCaYLECLCqxQAN+w7E3DsoPoiBGO8GcFD018QAnFQeHbV0gJ7A
EHt1ymeH2z9s599JDveAjo+riygItPda1MoGc4u4Ga3jm7P89kMMcQF4IIGgMiin
yo81dYYDAzl1CmxxeJeNS6BnxG+b9E9dHgjooOAMuKfyU1Uh4Ke4H40n/4Mtbw5w
tj483pMnHMo=
=Fdrs
-----END PGP SIGNATURE-----

--Sig_/9tv9O25w0USC2A37ATsi6W7--
