Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC036C4338F
	for <linux-raid@archiver.kernel.org>; Tue, 24 Aug 2021 19:50:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D2862611F0
	for <linux-raid@archiver.kernel.org>; Tue, 24 Aug 2021 19:50:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231417AbhHXTuy (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 24 Aug 2021 15:50:54 -0400
Received: from vps.thesusis.net ([34.202.238.73]:35764 "EHLO vps.thesusis.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229514AbhHXTuy (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Tue, 24 Aug 2021 15:50:54 -0400
X-Greylist: delayed 559 seconds by postgrey-1.27 at vger.kernel.org; Tue, 24 Aug 2021 15:50:54 EDT
Received: by vps.thesusis.net (Postfix, from userid 1000)
        id 1675347492; Tue, 24 Aug 2021 15:40:20 -0400 (EDT)
References: <5EAED86C53DED2479E3E145969315A238585EA77@UMECHPA7B.easf.csd.disa.mil>
User-agent: mu4e 1.5.13; emacs 27.1
From:   Phillip Susi <phill@thesusis.net>
To:     "Finlayson, James M CIV (USA)" <james.m.finlayson4.civ@mail.mil>
Cc:     "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
Subject: Re: SSDs and mdraid
Date:   Tue, 24 Aug 2021 15:38:38 -0400
In-reply-to: <5EAED86C53DED2479E3E145969315A238585EA77@UMECHPA7B.easf.csd.disa.mil>
Message-ID: <87y28qws0r.fsf@vps.thesusis.net>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org


"Finlayson, James M CIV (USA)" <james.m.finlayson4.civ@mail.mil> writes:

> All,
> As I'm trying to achieve maximum performance on mdraid with SSDs, I've
> noticed a situation that I think could be corrected somewhat easily.
>
> I've been having to play the partitioning game to get enough kernel
> workers to achieve maximum performance on mdraid SSD stripes, but I've
> run into a few troubling problems.  Basically on raid creation and on
> raid check, many events get DELAYED because they share underlying
> devices with other mdraid stripes when you look at the status in
> /proc/mdstat.  I feel like mdraid hasn't made the leap to SSDs, in
> that we have a signal in /sys/block/<md_device>/queue/rotational that
> could enable these DELAYED activities for SSDs.  The SSDs have way
> more IOPS, both read and write, to handle these DELAYs and we need to
> start taking advantage of the abilities of the SSDs.  It is an SSD
> world now.

While there is little to no pentalty for running multiple concurrent IO
streams to the SSD, there is nothing gained by doing so either.  In
other words, if you are trying to resync both mirrors on different parts
of two SSDs at the same time, each one will go half as fast, and will
take the same amount of time to finish both.
