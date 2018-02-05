From: yuyufen <yuyufen@huawei.com>
Subject: Re: [RFC PATCH] md raid10: fix NULL deference in
 handle_write_completed()
Date: Mon, 5 Feb 2018 17:01:43 +0800
Message-ID: <96ac22a2-5dae-9bcf-45c5-3c726e2644a1@huawei.com>
References: <20180205042343.17235-1-yuyufen@huawei.com>
 <87d11kovgg.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87d11kovgg.fsf@notabene.neil.brown.name>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>, shli@kernel.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On 2018/2/5 13:29, NeilBrown wrote:
> On Mon, Feb 05 2018, Yufen Yu wrote:
>
>> When an io error in recovery, end_sync_write will set R10BIO_WriteError.
>> After reschedule_retry(), this r10_bio will be inserted to retry_list,
>> and progressed by handle_write_completed(), which will traverse all
>> r10_bio->devs[]. If devs[m].repl_bio != NULL, it thinks
>> conf->mirrors[dev].replacement is also not NULL.
>> In fact, it is not true, resulting in replacement NULL deference.
>>
>> For example,
>> in raid10, only rdev[1] has replacement, rdev[0], rdev[2] and rdev[3]
>> don't have replacement. And, r10buf_pool_alloc() will allocate
>> repl_bio for every r10bio. raid10_sync_request() gets a r10bio from
>> the pool. But, it doesn't pay attention to repl_bio for
>> read bio(r10bio->devs[0], rdev[2]), or sets repl_bio=NULL in
>> write bio(r10bio->devs[1], rdev[3]), if replacement == NULL.
>>
>> Signed-off-by: Yufen Yu <yuyufen@huawei.com>
> Thanks for this.  You're analysis is correct.
> This bug was introduced when replacement support for raid10 was added
> in Linux 3.3, so
>
> Fixes: 9ad1aefc8ae8 ("md/raid10:  Handle replacement devices during resync.")
>
> I'm not sure you patch is correct though.  Just because rdev is not NULL
> and bio is not NULL, that doesn't mean we tried to write - particularly
> in the 'recover' case.
>
> Elsewhere the determination of "is this device part of the
> resync/recovery" is made by resting bio->bi_end_io.
> If this is end_sync_write, then we tried to write here.
> If it is NULL, then we didn't try to write.
>
> So I think a correct patch would be more like.
>
>   if (r10_bio->devs[m].bio == NULL ||
>       r10_bio->devs[m].bio->bi_end_io == NULL)
>           continue;
Thanks for your suggest. I think you are right and I will resend a patch.

Thanks a lot,
Yufen Yu

> Thanks,
> NeilBrown
>
>
>> ---
>>   drivers/md/raid10.c | 4 ++--
>>   1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
>> index 99c9207899a7..9cbc1a193c8e 100644
>> --- a/drivers/md/raid10.c
>> +++ b/drivers/md/raid10.c
>> @@ -2655,7 +2655,7 @@ static void handle_write_completed(struct r10conf *conf, struct r10bio *r10_bio)
>>   		for (m = 0; m < conf->copies; m++) {
>>   			int dev = r10_bio->devs[m].devnum;
>>   			rdev = conf->mirrors[dev].rdev;
>> -			if (r10_bio->devs[m].bio == NULL)
>> +			if (rdev == NULL || r10_bio->devs[m].bio == NULL)
>>   				continue;
>>   			if (!r10_bio->devs[m].bio->bi_status) {
>>   				rdev_clear_badblocks(
>> @@ -2670,7 +2670,7 @@ static void handle_write_completed(struct r10conf *conf, struct r10bio *r10_bio)
>>   					md_error(conf->mddev, rdev);
>>   			}
>>   			rdev = conf->mirrors[dev].replacement;
>> -			if (r10_bio->devs[m].repl_bio == NULL)
>> +			if (rdev == NULL || r10_bio->devs[m].repl_bio == NULL)
>>   				continue;
>>   
>>   			if (!r10_bio->devs[m].repl_bio->bi_status) {
>> -- 
>> 2.13.6
.

