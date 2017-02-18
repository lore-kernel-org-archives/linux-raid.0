From: Coly Li <colyli@suse.de>
Subject: Re: [PATCH V3 1/2] RAID1: a new I/O barrier implementation to remove
 resync window
Date: Sat, 18 Feb 2017 10:40:35 +0800
Message-ID: <8be07d2a-1611-4552-9af8-946b8002b577@suse.de>
References: <1487176523-109075-1-git-send-email-colyli@suse.de>
 <87shnevcpr.fsf@notabene.neil.brown.name>
 <20170217194117.cgbdm247p5p4gj6v@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170217194117.cgbdm247p5p4gj6v@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>, NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, Shaohua Li <shli@fb.com>, Johannes Thumshirn <jthumshirn@suse.de>, Guoqing Jiang <gqjiang@suse.com>
List-Id: linux-raid.ids

On 2017/2/18 上午3:41, Shaohua Li wrote:
> On Thu, Feb 16, 2017 at 06:04:00PM +1100, NeilBrown wrote:

[snip]
>>> @@ -1447,36 +1501,26 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
>>>  
>>>  static void raid1_make_request(struct mddev *mddev, struct bio *bio)
>>>  {
>>> -	struct r1conf *conf = mddev->private;
>>> -	struct r1bio *r1_bio;
>>> +	void (*make_request_fn)(struct mddev *mddev, struct bio *bio);
>>> +	struct bio *split;
>>> +	sector_t sectors;
>>>  
>>> -	/*
>>> -	 * make_request() can abort the operation when read-ahead is being
>>> -	 * used and no empty request is available.
>>> -	 *
>>> -	 */
>>> -	r1_bio = mempool_alloc(conf->r1bio_pool, GFP_NOIO);
>>> +	make_request_fn = (bio_data_dir(bio) == READ) ?
>>> +			  raid1_read_request : raid1_write_request;
>>>  
>>> -	r1_bio->master_bio = bio;
>>> -	r1_bio->sectors = bio_sectors(bio);
>>> -	r1_bio->state = 0;
>>> -	r1_bio->mddev = mddev;
>>> -	r1_bio->sector = bio->bi_iter.bi_sector;
>>> -
>>> -	/*
>>> -	 * We might need to issue multiple reads to different devices if there
>>> -	 * are bad blocks around, so we keep track of the number of reads in
>>> -	 * bio->bi_phys_segments.  If this is 0, there is only one r1_bio and
>>> -	 * no locking will be needed when requests complete.  If it is
>>> -	 * non-zero, then it is the number of not-completed requests.
>>> -	 */
>>> -	bio->bi_phys_segments = 0;
>>> -	bio_clear_flag(bio, BIO_SEG_VALID);
>>> +	/* if bio exceeds barrier unit boundary, split it */
>>> +	do {
>>> +		sectors = align_to_barrier_unit_end(
>>> +				bio->bi_iter.bi_sector, bio_sectors(bio));
>>> +		if (sectors < bio_sectors(bio)) {
>>> +			split = bio_split(bio, sectors, GFP_NOIO, fs_bio_set);
>>> +			bio_chain(split, bio);
>>> +		} else {
>>> +			split = bio;
>>> +		}
>>>  
>>> -	if (bio_data_dir(bio) == READ)
>>> -		raid1_read_request(mddev, bio, r1_bio);
>>> -	else
>>> -		raid1_write_request(mddev, bio, r1_bio);
>>> +		make_request_fn(mddev, split);
>>> +	} while (split != bio);
>>>  }
>>
>> I know you are going to change this as Shaohua wantsthe spitting
>> to happen in a separate function, which I agree with, but there is
>> something else wrong here.
>> Calling bio_split/bio_chain repeatedly in a loop is dangerous.
>> It is OK for simple devices, but when one request can wait for another
>> request to the same device it can deadlock.
>> This can happen with raid1.  If a resync request calls raise_barrier()
>> between one request and the next, then the next has to wait for the
>> resync request, which has to wait for the first request.
>> As the first request will be stuck in the queue in
>> generic_make_request(), you get a deadlock.
>> It is much safer to:
>>
>>     if (need to split) {
>>         split = bio_split(bio, ...)
>>         bio_chain(...)
>>         make_request_fn(split);
>>         generic_make_request(bio);
>>    } else
>>         make_request_fn(mddev, bio);
>>
>> This way we first process the initial section of the bio (in 'split')
>> which will queue some requests to the underlying devices.  These
>> requests will be queued in generic_make_request.
>> Then we queue the remainder of the bio, which will be added to the end
>> of the generic_make_request queue.
>> Then we return.
>> generic_make_request() will pop the lower-level device requests off the
>> queue and handle them first.  Then it will process the remainder
>> of the original bio once the first section has been fully processed.
> 
> Good point! raid10 has the same problem. Looks this doesn't solve the issue for
> device with 3 times stack though.
> 
> I knew you guys are working on this issue in block layer. Should we fix the
> issue in MD side (for 2 stack devices) or wait for the block layer patch?

Obviously I don't get the point at all ... Could you please explain a
little more about why it is an issue and how it may happen ? Thanks a
lot :-)

Coly

