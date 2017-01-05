From: NeilBrown <neilb@suse.com>
Subject: Re: [v2 PATCH 1/2] RAID1: a new I/O barrier implementation to remove resync window
Date: Fri, 06 Jan 2017 10:08:02 +1100
Message-ID: <87o9zlksvh.fsf@notabene.neil.brown.name>
References: <1482853658-82535-1-git-send-email-colyli@suse.de>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1482853658-82535-1-git-send-email-colyli@suse.de>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Coly Li <colyli@suse.de>, Shaohua Li <shli@fb.com>, Neil Brown <neilb@suse.de>, Johannes Thumshirn <jthumshirn@suse.de>, Guoqing Jiang <gqjiang@suse.com>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 28 2016, Coly Li wrote:

> 'Commit 79ef3a8aa1cb ("raid1: Rewrite the implementation of iobarrier.")'
> introduces a sliding resync window for raid1 I/O barrier, this idea limits
> I/O barriers to happen only inside a slidingresync window, for regular
> I/Os out of this resync window they don't need to wait for barrier any
> more. On large raid1 device, it helps a lot to improve parallel writing
> I/O throughput when there are background resync I/Os performing at
> same time.
>
> The idea of sliding resync widow is awesome, but there are several
> challenges are very difficult to solve,
>  - code complexity
>    Sliding resync window requires several veriables to work collectively,
>    this is complexed and very hard to make it work correctly. Just grep
>    "Fixes: 79ef3a8aa1" in kernel git log, there are 8 more patches to fix
>    the original resync window patch. This is not the end, any further
>    related modification may easily introduce more regreassion.
>  - multiple sliding resync windows
>    Currently raid1 code only has a single sliding resync window, we cannot
>    do parallel resync with current I/O barrier implementation.
>    Implementing multiple resync windows are much more complexed, and very
>    hard to make it correctly.

I think I've asked this before, but why do you think that parallel
resync might ever be a useful idea?  I don't think it makes any sense, so
it is wrong for you use it as part of the justification for this patch.
Just don't mention it at all unless you have a genuine expectation that
it would really be a good thing, in which case: explain the value.

>
> Therefore I decide to implement a much simpler raid1 I/O barrier, by
> removing resync window code, I believe life will be much easier.
>
> The brief idea of the simpler barrier is,
>  - Do not maintain a logbal unique resync window
>  - Use multiple hash buckets to reduce I/O barrier conflictions, regular
>    I/O only has to wait for a resync I/O when both them have same barrier
>    bucket index, vice versa.
>  - I/O barrier can be recuded to an acceptable number if there are enought
>    barrier buckets
>
> Here I explain how the barrier buckets are designed,
>  - BARRIER_UNIT_SECTOR_SIZE
>    The whole LBA address space of a raid1 device is divided into multiple
>    barrier units, by the size of BARRIER_UNIT_SECTOR_SIZE.
>    Bio request won't go across border of barrier unit size, that means
>    maximum bio size is BARRIER_UNIT_SECTOR_SIZE<<9 in bytes.

It would be good to say here what number you chose, and why you chose
it.
You have picked 64MB.  This divides a 1TB device into 4096 regions.
Any write request must fit into one of these regions, so we mustn't make
the region too small, else we would get the benefits for sending large
requests down.

We want the resync to move from region to region fairly quickly so that
the slowness caused by having to synchronize with the resync is averaged
out overa fairly small time frame.  At full speed, 64MB should take less
than 1 second.  When resync is competing with other IO, it could easily
take up to a minute(?).  I think that is a fairly good range.

So I think 64MB is probably a very good choice.  I just would like to
see the justification clearly stated.

>  - BARRIER_BUCKETS_NR
>    There are BARRIER_BUCKETS_NR buckets in total, which is defined by,
>         #define BARRIER_BUCKETS_NR_BITS   9
>         #define BARRIER_BUCKETS_NR        (1<<BARRIER_BUCKETS_NR_BITS)

Why 512 buckets?  What are the tradeoffs?
More buckets means more memory consumed for counters.
Fewer buckets means more false sharing.
With 512 buckets, a request which is smaller than the region size has a
0.2% chance of having to wait for resync to pause.  I think that is
quite a small enough fraction.
I think you originally chose the number of buckets so that a set of
4-byte counters fits exactly into a page.  I think that is still a good
guideline, so I would have
	#define BARRIER_BUCKETS_NR_BITS	(PAGE_SHIFT - 2)
(which makes it 10 ...).

>    if multiple I/O requests hit different barrier units, they only need
>    to compete I/O barrier with other I/Os which hit the same barrier
>    bucket index with each other. The index of a barrier bucket which a
>    bio should look for is calculated by,
>         int idx =3D hash_long(sector_nr, BARRIER_BUCKETS_NR_BITS)

This isn't right.  You have to divide by BARRIER_UNIT_SECTOR_SIZE first.
	int idx =3D hash_long(sector_nr >> BARRIER_UNIT_SECTOR_BITS, BARRIER_BUCKE=
TS_NR_BITS);

>    that sector_nr is the start sector number of a bio. We use function
>    align_to_barrier_unit_end() to calculate sectors number from sector_nr
>    to the next barrier unit size boundary, if the requesting bio size
>    goes across the boundary, we split the bio in raid1_make_request(), to
>    make sure the finall bio sent into generic_make_request() won't exceed
>    barrier unit boundary.
>
> Comparing to single sliding resync window,
>  - Currently resync I/O grows linearly, therefore regular and resync I/O
>    will have confliction within a single barrier units. So it is similar =
to
>    single sliding resync window.
>  - But a barrier unit bucket is shared by all barrier units with identical
>    barrier uinit index, the probability of confliction might be higher
>    than single sliding resync window, in condition that writing I/Os
>    always hit barrier units which have identical barrier bucket index with
>    the resync I/Os. This is a very rare condition in real I/O work loads,
>    I cannot imagine how it could happen in practice.
>  - Therefore we can achieve a good enough low confliction rate with much
>    simpler barrier algorithm and implementation.
>
> If user has a (realy) large raid1 device, for example 10PB size, we may
> just increase the buckets number BARRIER_BUCKETS_NR. Now this is a macro,
> it is possible to be a raid1-created-time-defined variable in future.

Why?  Why would a large array require more buckets?  Are you just
guessing, or do you see some concrete reason for there to be a
relationship between the size of the array and the number of buckets?
If you can see a connection, please state it.  If not, don't mention it.

