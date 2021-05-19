Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9F4FC433B4
	for <linux-raid@archiver.kernel.org>; Wed, 19 May 2021 03:42:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A704060FF1
	for <linux-raid@archiver.kernel.org>; Wed, 19 May 2021 03:42:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238952AbhESDnh (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 18 May 2021 23:43:37 -0400
Received: from hammer.websitemanagers.com.au ([59.100.172.130]:58134 "EHLO
        hammer.websitemanagers.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235999AbhESDnh (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Tue, 18 May 2021 23:43:37 -0400
Received: (qmail 14094 invoked by uid 1011); 19 May 2021 03:42:17 -0000
Received: from 192.168.5.101 by hammer (envelope-from <mailinglists@websitemanagers.com.au>, uid 1008) with qmail-scanner-1.24 
 (clamdscan: 0.102.4/25878. spamassassin: 3.4.2.  
 Clear:RC:1(192.168.5.101):. 
 Processed in 0.043861 secs); 19 May 2021 03:42:17 -0000
Received: from unknown (HELO AGMBP2.local) (adamg+websitemanagers.com.au@192.168.5.101)
  by 0 with ESMTPA; 19 May 2021 03:42:16 -0000
Subject: Re: raid10 redundancy
To:     antlists <antlists@youngman.org.uk>,
        Phillip Susi <phill@thesusis.net>
Cc:     Roy Sigurd Karlsbakk <roy@karlsbakk.net>,
        Linux Raid <linux-raid@vger.kernel.org>
References: <CAC6SzHJLG=0_URJUsgQshpk-QLh6b8SBJDrfxiNg4wikQw4uyw@mail.gmail.com>
 <2140221131.2872520.1620837067395.JavaMail.zimbra@karlsbakk.net>
 <87a6oyr64b.fsf@vps.thesusis.net>
 <3f3fd663-77e4-8c23-eb22-1b8223eaf277@turmel.org>
 <87y2ch4c3w.fsf@vps.thesusis.net>
 <947223877.4161967.1621003717636.JavaMail.zimbra@karlsbakk.net>
 <87cztpm68z.fsf@vps.thesusis.net> <60A2EC87.9080701@youngman.org.uk>
 <874kf0yq31.fsf@vps.thesusis.net>
 <d7c8b22d-f74a-409e-4e08-46240bb815e4@youngman.org.uk>
From:   Adam Goryachev <mailinglists@websitemanagers.com.au>
Organization: Website Managers
Message-ID: <35a2f34e-178c-dcd2-b498-cf3fc029ae11@websitemanagers.com.au>
Date:   Wed, 19 May 2021 13:42:16 +1000
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <d7c8b22d-f74a-409e-4e08-46240bb815e4@youngman.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-AU
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org


On 19/5/21 09:48, antlists wrote:
> On 18/05/2021 17:05, Phillip Susi wrote:
>>
>> Wols Lists writes:
>>
>>> When rebuilding a mirror (of any sort), one block written requires ONE
>>> block read. When rebuilding a parity array, one block written requires
>>> one STRIPE read.
>>
>> Again, we're in agreement here.  What you keep ignoring is the fact that
>> both of these take the same amount of time, provided that you are IO 
>> bound.
>>
> And if you've got spinning rust, that's unlikely to be true. I can't 
> speak for SATA, but on PATA I've personally experienced the exact 
> opposite. Doubling the load on the interface absolutely DEMOLISHED 
> throughput, turning what should have been a five-minute job into a 
> several-hours job.
>
> And if you've got many drives in your stripe, who's to say that won't 
> overwhelm the i/o bandwidth. Your reads could be 50% or less of full 
> speed, because there isn't the back end capacity to pass them on.
>
> Cheers,
> Wol

Jumping into this one late, but I thought the main risk was related to 
the fact that for every read there is a chance the device will fail to 
read the data successfully, and so the more data you need to read in 
order to restore redundancy, the greater the risk of not being able to 
regain redundancy.

So, assuming all drives are of equal capacity, you will need to read 
less data to recover a RAID10 than you would to recover a RAID5/6, thus 
a RAID10 has a better chance to recover.

1) speed of recovery (quicker to read 1 x drive capacity instead of n x 
drive capacity even if all in parallel) (unless you can sustain full 
read speed on all devices concurrently I guess).

2) equal load on the single "mirror" device from RAID10 compared to load 
on ALL devices in the RAID5/6.

3) lower impact to operational status (ie, real work load can continue 
without impact on all reads/writes not involving the small part of the 
array being recovered, equal impact for read/write that does involve 
this part of the array).

Right?

Regards,
Adam


