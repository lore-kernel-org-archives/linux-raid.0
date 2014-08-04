From: NeilBrown <neilb@suse.de>
Subject: Re: [patch 1/2 v2]RAID5: make stripe size configurable
Date: Mon, 4 Aug 2014 10:57:07 +1000
Message-ID: <20140804105707.5cd783a6@notabene.brown>
References: <20140723074723.GB3517@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/=ykqH/iAjcuhsnhl_eCFw1D"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140723074723.GB3517@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/=ykqH/iAjcuhsnhl_eCFw1D
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 23 Jul 2014 15:47:23 +0800 Shaohua Li <shli@kernel.org> wrote:

>=20
> stripe size is 4k default. Bigger stripe size is considered harmful, beca=
use if
> IO size is small, big stripe size can cause a lot of unnecessary IO/parity
> calculation. But if upper layer always sends full stripe write to RAID5 a=
rray,
> this drawback goes away. And bigger stripe size can improve performance
> actually in this case because of bigger size IO and less stripes to handl=
e. In
> my full stripe write test case, 16k stripe size can improve throughput 40=
% -
> 120% depending on RAID5 configuration.
>=20
> V2: use order-0 page allocation

Hi,
 using order-0 page allocations is a definite improvement, and the throughp=
ut
 improvements sound impressive.
 But I really don't like the idea of adding a configuration option.  I'd mu=
ch
 rather get rid of those than add new ones.

 I see your work as making it very clear that the current stripe cache is
 quite inefficient for some cases, and it is good to have that demonstrated.
 I don't think it is a useful fix though.  We need to find a way to remove
 the overheads without using a "sledge hammer".  Maybe adjacent stripe_heads
 can be linked together and processed as a unit?

Thanks,
NeilBrown


