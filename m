Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E33C8C43334
	for <linux-raid@archiver.kernel.org>; Sat, 25 Jun 2022 08:27:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232026AbiFYI1a (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 25 Jun 2022 04:27:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229722AbiFYI13 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 25 Jun 2022 04:27:29 -0400
Received: from maiev.nerim.net (smtp-156-saturday.nerim.net [194.79.134.156])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2C4E93137E
        for <linux-raid@vger.kernel.org>; Sat, 25 Jun 2022 01:27:28 -0700 (PDT)
Received: from [192.168.0.250] (plouf.fr.eu.org [213.41.155.166])
        by maiev.nerim.net (Postfix) with ESMTP id E0F0A2E007;
        Sat, 25 Jun 2022 10:27:26 +0200 (CEST)
Message-ID: <350e9a93-7af1-d5e6-62d7-a427e3e78eee@plouf.fr.eu.org>
Date:   Sat, 25 Jun 2022 10:27:26 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: a new install - - - putting the system on raid
Content-Language: en-US
To:     Wol <antlists@youngman.org.uk>, o1bigtenor <o1bigtenor@gmail.com>,
        Linux-RAID <linux-raid@vger.kernel.org>
References: <CAPpdf59G6UjOe-80oqgwPmMY14t0_E=D20cbUwDwtOT8=AFcLQ@mail.gmail.com>
 <81c50899-7edb-e629-3bbc-16cfa8f17e34@youngman.org.uk>
 <b777865e-b265-1e83-dae0-f89654e86332@plouf.fr.eu.org>
 <5cbd9dd1-73fc-ce11-4a9d-8752f7bea979@youngman.org.uk>
 <1de4bf1f-242b-7d02-23dc-a6d05893db81@plouf.fr.eu.org>
 <9ff8c1e7-7c29-6243-2749-c6e0a3e25640@youngman.org.uk>
From:   Pascal Hambourg <pascal@plouf.fr.eu.org>
Organization: Plouf !
In-Reply-To: <9ff8c1e7-7c29-6243-2749-c6e0a3e25640@youngman.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Le 24/06/2022 à 01:44, Wol a écrit :
> On 23/06/2022 23:27, Pascal Hambourg wrote:
>>
>>> Firstly, the system shouldn't be swapping. MOST systems, under MOST 
>>> workloads, don't need swap.
>>
>> Conversely, some systems, under some workloads, do need swap. And when 
>> they do, swap needs to be as reliable as any other storage space.
> 
> And if your system is one of the ?majority? that shouldn't swap, the 
> cost/benefit analysis is COMPLETELY different for swap than for main 
> storage. So don't treat them the same.

If your system should not swap, then why use any swap at all ?

>>> And secondly, the *system* should not be using swap. User space, yes. 
>>> So a bunch of running stuff might crash. But the system should stay up.
>>
>> Firstly, the *system* is not only the kernel. Many user space 
>> processes are part of the *system*. Secondly, you were the one who wrote:
>>
>> "/tmp - is usually tmpfs nowadays, if you need disk backing, just make 
>> sure you've got a big-enough swap (tmpfs defaults to half ram, make it 
>> bigger and let it swap)."
>>
> And? /tmp is *explicitly* not to be trusted in the event of problems. If 
> you lose a disk and it takes /tmp out, sorry.

Source ?

> If the tmp-cleaner decides 
> to do a random "rm /tmp/*" at an inconvenient moment, well, if the 
> system can't handle it then whoever set the system up (or wrote the 
> program) was incompetent.

Cleaning /tmp is not the same as loosing access to it. Opened files are 
still accessible.

>>> Raid is meant to protect your data. The benefit for raiding your swap 
>>> is much less, and *should* be negligible.
>>
>> No, this is what backup is meant to. RAID does not protect your data 
>> against accidental or malicious deletion or corruption. RAID is meant 
>> to provide availabity. The benefit of having everything including swap 
>> on RAID is that the system as a whole will continue to operate 
>> normally when a drive fails.
> 
> And how does backup protect your data when the system crashes? You know, 
> all that web-shop data that is fresh and new and arrived after the most 
> recent backup 5mins ago?

Use RAID, so that the system does not crash when a drive fails.

> (Oh, and I didn't tell o1bigtenor NOT to raid his swap. I asked him WHY 
> he would want to. Maybe he has good reason. But I know him of old, and 
> have good reason to suspect he's going OTT.)

I think you do not need a good reason to have swap on RAID when all the 
rest is on RAID. It is the other way around : you need a good reason not 
to have swap on RAID.

> I run xosview. Even with gentoo, and a massive tmpfs, swap in-use sits 
> at 0B practically ALL the time. Why would I want to protect it?

Because you may not want anything to crash when a drive fails while the 
swap is used. If you don't care, well, don't protect the swap.
