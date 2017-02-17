From: Coly Li <colyli@suse.de>
Subject: Re: [PATCH V3 1/2] RAID1: a new I/O barrier implementation to remove
 resync window
Date: Fri, 17 Feb 2017 14:56:47 +0800
Message-ID: <2f6b3d68-1536-3167-7362-78fdfa91e149@suse.de>
References: <1487176523-109075-1-git-send-email-colyli@suse.de>
 <87shnevcpr.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87shnevcpr.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org
Cc: Shaohua Li <shli@fb.com>, Johannes Thumshirn <jthumshirn@suse.de>, Guoqing Jiang <gqjiang@suse.com>
List-Id: linux-raid.ids

On 2017/2/16 下午3:04, NeilBrown wrote:
> On Thu, Feb 16 2017, colyli@suse.de wrote:

[snip]
>> - I/O barrier bucket is indexed by bio start sector If multiple
>> I/O requests hit different I/O barrier units, they only need to
>> compete I/O barrier with other I/Os which hit the same I/O
>> barrier bucket index with each other. The index of a barrier
>> bucket which a bio should look for is calculated by
>> sector_to_idx() which is defined in raid1.h as an inline
>> function, static inline int sector_to_idx(sector_t sector) { 
>> return hash_long(sector >> BARRIER_UNIT_SECTOR_BITS, 
>> BARRIER_BUCKETS_NR_BITS); } Here sector_nr is the start sector
>> number of a bio.
> 
> "hash_long() is used so that sequential writes in are region of
> the array which is not being resynced will not consistently align
> with the buckets that are being sequentially resynced, as described
> below"

Sorry, this sentence is too long to be understood by me ... Could you
please to use some simple and short sentence ?


[snip]
>> There are two changes should be noticed, - In raid1d(), I change
>> the code to decrease conf->nr_pending[idx] into single loop, it
>> looks like this, spin_lock_irqsave(&conf->device_lock, flags); 
>> conf->nr_queued[idx]--; 
>> spin_unlock_irqrestore(&conf->device_lock, flags); This change
>> generates more spin lock operations, but in next patch of this
>> patch set, it will be replaced by a single line code, 
>> atomic_dec(&conf->nr_queueud[idx]); So we don't need to worry
>> about spin lock cost here. - Mainline raid1 code split original
>> raid1_make_request() into raid1_read_request() and
>> raid1_write_request(). If the original bio goes across an I/O
>> barrier unit size, this bio will be split before calling
>> raid1_read_request() or raid1_write_request(),  this change the
>> code logic more simple and clear. - In this patch wait_barrier()
>> is moved from raid1_make_request() to raid1_write_request(). In
>> raid_read_request(), original wait_barrier() is replaced by
>> raid1_read_request(). The differnece is wait_read_barrier() only
>> waits if array is frozen, using different barrier function in
>> different code path makes the code more clean and easy to read.
> 
> Thank you for putting the effort into writing a comprehensve
> change description.  I really appreciate it.

Neil, thank you so much. I fix all the above typos in next version,
once I understand that long sentence I will include it in the patch
comments too.


