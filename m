From: NeilBrown <nfbrown@novell.com>
Subject: Re: [RFC 3/5] r5cache: look up stripe cache for chunk_aligned_read
Date: Wed, 01 Jun 2016 12:52:23 +1000
Message-ID: <8737oxsjrs.fsf@notabene.neil.brown.name>
References: <1464326983-3798454-1-git-send-email-songliubraving@fb.com> <1464326983-3798454-4-git-send-email-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1464326983-3798454-4-git-send-email-songliubraving@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: shli@fb.com, dan.j.williams@intel.com, hch@infradead.org, kernel-team@fb.com, Song Liu <songliubraving@fb.com>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, May 27 2016, Song Liu wrote:

> This is the read part of raid5 cache (r5cache).
>
> In raid456, when the array is in-sync, the md layer bypasses stripe
> cache for chunk_aligned_read(). However, with write back cache,
> data in the RAID disks may not be uptodate. Therefore, it is necessary
> to search the stripe cache latest data.
>
> With this patch, raid5_read_one_chunk() looks up data in stripe cache.
> The outcome of this lookup could be read_full_hit (all data of the
> chunk are in stripe cache), read_partial_hit (only part of the chunk
> is in stripe cache), or read_miss (no data of the chunk in stripe cache).
>
> For read_full_hit, raid5_read_one_chunk returns data directly from
> stripe cache; for read_miss, raid5_read_one_chunk reads all data from
> the disk; for read_partial_hit, raid5_read_one_chunk reads data from
> disk, and amends the data with data in stripe cache in endio
> (r5c_chunk_aligned_read_endio).

I wonder if all this complexity is really justified.
If we cannot bypass the cache, then we can just perform the read using
the cache with the existing code.  That will be slower than the direct
bypass, but is it so much slower that the complexity is needed.

Alternately.... is a full hit at all likely?  If data is in the stripe
cache, then there is a good chance it is in the page cache too, so it
won't be read.
If we assume that all reads will either be partial-hits or misses, then
your approach will always read from the disk, then add updates (possibly
none) from the cache.  In that case it might be simpler to do exactly
that.
i.e. schedule the read and then when that finishes, find all the stripes
which overlap and if they contain unwritten data, attach the bio and
queue for normal handling.

I suspect the code would end up being much simpler as it would reuse
more existing code.

>
> Sysfs entry is added to show statistics of read_full_hits,
> read_partial_hits, and read_misses.

I'm not sure putting statistics like this in /sys is a good idea.  If
they are just for debugging, then put them in debugfs.

>
> Signed-off-by: Song Liu <songliubraving@fb.com>
> Signed-off-by: Shaohua Li <shli@fb.com>
> ---
>  drivers/md/raid5-cache.c | 238 +++++++++++++++++++++++++++++++++++++++++=
++++++
>  drivers/md/raid5.c       |  23 ++++-
>  drivers/md/raid5.h       |   6 ++
>  3 files changed, 265 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
> index e889e2d..5f0d96f 100644
> --- a/drivers/md/raid5-cache.c
> +++ b/drivers/md/raid5-cache.c
> @@ -40,8 +40,15 @@
>   */
>  #define R5L_POOL_SIZE	4
>=20=20
> +struct r5c_cache {
> +	atomic64_t read_full_hits;	/* the whole chunk in cache */
> +	atomic64_t read_partial_hits;	/* some pages of the chunk in cache */
> +	atomic64_t read_misses;		/* the whold chunk is not in cache */
> +};

If this structure just holds statistics, then the name of the structure
should indicate that.  "r5c_cache" makes it seem like it is a cache...

