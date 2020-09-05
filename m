Return-Path: <SRS0=4oqD=CO=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.4 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFB1BC43461
	for <linux-raid@archiver.kernel.org>; Sat,  5 Sep 2020 22:43:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 716F120760
	for <linux-raid@archiver.kernel.org>; Sat,  5 Sep 2020 22:43:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728713AbgIEWm7 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 5 Sep 2020 18:42:59 -0400
Received: from smtp.hosts.co.uk ([85.233.160.19]:25354 "EHLO smtp.hosts.co.uk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728505AbgIEWm7 (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Sat, 5 Sep 2020 18:42:59 -0400
Received: from host86-136-163-47.range86-136.btcentralplus.com ([86.136.163.47] helo=[192.168.1.64])
        by smtp.hosts.co.uk with esmtpa (Exim)
        (envelope-from <antlists@youngman.org.uk>)
        id 1kEgtc-000Bp4-Dl; Sat, 05 Sep 2020 23:42:56 +0100
Subject: Re: Linux raid-like idea
To:     Brian Allen Vanderburg II <brianvanderburg2@aim.com>,
        linux-raid@vger.kernel.org
References: <1cf0d18c-2f63-6bca-9884-9544b0e7c54e.ref@aim.com>
 <1cf0d18c-2f63-6bca-9884-9544b0e7c54e@aim.com>
 <e3cb1bbe-65eb-5b75-8e99-afba72156b6e@youngman.org.uk>
 <ef3719a9-ae53-516e-29ee-36d1cdf91ef1@aim.com>
From:   Wols Lists <antlists@youngman.org.uk>
X-Enigmail-Draft-Status: N1110
Message-ID: <5F54146F.40808@youngman.org.uk>
Date:   Sat, 5 Sep 2020 23:42:55 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:38.0) Gecko/20100101
 Thunderbird/38.7.0
MIME-Version: 1.0
In-Reply-To: <ef3719a9-ae53-516e-29ee-36d1cdf91ef1@aim.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-raid-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 05/09/20 22:47, Brian Allen Vanderburg II wrote:
> The idea is actually to be able to use more than two disks, like raid 5
> or raid 6, except with parity on their own disks instead of distributed
> across disks, and data kept own their own disks as well.  I've used
> SnapRaid a bit and was just making some changes to my own setup when I
> got the idea as to why something similar can't be done in block device
> level, but keeping one of the advantages of SnapRaid-like systems which
> is if any data disk is lost beyond recovery, then only the data on that
> data disk is lost due to the fact that the data on the other data disks
> are still their own complete filesystem, and providing real-time updates
> to the parity data.

I doubt I understand what you're getting at, but this is sounding a bit
like raid-4, if you have data disk(s) and a separate parity disk. People
don't use raid 4 because it has a nasty performance hit.

Personally, I'm looking at something like raid-61 as a project. That
would let you survive four disk failures ...

Also, one of the biggest problems when a disk fails and you have to
replace it is that, at present, with nearly all raid levels even if you
have lots of disks, rebuilding a failed disk is pretty much guaranteed
to hammer just one or two surviving disks, pushing them into failure if
they're at all dodgy. I'm also looking at finding some randomisation
algorithm that will smear the blocks out across all the disks, so that
rebuilding one disk spreads the load evenly across all disks.

At the end of the day, if you think what you're doing is a good idea,
scratch that itch, bounce stuff off here (and the kernel newbies list if
you're not a kernel programmer yet), and see how it goes. Personally, I
don't think it'll fly, but I'm sure people here would say the same about
some of my pet ideas too. Give it a go!

Cheers,
Wol
