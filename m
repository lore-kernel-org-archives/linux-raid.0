Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67814C433E0
	for <linux-raid@archiver.kernel.org>; Tue, 12 Jan 2021 11:31:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2757F22B37
	for <linux-raid@archiver.kernel.org>; Tue, 12 Jan 2021 11:31:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728315AbhALLbh (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 12 Jan 2021 06:31:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728304AbhALLbg (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 12 Jan 2021 06:31:36 -0500
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 687FBC061575
        for <linux-raid@vger.kernel.org>; Tue, 12 Jan 2021 03:30:55 -0800 (PST)
Received: by mail-wm1-x32b.google.com with SMTP id a6so1610157wmc.2
        for <linux-raid@vger.kernel.org>; Tue, 12 Jan 2021 03:30:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=from:subject:to:references:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=CKGZAq37IiC/rLpa0PMppscGc9SbK8FOMblF+AVzGgk=;
        b=il6R0TaDO5fF09xHDzGZjcEKZKJ/owBW7nGsfct59XCX9waR8wFD8aKXzgYbbOMi3M
         MKFjcfOrG65z9zGlfn/LIQAHlF+HqeHkZ9B9koQuQoco0rKlKvIQ7RR80qf57hCosT6E
         yZlVKlGAlUwsv6BrKxdr4ldm1CIQGwTAj7+nlZImzLgr4lNq0SWwEnRGzBRvuDFUXigp
         j2fs6mgVLmkzr9w3RwvIMB0mNSl6Mwrc3BAyvsp7Yz+lNc5fO/QMCd7lYldenhGpvA5T
         +ydi2r11AzKKoU/AjprgJcJKHbVgEo9NpOiVMCp/2hvKFxqWPWvnI+jCe3AUoFtB/tL3
         iWGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=CKGZAq37IiC/rLpa0PMppscGc9SbK8FOMblF+AVzGgk=;
        b=QrWV+DtOMNPcE0DLIV/z6yAsnyllBGMZ0p+myuvJeYyuN2ChekgoXSzPvODa4W51+9
         jp5FTgUPKak0nNToD1Gyaq3oWkcGO26INn2kOVM7FijINjiEm0l+dHt43qsB50roolD3
         UIFPT4JvK/Zk+5Zhcpd5pP3XAAVMiuYOKOelgR0xCFRseVTD+JrpnrMD1du+HINf3rCy
         AI3NRRAofgt8p9/f1NWwqiNzp08gmo6p46y4mZippkek2vGr6PNzYSUVqAXfQQLoiZwa
         QEZycisELjcPflPVmF2rQmIPBA+DymIvq1vBxaZDD+VeTev0xc35kDiVyP63TJOkvcL4
         B1YQ==
X-Gm-Message-State: AOAM5323mXVeT1wTpiJoBqM46QCrX8Sbq3CcB4qdLvh4nOLFfSwblNDG
        4Jg21NySL363bwXiQyJX8zCZKjbAn3YPYQ==
X-Google-Smtp-Source: ABdhPJwOehAonjdZMfrCwWl4Z9/j94E2MBu7FaPjwZV9spkpke4qVy0s9y3QT0QA7r0pIaw1w6k5fg==
X-Received: by 2002:a7b:c259:: with SMTP id b25mr3242623wmj.40.1610451053777;
        Tue, 12 Jan 2021 03:30:53 -0800 (PST)
Received: from ?IPv6:240e:304:2c80:9157:bc1a:d197:711d:3085? ([240e:304:2c80:9157:bc1a:d197:711d:3085])
        by smtp.gmail.com with ESMTPSA id i11sm3296557wmd.47.2021.01.12.03.30.52
        for <linux-raid@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Jan 2021 03:30:53 -0800 (PST)
From:   Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
Subject: Re: "md/raid10:md5: sdf: redirecting sector 2979126480 to another
 mirror"
To:     linux-raid@vger.kernel.org
References: <20210106232716.GY3712@bitfolk.com>
 <a5c10248-9835-dec9-2ac2-a72b9a49deff@cloud.ionos.com>
 <20210112020336.GJ3712@bitfolk.com>
Message-ID: <e090f945-d616-bd93-cc61-268cf881c367@cloud.ionos.com>
Date:   Tue, 12 Jan 2021 12:30:37 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210112020336.GJ3712@bitfolk.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Andy,

On 1/12/21 03:03, Andy Smith wrote:
> Hi Guoqing,
> 
> Thanks for following up on this. I have a couple of questions.
> 
> On Tue, Jan 12, 2021 at 01:36:55AM +0100, Guoqing Jiang wrote:
>> On 1/7/21 00:27, Andy Smith wrote:
>>> err_rdev there can only be set inside the block above that starts
>>> with:
>>>
>>>      if (r10_bio->devs[slot].rdev) {
>>>          /*
>>>           * This is an error retry, but we cannot
>>>           * safely dereference the rdev in the r10_bio,
>>>           * we must use the one in conf.
>>>
>>> …but why is this an error retry? Nothing was logged so how do I find
>>> out what the error was?
>>
>> This is because handle_read_error also calls raid10_read_request, pls see
>> commit 545250f2480 ("md/raid10: simplify handle_read_error()").
> 
> So if I understand you correctly, this is a consequence of
> raid10_read_request being reworked so that it can be called by
> handle_read_error, but in my case it is not being called by
> handle_read_error but instead raid10_make_request and is incorrectly
> going down an error path and reporting a redirected read?

Yes, that is my guess too if the message appears but there is no read 
issue from component device.

> 
>  From my stack trace it seemed that it was just
> raid10.c:__make_request that was calling raid10_read_request but I
> could not see where in __make_request the r10_bio->devs[slot].rdev
> was being set, enabling the above test to succeed. All I could see
> was a memset to 0.

IIUC, the rdev is set in raid10_run instead of before dispatch IO request.

> 
> I understand that your patch makes it so this test can no longer
> succeed when being called by __make_request, meaning that aside from
> not logging about a redirected read it will also not do the
> rcu_read_lock() / rcu_dereference() / rcu_read_unlock() that's in
> that if block. Is that a significant amount of work that is being
> needlessly done right now or is it trivial?

I think check if raid10_read_request is called from read error path is 
enough.

> 
> I'm trying to understand how big of a problem this is, beyond some
> spurious logging.
> 
> Right now when it is logging about redirecting a read, does that
> mean that it isn't actually redirecting a read? That is, when it
> says:
> 
> Jan 11 17:10:40 hostname kernel: [1318773.480077] md/raid10:md3: nvme1n1p5: redirecting sector 699122984 to another mirror
> 
> in the absence of any other error logging it is in fact its first
> try at reading and it will really be using device nvme1n1p5 (rdev)
> to satisfy that?
> 
> I suppose I am also confused why this happens so rarely. I can only
> encourage it to happen a couple of times by putting the array under
> very heavy read load, and it only seems to happen with pretty high
> performing arrays (all SSD). But perhaps that is the result of the
> rate-limited logging with pr_err_ratelimited() causing me to only
> see very few of the actual events.

If the message ("redirecting sector ...") is not comes from handle read 
err path, then I suppose the message is false alarm.


Thanks,
Guoqing