>
> There are two changes should be noticed,
>  - In raid1d(), I change the code to decrease conf->nr_pending[idx] into
>    single loop, it looks like this,
>         spin_lock_irqsave(&conf->device_lock, flags);
>         conf->nr_queued[idx]--;
>         spin_unlock_irqrestore(&conf->device_lock, flags);
>    This change generates more spin lock operations, but in next patch of
>    this patch set, it will be replaced by a single line code,
>         atomic_dec(conf->nr_queueud[idx]);
>    So we don't need to worry about spin lock cost here.
>  - Original function raid1_make_request() is split into two functions,
>    - raid1_make_read_request(): handles regular read request and calls
>      wait_read_barrier() for I/O barrier.
>    - raid1_make_write_request(): handles regular write request and calls
>      wait_barrier() for I/O barrier.
>    The differnece is wait_read_barrier() only waits if array is frozen,
>    using different barrier function in different code path makes the code
>    more clean and easy to read.
>  - align_to_barrier_unit_end() is called to make sure both regular and
>    resync I/O won't go across a barrier unit boundary.
>
> Changelog
> V1:
> - Original RFC patch for comments
> V2:
> - Use bio_split() to split the orignal bio if it goes across barrier unit
>   bounday, to make the code more simple, by suggestion from Shaohua and
>   Neil.
> - Use hash_long() to replace original linear hash, to avoid a possible
>   confilict between resync I/O and sequential write I/O, by suggestion fr=
om
>   Shaohua.
> - Add conf->total_barriers to record barrier depth, which is used to
>   control number of parallel sync I/O barriers, by suggestion from Shaohu=
a.

I really don't think this is needed.
As long as RESYNC_DEPTH * RESYNC_SECTORS is less than BARRIER_UNIT_SECTOR_S=
IZE
just testing again ->barrier[idx] will ensure the number of barrier
requests never exceeds RESYNC_DEPTH*2.  That is sufficient.

Also, I think the reason for imposing the RESYNC_DEPTH limit is to make
sure regular IO never has to wait too long for pending resync requests
to flush.  With the simple test, regular IO will never need to wait for
more than RESYNC_DEPTH requests to complete.

So I think have this field brings no valid, and is potentially confusing.

> - In V1 patch the bellowed barrier buckets related members in r1conf are
>   allocated in memory page. To make the code more simple, V2 patch moves
>   the memory space into struct r1conf, like this,
>         -       int                     nr_pending;
>         -       int                     nr_waiting;
>         -       int                     nr_queued;
>         -       int                     barrier;
>         +       int                     nr_pending[BARRIER_BUCKETS_NR];
>         +       int                     nr_waiting[BARRIER_BUCKETS_NR];
>         +       int                     nr_queued[BARRIER_BUCKETS_NR];
>         +       int                     barrier[BARRIER_BUCKETS_NR];

I don't like this.  It makes the r1conf 4 pages is size, most of which
is wasted.  A 4-page allocation is more likely to fail than a few 1-page
allocations.
I think these should be:
>         +       int                     *nr_pending;
>         +       int                     *nr_waiting;
>         +       int                     *nr_queued;
>         +       int                     *barrier;

Then use kcalloc(BARRIER_BUCKETS_NR, sizeof(int), GFP_KERNEL)
to allocate each array.   I think this approach addresses Shaohua's
concerns without requiring a multi-page allocation.

