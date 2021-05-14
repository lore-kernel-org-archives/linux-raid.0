Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F105CC433B4
	for <linux-raid@archiver.kernel.org>; Fri, 14 May 2021 14:30:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ADEFE6144A
	for <linux-raid@archiver.kernel.org>; Fri, 14 May 2021 14:30:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231751AbhENObP (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 14 May 2021 10:31:15 -0400
Received: from vps.thesusis.net ([34.202.238.73]:59746 "EHLO vps.thesusis.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230141AbhENObP (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Fri, 14 May 2021 10:31:15 -0400
Received: from localhost (localhost [127.0.0.1])
        by vps.thesusis.net (Postfix) with ESMTP id 6A7CA21042;
        Fri, 14 May 2021 10:30:03 -0400 (EDT)
Received: from vps.thesusis.net ([127.0.0.1])
        by localhost (vps.thesusis.net [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id ArY7Ln9a4yY7; Fri, 14 May 2021 10:30:03 -0400 (EDT)
Received: by vps.thesusis.net (Postfix, from userid 1000)
        id 2C01B21040; Fri, 14 May 2021 10:30:03 -0400 (EDT)
References: <CAC6SzHJLG=0_URJUsgQshpk-QLh6b8SBJDrfxiNg4wikQw4uyw@mail.gmail.com> <8626adeb-696c-7778-2d5e-0718ed6aefdb@redhat.com> <CAC6SzHK1A=4wsbLRaYy9RTFZhda6EZs+2FjuKxahoos_zAd0iw@mail.gmail.com> <6db10ef4-e087-3940-4870-e5d9717b853f@thelounge.net> <CAC6SzH+gZ_WYRdx-vHM6zZxH=kx0YBvV-x2VT9h7EugwdmGcxA@mail.gmail.com> <20210508134726.GA11665@www5.open-std.org> <87y2co1zun.fsf@vps.thesusis.net> <20210512172242.GX1415@justpickone.org> <877dk2r5s3.fsf@vps.thesusis.net> <20210513155956.6m6yek3t4ln464bw@bitfolk.com>
User-agent: mu4e 1.5.7; emacs 26.3
From:   Phillip Susi <phill@thesusis.net>
To:     Andy Smith <andy@strugglers.net>
Cc:     list Linux RAID <linux-raid@vger.kernel.org>
Subject: Re: raid10 redundancy
Date:   Fri, 14 May 2021 10:28:52 -0400
In-reply-to: <20210513155956.6m6yek3t4ln464bw@bitfolk.com>
Message-ID: <871ra95qxg.fsf@vps.thesusis.net>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org


Andy Smith writes:

> While the *layout* would be identical to RAID-1 in this case, there
> is the difference that a single threaded read will come from both
> devices with RAID-10, right?

No, since the data is not striped, you would get *worse* performance if
you tried to do that.
