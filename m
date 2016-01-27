From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] util: fix wrong return value of cluster_get_dlmlock
Date: Wed, 27 Jan 2016 11:44:37 +1100
Message-ID: <87bn873l6y.fsf@notabene.neil.brown.name>
References: <1453278085-19883-1-git-send-email-gqjiang@suse.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1453278085-19883-1-git-send-email-gqjiang@suse.com>
Sender: linux-raid-owner@vger.kernel.org
Cc: linux-raid@vger.kernel.org, Guoqing Jiang <gqjiang@suse.com>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 20 2016, Guoqing Jiang wrote:

> Actually lksb.sb_status means that a node get the lock
> or not instead of the return value of dlm_lock.
>
> Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
> ---
>  util.c | 14 ++++----------
>  1 file changed, 4 insertions(+), 10 deletions(-)
>
> diff --git a/util.c b/util.c
> index f1b0b95..cf9572b 100644
> --- a/util.c
> +++ b/util.c
> @@ -142,7 +142,7 @@ int cluster_get_dlmlock(int *lockid)
>  	dlm_lock_res->ls =3D dlm_hooks->create_lockspace(cluster_name, O_RDWR);
>  	if (!dlm_lock_res->ls) {
>  		pr_err("%s failed to create lockspace\n", cluster_name);
> -                goto out;
> +		return -ENOMEM;
>  	}
>=20=20
>  	/* Conversions need the lockid in the LKSB */
> @@ -157,21 +157,15 @@ int cluster_get_dlmlock(int *lockid)
>  			  dlm_lock_res, NULL, NULL);
>  	if (ret) {
>  		pr_err("error %d when get PW mode on lock %s\n", errno, str);
> -                goto out;
> +		dlm_hooks->release_lockspace(cluster_name, dlm_lock_res->ls, 1);
> +		return ret;
>  	}
>=20=20
>  	/* Wait for it to complete */
>  	poll_for_ast(dlm_lock_res->ls);
>  	*lockid =3D dlm_lock_res->lksb.sb_lkid;
>=20=20
> -	errno =3D	dlm_lock_res->lksb.sb_status;
> -	if (errno) {
> -		pr_err("error %d happened in ast with lock %s\n", errno, str);
> -		goto out;
> -	}
> -
> -out:
> -	return ret;
> +	return dlm_lock_res->lksb.sb_status;
>  }
>=20=20
>  int cluster_release_dlmlock(int lockid)
> --=20

Applied, thanks.

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWqBL1AAoJEDnsnt1WYoG5K40P/25szTBnLJoenHy+PenzIrpi
nahHoT53zy8VKNKIaZPubp0qGluOg1cEBKuh0IyBnhYWp0ScEwmSJt7NNQeH2BTw
Ll5AeutZgazjjXmViHoRL/QqHmy2BN1PrV/0H4chjgcfkQfa6sURqcdGz3ZDUcHB
1QaSTItkSMVDjGws2AmuSFvV237Vo0sWGdO9yFGv91huBQWlrwxX6JsknKTFnVpY
eQaBimPQ+Fn5+ytfxS85SlPZswAgIU1WelIo4zyXSuNqRaFpTVENltTUJ5+rbtkL
PRWtWsDyd+BEh3OQOBkSdXsx6SQKxEL2JfsCJG0zmhD3vNSPH3q68JP2zg4m3TUX
OEe/McgiMgI0Y8/YpsXVp5XZlTs2Iv3Gm7w3tYKdf6/E2EaSxLIPzI122zUrmksl
Hiz//IBVVqOW/dxoAQmit/jByLtZhWxr9LWPJMmEP2XKqodFjUzeUscoprD8YRh5
2reiBbZg7t+pGfz4hgkbKzgS3z+1GrNuk4fzzXueIUhPD4OKnQt+j6PYRIROoRoO
k32/Zsk6/K/lj67NlsrtIGsS68B1s4qMluLM0XhgBFGgFpoQwv9ps8DMlDH009C+
9fhhALDKgSVK0Y+RpHncHNcoC+uKVJCbb9pr2URRRIX2UCbthcLHEjx8kZb59rmK
E0JCJSBmo412xHIz6El3
=kjBq
-----END PGP SIGNATURE-----
--=-=-=--
