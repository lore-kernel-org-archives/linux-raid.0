Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75257C433FE
	for <linux-raid@archiver.kernel.org>; Fri, 11 Mar 2022 16:56:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350189AbiCKQ5Y (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 11 Mar 2022 11:57:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348713AbiCKQ5W (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 11 Mar 2022 11:57:22 -0500
Received: from mail-il1-x12e.google.com (mail-il1-x12e.google.com [IPv6:2607:f8b0:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF3281D4503
        for <linux-raid@vger.kernel.org>; Fri, 11 Mar 2022 08:56:18 -0800 (PST)
Received: by mail-il1-x12e.google.com with SMTP id d3so6360086ilr.10
        for <linux-raid@vger.kernel.org>; Fri, 11 Mar 2022 08:56:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=Q3smtxn9OiYv7rGeOsGWVx0uxe5V1xKcWP4ezknIoU4=;
        b=HCodvsBkzMMBGI2QM0Zn0XFHi2i6oFcJsWh7QrHds/a9Y9dp3sSz3fX72F6ERSDXCi
         hReV46UvwdGSOkR/dABYO+YYhGFV5SHMGxHNouZRxdblZwciWAX6zy/0j8UaCNs+/lBO
         qwsIIGZ8el/4qmTcziJD/Dl1QIYFQG3IQQZNUtAmX6BkK5lQVzPJ40ARuKHrYohpyGOQ
         xwZ8dvkf7SMGw/TnOOPdMwfFKGTbrslHNwoNLkLpqWnOVKJWSp2lF/XEkzNHCuW6PL6g
         S+QjTBhPeTTHOuzbDcwrir4glEOOU56HYFRY12y7DiIU04IcmNHwr03e73HJ67WJfLsL
         AIsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Q3smtxn9OiYv7rGeOsGWVx0uxe5V1xKcWP4ezknIoU4=;
        b=MrDiqcdNBl9zxV1o8CzKpQwATGJxcH9uxugmh4KT/INNWGVXqswM5J8++Ly57VD+yY
         wYAknJA6gq8DTFtBsHn8ctT8bQFAKvtTcVFR6WYXQ8FQN4JPHVlyUL/isMEV9dHklj05
         kBYkDujpNIaYJaJRXJCZRTnnOHCcfBdutkxH+kKK2Qa2KIZs+J4+dkumr30T3SOkq5Wz
         rylQ1nXe+cKddPkCvxUUdIDIaQMaSJCe65zFTqdIPWhm4mCsFBaud00SEOfVUhEO+WNS
         +5CDfkO0Pu0psQXAfOI3aFKLWLvyUBerRivV5HWuDNPWIGQlWMmzGPfQQ0VqpmoIsBLC
         /kGQ==
X-Gm-Message-State: AOAM533HlAZlt6Y0vhmbTZXWJOyZmVazOsFQvPROwn+aZUyDcBjaqoYu
        tyZle9IljY2XlHwky4WsVmtxrg==
X-Google-Smtp-Source: ABdhPJz3ImFD+/lzaSB2dcc+NoB91jMOO5GIRuspRE8WpmZxyqONPvuBTBBe3M2lMBgDJswtpoL9jQ==
X-Received: by 2002:a05:6e02:1449:b0:2c2:ed4a:53b9 with SMTP id p9-20020a056e02144900b002c2ed4a53b9mr8106597ilo.165.1647017778009;
        Fri, 11 Mar 2022 08:56:18 -0800 (PST)
Received: from [192.168.1.172] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id h1-20020a056e02052100b002bdfcff2d98sm4558364ils.61.2022.03.11.08.56.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Mar 2022 08:56:17 -0800 (PST)
Message-ID: <800fa121-5da2-e4c0-d756-991f007f0ad4@kernel.dk>
Date:   Fri, 11 Mar 2022 09:56:15 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [EXT] Re: [PATCH 2/2] block: remove the per-bio/request write
 hint.
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>,
        "Bean Huo (beanhuo)" <beanhuo@micron.com>,
        "Luca Porzio (lporzio)" <lporzio@micron.com>,
        Manjong Lee <mj0123.lee@samsung.com>,
        "david@fromorbit.com" <david@fromorbit.com>
Cc:     "hch@lst.de" <hch@lst.de>, "kbusch@kernel.org" <kbusch@kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
        "sagi@grimberg.me" <sagi@grimberg.me>,
        "song@kernel.org" <song@kernel.org>,
        "seunghwan.hyun@samsung.com" <seunghwan.hyun@samsung.com>,
        "sookwan7.kim@samsung.com" <sookwan7.kim@samsung.com>,
        "nanich.lee@samsung.com" <nanich.lee@samsung.com>,
        "woosung2.lee@samsung.com" <woosung2.lee@samsung.com>,
        "yt0928.kim@samsung.com" <yt0928.kim@samsung.com>,
        "junho89.kim@samsung.com" <junho89.kim@samsung.com>,
        "jisoo2146.oh@samsung.com" <jisoo2146.oh@samsung.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>
References: <20220306231727.GP3927073@dread.disaster.area>
 <CGME20220309042324epcas1p111312e20f4429dc3a17172458284a923@epcas1p1.samsung.com>
 <20220309133119.6915-1-mj0123.lee@samsung.com>
 <CO3PR08MB797524ACBF04B861D48AF612DC0B9@CO3PR08MB7975.namprd08.prod.outlook.com>
 <e98948ae-1709-32ef-e1e4-063be38609b1@kernel.dk>
 <CO3PR08MB797562AAE72BC201EB951C6CDC0B9@CO3PR08MB7975.namprd08.prod.outlook.com>
 <d477c7bf-f3a7-ccca-5472-f9cbb05b83c1@kernel.dk>
 <c27a5ec3-f683-d2a7-d5e7-fd54d2baa278@acm.org>
 <PH0PR08MB7889642784B2E1FC1799A828DB0B9@PH0PR08MB7889.namprd08.prod.outlook.com>
 <ef77ef36-df95-8658-ff54-7d8046f5d0e7@kernel.dk>
 <bf221ef4-f4d0-4431-02f3-ef3bea0e8cb2@acm.org>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <bf221ef4-f4d0-4431-02f3-ef3bea0e8cb2@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 3/11/22 9:45 AM, Bart Van Assche wrote:
> On 3/10/22 14:10, Jens Axboe wrote:
>> On 3/10/22 2:52 PM, Bean Huo (beanhuo) wrote:
>>> Yes, in upstream linux and upstream android, there is no such code.
>>> But as we know, mobile customers have used bio->bi_write_hint in their
>>> products for years. And the group ID is set according to
>>> bio->bi_write_hint before passing the CDB to UFS.
>>>
>>>
>>>     lrbp = &hba->lrb[tag];
>>>                  WARN_ON(lrbp->cmd);
>>>               + if(cmd->cmnd[0] == WRITE_10)
>>>                +{
>>>                  +             cmd->cmnd[6] = (0x1f& cmd->request->bio->bi_write_hint);
>>>                +}
>>>                lrbp->cmd = cmd;
>>>                lrbp->sense_bufflen = UFS_SENSE_SIZE;
>>>                lrbp->sense_buffer = cmd->sense_buffer;
>>>
>>> I don't know why they don't push these changes to the community, maybe
>>> it's because changes across the file system and block layers are
>>> unacceptable to the block layer and FS. but for sure we should now
>>> warn them to push to the community as soon as possible.
>>
>> If the code isn't upstream, it's a bit late to start thinking about
>> that now. This feature has existed for 5 years at this point, and the
>> only consumer was NVMe. The upstream kernel cares only about what is
>> in-tree, as that is the only part we can modify and fix. We
>> change/modify internal kernel APIs all the time, which is how tech debt
>> is removed and the long term sanity of the project is maintained. This
>> in turn means that out-of-tree code will break, that's just a natural
>> side effect and something we can't do anything about.
>>
>> If at some point there's a desire to actually try and upstream this
>> support, then we'll be happy to review that patchset. Or you can
>> continue to stay out-of-tree and just patch in what you need. If you're
>> already modifying core code, then that shouldn't be a problem.
> 
> Hi Jens,
> 
> The "upstream first" policy applies to the Android kernel (see also
> https://arstechnica.com/gadgets/2021/09/android-to-take-an-upstream-first-development-model-for-the-linux-kernel/).
> If anyone requests inclusion in the Android kernel tree of a patch
> that is not upstream, that request is rejected unless a very strong
> reason can be provided why it should be included in the Android kernel
> only instead of being sent upstream. It is not clear to me why the
> patch Bean mentioned is not upstream nor in the upstream Android
> kernel tree.
> 
> From a UFS vendor I received the feedback that the F2FS write hint
> information helps to reduce write amplification significantly. If the
> write hint information is retained in the upstream kernel I can help
> with making sure that the UFS patch mentioned above is integrated in
> the upstream Linux kernel.

I'm really not that interested at this point, and I don't want to gate
removal or inclusion of code on some potential future event that may
never happen.

That doesn't mean that the work and process can't continue on the
Android front, the only difference is what the baseline kernel looks
like for the submitted patchset.

Hence I do think we should go ahead as planned, and then we'll just
revisit the topic if/when some actual code comes up.

-- 
Jens Axboe

