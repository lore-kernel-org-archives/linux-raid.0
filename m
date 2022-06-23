Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78753C43334
	for <linux-raid@archiver.kernel.org>; Thu, 23 Jun 2022 01:30:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237496AbiFWBaA (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 22 Jun 2022 21:30:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233608AbiFWB37 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 22 Jun 2022 21:29:59 -0400
Received: from out0.migadu.com (out0.migadu.com [94.23.1.103])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C73A44339C
        for <linux-raid@vger.kernel.org>; Wed, 22 Jun 2022 18:29:57 -0700 (PDT)
Subject: Re: [PATCH V2] md: unlock mddev before reap sync_thread in
 action_store
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1655947795;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9OV3tIIEv6Kh+BNDKZbOPTM/GteKj59hTaGqFl13npM=;
        b=V8vJLCfWrwkonXAxoXg40LdR3HxXWiXVyr55IlxtbWPNvJhZc1qi2jFepNop7zaWbthtlV
        f72zgM9gJcWhtoYi+rvs3pl3o3rHcloFUm/c3J0MZAhE0+VW0xZuoZUZm2x7FcnnlKUC+p
        f+R4ykX6fPIGKo58nT3dfFHLH5yXVBY=
To:     Song Liu <song@kernel.org>
Cc:     Donald Buczek <buczek@molgen.mpg.de>,
        Logan Gunthorpe <logang@deltatee.com>,
        linux-raid <linux-raid@vger.kernel.org>
References: <20220621031129.24778-1-guoqing.jiang@linux.dev>
 <CAPhsuW5SGxiosMw28km7v7bM9qSDRGbLFvyyH1nsAPg2_RcZgA@mail.gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Guoqing Jiang <guoqing.jiang@linux.dev>
Message-ID: <c8fd5b4f-58c7-e85b-f3ba-f3d8a519a059@linux.dev>
Date:   Thu, 23 Jun 2022 09:29:46 +0800
MIME-Version: 1.0
In-Reply-To: <CAPhsuW5SGxiosMw28km7v7bM9qSDRGbLFvyyH1nsAPg2_RcZgA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 6/23/22 7:32 AM, Song Liu wrote:
> On Mon, Jun 20, 2022 at 8:11 PM Guoqing Jiang <guoqing.jiang@linux.dev> wrote:
>> Since the bug which commit 8b48ec23cc51a ("md: don't unregister sync_thread
>> with reconfig_mutex held") fixed is related with action_store path, other
>> callers which reap sync_thread didn't need to be changed.
>>
>> Let's pull md_unregister_thread from md_reap_sync_thread, then fix previous
>> bug with belows.
>>
>> 1. unlock mddev before md_reap_sync_thread in action_store.
>> 2. save reshape_position before unlock, then restore it to ensure position
>>     not changed accidentally by others.
>>
>> Signed-off-by: Guoqing Jiang <guoqing.jiang@linux.dev>
>> ---
>> V2 changes:
>> 1. add set_bit(MD_RECOVERY_INTR, &mddev->recovery) before unregister sync thread
>>
>> And I didn't find regression with this version after run mdadm tests.
>>
>>   drivers/md/dm-raid.c |  1 +
>>   drivers/md/md.c      | 19 +++++++++++++++++--
>>   2 files changed, 18 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
>> index 9526ccbedafb..d43b8075c055 100644
>> --- a/drivers/md/dm-raid.c
>> +++ b/drivers/md/dm-raid.c
>> @@ -3725,6 +3725,7 @@ static int raid_message(struct dm_target *ti, unsigned int argc, char **argv,
>>          if (!strcasecmp(argv[0], "idle") || !strcasecmp(argv[0], "frozen")) {
>>                  if (mddev->sync_thread) {
>>                          set_bit(MD_RECOVERY_INTR, &mddev->recovery);
>> +                       md_unregister_thread(&mddev->sync_thread);
>>                          md_reap_sync_thread(mddev);
>>                  }
>>          } else if (decipher_sync_action(mddev, mddev->recovery) != st_idle)
>> diff --git a/drivers/md/md.c b/drivers/md/md.c
>> index c7ecb0bffda0..04bab0511312 100644
>> --- a/drivers/md/md.c
>> +++ b/drivers/md/md.c
>> @@ -4830,6 +4830,19 @@ action_store(struct mddev *mddev, const char *page, size_t len)
>>                          if (work_pending(&mddev->del_work))
>>                                  flush_workqueue(md_misc_wq);
>>                          if (mddev->sync_thread) {
>> +                               sector_t save_rp = mddev->reshape_position;
>> +
>> +                               mddev_unlock(mddev);
>> +                               set_bit(MD_RECOVERY_INTR, &mddev->recovery);
>> +                               md_unregister_thread(&mddev->sync_thread);
>> +                               mddev_lock_nointr(mddev);
>> +                               /*
>> +                                * set RECOVERY_INTR again and restore reshape
>> +                                * position in case others changed them after
>> +                                * got lock, eg, reshape_position_store and
>> +                                * md_check_recovery.
>> +                                */
> Hmm.. do we really need to handle reshape_position changed case? What would
> break if we don't?

I want to make the behavior consistent with previous code, and 
reshape_position_store
can change it as said in comment.

Anyway, I didn't see regression with mdadm test with or without setting 
reshape_position,
so it is a more conservative way to avoid potential issue. I will remove 
it if you think it is
not necessary.

Thanks,
Guoqing
