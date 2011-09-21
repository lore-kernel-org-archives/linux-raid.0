From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 07/14] FIX: Memory leak during Assembly
Date: Wed, 21 Sep 2011 12:23:10 +1000
Message-ID: <20110921122310.6edcfab7@notabene.brown>
References: <20110916115229.5201.42794.stgit@gklab-128-013.igk.intel.com>
	<20110916115440.5201.42062.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/V7SI/DHPlBT0Sxi_3vo70RA"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110916115440.5201.42062.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Kwolek <adam.kwolek@intel.com>
Cc: linux-raid@vger.kernel.org, ed.ciechanowski@intel.com, marcin.labun@intel.com
List-Id: linux-raid.ids

--Sig_/V7SI/DHPlBT0Sxi_3vo70RA
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 16 Sep 2011 13:54:40 +0200 Adam Kwolek <adam.kwolek@intel.com> wrot=
e:

> For fdlist pointer allocated in assemble_container_content() function,
> free() is never called. This patch fixes this memory leak.
>=20
> Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
> ---
>=20
>  Assemble.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
>=20
> diff --git a/Assemble.c b/Assemble.c
> index 25cfec1..66d2ee4 100644
> --- a/Assemble.c
> +++ b/Assemble.c
> @@ -1584,6 +1584,7 @@ int assemble_container_content(struct supertype *st=
, int mdfd,
>  				if (fdlist[spare] >=3D 0)
>  					close(fdlist[spare]);
>  			}
> +			free(fdlist);
>  			if (err) {
>  				fprintf(stderr, Name ": Failed to restore critical"
>  					" section for reshape - sorry.\n");
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


I've applied this fix, thanks.

NeilBrown


--Sig_/V7SI/DHPlBT0Sxi_3vo70RA
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iD8DBQFOeUqOG5fc6gV+Wb0RAtYMAKCEL5hmOBNEx8U2ZsgyDowfMf4KbgCfRhTi
o5eKiuZMAUiKRb++n7DhYgM=
=+Hji
-----END PGP SIGNATURE-----

--Sig_/V7SI/DHPlBT0Sxi_3vo70RA--
