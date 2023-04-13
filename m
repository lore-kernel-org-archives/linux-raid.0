Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35EE4C77B6E
	for <linux-raid@archiver.kernel.org>; Thu, 13 Apr 2023 12:12:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229821AbjDMMMN (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 13 Apr 2023 08:12:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229749AbjDMMMM (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 13 Apr 2023 08:12:12 -0400
Received: from hermes.turmel.org (hermes.turmel.org [IPv6:2604:180:f1::1e9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C435D49EA
        for <linux-raid@vger.kernel.org>; Thu, 13 Apr 2023 05:12:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=turmel.org;
         s=a; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:References:To
        :Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:Cc:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=IjiAMSq5Edm1K2qbWClwnX12gj6RK4kKo9lZH88XUCw=; b=nbvFwmmlogmmNDc9rQjy4YHUoc
        xqzuERKA+ub7Sof6nFcnr7M/xSHvr8ER1xs6nUwKe7wyG/JrEeMNKmRc5Mj37+YQq3W5/b0rnntJZ
        8k0s6dG+fDxnGqjc8J4m8beF3ToEzCyRjvGhUmZIat/5vJXGehN8tmiG+tczuc8pKH4uhBuVhFXVP
        4kyb7YdjnBW17ua4hTwtNVNeSzY4kJmu6+xTWuhIP6hXFMa4VLAGZ9NEiMYm+rIdCa8jvoKbWdytu
        xhz7FphnsThr1Px4WKDIqTPHdHcbk8grQCYchf7w7HhnQQSYqNrc4Ye2H1UTfc6dczzRSJYhFIdb8
        KYwNBA6A==;
Received: from 108-70-166-50.lightspeed.tukrga.sbcglobal.net ([108.70.166.50] helo=[192.168.20.123])
        by hermes.turmel.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.90_1)
        (envelope-from <philip@turmel.org>)
        id 1pmvoA-0006s9-2w; Thu, 13 Apr 2023 12:12:10 +0000
Message-ID: <5881bab7-9ecf-1098-b624-846b39d83d63@turmel.org>
Date:   Thu, 13 Apr 2023 08:12:09 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: Recover data from accidentally created raid5 over raid1
Content-Language: en-US
To:     Wols Lists <antlists@youngman.org.uk>,
        Mark Wagner <carnildo@gmail.com>, linux-raid@vger.kernel.org
References: <c0a9e08b91e86c86038be889907f0796@itrosinen.de>
 <25653.47458.489415.933722@quad.stoffel.home>
 <21b0a1ef-6389-8851-f6f9-17f3ca6d96c0@youngman.org.uk>
 <14ccbf12-0254-b0b8-4c9a-8949c947a63c@thelounge.net>
 <da9f8739-f923-de3f-2a4e-320c757f3139@turmel.org>
 <CAA04aRTJ4RreJtOnZcvvTqcc5ZGU5T5WbBt0X0str210CcMo8g@mail.gmail.com>
 <2d471704-bf1c-453f-1c46-469c4d88b98c@youngman.org.uk>
From:   Phil Turmel <philip@turmel.org>
In-Reply-To: <2d471704-bf1c-453f-1c46-469c4d88b98c@youngman.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 4/13/23 04:05, Wols Lists wrote:
> On 12/04/2023 21:22, Mark Wagner wrote:
>> On Wed, Apr 12, 2023 at 5:45 AM Phil Turmel <philip@turmel.org> wrote:
>>>
>>> What is nonsense?  A two-disk raid5 does have exactly the same content
>>> on both disks, just like a mirror.  The parity for any given single byte
>>> is that same byte.
>>
>> Only if it's using even parity.  If it's using odd parity, the second
>> disk is the inverse of the first.
>>
> It's documented on the raid wiki (because I think it was documented 
> there before I started editing it), that the way raid switches between 
> different raid types is through the fact (accidental or on purpose I 
> don't know) that most of the two-disk raid types just happen to have an 
> "identical in practice" disk layout.
> 
> So converting between raid-1 and raid-5 is as simple as changing the 
> config of a raid-1 to a degraded raid-5 and vice versa.

Be careful!  This is only true for a *two* disk raid.

> Cheers,
> Wol
> 

Phil
