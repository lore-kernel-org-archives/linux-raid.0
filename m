From: Neil Brown <neilb@suse.com>
Subject: Re: [PATCH 17/39] md: drop null test before destroy functions
Date: Tue, 15 Sep 2015 09:29:10 +0200
Message-ID: <87613c6szd.fsf@notabene.neil.brown.name>
References: <1442146532-9100-1-git-send-email-Julia.Lawall@lip6.fr> <1442146532-9100-18-git-send-email-Julia.Lawall@lip6.fr>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1442146532-9100-18-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: sergey.senozhatsky@gmail.com, kernel-janitors@vger.kernel.org, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Julia Lawall <Julia.Lawall@lip6.fr> writes:

> Remove unneeded NULL test.
>
> The semantic patch that makes this change is as follows:
> (http://coccinelle.lip6.fr/)
>
> // <smpl>
> @@ expression x; @@
> -if (x !=3D NULL)
>   \(kmem_cache_destroy\|mempool_destroy\|dma_pool_destroy\)(x);
> // </smpl>
>
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
>
> ---
>  drivers/md/multipath.c |    3 +--
>  drivers/md/raid1.c     |    6 ++----
>  drivers/md/raid10.c    |    9 +++------
>  drivers/md/raid5.c     |    3 +--
>  4 files changed, 7 insertions(+), 14 deletions(-)

Applied, thanks.

NeilBrown


>
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 15ef2c6..09a12d7 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -2271,8 +2271,7 @@ static void shrink_stripes(struct r5conf *conf)
>  	       drop_one_stripe(conf))
>  		;
>=20=20
> -	if (conf->slab_cache)
> -		kmem_cache_destroy(conf->slab_cache);
> +	kmem_cache_destroy(conf->slab_cache);
>  	conf->slab_cache =3D NULL;
>  }
>=20=20
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index 4517f06..5f4f553 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -2843,8 +2843,7 @@ static struct r1conf *setup_conf(struct mddev *mdde=
v)
>=20=20
>   abort:
>  	if (conf) {
> -		if (conf->r1bio_pool)
> -			mempool_destroy(conf->r1bio_pool);
> +		mempool_destroy(conf->r1bio_pool);
>  		kfree(conf->mirrors);
>  		safe_put_page(conf->tmppage);
>  		kfree(conf->poolinfo);
> @@ -2946,8 +2945,7 @@ static void raid1_free(struct mddev *mddev, void *p=
riv)
>  {
>  	struct r1conf *conf =3D priv;
>=20=20
> -	if (conf->r1bio_pool)
> -		mempool_destroy(conf->r1bio_pool);
> +	mempool_destroy(conf->r1bio_pool);
>  	kfree(conf->mirrors);
>  	safe_put_page(conf->tmppage);
>  	kfree(conf->poolinfo);
> diff --git a/drivers/md/multipath.c b/drivers/md/multipath.c
> index d222522..d132f06 100644
> --- a/drivers/md/multipath.c
> +++ b/drivers/md/multipath.c
> @@ -470,8 +470,7 @@ static int multipath_run (struct mddev *mddev)
>  	return 0;
>=20=20
>  out_free_conf:
> -	if (conf->pool)
> -		mempool_destroy(conf->pool);
> +	mempool_destroy(conf->pool);
>  	kfree(conf->multipaths);
>  	kfree(conf);
>  	mddev->private =3D NULL;
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index 0fc33eb..7c99a40 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -3486,8 +3486,7 @@ static struct r10conf *setup_conf(struct mddev *mdd=
ev)
>  		printk(KERN_ERR "md/raid10:%s: couldn't allocate memory.\n",
>  		       mdname(mddev));
>  	if (conf) {
> -		if (conf->r10bio_pool)
> -			mempool_destroy(conf->r10bio_pool);
> +		mempool_destroy(conf->r10bio_pool);
>  		kfree(conf->mirrors);
>  		safe_put_page(conf->tmppage);
>  		kfree(conf);
> @@ -3682,8 +3681,7 @@ static int run(struct mddev *mddev)
>=20=20
>  out_free_conf:
>  	md_unregister_thread(&mddev->thread);
> -	if (conf->r10bio_pool)
> -		mempool_destroy(conf->r10bio_pool);
> +	mempool_destroy(conf->r10bio_pool);
>  	safe_put_page(conf->tmppage);
>  	kfree(conf->mirrors);
>  	kfree(conf);
> @@ -3696,8 +3694,7 @@ static void raid10_free(struct mddev *mddev, void *=
priv)
>  {
>  	struct r10conf *conf =3D priv;
>=20=20
> -	if (conf->r10bio_pool)
> -		mempool_destroy(conf->r10bio_pool);
> +	mempool_destroy(conf->r10bio_pool);
>  	safe_put_page(conf->tmppage);
>  	kfree(conf->mirrors);
>  	kfree(conf->mirrors_old);

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJV98jGAAoJEDnsnt1WYoG5VK4P/2mIFc+DTSvH4vi6SO65G0ON
gBUrCh8TmvjgSncNfr77R5xevhivH4sclBNc+ZmfB0JaFzt9Qi7UfaCEJAu6qRVu
4HD3MVS7v7aUxzT6eKt47/RlCp7bF9nYyazXzP8FniCuEop8ukcp/vMFrlYOKp2p
rf/f+J0aXPdPntSe5/j/p/8pXXGogupe0fh4Q4sLyj17ZmSUEfEZyXcf50lQXPh+
Z73Sf8NEeVYVesrgPHTCbFPeGkocGih7QmW1wwK+zbzPALEnj1JnVeMnw2o5oZ1n
XJF5sS5Ins515Ogt4TwALxoCKnqVig0qrYhrYGY+qq+1k6InaDTP4bEDiHV7MeYK
arpoHzOHF0lDRaJYh9Zpz6Llu5/bVp9svqJNcihTGkqSHzLuNKx8Uqq+QV2iZEeU
fF2NKysjZ37CicAS+Si0Xyk9DDotDoirdnbjCKg+7wU1gFephNDrNTxovci2tRNc
rbqu3LmTd7rBe8R0kA8h/Qm8LRXl7nSvjRhUUCkDBSvCELRnCe8GxFQLKHYPIFKn
DMH5zfHdAjgzR1xXOyIuY7vtKcsK3mV3aG41pjaMmrJCrnBcJF8mfvu4PXCVfyuf
81AQSSAgWE7J1mYK0nhbMJUhCz3sSBQTC/SgbW9/uPzjMTYX+YfqOBfMSEn9JtRP
k2pD3LJwOdlcRHglNjpj
=P64Z
-----END PGP SIGNATURE-----
--=-=-=--
