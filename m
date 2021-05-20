Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8816FC433B4
	for <linux-raid@archiver.kernel.org>; Thu, 20 May 2021 15:08:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6ACA860C3D
	for <linux-raid@archiver.kernel.org>; Thu, 20 May 2021 15:08:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232438AbhETPJo (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 20 May 2021 11:09:44 -0400
Received: from smtp.hosts.co.uk ([85.233.160.19]:11815 "EHLO smtp.hosts.co.uk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231751AbhETPJl (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Thu, 20 May 2021 11:09:41 -0400
Received: from host109-154-217-227.range109-154.btcentralplus.com ([109.154.217.227] helo=[192.168.1.65])
        by smtp.hosts.co.uk with esmtpa (Exim)
        (envelope-from <antlists@youngman.org.uk>)
        id 1ljkHZ-0003qK-5o; Thu, 20 May 2021 16:08:17 +0100
Subject: Re: raid10 redundancy
To:     Roger Heflin <rogerheflin@gmail.com>,
        Adam Goryachev <mailinglists@websitemanagers.com.au>
Cc:     Phillip Susi <phill@thesusis.net>,
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
 <d4e9070c-e80f-3f1b-4d26-21caf1318eb6@websitemanagers.com.au>
 <CAAMCDeeOnraMDNCF6ZZqPAxUrih2gSse1wDYgOfd1LqY-Ffqxw@mail.gmail.com>
From:   antlists <antlists@youngman.org.uk>
Message-ID: <9a92219d-1671-4e9b-3c5c-e01d8eb27aa8@youngman.org.uk>
Date:   Thu, 20 May 2021 16:08:17 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <CAAMCDeeOnraMDNCF6ZZqPAxUrih2gSse1wDYgOfd1LqY-Ffqxw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 20/05/2021 12:12, Roger Heflin wrote:
> The read failures exist on the platter for the most part. Reading the 
> platters or not does not change the fact that sectors are already bad. 
> raid6 reading more sectors just means you have a higher risk of finding 
> the already corrupted sector.

I think you're wrong there ... glitches in the electronics also seem to 
be not uncommon. But here, the read normally fails, and if the OS 
retries, it succeeds without trouble.

But as I look at it, if the manufacturers specify "less than 1 error per 
X bytes read", even if X in practice is much larger than X in the spec, 
you should plan to handle what the spec says.

Cheers,
Wol
