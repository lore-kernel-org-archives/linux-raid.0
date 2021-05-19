Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53851C433ED
	for <linux-raid@archiver.kernel.org>; Wed, 19 May 2021 21:19:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2858C611BF
	for <linux-raid@archiver.kernel.org>; Wed, 19 May 2021 21:19:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229548AbhESVVA (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 19 May 2021 17:21:00 -0400
Received: from mail.thelounge.net ([91.118.73.15]:22925 "EHLO
        mail.thelounge.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbhESVVA (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 19 May 2021 17:21:00 -0400
Received: from srv-rhsoft.rhsoft.net (rh.vpn.thelounge.net [10.10.10.2])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-256) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: h.reindl@thelounge.net)
        by mail.thelounge.net (THELOUNGE MTA) with ESMTPSA id 4Flm3G3MMbzXRq;
        Wed, 19 May 2021 23:19:38 +0200 (CEST)
Subject: Re: raid10 redundancy
To:     Phillip Susi <phill@thesusis.net>,
        Adam Goryachev <mailinglists@websitemanagers.com.au>
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
From:   Reindl Harald <h.reindl@thelounge.net>
Organization: the lounge interactive design
Message-ID: <56b4a4e0-a808-964e-031f-f40df6139f13@thelounge.net>
Date:   Wed, 19 May 2021 23:19:38 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <87im3e50sz.fsf@vps.thesusis.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



Am 19.05.21 um 15:02 schrieb Phillip Susi:
> 
> Adam Goryachev writes:
> 
>> Jumping into this one late, but I thought the main risk was related to
>> the fact that for every read there is a chance the device will fail to
>> read the data successfully, and so the more data you need to read in
>> order to restore redundancy, the greater the risk of not being able to
>> regain redundancy.
> 
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

frankly that discussion is idiotic - there is nothing like a fixed 
number of whatever load until something fails

but it's fact the *minimize whatever load* in doubt is a good thing - no 
matter what type of devices
