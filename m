Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35837C77B7A
	for <linux-raid@archiver.kernel.org>; Wed, 31 May 2023 01:49:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232098AbjEaBty (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 30 May 2023 21:49:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233909AbjEaBtw (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 30 May 2023 21:49:52 -0400
Received: from out-1.mta0.migadu.com (out-1.mta0.migadu.com [IPv6:2001:41d0:1004:224b::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8515F113
        for <linux-raid@vger.kernel.org>; Tue, 30 May 2023 18:49:50 -0700 (PDT)
Message-ID: <e2c936ce-5832-9d69-919a-c98af673bb3a@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1685497788;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=u48UJmA/2Yjt1kKlLoKXVdzACrCJ2AOYz6a3+Scc6hM=;
        b=QQ/o6PusxfcxNV/jqDmr7ib7MPO7mmnIvGVQd3fIWB7KsmtqT9S7Xd6jKQnDyHaOXXHtlC
        dJIvk9B0YdH4Lumj32Lgwr7B+r2lLn4Gfs3sN7N+1cmSRQPp6ONX+J11oShzrx+6e9vpdx
        T5CFGOOhQEFykdQRL2v/Jd6sPN9DT90=
Date:   Wed, 31 May 2023 09:49:43 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v2] md/raid5: don't allow concurrent reshape with recovery
Content-Language: en-US
To:     Yu Kuai <yukuai1@huaweicloud.com>, song@kernel.org,
        pmenzel@molgen.mpg.de
Cc:     linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
        yi.zhang@huawei.com, yangerkun@huawei.com,
        "yukuai (C)" <yukuai3@huawei.com>
References: <20230529133410.2125914-1-yukuai1@huaweicloud.com>
 <b9fd7105-eadc-29cb-fa2e-24109f4a99b7@linux.dev>
 <e26af7db-a283-47ca-fc61-89af99f52c17@huaweicloud.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Guoqing Jiang <guoqing.jiang@linux.dev>
In-Reply-To: <e26af7db-a283-47ca-fc61-89af99f52c17@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 5/31/23 09:22, Yu Kuai wrote:
> Hi,
>
> 在 2023/05/31 9:06, Guoqing Jiang 写道:
>>
>>
>> On 5/29/23 21:34, Yu Kuai wrote:
>>> From: Yu Kuai <yukuai3@huawei.com>
>>>
>>> Commit 0aecb06e2249 ("md/raid5: don't allow replacement while reshape
>>> is in progress") fixes that replacement can be set if reshape is
>>> interrupted, which will cause that array can't be assembled.

I just pulled md tree, but can't find the commit id either in md-next or 
md-fixes .
gjiang@pc:~/storage/md> git branch
  master
  md-fixes
* md-next
gjiang@pc:~/storage/md> git branch --contain 0aecb06e2249
error: malformed object name 0aecb06e2249

>>> There is a similar problem on the other side, if recovery is
>>> interrupted, then reshape can start, which will cause the same problem.
>>>
>>> Fix the problem by not starting to reshape while recovery is still in
>>> progress.
>>>
>>> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
>>> ---
>>> Changes in v2:
>>>   - fix some typo in commit message.
>>>
>>>   drivers/md/raid5.c | 8 ++++++++
>>>   1 file changed, 8 insertions(+)
>>>
>>> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
>>> index 8686d629e3f2..6615abf54d3f 100644
>>> --- a/drivers/md/raid5.c
>>> +++ b/drivers/md/raid5.c
>>> @@ -8525,6 +8525,7 @@ static int raid5_start_reshape(struct mddev 
>>> *mddev)
>>>       struct r5conf *conf = mddev->private;
>>>       struct md_rdev *rdev;
>>>       int spares = 0;
>>> +    int i;
>>>       unsigned long flags;
>>>       if (test_bit(MD_RECOVERY_RUNNING, &mddev->recovery))
>>> @@ -8536,6 +8537,13 @@ static int raid5_start_reshape(struct mddev 
>>> *mddev)
>>>       if (has_failed(conf))
>>>           return -EINVAL;
>>> +    /* raid5 can't handle concurrent reshape and recovery */
>>> +    if (mddev->recovery_cp < MaxSector)
>>> +        return -EBUSY;
>>> +    for (i = 0; i < conf->raid_disks; i++)
>>> +        if (rdev_mdlock_deref(mddev, conf->disks[i].replacement))
>>> +            return -EBUSY;
>>> +
>>
>> Does it mean reshape and recovery  can happen in parallel without the 
>> change?
>> I really doubt about it given any kind of internal io (resync, 
>> reshape and recovery)
>> is handled by resync thread. And IIUC either md_do_sync or 
>> md_check_recovery
>> should avoid it, no need to do it in personality layer.
>>
>
> They can't, in this case recovery is interrupted, then recovery can't
> make progress, and md_check_recovery() will start reshape, and after
> reshape is done, recovery will continue, and data will be corrupted
> because raid456 reshape doesn't handle replacement.

So, do reshape first then recovery, right? I don't see concurrent 
reshape and recovery
happen based on your description, if concurrent reshape and recovery is 
possible
then I believe we really have big trouble.

> And by the way in raid456 is that if system reboot, this array can't be
> assembled, raid5_run() will fail if reshape and replacement are both
> set.

Assemble an array need to read data from sb, I don't know which place 
record replacement,
I probably misunderstand something.

Thanks,
Guoqing

