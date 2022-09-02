Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9C4AECAAD5
	for <linux-raid@archiver.kernel.org>; Fri,  2 Sep 2022 10:17:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234836AbiIBKRB (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 2 Sep 2022 06:17:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235392AbiIBKQt (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 2 Sep 2022 06:16:49 -0400
Received: from out0.migadu.com (out0.migadu.com [94.23.1.103])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D9D1BD148;
        Fri,  2 Sep 2022 03:16:48 -0700 (PDT)
Subject: Re: [PATCH -next 2/3] md/raid10: convert resync_lock to use seqlock
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1662113807;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=O40vbZGt1Y5kCW9ypK/tl8Ui47f9mlO/G51Egg7PW/0=;
        b=Js0Kypu7ndSycNbsf6r6dJniSbmwfD10HvhprtHSYqE0B9EpCyhMnF3DvqvdOeWSwtp+fS
        7LjUxftFc920sJDkQgwQiTFKazmF2WAmZnXQtAlTyd3mT2S6mPgKk+sbn0KxgqowJ1Aklb
        dzNG0zLcNybv0wdKRGBrDGP1HKcrxoQ=
To:     Yu Kuai <yukuai1@huaweicloud.com>, song@kernel.org
Cc:     linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
        yi.zhang@huawei.com, "yukuai (C)" <yukuai3@huawei.com>
References: <20220829131502.165356-1-yukuai1@huaweicloud.com>
 <20220829131502.165356-3-yukuai1@huaweicloud.com>
 <3d8859bc-80d6-08b0-fd40-8874df4d3419@linux.dev>
 <1891ec2c-0ccc-681e-31de-fdd28eebce82@huaweicloud.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Guoqing Jiang <guoqing.jiang@linux.dev>
Message-ID: <82f11462-454c-4a5e-d3a2-e71479960eaf@linux.dev>
Date:   Fri, 2 Sep 2022 18:16:44 +0800
MIME-Version: 1.0
In-Reply-To: <1891ec2c-0ccc-681e-31de-fdd28eebce82@huaweicloud.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 9/2/22 6:02 PM, Yu Kuai wrote:
> Hi,
>
> 在 2022/09/02 17:42, Guoqing Jiang 写道:
>> Hi,
>>
>> On 8/29/22 9:15 PM, Yu Kuai wrote:
>>> +static bool wait_barrier_nolock(struct r10conf *conf)
>>> +{
>>> +    unsigned int seq = raw_read_seqcount(&conf->resync_lock.seqcount);
>>> +
>>> +    if (seq & 1)
>>> +        return false;
>>> +
>>> +    if (READ_ONCE(conf->barrier))
>>> +        return false;
>>> +
>>> +    atomic_inc(&conf->nr_pending);
>>> +    if (!read_seqcount_retry(&conf->resync_lock.seqcount, seq))
>>
>> I think 'seq' is usually get from read_seqcount_begin.
>
> read_seqcount_begin will loop untill "req & 1" failed, I'm afraid this
> will cause high cpu usage in come cases.
>
> What I try to do here is just try once, and fall back to hold lock and
> wait if failed.

Thanks for the explanation.

I'd suggest to try with read_seqcount_begin/read_seqcount_retry pattern
because it is a common usage in kernel I think, then check whether the
performance drops or not.  Maybe it is related to lockdep issue, but I am
not sure.

Thanks,
Guoqing
