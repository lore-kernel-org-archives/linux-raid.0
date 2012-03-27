From: NeilBrown <neilb@suse.de>
Subject: Re: md/raid0: If md_integrity_register() failed,raid0_run() must
 free the mem.
Date: Tue, 27 Mar 2012 13:18:16 +1100
Message-ID: <20120327131816.057997b0@notabene.brown>
References: <201203231030029373801@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/YxsKZ5_.0D9r01UEmNUex9R"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201203231030029373801@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: majianpeng <majianpeng@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/YxsKZ5_.0D9r01UEmNUex9R
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 23 Mar 2012 10:30:09 +0800 "majianpeng" <majianpeng@gmail.com> wrot=
e:

> >From 3d07b1d34ee2dcb1abd599a90855f1a5c30c3de6 Mon Sep 17 00:00:00 2001
> From: majianpeng <majianpeng@gmail.com>
> Date: Fri, 23 Mar 2012 10:04:57 +0800
> Subject: [PATCH] md/raid0: If md_integrity_register() failed,raid0_run() =
must
>   free the mem.
>=20
>=20
> Signed-off-by: majianpeng <majianpeng@gmail.com>
> ---
>  drivers/md/raid0.c |   10 +++++++++-
>  1 files changed, 9 insertions(+), 1 deletions(-)
>=20
> diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
> index 6f31f55..5a99cde 100644
> --- a/drivers/md/raid0.c
> +++ b/drivers/md/raid0.c
> @@ -454,7 +454,15 @@ static int raid0_run(struct mddev *mddev)
> =20
>  	blk_queue_merge_bvec(mddev->queue, raid0_mergeable_bvec);
>  	dump_zones(mddev);
> -	return md_integrity_register(mddev);
> +
> +	ret =3D md_integrity_register(mddev);
> +	if (ret) {
> +		kfree(conf->strip_zone);
> +		kfree(conf->devlist);
> +		kfree(conf);
> +		mddev->private =3D NULL;
> +	}
> +	return ret;
>  }
> =20
>  static int raid0_stop(struct mddev *mddev)

Applied, thanks,
however I changed it to just call "raid0_stop" instead of explicitly freeing
things.  This reduces code duplication.

Thanks,
NeilBrown


--Sig_/YxsKZ5_.0D9r01UEmNUex9R
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT3EjaDnsnt1WYoG5AQLvmhAAnnr6VKItu3tCVqRPJqLmC+W0E0szzzHv
H3mcbhjZnKkV00GraICyJKHkSXitreTf/QDkNINPLz5k8NHme+8TlkYUyn3aryhq
gvGyx2vTkEHkxN+2Ckr030qBaJt6qdoNgzj2PqmzPigeQmykSo46oRcguZUSeHgc
3TUW2ffB4ItysPcaTwG5CF8gKavlgpIEFWzTfctcFyhTnGxMuUBVzLXbROdoRLna
hYmHxEUlm2EgLb6DrGpLRPniSNBKLsMmpN2ZBtrUV3caHLr5puTnHDthLRNQ/nPk
gnkFWRpw0Ht5tgRLTg74dLz02YPvUvt7SmLGC2NrSInEWJ1+EvCfHGKzKLpPS04l
C8Nn2KvQFhvv/T5qf+BatY8UZ56kIdj/O/1X9bnTlo9RzSV/DUuX5kythgvi9X8E
pHu1lvO/MJMe+rEtH2Jq4oTezVmYqq4cOvilC07yfHj2obOQhOrOyJJM8BTEabsf
l0+BAZaAe0uBB+FdMqsfkDAbiSRJ6V69WLnxvDXuIYaKE+h5M2O8sF8mNsylptnU
7SlH4I9ZUMB3Gyy8KygPrX4zDJGv+Awx5jtM1jkvN4JFOUB6AbeEsbzn09gdgC7v
YfP+hj1Rol5oHjEJTKqonyyW5QrKUsq1Jc0ZzEh95B5rhrRy0KNZMOLMIn3h1e1W
1PQ+4JX5WjU=
=UbB8
-----END PGP SIGNATURE-----

--Sig_/YxsKZ5_.0D9r01UEmNUex9R--
