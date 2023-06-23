Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C82BEB64D7
	for <linux-raid@archiver.kernel.org>; Fri, 23 Jun 2023 15:17:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232516AbjFWPRf (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 23 Jun 2023 11:17:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231577AbjFWPRT (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 23 Jun 2023 11:17:19 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B37CE35B3
        for <linux-raid@vger.kernel.org>; Fri, 23 Jun 2023 08:16:18 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id d9443c01a7336-1b3ecb17721so1038085ad.0
        for <linux-raid@vger.kernel.org>; Fri, 23 Jun 2023 08:16:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1687533376; x=1690125376;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9UmpiSk2PeJ2MO2bu3RiCBFrjdf9WMDh1Cx5B/8xsFI=;
        b=gL0k4uVoLvvPa31spEITGqADBWx8sUzTOlUaxpcibpQuGJU2yFO2wXbGQJQjDUvXuq
         qy02dUkr10FVWA3S45gutGZbqqTO0MkjeaPke94zqJeilHJLNfsjyCEkTtUB4V/ynkSK
         hTCpd7/0CxQ05X14Topd4FMlP686Ugf4v6aJAiznBTCu825C5nDY1lLod9YLvui6kqr6
         CL5XIw4eSHrXBZI+piGjto5V2Q7BuyAsaZq9LLsndCnfTU/yHQHOGzKnLZ/sVj+yn7SQ
         f5b45mhtjoHS/OBlWSDIL91L06vcTkGBJNN2VR3Gga3MOKqI+0Jk0mzc2ZbOPeflSycs
         j0fA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687533376; x=1690125376;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9UmpiSk2PeJ2MO2bu3RiCBFrjdf9WMDh1Cx5B/8xsFI=;
        b=fqcC3P+8mRxYNlFAav80dPaxseHZwK0RRF1SMB8WFpsTlmn5uTTIkkmVGHvXv/NXw+
         2r6pTWCJkEwHpamBRkUc3FbZ3FPD7D/EypALt1cSoCnC0AMipe3LzRpL1lqIC1QaZ8NQ
         zTnFzYu1nNzKGXIvBTWKttr4yIMxI1jQ1sMiF606waw8ThD6fSDoRCdVFQZOV/0mmpf+
         I6iSQrbBRTPaByjMLHVGOqvDtb1tMcYsHlsiLuc4ntXV/0eRgDdQqSGuAeC33HEtQZhC
         cl/IyJ70s7nrt5Ki5tY8T6uhnwft9zjNrtTgoCbyr9OEl8zi6K6kNLVwFZ7whZGM4jl3
         YzEw==
X-Gm-Message-State: AC+VfDz15WVCG4gYfA9jeMQyYF8qPtTWKgz9r2kTZHJ128cqEhQlGj6i
        xG3jvayKIMGD+ewyG6a81AYLAw==
X-Google-Smtp-Source: ACHHUZ5EPwawicoVzcM7RwAKn446zExGuhHCzOn4wIVCz4sDfYgEsgXFdgS9oubG2MAGbMQRw19jHw==
X-Received: by 2002:a17:902:c945:b0:1ac:40f7:8b5a with SMTP id i5-20020a170902c94500b001ac40f78b5amr25381007pla.3.1687533376282;
        Fri, 23 Jun 2023 08:16:16 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id o16-20020a170902d4d000b001b1c3542f57sm7335746plg.103.2023.06.23.08.16.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Jun 2023 08:16:15 -0700 (PDT)
Message-ID: <480ac9e9-9257-b1a9-520e-50feb54dfdf5@kernel.dk>
Date:   Fri, 23 Jun 2023 09:16:14 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [GIT PULL] md-next 20230622
Content-Language: en-US
To:     Song Liu <songliubraving@meta.com>, Christoph Hellwig <hch@lst.de>
Cc:     linux-raid <linux-raid@vger.kernel.org>,
        Li Nan <linan122@huawei.com>, Yu Kuai <yukuai3@huawei.com>
References: <BCD9738E-472D-4AA7-B4F9-CCF36B5DA0E1@fb.com>
 <83240030-681c-9ff5-6e2c-600e83b0cc71@kernel.dk>
 <392A5BF5-2961-4F2C-A1C6-D6532B5AAFC2@fb.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <392A5BF5-2961-4F2C-A1C6-D6532B5AAFC2@fb.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 6/23/23 9:08?AM, Song Liu wrote:
> Hi Jens, 
> 
> I am so sorry for this problem. 
> 
>> On Jun 23, 2023, at 7:12 AM, Jens Axboe <axboe@kernel.dk> wrote:
>>
>> On 6/22/23 11:48?PM, Song Liu wrote:
>>> Hi Jens, 
>>>
>>> Please consider pulling the following changes for md-next on top of your
>>> for-6.5/block branch. The major changes are:
>>>
>>> 1. Deprecate bitmap file support, by Christoph Hellwig;
>>> 2. Fix deadlock with md sync thread, by Yu Kuai;
>>> 3. Refactor md io accounting, by Yu Kuai.
>>
>> This is quite a lot on the day that I prepare pull requests for the
>> merge window... I've said this many times before, but just to state this
>> in completeness, maybe it'll benefit others too:
>>
>> 1) Major changes for the next release should be sent to me _at least_ 1
>>   week prior to the merge window opening. That way it gets some decent
>>   soak time in linux-next before heading upstream.
> 
> I am aware of the rule. A couple reasons caused a late PR this time:

Then please be explicit when sending out a pull request like this on why
it's late. Otherwise it just looks like a normal pull request, which it
is not. If your original pull request had any kind of explanation on why
so much is being sent so late, then we would not be having this followup
at all...

> 1. Set #1 and set #3 are relatively new, especially set #3, which was
>    first sent earlier this week. Set #2 is older, but there was more
>    discussions on it until recently. (It is still my fault not pushing
>    on set #2 sooner). 
> 
> 2. I wasn't very sure whether there will be a rc8. The announcement for
>    rc7 didn't state it clearly. (Shall I assume there is no rc8 unless
>    Linus states it clearly?)
> 
> 3. I was hoping to group more patches into one PR. I guess this was the 
>    biggest mistake, especially when it is close to the merge window.

Most of the time Linus will be explicit about _maybe_ doing an -rc8, but
it doesn't really change the rule that I should have bigger stuff in the
week between rc6 and rc7. When -rc7 is cut, my for-next branches should
be basically baked and done at that point, and then post -rc7 just fixes
for existing code. If people stick to that rc6-7 timing, then it'll
always work, regardless of an -rc8 happening or not.

Even when Linus has -rc8 musings in his later rc posts, it's not a given
that they will happen. 

>> 2) Minor fixes, either for major pulls that already went into my next
>>   branch or just fixes in general, can be sent anytime and I'll shove
>>   them into the appropriate branch.
>>
>> When bigger stuff gets sent this late, then I have two choices: reject
>> them and tell you to send it in for the next version, or setup a new
>> branch just for this so I can send it to Linus in a later pull in the
>> merge window. Neither of those two options are great - the first one
>> delays you by a release, the second one creates more churn and hassle
>> for me.
> 
> I will prepare another PR with just fixes. 
> 
> Christoph, 
> 
> Please let me know if you need set #1 (deprecate file bitmap) to 
> unblock other work. Otherwise, we will delay it until 6.6. 

I've done a for-6.5/block-late and put your stuff there, but it can be
dropped very easily. It doesn't really matter if Christoph's stuff can
get pushed, it's still a lot of commits late. So regardless of that, the
only real difference with a new PR would be that we'd drop some bits.
It'd still go into a late branch, as it is indeed late.

-- 
Jens Axboe