>> 
>> @@ -1447,36 +1501,26 @@ static void raid1_write_request(struct
>> mddev *mddev, struct bio *bio,
>> 
>> static void raid1_make_request(struct mddev *mddev, struct bio
>> *bio) { -	struct r1conf *conf = mddev->private; -	struct r1bio
>> *r1_bio; +	void (*make_request_fn)(struct mddev *mddev, struct
>> bio *bio); +	struct bio *split; +	sector_t sectors;
>> 
>> -	/* -	 * make_request() can abort the operation when read-ahead
>> is being -	 * used and no empty request is available. -	 * -	 */ 
>> -	r1_bio = mempool_alloc(conf->r1bio_pool, GFP_NOIO); +
>> make_request_fn = (bio_data_dir(bio) == READ) ? +
>> raid1_read_request : raid1_write_request;
>> 
>> -	r1_bio->master_bio = bio; -	r1_bio->sectors =
>> bio_sectors(bio); -	r1_bio->state = 0; -	r1_bio->mddev = mddev; -
>> r1_bio->sector = bio->bi_iter.bi_sector; - -	/* -	 * We might
>> need to issue multiple reads to different devices if there -	 *
>> are bad blocks around, so we keep track of the number of reads
>> in -	 * bio->bi_phys_segments.  If this is 0, there is only one
>> r1_bio and -	 * no locking will be needed when requests complete.
>> If it is -	 * non-zero, then it is the number of not-completed
>> requests. -	 */ -	bio->bi_phys_segments = 0; -
>> bio_clear_flag(bio, BIO_SEG_VALID); +	/* if bio exceeds barrier
>> unit boundary, split it */ +	do { +		sectors =
>> align_to_barrier_unit_end( +				bio->bi_iter.bi_sector,
>> bio_sectors(bio)); +		if (sectors < bio_sectors(bio)) { +			split
>> = bio_split(bio, sectors, GFP_NOIO, fs_bio_set); +
>> bio_chain(split, bio); +		} else { +			split = bio; +		}
>> 
>> -	if (bio_data_dir(bio) == READ) -		raid1_read_request(mddev,
>> bio, r1_bio); -	else -		raid1_write_request(mddev, bio, r1_bio); 
>> +		make_request_fn(mddev, split); +	} while (split != bio); }
> 
> I know you are going to change this as Shaohua wantsthe spitting to
> happen in a separate function, which I agree with, but there is 
> something else wrong here. Calling bio_split/bio_chain repeatedly
> in a loop is dangerous. It is OK for simple devices, but when one
> request can wait for another request to the same device it can
> deadlock. This can happen with raid1.  If a resync request calls
> raise_barrier() between one request and the next, then the next has
> to wait for the resync request, which has to wait for the first
> request. As the first request will be stuck in the queue in 
> generic_make_request(), you get a deadlock.

For md raid1, queue in generic_make_request(), can I understand it as
bio_list_on_stack in this function? And queue in underlying device,
can I understand it as the data structures like plug->pending and
conf->pending_bio_list ?

I still don't get the point of deadlock, let me try to explain why I
don't see the possible deadlock. If a bio is split, and the first part
is processed by make_request_fn(), and then a resync comes and it will
raise a barrier, there are 3 possible conditions,
- the resync I/O tries to raise barrier on same bucket of the first
regular bio. Then the resync task has to wait to the first bio drops
its conf->nr_pending[idx]
- the resync I/O hits a barrier bucket not related to the first split
regular I/O or the second split regular I/O, no one will be blocked.
- the resync I/O hits the same barrier bucket which the second split
regular bio will access, then the barrier is raised and second split
bio will be blocked, but the first split regular I/O will continue to
go ahead.

The first and the second split bios won't hit same I/O barrier bucket,
and a single resync bio may only be interfered with one of the split
regular I/O. This is why I don't see how the deadlock comes.


And one more question is, even there is only one I/O barrier bucket, I
don't understand how the first split regular I/O will be stuck in the
queue in generic_make_request(), I assume the queue is
bio_list_on_stack. If the first split bio is stuck in
generic_make_request() I can understand there is a deadlock, but I
don't see why it may be blocked there. Could you please to give me
more hint ?


> It is much safer to:
> 
> if (need to split) { split = bio_split(bio, ...) bio_chain(...) 
> make_request_fn(split); generic_make_request(bio); } else 
> make_request_fn(mddev, bio);
> 
> This way we first process the initial section of the bio (in
> 'split') which will queue some requests to the underlying devices.
> These requests will be queued in generic_make_request. Then we
> queue the remainder of the bio, which will be added to the end of
> the generic_make_request queue. Then we return. 
> generic_make_request() will pop the lower-level device requests off
> the queue and handle them first.  Then it will process the
> remainder of the original bio once the first section has been fully
> processed.

Do you mean before the first split bio being fully processed, the
second split bio should not be sent to the underlying device ? If this
is what I understand, it seems the split bio won't be merged into
large request in underlying device, it might be a tiny performance lost ?

Coly


