Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26CE8C433E0
	for <linux-raid@archiver.kernel.org>; Tue, 26 Jan 2021 13:00:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F3E7D23109
	for <linux-raid@archiver.kernel.org>; Tue, 26 Jan 2021 13:00:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404319AbhAZM7j (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 26 Jan 2021 07:59:39 -0500
Received: from mx3.molgen.mpg.de ([141.14.17.11]:34843 "EHLO mx1.molgen.mpg.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2392459AbhAZM7A (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Tue, 26 Jan 2021 07:59:00 -0500
Received: from [192.168.0.5] (ip5f5aed2c.dynamic.kabel-deutschland.de [95.90.237.44])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: buczek)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id 85EA220647904;
        Tue, 26 Jan 2021 13:58:07 +0100 (CET)
Subject: Re: md_raid: mdX_raid6 looping after sync_action "check" to "idle"
 transition
To:     Guoqing Jiang <guoqing.jiang@cloud.ionos.com>,
        Song Liu <song@kernel.org>, linux-raid@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        it+raid@molgen.mpg.de
References: <aa9567fd-38e1-7b9c-b3e1-dc2fdc055da5@molgen.mpg.de>
 <95fbd558-5e46-7a6a-43ac-bcc5ae8581db@cloud.ionos.com>
 <77244d60-1c2d-330e-71e6-4907d4dd65fc@molgen.mpg.de>
 <7c5438c7-2324-cc50-db4d-512587cb0ec9@molgen.mpg.de>
 <b289ae15-ff82-b36e-4be4-a1c8bbdbacd7@cloud.ionos.com>
 <37c158cb-f527-34f5-2482-cae138bc8b07@molgen.mpg.de>
 <efb8d47b-ab9b-bdb9-ee2f-fb1be66343b1@molgen.mpg.de>
 <55e30408-ac63-965f-769f-18be5fd5885c@molgen.mpg.de>
 <d95aa962-9750-c27c-639a-2362bdb32f41@cloud.ionos.com>
 <30576384-682c-c021-ff16-bebed8251365@molgen.mpg.de>
 <cdc0b03c-db53-35bc-2f75-93bbca0363b5@molgen.mpg.de>
 <bc342de0-98d2-1733-39cd-cc1999777ff3@molgen.mpg.de>
 <c3390ab0-d038-f1c3-5544-67ae9c8408b1@cloud.ionos.com>
 <a27c5a64-62bf-592c-e547-1e8e904e3c97@molgen.mpg.de>
 <6c7008df-942e-13b1-2e70-a058e96ab0e9@cloud.ionos.com>
From:   Donald Buczek <buczek@molgen.mpg.de>
Message-ID: <12f09162-c92f-8fbb-8382-cba6188bfb29@molgen.mpg.de>
Date:   Tue, 26 Jan 2021 13:58:06 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <6c7008df-942e-13b1-2e70-a058e96ab0e9@cloud.ionos.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 26.01.21 12:14, Guoqing Jiang wrote:
> Hi Donald,
> 
> On 1/26/21 10:50, Donald Buczek wrote:
> [...]
> 
>>>>
>>>> diff --git a/drivers/md/md.c b/drivers/md/md.c
>>>> index 2d21c298ffa7..f40429843906 100644
>>>> --- a/drivers/md/md.c
>>>> +++ b/drivers/md/md.c
>>>> @@ -4687,11 +4687,13 @@ action_store(struct mddev *mddev, const char *page, size_t len)
>>>>               clear_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
>>>>           if (test_bit(MD_RECOVERY_RUNNING, &mddev->recovery) &&
>>>>               mddev_lock(mddev) == 0) {
>>>> +            set_bit(MD_ALLOW_SB_UPDATE, &mddev->flags);
>>>>               flush_workqueue(md_misc_wq);
>>>>               if (mddev->sync_thread) {
>>>>                   set_bit(MD_RECOVERY_INTR, &mddev->recovery);
>>>>                   md_reap_sync_thread(mddev);
>>>>               }
>>>> +            clear_bit(MD_ALLOW_SB_UPDATE, &mddev->flags);
>>>>               mddev_unlock(mddev);
>>>>           }
>>>>       } else if (test_bit(MD_RECOVERY_RUNNING, &mddev->recovery))
>>>
>>> Yes, it could break the deadlock issue, but I am not sure if it is the right way given we only set ALLOW_SB_UPDATE in suspend which makes sense since the io will be quiesced, but write idle action can't guarantee the  similar thing.
>>
>> Thinking (and documenting) MD_ALLOW_SB_UPDATE as "the holder of reconfig_mutex promises not to make any changes which would exclude superblocks from being written" might make it easier to accept the usage.
> 
> I am not sure it is safe to set the flag here since write idle can't prevent IO from fs while mddev_suspend can guarantee that.
> 
>>
>>> I prefer to make resync thread not wait forever here.
>>>
> 
> [...]
> 
>>>
>>> -        sh = raid5_get_active_stripe(conf, new_sector, previous,
>>> +        sh = raid5_get_active_stripe(conf, new_sector, previous, 0,
>>
>>
>> Mistake here (fourth argument added instead of third)
> 
> Thanks for checking.
> 
> [...]
> 
>> Unfortunately, this patch did not fix the issue.
>>
>>      root@sloth:~/linux# cat /proc/$(pgrep md3_resync)/stack
>>      [<0>] raid5_get_active_stripe+0x1e7/0x6b0
>>      [<0>] raid5_sync_request+0x2a7/0x3d0
>>      [<0>] md_do_sync.cold+0x3ee/0x97c
>>      [<0>] md_thread+0xab/0x160
>>      [<0>] kthread+0x11b/0x140
>>      [<0>] ret_from_fork+0x22/0x30
>>
>> which is ( according to objdump -d -Sl drivers/md/raid5.o ) at https://elixir.bootlin.com/linux/v5.11-rc5/source/drivers/md/raid5.c#L735
>>
>> Isn't it still the case that the superblocks are not written, therefore stripes are not processed, therefore number of active stripes are not decreasing? Who is expected to wake up conf->wait_for_stripe waiters?
> 
> Hmm, how about wake the waiter up in the while loop of raid5d?
> 
> @@ -6520,6 +6532,11 @@ static void raid5d(struct md_thread *thread)
>                          md_check_recovery(mddev);
>                          spin_lock_irq(&conf->device_lock);
>                  }
> +
> +               if ((atomic_read(&conf->active_stripes)
> +                    < (conf->max_nr_stripes * 3 / 4) ||
> +                    (test_bit(MD_RECOVERY_INTR, &mddev->recovery))))
> +                       wake_up(&conf->wait_for_stripe);
>          }
>          pr_debug("%d stripes handled\n", handled);

Hmm... With this patch on top of your other one, we still have the basic symptoms (md3_raid6 busy looping), but the sync thread is now hanging at

     root@sloth:~# cat /proc/$(pgrep md3_resync)/stack
     [<0>] md_do_sync.cold+0x8ec/0x97c
     [<0>] md_thread+0xab/0x160
     [<0>] kthread+0x11b/0x140
     [<0>] ret_from_fork+0x22/0x30

instead, which is https://elixir.bootlin.com/linux/latest/source/drivers/md/md.c#L8963

And, unlike before, "md: md3: data-check interrupted." from the pr_info two lines above appears in dmesg.

Best
   Donald

> If the issue still appears then I will change the waiter to break just if MD_RECOVERY_INTR is set, something like.
> 
> wait_event_lock_irq(conf->wait_for_stripe,
>      (test_bit(MD_RECOVERY_INTR, &mddev->recovery) && sync_req) ||
>       /* the previous condition */,
>      *(conf->hash_locks + hash));
> 
> Thanks,
> Guoqing
