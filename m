From: Coly Li <colyli@suse.de>
Subject: Re: [PATCH V3 1/2] RAID1: a new I/O barrier implementation to remove
 resync window
Date: Fri, 17 Feb 2017 20:40:25 +0800
Message-ID: <c13d9735-b700-4154-623d-594605fe4559@suse.de>
References: <1487176523-109075-1-git-send-email-colyli@suse.de>
 <20170216022222.73xmrd7lujkpns2x@kernel.org>
 <b54e3798-4cdc-e1d3-a11e-625290131d37@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <b54e3798-4cdc-e1d3-a11e-625290131d37@suse.de>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org, Shaohua Li <shli@fb.com>, Neil Brown <neilb@suse.de>, Johannes Thumshirn <jthumshirn@suse.de>, Guoqing Jiang <gqjiang@suse.com>
List-Id: linux-raid.ids

On 2017/2/17 上午1:05, Coly Li wrote:
> On 2017/2/16 上午10:22, Shaohua Li wrote:
>> On Thu, Feb 16, 2017 at 12:35:22AM +0800, colyli@suse.de wrote:

[snip]
>>
>>>  
>>> -static void raid1_read_request(struct mddev *mddev, struct bio *bio,
>>> -				 struct r1bio *r1_bio)
>>> +static void raid1_read_request(struct mddev *mddev, struct bio *bio)
>>>  {
>>>  	struct r1conf *conf = mddev->private;
>>>  	struct raid1_info *mirror;
>>> +	struct r1bio *r1_bio;
>>>  	struct bio *read_bio;
>>>  	struct bitmap *bitmap = mddev->bitmap;
>>>  	const int op = bio_op(bio);
>>> @@ -1083,7 +1101,34 @@ static void raid1_read_request(struct mddev *mddev, struct bio *bio,
>>>  	int max_sectors;
>>>  	int rdisk;
>>>  
>>> -	wait_barrier(conf, bio);
>>> +	/*
>>> +	 * Still need barrier for READ in case that whole
>>> +	 * array is frozen.
>>> +	 */
>>> +	wait_read_barrier(conf, bio->bi_iter.bi_sector);
>>> +	bitmap = mddev->bitmap;
>>> +
>>> +	/*
>>> +	 * make_request() can abort the operation when read-ahead is being
>>> +	 * used and no empty request is available.
>>> +	 *
>>> +	 */
>>> +	r1_bio = mempool_alloc(conf->r1bio_pool, GFP_NOIO);
>>> +	r1_bio->master_bio = bio;
>>> +	r1_bio->sectors = bio_sectors(bio);
>>> +	r1_bio->state = 0;
>>> +	r1_bio->mddev = mddev;
>>> +	r1_bio->sector = bio->bi_iter.bi_sector;
>>
>> This part looks unnecessary complicated. If you change raid1_make_request to
>> something like __raid1_make_reques, add a new raid1_make_request and do bio
>> split there, then call __raid1_make_request for each splitted bio, then you
>> don't need to duplicate the r1_bio allocation parts for read/write.
>>
> 
> Aha, good point! I will do that.

I find adding one more wrap function increases stack depth in raid1 I/O
path. Finally I choose to use a static inline function to allocate
r1bio, other than wrap one more function.


+static inline struct r1bio *
+alloc_r1bio(struct mddev *mddev, struct bio *bio, sector_t sectors_handled)
+{
+       struct r1conf *conf = mddev->private;
+       struct r1bio *r1_bio = NULL;
+
+
+       r1_bio = mempool_alloc(conf->r1bio_pool, GFP_NOIO);
+       if (!r1_bio) {
+               WARN(1, "%s: fail to allocate r1_bio.\n", __func__);
+               return NULL;
+       }
+
+       r1_bio->master_bio = bio;
+       r1_bio->sectors = bio_sectors(bio) - sectors_handled;
+       r1_bio->state = 0;
+       r1_bio->mddev = mddev;
+       r1_bio->sector = bio->bi_iter.bi_sector + sectors_handled;
+
+       return r1_bio;
+}

A good point is, before jumping to read_again in raid1_read_request() or
jumping to retry_write in raid1_write_request(), this function can help
to remove more redundant code like this,
	r1_bio = alloc_r1bio(mddev, bio, sectors_handled);

I don't check whether alloc_r1bio() returns NULL in neither
raid1_read_request() nor raid1_write_request(). If the allocation
failed, it may cause a NULL pointer deference fault, but I don't plan to
fix it in this patch set, just keep the existing code logic.

Coly


