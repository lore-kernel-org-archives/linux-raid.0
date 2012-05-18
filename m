From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] imsm: fix a typo in fprintf message
Date: Fri, 18 May 2012 13:42:05 +1000
Message-ID: <20120518134205.5d2170b4@notabene.brown>
References: <20120517133724.19669.66945.stgit@gklab-128-085.igk.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/zNp0=TtLpX_eB2GOVJ/dg07"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120517133724.19669.66945.stgit@gklab-128-085.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Lukasz Dorau <lukasz.dorau@intel.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/zNp0=TtLpX_eB2GOVJ/dg07
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 17 May 2012 15:37:24 +0200 Lukasz Dorau <lukasz.dorau@intel.com>
wrote:

> Signed-off-by: Lukasz Dorau <lukasz.dorau@intel.com>
> ---
>  super-intel.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>=20
> diff --git a/super-intel.c b/super-intel.c
> index e2ed95a..733bb38 100644
> --- a/super-intel.c
> +++ b/super-intel.c
> @@ -10051,7 +10051,7 @@ enum imsm_reshape_type imsm_analyze_change(struct=
 supertype *st,
>  				geo->size );
>  			if (current_size >=3D geo->size) {
>  				fprintf(stderr,
> -					Name " Error. Size expanssion is "
> +					Name " Error. Size expansion is "
>  					"supported only (current size is %llu, "
>  					"requested size /rounded/ is %llu).\n",
>  					current_size, geo->size);

Applied,
thanks.

NeilBrown

--Sig_/zNp0=TtLpX_eB2GOVJ/dg07
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT7XFDTnsnt1WYoG5AQK1OQ/9G5nGdLGrziPaBxSTYQ4+NsSJc0ujVQNn
2NcsvmSJzhMkwqrfVcIBoYuT2PzVK1xnVLKiYuslZNh38jraidm7ot9LF7oFfbrT
T9CKffd4oA71PX9Nvh8ydnm1FQV32gYE9TqPdQoMPCijAm9LNBjFeqLTVrMUCJzU
kfWEwO0GbZEMXstECF8OfUWVn7IyiyS2zNJ29aAvCCJxNVG1A9LPn35O2GkBBtUq
Goink0KsgBc/EflDyPZnO3JdOCrWfvCKdghLI1SaIt3RirsTJxjWMIH0eleUCxDn
PCB6EsyVHI/uRj70sXKrLGZJhiV7tv1XBGIRSu6tlRF/lXfIeFuBz8zPQBVM+OwD
O7ISLHtdxz19wMC/C7Z4z20WH7Qi39fjZFEeU6DQ+kXVcU21rOhO1j7/qF/CP6ih
sd7fDaKfGtld7kec9jLd+PRAI5iHrjPFhGZ0kNjy9T4UPgObznXlHc9JZqJN48Pm
LDzpIK3KAUdLQlGxNGiSSnhO9eKIZdnK4MLoT5SxLhzpSG28satDWxtCXDlForbT
8yJie+X2QA+MUIY7KlpvkvjQVEOqg2JBppkZ7k/PwBSIxUjgXnWn2ZcA7wYmLRfr
M4/1TeenLcF0L2vOHUhIOLnatG7A2t1mM/1gh1bNUKkyjx6c3qFEmtPAqCkPakj8
n1e2OQ0QkD0=
=BasB
-----END PGP SIGNATURE-----

--Sig_/zNp0=TtLpX_eB2GOVJ/dg07--
