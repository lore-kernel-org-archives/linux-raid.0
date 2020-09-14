Return-Path: <SRS0=PPQD=CX=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7ED9C433E2
	for <linux-raid@archiver.kernel.org>; Mon, 14 Sep 2020 11:43:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A8DE321741
	for <linux-raid@archiver.kernel.org>; Mon, 14 Sep 2020 11:43:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726086AbgINLmf (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 14 Sep 2020 07:42:35 -0400
Received: from icebox.esperi.org.uk ([81.187.191.129]:36002 "EHLO
        mail.esperi.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725964AbgINLlU (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 14 Sep 2020 07:41:20 -0400
Received: from loom (nix@sidle.srvr.nix [192.168.14.8])
        by mail.esperi.org.uk (8.15.2/8.15.2) with ESMTP id 08EBeVUA015554;
        Mon, 14 Sep 2020 12:40:31 +0100
From:   Nix <nix@esperi.org.uk>
To:     Ram Ramesh <rramesh2400@gmail.com>
Cc:     Drew <drew.kay@gmail.com>, antlists <antlists@youngman.org.uk>,
        Linux Raid <linux-raid@vger.kernel.org>
Subject: Re: Best way to add caching to a new raid setup.
References: <16cee7f2-38d9-13c8-4342-4562be68930b.ref@verizon.net>
        <16cee7f2-38d9-13c8-4342-4562be68930b@verizon.net>
        <dc91cc7d-02c4-66ee-21b4-bda69be3bbd9@youngman.org.uk>
        <1310d10c-1b83-7031-58e3-0f767b1df71b@gmail.com>
        <101d4a60-916c-fe30-ae7c-994098fe2ebe@youngman.org.uk>
        <694be035-4317-26fd-5eaf-8fdc20019d9b@gmail.com>
        <CAAMCDecWsihd4oy1ZAvcVb4aPnntrit2PXx-Zn2uM5rQoKPU=g@mail.gmail.com>
        <d4d38059-eaaa-a577-963a-c348434c260e@verizon.net>
        <CACJz6QvRqq+WLmbOYR=YECNwHzpedUjJEAcoaHseEzEd2Bq8nQ@mail.gmail.com>
        <79c15e0e-5f34-2b1a-282c-8bb36f2e3e81@gmail.com>
Emacs:  The Awakening
Date:   Mon, 14 Sep 2020 12:40:31 +0100
In-Reply-To: <79c15e0e-5f34-2b1a-282c-8bb36f2e3e81@gmail.com> (Ram Ramesh's
        message of "Tue, 1 Sep 2020 11:12:40 -0500")
Message-ID: <87v9ggzivk.fsf@esperi.org.uk>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.3.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-DCC-wuwien-Metrics: loom 1290; Body=4 Fuz1=4 Fuz2=4
Sender: linux-raid-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 1 Sep 2020, Ram Ramesh uttered the following:

> After thinking through this, I really like the idea of simply
> recording programs to SSD and move one file at a time based on some
> aging algorithms of my own. I will move files back and forth as needed
> during overnight hours creating my own caching effect.

I don't really see the benefit here for a mythtv installation in
particular. I/O patterns for large media are extremely non-seeky: even
with multiple live recordings at once, an HDD would easily be able to
keep up since it'd only have to seek a few times per 30s period given
the size of most plausible write caches.

In general, doing the hierarchical storage thing is useful if you have
stuff you will almost never access that you can keep on slower media
(or, in this case, stuff whose access patterns are non-seeky that you
can keep on media with a high seek time). But in this case, that would
be 'all of it'. Even if it weren't, by-hand copying won't deal with the
thing you really need to keep on fast-seek media: metadata. You can't
build your own filesystem with metadata on SSD and data on non-SSD this
way! But both LVM caching and bcache do exactly that.
