From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] Fix two typos in fprintf messages
Date: Tue, 10 Apr 2012 09:17:30 +1000
Message-ID: <20120410091730.299cc206@notabene.brown>
References: <20120405102641.14638.79381.stgit@gklab-128-085.igk.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/ES=qa_HE9.=03MSb0jmsgpw"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120405102641.14638.79381.stgit@gklab-128-085.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Lukasz Dorau <lukasz.dorau@intel.com>
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, marcin.labun@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

--Sig_/ES=qa_HE9.=03MSb0jmsgpw
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 05 Apr 2012 12:26:41 +0200 Lukasz Dorau <lukasz.dorau@intel.com>
wrote:

> Signed-off-by: Lukasz Dorau <lukasz.dorau@intel.com>
> ---
>  super-intel.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/super-intel.c b/super-intel.c
> index a351b60..8ee9b61 100644
> --- a/super-intel.c
> +++ b/super-intel.c
> @@ -5981,7 +5981,7 @@ static int validate_geometry_imsm_volume(struct sup=
ertype *st, int level,
>  		int count =3D count_volumes(super->hba->path,
>  				      super->orom->dpa, verbose);
>  		if (super->orom->vphba <=3D count) {
> -			pr_vrb(": platform does not support more then %d raid volumes.\n",
> +			pr_vrb(": platform does not support more than %d raid volumes.\n",
>  			       super->orom->vphba);
>  			return 0;
>  		}
> @@ -6115,7 +6115,7 @@ static int validate_geometry_imsm(struct supertype =
*st, int level, int layout,
>  						      super->orom->dpa, verbose);
>  				if (super->orom->vphba <=3D count) {
>  					pr_vrb(": platform does not support more"
> -					       "then %d raid volumes.\n",
> +					       " than %d raid volumes.\n",
>  					       super->orom->vphba);
>  					return 0;
>  				}


applied, thanks.

NeilBrown


--Sig_/ES=qa_HE9.=03MSb0jmsgpw
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT4NuCjnsnt1WYoG5AQJVIw/8CFu+i3KGv62lyDJW19sOg6ARCXJlFHYX
Gn77L6vLV9dzRAZb/didkJ2XWiqwZuKxSCyOoYcPO3xs4MdP5xqte9S3vwHC/+FS
0Y7eJgKkr6aK6f8roU1OuL/FgAS8uXn8g9TH3/8wrmIDVl4+G2TF9K6+syxPn72S
9/brOqKt6ONSHFb2YNA9WaA6dTHXle3Ecw12tIDukdrxPfE6GqABFj6XPqFtB7d/
50XJk5Nd5ym/Ot7p9QCdCXfx8SEQK3ExUwtSInJi1Aj4QQLLCJaLBwy3A+ijzDo/
boEhyLOm40k8x2fIJLZErhFesnz0CpoFBqS6RBVxDOu6GG0T+eiPXJsgMb2rjBf/
JNgU0VH0UxlfYMQi0CKofHAcayYPYZicc0FpUSuE0P744fn+w87clH3o2u+xqALI
28Y5woDDZJ+9QnZHFVOqcYWUG9fq3TZSuk3rZ+zeyDVaP5+xFygzBMiJJI0cu5qU
2gVncFJI9/PWzWspHKHtIf965fAsM066L9baBSbutxPSl8sNiy0Y3IBy1qbDkejM
ZX1mlg+nFLDWcwIWk+COsC9bT7S9q4Z2YYWnWwb6qeflH6Y+QXS48ZGWr/AyefaI
kfIHyUCaE6LCT8sYanbHjVGWAta/l4RovvRC8exuwlijXVALGpnXjvAmtr5P4pIK
LPoLYCEzV7Q=
=egMA
-----END PGP SIGNATURE-----

--Sig_/ES=qa_HE9.=03MSb0jmsgpw--
