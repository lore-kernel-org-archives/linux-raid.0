From: Ming Lei <tom.leiming@gmail.com>
Subject: Re: [PATCH 02/17] block: introduce bio_remove_last_page()
Date: Thu, 16 Feb 2017 21:30:45 +0800
Message-ID: <CACVXFVPPifd4ktKnCb6v+44dwUOyN6cTNiQp5zT82r9XzP_z1A@mail.gmail.com>
References: <1487245547-24384-1-git-send-email-tom.leiming@gmail.com>
 <1487245547-24384-3-git-send-email-tom.leiming@gmail.com> <b443b3a1-ecc9-8238-1b3d-90870a25c793@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <b443b3a1-ecc9-8238-1b3d-90870a25c793@suse.de>
Sender: linux-block-owner@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: Shaohua Li <shli@kernel.org>, Jens Axboe <axboe@fb.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "open list:SOFTWARE RAID (Multiple Disks) SUPPORT" <linux-raid@vger.kernel.org>, linux-block <linux-block@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>, NeilBrown <neilb@suse.com>
List-Id: linux-raid.ids

On Thu, Feb 16, 2017 at 8:08 PM, Johannes Thumshirn <jthumshirn@suse.de> wrote:
> On 02/16/2017 12:45 PM, Ming Lei wrote:
>> MD need this helper to remove the last added page, so introduce
>> it.
>>
>> Signed-off-by: Ming Lei <tom.leiming@gmail.com>
>> ---
>>  block/bio.c         | 23 +++++++++++++++++++++++
>>  include/linux/bio.h |  1 +
>>  2 files changed, 24 insertions(+)
>>
>> diff --git a/block/bio.c b/block/bio.c
>> index 5eec5e08417f..0ce7ffcd7939 100644
>> --- a/block/bio.c
>> +++ b/block/bio.c
>> @@ -837,6 +837,29 @@ int bio_add_pc_page(struct request_queue *q, struct bio *bio, struct page
>>  EXPORT_SYMBOL(bio_add_pc_page);
>>
>>  /**
>> + *   bio_remove_last_page    -       remove the last added page
>> + *   @bio: destination bio
>> + *
>> + *   Attempt to remove the last added page from the bio_vec maplist.
>> + */
>> +void bio_remove_last_page(struct bio *bio)
>> +{
>> +     /*
>> +      * cloned bio must not modify vec list
>> +      */
>> +     if (WARN_ON_ONCE(bio_flagged(bio, BIO_CLONED)))
>> +             return;
>> +
>> +     if (bio->bi_vcnt > 0) {
>
> In patch 1 you introduce bio_segments_all() with the log message 'So
> that we can replace the direct access to .bi_vcnt.' Here you introduce a
> new direct access to it (plus the duplicated WARN_ON_ONCE()).
>
> Maybe use the helper directly here (I admit I haven't gone through the
> whole series yet, so I can't see if the change is made later).

Firstly MD does need one helper to remove the last added page, as you
can see there are three such uses in patch3.

Secondly both the two helpers will be changed once multipage bvec
is supported, that means we have to change MD too after multipage bvec
if just using bio_segments_all() to replace .bi_vcnt for removing
the last added page.



Thanks,
Ming Lei
