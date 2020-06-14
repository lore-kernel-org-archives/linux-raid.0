From: Xiao Ni <xni@redhat.com>
Subject: Re: [PATCH v4 01/15] md/raid456: covert macro define of STRIPE_* as
 members of struct r5conf
Date: Sun, 14 Jun 2020 10:28:23 +0800
Message-ID: <00ffbcfe-1cc1-470b-d1a7-718e09f4f922@redhat.com>
References: <20200612114220.13126-1-yuyufen@huawei.com>
 <20200612114220.13126-2-yuyufen@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20200612114220.13126-2-yuyufen@huawei.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Yufen Yu <yuyufen@huawei.com>, song@kernel.org
Cc: linux-raid@vger.kernel.org, neilb@suse.com, guoqing.jiang@cloud.ionos.com, houtao1@huawei.com
List-Id: linux-raid.ids

Hi Yufen

It looks like there is something wrong. I try to apply these patches 
based on latest upstream, but it fails.

[xni@xiao md]$ git am big-page/\[PATCH\ v4\ 01_15\]\ md_raid456\:\ 
covert\ macro\ define\ of\ STRIPE_\*\ as\ members\ of\ struct\ r5conf\ 
-\ Yufen\ Yu\ \<yuyufen@huawei.com\>\ -\ 2020-06-12\ 1942.eml
Applying: md/raid456: covert macro define of STRIPE_* as members of 
struct r5conf
error: patch failed: drivers/md/raid5.c:2267
error: drivers/md/raid5.c: patch does not apply
Patch failed at 0001 md/raid456: covert macro define of STRIPE_* as 
members of struct r5conf
The copy of the patch that failed is found in: .git/rebase-apply/patch
[xni@xiao md]$ cat .git/config
snip..
[remote "origin"]
     url = https://git.kernel.org/pub/scm/linux/kernel/git/song/md.git
[xni@xiao md]$ git branch
   master
* md-next


