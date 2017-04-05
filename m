From: Michael Wang <yun.wang@profitbricks.com>
Subject: Re: [RFC PATCH] raid1: reset 'bi_next' before reuse the bio
Date: Wed, 5 Apr 2017 09:40:10 +0200
Message-ID: <465f2653-3afc-3329-dbf4-af13010113b7@profitbricks.com>
References: <dcd33b53-5c6f-3ebc-8c07-04f0c0372796@profitbricks.com>
 <87shlnizqn.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <87shlnizqn.fsf@notabene.neil.brown.name>
Sender: linux-kernel-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>, linux-raid@vger.kernel.org, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Shaohua Li <shli@kernel.org>, Jinpu Wang <jinpu.wang@profitbricks.com>
List-Id: linux-raid.ids



On 04/05/2017 12:17 AM, NeilBrown wrote:
[snip]
>> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
>> index 7d67235..0554110 100644
>> --- a/drivers/md/raid1.c
>> +++ b/drivers/md/raid1.c
>> @@ -1986,11 +1986,13 @@ static int fix_sync_read_error(struct r1bio *r1_bio)
>>  		/* Don't try recovering from here - just fail it
>>  		 * ... unless it is the last working device of course */
>>  		md_error(mddev, rdev);
>> -		if (test_bit(Faulty, &rdev->flags))
>> +		if (test_bit(Faulty, &rdev->flags)) {
>>  			/* Don't try to read from here, but make sure
>>  			 * put_buf does it's thing
>>  			 */
>>  			bio->bi_end_io = end_sync_write;
>> +			bio->bi_next = NULL;
>> +		}
>>  	}
>>  
>>  	while(sectors) {
> 
> 
> Ah - I see what is happening now.  I was looking at the vanilla 4.4
> code, which doesn't have the failfast changes.

My bad to forgot mention... yes our md stuff is very much close to the
upstream.

> 
> I don't think your patch is correct though.  We really shouldn't be
> re-using that bio, and setting bi_next to NULL just hides the bug.  It
> doesn't fix it.
> As the rdev is now Faulty, it doesn't make sense for
> sync_request_write() to submit a write request to it.

Make sense, while still have concerns regarding the design:
  * in this case since the read_disk already abandoned, is it fine to
    keep r1_bio->read_disk recording the faulty device index?
  * we assign the 'end_sync_write' to the original read bio in this
    case, but when is this supposed to be called?

> 
> Can you confirm that this works please.

Yes, it works.

Tested-by: Michael Wang <yun.wang@profitbricks.com>

Regards,
Michael Wang

> 
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index d2d8b8a5bd56..219f1e1f1d1d 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -2180,6 +2180,8 @@ static void sync_request_write(struct mddev *mddev, struct r1bio *r1_bio)
>  		     (i == r1_bio->read_disk ||
>  		      !test_bit(MD_RECOVERY_SYNC, &mddev->recovery))))
>  			continue;
> +		if (test_bit(Faulty, &conf->mirrors[i].rdev->flags))
> +			continue;
>  
>  		bio_set_op_attrs(wbio, REQ_OP_WRITE, 0);
>  		if (test_bit(FailFast, &conf->mirrors[i].rdev->flags))
> 
> 
> Thanks,
> NeilBrown
> 
