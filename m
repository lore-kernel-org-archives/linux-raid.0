Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85F91C432BE
	for <linux-raid@archiver.kernel.org>; Wed,  1 Sep 2021 01:22:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6044D6056B
	for <linux-raid@archiver.kernel.org>; Wed,  1 Sep 2021 01:22:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241575AbhIABXZ (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 31 Aug 2021 21:23:25 -0400
Received: from smtp.hosts.co.uk ([85.233.160.19]:22058 "EHLO smtp.hosts.co.uk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234036AbhIABXZ (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Tue, 31 Aug 2021 21:23:25 -0400
Received: from host86-157-192-80.range86-157.btcentralplus.com ([86.157.192.80] helo=[192.168.1.65])
        by smtp.hosts.co.uk with esmtpa (Exim)
        (envelope-from <antlists@youngman.org.uk>)
        id 1mLExP-0004mZ-ED; Wed, 01 Sep 2021 02:22:27 +0100
Subject: Re: [Non-DoD Source] Re: Slow initial resync in RAID6 with 36 SAS
 drives
To:     "Finlayson, James M CIV (USA)" <james.m.finlayson4.civ@mail.mil>,
        'Marcin Wanat' <marcin.wanat@gmail.com>,
        "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
References: <CAFDAVznKiKC7YrCTJ4oj6NimXrhnY-=PUnJhFopw6Ur5LvOCjg@mail.gmail.com>
 <CAFDAVzmjGYsdgx0Yyn3n8NWVpAZQqmhBSneZY9fagV5PGTrgGw@mail.gmail.com>
 <5EAED86C53DED2479E3E145969315A2385863D46@UMECHPA7D.easf.csd.disa.mil>
From:   antlists <antlists@youngman.org.uk>
Message-ID: <18699120-fb61-35e2-3b27-975773f3216a@youngman.org.uk>
Date:   Wed, 1 Sep 2021 02:22:25 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <5EAED86C53DED2479E3E145969315A2385863D46@UMECHPA7D.easf.csd.disa.mil>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 25/08/2021 11:28, Finlayson, James M CIV (USA) wrote:
> I'm not a person necessarily in the "know", but I mess with these in udev  for SSDs:
> SUBSYSTEM=="block", ACTION=="add|change", KERNEL=="md*", ATTR{md/sync_speed_max}="2000000",ATTR{md/group_thread_cnt}="64", ATTR{md/stripe_cache_size}="8192"
> 
> Guidance on why I change the values this way - educated "guess", as I'm an experienced practitioner at best and not someone that messes with the code......I've seen resync rates as high as 900MB/s sustained on my SSD mdraids, even though the SSDs should be able to sustain higher.....

Not raid, but I've picked up on comments (on LWN?) that certain 
file-systems are very much "single threaded" in their behaviour. I 
strongly suspect that md-raid predates common multi-cpu/multi-core 
systems, and I've heard somewhere that md-raid doesn't thread that well.

It'd be nice to fix it, but retro-fitting existing code is a lot more 
work than starting from scratch ...

Cheers,
Wol
