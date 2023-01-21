Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BCD8C004D4
	for <linux-raid@archiver.kernel.org>; Sat, 21 Jan 2023 13:33:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229527AbjAUNdH (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 21 Jan 2023 08:33:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbjAUNdF (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 21 Jan 2023 08:33:05 -0500
Received: from mallaury.nerim.net (smtp-106-saturday.noc.nerim.net [178.132.17.106])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B6D841E1C1
        for <linux-raid@vger.kernel.org>; Sat, 21 Jan 2023 05:33:02 -0800 (PST)
Received: from [192.168.0.252] (plouf.fr.eu.org [213.41.155.166])
        by mallaury.nerim.net (Postfix) with ESMTP id 0C3C5DB17D;
        Sat, 21 Jan 2023 14:32:56 +0100 (CET)
Message-ID: <5030b2e0-b4af-c55f-b965-9e3aab6e5c39@plouf.fr.eu.org>
Date:   Sat, 21 Jan 2023 14:32:55 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: Transferring an existing system from non-RAID disks to RAID1
 disks in the same computer
To:     Wols Lists <antlists@youngman.org.uk>,
        Phil Turmel <philip@turmel.org>, H <agents@meddatainc.com>,
        Linux RAID Mailing List <linux-raid@vger.kernel.org>
References: <273d1fc9-853f-a8fa-bb47-2883ba217820@meddatainc.com>
 <3c124633-6b69-c97c-30f2-02f70141ac1a@plouf.fr.eu.org>
 <963bb7eb-7ce2-c887-ca5c-d0359290841b@turmel.org>
 <4224103d-17b4-0635-9bb4-7f81b896ad07@plouf.fr.eu.org>
 <d1a78f14-843a-e6f1-b909-67e091c5fa3f@youngman.org.uk>
 <3a3d1de2-f02b-cd2a-7dd4-9d269bb0443e@plouf.fr.eu.org>
 <d4988c81-21f5-9b71-18ed-6ce489b28667@youngman.org.uk>
Content-Language: en-US
From:   Pascal Hambourg <pascal@plouf.fr.eu.org>
Organization: Plouf !
In-Reply-To: <d4988c81-21f5-9b71-18ed-6ce489b28667@youngman.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 21/01/2023 at 09:49, Wols Lists wrote:
> On 20/01/2023 21:01, Pascal Hambourg wrote:
>> On 20/01/2023 at 21:26, Wol wrote:
>>>
>>> I think you've just put your finger on it. Multiple EFI partitions is 
>>> outside the remit of linux
>>
>> I do not subscribe to this point of view. Distributions used to handle 
>> multiple boot sectors, why could they not handle multiple EFI 
>> partitions as well ?
> 
> Because that means that distros need to know all about EVERY OTHER 
> OPERATING SYSTEM?

Why would the distributions need to know all about every other OS, and 
what do you mean by "all" ?

> I don't know who's fault it was, probably Microsoft's, but I gave up 
> trying to dual-boot a laptop ...

I blame UEFI firmware vendors first, for improperly implementing the 
UEFI boot specification. Then I blame operating system vendors for not 
natively handling the case of multiple redundant EFI partitions.

Back on topic, if you mean Windows+Linux dual boot, it seems unlikely to 
me that this can be achieved with Linux software RAID, because Windows 
does not support it and Windows software RAID usually works on whole drives.
If you mean Linux dual-boot, you do not need multiple boot loaders, one 
single boot loader can boot all Linux systems.

>>> At the end of the day, it's down to the user, and if you can shove a 
>>> quick rsync in the initramfs or boot sequence to sync EFIs, then 
>>> that's probably the best place. Then it doesn't get missed ...
>>
>> No, these are not adequate places. Too early or too late. The right 
>> place is when anything is written to the EFI partition.
> 
> I would agree with you. But that requires EVERY OS on the computer to 
> co-operate. I think you are being - shall we say - optimistic?
> 
> Fact: Other systems outside of linux meddle with the EFI. Conclusion: 
> modifying linux to sync EFI *at the point of modification* is going to 
> fail. Badly.

I suspect we are misunderstanding each other about the meaning of "sync 
EFI partitions" and it may be my fault for not being clear enough. 
First, I do not mean to sync the whole EFI partition contents but only 
the part which belongs to the running operating system. This way, 
neither knowledge or cooperation of other operating systems is required.
Second, I do not mean "sync" in the sense of doing what rsync does but 
in the sense of writing the same stuff in all EFI partitions in the 
first place, instead of writing stuff in one "main" EFI partition only 
and sync'ing other EFI partitions at a later time.
