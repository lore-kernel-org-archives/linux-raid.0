From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH] raid5-ppl: PPL support for disks with write-back cache
 enabled
Date: Fri, 22 Dec 2017 10:09:13 -0800
Message-ID: <20171222180913.ky6wmxjnswjs4a4s@kernel.org>
References: <1513604700-1826-1-git-send-email-tomasz.majchrzak@intel.com>
 <20171221193038.7i7cds7ddygsbw5q@kernel.org>
 <20171222110651.GA15828@proton.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171222110651.GA15828@proton.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Dec 22, 2017 at 12:06:51PM +0100, Tomasz Majchrzak wrote:
> On Thu, Dec 21, 2017 at 11:30:38AM -0800, Shaohua Li wrote:
> > On Mon, Dec 18, 2017 at 02:45:00PM +0100, Tomasz Majchrzak wrote:
> > > In order to provide data consistency with PPL for disks with write-back
> > > cache enabled all data has to be flushed to disks before next PPL
> > > entry.
> > > 
> > > With write-back cache disabled next PPL entry is submitted when data write
> > > for current one completes. Data flush defers next log submission so trigger
> > > it when there are no stripes for handling found.
> > > 
> > > As PPL assures all data is flushed to disk at request completion, just
> > > acknowledge flush request when PPL is enabled.
> > > 
> > > Signed-off-by: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
> > > ---
> > >  Documentation/md/raid5-ppl.txt |   4 -
> > >  drivers/md/md.c                |   5 +-
> > >  drivers/md/md.h                |   1 +
> > >  drivers/md/raid5-cache.c       |   5 --
> > >  drivers/md/raid5-log.h         |  29 +++++++
> > >  drivers/md/raid5-ppl.c         | 166 ++++++++++++++++++++++++++++++++++++++---
> > >  drivers/md/raid5.c             |   6 +-
> > >  7 files changed, 190 insertions(+), 26 deletions(-)
> > > 
> > > diff --git a/Documentation/md/raid5-ppl.txt b/Documentation/md/raid5-ppl.txt
> > > index 127072b..2df5cb1 100644
> > > --- a/Documentation/md/raid5-ppl.txt
> > > +++ b/Documentation/md/raid5-ppl.txt
> > > @@ -38,7 +38,3 @@ case the behavior is the same as in plain raid5.
> > >  
> > >  PPL is available for md version-1 metadata and external (specifically IMSM)
> > >  metadata arrays. It can be enabled using mdadm option --consistency-policy=ppl.
> > > -
> > > -Currently, volatile write-back cache should be disabled on all member drives
> > > -when using PPL. Otherwise it cannot guarantee consistency in case of power
> > > -failure.
> > > diff --git a/drivers/md/md.c b/drivers/md/md.c
> > > index a71adb3..1b5c9af2 100644
> > > --- a/drivers/md/md.c
> > > +++ b/drivers/md/md.c
> > > @@ -711,7 +711,7 @@ static struct md_rdev *find_rdev(struct mddev *mddev, dev_t dev)
> > >  	return NULL;
> > >  }
> > >  
> > > -static struct md_rdev *find_rdev_rcu(struct mddev *mddev, dev_t dev)
> > > +struct md_rdev *md_find_rdev_rcu(struct mddev *mddev, dev_t dev)
> > >  {
> > >  	struct md_rdev *rdev;
> > >  
> > > @@ -721,6 +721,7 @@ static struct md_rdev *find_rdev_rcu(struct mddev *mddev, dev_t dev)
> > >  
> > >  	return NULL;
> > >  }
> > > +EXPORT_SYMBOL_GPL(md_find_rdev_rcu);
> > >  
> > >  static struct md_personality *find_pers(int level, char *clevel)
> > >  {
> > > @@ -7010,7 +7011,7 @@ static int set_disk_faulty(struct mddev *mddev, dev_t dev)
> > >  		return -ENODEV;
> > >  
> > >  	rcu_read_lock();
> > > -	rdev = find_rdev_rcu(mddev, dev);
> > > +	rdev = md_find_rdev_rcu(mddev, dev);
> > >  	if (!rdev)
> > >  		err =  -ENODEV;
> > >  	else {
> > > diff --git a/drivers/md/md.h b/drivers/md/md.h
> > > index be8f72a..58cd20a 100644
> > > --- a/drivers/md/md.h
> > > +++ b/drivers/md/md.h
> > > @@ -710,6 +710,7 @@ extern struct bio *bio_alloc_mddev(gfp_t gfp_mask, int nr_iovecs,
> > >  extern void md_update_sb(struct mddev *mddev, int force);
> > >  extern void md_kick_rdev_from_array(struct md_rdev * rdev);
> > >  struct md_rdev *md_find_rdev_nr_rcu(struct mddev *mddev, int nr);
> > > +struct md_rdev *md_find_rdev_rcu(struct mddev *mddev, dev_t dev);
> > >  
> > >  static inline void rdev_dec_pending(struct md_rdev *rdev, struct mddev *mddev)
> > >  {
> > > diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
> > > index f259a5f..3b1f3d6 100644
> > > --- a/drivers/md/raid5-cache.c
> > > +++ b/drivers/md/raid5-cache.c
> > > @@ -1111,9 +1111,6 @@ void r5l_write_stripe_run(struct r5l_log *log)
> > >  
> > >  int r5l_handle_flush_request(struct r5l_log *log, struct bio *bio)
> > >  {
> > > -	if (!log)
> > > -		return -ENODEV;
> > > -
> > >  	if (log->r5c_journal_mode == R5C_JOURNAL_MODE_WRITE_THROUGH) {
> > >  		/*
> > >  		 * in write through (journal only)
> > > @@ -1592,8 +1589,6 @@ void r5l_wake_reclaim(struct r5l_log *log, sector_t space)
> > >  void r5l_quiesce(struct r5l_log *log, int quiesce)
> > >  {
> > >  	struct mddev *mddev;
> > > -	if (!log)
> > > -		return;
> > >  
> > >  	if (quiesce) {
> > >  		/* make sure r5l_write_super_and_discard_space exits */
> > > diff --git a/drivers/md/raid5-log.h b/drivers/md/raid5-log.h
> > > index 3860041..d5b3965 100644
> > > --- a/drivers/md/raid5-log.h
> > > +++ b/drivers/md/raid5-log.h
> > > @@ -43,6 +43,7 @@ extern void r5c_update_on_rdev_error(struct mddev *mddev,
> > >  extern void ppl_write_stripe_run(struct r5conf *conf);
> > >  extern void ppl_stripe_write_finished(struct stripe_head *sh);
> > >  extern int ppl_modify_log(struct r5conf *conf, struct md_rdev *rdev, bool add);
> > > +extern void ppl_quiesce(struct r5conf *conf, int quiesce);
> > >  
> > >  static inline bool raid5_has_ppl(struct r5conf *conf)
> > >  {
> > > @@ -88,6 +89,34 @@ static inline void log_write_stripe_run(struct r5conf *conf)
> > >  		ppl_write_stripe_run(conf);
> > >  }
> > >  
> > > +static inline void log_flush_stripe_to_raid(struct r5conf *conf)
> > > +{
> > > +	if (conf->log)
> > > +		r5l_flush_stripe_to_raid(conf->log);
> > > +	else if (raid5_has_ppl(conf))
> > > +		ppl_write_stripe_run(conf);
> > > +}
> > > +
> > > +static inline int log_handle_flush_request(struct r5conf *conf, struct bio *bio)
> > > +{
> > > +	int ret = -ENODEV;
> > 
> > make ret = 0, and you can delete the ppl branch below
> 
> I don't think so. It would "acknowledge" no need for flush when PPL if off.

Ok, I missed that. 
> > > +
> > > +	if (conf->log)
> > > +		ret = r5l_handle_flush_request(conf->log, bio);
> > > +	else if (raid5_has_ppl(conf))
> > > +		ret = 0;
> > > +
> > > +	return ret;
> > > +}
> > > +
> > > +static inline void log_quiesce(struct r5conf *conf, int quiesce)
> > > +{
> > > +	if (conf->log)
> > > +		r5l_quiesce(conf->log, quiesce);
> > > +	else if (raid5_has_ppl(conf))
> > > +		ppl_quiesce(conf, quiesce);
> > > +}
> > > +
> > >  static inline void log_exit(struct r5conf *conf)
> > >  {
> > >  	if (conf->log)
> > > diff --git a/drivers/md/raid5-ppl.c b/drivers/md/raid5-ppl.c
> > > index 628c0bf..50fc2ca 100644
> > > --- a/drivers/md/raid5-ppl.c
> > > +++ b/drivers/md/raid5-ppl.c
> > > @@ -85,6 +85,9 @@
> > >   * (for a single member disk). New io_units are added to the end of the list
> > >   * and the first io_unit is submitted, if it is not submitted already.
> > >   * The current io_unit accepting new stripes is always at the end of the list.
> > > + *
> > > + * If write-back cache is enabled for any of the disks in the array, its data
> > > + * must be flushed before next io_unit is submitted.
> > >   */
> > >  
> > >  #define PPL_SPACE_SIZE (128 * 1024)
> > > @@ -104,6 +107,7 @@ struct ppl_conf {
> > >  	struct kmem_cache *io_kc;
> > >  	mempool_t *io_pool;
> > >  	struct bio_set *bs;
> > > +	struct bio_set *flush_bs;
> > >  
> > >  	/* used only for recovery */
> > >  	int recovered_entries;
> > > @@ -128,6 +132,8 @@ struct ppl_log {
> > >  	sector_t next_io_sector;
> > >  	unsigned int entry_space;
> > >  	bool use_multippl;
> > > +	bool wb_cache_on;
> > > +	unsigned long disk_flush_bitmap;
> > >  };
> > >  
> > >  #define PPL_IO_INLINE_BVECS 32
> > > @@ -145,6 +151,7 @@ struct ppl_io_unit {
> > >  
> > >  	struct list_head stripe_list;	/* stripes added to the io_unit */
> > >  	atomic_t pending_stripes;	/* how many stripes not written to raid */
> > > +	atomic_t pending_flushes;	/* how many disk flushes are in progress */
> > >  
> > >  	bool submitted;			/* true if write to log started */
> > >  
> > > @@ -249,6 +256,7 @@ static struct ppl_io_unit *ppl_new_iounit(struct ppl_log *log,
> > >  	INIT_LIST_HEAD(&io->log_sibling);
> > >  	INIT_LIST_HEAD(&io->stripe_list);
> > >  	atomic_set(&io->pending_stripes, 0);
> > > +	atomic_set(&io->pending_flushes, 0);
> > >  	bio_init(&io->bio, io->biovec, PPL_IO_INLINE_BVECS);
> > >  
> > >  	pplhdr = page_address(io->header_page);
> > > @@ -475,7 +483,18 @@ static void ppl_submit_iounit(struct ppl_io_unit *io)
> > >  	if (log->use_multippl)
> > >  		log->next_io_sector += (PPL_HEADER_SIZE + io->pp_size) >> 9;
> > >  
> > > +	WARN_ON(log->disk_flush_bitmap != 0);
> > > +
> > >  	list_for_each_entry(sh, &io->stripe_list, log_list) {
> > > +		for (i = 0; i < sh->disks; i++) {
> > > +			struct r5dev *dev = &sh->dev[i];
> > > +
> > > +			if ((ppl_conf->child_logs[i].wb_cache_on) &&
> > > +			    (test_bit(R5_Wantwrite, &dev->flags))) {
> > > +				set_bit(i, &log->disk_flush_bitmap);
> > > +			}
> > > +		}
> > > +
> > >  		/* entries for full stripe writes have no partial parity */
> > >  		if (test_bit(STRIPE_FULL_WRITE, &sh->state))
> > >  			continue;
> > > @@ -540,6 +559,7 @@ static void ppl_io_unit_finished(struct ppl_io_unit *io)
> > >  {
> > >  	struct ppl_log *log = io->log;
> > >  	struct ppl_conf *ppl_conf = log->ppl_conf;
> > > +	struct r5conf *conf = ppl_conf->mddev->private;
> > >  	unsigned long flags;
> > >  
> > >  	pr_debug("%s: seq: %llu\n", __func__, io->seq);
> > > @@ -565,6 +585,111 @@ static void ppl_io_unit_finished(struct ppl_io_unit *io)
> > >  	spin_unlock(&ppl_conf->no_mem_stripes_lock);
> > >  
> > >  	local_irq_restore(flags);
> > > +
> > > +	wake_up(&conf->wait_for_quiescent);
> > > +}
> > > +
> > > +static void ppl_flush_endio(struct bio *bio)
> > > +{
> > > +	struct ppl_io_unit *io = bio->bi_private;
> > > +	struct ppl_log *log = io->log;
> > > +	struct ppl_conf *ppl_conf = log->ppl_conf;
> > > +	struct r5conf *conf = ppl_conf->mddev->private;
> > > +	char b[BDEVNAME_SIZE];
> > > +
> > > +	pr_debug("%s: dev: %s\n", __func__, bio_devname(bio, b));
> > > +
> > > +	if (bio->bi_status) {
> > > +		struct md_rdev *rdev;
> > > +
> > > +		rcu_read_lock();
> > > +		rdev = md_find_rdev_rcu(conf->mddev, bio_dev(bio));
> > > +		if (rdev)
> > > +			md_error(rdev->mddev, rdev);
> > > +		rcu_read_unlock();
> > 
> > Why check the rdev here? I think we already take a refcount in write path for
> > stripe handling, so the rdev doesn't disappear.
> >
> 
> I believe it takes place after write path is already finished. Flush
> requests are submitted at the end of the write path and they happen
> asynchronously. We cannot assume rdev still exists at this point. I could
> increase refcount before submitting flush but if device is gone, there is no
> need to fail it again here.

I need to double check, but our practice is to hold the lock and increase the
refcount, so later we don't need to worry if the device is gone. If you don't
do this way, you must carefully review the code.

> > > +	}
> > > +
> > > +	bio_put(bio);
> > > +
> > > +	if (atomic_dec_and_test(&io->pending_flushes)) {
> > > +		ppl_io_unit_finished(io);
> > > +		md_wakeup_thread(conf->mddev->thread);
> > > +	}
> > > +}
> > > +
> > > +static void ppl_do_flush(struct ppl_io_unit *io)
> > > +{
> > > +	struct ppl_log *log = io->log;
> > > +	struct ppl_conf *ppl_conf = log->ppl_conf;
> > > +	struct r5conf *conf = ppl_conf->mddev->private;
> > > +	int raid_disks = conf->raid_disks;
> > > +	int flushed_disks = 0;
> > > +	int i;
> > > +
> > > +	atomic_set(&io->pending_flushes, raid_disks);
> > > +
> > > +	for_each_set_bit(i, &log->disk_flush_bitmap, raid_disks) {
> > 
> > can you add comments explaining why accessing disk_flush_bitmap is safe without
> > lock?
> 
> Modifying the bitmap is safe because it takes place under log io_mutex. The
> bitmap is only read after PPL io unit is submitted  (and it's not modified
> past this point). I'll update commit message to mention it.
> 
> > > +		struct md_rdev *rdev;
> > > +
> > > +		rcu_read_lock();
> > > +		rdev = rcu_dereference(conf->disks[i].rdev);
> > > +		if (rdev && test_bit(Faulty, &rdev->flags))
> > > +			rdev = NULL;
> > > +		rcu_read_unlock();
> > > +		if (rdev) {
> > 
> > Same here. And if we don't take a refcount, this code isn't safe too, because
> > the rdev can disappear after the rcu lock.
> 
> Well, I have tried to remove rdev check for NULL and my test crashes in the
> first iteration. Are you sure rdev is still guaranteed to exist here?
> 
> I agree that using rdev after rcu unlock is not safe. I can re-work it to
> get block device with lock on and just use block device after unlock. Are
> you ok with it?

Sounds good.
 
> > > +			struct bio *bio;
> > > +			char b[BDEVNAME_SIZE];
> > > +
> > > +			bio = bio_alloc_bioset(GFP_NOIO, 0, ppl_conf->flush_bs);
> > > +			bio_set_dev(bio, rdev->bdev);
> > > +			bio->bi_private = io;
> > > +			bio->bi_opf = REQ_OP_WRITE | REQ_PREFLUSH;
> > > +			bio->bi_end_io = ppl_flush_endio;
> > > +
> > > +			pr_debug("%s: dev: %s\n", __func__,
> > > +				 bio_devname(bio, b));
> > > +
> > > +			submit_bio(bio);
> > > +			flushed_disks++;
> > > +		}
> > > +	}
> > > +
> > > +	log->disk_flush_bitmap = 0;
> > > +
> > > +	for (i = flushed_disks ; i < raid_disks; i++) {
> > > +		if (atomic_dec_and_test(&io->pending_flushes))
> > > +			ppl_io_unit_finished(io);
> > > +	}
> > > +}
> > > +
> > > +static inline bool ppl_no_io_unit_submitted(struct r5conf *conf,
> > > +					    struct ppl_log *log)
> > > +{
> > > +	struct ppl_io_unit *io;
> > > +
> > > +	io = list_first_entry_or_null(&log->io_list, struct ppl_io_unit,
> > > +				      log_sibling);
> > > +
> > > +	return !io || !io->submitted;
> > > +}
> > > +
> > > +void ppl_quiesce(struct r5conf *conf, int quiesce)
> > > +{
> > > +	struct ppl_conf *ppl_conf = conf->log_private;
> > > +	int i;
> > > +
> > > +	if (quiesce) {
> > > +		for (i = 0; i < ppl_conf->count; i++) {
> > > +			struct ppl_log *log = &ppl_conf->child_logs[i];
> > > +
> > > +			spin_lock_irq(&log->io_list_lock);
> > > +			wait_event_lock_irq(conf->wait_for_quiescent,
> > > +					    ppl_no_io_unit_submitted(conf, log),
> > > +					    log->io_list_lock);
> > > +			spin_unlock_irq(&log->io_list_lock);
> > > +		}
> > > +	}
> > >  }
> > >  
> > >  void ppl_stripe_write_finished(struct stripe_head *sh)
> > > @@ -574,8 +699,12 @@ void ppl_stripe_write_finished(struct stripe_head *sh)
> > >  	io = sh->ppl_io;
> > >  	sh->ppl_io = NULL;
> > >  
> > > -	if (io && atomic_dec_and_test(&io->pending_stripes))
> > > -		ppl_io_unit_finished(io);
> > > +	if (io && atomic_dec_and_test(&io->pending_stripes)) {
> > > +		if (io->log->disk_flush_bitmap)
> > > +			ppl_do_flush(io);
> > > +		else
> > > +			ppl_io_unit_finished(io);
> > > +	}
> > >  }
> > >  
> > >  static void ppl_xor(int size, struct page *page1, struct page *page2)
> > > @@ -1108,6 +1237,8 @@ static void __ppl_exit_log(struct ppl_conf *ppl_conf)
> > >  
> > >  	if (ppl_conf->bs)
> > >  		bioset_free(ppl_conf->bs);
> > > +	if (ppl_conf->flush_bs)
> > > +		bioset_free(ppl_conf->flush_bs);
> > >  	mempool_destroy(ppl_conf->io_pool);
> > >  	kmem_cache_destroy(ppl_conf->io_kc);
> > >  
> > > @@ -1173,6 +1304,8 @@ static int ppl_validate_rdev(struct md_rdev *rdev)
> > >  
> > >  static void ppl_init_child_log(struct ppl_log *log, struct md_rdev *rdev)
> > >  {
> > > +	struct request_queue *q;
> > > +
> > >  	if ((rdev->ppl.size << 9) >= (PPL_SPACE_SIZE +
> > >  				      PPL_HEADER_SIZE) * 2) {
> > >  		log->use_multippl = true;
> > > @@ -1185,6 +1318,10 @@ static void ppl_init_child_log(struct ppl_log *log, struct md_rdev *rdev)
> > >  				   PPL_HEADER_SIZE;
> > >  	}
> > >  	log->next_io_sector = rdev->ppl.sector;
> > > +
> > > +	q = bdev_get_queue(rdev->bdev);
> > > +	if (test_bit(QUEUE_FLAG_WC, &q->queue_flags))
> > > +		log->wb_cache_on = true;
> > >  }
> > >  
> > >  int ppl_init_log(struct r5conf *conf)
> > > @@ -1192,8 +1329,8 @@ int ppl_init_log(struct r5conf *conf)
> > >  	struct ppl_conf *ppl_conf;
> > >  	struct mddev *mddev = conf->mddev;
> > >  	int ret = 0;
> > > +	int max_disks;
> > >  	int i;
> > > -	bool need_cache_flush = false;
> > >  
> > >  	pr_debug("md/raid:%s: enabling distributed Partial Parity Log\n",
> > >  		 mdname(conf->mddev));
> > > @@ -1219,6 +1356,14 @@ int ppl_init_log(struct r5conf *conf)
> > >  		return -EINVAL;
> > >  	}
> > >  
> > > +	max_disks = FIELD_SIZEOF(struct ppl_log, disk_flush_bitmap) *
> > > +		BITS_PER_BYTE;
> > > +	if (conf->raid_disks > max_disks) {
> > > +		pr_warn("md/raid:%s PPL doesn't support over %d disks in the array\n",
> > > +			mdname(mddev), max_disks);
> > > +		return -EINVAL;
> > > +	}
> > 
> > This looks like an unnecessary limitation, can we just use bitmap API?
> > 
> 
> Actually I had it implemented this way initially but I found it
> overcomplicated. ppl_log forms an array which is referenced by index in
> few places around the code. Variable-length bitmap would part of it so
> standard array indexing cannot be used anymore.
> 
> RAID5 arrays with so many disks are not common due to high risk of multiple
> disks failure. I thought such restriction is not a real life limitation.
> Would you be ok with just explaining it this way in commit message or do you
> prefer me to resend the patch without the limitation?

If it's hard to implement, I'm ok with limitation. Please describe it in the
log and the documentation file.

Thanks,
Shaohua
