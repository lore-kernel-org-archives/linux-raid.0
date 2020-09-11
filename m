Return-Path: <SRS0=sV2i=CU=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C120C433E2
	for <linux-raid@archiver.kernel.org>; Fri, 11 Sep 2020 22:41:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4B40D221EB
	for <linux-raid@archiver.kernel.org>; Fri, 11 Sep 2020 22:41:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WPDlQD15"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725880AbgIKWlP (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 11 Sep 2020 18:41:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725871AbgIKWlI (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 11 Sep 2020 18:41:08 -0400
Received: from mail-ot1-x330.google.com (mail-ot1-x330.google.com [IPv6:2607:f8b0:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4138C061573
        for <linux-raid@vger.kernel.org>; Fri, 11 Sep 2020 15:41:07 -0700 (PDT)
Received: by mail-ot1-x330.google.com with SMTP id g96so9647873otb.12
        for <linux-raid@vger.kernel.org>; Fri, 11 Sep 2020 15:41:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-transfer-encoding:content-language;
        bh=KVFv3V4t5w927oSbA3UhahP9s5+u3VDxSr4A1cjdvNM=;
        b=WPDlQD15gtM2oWSlc3gNpTSpic7cLws+Ma3WrbZJk/Wj4uhzN9Xpb9Whrn98ZuZve5
         BEMxVdf0GovkGbzuNR+x+gfpGpYyyXe4mqwugI/q+pbZiIcatkAuFyImgdcy2d1uD9Yy
         Te0lAgknRBn4UFsKbmSgoeXhWjUPEcKfXK3CBwwKqCRFEOM4oYjXodjI0+c3GV3Dgzoc
         lcNvO833v4winzJgRdjoO9j+6SAPyuVGyQ8WXzDJ13dmMNI9ylCViuInM21BQ9z7evfT
         Rif8XtNymXvG+2d8Wp33U1FKqsgvc0+AaB7rgvbKr1YU9uhBdaU7vM+UGBqj1ehynVkN
         kslw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=KVFv3V4t5w927oSbA3UhahP9s5+u3VDxSr4A1cjdvNM=;
        b=uBk0yyna+rJQxv4HpO2tr+FrXPSbaiB7kZ0GPNjX+AYhv7cZssVSiULDxRv+dYUOQ9
         m3Y5EzDXgSkhC3Mx1daTIWxNZw2vp8vc10Arpr05sryEjYQZSmAqrLokLPjG3atWeL0Q
         Ujpjsz17osEzJn57Scos5S5i1ShXYXwZ7AP8uF8uk4nPHSeMfiy5HTywxoUmkQzSs7cF
         lSDPXXCFY4prTm4xi/CNwwRYUC/OQ6z+Ys+e4xqSBf6qB0Q2OSAhhJqtmgrIoUWQsdQV
         LUdz0VuTAk28t1Y6ZqnvoDIbkkbTzy06APaF0kVkiHW/wRCt9CALRgAGbRUUPZXl+JC2
         cf7A==
X-Gm-Message-State: AOAM530kBUkQYfxVqLux42aIpUqN7y6d3em4LtqU712cTqfpCsdebOxs
        G7LNlAsIVlnns0PiNMSYALjN89HAzD0=
X-Google-Smtp-Source: ABdhPJw8AMUVFhf/OYTgoQ7ORtb1dsR8dpxE3pQedsc0h9HVrEyiTK685JaXWiakIi6ZoreW1BIUsw==
X-Received: by 2002:a9d:7854:: with SMTP id c20mr2567096otm.123.1599864065833;
        Fri, 11 Sep 2020 15:41:05 -0700 (PDT)
Received: from [192.168.3.75] ([47.187.193.82])
        by smtp.googlemail.com with ESMTPSA id a5sm571185oti.30.2020.09.11.15.41.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Sep 2020 15:41:05 -0700 (PDT)
Subject: Re: Best way to add caching to a new raid setup.
To:     Roger Heflin <rogerheflin@gmail.com>,
        "R. Ramesh" <rramesh@verizon.net>,
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
 <ad54a1fa-2dc7-7e30-b02d-e5aa0d9c7e88@gmail.com>
 <CAAMCDed6HPj3uO8+uUPYb-=5Rurp5LVYsDmMvmmtZiCEi5i39A@mail.gmail.com>
 <377f4acd-a39f-5715-b130-23c395ef0588@verizon.net>
 <CAAMCDefEGFxURV2c6wQjpjwNsos1FoV-sRhh3xzNj70BZa04zQ@mail.gmail.com>
From:   Ram Ramesh <rramesh2400@gmail.com>
Message-ID: <05c0f4f5-3ca1-0971-d29d-0223879d17cf@gmail.com>
Date:   Fri, 11 Sep 2020 17:41:04 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <CAAMCDefEGFxURV2c6wQjpjwNsos1FoV-sRhh3xzNj70BZa04zQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Appreciate the details. I agree spinning down the disk is a good idea to 
consider. I will look more in to it.

Ramesh


On 9/11/20 3:37 PM, Roger Heflin wrote:
> It is simpler, and has very simple to maintain moving parts.  I have
> been a linux admin for 20+ years, and a professional unix admin for
> longer, and too often complicated seems nice but has burned me with
> bugs and other unexpected results, so simple is best.  The daily move
> uses nothing complicated and can be expected to work on any unix
> system that has ever existed and relies on heavily used operations
> that have a high probability of working and of being caught quickly as
> broken if they did not work.  Any of the others are a bit more
> complicated, and more likely to have bugs and less likely to get
> caught as quick as the moving parts I rely on.  I also wanted to be
> able to spin down my array for any hours when no one is watching the
> dvr (usually this is 18+ hours per day, x 7 drives ==   1.25kw/day, or
> 37kw/month, or $4-$10 depending on power costs), and I also have
> motion software collecting security cams that go to the SSD and are
> also copied onto the array nighty.   The security cams would have kept
> the array spinning when anything moved anywhere outside so pretty much
> 100% of the time.
>
> On Fri, Sep 11, 2020 at 1:39 PM R. Ramesh <rramesh@verizon.net> wrote:
>> On 8/30/20 10:42 AM, Roger Heflin wrote:
>>> The LSI should be a good controller as long as you the HBA fw and not
>>> the raid fw.
>>>
>>> I use an LSI with hba + the 8 AMD chipset sata ports, currently I have
>>> 12 ports cabled to hot swap bays but only 7+boot disk used.
>>>
>>> How many recording do you think you will have and how many
>>> clients/watchers?  With the SSD handling the writes for recording my
>>> disks actually spin down if no one is watching anything.
>>>
>>> The other trick the partitions let me do is initially I moved from 1.5
>>> -> 3tb disks (2x750 -> 4x750) and once I got 3-3tbs in I added the 2
>>> more partitions raid6(+1.5TB) (I bought the 3tb drives slowly), then
>>> the next 3tb gets added to all 4 partitions (+3TB).
>>>
>>> On reads at least each disk can do at least 50 iops, and for the most
>>> part the disks themselves are very likely to cache the entire track
>>> the head goes over, so a 2nd sequential read likely comes from the
>>> disk's read cache and does not have to actually be read.  So several
>>> sequential workloads jumping back and forth do not behave as bad as
>>> one would expect.  Write are a different story and a lot more
>>> expensive.  I isloate those to ssd and copy them in the middle of the
>>> night when it is low activity.  And since they are being copied as big
>>> fast streams one file at a time they end up with very few fragments
>>> and write very quickly.   The way I have mine setup mythtv will find
>>> the file whether it is on the ssd recording directory or the raid
>>> recording directory, so when I mv the files nothing has to be done
>>> except the mv.
>>>
>>>
>>> On Sat, Aug 29, 2020 at 7:56 PM Ram Ramesh <rramesh2400@gmail.com> wrote:
>>>> On 8/29/20 4:26 PM, Roger Heflin wrote:
>>>>> It should be worth noting that if you buy 2 exactly the same SSD's at
>>>>> the same time and use them in a mirror they are very likely to be
>>>>> wearing about the same.
>>>>>
>>>>> I am hesitant to go much bigger on disks, especially since the $$/GB
>>>>> really does not change much as the disks get bigger.
>>>>>
>>>>> And be careful of adding on a cheap sata controller as a lot of them work badly.
>>>>>
>>>>> Most of my disks have died from bad blocks causing a section of the
>>>>> disk to have some errors, or bad blocks on sections causing the array
>>>>> to pause for 7 seconds.  Make sure to get a disk with SCTERC settable
>>>>> (timeout when bad blocks happen, otherwise the default timeout is a
>>>>> 60-120seconds, but with it you can set it to no more than 7 seconds).
>>>>>     In the cases where the entire disk did not just stop and is just
>>>>> getting bad blocks in places, typically you have time as only a single
>>>>> section is getting bad blocks, so in this case having sections does
>>>>> help.    Also note that mdadm with 4 sections like I have will only
>>>>> run a single rebuild at a time as mdadm understands that the
>>>>> underlying disks are shared, this makes replacing a disk with 1
>>>>> section or 4 sections basically work pretty much the same.  It does
>>>>> the same thing on the weekly scans, it sets all 4 to scan, and it
>>>>> scans 1 and defers the other scan as disks are shared.
>>>>>
>>>>> It seems to be a disk completely dying is a lot less often than badblock issues.
>>>>>
>>>>> On Sat, Aug 29, 2020 at 3:50 PM Ram Ramesh <rramesh2400@gmail.com> wrote:
>>>>>> On 8/29/20 12:02 AM, Roman Mamedov wrote:
>>>>>>> On Fri, 28 Aug 2020 22:08:22 -0500
>>>>>>> "R. Ramesh" <rramesh@verizon.net> wrote:
>>>>>>>
>>>>>>>> I do not know how SSD caching is implemented. I assumed it will be
>>>>>>>> somewhat similar to memory cache (L2 vs L3 vs L4 etc). I am hoping that
>>>>>>>> with SSD caching, reads/writes to disk will be larger in size and
>>>>>>>> sequential within a file (similar to cache line fill in memory cache
>>>>>>>> which results in memory bursts that are efficient). I thought that is
>>>>>>>> what SSD caching will do to disk reads/writes. I assumed, once reads
>>>>>>>> (ahead) and writes (assuming writeback cache) buffers data sufficiently
>>>>>>>> in the SSD, all reads/writes will be to SSD with periodic well organized
>>>>>>>> large transfers to disk. If I am wrong here then I do not see any point
>>>>>>>> in SSD as a cache. My aim is not to optimize by cache hits, but optimize
>>>>>>>> by preventing disks from thrashing back and forth seeking after every
>>>>>>>> block read. I suppose Linux (memory) buffer cache alleviates some of
>>>>>>>> that. I was hoping SSD will provide next level. If not, I am off in my
>>>>>>>> understanding of SSD as a disk cache.
>>>>>>> Just try it, as I said before with LVM it is easy to remove if it doesn't work
>>>>>>> out. You can always go to the manual copying method or whatnot, but first why
>>>>>>> not check if the automatic caching solution might be "good enough" for your
>>>>>>> needs.
>>>>>>>
>>>>>>> Yes it usually tries to avoid caching long sequential reads or writes, but
>>>>>>> there's also quite a bit of other load on the FS, i.e. metadata. I found that
>>>>>>> browsing directories and especially mounting the filesystem had a great
>>>>>>> benefit from caching.
>>>>>>>
>>>>>>> You are correct that it will try to increase performance via writeback
>>>>>>> caching, however with LVM that needs to be enabled explicitly:
>>>>>>> https://www.systutorials.com/docs/linux/man/7-lvmcache/#lbAK
>>>>>>> And of course a failure of that cache SSD will mean losing some data, even if
>>>>>>> the main array is RAID. Perhaps should consider a RAID of SSDs for cache in
>>>>>>> that case then.
>>>>>>>
>>>>>> Yes, I have 2x500GB ssds for cache. May be, I should do raid1 on them
>>>>>> and use as cache volume.
>>>>>> I thought SSDs are more reliable and even when they begin to die, they
>>>>>> become readonly before quitting.  Of course, this is all theory, and I
>>>>>> do not think standards exists on how they behave when reaching EoL.
>>>>>>
>>>>>> Ramesh
>>>>>>
>>>> My SSDs are from different companies and bought at different times
>>>> (2019/2016, I think).
>>>>
>>>> I have not had many hard disk failures. However, each time I had one, it
>>>> has been a total death. So, I am a bit biased. May be with sections, I
>>>> can replace one md at a time and letting others run degraded. I am sure
>>>> there other tricks. I am simply saying it is a lot of reads/writes, and
>>>> of course computation, in cold replacement of disks in RAID6 vs. RAID1.
>>>>
>>>> Yes, larger disks are not cheaper, but they use one SATA port vs.
>>>> smaller disks. Also, they use less power in the long run (mine run
>>>> 24x7). That is why I have a policy of replacing disks once 2x size disks
>>>> (compared to what I currently own) become commonplace.
>>>>
>>>> I have a LSI 9211 SAS HBA which is touted to be reliable by this community.
>>>>
>>>> Regards
>>>> Ramesh
>>>>
>> Roger,
>>
>>     Just curious, in your search for a SSD solution to mythtv recording,
>> did you consider overlayfs, unionfs or mergerfs? If you did, why did you
>> decide that a simple copy is better?
>>
>> Ramesh
>>

