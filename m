Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92C30C433B4
	for <linux-raid@archiver.kernel.org>; Sun,  9 May 2021 01:05:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5F4D5613FA
	for <linux-raid@archiver.kernel.org>; Sun,  9 May 2021 01:05:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229647AbhEIBGI (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 8 May 2021 21:06:08 -0400
Received: from vps.thesusis.net ([34.202.238.73]:48780 "EHLO vps.thesusis.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229620AbhEIBGI (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Sat, 8 May 2021 21:06:08 -0400
Received: from localhost (localhost [127.0.0.1])
        by vps.thesusis.net (Postfix) with ESMTP id 414332F37E;
        Sat,  8 May 2021 21:05:05 -0400 (EDT)
Received: from vps.thesusis.net ([IPv6:::1])
        by localhost (vps.thesusis.net [IPv6:::1]) (amavisd-new, port 10024)
        with ESMTP id xxgxjM3mzGMq; Sat,  8 May 2021 21:05:05 -0400 (EDT)
Received: by vps.thesusis.net (Postfix, from userid 1000)
        id F2EF82F37C; Sat,  8 May 2021 21:05:04 -0400 (EDT)
References: <CAC6SzHJLG=0_URJUsgQshpk-QLh6b8SBJDrfxiNg4wikQw4uyw@mail.gmail.com> <8626adeb-696c-7778-2d5e-0718ed6aefdb@redhat.com> <CAC6SzHK1A=4wsbLRaYy9RTFZhda6EZs+2FjuKxahoos_zAd0iw@mail.gmail.com> <6db10ef4-e087-3940-4870-e5d9717b853f@thelounge.net> <CAC6SzH+gZ_WYRdx-vHM6zZxH=kx0YBvV-x2VT9h7EugwdmGcxA@mail.gmail.com> <20210508134726.GA11665@www5.open-std.org>
User-agent: mu4e 1.5.7; emacs 26.3
From:   Phillip Susi <phill@thesusis.net>
To:     keld@keldix.com
Cc:     d tbsky <tbskyd@gmail.com>, Reindl Harald <h.reindl@thelounge.net>,
        list Linux RAID <linux-raid@vger.kernel.org>
Subject: Re: raid10 redundancy
Date:   Sat, 08 May 2021 20:52:18 -0400
In-reply-to: <20210508134726.GA11665@www5.open-std.org>
Message-ID: <87y2co1zun.fsf@vps.thesusis.net>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org


keld@keldix.com writes:

> My understanding is that raid10 - all layouts - are really raid0 and
> then raid 1 on top.

Naieve implementations work that way, and this is also why they require
a an even number of disks with 4 being the minimum.  Linux raid10 is not
naieve and can operate with any number of disks >= 2.

> If you loose two disks you loose the whole raid in 2 out of 3 cases in a 4 disk setup.
> If it was raid0 over a raid1 you would only lose the whole raid in one out of 3.
>
>                raid1
>            raid0  raid0      
>            d1 d2  d3 d4
>
>
> gone d1+d2  survives d3+d4
> gone d1+d3  dead
> gone d1+d4  dead

Only for the naieve implementation that considers the whole raid0 dead
as soon as one drive fails.  Linux raid10 does not have this problem
because it knows that if d1 and d3 fail, you still have a copy of all of
the required data on d2 and d4.

The bottom line is that the exact layout doesn't really matter.  You
have two copies of all data and so you can be sure that the array can
survie any one failure.  An additional failure has a 1/3 chance of
killing the whole array ( for a 4 drive array ).  Of course, you could
say, have an 8 disk array with 3 copies, then it can survive any 2
failures, and has a 5/6 chance of surviving another failure.  On the
other hand, you only get 1/3rd of the usable capacity of those 8 disks.
