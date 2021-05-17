Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C9F4C433B4
	for <linux-raid@archiver.kernel.org>; Mon, 17 May 2021 20:53:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5A635611BF
	for <linux-raid@archiver.kernel.org>; Mon, 17 May 2021 20:53:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234405AbhEQUzG (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 17 May 2021 16:55:06 -0400
Received: from vps.thesusis.net ([34.202.238.73]:33664 "EHLO vps.thesusis.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233271AbhEQUzG (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Mon, 17 May 2021 16:55:06 -0400
Received: from localhost (localhost [127.0.0.1])
        by vps.thesusis.net (Postfix) with ESMTP id 386542154A;
        Mon, 17 May 2021 16:53:49 -0400 (EDT)
Received: from vps.thesusis.net ([127.0.0.1])
        by localhost (vps.thesusis.net [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id NB9SPu4DprFO; Mon, 17 May 2021 16:53:48 -0400 (EDT)
Received: by vps.thesusis.net (Postfix, from userid 1000)
        id EC21F21548; Mon, 17 May 2021 16:53:48 -0400 (EDT)
References: <CAC6SzHJLG=0_URJUsgQshpk-QLh6b8SBJDrfxiNg4wikQw4uyw@mail.gmail.com> <2140221131.2872520.1620837067395.JavaMail.zimbra@karlsbakk.net> <87a6oyr64b.fsf@vps.thesusis.net> <3f3fd663-77e4-8c23-eb22-1b8223eaf277@turmel.org> <87y2ch4c3w.fsf@vps.thesusis.net> <947223877.4161967.1621003717636.JavaMail.zimbra@karlsbakk.net>
User-agent: mu4e 1.5.7; emacs 26.3
From:   Phillip Susi <phill@thesusis.net>
To:     Roy Sigurd Karlsbakk <roy@karlsbakk.net>
Cc:     Phil Turmel <philip@turmel.org>, d tbsky <tbskyd@gmail.com>,
        Linux Raid <linux-raid@vger.kernel.org>
Subject: Re: raid10 redundancy
Date:   Mon, 17 May 2021 16:50:12 -0400
In-reply-to: <947223877.4161967.1621003717636.JavaMail.zimbra@karlsbakk.net>
Message-ID: <87cztpm68z.fsf@vps.thesusis.net>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org


Roy Sigurd Karlsbakk writes:

> RAID10 is like RAID1+0, only a bit more fancy. That means it's
> basically striping across mirrors. It's *not* like RAID0+1, which is
> the other way, when you mirror two RAID0 sets. So when a drive dies in
> a RAID10, you'll have to read from one or two other drives, depending
> on redundancy and the number of drives (odd or even).

Yes... what does that have to do with what I said?  My point was that as
long as you are IO bound, it doesn't make much difference between having
to read all of the disks in the stripe for a raid6 and having to read
some number that is possibly less than that for a raid10.  They both
take about the same amount of time as just writing the data to the new
disk.
