From: Deepa Dinamani <deepa.kernel@gmail.com>
Subject: Re: [PATCH 2/2] md: Replace get_seconds with ktime_get_seconds
Date: Wed, 23 Dec 2015 04:21:35 +0530
Message-ID: <E77EBB87-65AE-4D2D-8E8B-A79E44CF593D@gmail.com>
References: <1450789602-31162-1-git-send-email-shraddha.6596@gmail.com> <87io3q2jqt.fsf@notabene.neil.brown.name>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87io3q2jqt.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: Shraddha Barke <shraddha.6596@gmail.com>, linux-raid@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
List-Id: linux-raid.ids

 It should be real seconds.
You cannot use monotonic clock here since these are actual clock time timestamps. Monotonic time  starts from 0 on every boot.

-Deepa

> On Dec 23, 2015, at 4:06 AM, NeilBrown <neilb@suse.com> wrote:
> 
>> On Wed, Dec 23 2015, Shraddha Barke wrote:
>> 
>> 32-bit systems using function get_seconds will break in year 2038,
>> in order to avoid that replace the code with more appropriate function
>> ktime_get_seconds which is y2038 safe. Function ktime_get_seconds use
>> monotonic instead of real time and therefore will not cause overflow
>> 
>> Signed-off-by: Shraddha Barke <shraddha.6596@gmail.com>
>> ---
>> drivers/md/md.c | 6 +++---
>> 1 file changed, 3 insertions(+), 3 deletions(-)
>> 
>> diff --git a/drivers/md/md.c b/drivers/md/md.c
>> index 807095f..8dd74bb 100644
>> --- a/drivers/md/md.c
>> +++ b/drivers/md/md.c
>> @@ -2333,7 +2333,7 @@ repeat:
>> 
>>    spin_lock(&mddev->lock);
>> 
>> -    mddev->utime = get_seconds();
>> +    mddev->utime = ktime_get_seconds();
>> 
>>    if (test_and_clear_bit(MD_CHANGE_DEVS, &mddev->flags))
>>        force_change = 1;
>> @@ -6347,13 +6347,13 @@ static int set_array_info(struct mddev *mddev, mdu_array_info_t *info)
>>        /* ensure mddev_put doesn't delete this now that there
>>         * is some minimal configuration.
>>         */
>> -        mddev->ctime         = get_seconds();
>> +        mddev->ctime         = ktime_get_seconds();
>>        return 0;
>>    }
>>    mddev->major_version = MD_MAJOR_VERSION;
>>    mddev->minor_version = MD_MINOR_VERSION;
>>    mddev->patch_version = MD_PATCHLEVEL_VERSION;
>> -    mddev->ctime         = get_seconds();
>> +    mddev->ctime         = ktime_get_seconds();
>> 
>>    mddev->level         = info->level;
>>    mddev->clevel[0]     = 0;
>> -- 
>> 2.1.4
> 
> Thanks for splitting this off.
> However I tried to apply it and it doesn't apply.
> 
> I already have a patch (in linux-next) from
>  Deepa Dinamani <deepa.kernel@gmail.com>
> which uses ktime_get_real_seconds().
> 
> http://git.neil.brown.name/?p=md.git;a=commitdiff;h=195e0e2726a7f93295b28ebf277876d5a7c6cf2d
> 
> Which should it be?  ktime_get_seconds or ktime_get_real_seconds?
> 
> Thanks,
> NeilBrown
