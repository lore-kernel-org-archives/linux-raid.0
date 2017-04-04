From: Michael Wang <yun.wang@profitbricks.com>
Subject: Re: [RFC PATCH] blk: reset 'bi_next' when bio is done inside request
Date: Tue, 4 Apr 2017 10:13:05 +0200
Message-ID: <9be3ca00-d802-bf64-bcdc-1e76608147f0@profitbricks.com>
References: <9505ff12-7307-7dec-76b5-2a233a592634@profitbricks.com>
 <877f31kwti.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <877f31kwti.fsf@notabene.neil.brown.name>
Sender: linux-block-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-block@vger.kernel.org, linux-raid@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, Shaohua Li <shli@kernel.org>, Jinpu Wang <jinpu.wang@profitbricks.com>
List-Id: linux-raid.ids

Hi, Neil

On 04/03/2017 11:25 PM, NeilBrown wrote:
> On Mon, Apr 03 2017, Michael Wang wrote:
> 
>> blk_attempt_plug_merge() try to merge bio into request and chain them
>> by 'bi_next', while after the bio is done inside request, we forgot to
>> reset the 'bi_next'.
>>
>> This lead into BUG while removing all the underlying devices from md-raid1,
>> the bio once go through:
>>
>>   md_do_sync()
>>     sync_request()
>>       generic_make_request()
> 
> This is a read request from the "first" device.
> 
>>         blk_queue_bio()
>>           blk_attempt_plug_merge()
>>             CHAINED HERE
>>
>> will keep chained and reused by:
>>
>>   raid1d()
>>     sync_request_write()
>>       generic_make_request()
> 
> This is a write request to some other device, isn't it?
> 
> If sync_request_write() is using a bio that has already been used, it
> should call bio_reset() and fill in the details again.
> However I don't see how that would happen.
> Can you give specific details on the situation that triggers the bug?

We have storage side mapping lv through scst to server, on server side
we assemble them into multipath device, and then assemble these dm into
two raid1.

The test is firstly do mkfs.ext4 on raid1 then start fio on it, on storage
side we unmap all the lv (could during mkfs or fio), then on server side
we hit the BUG (reproducible).

The path of bio was confirmed by add tracing, it is reused in sync_request_write()
with 'bi_next' once chained inside blk_attempt_plug_merge().

We also tried to reset the bi_next inside sync_request_write() before
generic_make_request() which also works.

The testing was done with 4.4, but we found upstream also left bi_next
chained after done in request, thus we post this RFC.

Regarding raid1, we haven't found the place on path where the bio was
reset... where does it supposed to be?

BTW the fix_sync_read_error() also invoked and succeed before trigger
the BUG.

Regards,
Michael Wang

> 
> Thanks,
> NeilBrown
> 
> 
>>         BUG_ON(bio->bi_next)
>>
>> After reset the 'bi_next' this can no longer happen.
>>
>> Signed-off-by: Michael Wang <yun.wang@profitbricks.com>
>> ---
>>  block/blk-core.c | 4 +++-
>>  1 file changed, 3 insertions(+), 1 deletion(-)
>>
>> diff --git a/block/blk-core.c b/block/blk-core.c
>> index 43b7d06..91223b2 100644
>> --- a/block/blk-core.c
>> +++ b/block/blk-core.c
>> @@ -2619,8 +2619,10 @@ bool blk_update_request(struct request *req, int error, unsigned int nr_bytes)
>>                 struct bio *bio = req->bio;
>>                 unsigned bio_bytes = min(bio->bi_iter.bi_size, nr_bytes);
>>
>> -               if (bio_bytes == bio->bi_iter.bi_size)
>> +               if (bio_bytes == bio->bi_iter.bi_size) {
>>                         req->bio = bio->bi_next;
>> +                       bio->bi_next = NULL;
>> +               }
>>
>>                 req_bio_endio(req, bio, bio_bytes, error);
>>
>> -- 
>> 2.5.0
