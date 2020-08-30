Return-Path: <SRS0=i/ST=CI=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B348C433E6
	for <linux-raid@archiver.kernel.org>; Sun, 30 Aug 2020 00:56:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 54F55207BB
	for <linux-raid@archiver.kernel.org>; Sun, 30 Aug 2020 00:56:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Et0yo44U"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728445AbgH3A4I (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 29 Aug 2020 20:56:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728246AbgH3A4H (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 29 Aug 2020 20:56:07 -0400
Received: from mail-oi1-x236.google.com (mail-oi1-x236.google.com [IPv6:2607:f8b0:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9F73C061573
        for <linux-raid@vger.kernel.org>; Sat, 29 Aug 2020 17:56:06 -0700 (PDT)
Received: by mail-oi1-x236.google.com with SMTP id d189so4042075oig.12
        for <linux-raid@vger.kernel.org>; Sat, 29 Aug 2020 17:56:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=ZznMzbEQ6kbMdSI5fO0pJaHWOE+hLe4/9rGuHAtXDLA=;
        b=Et0yo44UyRR0wRm7/7fSoX/psogXygProt0Uebp1mYVfIC9Vsr9LTrG7GURBufqgzj
         qd7hXbP7PPGxSCQhe2L6PTJQux9CF9VzXtRuhmV6kiWauwt5UQiLCsFAhKtMZ3LbWmCu
         VGhaG27jIMk5rSTXlZ7izpezxyRK17dnxrgIWz3qWM69AdafojnGu+pMc8qU2ULxZSVV
         +5DpULIRfwhmkj6H7aga1nflm1GsVlo7pwdTQ7SUfYlZd2qSATYeXGsoRijMo/2FfZYU
         /2CpfC6+FaKlTeJp1cGtoCbEUL32F7R7xC6LG/ibxTP6Amt/vhiMlTrxTaKcDCIUbF7a
         bS1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=ZznMzbEQ6kbMdSI5fO0pJaHWOE+hLe4/9rGuHAtXDLA=;
        b=roOpSlHyf4aL2XUMOAXtdkuxH+nt0g5YKHfenKKYs0ARrCcDOIYFJf2JMrV2zN2E4b
         JNZJIDKw1Zz4WjyNF2aCt/0xpWzrh5IaQJO5D0iARi4MBO2U4PMoKPdVXR02aoGDHMib
         MzJcrw7sMsVn9Tzr+gfZpUHkAE4t5goCsuqKqQvrpTNMj9RwgkCP0R5IhsPwI7ijry7W
         7fLHt/YLYuTmjhifmHT6k6LWFa3SpNCHwdesgCgk/0/LMaox5wqKcBzmlcDAn8kVJRM7
         9NWfDJ6RevLgHZLDK/krqmM9OszMR8gvBnRlJiTff82h/100w0/Cny+UDDy1yux4GwMN
         U7JQ==
X-Gm-Message-State: AOAM531l9efNEIPzmQLParoblqZ2/YupBP78lfeaR1LcTFLnaXAvrOc0
        15GQdnPHmV7t2xakR3/nMuk7gNCJTC+6Fg==
X-Google-Smtp-Source: ABdhPJxtRydCtLk6jsM1Wka/TfoUPkuC1t4fAwDz1h0JrLoG4IV7uHj2DOtPS4hHCVjE8/tb8k2YcA==
X-Received: by 2002:a54:4698:: with SMTP id k24mr351957oic.102.1598748965668;
        Sat, 29 Aug 2020 17:56:05 -0700 (PDT)
Received: from [192.168.3.65] ([47.187.193.82])
        by smtp.googlemail.com with ESMTPSA id n61sm867247otn.34.2020.08.29.17.56.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 29 Aug 2020 17:56:05 -0700 (PDT)
Subject: Re: Best way to add caching to a new raid setup.
To:     Roger Heflin <rogerheflin@gmail.com>
Cc:     Roman Mamedov <rm@romanrm.net>, "R. Ramesh" <rramesh@verizon.net>,
        antlists <antlists@youngman.org.uk>,
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
 <55a16008-f6ff-a44f-6e7c-e67bac4b02a6@gmail.com>
 <CAAMCDec9xgnoA0OLVJuCNxS4X5aXE7F771X07_rg0RZH-vmU1g@mail.gmail.com>
From:   Ram Ramesh <rramesh2400@gmail.com>
Message-ID: <ad54a1fa-2dc7-7e30-b02d-e5aa0d9c7e88@gmail.com>
Date:   Sat, 29 Aug 2020 19:56:04 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <CAAMCDec9xgnoA0OLVJuCNxS4X5aXE7F771X07_rg0RZH-vmU1g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 8/29/20 4:26 PM, Roger Heflin wrote:
> It should be worth noting that if you buy 2 exactly the same SSD's at
> the same time and use them in a mirror they are very likely to be
> wearing about the same.
>
> I am hesitant to go much bigger on disks, especially since the $$/GB
> really does not change much as the disks get bigger.
>
> And be careful of adding on a cheap sata controller as a lot of them work badly.
>
> Most of my disks have died from bad blocks causing a section of the
> disk to have some errors, or bad blocks on sections causing the array
> to pause for 7 seconds.  Make sure to get a disk with SCTERC settable
> (timeout when bad blocks happen, otherwise the default timeout is a
> 60-120seconds, but with it you can set it to no more than 7 seconds).
>   In the cases where the entire disk did not just stop and is just
> getting bad blocks in places, typically you have time as only a single
> section is getting bad blocks, so in this case having sections does
> help.    Also note that mdadm with 4 sections like I have will only
> run a single rebuild at a time as mdadm understands that the
> underlying disks are shared, this makes replacing a disk with 1
> section or 4 sections basically work pretty much the same.  It does
> the same thing on the weekly scans, it sets all 4 to scan, and it
> scans 1 and defers the other scan as disks are shared.
>
> It seems to be a disk completely dying is a lot less often than badblock issues.
>
> On Sat, Aug 29, 2020 at 3:50 PM Ram Ramesh <rramesh2400@gmail.com> wrote:
>> On 8/29/20 12:02 AM, Roman Mamedov wrote:
>>> On Fri, 28 Aug 2020 22:08:22 -0500
>>> "R. Ramesh" <rramesh@verizon.net> wrote:
>>>
>>>> I do not know how SSD caching is implemented. I assumed it will be
>>>> somewhat similar to memory cache (L2 vs L3 vs L4 etc). I am hoping that
>>>> with SSD caching, reads/writes to disk will be larger in size and
>>>> sequential within a file (similar to cache line fill in memory cache
>>>> which results in memory bursts that are efficient). I thought that is
>>>> what SSD caching will do to disk reads/writes. I assumed, once reads
>>>> (ahead) and writes (assuming writeback cache) buffers data sufficiently
>>>> in the SSD, all reads/writes will be to SSD with periodic well organized
>>>> large transfers to disk. If I am wrong here then I do not see any point
>>>> in SSD as a cache. My aim is not to optimize by cache hits, but optimize
>>>> by preventing disks from thrashing back and forth seeking after every
>>>> block read. I suppose Linux (memory) buffer cache alleviates some of
>>>> that. I was hoping SSD will provide next level. If not, I am off in my
>>>> understanding of SSD as a disk cache.
>>> Just try it, as I said before with LVM it is easy to remove if it doesn't work
>>> out. You can always go to the manual copying method or whatnot, but first why
>>> not check if the automatic caching solution might be "good enough" for your
>>> needs.
>>>
>>> Yes it usually tries to avoid caching long sequential reads or writes, but
>>> there's also quite a bit of other load on the FS, i.e. metadata. I found that
>>> browsing directories and especially mounting the filesystem had a great
>>> benefit from caching.
>>>
>>> You are correct that it will try to increase performance via writeback
>>> caching, however with LVM that needs to be enabled explicitly:
>>> https://www.systutorials.com/docs/linux/man/7-lvmcache/#lbAK
>>> And of course a failure of that cache SSD will mean losing some data, even if
>>> the main array is RAID. Perhaps should consider a RAID of SSDs for cache in
>>> that case then.
>>>
>> Yes, I have 2x500GB ssds for cache. May be, I should do raid1 on them
>> and use as cache volume.
>> I thought SSDs are more reliable and even when they begin to die, they
>> become readonly before quitting.  Of course, this is all theory, and I
>> do not think standards exists on how they behave when reaching EoL.
>>
>> Ramesh
>>
My SSDs are from different companies and bought at different times 
(2019/2016, I think).

I have not had many hard disk failures. However, each time I had one, it 
has been a total death. So, I am a bit biased. May be with sections, I 
can replace one md at a time and letting others run degraded. I am sure 
there other tricks. I am simply saying it is a lot of reads/writes, and 
of course computation, in cold replacement of disks in RAID6 vs. RAID1.

Yes, larger disks are not cheaper, but they use one SATA port vs. 
smaller disks. Also, they use less power in the long run (mine run 
24x7). That is why I have a policy of replacing disks once 2x size disks 
(compared to what I currently own) become commonplace.

I have a LSI 9211 SAS HBA which is touted to be reliable by this community.

Regards
Ramesh

