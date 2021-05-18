Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92873C43460
	for <linux-raid@archiver.kernel.org>; Tue, 18 May 2021 18:57:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 77CCD61261
	for <linux-raid@archiver.kernel.org>; Tue, 18 May 2021 18:57:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351714AbhERS6s (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 18 May 2021 14:58:48 -0400
Received: from vps.thesusis.net ([34.202.238.73]:34882 "EHLO vps.thesusis.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239247AbhERS6r (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Tue, 18 May 2021 14:58:47 -0400
Received: from localhost (localhost [127.0.0.1])
        by vps.thesusis.net (Postfix) with ESMTP id 1850F21844;
        Tue, 18 May 2021 14:57:29 -0400 (EDT)
Received: from vps.thesusis.net ([127.0.0.1])
        by localhost (vps.thesusis.net [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id EL97CiOOwxGN; Tue, 18 May 2021 14:57:28 -0400 (EDT)
Received: by vps.thesusis.net (Postfix, from userid 1000)
        id DB87921842; Tue, 18 May 2021 14:57:28 -0400 (EDT)
References: <CAC6SzHJLG=0_URJUsgQshpk-QLh6b8SBJDrfxiNg4wikQw4uyw@mail.gmail.com> <2140221131.2872520.1620837067395.JavaMail.zimbra@karlsbakk.net> <87a6oyr64b.fsf@vps.thesusis.net> <3f3fd663-77e4-8c23-eb22-1b8223eaf277@turmel.org> <87y2ch4c3w.fsf@vps.thesusis.net> <947223877.4161967.1621003717636.JavaMail.zimbra@karlsbakk.net> <87cztpm68z.fsf@vps.thesusis.net> <60A2EC87.9080701@youngman.org.uk> <874kf0yq31.fsf@vps.thesusis.net> <b27c2f22-a88e-520f-57ef-bc84afb938c3@thelounge.net>
User-agent: mu4e 1.5.7; emacs 26.3
From:   Phillip Susi <phill@thesusis.net>
To:     Reindl Harald <h.reindl@thelounge.net>
Cc:     Wols Lists <antlists@youngman.org.uk>,
        Roy Sigurd Karlsbakk <roy@karlsbakk.net>,
        Linux Raid <linux-raid@vger.kernel.org>
Subject: Re: raid10 redundancy
Date:   Tue, 18 May 2021 14:51:05 -0400
In-reply-to: <b27c2f22-a88e-520f-57ef-bc84afb938c3@thelounge.net>
Message-ID: <87wnrvdg4n.fsf@vps.thesusis.net>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org


Reindl Harald writes:

> it's common sense that additional load on drives which have the same 
> history makes a failure one one of them more likely

"It's common sense" = the logical fallacy of hand waving.  Show me
statistical evidence.  I have had lightly loaded drives die in under 2
years and heavily loaded ones last 10 years.  I have replaced failed
drives in a raid and the other drives with essentially the same wear on
them lasted for years without another failure.  There does not appear to
be a strong correlation usage and drive failure.  Certainly not one that
is so strong that you can claim with a straight face that after the
first failure, a second one can be expected within X IOPS, and the IOPS
needed to rebuild the array are a significant fraction of X.

