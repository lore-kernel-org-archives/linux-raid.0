From: hank <pyu@redhat.com>
Subject: Re: Subject: [PATCH 1/1] drivers/md/raid1.c: fix NULL pointer bug
 in fix_read_error function
Date: Thu, 13 Sep 2012 14:21:05 +0800
Message-ID: <50517B51.4000805@redhat.com>
References: <5045708C.10705@redhat.com>	<505144D0.4080908@redhat.com> <20120913154417.3f886f8d@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20120913154417.3f886f8d@notabene.brown>
Sender: linux-kernel-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: miku@iki.fi, jakob@ostenfeld.dk, ptb@it.uc3m.es, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

On 09/13/2012 01:44 PM, NeilBrown wrote:

> On Thu, 13 Sep 2012 10:28:32 +0800 hank <pyu@redhat.com> wrote:
> 
>> On 09/04/2012 11:07 AM, hank wrote:
>>
>>> From 0ba5879082544dc3aa13807087563b1258124b1e Mon Sep 17 00:00:00 2001
>>> From: hank <pyu@redhat.com>
>>> Date: Tue, 4 Sep 2012 10:23:45 +0800
>>> Subject: [PATCH 1/1] drivers/md/raid1.c: fix NULL pointer bug in
>>>  fix_read_error function
>>>
>>> in fix_read_error function, the conf->mirrors[read_disk].rdev may
>>> become NULL, as in this function, rdev->nr_pending may be zero, anyone
>>> can delete it. So should check if it is NULL before use.
>>>
>>> Signed-off-by: hank <pyu@redhat.com>
>>> ---
>>>  drivers/md/raid1.c |    2 +-
>>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>>
>>> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
>>> index 611b5f7..fd8de28 100644
>>> --- a/drivers/md/raid1.c
>>> +++ b/drivers/md/raid1.c
>>> @@ -2005,7 +2005,7 @@ static void fix_read_error(struct r1conf *conf, int read_disk,
>>>  		if (!success) {
>>>  			/* Cannot read from anywhere - mark it bad */
>>>  			struct md_rdev *rdev = conf->mirrors[read_disk].rdev;
>>> -			if (!rdev_set_badblocks(rdev, sect, s, 0))
>>> +			if (!rdev || !rdev_set_badblocks(rdev, sect, s, 0))
>>>  				md_error(mddev, rdev);
>>>  			break;
>>>  		}
>>
>>
>>
>> Anyone can review this patch? I think it is a bug and should be fixed.
> 
> I agree there is a bug there but I don't think this is the right fix.
> If rdev could be NULL there, then it could also be NULL in
> 		md_error(mddev, conf->mirrors[r1_bio->read_disk].rdev);
> in handle_read_error().
> I think we should just hold on to the reference to the rdev until we are
> done with it, like the follow.
> 
> Would you agree?
> 
> Thanks,
> NeilBrown
> 
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index 611b5f7..eb1f8a3 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -333,9 +333,10 @@ static void raid1_end_read_request(struct bio *bio, int error)
>  		spin_unlock_irqrestore(&conf->device_lock, flags);
>  	}
>  
> -	if (uptodate)
> +	if (uptodate) {
>  		raid_end_bio_io(r1_bio);
> -	else {
> +		rdev_dec_pending(conf->mirrors[mirror].rdev, conf->mddev);
> +	} else {
>  		/*
>  		 * oops, read error:
>  		 */
> @@ -349,9 +350,8 @@ static void raid1_end_read_request(struct bio *bio, int error)
>  			(unsigned long long)r1_bio->sector);
>  		set_bit(R1BIO_ReadError, &r1_bio->state);
>  		reschedule_retry(r1_bio);
> +		/* don't drop the reference on read_disk yet */
>  	}
> -
> -	rdev_dec_pending(conf->mirrors[mirror].rdev, conf->mddev);
>  }
>  
>  static void close_write(struct r1bio *r1_bio)
> @@ -2220,6 +2220,7 @@ static void handle_read_error(struct r1conf *conf, struct r1bio *r1_bio)
>  		unfreeze_array(conf);
>  	} else
>  		md_error(mddev, conf->mirrors[r1_bio->read_disk].rdev);
> +	rdev_dec_pending(conf->mirrors[r1_bio->read_disk].rdev, conf->mddev);
>  
>  	bio = r1_bio->bios[r1_bio->read_disk];
>  	bdevname(bio->bi_bdev, b);


The md_error function will check if rdev is NULL, if it is NULL,
md_error will return directly, so I think it is doesn't matther if we
pass a NULL rdev to md_error function.

But anyway, I can't find any problem in your patch, it is correct doubtless.

Best Regards.
Hank.
