Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1D94C433EF
	for <linux-raid@archiver.kernel.org>; Thu, 28 Oct 2021 09:53:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A97AA60FC0
	for <linux-raid@archiver.kernel.org>; Thu, 28 Oct 2021 09:53:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229809AbhJ1Jze (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 28 Oct 2021 05:55:34 -0400
Received: from smarthost01a.ixn.mail.zen.net.uk ([212.23.1.20]:45916 "EHLO
        smarthost01a.ixn.mail.zen.net.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229775AbhJ1Jzd (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Thu, 28 Oct 2021 05:55:33 -0400
Received: from [82.71.70.4] (helo=aawcs.co.uk)
        by smarthost01a.ixn.mail.zen.net.uk with esmtp (Exim 4.90_1)
        (envelope-from <john@aawcs.co.uk>)
        id 1mg25o-0000j7-2d; Thu, 28 Oct 2021 09:53:04 +0000
Received: from [192.168.1.200] ( [192.168.1.200])
          by aawcs.co.uk with ESMTP (Mailtraq/2.17.7.3560) id AWCS4BA23B73;
          Thu, 28 Oct 2021 10:54:09 +0100
Subject: Re: Missing Superblocks
To:     Wol <antlists@youngman.org.uk>,
        Roger Heflin <rogerheflin@gmail.com>
Cc:     linux-raid <linux-raid@vger.kernel.org>
References: <de712291-fa08-b35a-f8fb-6d18b573f3f4@aawcs.co.uk>
 <a5f362c3-122e-d0ac-1234-d4852e43adfa@aawcs.co.uk>
 <CAAMCDee8fEHGMg7NBNzMq7+kbFHo-4DM0D2T=rNezpPZgKabeg@mail.gmail.com>
 <9d80e924-ae3e-4a04-1d17-65bfc949e276@aawcs.co.uk>
 <880c0b3a-a3b8-d8fa-4ea4-bd0a801938d3@youngman.org.uk>
From:   John Atkins <John@aawcs.co.uk>
Organization: AAW Control Systems
Message-ID: <7514dcba-9366-2227-9805-a0efbe68cd8a@aawcs.co.uk>
Date:   Thu, 28 Oct 2021 10:52:59 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <880c0b3a-a3b8-d8fa-4ea4-bd0a801938d3@youngman.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Hops: 1
X-Originating-smarthost01a-IP: [82.71.70.4]
Feedback-ID: 82.71.70.4
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 27/10/2021 17:33, Wol wrote:

> On 26/10/2021 10:45, John Atkins wrote:
>> Thanks for the suggestions.
>> No partition ever on these disks.
>
> BAD IDEA ... it *should* be okay, but there are too many rogue 
> programs/utilities out there that think stomping all over a 
> partition-free disk is acceptable behaviour ...
>
> It's bad enough when a GPT or MBR gets trashed, which sadly is not 
> unusual in your scenario, but without partitions you're inviting 
> disaster... :-(
Ah confirmation from what I read in a 2017 post *sigh*, naivete on my 
part thinking that with out partitions there was less to go wrong.
>
>> I will try the dd method but as there was never a partition on the 
>> drive I don't think that will return results.
>
> Why not? it may return traces of the array ...
Thought this was to look for partition headers, I was assuming wrong 
again. I will try this.
>
>> The busy drive is not part of an active md array nor mounted so still 
>> a bit bemused by that.
>
> When mdadm attempts to start an array (which it does by default at 
> boot), if the attempt fails it usually leaves a broken inactive array 
> in an unusable state. You need to "kill" this mess before you can do 
> anything with it!
Ah ha that explains that. I will kill what I can find.
>
>> I know the order, after my first few muckups I number them to make 
>> sure if I have to move them it will work. If I use assume clean, if 
>> it does not work I can just try another order I assume. I do have a 
>> backup but 14T will take time to replicate.
>
> If you haven't yet tried to force the array, and possibly corrupted 
> where the headers should be, you could try a plain force-assemble, 
> which *might* work (very long shot ...)
I will try giving this ago, I was under the assumption as there is only 
one drive with a super block it would not, I will check the Wiki again 
to explore this and how to specify the drives.
>
> Otherwise, read the wiki and try with overlays until something 
> "strikes gold". Then I'd be inclined to fail each drive in turn, 
> re-adding it as a partition, to try and avoid a similar screw-up in 
> future.
Yes from now on it is partitions not raw drives haha.
> That, or disconnect all the raid drives before an upgrade, and 
> re-connect them afterwards - though that's been known to cause grief, 
> too :-(
I was just a machine reboot not even upgrades so bit lost on what caused 
the OS to scramble its self and prevent the OS from booting.
>
> (Of course, if you've used all available space, partitioning will 
> shrink the raid and cause more grief elsewhere ...)
Luckily not yet
>
> Hopefully, you've never resized the array, and the mdadm defaults 
> haven't changed, so you'll strike gold first attempt. Otherwise it 
> could be a long hard slog with all the possible options.
>
> https://raid.wiki.kernel.org/index.php/Linux_Raid
>
> Cheers,
> Wol
> .
Thank you very much for the advice!
John
