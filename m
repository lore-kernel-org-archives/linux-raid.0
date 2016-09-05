From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH V3] md-cluster: make md-cluster also can work when compiled into kernel
Date: Mon, 05 Sep 2016 13:10:46 +1000
Message-ID: <87mvjn9h3d.fsf@notabene.neil.brown.name>
References: <1472813500-4921-1-git-send-email-gqjiang@suse.com> <1473041848-28009-1-git-send-email-gqjiang@suse.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1473041848-28009-1-git-send-email-gqjiang@suse.com>
Sender: stable-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: shli@kernel.org, Guoqing Jiang <gqjiang@suse.com>, "v4.1+" <stable@vger.kernel.org>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 05 2016, Guoqing Jiang wrote:

> The md-cluster is compiled as module by default,
> if it is compiled by built-in way, then we can't
> make md-cluster works.
>
> [64782.630008] md/raid1:md127: active with 2 out of 2 mirrors
> [64782.630528] md-cluster module not found.
> [64782.630530] md127: Could not setup cluster service (-2)
>
> Fixes: edb39c9 ("Introduce md_cluster_operations to handle cluster functi=
ons")
> Cc: stable@vger.kernel.org (v4.1+)
> Cc: NeilBrown <neilb@suse.com>
> Reported-by: Marc Smith <marc.smith@mcc.edu>
> Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
> ---
> V3 changes:
> 1. add the "!md_cluster_ops" test back
> 2. fix wrong mail info of stable kernel
>
> V2 changes:
> 1. call try_module_get if md_cluster_ops is already set,
>    otherwise try_module_get/module_put are unbalanced.
>
>  drivers/md/md.c | 12 ++++--------
>  1 file changed, 4 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 67642ba..915e84d 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -7610,16 +7610,12 @@ EXPORT_SYMBOL(unregister_md_cluster_operations);
>=20=20
>  int md_setup_cluster(struct mddev *mddev, int nodes)
>  {
> -	int err;
> -
> -	err =3D request_module("md-cluster");
> -	if (err) {
> -		pr_err("md-cluster module not found.\n");
> -		return -ENOENT;
> -	}
> -
> +	if (!md_cluster_ops)
> +		request_module("md-cluster");
>  	spin_lock(&pers_lock);
> +	/* ensure module won't be unloaded */
>  	if (!md_cluster_ops || !try_module_get(md_cluster_mod)) {
> +		pr_err("can't find md-cluster module or get it's reference.\n");
>  		spin_unlock(&pers_lock);
>  		return -ENOENT;
>  	}
> --=20
> 2.6.6

Reviewed-by: NeilBrown <neilb@suse.com>

Thanks,
NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBCAAGBQJXzOI2AAoJEDnsnt1WYoG5U48P/31gxhcyQNBeKbps7prNRcVe
S35uvRyrv0xs/6riBnORO6IfWT33PbFteKqJr1YQB0O7Xvvi9SzVbSBgOo7g8I42
B1c1yEjPgshVlCQp2yUEZ/TMLZNhL4caMR7UpYtyxrXAORpJGx/rTzHN4zdFxfpd
hEsICjPVFuc6VRTFjwahJNZqnp5mRtFNIXcSqXMF4gFPvO9354K41zLohO93zOcM
BP1fWEnDZZDWSiA7XZU9054LfF6wLAKw3Dcx5IIR+n9UM+4ne5rR9bFnsvYfgSxN
FqNI1CUMFRw0BkRft5aIUTiVLa9lb4OraSVUN8ZT6aobJ5MNvvg7KBTrbZjUjsHv
MgoXUTMKLk4pt1BiohmkCe3ETgLsILHzYcYaxQmyKS4btcwltFu+mDItueasatNz
V+hizsikKIPoMYzkWZ+jcbxnPvTRAbjmQVa/clRX9XnxAKhjRcx7rmefqKlXIY5E
kyz/prqwT20k8zuLVnf0pBEY9yPYHrOoFhuKAP4VM9kps/p1oWYEH10tzfBr4im5
Jv6gxpdFGwnGfugPbLVZR/tBMWTsW1ZDQ4g/fDRUrXCMydNcyCY3rWK239oMfIax
rGC81KV0D/2DYH4itb14dVXvO2XVwzfQ6qh8zCA/z91c+Z22SXZlV284NcRwcK+W
HBqqf/Exz8j1+dveq8gL
=IeH6
-----END PGP SIGNATURE-----
--=-=-=--
