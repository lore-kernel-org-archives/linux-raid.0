Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.0 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD25EC433ED
	for <linux-raid@archiver.kernel.org>; Sat,  8 May 2021 05:55:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 910456141F
	for <linux-raid@archiver.kernel.org>; Sat,  8 May 2021 05:55:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229583AbhEHF4I (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 8 May 2021 01:56:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbhEHF4I (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 8 May 2021 01:56:08 -0400
Received: from mail.bitfolk.com (mail.bitfolk.com [IPv6:2001:ba8:1f1:f019::25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A037C061574
        for <linux-raid@vger.kernel.org>; Fri,  7 May 2021 22:55:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=bitfolk.com
        ; s=alpha; h=In-Reply-To:Content-Transfer-Encoding:Content-Type:MIME-Version:
        References:Message-ID:Subject:To:From:Date:Sender:Reply-To:Cc:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=TXK+hBINWM/IGUpDrEfF8szC/IPTDjMIGD/bhCdnXew=; b=Eo72eIJCnr4KJappGaWzHxA/ze
        LVFt2cv4UDiC0j8UgGho95UrYf7KiDHBIHrEger7atxXmM4v5sf2U8YRXeCgXDXPgoZWNX/hiDGMJ
        lf66eE/BplYUqfJRaZHnEIe6pz2J8TjqKkMjRjjzCfWBJNmhoZB9P5tQOZEqo+7rtNSz2R20YCRDZ
        t9WHU+HP5ypj4dHgua70D2B9GsDE5AgybGvY6/wSbE/YHBR1qq8y0QXcMoaj8uHc2caZuAmiAElYB
        MyRrtWtY3GDMEsG1qcNjmflMP0weeKTtGh0IvIJosVvHnhDrPl6/zZy6ikzsYBM1VKOFWUfgOskD7
        y4jxHmjw==;
Received: from andy by mail.bitfolk.com with local (Exim 4.89)
        (envelope-from <andy@strugglers.net>)
        id 1lfFvd-0001Rd-VS
        for linux-raid@vger.kernel.org; Sat, 08 May 2021 05:55:05 +0000
Date:   Sat, 8 May 2021 05:55:05 +0000
From:   Andy Smith <andy@strugglers.net>
To:     list Linux RAID <linux-raid@vger.kernel.org>
Subject: Re: raid10 redundancy
Message-ID: <20210508055505.muicnszlwvpfqbnn@bitfolk.com>
Mail-Followup-To: list Linux RAID <linux-raid@vger.kernel.org>
References: <CAC6SzHJLG=0_URJUsgQshpk-QLh6b8SBJDrfxiNg4wikQw4uyw@mail.gmail.com>
 <8626adeb-696c-7778-2d5e-0718ed6aefdb@redhat.com>
 <CAC6SzHK1A=4wsbLRaYy9RTFZhda6EZs+2FjuKxahoos_zAd0iw@mail.gmail.com>
 <871rakovki.fsf@vps.thesusis.net>
 <CAC6SzHKKPCk4fOx7b2CxMWorPghRPMH3GD2v7vcC_YLKbDn7KA@mail.gmail.com>
 <20210507145312.qjrvho4m64s3uz3t@bitfolk.com>
 <CAC6SzHL+o6TY_7JhHvdZ52cu5DZySFk4nj84TnHf+p9nOvnp3g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAC6SzHL+o6TY_7JhHvdZ52cu5DZySFk4nj84TnHf+p9nOvnp3g@mail.gmail.com>
OpenPGP: id=BF15490B; url=http://strugglers.net/~andy/pubkey.asc
X-URL:  http://strugglers.net/wiki/User:Andy
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: andy@strugglers.net
X-SA-Exim-Scanned: No (on mail.bitfolk.com); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hello,

On Sat, May 08, 2021 at 09:54:03AM +0800, d tbsky wrote:
> Andy Smith <andy@strugglers.net>
> > If you're referring to this, which I wrote:
> >
> >     http://strugglers.net/~andy/blog/2019/06/01/why-linux-raid-10-sometimes-performs-worse-than-raid-1/

[…]

> sorry I didn't find that comprehensive report before.

Okay, so that wasn't what you were thinking of then.

I haven't got anything published to back up the assertion but I
haven't really noticed very much performance difference between
RAID-10 and RAID-1 on non-rotational storage since the above fix.
Most of my storage is non-rotational these days.

> what I saw is that raid10 and raid1 performance are similar and
> raid1 is a little faster.

I haven't got anything published to back up the assertion but I
haven't really noticed very much performance difference between
RAID-10 and RAID-1 on non-rotational storage since the above fix.
Most of my storage is non-rotational these days.

That does assume a load that isn't single-threaded, since a single
thread is only ever going to read from one half of an md RAID-1. It
doesn't stripe.

> so I just use raid1 at two disks conditions these years. like the
> discussion here
> https://www.reddit.com/r/homelab/comments/4pfonh/2_disk_ssd_raid_raid_1_or_10/

I must admit that as most of my storage has shifted from HDD to SSD
I've shifted away from md RAID-10, which I used to use even when
there were only 2 devices. With HDDs I felt (and measured) the
increased performance.

But with SSDs these days I tend to just use RAID-1 pairs and
concatenate them in LVM (which I am using anyway) afterwards. Mainly
just because it's much simpler and the performance is good enough.

If you need to eke out the most performance this is maybe not the
way. Certainly not the way if you need better redundancy (lose any
two devices etc). Many concerns, performance only one of them…

> I don't know if the situation is the same now. I will try to do my
> testing. but I think in theory they are similar under multiple
> process.

I think so but it's always good to see a recent test with numbers!

Cheers,
Andy
