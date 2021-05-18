Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2EE0C433B4
	for <linux-raid@archiver.kernel.org>; Tue, 18 May 2021 23:48:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B7DAC61074
	for <linux-raid@archiver.kernel.org>; Tue, 18 May 2021 23:48:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231148AbhERXto (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 18 May 2021 19:49:44 -0400
Received: from smtp.hosts.co.uk ([85.233.160.19]:40182 "EHLO smtp.hosts.co.uk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229969AbhERXto (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Tue, 18 May 2021 19:49:44 -0400
Received: from host109-154-217-227.range109-154.btcentralplus.com ([109.154.217.227] helo=[192.168.1.65])
        by smtp.hosts.co.uk with esmtpa (Exim)
        (envelope-from <antlists@youngman.org.uk>)
        id 1lj9Ro-000CkF-BG; Wed, 19 May 2021 00:48:24 +0100
Subject: Re: raid10 redundancy
To:     Phillip Susi <phill@thesusis.net>
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
From:   antlists <antlists@youngman.org.uk>
Message-ID: <d7c8b22d-f74a-409e-4e08-46240bb815e4@youngman.org.uk>
Date:   Wed, 19 May 2021 00:48:26 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <874kf0yq31.fsf@vps.thesusis.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 18/05/2021 17:05, Phillip Susi wrote:
> 
> Wols Lists writes:
> 
>> When rebuilding a mirror (of any sort), one block written requires ONE
>> block read. When rebuilding a parity array, one block written requires
>> one STRIPE read.
> 
> Again, we're in agreement here.  What you keep ignoring is the fact that
> both of these take the same amount of time, provided that you are IO bound.
> 
And if you've got spinning rust, that's unlikely to be true. I can't 
speak for SATA, but on PATA I've personally experienced the exact 
opposite. Doubling the load on the interface absolutely DEMOLISHED 
throughput, turning what should have been a five-minute job into a 
several-hours job.

And if you've got many drives in your stripe, who's to say that won't 
overwhelm the i/o bandwidth. Your reads could be 50% or less of full 
speed, because there isn't the back end capacity to pass them on.

Cheers,
Wol