>   This change is by the suggestion from Shaohua.
> - Remove some inrelavent code comments, by suggestion from Guoqing.
> - Add a missing wait_barrier() before jumping to retry_write, in
>   raid1_make_write_request().
>
> Signed-off-by: Coly Li <colyli@suse.de>
> Cc: Shaohua Li <shli@fb.com>
> Cc: Neil Brown <neilb@suse.de>
> Cc: Johannes Thumshirn <jthumshirn@suse.de>
> Cc: Guoqing Jiang <gqjiang@suse.com>
> ---
>  drivers/md/raid1.c | 485 ++++++++++++++++++++++++++++++-----------------=
------
>  drivers/md/raid1.h |  37 ++--
>  2 files changed, 291 insertions(+), 231 deletions(-)
>
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index a1f3fbe..5813656 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -67,9 +67,8 @@
>   */
>  static int max_queued_requests =3D 1024;
>=20=20
> -static void allow_barrier(struct r1conf *conf, sector_t start_next_windo=
w,
> -			  sector_t bi_sector);
> -static void lower_barrier(struct r1conf *conf);
> +static void allow_barrier(struct r1conf *conf, sector_t sector_nr);
> +static void lower_barrier(struct r1conf *conf, sector_t sector_nr);
>=20=20
>  #define raid1_log(md, fmt, args...)				\
>  	do { if ((md)->queue) blk_add_trace_msg((md)->queue, "raid1 " fmt, ##ar=
gs); } while (0)
> @@ -96,7 +95,6 @@ static void r1bio_pool_free(void *r1_bio, void *data)
>  #define RESYNC_WINDOW_SECTORS (RESYNC_WINDOW >> 9)
>  #define CLUSTER_RESYNC_WINDOW (16 * RESYNC_WINDOW)
>  #define CLUSTER_RESYNC_WINDOW_SECTORS (CLUSTER_RESYNC_WINDOW >> 9)
> -#define NEXT_NORMALIO_DISTANCE (3 * RESYNC_WINDOW_SECTORS)
>=20=20
>  static void * r1buf_pool_alloc(gfp_t gfp_flags, void *data)
>  {
> @@ -211,7 +209,7 @@ static void put_buf(struct r1bio *r1_bio)
>=20=20
>  	mempool_free(r1_bio, conf->r1buf_pool);
>=20=20
> -	lower_barrier(conf);
> +	lower_barrier(conf, r1_bio->sector);
>  }
>=20=20
>  static void reschedule_retry(struct r1bio *r1_bio)
> @@ -219,10 +217,12 @@ static void reschedule_retry(struct r1bio *r1_bio)
>  	unsigned long flags;
>  	struct mddev *mddev =3D r1_bio->mddev;
>  	struct r1conf *conf =3D mddev->private;
> +	int idx;
>=20=20
> +	idx =3D hash_long(r1_bio->sector, BARRIER_BUCKETS_NR_BITS);
>  	spin_lock_irqsave(&conf->device_lock, flags);
>  	list_add(&r1_bio->retry_list, &conf->retry_list);
> -	conf->nr_queued ++;
> +	conf->nr_queued[idx]++;
>  	spin_unlock_irqrestore(&conf->device_lock, flags);
>=20=20
>  	wake_up(&conf->wait_barrier);
> @@ -239,8 +239,6 @@ static void call_bio_endio(struct r1bio *r1_bio)
>  	struct bio *bio =3D r1_bio->master_bio;
>  	int done;
>  	struct r1conf *conf =3D r1_bio->mddev->private;
> -	sector_t start_next_window =3D r1_bio->start_next_window;
> -	sector_t bi_sector =3D bio->bi_iter.bi_sector;
>=20=20
>  	if (bio->bi_phys_segments) {
>  		unsigned long flags;
> @@ -265,7 +263,7 @@ static void call_bio_endio(struct r1bio *r1_bio)
>  		 * Wake up any possible resync thread that waits for the device
>  		 * to go idle.
>  		 */
> -		allow_barrier(conf, start_next_window, bi_sector);
> +		allow_barrier(conf, bio->bi_iter.bi_sector);

Why did you change this to use "bio->bi_iter.bi_sector" instead of
"bi_sector"?

I assume you thought it was an optimization that you would just slip
in.  Can't hurt, right?

Just before this line is:
		bio_endio(bio);
and that might cause the bio to be freed.  So your code could
access freed memory.

Please be *very* cautious when making changes that are not directly
related to the purpose of the patch.
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20

>  	}
>  }
>=20=20
> @@ -513,6 +511,25 @@ static void raid1_end_write_request(struct bio *bio)
>  		bio_put(to_put);
>  }
>=20=20
> +static sector_t align_to_barrier_unit_end(sector_t start_sector,
> +					  sector_t sectors)
> +{
> +	sector_t len;
> +
> +	WARN_ON(sectors =3D=3D 0);
> +	/* len is the number of sectors from start_sector to end of the
> +	 * barrier unit which start_sector belongs to.
> +	 */
> +	len =3D ((start_sector + sectors + (1<<BARRIER_UNIT_SECTOR_BITS) - 1) &
> +	       (~(BARRIER_UNIT_SECTOR_SIZE - 1))) -
> +	      start_sector;

This would be better as

    len =3D round_up(start_sector+1, BARRIER_UNIT_SECTOR_SIZE) - start_sect=
or;


> +
> +	if (len > sectors)
> +		len =3D sectors;
> +
> +	return len;
> +}
> +
>  /*
>   * This routine returns the disk from which the requested read should
>   * be done. There is a per-array 'next expected sequential IO' sector
> @@ -809,168 +826,179 @@ static void flush_pending_writes(struct r1conf *c=
onf)
>   */
>  static void raise_barrier(struct r1conf *conf, sector_t sector_nr)
>  {
> +	int idx =3D hash_long(sector_nr, BARRIER_BUCKETS_NR_BITS);
> +
>  	spin_lock_irq(&conf->resync_lock);
>=20=20
>  	/* Wait until no block IO is waiting */
> -	wait_event_lock_irq(conf->wait_barrier, !conf->nr_waiting,
> +	wait_event_lock_irq(conf->wait_barrier, !conf->nr_waiting[idx],
>  			    conf->resync_lock);
>=20=20
>  	/* block any new IO from starting */
> -	conf->barrier++;
> -	conf->next_resync =3D sector_nr;
> +	conf->barrier[idx]++;
> +	conf->total_barriers++;
>=20=20
>  	/* For these conditions we must wait:
>  	 * A: while the array is in frozen state
> -	 * B: while barrier >=3D RESYNC_DEPTH, meaning resync reach
> -	 *    the max count which allowed.
> -	 * C: next_resync + RESYNC_SECTORS > start_next_window, meaning
> -	 *    next resync will reach to the window which normal bios are
> -	 *    handling.
> -	 * D: while there are any active requests in the current window.
> +	 * B: while conf->nr_pending[idx] is not 0, meaning regular I/O
> +	 *    existing in sector number ranges corresponding to idx.
> +	 * C: while conf->total_barriers >=3D RESYNC_DEPTH, meaning resync reach
> +	 *    the max count which allowed on the whole raid1 device.
>  	 */
>  	wait_event_lock_irq(conf->wait_barrier,
>  			    !conf->array_frozen &&
> -			    conf->barrier < RESYNC_DEPTH &&
> -			    conf->current_window_requests =3D=3D 0 &&
> -			    (conf->start_next_window >=3D
> -			     conf->next_resync + RESYNC_SECTORS),
> +			     !conf->nr_pending[idx] &&
> +			     conf->total_barriers < RESYNC_DEPTH,
>  			    conf->resync_lock);
>=20=20
> -	conf->nr_pending++;
> +	conf->nr_pending[idx]++;
>  	spin_unlock_irq(&conf->resync_lock);
>  }
>=20=20
> -static void lower_barrier(struct r1conf *conf)
> +static void lower_barrier(struct r1conf *conf, sector_t sector_nr)
>  {
>  	unsigned long flags;
> -	BUG_ON(conf->barrier <=3D 0);
> +	int idx =3D hash_long(sector_nr, BARRIER_BUCKETS_NR_BITS);
> +
> +	BUG_ON((conf->barrier[idx] <=3D 0) || conf->total_barriers <=3D 0);
> +
>  	spin_lock_irqsave(&conf->resync_lock, flags);
> -	conf->barrier--;
> -	conf->nr_pending--;
> +	conf->barrier[idx]--;
> +	conf->total_barriers--;
> +	conf->nr_pending[idx]--;
>  	spin_unlock_irqrestore(&conf->resync_lock, flags);
>  	wake_up(&conf->wait_barrier);
>  }
>=20=20
> -static bool need_to_wait_for_sync(struct r1conf *conf, struct bio *bio)
> +static void _wait_barrier(struct r1conf *conf, int idx)
>  {
> -	bool wait =3D false;
> -
> -	if (conf->array_frozen || !bio)
> -		wait =3D true;
> -	else if (conf->barrier && bio_data_dir(bio) =3D=3D WRITE) {
> -		if ((conf->mddev->curr_resync_completed
> -		     >=3D bio_end_sector(bio)) ||
> -		    (conf->start_next_window + NEXT_NORMALIO_DISTANCE
> -		     <=3D bio->bi_iter.bi_sector))
> -			wait =3D false;
> -		else
> -			wait =3D true;
> +	spin_lock_irq(&conf->resync_lock);
> +	if (conf->array_frozen || conf->barrier[idx]) {
> +		conf->nr_waiting[idx]++;
> +		/* Wait for the barrier to drop. */
> +		wait_event_lock_irq(
> +			conf->wait_barrier,
> +			!conf->array_frozen && !conf->barrier[idx],
> +			conf->resync_lock);
> +		conf->nr_waiting[idx]--;
>  	}
>=20=20
> -	return wait;
> +	conf->nr_pending[idx]++;
> +	spin_unlock_irq(&conf->resync_lock);
>  }
>=20=20
> -static sector_t wait_barrier(struct r1conf *conf, struct bio *bio)
> +static void wait_read_barrier(struct r1conf *conf, sector_t sector_nr)
>  {
> -	sector_t sector =3D 0;
> +	long idx =3D hash_long(sector_nr, BARRIER_BUCKETS_NR_BITS);
>=20=20
>  	spin_lock_irq(&conf->resync_lock);
> -	if (need_to_wait_for_sync(conf, bio)) {
> -		conf->nr_waiting++;
> -		/* Wait for the barrier to drop.
> -		 * However if there are already pending
> -		 * requests (preventing the barrier from
> -		 * rising completely), and the
> -		 * per-process bio queue isn't empty,
> -		 * then don't wait, as we need to empty
> -		 * that queue to allow conf->start_next_window
> -		 * to increase.
> -		 */
> -		raid1_log(conf->mddev, "wait barrier");
> -		wait_event_lock_irq(conf->wait_barrier,
> -				    !conf->array_frozen &&
> -				    (!conf->barrier ||
> -				     ((conf->start_next_window <
> -				       conf->next_resync + RESYNC_SECTORS) &&
> -				      current->bio_list &&
> -				      !bio_list_empty(current->bio_list))),
> -				    conf->resync_lock);
> -		conf->nr_waiting--;
> -	}
> -
> -	if (bio && bio_data_dir(bio) =3D=3D WRITE) {
> -		if (bio->bi_iter.bi_sector >=3D conf->next_resync) {
> -			if (conf->start_next_window =3D=3D MaxSector)
> -				conf->start_next_window =3D
> -					conf->next_resync +
> -					NEXT_NORMALIO_DISTANCE;
> -
> -			if ((conf->start_next_window + NEXT_NORMALIO_DISTANCE)
> -			    <=3D bio->bi_iter.bi_sector)
> -				conf->next_window_requests++;
> -			else
> -				conf->current_window_requests++;
> -			sector =3D conf->start_next_window;
> -		}
> +	if (conf->array_frozen) {
> +		conf->nr_waiting[idx]++;
> +		/* Wait for array to unfreeze */
> +		wait_event_lock_irq(
> +			conf->wait_barrier,
> +			!conf->array_frozen,
> +			conf->resync_lock);
> +		conf->nr_waiting[idx]--;
>  	}
>=20=20
> -	conf->nr_pending++;
> +	conf->nr_pending[idx]++;
>  	spin_unlock_irq(&conf->resync_lock);
> -	return sector;
>  }
>=20=20
> -static void allow_barrier(struct r1conf *conf, sector_t start_next_windo=
w,
> -			  sector_t bi_sector)
> +static void wait_barrier(struct r1conf *conf, sector_t sector_nr)
> +{
> +	int idx =3D hash_long(sector_nr, BARRIER_BUCKETS_NR_BITS);
> +
> +	_wait_barrier(conf, idx);
> +}
> +
> +static void wait_all_barriers(struct r1conf *conf)
> +{
> +	int idx;
> +
> +	for (idx =3D 0; idx < BARRIER_BUCKETS_NR; idx++)
> +		_wait_barrier(conf, idx);
> +}
> +
> +static void _allow_barrier(struct r1conf *conf, int idx)
>  {
>  	unsigned long flags;
>=20=20
>  	spin_lock_irqsave(&conf->resync_lock, flags);
> -	conf->nr_pending--;
> -	if (start_next_window) {
> -		if (start_next_window =3D=3D conf->start_next_window) {
> -			if (conf->start_next_window + NEXT_NORMALIO_DISTANCE
> -			    <=3D bi_sector)
> -				conf->next_window_requests--;
> -			else
> -				conf->current_window_requests--;
> -		} else
> -			conf->current_window_requests--;
> -
> -		if (!conf->current_window_requests) {
> -			if (conf->next_window_requests) {
> -				conf->current_window_requests =3D
> -					conf->next_window_requests;
> -				conf->next_window_requests =3D 0;
> -				conf->start_next_window +=3D
> -					NEXT_NORMALIO_DISTANCE;
> -			} else
> -				conf->start_next_window =3D MaxSector;
> -		}
> -	}
> +	conf->nr_pending[idx]--;
>  	spin_unlock_irqrestore(&conf->resync_lock, flags);
>  	wake_up(&conf->wait_barrier);
>  }
>=20=20
> +static void allow_barrier(struct r1conf *conf, sector_t sector_nr)
> +{
> +	int idx =3D hash_long(sector_nr, BARRIER_BUCKETS_NR_BITS);
> +
> +	_allow_barrier(conf, idx);
> +}
> +
> +static void allow_all_barriers(struct r1conf *conf)
> +{
> +	int idx;
> +
> +	for (idx =3D 0; idx < BARRIER_BUCKETS_NR; idx++)
> +		_allow_barrier(conf, idx);
> +}
> +
> +/* conf->resync_lock should be held */
> +static int get_all_pendings(struct r1conf *conf)
> +{
> +	int idx, ret;
> +
> +	for (ret =3D 0, idx =3D 0; idx < BARRIER_BUCKETS_NR; idx++)
> +		ret +=3D conf->nr_pending[idx];
> +	return ret;
> +}
> +
> +/* conf->resync_lock should be held */
> +static int get_all_queued(struct r1conf *conf)
> +{
> +	int idx, ret;
> +
> +	for (ret =3D 0, idx =3D 0; idx < BARRIER_BUCKETS_NR; idx++)
> +		ret +=3D conf->nr_queued[idx];
> +	return ret;
> +}
> +
>  static void freeze_array(struct r1conf *conf, int extra)
>  {
> -	/* stop syncio and normal IO and wait for everything to
> +	/* Stop sync I/O and normal I/O and wait for everything to
>  	 * go quite.
> -	 * We wait until nr_pending match nr_queued+extra
> -	 * This is called in the context of one normal IO request
> -	 * that has failed. Thus any sync request that might be pending
> -	 * will be blocked by nr_pending, and we need to wait for
> -	 * pending IO requests to complete or be queued for re-try.
> -	 * Thus the number queued (nr_queued) plus this request (extra)
> -	 * must match the number of pending IOs (nr_pending) before
> -	 * we continue.
> +	 * This is called in two situations:
> +	 * 1) management command handlers (reshape, remove disk, quiesce).
> +	 * 2) one normal I/O request failed.
> +
> +	 * After array_frozen is set to 1, new sync IO will be blocked at
> +	 * raise_barrier(), and new normal I/O will blocked at _wait_barrier().
> +	 * The flying I/Os will either complete or be queued. When everything
> +	 * goes quite, there are only queued I/Os left.
> +
> +	 * Every flying I/O contributes to a conf->nr_pending[idx], idx is the
> +	 * barrier bucket index which this I/O request hits. When all sync and
> +	 * normal I/O are queued, sum of all conf->nr_pending[] will match sum
> +	 * of all conf->nr_queued[]. But normal I/O failure is an exception,
> +	 * in handle_read_error(), we may call freeze_array() before trying to
> +	 * fix the read error. In this case, the error read I/O is not queued,
> +	 * so get_all_pending() =3D=3D get_all_queued() + 1.
> +	 *
> +	 * Therefore before this function returns, we need to wait until
> +	 * get_all_pendings(conf) gets equal to get_all_queued(conf)+extra. For
> +	 * normal I/O context, extra is 1, in rested situations extra is 0.
>  	 */
>  	spin_lock_irq(&conf->resync_lock);
>  	conf->array_frozen =3D 1;
>  	raid1_log(conf->mddev, "wait freeze");
> -	wait_event_lock_irq_cmd(conf->wait_barrier,
> -				conf->nr_pending =3D=3D conf->nr_queued+extra,
> -				conf->resync_lock,
> -				flush_pending_writes(conf));
> +	wait_event_lock_irq_cmd(
> +		conf->wait_barrier,
> +		get_all_pendings(conf) =3D=3D get_all_queued(conf)+extra,
> +		conf->resync_lock,
> +		flush_pending_writes(conf));
>  	spin_unlock_irq(&conf->resync_lock);
>  }
>  static void unfreeze_array(struct r1conf *conf)
> @@ -1066,64 +1094,23 @@ static void raid1_unplug(struct blk_plug_cb *cb, =
bool from_schedule)
>  	kfree(plug);
>  }
>=20=20
> -static void raid1_make_request(struct mddev *mddev, struct bio * bio)
> +static void raid1_make_read_request(struct mddev *mddev, struct bio *bio)
>  {
>  	struct r1conf *conf =3D mddev->private;
>  	struct raid1_info *mirror;
>  	struct r1bio *r1_bio;
>  	struct bio *read_bio;
> -	int i, disks;
>  	struct bitmap *bitmap;
> -	unsigned long flags;
>  	const int op =3D bio_op(bio);
> -	const int rw =3D bio_data_dir(bio);
>  	const unsigned long do_sync =3D (bio->bi_opf & REQ_SYNC);
> -	const unsigned long do_flush_fua =3D (bio->bi_opf &
> -						(REQ_PREFLUSH | REQ_FUA));
> -	struct md_rdev *blocked_rdev;
> -	struct blk_plug_cb *cb;
> -	struct raid1_plug_cb *plug =3D NULL;
> -	int first_clone;
>  	int sectors_handled;
>  	int max_sectors;
> -	sector_t start_next_window;
> +	int rdisk;
>=20=20
> -	/*
> -	 * Register the new request and wait if the reconstruction
> -	 * thread has put up a bar for new requests.
> -	 * Continue immediately if no resync is active currently.
> +	/* Still need barrier for READ in case that whole
> +	 * array is frozen.
>  	 */
> -
> -	md_write_start(mddev, bio); /* wait on superblock update early */
> -
> -	if (bio_data_dir(bio) =3D=3D WRITE &&
> -	    ((bio_end_sector(bio) > mddev->suspend_lo &&
> -	    bio->bi_iter.bi_sector < mddev->suspend_hi) ||
> -	    (mddev_is_clustered(mddev) &&
> -	     md_cluster_ops->area_resyncing(mddev, WRITE,
> -		     bio->bi_iter.bi_sector, bio_end_sector(bio))))) {
> -		/* As the suspend_* range is controlled by
> -		 * userspace, we want an interruptible
> -		 * wait.
> -		 */
> -		DEFINE_WAIT(w);
> -		for (;;) {
> -			flush_signals(current);
> -			prepare_to_wait(&conf->wait_barrier,
> -					&w, TASK_INTERRUPTIBLE);
> -			if (bio_end_sector(bio) <=3D mddev->suspend_lo ||
> -			    bio->bi_iter.bi_sector >=3D mddev->suspend_hi ||
> -			    (mddev_is_clustered(mddev) &&
> -			     !md_cluster_ops->area_resyncing(mddev, WRITE,
> -				     bio->bi_iter.bi_sector, bio_end_sector(bio))))
> -				break;
> -			schedule();
> -		}
> -		finish_wait(&conf->wait_barrier, &w);
> -	}
> -
> -	start_next_window =3D wait_barrier(conf, bio);
> -
> +	wait_read_barrier(conf, bio->bi_iter.bi_sector);
>  	bitmap =3D mddev->bitmap;
>=20=20
>  	/*
> @@ -1149,12 +1136,9 @@ static void raid1_make_request(struct mddev *mddev=
, struct bio * bio)
>  	bio->bi_phys_segments =3D 0;
>  	bio_clear_flag(bio, BIO_SEG_VALID);
>=20=20
> -	if (rw =3D=3D READ) {
>  		/*
>  		 * read balancing logic:
>  		 */
> -		int rdisk;
> -
>  read_again:
>  		rdisk =3D read_balance(conf, r1_bio, &max_sectors);
>=20=20
> @@ -1176,7 +1160,6 @@ static void raid1_make_request(struct mddev *mddev,=
 struct bio * bio)
>  				   atomic_read(&bitmap->behind_writes) =3D=3D 0);
>  		}
>  		r1_bio->read_disk =3D rdisk;
> -		r1_bio->start_next_window =3D 0;
>=20=20
>  		read_bio =3D bio_clone_mddev(bio, GFP_NOIO, mddev);
>  		bio_trim(read_bio, r1_bio->sector - bio->bi_iter.bi_sector,
> @@ -1232,11 +1215,89 @@ static void raid1_make_request(struct mddev *mdde=
v, struct bio * bio)
>  		} else
>  			generic_make_request(read_bio);
>  		return;
> +}
> +
> +static void raid1_make_write_request(struct mddev *mddev, struct bio *bi=
o)
> +{
> +	struct r1conf *conf =3D mddev->private;
> +	struct r1bio *r1_bio;
> +	int i, disks;
> +	struct bitmap *bitmap;
> +	unsigned long flags;
> +	const int op =3D bio_op(bio);
> +	const unsigned long do_sync =3D (bio->bi_opf & REQ_SYNC);
> +	const unsigned long do_flush_fua =3D (bio->bi_opf &
> +						(REQ_PREFLUSH | REQ_FUA));
> +	struct md_rdev *blocked_rdev;
> +	struct blk_plug_cb *cb;
> +	struct raid1_plug_cb *plug =3D NULL;
> +	int first_clone;
> +	int sectors_handled;
> +	int max_sectors;
> +
> +	/*
> +	 * Register the new request and wait if the reconstruction
> +	 * thread has put up a bar for new requests.
> +	 * Continue immediately if no resync is active currently.
> +	 */
> +
> +	md_write_start(mddev, bio); /* wait on superblock update early */
> +
> +	if (((bio_end_sector(bio) > mddev->suspend_lo &&
> +	    bio->bi_iter.bi_sector < mddev->suspend_hi) ||
> +	    (mddev_is_clustered(mddev) &&
> +	     md_cluster_ops->area_resyncing(mddev, WRITE,
> +		     bio->bi_iter.bi_sector, bio_end_sector(bio))))) {
> +		/* As the suspend_* range is controlled by
> +		 * userspace, we want an interruptible
> +		 * wait.
> +		 */
> +		DEFINE_WAIT(w);
> +
> +		for (;;) {
> +			flush_signals(current);
> +			prepare_to_wait(&conf->wait_barrier,
> +					&w, TASK_INTERRUPTIBLE);
> +			if (bio_end_sector(bio) <=3D mddev->suspend_lo ||
> +			    bio->bi_iter.bi_sector >=3D mddev->suspend_hi ||
> +			    (mddev_is_clustered(mddev) &&
> +			     !md_cluster_ops->area_resyncing(
> +						mddev,
> +						WRITE,
> +						bio->bi_iter.bi_sector,
> +						bio_end_sector(bio))))
> +				break;
> +			schedule();
> +		}
> +		finish_wait(&conf->wait_barrier, &w);
>  	}
>=20=20
> +	wait_barrier(conf, bio->bi_iter.bi_sector);
> +	bitmap =3D mddev->bitmap;
> +
>  	/*
> -	 * WRITE:
> +	 * make_request() can abort the operation when read-ahead is being
> +	 * used and no empty request is available.
> +	 *
> +	 */
> +	r1_bio =3D mempool_alloc(conf->r1bio_pool, GFP_NOIO);
> +
> +	r1_bio->master_bio =3D bio;
> +	r1_bio->sectors =3D bio_sectors(bio);
> +	r1_bio->state =3D 0;
> +	r1_bio->mddev =3D mddev;
> +	r1_bio->sector =3D bio->bi_iter.bi_sector;
> +
> +	/* We might need to issue multiple reads to different
> +	 * devices if there are bad blocks around, so we keep
> +	 * track of the number of reads in bio->bi_phys_segments.
> +	 * If this is 0, there is only one r1_bio and no locking
> +	 * will be needed when requests complete.  If it is
> +	 * non-zero, then it is the number of not-completed requests.

This comment mentions "reads".  It should probably be changed to discuss
what happens to "writes" since this is raid1_make_write_request().

>  	 */
> +	bio->bi_phys_segments =3D 0;
> +	bio_clear_flag(bio, BIO_SEG_VALID);
> +
>  	if (conf->pending_count >=3D max_queued_requests) {
>  		md_wakeup_thread(mddev->thread);
>  		raid1_log(mddev, "wait queued");
> @@ -1256,7 +1317,6 @@ static void raid1_make_request(struct mddev *mddev,=
 struct bio * bio)
>=20=20
>  	disks =3D conf->raid_disks * 2;
>   retry_write:
> -	r1_bio->start_next_window =3D start_next_window;
>  	blocked_rdev =3D NULL;
>  	rcu_read_lock();
>  	max_sectors =3D r1_bio->sectors;
> @@ -1324,25 +1384,15 @@ static void raid1_make_request(struct mddev *mdde=
v, struct bio * bio)
>  	if (unlikely(blocked_rdev)) {
>  		/* Wait for this device to become unblocked */
>  		int j;
> -		sector_t old =3D start_next_window;
>=20=20
>  		for (j =3D 0; j < i; j++)
>  			if (r1_bio->bios[j])
>  				rdev_dec_pending(conf->mirrors[j].rdev, mddev);
>  		r1_bio->state =3D 0;
> -		allow_barrier(conf, start_next_window, bio->bi_iter.bi_sector);
> +		allow_barrier(conf, bio->bi_iter.bi_sector);
>  		raid1_log(mddev, "wait rdev %d blocked", blocked_rdev->raid_disk);
>  		md_wait_for_blocked_rdev(blocked_rdev, mddev);
> -		start_next_window =3D wait_barrier(conf, bio);
> -		/*
> -		 * We must make sure the multi r1bios of bio have
> -		 * the same value of bi_phys_segments
> -		 */
> -		if (bio->bi_phys_segments && old &&
> -		    old !=3D start_next_window)
> -			/* Wait for the former r1bio(s) to complete */
> -			wait_event(conf->wait_barrier,
> -				   bio->bi_phys_segments =3D=3D 1);
> +		wait_barrier(conf, bio->bi_iter.bi_sector);
>  		goto retry_write;
>  	}
>=20=20
> @@ -1464,6 +1514,31 @@ static void raid1_make_request(struct mddev *mddev=
, struct bio * bio)
>  	wake_up(&conf->wait_barrier);
>  }
>=20=20
> +static void raid1_make_request(struct mddev *mddev, struct bio *bio)
> +{
> +	void (*make_request_fn)(struct mddev *mddev, struct bio *bio);
> +	struct bio *split;
> +	sector_t sectors;
> +
> +	make_request_fn =3D (bio_data_dir(bio) =3D=3D READ) ?
> +			  raid1_make_read_request :
> +			  raid1_make_write_request;
> +
> +	/* if bio exceeds barrier unit boundary, split it */
> +	do {
> +		sectors =3D align_to_barrier_unit_end(bio->bi_iter.bi_sector,
> +						    bio_sectors(bio));
> +		if (sectors < bio_sectors(bio)) {
> +			split =3D bio_split(bio, sectors, GFP_NOIO, fs_bio_set);
> +			bio_chain(split, bio);
> +		} else {
> +			split =3D bio;
> +		}
> +
> +		make_request_fn(mddev, split);
> +	} while (split !=3D bio);
> +}
> +
>  static void raid1_status(struct seq_file *seq, struct mddev *mddev)
>  {
>  	struct r1conf *conf =3D mddev->private;
> @@ -1552,19 +1627,11 @@ static void print_conf(struct r1conf *conf)
>=20=20
>  static void close_sync(struct r1conf *conf)
>  {
> -	wait_barrier(conf, NULL);
> -	allow_barrier(conf, 0, 0);
> +	wait_all_barriers(conf);
> +	allow_all_barriers(conf);
>=20=20
>  	mempool_destroy(conf->r1buf_pool);
>  	conf->r1buf_pool =3D NULL;
> -
> -	spin_lock_irq(&conf->resync_lock);
> -	conf->next_resync =3D MaxSector - 2 * NEXT_NORMALIO_DISTANCE;
> -	conf->start_next_window =3D MaxSector;
> -	conf->current_window_requests +=3D
> -		conf->next_window_requests;
> -	conf->next_window_requests =3D 0;
> -	spin_unlock_irq(&conf->resync_lock);
>  }
>=20=20
>  static int raid1_spare_active(struct mddev *mddev)
> @@ -2311,8 +2378,9 @@ static void handle_sync_write_finished(struct r1con=
f *conf, struct r1bio *r1_bio
>=20=20
>  static void handle_write_finished(struct r1conf *conf, struct r1bio *r1_=
bio)
>  {
> -	int m;
> +	int m, idx;
>  	bool fail =3D false;
> +
>  	for (m =3D 0; m < conf->raid_disks * 2 ; m++)
>  		if (r1_bio->bios[m] =3D=3D IO_MADE_GOOD) {
>  			struct md_rdev *rdev =3D conf->mirrors[m].rdev;
> @@ -2338,7 +2406,8 @@ static void handle_write_finished(struct r1conf *co=
nf, struct r1bio *r1_bio)
>  	if (fail) {
>  		spin_lock_irq(&conf->device_lock);
>  		list_add(&r1_bio->retry_list, &conf->bio_end_io_list);
> -		conf->nr_queued++;
> +		idx =3D hash_long(r1_bio->sector, BARRIER_BUCKETS_NR_BITS);
> +		conf->nr_queued[idx]++;
>  		spin_unlock_irq(&conf->device_lock);
>  		md_wakeup_thread(conf->mddev->thread);
>  	} else {
> @@ -2460,6 +2529,7 @@ static void raid1d(struct md_thread *thread)
>  	struct r1conf *conf =3D mddev->private;
>  	struct list_head *head =3D &conf->retry_list;
>  	struct blk_plug plug;
> +	int idx;
>=20=20
>  	md_check_recovery(mddev);
>=20=20
> @@ -2467,17 +2537,18 @@ static void raid1d(struct md_thread *thread)
>  	    !test_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags)) {
>  		LIST_HEAD(tmp);
>  		spin_lock_irqsave(&conf->device_lock, flags);
> -		if (!test_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags)) {
> -			while (!list_empty(&conf->bio_end_io_list)) {
> -				list_move(conf->bio_end_io_list.prev, &tmp);
> -				conf->nr_queued--;
> -			}
> -		}
> +		if (!test_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags))
> +			list_splice_init(&conf->bio_end_io_list, &tmp);
>  		spin_unlock_irqrestore(&conf->device_lock, flags);
>  		while (!list_empty(&tmp)) {
>  			r1_bio =3D list_first_entry(&tmp, struct r1bio,
>  						  retry_list);
>  			list_del(&r1_bio->retry_list);
> +			idx =3D hash_long(r1_bio->sector,
> +					BARRIER_BUCKETS_NR_BITS);
> +			spin_lock_irqsave(&conf->device_lock, flags);
> +			conf->nr_queued[idx]--;
> +			spin_unlock_irqrestore(&conf->device_lock, flags);
>  			if (mddev->degraded)
>  				set_bit(R1BIO_Degraded, &r1_bio->state);
>  			if (test_bit(R1BIO_WriteError, &r1_bio->state))
> @@ -2498,7 +2569,8 @@ static void raid1d(struct md_thread *thread)
>  		}
>  		r1_bio =3D list_entry(head->prev, struct r1bio, retry_list);
>  		list_del(head->prev);
> -		conf->nr_queued--;
> +		idx =3D hash_long(r1_bio->sector, BARRIER_BUCKETS_NR_BITS);
> +		conf->nr_queued[idx]--;
>  		spin_unlock_irqrestore(&conf->device_lock, flags);
>=20=20
>  		mddev =3D r1_bio->mddev;
> @@ -2537,7 +2609,6 @@ static int init_resync(struct r1conf *conf)
>  					  conf->poolinfo);
>  	if (!conf->r1buf_pool)
>  		return -ENOMEM;
> -	conf->next_resync =3D 0;
>  	return 0;
>  }
>=20=20
> @@ -2566,6 +2637,7 @@ static sector_t raid1_sync_request(struct mddev *md=
dev, sector_t sector_nr,
>  	int still_degraded =3D 0;
>  	int good_sectors =3D RESYNC_SECTORS;
>  	int min_bad =3D 0; /* number of sectors that are bad in all devices */
> +	int idx =3D hash_long(sector_nr, BARRIER_BUCKETS_NR_BITS);
>=20=20
>  	if (!conf->r1buf_pool)
>  		if (init_resync(conf))
> @@ -2615,7 +2687,7 @@ static sector_t raid1_sync_request(struct mddev *md=
dev, sector_t sector_nr,
>  	 * If there is non-resync activity waiting for a turn, then let it
>  	 * though before starting on this new sync request.
>  	 */
> -	if (conf->nr_waiting)
> +	if (conf->nr_waiting[idx])
>  		schedule_timeout_uninterruptible(1);
>=20=20
>  	/* we are incrementing sector_nr below. To be safe, we check against
> @@ -2642,6 +2714,8 @@ static sector_t raid1_sync_request(struct mddev *md=
dev, sector_t sector_nr,
>  	r1_bio->sector =3D sector_nr;
>  	r1_bio->state =3D 0;
>  	set_bit(R1BIO_IsSync, &r1_bio->state);
> +	/* make sure good_sectors won't go across barrier unit boundary */
> +	good_sectors =3D align_to_barrier_unit_end(sector_nr, good_sectors);
>=20=20
>  	for (i =3D 0; i < conf->raid_disks * 2; i++) {
>  		struct md_rdev *rdev;
> @@ -2927,9 +3001,6 @@ static struct r1conf *setup_conf(struct mddev *mdde=
v)
>  	conf->pending_count =3D 0;
>  	conf->recovery_disabled =3D mddev->recovery_disabled - 1;
>=20=20
> -	conf->start_next_window =3D MaxSector;
> -	conf->current_window_requests =3D conf->next_window_requests =3D 0;
> -
>  	err =3D -EIO;
>  	for (i =3D 0; i < conf->raid_disks * 2; i++) {
>=20=20
> diff --git a/drivers/md/raid1.h b/drivers/md/raid1.h
> index c52ef42..817115d 100644
> --- a/drivers/md/raid1.h
> +++ b/drivers/md/raid1.h
> @@ -1,6 +1,14 @@
>  #ifndef _RAID1_H
>  #define _RAID1_H
>=20=20
> +/* each barrier unit size is 64MB fow now
> + * note: it must be larger than RESYNC_DEPTH
> + */
> +#define BARRIER_UNIT_SECTOR_BITS	17
> +#define BARRIER_UNIT_SECTOR_SIZE	(1<<17)
> +#define BARRIER_BUCKETS_NR_BITS		9
> +#define BARRIER_BUCKETS_NR		(1<<BARRIER_BUCKETS_NR_BITS)
> +
>  struct raid1_info {
>  	struct md_rdev	*rdev;
>  	sector_t	head_position;
> @@ -35,25 +43,6 @@ struct r1conf {
>  						 */
>  	int			raid_disks;
>=20=20
> -	/* During resync, read_balancing is only allowed on the part
> -	 * of the array that has been resynced.  'next_resync' tells us
> -	 * where that is.
> -	 */
> -	sector_t		next_resync;
> -
> -	/* When raid1 starts resync, we divide array into four partitions
> -	 * |---------|--------------|---------------------|-------------|
> -	 *        next_resync   start_next_window       end_window
> -	 * start_next_window =3D next_resync + NEXT_NORMALIO_DISTANCE
> -	 * end_window =3D start_next_window + NEXT_NORMALIO_DISTANCE
> -	 * current_window_requests means the count of normalIO between
> -	 *   start_next_window and end_window.
> -	 * next_window_requests means the count of normalIO after end_window.
> -	 * */
> -	sector_t		start_next_window;
> -	int			current_window_requests;
> -	int			next_window_requests;
> -
>  	spinlock_t		device_lock;
>=20=20
>  	/* list of 'struct r1bio' that need to be processed by raid1d,
> @@ -79,10 +68,11 @@ struct r1conf {
>  	 */
>  	wait_queue_head_t	wait_barrier;
>  	spinlock_t		resync_lock;
> -	int			nr_pending;
> -	int			nr_waiting;
> -	int			nr_queued;
> -	int			barrier;
> +	int			nr_pending[BARRIER_BUCKETS_NR];
> +	int			nr_waiting[BARRIER_BUCKETS_NR];
> +	int			nr_queued[BARRIER_BUCKETS_NR];
> +	int			barrier[BARRIER_BUCKETS_NR];
> +	int			total_barriers;
>  	int			array_frozen;
>=20=20
>  	/* Set to 1 if a full sync is needed, (fresh device added).
> @@ -135,7 +125,6 @@ struct r1bio {
>  						 * in this BehindIO request
>  						 */
>  	sector_t		sector;
> -	sector_t		start_next_window;
>  	int			sectors;
>  	unsigned long		state;
>  	struct mddev		*mddev;
> --=20
> 2.6.6


Thanks,
NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlhu0dIACgkQOeye3VZi
gbmXsg//baGk536TUO61BZqEiwT+tV/guMBYX3ug0TeAzIdxsf8NyMEM2AM8yTx7
attBcDgPfy8Ao7Wf7cB96+p413oId1Eg7L/CxsudxrFGEd2R+ToN6qWl5KTwj6i/
36rJlGdUVCJLExqaSqXVuSbqT7Ci4tIv0Xqz7ui3zx3oZcRaVfu49oqBLkH+9MFk
H+EkKFQ84eMnKNJpPW+SjPhnvThExIDXUwVWGycXz7udQxnvHYUtikbI5FpBRkHp
M221D5xVnUcTtoloaoBImB8APBM8V8Hg3uMXct5VJtLJKfuPy03QHiMCS8k2aKCj
A9y2yVN5ftXaZ8xCD7cgCSkNVWQWE4O6mYFz2qBRFGZbFizE+o+rNleEFV/0Z+UF
juQ5Q52VkunR9DF1vg8pcpLqxWOnox/gg8DCNvG6VPT6wSXkmgmh3bcYfkFJb+Xw
A1RdG5vZOvzVrA6rYWyzY30dLXcSw5bs/Ss2HrEuiDZzh/OX3mpi6qFDJHHQZIMz
yFnsVYiudf9IxtWwHr8Ikb7FYTc0QILFjCFnpBfcy2ly+fcoKTNxPsNAG0RFkFED
I0rYpc7vB2GcRshd9WJUUKDCWNSDF+h51+PSfaHljxpSVbel3Ggd6xkDKTTvh50Q
7ccRKAX82OXNRhxndFxNu4xY+apc3xxVTE7zY3iXd5GWcLrcb3k=
=CTMc
-----END PGP SIGNATURE-----
--=-=-=--
