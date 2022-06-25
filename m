Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E053AC43334
	for <linux-raid@archiver.kernel.org>; Sat, 25 Jun 2022 11:42:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232625AbiFYLmE (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 25 Jun 2022 07:42:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232542AbiFYLmD (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 25 Jun 2022 07:42:03 -0400
Received: from smtp.hosts.co.uk (smtp.hosts.co.uk [85.233.160.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B35121DA62
        for <linux-raid@vger.kernel.org>; Sat, 25 Jun 2022 04:42:01 -0700 (PDT)
Received: from host86-158-155-35.range86-158.btcentralplus.com ([86.158.155.35] helo=[192.168.1.218])
        by smtp.hosts.co.uk with esmtpa (Exim)
        (envelope-from <antlists@youngman.org.uk>)
        id 1o54Ap-000Ajj-B0;
        Sat, 25 Jun 2022 12:41:59 +0100
Message-ID: <7d08fbbb-fefa-f57b-d12b-af0f16a3daba@youngman.org.uk>
Date:   Sat, 25 Jun 2022 12:41:58 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
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
 <9ff8c1e7-7c29-6243-2749-c6e0a3e25640@youngman.org.uk>
 <350e9a93-7af1-d5e6-62d7-a427e3e78eee@plouf.fr.eu.org>
From:   Wols Lists <antlists@youngman.org.uk>
In-Reply-To: <350e9a93-7af1-d5e6-62d7-a427e3e78eee@plouf.fr.eu.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 25/06/2022 09:27, Pascal Hambourg wrote:
> Le 24/06/2022 à 01:44, Wol a écrit :
>> On 23/06/2022 23:27, Pascal Hambourg wrote:
>>>
>>>> Firstly, the system shouldn't be swapping. MOST systems, under MOST 
>>>> workloads, don't need swap.
>>>
>>> Conversely, some systems, under some workloads, do need swap. And 
>>> when they do, swap needs to be as reliable as any other storage space.
>>
>> And if your system is one of the ?majority? that shouldn't swap, the 
>> cost/benefit analysis is COMPLETELY different for swap than for main 
>> storage. So don't treat them the same.
> 
> If your system should not swap, then why use any swap at all ?

Same reason I do? I have a whole bunch of rarely used, and not-at-all 
critical tmpfs's, so the system occasionally spills into swap. A system 
failure is no grief - reboot, carry on where it left off ...
> 
>>>> And secondly, the *system* should not be using swap. User space, 
>>>> yes. So a bunch of running stuff might crash. But the system should 
>>>> stay up.
>>>
>>> Firstly, the *system* is not only the kernel. Many user space 
>>> processes are part of the *system*. Secondly, you were the one who 
>>> wrote:
>>>
>>> "/tmp - is usually tmpfs nowadays, if you need disk backing, just 
>>> make sure you've got a big-enough swap (tmpfs defaults to half ram, 
>>> make it bigger and let it swap)."
>>>
>> And? /tmp is *explicitly* not to be trusted in the event of problems. 
>> If you lose a disk and it takes /tmp out, sorry.
> 
> Source ?

Linux Filesystem Hierarchy Standard? The presence of ANY files in /tmp 
is not to be trusted - even if you created it ten seconds ago ...
> 
> 
>> (Oh, and I didn't tell o1bigtenor NOT to raid his swap. I asked him 
>> WHY he would want to. Maybe he has good reason. But I know him of old, 
>> and have good reason to suspect he's going OTT.)
> 
> I think you do not need a good reason to have swap on RAID when all the 
> rest is on RAID. It is the other way around : you need a good reason not 
> to have swap on RAID.
> 
>> I run xosview. Even with gentoo, and a massive tmpfs, swap in-use sits 
>> at 0B practically ALL the time. Why would I want to protect it?
> 
> Because you may not want anything to crash when a drive fails while the 
> swap is used. If you don't care, well, don't protect the swap.

And most people nowadays - certainly on a single-user system - will have 
no reason to care. Certainly my system, with 32GB of ram, is very 
unlikely to spill into swap in normal operation ...

Cheers,
Wol
