From: NeilBrown <neilb@suse.de>
Subject: Re: md/raid1: If md_integrity_register() failed,run() must  free
 the mem
Date: Tue, 27 Mar 2012 13:18:42 +1100
Message-ID: <20120327131842.707f6c44@notabene.brown>
References: <201203231030548909882@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/ZuTo//=bjVnR8c7ljqxH6ys"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201203231030548909882@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: majianpeng <majianpeng@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/ZuTo//=bjVnR8c7ljqxH6ys
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 23 Mar 2012 10:30:59 +0800 "majianpeng" <majianpeng@gmail.com> wrot=
e:

> >From 8a7f9d02f3e7151ecfd05ca9b1734d6e62414c03 Mon Sep 17 00:00:00 2001
> From: majianpeng <majianpeng@gmail.com>
> Date: Fri, 23 Mar 2012 10:25:41 +0800
> Subject: [PATCH] md/raid1: If md_integrity_register() failed,run() must  =
free
>  the mem.
>=20
>=20
> Signed-off-by: majianpeng <majianpeng@gmail.com>
> ---
>  drivers/md/raid1.c |   14 +++++++++++++-
>  1 files changed, 13 insertions(+), 1 deletions(-)
>=20
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index 4a40a20..f71d8a0 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -2641,6 +2641,7 @@ static int run(struct mddev *mddev)
>  	struct r1conf *conf;
>  	int i;
>  	struct md_rdev *rdev;
> +	int ret;
> =20
>  	if (mddev->level !=3D 1) {
>  		printk(KERN_ERR "md/raid1:%s: raid level not set to mirroring (%d)\n",
> @@ -2705,7 +2706,18 @@ static int run(struct mddev *mddev)
>  		mddev->queue->backing_dev_info.congested_data =3D mddev;
>  		blk_queue_merge_bvec(mddev->queue, raid1_mergeable_bvec);
>  	}
> -	return md_integrity_register(mddev);
> +
> +	ret =3D  md_integrity_register(mddev);
> +	if (ret) {
> +		md_unregister_thread(&mddev->thread);
> +		if (conf->r1bio_pool)
> +			mempool_destroy(conf->r1bio_pool);
> +		kfree(conf->mirrors);
> +		kfree(conf->poolinfo);
> +		kfree(conf);
> +		mddev->private =3D NULL;
> +	}
> +	return ret;
>  }
> =20
>  static int stop(struct mddev *mddev)


applied, thanks.

Again, I changed it to just call 'stop' instead of duplicating the code.

NeilBrown

--Sig_/ZuTo//=bjVnR8c7ljqxH6ys
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT3Ejgjnsnt1WYoG5AQJB+g//aXzA/pAg3YMBghgY3RbYgWGkAnOxMTK9
2jH6sPssz99HBWBEDbM6rHfmHyZMQDtUX6fUVt6Hjb8G2SYwMqdeg4AK46aWuX82
UnSKPL/b7NHkQrhFkqkXaFDXe+Xm1cPghDNo0X3YP90m1iH3cvU3VSQpTNJf4pL/
6OKvDGl7YuHDU6IArDYIHQ5utqXniLaAXB1RPC/ohoY0iv+hD4/bn6BfLMV8dYpu
T1mb120Q9t0sMimkDo7+aGb+5VKRQvCB7S3sqDFFDWQQp7O12sAmBlJ9uMq5f+8t
lSL99mittvJGoNPKmaFjITW2FfcNAe1QUgxurI0Djod2VOKI5KXuuhMEFo7htkgo
7Wnz5H3L3Wi97q/xep9AbUR9XCh+OCvyoxqIDqpS74U/D8NLn/g39u0HlhFOUWYY
2n4E0+NjMvwgss8zz9TdMuWaFUi2cFp4h3dlhJEO5VFVE+etF2ryveWKpB7M4rp9
hKWGeAHfhgUDDxDbaXchF/Te8KGtyZY5cPPqDQW6r7T5CwjF256CdGS0/rpqm/W0
DO9VgMEP+VeO/cky8NnglH7v+FWyhfbknYYDpcb0I7O4dPGY53ACQrKBwjvd5OpV
vqvOBOJUnrO5XyJXwcF6PmqEtifRGlgqGaxfGgOmaNOMnZxt7cbHMDd+Ky17HqHI
rhoVsd5WQTA=
=s4cx
-----END PGP SIGNATURE-----

--Sig_/ZuTo//=bjVnR8c7ljqxH6ys--
