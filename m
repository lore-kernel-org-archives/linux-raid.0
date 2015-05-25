From: Ming Lin <mlin@kernel.org>
Subject: Re: [PATCH v4 06/11] md/raid5: get rid of bio_fits_rdev()
Date: Mon, 25 May 2015 00:03:20 -0700
Message-ID: <CAF1ivSY+ky5PD=m34KXU4z9gE_v4uztaFT=MuU4g69DtXD9vWA@mail.gmail.com>
References: <1432318723-18829-1-git-send-email-mlin@kernel.org>
	<1432318723-18829-7-git-send-email-mlin@kernel.org>
	<20150525154829.4330f149@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150525154829.4330f149@notabene.brown>
Sender: linux-kernel-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: lkml <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Kent Overstreet <kent.overstreet@gmail.com>, Jens Axboe <axboe@kernel.dk>, Dongsu Park <dpark@posteo.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, May 24, 2015 at 10:48 PM, NeilBrown <neilb@suse.de> wrote:
> On Fri, 22 May 2015 11:18:38 -0700 Ming Lin <mlin@kernel.org> wrote:
>
>> From: Kent Overstreet <kent.overstreet@gmail.com>
>>
>> Remove bio_fits_rdev() completely, because ->merge_bvec_fn() has now
>> gone. There's no point in calling bio_fits_rdev() only for ensuring
>> aligned read from rdev.
>
> Surely this patch should come *before*
>   [PATCH v4 07/11] md/raid5: split bio for chunk_aligned_read

PATCH 6, then PATCH 7, isn't it already *before*?

>
> and the comment says ->merge_bvec_fn() has gone, but that isn't until
>   [PATCH v4 08/11] block: kill merge_bvec_fn() completely
>
>
> If those issues are resolved, then

How about this?

PATCH 6: md/raid5: split bio for chunk_aligned_read
PATCH 7: block: kill merge_bvec_fn() completely
PATCH 8: md/raid5: get rid of bio_fits_rdev()

Thanks.

>
>   Acked-by: NeilBrown <neilb@suse.de>
>
> Thanks,
> NeilBrown
>
>
>>
>> Cc: Neil Brown <neilb@suse.de>
>> Cc: linux-raid@vger.kernel.org
>> Signed-off-by: Kent Overstreet <kent.overstreet@gmail.com>
>> [dpark: add more description in commit message]
>> Signed-off-by: Dongsu Park <dpark@posteo.net>
>> Signed-off-by: Ming Lin <mlin@kernel.org>
>> ---
>>  drivers/md/raid5.c | 23 +----------------------
>>  1 file changed, 1 insertion(+), 22 deletions(-)
>>
>> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
>> index 1ba97fd..b303ded 100644
>> --- a/drivers/md/raid5.c
>> +++ b/drivers/md/raid5.c
>> @@ -4743,25 +4743,6 @@ static void raid5_align_endio(struct bio *bi, int error)
>>       add_bio_to_retry(raid_bi, conf);
>>  }
>>
>> -static int bio_fits_rdev(struct bio *bi)
>> -{
>> -     struct request_queue *q = bdev_get_queue(bi->bi_bdev);
>> -
>> -     if (bio_sectors(bi) > queue_max_sectors(q))
>> -             return 0;
>> -     blk_recount_segments(q, bi);
>> -     if (bi->bi_phys_segments > queue_max_segments(q))
>> -             return 0;
>> -
>> -     if (q->merge_bvec_fn)
>> -             /* it's too hard to apply the merge_bvec_fn at this stage,
>> -              * just just give up
>> -              */
>> -             return 0;
>> -
>> -     return 1;
>> -}
>> -
>>  static int chunk_aligned_read(struct mddev *mddev, struct bio * raid_bio)
>>  {
>>       struct r5conf *conf = mddev->private;
>> @@ -4815,11 +4796,9 @@ static int chunk_aligned_read(struct mddev *mddev, struct bio * raid_bio)
>>               align_bi->bi_bdev =  rdev->bdev;
>>               __clear_bit(BIO_SEG_VALID, &align_bi->bi_flags);
>>
>> -             if (!bio_fits_rdev(align_bi) ||
>> -                 is_badblock(rdev, align_bi->bi_iter.bi_sector,
>> +             if (is_badblock(rdev, align_bi->bi_iter.bi_sector,
>>                               bio_sectors(align_bi),
>>                               &first_bad, &bad_sectors)) {
>> -                     /* too big in some way, or has a known bad block */
>>                       bio_put(align_bi);
>>                       rdev_dec_pending(rdev, mddev);
>>                       return 0;
>
