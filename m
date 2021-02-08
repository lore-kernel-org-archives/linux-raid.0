Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFBE1C433DB
	for <linux-raid@archiver.kernel.org>; Mon,  8 Feb 2021 11:43:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9E36A64E30
	for <linux-raid@archiver.kernel.org>; Mon,  8 Feb 2021 11:43:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233385AbhBHLmd (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 8 Feb 2021 06:42:33 -0500
Received: from mx3.molgen.mpg.de ([141.14.17.11]:38317 "EHLO mx1.molgen.mpg.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232931AbhBHLjY (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Mon, 8 Feb 2021 06:39:24 -0500
Received: from [192.168.0.5] (ip5f5aed2c.dynamic.kabel-deutschland.de [95.90.237.44])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: buczek)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id F1CCC206446A2;
        Mon,  8 Feb 2021 12:38:32 +0100 (CET)
Subject: Re: md_raid: mdX_raid6 looping after sync_action "check" to "idle"
 transition
To:     Guoqing Jiang <guoqing.jiang@cloud.ionos.com>,
        Song Liu <song@kernel.org>, linux-raid@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        it+raid@molgen.mpg.de
References: <aa9567fd-38e1-7b9c-b3e1-dc2fdc055da5@molgen.mpg.de>
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
 <12f09162-c92f-8fbb-8382-cba6188bfb29@molgen.mpg.de>
 <6757d55d-ada8-9b7e-b7fd-2071fe905466@cloud.ionos.com>
 <93d8d623-8aec-ad91-490c-a414c4926fb2@molgen.mpg.de>
 <0bb7c8d8-6b96-ce70-c5ee-ba414de10561@cloud.ionos.com>
From:   Donald Buczek <buczek@molgen.mpg.de>
Message-ID: <e271e183-20e9-8ca2-83eb-225d4d7ab5db@molgen.mpg.de>
Date:   Mon, 8 Feb 2021 12:38:32 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <0bb7c8d8-6b96-ce70-c5ee-ba414de10561@cloud.ionos.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 02.02.21 16:42, Guoqing Jiang wrote:
> Hi Donald,
> 
> On 1/26/21 17:05, Donald Buczek wrote:
>> Dear Guoqing,
>>
>> On 26.01.21 15:06, Guoqing Jiang wrote:
>>>
>>>
>>> On 1/26/21 13:58, Donald Buczek wrote:
>>>>
>>>>
>>>>> Hmm, how about wake the waiter up in the while loop of raid5d?
>>>>>
>>>>> @@ -6520,6 +6532,11 @@ static void raid5d(struct md_thread *thread)
>>>>>                          md_check_recovery(mddev);
>>>>>                          spin_lock_irq(&conf->device_lock);
>>>>>                  }
>>>>> +
>>>>> +               if ((atomic_read(&conf->active_stripes)
>>>>> +                    < (conf->max_nr_stripes * 3 / 4) ||
>>>>> +                    (test_bit(MD_RECOVERY_INTR, &mddev->recovery))))
>>>>> +                       wake_up(&conf->wait_for_stripe);
>>>>>          }
>>>>>          pr_debug("%d stripes handled\n", handled);
>>>>
>>>> Hmm... With this patch on top of your other one, we still have the basic symptoms (md3_raid6 busy looping), but the sync thread is now hanging at
>>>>
>>>>      root@sloth:~# cat /proc/$(pgrep md3_resync)/stack
>>>>      [<0>] md_do_sync.cold+0x8ec/0x97c
>>>>      [<0>] md_thread+0xab/0x160
>>>>      [<0>] kthread+0x11b/0x140
>>>>      [<0>] ret_from_fork+0x22/0x30
>>>>
>>>> instead, which is https://elixir.bootlin.com/linux/latest/source/drivers/md/md.c#L8963
>>>
>>> Not sure why recovery_active is not zero, because it is set 0 before blk_start_plug, and raid5_sync_request returns 0 and skipped is also set to 1. Perhaps handle_stripe calls md_done_sync.
>>>
>>> Could you double check the value of recovery_active? Or just don't wait if resync thread is interrupted.
>>>
>>> wait_event(mddev->recovery_wait,
>>>         test_bit(MD_RECOVERY_INTR,&mddev->recovery) ||
>>>         !atomic_read(&mddev->recovery_active));
>>
>> With that added, md3_resync goes into a loop, too. Not 100% busy, though.
>>
>> root@sloth:~# cat /proc/$(pgrep md3_resync)/stack
>>
>> [<0>] raid5_get_active_stripe+0x1e7/0x6b0  # https://elixir.bootlin.com/linux/v5.11-rc5/source/drivers/md/raid5.c#L735
>> [<0>] raid5_sync_request+0x2a7/0x3d0       # https://elixir.bootlin.com/linux/v5.11-rc5/source/drivers/md/raid5.c#L6274
>> [<0>] md_do_sync.cold+0x3ee/0x97c          # https://elixir.bootlin.com/linux/v5.11-rc5/source/drivers/md/md.c#L8883
>> [<0>] md_thread+0xab/0x160
>> [<0>] kthread+0x11b/0x140
>> [<0>] ret_from_fork+0x22/0x30
>>
>> Sometimes top of stack is raid5_get_active_stripe+0x1ef/0x6b0 instead of raid5_get_active_stripe+0x1e7/0x6b0, so I guess it sleeps, its woken, but the conditions don't match so its sleeps again.
> 
> I don't know why the condition was not true after the change since the RECOVERY_INTR is set and the caller is raid5_sync_request.
> 
> wait_event_lock_irq(conf->wait_for_stripe,
>      (test_bit(MD_RECOVERY_INTR, &mddev->recovery) && sync_req) ||
>       /* the previous condition */,
>      *(conf->hash_locks + hash));

Not knowing the system by heart, I'd probably need more than a full day to analyze that. Please let me know, if this is needed.

> BTW, I think there some some possible ways:
> 
> 1. let "echo idle" give up the reconfig_mutex if there are limited number of active stripe, but I feel it is ugly to check sh number from action_store (kind of layer violation).

My first though is, that it is either needed to hold the mutex or it is not. Why should this depend on the number of available stripes?

And wouldn't we get into the same situation, if another another reconfiguration from userspace takes the mutex again?

> 2. make raid5_sync_request -> raid5_get_active_stripe can quit from the current situation (this was we tried, though it doesn't work so far).
> 
> 3. set MD_ALLOW_SB_UPDATE as you said though I am not sure the safety (but maybe I am wrong).
> 
> 4. given the write IO keeps coming from upper layer which decrease the available stripes. Maybe we need to call grow_one_stripe at the beginning of raid5_make_request for this case, then call drop_one_stripe
> at the end of make_request.
> 
> 5. maybe don't hold reconfig_mutex when try to unregister sync_thread, like this.
> 
>          /* resync has finished, collect result */
>          mddev_unlock(mddev);
>          md_unregister_thread(&mddev->sync_thread);
>          mddev_lock(mddev);

As above: While we wait for the sync thread to terminate, wouldn't it be a problem, if another user space operation takes the mutex?

> My suggestion would be try 2 + 4 together since the reproducer triggers both sync io and write io. Or try 5. Perhaps there is better way which I just can't find.

I just get a bit suspicious, if it is needed to add special code here and here and here, that there might be something wrong with the abstraction.

But, I'm afraid, that aside from testing, I can't be of to much help here, as I don't know all the components or details of the system that well.

Best
   Donald

> Thanks,
> Guoqing

