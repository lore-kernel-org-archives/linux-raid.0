Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7AF7C433B4
	for <linux-raid@archiver.kernel.org>; Wed, 12 May 2021 18:46:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A079461026
	for <linux-raid@archiver.kernel.org>; Wed, 12 May 2021 18:46:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245620AbhELSr3 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 12 May 2021 14:47:29 -0400
Received: from mail.thelounge.net ([91.118.73.15]:52623 "EHLO
        mail.thelounge.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347205AbhELR1m (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 12 May 2021 13:27:42 -0400
Received: from srv-rhsoft.rhsoft.net (rh.vpn.thelounge.net [10.10.10.2])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-256))
        (No client certificate requested)
        (Authenticated sender: h.reindl@thelounge.net)
        by mail.thelounge.net (THELOUNGE MTA) with ESMTPSA id 4FgMCV262QzXSq;
        Wed, 12 May 2021 19:26:30 +0200 (CEST)
To:     David T-G <davidtg-robot@justpickone.org>,
        list Linux RAID <linux-raid@vger.kernel.org>
References: <CAC6SzHJLG=0_URJUsgQshpk-QLh6b8SBJDrfxiNg4wikQw4uyw@mail.gmail.com>
 <8626adeb-696c-7778-2d5e-0718ed6aefdb@redhat.com>
 <CAC6SzHK1A=4wsbLRaYy9RTFZhda6EZs+2FjuKxahoos_zAd0iw@mail.gmail.com>
 <6db10ef4-e087-3940-4870-e5d9717b853f@thelounge.net>
 <CAC6SzH+gZ_WYRdx-vHM6zZxH=kx0YBvV-x2VT9h7EugwdmGcxA@mail.gmail.com>
 <20210508134726.GA11665@www5.open-std.org> <87y2co1zun.fsf@vps.thesusis.net>
 <20210512172242.GX1415@justpickone.org>
From:   Reindl Harald <h.reindl@thelounge.net>
Organization: the lounge interactive design
Subject: Re: raid10 redundancy
Message-ID: <35f867b4-6e20-5325-3489-6dba62041fc2@thelounge.net>
Date:   Wed, 12 May 2021 19:26:30 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210512172242.GX1415@justpickone.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



Am 12.05.21 um 19:22 schrieb David T-G:
> Phillip, et al --
> 
> ...and then Phillip Susi said...
> %
> % keld@keldix.com writes:
> %
> % > My understanding is that raid10 - all layouts - are really raid0 and
> % > then raid 1 on top.
> %
> % Naieve implementations work that way, and this is also why they require
> % a an even number of disks with 4 being the minimum.  Linux raid10 is not
> % naieve and can operate with any number of disks >= 2.
> [snip]
> 
> I've been chewing on this for a few days and I am STILL confused.  Please
> help! :-)
> 
> RAID10 is striping AND mirroring (leaving out for the moment the distinction
> of striping mirrors vs mirroring stripes).  How can one have both with only
> two disks??  You either stripe the two disks together for more storage or
> mirror them for redundant storage, but I just don't see how one could do both

by wasting even more space

the point of mirroring is that there are two phyiscal drives with each 
stripe

you can even have 20 partitions on the disks and make a big RAID10 out 
of them - not that it makes sense but you can

the point of such setups is typically temporary: at the moment only two 
disks are here but i want a RAID10 at the end of the day

for such setups often you even start with a degraded RAID and later add 
drives
