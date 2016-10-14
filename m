From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH v5 4/8] md/r5cache: write part of r5cache
Date: Fri, 14 Oct 2016 17:53:29 +1100
Message-ID: <87lgxrzaja.fsf@notabene.neil.brown.name>
References: <20161013054944.1038806-1-songliubraving@fb.com> <20161013054944.1038806-5-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20161013054944.1038806-5-songliubraving@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: shli@fb.com, kernel-team@fb.com, dan.j.williams@intel.com, hch@infradead.org, liuzhengyuang521@gmail.com, liuzhengyuan@kylinos.cn, Song Liu <songliubraving@fb.com>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 13 2016, Song Liu wrote:

> This is the write part of r5cache. The cache is integrated with
> stripe cache of raid456. It leverages code of r5l_log to write
> data to journal device.
>
> r5cache split current write path into 2 parts: the write path
> and the reclaim path. The write path is as following:
> 1. write data to journal
>    (r5c_handle_stripe_dirtying, r5c_cache_data)
> 2. call bio_endio
>    (r5c_handle_data_cached, r5c_return_dev_pending_writes).
>
> Then the reclaim path is as:
> 1. Freeze the stripe (r5c_freeze_stripe_for_reclaim)
> 2. Calcualte parity (reconstruct or RMW)
> 3. Write parity (and maybe some other data) to journal device
> 4. Write data and parity to RAID disks
>
> Reclaim path of the cache is implemented in the next patch.
>
> With r5cache, write operation does not wait for parity calculation
> and write out, so the write latency is lower (1 write to journal
> device vs. read and then write to raid disks). Also, r5cache will
> reduce RAID overhead (multipile IO due to read-modify-write of
> parity) and provide more opportunities of full stripe writes.
>
> This patch adds 2 flags to stripe_head.state:
>  - STRIPE_R5C_PARTIAL_STRIPE,
>  - STRIPE_R5C_FULL_STRIPE,
>
> Instead of inactive_list, stripes with cached data are tracked in
> r5conf->r5c_full_stripe_list and r5conf->r5c_partial_stripe_list.
> STRIPE_R5C_FULL_STRIPE and STRIPE_R5C_PARTIAL_STRIPE are flags for
> stripes in these lists. Note: stripes in r5c_full/partial_stripe_list
> are not considered as "active".
>
> For RMW, the code allocates an extra page for each data block
> being updated.  This is stored in r5dev->page and the old data
> is read into it.  Then the prexor calculation subtracts ->page
> from the parity block, and the reconstruct calculation adds the
> ->orig_page data back into the parity block.

What happens if the alloc_page() fails?

>
> r5cache naturally excludes SkipCopy. With R5_Wantcache bit set,
> async_copy_data will not skip copy.
>
> There are some known limitations of the cache implementation:
>
> 1. Write cache only covers full page writes (R5_OVERWRITE). Writes
>    of smaller granularity are write through.
> 2. Only one log io (sh->log_io) for each stripe at anytime. Later
>    writes for the same stripe have to wait. This can be improved by
>    moving log_io to r5dev.
> 3. With writeback cache, read path must enter state machine, which
>    is a significant bottleneck for some workloads.
> 4. There is no per stripe checkpoint (with r5l_payload_flush) in
>    the log, so recovery code has to replay more than necessary data
>    (sometimes all the log from last_checkpoint). This reduces
>    availability of the array.
>
> This patch includes a fix proposed by ZhengYuan Liu
> <liuzhengyuan@kylinos.cn>
>
> Signed-off-by: Song Liu <songliubraving@fb.com>

You introduce a new flag:
> +	R5_InCache,	/* Data in cache */

but don't document it at all (apart from those three words).
I must confess that I found it confuses when you talk about the
"journal" as the "cache".  I understand way, but in my mind, the "cache"
is the in-memory cache of stripe_heads.
We now have something that we sometimes call a "journal", sometimes call
a "log" and sometimes call a "cache".  That is a recipe for confusion.

A sentence or two explaining how this flag will be used would help in
reading the rest of the code.


