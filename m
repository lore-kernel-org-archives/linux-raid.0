From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH 1/2] raid5-cache: use a bio_set
Date: Wed, 09 Dec 2015 10:22:12 +1100
Message-ID: <87bna0r0ez.fsf@notabene.neil.brown.name>
References: <1449072638-15409-1-git-send-email-hch@lst.de> <1449072638-15409-2-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1449072638-15409-2-git-send-email-hch@lst.de>
Sender: linux-raid-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, shli@fb.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 03 2015, Christoph Hellwig wrote:

> This allows us to make guaranteed forward progress.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/md/raid5-cache.c | 16 +++++++++++++++-
>  1 file changed, 15 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
> index 668e973..ef59564 100644
> --- a/drivers/md/raid5-cache.c
> +++ b/drivers/md/raid5-cache.c
> @@ -34,6 +34,12 @@
>  #define RECLAIM_MAX_FREE_SPACE (10 * 1024 * 1024 * 2) /* sector */
>  #define RECLAIM_MAX_FREE_SPACE_SHIFT (2)
>=20=20
> +/*
> + * We only need 2 bios per I/O unit to make progress, but ensure we
> + * have a few more available to not get too tight.
> + */
> +#define R5L_POOL_SIZE	1024
> +

I'm really suspicious of big pool sizes.
The memory allocated to the pool is almost never used - only where no
other memory is available - so large pools are largely wasted.

As you say, we need 2 bios per unit, and unit submission is serialized
(by ->io_mutex) so '2' really should be enough.  For the very brief
periods when there is no other memory, there will only be one or two
units in flight at once, but as each one gets us closer to freeing real
memory, that shouldn't last long.

I can easily justify '4' as "double buffering" is a well understood
technique, but 1024 just seems like gratuitous waste.

If you have performance numbers that tell me I'm wrong I'll stand
corrected, but without evidence I much prefer a smaller number.

Otherwise I really like the change.

Thanks,
NeilBrown


>  struct r5l_log {
>  	struct md_rdev *rdev;
>=20=20
> @@ -70,6 +76,7 @@ struct r5l_log {
>  	struct bio flush_bio;
>=20=20
>  	struct kmem_cache *io_kc;
> +	struct bio_set *bs;
>=20=20
>  	struct md_thread *reclaim_thread;
>  	unsigned long reclaim_target;	/* number of space that need to be
> @@ -248,7 +255,7 @@ static void r5l_submit_current_io(struct r5l_log *log)
>=20=20
>  static struct bio *r5l_bio_alloc(struct r5l_log *log)
>  {
> -	struct bio *bio =3D bio_kmalloc(GFP_NOIO | __GFP_NOFAIL, BIO_MAX_PAGES);
> +	struct bio *bio =3D bio_alloc_bioset(GFP_NOIO, BIO_MAX_PAGES, log->bs);
>=20=20
>  	bio->bi_rw =3D WRITE;
>  	bio->bi_bdev =3D log->rdev->bdev;
> @@ -1153,6 +1160,10 @@ int r5l_init_log(struct r5conf *conf, struct md_rd=
ev *rdev)
>  	if (!log->io_kc)
>  		goto io_kc;
>=20=20
> +	log->bs =3D bioset_create(R5L_POOL_SIZE, 0);
> +	if (!log->bs)
> +		goto io_bs;
> +
>  	log->reclaim_thread =3D md_register_thread(r5l_reclaim_thread,
>  						 log->rdev->mddev, "reclaim");
>  	if (!log->reclaim_thread)
> @@ -1170,6 +1181,8 @@ int r5l_init_log(struct r5conf *conf, struct md_rde=
v *rdev)
>  error:
>  	md_unregister_thread(&log->reclaim_thread);
>  reclaim_thread:
> +	bioset_free(log->bs);
> +io_bs:
>  	kmem_cache_destroy(log->io_kc);
>  io_kc:
>  	kfree(log);
> @@ -1179,6 +1192,7 @@ io_kc:
>  void r5l_exit_log(struct r5l_log *log)
>  {
>  	md_unregister_thread(&log->reclaim_thread);
> +	bioset_free(log->bs);
>  	kmem_cache_destroy(log->io_kc);
>  	kfree(log);
>  }
> --=20
> 1.9.1

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWZ2YkAAoJEDnsnt1WYoG5cg4P/3mMQ5NbuJ7OtDkP2BB89QW+
3285S0oQ2ed3UCxQrvcONMaVVDO5rolbW6jK2R4Ls8J06Rv6FVcA1xSDojvwlbo7
nZGYjf7VcOezDqXcEv/GI9DD8ZirjzIJdAsin/8sNhstkD8dyZ24kOhb50wuiYpU
ZJlbexbMr/wxnnfaPD78aeJaYxt5tyC7CCY8amRA+8+LtOPgDfcb2/jnovL884B9
m0tt8G2VxrS1e9q6xhmvEtaMx8UYchjknIfsTYRWafN/KgCgpMLN95qLVo2QUa2G
eJKEu/8a/R5B/oWV2EyCJPrxzGmBq5o6XV4x0qBjZcpITk4YKpulQ9cwjdxsxwIJ
jCkUGxdCqhrGRVxTAyhc26SaGs5PaCtwb+BhyWrcb2R62xvF1tX5zumBgidCkCWh
hai96oVGdM9g0HDiY2r9RmvHMW1aiJ+I8+HHfNhEjIfDTk48wInG+mcK9bIC13Mp
+17qSqPKSreHCcc6E6oE/Pn1HL9vQfCoPC4zhwJI4bVjvfTo1EoxytEuUS2Ebqxu
LIzodNoRFCqKKn1N5H/sp6aAkshEQSaKYmYrVFxT7yWrtMGDEBJHNfdeZauMUsOD
6cGNRx7irQ0VkNgIWroQQhFq4WS3fYU8U8LL3I+KjpkmbPQFiZ98qvuI3LgxoHPc
DUYpTllWR0z9gpSMPAPx
=gB8s
-----END PGP SIGNATURE-----
--=-=-=--
