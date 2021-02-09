Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55570C433DB
	for <linux-raid@archiver.kernel.org>; Tue,  9 Feb 2021 00:48:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1F45C64E7A
	for <linux-raid@archiver.kernel.org>; Tue,  9 Feb 2021 00:48:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229554AbhBIAsF (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 8 Feb 2021 19:48:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229716AbhBIAsE (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 8 Feb 2021 19:48:04 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB7F9C061788
        for <linux-raid@vger.kernel.org>; Mon,  8 Feb 2021 16:47:23 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id s5so21461006edw.8
        for <linux-raid@vger.kernel.org>; Mon, 08 Feb 2021 16:47:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=4YebtuUi/PR5llRiWIYR0zec6xzvQl4vp+Fy366eVCg=;
        b=ViJ7zra8GXrMGdHHelVxDi2/PDb+5DOVThdaIkh3cydSjUqec9hN03QNewygoXDgLG
         jQ0fdBHa4Zso/j/Bf5s+wRCRJWg7ZfiJrOAwDd7z/h9oaFpRsDMhnB2NhkDiRtS6BgOP
         BnwftwwLYdU8yDfO6ADkvrMxehviTxfOwGW7vJiVqPOFUNLZexGSKaF+8gQQW4HUYZSQ
         pOTdEeUCr4+J1eSI4/C0DO5zmi4VeAkYUQfldYtnMeUH/x5t5lBkV1Ux2dWV/GzNkNXY
         KHkM88eI6e4jNRQkkASai4E6CrKXNXZ3xEZvjXqjVhsrVSNBFs59EP6yAEM5mahIUcfZ
         golw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4YebtuUi/PR5llRiWIYR0zec6xzvQl4vp+Fy366eVCg=;
        b=YwF4J4skieZEps83Y0aH6vIkfyJveQBIlIFExYxmcz5NxJ5xlNQ+oXCf+wRo/TPLva
         vldip5P92d6fbRU2aASwtG1pE1KmrT7mKR25lEOYXVHBveCKvKxVFVlItgR0X2t3YbnS
         /GTCbZEYMN8PhkVer6KVXUxE85xv1bw9aEwMde7qmIrtq9Y+DDY5URhfYeDq7+xI0gxX
         QoBFIBe9ObAHOTZzy4vJVSiJPmRK7E5phc8vYI+6SWSUxRjb3J7ghGJ+LrLVADWOOWN/
         7osqIfrAa0pXpHhTbxspSN3w0ngKxSZJjtxISr//sMuWhv99tPft7jFyXpyWXTkHYQja
         sw6A==
X-Gm-Message-State: AOAM531iBt/HJ7zMsKdOyDUcBy3ePDHZ1yKZXzYLu6pEz47GZN1beLs4
        NqkT97g0hD60gsVmo3qT48BaQGBvag3Wm87d
X-Google-Smtp-Source: ABdhPJwg8aA+GqEREbOwxcbR5IpsUsFiwEI9v9uaTNirdPstanSRfk68Fdd0QZA8UYZdnz6ijU0yRA==
X-Received: by 2002:a05:6402:17aa:: with SMTP id j10mr20203634edy.184.1612831642434;
        Mon, 08 Feb 2021 16:47:22 -0800 (PST)
Received: from [0.0.0.0] ([2001:1438:4010:2540:8ad:59ed:fe2a:9dd9])
        by smtp.gmail.com with ESMTPSA id ca15sm7060408edb.90.2021.02.08.16.46.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Feb 2021 16:47:21 -0800 (PST)
Subject: Re: md_raid: mdX_raid6 looping after sync_action "check" to "idle"
 transition
To:     Donald Buczek <buczek@molgen.mpg.de>, Song Liu <song@kernel.org>,
        linux-raid@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        it+raid@molgen.mpg.de
References: <aa9567fd-38e1-7b9c-b3e1-dc2fdc055da5@molgen.mpg.de>
 <37c158cb-f527-34f5-2482-cae138bc8b07@molgen.mpg.de>
 <efb8d47b-ab9b-bdb9-ee2f-fb1be66343b1@molgen.mpg.de>
 <55e30408-ac63-965f-769f-18be5fd5885c@molgen.mpg.de>
 <d95aa962-9750-c27c-639a-2362bdb32f41@cloud.ionos.com>
 <30576384-682c-c021-ff16-bebed8251365@molgen.mpg.de>
 <cdc0b03c-db53-35bc-2f75-93bbca0363b5@molgen.mpg.de>
 <bc342de0-98d2-1733-39cd-cc1999777ff3@molgen.mpg.de>
 <c3390ab0-d038-f1c3-5544-67ae9c8408b1@cloud.ionos.com>
 <a27c5a64-62bf-592c-e547-1e8e904e3c97@molgen.mpg.de>
 <6c7008df-942e-13b1-2e70-a058e96ab0e9@cloud.ionos.com>
 <12f09162-c92f-8fbb-8382-cba6188bfb29@molgen.mpg.de>
 <6757d55d-ada8-9b7e-b7fd-2071fe905466@cloud.ionos.com>
 <93d8d623-8aec-ad91-490c-a414c4926fb2@molgen.mpg.de>
 <0bb7c8d8-6b96-ce70-c5ee-ba414de10561@cloud.ionos.com>
 <e271e183-20e9-8ca2-83eb-225d4d7ab5db@molgen.mpg.de>
 <1cdfceb6-f39b-70e1-3018-ea14dbe257d9@cloud.ionos.com>
 <7733de01-d1b0-e56f-db6a-137a752f7236@molgen.mpg.de>
From:   Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
Message-ID: <d92922af-f411-fc53-219f-154de855cd13@cloud.ionos.com>
Date:   Tue, 9 Feb 2021 01:46:26 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <7733de01-d1b0-e56f-db6a-137a752f7236@molgen.mpg.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Donald,

On 2/8/21 19:41, Donald Buczek wrote:
> Dear Guoqing,
> 
> On 08.02.21 15:53, Guoqing Jiang wrote:
>>
>>
>> On 2/8/21 12:38, Donald Buczek wrote:
>>>> 5. maybe don't hold reconfig_mutex when try to unregister 
>>>> sync_thread, like this.
>>>>
>>>>          /* resync has finished, collect result */
>>>>          mddev_unlock(mddev);
>>>>          md_unregister_thread(&mddev->sync_thread);
>>>>          mddev_lock(mddev);
>>>
>>> As above: While we wait for the sync thread to terminate, wouldn't it 
>>> be a problem, if another user space operation takes the mutex?
>>
>> I don't think other places can be blocked while hold mutex, otherwise 
>> these places can cause potential deadlock. Please try above two lines 
>> change. And perhaps others have better idea.
> 
> Yes, this works. No deadlock after >11000 seconds,
> 
> (Time till deadlock from previous runs/seconds: 1723, 37, 434, 1265, 
> 3500, 1136, 109, 1892, 1060, 664, 84, 315, 12, 820 )

Great. I will send a formal patch with your reported-by and tested-by.

Thanks,
Guoqing
