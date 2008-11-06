From: Thomas Backlund <tmb@mandriva.org>
Subject: Re: md raid10 regression in 2.6.27.4 (possibly earlier) BISECTED
Date: Thu, 06 Nov 2008 11:23:14 +0200
Message-ID: <4912B782.2070409@mandriva.org>
References: <490D8EBF.8050400@rabbit.us>	<490DE55F.6080600@mandriva.org>	<490E3CF9.20208@mandriva.org>	<49122C88.5000102@mandriva.org> <18706.35892.143554.833998@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18706.35892.143554.833998@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Neil Brown skrev:
> On Thursday November 6, tmb@mandriva.org wrote:
>> But anyway...
>>
>> This is the commit that breaks the raid10 rebuild/resync:
> 
> Awesome. Thanks!
> 
>> --- cut ---
>> 6c2fce2ef6b4821c21b5c42c7207cb9cf8c87eda is first bad commit
>> commit 6c2fce2ef6b4821c21b5c42c7207cb9cf8c87eda
>> Author: Neil Brown <neilb@notabene.brown>
>                       ^^^^^^^^^^^^^^^^^^^^
> Grown.  I hadn't noticed that.  Fixed now I hope.
> 
>> Date:   Sat Jun 28 08:31:31 2008 +1000
>>
>>      Support adding a spare to a live md array with external metadata.
>>
>>      i.e. extend the 'md/dev-XXX/slot' attribute so that you can
>>      tell a device to fill an vacant slot in an and md array.
>>
>>      Signed-off-by: Neil Brown <neilb@suse.de>
>> --- cut ---
>>
>> I have verified that adding this patch to a working 2.6.26 kernel breaks
>> the rebuild/resync
>>
>> I have not verified if reverting it on a 2.6.27 kernel restores the 
>> rebuild/resync as it does not revert cleanly...
>>
>> So...
>>
>> Any suggestions of what to try next ?
> 
> You mean apart from hitting Neil with a clue-bat?
> 

;-)

> Maybe try this patch.  I haven't even compile tested it, but I'm
> certain it'll fix your problem.
> 

Yeah,
After reading the commit that broke raid10, it's an obvious fix...

And I have now verified it on a 2.6.27.4 kernel that it works!

Thanks!

> Thanks again,
> 
> NeilBrown
> 
> ----------------------------------------------
> From: NeilBrown <neilb@suse.de>
> Date: Thu, 6 Nov 2008 17:14:31 +1100
> Subject: [PATCH] md: fix bug in raid10 recovery.
> 
> Adding a spare to a raid10 doesn't cause recovery to start.
> This is due to an silly type in
>   commit 6c2fce2ef6b4821c21b5c42c7207cb9cf8c87eda
> and so is a bug in 2.6.27 and .28-rc.
> 
> Thanks to Thomas Backlund for bisecting to find this.
> 
> Cc: Thomas Backlund <tmb@mandriva.org>
> Cc: stable@kernel.org
> 
> Signed-off-by: NeilBrown <neilb@suse.de>
   Tested-by: Thomas Backlund <tmb@mandriva.org>
> 
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index da5129a..970a96e 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -1137,7 +1137,7 @@ static int raid10_add_disk(mddev_t *mddev, mdk_rdev_t *rdev)
>  	if (!enough(conf))
>  		return -EINVAL;
>  
> -	if (rdev->raid_disk)
> +	if (rdev->raid_disk >= 0)
>  		first = last = rdev->raid_disk;
>  
>  	if (rdev->saved_raid_disk >= 0 &&


--
Thomas
