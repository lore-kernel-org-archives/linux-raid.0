Return-Path: <SRS0=8aTj=CH=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B542C433E6
	for <linux-raid@archiver.kernel.org>; Sat, 29 Aug 2020 00:02:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D2B11207DA
	for <linux-raid@archiver.kernel.org>; Sat, 29 Aug 2020 00:02:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="vTOUKtb6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727024AbgH2ACH (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 28 Aug 2020 20:02:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726775AbgH2ACG (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 28 Aug 2020 20:02:06 -0400
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52325C061264
        for <linux-raid@vger.kernel.org>; Fri, 28 Aug 2020 17:02:06 -0700 (PDT)
Received: by mail-lf1-x131.google.com with SMTP id x77so559749lfa.0
        for <linux-raid@vger.kernel.org>; Fri, 28 Aug 2020 17:02:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LvbawZesHUGi+WFWsBxMBsLmQDNidUfCwcvH35h9Vzw=;
        b=vTOUKtb6sBmR+WO1kRqH22FMEpWtquKQ/PIcEmppD0q99NVAggLWEkrYRmE0xa5blT
         qEfbCwb7rL0iBKFz3l8f3LNwEJDGJPx/+AHTMo0nOhCcjXTR1zKmXy5oFksUE9TEH2qC
         GNvaSWKSFKt8YAIVayldzi0LptzCTzVDMPnEsMn5kmcYkV864CuCZku08dflc4RGKlkJ
         0GqJxnlFG0/CJ4wadJcDMXviguHOBdsv/mfrQUwb1ahCwO0oU6kX039cH4xY7LyvvQu4
         z2y+Q4hTaFtOI8cYPG4Fyl6/HK1hESynul0SIYBs18GQdy6U2F0xi/XPmvn3x5DdaSB0
         KmpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LvbawZesHUGi+WFWsBxMBsLmQDNidUfCwcvH35h9Vzw=;
        b=cK4Hxa4ZdDOom4yAgG4pBCtWlezvMIdZzlOKoBCsgB6PA4qI9FSCkKi2epzBB/Wsdc
         ObHauJYpDL/cfsLfNWAZCWjzQNLschxNoZsDYCqF1g6vo9mJlzKwL+lAoCyNUJCvEgru
         0tHREvfnQyn0atmCKHT66mVGRMuMxKQwnm8l12wluzkyDtghFJazVIV2dbFC45lEULxP
         Bk1yhWPcweH8qYb6H6+DlXLHw8DNuiuz8Smjw8KTXWCsFJko+YfBFDe2kQJcaSOP8Nii
         Vy0Tjx5FWc1AtJfHdIaahuPEAk8i8WyTo9nSrzdt0UGouW4v/GTmDImY3IN3cwYPtvTY
         Ew0Q==
X-Gm-Message-State: AOAM530RG8CfukSlTulLm+wUl5I2w08hhThC4Ku0XuJdnC7Ehgyle4V4
        LbMtyfLLSjSYOpE8Rjo7KPRvwkBAi6TyG+8AYyA=
X-Google-Smtp-Source: ABdhPJyNOZV2a9YS1OKAqUApoDOfzMc+Amvbaiwvpc2jB53uwaiv0syiWhhcsLYdRNMuA4ofrX8VfrTASJ2aSoG5DAs=
X-Received: by 2002:a19:e07:: with SMTP id 7mr437689lfo.6.1598659322298; Fri,
 28 Aug 2020 17:02:02 -0700 (PDT)
MIME-Version: 1.0
References: <16cee7f2-38d9-13c8-4342-4562be68930b.ref@verizon.net>
 <16cee7f2-38d9-13c8-4342-4562be68930b@verizon.net> <dc91cc7d-02c4-66ee-21b4-bda69be3bbd9@youngman.org.uk>
 <1310d10c-1b83-7031-58e3-0f767b1df71b@gmail.com> <101d4a60-916c-fe30-ae7c-994098fe2ebe@youngman.org.uk>
 <694be035-4317-26fd-5eaf-8fdc20019d9b@gmail.com>
In-Reply-To: <694be035-4317-26fd-5eaf-8fdc20019d9b@gmail.com>
From:   Roger Heflin <rogerheflin@gmail.com>
Date:   Fri, 28 Aug 2020 19:01:51 -0500
Message-ID: <CAAMCDecWsihd4oy1ZAvcVb4aPnntrit2PXx-Zn2uM5rQoKPU=g@mail.gmail.com>
Subject: Re: Best way to add caching to a new raid setup.
To:     Ram Ramesh <rramesh2400@gmail.com>
Cc:     antlists <antlists@youngman.org.uk>,
        "R. Ramesh" <rramesh@verizon.net>,
        Linux Raid <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-raid-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Something I would suggest, I have found improves my mythtv experience
is:  Get a big enough SSD to hold 12-18 hours of the recording or
whatever you do daily, and setup the recordings to go to the SSD.    i
defined use the disk with the highest percentage free to be used
first, and since my raid6 is always 90% plus the SSD always gets used.
Then nightly I move the files from the ssd recordings directory onto
the raid6 recordings directory.  This also helps when your disks start
going bad and getting badblocks, the badblocks *WILL* cause mythtv to
stop recording shows at random because of some prior choices the
developers made (sync often, and if you get more than a few seconds
behind stop recording, attempting to save some recordings).

I also put daily security camera data on the ssd and copy it over to
the raid6 device nightly.

Using the ssd for recording much reduces the load on the slower raid6
spinning disks.

You would have to have a large number of people watching at the same
time as the watching is relatively easy load, compared to the writes.

On Fri, Aug 28, 2020 at 5:42 PM Ram Ramesh <rramesh2400@gmail.com> wrote:
>
> On 8/28/20 5:12 PM, antlists wrote:
> > On 28/08/2020 18:25, Ram Ramesh wrote:
> >> I am mainly looking for IOP improvement as I want to use this RAID in
> >> mythtv environment. So multiple threads will be active and I expect
> >> cache to help with random access IOPs.
> >
> > ???
> >
> > Caching will only help in a read-after-write scenario, or a
> > read-several-times scenario.
> >
> > I'm guessing mythtv means it's a film server? Can ALL your films (or
> > at least your favourite "watch again and again" ones) fit in the
> > cache? If you watch a lot of films, chances are you'll read it from
> > disk (no advantage from the cache), and by the time you watch it again
> > it will have been evicted so you'll have to read it again.
> >
> > The other time cache may be useful, is if you're recording one thing
> > and watching another. That way, the writes can stall in cache as you
> > prioritise reading.
> >
> > Think about what is actually happening at the i/o level, and will
> > cache help?
> >
> > Cheers,
> > Wol
>
> Mythtv is a sever client DVR system. I have a client next to each of my
> TVs and one backend with large disk (this will have RAID with cache). At
> any time many clients will be accessing different programs and any
> scheduled recording will also be going on in parallel. So you will see a
> lot of seeks, but still all will be based on limited threads (I only
> have 3 TVs and may be one other PC acting as a client) So lots of IOs,
> mostly sequential, across small number of threads. I think most cache
> algorithms should be able to benefit from random access to blocks in SSD.
>
> Do you see any flaws in my argument?
>
> Regards
> Ramesh
>