> +
>  struct r5l_log {
>  	struct md_rdev *rdev;
> +	struct r5c_cache cache;
>=20=20
>  	u32 uuid_checksum;
>=20=20
> @@ -134,6 +141,21 @@ enum r5l_io_unit_state {
>  	IO_UNIT_STRIPE_END =3D 3,	/* stripes data finished writing to raid */
>  };
>=20=20
> +struct r5c_chunk_map {
> +	int sh_count;
> +	struct r5conf *conf;
> +	struct bio *parent_bi;
> +	int dd_idx;
> +	struct stripe_head *sh_array[0];
> +};
> +
> +static void init_r5c_cache(struct r5conf *conf, struct r5c_cache *cache)
> +{
> +	atomic64_set(&cache->read_full_hits, 0);
> +	atomic64_set(&cache->read_partial_hits, 0);
> +	atomic64_set(&cache->read_misses, 0);
> +}
> +
>  static sector_t r5l_ring_add(struct r5l_log *log, sector_t start, sector=
_t inc)
>  {
>  	start +=3D inc;
> @@ -1120,6 +1142,220 @@ static void r5l_write_super(struct r5l_log *log, =
sector_t cp)
>  	set_bit(MD_CHANGE_DEVS, &mddev->flags);
>  }
>=20=20
> +/* TODO: use async copy */
> +static void r5c_copy_data_to_bvec(struct r5dev *rdev, int sh_offset,
> +				  struct bio_vec *bvec, int bvec_offset, int len)
> +{
> +	/* We always copy data from orig_page. This is because in R-M-W, we use
> +	 * page to do prexor of parity */
> +	void *src_p =3D kmap_atomic(rdev->orig_page);
> +	void *dst_p =3D kmap_atomic(bvec->bv_page);
> +	memcpy(dst_p + bvec_offset, src_p + sh_offset, len);
> +	kunmap_atomic(dst_p);
> +	kunmap_atomic(src_p);
> +}
> +
> +/*
> + * copy data from a chunk_map to a bio
> + */
> +static void r5c_copy_chunk_map_to_bio(struct r5c_chunk_map *chunk_map,
> +			 struct bio *bio)
> +{
> +	struct bvec_iter iter;
> +	struct bio_vec bvec;
> +	int sh_idx;
> +	unsigned sh_offset;
> +
> +	sh_idx =3D 0;
> +	sh_offset =3D (bio->bi_iter.bi_sector & ((sector_t)STRIPE_SECTORS-1)) <=
< 9;
> +
> +	/*
> +	 * If bio is not page aligned, the chunk_map will have 1 more sh than b=
vecs
> +	 * in the bio. Chunk_map may also have NULL-sh. To copy the right data,=
 we
> +	 * need to walk through the chunk_map carefully. In this implementation,
> +	 * bvec/bvec_offset always matches with sh_array[sh_idx]/sh_offset.
> +	 *
> +	 * In the following example, the nested loop will run 4 times; and
> +	 * r5c_copy_data_to_bvec will be called for the first and last iteratio=
n.
> +	 *
> +	 *             --------------------------------
> +	 * chunk_map   | valid sh |  NULL  | valid sh |
> +	 *             --------------------------------
> +	 *                   ---------------------
> +	 * bio               |         |         |
> +	 *                   ---------------------
> +	 *
> +	 *                   |    |    |   |     |
> +	 * copy_data         | Y  | N  | N |  Y  |
> +	 */
> +	bio_for_each_segment(bvec, bio, iter) {
> +		int len;
> +		unsigned bvec_offset =3D bvec.bv_offset;
> +		while (bvec_offset < PAGE_SIZE) {
> +			len =3D min_t(unsigned, PAGE_SIZE - bvec_offset, PAGE_SIZE - sh_offse=
t);
> +			if (chunk_map->sh_array[sh_idx])
> +				r5c_copy_data_to_bvec(&chunk_map->sh_array[sh_idx]->dev[chunk_map->d=
d_idx], sh_offset,
> +						      &bvec, bvec_offset, len);
> +			bvec_offset +=3D len;
> +			sh_offset +=3D len;
> +			if (sh_offset =3D=3D PAGE_SIZE) {
> +				sh_idx +=3D 1;
> +				sh_offset =3D 0;
> +			}
> +		}
> +	}
> +	return;
> +}
> +
> +/*
> + * release stripes in chunk_map and free the chunk_map
> + */
> +static void free_r5c_chunk_map(struct r5c_chunk_map *chunk_map)
> +{
> +	unsigned sh_idx;
> +	struct stripe_head *sh;
> +
> +	for (sh_idx =3D 0; sh_idx < chunk_map->sh_count; ++sh_idx) {
> +		sh =3D chunk_map->sh_array[sh_idx];
> +		if (sh) {
> +			set_bit(STRIPE_HANDLE, &sh->state);
> +			raid5_release_stripe(sh);
> +		}
> +	}
> +	kfree(chunk_map);
> +}
> +
> +static void r5c_chunk_aligned_read_endio(struct bio *bio)
> +{
> +	struct r5c_chunk_map *chunk_map =3D (struct r5c_chunk_map *) bio->bi_pr=
ivate;
> +	struct bio *parent_bi =3D chunk_map->parent_bi;
> +
> +	r5c_copy_chunk_map_to_bio(chunk_map, bio);
> +	free_r5c_chunk_map(chunk_map);
> +	bio_put(bio);
> +	bio_endio(parent_bi);
> +}
> +
> +/*
> + * look up bio in stripe cache
> + * return raid_bio	-> no data in cache, read the chunk from disk
> + * return new r5c_bio	-> partial data in cache, read from disk, and amen=
d in r5c_align_endio
> + * return NULL		-> all data in cache, no need to read disk
> + */
> +struct bio *r5c_lookup_chunk(struct r5l_log *log, struct bio *raid_bio)
> +{
> +	struct r5conf *conf;
> +	sector_t logical_sector;
> +	sector_t first_stripe, last_stripe;  /* first (inclusive) stripe and la=
st (exclusive) */
> +	int dd_idx;
> +	struct stripe_head *sh;
> +	unsigned sh_count, sh_idx, sh_cached;
> +	struct r5c_chunk_map *chunk_map;
> +	struct bio *r5c_bio;
> +	int hash;
> +	unsigned long flags;
> +
> +	if (!log)
> +		return raid_bio;
> +
> +	conf =3D log->rdev->mddev->private;
> +
> +	logical_sector =3D raid_bio->bi_iter.bi_sector &
> +		~((sector_t)STRIPE_SECTORS-1);
> +	sh_count =3D DIV_ROUND_UP_SECTOR_T(bio_end_sector(raid_bio) - logical_s=
ector, STRIPE_SECTORS);
> +
> +	first_stripe =3D raid5_compute_sector(conf, logical_sector, 0, &dd_idx,=
 NULL);
> +	last_stripe =3D first_stripe + STRIPE_SECTORS * sh_count;
> +
> +	chunk_map =3D kzalloc(sizeof(struct r5c_chunk_map) + sh_count * sizeof(=
struct stripe_head*), GFP_NOIO);
> +	sh_cached =3D 0;
> +
> +	for (sh_idx =3D 0; sh_idx < sh_count; ++sh_idx) {
> +		hash =3D stripe_hash_locks_hash(first_stripe + sh_idx * STRIPE_SECTORS=
);
> +		spin_lock_irqsave(conf->hash_locks + hash, flags);
> +		sh =3D __find_stripe(conf, first_stripe + sh_idx * STRIPE_SECTORS, con=
f->generation);
> +		if (sh &&
> +		    test_bit(R5_UPTODATE, &sh->dev[dd_idx].flags)) {
> +			if (!atomic_inc_not_zero(&sh->count)) {
> +				spin_lock(&conf->device_lock);
> +				if (!atomic_read(&sh->count)) {
> +					if (!test_bit(STRIPE_HANDLE, &sh->state))
> +						atomic_inc(&conf->active_stripes);
> +					BUG_ON(list_empty(&sh->lru) &&
> +					       !test_bit(STRIPE_EXPANDING, &sh->state));
> +					list_del_init(&sh->lru);
> +					if (sh->group) {
> +						sh->group->stripes_cnt--;
> +						sh->group =3D NULL;
> +					}
> +				}
> +				atomic_inc(&sh->count);
> +				spin_unlock(&conf->device_lock);
> +			}
> +			chunk_map->sh_array[sh_idx] =3D sh;
> +			++sh_cached;
> +		}
> +		spin_unlock_irqrestore(conf->hash_locks + hash, flags);
> +	}
> +
> +	if (sh_cached =3D=3D 0) {
> +		atomic64_inc(&log->cache.read_misses);
> +		kfree(chunk_map);
> +		return raid_bio;
> +	}
> +
> +	chunk_map->sh_count =3D sh_count;
> +	chunk_map->dd_idx =3D dd_idx;
> +
> +	if (sh_cached =3D=3D sh_count) {
> +		atomic64_inc(&log->cache.read_full_hits);
> +		r5c_copy_chunk_map_to_bio(chunk_map, raid_bio);
> +		free_r5c_chunk_map(chunk_map);
> +		bio_endio(raid_bio);
> +		return NULL;
> +	}
> +
> +	chunk_map->parent_bi =3D raid_bio;
> +	chunk_map->conf =3D conf;
> +
> +	atomic64_inc(&log->cache.read_partial_hits);
> +
> +	/* TODO: handle bio_clone failure? */
> +	r5c_bio =3D bio_clone_mddev(raid_bio, GFP_NOIO, log->rdev->mddev);
> +
> +	r5c_bio->bi_private =3D chunk_map;
> +	r5c_bio->bi_end_io =3D r5c_chunk_aligned_read_endio;
> +
> +	return r5c_bio;
> +}
> +
> +ssize_t
> +r5c_stat_show(struct mddev *mddev, char* page)
> +{
> +	struct r5conf *conf =3D mddev->private;
> +	struct r5l_log *log;
> +	int ret =3D 0;
> +
> +	if (!conf)
> +		return 0;
> +
> +	log =3D conf->log;
> +
> +	if (!log)
> +		return 0;
> +
> +	ret +=3D snprintf(page + ret, PAGE_SIZE - ret, "r5c_read_full_hits: %ll=
u\n",
> +			(unsigned long long) atomic64_read(&log->cache.read_full_hits));
> +
> +	ret +=3D snprintf(page + ret, PAGE_SIZE - ret, "r5c_read_partial_hits: =
%llu\n",
> +			(unsigned long long) atomic64_read(&log->cache.read_partial_hits));
> +
> +	ret +=3D snprintf(page + ret, PAGE_SIZE - ret, "r5c_read_misses: %llu\n=
",
> +			(unsigned long long) atomic64_read(&log->cache.read_misses));
> +
> +	return ret;
> +}
> +
>  static int r5l_load_log(struct r5l_log *log)
>  {
>  	struct md_rdev *rdev =3D log->rdev;
> @@ -1239,6 +1475,8 @@ int r5l_init_log(struct r5conf *conf, struct md_rde=
v *rdev)
>  	INIT_LIST_HEAD(&log->no_space_stripes);
>  	spin_lock_init(&log->no_space_stripes_lock);
>=20=20
> +	init_r5c_cache(conf, &log->cache);
> +
>  	if (r5l_load_log(log))
>  		goto error;
>=20=20
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index dc24b664..cdd9c4b 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -503,7 +503,7 @@ retry:
>  	set_bit(STRIPE_BATCH_READY, &sh->state);
>  }
>=20=20
> -static struct stripe_head *__find_stripe(struct r5conf *conf, sector_t s=
ector,
> +struct stripe_head *__find_stripe(struct r5conf *conf, sector_t sector,
>  					 short generation)
>  {
>  	struct stripe_head *sh;
> @@ -515,6 +515,7 @@ static struct stripe_head *__find_stripe(struct r5con=
f *conf, sector_t sector,
>  	pr_debug("__stripe %llu not in cache\n", (unsigned long long)sector);
>  	return NULL;
>  }
> +EXPORT_SYMBOL(__find_stripe);

Why are you exporting this?  raid5-cache is not a separate module.
If you were going the export it the name would need to be changed to
include "md_".


NeilBrown


>=20=20
>  /*
>   * Need to check if array has failed when deciding whether to:
> @@ -4726,7 +4727,8 @@ static int raid5_read_one_chunk(struct mddev *mddev=
, struct bio *raid_bio)
>  {
>  	struct r5conf *conf =3D mddev->private;
>  	int dd_idx;
> -	struct bio* align_bi;
> +	struct bio *align_bi;
> +	struct bio *r5c_bio;
>  	struct md_rdev *rdev;
>  	sector_t end_sector;
>=20=20
> @@ -4734,6 +4736,18 @@ static int raid5_read_one_chunk(struct mddev *mdde=
v, struct bio *raid_bio)
>  		pr_debug("%s: non aligned\n", __func__);
>  		return 0;
>  	}
> +
> +	r5c_bio =3D r5c_lookup_chunk(conf->log, raid_bio);
> +
> +	if (r5c_bio =3D=3D NULL) {
> +		pr_debug("Read all data from stripe cache\n");
> +		return 1;
> +	} else if (r5c_bio =3D=3D raid_bio)
> +		pr_debug("No data in stripe cache, read all from disk\n");
> +	else {
> +		pr_debug("Partial data in stripe cache, read and amend\n");
> +		raid_bio =3D r5c_bio;
> +	}
>  	/*
>  	 * use bio_clone_mddev to make a copy of the bio
>  	 */
> @@ -6157,6 +6171,10 @@ raid5_group_thread_cnt =3D __ATTR(group_thread_cnt=
, S_IRUGO | S_IWUSR,
>  				raid5_show_group_thread_cnt,
>  				raid5_store_group_thread_cnt);
>=20=20
> +static struct md_sysfs_entry
> +r5c_cache_stats =3D __ATTR(r5c_cache_stats, S_IRUGO,
> +			 r5c_stat_show, NULL);
> +
>  static struct attribute *raid5_attrs[] =3D  {
>  	&raid5_stripecache_size.attr,
>  	&raid5_stripecache_active.attr,
> @@ -6164,6 +6182,7 @@ static struct attribute *raid5_attrs[] =3D  {
>  	&raid5_group_thread_cnt.attr,
>  	&raid5_skip_copy.attr,
>  	&raid5_rmw_level.attr,
> +	&r5c_cache_stats.attr,
>  	NULL,
>  };
>  static struct attribute_group raid5_attrs_group =3D {
> diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
> index 3b68d4f..de11514 100644
> --- a/drivers/md/raid5.h
> +++ b/drivers/md/raid5.h
> @@ -690,4 +690,10 @@ extern void r5l_stripe_write_finished(struct stripe_=
head *sh);
>  extern int r5l_handle_flush_request(struct r5l_log *log, struct bio *bio=
);
>  extern void r5l_quiesce(struct r5l_log *log, int state);
>  extern bool r5l_log_disk_error(struct r5conf *conf);
> +
> +extern struct bio *r5c_lookup_chunk(struct r5l_log *log, struct bio *rai=
d_bio);
> +extern struct stripe_head *__find_stripe(struct r5conf *conf, sector_t s=
ector,
> +					 short generation);
> +
> +extern ssize_t r5c_stat_show(struct mddev *mddev, char* page);
>  #endif
> --=20
> 2.8.0.rc2

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJXTk3oAAoJEDnsnt1WYoG5OUkQALX56HA8EAL85mwkqizD5kdg
E0D08qgsEsIOiVWDAl/ncmN1g3FGqp6I3Y4p3z7m7ShW9A52THI6Zq1KBrCxGwJ+
g2OGDK4JvYZ4lvmtjUp1w+FWEjo9scGC4YMkAHFskpcpHwRgmEtMYocNBfw7zMgB
dzXfoDNlzys/VPJKht3a16GhcJDRGm5Y9CtHFMwhvQ0BHgBIL49IEI/2Cu3L6/c8
lS2y1SJqVE8oNl//lE5YHEWXLtBkMQtNIDTQ/XA15LKCjlQ55qecNTjDiih+vva+
kWpBh43ONxF6ItH9xN+/S5wRqDH/vvWsZfxmrDK41wFaRfhSOQOd41fHCenzKlIU
52CW0p9lQh+P3X4lf8qd5EEEi8RWOH2+Tw5oRyLAXYiftOs8b6Z367uDQwhVhJ0h
PKq5JPICcGbC3wlN+woJWpcaZabHLUEn+KCfBZ4yVL1CedlQQ5PtzZQ4wdo+SesU
2dPDuDcUlYGHFmZDop2L5JDsH4JSBucdwLIp+ycMMzG6X1b8hyM8YIRo0a4Z/30q
rUWm6i1B/yV2YxZvc7i+DNAeA8cw7lJjrKHfGB5+wNUEkG+MS9HpWGiFAVBvAoOY
jehlzjDGPKP1kP03H14mr3xvFw6yha1UdZZycFAxbnhSilfBKbScBzt8OMDSVa7x
pa5GlqRRXkpmQCDUXxlj
=ODCi
-----END PGP SIGNATURE-----
--=-=-=--
