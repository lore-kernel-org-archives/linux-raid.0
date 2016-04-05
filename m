From: Ming Lei <tom.leiming@gmail.com>
Subject: Re: [PATCH 11/27] bcache: io.c: use bio_set_vec_table
Date: Tue, 5 Apr 2016 23:24:30 +0800
Message-ID: <CACVXFVN+SfQ=mkdKeAMmPrkzQtrYcNxDPrT6bxNjC==xnuaxhg@mail.gmail.com>
References: <1459857443-20611-1-git-send-email-tom.leiming@gmail.com>
	<1459857443-20611-12-git-send-email-tom.leiming@gmail.com>
	<20160405124902.GA11986@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20160405124902.GA11986@infradead.org>
Sender: linux-raid-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Jens Axboe <axboe@fb.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-block@vger.kernel.org, Boaz Harrosh <boaz@plexistor.com>, Kent Overstreet <kent.overstreet@gmail.com>, Shaohua Li <shli@kernel.org>, "open list:BCACHE (BLOCK LAYER CACHE)" <linux-bcache@vger.kernel.org>, "open list:SOFTWARE RAID (Multiple Disks) SUPPORT" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, Apr 5, 2016 at 8:49 PM, Christoph Hellwig <hch@infradead.org> wrote:
> On Tue, Apr 05, 2016 at 07:56:56PM +0800, Ming Lei wrote:
>> diff --git a/drivers/md/bcache/io.c b/drivers/md/bcache/io.c
>> index 86a0bb8..1c48462 100644
>> --- a/drivers/md/bcache/io.c
>> +++ b/drivers/md/bcache/io.c
>> @@ -26,8 +26,7 @@ struct bio *bch_bbio_alloc(struct cache_set *c)
>>
>>       bio_init(bio);
>>       bio->bi_flags           |= BIO_POOL_NONE << BIO_POOL_OFFSET;
>> -     bio->bi_max_vecs         = bucket_pages(c);
>> -     bio->bi_io_vec           = bio->bi_inline_vecs;
>> +     bio_set_vec_table(bio, bio->bi_inline_vecs, bucket_pages(c));
>
> All this bcache code needs to move away from bio_init on a bio
> embedded in a driver private structure toward properly using
> bio_alloc / bio_alloc_bioset.  That will also fix the crash
> with bcache over md that Shaohua reported, so I'd suggest to fast
> track this part of the series.

I suggest to keep this usage for the following reasons:

- bio can be embedded into one biger instance, which is often allocated
dynamically, so one extra allocation for bio can be avoided.

- we should support arbitrary bio size by this way, at least bio_add_page()
supports this usage.  Also code gets lots of simplication with arbitrary bio
size support, such as prio_io(): bcache

BTW, the root cause for bcache crash still isn't clear now because
blk_bio_segment_split() should split big bio into proper size with
all queue's limits. Maybe the max segment limit isn't figured out correctly.

Thanks,
Ming Lei
