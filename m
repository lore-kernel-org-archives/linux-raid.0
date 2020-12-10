Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF908C0018C
	for <linux-raid@archiver.kernel.org>; Thu, 10 Dec 2020 15:31:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6CEBF23D22
	for <linux-raid@archiver.kernel.org>; Thu, 10 Dec 2020 15:31:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390572AbgLJPaz (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 10 Dec 2020 10:30:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729979AbgLJPam (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 10 Dec 2020 10:30:42 -0500
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 513D2C0613CF
        for <linux-raid@vger.kernel.org>; Thu, 10 Dec 2020 07:30:02 -0800 (PST)
Received: by mail-io1-xd31.google.com with SMTP id o8so5931525ioh.0
        for <linux-raid@vger.kernel.org>; Thu, 10 Dec 2020 07:30:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=CLUcdVoTS0KpV496cqdhKIjPuoIPuM2lnsf6pLV7NtU=;
        b=Unr42VwG5m7A052lIcw00Jv+JlWCDeJx9a7zEmvwCGKr3oTB31eu1MZjV0Ep/Wsz/A
         4h5xvCsKahHKtDv28uQIXVxifEN1nesFDGH7tklzS91s4BoqXldNL3CUhIs8vOCh7mJn
         ykFdDwPfH08WM8Tv1b6Pw+esr8KhhqxYm1QTbsko/VGigU34IzPOXGRRQcwpFp/c7E7h
         w3xoBqjd9nXXGmMABZLQnID3GuwUEI7/ecsFIlpecp70jhlcowpyc9HchPZ6ddR9g5Tq
         fl4YZAJB+ir1uVeaweqjqNv1S3Ywz8PvHZqAb1PweQozDXfbQYC0sP9SqGvXv0JCmK5S
         A7Hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=CLUcdVoTS0KpV496cqdhKIjPuoIPuM2lnsf6pLV7NtU=;
        b=OC2i4JI0Lz09kNbQTe0VVtouDSMAhGZhudK6FcaUKaCKkzjFmpEAd7eIocS1iGO1DO
         bYEC2OoQ2cIpYzQ5Q+NUlyEVHErZaFv8ANMBnFfTGq/99hNfttGS24dXqwk2pUgXsaCq
         ZQL5MxTrEbtZoHX4UjXoAVVL+Czb68Z3w4n5DQoOtKdLrnTfRU17geCHblh3zn6VRGB3
         8mmw4a1fnHPWF2TlHCFJkyJ8/eVMDV/VZQR9eR24uJ82BjTp7kZ28579wzUl4U0AeGOC
         wrvq0FvlYOlfzwDBH3QNjyB9YH6NKGCIh1BNWVMMDxpgJbhrlEnAKCk9MXC87C+tiFWl
         3Npg==
X-Gm-Message-State: AOAM533hTUzD5M5P5AXcCWE7IKEMaqWQJPdwJvDTSF2/wywUVvJOH9sa
        5+omk76k7Gy/6CLLWgDBDjksNg==
X-Google-Smtp-Source: ABdhPJzZip4bmW6pvZRMHsPsYzr6rFNPOEKXNdkqs+pOp3RXtExNSmWQG7OgFJoezOjQnkzbRSUbQw==
X-Received: by 2002:a6b:b5d2:: with SMTP id e201mr5359683iof.111.1607614201641;
        Thu, 10 Dec 2020 07:30:01 -0800 (PST)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id r10sm3468716ilo.34.2020.12.10.07.30.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Dec 2020 07:30:01 -0800 (PST)
Subject: Re: [GIT PULL v2] md-fixes 20201209
To:     Mike Snitzer <snitzer@redhat.com>
Cc:     Song Liu <songliubraving@fb.com>,
        linux-raid <linux-raid@vger.kernel.org>,
        Xiao Ni <xni@redhat.com>,
        Matthew Ruffell <matthew.ruffell@canonical.com>
References: <0C161FAC-8A21-4EAF-B3B4-A7BF04089213@fb.com>
 <aa01f088-c4a5-2eed-3e74-2288554ea98a@kernel.dk>
 <20201210145119.GA9856@redhat.com>
 <00e0d114-e45e-9fbc-0f44-2eb1d81f992d@kernel.dk>
 <20201210152136.GB9856@redhat.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <6fec3df2-c94a-7291-ce3e-89cd7c21728c@kernel.dk>
Date:   Thu, 10 Dec 2020 08:29:59 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201210152136.GB9856@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 12/10/20 8:21 AM, Mike Snitzer wrote:
> On Thu, Dec 10 2020 at  9:53am -0500,
> Jens Axboe <axboe@kernel.dk> wrote:
> 
>> On 12/10/20 7:51 AM, Mike Snitzer wrote:
>>> On Thu, Dec 10 2020 at  9:08am -0500,
>>> Jens Axboe <axboe@kernel.dk> wrote:
>>>
>>>> On 12/9/20 9:59 PM, Song Liu wrote:
>>>>> Hi Jens, 
>>>>>
>>>>> Please consider pulling the following changes on top of your block-5.10 
>>>>> branch. This is to fix raid10 data corruption [1] in 5.10-rc7. 
>>>>
>>>> Pulled, thanks.
>>>
>>> Hi Jens,
>>>
>>> Can you please pick this related revert up too?:
>>> https://patchwork.kernel.org/project/dm-devel/patch/20201209215814.2623617-1-songliubraving@fb.com/
>>>
>>> I asked Song to do so in v2.. seems it got overlooked.
>>>
>>> Patchwork didn't grab my Acked-by, but I did provide it (should be in
>>> your INBOX).
>>
>> I would, but looks like the offending patch isn't even in my block-5.10.
>> So probably best if you just ship that one.
> 
> Ha, you already pulled the dm-raid revert in via Song's v2... I just
> missed that Song _did_ include it in v2 like I asked.

Ah yes indeed, all's well then.

-- 
Jens Axboe

