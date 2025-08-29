Received: from www5210.sakura.ne.jp (www5210.sakura.ne.jp [133.167.8.150])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A14C1FCFEF
	for <linux-raid@vger.kernel.org>; Fri, 29 Aug 2025 12:24:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=133.167.8.150
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756470274; cv=none; b=PwVAXFvr0HdYDdpT7HP7P3hnWMhZVACLNuCTniWaTxgQZ/gqBZ3lUyGL1NKjq9nkfnuHQKnNa0bNwa8WtrVnJ94dd7WoJcEZFtbt8x1hSLXzHnVyccsGvut8QSw7kxjEdnU/Ti5SzWX1rp6T6WS+vcGnSH7ztX6krm9T8f6otfk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756470274; c=relaxed/simple;
	bh=QcNrel/EaV1GtKzz91WehSWO1weENSNqyhEAV6F2RVw=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=P9cM4m+6/1YYTZ2NwfKGtaDQ8ZrvUDQj4XH/wASsC3sySd6UK8Xctq5w3j2hramvFAEwVRdG7FOKyFdTihodIzwFiF6RkTcEd4LdDzRo9PD/ZDA7y1vlbLH6BF4/UfCKz8Q1cCNg0RT0toilcjBAjbA1wQFtVHLdwC8CDa6PP1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mgml.me; spf=pass smtp.mailfrom=mgml.me; dkim=pass (2048-bit key) header.d=mgml.me header.i=@mgml.me header.b=acLKRBqw; arc=none smtp.client-ip=133.167.8.150
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mgml.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mgml.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mgml.me header.i=@mgml.me header.b="acLKRBqw"
Received: from NEET (p4284234-ipxg00p01tokaisakaetozai.aichi.ocn.ne.jp [153.201.197.234])
	(authenticated bits=0)
	by www5210.sakura.ne.jp (8.16.1/8.16.1) with ESMTPSA id 57TCLWNf059909
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Fri, 29 Aug 2025 21:21:32 +0900 (JST)
	(envelope-from k@mgml.me)
DKIM-Signature: a=rsa-sha256; bh=Wx1rCVZP3oFaDCKj3lQnD1g+V9mPan0AUC2YN+4/xgA=;
        c=relaxed/relaxed; d=mgml.me;
        h=Message-ID:Date:Subject:To:From;
        s=rs20250315; t=1756470092; v=1;
        b=acLKRBqw7Qzz2gE2UXXGGjGeMjtIlXlrCqZ44HogiBFnjP6Bm+MCkQhJSNE3QSSz
         rqZA7LnRfksEEkpc5LaNriaTJsL0ejTUzjIIgH4uZWKxY7h9ZU39rkfgv2rd3uRx
         JEP4OsFxnnvkh6yXRzTxSsGpzEqu7SinoLhOvd/zkNgjVlSKw9/h71ZVUgh9Rk/g
         De8aXLXQQFMdDeqnkByKHEok68skUQTalSjOv6yDLi+Bu1idQd2b02xQFFSgeKf+
         2EQzModgxhciSQRsVdEdKclKPT2O7xNkkVQ+zHpTf2v9z30PS8kbnZCaVdLkbfD6
         6LKjTg3RH3JS87wVhDbGbA==
Message-ID: <6b3119f1-486e-4361-b04d-5e3c67a52a91@mgml.me>
Date: Fri, 29 Aug 2025 21:21:33 +0900
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kenta Akagi <k@mgml.me>
Subject: Re: [PATCH v3 1/3] md/raid1,raid10: Do not set MD_BROKEN on failfast
 io failure
To: Li Nan <linan666@huaweicloud.com>, Song Liu <song@kernel.org>,
        Yu Kuai <yukuai3@huawei.com>, Mariusz Tkaczyk <mtkaczyk@kernel.org>,
        Guoqing Jiang <jgq516@gmail.com>
References: <20250828163216.4225-1-k@mgml.me>
 <20250828163216.4225-2-k@mgml.me>
 <dcb72e23-d0ea-c8b3-24db-5dd515f619a8@huaweicloud.com>
