Return-Path: <SRS0=PPQD=CX=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9013C433E2
	for <linux-raid@archiver.kernel.org>; Mon, 14 Sep 2020 17:35:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 81B3520771
	for <linux-raid@archiver.kernel.org>; Mon, 14 Sep 2020 17:35:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725984AbgINRfU (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 14 Sep 2020 13:35:20 -0400
Received: from vps.thesusis.net ([34.202.238.73]:53948 "EHLO vps.thesusis.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726064AbgINR0A (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Mon, 14 Sep 2020 13:26:00 -0400
X-Greylist: delayed 389 seconds by postgrey-1.27 at vger.kernel.org; Mon, 14 Sep 2020 13:26:00 EDT
Received: from localhost (localhost [127.0.0.1])
        by vps.thesusis.net (Postfix) with ESMTP id B648C32A1B;
        Mon, 14 Sep 2020 13:19:26 -0400 (EDT)
Received: from vps.thesusis.net ([127.0.0.1])
        by localhost (ip-172-26-1-203.ec2.internal [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id Oe0e7UUUmxD1; Mon, 14 Sep 2020 13:19:25 -0400 (EDT)
Received: by vps.thesusis.net (Postfix, from userid 1000)
        id 401A532A1D; Mon, 14 Sep 2020 13:19:24 -0400 (EDT)
References: <1cf0d18c-2f63-6bca-9884-9544b0e7c54e.ref@aim.com> <1cf0d18c-2f63-6bca-9884-9544b0e7c54e@aim.com> <e3cb1bbe-65eb-5b75-8e99-afba72156b6e@youngman.org.uk> <ef3719a9-ae53-516e-29ee-36d1cdf91ef1@aim.com> <5F54146F.40808@youngman.org.uk> <274cb804-9cf1-f56c-9ee4-56463f052c09@aim.com> <ddd9b5b9-88e6-e730-29f4-30dfafd3a736@youngman.org.uk> <38f9595b-963e-b1f5-3c29-ad8981e677a7@aim.com> <9220ea81-3a81-bb98-22e3-be1a123113a1@youngman.org.uk>
User-agent: mu4e 0.9.18; emacs 25.2.2
From:   Phillip Susi <phill@thesusis.net>
To:     antlists <antlists@youngman.org.uk>
Cc:     Brian Allen Vanderburg II <brianvanderburg2@aim.com>,
        linux-raid@vger.kernel.org
Subject: Re: Linux raid-like idea
In-reply-to: <9220ea81-3a81-bb98-22e3-be1a123113a1@youngman.org.uk>
Date:   Mon, 14 Sep 2020 13:19:24 -0400
Message-ID: <87k0ww6ztv.fsf@vps.thesusis.net>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-raid-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org


antlists writes:

> Yup. Raid 6 has two parity disks, and that's mirrored to give four 
> parity disks. So as an *absolute* *minimum*, raid-61 could lose four 
> disks with no data loss.

Don't you mean 5 disks?

At best 4 lost disks paird off in each raid1 means the raid6 sees two
failures.  One more disk failing isn't enough to take out another mirror
so the raid6 keeps ticking.
