Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A04DBC004D4
	for <linux-raid@archiver.kernel.org>; Sat, 21 Jan 2023 08:49:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229637AbjAUItf (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 21 Jan 2023 03:49:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229493AbjAUIte (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 21 Jan 2023 03:49:34 -0500
Received: from smtp.hosts.co.uk (smtp.hosts.co.uk [85.233.160.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38A9655B2
        for <linux-raid@vger.kernel.org>; Sat, 21 Jan 2023 00:49:32 -0800 (PST)
Received: from host81-147-105-30.range81-147.btcentralplus.com ([81.147.105.30] helo=[192.168.1.218])
        by smtp.hosts.co.uk with esmtpa (Exim)
        (envelope-from <antlists@youngman.org.uk>)
        id 1pJ9Z4-000ClP-Ai;
        Sat, 21 Jan 2023 08:49:30 +0000
Message-ID: <d4988c81-21f5-9b71-18ed-6ce489b28667@youngman.org.uk>
Date:   Sat, 21 Jan 2023 08:49:29 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: Transferring an existing system from non-RAID disks to RAID1
 disks in the same computer
To:     Pascal Hambourg <pascal@plouf.fr.eu.org>,
        Phil Turmel <philip@turmel.org>, H <agents@meddatainc.com>,
        Linux RAID Mailing List <linux-raid@vger.kernel.org>
References: <273d1fc9-853f-a8fa-bb47-2883ba217820@meddatainc.com>
 <3c124633-6b69-c97c-30f2-02f70141ac1a@plouf.fr.eu.org>
 <963bb7eb-7ce2-c887-ca5c-d0359290841b@turmel.org>
 <4224103d-17b4-0635-9bb4-7f81b896ad07@plouf.fr.eu.org>
 <d1a78f14-843a-e6f1-b909-67e091c5fa3f@youngman.org.uk>
 <3a3d1de2-f02b-cd2a-7dd4-9d269bb0443e@plouf.fr.eu.org>
Content-Language: en-GB
From:   Wols Lists <antlists@youngman.org.uk>
In-Reply-To: <3a3d1de2-f02b-cd2a-7dd4-9d269bb0443e@plouf.fr.eu.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 20/01/2023 21:01, Pascal Hambourg wrote:
> On 20/01/2023 at 21:26, Wol wrote:
>>
>> I think you've just put your finger on it. Multiple EFI partitions is 
>> outside the remit of linux
> 
> I do not subscribe to this point of view. Distributions used to handle 
> multiple boot sectors, why could they not handle multiple EFI partitions 
> as well ?

Because that means that distros need to know all about EVERY OTHER 
OPERATING SYSTEM?
> 
>> I really don't think the system manager - be it yast, yum, apt, 
>> whatever - is capable of even trying.
> 
> yum and apt are package managers, not system managers. FWIW, Ubuntu's 
> grub-efi packages can deal with multiple EFI partitions in the same way 
> grub-pc can deal with multiple boot sectors.

???

I don't know who's fault it was, probably Microsoft's, but I gave up 
trying to dual-boot a laptop ...
> 
>> At the end of the day, it's down to the user, and if you can shove a 
>> quick rsync in the initramfs or boot sequence to sync EFIs, then 
>> that's probably the best place. Then it doesn't get missed ...
> 
> No, these are not adequate places. Too early or too late. The right 
> place is when anything is written to the EFI partition.

I would agree with you. But that requires EVERY OS on the computer to 
co-operate. I think you are being - shall we say - optimistic?

Fact: Other systems outside of linux meddle with the EFI. Conclusion: 
modifying linux to sync EFI *at the point of modification* is going to 
fail. Badly.

Cheers,
Wol
