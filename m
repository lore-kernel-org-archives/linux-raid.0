From: Guoqing Jiang <gqjiang@suse.com>
Subject: Re: [RFC PATCH 1/2] RAID1: a new I/O barrier implementation to remove
 resync window
Date: Thu, 24 Nov 2016 14:05:45 +0800
Message-ID: <58368339.4050508@suse.com>
References: <1479765241-15528-1-git-send-email-colyli@suse.de>
 <20161122213541.btgw4cpoly5j4jpc@kernel.org>
 <871sy1bfd9.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <871sy1bfd9.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>, Shaohua Li <shli@kernel.org>, Coly Li <colyli@suse.de>
Cc: linux-raid@vger.kernel.org, Shaohua Li <shli@fb.com>, Neil Brown <neilb@suse.de>, Johannes Thumshirn <jthumshirn@suse.de>
List-Id: linux-raid.ids



On 11/24/2016 01:45 PM, NeilBrown wrote:
>
>>> @@ -255,19 +257,14 @@ static void call_bio_endio(struct r1bio
>>>   	if (!test_bit(R1BIO_Uptodate, &r1_bio->state))
>>>   		bio->bi_error = -EIO;
>>>   
>>> -	if (done) {
>>> +	if (done)
>>>   		bio_endio(bio);
>>> -		/*
>>> -		 * Wake up any possible resync thread that waits for the device
>>> -		 * to go idle.
>>> -		 */
>>> -		allow_barrier(conf, start_next_window, bi_sector);
>>> -	}
>>>   }
>>>   
>>>   static void raid_end_bio_io(struct r1bio *r1_bio)
>>>   {
>>>   	struct bio *bio = r1_bio->master_bio;
>>> +	struct r1conf *conf = r1_bio->mddev->private;
>>>   
>>>   	/* if nobody has done the final endio yet, do it now */
>>>   	if (!test_and_set_bit(R1BIO_Returned, &r1_bio->state)) {
>>> @@ -278,6 +275,12 @@ static void raid_end_bio_io(struct r1bio
>>>   
>>>   		call_bio_endio(r1_bio);
>>>   	}
>>> +
>>> +	/*
>>> +	 * Wake up any possible resync thread that waits for the device
>>> +	 * to go idle.
>>> +	 */
>>> +	allow_barrier(conf, r1_bio->sector);
>> Why this change?
> I wondered too.  I think it may be correct, but it should be in a
> separate patch.
> When you have a write-mostly device, I think the current code will
> allow_barrier() before the writes to the write-mostly devices have
> completed.
>

Seems the change is moved from call_bio_endio, but call_bio_endio is 
also called
from raid1_end_write_request, I think it is better to keep the original 
code.

Thanks,
Guoqing
