Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDD57C433ED
	for <linux-raid@archiver.kernel.org>; Sun,  9 May 2021 01:16:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BDD68613D9
	for <linux-raid@archiver.kernel.org>; Sun,  9 May 2021 01:16:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229648AbhEIBRh (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 8 May 2021 21:17:37 -0400
Received: from vps.thesusis.net ([34.202.238.73]:48810 "EHLO vps.thesusis.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229601AbhEIBRg (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Sat, 8 May 2021 21:17:36 -0400
Received: from localhost (localhost [127.0.0.1])
        by vps.thesusis.net (Postfix) with ESMTP id 974D52F37E;
        Sat,  8 May 2021 21:16:33 -0400 (EDT)
Received: from vps.thesusis.net ([IPv6:::1])
        by localhost (vps.thesusis.net [IPv6:::1]) (amavisd-new, port 10024)
        with ESMTP id cRrYiFapV1t8; Sat,  8 May 2021 21:16:33 -0400 (EDT)
Received: by vps.thesusis.net (Postfix, from userid 1000)
        id 5750D2F37C; Sat,  8 May 2021 21:16:33 -0400 (EDT)
References: <CAC6SzHJLG=0_URJUsgQshpk-QLh6b8SBJDrfxiNg4wikQw4uyw@mail.gmail.com> <8626adeb-696c-7778-2d5e-0718ed6aefdb@redhat.com> <CAC6SzHK1A=4wsbLRaYy9RTFZhda6EZs+2FjuKxahoos_zAd0iw@mail.gmail.com> <871rakovki.fsf@vps.thesusis.net> <CAC6SzHKKPCk4fOx7b2CxMWorPghRPMH3GD2v7vcC_YLKbDn7KA@mail.gmail.com>
User-agent: mu4e 1.5.7; emacs 26.3
From:   Phillip Susi <phill@thesusis.net>
To:     d tbsky <tbskyd@gmail.com>
Cc:     Xiao Ni <xni@redhat.com>,
        list Linux RAID <linux-raid@vger.kernel.org>
Subject: Re: raid10 redundancy
Date:   Sat, 08 May 2021 21:10:28 -0400
In-reply-to: <CAC6SzHKKPCk4fOx7b2CxMWorPghRPMH3GD2v7vcC_YLKbDn7KA@mail.gmail.com>
Message-ID: <87sg2w1zbi.fsf@vps.thesusis.net>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org


d tbsky writes:

> I thought someone test the performance of two ssd, raid-1 outperforms
> all the layout. so maybe under ssd it's not important?

A two disk raid10 in the near layout should be identical to a raid1 and
have exactly the same performance.  The benefits from the offset and far
layouts obviosuly should not help with SSDs since they have no seek penalty.

>  I am trying to figure out how to lose two disks without losing two
> copies. in history there are time bombs in ssd (like hp ssd made by
> samsung) caused by buggy firmware.
> if I put the orders correct, it will be safe even the same twin ssd
> died together.

You don't.  You don't get to pick which of the remaining disks the
second failure will take.  In my experience, the real problem with buggy
SSD firmware is that it silently corrupts data by doing nasty things
like changing the contents of an LBA to something that had been there
prior to the last completed write, or worse yet, conents of another LBA
completely.  I had an OCZ SSD that started throwing ext4 errors and fsck
complained that an inode table was corrupt and when I looked into it
with debugfs, I found the contents of some text file where the inode
table should have been, which clearly had never been written to that
LBA.

