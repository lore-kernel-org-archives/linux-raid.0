Return-Path: <SRS0=RtKw=CA=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C150C433E1
	for <linux-raid@archiver.kernel.org>; Sat, 22 Aug 2020 23:50:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7F593204FD
	for <linux-raid@archiver.kernel.org>; Sat, 22 Aug 2020 23:50:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728635AbgHVXuh (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 22 Aug 2020 19:50:37 -0400
Received: from smtp.hosts.co.uk ([85.233.160.19]:20514 "EHLO smtp.hosts.co.uk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728453AbgHVXug (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Sat, 22 Aug 2020 19:50:36 -0400
Received: from host86-157-102-164.range86-157.btcentralplus.com ([86.157.102.164] helo=[192.168.1.65])
        by smtp.hosts.co.uk with esmtpa (Exim)
        (envelope-from <antlists@youngman.org.uk>)
        id 1k9dHM-0002T5-8T; Sun, 23 Aug 2020 00:50:32 +0100
Subject: Re: Recommended filesystem for RAID 6
To:     Chris Murphy <lists@colorremedies.com>
Cc:     Linux-RAID <linux-raid@vger.kernel.org>
References: <CAF-KpgYcEF5juR9nFPifZunPPGW73kWVG9fjR3=WpufxXJcewg@mail.gmail.com>
 <1381759926.21710099.1597158389614.JavaMail.zimbra@karlsbakk.net>
 <4a7bfca8-af6e-cbd1-0dc4-feaf1a0288be@fritscher.net>
 <5F32F56C.7040603@youngman.org.uk>
 <CAJCQCtRkLmfQ9BHy1ymYU=LC95LA2b2-Pyf_Gm8X06cza1YUjw@mail.gmail.com>
From:   antlists <antlists@youngman.org.uk>
Message-ID: <cb519e5f-a603-8254-2c5b-0f983431aeb1@youngman.org.uk>
Date:   Sun, 23 Aug 2020 00:50:35 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <CAJCQCtRkLmfQ9BHy1ymYU=LC95LA2b2-Pyf_Gm8X06cza1YUjw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-raid-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 22/08/2020 19:50, Chris Murphy wrote:
> How can you tell? From the spec, I can't find anything that indicates
> it. Let alone which of three varieties it is.
> https://www.seagate.com/www-content/product-content/barracuda-fam/barracuda-new/en-us/docs/100805918d.pdf

Simple.

Seagate now say that all the BarraCuda range are SMR. And this is a 
BarraCuda, not a Barracuda. (What's the difference, you say? The capital C.)

I've been digging, and I think if you want an old-fashioned CMR desktop 
drive you need the BarraCuda Pro or FireCuda. But at least - like the WD 
Reds or Red Pluses, there is at least an official naming convention that 
tells you what's what.

https://www.seagate.com/gb/en/internal-hard-drives/cmr-smr-list/

This is linked to on the wiki timeout problem page, as is the official 
WD statement.

Cheers,
Wol
