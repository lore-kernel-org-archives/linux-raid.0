Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD5FAC433ED
	for <linux-raid@archiver.kernel.org>; Thu, 20 May 2021 01:39:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8328460551
	for <linux-raid@archiver.kernel.org>; Thu, 20 May 2021 01:39:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230137AbhETBk0 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 19 May 2021 21:40:26 -0400
Received: from hammer.websitemanagers.com.au ([59.100.172.130]:40302 "EHLO
        hammer.websitemanagers.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230088AbhETBkZ (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Wed, 19 May 2021 21:40:25 -0400
Received: (qmail 14714 invoked by uid 1011); 20 May 2021 01:32:23 -0000
Received: from 192.168.5.101 by hammer (envelope-from <mailinglists@websitemanagers.com.au>, uid 1008) with qmail-scanner-1.24 
 (clamdscan: 0.102.4/25878. spamassassin: 3.4.2.  
 Clear:RC:1(192.168.5.101):. 
 Processed in 0.046959 secs); 20 May 2021 01:32:23 -0000
Received: from unknown (HELO AGMBP2.local) (adamg+websitemanagers.com.au@192.168.5.101)
  by 0 with ESMTPA; 20 May 2021 01:32:23 -0000
Subject: Re: raid10 redundancy
To:     Phillip Susi <phill@thesusis.net>
Cc:     antlists <antlists@youngman.org.uk>,
        Roy Sigurd Karlsbakk <roy@karlsbakk.net>,
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
 <35a2f34e-178c-dcd2-b498-cf3fc029ae11@websitemanagers.com.au>
 <87im3e50sz.fsf@vps.thesusis.net>
From:   Adam Goryachev <mailinglists@websitemanagers.com.au>
Organization: Website Managers
Message-ID: <d4e9070c-e80f-3f1b-4d26-21caf1318eb6@websitemanagers.com.au>
Date:   Thu, 20 May 2021 11:32:22 +1000
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <87im3e50sz.fsf@vps.thesusis.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-AU
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org


On 19/5/21 23:02, Phillip Susi wrote:
> Adam Goryachev writes:
>
>> Jumping into this one late, but I thought the main risk was related to
>> the fact that for every read there is a chance the device will fail to
>> read the data successfully, and so the more data you need to read in
>> order to restore redundancy, the greater the risk of not being able to
>> regain redundancy.
> Also the assumption that the drives tend to fail after about the same
> number of reads, and since all of the drives in the array have had about
> the same number of reads, by the time you get the first failure, a
> second likely is not far behind.
>
> Both of these assumptions are about as flawed as the mistaken belief
> that many have that based on the bit error rates published by drive
> manufacturers, that if you read the entire multi TB drive, odds are
> quite good that you will get an uncorrectable error.  I've tried it
> many times and it doesn't work that way.

Except that is not what I said. I said the risk is increased for each 
read required. I didn't say that you *will* experience a read failure. 
It's all about reducing risks without increasing costs to the point that 
there is no benefit gained. Your costs and benefits will differ from the 
next person, so there is no single answer that matches for everyone. 
Some people will say they need a minimum of triple mirror RAID10, others 
will be fine with RAID5 or even RAID0.

It sounds like you are trying to say that regardless of how many reads 
are required you will never experience a read failure? That doesn't seem 
to match what the manufacturers are saying.

Regards,
Adam

