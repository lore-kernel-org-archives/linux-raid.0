Return-Path: <SRS0=wQ6l=CG=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B7ABC433E2
	for <linux-raid@archiver.kernel.org>; Fri, 28 Aug 2020 22:12:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DA6E9207DA
	for <linux-raid@archiver.kernel.org>; Fri, 28 Aug 2020 22:12:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726418AbgH1WM2 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 28 Aug 2020 18:12:28 -0400
Received: from smtp.hosts.co.uk ([85.233.160.19]:61060 "EHLO smtp.hosts.co.uk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726338AbgH1WM2 (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Fri, 28 Aug 2020 18:12:28 -0400
Received: from host86-157-102-164.range86-157.btcentralplus.com ([86.157.102.164] helo=[192.168.1.65])
        by smtp.hosts.co.uk with esmtpa (Exim)
        (envelope-from <antlists@youngman.org.uk>)
        id 1kBmbi-00086i-3Z; Fri, 28 Aug 2020 23:12:26 +0100
Subject: Re: Best way to add caching to a new raid setup.
To:     Ram Ramesh <rramesh2400@gmail.com>,
        "R. Ramesh" <rramesh@verizon.net>,
        Linux Raid <linux-raid@vger.kernel.org>
References: <16cee7f2-38d9-13c8-4342-4562be68930b.ref@verizon.net>
 <16cee7f2-38d9-13c8-4342-4562be68930b@verizon.net>
 <dc91cc7d-02c4-66ee-21b4-bda69be3bbd9@youngman.org.uk>
 <1310d10c-1b83-7031-58e3-0f767b1df71b@gmail.com>
From:   antlists <antlists@youngman.org.uk>
Message-ID: <101d4a60-916c-fe30-ae7c-994098fe2ebe@youngman.org.uk>
Date:   Fri, 28 Aug 2020 23:12:26 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <1310d10c-1b83-7031-58e3-0f767b1df71b@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-raid-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 28/08/2020 18:25, Ram Ramesh wrote:
> I am mainly looking for IOP improvement as I want to use this RAID in 
> mythtv environment. So multiple threads will be active and I expect 
> cache to help with random access IOPs.

???

Caching will only help in a read-after-write scenario, or a 
read-several-times scenario.

I'm guessing mythtv means it's a film server? Can ALL your films (or at 
least your favourite "watch again and again" ones) fit in the cache? If 
you watch a lot of films, chances are you'll read it from disk (no 
advantage from the cache), and by the time you watch it again it will 
have been evicted so you'll have to read it again.

The other time cache may be useful, is if you're recording one thing and 
watching another. That way, the writes can stall in cache as you 
prioritise reading.

Think about what is actually happening at the i/o level, and will cache 
help?

Cheers,
Wol