Content-Language: en-US
From: Kenta Akagi <k@mgml.me>
In-Reply-To: <dcb72e23-d0ea-c8b3-24db-5dd515f619a8@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 2025/08/29 11:54, Li Nan wrote:
> 
> 在 2025/8/29 0:32, Kenta Akagi 写道:
>> This commit ensures that an MD_FAILFAST IO failure does not put
>> the array into a broken state.
>>
>> When failfast is enabled on rdev in RAID1 or RAID10,
>> the array may be flagged MD_BROKEN in the following cases.
>> - If MD_FAILFAST IOs to multiple rdevs fail simultaneously
>> - If an MD_FAILFAST metadata write to the 'last' rdev fails
> 
> [...]
> 
>> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
>> index 408c26398321..8a61fd93b3ff 100644
>> --- a/drivers/md/raid1.c
>> +++ b/drivers/md/raid1.c
>> @@ -470,6 +470,7 @@ static void raid1_end_write_request(struct bio *bio)
>>               (bio->bi_opf & MD_FAILFAST) &&
>>               /* We never try FailFast to WriteMostly devices */
>>               !test_bit(WriteMostly, &rdev->flags)) {
>> +            set_bit(FailfastIOFailure, &rdev->flags);
>>               md_error(r1_bio->mddev, rdev);
>>           }
>>   @@ -1746,8 +1747,12 @@ static void raid1_status(struct seq_file *seq, struct mddev *mddev)
>>    *    - recovery is interrupted.
>>    *    - &mddev->degraded is bumped.
>>    *
>> - * @rdev is marked as &Faulty excluding case when array is failed and
>> - * &mddev->fail_last_dev is off.
>> + * If @rdev has &FailfastIOFailure and it is the 'last' rdev,
>> + * then @mddev and @rdev will not be marked as failed.
>> + *
>> + * @rdev is marked as &Faulty excluding any cases:
>> + *    - when @mddev is failed and &mddev->fail_last_dev is off
>> + *    - when @rdev is last device and &FailfastIOFailure flag is set
>>    */
>>   static void raid1_error(struct mddev *mddev, struct md_rdev *rdev)
>>   {
>> @@ -1758,6 +1763,13 @@ static void raid1_error(struct mddev *mddev, struct md_rdev *rdev)
>>         if (test_bit(In_sync, &rdev->flags) &&
>>           (conf->raid_disks - mddev->degraded) == 1) {
>> +        if (test_and_clear_bit(FailfastIOFailure, &rdev->flags)) {
>> +            spin_unlock_irqrestore(&conf->device_lock, flags);
>> +            pr_warn_ratelimited("md/raid1:%s: Failfast IO failure on %pg, "
>> +                "last device but ignoring it\n",
>> +                mdname(mddev), rdev->bdev);
>> +            return;
>> +        }
>>           set_bit(MD_BROKEN, &mddev->flags);
>>             if (!mddev->fail_last_dev) {
>> @@ -2148,6 +2160,7 @@ static int fix_sync_read_error(struct r1bio *r1_bio)
>>       if (test_bit(FailFast, &rdev->flags)) {
>>           /* Don't try recovering from here - just fail it
>>            * ... unless it is the last working device of course */
>> +        set_bit(FailfastIOFailure, &rdev->flags);
>>           md_error(mddev, rdev);
>>           if (test_bit(Faulty, &rdev->flags))
>>               /* Don't try to read from here, but make sure
>> @@ -2652,6 +2665,7 @@ static void handle_read_error(struct r1conf *conf, struct r1bio *r1_bio)
>>           fix_read_error(conf, r1_bio);
>>           unfreeze_array(conf);
>>       } else if (mddev->ro == 0 && test_bit(FailFast, &rdev->flags)) {
>> +        set_bit(FailfastIOFailure, &rdev->flags);
>>           md_error(mddev, rdev);
>>       } else {
>>           r1_bio->bios[r1_bio->read_disk] = IO_BLOCKED;
>> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
>> index b60c30bfb6c7..530ad6503189 100644
>> --- a/drivers/md/raid10.c
>> +++ b/drivers/md/raid10.c
>> @@ -488,6 +488,7 @@ static void raid10_end_write_request(struct bio *bio)
>>               dec_rdev = 0;
>>               if (test_bit(FailFast, &rdev->flags) &&
>>                   (bio->bi_opf & MD_FAILFAST)) {
>> +                set_bit(FailfastIOFailure, &rdev->flags);
>>                   md_error(rdev->mddev, rdev);
>>               }
>>   
> 
> Thank you for the patch. There may be an issue with 'test_and_clear'.
> 
> If two write IO go to the same rdev, MD_BROKEN may be set as below:

> IO1                    IO2
> set FailfastIOFailure
>                     set FailfastIOFailure       
>  md_error
>   raid1_error
>    test_and_clear FailfastIOFailur
>                        md_error
>                       raid1_error
>                        //FailfastIOFailur is cleared
>                        set MD_BROKEN
> 
> Maybe we should check whether FailfastIOFailure is already set before
> setting it. It also needs to be considered in metadata writes.
Thank you for reviewing.

I agree, this seems to be as you described.
So, should it be implemented as follows?

bool old=false;
do{
 spin_lock_irqsave(&conf->device_lock, flags);
 old = test_and_set_bit(FailfastIOFailure, &rdev->flags);
 spin_unlock_irqrestore(&conf->device_lock, flags);
}while(old);

However, since I am concerned about potential deadlocks, 
so I am considering two alternative approaches:

* Add an atomic_t counter to md_rdev to track failfast IO failures.

This may set MD_BROKEN at a slightly incorrect timing, but mixing
error handling of Failfast and non-Failfast IOs appears to be rare.
In any case, the final outcome would be the same, i.e. the array
ends up with MD_BROKEN. Therefore, I think this should not cause
issues. I think the same applies to test_and_set_bit.

IO1                    IO2                    IO3
FailfastIOFailure      Normal IOFailure       FailfastIOFailure
atomic_inc                            
                                              
 md_error                                     atomic_inc 
  raid1_error
   atomic_dec //2to1          
                       md_error          
                        raid1_error           md_error
                         atomic_dec //1to0     raid1_error
                                                atomic_dec //0
                                                  set MD_BROKEN

* Alternatively, create a separate error handler,
  e.g. md_error_failfast(), that clearly does not fail the array.

This approach would require somewhat larger changes and may not
be very elegant, but it seems to be a reliable way to ensure 
MD_BROKEN is never set at the wrong timing.

Which of these three approaches would you consider preferable?
I would appreciate your feedback.


For metadata writes, I plan to clear_bit MD_FAILFAST_SUPPORTED
when the array is degraded.

Thanks,
Akagi

>> @@ -1995,8 +1996,12 @@ static int enough(struct r10conf *conf, int ignore)
>>    *    - recovery is interrupted.
>>    *    - &mddev->degraded is bumped.
>>    *
>> - * @rdev is marked as &Faulty excluding case when array is failed and
>> - * &mddev->fail_last_dev is off.
>> + * If @rdev has &FailfastIOFailure and it is the 'last' rdev,
>> + * then @mddev and @rdev will not be marked as failed.
>> + *
>> + * @rdev is marked as &Faulty excluding any cases:
>> + *    - when @mddev is failed and &mddev->fail_last_dev is off
>> + *    - when @rdev is last device and &FailfastIOFailure flag is set
>>    */
>>   static void raid10_error(struct mddev *mddev, struct md_rdev *rdev)
>>   {
>> @@ -2006,6 +2011,13 @@ static void raid10_error(struct mddev *mddev, struct md_rdev *rdev)
>>       spin_lock_irqsave(&conf->device_lock, flags);
>>         if (test_bit(In_sync, &rdev->flags) && !enough(conf, rdev->raid_disk)) {
>> +        if (test_and_clear_bit(FailfastIOFailure, &rdev->flags)) {
>> +            spin_unlock_irqrestore(&conf->device_lock, flags);
>> +            pr_warn_ratelimited("md/raid10:%s: Failfast IO failure on %pg, "
>> +                "last device but ignoring it\n",
>> +                mdname(mddev), rdev->bdev);
>> +            return;
>> + >           set_bit(MD_BROKEN, &mddev->flags);
>>             if (!mddev->fail_last_dev) {
>> @@ -2413,6 +2425,7 @@ static void sync_request_write(struct mddev *mddev, struct r10bio *r10_bio)
>>                   continue;
>>           } else if (test_bit(FailFast, &rdev->flags)) {
>>               /* Just give up on this device */
>> +            set_bit(FailfastIOFailure, &rdev->flags);
>>               md_error(rdev->mddev, rdev);
>>               continue;
>>           }
>> @@ -2865,8 +2878,10 @@ static void handle_read_error(struct mddev *mddev, struct r10bio *r10_bio)
>>           freeze_array(conf, 1);
>>           fix_read_error(conf, mddev, r10_bio);
>>           unfreeze_array(conf);
>> -    } else
>> +    } else {
>> +        set_bit(FailfastIOFailure, &rdev->flags);
>>           md_error(mddev, rdev);
>> +    }
>>         rdev_dec_pending(rdev, mddev);
>>       r10_bio->state = 0;
> 
> -- 
> Thanks,
> Nan
> 
> 

