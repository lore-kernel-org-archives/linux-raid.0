Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF18EC6FD1D
	for <linux-raid@archiver.kernel.org>; Tue, 14 Mar 2023 13:56:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232502AbjCNN4f (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 14 Mar 2023 09:56:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232524AbjCNN4R (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 14 Mar 2023 09:56:17 -0400
Received: from out-51.mta1.migadu.com (out-51.mta1.migadu.com [IPv6:2001:41d0:203:375::33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 394414740B
        for <linux-raid@vger.kernel.org>; Tue, 14 Mar 2023 06:55:17 -0700 (PDT)
Message-ID: <2af18cf7-05eb-f1d1-616a-2c5894d1ac43@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1678802112;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0ZQlDRsJJLo9jRATZRTI3E9uhgKx5QuX4i91g5Gttno=;
        b=c8R5Q3IZ4RmCiO68HHIoZsYNwb1sbqBCM6LGomm+7cFpTfOzjCzfpr/9gl0YbMrPE0LSvE
        mGRHb8NuAsOJ2mScz5HIK3jpMTJiw6a2arPbqnjszYVNBQjq1jcmIdt10zt4J/lt+q961E
        qUM2PND9e86U4qbAop1oaqXUW2z2E5k=
Date:   Tue, 14 Mar 2023 21:55:08 +0800
MIME-Version: 1.0
Subject: Re: md_raid: mdX_raid6 looping after sync_action "check" to "idle"
 transition
Content-Language: en-US
To:     Marc Smith <msmith626@gmail.com>
Cc:     Donald Buczek <buczek@molgen.mpg.de>, Song Liu <song@kernel.org>,
        linux-raid@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        it+raid@molgen.mpg.de
References: <aa9567fd-38e1-7b9c-b3e1-dc2fdc055da5@molgen.mpg.de>
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
 <e271e183-20e9-8ca2-83eb-225d4d7ab5db@molgen.mpg.de>
 <1cdfceb6-f39b-70e1-3018-ea14dbe257d9@cloud.ionos.com>
 <7733de01-d1b0-e56f-db6a-137a752f7236@molgen.mpg.de>
 <d92922af-f411-fc53-219f-154de855cd13@cloud.ionos.com>
 <CAH6h+hf7Y-kurBJG+pnH6WCQiaEK+Jq3KG5JOGnHJ4Uw6AbUjg@mail.gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Guoqing Jiang <guoqing.jiang@linux.dev>
In-Reply-To: <CAH6h+hf7Y-kurBJG+pnH6WCQiaEK+Jq3KG5JOGnHJ4Uw6AbUjg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 3/14/23 21:25, Marc Smith wrote:
> On Mon, Feb 8, 2021 at 7:49 PM Guoqing Jiang
> <guoqing.jiang@cloud.ionos.com> wrote:
>> Hi Donald,
>>
>> On 2/8/21 19:41, Donald Buczek wrote:
>>> Dear Guoqing,
>>>
>>> On 08.02.21 15:53, Guoqing Jiang wrote:
>>>>
>>>> On 2/8/21 12:38, Donald Buczek wrote:
>>>>>> 5. maybe don't hold reconfig_mutex when try to unregister
>>>>>> sync_thread, like this.
>>>>>>
>>>>>>           /* resync has finished, collect result */
>>>>>>           mddev_unlock(mddev);
>>>>>>           md_unregister_thread(&mddev->sync_thread);
>>>>>>           mddev_lock(mddev);
>>>>> As above: While we wait for the sync thread to terminate, wouldn't it
>>>>> be a problem, if another user space operation takes the mutex?
>>>> I don't think other places can be blocked while hold mutex, otherwise
>>>> these places can cause potential deadlock. Please try above two lines
>>>> change. And perhaps others have better idea.
>>> Yes, this works. No deadlock after >11000 seconds,
>>>
>>> (Time till deadlock from previous runs/seconds: 1723, 37, 434, 1265,
>>> 3500, 1136, 109, 1892, 1060, 664, 84, 315, 12, 820 )
>> Great. I will send a formal patch with your reported-by and tested-by.
>>
>> Thanks,
>> Guoqing
> I'm still hitting this issue with Linux 5.4.229 -- it looks like 1/2
> of the patches that supposedly resolve this were applied to the stable
> kernels, however, one was omitted due to a regression:
> md: don't unregister sync_thread with reconfig_mutex held (upstream
> commit 8b48ec23cc51a4e7c8dbaef5f34ebe67e1a80934)
>
> I don't see any follow-up on the thread from June 8th 2022 asking for
> this patch to be dropped from all stable kernels since it caused a
> regression.
>
> The patch doesn't appear to be present in the current mainline kernel
> (6.3-rc2) either. So I assume this issue is still present there, or it
> was resolved differently and I just can't find the commit/patch.

It should be fixed by commit 9dfbdafda3b3"md: unlock mddev before reap
sync_thread in action_store".

Thanks,
Guoqing
