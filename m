Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B74A3C433EF
	for <linux-raid@archiver.kernel.org>; Thu, 23 Jun 2022 23:44:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230388AbiFWXoS (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 23 Jun 2022 19:44:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbiFWXoR (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 23 Jun 2022 19:44:17 -0400
Received: from smtp.hosts.co.uk (smtp.hosts.co.uk [85.233.160.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D378D4D61C
        for <linux-raid@vger.kernel.org>; Thu, 23 Jun 2022 16:44:15 -0700 (PDT)
Received: from host86-158-155-35.range86-158.btcentralplus.com ([86.158.155.35] helo=[192.168.1.65])
        by smtp.hosts.co.uk with esmtpa (Exim)
        (envelope-from <antlists@youngman.org.uk>)
        id 1o4WUf-000C9v-Fv;
        Fri, 24 Jun 2022 00:44:14 +0100
Message-ID: <9ff8c1e7-7c29-6243-2749-c6e0a3e25640@youngman.org.uk>
Date:   Fri, 24 Jun 2022 00:44:13 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: a new install - - - putting the system on raid
Content-Language: en-GB
To:     Pascal Hambourg <pascal@plouf.fr.eu.org>,
        o1bigtenor <o1bigtenor@gmail.com>,
        Linux-RAID <linux-raid@vger.kernel.org>
References: <CAPpdf59G6UjOe-80oqgwPmMY14t0_E=D20cbUwDwtOT8=AFcLQ@mail.gmail.com>
 <81c50899-7edb-e629-3bbc-16cfa8f17e34@youngman.org.uk>
 <b777865e-b265-1e83-dae0-f89654e86332@plouf.fr.eu.org>
 <5cbd9dd1-73fc-ce11-4a9d-8752f7bea979@youngman.org.uk>
 <1de4bf1f-242b-7d02-23dc-a6d05893db81@plouf.fr.eu.org>
From:   Wol <antlists@youngman.org.uk>
In-Reply-To: <1de4bf1f-242b-7d02-23dc-a6d05893db81@plouf.fr.eu.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 23/06/2022 23:27, Pascal Hambourg wrote:
> 

>>
>> Why would it crash?
> 
> Do you really believe a program can lose some of its data and still 
> behave as if nothing happened ? If that were true, then why not just 
> discard data instead of swap them out when memory is short ?

No ...
> 
>> Firstly, the system shouldn't be swapping. MOST systems, under MOST 
>> workloads, don't need swap.
> 
> Conversely, some systems, under some workloads, do need swap. And when 
> they do, swap needs to be as reliable as any other storage space.

And if your system is one of the ?majority? that shouldn't swap, the 
cost/benefit analysis is COMPLETELY different for swap than for main 
storage. So don't treat them the same.
> 
>> And secondly, the *system* should not be using swap. User space, yes. 
>> So a bunch of running stuff might crash. But the system should stay up.
> 
> Firstly, the *system* is not only the kernel. Many user space processes 
> are part of the *system*. Secondly, you were the one who wrote:
> 
> "/tmp - is usually tmpfs nowadays, if you need disk backing, just make 
> sure you've got a big-enough swap (tmpfs defaults to half ram, make it 
> bigger and let it swap)."
> 
And? /tmp is *explicitly* not to be trusted in the event of problems. If 
you lose a disk and it takes /tmp out, sorry. If the tmp-cleaner decides 
to do a random "rm /tmp/*" at an inconvenient moment, well, if the 
system can't handle it then whoever set the system up (or wrote the 
program) was incompetent. Sorry. It's true. (And, no, I'm not claiming 
to be a competent person :-)

>> Raid is meant to protect your data. The benefit for raiding your swap 
>> is much less, and *should* be negligible.
> 
> No, this is what backup is meant to. RAID does not protect your data 
> against accidental or malicious deletion or corruption. RAID is meant to 
> provide availabity. The benefit of having everything including swap on 
> RAID is that the system as a whole will continue to operate normally 
> when a drive fails.

And how does backup protect your data when the system crashes? You know, 
all that web-shop data that is fresh and new and arrived after the most 
recent backup 5mins ago? But that is probably irrelevant to most people :-)

(Oh, and I didn't tell o1bigtenor NOT to raid his swap. I asked him WHY 
he would want to. Maybe he has good reason. But I know him of old, and 
have good reason to suspect he's going OTT.)

You need to know what the threats are, what the mitigations are, and 
what strategies are RELEVANT. And you need different strategies for 
long-term, short-term, and immediate protection/threats.

I run xosview. Even with gentoo, and a massive tmpfs, swap in-use sits 
at 0B practically ALL the time. Why would I want to protect it? On the 
other hand, my data sits on raid-5 on top of dm-integrity - protected 
against both disk corruption and disk loss.

And then I usually forget I've got a massive disk sitting there for 
backup. Losing a hard drive doesn't cross my mind, because in pretty 
much 30 years I personally have yet to lose a disk. I know I'm lucky, 
I've recovered other people who have, but ...

As I say, different risks, different mitigations...

Cheers,
Wol
