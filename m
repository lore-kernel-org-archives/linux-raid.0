Return-Path: <SRS0=sV2i=CU=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7BC3C433E2
	for <linux-raid@archiver.kernel.org>; Fri, 11 Sep 2020 18:39:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6DE6A221F0
	for <linux-raid@archiver.kernel.org>; Fri, 11 Sep 2020 18:39:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=verizon.net header.i=@verizon.net header.b="VfFkrCzR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725844AbgIKSj4 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 11 Sep 2020 14:39:56 -0400
Received: from sonic309-14.consmr.mail.bf2.yahoo.com ([74.6.129.124]:33311
        "EHLO sonic309-14.consmr.mail.bf2.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725730AbgIKSjx (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Fri, 11 Sep 2020 14:39:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=verizon.net; s=a2048; t=1599849591; bh=Zj2H0I47+fns/QM2L8T13ox49NW7I0geg41BZtQ7k/w=; h=Subject:To:Cc:References:From:Date:In-Reply-To:From:Subject; b=VfFkrCzRzjXpFL3IK6AnSe6iidpATxHafXFnnQ/97+9nUFOVVCLmSQFQJrWy9NEy4ZE3fHWQwZEX9S8lEd/MMjVISTE9Mtqn/QqL+aS4CYoclbthE884YG0e3dzC8IebcvHlbl9wBcURSyrjKmEUHJl4N/RrE3NoUorEt1+vx56OTEW+sGlYm6B8UwowxvJ4+TVy2DukpA+fxMYAJpjPZ/e3osruTGyBgqJ7rF1nSpxd898f/DDSoSC7mJfwq9fxMytMvDMWsR/+J0qIID/7f4bYDgmKyrxZcqZyTfsJj8UvX51sRL2Fa67GEVRdkZ+zP+pP3+SC4kq92SflcUBhdw==
X-YMail-OSG: icvX.RMVM1kHyZMLPd0NGL06uNJA2XM2Sbb6ebFyyb01optWGjZxhtjPffPAdqn
 J0Cxm6jYKNEJapz103qOBwMINgcHrzm4zu3niFG98qSSE8cFLEbrKJ7bP.SOIomp0DWF.8Jybk31
 nJJjBGIBdOSu2AaHnt80ltEG.N4h97YJunWQqBp_66jjj5qIxJvMKiQLa4PyGhFH0Gw8rRWQZgGJ
 LRtmnw1CvuVMQNYDUYwWj_NXn41ynq84KhEn0p.dg2juLIxobRqzkOwRV8hYHA2KQ6WM9YG2ZZBc
 VBuDQfDDSp7rrYRTOKZLa6Bx4XLQg4epWyRvN2pvXJv5nshxHfOELDaObvq.kUNRj5wYxz86xEDN
 k3HMKM0SGeeTHWKEF9vELaj9FoIq895QOxErFYJkCEtqUFOLjJJdKXhP2aIzAOklmVrHAQx5Kwnu
 zIVFEm6j41D04sUXNDF8ocy0SBFyM1CwoLeuD9h9pbFclhms4enuFK3MIQqWTfJbrtsqFqX5DttB
 yHP.atXgUJ1U.16GbIK03Cr4.uFJZTYP12Fxndyf.Txe5bDlR8y4P5TRFK3pfeYh_TUN0QZj7WMC
 Sf53m50.5.uQxMCTsXGVq09hwmIxNQPxPdUBCLs7nWGxIQ6IY59ozVygkXm7cVx0fnL2yDDL3fJa
 iMiMpCcKNKW2Z61nJGkq_0rzkXbd4J_S0jZEQ1yFqdcNldhVpd4LiaI7o902Na6vNocvmfgbEqhn
 fAlbLHTlBDyua0dF9zg.xCfvcICtsnNfEoHGE.wAurO93ACm6DImNVKA7pv1c8AneUoLNwEAMVXi
 b6zom.aoHe1Mn9baG8K7UbgV86yz_diKSb1dfAT7BB.o.ApqbtKjK95ej.OA1B8_MZCeVN07bGn9
 p1yGXdd6PrXFLgL14q231iC_ZfraY3GBNK6ynlkMsb.VryiB57sHDRUKjIT1Y010F2tkTRv85WKO
 fG0.2tfEQKFw0yqW3jJEcndbZvj.ArPc5zGvj1OI2Q5N.co3MneOphjdwXFZGJ7LGEDh9cQf5wOm
 4kJHa9wbtNH0IhJRZN76EZQSX7qHatSj4bnfZmmhuSKiK49kWQpvInFto0JFKwWE9jhrL1JzDM49
 NmcE_tOO4gsyfZrIOkH5IscmhqxmsYSkB90b8m3EIho0nXv82OfXY1q21CFkGg2OyNdP7gLqLVV6
 RL3rBNT5MPymTT63K4meqToA1hXJ1GJsxV9vPDkF4Bdnz6aT5zJqWpbCTT4.vEqW2gEPdikSzOoD
 pF3Ep4yaqFK9rK0E4dn4pSJe7VGHauzKaPjHGpuwr6_WsntpiaW1UPkyUGTpKcikKmZpW_vXm4YV
 .hUd5vZxGeO5gu650IHQJ.Q1zV369s9.QR9AWfk2tKx5xewe1reA7z3lZ8qrRGFxt2k3wswkAC2C
 OtQiA1MSZEKWp.RFfpR7B9W6dm_DGZNDTk.oLzpD_oNQniVeQcFvI6X3KOSxaU7DGc8NYNDg6GXl
 mf9MJbTlguiS_IwBeoLvbbwXgbCurGBQD_2IPF37AGsVc1Y0iy7CoIOqXM96f9FN1wVBqfw--
Received: from sonic.gate.mail.ne1.yahoo.com by sonic309.consmr.mail.bf2.yahoo.com with HTTP; Fri, 11 Sep 2020 18:39:51 +0000
Received: by smtp424.mail.ne1.yahoo.com (VZM Hermes SMTP Server) with ESMTPA ID 17bd3cb5e8e6a664c28c4b91eacebb34;
          Fri, 11 Sep 2020 18:39:44 +0000 (UTC)
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
From:   "R. Ramesh" <rramesh@verizon.net>
Message-ID: <377f4acd-a39f-5715-b130-23c395ef0588@verizon.net>
Date:   Fri, 11 Sep 2020 13:39:43 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <CAAMCDed6HPj3uO8+uUPYb-=5Rurp5LVYsDmMvmmtZiCEi5i39A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Mailer: WebService/1.1.16583 mail.backend.jedi.jws.acl:role.jedi.acl.token.atz.jws.hermes.aol Apache-HttpAsyncClient/4.1.4 (Java/11.0.7)
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

   Just curious, in your search for a SSD solution to mythtv recording, 
did you consider overlayfs, unionfs or mergerfs? If you did, why did you 
decide that a simple copy is better?

Ramesh

