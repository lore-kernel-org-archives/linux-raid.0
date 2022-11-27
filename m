Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD034C4332F
	for <linux-raid@archiver.kernel.org>; Sun, 27 Nov 2022 22:08:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229619AbiK0WIe (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 27 Nov 2022 17:08:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229555AbiK0WId (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 27 Nov 2022 17:08:33 -0500
Received: from mail.thelounge.net (mail.thelounge.net [91.118.73.15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3083E1BD
        for <linux-raid@vger.kernel.org>; Sun, 27 Nov 2022 14:08:31 -0800 (PST)
Received: from [10.10.10.2] (rh.vpn.thelounge.net [10.10.10.2])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-256) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: h.reindl@thelounge.net)
        by mail.thelounge.net (THELOUNGE MTA) with ESMTPSA id 4NL2mY1PM3zXLf;
        Sun, 27 Nov 2022 23:08:24 +0100 (CET)
Message-ID: <5ae1729b-d084-384c-04ff-165b9e3298f9@thelounge.net>
Date:   Sun, 27 Nov 2022 23:08:23 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: how do i fix these RAID5 arrays?
Content-Language: en-US
To:     Wol <antlists@youngman.org.uk>, piergiorgio.sartor@nexgo.de,
        John Stoffel <john@stoffel.org>
Cc:     David T-G <davidtg-robot@justpickone.org>,
        Linux RAID list <linux-raid@vger.kernel.org>
References: <fd543697-14a6-0868-82a1-be61790e07f3@thelounge.net>
 <20221123220736.GD19721@jpo> <20221124032821.628cd042@nvm>
 <20221124211019.GE19721@jpo>
 <f58964da-4ded-61a8-bd6a-e2391557b38a@youngman.org.uk>
 <25474.28874.952381.412636@quad.stoffel.home>
 <0c7ad6eff626c8440734909300ebc50d9b1bf615@nexgo.de>
 <4379b4f4-9e7f-a7dc-fc29-6c22b12bf3ea@thelounge.net>
 <531e8606-94b4-d48b-1d5a-72cc7d078755@youngman.org.uk>
From:   Reindl Harald <h.reindl@thelounge.net>
Organization: the lounge interactive design
In-Reply-To: <531e8606-94b4-d48b-1d5a-72cc7d078755@youngman.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



Am 27.11.22 um 23:05 schrieb Wol:
> On 27/11/2022 18:21, Reindl Harald wrote:
>>> If the array is 99% full, MD or ZFS/BTRFS have
>>> same behaviour, in terms of reliability.
>>> If the array is 0% full, as well
>>
>> you completly miss the point!
>>
>> if your mdadm-array is built with 6 TB drivres wehn you replace a 
>> drive you need to sync 6 TB no matter if 10 MB or 5 TB are actually used
> 
> And you are also completely missing the point!
> 
> When mdadm creates an array - IF IT SUPPORTED TRIM - you could tell it 
> "this is a blank array, don't bother initialising it". So it would 
> initialise an internal bitmap to say "all these stripes are empty"

you could - but it don't

> tldr - there is no reason why mdadm couldn't implement trim, and if it 
> did, then it would know how much of the array needed to be sync'd and 
> how much didn't need bothering with

who the hell cares about what it *could*?
it simply don't and that's state of play

that's the difference between a filesystem on top of mdadm versus a 
filesystem which implements RAID on it's own

that's the whole point: what things actually do
