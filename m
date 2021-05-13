Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8F96C433B4
	for <linux-raid@archiver.kernel.org>; Thu, 13 May 2021 15:44:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 86320611BE
	for <linux-raid@archiver.kernel.org>; Thu, 13 May 2021 15:44:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230096AbhEMPpP (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 13 May 2021 11:45:15 -0400
Received: from vps.thesusis.net ([34.202.238.73]:58552 "EHLO vps.thesusis.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229724AbhEMPpO (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Thu, 13 May 2021 11:45:14 -0400
Received: from localhost (localhost [127.0.0.1])
        by vps.thesusis.net (Postfix) with ESMTP id 7D8D920D8B;
        Thu, 13 May 2021 11:44:04 -0400 (EDT)
Received: from vps.thesusis.net ([IPv6:::1])
        by localhost (vps.thesusis.net [IPv6:::1]) (amavisd-new, port 10024)
        with ESMTP id o723DYsxvGgE; Thu, 13 May 2021 11:44:04 -0400 (EDT)
Received: by vps.thesusis.net (Postfix, from userid 1000)
        id 2FC7B20D7F; Thu, 13 May 2021 11:44:04 -0400 (EDT)
References: <CAC6SzHJLG=0_URJUsgQshpk-QLh6b8SBJDrfxiNg4wikQw4uyw@mail.gmail.com> <2140221131.2872520.1620837067395.JavaMail.zimbra@karlsbakk.net>
User-agent: mu4e 1.5.7; emacs 26.3
From:   Phillip Susi <phill@thesusis.net>
To:     Roy Sigurd Karlsbakk <roy@karlsbakk.net>
Cc:     d tbsky <tbskyd@gmail.com>, Linux Raid <linux-raid@vger.kernel.org>
Subject: Re: raid10 redundancy
Date:   Thu, 13 May 2021 11:38:22 -0400
In-reply-to: <2140221131.2872520.1620837067395.JavaMail.zimbra@karlsbakk.net>
Message-ID: <87a6oyr64b.fsf@vps.thesusis.net>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org


Roy Sigurd Karlsbakk writes:

> Basically, the reason to use raid10 over raid6 is to increase
> performance. This is particularly important regarding rebuild
> times. If you have a huge raid-6 array with large drives, it'll take a
> long time to rebuild it after a disk fails. With raid10, this is far
> lower, since you don't need to rewrite and compute so
> much. Personally, I'd choose raid6 over raid10 in most setups unless I

How do you figure that?  Sure, raid6 is going to use more CPU time but
that isn't going to be a bottleneck unless you are using some blazing
fast NVME drives.  Certainly with HDD the rebuild time is simply how
long it takes to write all of the data to the new disk, so it's going to
be the same either way.

