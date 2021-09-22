Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A98A2C433EF
	for <linux-raid@archiver.kernel.org>; Wed, 22 Sep 2021 18:42:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8526D6109E
	for <linux-raid@archiver.kernel.org>; Wed, 22 Sep 2021 18:42:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237021AbhIVSo1 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 22 Sep 2021 14:44:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbhIVSo1 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 22 Sep 2021 14:44:27 -0400
Received: from mail-il1-x134.google.com (mail-il1-x134.google.com [IPv6:2607:f8b0:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48783C061574
        for <linux-raid@vger.kernel.org>; Wed, 22 Sep 2021 11:42:57 -0700 (PDT)
Received: by mail-il1-x134.google.com with SMTP id b15so3799087ils.10
        for <linux-raid@vger.kernel.org>; Wed, 22 Sep 2021 11:42:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=y21BwIF+NoA4/I2WwwaRUhE7DfHmkcVEgB8kA3JwHe8=;
        b=lZSa6in0fXM5kNZbaNELvzoKNC+H/ou0Ky3d9+U+qWw71g4KaloYLfDPO4dCfygoF5
         gu4y2yfmlqcfucZHfPsvUgmUc3XVf0pTwZi9YAjFnu+0pEyku978OKwnXt5rsDGrO8jk
         kRcGCTSuzN0Xo8efiKQPDdYWt79PxejgJZHGTITVWrRJ91BQ2gLAMV8vRZMKM1Xakz5Y
         4+N1r/vNnxTFXe6o2o1ckIeQYiilW8mV9fI/vwWfeQ8oA5wUs/46hIGWoXR4uGVBepmF
         ZBnh4mJ54AgUURTlkNQfNnp7pPlXcaB3OeG9kXpb1q0Ee5KQJhwNCiQ6Z5BktOg/1DAX
         5lMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=y21BwIF+NoA4/I2WwwaRUhE7DfHmkcVEgB8kA3JwHe8=;
        b=qGTPIWf2ldWt+Jl6+uaqRqoAwudwxI1I9p+5XnMXnIZOtgPgqprlMeZ1KF9eN4mHXH
         0FqOQYn01wpOuegW7EtjCU+uHRcNMzdbX7Rvc6A7cMOl2HGQUww4h5Aumm258IBVRLr5
         j34t/vsf2aB0D8gYPUQyRpHPkW9gyfdHEMUw6ULMYCLAhDBp7YFruEMPPeQfFF6YZ4St
         M1pVyBqIYu7gGthJbTsIt6aMw5S4rhjiyJSod/Q6bNA06aIKPcSIWhIuJAQ1CahNbefJ
         yGtepdrE4ErieS2pYLNgDXZp6EA2kxcGdBa6wvwOt+7TN7nVJN/NNvT8QRM3d7Y4HL1p
         jThg==
X-Gm-Message-State: AOAM532vDrSpoZ2gedbxMSmLOuP4ED3EpS9AHGMEHhg9P8i89zBHJBk9
        TtJJjKChfp9VsVb+tUOSHjRN7kgQGIoUWk4SfeE=
X-Google-Smtp-Source: ABdhPJx06JdvsrpcDQaLWvwJfB1iqnBIFM9BxohGkQLf/n/zX7WapYLoFqM2oiwS/s4B1sj0GaV9Aw==
X-Received: by 2002:a92:cdad:: with SMTP id g13mr379683ild.149.1632336176556;
        Wed, 22 Sep 2021 11:42:56 -0700 (PDT)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id x5sm1308243ioa.35.2021.09.22.11.42.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Sep 2021 11:42:56 -0700 (PDT)
Subject: Re: [GIT PULL] md-fixes 20210922
To:     Song Liu <songliubraving@fb.com>
Cc:     linux-raid <linux-raid@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Luis Chamberlain <mcgrof@kernel.org>
References: <A739EDD6-BF73-458E-B674-D426564E13C0@fb.com>
 <7f6f82a2-0f10-3648-e6ae-4a66e1e50bbb@kernel.dk>
 <DE9C1858-5F06-4E1F-A842-19A6B70D3F4F@fb.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <b79aae3b-bd40-5f8f-5ecc-873d825f8e46@kernel.dk>
Date:   Wed, 22 Sep 2021 12:42:55 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <DE9C1858-5F06-4E1F-A842-19A6B70D3F4F@fb.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 9/22/21 11:38 AM, Song Liu wrote:
> 
> 
>> On Sep 22, 2021, at 9:14 AM, Jens Axboe <axboe@kernel.dk> wrote:
>>
>> On 9/22/21 10:10 AM, Song Liu wrote:
>>> Hi Jens, 
>>>
>>> Please consider pulling the following changes for md-fixes on top of your 
>>> block-5.15 branch. The changes are:
>>>  1. Fix lock order reversal in md_alloc. (Christoph)
>>>  2. Handle add_disk error in md_alloc. (Luis)
>>>  3. Refactor md sysfs attrs, included because of dependency with 1 and 2. 
>>>     (Christoph). 
>>
>> I don't think the error handling for add_disk is prudent at this point,
>> that's something that should go in with the 5.16 cycle. It's been like
>> that forever, nothing that warrants pushing this for 5.15 at all.
> 
> Hmm... I see. The WARN_ON_ONCE at the end of device_add_disk() should be
> enough.

We've had no error handling in add_disk forever, this is not a new issue.


> Then we just need the first commit. Could you please pull the 
> following change instead? 
> 
>   1. Fix lock order reversal in md_alloc. (Christoph)

Looks better, thanks.

-- 
Jens Axboe

