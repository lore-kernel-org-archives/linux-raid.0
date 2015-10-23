From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH] md-cluster: Only one thread should request DLM lock
Date: Fri, 23 Oct 2015 13:11:24 +1100
Message-ID: <874mhiz643.fsf@notabene.neil.brown.name>
References: <1445520669-4406-1-git-send-email-rgoldwyn@suse.de>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1445520669-4406-1-git-send-email-rgoldwyn@suse.de>
Sender: linux-raid-owner@vger.kernel.org
To: rgoldwyn@suse.de, linux-raid@vger.kernel.org
Cc: gqjiang@suse.com, Goldwyn Rodrigues <rgoldwyn@suse.com>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

rgoldwyn@suse.de writes:

> From: Goldwyn Rodrigues <rgoldwyn@suse.com>
>
> If a DLM lock is in progress, requesting the same DLM lock will
> result in -EBUSY. Use a mutex to make sure only one thread requests
> for dlm_lock() function at a time.
>
> This will fix the error -EBUSY returned from DLM's
> validate_lock_args().

I can see that we only want one thread calling dlm_lock() with a given
'struct dlm_lock_resource' at a time, otherwise nasty things could
happen.

However if such a race is possible, then aren't there other possibly
complications.

Suppose two threads try to lock the same resource.
Presumably one will try to lock the resource, then the next one (when it
gets the mutex) will discover that it already has the resource, but will
think it has exclusive access - maybe?

Then both threads will eventually try to unlock, and the second one will
unlock something that doesn't have locked.

I'm not certain, but that doesn't sound entirely safe.

Which resources to we actually see races with?

Thanks,
NeilBrown


>
> Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
> ---
>  drivers/md/md-cluster.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
> index 35ac2e8..9b977a2 100644
> --- a/drivers/md/md-cluster.c
> +++ b/drivers/md/md-cluster.c
> @@ -29,6 +29,7 @@ struct dlm_lock_resource {
>  	void (*bast)(void *arg, int mode); /* blocking AST function pointer*/
>  	struct mddev *mddev; /* pointing back to mddev. */
>  	int mode;
> +	struct mutex res_lock;
>  };
>=20=20
>  struct suspend_info {
> @@ -102,14 +103,19 @@ static int dlm_lock_sync(struct dlm_lock_resource *=
res, int mode)
>  {
>  	int ret =3D 0;
>=20=20
> +	mutex_lock(&res->res_lock);
> +
>  	ret =3D dlm_lock(res->ls, mode, &res->lksb,
>  			res->flags, res->name, strlen(res->name),
>  			0, sync_ast, res, res->bast);
> -	if (ret)
> +	if (ret) {
> +		mutex_unlock(&res->res_lock);
>  		return ret;
> +	}
>  	wait_for_completion(&res->completion);
>  	if (res->lksb.sb_status =3D=3D 0)
>  		res->mode =3D mode;
> +	mutex_unlock(&res->res_lock);
>  	return res->lksb.sb_status;
>  }
>=20=20
> @@ -134,6 +140,7 @@ static struct dlm_lock_resource *lockres_init(struct =
mddev *mddev,
>  	res->mode =3D DLM_LOCK_IV;
>  	namelen =3D strlen(name);
>  	res->name =3D kzalloc(namelen + 1, GFP_KERNEL);
> +	mutex_init(&res->res_lock);
>  	if (!res->name) {
>  		pr_err("md-cluster: Unable to allocate resource name for resource %s\n=
", name);
>  		goto out_err;
> --=20
> 1.8.5.6
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWKZdMAAoJEDnsnt1WYoG57FUQAK959zYJu/y/hBID5+8BW30G
GpeR6qIkTIddmyIOvL4ApEDGHnBsB3081SqE/GIICUuSsFzkNoP5b3cp2NKfls09
QTeacsk1XnwYxV4m/4epQRqVE0osy4WLTEIY6DOeJReJjysbPpkq7ZjN2tb6m8L4
/JNgIgw8nKNvoydDLcCdHXo5IH1Z5OY6vKt0rcP1fGg+ecoUyDN/0Hf5yvxaai9Y
wiKSpfiD7Y5GZc4up7cJBGp6e90sgXG8xiE48LxmSjdBIoraa2K3+QNDHI3K49xI
WILA8RBj0Ko+4CUyZNdLFGjkZR57q2xTYiNup5KEePxy17UXPnZMSbZqSpE6toQ5
K46y9qBEwJWMzj9JXDkBlS8kHr26GFErUkqQQzTFhZZoC+eDxNhIXU/oVWysGeOE
grLLEbQuVw3C+tM5WpE82AF4kPxC6dGo0pY+JOA7aGP8O9fkcaJqCZqJOGuNQbtp
QsIxqnv2RoFfrpENy3gZetStZTCQTkCoisRMlhuWS7wYKtC5tUZc2IfzZhwg05OZ
PtrJwQ+dqhXaaJixbWVDDIfTApXokqdnezVztLfn5VBdfB8deiW6BFjNix3tRUQA
LRQzDHMXhqaY1rAumVRnqU/av/qMtKebNr7Lc7OUdCGvDpiRryXBgXec2aMXEAgU
14HoeNZDG/cDO6hWD3XH
=PR/3
-----END PGP SIGNATURE-----
--=-=-=--
