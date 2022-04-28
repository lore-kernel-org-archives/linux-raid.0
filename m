Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 677DAC433EF
	for <linux-raid@archiver.kernel.org>; Thu, 28 Apr 2022 01:32:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240712AbiD1Bf1 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 27 Apr 2022 21:35:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229528AbiD1Bf0 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 27 Apr 2022 21:35:26 -0400
Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEF1621E29;
        Wed, 27 Apr 2022 18:32:12 -0700 (PDT)
Subject: Re: [PATCH v2 12/12] md/raid5: Pivot raid5_make_request()
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1651109531;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4TFVQFu0rykJD50E777mtyWIANKFdqBa79MHalLslEQ=;
        b=nheX71NgOZgPiXaNl03bC1a9mLk6ooU9Z1NZqVgGaCSaeBrMUY4pJqDZAwpscMF2+kYgNY
        Oe0B0M7PMkgXUhCfE3J6s3KoyOr3mvGe+VX4W5mgpr4Er2Iyk1pX4WM/aaDWebveumX9zc
        uGjzfzBPELLCMbQ7A6H/cXbHdkHXDls=
To:     Logan Gunthorpe <logang@deltatee.com>,
        linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
        Song Liu <song@kernel.org>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Stephen Bates <sbates@raithlin.com>,
        Martin Oliveira <Martin.Oliveira@eideticom.com>,
        David Sloan <David.Sloan@eideticom.com>
References: <20220420195425.34911-1-logang@deltatee.com>
 <20220420195425.34911-13-logang@deltatee.com>
 <61411981-6401-aaa7-9d3d-6a9ac1fec4f2@linux.dev>
 <67153d42-93c0-def1-95d9-a09678cf343d@deltatee.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Guoqing Jiang <guoqing.jiang@linux.dev>
Message-ID: <2f566b2f-d1a8-d783-a6a2-787051b066c4@linux.dev>
Date:   Thu, 28 Apr 2022 09:32:04 +0800
MIME-Version: 1.0
In-Reply-To: <67153d42-93c0-def1-95d9-a09678cf343d@deltatee.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 4/28/22 12:18 AM, Logan Gunthorpe wrote:
>>> diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
>>> index 638d29863503..e73b58844f83 100644
>>> --- a/drivers/md/raid5.h
>>> +++ b/drivers/md/raid5.h
>>> @@ -308,6 +308,7 @@ enum r5dev_flags {
>>>        R5_Wantwrite,
>>>        R5_Overlap,    /* There is a pending overlapping request
>>>                 * on this block */
>>> +    R5_BioReady,    /* The current bio can be added to this disk */
>> This doesn't seem right to me, since the comment describes bio status
>> while others
>> are probably for r5dev.
> I'm not sure I understand the objection. If you have a better option
> please let me know.

As said, the flag is for r5dev not for bio, please don't make people confuse
about it.

My personal suggestion would be change it to R5_Ready_For_BIO or some
thing else, then update the comment accordingly.

> I'm still working on this patch. Caught a couple more rare bugs that I'm
> working to fix. The next version should also hopefully be clearer.

Thanks,
Guoqing
