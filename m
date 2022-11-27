Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A159C4332F
	for <linux-raid@archiver.kernel.org>; Sun, 27 Nov 2022 22:05:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229770AbiK0WFQ (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 27 Nov 2022 17:05:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbiK0WFL (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 27 Nov 2022 17:05:11 -0500
Received: from smtp.hosts.co.uk (smtp.hosts.co.uk [85.233.160.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AF39FAEB
        for <linux-raid@vger.kernel.org>; Sun, 27 Nov 2022 14:05:10 -0800 (PST)
Received: from host86-138-24-20.range86-138.btcentralplus.com ([86.138.24.20] helo=[192.168.1.65])
        by smtp.hosts.co.uk with esmtpa (Exim)
        (envelope-from <antlists@youngman.org.uk>)
        id 1ozPls-0001XC-Ee;
        Sun, 27 Nov 2022 22:05:08 +0000
Message-ID: <531e8606-94b4-d48b-1d5a-72cc7d078755@youngman.org.uk>
Date:   Sun, 27 Nov 2022 22:05:07 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: how do i fix these RAID5 arrays?
Content-Language: en-GB
To:     Reindl Harald <h.reindl@thelounge.net>,
        piergiorgio.sartor@nexgo.de, John Stoffel <john@stoffel.org>
Cc:     David T-G <davidtg-robot@justpickone.org>,
        Linux RAID list <linux-raid@vger.kernel.org>
References: <fd543697-14a6-0868-82a1-be61790e07f3@thelounge.net>
 <20221123220736.GD19721@jpo> <20221124032821.628cd042@nvm>
 <20221124211019.GE19721@jpo>
 <f58964da-4ded-61a8-bd6a-e2391557b38a@youngman.org.uk>
 <25474.28874.952381.412636@quad.stoffel.home>
 <0c7ad6eff626c8440734909300ebc50d9b1bf615@nexgo.de>
 <4379b4f4-9e7f-a7dc-fc29-6c22b12bf3ea@thelounge.net>
From:   Wol <antlists@youngman.org.uk>
In-Reply-To: <4379b4f4-9e7f-a7dc-fc29-6c22b12bf3ea@thelounge.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 27/11/2022 18:21, Reindl Harald wrote:
>> If the array is 99% full, MD or ZFS/BTRFS have
>> same behaviour, in terms of reliability.
>> If the array is 0% full, as well
> 
> you completly miss the point!
> 
> if your mdadm-array is built with 6 TB drivres wehn you replace a drive 
> you need to sync 6 TB no matter if 10 MB or 5 TB are actually used

And you are also completely missing the point!

When mdadm creates an array - IF IT SUPPORTED TRIM - you could tell it 
"this is a blank array, don't bother initialising it". So it would 
initialise an internal bitmap to say "all these stripes are empty".

As the file system above sends writes down, mdadm would update the 
bitmap to say "these stripes are in use".

AND THIS IS WHAT I MEAN BY "SUPPORTING TRIM" - when the filesystem sends 
a trim command, saying "I'm no longer using these blocks", MDADM WOULD 
REMEMBER, and if appropriate clear the bitmap.

So when a drive breaks, mdadm would know what stripes are in use, and 
what stripes to sync, and what stripes to ignore!

And no, you are COMPLETELY WRONG in assuming that the only block layers 
that implement trim is hardware. Any block layer that wants to can 
implement trim - there is no reason whatsoever why mdadm couldn't. I 
never said it had, I said I wish it did.

But if virtual file system layers did NOT implement trim, you'd have a 
lot of unhappy punters on Amazon Cloud, or Google Cloud, or whatever 
these other suppliers of virtual systems are, if they had to pay for all 
that disk storage they're not actually using, because their virtual hard 
disks couldn't free up empty space.

tldr - there is no reason why mdadm couldn't implement trim, and if it 
did, then it would know how much of the array needed to be sync'd and 
how much didn't need bothering with.

Cheers,
Wol
