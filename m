From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH 2/2] md/r5cache: enable chunk_aligned_read with write back cache
Date: Wed, 04 Jan 2017 15:02:48 +1100
Message-ID: <87bmvnmpzr.fsf@notabene.neil.brown.name>
References: <20161229011802.692478-1-songliubraving@fb.com> <20161229011802.692478-2-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20161229011802.692478-2-songliubraving@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: shli@fb.com, kernel-team@fb.com, dan.j.williams@intel.com, hch@infradead.org, liuzhengyuan@kylinos.cn, liuyun01@kylinos.cn, Song Liu <songliubraving@fb.com>, Jes.Sorensen@redhat.com
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 29 2016, Song Liu wrote:

> Chunk aligned read significantly reduces CPU usage of raid456.
> However, it is not safe to fully bypass the write back cache.
> This patch enables chunk aligned read with write back cache.
>
> For chunk aligned read, we track stripes in write back cache at
> a bigger granularity, "big_stripe". Each chunk may contain more
> than one stripe (for example, a 256kB chunk contains 64 4kB-page,
> so this chunk contain 64 stripes). For chunk_aligned_read, these
> stripes are grouped into one big_stripe, so we only need one lookup
> for the whole chunk.
>
> For each big_stripe, struct big_stripe_info tracks how many stripes of
> this big_stripe are in the write back cache. These data are tracked
> in a radix tree (big_stripe_tree). big_stripe_index() is used to
> calculate keys for the radix tree.
>
> chunk_aligned_read() calls r5c_big_stripe_cached() to look up
> big_stripe of each chunk in the tree. If this big_stripe is in the
> tree, chunk_aligned_read() aborts. This look up is protected by
> rcu_read_lock().
>
> It is necessary to remember whether a stripe is counted in
> big_stripe_tree. Instead of adding new flag, we reuses existing flags:
> STRIPE_R5C_PARTIAL_STRIPE and STRIPE_R5C_FULL_STRIPE. If either of these
> two flags are set, the stripe is counted in big_stripe_tree. This
> requires moving set_bit(STRIPE_R5C_PARTIAL_STRIPE) to
> r5c_try_caching_write().
>
> Signed-off-by: Song Liu <songliubraving@fb.com>
> ---
>  drivers/md/raid5-cache.c | 146 +++++++++++++++++++++++++++++++++++++++++=
+++---
>  drivers/md/raid5.c       |  19 +++---
>  drivers/md/raid5.h       |   1 +
>  3 files changed, 152 insertions(+), 14 deletions(-)
>
> diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
> index 817b294..268dcd2 100644
> --- a/drivers/md/raid5-cache.c
> +++ b/drivers/md/raid5-cache.c
> @@ -162,9 +162,60 @@ struct r5l_log {
>=20=20
>  	/* to submit async io_units, to fulfill ordering of flush */
>  	struct work_struct deferred_io_work;
> +
> +	/* to for chunk_aligned_read in writeback mode, details below */
> +	spinlock_t tree_lock;
> +	struct radix_tree_root big_stripe_tree;
> +	struct kmem_cache *bsi_kc;	/* kmem_cache for big_stripe_info */

Why use a kmem_cache.  The structure you are allocating is an atomic_t,
which is 4 or 8 bytes, so kmalloc can allocate it efficiently.  You only
need a kmem_cache for objects that are not a nice even size.

> +	mempool_t *big_stripe_info_pool;

And why a mempool? Mempool are used when the allocation mustn't fail and
you can wait for some other users of the memory to free it.  That is not
at all the case here.

As you are using a radix tree, it would probably make sense to not store
a pointer, but to store an integer directly.  Use radix_tree_replace to
update.


>  };
>=20=20
>  /*
> + * Enable chunk_aligned_read() with write back cache.
> + *
> + * Each chunk may contain more than one stripe (for example, a 256kB
> + * chunk contains 64 4kB-page, so this chunk contain 64 stripes). For
> + * chunk_aligned_read, these stripes are grouped into one "big_stripe".
> + * For each big_stripe, struct big_stripe_info tracks how many stripes of
> + * this big_stripe are in the write back cache. These data are tracked
> + * in a radix tree (big_stripe_tree). big_stripe_index() is used to
> + * calculate keys for the radix tree.
> + *
> + * chunk_aligned_read() calls r5c_big_stripe_cached() to look up
> + * big_stripe of each chunk in the tree. If this big_stripe is in the
> + * tree, chunk_aligned_read() aborts. This look up is protected by
> + * rcu_read_lock().
> + *
> + * It is necessary to remember whether a stripe is counted in
> + * big_stripe_tree. Instead of adding new flag, we reuses existing flags:
> + * STRIPE_R5C_PARTIAL_STRIPE and STRIPE_R5C_FULL_STRIPE. If either of th=
ese
> + * two flags are set, the stripe is counted in big_stripe_tree. This
> + * requires moving set_bit(STRIPE_R5C_PARTIAL_STRIPE) to
> + * r5c_try_caching_write().
> + */
> +struct big_stripe_info {
> +	atomic_t count;
> +#ifdef CONFIG_DEBUG_VM
> +	void *pad;  /* suppress size check error in kmem_cache_sanity_check */

There is a probably a reason for this error .....

> +#endif
> +};
> +
> +/*
> + * calculate key for big_stripe_tree
> + *
> + * sect: align_bi->bi_iter.bi_sector or sh->sector
> + */
> +static inline sector_t big_stripe_index(struct r5conf *conf,
> +					sector_t sect)
> +{
> +	sector_t offset;
> +
> +	offset =3D sector_div(sect, conf->chunk_sectors *
> +			    (conf->raid_disks - conf->max_degraded));

This code implies that 'sect' is a sector address in the array.
However you call this function as=20
> +		bs_index =3D big_stripe_index(conf, sh->sector);

and sh->sector is a sector address in each underlying device.
So something is definitely wrong.


> +	return sect;
> +}
> +
> +/*
>   * an IO range starts from a meta data block and end at the next meta da=
ta
>   * block. The io unit's the meta data block tracks data/parity followed =
it. io
>   * unit is written to log disk with normal write, as we always flush log=
 disk
> @@ -2293,6 +2344,8 @@ int r5c_try_caching_write(struct r5conf *conf,
>  	int i;
>  	struct r5dev *dev;
>  	int to_cache =3D 0;
> +	struct big_stripe_info *bsinfo;
> +	sector_t bs_index;
>=20=20
>  	BUG_ON(!r5c_is_writeback(log));
>=20=20
> @@ -2327,6 +2380,37 @@ int r5c_try_caching_write(struct r5conf *conf,
>  		}
>  	}
>=20=20
> +	/* if the stripe is not counted in big_stripe_tree, add it now */
> +	if (!test_bit(STRIPE_R5C_PARTIAL_STRIPE, &sh->state) &&
> +	    !test_bit(STRIPE_R5C_FULL_STRIPE, &sh->state)) {
> +		bs_index =3D big_stripe_index(conf, sh->sector);
> +		spin_lock(&log->tree_lock);
> +		bsinfo =3D radix_tree_lookup(&log->big_stripe_tree, bs_index);
> +		if (bsinfo)
> +			atomic_inc(&bsinfo->count);
> +		else {
> +			bsinfo =3D mempool_alloc(log->big_stripe_info_pool, GFP_ATOMIC);
> +			if (bsinfo) {
> +				atomic_set(&bsinfo->count, 1);
> +				radix_tree_insert(&log->big_stripe_tree, bs_index, bsinfo);

You've declared this radix_tree as
> +	INIT_RADIX_TREE(&log->big_stripe_tree, GFP_ATOMIC);

so it can be using in spinlock context, but that is only reliable if you
first call radix_tree_preload() before taking the lock.

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlhsc+kACgkQOeye3VZi
gbm/wA/8DLKxyBJaGfEGAyJWppWPMnnJ8vbk3XNsNhZ5KwJI9QME9VSGsD8VO4wG
WE1epPbzgvL1LWKS+oydV3Oz/ZJJr4otKI5BQvQR2KM7Y+4ejOu7xpXtIaJ/dBwF
gvlW993UV2CjGRt+yATQGREZPMPtTbDUPp3a8KnxLE9JXM5TPKmkYiQBVaqjhwnF
86MHSP0t6saryu0P8p6QksgR/LaXai2699nMUd5jqFwChuRYVIPGTWXsDCLqkLix
mP3fQsRwamo56s148atWUnVf3/MlIydflmvopA6kNZid0wLAlh6F6IzfKnS9wK8j
m6lV5s81mkMZvp/i9Pr5HwPAA8PZ27AdYwO9yqRpp8uLAbu8A5sTzlreDjjKMj8w
KOr1AMOhMjTwzpRpD7BSbM3+dkJyy2MAmPkxKxn6IoErcgOAYrl3EeaXxc53C8/+
ONJjNgap20fWF8aC30Q0Q3C4tSOZKOwjaRqbxhXzN2E/0uiZpkaYuMbAxS4h0s+1
5YpoERvnRTOohWp5xRxe2D/HFMgQiDpJPac9pil7gE+ClmV/bkPaW1uoaYgANLDJ
AuJHxSS/1s9KnckE1RQ9SkGgNwzS1qDrhqRUOivOCPQAwsPWvO11g8boGIHU8WOR
IGShxnKQ99ZkTUmW+YFM/bsQlGVk0DarWLbrqA1uM+5GNcFIEG8=
=6xWm
-----END PGP SIGNATURE-----
--=-=-=--
