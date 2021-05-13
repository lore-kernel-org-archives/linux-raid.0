Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC5A9C433B4
	for <linux-raid@archiver.kernel.org>; Thu, 13 May 2021 15:51:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7803D6142E
	for <linux-raid@archiver.kernel.org>; Thu, 13 May 2021 15:51:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234977AbhEMPwk (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 13 May 2021 11:52:40 -0400
Received: from vps.thesusis.net ([34.202.238.73]:58566 "EHLO vps.thesusis.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234816AbhEMPwf (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Thu, 13 May 2021 11:52:35 -0400
Received: from localhost (localhost [127.0.0.1])
        by vps.thesusis.net (Postfix) with ESMTP id E88BD20DA0;
        Thu, 13 May 2021 11:51:24 -0400 (EDT)
Received: from vps.thesusis.net ([IPv6:::1])
        by localhost (vps.thesusis.net [IPv6:::1]) (amavisd-new, port 10024)
        with ESMTP id M2lSrge9OCuV; Thu, 13 May 2021 11:51:24 -0400 (EDT)
Received: by vps.thesusis.net (Postfix, from userid 1000)
        id B349720D8B; Thu, 13 May 2021 11:51:24 -0400 (EDT)
References: <CAC6SzHJLG=0_URJUsgQshpk-QLh6b8SBJDrfxiNg4wikQw4uyw@mail.gmail.com> <8626adeb-696c-7778-2d5e-0718ed6aefdb@redhat.com> <CAC6SzHK1A=4wsbLRaYy9RTFZhda6EZs+2FjuKxahoos_zAd0iw@mail.gmail.com> <6db10ef4-e087-3940-4870-e5d9717b853f@thelounge.net> <CAC6SzH+gZ_WYRdx-vHM6zZxH=kx0YBvV-x2VT9h7EugwdmGcxA@mail.gmail.com> <20210508134726.GA11665@www5.open-std.org> <87y2co1zun.fsf@vps.thesusis.net> <20210512172242.GX1415@justpickone.org>
User-agent: mu4e 1.5.7; emacs 26.3
From:   Phillip Susi <phill@thesusis.net>
To:     David T-G <davidtg-robot@justpickone.org>
Cc:     list Linux RAID <linux-raid@vger.kernel.org>
Subject: Re: raid10 redundancy
Date:   Thu, 13 May 2021 11:46:42 -0400
In-reply-to: <20210512172242.GX1415@justpickone.org>
Message-ID: <877dk2r5s3.fsf@vps.thesusis.net>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org


David T-G writes:

> RAID10 is striping AND mirroring (leaving out for the moment the distinction
> of striping mirrors vs mirroring stripes).  How can one have both with only
> two disks??  You either stripe the two disks together for more storage or
> mirror them for redundant storage, but I just don't see how one could do both.

In the default near layout, you don't get the striping with only two
disks; it is identical to raid1.  With the offset and far layouts
though, you do get the striping and the mirroring by mirroring each
stripe elsewhere on the disk ( one stripe down in the case of offset,
and in the second half of the disk in the case of far ).

With 3 disks, even the near layout benefits from striping.