>=20
> Signed-off-by: Shaohua Li<shli@fusionio.com>
> ---
>  drivers/md/raid5.c |  738 +++++++++++++++++++++++++++++++++++-----------=
-------
>  drivers/md/raid5.h |    8=20
>  2 files changed, 502 insertions(+), 244 deletions(-)
>=20
> Index: linux/drivers/md/raid5.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux.orig/drivers/md/raid5.c	2014-07-23 14:09:45.844570945 +0800
> +++ linux/drivers/md/raid5.c	2014-07-23 14:09:45.836571048 +0800
> @@ -70,9 +70,10 @@ static struct workqueue_struct *raid5_wq
>   */
> =20
>  #define NR_STRIPES		256
> -#define STRIPE_SIZE		PAGE_SIZE
> -#define STRIPE_SHIFT		(PAGE_SHIFT - 9)
> -#define STRIPE_SECTORS		(STRIPE_SIZE>>9)
> +#define STRIPE_SIZE(conf)	(PAGE_SIZE << conf->stripe_size_order)
> +#define STRIPE_SHIFT(conf)	(PAGE_SHIFT - 9 + conf->stripe_size_order)
> +#define STRIPE_SECTORS(conf)	(STRIPE_SIZE(conf) >> 9)
> +#define STRIPE_PAGES(conf)	(1 << conf->stripe_size_order)
>  #define	IO_THRESHOLD		1
>  #define BYPASS_THRESHOLD	1
>  #define NR_HASH			(PAGE_SIZE / sizeof(struct hlist_head))
> @@ -81,13 +82,13 @@ static struct workqueue_struct *raid5_wq
> =20
>  static inline struct hlist_head *stripe_hash(struct r5conf *conf, sector=
_t sect)
>  {
> -	int hash =3D (sect >> STRIPE_SHIFT) & HASH_MASK;
> +	int hash =3D (sect >> STRIPE_SHIFT(conf)) & HASH_MASK;
>  	return &conf->stripe_hashtbl[hash];
>  }
> =20
> -static inline int stripe_hash_locks_hash(sector_t sect)
> +static inline int stripe_hash_locks_hash(struct r5conf *conf, sector_t s=
ect)
>  {
> -	return (sect >> STRIPE_SHIFT) & STRIPE_HASH_LOCKS_MASK;
> +	return (sect >> STRIPE_SHIFT(conf)) & STRIPE_HASH_LOCKS_MASK;
>  }
> =20
>  static inline void lock_device_hash_lock(struct r5conf *conf, int hash)
> @@ -130,10 +131,10 @@ static inline void unlock_all_device_has
>   * This function is used to determine the 'next' bio in the list, given =
the sector
>   * of the current stripe+device
>   */
> -static inline struct bio *r5_next_bio(struct bio *bio, sector_t sector)
> +static inline struct bio *r5_next_bio(struct r5conf *conf, struct bio *b=
io, sector_t sector)
>  {
>  	int sectors =3D bio_sectors(bio);
> -	if (bio->bi_iter.bi_sector + sectors < sector + STRIPE_SECTORS)
> +	if (bio->bi_iter.bi_sector + sectors < sector + STRIPE_SECTORS(conf))
>  		return bio->bi_next;
>  	else
>  		return NULL;
> @@ -483,36 +484,51 @@ out:
>  static void shrink_buffers(struct stripe_head *sh)
>  {
>  	struct page *p;
> -	int i;
> +	int i, j;
>  	int num =3D sh->raid_conf->pool_size;
> =20
>  	for (i =3D 0; i < num ; i++) {
> -		WARN_ON(sh->dev[i].page !=3D sh->dev[i].orig_page);
> -		p =3D sh->dev[i].page;
> -		if (!p)
> -			continue;
> -		sh->dev[i].page =3D NULL;
> -		put_page(p);
> +		for (j =3D 0; j < STRIPE_PAGES(sh->raid_conf); j++) {
> +			p =3D sh->dev[i].orig_pages[j];
> +			if (!p)
> +				continue;
> +			WARN_ON(sh->dev[i].pages[j] !=3D
> +					sh->dev[i].orig_pages[j]);
> +			put_page(p);
> +			sh->dev[i].pages[j] =3D NULL;
> +			sh->dev[i].orig_pages[j] =3D NULL;
> +		}
>  	}
>  }
> =20
>  static int grow_buffers(struct stripe_head *sh)
>  {
> -	int i;
> +	int i, j;
>  	int num =3D sh->raid_conf->pool_size;
> =20
>  	for (i =3D 0; i < num; i++) {
>  		struct page *page;
> =20
> -		if (!(page =3D alloc_page(GFP_KERNEL))) {
> -			return 1;
> +		for (j =3D 0; j < STRIPE_PAGES(sh->raid_conf); j++) {
> +			page =3D alloc_page(GFP_KERNEL);
> +			if (!page)
> +				return 1;
> +			sh->dev[i].pages[j] =3D page;
> +			sh->dev[i].orig_pages[j] =3D page;
>  		}
> -		sh->dev[i].page =3D page;
> -		sh->dev[i].orig_page =3D page;
>  	}
>  	return 0;
>  }
> =20
> +static void reset_stripe_devpage(struct stripe_head *sh, int i)
> +{
> +	struct r5conf *conf =3D sh->raid_conf;
> +	int j;
> +
> +	for (j =3D 0; j < STRIPE_PAGES(conf); j++)
> +		sh->dev[i].pages[j] =3D sh->dev[i].orig_pages[j];
> +}
> +
>  static void raid5_build_block(struct stripe_head *sh, int i, int previou=
s);
>  static void stripe_set_idx(sector_t stripe, struct r5conf *conf, int pre=
vious,
>  			    struct stripe_head *sh);
> @@ -659,7 +675,7 @@ get_active_stripe(struct r5conf *conf, s
>  		  int previous, int noblock, int noquiesce)
>  {
>  	struct stripe_head *sh;
> -	int hash =3D stripe_hash_locks_hash(sector);
> +	int hash =3D stripe_hash_locks_hash(conf, sector);
> =20
>  	pr_debug("get_stripe, sector %llu\n", (unsigned long long)sector);
> =20
> @@ -740,7 +756,7 @@ raid5_end_write_request(struct bio *bi,
>  static void ops_run_io(struct stripe_head *sh, struct stripe_head_state =
*s)
>  {
>  	struct r5conf *conf =3D sh->raid_conf;
> -	int i, disks =3D sh->disks;
> +	int i, disks =3D sh->disks, j;
> =20
>  	might_sleep();
> =20
> @@ -808,7 +824,7 @@ static void ops_run_io(struct stripe_hea
>  		       test_bit(WriteErrorSeen, &rdev->flags)) {
>  			sector_t first_bad;
>  			int bad_sectors;
> -			int bad =3D is_badblock(rdev, sh->sector, STRIPE_SECTORS,
> +			int bad =3D is_badblock(rdev, sh->sector, STRIPE_SECTORS(conf),
>  					      &first_bad, &bad_sectors);
>  			if (!bad)
>  				break;
> @@ -840,7 +856,7 @@ static void ops_run_io(struct stripe_hea
>  		if (rdev) {
>  			if (s->syncing || s->expanding || s->expanded
>  			    || s->replacing)
> -				md_sync_acct(rdev->bdev, STRIPE_SECTORS);
> +				md_sync_acct(rdev->bdev, STRIPE_SECTORS(conf));
> =20
>  			set_bit(STRIPE_IO_STARTED, &sh->state);
> =20
> @@ -867,11 +883,12 @@ static void ops_run_io(struct stripe_hea
> =20
>  			if (test_bit(R5_SkipCopy, &sh->dev[i].flags))
>  				WARN_ON(test_bit(R5_UPTODATE, &sh->dev[i].flags));
> -			sh->dev[i].vec.bv_page =3D sh->dev[i].page;
> -			bi->bi_vcnt =3D 1;
> -			bi->bi_io_vec[0].bv_len =3D STRIPE_SIZE;
> -			bi->bi_io_vec[0].bv_offset =3D 0;
> -			bi->bi_iter.bi_size =3D STRIPE_SIZE;
> +
> +			bi->bi_max_vecs =3D 1 << conf->stripe_size_order;
> +			bi->bi_io_vec =3D sh->dev[i].vecs;
> +
> +			for (j =3D 0; j < STRIPE_PAGES(conf); j++)
> +				bio_add_page(bi, sh->dev[i].pages[j], PAGE_SIZE, 0);
>  			/*
>  			 * If this is discard request, set bi_vcnt 0. We don't
>  			 * want to confuse SCSI because SCSI will replace payload
> @@ -890,7 +907,7 @@ static void ops_run_io(struct stripe_hea
>  		if (rrdev) {
>  			if (s->syncing || s->expanding || s->expanded
>  			    || s->replacing)
> -				md_sync_acct(rrdev->bdev, STRIPE_SECTORS);
> +				md_sync_acct(rrdev->bdev, STRIPE_SECTORS(conf));
> =20
>  			set_bit(STRIPE_IO_STARTED, &sh->state);
> =20
> @@ -914,11 +931,12 @@ static void ops_run_io(struct stripe_hea
>  						  + rrdev->data_offset);
>  			if (test_bit(R5_SkipCopy, &sh->dev[i].flags))
>  				WARN_ON(test_bit(R5_UPTODATE, &sh->dev[i].flags));
> -			sh->dev[i].rvec.bv_page =3D sh->dev[i].page;
> -			rbi->bi_vcnt =3D 1;
> -			rbi->bi_io_vec[0].bv_len =3D STRIPE_SIZE;
> -			rbi->bi_io_vec[0].bv_offset =3D 0;
> -			rbi->bi_iter.bi_size =3D STRIPE_SIZE;
> +
> +			rbi->bi_max_vecs =3D 1 << conf->stripe_size_order;
> +			rbi->bi_io_vec =3D sh->dev[i].rvecs;
> +
> +			for (j =3D 0; j < STRIPE_PAGES(conf); j++)
> +				bio_add_page(rbi, sh->dev[i].pages[j], PAGE_SIZE, 0);
>  			/*
>  			 * If this is discard request, set bi_vcnt 0. We don't
>  			 * want to confuse SCSI because SCSI will replace payload
> @@ -943,7 +961,7 @@ static void ops_run_io(struct stripe_hea
>  }
> =20
>  static struct dma_async_tx_descriptor *
> -async_copy_data(int frombio, struct bio *bio, struct page **page,
> +async_copy_one_page(int frombio, struct bio *bio, struct page **page,
>  	sector_t sector, struct dma_async_tx_descriptor *tx,
>  	struct stripe_head *sh)
>  {
> @@ -974,8 +992,8 @@ async_copy_data(int frombio, struct bio
>  			len -=3D b_offset;
>  		}
> =20
> -		if (len > 0 && page_offset + len > STRIPE_SIZE)
> -			clen =3D STRIPE_SIZE - page_offset;
> +		if (len > 0 && page_offset + len > PAGE_SIZE)
> +			clen =3D PAGE_SIZE - page_offset;
>  		else
>  			clen =3D len;
> =20
> @@ -985,7 +1003,7 @@ async_copy_data(int frombio, struct bio
>  			if (frombio) {
>  				if (sh->raid_conf->skip_copy &&
>  				    b_offset =3D=3D 0 && page_offset =3D=3D 0 &&
> -				    clen =3D=3D STRIPE_SIZE)
> +				    clen =3D=3D PAGE_SIZE)
>  					*page =3D bio_page;
>  				else
>  					tx =3D async_memcpy(*page, bio_page, page_offset,
> @@ -997,14 +1015,42 @@ async_copy_data(int frombio, struct bio
>  		/* chain the operations */
>  		submit.depend_tx =3D tx;
> =20
> -		if (clen < len) /* hit end of page */
> -			break;
>  		page_offset +=3D  len;
> +		/* hit end of page */
> +		if (page_offset > 0 && (page_offset % PAGE_SIZE) =3D=3D 0)
> +			break;
>  	}
> =20
>  	return tx;
>  }
> =20
> +static struct dma_async_tx_descriptor *
> +async_copy_data(int frombio, struct bio *bio, struct page **pages,
> +	sector_t sector, struct dma_async_tx_descriptor *tx,
> +	struct stripe_head *sh, int *skip_copy)
> +{
> +	sector_t offset;
> +	struct page **cur_page, *tmp;
> +
> +	*skip_copy =3D 0;
> +	if (sector > bio->bi_iter.bi_sector)
> +		offset =3D sector;
> +	else {
> +		offset =3D bio->bi_iter.bi_sector >> 3;
> +		offset <<=3D 3;
> +	}
> +	while (offset < bio_end_sector(bio) &&
> +	       offset < sector + STRIPE_SECTORS(sh->raid_conf)) {
> +		cur_page =3D &pages[(offset - sector) >> 3];
> +		tmp =3D *cur_page;
> +		tx =3D async_copy_one_page(frombio, bio, cur_page, offset, tx, sh);
> +		if (tmp !=3D *cur_page)
> +			*skip_copy =3D 1;
> +		offset +=3D PAGE_SIZE >> 9;
> +	}
> +	return tx;
> +}
> +
>  static void ops_complete_biofill(void *stripe_head_ref)
>  {
>  	struct stripe_head *sh =3D stripe_head_ref;
> @@ -1030,8 +1076,8 @@ static void ops_complete_biofill(void *s
>  			rbi =3D dev->read;
>  			dev->read =3D NULL;
>  			while (rbi && rbi->bi_iter.bi_sector <
> -				dev->sector + STRIPE_SECTORS) {
> -				rbi2 =3D r5_next_bio(rbi, dev->sector);
> +				dev->sector + STRIPE_SECTORS(sh->raid_conf)) {
> +				rbi2 =3D r5_next_bio(sh->raid_conf, rbi, dev->sector);
>  				if (!raid5_dec_bi_active_stripes(rbi)) {
>  					rbi->bi_next =3D return_bi;
>  					return_bi =3D rbi;
> @@ -1052,7 +1098,7 @@ static void ops_run_biofill(struct strip
>  {
>  	struct dma_async_tx_descriptor *tx =3D NULL;
>  	struct async_submit_ctl submit;
> -	int i;
> +	int i, dummy;
> =20
>  	pr_debug("%s: stripe %llu\n", __func__,
>  		(unsigned long long)sh->sector);
> @@ -1066,10 +1112,10 @@ static void ops_run_biofill(struct strip
>  			dev->toread =3D NULL;
>  			spin_unlock_irq(&sh->stripe_lock);
>  			while (rbi && rbi->bi_iter.bi_sector <
> -				dev->sector + STRIPE_SECTORS) {
> -				tx =3D async_copy_data(0, rbi, &dev->page,
> -					dev->sector, tx, sh);
> -				rbi =3D r5_next_bio(rbi, dev->sector);
> +				dev->sector + STRIPE_SECTORS(sh->raid_conf)) {
> +				tx =3D async_copy_data(0, rbi, dev->pages,
> +					dev->sector, tx, sh, &dummy);
> +				rbi =3D r5_next_bio(sh->raid_conf, rbi, dev->sector);
>  			}
>  		}
>  	}
> @@ -1112,40 +1158,64 @@ static void ops_complete_compute(void *s
> =20
>  /* return a pointer to the address conversion region of the scribble buf=
fer */
>  static addr_conv_t *to_addr_conv(struct stripe_head *sh,
> -				 struct raid5_percpu *percpu)
> +				 struct raid5_percpu *percpu, int page_index)
> +{
> +
> +	return percpu->scribble + sizeof(struct page *) * (sh->disks + 2) +
> +		page_index * (sh->raid_conf->scribble_len /
> +		STRIPE_PAGES(sh->raid_conf));
> +}
> +
> +static struct page **to_scribble_page(struct stripe_head *sh,
> +				struct raid5_percpu *percpu, int page_index)
>  {
> -	return percpu->scribble + sizeof(struct page *) * (sh->disks + 2);
> +	return percpu->scribble + page_index * (sh->raid_conf->scribble_len /
> +		STRIPE_PAGES(sh->raid_conf));
>  }
> =20
>  static struct dma_async_tx_descriptor *
>  ops_run_compute5(struct stripe_head *sh, struct raid5_percpu *percpu)
>  {
>  	int disks =3D sh->disks;
> -	struct page **xor_srcs =3D percpu->scribble;
> +	struct page **xor_srcs;
>  	int target =3D sh->ops.target;
>  	struct r5dev *tgt =3D &sh->dev[target];
> -	struct page *xor_dest =3D tgt->page;
> -	int count =3D 0;
> -	struct dma_async_tx_descriptor *tx;
> +	struct page *xor_dest;
> +	int count;
> +	struct dma_async_tx_descriptor *tx =3D NULL;
>  	struct async_submit_ctl submit;
> -	int i;
> +	int i, j =3D 0;
> =20
>  	pr_debug("%s: stripe %llu block: %d\n",
>  		__func__, (unsigned long long)sh->sector, target);
>  	BUG_ON(!test_bit(R5_Wantcompute, &tgt->flags));
> =20
> +again:
> +	count =3D 0;
> +	xor_srcs =3D to_scribble_page(sh, percpu, j);
> +	xor_dest =3D tgt->pages[j];
> +
>  	for (i =3D disks; i--; )
>  		if (i !=3D target)
> -			xor_srcs[count++] =3D sh->dev[i].page;
> +			xor_srcs[count++] =3D sh->dev[i].pages[j];
> =20
> -	atomic_inc(&sh->count);
> +	if (j =3D=3D STRIPE_PAGES(sh->raid_conf) - 1) {
> +		atomic_inc(&sh->count);
> +
> +		init_async_submit(&submit, ASYNC_TX_FENCE|ASYNC_TX_XOR_ZERO_DST, tx,
> +			ops_complete_compute, sh, to_addr_conv(sh, percpu, j));
> +	} else
> +		init_async_submit(&submit, ASYNC_TX_FENCE|ASYNC_TX_XOR_ZERO_DST, tx,
> +				  NULL, NULL, to_addr_conv(sh, percpu, j));
> =20
> -	init_async_submit(&submit, ASYNC_TX_FENCE|ASYNC_TX_XOR_ZERO_DST, NULL,
> -			  ops_complete_compute, sh, to_addr_conv(sh, percpu));
>  	if (unlikely(count =3D=3D 1))
> -		tx =3D async_memcpy(xor_dest, xor_srcs[0], 0, 0, STRIPE_SIZE, &submit);
> +		tx =3D async_memcpy(xor_dest, xor_srcs[0], 0, 0, PAGE_SIZE, &submit);
>  	else
> -		tx =3D async_xor(xor_dest, xor_srcs, 0, count, STRIPE_SIZE, &submit);
> +		tx =3D async_xor(xor_dest, xor_srcs, 0, count, PAGE_SIZE, &submit);
> +
> +	j++;
> +	if (j < STRIPE_PAGES(sh->raid_conf))
> +		goto again;
> =20
>  	return tx;
>  }
> @@ -1159,7 +1229,8 @@ ops_run_compute5(struct stripe_head *sh,
>   * destination buffer is recorded in srcs[count] and the Q destination
>   * is recorded in srcs[count+1]].
>   */
> -static int set_syndrome_sources(struct page **srcs, struct stripe_head *=
sh)
> +static int set_syndrome_sources(struct page **srcs, struct stripe_head *=
sh,
> +	int page_index)
>  {
>  	int disks =3D sh->disks;
>  	int syndrome_disks =3D sh->ddf_layout ? disks : (disks - 2);
> @@ -1175,7 +1246,7 @@ static int set_syndrome_sources(struct p
>  	do {
>  		int slot =3D raid6_idx_to_slot(i, sh, &count, syndrome_disks);
> =20
> -		srcs[slot] =3D sh->dev[i].page;
> +		srcs[slot] =3D sh->dev[i].pages[page_index];
>  		i =3D raid6_next_disk(i, disks);
>  	} while (i !=3D d0_idx);
> =20
> @@ -1186,14 +1257,14 @@ static struct dma_async_tx_descriptor *
>  ops_run_compute6_1(struct stripe_head *sh, struct raid5_percpu *percpu)
>  {
>  	int disks =3D sh->disks;
> -	struct page **blocks =3D percpu->scribble;
> +	struct page **blocks;
>  	int target;
>  	int qd_idx =3D sh->qd_idx;
> -	struct dma_async_tx_descriptor *tx;
> +	struct dma_async_tx_descriptor *tx =3D NULL;
>  	struct async_submit_ctl submit;
>  	struct r5dev *tgt;
>  	struct page *dest;
> -	int i;
> +	int i, j =3D 0;
>  	int count;
> =20
>  	if (sh->ops.target < 0)
> @@ -1209,40 +1280,57 @@ ops_run_compute6_1(struct stripe_head *s
> =20
>  	tgt =3D &sh->dev[target];
>  	BUG_ON(!test_bit(R5_Wantcompute, &tgt->flags));
> -	dest =3D tgt->page;
> =20
> -	atomic_inc(&sh->count);
> +again:
> +	dest =3D tgt->pages[j];
> +	blocks =3D to_scribble_page(sh, percpu, j);
> +
> +	if (j =3D=3D STRIPE_PAGES(sh->raid_conf) - 1)
> +		atomic_inc(&sh->count);
> =20
>  	if (target =3D=3D qd_idx) {
> -		count =3D set_syndrome_sources(blocks, sh);
> +		count =3D set_syndrome_sources(blocks, sh, j);
>  		blocks[count] =3D NULL; /* regenerating p is not necessary */
>  		BUG_ON(blocks[count+1] !=3D dest); /* q should already be set */
> -		init_async_submit(&submit, ASYNC_TX_FENCE, NULL,
> -				  ops_complete_compute, sh,
> -				  to_addr_conv(sh, percpu));
> -		tx =3D async_gen_syndrome(blocks, 0, count+2, STRIPE_SIZE, &submit);
> +
> +		if (j =3D=3D STRIPE_PAGES(sh->raid_conf) - 1)
> +			init_async_submit(&submit, ASYNC_TX_FENCE, tx,
> + 				  ops_complete_compute, sh,
> +				  to_addr_conv(sh, percpu, j));
> +		else
> +			init_async_submit(&submit, ASYNC_TX_FENCE, tx,
> +				  NULL, NULL, to_addr_conv(sh, percpu, j));
> +		tx =3D async_gen_syndrome(blocks, 0, count+2, PAGE_SIZE, &submit);
>  	} else {
>  		/* Compute any data- or p-drive using XOR */
>  		count =3D 0;
>  		for (i =3D disks; i-- ; ) {
>  			if (i =3D=3D target || i =3D=3D qd_idx)
>  				continue;
> -			blocks[count++] =3D sh->dev[i].page;
> +			blocks[count++] =3D sh->dev[i].pages[j];
>  		}
> =20
> -		init_async_submit(&submit, ASYNC_TX_FENCE|ASYNC_TX_XOR_ZERO_DST,
> -				  NULL, ops_complete_compute, sh,
> -				  to_addr_conv(sh, percpu));
> -		tx =3D async_xor(dest, blocks, 0, count, STRIPE_SIZE, &submit);
> +		if (j =3D=3D STRIPE_PAGES(sh->raid_conf) - 1)
> +			init_async_submit(&submit, ASYNC_TX_FENCE|ASYNC_TX_XOR_ZERO_DST,
> +				  tx, ops_complete_compute, sh,
> +				  to_addr_conv(sh, percpu, j));
> +		else
> +			init_async_submit(&submit, ASYNC_TX_FENCE|ASYNC_TX_XOR_ZERO_DST,
> +				  tx, NULL, NULL,
> +				  to_addr_conv(sh, percpu, j));
> +		tx =3D async_xor(dest, blocks, 0, count, PAGE_SIZE, &submit);
>  	}
> =20
> +	j++;
> +	if (j < STRIPE_PAGES(sh->raid_conf))
> +		goto again;
>  	return tx;
>  }
> =20
>  static struct dma_async_tx_descriptor *
>  ops_run_compute6_2(struct stripe_head *sh, struct raid5_percpu *percpu)
>  {
> -	int i, count, disks =3D sh->disks;
> +	int i, count, disks =3D sh->disks, j =3D 0;
>  	int syndrome_disks =3D sh->ddf_layout ? disks : disks-2;
>  	int d0_idx =3D raid6_d0(sh);
>  	int faila =3D -1, failb =3D -1;
> @@ -1250,8 +1338,8 @@ ops_run_compute6_2(struct stripe_head *s
>  	int target2 =3D sh->ops.target2;
>  	struct r5dev *tgt =3D &sh->dev[target];
>  	struct r5dev *tgt2 =3D &sh->dev[target2];
> -	struct dma_async_tx_descriptor *tx;
> -	struct page **blocks =3D percpu->scribble;
> +	struct dma_async_tx_descriptor *tx =3D NULL;
> +	struct page **blocks;
>  	struct async_submit_ctl submit;
> =20
>  	pr_debug("%s: stripe %llu block1: %d block2: %d\n",
> @@ -1260,6 +1348,8 @@ ops_run_compute6_2(struct stripe_head *s
>  	BUG_ON(!test_bit(R5_Wantcompute, &tgt->flags));
>  	BUG_ON(!test_bit(R5_Wantcompute, &tgt2->flags));
> =20
> +again:
> +	blocks =3D to_scribble_page(sh, percpu, j);
>  	/* we need to open-code set_syndrome_sources to handle the
>  	 * slot number conversion for 'faila' and 'failb'
>  	 */
> @@ -1270,7 +1360,7 @@ ops_run_compute6_2(struct stripe_head *s
>  	do {
>  		int slot =3D raid6_idx_to_slot(i, sh, &count, syndrome_disks);
> =20
> -		blocks[slot] =3D sh->dev[i].page;
> +		blocks[slot] =3D sh->dev[i].pages[j];
> =20
>  		if (i =3D=3D target)
>  			faila =3D slot;
> @@ -1285,17 +1375,23 @@ ops_run_compute6_2(struct stripe_head *s
>  	pr_debug("%s: stripe: %llu faila: %d failb: %d\n",
>  		 __func__, (unsigned long long)sh->sector, faila, failb);
> =20
> -	atomic_inc(&sh->count);
> +	if (j =3D=3D STRIPE_PAGES(sh->raid_conf) - 1)
> +		atomic_inc(&sh->count);
> =20
>  	if (failb =3D=3D syndrome_disks+1) {
>  		/* Q disk is one of the missing disks */
>  		if (faila =3D=3D syndrome_disks) {
>  			/* Missing P+Q, just recompute */
> -			init_async_submit(&submit, ASYNC_TX_FENCE, NULL,
> +			if (j =3D=3D STRIPE_PAGES(sh->raid_conf) - 1)
> +				init_async_submit(&submit, ASYNC_TX_FENCE, tx,
>  					  ops_complete_compute, sh,
> -					  to_addr_conv(sh, percpu));
> -			return async_gen_syndrome(blocks, 0, syndrome_disks+2,
> -						  STRIPE_SIZE, &submit);
> +					  to_addr_conv(sh, percpu, j));
> +			else
> +				init_async_submit(&submit, ASYNC_TX_FENCE, tx,
> +					  NULL, NULL,
> +					  to_addr_conv(sh, percpu, j));
> +			tx =3D async_gen_syndrome(blocks, 0, syndrome_disks+2,
> +						  PAGE_SIZE, &submit);
>  		} else {
>  			struct page *dest;
>  			int data_target;
> @@ -1311,39 +1407,55 @@ ops_run_compute6_2(struct stripe_head *s
>  			for (i =3D disks; i-- ; ) {
>  				if (i =3D=3D data_target || i =3D=3D qd_idx)
>  					continue;
> -				blocks[count++] =3D sh->dev[i].page;
> +				blocks[count++] =3D sh->dev[i].pages[j];
>  			}
> -			dest =3D sh->dev[data_target].page;
> +			dest =3D sh->dev[data_target].pages[j];
>  			init_async_submit(&submit,
>  					  ASYNC_TX_FENCE|ASYNC_TX_XOR_ZERO_DST,
> -					  NULL, NULL, NULL,
> -					  to_addr_conv(sh, percpu));
> -			tx =3D async_xor(dest, blocks, 0, count, STRIPE_SIZE,
> +					  tx, NULL, NULL,
> +					  to_addr_conv(sh, percpu, j));
> +			tx =3D async_xor(dest, blocks, 0, count, PAGE_SIZE,
>  				       &submit);
> =20
> -			count =3D set_syndrome_sources(blocks, sh);
> -			init_async_submit(&submit, ASYNC_TX_FENCE, tx,
> +			count =3D set_syndrome_sources(blocks, sh, j);
> +			if (j =3D=3D STRIPE_PAGES(sh->raid_conf) - 1)
> +				init_async_submit(&submit, ASYNC_TX_FENCE, tx,
>  					  ops_complete_compute, sh,
> -					  to_addr_conv(sh, percpu));
> -			return async_gen_syndrome(blocks, 0, count+2,
> -						  STRIPE_SIZE, &submit);
> +					  to_addr_conv(sh, percpu, j));
> +			else
> +				init_async_submit(&submit, ASYNC_TX_FENCE, tx,
> +					  NULL, NULL,
> +					  to_addr_conv(sh, percpu, j));
> +			tx =3D async_gen_syndrome(blocks, 0, count+2,
> +						  PAGE_SIZE, &submit);
>  		}
>  	} else {
> -		init_async_submit(&submit, ASYNC_TX_FENCE, NULL,
> +		if (j =3D=3D STRIPE_PAGES(sh->raid_conf) - 1)
> +			init_async_submit(&submit, ASYNC_TX_FENCE, tx,
>  				  ops_complete_compute, sh,
> -				  to_addr_conv(sh, percpu));
> +				  to_addr_conv(sh, percpu, j));
> +		else
> +			init_async_submit(&submit, ASYNC_TX_FENCE, tx,
> +				  NULL, NULL, to_addr_conv(sh, percpu, j));
> +
>  		if (failb =3D=3D syndrome_disks) {
>  			/* We're missing D+P. */
> -			return async_raid6_datap_recov(syndrome_disks+2,
> -						       STRIPE_SIZE, faila,
> +			tx =3D async_raid6_datap_recov(syndrome_disks+2,
> +						       PAGE_SIZE, faila,
>  						       blocks, &submit);
>  		} else {
>  			/* We're missing D+D. */
> -			return async_raid6_2data_recov(syndrome_disks+2,
> -						       STRIPE_SIZE, faila, failb,
> +			tx =3D async_raid6_2data_recov(syndrome_disks+2,
> +						       PAGE_SIZE, faila, failb,
>  						       blocks, &submit);
>  		}
>  	}
> +
> +	j++;
> +	if (j < STRIPE_PAGES(sh->raid_conf))
> +		goto again;
> +
> +	return tx;
>  }
> =20
> =20
> @@ -1360,26 +1472,40 @@ ops_run_prexor(struct stripe_head *sh, s
>  	       struct dma_async_tx_descriptor *tx)
>  {
>  	int disks =3D sh->disks;
> -	struct page **xor_srcs =3D percpu->scribble;
> -	int count =3D 0, pd_idx =3D sh->pd_idx, i;
> +	struct page **xor_srcs;
> +	int count, pd_idx =3D sh->pd_idx, i, j =3D 0;
>  	struct async_submit_ctl submit;
> =20
>  	/* existing parity data subtracted */
> -	struct page *xor_dest =3D xor_srcs[count++] =3D sh->dev[pd_idx].page;
> +	struct page *xor_dest;
> =20
>  	pr_debug("%s: stripe %llu\n", __func__,
>  		(unsigned long long)sh->sector);
> =20
> +again:
> +	count =3D 0;
> +	xor_srcs =3D to_scribble_page(sh, percpu, j);
> +	/* existing parity data subtracted */
> +	xor_dest =3D xor_srcs[count++] =3D sh->dev[pd_idx].pages[j];
> +
>  	for (i =3D disks; i--; ) {
>  		struct r5dev *dev =3D &sh->dev[i];
>  		/* Only process blocks that are known to be uptodate */
>  		if (test_bit(R5_Wantdrain, &dev->flags))
> -			xor_srcs[count++] =3D dev->page;
> +			xor_srcs[count++] =3D dev->pages[j];
>  	}
> =20
> -	init_async_submit(&submit, ASYNC_TX_FENCE|ASYNC_TX_XOR_DROP_DST, tx,
> -			  ops_complete_prexor, sh, to_addr_conv(sh, percpu));
> -	tx =3D async_xor(xor_dest, xor_srcs, 0, count, STRIPE_SIZE, &submit);
> +	if (j =3D=3D STRIPE_PAGES(sh->raid_conf) - 1)
> +		init_async_submit(&submit, ASYNC_TX_FENCE|ASYNC_TX_XOR_DROP_DST, tx,
> +			  ops_complete_prexor, sh, to_addr_conv(sh, percpu, j));
> +	else
> +		init_async_submit(&submit, ASYNC_TX_FENCE|ASYNC_TX_XOR_DROP_DST, tx,
> +			  NULL, NULL, to_addr_conv(sh, percpu, j));
> +	tx =3D async_xor(xor_dest, xor_srcs, 0, count, PAGE_SIZE, &submit);
> +
> +	j++;
> +	if (j < STRIPE_PAGES(sh->raid_conf))
> +		goto again;
> =20
>  	return tx;
>  }
> @@ -1406,10 +1532,10 @@ ops_run_biodrain(struct stripe_head *sh,
>  			BUG_ON(dev->written);
>  			wbi =3D dev->written =3D chosen;
>  			spin_unlock_irq(&sh->stripe_lock);
> -			WARN_ON(dev->page !=3D dev->orig_page);
> +			WARN_ON(dev->pages[0] !=3D dev->orig_pages[0]);
> =20
>  			while (wbi && wbi->bi_iter.bi_sector <
> -				dev->sector + STRIPE_SECTORS) {
> +				dev->sector + STRIPE_SECTORS(sh->raid_conf)) {
>  				if (wbi->bi_rw & REQ_FUA)
>  					set_bit(R5_WantFUA, &dev->flags);
>  				if (wbi->bi_rw & REQ_SYNC)
> @@ -1417,15 +1543,16 @@ ops_run_biodrain(struct stripe_head *sh,
>  				if (wbi->bi_rw & REQ_DISCARD)
>  					set_bit(R5_Discard, &dev->flags);
>  				else {
> -					tx =3D async_copy_data(1, wbi, &dev->page,
> -						dev->sector, tx, sh);
> -					if (dev->page !=3D dev->orig_page) {
> +					int skip_copy;
> +					tx =3D async_copy_data(1, wbi, dev->pages,
> +						dev->sector, tx, sh, &skip_copy);
> +					if (skip_copy) {
>  						set_bit(R5_SkipCopy, &dev->flags);
>  						clear_bit(R5_UPTODATE, &dev->flags);
>  						clear_bit(R5_OVERWRITE, &dev->flags);
>  					}
>  				}
> -				wbi =3D r5_next_bio(wbi, dev->sector);
> +				wbi =3D r5_next_bio(sh->raid_conf, wbi, dev->sector);
>  			}
>  		}
>  	}
> @@ -1482,9 +1609,9 @@ ops_run_reconstruct5(struct stripe_head
>  		     struct dma_async_tx_descriptor *tx)
>  {
>  	int disks =3D sh->disks;
> -	struct page **xor_srcs =3D percpu->scribble;
> +	struct page **xor_srcs;
>  	struct async_submit_ctl submit;
> -	int count =3D 0, pd_idx =3D sh->pd_idx, i;
> +	int count, pd_idx =3D sh->pd_idx, i, j =3D 0;
>  	struct page *xor_dest;
>  	int prexor =3D 0;
>  	unsigned long flags;
> @@ -1504,23 +1631,27 @@ ops_run_reconstruct5(struct stripe_head
>  		ops_complete_reconstruct(sh);
>  		return;
>  	}
> +
> +again:
> +	count =3D 0;
> +	xor_srcs =3D to_scribble_page(sh, percpu, j);
>  	/* check if prexor is active which means only process blocks
>  	 * that are part of a read-modify-write (written)
>  	 */
>  	if (sh->reconstruct_state =3D=3D reconstruct_state_prexor_drain_run) {
>  		prexor =3D 1;
> -		xor_dest =3D xor_srcs[count++] =3D sh->dev[pd_idx].page;
> +		xor_dest =3D xor_srcs[count++] =3D sh->dev[pd_idx].pages[j];
>  		for (i =3D disks; i--; ) {
>  			struct r5dev *dev =3D &sh->dev[i];
>  			if (dev->written)
> -				xor_srcs[count++] =3D dev->page;
> +				xor_srcs[count++] =3D dev->pages[j];
>  		}
>  	} else {
> -		xor_dest =3D sh->dev[pd_idx].page;
> +		xor_dest =3D sh->dev[pd_idx].pages[j];
>  		for (i =3D disks; i--; ) {
>  			struct r5dev *dev =3D &sh->dev[i];
>  			if (i !=3D pd_idx)
> -				xor_srcs[count++] =3D dev->page;
> +				xor_srcs[count++] =3D dev->pages[j];
>  		}
>  	}
> =20
> @@ -1529,17 +1660,28 @@ ops_run_reconstruct5(struct stripe_head
>  	 * set ASYNC_TX_XOR_DROP_DST and ASYNC_TX_XOR_ZERO_DST
>  	 * for the synchronous xor case
>  	 */
> -	flags =3D ASYNC_TX_ACK |
> -		(prexor ? ASYNC_TX_XOR_DROP_DST : ASYNC_TX_XOR_ZERO_DST);
> +	if (j =3D=3D STRIPE_PAGES(sh->raid_conf) - 1) {
> +		flags =3D ASYNC_TX_ACK |
> +			(prexor ? ASYNC_TX_XOR_DROP_DST : ASYNC_TX_XOR_ZERO_DST);
> =20
> -	atomic_inc(&sh->count);
> +		atomic_inc(&sh->count);
> +
> +		init_async_submit(&submit, flags, tx, ops_complete_reconstruct, sh,
> +			  to_addr_conv(sh, percpu, j));
> +	} else {
> +		flags =3D prexor ? ASYNC_TX_XOR_DROP_DST : ASYNC_TX_XOR_ZERO_DST;
> +		init_async_submit(&submit, flags, tx, NULL, NULL,
> +			  to_addr_conv(sh, percpu, j));
> +	}
> =20
> -	init_async_submit(&submit, flags, tx, ops_complete_reconstruct, sh,
> -			  to_addr_conv(sh, percpu));
>  	if (unlikely(count =3D=3D 1))
> -		tx =3D async_memcpy(xor_dest, xor_srcs[0], 0, 0, STRIPE_SIZE, &submit);
> +		tx =3D async_memcpy(xor_dest, xor_srcs[0], 0, 0, PAGE_SIZE, &submit);
>  	else
> -		tx =3D async_xor(xor_dest, xor_srcs, 0, count, STRIPE_SIZE, &submit);
> +		tx =3D async_xor(xor_dest, xor_srcs, 0, count, PAGE_SIZE, &submit);
> +
> +	j++;
> +	if (j < STRIPE_PAGES(sh->raid_conf))
> +		goto again;
>  }
> =20
>  static void
> @@ -1547,8 +1689,8 @@ ops_run_reconstruct6(struct stripe_head
>  		     struct dma_async_tx_descriptor *tx)
>  {
>  	struct async_submit_ctl submit;
> -	struct page **blocks =3D percpu->scribble;
> -	int count, i;
> +	struct page **blocks;
> +	int count, i, j =3D 0;
> =20
>  	pr_debug("%s: stripe %llu\n", __func__, (unsigned long long)sh->sector);
> =20
> @@ -1566,22 +1708,38 @@ ops_run_reconstruct6(struct stripe_head
>  		return;
>  	}
> =20
> -	count =3D set_syndrome_sources(blocks, sh);
> +again:
> +	blocks =3D to_scribble_page(sh, percpu, j);
> =20
> -	atomic_inc(&sh->count);
> +	count =3D set_syndrome_sources(blocks, sh, j);
> +
> +	if (j =3D=3D STRIPE_PAGES(sh->raid_conf) - 1) {
> +		atomic_inc(&sh->count);
> =20
> -	init_async_submit(&submit, ASYNC_TX_ACK, tx, ops_complete_reconstruct,
> -			  sh, to_addr_conv(sh, percpu));
> -	async_gen_syndrome(blocks, 0, count+2, STRIPE_SIZE,  &submit);
> +		init_async_submit(&submit, ASYNC_TX_ACK, tx, ops_complete_reconstruct,
> +			  sh, to_addr_conv(sh, percpu, j));
> +	} else
> +		init_async_submit(&submit, 0, tx, NULL,
> +			  NULL, to_addr_conv(sh, percpu, j));
> +	tx =3D async_gen_syndrome(blocks, 0, count+2, PAGE_SIZE,  &submit);
> +
> +	j++;
> +	if (j < STRIPE_PAGES(sh->raid_conf))
> +		goto again;
>  }
> =20
>  static void ops_complete_check(void *stripe_head_ref)
>  {
>  	struct stripe_head *sh =3D stripe_head_ref;
> +	int i;
> =20
>  	pr_debug("%s: stripe %llu\n", __func__,
>  		(unsigned long long)sh->sector);
> =20
> +	sh->ops.zero_sum_result =3D 0;
> +	for (i =3D 0; i < STRIPE_PAGES(sh->raid_conf); i++)
> +		sh->ops.zero_sum_result |=3D sh->ops.sum_results[i];
> +
>  	sh->check_state =3D check_state_check_result;
>  	set_bit(STRIPE_HANDLE, &sh->state);
>  	release_stripe(sh);
> @@ -1593,28 +1751,34 @@ static void ops_run_check_p(struct strip
>  	int pd_idx =3D sh->pd_idx;
>  	int qd_idx =3D sh->qd_idx;
>  	struct page *xor_dest;
> -	struct page **xor_srcs =3D percpu->scribble;
> -	struct dma_async_tx_descriptor *tx;
> +	struct page **xor_srcs;
> +	struct dma_async_tx_descriptor *tx =3D NULL;
>  	struct async_submit_ctl submit;
>  	int count;
> -	int i;
> +	int i, j =3D 0;
> =20
>  	pr_debug("%s: stripe %llu\n", __func__,
>  		(unsigned long long)sh->sector);
> =20
> +again:
> +	xor_srcs =3D to_scribble_page(sh, percpu, j);
>  	count =3D 0;
> -	xor_dest =3D sh->dev[pd_idx].page;
> +	xor_dest =3D sh->dev[pd_idx].pages[j];
>  	xor_srcs[count++] =3D xor_dest;
>  	for (i =3D disks; i--; ) {
>  		if (i =3D=3D pd_idx || i =3D=3D qd_idx)
>  			continue;
> -		xor_srcs[count++] =3D sh->dev[i].page;
> +		xor_srcs[count++] =3D sh->dev[i].pages[j];
>  	}
> =20
> -	init_async_submit(&submit, 0, NULL, NULL, NULL,
> -			  to_addr_conv(sh, percpu));
> -	tx =3D async_xor_val(xor_dest, xor_srcs, 0, count, STRIPE_SIZE,
> -			   &sh->ops.zero_sum_result, &submit);
> +	init_async_submit(&submit, 0, tx, NULL, NULL,
> +			  to_addr_conv(sh, percpu, j));
> +	tx =3D async_xor_val(xor_dest, xor_srcs, 0, count, PAGE_SIZE,
> +			   &sh->ops.sum_results[j], &submit);
> +
> +	j++;
> +	if (j < STRIPE_PAGES(sh->raid_conf))
> +		goto again;
> =20
>  	atomic_inc(&sh->count);
>  	init_async_submit(&submit, ASYNC_TX_ACK, tx, ops_complete_check, sh, NU=
LL);
> @@ -1623,22 +1787,32 @@ static void ops_run_check_p(struct strip
> =20
>  static void ops_run_check_pq(struct stripe_head *sh, struct raid5_percpu=
 *percpu, int checkp)
>  {
> -	struct page **srcs =3D percpu->scribble;
> +	struct page **srcs;
>  	struct async_submit_ctl submit;
> -	int count;
> +	int count, j =3D 0;
> +	struct dma_async_tx_descriptor *tx =3D NULL;
> =20
>  	pr_debug("%s: stripe %llu checkp: %d\n", __func__,
>  		(unsigned long long)sh->sector, checkp);
> =20
> -	count =3D set_syndrome_sources(srcs, sh);
> +again:
> +	srcs =3D to_scribble_page(sh, percpu, j);
> +	count =3D set_syndrome_sources(srcs, sh, j);
>  	if (!checkp)
>  		srcs[count] =3D NULL;
> =20
> -	atomic_inc(&sh->count);
> -	init_async_submit(&submit, ASYNC_TX_ACK, NULL, ops_complete_check,
> -			  sh, to_addr_conv(sh, percpu));
> -	async_syndrome_val(srcs, 0, count+2, STRIPE_SIZE,
> -			   &sh->ops.zero_sum_result, percpu->spare_page, &submit);
> +	init_async_submit(&submit, 0, tx, NULL,
> +			  NULL, to_addr_conv(sh, percpu, j));
> +	async_syndrome_val(srcs, 0, count+2, PAGE_SIZE,
> +			   &sh->ops.sum_results[j], percpu->spare_pages[j], &submit);
> +
> +	j++;
> +	if (j < STRIPE_PAGES(sh->raid_conf))
> +		goto again;
> +
> + 	atomic_inc(&sh->count);
> +	init_async_submit(&submit, ASYNC_TX_ACK, tx, ops_complete_check, sh, NU=
LL);
> +	tx =3D async_trigger_callback(&submit);
>  }
> =20
>  static void raid_run_ops(struct stripe_head *sh, unsigned long ops_reque=
st)
> @@ -1706,6 +1880,37 @@ static void raid_run_ops(struct stripe_h
>  	put_cpu();
>  }
> =20
> +#define STRIPE_ALLOC_SIZE(conf, devs) \
> +	(sizeof(struct stripe_head) + (devs - 1) * sizeof(struct r5dev) + \
> +	 sizeof(enum sum_check_flags) * STRIPE_PAGES(conf) + \
> +	 sizeof(struct bio_vec) * devs * STRIPE_PAGES(conf) * 2 + \
> +	 sizeof(struct page *) * devs * STRIPE_PAGES(conf) * 2)
> +
> +static void init_stripe_pointer(struct r5conf *conf, struct stripe_head =
*sh, int devs)
> +{
> +	void *p =3D sh;
> +	struct bio_vec *vecs, *rvecs;
> +	struct page **pages, **orig_pages;
> +	int i;
> +
> +	p +=3D sizeof(struct stripe_head) + (devs - 1) * sizeof(struct r5dev);
> +	sh->ops.sum_results =3D p;
> +	p +=3D sizeof(enum sum_check_flags) * STRIPE_PAGES(conf);
> +	vecs =3D p;
> +	p +=3D sizeof(struct bio_vec) * devs * STRIPE_PAGES(conf);
> +	rvecs =3D p;
> +	p +=3D sizeof(struct bio_vec) * devs * STRIPE_PAGES(conf);
> +	pages =3D p;
> +	p +=3D sizeof(struct page *) * devs * STRIPE_PAGES(conf);
> +	orig_pages =3D p;
> +	for (i =3D 0; i < devs; i++) {
> +		sh->dev[i].vecs =3D vecs + i * STRIPE_PAGES(conf);
> +		sh->dev[i].rvecs =3D rvecs + i * STRIPE_PAGES(conf);
> +		sh->dev[i].pages =3D pages + i * STRIPE_PAGES(conf);
> +		sh->dev[i].orig_pages =3D orig_pages + i * STRIPE_PAGES(conf);
> +	}
> +}
> +
>  static int grow_one_stripe(struct r5conf *conf, int hash)
>  {
>  	struct stripe_head *sh;
> @@ -1713,6 +1918,7 @@ static int grow_one_stripe(struct r5conf
>  	if (!sh)
>  		return 0;
> =20
> +	init_stripe_pointer(conf, sh, conf->pool_size);
>  	sh->raid_conf =3D conf;
> =20
>  	spin_lock_init(&sh->stripe_lock);
> @@ -1747,7 +1953,7 @@ static int grow_stripes(struct r5conf *c
> =20
>  	conf->active_name =3D 0;
>  	sc =3D kmem_cache_create(conf->cache_name[conf->active_name],
> -			       sizeof(struct stripe_head)+(devs-1)*sizeof(struct r5dev),
> +			       STRIPE_ALLOC_SIZE(conf, devs),
>  			       0, 0, NULL);
>  	if (!sc)
>  		return 1;
> @@ -1776,11 +1982,12 @@ static int grow_stripes(struct r5conf *c
>   * calculate over all devices (not just the data blocks), using zeros in=
 place
>   * of the P and Q blocks.
>   */
> -static size_t scribble_len(int num)
> +static size_t scribble_len(struct r5conf *conf, int num)
>  {
>  	size_t len;
> =20
>  	len =3D sizeof(struct page *) * (num+2) + sizeof(addr_conv_t) * (num+2);
> +	len *=3D STRIPE_PAGES(conf);
> =20
>  	return len;
>  }
> @@ -1816,7 +2023,7 @@ static int resize_stripes(struct r5conf
>  	unsigned long cpu;
>  	int err;
>  	struct kmem_cache *sc;
> -	int i;
> +	int i, j;
>  	int hash, cnt;
> =20
>  	if (newsize <=3D conf->pool_size)
> @@ -1828,7 +2035,7 @@ static int resize_stripes(struct r5conf
> =20
>  	/* Step 1 */
>  	sc =3D kmem_cache_create(conf->cache_name[1-conf->active_name],
> -			       sizeof(struct stripe_head)+(newsize-1)*sizeof(struct r5dev),
> +			       STRIPE_ALLOC_SIZE(conf, newsize),
>  			       0, 0, NULL);
>  	if (!sc)
>  		return -ENOMEM;
> @@ -1838,6 +2045,8 @@ static int resize_stripes(struct r5conf
>  		if (!nsh)
>  			break;
> =20
> +		init_stripe_pointer(conf, nsh, newsize);
> +
>  		nsh->raid_conf =3D conf;
>  		spin_lock_init(&nsh->stripe_lock);
> =20
> @@ -1869,11 +2078,17 @@ static int resize_stripes(struct r5conf
>  		unlock_device_hash_lock(conf, hash);
>  		atomic_set(&nsh->count, 1);
>  		for(i=3D0; i<conf->pool_size; i++) {
> -			nsh->dev[i].page =3D osh->dev[i].page;
> -			nsh->dev[i].orig_page =3D osh->dev[i].page;
> +			for (j =3D 0; j < STRIPE_PAGES(conf); j++) {
> +				nsh->dev[i].pages[j] =3D osh->dev[i].pages[j];
> +				nsh->dev[i].orig_pages[j] =3D osh->dev[i].orig_pages[j];
> +			}
> +		}
> +		for( ; i < newsize; i++) {
> +			for (j =3D 0; j < STRIPE_PAGES(conf); j++) {
> +				nsh->dev[i].pages[j] =3D NULL;
> +				nsh->dev[i].orig_pages[j] =3D NULL;
> +			}
>  		}
> -		for( ; i<newsize; i++)
> -			nsh->dev[i].page =3D NULL;
>  		nsh->hash_lock_index =3D hash;
>  		kmem_cache_free(conf->slab_cache, osh);
>  		cnt++;
> @@ -1900,7 +2115,7 @@ static int resize_stripes(struct r5conf
>  		err =3D -ENOMEM;
> =20
>  	get_online_cpus();
> -	conf->scribble_len =3D scribble_len(newsize);
> +	conf->scribble_len =3D scribble_len(conf, newsize);
>  	for_each_present_cpu(cpu) {
>  		struct raid5_percpu *percpu;
>  		void *scribble;
> @@ -1923,14 +2138,21 @@ static int resize_stripes(struct r5conf
>  		nsh =3D list_entry(newstripes.next, struct stripe_head, lru);
>  		list_del_init(&nsh->lru);
> =20
> -		for (i=3Dconf->raid_disks; i < newsize; i++)
> -			if (nsh->dev[i].page =3D=3D NULL) {
> -				struct page *p =3D alloc_page(GFP_NOIO);
> -				nsh->dev[i].page =3D p;
> -				nsh->dev[i].orig_page =3D p;
> -				if (!p)
> +		for (i=3Dconf->raid_disks; i < newsize; i++) {
> +			for (j =3D 0; j < STRIPE_PAGES(conf); j++) {
> +				struct page *p;
> +				if (nsh->dev[i].orig_pages[j])
> +					continue;
> +
> +				p =3D alloc_page(GFP_NOIO);
> +				if (!p) {
>  					err =3D -ENOMEM;
> +					continue;
> +				}
> +				nsh->dev[i].orig_pages[j] =3D p;
> +				nsh->dev[i].pages[j] =3D p;
>  			}
> +		}
>  		release_stripe(nsh);
>  	}
>  	/* critical section pass, GFP_NOIO no longer needed */
> @@ -2015,10 +2237,10 @@ static void raid5_end_read_request(struc
>  				KERN_INFO
>  				"md/raid:%s: read error corrected"
>  				" (%lu sectors at %llu on %s)\n",
> -				mdname(conf->mddev), STRIPE_SECTORS,
> +				mdname(conf->mddev), STRIPE_SECTORS(conf),
>  				(unsigned long long)s,
>  				bdevname(rdev->bdev, b));
> -			atomic_add(STRIPE_SECTORS, &rdev->corrected_errors);
> +			atomic_add(STRIPE_SECTORS(conf), &rdev->corrected_errors);
>  			clear_bit(R5_ReadError, &sh->dev[i].flags);
>  			clear_bit(R5_ReWrite, &sh->dev[i].flags);
>  		} else if (test_bit(R5_ReadNoMerge, &sh->dev[i].flags))
> @@ -2082,7 +2304,7 @@ static void raid5_end_read_request(struc
>  			if (!(set_bad
>  			      && test_bit(In_sync, &rdev->flags)
>  			      && rdev_set_badblocks(
> -				      rdev, sh->sector, STRIPE_SECTORS, 0)))
> +				      rdev, sh->sector, STRIPE_SECTORS(conf), 0)))
>  				md_error(conf->mddev, rdev);
>  		}
>  	}
> @@ -2133,7 +2355,7 @@ static void raid5_end_write_request(stru
>  		if (!uptodate)
>  			md_error(conf->mddev, rdev);
>  		else if (is_badblock(rdev, sh->sector,
> -				     STRIPE_SECTORS,
> +				     STRIPE_SECTORS(conf),
>  				     &first_bad, &bad_sectors))
>  			set_bit(R5_MadeGoodRepl, &sh->dev[i].flags);
>  	} else {
> @@ -2145,7 +2367,7 @@ static void raid5_end_write_request(stru
>  				set_bit(MD_RECOVERY_NEEDED,
>  					&rdev->mddev->recovery);
>  		} else if (is_badblock(rdev, sh->sector,
> -				       STRIPE_SECTORS,
> +				       STRIPE_SECTORS(conf),
>  				       &first_bad, &bad_sectors)) {
>  			set_bit(R5_MadeGood, &sh->dev[i].flags);
>  			if (test_bit(R5_ReadError, &sh->dev[i].flags))
> @@ -2171,13 +2393,9 @@ static void raid5_build_block(struct str
>  	struct r5dev *dev =3D &sh->dev[i];
> =20
>  	bio_init(&dev->req);
> -	dev->req.bi_io_vec =3D &dev->vec;
> -	dev->req.bi_max_vecs =3D 1;
>  	dev->req.bi_private =3D sh;
> =20
>  	bio_init(&dev->rreq);
> -	dev->rreq.bi_io_vec =3D &dev->rvec;
> -	dev->rreq.bi_max_vecs =3D 1;
>  	dev->rreq.bi_private =3D sh;
> =20
>  	dev->flags =3D 0;
> @@ -2674,13 +2892,13 @@ static int add_stripe_bio(struct stripe_
>  		/* check if page is covered */
>  		sector_t sector =3D sh->dev[dd_idx].sector;
>  		for (bi=3Dsh->dev[dd_idx].towrite;
> -		     sector < sh->dev[dd_idx].sector + STRIPE_SECTORS &&
> +		     sector < sh->dev[dd_idx].sector + STRIPE_SECTORS(conf) &&
>  			     bi && bi->bi_iter.bi_sector <=3D sector;
> -		     bi =3D r5_next_bio(bi, sh->dev[dd_idx].sector)) {
> +		     bi =3D r5_next_bio(conf, bi, sh->dev[dd_idx].sector)) {
>  			if (bio_end_sector(bi) >=3D sector)
>  				sector =3D bio_end_sector(bi);
>  		}
> -		if (sector >=3D sh->dev[dd_idx].sector + STRIPE_SECTORS)
> +		if (sector >=3D sh->dev[dd_idx].sector + STRIPE_SECTORS(conf))
>  			set_bit(R5_OVERWRITE, &sh->dev[dd_idx].flags);
>  	}
> =20
> @@ -2691,7 +2909,7 @@ static int add_stripe_bio(struct stripe_
> =20
>  	if (conf->mddev->bitmap && firstwrite) {
>  		bitmap_startwrite(conf->mddev->bitmap, sh->sector,
> -				  STRIPE_SECTORS, 0);
> +				  STRIPE_SECTORS(conf), 0);
>  		sh->bm_seq =3D conf->seq_flush+1;
>  		set_bit(STRIPE_BIT_DELAY, &sh->state);
>  	}
> @@ -2744,7 +2962,7 @@ handle_failed_stripe(struct r5conf *conf
>  				if (!rdev_set_badblocks(
>  					    rdev,
>  					    sh->sector,
> -					    STRIPE_SECTORS, 0))
> +					    STRIPE_SECTORS(conf), 0))
>  					md_error(conf->mddev, rdev);
>  				rdev_dec_pending(rdev, conf->mddev);
>  			}
> @@ -2761,8 +2979,8 @@ handle_failed_stripe(struct r5conf *conf
>  			wake_up(&conf->wait_for_overlap);
> =20
>  		while (bi && bi->bi_iter.bi_sector <
> -			sh->dev[i].sector + STRIPE_SECTORS) {
> -			struct bio *nextbi =3D r5_next_bio(bi, sh->dev[i].sector);
> +			sh->dev[i].sector + STRIPE_SECTORS(conf)) {
> +			struct bio *nextbi =3D r5_next_bio(conf, bi, sh->dev[i].sector);
>  			clear_bit(BIO_UPTODATE, &bi->bi_flags);
>  			if (!raid5_dec_bi_active_stripes(bi)) {
>  				md_write_end(conf->mddev);
> @@ -2773,20 +2991,20 @@ handle_failed_stripe(struct r5conf *conf
>  		}
>  		if (bitmap_end)
>  			bitmap_endwrite(conf->mddev->bitmap, sh->sector,
> -				STRIPE_SECTORS, 0, 0);
> +				STRIPE_SECTORS(conf), 0, 0);
>  		bitmap_end =3D 0;
>  		/* and fail all 'written' */
>  		bi =3D sh->dev[i].written;
>  		sh->dev[i].written =3D NULL;
>  		if (test_and_clear_bit(R5_SkipCopy, &sh->dev[i].flags)) {
>  			WARN_ON(test_bit(R5_UPTODATE, &sh->dev[i].flags));
> -			sh->dev[i].page =3D sh->dev[i].orig_page;
> +			reset_stripe_devpage(sh, i);
>  		}
> =20
>  		if (bi) bitmap_end =3D 1;
>  		while (bi && bi->bi_iter.bi_sector <
> -		       sh->dev[i].sector + STRIPE_SECTORS) {
> -			struct bio *bi2 =3D r5_next_bio(bi, sh->dev[i].sector);
> +		       sh->dev[i].sector + STRIPE_SECTORS(conf)) {
> +			struct bio *bi2 =3D r5_next_bio(conf, bi, sh->dev[i].sector);
>  			clear_bit(BIO_UPTODATE, &bi->bi_flags);
>  			if (!raid5_dec_bi_active_stripes(bi)) {
>  				md_write_end(conf->mddev);
> @@ -2809,9 +3027,9 @@ handle_failed_stripe(struct r5conf *conf
>  			if (test_and_clear_bit(R5_Overlap, &sh->dev[i].flags))
>  				wake_up(&conf->wait_for_overlap);
>  			while (bi && bi->bi_iter.bi_sector <
> -			       sh->dev[i].sector + STRIPE_SECTORS) {
> +			       sh->dev[i].sector + STRIPE_SECTORS(conf)) {
>  				struct bio *nextbi =3D
> -					r5_next_bio(bi, sh->dev[i].sector);
> +					r5_next_bio(conf, bi, sh->dev[i].sector);
>  				clear_bit(BIO_UPTODATE, &bi->bi_flags);
>  				if (!raid5_dec_bi_active_stripes(bi)) {
>  					bi->bi_next =3D *return_bi;
> @@ -2822,7 +3040,7 @@ handle_failed_stripe(struct r5conf *conf
>  		}
>  		if (bitmap_end)
>  			bitmap_endwrite(conf->mddev->bitmap, sh->sector,
> -					STRIPE_SECTORS, 0, 0);
> +					STRIPE_SECTORS(conf), 0, 0);
>  		/* If we were in the middle of a write the parity block might
>  		 * still be locked - so just clear all R5_LOCKED flags
>  		 */
> @@ -2863,21 +3081,21 @@ handle_failed_sync(struct r5conf *conf,
>  			    && !test_bit(Faulty, &rdev->flags)
>  			    && !test_bit(In_sync, &rdev->flags)
>  			    && !rdev_set_badblocks(rdev, sh->sector,
> -						   STRIPE_SECTORS, 0))
> +						   STRIPE_SECTORS(conf), 0))
>  				abort =3D 1;
>  			rdev =3D conf->disks[i].replacement;
>  			if (rdev
>  			    && !test_bit(Faulty, &rdev->flags)
>  			    && !test_bit(In_sync, &rdev->flags)
>  			    && !rdev_set_badblocks(rdev, sh->sector,
> -						   STRIPE_SECTORS, 0))
> +						   STRIPE_SECTORS(conf), 0))
>  				abort =3D 1;
>  		}
>  		if (abort)
>  			conf->recovery_disabled =3D
>  				conf->mddev->recovery_disabled;
>  	}
> -	md_done_sync(conf->mddev, STRIPE_SECTORS, !abort);
> +	md_done_sync(conf->mddev, STRIPE_SECTORS(conf), !abort);
>  }
> =20
>  static int want_replace(struct stripe_head *sh, int disk_idx)
> @@ -3036,13 +3254,13 @@ static void handle_stripe_clean_event(st
>  					clear_bit(R5_UPTODATE, &dev->flags);
>  				if (test_and_clear_bit(R5_SkipCopy, &dev->flags)) {
>  					WARN_ON(test_bit(R5_UPTODATE, &dev->flags));
> -					dev->page =3D dev->orig_page;
> +					reset_stripe_devpage(sh, i);
>  				}
>  				wbi =3D dev->written;
>  				dev->written =3D NULL;
>  				while (wbi && wbi->bi_iter.bi_sector <
> -					dev->sector + STRIPE_SECTORS) {
> -					wbi2 =3D r5_next_bio(wbi, dev->sector);
> +					dev->sector + STRIPE_SECTORS(conf)) {
> +					wbi2 =3D r5_next_bio(conf, wbi, dev->sector);
>  					if (!raid5_dec_bi_active_stripes(wbi)) {
>  						md_write_end(conf->mddev);
>  						wbi->bi_next =3D *return_bi;
> @@ -3051,13 +3269,13 @@ static void handle_stripe_clean_event(st
>  					wbi =3D wbi2;
>  				}
>  				bitmap_endwrite(conf->mddev->bitmap, sh->sector,
> -						STRIPE_SECTORS,
> +						STRIPE_SECTORS(conf),
>  					 !test_bit(STRIPE_DEGRADED, &sh->state),
>  						0);
>  			} else if (test_bit(R5_Discard, &dev->flags))
>  				discard_pending =3D 1;
>  			WARN_ON(test_bit(R5_SkipCopy, &dev->flags));
> -			WARN_ON(dev->page !=3D dev->orig_page);
> +			WARN_ON(dev->pages[0] !=3D dev->orig_pages[0]);
>  		}
>  	if (!discard_pending &&
>  	    test_bit(R5_Discard, &sh->dev[sh->pd_idx].flags)) {
> @@ -3274,7 +3492,7 @@ static void handle_parity_checks5(struct
>  			 */
>  			set_bit(STRIPE_INSYNC, &sh->state);
>  		else {
> -			atomic64_add(STRIPE_SECTORS, &conf->mddev->resync_mismatches);
> +			atomic64_add(STRIPE_SECTORS(conf), &conf->mddev->resync_mismatches);
>  			if (test_bit(MD_RECOVERY_CHECK, &conf->mddev->recovery))
>  				/* don't try to repair!! */
>  				set_bit(STRIPE_INSYNC, &sh->state);
> @@ -3426,7 +3644,7 @@ static void handle_parity_checks6(struct
>  				 */
>  			}
>  		} else {
> -			atomic64_add(STRIPE_SECTORS, &conf->mddev->resync_mismatches);
> +			atomic64_add(STRIPE_SECTORS(conf), &conf->mddev->resync_mismatches);
>  			if (test_bit(MD_RECOVERY_CHECK, &conf->mddev->recovery))
>  				/* don't try to repair!! */
>  				set_bit(STRIPE_INSYNC, &sh->state);
> @@ -3466,7 +3684,7 @@ static void handle_parity_checks6(struct
> =20
>  static void handle_stripe_expansion(struct r5conf *conf, struct stripe_h=
ead *sh)
>  {
> -	int i;
> +	int i, k;
> =20
>  	/* We have read all the blocks in this stripe and now we need to
>  	 * copy some of them into a target stripe for expand.
> @@ -3496,11 +3714,13 @@ static void handle_stripe_expansion(stru
>  				continue;
>  			}
> =20
> -			/* place all the copies on one channel */
> -			init_async_submit(&submit, 0, tx, NULL, NULL, NULL);
> -			tx =3D async_memcpy(sh2->dev[dd_idx].page,
> -					  sh->dev[i].page, 0, 0, STRIPE_SIZE,
> -					  &submit);
> +			for (k =3D 0; k < STRIPE_PAGES(sh->raid_conf); k++) {
> +				/* place all the copies on one channel */
> +				init_async_submit(&submit, 0, tx, NULL, NULL, NULL);
> +				tx =3D async_memcpy(sh2->dev[dd_idx].pages[k],
> +						  sh->dev[i].pages[k], 0, 0, PAGE_SIZE,
> +						  &submit);
> +			}
> =20
>  			set_bit(R5_Expanded, &sh2->dev[dd_idx].flags);
>  			set_bit(R5_UPTODATE, &sh2->dev[dd_idx].flags);
> @@ -3597,8 +3817,8 @@ static void analyse_stripe(struct stripe
>  		 */
>  		rdev =3D rcu_dereference(conf->disks[i].replacement);
>  		if (rdev && !test_bit(Faulty, &rdev->flags) &&
> -		    rdev->recovery_offset >=3D sh->sector + STRIPE_SECTORS &&
> -		    !is_badblock(rdev, sh->sector, STRIPE_SECTORS,
> +		    rdev->recovery_offset >=3D sh->sector + STRIPE_SECTORS(conf) &&
> +		    !is_badblock(rdev, sh->sector, STRIPE_SECTORS(conf),
>  				 &first_bad, &bad_sectors))
>  			set_bit(R5_ReadRepl, &dev->flags);
>  		else {
> @@ -3610,7 +3830,7 @@ static void analyse_stripe(struct stripe
>  		if (rdev && test_bit(Faulty, &rdev->flags))
>  			rdev =3D NULL;
>  		if (rdev) {
> -			is_bad =3D is_badblock(rdev, sh->sector, STRIPE_SECTORS,
> +			is_bad =3D is_badblock(rdev, sh->sector, STRIPE_SECTORS(conf),
>  					     &first_bad, &bad_sectors);
>  			if (s->blocked_rdev =3D=3D NULL
>  			    && (test_bit(Blocked, &rdev->flags)
> @@ -3637,7 +3857,7 @@ static void analyse_stripe(struct stripe
>  			}
>  		} else if (test_bit(In_sync, &rdev->flags))
>  			set_bit(R5_Insync, &dev->flags);
> -		else if (sh->sector + STRIPE_SECTORS <=3D rdev->recovery_offset)
> +		else if (sh->sector + STRIPE_SECTORS(conf) <=3D rdev->recovery_offset)
>  			/* in sync if before recovery_offset */
>  			set_bit(R5_Insync, &dev->flags);
>  		else if (test_bit(R5_UPTODATE, &dev->flags) &&
> @@ -3903,7 +4123,7 @@ static void handle_stripe(struct stripe_
>  	if ((s.syncing || s.replacing) && s.locked =3D=3D 0 &&
>  	    !test_bit(STRIPE_COMPUTE_RUN, &sh->state) &&
>  	    test_bit(STRIPE_INSYNC, &sh->state)) {
> -		md_done_sync(conf->mddev, STRIPE_SECTORS, 1);
> +		md_done_sync(conf->mddev, STRIPE_SECTORS(conf), 1);
>  		clear_bit(STRIPE_SYNCING, &sh->state);
>  		if (test_and_clear_bit(R5_Overlap, &sh->dev[sh->pd_idx].flags))
>  			wake_up(&conf->wait_for_overlap);
> @@ -3972,7 +4192,7 @@ static void handle_stripe(struct stripe_
>  		clear_bit(STRIPE_EXPAND_READY, &sh->state);
>  		atomic_dec(&conf->reshape_stripes);
>  		wake_up(&conf->wait_for_overlap);
> -		md_done_sync(conf->mddev, STRIPE_SECTORS, 1);
> +		md_done_sync(conf->mddev, STRIPE_SECTORS(conf), 1);
>  	}
> =20
>  	if (s.expanding && s.locked =3D=3D 0 &&
> @@ -4002,14 +4222,14 @@ finish:
>  				/* We own a safe reference to the rdev */
>  				rdev =3D conf->disks[i].rdev;
>  				if (!rdev_set_badblocks(rdev, sh->sector,
> -							STRIPE_SECTORS, 0))
> +							STRIPE_SECTORS(conf), 0))
>  					md_error(conf->mddev, rdev);
>  				rdev_dec_pending(rdev, conf->mddev);
>  			}
>  			if (test_and_clear_bit(R5_MadeGood, &dev->flags)) {
>  				rdev =3D conf->disks[i].rdev;
>  				rdev_clear_badblocks(rdev, sh->sector,
> -						     STRIPE_SECTORS, 0);
> +						     STRIPE_SECTORS(conf), 0);
>  				rdev_dec_pending(rdev, conf->mddev);
>  			}
>  			if (test_and_clear_bit(R5_MadeGoodRepl, &dev->flags)) {
> @@ -4018,7 +4238,7 @@ finish:
>  					/* rdev have been moved down */
>  					rdev =3D conf->disks[i].rdev;
>  				rdev_clear_badblocks(rdev, sh->sector,
> -						     STRIPE_SECTORS, 0);
> +						     STRIPE_SECTORS(conf), 0);
>  				rdev_dec_pending(rdev, conf->mddev);
>  			}
>  		}
> @@ -4502,7 +4722,7 @@ static void make_discard_request(struct
>  		/* Skip discard while reshape is happening */
>  		return;
> =20
> -	logical_sector =3D bi->bi_iter.bi_sector & ~((sector_t)STRIPE_SECTORS-1=
);
> +	logical_sector =3D bi->bi_iter.bi_sector & ~((sector_t)STRIPE_SECTORS(c=
onf)-1);
>  	last_sector =3D bi->bi_iter.bi_sector + (bi->bi_iter.bi_size>>9);
> =20
>  	bi->bi_next =3D NULL;
> @@ -4518,7 +4738,7 @@ static void make_discard_request(struct
>  	last_sector *=3D conf->chunk_sectors;
> =20
>  	for (; logical_sector < last_sector;
> -	     logical_sector +=3D STRIPE_SECTORS) {
> +	     logical_sector +=3D STRIPE_SECTORS(conf)) {
>  		DEFINE_WAIT(w);
>  		int d;
>  	again:
> @@ -4560,7 +4780,7 @@ static void make_discard_request(struct
>  			     d++)
>  				bitmap_startwrite(mddev->bitmap,
>  						  sh->sector,
> -						  STRIPE_SECTORS,
> +						  STRIPE_SECTORS(conf),
>  						  0);
>  			sh->bm_seq =3D conf->seq_flush + 1;
>  			set_bit(STRIPE_BIT_DELAY, &sh->state);
> @@ -4609,13 +4829,13 @@ static void make_request(struct mddev *m
>  		return;
>  	}
> =20
> -	logical_sector =3D bi->bi_iter.bi_sector & ~((sector_t)STRIPE_SECTORS-1=
);
> +	logical_sector =3D bi->bi_iter.bi_sector & ~((sector_t)STRIPE_SECTORS(c=
onf)-1);
>  	last_sector =3D bio_end_sector(bi);
>  	bi->bi_next =3D NULL;
>  	bi->bi_phys_segments =3D 1;	/* over-loaded to count active stripes */
> =20
>  	prepare_to_wait(&conf->wait_for_overlap, &w, TASK_UNINTERRUPTIBLE);
> -	for (;logical_sector < last_sector; logical_sector +=3D STRIPE_SECTORS)=
 {
> +	for (;logical_sector < last_sector; logical_sector +=3D STRIPE_SECTORS(=
conf)) {
>  		int previous;
>  		int seq;
> =20
> @@ -4895,7 +5115,7 @@ static sector_t reshape_request(struct m
>  	}
> =20
>  	INIT_LIST_HEAD(&stripes);
> -	for (i =3D 0; i < reshape_sectors; i +=3D STRIPE_SECTORS) {
> +	for (i =3D 0; i < reshape_sectors; i +=3D STRIPE_SECTORS(conf)) {
>  		int j;
>  		int skipped_disk =3D 0;
>  		sh =3D get_active_stripe(conf, stripe_addr+i, 0, 0, 1);
> @@ -4906,6 +5126,7 @@ static sector_t reshape_request(struct m
>  		 */
>  		for (j=3Dsh->disks; j--;) {
>  			sector_t s;
> +			int k;
>  			if (j =3D=3D sh->pd_idx)
>  				continue;
>  			if (conf->level =3D=3D 6 &&
> @@ -4916,7 +5137,8 @@ static sector_t reshape_request(struct m
>  				skipped_disk =3D 1;
>  				continue;
>  			}
> -			memset(page_address(sh->dev[j].page), 0, STRIPE_SIZE);
> +			for (k =3D 0; k < STRIPE_PAGES(conf); k++)
> +				memset(page_address(sh->dev[j].pages[k]), 0, PAGE_SIZE);
>  			set_bit(R5_Expanded, &sh->dev[j].flags);
>  			set_bit(R5_UPTODATE, &sh->dev[j].flags);
>  		}
> @@ -4951,7 +5173,7 @@ static sector_t reshape_request(struct m
>  		set_bit(STRIPE_EXPAND_SOURCE, &sh->state);
>  		set_bit(STRIPE_HANDLE, &sh->state);
>  		release_stripe(sh);
> -		first_sector +=3D STRIPE_SECTORS;
> +		first_sector +=3D STRIPE_SECTORS(conf);
>  	}
>  	/* Now that the sources are clearly marked, we can release
>  	 * the destination stripes
> @@ -5046,11 +5268,11 @@ static inline sector_t sync_request(stru
>  	if (!test_bit(MD_RECOVERY_REQUESTED, &mddev->recovery) &&
>  	    !conf->fullsync &&
>  	    !bitmap_start_sync(mddev->bitmap, sector_nr, &sync_blocks, 1) &&
> -	    sync_blocks >=3D STRIPE_SECTORS) {
> +	    sync_blocks >=3D STRIPE_SECTORS(conf)) {
>  		/* we can skip this block, and probably more */
> -		sync_blocks /=3D STRIPE_SECTORS;
> +		sync_blocks /=3D STRIPE_SECTORS(conf);
>  		*skipped =3D 1;
> -		return sync_blocks * STRIPE_SECTORS; /* keep things rounded to whole s=
tripes */
> +		return sync_blocks * STRIPE_SECTORS(conf); /* keep things rounded to w=
hole stripes */
>  	}
> =20
>  	bitmap_cond_end_sync(mddev->bitmap, sector_nr);
> @@ -5078,7 +5300,7 @@ static inline sector_t sync_request(stru
> =20
>  	release_stripe(sh);
> =20
> -	return STRIPE_SECTORS;
> +	return STRIPE_SECTORS(conf);
>  }
> =20
>  static int  retry_aligned_read(struct r5conf *conf, struct bio *raid_bio)
> @@ -5101,14 +5323,14 @@ static int  retry_aligned_read(struct r5
>  	int handled =3D 0;
> =20
>  	logical_sector =3D raid_bio->bi_iter.bi_sector &
> -		~((sector_t)STRIPE_SECTORS-1);
> +		~((sector_t)STRIPE_SECTORS(conf)-1);
>  	sector =3D raid5_compute_sector(conf, logical_sector,
>  				      0, &dd_idx, NULL);
>  	last_sector =3D bio_end_sector(raid_bio);
> =20
>  	for (; logical_sector < last_sector;
> -	     logical_sector +=3D STRIPE_SECTORS,
> -		     sector +=3D STRIPE_SECTORS,
> +	     logical_sector +=3D STRIPE_SECTORS(conf),
> +		     sector +=3D STRIPE_SECTORS(conf),
>  		     scnt++) {
> =20
>  		if (scnt < raid5_bi_processed_stripes(raid_bio))
> @@ -5607,20 +5829,42 @@ raid5_size(struct mddev *mddev, sector_t
> =20
>  static void free_scratch_buffer(struct r5conf *conf, struct raid5_percpu=
 *percpu)
>  {
> -	safe_put_page(percpu->spare_page);
> +	int i;
> +	if (percpu->spare_pages) {
> +		for (i =3D 0; i < STRIPE_PAGES(conf); i++)
> +			safe_put_page(percpu->spare_pages[i]);
> +		kfree(percpu->spare_pages);
> +	}
>  	kfree(percpu->scribble);
> -	percpu->spare_page =3D NULL;
> +	percpu->spare_pages =3D NULL;
>  	percpu->scribble =3D NULL;
>  }
> =20
>  static int alloc_scratch_buffer(struct r5conf *conf, struct raid5_percpu=
 *percpu)
>  {
> -	if (conf->level =3D=3D 6 && !percpu->spare_page)
> -		percpu->spare_page =3D alloc_page(GFP_KERNEL);
> +	bool sp_alloc_fail =3D false;
> +	if (conf->level =3D=3D 6 && !percpu->spare_pages) {
> +		struct page **pages;
> +		int i;
> +
> +		pages =3D kzalloc(sizeof(struct page *) * STRIPE_PAGES(conf),
> +			GFP_KERNEL);
> +		sp_alloc_fail =3D true;
> +		if (pages) {
> +			percpu->spare_pages =3D pages;
> +			for (i =3D 0; i < STRIPE_PAGES(conf); i++) {
> +				pages[i] =3D alloc_page(GFP_KERNEL);
> +				if (!pages[i])
> +					break;
> +			}
> +			if (i =3D=3D STRIPE_PAGES(conf))
> +				sp_alloc_fail =3D false;
> +		}
> +	}
>  	if (!percpu->scribble)
>  		percpu->scribble =3D kmalloc(conf->scribble_len, GFP_KERNEL);
> =20
> -	if (!percpu->scribble || (conf->level =3D=3D 6 && !percpu->spare_page))=
 {
> +	if (!percpu->scribble || sp_alloc_fail) {
>  		free_scratch_buffer(conf, percpu);
>  		return -ENOMEM;
>  	}
> @@ -5788,7 +6032,7 @@ static struct r5conf *setup_conf(struct
>  	else
>  		conf->previous_raid_disks =3D mddev->raid_disks - mddev->delta_disks;
>  	max_disks =3D max(conf->raid_disks, conf->previous_raid_disks);
> -	conf->scribble_len =3D scribble_len(max_disks);
> +	conf->scribble_len =3D scribble_len(conf, max_disks);
> =20
>  	conf->disks =3D kzalloc(max_disks * sizeof(struct disk_info),
>  			      GFP_KERNEL);
> @@ -6512,14 +6756,25 @@ static int check_stripe_cache(struct mdd
>  	 * stripe_heads first.
>  	 */
>  	struct r5conf *conf =3D mddev->private;
> -	if (((mddev->chunk_sectors << 9) / STRIPE_SIZE) * 4
> +
> +	/*
> +	 * stripe size is bigger than chunk size is possible, but not very
> +	 * useful. We don't allow it at this point.
> +	 */
> +	if ((mddev->new_chunk_sectors << 9) < STRIPE_SIZE(conf)) {
> +		printk(KERN_WARNING
> +		  "md/raid:%s: reshape: chunk size is smaller than stripe cache size\n=
",
> +		  mdname(mddev));
> +		return 0;
> +	}
> +	if (((mddev->chunk_sectors << 9) / STRIPE_SIZE(conf)) * 4
>  	    > conf->max_nr_stripes ||
> -	    ((mddev->new_chunk_sectors << 9) / STRIPE_SIZE) * 4
> +	    ((mddev->new_chunk_sectors << 9) / STRIPE_SIZE(conf)) * 4
>  	    > conf->max_nr_stripes) {
>  		printk(KERN_WARNING "md/raid:%s: reshape: not enough stripes.  Needed =
%lu\n",
>  		       mdname(mddev),
>  		       ((max(mddev->chunk_sectors, mddev->new_chunk_sectors) << 9)
> -			/ STRIPE_SIZE)*4);
> +			/ STRIPE_SIZE(conf))*4);
>  		return 0;
>  	}
>  	return 1;
> @@ -6827,6 +7082,7 @@ static void *raid45_takeover_raid0(struc
>  static void *raid5_takeover_raid1(struct mddev *mddev)
>  {
>  	int chunksect;
> +	struct r5conf *conf =3D mddev->private;
> =20
>  	if (mddev->raid_disks !=3D 2 ||
>  	    mddev->degraded > 1)
> @@ -6840,7 +7096,7 @@ static void *raid5_takeover_raid1(struct
>  	while (chunksect && (mddev->array_sectors & (chunksect-1)))
>  		chunksect >>=3D 1;
> =20
> -	if ((chunksect<<9) < STRIPE_SIZE)
> +	if ((chunksect<<9) < STRIPE_SIZE(conf))
>  		/* array size does not allow a suitable chunk size */
>  		return ERR_PTR(-EINVAL);
> =20
> Index: linux/drivers/md/raid5.h
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux.orig/drivers/md/raid5.h	2014-07-23 14:09:45.844570945 +0800
> +++ linux/drivers/md/raid5.h	2014-07-23 14:09:45.836571048 +0800
> @@ -225,14 +225,15 @@ struct stripe_head {
>  	struct stripe_operations {
>  		int 		     target, target2;
>  		enum sum_check_flags zero_sum_result;
> +		enum sum_check_flags *sum_results;
>  	} ops;
>  	struct r5dev {
>  		/* rreq and rvec are used for the replacement device when
>  		 * writing data to both devices.
>  		 */
>  		struct bio	req, rreq;
> -		struct bio_vec	vec, rvec;
> -		struct page	*page, *orig_page;
> +		struct bio_vec	*vecs, *rvecs;
> +		struct page	**pages, **orig_pages;
>  		struct bio	*toread, *read, *towrite, *written;
>  		sector_t	sector;			/* sector of this page */
>  		unsigned long	flags;
> @@ -458,7 +459,7 @@ struct r5conf {
>  	int			recovery_disabled;
>  	/* per cpu variables */
>  	struct raid5_percpu {
> -		struct page	*spare_page; /* Used when checking P/Q in raid6 */
> +		struct page	**spare_pages; /* Used when checking P/Q in raid6 */
>  		void		*scribble;   /* space for constructing buffer
>  					      * lists and performing address
>  					      * conversions
> @@ -487,6 +488,7 @@ struct r5conf {
>  	int			pool_size; /* number of disks in stripeheads in pool */
>  	spinlock_t		device_lock;
>  	struct disk_info	*disks;
> +	int			stripe_size_order;
> =20
>  	/* When taking over an array from a different personality, we store
>  	 * the new thread here until we fully activate the array.


--Sig_/=ykqH/iAjcuhsnhl_eCFw1D
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBU97aYznsnt1WYoG5AQJGpQ//T/HcYg7pBc5QA3x4HCSqDi/X2bjQjb33
nkhtVCudlpi+K+SCnZnbOO7Ga4Ebe0msHfLRjN2qqqRTgSI4yubd282Wsr/cmc6T
5u/gozZLFA8Q2e0VjlK9ovtQ6SZhKOASDxQqElj/7CpbqYzv5vUGLe6yFrDRkPp5
FjT92ObPxugkcEx2+TWRc1z5JuhpPzheHFx8qdhHWGsjqf4CSlPaKxhu5sZNDqAW
+tuIuPIAb9zvQMBmXSyFUnQxq1sfT3JSJzZ6Kh7aLAlGGbK3cdXugac5hzyBiJaj
VAY7OVgKmMJK5iMn80lfu0mHp/zNsT3Px/feBxS5P1JinCvBfpQWSk7DSIbijGoP
GepGU9YboKu8eIRao1D29w5ffqFrpF+EGgazl76Nw9Akd58R56Ofk5yp7ZkeJ6J7
oAVohWz9cT8A36r8os6AfVku85tQFnMGrqLhUYPiWUNGodrRxiVsWNhwkV2OBZw3
r0gXWw0AQ1iIDJg1G5HjJHmer25Gi6cI5GWQL3BI8TqBkrj441d8DNLVNeAziVFV
M996xouquLLZC4IK22VbHqa7Ok8zg4g1GvFIr9lxZxP7nQQXoE7vu8POtTvC1Pjv
89V7iKkJ0TaZ/iKAsS5auWTVebelAdqWG+2lQwxVGxfRyEqMFr/JGicSDbbMBpUW
B/hcCJOmNug=
=9h+q
-----END PGP SIGNATURE-----

--Sig_/=ykqH/iAjcuhsnhl_eCFw1D--
