From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH v3 05/14] md: raid1: don't use bio's vec table to manage resync pages
Date: Mon, 10 Jul 2017 09:09:08 +1000
Message-ID: <87mv8d5ht7.fsf@notabene.neil.brown.name>
References: <20170316161235.27110-1-tom.leiming@gmail.com> <20170316161235.27110-6-tom.leiming@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170316161235.27110-6-tom.leiming@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>, Jens Axboe <axboe@fb.com>, linux-raid@vger.kernel.org, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
Cc: Ming Lei <tom.leiming@gmail.com>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 17 2017, Ming Lei wrote:

> Now we allocate one page array for managing resync pages, instead
> of using bio's vec table to do that, and the old way is very hacky
> and won't work any more if multipage bvec is enabled.
>
> The introduced cost is that we need to allocate (128 + 16) * raid_disks
> bytes per r1_bio, and it is fine because the inflight r1_bio for
> resync shouldn't be much, as pointed by Shaohua.
>
> Also the bio_reset() in raid1_sync_request() is removed because
> all bios are freshly new now and not necessary to reset any more.
>
> This patch can be thought as a cleanup too
>
> Suggested-by: Shaohua Li <shli@kernel.org>
> Signed-off-by: Ming Lei <tom.leiming@gmail.com>
> ---
>  drivers/md/raid1.c | 94 +++++++++++++++++++++++++++++++++++++-----------=
------
>  1 file changed, 64 insertions(+), 30 deletions(-)
>
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index e30d89690109..0e64beb60e4d 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -80,6 +80,24 @@ static void lower_barrier(struct r1conf *conf, sector_=
t sector_nr);
>  #define raid1_log(md, fmt, args...)				\
>  	do { if ((md)->queue) blk_add_trace_msg((md)->queue, "raid1 " fmt, ##ar=
gs); } while (0)
>=20=20
> +/*
> + * 'strct resync_pages' stores actual pages used for doing the resync
> + *  IO, and it is per-bio, so make .bi_private points to it.
> + */
> +static inline struct resync_pages *get_resync_pages(struct bio *bio)
> +{
> +	return bio->bi_private;
> +}
> +
> +/*
> + * for resync bio, r1bio pointer can be retrieved from the per-bio
> + * 'struct resync_pages'.
> + */
> +static inline struct r1bio *get_resync_r1bio(struct bio *bio)
> +{
> +	return get_resync_pages(bio)->raid_bio;
> +}
> +
>  static void * r1bio_pool_alloc(gfp_t gfp_flags, void *data)
>  {
>  	struct pool_info *pi =3D data;
> @@ -107,12 +125,18 @@ static void * r1buf_pool_alloc(gfp_t gfp_flags, voi=
d *data)
>  	struct r1bio *r1_bio;
>  	struct bio *bio;
>  	int need_pages;
> -	int i, j;
> +	int j;
> +	struct resync_pages *rps;
>=20=20
>  	r1_bio =3D r1bio_pool_alloc(gfp_flags, pi);
>  	if (!r1_bio)
>  		return NULL;
>=20=20
> +	rps =3D kmalloc(sizeof(struct resync_pages) * pi->raid_disks,
> +		      gfp_flags);
> +	if (!rps)
> +		goto out_free_r1bio;
> +
>  	/*
>  	 * Allocate bios : 1 for reading, n-1 for writing
>  	 */
> @@ -132,22 +156,22 @@ static void * r1buf_pool_alloc(gfp_t gfp_flags, voi=
d *data)
>  		need_pages =3D pi->raid_disks;
>  	else
>  		need_pages =3D 1;
> -	for (j =3D 0; j < need_pages; j++) {
> +	for (j =3D 0; j < pi->raid_disks; j++) {
> +		struct resync_pages *rp =3D &rps[j];
> +
>  		bio =3D r1_bio->bios[j];
> -		bio->bi_vcnt =3D RESYNC_PAGES;
> -
> -		if (bio_alloc_pages(bio, gfp_flags))
> -			goto out_free_pages;
> -	}
> -	/* If not user-requests, copy the page pointers to all bios */
> -	if (!test_bit(MD_RECOVERY_REQUESTED, &pi->mddev->recovery)) {
> -		for (i=3D0; i<RESYNC_PAGES ; i++)
> -			for (j=3D1; j<pi->raid_disks; j++) {
> -				struct page *page =3D
> -					r1_bio->bios[0]->bi_io_vec[i].bv_page;
> -				get_page(page);
> -				r1_bio->bios[j]->bi_io_vec[i].bv_page =3D page;
> -			}
> +
> +		if (j < need_pages) {
> +			if (resync_alloc_pages(rp, gfp_flags))
> +				goto out_free_pages;
> +		} else {
> +			memcpy(rp, &rps[0], sizeof(*rp));
> +			resync_get_all_pages(rp);
> +		}
> +
> +		rp->idx =3D 0;

This is the only place the ->idx is initialized, in r1buf_pool_alloc().
The mempool alloc function is suppose to allocate memory, not initialize
it.

If the mempool_alloc() call cannot allocate memory it will use memory
from the pool.  If this memory has already been used, then it will no
longer have the initialized value.

In short: you need to initialise memory *after* calling
mempool_alloc(), unless you ensure it is reset to the init values before
calling mempool_free().

https://bugzilla.kernel.org/show_bug.cgi?id=3D196307

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAllit5YACgkQOeye3VZi
gbljMhAAmvqMYlgmRpp1LeduN2m7QCTYbZcP4wu85B35s4HN2bpbdBCDPFPz8dZ0
6i3AjoOTycIraqLNH4rLwohqT+sLoXB9IjYBCIHlR0GkGClFt7CcA7BpJodE16Q+
9bjoiimprAUZDcC903CTg3nm0UB4LznzaGTGrBz8LJK0G931HJA9sZJYZ0Ed7qff
hN7VwiXGk1OWLXRFmtYTjTQ2FNutaKy5BcvJU/JlbqDjOaF6xw4j9cC12CGdT0bv
Jyi6fls/7IaUbrmEdQOei9frMiQUClVY9lEjPVJJXP6xk8LGdDV5STCE+KVL6+ll
9PTkHiz08hEs+GTHpJT9Xe0MCWJy/6qEeaRj292YDR8ooCjeFvIF+nywEA1WNzJY
7jYvd30tNGoeXbekd1uf17JuAnY9Pgo2rg58uMxYzCoxO9JWkk/HHL8/wKZI+GP3
TeA9D9Jbv7Go5S7EFvGwDD+TSkLqupgzmtZynEom2RP7fhRp9Jkr2SwlkMkcoJju
ur1/ETs7j5/yB2lrlmIKm4bYJDwcjBM8JJxN6CsffTAVZ2hjT/sgfXZqkHwIT62v
+N6EwrgfjX10HJcPuvXWULDoNDozsbE1kNKiZfq3iErbVKhdMOQdwoQQRS9e2DBS
k80jvTnIB/oN1MGjRGFSDT5tncZI427c2i09+kjV+Ui5H8RxsWg=
=LQ88
-----END PGP SIGNATURE-----
--=-=-=--
