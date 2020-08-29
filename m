Return-Path: <SRS0=8aTj=CH=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4357DC433E6
	for <linux-raid@archiver.kernel.org>; Sat, 29 Aug 2020 20:48:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 21A5220774
	for <linux-raid@archiver.kernel.org>; Sat, 29 Aug 2020 20:48:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="REw8JSjy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728509AbgH2Usz (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 29 Aug 2020 16:48:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728406AbgH2Usz (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 29 Aug 2020 16:48:55 -0400
Received: from mail-ot1-x32a.google.com (mail-ot1-x32a.google.com [IPv6:2607:f8b0:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE2F2C061573
        for <linux-raid@vger.kernel.org>; Sat, 29 Aug 2020 13:48:54 -0700 (PDT)
Received: by mail-ot1-x32a.google.com with SMTP id h17so2210793otl.9
        for <linux-raid@vger.kernel.org>; Sat, 29 Aug 2020 13:48:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=d0sw02iWfKET5xbiQJQxTIVLd7w1iSFDZNbsjkdYK2s=;
        b=REw8JSjyXCZaDMv1BEhXSwdCZrTWZUwDO7Ch8CH2aguecsvAO0hl5VPBOixDYlUKEK
         jlkkiPtcp6bkR+VG7QC9inLc/tPfO6wZ8MxgBwFzKvMU6rWpJikduNoMRlnLMy0/J+OD
         hMLZNEH4rjJ41Feo+qHaMvv9mSnjOsgw2pHMpnFTFXzzWcHiyWZcWQe30EbSR26s8Fz5
         8Zq39atzOLdeWN1IWj+Li8DgMflUJsvEQjRuJNDByvxa5P2nnJ7pQeDyH6gJty5hZh9T
         7AXFrjLJ7PIY9D3khsz+Dlnjm5xHG8kjfvx0FfeyEEXZNnISUnSYuc+kv8fgB+zZu+rJ
         umPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=d0sw02iWfKET5xbiQJQxTIVLd7w1iSFDZNbsjkdYK2s=;
        b=tcnronPkJpvH09imE+8BL6IC5EwtMXrof5uwID4WJyep8rsecWC+PipEAXuoWlRSsE
         j0PFQuSMWtKSpNob4LMDKxyiVaJ7+EuskR2maKDqL23x51IEFpGfT/Wk7mXy//hkhkGM
         nevOx4woHsG6krjyiBkLmj8UGAMOujbFCWIAYPi2hyymw5b7F7ikHW6Xj6m/iwwTj4/1
         6lMVrxGvAOLWOvC4np6FFon+M+j5jN3f/5b1+KR8boXbpC5KGrtlnMkSxCM7U/Zq+idX
         tcs9rBkfsi4AlsHdePRec7BY59j9GOyRhXHUKLCY61qMUOBhVSrI9ILFlWAcuYHqpfCJ
         jGZw==
X-Gm-Message-State: AOAM532ezO2fdck6j2GOfPWQ5mn4aAqPLhkTZ8XAgeW2eVGL6qUrxEkf
        QwIgRvnlabM2xQSlM8QRJ0HWBzdIQ2k=
X-Google-Smtp-Source: ABdhPJwE1q3t1hSDIQPKsaXdUWPJqHfI8eDbcxpGtxQu+rX2LjPOSsg4Y5yqWX4E9Z6BX9ucFhft9A==
X-Received: by 2002:a9d:19ca:: with SMTP id k68mr3229975otk.198.1598734133828;
        Sat, 29 Aug 2020 13:48:53 -0700 (PDT)
Received: from [192.168.3.65] ([47.187.193.82])
        by smtp.googlemail.com with ESMTPSA id e15sm683990oie.31.2020.08.29.13.48.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 29 Aug 2020 13:48:53 -0700 (PDT)
Subject: Re: Best way to add caching to a new raid setup.
To:     Roman Mamedov <rm@romanrm.net>, "R. Ramesh" <rramesh@verizon.net>
Cc:     antlists <antlists@youngman.org.uk>,
        Linux Raid <linux-raid@vger.kernel.org>
References: <16cee7f2-38d9-13c8-4342-4562be68930b.ref@verizon.net>
 <16cee7f2-38d9-13c8-4342-4562be68930b@verizon.net>
 <dc91cc7d-02c4-66ee-21b4-bda69be3bbd9@youngman.org.uk>
 <1310d10c-1b83-7031-58e3-0f767b1df71b@gmail.com>
 <101d4a60-916c-fe30-ae7c-994098fe2ebe@youngman.org.uk>
 <694be035-4317-26fd-5eaf-8fdc20019d9b@gmail.com>
 <6872a42c-5c27-e38a-33ab-10ec01723961@youngman.org.uk>
 <d0aeb41b-09d4-b756-05ee-f0b3da486532@verizon.net>
 <20200829100256.57e8d57b@natsu>
From:   Ram Ramesh <rramesh2400@gmail.com>
Message-ID: <55a16008-f6ff-a44f-6e7c-e67bac4b02a6@gmail.com>
Date:   Sat, 29 Aug 2020 15:48:52 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200829100256.57e8d57b@natsu>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 8/29/20 12:02 AM, Roman Mamedov wrote:
> On Fri, 28 Aug 2020 22:08:22 -0500
> "R. Ramesh" <rramesh@verizon.net> wrote:
>
>> I do not know how SSD caching is implemented. I assumed it will be
>> somewhat similar to memory cache (L2 vs L3 vs L4 etc). I am hoping that
>> with SSD caching, reads/writes to disk will be larger in size and
>> sequential within a file (similar to cache line fill in memory cache
>> which results in memory bursts that are efficient). I thought that is
>> what SSD caching will do to disk reads/writes. I assumed, once reads
>> (ahead) and writes (assuming writeback cache) buffers data sufficiently
>> in the SSD, all reads/writes will be to SSD with periodic well organized
>> large transfers to disk. If I am wrong here then I do not see any point
>> in SSD as a cache. My aim is not to optimize by cache hits, but optimize
>> by preventing disks from thrashing back and forth seeking after every
>> block read. I suppose Linux (memory) buffer cache alleviates some of
>> that. I was hoping SSD will provide next level. If not, I am off in my
>> understanding of SSD as a disk cache.
> Just try it, as I said before with LVM it is easy to remove if it doesn't work
> out. You can always go to the manual copying method or whatnot, but first why
> not check if the automatic caching solution might be "good enough" for your
> needs.
>
> Yes it usually tries to avoid caching long sequential reads or writes, but
> there's also quite a bit of other load on the FS, i.e. metadata. I found that
> browsing directories and especially mounting the filesystem had a great
> benefit from caching.
>
> You are correct that it will try to increase performance via writeback
> caching, however with LVM that needs to be enabled explicitly:
> https://www.systutorials.com/docs/linux/man/7-lvmcache/#lbAK
> And of course a failure of that cache SSD will mean losing some data, even if
> the main array is RAID. Perhaps should consider a RAID of SSDs for cache in
> that case then.
>
Yes, I have 2x500GB ssds for cache. May be, I should do raid1 on them 
and use as cache volume.
I thought SSDs are more reliable and even when they begin to die, they 
become readonly before quitting.  Of course, this is all theory, and I 
do not think standards exists on how they behave when reaching EoL.

Ramesh

