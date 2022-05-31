Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C21BCC433F5
	for <linux-raid@archiver.kernel.org>; Tue, 31 May 2022 08:14:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244749AbiEaIOG (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 31 May 2022 04:14:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242430AbiEaIOF (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 31 May 2022 04:14:05 -0400
Received: from out1.migadu.com (out1.migadu.com [91.121.223.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B01F8B0A4
        for <linux-raid@vger.kernel.org>; Tue, 31 May 2022 01:14:03 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1653984841;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yHGAvmgIJ+iQdfQFE1hC/ngFNb4J1kX4iQ8Cow0rY9A=;
        b=JnG7wCbAMHAl9/gobbfgIALSZVKdCS7EAH2zX/FHwWRns8PxH3UGOuqpVMZXlmJ+2B1pEP
        wII/aNHxqhAVv1phtijByrcjYHtXmiWjk1giVpwhO0Gu7u80qIQHCzSJ0GZThWGQwnMSCH
        ua2DCtCNFJMuJaSHLGuRk2n5uuCYlCM=
From:   Guoqing Jiang <guoqing.jiang@linux.dev>
Subject: Re: [Update PATCH V3] md: don't unregister sync_thread with
 reconfig_mutex held
To:     Logan Gunthorpe <logang@deltatee.com>,
        Donald Buczek <buczek@molgen.mpg.de>,
        Song Liu <song@kernel.org>
Cc:     linux-raid <linux-raid@vger.kernel.org>
References: <20220505081641.21500-1-guoqing.jiang@linux.dev>
 <20220506113656.25010-1-guoqing.jiang@linux.dev>
 <CAPhsuW6mGnkg4x5xm6x5n06JXxF-7PNubpQiZNmX0BH9Zo1ncA@mail.gmail.com>
 <141b4110-767e-7670-21d5-6a5f636d1207@linux.dev>
 <CAPhsuW6U3g-Xikbw4mAJOH1-kN42rYHLiq_ocv==436azhm33g@mail.gmail.com>
 <b4244eab-d9e2-20a0-ebce-1a96e8fadb91@deltatee.com>
 <836b2a93-65be-8d6c-8610-18373b88f86d@molgen.mpg.de>
 <5b0584a3-c128-cb53-7c8a-63744c60c667@linux.dev>
 <4edc9468-d195-6937-f550-211bccbd6756@molgen.mpg.de>
 <954f9c33-7801-b6d2-65e3-9e5237905886@linux.dev>
 <31a9aed2-16cf-663a-5da3-0f9543ceb8c9@linux.dev>
 <a894c9a2-26c8-2328-1980-7a184a3dc311@deltatee.com>
Message-ID: <1bd5c3f4-415b-c504-8571-5cdffaf6c423@linux.dev>
Date:   Tue, 31 May 2022 16:13:54 +0800
MIME-Version: 1.0
In-Reply-To: <a894c9a2-26c8-2328-1980-7a184a3dc311@deltatee.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 5/31/22 12:35 AM, Logan Gunthorpe wrote:
> On 2022-05-30 03:55, Guoqing Jiang wrote:
>> I tried with 5.18.0-rc3, no problem for 07reshape5intr (will investigate
>> why it failed with this patch), but 07revert-grow still failed without
>> apply this one.
>>
>>   From fail07revert-grow.log, it shows below issues.
>>
>> [ 7856.233515] mdadm[25246]: segfault at 0 ip 000000000040fe56 sp
>> 00007ffdcf252800 error 4 in mdadm[400000+81000]
>> [ 7856.233544] Code: 00 48 8d 7c 24 30 e8 79 30 ff ff 48 8d 7c 24 30 31
>> f6 31 c0 e8 db 34 ff ff 85 c0 79 77 bf 26 50 46 00 b9 04 00 00 00 48 89
>> de <f3> a6 0f 97 c0 1c 00 84 c0 75 18 e8 fa 36 ff ff 48 0f be 53 04 48
>>
>> [ 7866.871747] mdadm[25463]: segfault at 0 ip 000000000040fe56 sp
>> 00007ffe91e39800 error 4 in mdadm[400000+81000]
>> [ 7866.871760] Code: 00 48 8d 7c 24 30 e8 79 30 ff ff 48 8d 7c 24 30 31
>> f6 31 c0 e8 db 34 ff ff 85 c0 79 77 bf 26 50 46 00 b9 04 00 00 00 48 89
>> de <f3> a6 0f 97 c0 1c 00 84 c0 75 18 e8 fa 36 ff ff 48 0f be 53 04 48
>>
>> [ 7876.779855] ======================================================
>> [ 7876.779858] WARNING: possible circular locking dependency detected
>> [ 7876.779861] 5.18.0-rc3-57-default #28 Tainted: G            E
>> [ 7876.779864] ------------------------------------------------------
>> [ 7876.779867] mdadm/25444 is trying to acquire lock:
>> [ 7876.779870] ffff991817749938 ((wq_completion)md_misc){+.+.}-{0:0},
>> at: flush_workqueue+0x87/0x470
>> [ 7876.779879]
>>                  but task is already holding lock:
>> [ 7876.779882] ffff9917c5c1c2c0 (&mddev->reconfig_mutex){+.+.}-{3:3},
>> at: action_store+0x11a/0x2c0 [md_mod]
>> [ 7876.779892]
>>                  which lock already depends on the new lock.
>>
> Hmm, strange. I'm definitely running with lockdep and even if I try the
> test on my machine, on v5.18-rc3, I don't get this error. Not sure why.
>
> In any case it looks like we recently added a
> flush_workqueue(md_misc_wq) call in action_store() which runs with the
> mddev_lock() held. According to your lockdep warning, that can deadlock.

It was originally added by f851b60db if I am not misunderstood.

> That call was added in this commit:
>
> Fixes: cc1ffe61c026 ("md: add new workqueue for delete rdev")

The above fix commit didn't add it. And cc1ffe61c026 was added to avoid 
other
lockdep warnings, IIRC it just added work_pending checking before flush.

> Can we maybe run flush_workqueue() before we take mddev_lock()?

Currently, I am not sure, need to investigate and test. Anyway, it is on 
my todo
list unless someone beats me 😉.

Thanks,
Guoqing
