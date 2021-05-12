Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37ACDC433B4
	for <linux-raid@archiver.kernel.org>; Wed, 12 May 2021 18:55:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E7FA2613C4
	for <linux-raid@archiver.kernel.org>; Wed, 12 May 2021 18:55:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343564AbhELSrz (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 12 May 2021 14:47:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347553AbhELR2t (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 12 May 2021 13:28:49 -0400
X-Greylist: delayed 279 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 12 May 2021 10:27:23 PDT
Received: from u17383850.onlinehome-server.com (u17383850.onlinehome-server.com [IPv6:2607:f1c0:83f:ac00::a6:f62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1631AC061347
        for <linux-raid@vger.kernel.org>; Wed, 12 May 2021 10:27:22 -0700 (PDT)
Received: by u17383850.onlinehome-server.com (Postfix, from userid 5001)
        id 80E28770; Wed, 12 May 2021 13:27:20 -0400 (EDT)
Date:   Wed, 12 May 2021 13:27:20 -0400
From:   David T-G <davidtg-robot@justpickone.org>
To:     list Linux RAID <linux-raid@vger.kernel.org>
Subject: Re: raid10 redundancy
Message-ID: <20210512172720.GY1415@justpickone.org>
References: <CAC6SzHJLG=0_URJUsgQshpk-QLh6b8SBJDrfxiNg4wikQw4uyw@mail.gmail.com>
 <AD8C004B-FE83-4ABD-B58A-1F7F8683CD1F@websitemanagers.com.au>
 <CAC6SzHKH62XwudewxtOUyNQYi9QSFar=dZ64fz9HiEW1eZh47g@mail.gmail.com>
 <60950C7B.5040706@youngman.org.uk>
 <8333ded7-8805-18df-13d8-166ba021ac02@turmel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8333ded7-8805-18df-13d8-166ba021ac02@turmel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Phil, et al --

...and then Phil Turmel said...
% 
% I do this for my medium-speed read-mostly tasks.  Raid10,n3 across 4
% or 5 disks gives me redundancy comparable to raid6 (lose any two)
% without the CPU load of parity and syndrome calculations.

I've been reading and I still need to catch up on the notation, but how
much space do you get in the end?

I'm hoping to grow our disk farm and end up with 8+ disks.  I'm more than
a bit nervous about RAID5 across a bunch of 6T (or bigger) disks, so I've
been thinking of RAID6.  That would give me 6x6 = 36T plus two parity.

Putting 8 disks in RAID10 should give me 6x4 = 24T with mirroring.
That's a pretty hefty space penalty :-(  But ...

How does RAID10 across 5 disks as above 1) work and 2) work out?  If you
had 8 disks with a huge need for space, how would y'all lay out everything?


% 
% Phil


Thanks in advance :-)

:-D
-- 
David T-G
See http://justpickone.org/davidtg/email/
See http://justpickone.org/davidtg/tofu.txt

