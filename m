Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5812BC433B4
	for <linux-raid@archiver.kernel.org>; Tue, 18 May 2021 16:16:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 29E726100C
	for <linux-raid@archiver.kernel.org>; Tue, 18 May 2021 16:16:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350239AbhERQSJ (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 18 May 2021 12:18:09 -0400
Received: from vps.thesusis.net ([34.202.238.73]:34646 "EHLO vps.thesusis.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242950AbhERQSJ (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Tue, 18 May 2021 12:18:09 -0400
Received: from localhost (localhost [127.0.0.1])
        by vps.thesusis.net (Postfix) with ESMTP id 70B4C2177F;
        Tue, 18 May 2021 12:16:50 -0400 (EDT)
Received: from vps.thesusis.net ([127.0.0.1])
        by localhost (vps.thesusis.net [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id QwQHI5gPFq_P; Tue, 18 May 2021 12:16:50 -0400 (EDT)
Received: by vps.thesusis.net (Postfix, from userid 1000)
        id 2D43A21786; Tue, 18 May 2021 12:16:50 -0400 (EDT)
References: <CAC6SzHJLG=0_URJUsgQshpk-QLh6b8SBJDrfxiNg4wikQw4uyw@mail.gmail.com> <2140221131.2872520.1620837067395.JavaMail.zimbra@karlsbakk.net> <87a6oyr64b.fsf@vps.thesusis.net> <3f3fd663-77e4-8c23-eb22-1b8223eaf277@turmel.org> <87y2ch4c3w.fsf@vps.thesusis.net> <947223877.4161967.1621003717636.JavaMail.zimbra@karlsbakk.net> <87cztpm68z.fsf@vps.thesusis.net> <60A2EC87.9080701@youngman.org.uk>
User-agent: mu4e 1.5.7; emacs 26.3
From:   Phillip Susi <phill@thesusis.net>
To:     Wols Lists <antlists@youngman.org.uk>
Cc:     Roy Sigurd Karlsbakk <roy@karlsbakk.net>,
        Linux Raid <linux-raid@vger.kernel.org>
Subject: Re: raid10 redundancy
Date:   Tue, 18 May 2021 12:05:26 -0400
In-reply-to: <60A2EC87.9080701@youngman.org.uk>
Message-ID: <874kf0yq31.fsf@vps.thesusis.net>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org


Wols Lists writes:

> When rebuilding a mirror (of any sort), one block written requires ONE
> block read. When rebuilding a parity array, one block written requires
> one STRIPE read.

Again, we're in agreement here.  What you keep ignoring is the fact that
both of these take the same amount of time, provided that you are IO bound.

> That's a hell of a lot more load on the machine. And when faced with a
> production machine that needs to work (as opposed to a hobbyist machine
> which can dedicate itself solely to a rebuild), you have the two
> conflicting requirements that you need to finish the rebuild as quickly
> as possible for data safety, but you also need the computer to do real
> work. Minimising disk i/o is *crucial*.

That is true, it does put less load on the machine giving it more time
to perform other tasks, but your original argument was that it is more
likely to fail during a rebuild.  I suppose if you take the two together
and assume the machine is busy servicing other tasks while doing the
rebuild, then both are probably going to slow down somewhat leading to
the rebuild taking a little longer, but I have a hard time believing
that it is going to be 2-3 times longer, or that it is really very
likely of having a second failure in that time.
