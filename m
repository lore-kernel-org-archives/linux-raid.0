Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A244C433ED
	for <linux-raid@archiver.kernel.org>; Wed, 12 May 2021 18:55:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5AF5E61352
	for <linux-raid@archiver.kernel.org>; Wed, 12 May 2021 18:55:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240044AbhELSsP (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 12 May 2021 14:48:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235751AbhELRkm (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 12 May 2021 13:40:42 -0400
Received: from u17383850.onlinehome-server.com (u17383850.onlinehome-server.com [IPv6:2607:f1c0:83f:ac00::a6:f62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 35D8CC061574
        for <linux-raid@vger.kernel.org>; Wed, 12 May 2021 10:39:34 -0700 (PDT)
Received: by u17383850.onlinehome-server.com (Postfix, from userid 5001)
        id A4BD776B; Wed, 12 May 2021 13:39:33 -0400 (EDT)
Date:   Wed, 12 May 2021 13:39:33 -0400
From:   David T-G <davidtg-robot@justpickone.org>
To:     Reindl Harald <h.reindl@thelounge.net>
Cc:     list Linux RAID <linux-raid@vger.kernel.org>
Subject: Re: raid10 redundancy
Message-ID: <20210512173933.GZ1415@justpickone.org>
References: <CAC6SzHJLG=0_URJUsgQshpk-QLh6b8SBJDrfxiNg4wikQw4uyw@mail.gmail.com>
 <8626adeb-696c-7778-2d5e-0718ed6aefdb@redhat.com>
 <CAC6SzHK1A=4wsbLRaYy9RTFZhda6EZs+2FjuKxahoos_zAd0iw@mail.gmail.com>
 <6db10ef4-e087-3940-4870-e5d9717b853f@thelounge.net>
 <CAC6SzH+gZ_WYRdx-vHM6zZxH=kx0YBvV-x2VT9h7EugwdmGcxA@mail.gmail.com>
 <20210508134726.GA11665@www5.open-std.org>
 <87y2co1zun.fsf@vps.thesusis.net>
 <20210512172242.GX1415@justpickone.org>
 <35f867b4-6e20-5325-3489-6dba62041fc2@thelounge.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <35f867b4-6e20-5325-3489-6dba62041fc2@thelounge.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Reindl, et al --

...and then Reindl Harald said...
% 
% Am 12.05.21 um 19:22 schrieb David T-G:
% >
% >...and then Phillip Susi said...
% >%
% >% Naieve implementations work that way, and this is also why they require
% >% a an even number of disks with 4 being the minimum.  Linux raid10 is not
% >% naieve and can operate with any number of disks >= 2.
...
% >
% >RAID10 is striping AND mirroring (leaving out for the moment the distinction
...
% >mirror them for redundant storage, but I just don't see how one could do both
% 
% by wasting even more space

Well, that's an interesting approach :-)


% 
% the point of mirroring is that there are two phyiscal drives with
% each stripe

Right.


% 
% you can even have 20 partitions on the disks and make a big RAID10
% out of them - not that it makes sense but you can

Hmmmm...  OK.  Yes, that makes sense (logically, anyway!).


% 
% the point of such setups is typically temporary: at the moment only
% two disks are here but i want a RAID10 at the end of the day
% 
% for such setups often you even start with a degraded RAID and later
% add drives

Aha!  NOW I start to see it.  So you set up two mirrors each with only
one disk, and then you stripe them, and you get the full size before
later adding the other side of each mirror.  Right?

So it's not an end goal configuration :-)


Thanks again & HAND

:-D
-- 
David T-G
See http://justpickone.org/davidtg/email/
See http://justpickone.org/davidtg/tofu.txt

