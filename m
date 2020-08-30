Return-Path: <SRS0=i/ST=CI=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0860C433E6
	for <linux-raid@archiver.kernel.org>; Sun, 30 Aug 2020 17:19:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6B36F20714
	for <linux-raid@archiver.kernel.org>; Sun, 30 Aug 2020 17:19:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="B8YYCSEH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726035AbgH3RTc (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 30 Aug 2020 13:19:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725934AbgH3RTa (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 30 Aug 2020 13:19:30 -0400
Received: from mail-ot1-x334.google.com (mail-ot1-x334.google.com [IPv6:2607:f8b0:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9BEAC061573
        for <linux-raid@vger.kernel.org>; Sun, 30 Aug 2020 10:19:29 -0700 (PDT)
Received: by mail-ot1-x334.google.com with SMTP id a65so3421955otc.8
        for <linux-raid@vger.kernel.org>; Sun, 30 Aug 2020 10:19:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=bY9aWEOL1AdmUmlLg6Z8rID7sS4r5LPM7rC5vaOc76I=;
        b=B8YYCSEHdheUpmmpDBtAvOmvcWHWkc7vCJRu3kL52TnCM6twPYdYZSKlPIxVjshXbu
         LQaCosqzDWvQcF+sGNNNzixqBNxsHEMJXlg+teC3ulL4TfKeBhmqFUzdIOR8LoT6UHcj
         KfPZHJCyjUiPxceUjQLL4j7tqHuuyCeCYjOP/2k+qUAX3Tvbx+mKCzo8bwBr/Z1P4f2a
         9dw60jlVhgfD/RKxsYYqK+hVfxazb8Nadw6UG5+IF6up3d/KSCAIbJ4T+pbngnV2i8lu
         hQFG0RMXGt4RMO1OWdyB2WF9Rqx0/gOgTwzI8sQU/k7Bss3OLLgQP7FSyETEL8wkv6U2
         rukg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=bY9aWEOL1AdmUmlLg6Z8rID7sS4r5LPM7rC5vaOc76I=;
        b=VgbffZ336DQ2Ggs+peXQZ0HZrWldAgDP2IDoYktg/23JKcDGCppU7l6MkKijMFYYFo
         l/0pFu7gzoGqHuG7SVnwqMAEya0zWuO5sugd2AAlRhLjuRayGbz2vkzOkrh+pIJXDnz/
         Erh0ArPDXVdYVwSAIQonHFJqfWfTgfyM+xor1VM9aj/zhnP3UKpdy5tNol2MuvCMqOQO
         ouldER48T0gEZq9MBY5em3erbl5Yphsott3jxc1bct3jYesDJPvzLxd24yiSdLQq3LBx
         fFroBngSzgzHxy1qF3/6IwpnuYZOU8xHQJ2KBR7FAcWIoxWe9xJuRFhiVVP3293ywm3D
         6JWQ==
X-Gm-Message-State: AOAM53357APs6fhiRGzpcEcKB4xMvDIXYyCsXRL22DXD52+zaAqgTtsX
        buB9IIDxQ+fhvYbTH3m4Wdny/sZOsWQ=
X-Google-Smtp-Source: ABdhPJxszuCurXk8z4/D5z70j605EmjU1kW6g/2tb35o4gn6m0dPtNNnn57ZeV/oVQTVhBF8fn6qJA==
X-Received: by 2002:a9d:7305:: with SMTP id e5mr1613956otk.253.1598807964747;
        Sun, 30 Aug 2020 10:19:24 -0700 (PDT)
Received: from [192.168.3.65] ([47.187.193.82])
        by smtp.googlemail.com with ESMTPSA id t1sm1352302ooi.27.2020.08.30.10.19.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 30 Aug 2020 10:19:24 -0700 (PDT)
Subject: Re: Best way to add caching to a new raid setup.
To:     Roger Heflin <rogerheflin@gmail.com>
Cc:     Linux Raid <linux-raid@vger.kernel.org>
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
 <ad54a1fa-2dc7-7e30-b02d-e5aa0d9c7e88@gmail.com>
 <CAAMCDed6HPj3uO8+uUPYb-=5Rurp5LVYsDmMvmmtZiCEi5i39A@mail.gmail.com>
From:   Ram Ramesh <rramesh2400@gmail.com>
Message-ID: <12da829e-d8b1-a2ee-7c0a-7da84788bc39@gmail.com>
Date:   Sun, 30 Aug 2020 12:19:23 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <CAAMCDed6HPj3uO8+uUPYb-=5Rurp5LVYsDmMvmmtZiCEi5i39A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 8/30/20 10:42 AM, Roger Heflin wrote:
> The LSI should be a good controller as long as you the HBA fw and not
> the raid fw.
>
> I use an LSI with hba + the 8 AMD chipset sata ports, currently I have
> 12 ports cabled to hot swap bays but only 7+boot disk used.
>
> How many recording do you think you will have and how many
> clients/watchers?  With the SSD handling the writes for recording my
> disks actually spin down if no one is watching anything.
>
> The other trick the partitions let me do is initially I moved from 1.5
> -> 3tb disks (2x750 -> 4x750) and once I got 3-3tbs in I added the 2
> more partitions raid6(+1.5TB) (I bought the 3tb drives slowly), then
> the next 3tb gets added to all 4 partitions (+3TB).
>
> On reads at least each disk can do at least 50 iops, and for the most
> part the disks themselves are very likely to cache the entire track
> the head goes over, so a 2nd sequential read likely comes from the
> disk's read cache and does not have to actually be read.  So several
> sequential workloads jumping back and forth do not behave as bad as
> one would expect.  Write are a different story and a lot more
> expensive.  I isloate those to ssd and copy them in the middle of the
> night when it is low activity.  And since they are being copied as big
> fast streams one file at a time they end up with very few fragments
> and write very quickly.   The way I have mine setup mythtv will find
> the file whether it is on the ssd recording directory or the raid
> recording directory, so when I mv the files nothing has to be done
> except the mv.
>
>
> On Sat, Aug 29, 2020 at 7:56 PM Ram Ramesh <rramesh2400@gmail.com> wrote:
>> On 8/29/20 4:26 PM, Roger Heflin wrote:
>>> It should be worth noting that if you buy 2 exactly the same SSD's at
>>> the same time and use them in a mirror they are very likely to be
>>> wearing about the same.
>>>
>>> I am hesitant to go much bigger on disks, especially since the $$/GB
>>> really does not change much as the disks get bigger.
>>>
>>> And be careful of adding on a cheap sata controller as a lot of them work badly.
>>>
>>> Most of my disks have died from bad blocks causing a section of the
>>> disk to have some errors, or bad blocks on sections causing the array
>>> to pause for 7 seconds.  Make sure to get a disk with SCTERC settable
>>> (timeout when bad blocks happen, otherwise the default timeout is a
>>> 60-120seconds, but with it you can set it to no more than 7 seconds).
>>>    In the cases where the entire disk did not just stop and is just
>>> getting bad blocks in places, typically you have time as only a single
>>> section is getting bad blocks, so in this case having sections does
>>> help.    Also note that mdadm with 4 sections like I have will only
>>> run a single rebuild at a time as mdadm understands that the
>>> underlying disks are shared, this makes replacing a disk with 1
>>> section or 4 sections basically work pretty much the same.  It does
>>> the same thing on the weekly scans, it sets all 4 to scan, and it
>>> scans 1 and defers the other scan as disks are shared.
>>>
>>> It seems to be a disk completely dying is a lot less often than badblock issues.
>>>
>>> On Sat, Aug 29, 2020 at 3:50 PM Ram Ramesh <rramesh2400@gmail.com> wrote:
>>>> On 8/29/20 12:02 AM, Roman Mamedov wrote:
>>>>> On Fri, 28 Aug 2020 22:08:22 -0500
>>>>> "R. Ramesh" <rramesh@verizon.net> wrote:
>>>>>
>>>>>> I do not know how SSD caching is implemented. I assumed it will be
>>>>>> somewhat similar to memory cache (L2 vs L3 vs L4 etc). I am hoping that
>>>>>> with SSD caching, reads/writes to disk will be larger in size and
>>>>>> sequential within a file (similar to cache line fill in memory cache
>>>>>> which results in memory bursts that are efficient). I thought that is
>>>>>> what SSD caching will do to disk reads/writes. I assumed, once reads
>>>>>> (ahead) and writes (assuming writeback cache) buffers data sufficiently
>>>>>> in the SSD, all reads/writes will be to SSD with periodic well organized
>>>>>> large transfers to disk. If I am wrong here then I do not see any point
>>>>>> in SSD as a cache. My aim is not to optimize by cache hits, but optimize
>>>>>> by preventing disks from thrashing back and forth seeking after every
>>>>>> block read. I suppose Linux (memory) buffer cache alleviates some of
>>>>>> that. I was hoping SSD will provide next level. If not, I am off in my
>>>>>> understanding of SSD as a disk cache.
>>>>> Just try it, as I said before with LVM it is easy to remove if it doesn't work
>>>>> out. You can always go to the manual copying method or whatnot, but first why
>>>>> not check if the automatic caching solution might be "good enough" for your
>>>>> needs.
>>>>>
>>>>> Yes it usually tries to avoid caching long sequential reads or writes, but
>>>>> there's also quite a bit of other load on the FS, i.e. metadata. I found that
>>>>> browsing directories and especially mounting the filesystem had a great
>>>>> benefit from caching.
>>>>>
>>>>> You are correct that it will try to increase performance via writeback
>>>>> caching, however with LVM that needs to be enabled explicitly:
>>>>> https://www.systutorials.com/docs/linux/man/7-lvmcache/#lbAK
>>>>> And of course a failure of that cache SSD will mean losing some data, even if
>>>>> the main array is RAID. Perhaps should consider a RAID of SSDs for cache in
>>>>> that case then.
>>>>>
>>>> Yes, I have 2x500GB ssds for cache. May be, I should do raid1 on them
>>>> and use as cache volume.
>>>> I thought SSDs are more reliable and even when they begin to die, they
>>>> become readonly before quitting.  Of course, this is all theory, and I
>>>> do not think standards exists on how they behave when reaching EoL.
>>>>
>>>> Ramesh
>>>>
>> My SSDs are from different companies and bought at different times
>> (2019/2016, I think).
>>
>> I have not had many hard disk failures. However, each time I had one, it
>> has been a total death. So, I am a bit biased. May be with sections, I
>> can replace one md at a time and letting others run degraded. I am sure
>> there other tricks. I am simply saying it is a lot of reads/writes, and
>> of course computation, in cold replacement of disks in RAID6 vs. RAID1.
>>
>> Yes, larger disks are not cheaper, but they use one SATA port vs.
>> smaller disks. Also, they use less power in the long run (mine run
>> 24x7). That is why I have a policy of replacing disks once 2x size disks
>> (compared to what I currently own) become commonplace.
>>
>> I have a LSI 9211 SAS HBA which is touted to be reliable by this community.
>>
>> Regards
>> Ramesh
>>
Roger,

   Thanks for the details on your SSD setup. Yes, mythtv is supposed to 
find the file from storage group entries regardless of the actual 
location and thus mv is all that is required. However, I have never 
tried to use this feature though. So, it will be a new thing for me.  
Like I said before, I will try the LVM cache and see my disk activities 
are better. If that is not to my satisfaction, I will remove the cache 
and add it differently like you have. I only have a 500GB SSD, but I do 
not think daily recording will be anywhere close to that size.

Regards
Ramesh

