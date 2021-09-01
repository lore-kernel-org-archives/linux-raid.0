Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 485D7C4320A
	for <linux-raid@archiver.kernel.org>; Wed,  1 Sep 2021 01:51:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 29D3460F46
	for <linux-raid@archiver.kernel.org>; Wed,  1 Sep 2021 01:51:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231481AbhIABv7 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 31 Aug 2021 21:51:59 -0400
Received: from out1.migadu.com ([91.121.223.63]:20881 "EHLO out1.migadu.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231396AbhIABv6 (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Tue, 31 Aug 2021 21:51:58 -0400
Subject: Re: [Non-DoD Source] Re: Slow initial resync in RAID6 with 36 SAS
 drives
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1630461061;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CWGglmHtTqkWFZiZuKvkYzngRqPWDq7aJacpY0x0SuI=;
        b=X2plcf07fzNWQhifeDEBtR9KVq3QcNAGHmn9dDk59HX2NFo5bSXeawQtQ0AzBFOuHT7Nyx
        gZPVlWM5SEyvtVWvsUeU4i6HCaClZ3LMD8Er1CiZU/pVbZtJeHpPoVgnrbUlPLvk555vF4
        avv0wcsPaWgR+WpPG6c437FwZ1e3jpY=
To:     antlists <antlists@youngman.org.uk>,
        "Finlayson, James M CIV (USA)" <james.m.finlayson4.civ@mail.mil>,
        'Marcin Wanat' <marcin.wanat@gmail.com>,
        "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
References: <CAFDAVznKiKC7YrCTJ4oj6NimXrhnY-=PUnJhFopw6Ur5LvOCjg@mail.gmail.com>
 <CAFDAVzmjGYsdgx0Yyn3n8NWVpAZQqmhBSneZY9fagV5PGTrgGw@mail.gmail.com>
 <5EAED86C53DED2479E3E145969315A2385863D46@UMECHPA7D.easf.csd.disa.mil>
 <18699120-fb61-35e2-3b27-975773f3216a@youngman.org.uk>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Guoqing Jiang <guoqing.jiang@linux.dev>
Message-ID: <f8eee1bd-673e-dd68-d393-5e1c07415117@linux.dev>
Date:   Wed, 1 Sep 2021 09:50:55 +0800
MIME-Version: 1.0
In-Reply-To: <18699120-fb61-35e2-3b27-975773f3216a@youngman.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: guoqing.jiang@linux.dev
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 9/1/21 9:22 AM, antlists wrote:
> On 25/08/2021 11:28, Finlayson, James M CIV (USA) wrote:
>> I'm not a person necessarily in the "know", but I mess with these in 
>> udev  for SSDs:
>> SUBSYSTEM=="block", ACTION=="add|change", KERNEL=="md*", 
>> ATTR{md/sync_speed_max}="2000000",ATTR{md/group_thread_cnt}="64", 
>> ATTR{md/stripe_cache_size}="8192"
>>
>> Guidance on why I change the values this way - educated "guess", as 
>> I'm an experienced practitioner at best and not someone that messes 
>> with the code......I've seen resync rates as high as 900MB/s 
>> sustained on my SSD mdraids, even though the SSDs should be able to 
>> sustain higher.....
>
> Not raid, but I've picked up on comments (on LWN?) that certain 
> file-systems are very much "single threaded" in their behaviour. I 
> strongly suspect that md-raid predates common multi-cpu/multi-core 
> systems, and I've heard somewhere that md-raid doesn't thread that well.

Yes and no, raid5 does support multi-threading if group_thread_cnt > 0, 
but IIUC, only one thread (mdx_resync) deals with resync IO.

Thanks,
Guoqing
