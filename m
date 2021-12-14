Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 588AFC433EF
	for <linux-raid@archiver.kernel.org>; Tue, 14 Dec 2021 10:03:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232809AbhLNKDx (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 14 Dec 2021 05:03:53 -0500
Received: from out1.migadu.com ([91.121.223.63]:47998 "EHLO out1.migadu.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232803AbhLNKDx (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Tue, 14 Dec 2021 05:03:53 -0500
Subject: Re: [PATCH V2] md: don't unregister sync_thread with reconfig_mutex
 held
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1639476231;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QJqfhqj9RoOLjPpuMR7rqCOh+WalYXGdOdDYofORJSo=;
        b=i2zaVhRJ0otLocVstDpAX0vQTIXbK30hxuXVOjtBvIHKmjPWFOmY3R9JfIteZ8hA3gJVsP
        Mh2RuwfxZWLcddH4NzzGmga3BTbGBEoAitPyajLgHTtB4wEoVSBcLPo+C73c+N7TGZKb0I
        q4Ps+UIfchGNhqLmPDRVgLTqjc6Ux+g=
To:     Donald Buczek <buczek@molgen.mpg.de>, song@kernel.org
Cc:     agk@redhat.com, snitzer@redhat.com, linux-raid@vger.kernel.org,
        dm-devel@redhat.com, Paul Menzel <pmenzel@molgen.mpg.de>
References: <1613177399-22024-1-git-send-email-guoqing.jiang@cloud.ionos.com>
 <8312a154-14fb-6f07-0cf1-8c970187cc49@molgen.mpg.de>
 <87206712-b066-9d1d-3e46-14338e704c1a@linux.dev>
 <75958549-03d4-e396-e761-9956c4b2f991@molgen.mpg.de>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Guoqing Jiang <guoqing.jiang@linux.dev>
Message-ID: <2ed2d0ba-14e9-f708-265e-8fc64902bd93@linux.dev>
Date:   Tue, 14 Dec 2021 18:03:43 +0800
MIME-Version: 1.0
In-Reply-To: <75958549-03d4-e396-e761-9956c4b2f991@molgen.mpg.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: guoqing.jiang@linux.dev
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 12/14/21 5:31 PM, Donald Buczek wrote:

>>>>   -void md_reap_sync_thread(struct mddev *mddev)
>>>> +void md_reap_sync_thread(struct mddev *mddev, bool 
>>>> reconfig_mutex_held)
>>>>   {
>>>>       struct md_rdev *rdev;
>>>>       sector_t old_dev_sectors = mddev->dev_sectors;
>>>>       bool is_reshaped = false;
>>>>         /* resync has finished, collect result */
>>>> +    if (reconfig_mutex_held)
>>>> +        mddev_unlock(mddev);
>>>
>>>
>>> If one thread got here, e.g. via action_store( /* "idle" */ ), now 
>>> that the mutex is unlocked, is there anything which would prevent 
>>> another thread getting  here as well, e.g. via the same path?
>>>
>>> If not, they both might call
>>>
>>>> md_unregister_thread(&mddev->sync_thread);
>>>
>>> Which is not reentrant:
>>>
>>> void md_unregister_thread(struct md_thread **threadp)
>>> {
>>>     struct md_thread *thread = *threadp;
>>>     if (!thread)
>>>         return;
>>>     pr_debug("interrupting MD-thread pid %d\n", 
>>> task_pid_nr(thread->tsk));
>>>     /* Locking ensures that mddev_unlock does not wake_up a
>>>      * non-existent thread
>>>      */
>>>     spin_lock(&pers_lock);
>>>     *threadp = NULL;
>>>     spin_unlock(&pers_lock);
>>>
>>>     kthread_stop(thread->tsk);
>>>     kfree(thread);
>>> }
>>>
>>> This might be a preexisting problem, because the call site in 
>>> dm-raid.c, which you updated to `md_reap_sync_thread(mddev, 
>>> false);`, didn't hold the mutex anyway.
>>>
>>> Am I missing something? Probably, I do.
>>>
>>> Otherwise: Move the deref of threadp in md_unregister_thread() into 
>>> the spinlock scope?
>>
>> Good point, I think you are right.
>>
>> And actually pers_lock does extra service to protect accesses to 
>> mddev->thread (I think it
>> also suitable for mddev->sync_thread ) when the mutex can't be held. 
>> Care to send a patch
>> for it?
>
> I'm really sorry, but it's one thing to point to a possible problem 
> and another thing to come up with a correct solution.

Yes, it is often the reality of life, and we can always correct 
ourselves if there is problem 😎.

> While I think it would be easy to avoid the double free with the 
> spinlock (or maybe atomic RMW) , we surely don't want to hold the 
> spinlock while we are sleeping in kthread_stop(). If we don't hold 
> some kind of lock, what are the side effects of another sync thread 
> being started or any other reconfiguration? Are the existing flags 
> enough to protect us from this? If we do want to hold the lock while 
> waiting for the thread to terminate, should it be made into a mutex? 
> If so, it probably shouldn't be static but moved into the mddev 
> structure. I'd need weeks if not month to figure that out and to feel 
> bold enough to post it.

Thanks for deep thinking about it, I think we can avoid to call 
kthread_stop with spinlock
held. Maybe something like this, but just my raw idea, please have a 
thorough review.

  void md_unregister_thread(struct md_thread **threadp)
  {
-       struct md_thread *thread = *threadp;
-       if (!thread)
+       struct md_thread *thread = READ_ONCE(*threadp);
+
+       spin_lock(&pers_lock);
+       if (!thread) {
+               spin_unlock(&pers_lock);
                 return;
+       }
         pr_debug("interrupting MD-thread pid %d\n", 
task_pid_nr(thread->tsk));
         /* Locking ensures that mddev_unlock does not wake_up a
          * non-existent thread
          */
-       spin_lock(&pers_lock);
         *threadp = NULL;
         spin_unlock(&pers_lock);

-       kthread_stop(thread->tsk);
+       if (IS_ERR_OR_NULL(thread->tsk)) {
+               kthread_stop(thread->tsk);
+               thread->tsk = NULL;
+       }
         kfree(thread);
  }
  EXPORT_SYMBOL(md_unregister_thread);

> I don't want to push work to others, but my own my understanding of md 
> is to narrow.

Me either 😉

Thanks,
Guoqing
