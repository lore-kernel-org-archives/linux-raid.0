Return-Path: <SRS0=8aTj=CH=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98A3FC433E6
	for <linux-raid@archiver.kernel.org>; Sat, 29 Aug 2020 21:27:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7328520776
	for <linux-raid@archiver.kernel.org>; Sat, 29 Aug 2020 21:27:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fS1PBA+Z"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727831AbgH2V1O (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 29 Aug 2020 17:27:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726748AbgH2V1L (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 29 Aug 2020 17:27:11 -0400
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0DF9C061573
        for <linux-raid@vger.kernel.org>; Sat, 29 Aug 2020 14:27:10 -0700 (PDT)
Received: by mail-lf1-x135.google.com with SMTP id c15so1525339lfi.3
        for <linux-raid@vger.kernel.org>; Sat, 29 Aug 2020 14:27:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xJta4MTlSOGI7lhQQ/Hq0EXbH6kLf+lldZmuW8M8IIc=;
        b=fS1PBA+Zot6UdHAbtTAsk4BD8XSgyPxfvu2tdepClgNUJ6TJqw71zpPdHBP7mxHl//
         qmYVa49qKy/qebTvn5CMUNAqDdmo9BfUutCcRlPZs++ZInFwoiAMXGFDX3o50RqfV5wK
         GXKuQQpiwzly14y1fLzGlQFISQPepUvJpQNRVV2VL8gi+pWJpQu8r5lAWOiuEOmE5Lmx
         9JyF/NA759C/Gt6dfTT0BqO/OmCOsF7emn1ZwPazq0OwXiHrhMV/Z7hR5mgY6IuwpFgG
         siOIOVGL2TjCE4aG6rV0iPlUopn1HOt1mjCMKa1Z+NPdY8OkXhCTEhloT9P98arTqL3v
         H4ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xJta4MTlSOGI7lhQQ/Hq0EXbH6kLf+lldZmuW8M8IIc=;
        b=dxcAB/zbjKThfhdAyd5EADTC7UAjjzlBaVDjr8u6wr7l/TawB3nvA9jpaqXgzaOLy7
         6nj5gUNrbjskSNW0oE41o+K5b2EAdSIUxpXx176d2SPbysPrw9j9h0kMVaTCwh24de85
         w0Vrbe4XHgWOlrCFTs4LRnOMu16ZjMFC09ekPabNE4jTU+NovMjy5q/MVSUjp7BNnys9
         pwBfGK4+wg/BcFnVwUJDb1cGyNDaKVhTlM4FrtdPWXG75FlOHTtLkbLMFOtnckaFys16
         StHgxW8RwrVFHB5f0IOyFyPNopiqoDB3a5wdMRE0n6mgKr6zhEwFQ70FeuFvhDornHGI
         DfWw==
X-Gm-Message-State: AOAM531QoEoJLtcUatGvtsJgxnUURlM3S3L7lG98bo+4a1cTKkOYrcgr
        6HVaEXXkRZswQpXl+Y9laHkHb0rTUUrlwAPaV6Y=
X-Google-Smtp-Source: ABdhPJyF22sWenbB2pvEAJGBcUnH8u1Rs+XQwg0fLi19NzMdI8Mufaw/jrnOsvy3fjKr7Tp5bTfRyzgMM8GwMtlF0MI=
X-Received: by 2002:a19:5e5d:: with SMTP id z29mr2266212lfi.32.1598736427910;
 Sat, 29 Aug 2020 14:27:07 -0700 (PDT)
MIME-Version: 1.0
References: <16cee7f2-38d9-13c8-4342-4562be68930b.ref@verizon.net>
 <16cee7f2-38d9-13c8-4342-4562be68930b@verizon.net> <dc91cc7d-02c4-66ee-21b4-bda69be3bbd9@youngman.org.uk>
 <1310d10c-1b83-7031-58e3-0f767b1df71b@gmail.com> <101d4a60-916c-fe30-ae7c-994098fe2ebe@youngman.org.uk>
 <694be035-4317-26fd-5eaf-8fdc20019d9b@gmail.com> <6872a42c-5c27-e38a-33ab-10ec01723961@youngman.org.uk>
 <d0aeb41b-09d4-b756-05ee-f0b3da486532@verizon.net> <20200829100256.57e8d57b@natsu>
 <55a16008-f6ff-a44f-6e7c-e67bac4b02a6@gmail.com>
