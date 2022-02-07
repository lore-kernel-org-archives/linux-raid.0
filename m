Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB6B0C4332F
	for <linux-raid@archiver.kernel.org>; Tue,  8 Feb 2022 01:06:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344024AbiBHBG1 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 7 Feb 2022 20:06:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232539AbiBHAIk (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 7 Feb 2022 19:08:40 -0500
X-Greylist: delayed 5980 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 07 Feb 2022 16:08:38 PST
Received: from smtp.hosts.co.uk (smtp.hosts.co.uk [85.233.160.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99FF5C061355
        for <linux-raid@vger.kernel.org>; Mon,  7 Feb 2022 16:08:38 -0800 (PST)
Received: from host81-132-12-162.range81-132.btcentralplus.com ([81.132.12.162] helo=[192.168.1.65])
        by smtp.hosts.co.uk with esmtpa (Exim)
        (envelope-from <antlists@youngman.org.uk>)
        id 1nHCVD-0000ir-44; Mon, 07 Feb 2022 22:28:55 +0000
Message-ID: <c6873b6a-eabf-d6db-80f1-20b75a37bca7@youngman.org.uk>
Date:   Mon, 7 Feb 2022 22:28:57 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
Subject: Re: Replacing all disks in a an array as a preventative measure
 before failing.
Content-Language: en-GB
To:     Red Wil <redwil@gmail.com>, linux-raid <linux-raid@vger.kernel.org>
References: <20220207152648.42dd311a@falcon.sitarc.ca>
From:   Wol <antlists@youngman.org.uk>
In-Reply-To: <20220207152648.42dd311a@falcon.sitarc.ca>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 07/02/2022 20:26, Red Wil wrote:
> Hello,
> 
> It started as the subject said:
>   - goal was to replace all 10 disks in a R6
>   - context and perceived constraints
>     - soft raid (no imsm and or ddl containers)
>     - multiple disk partition. partitions across 10 disks formed R6
>     - downtime not an issue
>     - minimize the number of commands
>     - minimize disks stress
>     - reduce the time spent with this process
>     - difficult to add 10 spares at once in the rig
>     - after a reshape/grow from 6 to 10 disks offset of data in raid
>       members was all over the place from cca 10ksect to 200ksect
> 
> Approaches/solutions and critique
>   1- add one by one a 'spare' and 'replace' raid member
>    critique:
>    - seem to me long and tedious process
>    - cannot/will not run in parallel

There's not a problem running in parallel as far as mdraid is concerned. 
If you can get the spare drives into the chassis (or on eSATA), you can 
--replace several drives at once.

And it pretty much just does a dd, just on the live system keeping you 
raid-safe.

>   2- add all the spares at once and perform 'replace' on members
>    critique
>    - just tedious - lots of cli commands which can be prone to mistakes.

pretty much the same as (1). Given that your sdX's are moving all over 
the place, I would work with uuids even though it's more typing, it's safer.

>   next ones assume I have all the 'spares' in the rig
>   3- create new arrays on spares, fresh fs and copy data.

Well, you could fail/replace all the old drives, but yes just building a 
new array from scratch (if you can afford the downtime) is probably better.

>   4- dd/ddrescue copy each drive to a new one. Advantage can be done one
>   by one or in parallel. less commands in the terminal.

Less commands? Dunno about that. Much safer in many ways though, remove 
the drive you're replacing, copy it, put the new one back. Less chance 
for a physical error.
> 
> In the end I decided I will use route (3).
>   - flexibility on creation
>   - copy only what I need
>   - old array is a sort of backup
> 
> Question:
> Just for my curiosity regarding (4) assuming array is offline:
> Besides being not recommended in case of imsm/ddl containers which (as
> far as i understood) keep some data on the hardware itself
> 
> In case of pure soft raid is anything technical or safety related that
> prevents a 'dd' copy of a physical hard drive to act exactly as the
> original.
> 
Nope. You've copied the partition byte for byte, the raid won't know any 
different.

One question, though. Why are you replacing the drives? Just a precaution?

How big are the drives? What I'd do if you're not replacing dying 
drives, is buy five or possibly six drives of twice the capacity. Do a 
--replace on those five drives. Now take two of the drives you've 
removed, raid-0 them, and now do a major re-org, adding your raid-0 as 
device 6, reducing your raid to a 6-device array, and removing the last 
four old drives from the array. Assuming you've only got 10 bays and 
you've been faffing about externally as you replace drives, you can now 
use the last three drives in the chassis to create another two-drive 
raid-0, add that as a spare into your raid-6, and add your last drive as 
a spare into both your raid-0s.

So you end up with a 6-device+plus-spare raid-6, and devices 6 & spare 
(your raid-0s) share a spare between them.

Cheers,
Wol
