From: Coly Li <colyli@suse.de>
Subject: Re: [RFC PATCH 1/2] RAID1: a new I/O barrier implementation to remove
 resync window
Date: Mon, 28 Nov 2016 14:59:44 +0800
Message-ID: <c419c6fb-346f-9926-697c-fd823fb99d3e@suse.de>
References: <1479765241-15528-1-git-send-email-colyli@suse.de>
 <20161122213541.btgw4cpoly5j4jpc@kernel.org>
 <871sy1bfd9.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <871sy1bfd9.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: Shaohua Li <shli@kernel.org>, linux-raid@vger.kernel.org, Shaohua Li <shli@fb.com>, Neil Brown <neilb@suse.de>, Johannes Thumshirn <jthumshirn@suse.de>, Guoqing Jiang <gqjiang@suse.com>
List-Id: linux-raid.ids

On 2016/11/24 下午1:45, NeilBrown wrote:
> On Wed, Nov 23 2016, Shaohua Li wrote:
>> 
>> Thanks! The idea is awesome and does makes the code easier to
>> understand.
> 
> This is a key point - simpler code!!
> 
>> 
>> For hash conflict, I'm worrying about one case. resync does
>> sequential access. Say we have a sequential normal IO. If the
>> first normal IO and resync IO have conflict, it's possible they
>> will have conflict subsequently, since both are doing sequential
>> access. We can change the hash to something like this:
>> 
>> for the first 64M * 512, the hash is 0, 1, ... 511 For the second
>> 64M * 512, the hash is 1, 3, 5 ... The third 64M * 512, the hash
>> is 2, 5, 8 ...
> 
> This would happen when the write and the resync are at different 
> addresses which happen to collide in the hash. They would only
> remain in sync if the two proceeded at the same speed. Normally
> resync is throttled when there is competing IO, so that is fairly
> unlikely.
> 
> If this really was important, it might make sense to just use 
> hash_long() to make the relevant bits of the sector number into
> and index. (i.e. keep the code simple)
> 
>>> 
>>> If user has a (realy) large raid1 device, for example 10PB
>>> size, we may just increase the buckets number
>>> BARRIER_BUCKETS_NR. Now this is a macro, it is possible to be a
>>> raid1-created-time-defined variable in future.
> 
> I don't think the size of the array is very relevant.  No matter
> how big the array is, resync can be expected to directly interfere
> with 0.2% of all writes.  So, assuming a fairly random distribution
> over times, most writes will most often not be blocked by resync at
> all.
> 
> I wouldn't give any thought to any problems like this until they
> are actually measured.
> 

Yes, I agree with you. If we do have to use more buckets in future,
current patch makes future modification easier.


