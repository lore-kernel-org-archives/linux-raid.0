From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH V3 1/2] RAID1: a new I/O barrier implementation to remove
 resync window
Date: Fri, 17 Feb 2017 11:41:17 -0800
Message-ID: <20170217194117.cgbdm247p5p4gj6v@kernel.org>
References: <1487176523-109075-1-git-send-email-colyli@suse.de>
 <87shnevcpr.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87shnevcpr.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: colyli@suse.de, linux-raid@vger.kernel.org, Shaohua Li <shli@fb.com>, Johannes Thumshirn <jthumshirn@suse.de>, Guoqing Jiang <gqjiang@suse.com>
List-Id: linux-raid.ids

On Thu, Feb 16, 2017 at 06:04:00PM +1100, NeilBrown wrote:
> On Thu, Feb 16 2017, colyli@suse.de wrote:
> 
> > 'Commit 79ef3a8aa1cb ("raid1: Rewrite the implementation of iobarrier.")'
> > introduces a sliding resync window for raid1 I/O barrier, this idea limits
> > I/O barriers to happen only inside a slidingresync window, for regular
> > I/Os out of this resync window they don't need to wait for barrier any
> > more. On large raid1 device, it helps a lot to improve parallel writing
> > I/O throughput when there are background resync I/Os performing at
> > same time.
> >
> > The idea of sliding resync widow is awesome, but code complexity is a
> > challenge. Sliding resync window requires several veriables to work
> 
> variables
> 
> > collectively, this is complexed and very hard to make it work correctly.
> > Just grep "Fixes: 79ef3a8aa1" in kernel git log, there are 8 more patches
> > to fix the original resync window patch. This is not the end, any further
> > related modification may easily introduce more regreassion.
> >
> > Therefore I decide to implement a much simpler raid1 I/O barrier, by
> > removing resync window code, I believe life will be much easier.
> >
> > The brief idea of the simpler barrier is,
> >  - Do not maintain a logbal unique resync window
> 
> global
> 
> >  - Use multiple hash buckets to reduce I/O barrier conflictions, regular
> 
> conflicts
> 
> >    I/O only has to wait for a resync I/O when both them have same barrier
> >    bucket index, vice versa.
> >  - I/O barrier can be recuded to an acceptable number if there are enought
> 
> reduced
> enough
> 
> >    barrier buckets
> >
> > Here I explain how the barrier buckets are designed,
> >  - BARRIER_UNIT_SECTOR_SIZE
> >    The whole LBA address space of a raid1 device is divided into multiple
> >    barrier units, by the size of BARRIER_UNIT_SECTOR_SIZE.
> >    Bio request won't go across border of barrier unit size, that means
> 
> requests
> 
> >    maximum bio size is BARRIER_UNIT_SECTOR_SIZE<<9 (64MB) in bytes.
> >    For random I/O 64MB is large enough for both read and write requests,
> >    for sequential I/O considering underlying block layer may merge them
> >    into larger requests, 64MB is still good enough.
> >    Neil also points out that for resync operation, "we want the resync to
> >    move from region to region fairly quickly so that the slowness caused
> >    by having to synchronize with the resync is averaged out over a fairly
> >    small time frame". For full speed resync, 64MB should take less then 1
> >    second. When resync is competing with other I/O, it could take up a few
> >    minutes. Therefore 64MB size is fairly good range for resync.
> >
> >  - BARRIER_BUCKETS_NR
> >    There are BARRIER_BUCKETS_NR buckets in total, which is defined by,
> >         #define BARRIER_BUCKETS_NR_BITS   (PAGE_SHIFT - 2)
> >         #define BARRIER_BUCKETS_NR        (1<<BARRIER_BUCKETS_NR_BITS)
> >    this patch makes the bellowed members of struct r1conf from integer
> >    to array of integers,
> >         -       int                     nr_pending;
> >         -       int                     nr_waiting;
> >         -       int                     nr_queued;
> >         -       int                     barrier;
> >         +       int                     *nr_pending;
> >         +       int                     *nr_waiting;
> >         +       int                     *nr_queued;
> >         +       int                     *barrier;
> >    number of the array elements is defined as BARRIER_BUCKETS_NR. For 4KB
> >    kernel space page size, (PAGE_SHIFT - 2) indecates there are 1024 I/O
> >    barrier buckets, and each array of integers occupies single memory page.
> >    1024 means for a request which is smaller than the I/O barrier unit size
> >    has ~0.1% chance to wait for resync to pause, which is quite a small
> >    enough fraction. Also requesting single memory page is more friendly to
> >    kernel page allocator than larger memory size.
> >
> >  - I/O barrier bucket is indexed by bio start sector
> >    If multiple I/O requests hit different I/O barrier units, they only need
> >    to compete I/O barrier with other I/Os which hit the same I/O barrier
> >    bucket index with each other. The index of a barrier bucket which a
> >    bio should look for is calculated by sector_to_idx() which is defined
> >    in raid1.h as an inline function,
> >         static inline int sector_to_idx(sector_t sector)
> >         {
> >                 return hash_long(sector >> BARRIER_UNIT_SECTOR_BITS,
> >                                 BARRIER_BUCKETS_NR_BITS);
> >         }
> >    Here sector_nr is the start sector number of a bio.
> 
> "hash_long() is used so that sequential writes in are region of the
> array which is not being resynced will not consistently align with
> the buckets that are being sequentially resynced, as described below"
> 
> >
> >  - Single bio won't go across boundary of a I/O barrier unit
> >    If a request goes across boundary of barrier unit, it will be split. A
> >    bio may be split in raid1_make_request() or raid1_sync_request(), if
> >    sectors returned by align_to_barrier_unit_end() is small than original
> 
> smaller
> 
> >    bio size.
> >
> > Comparing to single sliding resync window,
> >  - Currently resync I/O grows linearly, therefore regular and resync I/O
> >    will have confliction within a single barrier units. So the I/O
> 
> ... will conflict within ...
> 
> >    behavior is similar to single sliding resync window.
> >  - But a barrier unit bucket is shared by all barrier units with identical
> >    barrier uinit index, the probability of confliction might be higher
> >    than single sliding resync window, in condition that writing I/Os
> >    always hit barrier units which have identical barrier bucket indexs with
> >    the resync I/Os. This is a very rare condition in real I/O work loads,
> >    I cannot imagine how it could happen in practice.
> >  - Therefore we can achieve a good enough low confliction rate with much
> 
> ... low conflict rate ...
> 
> >    simpler barrier algorithm and implementation.
> >
> > There are two changes should be noticed,
> >  - In raid1d(), I change the code to decrease conf->nr_pending[idx] into
> >    single loop, it looks like this,
> >         spin_lock_irqsave(&conf->device_lock, flags);
> >         conf->nr_queued[idx]--;
> >         spin_unlock_irqrestore(&conf->device_lock, flags);
> >    This change generates more spin lock operations, but in next patch of
> >    this patch set, it will be replaced by a single line code,
> >         atomic_dec(&conf->nr_queueud[idx]);
> >    So we don't need to worry about spin lock cost here.
> >  - Mainline raid1 code split original raid1_make_request() into
> >    raid1_read_request() and raid1_write_request(). If the original bio
> >    goes across an I/O barrier unit size, this bio will be split before
> >    calling raid1_read_request() or raid1_write_request(),  this change
> >    the code logic more simple and clear.
> >  - In this patch wait_barrier() is moved from raid1_make_request() to
> >    raid1_write_request(). In raid_read_request(), original wait_barrier()
> >    is replaced by raid1_read_request().
> >    The differnece is wait_read_barrier() only waits if array is frozen,
> >    using different barrier function in different code path makes the code
> >    more clean and easy to read.
> 
> Thank you for putting the effort into writing a comprehensve change
> description.  I really appreciate it.
> 
> >  
> > @@ -1447,36 +1501,26 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
> >  
> >  static void raid1_make_request(struct mddev *mddev, struct bio *bio)
> >  {
> > -	struct r1conf *conf = mddev->private;
> > -	struct r1bio *r1_bio;
> > +	void (*make_request_fn)(struct mddev *mddev, struct bio *bio);
> > +	struct bio *split;
> > +	sector_t sectors;
> >  
> > -	/*
> > -	 * make_request() can abort the operation when read-ahead is being
> > -	 * used and no empty request is available.
> > -	 *
> > -	 */
> > -	r1_bio = mempool_alloc(conf->r1bio_pool, GFP_NOIO);
> > +	make_request_fn = (bio_data_dir(bio) == READ) ?
> > +			  raid1_read_request : raid1_write_request;
> >  
> > -	r1_bio->master_bio = bio;
> > -	r1_bio->sectors = bio_sectors(bio);
> > -	r1_bio->state = 0;
> > -	r1_bio->mddev = mddev;
> > -	r1_bio->sector = bio->bi_iter.bi_sector;
> > -
> > -	/*
> > -	 * We might need to issue multiple reads to different devices if there
> > -	 * are bad blocks around, so we keep track of the number of reads in
> > -	 * bio->bi_phys_segments.  If this is 0, there is only one r1_bio and
> > -	 * no locking will be needed when requests complete.  If it is
> > -	 * non-zero, then it is the number of not-completed requests.
> > -	 */
> > -	bio->bi_phys_segments = 0;
> > -	bio_clear_flag(bio, BIO_SEG_VALID);
> > +	/* if bio exceeds barrier unit boundary, split it */
> > +	do {
> > +		sectors = align_to_barrier_unit_end(
> > +				bio->bi_iter.bi_sector, bio_sectors(bio));
> > +		if (sectors < bio_sectors(bio)) {
> > +			split = bio_split(bio, sectors, GFP_NOIO, fs_bio_set);
> > +			bio_chain(split, bio);
> > +		} else {
> > +			split = bio;
> > +		}
> >  
> > -	if (bio_data_dir(bio) == READ)
> > -		raid1_read_request(mddev, bio, r1_bio);
> > -	else
> > -		raid1_write_request(mddev, bio, r1_bio);
> > +		make_request_fn(mddev, split);
> > +	} while (split != bio);
> >  }
> 
> I know you are going to change this as Shaohua wantsthe spitting
> to happen in a separate function, which I agree with, but there is
> something else wrong here.
> Calling bio_split/bio_chain repeatedly in a loop is dangerous.
> It is OK for simple devices, but when one request can wait for another
> request to the same device it can deadlock.
> This can happen with raid1.  If a resync request calls raise_barrier()
> between one request and the next, then the next has to wait for the
> resync request, which has to wait for the first request.
> As the first request will be stuck in the queue in
> generic_make_request(), you get a deadlock.
> It is much safer to:
> 
>     if (need to split) {
>         split = bio_split(bio, ...)
>         bio_chain(...)
>         make_request_fn(split);
>         generic_make_request(bio);
>    } else
>         make_request_fn(mddev, bio);
> 
> This way we first process the initial section of the bio (in 'split')
> which will queue some requests to the underlying devices.  These
> requests will be queued in generic_make_request.
> Then we queue the remainder of the bio, which will be added to the end
> of the generic_make_request queue.
> Then we return.
> generic_make_request() will pop the lower-level device requests off the
> queue and handle them first.  Then it will process the remainder
> of the original bio once the first section has been fully processed.

Good point! raid10 has the same problem. Looks this doesn't solve the issue for
device with 3 times stack though.

I knew you guys are working on this issue in block layer. Should we fix the
issue in MD side (for 2 stack devices) or wait for the block layer patch?

Thanks,
Shaohua 
