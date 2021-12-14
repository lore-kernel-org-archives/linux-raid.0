Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E92FEC433EF
	for <linux-raid@archiver.kernel.org>; Tue, 14 Dec 2021 12:21:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232004AbhLNMVi (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 14 Dec 2021 07:21:38 -0500
Received: from mx3.molgen.mpg.de ([141.14.17.11]:60047 "EHLO mx1.molgen.mpg.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229809AbhLNMVi (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Tue, 14 Dec 2021 07:21:38 -0500
Received: from [192.168.0.175] (ip5f5aed0f.dynamic.kabel-deutschland.de [95.90.237.15])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: buczek)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id AC5EB61EA1923;
        Tue, 14 Dec 2021 13:21:35 +0100 (CET)
Subject: Re: [PATCH V2] md: don't unregister sync_thread with reconfig_mutex
 held
To:     Guoqing Jiang <guoqing.jiang@linux.dev>, song@kernel.org
Cc:     agk@redhat.com, snitzer@redhat.com, linux-raid@vger.kernel.org,
        dm-devel@redhat.com, Paul Menzel <pmenzel@molgen.mpg.de>
References: <1613177399-22024-1-git-send-email-guoqing.jiang@cloud.ionos.com>
 <8312a154-14fb-6f07-0cf1-8c970187cc49@molgen.mpg.de>
 <87206712-b066-9d1d-3e46-14338e704c1a@linux.dev>
 <75958549-03d4-e396-e761-9956c4b2f991@molgen.mpg.de>
 <2ed2d0ba-14e9-f708-265e-8fc64902bd93@linux.dev>
From:   Donald Buczek <buczek@molgen.mpg.de>
Message-ID: <c270e560-3d92-f05e-26a7-86523a79f1d8@molgen.mpg.de>
Date:   Tue, 14 Dec 2021 13:21:35 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <2ed2d0ba-14e9-f708-265e-8fc64902bd93@linux.dev>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 14.12.21 11:03, Guoqing Jiang wrote:
> 
> 
> On 12/14/21 5:31 PM, Donald Buczek wrote:
> 
>>>>>   -void md_reap_sync_thread(struct mddev *mddev)
>>>>> +void md_reap_sync_thread(struct mddev *mddev, bool reconfig_mutex_held)
>>>>>   {
>>>>>       struct md_rdev *rdev;
>>>>>       sector_t old_dev_sectors = mddev->dev_sectors;
>>>>>       bool is_reshaped = false;
>>>>>         /* resync has finished, collect result */
>>>>> +    if (reconfig_mutex_held)
>>>>> +        mddev_unlock(mddev);
>>>>
>>>>
>>>> If one thread got here, e.g. via action_store( /* "idle" */ ), now that the mutex is unlocked, is there anything which would prevent another thread getting  here as well, e.g. via the same path?
>>>>
>>>> If not, they both might call
>>>>
>>>>> md_unregister_thread(&mddev->sync_thread);
>>>>
>>>> Which is not reentrant:
>>>>
>>>> void md_unregister_thread(struct md_thread **threadp)
>>>> {
>>>>     struct md_thread *thread = *threadp;
>>>>     if (!thread)
>>>>         return;
>>>>     pr_debug("interrupting MD-thread pid %d\n", task_pid_nr(thread->tsk));
>>>>     /* Locking ensures that mddev_unlock does not wake_up a
>>>>      * non-existent thread
>>>>      */
>>>>     spin_lock(&pers_lock);
>>>>     *threadp = NULL;
>>>>     spin_unlock(&pers_lock);
>>>>
>>>>     kthread_stop(thread->tsk);
>>>>     kfree(thread);
>>>> }
>>>>
>>>> This might be a preexisting problem, because the call site in dm-raid.c, which you updated to `md_reap_sync_thread(mddev, false);`, didn't hold the mutex anyway.
>>>>
>>>> Am I missing something? Probably, I do.
>>>>
>>>> Otherwise: Move the deref of threadp in md_unregister_thread() into the spinlock scope?
>>>
>>> Good point, I think you are right.
>>>
>>> And actually pers_lock does extra service to protect accesses to mddev->thread (I think it
>>> also suitable for mddev->sync_thread ) when the mutex can't be held. Care to send a patch
>>> for it?
>>
>> I'm really sorry, but it's one thing to point to a possible problem and another thing to come up with a correct solution.
> 
> Yes, it is often the reality of life, and we can always correct ourselves if there is problem 😎.
> 
>> While I think it would be easy to avoid the double free with the spinlock (or maybe atomic RMW) , we surely don't want to hold the spinlock while we are sleeping in kthread_stop(). If we don't hold some kind of lock, what are the side effects of another sync thread being started or any other reconfiguration? Are the existing flags enough to protect us from this? If we do want to hold the lock while waiting for the thread to terminate, should it be made into a mutex? If so, it probably shouldn't be static but moved into the mddev structure. I'd need weeks if not month to figure that out and to feel bold enough to post it.
> 
> Thanks for deep thinking about it, I think we can avoid to call kthread_stop with spinlock
> held. Maybe something like this, but just my raw idea, please have a thorough review.
> 
>   void md_unregister_thread(struct md_thread **threadp)
>   {
> -       struct md_thread *thread = *threadp;
> -       if (!thread)
> +       struct md_thread *thread = READ_ONCE(*threadp);

- The access to *threadp needs to be after the spin_lock(). Otherwise two CPUs might read non-NULL here.

- If it was after spin_lock(), I think (!= I know), we don't need the READ_ONCE, because spin_lock() implies a compiler barrier.

> +
> +       spin_lock(&pers_lock);
> +       if (!thread) {
> +               spin_unlock(&pers_lock);
>                  return;
> +       }
>          pr_debug("interrupting MD-thread pid %d\n", task_pid_nr(thread->tsk));
>          /* Locking ensures that mddev_unlock does not wake_up a
>           * non-existent thread
>           */
> -       spin_lock(&pers_lock);
>          *threadp = NULL;
>          spin_unlock(&pers_lock);
> 
> -       kthread_stop(thread->tsk);
> +       if (IS_ERR_OR_NULL(thread->tsk)) {

- Test accidentally negated? This test is new. Is this an unrelated change? Anyway, I don't get it.

> +               kthread_stop(thread->tsk);
> +               thread->tsk = NULL;

- This assignment can't be required, because we are going to kfree(thread) in the next line.

> +       }
>          kfree(thread);
>   }
>   EXPORT_SYMBOL(md_unregister_thread);
> 
>> I don't want to push work to others, but my own my understanding of md is to narrow.
> 
> Me either 😉
> 
> Thanks,
> Guoqing

Best

   Donald

-- 
Donald Buczek
buczek@molgen.mpg.de
Tel: +49 30 8413 1433
