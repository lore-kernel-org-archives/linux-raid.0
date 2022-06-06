Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98018C433EF
	for <linux-raid@archiver.kernel.org>; Mon,  6 Jun 2022 09:00:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232288AbiFFJAl (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 6 Jun 2022 05:00:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232468AbiFFJAj (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 6 Jun 2022 05:00:39 -0400
Received: from out2.migadu.com (out2.migadu.com [IPv6:2001:41d0:2:aacc::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F11181862A7
        for <linux-raid@vger.kernel.org>; Mon,  6 Jun 2022 02:00:36 -0700 (PDT)
Subject: Re: [PATCH] md: only unlock mddev from action_store
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1654506034;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eBefRt67dB/z8YySlpgSAg3I0KCJ/wmJJj6BPCnFUto=;
        b=hv50GpS6DJdLnI9eyyf7//rjueed7DqR3GMjXCY5ruWJvKu03a/+7NLeGqUyBQM2OFNJVP
        RZ9ecMa2B53iBBzO7CL7oAPHniPX6LG55WQkZa1iOLIRArOetMmypjkagBCxGXXMxcsjrL
        9g9A94i3com89nACaPE9gIIONiJs9wo=
To:     Xiao Ni <xni@redhat.com>
Cc:     Logan Gunthorpe <logang@deltatee.com>, Song Liu <song@kernel.org>,
        linux-raid <linux-raid@vger.kernel.org>,
        Donald Buczek <buczek@molgen.mpg.de>
References: <20220602134509.16662-1-guoqing.jiang@linux.dev>
 <a6a1183b-35ca-b321-cbd5-08e2a9e29ca3@deltatee.com>
 <04d66d44-dc18-55f7-b044-defcbcf88fe0@linux.dev>
 <CALTww2_f5727NmOQw2=jiqg7DKSyYvEEMqvW_d_9UU0XT6n=4Q@mail.gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Guoqing Jiang <guoqing.jiang@linux.dev>
Message-ID: <f2e7af8c-074a-fc07-58a8-616616c59b64@linux.dev>
Date:   Mon, 6 Jun 2022 17:00:28 +0800
MIME-Version: 1.0
In-Reply-To: <CALTww2_f5727NmOQw2=jiqg7DKSyYvEEMqvW_d_9UU0XT6n=4Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 6/6/22 4:39 PM, Xiao Ni wrote:
> On Mon, Jun 6, 2022 at 11:08 AM Guoqing Jiang <guoqing.jiang@linux.dev> wrote:
>>
>>
>>>> +    }
>>> Maybe instead of the ugly boolean argument we could pull
>>> md_unregister_thread() into all the callers and explicitly unlock in the
>>> single call site that needs it?
>> Sounds good, let me revert previous commit then pull it.
>>
> Hi all
>
> Now md_reap_sync_thread is called by __md_stop_writes, action_store
> and md_check_recovery.
> If we move md_unregister_thread out of md_reap_sync_thread and unlock
> reconfig_mutex before
> calling md_unregister_thread, it means we break the atomic action for
> these three functions mentioned
> above.

No, only action_store need to be changed, other callers keep the original
behavior.

>   Not sure if it can introduce other problems, especially for the
> change of md_check_recovery.
>
> How about suspend I/O when changing the sync action? It should not
> hurt the performance, because
> it only interrupts the sync action and flush the in memory stripes.
> For this way, it needs to revert
> 7e6ba434cc60 (md: don't unregister sync_thread with reconfig_mutex
> held) and changes like this:
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index ce9d2845d3ac..af28cdeaf7e1 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -4827,12 +4827,14 @@ action_store(struct mddev *mddev, const char
> *page, size_t len)
>                          clear_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
>                  if (test_bit(MD_RECOVERY_RUNNING, &mddev->recovery) &&
>                      mddev_lock(mddev) == 0) {
> +                       mddev_suspend(mddev);
>                          if (work_pending(&mddev->del_work))
>                                  flush_workqueue(md_misc_wq);
>                          if (mddev->sync_thread) {
>                                  set_bit(MD_RECOVERY_INTR, &mddev->recovery);
>                                  md_reap_sync_thread(mddev);
>                          }
> +                       mddev_resume(mddev);
>                          mddev_unlock(mddev);
>                  }
>          } else if (test_bit(MD_RECOVERY_RUNNING, &mddev->recovery))

The action actually means sync action which are for internal IO instead
of external IO, I suppose the semantic is different with above change.

And there are lots of sync/locking actions in suspend path, I am not
sure it will cause other locking issues, you may need to investigate it.

Thanks,
Guoqing