On 06/12/2020 07:42 PM, Yufen Yu wrote:
> We covert STRIPE_SIZE, STRIPE_SHIFT and STRIPE_SECTORS to stripe_size,
> stripe_shift and stripe_sectors as members of struct r5conf. Then each
> raid456 array can config different stripe_size. This patch is prepared
> for following configurable stripe_size.
>
> Simply replace word STRIPE_ with conf->stripe_ and add 'conf' argument
> for function stripe_hash_locks_hash() and r5_next_bio() to get stripe_size.
> After that, we initialize stripe_size into setup_conf().
>
> Signed-off-by: Yufen Yu <yuyufen@huawei.com>
> ---
>   drivers/md/raid5-cache.c |   8 +-
>   drivers/md/raid5-ppl.c   |  12 +-
>   drivers/md/raid5.c       | 253 +++++++++++++++++++++++----------------
>   drivers/md/raid5.h       |  41 +++----
>   4 files changed, 182 insertions(+), 132 deletions(-)
>
> diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
> index 9b6da759dca2..a095de43d4c7 100644
> --- a/drivers/md/raid5-cache.c
> +++ b/drivers/md/raid5-cache.c
> @@ -298,8 +298,8 @@ r5c_return_dev_pending_writes(struct r5conf *conf, struct r5dev *dev)
>   	wbi = dev->written;
>   	dev->written = NULL;
>   	while (wbi && wbi->bi_iter.bi_sector <
> -	       dev->sector + STRIPE_SECTORS) {
> -		wbi2 = r5_next_bio(wbi, dev->sector);
> +	       dev->sector + conf->stripe_sectors) {
> +		wbi2 = r5_next_bio(conf, wbi, dev->sector);
>   		md_write_end(conf->mddev);
>   		bio_endio(wbi);
>   		wbi = wbi2;
> @@ -316,7 +316,7 @@ void r5c_handle_cached_data_endio(struct r5conf *conf,
>   			set_bit(R5_UPTODATE, &sh->dev[i].flags);
>   			r5c_return_dev_pending_writes(conf, &sh->dev[i]);
>   			md_bitmap_endwrite(conf->mddev->bitmap, sh->sector,
> -					   STRIPE_SECTORS,
> +					   conf->stripe_sectors,
>   					   !test_bit(STRIPE_DEGRADED, &sh->state),
>   					   0);
>   		}
> @@ -364,7 +364,7 @@ void r5c_check_cached_full_stripe(struct r5conf *conf)
>   	 */
>   	if (atomic_read(&conf->r5c_cached_full_stripes) >=
>   	    min(R5C_FULL_STRIPE_FLUSH_BATCH(conf),
> -		conf->chunk_sectors >> STRIPE_SHIFT))
> +		conf->chunk_sectors >> conf->stripe_shift))
>   		r5l_wake_reclaim(conf->log, 0);
>   }
>   
> diff --git a/drivers/md/raid5-ppl.c b/drivers/md/raid5-ppl.c
> index d50238d0a85d..16a44cb5751b 100644
> --- a/drivers/md/raid5-ppl.c
> +++ b/drivers/md/raid5-ppl.c
> @@ -324,7 +324,7 @@ static int ppl_log_stripe(struct ppl_log *log, struct stripe_head *sh)
>   		 * be just after the last logged stripe and write to the same
>   		 * disks. Use bit shift and logarithm to avoid 64-bit division.
>   		 */
> -		if ((sh->sector == sh_last->sector + STRIPE_SECTORS) &&
> +		if ((sh->sector == sh_last->sector + conf->stripe_sectors) &&
>   		    (data_sector >> ilog2(conf->chunk_sectors) ==
>   		     data_sector_last >> ilog2(conf->chunk_sectors)) &&
>   		    ((data_sector - data_sector_last) * data_disks ==
> @@ -844,9 +844,9 @@ static int ppl_recover_entry(struct ppl_log *log, struct ppl_header_entry *e,
>   
>   	/* if start and end is 4k aligned, use a 4k block */
>   	if (block_size == 512 &&
> -	    (r_sector_first & (STRIPE_SECTORS - 1)) == 0 &&
> -	    (r_sector_last & (STRIPE_SECTORS - 1)) == 0)
> -		block_size = STRIPE_SIZE;
> +	    (r_sector_first & (conf->stripe_sectors - 1)) == 0 &&
> +	    (r_sector_last & (conf->stripe_sectors - 1)) == 0)
> +		block_size = conf->stripe_size;
>   
>   	/* iterate through blocks in strip */
>   	for (i = 0; i < strip_sectors; i += (block_size >> 9)) {
> @@ -1264,6 +1264,7 @@ static int ppl_validate_rdev(struct md_rdev *rdev)
>   	char b[BDEVNAME_SIZE];
>   	int ppl_data_sectors;
>   	int ppl_size_new;
> +	struct r5conf *conf = rdev->mddev->private;
>   
>   	/*
>   	 * The configured PPL size must be enough to store
> @@ -1274,7 +1275,8 @@ static int ppl_validate_rdev(struct md_rdev *rdev)
>   	ppl_data_sectors = rdev->ppl.size - (PPL_HEADER_SIZE >> 9);
>   
>   	if (ppl_data_sectors > 0)
> -		ppl_data_sectors = rounddown(ppl_data_sectors, STRIPE_SECTORS);
> +		ppl_data_sectors =
> +			rounddown(ppl_data_sectors, conf->stripe_sectors);
>   
>   	if (ppl_data_sectors <= 0) {
>   		pr_warn("md/raid:%s: PPL space too small on %s\n",
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 3f96b4406902..5c972af66978 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -69,13 +69,13 @@ static struct workqueue_struct *raid5_wq;
>   
>   static inline struct hlist_head *stripe_hash(struct r5conf *conf, sector_t sect)
>   {
> -	int hash = (sect >> STRIPE_SHIFT) & HASH_MASK;
> +	int hash = (sect >> conf->stripe_shift) & HASH_MASK;
>   	return &conf->stripe_hashtbl[hash];
>   }
>   
> -static inline int stripe_hash_locks_hash(sector_t sect)
> +static inline int stripe_hash_locks_hash(struct r5conf *conf, sector_t sect)
>   {
> -	return (sect >> STRIPE_SHIFT) & STRIPE_HASH_LOCKS_MASK;
> +	return (sect >> conf->stripe_shift) & STRIPE_HASH_LOCKS_MASK;
>   }
>   
>   static inline void lock_device_hash_lock(struct r5conf *conf, int hash)
> @@ -627,7 +627,7 @@ raid5_get_active_stripe(struct r5conf *conf, sector_t sector,
>   			int previous, int noblock, int noquiesce)
>   {
>   	struct stripe_head *sh;
> -	int hash = stripe_hash_locks_hash(sector);
> +	int hash = stripe_hash_locks_hash(conf, sector);
>   	int inc_empty_inactive_list_flag;
>   
>   	pr_debug("get_stripe, sector %llu\n", (unsigned long long)sector);
> @@ -748,9 +748,9 @@ static void stripe_add_to_batch_list(struct r5conf *conf, struct stripe_head *sh
>   	tmp_sec = sh->sector;
>   	if (!sector_div(tmp_sec, conf->chunk_sectors))
>   		return;
> -	head_sector = sh->sector - STRIPE_SECTORS;
> +	head_sector = sh->sector - conf->stripe_sectors;
>   
> -	hash = stripe_hash_locks_hash(head_sector);
> +	hash = stripe_hash_locks_hash(conf, head_sector);
>   	spin_lock_irq(conf->hash_locks + hash);
>   	head = __find_stripe(conf, head_sector, conf->generation);
>   	if (head && !atomic_inc_not_zero(&head->count)) {
> @@ -1057,8 +1057,9 @@ static void ops_run_io(struct stripe_head *sh, struct stripe_head_state *s)
>   		       test_bit(WriteErrorSeen, &rdev->flags)) {
>   			sector_t first_bad;
>   			int bad_sectors;
> -			int bad = is_badblock(rdev, sh->sector, STRIPE_SECTORS,
> -					      &first_bad, &bad_sectors);
> +			int bad = is_badblock(rdev, sh->sector,
> +						conf->stripe_sectors,
> +						&first_bad, &bad_sectors);
>   			if (!bad)
>   				break;
>   
> @@ -1089,7 +1090,7 @@ static void ops_run_io(struct stripe_head *sh, struct stripe_head_state *s)
>   		if (rdev) {
>   			if (s->syncing || s->expanding || s->expanded
>   			    || s->replacing)
> -				md_sync_acct(rdev->bdev, STRIPE_SECTORS);
> +				md_sync_acct(rdev->bdev, conf->stripe_sectors);
>   
>   			set_bit(STRIPE_IO_STARTED, &sh->state);
>   
> @@ -1129,9 +1130,9 @@ static void ops_run_io(struct stripe_head *sh, struct stripe_head_state *s)
>   			else
>   				sh->dev[i].vec.bv_page = sh->dev[i].page;
>   			bi->bi_vcnt = 1;
> -			bi->bi_io_vec[0].bv_len = STRIPE_SIZE;
> +			bi->bi_io_vec[0].bv_len = conf->stripe_size;
>   			bi->bi_io_vec[0].bv_offset = 0;
> -			bi->bi_iter.bi_size = STRIPE_SIZE;
> +			bi->bi_iter.bi_size = conf->stripe_size;
>   			bi->bi_write_hint = sh->dev[i].write_hint;
>   			if (!rrdev)
>   				sh->dev[i].write_hint = RWH_WRITE_LIFE_NOT_SET;
> @@ -1156,7 +1157,7 @@ static void ops_run_io(struct stripe_head *sh, struct stripe_head_state *s)
>   		if (rrdev) {
>   			if (s->syncing || s->expanding || s->expanded
>   			    || s->replacing)
> -				md_sync_acct(rrdev->bdev, STRIPE_SECTORS);
> +				md_sync_acct(rrdev->bdev, conf->stripe_sectors);
>   
>   			set_bit(STRIPE_IO_STARTED, &sh->state);
>   
> @@ -1183,9 +1184,9 @@ static void ops_run_io(struct stripe_head *sh, struct stripe_head_state *s)
>   				WARN_ON(test_bit(R5_UPTODATE, &sh->dev[i].flags));
>   			sh->dev[i].rvec.bv_page = sh->dev[i].page;
>   			rbi->bi_vcnt = 1;
> -			rbi->bi_io_vec[0].bv_len = STRIPE_SIZE;
> +			rbi->bi_io_vec[0].bv_len = conf->stripe_size;
>   			rbi->bi_io_vec[0].bv_offset = 0;
> -			rbi->bi_iter.bi_size = STRIPE_SIZE;
> +			rbi->bi_iter.bi_size = conf->stripe_size;
>   			rbi->bi_write_hint = sh->dev[i].write_hint;
>   			sh->dev[i].write_hint = RWH_WRITE_LIFE_NOT_SET;
>   			/*
> @@ -1235,6 +1236,7 @@ async_copy_data(int frombio, struct bio *bio, struct page **page,
>   	int page_offset;
>   	struct async_submit_ctl submit;
>   	enum async_tx_flags flags = 0;
> +	struct r5conf *conf = sh->raid_conf;
>   
>   	if (bio->bi_iter.bi_sector >= sector)
>   		page_offset = (signed)(bio->bi_iter.bi_sector - sector) * 512;
> @@ -1256,8 +1258,8 @@ async_copy_data(int frombio, struct bio *bio, struct page **page,
>   			len -= b_offset;
>   		}
>   
> -		if (len > 0 && page_offset + len > STRIPE_SIZE)
> -			clen = STRIPE_SIZE - page_offset;
> +		if (len > 0 && page_offset + len > conf->stripe_size)
> +			clen = conf->stripe_size - page_offset;
>   		else
>   			clen = len;
>   
> @@ -1267,7 +1269,7 @@ async_copy_data(int frombio, struct bio *bio, struct page **page,
>   			if (frombio) {
>   				if (sh->raid_conf->skip_copy &&
>   				    b_offset == 0 && page_offset == 0 &&
> -				    clen == STRIPE_SIZE &&
> +				    clen == conf->stripe_size &&
>   				    !no_skipcopy)
>   					*page = bio_page;
>   				else
> @@ -1292,6 +1294,7 @@ static void ops_complete_biofill(void *stripe_head_ref)
>   {
>   	struct stripe_head *sh = stripe_head_ref;
>   	int i;
> +	struct r5conf *conf = sh->raid_conf;
>   
>   	pr_debug("%s: stripe %llu\n", __func__,
>   		(unsigned long long)sh->sector);
> @@ -1312,8 +1315,8 @@ static void ops_complete_biofill(void *stripe_head_ref)
>   			rbi = dev->read;
>   			dev->read = NULL;
>   			while (rbi && rbi->bi_iter.bi_sector <
> -				dev->sector + STRIPE_SECTORS) {
> -				rbi2 = r5_next_bio(rbi, dev->sector);
> +				dev->sector + conf->stripe_sectors) {
> +				rbi2 = r5_next_bio(conf, rbi, dev->sector);
>   				bio_endio(rbi);
>   				rbi = rbi2;
>   			}
> @@ -1344,10 +1347,11 @@ static void ops_run_biofill(struct stripe_head *sh)
>   			dev->toread = NULL;
>   			spin_unlock_irq(&sh->stripe_lock);
>   			while (rbi && rbi->bi_iter.bi_sector <
> -				dev->sector + STRIPE_SECTORS) {
> +				dev->sector + sh->raid_conf->stripe_sectors) {
>   				tx = async_copy_data(0, rbi, &dev->page,
>   						     dev->sector, tx, sh, 0);
> -				rbi = r5_next_bio(rbi, dev->sector);
> +				rbi = r5_next_bio(sh->raid_conf, rbi,
> +						dev->sector);
>   			}
>   		}
>   	}
> @@ -1413,6 +1417,7 @@ ops_run_compute5(struct stripe_head *sh, struct raid5_percpu *percpu)
>   	struct dma_async_tx_descriptor *tx;
>   	struct async_submit_ctl submit;
>   	int i;
> +	struct r5conf *conf = sh->raid_conf;
>   
>   	BUG_ON(sh->batch_head);
>   
> @@ -1429,9 +1434,11 @@ ops_run_compute5(struct stripe_head *sh, struct raid5_percpu *percpu)
>   	init_async_submit(&submit, ASYNC_TX_FENCE|ASYNC_TX_XOR_ZERO_DST, NULL,
>   			  ops_complete_compute, sh, to_addr_conv(sh, percpu, 0));
>   	if (unlikely(count == 1))
> -		tx = async_memcpy(xor_dest, xor_srcs[0], 0, 0, STRIPE_SIZE, &submit);
> +		tx = async_memcpy(xor_dest, xor_srcs[0], 0, 0,
> +				conf->stripe_size, &submit);
>   	else
> -		tx = async_xor(xor_dest, xor_srcs, 0, count, STRIPE_SIZE, &submit);
> +		tx = async_xor(xor_dest, xor_srcs, 0, count,
> +				conf->stripe_size, &submit);
>   
>   	return tx;
>   }
> @@ -1496,6 +1503,7 @@ ops_run_compute6_1(struct stripe_head *sh, struct raid5_percpu *percpu)
>   	struct page *dest;
>   	int i;
>   	int count;
> +	struct r5conf *conf = sh->raid_conf;
>   
>   	BUG_ON(sh->batch_head);
>   	if (sh->ops.target < 0)
> @@ -1522,7 +1530,8 @@ ops_run_compute6_1(struct stripe_head *sh, struct raid5_percpu *percpu)
>   		init_async_submit(&submit, ASYNC_TX_FENCE, NULL,
>   				  ops_complete_compute, sh,
>   				  to_addr_conv(sh, percpu, 0));
> -		tx = async_gen_syndrome(blocks, 0, count+2, STRIPE_SIZE, &submit);
> +		tx = async_gen_syndrome(blocks, 0, count+2,
> +				conf->stripe_size, &submit);
>   	} else {
>   		/* Compute any data- or p-drive using XOR */
>   		count = 0;
> @@ -1535,7 +1544,8 @@ ops_run_compute6_1(struct stripe_head *sh, struct raid5_percpu *percpu)
>   		init_async_submit(&submit, ASYNC_TX_FENCE|ASYNC_TX_XOR_ZERO_DST,
>   				  NULL, ops_complete_compute, sh,
>   				  to_addr_conv(sh, percpu, 0));
> -		tx = async_xor(dest, blocks, 0, count, STRIPE_SIZE, &submit);
> +		tx = async_xor(dest, blocks, 0, count,
> +				conf->stripe_size, &submit);
>   	}
>   
>   	return tx;
> @@ -1555,6 +1565,7 @@ ops_run_compute6_2(struct stripe_head *sh, struct raid5_percpu *percpu)
>   	struct dma_async_tx_descriptor *tx;
>   	struct page **blocks = to_addr_page(percpu, 0);
>   	struct async_submit_ctl submit;
> +	struct r5conf *conf = sh->raid_conf;
>   
>   	BUG_ON(sh->batch_head);
>   	pr_debug("%s: stripe %llu block1: %d block2: %d\n",
> @@ -1598,7 +1609,7 @@ ops_run_compute6_2(struct stripe_head *sh, struct raid5_percpu *percpu)
>   					  ops_complete_compute, sh,
>   					  to_addr_conv(sh, percpu, 0));
>   			return async_gen_syndrome(blocks, 0, syndrome_disks+2,
> -						  STRIPE_SIZE, &submit);
> +						  conf->stripe_size, &submit);
>   		} else {
>   			struct page *dest;
>   			int data_target;
> @@ -1621,15 +1632,15 @@ ops_run_compute6_2(struct stripe_head *sh, struct raid5_percpu *percpu)
>   					  ASYNC_TX_FENCE|ASYNC_TX_XOR_ZERO_DST,
>   					  NULL, NULL, NULL,
>   					  to_addr_conv(sh, percpu, 0));
> -			tx = async_xor(dest, blocks, 0, count, STRIPE_SIZE,
> -				       &submit);
> +			tx = async_xor(dest, blocks, 0, count,
> +					conf->stripe_size, &submit);
>   
>   			count = set_syndrome_sources(blocks, sh, SYNDROME_SRC_ALL);
>   			init_async_submit(&submit, ASYNC_TX_FENCE, tx,
>   					  ops_complete_compute, sh,
>   					  to_addr_conv(sh, percpu, 0));
>   			return async_gen_syndrome(blocks, 0, count+2,
> -						  STRIPE_SIZE, &submit);
> +						  conf->stripe_size, &submit);
>   		}
>   	} else {
>   		init_async_submit(&submit, ASYNC_TX_FENCE, NULL,
> @@ -1638,12 +1649,13 @@ ops_run_compute6_2(struct stripe_head *sh, struct raid5_percpu *percpu)
>   		if (failb == syndrome_disks) {
>   			/* We're missing D+P. */
>   			return async_raid6_datap_recov(syndrome_disks+2,
> -						       STRIPE_SIZE, faila,
> +						       conf->stripe_size, faila,
>   						       blocks, &submit);
>   		} else {
>   			/* We're missing D+D. */
>   			return async_raid6_2data_recov(syndrome_disks+2,
> -						       STRIPE_SIZE, faila, failb,
> +						       conf->stripe_size,
> +						       faila, failb,
>   						       blocks, &submit);
>   		}
>   	}
> @@ -1672,6 +1684,7 @@ ops_run_prexor5(struct stripe_head *sh, struct raid5_percpu *percpu,
>   	struct page **xor_srcs = to_addr_page(percpu, 0);
>   	int count = 0, pd_idx = sh->pd_idx, i;
>   	struct async_submit_ctl submit;
> +	struct r5conf *conf = sh->raid_conf;
>   
>   	/* existing parity data subtracted */
>   	struct page *xor_dest = xor_srcs[count++] = sh->dev[pd_idx].page;
> @@ -1691,7 +1704,8 @@ ops_run_prexor5(struct stripe_head *sh, struct raid5_percpu *percpu,
>   
>   	init_async_submit(&submit, ASYNC_TX_FENCE|ASYNC_TX_XOR_DROP_DST, tx,
>   			  ops_complete_prexor, sh, to_addr_conv(sh, percpu, 0));
> -	tx = async_xor(xor_dest, xor_srcs, 0, count, STRIPE_SIZE, &submit);
> +	tx = async_xor(xor_dest, xor_srcs, 0, count,
> +				conf->stripe_size, &submit);
>   
>   	return tx;
>   }
> @@ -1703,6 +1717,7 @@ ops_run_prexor6(struct stripe_head *sh, struct raid5_percpu *percpu,
>   	struct page **blocks = to_addr_page(percpu, 0);
>   	int count;
>   	struct async_submit_ctl submit;
> +	struct r5conf *conf = sh->raid_conf;
>   
>   	pr_debug("%s: stripe %llu\n", __func__,
>   		(unsigned long long)sh->sector);
> @@ -1711,7 +1726,8 @@ ops_run_prexor6(struct stripe_head *sh, struct raid5_percpu *percpu,
>   
>   	init_async_submit(&submit, ASYNC_TX_FENCE|ASYNC_TX_PQ_XOR_DST, tx,
>   			  ops_complete_prexor, sh, to_addr_conv(sh, percpu, 0));
> -	tx = async_gen_syndrome(blocks, 0, count+2, STRIPE_SIZE,  &submit);
> +	tx = async_gen_syndrome(blocks, 0, count+2,
> +				conf->stripe_size, &submit);
>   
>   	return tx;
>   }
> @@ -1752,7 +1768,7 @@ ops_run_biodrain(struct stripe_head *sh, struct dma_async_tx_descriptor *tx)
>   			WARN_ON(dev->page != dev->orig_page);
>   
>   			while (wbi && wbi->bi_iter.bi_sector <
> -				dev->sector + STRIPE_SECTORS) {
> +				dev->sector + conf->stripe_sectors) {
>   				if (wbi->bi_opf & REQ_FUA)
>   					set_bit(R5_WantFUA, &dev->flags);
>   				if (wbi->bi_opf & REQ_SYNC)
> @@ -1770,7 +1786,7 @@ ops_run_biodrain(struct stripe_head *sh, struct dma_async_tx_descriptor *tx)
>   						clear_bit(R5_OVERWRITE, &dev->flags);
>   					}
>   				}
> -				wbi = r5_next_bio(wbi, dev->sector);
> +				wbi = r5_next_bio(conf, wbi, dev->sector);
>   			}
>   
>   			if (head_sh->batch_head) {
> @@ -1848,6 +1864,7 @@ ops_run_reconstruct5(struct stripe_head *sh, struct raid5_percpu *percpu,
>   	int j = 0;
>   	struct stripe_head *head_sh = sh;
>   	int last_stripe;
> +	struct r5conf *conf = sh->raid_conf;
>   
>   	pr_debug("%s: stripe %llu\n", __func__,
>   		(unsigned long long)sh->sector);
> @@ -1910,9 +1927,11 @@ ops_run_reconstruct5(struct stripe_head *sh, struct raid5_percpu *percpu,
>   	}
>   
>   	if (unlikely(count == 1))
> -		tx = async_memcpy(xor_dest, xor_srcs[0], 0, 0, STRIPE_SIZE, &submit);
> +		tx = async_memcpy(xor_dest, xor_srcs[0], 0, 0,
> +					conf->stripe_size, &submit);
>   	else
> -		tx = async_xor(xor_dest, xor_srcs, 0, count, STRIPE_SIZE, &submit);
> +		tx = async_xor(xor_dest, xor_srcs, 0, count,
> +					conf->stripe_size, &submit);
>   	if (!last_stripe) {
>   		j++;
>   		sh = list_first_entry(&sh->batch_list, struct stripe_head,
> @@ -1932,6 +1951,7 @@ ops_run_reconstruct6(struct stripe_head *sh, struct raid5_percpu *percpu,
>   	int last_stripe;
>   	int synflags;
>   	unsigned long txflags;
> +	struct r5conf *conf = sh->raid_conf;
>   
>   	pr_debug("%s: stripe %llu\n", __func__, (unsigned long long)sh->sector);
>   
> @@ -1972,7 +1992,8 @@ ops_run_reconstruct6(struct stripe_head *sh, struct raid5_percpu *percpu,
>   	} else
>   		init_async_submit(&submit, 0, tx, NULL, NULL,
>   				  to_addr_conv(sh, percpu, j));
> -	tx = async_gen_syndrome(blocks, 0, count+2, STRIPE_SIZE,  &submit);
> +	tx = async_gen_syndrome(blocks, 0, count+2,
> +				conf->stripe_size, &submit);
>   	if (!last_stripe) {
>   		j++;
>   		sh = list_first_entry(&sh->batch_list, struct stripe_head,
> @@ -2004,6 +2025,7 @@ static void ops_run_check_p(struct stripe_head *sh, struct raid5_percpu *percpu)
>   	struct async_submit_ctl submit;
>   	int count;
>   	int i;
> +	struct r5conf *conf = sh->raid_conf;
>   
>   	pr_debug("%s: stripe %llu\n", __func__,
>   		(unsigned long long)sh->sector);
> @@ -2020,7 +2042,7 @@ static void ops_run_check_p(struct stripe_head *sh, struct raid5_percpu *percpu)
>   
>   	init_async_submit(&submit, 0, NULL, NULL, NULL,
>   			  to_addr_conv(sh, percpu, 0));
> -	tx = async_xor_val(xor_dest, xor_srcs, 0, count, STRIPE_SIZE,
> +	tx = async_xor_val(xor_dest, xor_srcs, 0, count, conf->stripe_size,
>   			   &sh->ops.zero_sum_result, &submit);
>   
>   	atomic_inc(&sh->count);
> @@ -2033,6 +2055,7 @@ static void ops_run_check_pq(struct stripe_head *sh, struct raid5_percpu *percpu
>   	struct page **srcs = to_addr_page(percpu, 0);
>   	struct async_submit_ctl submit;
>   	int count;
> +	struct r5conf *conf = sh->raid_conf;
>   
>   	pr_debug("%s: stripe %llu checkp: %d\n", __func__,
>   		(unsigned long long)sh->sector, checkp);
> @@ -2045,7 +2068,7 @@ static void ops_run_check_pq(struct stripe_head *sh, struct raid5_percpu *percpu
>   	atomic_inc(&sh->count);
>   	init_async_submit(&submit, ASYNC_TX_ACK, NULL, ops_complete_check,
>   			  sh, to_addr_conv(sh, percpu, 0));
> -	async_syndrome_val(srcs, 0, count+2, STRIPE_SIZE,
> +	async_syndrome_val(srcs, 0, count+2, conf->stripe_size,
>   			   &sh->ops.zero_sum_result, percpu->spare_page, &submit);
>   }
>   
> @@ -2267,7 +2290,7 @@ static int resize_chunks(struct r5conf *conf, int new_disks, int new_sectors)
>   
>   		percpu = per_cpu_ptr(conf->percpu, cpu);
>   		err = scribble_alloc(percpu, new_disks,
> -				     new_sectors / STRIPE_SECTORS,
> +				     new_sectors / conf->stripe_sectors,
>   				     GFP_NOIO);
>   		if (err)
>   			break;
> @@ -2502,10 +2525,12 @@ static void raid5_end_read_request(struct bio * bi)
>   			 */
>   			pr_info_ratelimited(
>   				"md/raid:%s: read error corrected (%lu sectors at %llu on %s)\n",
> -				mdname(conf->mddev), (unsigned long)STRIPE_SECTORS,
> +				mdname(conf->mddev),
> +				(unsigned long)conf->stripe_sectors,
>   				(unsigned long long)s,
>   				bdevname(rdev->bdev, b));
> -			atomic_add(STRIPE_SECTORS, &rdev->corrected_errors);
> +			atomic_add(conf->stripe_sectors,
> +					&rdev->corrected_errors);
>   			clear_bit(R5_ReadError, &sh->dev[i].flags);
>   			clear_bit(R5_ReWrite, &sh->dev[i].flags);
>   		} else if (test_bit(R5_ReadNoMerge, &sh->dev[i].flags))
> @@ -2578,7 +2603,8 @@ static void raid5_end_read_request(struct bio * bi)
>   			if (!(set_bad
>   			      && test_bit(In_sync, &rdev->flags)
>   			      && rdev_set_badblocks(
> -				      rdev, sh->sector, STRIPE_SECTORS, 0)))
> +					  rdev, sh->sector,
> +					  conf->stripe_sectors, 0)))
>   				md_error(conf->mddev, rdev);
>   		}
>   	}
> @@ -2630,7 +2656,7 @@ static void raid5_end_write_request(struct bio *bi)
>   		if (bi->bi_status)
>   			md_error(conf->mddev, rdev);
>   		else if (is_badblock(rdev, sh->sector,
> -				     STRIPE_SECTORS,
> +				     conf->stripe_sectors,
>   				     &first_bad, &bad_sectors))
>   			set_bit(R5_MadeGoodRepl, &sh->dev[i].flags);
>   	} else {
> @@ -2642,7 +2668,7 @@ static void raid5_end_write_request(struct bio *bi)
>   				set_bit(MD_RECOVERY_NEEDED,
>   					&rdev->mddev->recovery);
>   		} else if (is_badblock(rdev, sh->sector,
> -				       STRIPE_SECTORS,
> +				       conf->stripe_sectors,
>   				       &first_bad, &bad_sectors)) {
>   			set_bit(R5_MadeGood, &sh->dev[i].flags);
>   			if (test_bit(R5_ReadError, &sh->dev[i].flags))
> @@ -3276,13 +3302,13 @@ static int add_stripe_bio(struct stripe_head *sh, struct bio *bi, int dd_idx,
>   		/* check if page is covered */
>   		sector_t sector = sh->dev[dd_idx].sector;
>   		for (bi=sh->dev[dd_idx].towrite;
> -		     sector < sh->dev[dd_idx].sector + STRIPE_SECTORS &&
> +		     sector < sh->dev[dd_idx].sector + conf->stripe_sectors &&
>   			     bi && bi->bi_iter.bi_sector <= sector;
> -		     bi = r5_next_bio(bi, sh->dev[dd_idx].sector)) {
> +		     bi = r5_next_bio(conf, bi, sh->dev[dd_idx].sector)) {
>   			if (bio_end_sector(bi) >= sector)
>   				sector = bio_end_sector(bi);
>   		}
> -		if (sector >= sh->dev[dd_idx].sector + STRIPE_SECTORS)
> +		if (sector >= sh->dev[dd_idx].sector + conf->stripe_sectors)
>   			if (!test_and_set_bit(R5_OVERWRITE, &sh->dev[dd_idx].flags))
>   				sh->overwrite_disks++;
>   	}
> @@ -3307,7 +3333,7 @@ static int add_stripe_bio(struct stripe_head *sh, struct bio *bi, int dd_idx,
>   		set_bit(STRIPE_BITMAP_PENDING, &sh->state);
>   		spin_unlock_irq(&sh->stripe_lock);
>   		md_bitmap_startwrite(conf->mddev->bitmap, sh->sector,
> -				     STRIPE_SECTORS, 0);
> +				     conf->stripe_sectors, 0);
>   		spin_lock_irq(&sh->stripe_lock);
>   		clear_bit(STRIPE_BITMAP_PENDING, &sh->state);
>   		if (!sh->batch_head) {
> @@ -3369,7 +3395,7 @@ handle_failed_stripe(struct r5conf *conf, struct stripe_head *sh,
>   				if (!rdev_set_badblocks(
>   					    rdev,
>   					    sh->sector,
> -					    STRIPE_SECTORS, 0))
> +					    conf->stripe_sectors, 0))
>   					md_error(conf->mddev, rdev);
>   				rdev_dec_pending(rdev, conf->mddev);
>   			}
> @@ -3389,8 +3415,9 @@ handle_failed_stripe(struct r5conf *conf, struct stripe_head *sh,
>   			wake_up(&conf->wait_for_overlap);
>   
>   		while (bi && bi->bi_iter.bi_sector <
> -			sh->dev[i].sector + STRIPE_SECTORS) {
> -			struct bio *nextbi = r5_next_bio(bi, sh->dev[i].sector);
> +			sh->dev[i].sector + conf->stripe_sectors) {
> +			struct bio *nextbi =
> +				r5_next_bio(conf, bi, sh->dev[i].sector);
>   
>   			md_write_end(conf->mddev);
>   			bio_io_error(bi);
> @@ -3398,7 +3425,7 @@ handle_failed_stripe(struct r5conf *conf, struct stripe_head *sh,
>   		}
>   		if (bitmap_end)
>   			md_bitmap_endwrite(conf->mddev->bitmap, sh->sector,
> -					   STRIPE_SECTORS, 0, 0);
> +					   conf->stripe_sectors, 0, 0);
>   		bitmap_end = 0;
>   		/* and fail all 'written' */
>   		bi = sh->dev[i].written;
> @@ -3410,8 +3437,9 @@ handle_failed_stripe(struct r5conf *conf, struct stripe_head *sh,
>   
>   		if (bi) bitmap_end = 1;
>   		while (bi && bi->bi_iter.bi_sector <
> -		       sh->dev[i].sector + STRIPE_SECTORS) {
> -			struct bio *bi2 = r5_next_bio(bi, sh->dev[i].sector);
> +		       sh->dev[i].sector + conf->stripe_sectors) {
> +			struct bio *bi2 =
> +				r5_next_bio(conf, bi, sh->dev[i].sector);
>   
>   			md_write_end(conf->mddev);
>   			bio_io_error(bi);
> @@ -3434,9 +3462,9 @@ handle_failed_stripe(struct r5conf *conf, struct stripe_head *sh,
>   			if (bi)
>   				s->to_read--;
>   			while (bi && bi->bi_iter.bi_sector <
> -			       sh->dev[i].sector + STRIPE_SECTORS) {
> -				struct bio *nextbi =
> -					r5_next_bio(bi, sh->dev[i].sector);
> +			       sh->dev[i].sector + conf->stripe_sectors) {
> +				struct bio *nextbi = r5_next_bio(conf,
> +						bi, sh->dev[i].sector);
>   
>   				bio_io_error(bi);
>   				bi = nextbi;
> @@ -3444,7 +3472,7 @@ handle_failed_stripe(struct r5conf *conf, struct stripe_head *sh,
>   		}
>   		if (bitmap_end)
>   			md_bitmap_endwrite(conf->mddev->bitmap, sh->sector,
> -					   STRIPE_SECTORS, 0, 0);
> +					   conf->stripe_sectors, 0, 0);
>   		/* If we were in the middle of a write the parity block might
>   		 * still be locked - so just clear all R5_LOCKED flags
>   		 */
> @@ -3489,14 +3517,14 @@ handle_failed_sync(struct r5conf *conf, struct stripe_head *sh,
>   			    && !test_bit(Faulty, &rdev->flags)
>   			    && !test_bit(In_sync, &rdev->flags)
>   			    && !rdev_set_badblocks(rdev, sh->sector,
> -						   STRIPE_SECTORS, 0))
> +						   conf->stripe_sectors, 0))
>   				abort = 1;
>   			rdev = rcu_dereference(conf->disks[i].replacement);
>   			if (rdev
>   			    && !test_bit(Faulty, &rdev->flags)
>   			    && !test_bit(In_sync, &rdev->flags)
>   			    && !rdev_set_badblocks(rdev, sh->sector,
> -						   STRIPE_SECTORS, 0))
> +						   conf->stripe_sectors, 0))
>   				abort = 1;
>   		}
>   		rcu_read_unlock();
> @@ -3504,7 +3532,7 @@ handle_failed_sync(struct r5conf *conf, struct stripe_head *sh,
>   			conf->recovery_disabled =
>   				conf->mddev->recovery_disabled;
>   	}
> -	md_done_sync(conf->mddev, STRIPE_SECTORS, !abort);
> +	md_done_sync(conf->mddev, conf->stripe_sectors, !abort);
>   }
>   
>   static int want_replace(struct stripe_head *sh, int disk_idx)
> @@ -3778,14 +3806,15 @@ static void handle_stripe_clean_event(struct r5conf *conf,
>   				wbi = dev->written;
>   				dev->written = NULL;
>   				while (wbi && wbi->bi_iter.bi_sector <
> -					dev->sector + STRIPE_SECTORS) {
> -					wbi2 = r5_next_bio(wbi, dev->sector);
> +					dev->sector + conf->stripe_sectors) {
> +					wbi2 = r5_next_bio(conf,
> +							wbi, dev->sector);
>   					md_write_end(conf->mddev);
>   					bio_endio(wbi);
>   					wbi = wbi2;
>   				}
>   				md_bitmap_endwrite(conf->mddev->bitmap, sh->sector,
> -						   STRIPE_SECTORS,
> +						   conf->stripe_sectors,
>   						   !test_bit(STRIPE_DEGRADED, &sh->state),
>   						   0);
>   				if (head_sh->batch_head) {
> @@ -4092,7 +4121,8 @@ static void handle_parity_checks5(struct r5conf *conf, struct stripe_head *sh,
>   			 */
>   			set_bit(STRIPE_INSYNC, &sh->state);
>   		else {
> -			atomic64_add(STRIPE_SECTORS, &conf->mddev->resync_mismatches);
> +			atomic64_add(conf->stripe_sectors,
> +					&conf->mddev->resync_mismatches);
>   			if (test_bit(MD_RECOVERY_CHECK, &conf->mddev->recovery)) {
>   				/* don't try to repair!! */
>   				set_bit(STRIPE_INSYNC, &sh->state);
> @@ -4100,7 +4130,7 @@ static void handle_parity_checks5(struct r5conf *conf, struct stripe_head *sh,
>   						    "%llu-%llu\n", mdname(conf->mddev),
>   						    (unsigned long long) sh->sector,
>   						    (unsigned long long) sh->sector +
> -						    STRIPE_SECTORS);
> +						    conf->stripe_sectors);
>   			} else {
>   				sh->check_state = check_state_compute_run;
>   				set_bit(STRIPE_COMPUTE_RUN, &sh->state);
> @@ -4257,7 +4287,8 @@ static void handle_parity_checks6(struct r5conf *conf, struct stripe_head *sh,
>   				 */
>   			}
>   		} else {
> -			atomic64_add(STRIPE_SECTORS, &conf->mddev->resync_mismatches);
> +			atomic64_add(conf->stripe_sectors,
> +					&conf->mddev->resync_mismatches);
>   			if (test_bit(MD_RECOVERY_CHECK, &conf->mddev->recovery)) {
>   				/* don't try to repair!! */
>   				set_bit(STRIPE_INSYNC, &sh->state);
> @@ -4265,7 +4296,7 @@ static void handle_parity_checks6(struct r5conf *conf, struct stripe_head *sh,
>   						    "%llu-%llu\n", mdname(conf->mddev),
>   						    (unsigned long long) sh->sector,
>   						    (unsigned long long) sh->sector +
> -						    STRIPE_SECTORS);
> +						    conf->stripe_sectors);
>   			} else {
>   				int *target = &sh->ops.target;
>   
> @@ -4336,7 +4367,8 @@ static void handle_stripe_expansion(struct r5conf *conf, struct stripe_head *sh)
>   			/* place all the copies on one channel */
>   			init_async_submit(&submit, 0, tx, NULL, NULL, NULL);
>   			tx = async_memcpy(sh2->dev[dd_idx].page,
> -					  sh->dev[i].page, 0, 0, STRIPE_SIZE,
> +					  sh->dev[i].page, 0, 0,
> +					  conf->stripe_size,
>   					  &submit);
>   
>   			set_bit(R5_Expanded, &sh2->dev[dd_idx].flags);
> @@ -4435,8 +4467,9 @@ static void analyse_stripe(struct stripe_head *sh, struct stripe_head_state *s)
>   		 */
>   		rdev = rcu_dereference(conf->disks[i].replacement);
>   		if (rdev && !test_bit(Faulty, &rdev->flags) &&
> -		    rdev->recovery_offset >= sh->sector + STRIPE_SECTORS &&
> -		    !is_badblock(rdev, sh->sector, STRIPE_SECTORS,
> +		    (rdev->recovery_offset >=
> +			 sh->sector + conf->stripe_sectors) &&
> +			!is_badblock(rdev, sh->sector, conf->stripe_sectors,
>   				 &first_bad, &bad_sectors))
>   			set_bit(R5_ReadRepl, &dev->flags);
>   		else {
> @@ -4450,8 +4483,9 @@ static void analyse_stripe(struct stripe_head *sh, struct stripe_head_state *s)
>   		if (rdev && test_bit(Faulty, &rdev->flags))
>   			rdev = NULL;
>   		if (rdev) {
> -			is_bad = is_badblock(rdev, sh->sector, STRIPE_SECTORS,
> -					     &first_bad, &bad_sectors);
> +			is_bad = is_badblock(rdev, sh->sector,
> +						conf->stripe_sectors,
> +						&first_bad, &bad_sectors);
>   			if (s->blocked_rdev == NULL
>   			    && (test_bit(Blocked, &rdev->flags)
>   				|| is_bad < 0)) {
> @@ -4477,7 +4511,8 @@ static void analyse_stripe(struct stripe_head *sh, struct stripe_head_state *s)
>   			}
>   		} else if (test_bit(In_sync, &rdev->flags))
>   			set_bit(R5_Insync, &dev->flags);
> -		else if (sh->sector + STRIPE_SECTORS <= rdev->recovery_offset)
> +		else if (sh->sector + conf->stripe_sectors <=
> +				rdev->recovery_offset)
>   			/* in sync if before recovery_offset */
>   			set_bit(R5_Insync, &dev->flags);
>   		else if (test_bit(R5_UPTODATE, &dev->flags) &&
> @@ -4920,7 +4955,7 @@ static void handle_stripe(struct stripe_head *sh)
>   	if ((s.syncing || s.replacing) && s.locked == 0 &&
>   	    !test_bit(STRIPE_COMPUTE_RUN, &sh->state) &&
>   	    test_bit(STRIPE_INSYNC, &sh->state)) {
> -		md_done_sync(conf->mddev, STRIPE_SECTORS, 1);
> +		md_done_sync(conf->mddev, conf->stripe_sectors, 1);
>   		clear_bit(STRIPE_SYNCING, &sh->state);
>   		if (test_and_clear_bit(R5_Overlap, &sh->dev[sh->pd_idx].flags))
>   			wake_up(&conf->wait_for_overlap);
> @@ -4988,7 +5023,7 @@ static void handle_stripe(struct stripe_head *sh)
>   		clear_bit(STRIPE_EXPAND_READY, &sh->state);
>   		atomic_dec(&conf->reshape_stripes);
>   		wake_up(&conf->wait_for_overlap);
> -		md_done_sync(conf->mddev, STRIPE_SECTORS, 1);
> +		md_done_sync(conf->mddev, conf->stripe_sectors, 1);
>   	}
>   
>   	if (s.expanding && s.locked == 0 &&
> @@ -5018,14 +5053,14 @@ static void handle_stripe(struct stripe_head *sh)
>   				/* We own a safe reference to the rdev */
>   				rdev = conf->disks[i].rdev;
>   				if (!rdev_set_badblocks(rdev, sh->sector,
> -							STRIPE_SECTORS, 0))
> +						conf->stripe_sectors, 0))
>   					md_error(conf->mddev, rdev);
>   				rdev_dec_pending(rdev, conf->mddev);
>   			}
>   			if (test_and_clear_bit(R5_MadeGood, &dev->flags)) {
>   				rdev = conf->disks[i].rdev;
>   				rdev_clear_badblocks(rdev, sh->sector,
> -						     STRIPE_SECTORS, 0);
> +						     conf->stripe_sectors, 0);
>   				rdev_dec_pending(rdev, conf->mddev);
>   			}
>   			if (test_and_clear_bit(R5_MadeGoodRepl, &dev->flags)) {
> @@ -5034,7 +5069,7 @@ static void handle_stripe(struct stripe_head *sh)
>   					/* rdev have been moved down */
>   					rdev = conf->disks[i].rdev;
>   				rdev_clear_badblocks(rdev, sh->sector,
> -						     STRIPE_SECTORS, 0);
> +						     conf->stripe_sectors, 0);
>   				rdev_dec_pending(rdev, conf->mddev);
>   			}
>   		}
> @@ -5498,7 +5533,8 @@ static void make_discard_request(struct mddev *mddev, struct bio *bi)
>   		/* Skip discard while reshape is happening */
>   		return;
>   
> -	logical_sector = bi->bi_iter.bi_sector & ~((sector_t)STRIPE_SECTORS-1);
> +	logical_sector = bi->bi_iter.bi_sector &
> +			~((sector_t)conf->stripe_sectors-1);
>   	last_sector = bio_end_sector(bi);
>   
>   	bi->bi_next = NULL;
> @@ -5513,7 +5549,7 @@ static void make_discard_request(struct mddev *mddev, struct bio *bi)
>   	last_sector *= conf->chunk_sectors;
>   
>   	for (; logical_sector < last_sector;
> -	     logical_sector += STRIPE_SECTORS) {
> +	     logical_sector += conf->stripe_sectors) {
>   		DEFINE_WAIT(w);
>   		int d;
>   	again:
> @@ -5558,7 +5594,7 @@ static void make_discard_request(struct mddev *mddev, struct bio *bi)
>   			     d++)
>   				md_bitmap_startwrite(mddev->bitmap,
>   						     sh->sector,
> -						     STRIPE_SECTORS,
> +						     conf->stripe_sectors,
>   						     0);
>   			sh->bm_seq = conf->seq_flush + 1;
>   			set_bit(STRIPE_BIT_DELAY, &sh->state);
> @@ -5623,12 +5659,14 @@ static bool raid5_make_request(struct mddev *mddev, struct bio * bi)
>   		return true;
>   	}
>   
> -	logical_sector = bi->bi_iter.bi_sector & ~((sector_t)STRIPE_SECTORS-1);
> +	logical_sector = bi->bi_iter.bi_sector &
> +			~((sector_t)conf->stripe_sectors-1);
>   	last_sector = bio_end_sector(bi);
>   	bi->bi_next = NULL;
>   
>   	prepare_to_wait(&conf->wait_for_overlap, &w, TASK_UNINTERRUPTIBLE);
> -	for (;logical_sector < last_sector; logical_sector += STRIPE_SECTORS) {
> +	for (; logical_sector < last_sector;
> +			logical_sector += conf->stripe_sectors) {
>   		int previous;
>   		int seq;
>   
> @@ -5910,7 +5948,7 @@ static sector_t reshape_request(struct mddev *mddev, sector_t sector_nr, int *sk
>   	}
>   
>   	INIT_LIST_HEAD(&stripes);
> -	for (i = 0; i < reshape_sectors; i += STRIPE_SECTORS) {
> +	for (i = 0; i < reshape_sectors; i += conf->stripe_sectors) {
>   		int j;
>   		int skipped_disk = 0;
>   		sh = raid5_get_active_stripe(conf, stripe_addr+i, 0, 0, 1);
> @@ -5931,7 +5969,8 @@ static sector_t reshape_request(struct mddev *mddev, sector_t sector_nr, int *sk
>   				skipped_disk = 1;
>   				continue;
>   			}
> -			memset(page_address(sh->dev[j].page), 0, STRIPE_SIZE);
> +			memset(page_address(sh->dev[j].page), 0,
> +					conf->stripe_size);
>   			set_bit(R5_Expanded, &sh->dev[j].flags);
>   			set_bit(R5_UPTODATE, &sh->dev[j].flags);
>   		}
> @@ -5966,7 +6005,7 @@ static sector_t reshape_request(struct mddev *mddev, sector_t sector_nr, int *sk
>   		set_bit(STRIPE_EXPAND_SOURCE, &sh->state);
>   		set_bit(STRIPE_HANDLE, &sh->state);
>   		raid5_release_stripe(sh);
> -		first_sector += STRIPE_SECTORS;
> +		first_sector += conf->stripe_sectors;
>   	}
>   	/* Now that the sources are clearly marked, we can release
>   	 * the destination stripes
> @@ -6072,11 +6111,12 @@ static inline sector_t raid5_sync_request(struct mddev *mddev, sector_t sector_n
>   	if (!test_bit(MD_RECOVERY_REQUESTED, &mddev->recovery) &&
>   	    !conf->fullsync &&
>   	    !md_bitmap_start_sync(mddev->bitmap, sector_nr, &sync_blocks, 1) &&
> -	    sync_blocks >= STRIPE_SECTORS) {
> +	    sync_blocks >= conf->stripe_sectors) {
>   		/* we can skip this block, and probably more */
> -		sync_blocks /= STRIPE_SECTORS;
> +		sync_blocks /= conf->stripe_sectors;
>   		*skipped = 1;
> -		return sync_blocks * STRIPE_SECTORS; /* keep things rounded to whole stripes */
> +		/* keep things rounded to whole stripes */
> +		return sync_blocks * conf->stripe_sectors;
>   	}
>   
>   	md_bitmap_cond_end_sync(mddev->bitmap, sector_nr, false);
> @@ -6109,7 +6149,7 @@ static inline sector_t raid5_sync_request(struct mddev *mddev, sector_t sector_n
>   
>   	raid5_release_stripe(sh);
>   
> -	return STRIPE_SECTORS;
> +	return conf->stripe_sectors;
>   }
>   
>   static int  retry_aligned_read(struct r5conf *conf, struct bio *raid_bio,
> @@ -6132,14 +6172,14 @@ static int  retry_aligned_read(struct r5conf *conf, struct bio *raid_bio,
>   	int handled = 0;
>   
>   	logical_sector = raid_bio->bi_iter.bi_sector &
> -		~((sector_t)STRIPE_SECTORS-1);
> +		~((sector_t)conf->stripe_sectors-1);
>   	sector = raid5_compute_sector(conf, logical_sector,
>   				      0, &dd_idx, NULL);
>   	last_sector = bio_end_sector(raid_bio);
>   
>   	for (; logical_sector < last_sector;
> -	     logical_sector += STRIPE_SECTORS,
> -		     sector += STRIPE_SECTORS,
> +	     logical_sector += conf->stripe_sectors,
> +		     sector += conf->stripe_sectors,
>   		     scnt++) {
>   
>   		if (scnt < offset)
> @@ -6759,7 +6799,7 @@ static int alloc_scratch_buffer(struct r5conf *conf, struct raid5_percpu *percpu
>   			       conf->previous_raid_disks),
>   			   max(conf->chunk_sectors,
>   			       conf->prev_chunk_sectors)
> -			   / STRIPE_SECTORS,
> +			   / conf->stripe_sectors,
>   			   GFP_KERNEL)) {
>   		free_scratch_buffer(conf, percpu);
>   		return -ENOMEM;
> @@ -6912,6 +6952,11 @@ static struct r5conf *setup_conf(struct mddev *mddev)
>   	conf = kzalloc(sizeof(struct r5conf), GFP_KERNEL);
>   	if (conf == NULL)
>   		goto abort;
> +
> +	conf->stripe_size = PAGE_SIZE;
> +	conf->stripe_shift = PAGE_SHIFT - 9;
> +	conf->stripe_sectors = conf->stripe_size >> 9;
> +
>   	INIT_LIST_HEAD(&conf->free_list);
>   	INIT_LIST_HEAD(&conf->pending_list);
>   	conf->pending_data = kcalloc(PENDING_IO_MAX,
> @@ -7063,8 +7108,9 @@ static struct r5conf *setup_conf(struct mddev *mddev)
>   	conf->min_nr_stripes = NR_STRIPES;
>   	if (mddev->reshape_position != MaxSector) {
>   		int stripes = max_t(int,
> -			((mddev->chunk_sectors << 9) / STRIPE_SIZE) * 4,
> -			((mddev->new_chunk_sectors << 9) / STRIPE_SIZE) * 4);
> +			((mddev->chunk_sectors << 9) / conf->stripe_size) * 4,
> +			((mddev->new_chunk_sectors << 9) /
> +				conf->stripe_size) * 4);
>   		conf->min_nr_stripes = max(NR_STRIPES, stripes);
>   		if (conf->min_nr_stripes != NR_STRIPES)
>   			pr_info("md/raid:%s: force stripe size %d for reshape\n",
> @@ -7795,14 +7841,14 @@ static int check_stripe_cache(struct mddev *mddev)
>   	 * stripe_heads first.
>   	 */
>   	struct r5conf *conf = mddev->private;
> -	if (((mddev->chunk_sectors << 9) / STRIPE_SIZE) * 4
> +	if (((mddev->chunk_sectors << 9) / conf->stripe_size) * 4
>   	    > conf->min_nr_stripes ||
> -	    ((mddev->new_chunk_sectors << 9) / STRIPE_SIZE) * 4
> +	    ((mddev->new_chunk_sectors << 9) / conf->stripe_size) * 4
>   	    > conf->min_nr_stripes) {
>   		pr_warn("md/raid:%s: reshape: not enough stripes.  Needed %lu\n",
>   			mdname(mddev),
>   			(unsigned long )((max(mddev->chunk_sectors, mddev->new_chunk_sectors) << 9)
> -			 / STRIPE_SIZE)*4);
> +			 / conf->stripe_size)*4);
>   		return 0;
>   	}
>   	return 1;
> @@ -8121,6 +8167,7 @@ static void *raid5_takeover_raid1(struct mddev *mddev)
>   {
>   	int chunksect;
>   	void *ret;
> +	struct r5conf *conf = mddev->private;
>   
>   	if (mddev->raid_disks != 2 ||
>   	    mddev->degraded > 1)
> @@ -8134,7 +8181,7 @@ static void *raid5_takeover_raid1(struct mddev *mddev)
>   	while (chunksect && (mddev->array_sectors & (chunksect-1)))
>   		chunksect >>= 1;
>   
> -	if ((chunksect<<9) < STRIPE_SIZE)
> +	if ((chunksect<<9) < conf->stripe_size)
>   		/* array size does not allow a suitable chunk size */
>   		return ERR_PTR(-EINVAL);
>   
> diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
> index f90e0704bed9..e36cf71e8465 100644
> --- a/drivers/md/raid5.h
> +++ b/drivers/md/raid5.h
> @@ -472,32 +472,12 @@ struct disk_info {
>    */
>   
>   #define NR_STRIPES		256
> -#define STRIPE_SIZE		PAGE_SIZE
> -#define STRIPE_SHIFT		(PAGE_SHIFT - 9)
> -#define STRIPE_SECTORS		(STRIPE_SIZE>>9)
>   #define	IO_THRESHOLD		1
>   #define BYPASS_THRESHOLD	1
>   #define NR_HASH			(PAGE_SIZE / sizeof(struct hlist_head))
>   #define HASH_MASK		(NR_HASH - 1)
>   #define MAX_STRIPE_BATCH	8
>   
> -/* bio's attached to a stripe+device for I/O are linked together in bi_sector
> - * order without overlap.  There may be several bio's per stripe+device, and
> - * a bio could span several devices.
> - * When walking this list for a particular stripe+device, we must never proceed
> - * beyond a bio that extends past this device, as the next bio might no longer
> - * be valid.
> - * This function is used to determine the 'next' bio in the list, given the
> - * sector of the current stripe+device
> - */
> -static inline struct bio *r5_next_bio(struct bio *bio, sector_t sector)
> -{
> -	if (bio_end_sector(bio) < sector + STRIPE_SECTORS)
> -		return bio->bi_next;
> -	else
> -		return NULL;
> -}
> -
>   /* NOTE NR_STRIPE_HASH_LOCKS must remain below 64.
>    * This is because we sometimes take all the spinlocks
>    * and creating that much locking depth can cause
> @@ -574,6 +554,9 @@ struct r5conf {
>   	int			raid_disks;
>   	int			max_nr_stripes;
>   	int			min_nr_stripes;
> +	unsigned int	stripe_size;
> +	unsigned int	stripe_shift;
> +	unsigned int	stripe_sectors;
>   
>   	/* reshape_progress is the leading edge of a 'reshape'
>   	 * It has value MaxSector when no reshape is happening
> @@ -752,6 +735,24 @@ static inline int algorithm_is_DDF(int layout)
>   	return layout >= 8 && layout <= 10;
>   }
>   
> +/* bio's attached to a stripe+device for I/O are linked together in bi_sector
> + * order without overlap.  There may be several bio's per stripe+device, and
> + * a bio could span several devices.
> + * When walking this list for a particular stripe+device, we must never proceed
> + * beyond a bio that extends past this device, as the next bio might no longer
> + * be valid.
> + * This function is used to determine the 'next' bio in the list, given the
> + * sector of the current stripe+device
> + */
> +static inline struct bio *
> +r5_next_bio(struct r5conf *conf, struct bio *bio, sector_t sector)
> +{
> +	if (bio_end_sector(bio) < sector + conf->stripe_sectors)
> +		return bio->bi_next;
> +	else
> +		return NULL;
> +}
> +
>   extern void md_raid5_kick_device(struct r5conf *conf);
>   extern int raid5_set_cache_size(struct mddev *mddev, int size);
>   extern sector_t raid5_compute_blocknr(struct stripe_head *sh, int i, int previous);
