Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97E93C43334
	for <linux-raid@archiver.kernel.org>; Mon,  6 Jun 2022 09:55:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233118AbiFFJzU (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 6 Jun 2022 05:55:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232991AbiFFJzQ (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 6 Jun 2022 05:55:16 -0400
Received: from out2.migadu.com (out2.migadu.com [IPv6:2001:41d0:2:aacc::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52BDC11046E
        for <linux-raid@vger.kernel.org>; Mon,  6 Jun 2022 02:55:15 -0700 (PDT)
Subject: Re: [PATCH] md: only unlock mddev from action_store
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1654509313;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eEXFnFZbE3Ip6oh+D6oLffND31id3lRmR4w8qUEJaMo=;
        b=KyjEXKiA9TkuCwrm+M7vtIWvoWWf26ZxyVz4v8ejKb+YBATPjH4+V2+4VuQtyJLG77WcxK
        3A54HEQiZmw8813sNfeN16ZiL7wgJOE6Mv6u7M0rqG70jI0ipSD8jXeD2rE0UOHaL7CPUR
        ndIjG+XadtZ88dZ7kV6yxJHWztx+fwg=
To:     Xiao Ni <xni@redhat.com>
Cc:     Logan Gunthorpe <logang@deltatee.com>, Song Liu <song@kernel.org>,
        linux-raid <linux-raid@vger.kernel.org>,
        Donald Buczek <buczek@molgen.mpg.de>
References: <20220602134509.16662-1-guoqing.jiang@linux.dev>
 <a6a1183b-35ca-b321-cbd5-08e2a9e29ca3@deltatee.com>
 <04d66d44-dc18-55f7-b044-defcbcf88fe0@linux.dev>
 <CALTww2_f5727NmOQw2=jiqg7DKSyYvEEMqvW_d_9UU0XT6n=4Q@mail.gmail.com>
 <f2e7af8c-074a-fc07-58a8-616616c59b64@linux.dev>
 <CALTww2-GtH7g5Z1-e73TOE_xDGvDF___LcUq-FO53yeHqoGYUQ@mail.gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Guoqing Jiang <guoqing.jiang@linux.dev>
Message-ID: <a709dffa-84b4-281f-45c5-a52634c632a6@linux.dev>
Date:   Mon, 6 Jun 2022 17:55:06 +0800
MIME-Version: 1.0
In-Reply-To: <CALTww2-GtH7g5Z1-e73TOE_xDGvDF___LcUq-FO53yeHqoGYUQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 6/6/22 5:36 PM, Xiao Ni wrote:
>>> @@ -4827,12 +4827,14 @@ action_store(struct mddev *mddev, const char
>>> *page, size_t len)
>>>                           clear_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
>>>                   if (test_bit(MD_RECOVERY_RUNNING, &mddev->recovery) &&
>>>                       mddev_lock(mddev) == 0) {
>>> +                       mddev_suspend(mddev);
>>>                           if (work_pending(&mddev->del_work))
>>>                                   flush_workqueue(md_misc_wq);
>>>                           if (mddev->sync_thread) {
>>>                                   set_bit(MD_RECOVERY_INTR, &mddev->recovery);
>>>                                   md_reap_sync_thread(mddev);
>>>                           }
>>> +                       mddev_resume(mddev);
>>>                           mddev_unlock(mddev);
>>>                   }
>>>           } else if (test_bit(MD_RECOVERY_RUNNING, &mddev->recovery))
>> The action actually means sync action which are for internal IO instead
>> of external IO, I suppose the semantic is different with above change.
> The original problem should be i/o happen when interrupting the sync thread?
> So the external i/o calls md_write_start and sets MD_SB_CHANGE_PENDING.
> Then raid5d->md_check_recovery can't update superblock and handle internal
> stripes. So the `echo idle` action is stuck.

My point is action_store shouldn't disturb external IO, it should only 
deal with
sync IO and relevant stuffs as the function is for sync_action node, no?

Thanks,
Guoqing
