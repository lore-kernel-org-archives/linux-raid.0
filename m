From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 1/2] DDF: brief_examine_subarrays_ddf: print array name
Date: Mon, 9 Sep 2013 11:15:46 +1000
Message-ID: <20130909111546.2e9551b1@notabene.brown>
References: <1378502781-849-1-git-send-email-mwilck@arcor.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/3OSdDCJefyI5pPYCAODcr2P"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1378502781-849-1-git-send-email-mwilck@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: mwilck@arcor.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/3OSdDCJefyI5pPYCAODcr2P
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri,  6 Sep 2013 23:26:20 +0200 mwilck@arcor.de wrote:

> Print an array name in brief output. Do this even if no name is set,
> faking a simple pseudo name (may happen for some BIOS RAIDs).
> This makes DDF and IMSM behave equally.
>=20
> SUSE's YaST2 needs this in order to detect MD arrays during
> installation.

Thanks, but I don't like this - I would really rather SUSE's YaST2 got fixe=
d.

mdadm.conf is really for mdadm to read.  And the "--brief" output is meant
for inclusion in mdadm.conf.

If other programs want to parse the output of mdadm, they should use
--export, not --brief.

NeilBrown

>=20
> Signed-off-by: Martin Wilck <mwilck@arcor.de>
> ---
>  super-ddf.c |   13 +++++++++++--
>  1 files changed, 11 insertions(+), 2 deletions(-)
>=20
> diff --git a/super-ddf.c b/super-ddf.c
> index 8bba70a..72a8351 100644
> --- a/super-ddf.c
> +++ b/super-ddf.c
> @@ -30,6 +30,7 @@
>  #include "mdmon.h"
>  #include "sha1.h"
>  #include <values.h>
> +#include <ctype.h>
> =20
>  /* a non-official T10 name for creation GUIDs */
>  static char T10[] =3D "Linux-MD";
> @@ -1577,14 +1578,22 @@ static void brief_examine_subarrays_ddf(struct su=
pertype *st, int verbose)
>  		struct virtual_entry *ve =3D &ddf->virt->entries[i];
>  		struct vcl vcl;
>  		char nbuf1[64];
> +		char namebuf[sizeof(ve->name)+1], *c;
>  		if (all_ff(ve->guid))
>  			continue;
>  		memcpy(vcl.conf.guid, ve->guid, DDF_GUID_LEN);
>  		ddf->currentconf =3D&vcl;
>  		uuid_from_super_ddf(st, info.uuid);
>  		fname_from_uuid(st, &info, nbuf1, ':');
> -		printf("ARRAY container=3D%s member=3D%d UUID=3D%s\n",
> -		       nbuf+5, i, nbuf1+5);
> +		memcpy(namebuf, ve->name, sizeof(ve->name));
> +		namebuf[sizeof(ve->name)] =3D '\0';
> +		if (namebuf[0] =3D=3D '\0')
> +			sprintf(namebuf, "ddf_%d", i);
> +		for (c =3D namebuf; c < namebuf + sizeof(ve->name); c++)
> +			if (isspace(*c))
> +				*c =3D '-';
> +		printf("ARRAY /dev/md/%s container=3D%s member=3D%d UUID=3D%s\n",
> +		       namebuf, nbuf+5, i, nbuf1+5);
>  	}
>  }
> =20


--Sig_/3OSdDCJefyI5pPYCAODcr2P
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUi0hQjnsnt1WYoG5AQKUTw//SL3DSH3WnODnwWZdoxwS/NixDPpDunUV
HGNhNSTQDVS416BIhn4UXj3FbR9jr6+4HPv4O03qMX3wUiTQmB/B1vtIWB6IojrG
FBKuSmIiS1WobGgnTmiDO+CcuyJIm05b7/MlHTwR2/BdsA7C95jCdc/tiUl9OtAN
aD282mfkQpuV903s4Ct/iJGd8QGULueWoBfkkr9LQNnGX/yI6FwL8kSPAQfEB8Kr
z9rHnB+U37MeSj2bL+SD6i8omdD+mLuRi7LjKydN/qGCOOcgs70l/5AwAeB7KPDl
Yi34WDp04x9H4XjmmosDywiQ5kM8JFeLqYL3WwH2gay9AJdYlwhB4x5bN1Kf/zNv
eSATxzCXgQF9BvtCbL8iHvuBX/B5SQhG//kq7o8TGQ7btRETTUQjc7eEqfiPNXWJ
k4QkujcFlZoceW2MtOGVwUmNWPXiu/OK49rn1h1ptdngQZcLVH4LgawSLih/VrCN
+nYGwSl9AFWuongD1jYfVlke8FlHtPS2YSh1uLKsGot0fEnxdf1WIaV9btdQeebl
MHRqgRjH5OztyLSA7i9WGUz3hBn5t8gxtDHAE0lXg4wUm9B/6VTWPZqnWdtqt/3P
XlvahCni1m/+rXtU/Y39UnzYVG34FQBCYAgO1JL/BQBmYDwTI3XjH7UsQLrX1V1d
tXiZt+DZuo4=
=DaPb
-----END PGP SIGNATURE-----

--Sig_/3OSdDCJefyI5pPYCAODcr2P--