>>> static void reschedule_retry(struct r1bio *r1_bio) @@ -215,10
>>> +214,15 @@ static void reschedule_retry(struct r1bi unsigned
>>> long flags; struct mddev *mddev = r1_bio->mddev; struct r1conf
>>> *conf = mddev->private; +	sector_t sector_nr; +	long idx;
> 
> I wonder about the use of "long" for "idx". As that is an array
> index, it would have to be a REALLY big array before "long" is
> better than "int".
> 

Good suggestion! I will modify it to int in next version.


>>> @@ -255,19 +257,14 @@ static void call_bio_endio(struct r1bio 
>>> if (!test_bit(R1BIO_Uptodate, &r1_bio->state)) bio->bi_error =
>>> -EIO;
>>> 
>>> -	if (done) { +	if (done) bio_endio(bio); -		/* -		 * Wake up
>>> any possible resync thread that waits for the device -		 * to
>>> go idle. -		 */ -		allow_barrier(conf, start_next_window,
>>> bi_sector); -	} }
>>> 
>>> static void raid_end_bio_io(struct r1bio *r1_bio) { struct bio
>>> *bio = r1_bio->master_bio; +	struct r1conf *conf =
>>> r1_bio->mddev->private;
>>> 
>>> /* if nobody has done the final endio yet, do it now */ if
>>> (!test_and_set_bit(R1BIO_Returned, &r1_bio->state)) { @@ -278,6
>>> +275,12 @@ static void raid_end_bio_io(struct r1bio
>>> 
>>> call_bio_endio(r1_bio); } + +	/* +	 * Wake up any possible
>>> resync thread that waits for the device +	 * to go idle. +	 */ 
>>> +	allow_barrier(conf, r1_bio->sector);
>> Why this change?
> 
> I wondered too.  I think it may be correct, but it should be in a 
> separate patch. When you have a write-mostly device, I think the
> current code will allow_barrier() before the writes to the
> write-mostly devices have completed.
> 

I explain this in the reply to Shaohua's email. Current upstream code
increases/decreases conf->nr_pending for each bio (a.k.a
r1_bio->master_bio) received by raid1_make_request(). In this patch,
conf->nr_pending[idx] increases/decreases for each r1_bio, this is the
reason why allow_barrier() moves to raid1_end_bio_io(), you may also
find out wait_barrier() also changes its location and is replaced by
wait_barrier() and wait_read_barrier() in raid1_make_request().

>>> 
>>> +static sector_t align_to_barrier_unit_end(sector_t
>>> start_sector, +					  sector_t sectors) +{ +	sector_t len; + +
>>> WARN_ON(sectors == 0); +	/* len is the number of sectors from
>>> start_sector to end of the +	 * barrier unit which start_sector
>>> belongs to. +	 */ +	len = ((start_sector + sectors +
>>> (1<<BARRIER_UNIT_SECTOR_BITS) - 1) & +
>>> (~(BARRIER_UNIT_SECTOR_SIZE - 1))) - +	      start_sector; + +
>>> if (len > sectors) +		len = sectors; + +	return len; +}
>> 
>> I'd prefer calling bio_split at the early of raid1_make_request
>> and split the bio if it crosses the bucket boundary. please see
>> raid10_make_request for example. resync will not cross the
>> boundary. So the code will not need to worry about the boundary.
>> I believe this will make the code simpiler (all the 
>> align_to_barrier_unit_end calling can removed) and easy to
>> understand.
> 
> align_to_barrier_unit_end() is only called twice, once for writes
> and once for resync/recovery.  If bio_split() were used, you would
> still need the same number of calls.
> 
> Changing raid1.c to use bio_split() more may well be a valuable 
> simplification, but I think it is a separate issue.
> 

To use bio_split() won't be simpler, indeed it is a little bit more
complexed, because when r1_bio->master_bio will be the split bio of
master bio, not the original master bio, that's why I decide to not
use it.


>>> wait_event_lock_irq(conf->wait_barrier, -
>>> !conf->array_frozen && -			    conf->barrier < RESYNC_DEPTH && 
>>> -			    conf->current_window_requests == 0 && -
>>> (conf->start_next_window >= -			     conf->next_resync +
>>> RESYNC_SECTORS), +			    !conf->array_frozen &&
>>> !conf->nr_pending[idx] && +			    conf->barrier[idx] <
>>> RESYNC_DEPTH, conf->resync_lock);
>> 
>> So there is a slight behavior change. Originally we guarautee no
>> more than RESYNC_DEPTH sync. Now this only checks
>> 'conf->barrier[idx] < RESYNC_DEPTH'. How about barrier[idx-1],
>> barrier[idx-2]...? It's possible conf->barrier[idx] < 
>> RESYNC_DEPTH, but barrier[idx] + barrier[idx-1] > RESYNC_DEPTH.
>> Not sure how important this is, but at least we can check
>> barrier[idx] + barrier[idx-1].
> 
> I confess that I'm not entirely sure the point of RESYNC_DEPTH - it
> was already in the code when I started working on it. My best guess
> is that it limits the number of requests we need to wait for before
> regular writes can be permitted in the resync region. In that case,
> the current code is good enough.
> 
> Your "barrier[idx] + barrier[idx-1]" idea is interesting, but would
> only make a difference 1/1024 of the time (bucket is 64Meg, the 
> RESYNC_BLOCK_SIZE is 64K).
> 
> 

IMHO RESYNC_DEPTH is for better resync throughput, since now we have
linear resync, and only one resync window, I doubt whether it takes
effect or not. Now only one resync sliding window, therefore it is
very similar for testing the resync depth within the sliding window,
or within a single barrier bucket. A resync I/O won't hit more then
one barrier bucket now.

In future when parallel resync implemented, the modification here may
increase whole raid1 device resync depth to BARRIER_BUCKETS_NR *
RESYNC_DEPTH, which results better resync I/O when regular I/O is idle.



>>> + +static void wait_all_barriers(struct r1conf *conf) +{ +	long
>>> idx; + +	for (idx = 0; idx < BARRIER_BUCKETS_NR; idx++) +
>>> _wait_barrier(conf, idx);
>> 
>> This is racy. Since resync is sequential, idealy we only need to
>> check the bucket sequentially. The compiler could do
>> _wait_barrier(conf, 1) and then _wait_barrier(conf, 0). It's
>> possible the bucket 1 has barrier right after the check of bucket
>> 0. Even the compiler doesn't reorder, there is case the bucket 
>> 511 should be check before bucket 0 if the resync is just
>> crossing 512 buckets. It would be better we check the resync
>> position and adjust the bucket wait order according to the
>> position.
> 
> I cannot see how it is racy.  No new sync requests will be issued
> at this time, so once ->barrier[idx] reaches 0, it will stay at
> zero.
> 

Yes, this is what I mean.


>>> @@ -2786,6 +2824,22 @@ static struct r1conf *setup_conf(struct 
>>> if (!conf) goto abort;
>>> 
>>> +	conf->nr_pending = kzalloc(PAGE_SIZE, GFP_KERNEL); +	if
>>> (!conf->nr_pending) +		goto abort;
>> 
>> This allocation is a little wierd. I'd define a count and uses 
>> sizeof(nr_pending) * count to do the allocation. There is nothing
>> related to PAGE_SIZE. Alternatively, just make nr_pending an
>> array in r1conf.
> 
> The thing about PAGE_SIZE is that the allocation will succeed and
> won't waste space. If you make all the arrays simple members of
> r1conf, r1conf will be about 4pages larger, so will require an
> 8-page allocation, which is more likely to fail. I agree that it
> seems a little weird, but I think it results in the best use of
> memory.

Yes, this is what I mean.

Thanks for your comments!

Coly



