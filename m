From: Ming Lin <mlin@kernel.org>
Subject: Re: [PATCH] md/raid10: make sync_request_write() call bio_copy_data()
Date: Mon, 27 Apr 2015 00:29:50 -0700
Message-ID: <CAF1ivSbivZ=FxRH9sxA1qVoGp-C84bNWrUfrM4qvA7P=Q2+pYQ@mail.gmail.com>
References: <1429915930-22449-1-git-send-email-mlin@kernel.org>
	<20150427094911.0f71b986@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20150427094911.0f71b986@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>, linux-raid@vger.kernel.org, Kent Overstreet <kent.overstreet@gmail.com>, Dongsu Park <dongsu.park@profitbricks.com>
List-Id: linux-raid.ids

On Sun, Apr 26, 2015 at 4:49 PM, NeilBrown <neilb@suse.de> wrote:
> On Fri, 24 Apr 2015 15:52:10 -0700 Ming Lin <mlin@kernel.org> wrote:
>
>> From: Kent Overstreet <kent.overstreet@gmail.com>
>>
>> Refactor sync_request_write() of md/raid10 to use bio_copy_data()
>> instead of open coding bio_vec iterations.
>>
>> Reviewed-by: Christoph Hellwig <hch@lst.de>
>> Signed-off-by: Kent Overstreet <kent.overstreet@gmail.com>
>> [dpark: add more description in commit message]
>> Signed-off-by: Dongsu Park <dongsu.park@profitbricks.com>
>> Signed-off-by: Ming Lin <mlin@kernel.org>
>> ---
>>  drivers/md/raid10.c | 20 +++++---------------
>>  1 file changed, 5 insertions(+), 15 deletions(-)
>>
>> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
>> index a7196c4..02e33f1 100644
>> --- a/drivers/md/raid10.c
>> +++ b/drivers/md/raid10.c
>> @@ -2097,18 +2097,11 @@ static void sync_request_write(struct mddev *mddev, struct r10bio *r10_bio)
>>               tbio->bi_vcnt = vcnt;
>>               tbio->bi_iter.bi_size = r10_bio->sectors << 9;
>>               tbio->bi_rw = WRITE;
>> -             tbio->bi_private = r10_bio;
>>               tbio->bi_iter.bi_sector = r10_bio->devs[i].addr;
>> -
>> -             for (j=0; j < vcnt ; j++) {
>> -                     tbio->bi_io_vec[j].bv_offset = 0;
>> -                     tbio->bi_io_vec[j].bv_len = PAGE_SIZE;
>> -
>> -                     memcpy(page_address(tbio->bi_io_vec[j].bv_page),
>> -                            page_address(fbio->bi_io_vec[j].bv_page),
>> -                            PAGE_SIZE);
>> -             }
>
> You removed the resetting of bv_offset and bv_len.
> So I assume this is being applied in a context where these things are now
> immutable - is that correct?

Correct. The full patchset is here:
https://git.kernel.org/cgit/linux/kernel/git/mlin/linux.git/log/?h=block-generic-req

I'll rebase it on top of 4.1-rc1, then post it.

>
>>               tbio->bi_end_io = end_sync_write;
>> +             tbio->bi_private = r10_bio;
>
> Any reason you are moving this assignment to bi_private?
> It doesn't hurt, but it doesn't seem to be necessary.

I'll update it to where it was.

>
>
>> +
>> +             bio_copy_data(tbio, fbio);
>>
>>               d = r10_bio->devs[i].devnum;
>>               atomic_inc(&conf->mirrors[d].rdev->nr_pending);
>> @@ -2124,17 +2117,14 @@ static void sync_request_write(struct mddev *mddev, struct r10bio *r10_bio)
>>        * that are active
>>        */
>>       for (i = 0; i < conf->copies; i++) {
>> -             int j, d;
>> +             int d;
>>
>>               tbio = r10_bio->devs[i].repl_bio;
>>               if (!tbio || !tbio->bi_end_io)
>>                       continue;
>>               if (r10_bio->devs[i].bio->bi_end_io != end_sync_write
>>                   && r10_bio->devs[i].bio != fbio)
>> -                     for (j = 0; j < vcnt; j++)
>> -                             memcpy(page_address(tbio->bi_io_vec[j].bv_page),
>> -                                    page_address(fbio->bi_io_vec[j].bv_page),
>> -                                    PAGE_SIZE);
>> +                     bio_copy_data(tbio, fbio);
>>               d = r10_bio->devs[i].devnum;
>>               atomic_inc(&r10_bio->remaining);
>>               md_sync_acct(conf->mirrors[d].replacement->bdev,
>
> Providing you are confident that bv_offset and bv_len don't need to be
> updated:
>
>  Acked-by: NeilBrown <neilb@suse.de>
>
> though I'd prefer the bi_private assignment was left where it was.

Will update it.

Thanks.

>
> Thanks,
> NeilBrown
>
