From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH V2] md-cluster: make md-cluster also can work when compiled into kernel
Date: Mon, 05 Sep 2016 09:24:35 +1000
Message-ID: <87zinn9rkc.fsf@notabene.neil.brown.name>
References: <1472813500-4921-1-git-send-email-gqjiang@suse.com> <1472911410-15469-1-git-send-email-gqjiang@suse.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1472911410-15469-1-git-send-email-gqjiang@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: shli@kernel.org, Guoqing Jiang <gqjiang@suse.com>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, Sep 04 2016, Guoqing Jiang wrote:

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
> Cc: stable@vger.kernel.org # v4.1+

The above results in you sending email to
   stable@vger.kernel.org#v4.1+
which is not a valid address.

The correct form for comments in email address is to use parentheses.
e.g.
   Cc: stable@vger.kernel.org (v4.1+)

> Cc: NeilBrown <neilb@suse.com>
> Reported-by: Marc Smith <marc.smith@mcc.edu>
> Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
> ---
> Changes:
> 1. call try_module_get if md_cluster_ops is already set,
> otherwise try_module_get/module_put are unbalanced.
>
>  drivers/md/md.c | 14 +++++---------
>  1 file changed, 5 insertions(+), 9 deletions(-)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 67642ba..6ac5abe 100644
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
> -	if (!md_cluster_ops || !try_module_get(md_cluster_mod)) {
> +	/* ensure module won't be unloaded */
> +	if (!try_module_get(md_cluster_mod)) {

Why did you drop the "!md_cluster_ops" test?

What happens if the md-cluster module cannot be loaded?
md_cluster_ops will be NULL and md_cluster_mod will be NULL.
try_module_get(NULL) succeeds, so with this patch md_setup_cluster()
will succeed if the module is needed but fails to load.

NeilBrown



> +		pr_err("can't get md-cluster module reference.\n");
>  		spin_unlock(&pers_lock);
>  		return -ENOENT;
>  	}
> --=20
> 2.6.6

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBCAAGBQJXzK0zAAoJEDnsnt1WYoG5ovAP/3hvQyiqYQlA5JfXX6J+EXkN
0UUe2hx1ThVFgRed8C+S6RoBTTDpBRXOBZ6xXxF9rrxIM7+F+SqzejR/joe3+09X
3HY8RmYs65so7m2x0c/mvqJbp6nyNswugVLX78LpuIxQHm0vHK0EmLw4QWdmyCTz
W6E59kjHvlrZgz2WFRKdac5ViDvprPP3dEKnEuYcfudlQSnAK93k3Q1nJU16u1CU
WJipVqLvm6rFC/J1WH+oUw/PVblgcDIwt68jCtFhtPsasGjI25qrO5P+uAq54y7D
sh502GF4EGdJo+TAljdan0MFOe31DVOlwc1DmZ3cNSnUz22X1r5zJU0IqRlLg/U7
+oSMIqDXIbsCbcygLAB2pzfRAuo3QiNop3ows02TWAbgQpqtQ02R/zEWgSX5O68h
FA/LAfjHzo7hJvt61RPw2PYX1t+FTSXqy+KNp/LkqNL9QPJljq1tfMV425zhTmWD
sCA8HMVLQ9fR70bqtQs5gO8v2xUtzHJ0Kjj9H3fHGQdfOdLtBlFQ8Z8Knz7WzFgz
cpet3ih4gR/FtCXJF1UTaeAgjroFyZ3taNB3qagxe8IsJX9G4eYQGE/4K6GStAqt
PberPjW44QVpWSGceuPWJhkrm5vLuN/XRlNlEa4gmLP83ETrabt2JGXhhokHJrUU
j+T4XgfRznF9eEfqaCGM
=jN9O
-----END PGP SIGNATURE-----
--=-=-=--
