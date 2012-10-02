From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 6/6] Add MD_ARRAY_SIZE for --examine --export
Date: Tue, 2 Oct 2012 16:42:45 +1000
Message-ID: <20121002164245.498f4043@notabene.brown>
References: <20120926114202.328.71156.stgit@gklab-128-174.igk.intel.com>
	<20120926114422.328.64275.stgit@gklab-128-174.igk.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/CNbPkmJNK7YcFT71Ix6Mk32"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120926114422.328.64275.stgit@gklab-128-174.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Maciej Naruszewicz <maciej.naruszewicz@intel.com>
Cc: linux-raid@vger.kernel.org, maciej.patelczyk@intel.com
List-Id: linux-raid.ids

--Sig_/CNbPkmJNK7YcFT71Ix6Mk32
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 26 Sep 2012 13:44:22 +0200 Maciej Naruszewicz
<maciej.naruszewicz@intel.com> wrote:

> An additional pair of key=3Dvalue for --examine --export.
>=20
> Signed-off-by: Maciej Naruszewicz <maciej.naruszewicz@intel.com>
> ---
>  super1.c |   19 +++++++++++++++++++
>  1 file changed, 19 insertions(+)
>=20
> diff --git a/super1.c b/super1.c
> index b04945f..0df5bee 100644
> --- a/super1.c
> +++ b/super1.c
> @@ -495,6 +495,7 @@ static void export_examine_super1(struct supertype *s=
t)
>  	struct mdp_superblock_1 *sb =3D st->sb;
>  	int i;
>  	int len =3D 32;
> +	int layout;
> =20
>  	printf("MD_LEVEL=3D%s\n", map_num(pers, __le32_to_cpu(sb->level)));
>  	printf("MD_DEVICES=3D%d\n", __le32_to_cpu(sb->raid_disks));
> @@ -506,6 +507,24 @@ static void export_examine_super1(struct supertype *=
st)
>  		}
>  	if (len)
>  		printf("MD_NAME=3D%.*s\n", len, sb->set_name);
> +	if (__le32_to_cpu(sb->level) > 0) {
> +		int ddsks =3D 0, ddsks_denom =3D 1;
> +		switch(__le32_to_cpu(sb->level)) {
> +			case 1: ddsks=3D1;break;
> +			case 4:
> +			case 5: ddsks =3D __le32_to_cpu(sb->raid_disks)-1; break;
> +			case 6: ddsks =3D __le32_to_cpu(sb->raid_disks)-2; break;
> +			case 10:
> +				layout =3D __le32_to_cpu(sb->layout);
> +				ddsks =3D __le32_to_cpu(sb->raid_disks);
> +				ddsks_denom =3D (layout&255) * ((layout>>8)&255);
> +			}
> +		if (ddsks) {
> +			long long asize =3D __le64_to_cpu(sb->size);
> +			asize =3D (asize << 9) * ddsks / ddsks_denom;
> +			printf("MD_ARRAY_SIZE=3D%s\n",human_size_brief(asize,JEDEC));
> +		}
> +	}
>  	printf("MD_UUID=3D");
>  	for (i=3D0; i<16; i++) {
>  		if ((i&3)=3D=3D0 && i !=3D 0) printf(":");


Applied,
thanks,
NeilBrown

--Sig_/CNbPkmJNK7YcFT71Ix6Mk32
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUGqM5Tnsnt1WYoG5AQIrQQ/9EhxMJUx6bN3HK51pWRs19VbLv/92w6uU
2zPyMRxFj/fZXFUIhaz5vHoV1fkczS5SBkqpahINOO9k8CrgIiGlcmIK4KzGGM0v
81lDdZFRLHSYZBH1/lyYLSpW/fOZO4FM00NLNgyS5mzOky2A2t4qI+qNL9/meeWB
EBd+ajvQ2yDtXLeEE2W0KHqB9C38bseC2lYV7GGGd9sMns2KISnEY0o1APNmlcn3
6xoBDqvshIKREeA6XfONFiL1vP1LHDZTylTCPpeJtoLzXENyCtSo+0BbHEwPeDIT
fhD3X5hhWm3EdOu3pf4d08TrrXY/ozdo4uwGsHzlmrcN57uk+NUecEcrH428Izi1
eAQWV2w3HCzZ9BYG+VF7yMGRNd5iHnPb9FLpUz1bB66UvM1DnR8whJUsod2zv4sf
Oe4t9u5s4kc93IGoH4iMwJpO3wx19u82bVq9ziKPGTB9e0ImJ2a3K39dyj9mFuO+
GtVWFe4MO66tnprkiUd2J2XmqJiH+400Rb+ReeSXQ0WuLY9R2oHsCu2wjOhXHp9Y
+RH3DO56j2RbQPlTecmVHQ3QrGVKxGVQCYG7vQDE6gfNJPmnHdtTXfGUkosNNHrO
JEFre/omW6QRvBVWwFXHK6OEJdjYEZqP91Prztdlx3aiCSOxRsy2K4876c1JuNO2
VJwrrM4hSh4=
=HGcn
-----END PGP SIGNATURE-----

--Sig_/CNbPkmJNK7YcFT71Ix6Mk32--
