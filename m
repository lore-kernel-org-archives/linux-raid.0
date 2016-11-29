From: Shaohua Li <shli@kernel.org>
Subject: Re: [RFC PATCH 1/2] RAID1: a new I/O barrier implementation to
 remove resync window
Date: Tue, 29 Nov 2016 11:29:52 -0800
Message-ID: <20161129192952.woyx55w33ytry73a@kernel.org>
References: <1479765241-15528-1-git-send-email-colyli@suse.de>
 <20161122213541.btgw4cpoly5j4jpc@kernel.org>
 <c83399e6-2fbc-9b5d-70b5-0000a24f0653@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <c83399e6-2fbc-9b5d-70b5-0000a24f0653@suse.de>
Sender: linux-raid-owner@vger.kernel.org
To: Coly Li <colyli@suse.de>
Cc: linux-raid@vger.kernel.org, Shaohua Li <shli@fb.com>, Neil Brown <neilb@suse.de>, Johannes Thumshirn <jthumshirn@suse.de>, Guoqing Jiang <gqjiang@suse.com>
List-Id: linux-raid.ids

On Mon, Nov 28, 2016 at 02:42:22PM +0800, Coly Li wrote:
> On 2016/11/23 上午5:35, Shaohua Li wrote:
> > On Tue, Nov 22, 2016 at 05:54:00AM +0800, Coly Li wrote:
> >> 'Commit 79ef3a8aa1cb ("raid1: Rewrite the implementation of iobarrier.")'
> >> introduces a sliding resync window for raid1 I/O barrier, this idea limits
> >> I/O barriers to happen only inside a slidingresync window, for regular
> >> I/Os out of this resync window they don't need to wait for barrier any
> >> more. On large raid1 device, it helps a lot to improve parallel writing
> >> I/O throughput when there are background resync I/Os performing at
> >> same time. 
> >>
> >> The idea of sliding resync widow is awesome, but there are several
> >> challenges are very difficult to solve,
> >>  - code complexity
> >>    Sliding resync window requires several veriables to work collectively,
> >>    this is complexed and very hard to make it work correctly. Just grep
> >>    "Fixes: 79ef3a8aa1" in kernel git log, there are 8 more patches to fix
> >>    the original resync window patch. This is not the end, any further
> >>    related modification may easily introduce more regreassion.
> >>  - multiple sliding resync windows
> >>    Currently raid1 code only has a single sliding resync window, we cannot
> >>    do parallel resync with current I/O barrier implementation.
> >>    Implementing multiple resync windows are much more complexed, and very
> >>    hard to make it correctly.
> >>
> >> Therefore I decide to implement a much simpler raid1 I/O barrier, by
> >> removing resync window code, I believe life will be much easier.
> >>
> >> The brief idea of the simpler barrier is,
> >>  - Do not maintain a logbal unique resync window
> >>  - Use multiple hash buckets to reduce I/O barrier conflictions, regular
> >>    I/O only has to wait for a resync I/O when both them have same barrier
> >>    bucket index, vice versa.
> >>  - I/O barrier can be recuded to an acceptable number if there are enought
> >>    barrier buckets
> >>
> >> Here I explain how the barrier buckets are designed,
> >>  - BARRIER_UNIT_SECTOR_SIZE
> >>    The whole LBA address space of a raid1 device is divided into multiple
> >>    barrier units, by the size of BARRIER_UNIT_SECTOR_SIZE.
> >>    Bio request won't go across border of barrier unit size, that means
> >>    maximum bio size is BARRIER_UNIT_SECTOR_SIZE<<9 in bytes.
> >>  - BARRIER_BUCKETS_NR
> >>    There are BARRIER_BUCKETS_NR buckets in total, if multiple I/O requests
> >>    hit different barrier units, they only need to compete I/O barrier with
> >>    other I/Os which hit the same barrier bucket index with each other. The
> >>    index of a barrier bucket which a bio should look for is calculated by
> >>    get_barrier_bucket_idx(),
> >> 	(sector >> BARRIER_UNIT_SECTOR_BITS) % BARRIER_BUCKETS_NR
> >>    sector is the start sector number of a bio. align_to_barrier_unit_end()
> >>    will make sure the finall bio sent into generic_make_request() won't
> >>    exceed border of the barrier unit size.
> >>  - RRIER_BUCKETS_NR
> >>    Number of barrier buckets is defined by,
> >> 	#define BARRIER_BUCKETS_NR	(PAGE_SIZE/sizeof(long))
> >>    For 4KB page size, there are 512 buckets for each raid1 device. That
> >>    means the propobility of full random I/O barrier confliction may be
> >>    reduced down to 1/512.
> > 
> > Thanks! The idea is awesome and does makes the code easier to understand.
> > 
> > For hash conflict, I'm worrying about one case. resync does sequential access.
> > Say we have a sequential normal IO. If the first normal IO and resync IO have
> > conflict, it's possible they will have conflict subsequently, since both are
> > doing sequential access. We can change the hash to something like this:
> > 
> > for the first 64M * 512, the hash is 0, 1, ... 511
> > For the second 64M * 512, the hash is 1, 3, 5 ...
> > The third 64M * 512, the hash is 2, 5, 8 ...
> > 
> > It should be very easy to implement something like this, and this should reduce
> > the conflict of sequential access.
> >  
> 
> Hi Shaohua,
> 
> What I concerned was memory footprint. For very fast sequential I/O,
> lineal mapping buckets means each (64 bytes) cache line contains 8 long
> integer, it is very friendly for CPU caching,
>  - sequential writing 8 barrier units only requires 1 memory fetching
> for each barrier variables (barrier[], nr_pending[], nr_waiting[],
> nr_queued[]).
>  - memory prefetch may have positive effect in sequential I/O.
> 
> It will be very rare that resync I/O and regular I/O are always
> conflicted in same barrier bucket: resync I/O throughput usually is
> slower than regular I/O, it is very hard to keep them always conflicting
> in same bucket. If this condition really happens, current sliding resync
> window implementation may also have a similar conflict (regular I/O
> always hits resync window). So the barrier buckets don't make things worse.
> 
> If we use a non-continuous mapping, memory fingerprint of the buckets
> will be quite distributed, and occupies more cache lines for a
> sequential I/O, which will increase the probability of more cache bounce
> if there are multiple sequential I/O (on different offset) happen on
> different CPU cores.
> 
> This is why I use a very simple linear buckets hashing.

