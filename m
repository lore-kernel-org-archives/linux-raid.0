Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B898C4338F
	for <linux-raid@archiver.kernel.org>; Thu, 29 Jul 2021 15:54:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2264B601FC
	for <linux-raid@archiver.kernel.org>; Thu, 29 Jul 2021 15:54:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237817AbhG2Pyb (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 29 Jul 2021 11:54:31 -0400
Received: from smtp.hosts.co.uk ([85.233.160.19]:59109 "EHLO smtp.hosts.co.uk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237579AbhG2Pya (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Thu, 29 Jul 2021 11:54:30 -0400
Received: from host86-162-184-27.range86-162.btcentralplus.com ([86.162.184.27] helo=[192.168.1.64])
        by smtp.hosts.co.uk with esmtpa (Exim)
        (envelope-from <antlists@youngman.org.uk>)
        id 1m98Ma-0004pB-Fq; Thu, 29 Jul 2021 16:54:25 +0100
Subject: Re: [Non-DoD Source] Can't get RAID5/RAID6 NVMe randomread IOPS - AMD
 ROME what am I missing?????
To:     Matt Wallis <mattw@madmonks.org>,
        "Finlayson, James M CIV (USA)" <james.m.finlayson4.civ@mail.mil>
References: <5EAED86C53DED2479E3E145969315A2385841062@UMECHPA7B.easf.csd.disa.mil>
 <07195088-7E4B-4586-BB45-04890265BD62@madmonks.org>
 <5EAED86C53DED2479E3E145969315A23858411D1@UMECHPA7B.easf.csd.disa.mil>
 <21187A73-4000-4017-B016-15C03D19B799@madmonks.org>
Cc:     "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
From:   Wols Lists <antlists@youngman.org.uk>
X-Enigmail-Draft-Status: N1110
Message-ID: <6102D8B9.2080502@youngman.org.uk>
Date:   Thu, 29 Jul 2021 17:35:05 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:38.0) Gecko/20100101
 Thunderbird/38.7.0
MIME-Version: 1.0
In-Reply-To: <21187A73-4000-4017-B016-15C03D19B799@madmonks.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 29/07/21 01:54, Matt Wallis wrote:
> Hi Jim,
> 
> Totally get the Frankenstein’s monster aspect, I try not to build those where I can, but at the moment I don’t think there’s much that can be done about it.
> Not sure if LVM is better than MDRAID 0, it just gives you more control over the volumes that can be created, instead of having it all in one big chunk. If you just need one big chunk, then MDRAID 0 is probably fine.
> 
sticking raid 0 on top of raid 6 sounds an extremely weird thing to do.

What I guess you might be wanting to do instead is write a partition
table to the raid-6? That's perfectly normal if, imho, a bit unusual?

And LVM would be MUCH better than raid-0, I'm sure, because it addresses
this very issue by design, rather than by accident.

> I think if you can create a couple of scripts that allows the admin to fail a drive out of all the arrays that it’s in at once, then it's not that much worse than managing an MDRAID is normally. 

Is that wise? KISS.
> 
> Matt.
> 
>> On 28 Jul 2021, at 20:43, Finlayson, James M CIV (USA) <james.m.finlayson4.civ@mail.mil> wrote:
>>
>> Matt,
>> I have put as many as 32 partitions on a drive (based upon great advice from this list) and done RAID6 over them, but I was concerned about our sustainability long term.     As a researcher, I can do these cool science experiments, but I still have to hand designs  to sustainment folks.  I was also running into an issue of doing a mdraid RAID0 on top of the RAID6's so I could toss one  xfs file system on top each of the numa node's drives and the last RAID0 stripe of all of the RAID6's couldn't generate the queue depth needed.    We even recompiled the kernel to change the mdraid nr_request max from 128 to 1023.  
>>
>> I will have to try the LVM experiment.  I'm an LVM  neophyte, so it might take me the rest of today/tomorrow to get new results as I tend to let mdraid do all of its volume builds without forcing, so that will take a bit of time also.  Once might be able to argue that configuration isn't too much of a "Frankenstein's monster" for me to hand it off.
>>
Do. If it solves what you want, then it's worth it. I'm moving my stuff
over to LVM.

To throw something else into the mix, you've gone for raid 6, which
enables you to lose two drives, or corrupt one drive. Do you need the
two-drive redundancy? The calculations are a lot more expensive than
raid-5 if you're worried over write speed. I don't know the impact of it
but I'm playing with dm-integrity which provides some protection against
corruption.

>> Thanks,
>> Jim
>>
Cheers,
Wol

