Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64794C433EF
	for <linux-raid@archiver.kernel.org>; Wed, 27 Oct 2021 16:33:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 405266109D
	for <linux-raid@archiver.kernel.org>; Wed, 27 Oct 2021 16:33:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236750AbhJ0Qfk (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 27 Oct 2021 12:35:40 -0400
Received: from smtp.hosts.co.uk ([85.233.160.19]:24568 "EHLO smtp.hosts.co.uk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233805AbhJ0Qfj (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Wed, 27 Oct 2021 12:35:39 -0400
Received: from host81-132-12-162.range81-132.btcentralplus.com ([81.132.12.162] helo=[192.168.1.65])
        by smtp.hosts.co.uk with esmtpa (Exim)
        (envelope-from <antlists@youngman.org.uk>)
        id 1mflrU-0006dB-3c; Wed, 27 Oct 2021 17:33:12 +0100
Subject: Re: Missing Superblocks
To:     John Atkins <John@aawcs.co.uk>,
        Roger Heflin <rogerheflin@gmail.com>
Cc:     linux-raid <linux-raid@vger.kernel.org>
References: <de712291-fa08-b35a-f8fb-6d18b573f3f4@aawcs.co.uk>
 <a5f362c3-122e-d0ac-1234-d4852e43adfa@aawcs.co.uk>
 <CAAMCDee8fEHGMg7NBNzMq7+kbFHo-4DM0D2T=rNezpPZgKabeg@mail.gmail.com>
 <9d80e924-ae3e-4a04-1d17-65bfc949e276@aawcs.co.uk>
From:   Wol <antlists@youngman.org.uk>
Message-ID: <880c0b3a-a3b8-d8fa-4ea4-bd0a801938d3@youngman.org.uk>
Date:   Wed, 27 Oct 2021 17:33:24 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <9d80e924-ae3e-4a04-1d17-65bfc949e276@aawcs.co.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 26/10/2021 10:45, John Atkins wrote:
> Thanks for the suggestions.
> No partition ever on these disks.

BAD IDEA ... it *should* be okay, but there are too many rogue 
programs/utilities out there that think stomping all over a 
partition-free disk is acceptable behaviour ...

It's bad enough when a GPT or MBR gets trashed, which sadly is not 
unusual in your scenario, but without partitions you're inviting 
disaster... :-(

> I will try the dd method but as there was never a partition on the drive 
> I don't think that will return results.

Why not? it may return traces of the array ...

> The busy drive is not part of an active md array nor mounted so still a 
> bit bemused by that.

When mdadm attempts to start an array (which it does by default at 
boot), if the attempt fails it usually leaves a broken inactive array in 
an unusable state. You need to "kill" this mess before you can do 
anything with it!

> I know the order, after my first few muckups I number them to make sure 
> if I have to move them it will work. If I use assume clean, if it does 
> not work I can just try another order I assume. I do have a backup but 
> 14T will take time to replicate.

If you haven't yet tried to force the array, and possibly corrupted 
where the headers should be, you could try a plain force-assemble, which 
*might* work (very long shot ...)

Otherwise, read the wiki and try with overlays until something "strikes 
gold". Then I'd be inclined to fail each drive in turn, re-adding it as 
a partition, to try and avoid a similar screw-up in future. That, or 
disconnect all the raid drives before an upgrade, and re-connect them 
afterwards - though that's been known to cause grief, too :-(

(Of course, if you've used all available space, partitioning will shrink 
the raid and cause more grief elsewhere ...)

Hopefully, you've never resized the array, and the mdadm defaults 
haven't changed, so you'll strike gold first attempt. Otherwise it could 
be a long hard slog with all the possible options.

https://raid.wiki.kernel.org/index.php/Linux_Raid

Cheers,
Wol