Don't think memory footprint matters much. And wasting a little memory (eg,
make the barrier and stuffes cacheline aligned) doesn't matter here too if
necessary. If we could reduce the hash confilict in an easy way, why not? I
think Neil's suggestion (using hash_long) makes sense.
 
> >> Comparing to single sliding resync window,
> >>  - Currently resync I/O grows linearly, therefore regular and resync I/O
> >>    will have confliction within a single barrier units. So it is similar to
> >>    single sliding resync window.
> >>  - But a barrier unit bucket is shared by all barrier units with identical
> >>    barrier uinit index, the probability of confliction might be higher
> >>    than single sliding resync window, in condition that writing I/Os
> >>    always hit barrier units which have identical barrier bucket index with
> >>    the resync I/Os. This is a very rare condition in real I/O work loads,
> >>    I cannot imagine how it could happen in practice.
> >>  - Therefore we can achieve a good enough low confliction rate with much
> >>    simpler barrier algorithm and implementation.
> >>
> >> If user has a (realy) large raid1 device, for example 10PB size, we may
> >> just increase the buckets number BARRIER_BUCKETS_NR. Now this is a macro,
> >> it is possible to be a raid1-created-time-defined variable in future.
> >>
> >> There are two changes should be noticed,
> >>  - In raid1d(), I change the code to decrease conf->nr_pending[idx] into
> >>    single loop, it looks like this,
> >> 	spin_lock_irqsave(&conf->device_lock, flags);
> >> 	conf->nr_queued[idx]--;
> >> 	spin_unlock_irqrestore(&conf->device_lock, flags);
> >>    This change generates more spin lock operations, but in next patch of
> >>    this patch set, it will be replaced by a single line code,
> >> 	atomic_dec(conf->nr_queueud[idx]);
> >>    So we don't need to worry about spin lock cost here.
> >>  - In raid1_make_request(), wait_barrier() is replaced by,
> >>    a) wait_read_barrier(): wait barrier in regular read I/O code path
> >>    b) wait_barrier(): wait barrier in regular write I/O code path
> >>    The differnece is wait_read_barrier() only waits if array is frozen, I
> >>    am not able to combile them into one function, because they must receive
> >>    differnet data types in their arguments list.
> >>  - align_to_barrier_unit_end() is called to make sure both regular and
> >>    resync I/O won't go across the border of a barrier unit size.
> >>  
> >> Open question:
> >>  - Need review from md clustring developer, I don't touch related code now.
> > 
> > Don't think it matters, but please open eyes, Guoqing!
> >  
> >> Signed-off-by: Coly Li <colyli@suse.de>
> >> Cc: Shaohua Li <shli@fb.com>
> >> Cc: Neil Brown <neilb@suse.de>
> >> Cc: Johannes Thumshirn <jthumshirn@suse.de>
> >> Cc: Guoqing Jiang <gqjiang@suse.com>
> >> ---
> >>  drivers/md/raid1.c | 389 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++---------------------------------------------
> >>  drivers/md/raid1.h |  42 +++++-------
> >>  2 files changed, 242 insertions(+), 189 deletions(-)
> >>
> >> Index: linux-raid1/drivers/md/raid1.c
> >> ===================================================================
> >> --- linux-raid1.orig/drivers/md/raid1.c
> >> +++ linux-raid1/drivers/md/raid1.c
> >> @@ -66,9 +66,8 @@
> >>   */
> >>  static int max_queued_requests = 1024;
> >>  
> >> -static void allow_barrier(struct r1conf *conf, sector_t start_next_window,
> >> -			  sector_t bi_sector);
> >> -static void lower_barrier(struct r1conf *conf);
> >> +static void allow_barrier(struct r1conf *conf, sector_t sector_nr);
> >> +static void lower_barrier(struct r1conf *conf, sector_t sector_nr);
> >>  
> >>  static void * r1bio_pool_alloc(gfp_t gfp_flags, void *data)
> >>  {
> >> @@ -92,7 +91,6 @@ static void r1bio_pool_free(void *r1_bio
> >>  #define RESYNC_WINDOW_SECTORS (RESYNC_WINDOW >> 9)
> >>  #define CLUSTER_RESYNC_WINDOW (16 * RESYNC_WINDOW)
> >>  #define CLUSTER_RESYNC_WINDOW_SECTORS (CLUSTER_RESYNC_WINDOW >> 9)
> >> -#define NEXT_NORMALIO_DISTANCE (3 * RESYNC_WINDOW_SECTORS)
> >>  
> >>  static void * r1buf_pool_alloc(gfp_t gfp_flags, void *data)
> >>  {
> >> @@ -198,6 +196,7 @@ static void put_buf(struct r1bio *r1_bio
> >>  {
> >>  	struct r1conf *conf = r1_bio->mddev->private;
> >>  	int i;
> >> +	sector_t sector_nr = r1_bio->sector;
> >>  
> >>  	for (i = 0; i < conf->raid_disks * 2; i++) {
> >>  		struct bio *bio = r1_bio->bios[i];
> >> @@ -207,7 +206,7 @@ static void put_buf(struct r1bio *r1_bio
> >>  
> >>  	mempool_free(r1_bio, conf->r1buf_pool);
> >>  
> >> -	lower_barrier(conf);
> >> +	lower_barrier(conf, sector_nr);
> >>  }
> >>  
> >>  static void reschedule_retry(struct r1bio *r1_bio)
> >> @@ -215,10 +214,15 @@ static void reschedule_retry(struct r1bi
> >>  	unsigned long flags;
> >>  	struct mddev *mddev = r1_bio->mddev;
> >>  	struct r1conf *conf = mddev->private;
> >> +	sector_t sector_nr;
> >> +	long idx;
> >> +
> >> +	sector_nr = r1_bio->sector;
> >> +	idx = get_barrier_bucket_idx(sector_nr);
> >>  
> >>  	spin_lock_irqsave(&conf->device_lock, flags);
> >>  	list_add(&r1_bio->retry_list, &conf->retry_list);
> >> -	conf->nr_queued ++;
> >> +	conf->nr_queued[idx]++;
> >>  	spin_unlock_irqrestore(&conf->device_lock, flags);
> >>  
> >>  	wake_up(&conf->wait_barrier);
> >> @@ -235,8 +239,6 @@ static void call_bio_endio(struct r1bio
> >>  	struct bio *bio = r1_bio->master_bio;
> >>  	int done;
> >>  	struct r1conf *conf = r1_bio->mddev->private;
> >> -	sector_t start_next_window = r1_bio->start_next_window;
> >> -	sector_t bi_sector = bio->bi_iter.bi_sector;
> >>  
> >>  	if (bio->bi_phys_segments) {
> >>  		unsigned long flags;
> >> @@ -255,19 +257,14 @@ static void call_bio_endio(struct r1bio
> >>  	if (!test_bit(R1BIO_Uptodate, &r1_bio->state))
> >>  		bio->bi_error = -EIO;
> >>  
> >> -	if (done) {
> >> +	if (done)
> >>  		bio_endio(bio);
> >> -		/*
> >> -		 * Wake up any possible resync thread that waits for the device
> >> -		 * to go idle.
> >> -		 */
> >> -		allow_barrier(conf, start_next_window, bi_sector);
> >> -	}
> >>  }
> >>  
> >>  static void raid_end_bio_io(struct r1bio *r1_bio)
> >>  {
> >>  	struct bio *bio = r1_bio->master_bio;
> >> +	struct r1conf *conf = r1_bio->mddev->private;
> >>  
> >>  	/* if nobody has done the final endio yet, do it now */
> >>  	if (!test_and_set_bit(R1BIO_Returned, &r1_bio->state)) {
> >> @@ -278,6 +275,12 @@ static void raid_end_bio_io(struct r1bio
> >>  
> >>  		call_bio_endio(r1_bio);
> >>  	}
> >> +
> >> +	/*
> >> +	 * Wake up any possible resync thread that waits for the device
> >> +	 * to go idle.
> >> +	 */
> >> +	allow_barrier(conf, r1_bio->sector);
> > Why this change?
> > 
> 
> I move allow_barrier() here on purpose. Because current raid1 code
> raises nr_pending for each master bio, the barrier buckets patch raises
> nr_pending[idx] for each r1_bio.
> 
> Current code increases nr_pending for each master bio (the bio structure
> received by raid1_make_request()). A master bio may be split by multiple
> r1_bio structures, when all r1_bio completes, nr_pending is decreased
> for the original master bio.
> 
> Since the master bio may go across multiple barrier units, in this patch
> master bio will be split into multiple r1_bio structures for each
> barrier units. In this case, we need to call wait_barrer() for each
> r1_bio, and call allow_barrier() on each r1_bio completion. This is why
> allow_barrier() is moved form master bio completion time to r1_bio
> completion time.
> 
> A master bio may also be split into multiple r1_bio if bad blocks
> encountered, and these r1_bio may stay in same barrier unit. In this
> case the different r1_bio does increase nr_pending[] for same bucket
> index, we should also call wait_barrier() for each r1_bio and call
> allow_barrier() at its completion time.

I think if you do bio_split before raid1_make_request, these issues go away.

> >>  	free_r1bio(r1_bio);
> >>  }
> >>  
> >> @@ -311,6 +314,7 @@ static int find_bio_disk(struct r1bio *r
> >>  	return mirror;
> >>  }
> >>  
> >> +/* bi_end_io callback for regular READ bio */
> >>  static void raid1_end_read_request(struct bio *bio)
> >>  {
> >>  	int uptodate = !bio->bi_error;
> >> @@ -490,6 +494,25 @@ static void raid1_end_write_request(stru
> >>  		bio_put(to_put);
> >>  }
> >>  
> >> +static sector_t align_to_barrier_unit_end(sector_t start_sector,
> >> +					  sector_t sectors)
> >> +{
> >> +	sector_t len;
> >> +
> >> +	WARN_ON(sectors == 0);
> >> +	/* len is the number of sectors from start_sector to end of the
> >> +	 * barrier unit which start_sector belongs to.
> >> +	 */
> >> +	len = ((start_sector + sectors + (1<<BARRIER_UNIT_SECTOR_BITS) - 1) &
> >> +	       (~(BARRIER_UNIT_SECTOR_SIZE - 1))) -
> >> +	      start_sector;
> >> +
> >> +	if (len > sectors)
> >> +		len = sectors;
> >> +
> >> +	return len;
> >> +}
> > 
> > I'd prefer calling bio_split at the early of raid1_make_request and split the
> > bio if it crosses the bucket boundary. please see raid10_make_request for
> > example. resync will not cross the boundary. So the code will not need to worry
> > about the boundary. I believe this will make the code simpiler (all the
> > align_to_barrier_unit_end calling can removed) and easy to understand.
> > 
> 
> Indeed, my first implementation uses bio_split(). The reasons why I
> don't use it later are,
> - indeed I need to write more code.
> - I can't simply use existing r1_bio completion code to call
> bio_end_io() to the master bio when bio->bi_phys_segments is zero (see
> call_bio_endio()). Because r1_bio->master_bio is the split bio, not the
> original master bio received by raid1_make_request()
> 
> Therefore finally I decide to use align_to_barrier_unit_end() to
> generate more r1_bio structures if the original master bio goes across
> barrier unit size, it makes less modification in this patch.

That bi_phys_segments issue doesn't make sense to me. Please see how raid10 use
bio_split.
- rename raid1_make_request to __raid1_make_request
- add a raid1_make_request, split bio there, and then call __raid1_make_request

the __raid1_make_request does everthing it currently does, the bi_phys_segments
should still work. This might add more code. But now we don't need to worry
about the boundary problem everywhere else except the new raid1_make_request.
For example, the allow_barrier issue goes away with this approach. This will
make the code more understandable and less error prone.
 
> >> +
> >>  /*
> >>   * This routine returns the disk from which the requested read should
> >>   * be done. There is a per-array 'next expected sequential IO' sector
> >> @@ -691,6 +714,7 @@ static int read_balance(struct r1conf *c
> >>  		conf->mirrors[best_disk].next_seq_sect = this_sector + sectors;
> >>  	}
> >>  	rcu_read_unlock();
> >> +	sectors = align_to_barrier_unit_end(this_sector, sectors);
> >>  	*max_sectors = sectors;
> >>  
> >>  	return best_disk;
> >> @@ -779,168 +803,174 @@ static void flush_pending_writes(struct
> >>   *    there is no normal IO happeing.  It must arrange to call
> >>   *    lower_barrier when the particular background IO completes.
> >>   */
> >> +
> >>  static void raise_barrier(struct r1conf *conf, sector_t sector_nr)
> >>  {
> >> +	long idx = get_barrier_bucket_idx(sector_nr);
> >> +
> >>  	spin_lock_irq(&conf->resync_lock);
> >>  
> >>  	/* Wait until no block IO is waiting */
> >> -	wait_event_lock_irq(conf->wait_barrier, !conf->nr_waiting,
> >> +	wait_event_lock_irq(conf->wait_barrier, !conf->nr_waiting[idx],
> >>  			    conf->resync_lock);
> >>  
> >>  	/* block any new IO from starting */
> >> -	conf->barrier++;
> >> -	conf->next_resync = sector_nr;
> >> +	conf->barrier[idx]++;
> >>  
> >>  	/* For these conditions we must wait:
> >>  	 * A: while the array is in frozen state
> >> -	 * B: while barrier >= RESYNC_DEPTH, meaning resync reach
> >> -	 *    the max count which allowed.
> >> -	 * C: next_resync + RESYNC_SECTORS > start_next_window, meaning
> >> -	 *    next resync will reach to the window which normal bios are
> >> -	 *    handling.
> >> -	 * D: while there are any active requests in the current window.
> >> +	 * B: while conf->nr_pending[idx] is not 0, meaning regular I/O
> >> +	 *    existing in sector number ranges corresponding to idx.
> >> +	 * C: while conf->barrier[idx] >= RESYNC_DEPTH, meaning resync reach
> >> +	 *    the max count which allowed in sector number ranges
> >> +	 *    conrresponding to idx.
> >>  	 */
> >>  	wait_event_lock_irq(conf->wait_barrier,
> >> -			    !conf->array_frozen &&
> >> -			    conf->barrier < RESYNC_DEPTH &&
> >> -			    conf->current_window_requests == 0 &&
> >> -			    (conf->start_next_window >=
> >> -			     conf->next_resync + RESYNC_SECTORS),
> >> +			    !conf->array_frozen && !conf->nr_pending[idx] &&
> >> +			    conf->barrier[idx] < RESYNC_DEPTH,
> >>  			    conf->resync_lock);
> > 
> > So there is a slight behavior change. Originally we guarautee no more than
> > RESYNC_DEPTH sync. Now this only checks 'conf->barrier[idx] < RESYNC_DEPTH'.
> > How about barrier[idx-1], barrier[idx-2]...? It's possible conf->barrier[idx] <
> > RESYNC_DEPTH, but barrier[idx] + barrier[idx-1] > RESYNC_DEPTH. Not sure how
> > important this is, but at least we can check barrier[idx] + barrier[idx-1].
> 
> The original code wants to rise more multiple barriers, but less then
> RESYNC_DEPTH. It helps resync I/O throughput with less resync I/O and
> regular I/O conflict. Considering conf->barrier is a global barrier,
> large RESYNC_DEPTH will starve regular I/O, it is only set to 32 for
> whole raid1 device.
> 
> In the barrier buckets patch, conf->barrier[idx] only takes effect in a
> single bucket. More barriers raised in this barrier buckets won't
> interfere regular I/O in other barrier buckets, therefore we can have
> much more resync I/O barriers to raise, which is good for resync I/O
> throughput without starve more regular I/Os.
> 
> If we have 512 barrier buckets, that means on the whole raid1 device
> there are 512*RESYNC_DEPTH barriers can be raised, and allows more
> parallel resync I/O.
> 
> Before implementing parallel resync, I keep RESYNC_DEPTH as 32 in this
> patch, because we only have a resync I/O hits one barrier buckets, same
> RESYNC_DEPTH won't change barrier behavior now. Latter when we have
> parallel resync I/O, let's see whether we need to modify this value,
> also still keep it as 32.

The problem is resync write could harm latency of regular IO. Even we have
resync limitation mechanism, sending a lot of resync write out could harm
regular IO latency for worst case. If the application has P99 metrics, more
resync IO definitively will harm it. This will not be easy to observe though.
Could we have a global pending counter to record barrier IO and using it in the
same way as the old code? That said I'm not sure how important this is, but
this could make things worse, so I'd like to avoid the regression.
 
> >> -
> >> -	conf->nr_pending++;
> >> +	conf->nr_pending[idx]++;
> >>  	spin_unlock_irq(&conf->resync_lock);
> >>  }
> >>  
> >> -static void lower_barrier(struct r1conf *conf)
> >> +static void lower_barrier(struct r1conf *conf, sector_t sector_nr)
> >>  {
> >>  	unsigned long flags;
> >> -	BUG_ON(conf->barrier <= 0);
> >> +	long idx = get_barrier_bucket_idx(sector_nr);
> >> +
> >> +	BUG_ON(conf->barrier[idx] <= 0);
> >>  	spin_lock_irqsave(&conf->resync_lock, flags);
> >> -	conf->barrier--;
> >> -	conf->nr_pending--;
> >> +	conf->barrier[idx]--;
> >> +	conf->nr_pending[idx]--;
> >>  	spin_unlock_irqrestore(&conf->resync_lock, flags);
> >>  	wake_up(&conf->wait_barrier);
> >>  }
> >>  
> >> -static bool need_to_wait_for_sync(struct r1conf *conf, struct bio *bio)
> >> +/* A regular I/O should wait when,
> >> + * - The whole array is frozen (both READ and WRITE)
> >> + * - bio is WRITE and in same barrier bucket conf->barrier[idx] raised
> >> + */
> >> +static void _wait_barrier(struct r1conf *conf, long idx)
> >>  {
> >> -	bool wait = false;
> >> -
> >> -	if (conf->array_frozen || !bio)
> >> -		wait = true;
> >> -	else if (conf->barrier && bio_data_dir(bio) == WRITE) {
> >> -		if ((conf->mddev->curr_resync_completed
> >> -		     >= bio_end_sector(bio)) ||
> >> -		    (conf->next_resync + NEXT_NORMALIO_DISTANCE
> >> -		     <= bio->bi_iter.bi_sector))
> >> -			wait = false;
> >> -		else
> >> -			wait = true;
> >> +	spin_lock_irq(&conf->resync_lock);
> >> +	if (conf->array_frozen || conf->barrier[idx]) {
> >> +		conf->nr_waiting[idx]++;
> >> +		/* Wait for the barrier to drop. */
> >> +		wait_event_lock_irq(
> >> +			conf->wait_barrier,
> >> +			!conf->array_frozen && !conf->barrier[idx],
> >> +			conf->resync_lock);
> >> +		conf->nr_waiting[idx]--;
> >>  	}
> >>  
> >> -	return wait;
> >> +	conf->nr_pending[idx]++;
> >> +	spin_unlock_irq(&conf->resync_lock);
> >>  }
> >>  
> >> -static sector_t wait_barrier(struct r1conf *conf, struct bio *bio)
> >> +static void wait_read_barrier(struct r1conf *conf, sector_t sector_nr)
> >>  {
> >> -	sector_t sector = 0;
> >> +	long idx = get_barrier_bucket_idx(sector_nr);
> >>  
> >>  	spin_lock_irq(&conf->resync_lock);
> >> -	if (need_to_wait_for_sync(conf, bio)) {
> >> -		conf->nr_waiting++;
> >> -		/* Wait for the barrier to drop.
> >> -		 * However if there are already pending
> >> -		 * requests (preventing the barrier from
> >> -		 * rising completely), and the
> >> -		 * per-process bio queue isn't empty,
> >> -		 * then don't wait, as we need to empty
> >> -		 * that queue to allow conf->start_next_window
> >> -		 * to increase.
> >> -		 */
> >> -		wait_event_lock_irq(conf->wait_barrier,
> >> -				    !conf->array_frozen &&
> >> -				    (!conf->barrier ||
> >> -				     ((conf->start_next_window <
> >> -				       conf->next_resync + RESYNC_SECTORS) &&
> >> -				      current->bio_list &&
> >> -				      !bio_list_empty(current->bio_list))),
> >> -				    conf->resync_lock);
> >> -		conf->nr_waiting--;
> >> -	}
> >> -
> >> -	if (bio && bio_data_dir(bio) == WRITE) {
> >> -		if (bio->bi_iter.bi_sector >= conf->next_resync) {
> >> -			if (conf->start_next_window == MaxSector)
> >> -				conf->start_next_window =
> >> -					conf->next_resync +
> >> -					NEXT_NORMALIO_DISTANCE;
> >> -
> >> -			if ((conf->start_next_window + NEXT_NORMALIO_DISTANCE)
> >> -			    <= bio->bi_iter.bi_sector)
> >> -				conf->next_window_requests++;
> >> -			else
> >> -				conf->current_window_requests++;
> >> -			sector = conf->start_next_window;
> >> -		}
> >> +	if (conf->array_frozen) {
> >> +		conf->nr_waiting[idx]++;
> >> +		/* Wait for array to unfreeze */
> >> +		wait_event_lock_irq(
> >> +			conf->wait_barrier,
> >> +			!conf->array_frozen,
> >> +			conf->resync_lock);
> >> +		conf->nr_waiting[idx]--;
> >>  	}
> >> -
> >> -	conf->nr_pending++;
> >> +	conf->nr_pending[idx]++;
> >>  	spin_unlock_irq(&conf->resync_lock);
> >> -	return sector;
> >>  }
> >>  
> >> -static void allow_barrier(struct r1conf *conf, sector_t start_next_window,
> >> -			  sector_t bi_sector)
> >> +static void wait_barrier(struct r1conf *conf, sector_t sector_nr)
> >> +{
> >> +	long idx = get_barrier_bucket_idx(sector_nr);
> >> +
> >> +	_wait_barrier(conf, idx);
> >> +}
> >> +
> >> +static void wait_all_barriers(struct r1conf *conf)
> >> +{
> >> +	long idx;
> >> +
> >> +	for (idx = 0; idx < BARRIER_BUCKETS_NR; idx++)
> >> +		_wait_barrier(conf, idx);
> > 
> > This is racy. Since resync is sequential, idealy we only need to check the
> > bucket sequentially. The compiler could do  _wait_barrier(conf, 1) and then
> > _wait_barrier(conf, 0). It's possible the bucket 1 has barrier right after the
> > check of bucket 0. Even the compiler doesn't reorder, there is case the bucket
> > 511 should be check before bucket 0 if the resync is just crossing 512 buckets.
> > It would be better we check the resync position and adjust the bucket wait
> > order according to the position.
> > 
> 
> wait_all_barriers() and allow_all_barriers() are used in close_sync() only,
>  static void close_sync(struct r1conf *conf)
>  {
> -	wait_barrier(conf, NULL);
> -	allow_barrier(conf, 0, 0);
> +	wait_all_barriers(conf);
> +	allow_all_barriers(conf);
> [snip]
>  }
> 
> wait_barrier() and allow_barrier() called here is for a synchronization
> purpose, to make sure before close_sync() returns there is no resync I/O
> existing.
> 
> close_sync() is called in raid1_sync_request() when resync I/O exceeds
> the size of raid1 device, and resync should be closed. In this
> condition, there won't be any new resync I/O generated. If a
> conf->barrier[idx] reaches 0, it won't increase before a new resync
> restarts. Therefore it is safe to call _wait_barrier() one by one, until
> every conf->barrier[idx] reaches to 0.
> 
> This is a usage of wait/allow_barrier() which is not mentioned in the
> code. They are not for regular I/O waiting for resync I/O, they are used
> as a synchronization to make sure all on-flying resync I/O to complete.

thanks, this makes sense.

> >>  	int good_sectors = RESYNC_SECTORS;
> >>  	int min_bad = 0; /* number of sectors that are bad in all devices */
> >> +	long idx = get_barrier_bucket_idx(sector_nr);
> >>  
> >>  	if (!conf->r1buf_pool)
> >>  		if (init_resync(conf))
> >> @@ -2535,7 +2571,7 @@ static sector_t raid1_sync_request(struc
> >>  	 * If there is non-resync activity waiting for a turn, then let it
> >>  	 * though before starting on this new sync request.
> >>  	 */
> >> -	if (conf->nr_waiting)
> >> +	if (conf->nr_waiting[idx])
> >>  		schedule_timeout_uninterruptible(1);
> >>  
> >>  	/* we are incrementing sector_nr below. To be safe, we check against
> >> @@ -2562,6 +2598,8 @@ static sector_t raid1_sync_request(struc
> >>  	r1_bio->sector = sector_nr;
> >>  	r1_bio->state = 0;
> >>  	set_bit(R1BIO_IsSync, &r1_bio->state);
> >> +	/* make sure good_sectors won't go across barrier unit border */
> >> +	good_sectors = align_to_barrier_unit_end(sector_nr, good_sectors);
> >>  
> >>  	for (i = 0; i < conf->raid_disks * 2; i++) {
> >>  		struct md_rdev *rdev;
> >> @@ -2786,6 +2824,22 @@ static struct r1conf *setup_conf(struct
> >>  	if (!conf)
> >>  		goto abort;
> >>  
> >> +	conf->nr_pending = kzalloc(PAGE_SIZE, GFP_KERNEL);
> >> +	if (!conf->nr_pending)
> >> +		goto abort;
> > 
> > This allocation is a little wierd. I'd define a count and uses
> > sizeof(nr_pending) * count to do the allocation. There is nothing related to
> > PAGE_SIZE. Alternatively, just make nr_pending an array in r1conf.
> 
> This is just for better memory usage, r1conf is allocated by slab
> allocator, large not aligned size may cause internal memory
> fragmentation inside slab's pages. call kzalloc() with PAGE_SIZE will
> avoid such issue.

Not sure if slab has closest slab for this, but that's not important. I think
sizeof(nr_pending) * count makes more sense here, even sizeof(nr_pending)
* count == PAGE_SIZE.

Thanks,
Shaohua
