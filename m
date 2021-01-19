Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9800EC43381
	for <linux-raid@archiver.kernel.org>; Tue, 19 Jan 2021 20:03:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 50C132310B
	for <linux-raid@archiver.kernel.org>; Tue, 19 Jan 2021 20:03:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391966AbhASUBT (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 19 Jan 2021 15:01:19 -0500
Received: from vps.thesusis.net ([34.202.238.73]:40918 "EHLO vps.thesusis.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729731AbhASTuF (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Tue, 19 Jan 2021 14:50:05 -0500
X-Greylist: delayed 551 seconds by postgrey-1.27 at vger.kernel.org; Tue, 19 Jan 2021 14:50:05 EST
Received: from localhost (localhost [127.0.0.1])
        by vps.thesusis.net (Postfix) with ESMTP id 22E9F297D4;
        Tue, 19 Jan 2021 14:40:11 -0500 (EST)
Received: from vps.thesusis.net ([IPv6:::1])
        by localhost (vps.thesusis.net [IPv6:::1]) (amavisd-new, port 10024)
        with ESMTP id ervq_EOHcT1l; Tue, 19 Jan 2021 14:40:10 -0500 (EST)
Received: by vps.thesusis.net (Postfix, from userid 1000)
        id D5D012970C; Tue, 19 Jan 2021 14:40:10 -0500 (EST)
References: <950d061954e1f779739c9c5777b94ade@mail.eclipso.de> <CAJCQCtTT+_2F2EFUz=juOn2YG+ZOu2gmNx1Qwu2wp6273T9DNA@mail.gmail.com>
User-agent: mu4e 1.5.7; emacs 26.3
From:   Phillip Susi <phill@thesusis.net>
To:     Chris Murphy <lists@colorremedies.com>
Cc:     Cedric.dewijs@eclipso.eu, Linux-RAID <linux-raid@vger.kernel.org>
Subject: Re: What is the best way to combine 4 HDD's and 2 SSD's into a single filesystem?
Date:   Tue, 19 Jan 2021 14:27:55 -0500
In-reply-to: <CAJCQCtTT+_2F2EFUz=juOn2YG+ZOu2gmNx1Qwu2wp6273T9DNA@mail.gmail.com>
Message-ID: <87ft2w67hh.fsf@vps.thesusis.net>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org


Chris Murphy writes:

> A
>
> HDD1+SSD1=>
>                             Btrfs raid1 profile for metadata, raid0 or
> raid1 profile for data depending on your risk tolerance
> HDD2+SSD2=>

But then sometimes reads will go to one leg and miss the cache and have
to hit the HDD even though the data is in the ssd cache of the other leg
already.  Therefore, wouldn't it be preferable to keep the mirroring
underneath the cache?  Also having a separate B with the other two HDDs
and using it purely as a backup further halves your storage capacity (
so now only 1/4th ).  Also if one disk gets spun up to satisfy a read,
the next read might go start up the other disk rather than go to the one
that is already running.

I'd say make a raid5 of the 4 HDDs, a raid1 of the the two SSDs, and use
the combined SSDs to cache the combined HDDs.