In-Reply-To: <55a16008-f6ff-a44f-6e7c-e67bac4b02a6@gmail.com>
From:   Roger Heflin <rogerheflin@gmail.com>
Date:   Sat, 29 Aug 2020 16:26:55 -0500
Message-ID: <CAAMCDec9xgnoA0OLVJuCNxS4X5aXE7F771X07_rg0RZH-vmU1g@mail.gmail.com>
Subject: Re: Best way to add caching to a new raid setup.
To:     Ram Ramesh <rramesh2400@gmail.com>
Cc:     Roman Mamedov <rm@romanrm.net>, "R. Ramesh" <rramesh@verizon.net>,
        antlists <antlists@youngman.org.uk>,
        Linux Raid <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-raid-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

It should be worth noting that if you buy 2 exactly the same SSD's at
the same time and use them in a mirror they are very likely to be
wearing about the same.

I am hesitant to go much bigger on disks, especially since the $$/GB
really does not change much as the disks get bigger.

And be careful of adding on a cheap sata controller as a lot of them work badly.

Most of my disks have died from bad blocks causing a section of the
disk to have some errors, or bad blocks on sections causing the array
to pause for 7 seconds.  Make sure to get a disk with SCTERC settable
(timeout when bad blocks happen, otherwise the default timeout is a
60-120seconds, but with it you can set it to no more than 7 seconds).
 In the cases where the entire disk did not just stop and is just
getting bad blocks in places, typically you have time as only a single
section is getting bad blocks, so in this case having sections does
help.    Also note that mdadm with 4 sections like I have will only
run a single rebuild at a time as mdadm understands that the
underlying disks are shared, this makes replacing a disk with 1
section or 4 sections basically work pretty much the same.  It does
the same thing on the weekly scans, it sets all 4 to scan, and it
scans 1 and defers the other scan as disks are shared.

It seems to be a disk completely dying is a lot less often than badblock issues.

On Sat, Aug 29, 2020 at 3:50 PM Ram Ramesh <rramesh2400@gmail.com> wrote:
>
> On 8/29/20 12:02 AM, Roman Mamedov wrote:
> > On Fri, 28 Aug 2020 22:08:22 -0500
> > "R. Ramesh" <rramesh@verizon.net> wrote:
> >
> >> I do not know how SSD caching is implemented. I assumed it will be
> >> somewhat similar to memory cache (L2 vs L3 vs L4 etc). I am hoping that
> >> with SSD caching, reads/writes to disk will be larger in size and
> >> sequential within a file (similar to cache line fill in memory cache
> >> which results in memory bursts that are efficient). I thought that is
> >> what SSD caching will do to disk reads/writes. I assumed, once reads
> >> (ahead) and writes (assuming writeback cache) buffers data sufficiently
> >> in the SSD, all reads/writes will be to SSD with periodic well organized
> >> large transfers to disk. If I am wrong here then I do not see any point
> >> in SSD as a cache. My aim is not to optimize by cache hits, but optimize
> >> by preventing disks from thrashing back and forth seeking after every
> >> block read. I suppose Linux (memory) buffer cache alleviates some of
> >> that. I was hoping SSD will provide next level. If not, I am off in my
> >> understanding of SSD as a disk cache.
> > Just try it, as I said before with LVM it is easy to remove if it doesn't work
> > out. You can always go to the manual copying method or whatnot, but first why
> > not check if the automatic caching solution might be "good enough" for your
> > needs.
> >
> > Yes it usually tries to avoid caching long sequential reads or writes, but
> > there's also quite a bit of other load on the FS, i.e. metadata. I found that
> > browsing directories and especially mounting the filesystem had a great
> > benefit from caching.
> >
> > You are correct that it will try to increase performance via writeback
> > caching, however with LVM that needs to be enabled explicitly:
> > https://www.systutorials.com/docs/linux/man/7-lvmcache/#lbAK
> > And of course a failure of that cache SSD will mean losing some data, even if
> > the main array is RAID. Perhaps should consider a RAID of SSDs for cache in
> > that case then.
> >
> Yes, I have 2x500GB ssds for cache. May be, I should do raid1 on them
> and use as cache volume.
> I thought SSDs are more reliable and even when they begin to die, they
> become readonly before quitting.  Of course, this is all theory, and I
> do not think standards exists on how they behave when reaching EoL.
>
> Ramesh
>
