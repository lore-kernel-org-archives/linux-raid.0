From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH] md-cluster: make md-cluster also can work when compiled into kernel
Date: Fri, 02 Sep 2016 22:56:48 +1000
Message-ID: <87k2eubgtr.fsf@notabene.neil.brown.name>
References: <1472813500-4921-1-git-send-email-gqjiang@suse.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1472813500-4921-1-git-send-email-gqjiang@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: shli@kernel.org, Guoqing Jiang <gqjiang@suse.com>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 02 2016, Guoqing Jiang wrote:

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
> Cc: NeilBrown <neilb@suse.com>
> Reported-by: Marc Smith <marc.smith@mcc.edu>
> Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
> ---
>  drivers/md/md.c | 21 +++++++++------------
>  1 file changed, 9 insertions(+), 12 deletions(-)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index bdbbb6e1..3b19d21 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -7619,20 +7619,17 @@ EXPORT_SYMBOL(unregister_md_cluster_operations);
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
> -	spin_lock(&pers_lock);
> -	if (!md_cluster_ops || !try_module_get(md_cluster_mod)) {
> +	if (!md_cluster_ops) {
> +		/* load module and ensure it won't be unloaded */
> +		request_module("md-cluster");
> +		spin_lock(&pers_lock);
> +		if (!try_module_get(md_cluster_mod)) {
> +			pr_err("can't get md-cluster module reference.\n");
> +			spin_unlock(&pers_lock);
> +			return -ENODEV;
> +		}
>  		spin_unlock(&pers_lock);
> -		return -ENOENT;
>  	}
> -	spin_unlock(&pers_lock);
>=20=20
>  	return md_cluster_ops->join(mddev, nodes);
>  }
> --=20
> 2.6.6

No good.  If md_cluster_ops is set, try_module_get() won't be called, so
it will be possible to unload the module while it is in use.

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBCAAGBQJXyXcQAAoJEDnsnt1WYoG58qUQAJK/UFv9eBaG0pxkd1y/1Koz
Pmt+SrS++Kb9Y6/hpI+HTDOLKdF5NjnULsd/I4fc7Zd6/uZuq7MwxQgleeh+zHNB
JSFzC1oNIfavWKyWqwmG88sd2SdtH4hQBGwwWkW251PpxJuZIPBaPBXWDg3GZ65i
RlyAD8Ds5E0huS+0g/ikqG/YZ4G8vOgfhhuUYQ6S9T7LYy2VXqm/EYnQhQnje+qs
PjWSshYNgbBEB9p7xIJUt6jjO1RNPX+it3wIiPCr6Z+fBy8xpuKuIO75SnvA7tno
nEcVsj4ldCRTPGR+h5lAX/ZDFvuXUciyyf3vuNIOaGfBL18UuvYof1EQBuDtf3Ly
c14PQrEv67j0e2s/cd+Xa/R7BBmS4Ht7ItPQY8RkjaRSHKJ+DX5++J+YQTErGcMZ
sYeTAcYv5P67D+LbuqIh8oMgA3cqW9bHHr6Y1sEu8RWYdzCW5V7JB0Q4KmrrA8EP
p/KjOM5BpijdBnBDDyfMCj2aAmNLP1OqVjaM6+/ZRt0guF/qPS41J6Z8tJYHQkyQ
ezS4sirvRz1x1VKfTtMJbPqKm+oKWpd8vKU7+FRV9JeddQtP8ONiZnxSQN9akY4D
47zvE1kNJ9MH3YmelhevzeK1W/V4K0Ciwej7jQ9e/pnl+eBavvTNvsvqnZlJ2yh+
+/h0+AYke9WDerTAToX5
=lgMC
-----END PGP SIGNATURE-----
--=-=-=--