> ---
>  drivers/md/raid5-cache.c | 204 +++++++++++++++++++++++++++++++++++++++++=
++++--
>  drivers/md/raid5.c       | 144 ++++++++++++++++++++++++++++-----
>  drivers/md/raid5.h       |  22 +++++
>  3 files changed, 344 insertions(+), 26 deletions(-)
>
> diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
> index 9e05850..92d3d7b 100644
> --- a/drivers/md/raid5-cache.c
> +++ b/drivers/md/raid5-cache.c
> @@ -20,6 +20,7 @@
>  #include <linux/random.h>
>  #include "md.h"
>  #include "raid5.h"
> +#include "bitmap.h"
>=20=20
>  /*
>   * metadata/data stored in disk with 4k size unit (a block) regardless
> @@ -217,6 +218,44 @@ static void __r5l_set_io_unit_state(struct r5l_io_un=
it *io,
>  	io->state =3D state;
>  }
>=20=20
> +static void
> +r5c_return_dev_pending_writes(struct r5conf *conf, struct r5dev *dev,
> +			      struct bio_list *return_bi)
> +{
> +	struct bio *wbi, *wbi2;
> +
> +	wbi =3D dev->written;
> +	dev->written =3D NULL;
> +	while (wbi && wbi->bi_iter.bi_sector <
> +	       dev->sector + STRIPE_SECTORS) {
> +		wbi2 =3D r5_next_bio(wbi, dev->sector);
> +		if (!raid5_dec_bi_active_stripes(wbi)) {
> +			md_write_end(conf->mddev);
> +			bio_list_add(return_bi, wbi);
> +		}
> +		wbi =3D wbi2;
> +	}
> +}
> +
> +void r5c_handle_cached_data_endio(struct r5conf *conf,
> +	  struct stripe_head *sh, int disks, struct bio_list *return_bi)
> +{
> +	int i;
> +
> +	for (i =3D sh->disks; i--; ) {
> +		if (test_bit(R5_InCache, &sh->dev[i].flags) &&
> +		    sh->dev[i].written) {

Is it possible for R5_InCache to be set, but 'written' to be NULL ???

> +			set_bit(R5_UPTODATE, &sh->dev[i].flags);
> +			r5c_return_dev_pending_writes(conf, &sh->dev[i],
> +						      return_bi);
> +			bitmap_endwrite(conf->mddev->bitmap, sh->sector,
> +					STRIPE_SECTORS,
> +					!test_bit(STRIPE_DEGRADED, &sh->state),
> +					0);
> +		}
> +	}
> +}
> +
>  /*
>   * Freeze the stripe, thus send the stripe into reclaim path.
>   *
> @@ -233,6 +272,48 @@ void r5c_freeze_stripe_for_reclaim(struct stripe_hea=
d *sh)
>  		return;
>  	WARN_ON(test_bit(STRIPE_R5C_FROZEN, &sh->state));
>  	set_bit(STRIPE_R5C_FROZEN, &sh->state);
> +
> +	if (log->r5c_state =3D=3D R5C_STATE_WRITE_THROUGH)
> +		return;
> +
> +	if (!test_and_set_bit(STRIPE_PREREAD_ACTIVE, &sh->state))
> +		atomic_inc(&conf->preread_active_stripes);
> +
> +	if (test_and_clear_bit(STRIPE_R5C_PARTIAL_STRIPE, &sh->state)) {
> +		BUG_ON(atomic_read(&conf->r5c_cached_partial_stripes) =3D=3D 0);
> +		atomic_dec(&conf->r5c_cached_partial_stripes);
> +	}
> +
> +	if (test_and_clear_bit(STRIPE_R5C_FULL_STRIPE, &sh->state)) {
> +		BUG_ON(atomic_read(&conf->r5c_cached_full_stripes) =3D=3D 0);
> +		atomic_dec(&conf->r5c_cached_full_stripes);
> +	}
> +}
> +
> +static void r5c_handle_data_cached(struct stripe_head *sh)
> +{
> +	int i;
> +
> +	for (i =3D sh->disks; i--; )
> +		if (test_and_clear_bit(R5_Wantcache, &sh->dev[i].flags)) {
> +			set_bit(R5_InCache, &sh->dev[i].flags);
> +			clear_bit(R5_LOCKED, &sh->dev[i].flags);
> +			atomic_inc(&sh->dev_in_cache);
> +		}
> +}
> +
> +/*
> + * this journal write must contain full parity,
> + * it may also contain some data pages
> + */
> +static void r5c_handle_parity_cached(struct stripe_head *sh)
> +{
> +	int i;
> +
> +	for (i =3D sh->disks; i--; )
> +		if (test_bit(R5_InCache, &sh->dev[i].flags))
> +			set_bit(R5_Wantwrite, &sh->dev[i].flags);
> +	set_bit(STRIPE_R5C_WRITTEN, &sh->state);
>  }
>=20=20
>  static void r5c_finish_cache_stripe(struct stripe_head *sh)
> @@ -242,8 +323,10 @@ static void r5c_finish_cache_stripe(struct stripe_he=
ad *sh)
>  	if (log->r5c_state =3D=3D R5C_STATE_WRITE_THROUGH) {
>  		BUG_ON(!test_bit(STRIPE_R5C_FROZEN, &sh->state));
>  		set_bit(STRIPE_R5C_WRITTEN, &sh->state);
> -	} else
> -		BUG(); /* write back logic in next patch */
> +	} else if (test_bit(STRIPE_R5C_FROZEN, &sh->state))
> +		r5c_handle_parity_cached(sh);
> +	else
> +		r5c_handle_data_cached(sh);
>  }
>=20=20
>  static void r5l_io_run_stripes(struct r5l_io_unit *io)
> @@ -483,7 +566,8 @@ static int r5l_log_stripe(struct r5l_log *log, struct=
 stripe_head *sh,
>  	io =3D log->current_io;
>=20=20
>  	for (i =3D 0; i < sh->disks; i++) {
> -		if (!test_bit(R5_Wantwrite, &sh->dev[i].flags))
> +		if (!test_bit(R5_Wantwrite, &sh->dev[i].flags) &&
> +		    !test_bit(R5_Wantcache, &sh->dev[i].flags))
>  			continue;

If changed R5_Wantcache to R5_Wantjournal, and always set it on blocks
that were destined for the journal, then this would just be

 		if (!test_bit(R5_Wantjournal, &sh->dev[i].flags))

which would make lots of sense...  Just a thought.

>  		if (i =3D=3D sh->pd_idx || i =3D=3D sh->qd_idx)
>  			continue;
> @@ -514,7 +598,6 @@ static int r5l_log_stripe(struct r5l_log *log, struct=
 stripe_head *sh,
>  	return 0;
>  }
>=20=20
> -static void r5l_wake_reclaim(struct r5l_log *log, sector_t space);
>  /*
>   * running in raid5d, where reclaim could wait for raid5d too (when it f=
lushes
>   * data from log to raid disks), so we shouldn't wait for reclaim here
> @@ -544,6 +627,10 @@ int r5l_write_stripe(struct r5l_log *log, struct str=
ipe_head *sh)
>=20=20
>  		if (!test_bit(R5_Wantwrite, &sh->dev[i].flags))
>  			continue;
> +
> +		if (test_bit(R5_InCache, &sh->dev[i].flags))
> +			continue;
> +
>  		write_disks++;
>  		/* checksum is already calculated in last run */
>  		if (test_bit(STRIPE_LOG_TRAPPED, &sh->state))
> @@ -809,7 +896,6 @@ static void r5l_write_super_and_discard_space(struct =
r5l_log *log,
>  	}
>  }
>=20=20
> -
>  static void r5l_do_reclaim(struct r5l_log *log)
>  {
>  	sector_t reclaim_target =3D xchg(&log->reclaim_target, 0);
> @@ -872,7 +958,7 @@ static void r5l_reclaim_thread(struct md_thread *thre=
ad)
>  	r5l_do_reclaim(log);
>  }
>=20=20
> -static void r5l_wake_reclaim(struct r5l_log *log, sector_t space)
> +void r5l_wake_reclaim(struct r5l_log *log, sector_t space)

Why are you removing the 'static' here?  You don't call it from any
other file.

>  {
>  	unsigned long target;
>  	unsigned long new =3D (unsigned long)space; /* overflow in theory */
> @@ -1191,6 +1277,8 @@ int r5c_handle_stripe_dirtying(struct r5conf *conf,
>  			       int disks)
>  {
>  	struct r5l_log *log =3D conf->log;
> +	int i;
> +	struct r5dev *dev;
>=20=20
>  	if (!log || test_bit(STRIPE_R5C_FROZEN, &sh->state))
>  		return -EAGAIN;
> @@ -1201,21 +1289,121 @@ int r5c_handle_stripe_dirtying(struct r5conf *co=
nf,
>  		r5c_freeze_stripe_for_reclaim(sh);
>  		return -EAGAIN;
>  	}
> -	BUG();  /* write back logic in next commit */
> +
> +	s->to_cache =3D 0;
> +
> +	for (i =3D disks; i--; ) {
> +		dev =3D &sh->dev[i];
> +		/* if none-overwrite, use the reclaim path (write through) */
                      non-overwrite

> +		if (dev->towrite && !test_bit(R5_OVERWRITE, &dev->flags) &&
> +		    !test_bit(R5_InCache, &dev->flags)) {
> +			r5c_freeze_stripe_for_reclaim(sh);
> +			return -EAGAIN;
> +		}
> +	}
> +
> +	for (i =3D disks; i--; ) {
> +		dev =3D &sh->dev[i];
> +		if (dev->towrite) {
> +			set_bit(R5_Wantcache, &dev->flags);
> +			set_bit(R5_Wantdrain, &dev->flags);
> +			set_bit(R5_LOCKED, &dev->flags);
> +			s->to_cache++;
> +		}
> +	}
> +
> +	if (s->to_cache)
> +		set_bit(STRIPE_OP_BIODRAIN, &s->ops_request);
> +
>  	return 0;
>  }
>=20=20
>  /*
>   * clean up the stripe (clear STRIPE_R5C_FROZEN etc.) after the stripe is
>   * committed to RAID disks
> -*/
> + */
>  void r5c_handle_stripe_written(struct r5conf *conf,
>  			       struct stripe_head *sh)
>  {
> +	int i;
> +	int do_wakeup =3D 0;
> +
>  	if (!test_and_clear_bit(STRIPE_R5C_WRITTEN, &sh->state))
>  		return;
>  	WARN_ON(!test_bit(STRIPE_R5C_FROZEN, &sh->state));
>  	clear_bit(STRIPE_R5C_FROZEN, &sh->state);
> +
> +	if (conf->log->r5c_state =3D=3D R5C_STATE_WRITE_THROUGH)
> +		return;
> +
> +	for (i =3D sh->disks; i--; ) {
> +		if (test_and_clear_bit(R5_InCache, &sh->dev[i].flags))
> +			atomic_dec(&sh->dev_in_cache);
> +		if (test_and_clear_bit(R5_Overlap, &sh->dev[i].flags))
> +			do_wakeup =3D 1;
> +	}
> +
> +	if (test_and_clear_bit(STRIPE_FULL_WRITE, &sh->state))
> +		if (atomic_dec_and_test(&conf->pending_full_writes))
> +			md_wakeup_thread(conf->mddev->thread);
> +
> +	if (do_wakeup)
> +		wake_up(&conf->wait_for_overlap);
> +}
> +
> +int
> +r5c_cache_data(struct r5l_log *log, struct stripe_head *sh,
> +	       struct stripe_head_state *s)
> +{
> +	int pages;
> +	int reserve;
> +	int i;
> +	int ret =3D 0;
> +	int page_count =3D 0;
> +
> +	BUG_ON(!log);
> +
> +	for (i =3D 0; i < sh->disks; i++) {
> +		void *addr;
> +
> +		if (!test_bit(R5_Wantcache, &sh->dev[i].flags))
> +			continue;
> +		addr =3D kmap_atomic(sh->dev[i].page);
> +		sh->dev[i].log_checksum =3D crc32c_le(log->uuid_checksum,
> +						    addr, PAGE_SIZE);
> +		kunmap_atomic(addr);
> +		page_count++;
> +	}
> +	WARN_ON(page_count !=3D s->to_cache);
> +	pages =3D s->to_cache;
> +
> +	/*
> +	 * The stripe must enter state machine again to call endio, so
> +	 * don't delay.
> +	 */
> +	clear_bit(STRIPE_DELAYED, &sh->state);
> +	atomic_inc(&sh->count);
> +
> +	mutex_lock(&log->io_mutex);
> +	/* meta + data */
> +	reserve =3D (1 + pages) << (PAGE_SHIFT - 9);
> +	if (!r5l_has_free_space(log, reserve)) {
> +		spin_lock(&log->no_space_stripes_lock);
> +		list_add_tail(&sh->log_list, &log->no_space_stripes);
> +		spin_unlock(&log->no_space_stripes_lock);
> +
> +		r5l_wake_reclaim(log, reserve);
> +	} else {
> +		ret =3D r5l_log_stripe(log, sh, pages, 0);
> +		if (ret) {
> +			spin_lock_irq(&log->io_list_lock);
> +			list_add_tail(&sh->log_list, &log->no_mem_stripes);
> +			spin_unlock_irq(&log->io_list_lock);
> +		}
> +	}
> +
> +	mutex_unlock(&log->io_mutex);
> +	return 0;
>  }
>=20=20
>  static int r5l_load_log(struct r5l_log *log)
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 2e3e61a..0539f34 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -245,8 +245,25 @@ static void do_release_stripe(struct r5conf *conf, s=
truct stripe_head *sh,
>  			    < IO_THRESHOLD)
>  				md_wakeup_thread(conf->mddev->thread);
>  		atomic_dec(&conf->active_stripes);
> -		if (!test_bit(STRIPE_EXPANDING, &sh->state))
> -			list_add_tail(&sh->lru, temp_inactive_list);
> +		if (!test_bit(STRIPE_EXPANDING, &sh->state)) {
> +			if (atomic_read(&sh->dev_in_cache) =3D=3D 0) {
> +				list_add_tail(&sh->lru, temp_inactive_list);
> +			} else if (atomic_read(&sh->dev_in_cache) =3D=3D
> +				   conf->raid_disks - conf->max_degraded) {

Is this really the test that you want?
Presumably "full stripes" are those that can be written out without
reading anything, while "partial stripes" will need something read in
first.
It is possible that the stripe head contains data for some devices which
is not in the cache, possibly because a READ request filled it in.
So we should really be counting the number of devices with R5_UPTODATE.
??

> +				/* full stripe */
> +				if (!test_and_set_bit(STRIPE_R5C_FULL_STRIPE, &sh->state))
> +					atomic_inc(&conf->r5c_cached_full_stripes);
> +				if (test_and_clear_bit(STRIPE_R5C_PARTIAL_STRIPE, &sh->state))
> +					atomic_dec(&conf->r5c_cached_partial_stripes);
> +				list_add_tail(&sh->lru, &conf->r5c_full_stripe_list);
> +			} else {
> +				/* partial stripe */
> +				if (!test_and_set_bit(STRIPE_R5C_PARTIAL_STRIPE,
> +						      &sh->state))
> +					atomic_inc(&conf->r5c_cached_partial_stripes);
> +				list_add_tail(&sh->lru, &conf->r5c_partial_stripe_list);
> +			}
> +		}
>  	}
>  }
>=20=20
> @@ -830,6 +847,11 @@ static void ops_run_io(struct stripe_head *sh, struc=
t stripe_head_state *s)
>=20=20
>  	might_sleep();
>=20=20
> +	if (s->to_cache) {
> +		r5c_cache_data(conf->log, sh, s);
> +		return;
> +	}
> +
>  	if (r5l_write_stripe(conf->log, sh) =3D=3D 0)
>  		return;
>  	for (i =3D disks; i--; ) {
> @@ -1044,7 +1066,7 @@ again:
>  static struct dma_async_tx_descriptor *
>  async_copy_data(int frombio, struct bio *bio, struct page **page,
>  	sector_t sector, struct dma_async_tx_descriptor *tx,
> -	struct stripe_head *sh)
> +	struct stripe_head *sh, int no_skipcopy)
>  {
>  	struct bio_vec bvl;
>  	struct bvec_iter iter;
> @@ -1084,7 +1106,8 @@ async_copy_data(int frombio, struct bio *bio, struc=
t page **page,
>  			if (frombio) {
>  				if (sh->raid_conf->skip_copy &&
>  				    b_offset =3D=3D 0 && page_offset =3D=3D 0 &&
> -				    clen =3D=3D STRIPE_SIZE)
> +				    clen =3D=3D STRIPE_SIZE &&
> +				    !no_skipcopy)
>  					*page =3D bio_page;
>  				else
>  					tx =3D async_memcpy(*page, bio_page, page_offset,
> @@ -1166,7 +1189,7 @@ static void ops_run_biofill(struct stripe_head *sh)
>  			while (rbi && rbi->bi_iter.bi_sector <
>  				dev->sector + STRIPE_SECTORS) {
>  				tx =3D async_copy_data(0, rbi, &dev->page,
> -					dev->sector, tx, sh);
> +						     dev->sector, tx, sh, 0);
>  				rbi =3D r5_next_bio(rbi, dev->sector);
>  			}
>  		}
> @@ -1293,7 +1316,8 @@ static int set_syndrome_sources(struct page **srcs,
>  		if (i =3D=3D sh->qd_idx || i =3D=3D sh->pd_idx ||
>  		    (srctype =3D=3D SYNDROME_SRC_ALL) ||
>  		    (srctype =3D=3D SYNDROME_SRC_WANT_DRAIN &&
> -		     test_bit(R5_Wantdrain, &dev->flags)) ||
> +		     (test_bit(R5_Wantdrain, &dev->flags) ||
> +		      test_bit(R5_InCache, &dev->flags))) ||
>  		    (srctype =3D=3D SYNDROME_SRC_WRITTEN &&
>  		     dev->written))
>  			srcs[slot] =3D sh->dev[i].page;
> @@ -1472,9 +1496,25 @@ ops_run_compute6_2(struct stripe_head *sh, struct =
raid5_percpu *percpu)
>  static void ops_complete_prexor(void *stripe_head_ref)
>  {
>  	struct stripe_head *sh =3D stripe_head_ref;
> +	int i;
>=20=20
>  	pr_debug("%s: stripe %llu\n", __func__,
>  		(unsigned long long)sh->sector);
> +
> +	if (!r5c_is_writeback(sh->raid_conf->log))
> +		return;
> +
> +	/*
> +	 * raid5-cache write back uses orig_page during prexor. after prexor,
> +	 * it is time to free orig_page
> +	 */
> +	for (i =3D sh->disks; i--; )
> +		if (sh->dev[i].page !=3D sh->dev[i].orig_page) {
> +			struct page *p =3D sh->dev[i].page;
> +
> +			sh->dev[i].page =3D sh->dev[i].orig_page;
> +			put_page(p);
> +		}
>  }
>=20=20
>  static struct dma_async_tx_descriptor *
> @@ -1496,7 +1536,8 @@ ops_run_prexor5(struct stripe_head *sh, struct raid=
5_percpu *percpu,
>  	for (i =3D disks; i--; ) {
>  		struct r5dev *dev =3D &sh->dev[i];
>  		/* Only process blocks that are known to be uptodate */
> -		if (test_bit(R5_Wantdrain, &dev->flags))
> +		if (test_bit(R5_Wantdrain, &dev->flags) ||
> +		    test_bit(R5_InCache, &dev->flags))
>  			xor_srcs[count++] =3D dev->page;
>  	}
>=20=20
> @@ -1547,6 +1588,10 @@ ops_run_biodrain(struct stripe_head *sh, struct dm=
a_async_tx_descriptor *tx)
>=20=20
>  again:
>  			dev =3D &sh->dev[i];
> +			if (test_and_clear_bit(R5_InCache, &dev->flags)) {
> +				BUG_ON(atomic_read(&sh->dev_in_cache) =3D=3D 0);
> +				atomic_dec(&sh->dev_in_cache);
> +			}
>  			spin_lock_irq(&sh->stripe_lock);
>  			chosen =3D dev->towrite;
>  			dev->towrite =3D NULL;
> @@ -1566,8 +1611,10 @@ again:
>  					set_bit(R5_Discard, &dev->flags);
>  				else {
>  					tx =3D async_copy_data(1, wbi, &dev->page,
> -						dev->sector, tx, sh);
> -					if (dev->page !=3D dev->orig_page) {
> +							     dev->sector, tx, sh,
> +							     test_bit(R5_Wantcache, &dev->flags));
> +					if (dev->page !=3D dev->orig_page &&
> +					    !test_bit(R5_Wantcache, &dev->flags)) {
>  						set_bit(R5_SkipCopy, &dev->flags);
>  						clear_bit(R5_UPTODATE, &dev->flags);
>  						clear_bit(R5_OVERWRITE, &dev->flags);
> @@ -1675,7 +1722,8 @@ again:
>  		xor_dest =3D xor_srcs[count++] =3D sh->dev[pd_idx].page;
>  		for (i =3D disks; i--; ) {
>  			struct r5dev *dev =3D &sh->dev[i];
> -			if (head_sh->dev[i].written)
> +			if (head_sh->dev[i].written ||
> +			    test_bit(R5_InCache, &head_sh->dev[i].flags))
>  				xor_srcs[count++] =3D dev->page;
>  		}
>  	} else {
> @@ -1930,6 +1978,7 @@ static struct stripe_head *alloc_stripe(struct kmem=
_cache *sc, gfp_t gfp,
>  		INIT_LIST_HEAD(&sh->batch_list);
>  		INIT_LIST_HEAD(&sh->lru);
>  		atomic_set(&sh->count, 1);
> +		atomic_set(&sh->dev_in_cache, 0);
>  		for (i =3D 0; i < disks; i++) {
>  			struct r5dev *dev =3D &sh->dev[i];
>=20=20
> @@ -2810,12 +2859,30 @@ schedule_reconstruction(struct stripe_head *sh, s=
truct stripe_head_state *s,
>  		for (i =3D disks; i--; ) {
>  			struct r5dev *dev =3D &sh->dev[i];
>=20=20
> +			/*
> +			 * Initially, handle_stripe_dirtying decided to run rmw
> +			 * and allocates extra page for prexor. However, rcw is
> +			 * cheaper later on. We need to free the extra page
> +			 * now, because we won't be able to do that in
> +			 * ops_complete_prexor().
> +			 */
> +			if (sh->dev[i].page !=3D sh->dev[i].orig_page) {
> +				struct page *p =3D sh->dev[i].page;
> +
> +				p =3D sh->dev[i].page;
> +				sh->dev[i].page =3D sh->dev[i].orig_page;
> +				put_page(p);
> +			}
> +
>  			if (dev->towrite) {
>  				set_bit(R5_LOCKED, &dev->flags);
>  				set_bit(R5_Wantdrain, &dev->flags);
>  				if (!expand)
>  					clear_bit(R5_UPTODATE, &dev->flags);
>  				s->locked++;
> +			} else if (test_bit(R5_InCache, &dev->flags)) {
> +				set_bit(R5_LOCKED, &dev->flags);
> +				s->locked++;
>  			}
>  		}
>  		/* if we are not expanding this is a proper write request, and
> @@ -2855,6 +2922,9 @@ schedule_reconstruction(struct stripe_head *sh, str=
uct stripe_head_state *s,
>  				set_bit(R5_LOCKED, &dev->flags);
>  				clear_bit(R5_UPTODATE, &dev->flags);
>  				s->locked++;
> +			} else if (test_bit(R5_InCache, &dev->flags)) {
> +				set_bit(R5_LOCKED, &dev->flags);
> +				s->locked++;
>  			}
>  		}
>  		if (!s->locked)
> @@ -3529,9 +3599,12 @@ static void handle_stripe_dirtying(struct r5conf *=
conf,
>  	} else for (i =3D disks; i--; ) {
>  		/* would I have to read this buffer for read_modify_write */
>  		struct r5dev *dev =3D &sh->dev[i];
> -		if ((dev->towrite || i =3D=3D sh->pd_idx || i =3D=3D sh->qd_idx) &&
> +		if ((dev->towrite || i =3D=3D sh->pd_idx || i =3D=3D sh->qd_idx ||
> +		     test_bit(R5_InCache, &dev->flags)) &&
>  		    !test_bit(R5_LOCKED, &dev->flags) &&
> -		    !(test_bit(R5_UPTODATE, &dev->flags) ||
> +		    !((test_bit(R5_UPTODATE, &dev->flags) &&
> +		       (!test_bit(R5_InCache, &dev->flags) ||
> +			dev->page !=3D dev->orig_page)) ||
>  		      test_bit(R5_Wantcompute, &dev->flags))) {
>  			if (test_bit(R5_Insync, &dev->flags))
>  				rmw++;
> @@ -3543,13 +3616,15 @@ static void handle_stripe_dirtying(struct r5conf =
*conf,
>  		    i !=3D sh->pd_idx && i !=3D sh->qd_idx &&
>  		    !test_bit(R5_LOCKED, &dev->flags) &&
>  		    !(test_bit(R5_UPTODATE, &dev->flags) ||
> -		    test_bit(R5_Wantcompute, &dev->flags))) {
> +		      test_bit(R5_InCache, &dev->flags) ||
> +		      test_bit(R5_Wantcompute, &dev->flags))) {
>  			if (test_bit(R5_Insync, &dev->flags))
>  				rcw++;
>  			else
>  				rcw +=3D 2*disks;
>  		}
>  	}
> +
>  	pr_debug("for sector %llu, rmw=3D%d rcw=3D%d\n",
>  		(unsigned long long)sh->sector, rmw, rcw);
>  	set_bit(STRIPE_HANDLE, &sh->state);
> @@ -3561,10 +3636,18 @@ static void handle_stripe_dirtying(struct r5conf =
*conf,
>  					  (unsigned long long)sh->sector, rmw);
>  		for (i =3D disks; i--; ) {
>  			struct r5dev *dev =3D &sh->dev[i];
> -			if ((dev->towrite || i =3D=3D sh->pd_idx || i =3D=3D sh->qd_idx) &&
> +			if (test_bit(R5_InCache, &dev->flags) &&
> +			    dev->page =3D=3D dev->orig_page)
> +				dev->page =3D alloc_page(GFP_NOIO);  /* prexor */
> +
> +			if ((dev->towrite ||
> +			     i =3D=3D sh->pd_idx || i =3D=3D sh->qd_idx ||
> +			     test_bit(R5_InCache, &dev->flags)) &&
>  			    !test_bit(R5_LOCKED, &dev->flags) &&
> -			    !(test_bit(R5_UPTODATE, &dev->flags) ||
> -			    test_bit(R5_Wantcompute, &dev->flags)) &&
> +			    !((test_bit(R5_UPTODATE, &dev->flags) &&
> +			       (!test_bit(R5_InCache, &dev->flags) ||
> +				dev->page !=3D dev->orig_page)) ||
> +			      test_bit(R5_Wantcompute, &dev->flags)) &&
>  			    test_bit(R5_Insync, &dev->flags)) {
>  				if (test_bit(STRIPE_PREREAD_ACTIVE,
>  					     &sh->state)) {
> @@ -3590,6 +3673,7 @@ static void handle_stripe_dirtying(struct r5conf *c=
onf,
>  			    i !=3D sh->pd_idx && i !=3D sh->qd_idx &&
>  			    !test_bit(R5_LOCKED, &dev->flags) &&
>  			    !(test_bit(R5_UPTODATE, &dev->flags) ||
> +			      test_bit(R5_InCache, &dev->flags) ||
>  			      test_bit(R5_Wantcompute, &dev->flags))) {
>  				rcw++;
>  				if (test_bit(R5_Insync, &dev->flags) &&
> @@ -3629,7 +3713,7 @@ static void handle_stripe_dirtying(struct r5conf *c=
onf,
>  	 */
>  	if ((s->req_compute || !test_bit(STRIPE_COMPUTE_RUN, &sh->state)) &&
>  	    (s->locked =3D=3D 0 && (rcw =3D=3D 0 || rmw =3D=3D 0) &&
> -	    !test_bit(STRIPE_BIT_DELAY, &sh->state)))
> +	     !test_bit(STRIPE_BIT_DELAY, &sh->state)))
>  		schedule_reconstruction(sh, s, rcw =3D=3D 0, 0);
>  }
>=20=20
> @@ -4120,6 +4204,10 @@ static void analyse_stripe(struct stripe_head *sh,=
 struct stripe_head_state *s)
>  			if (rdev && !test_bit(Faulty, &rdev->flags))
>  				do_recovery =3D 1;
>  		}
> +		if (test_bit(R5_InCache, &dev->flags) && dev->written)
> +			s->just_cached++;
> +		if (test_bit(R5_Wantcache, &dev->flags) && dev->written)
> +			s->want_cache++;
>  	}
>  	if (test_bit(STRIPE_SYNCING, &sh->state)) {
>  		/* If there is a failed device being replaced,
> @@ -4285,6 +4373,17 @@ static void handle_stripe(struct stripe_head *sh)
>=20=20
>  	analyse_stripe(sh, &s);
>=20=20
> +	if (s.want_cache) {
> +		/* In last run of handle_stripe, we have finished
> +		 * r5c_handle_stripe_dirtying and ops_run_biodrain, but
> +		 * r5c_cache_data didn't finish because the journal device
> +		 * didn't have enough space. This time we should continue
> +		 * r5c_cache_data
> +		 */
> +		s.to_cache =3D s.want_cache;
> +		goto finish;
> +	}
> +
>  	if (test_bit(STRIPE_LOG_TRAPPED, &sh->state))
>  		goto finish;
>=20=20
> @@ -4348,7 +4447,7 @@ static void handle_stripe(struct stripe_head *sh)
>  			struct r5dev *dev =3D &sh->dev[i];
>  			if (test_bit(R5_LOCKED, &dev->flags) &&
>  				(i =3D=3D sh->pd_idx || i =3D=3D sh->qd_idx ||
> -				 dev->written)) {
> +				 dev->written || test_bit(R5_InCache, &dev->flags))) {
>  				pr_debug("Writing block %d\n", i);
>  				set_bit(R5_Wantwrite, &dev->flags);
>  				if (prexor)
> @@ -4388,6 +4487,10 @@ static void handle_stripe(struct stripe_head *sh)
>  				 test_bit(R5_Discard, &qdev->flags))))))
>  		handle_stripe_clean_event(conf, sh, disks, &s.return_bi);
>=20=20
> +	if (s.just_cached)
> +		r5c_handle_cached_data_endio(conf, sh, disks, &s.return_bi);
> +	r5l_stripe_write_finished(sh);
> +
>  	/* Now we might consider reading some blocks, either to check/generate
>  	 * parity, or to satisfy requests
>  	 * or to load a block that is being partially written.
> @@ -6526,6 +6629,11 @@ static struct r5conf *setup_conf(struct mddev *mdd=
ev)
>  	for (i =3D 0; i < NR_STRIPE_HASH_LOCKS; i++)
>  		INIT_LIST_HEAD(conf->temp_inactive_list + i);
>=20=20
> +	atomic_set(&conf->r5c_cached_full_stripes, 0);
> +	INIT_LIST_HEAD(&conf->r5c_full_stripe_list);
> +	atomic_set(&conf->r5c_cached_partial_stripes, 0);
> +	INIT_LIST_HEAD(&conf->r5c_partial_stripe_list);
> +
>  	conf->level =3D mddev->new_level;
>  	conf->chunk_sectors =3D mddev->new_chunk_sectors;
>  	if (raid5_alloc_percpu(conf) !=3D 0)
> diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
> index 8bae64b..ac6d7c7 100644
> --- a/drivers/md/raid5.h
> +++ b/drivers/md/raid5.h
> @@ -226,6 +226,7 @@ struct stripe_head {
>=20=20
>  	struct r5l_io_unit	*log_io;
>  	struct list_head	log_list;
> +	atomic_t		dev_in_cache;
>  	/**
>  	 * struct stripe_operations
>  	 * @target - STRIPE_OP_COMPUTE_BLK target
> @@ -263,6 +264,7 @@ struct stripe_head_state {
>  	 */
>  	int syncing, expanding, expanded, replacing;
>  	int locked, uptodate, to_read, to_write, failed, written;
> +	int to_cache, want_cache, just_cached;
>  	int to_fill, compute, req_compute, non_overwrite;
>  	int failed_num[2];
>  	int p_failed, q_failed;
> @@ -313,6 +315,8 @@ enum r5dev_flags {
>  			 */
>  	R5_Discard,	/* Discard the stripe */
>  	R5_SkipCopy,	/* Don't copy data from bio to stripe cache */
> +	R5_Wantcache,	/* Want write data to write cache */
> +	R5_InCache,	/* Data in cache */
>  };
>=20=20
>  /*
> @@ -348,6 +352,12 @@ enum {
>  	STRIPE_LOG_TRAPPED,	/* trapped into log */
>  	STRIPE_R5C_FROZEN,	/* r5c_cache frozen and being written out */
>  	STRIPE_R5C_WRITTEN,	/* ready for r5c_handle_stripe_written() */
> +	STRIPE_R5C_PARTIAL_STRIPE,	/* in r5c cache (to-be/being handled or
> +					 * in conf->r5c_partial_stripe_list)
> +					 */
> +	STRIPE_R5C_FULL_STRIPE,	/* in r5c cache (to-be/being handled or
> +				 * in conf->r5c_full_stripe_list)
> +				 */
>  };
>=20=20
>  #define STRIPE_EXPAND_SYNC_FLAGS \
> @@ -600,6 +610,12 @@ struct r5conf {
>  	 */
>  	atomic_t		active_stripes;
>  	struct list_head	inactive_list[NR_STRIPE_HASH_LOCKS];
> +
> +	atomic_t		r5c_cached_full_stripes;
> +	struct list_head	r5c_full_stripe_list;
> +	atomic_t		r5c_cached_partial_stripes;
> +	struct list_head	r5c_partial_stripe_list;
> +
>  	atomic_t		empty_inactive_list_nr;
>  	struct llist_head	released_stripes;
>  	wait_queue_head_t	wait_for_quiescent;
> @@ -720,4 +736,10 @@ r5c_handle_stripe_dirtying(struct r5conf *conf, stru=
ct stripe_head *sh,
>  			   struct stripe_head_state *s, int disks);
>  extern void
>  r5c_handle_stripe_written(struct r5conf *conf, struct stripe_head *sh);
> +extern void r5l_wake_reclaim(struct r5l_log *log, sector_t space);
> +extern void r5c_handle_cached_data_endio(struct r5conf *conf,
> +	struct stripe_head *sh, int disks, struct bio_list *return_bi);
> +extern int r5c_cache_data(struct r5l_log *log, struct stripe_head *sh,
> +			  struct stripe_head_state *s);
> +extern void r5c_freeze_stripe_for_reclaim(struct stripe_head *sh);
>  #endif
> --=20
> 2.9.3

This mostly seems go, though obviously I found a few little issues.
My eyes started to glaze over towards the end though ... maybe next time
I should read the patch from the bottom upwards :-)

Thanks,
NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBCAAGBQJYAIDpAAoJEDnsnt1WYoG570oP/ipsfAvD1jamJynxVqcsZ+2X
tx3zasbGnMylRMearb9ndXwjY34/5Ym6ofafrsSsJplxPCapbIeHPiRrWc8xoKpR
iiXO+w2UhvGJKn5eiBMSouzFG16FGMaWDb0O+7X8FdM9PIsxs9EmD+KVE7n25l3N
osIXwPAOeQi/DTDuS1MzGJfpWhO22Dbfy8zUX5SdeD9C55r5s183VqHuikOKA64j
StCJwFjer26kt2k6OyhE+HFgJgkqi53AjrYhiGcPrzZ+nSJ8rO7uW/wJQzfjF84m
JK7RMD6Q/z/iJhOB+nWDaRCSuOa2pA/mE6q+YONSGgQd48oagutrr7O1ZDEQw6Qp
TfxrV7oPIH7quWUETe41wHCSIXA4wGef+xSSMxHUcJWxUI8C3SIATE58uex8XlO1
K1U0bfQYrKggVaM2huQDtG+r20Ep2NpTc6i3Hnwh5398X04ERmw7wLDp+7VIi3ov
L+x6GOY51FKLM1gf6rYlIjHRAgn7/cQOi4/FS/74tZflEfP2Z4x0pd+VPbPM9ip6
KlL2n8B2nyyE/6lp+Ypfdfg8mS8UF+1v0cC7yLEHISeWlKPOQW2U3wlbyHYGV4OE
oxilCRYEE0WSPvGk7CZRwtglNrMGc8TiT9mEYqRgcGiikdZi3WPovOXnuwOPC3uZ
t0AS26PgdY4E3xCwzEXl
=LTuO
-----END PGP SIGNATURE-----
--=-=-=--
