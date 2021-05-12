Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6272EC43461
	for <linux-raid@archiver.kernel.org>; Wed, 12 May 2021 18:55:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2FFD0613EE
	for <linux-raid@archiver.kernel.org>; Wed, 12 May 2021 18:55:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237683AbhELSsD (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 12 May 2021 14:48:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347761AbhELR3j (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 12 May 2021 13:29:39 -0400
Received: from u17383850.onlinehome-server.com (u17383850.onlinehome-server.com [IPv6:2607:f1c0:83f:ac00::a6:f62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6ED5EC061760
        for <linux-raid@vger.kernel.org>; Wed, 12 May 2021 10:28:31 -0700 (PDT)
Received: by u17383850.onlinehome-server.com (Postfix, from userid 5001)
        id D13C376B; Wed, 12 May 2021 13:22:42 -0400 (EDT)
Date:   Wed, 12 May 2021 13:22:42 -0400
From:   David T-G <davidtg-robot@justpickone.org>
To:     list Linux RAID <linux-raid@vger.kernel.org>
Subject: Re: raid10 redundancy
Message-ID: <20210512172242.GX1415@justpickone.org>
References: <CAC6SzHJLG=0_URJUsgQshpk-QLh6b8SBJDrfxiNg4wikQw4uyw@mail.gmail.com>
 <8626adeb-696c-7778-2d5e-0718ed6aefdb@redhat.com>
 <CAC6SzHK1A=4wsbLRaYy9RTFZhda6EZs+2FjuKxahoos_zAd0iw@mail.gmail.com>
 <6db10ef4-e087-3940-4870-e5d9717b853f@thelounge.net>
 <CAC6SzH+gZ_WYRdx-vHM6zZxH=kx0YBvV-x2VT9h7EugwdmGcxA@mail.gmail.com>
 <20210508134726.GA11665@www5.open-std.org>
 <87y2co1zun.fsf@vps.thesusis.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87y2co1zun.fsf@vps.thesusis.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Phillip, et al --

...and then Phillip Susi said...
% 
% keld@keldix.com writes:
% 
% > My understanding is that raid10 - all layouts - are really raid0 and
% > then raid 1 on top.
% 
% Naieve implementations work that way, and this is also why they require
% a an even number of disks with 4 being the minimum.  Linux raid10 is not
% naieve and can operate with any number of disks >= 2.
[snip]

I've been chewing on this for a few days and I am STILL confused.  Please
help! :-)

RAID10 is striping AND mirroring (leaving out for the moment the distinction
of striping mirrors vs mirroring stripes).  How can one have both with only
two disks??  You either stripe the two disks together for more storage or
mirror them for redundant storage, but I just don't see how one could do both.


Thanks in advance :-)

:-D
-- 
David T-G
See http://justpickone.org/davidtg/email/
See http://justpickone.org/davidtg/tofu.txt

