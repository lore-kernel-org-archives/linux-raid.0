Return-Path: <SRS0=8aTj=CH=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09925C433E6
	for <linux-raid@archiver.kernel.org>; Sat, 29 Aug 2020 22:36:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CE352208CA
	for <linux-raid@archiver.kernel.org>; Sat, 29 Aug 2020 22:36:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CaKUEySH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728053AbgH2Wgt (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 29 Aug 2020 18:36:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727987AbgH2Wgq (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 29 Aug 2020 18:36:46 -0400
Received: from mail-qk1-x72c.google.com (mail-qk1-x72c.google.com [IPv6:2607:f8b0:4864:20::72c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2150EC061573
        for <linux-raid@vger.kernel.org>; Sat, 29 Aug 2020 15:36:46 -0700 (PDT)
Received: by mail-qk1-x72c.google.com with SMTP id b14so3054087qkn.4
        for <linux-raid@vger.kernel.org>; Sat, 29 Aug 2020 15:36:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=l0KI774HR389XRBbuQTXS91pjh6ki8SjSSBbRVuPM0g=;
        b=CaKUEySHFzJyiUABOZM0Z//gAIAvRmOqfXwv2Op2WnrtoTMlDwL8YUBttFuAka/J+W
         9uGrCfgKt2qCGhTcb9NQ4l59bBHufrMnuAdCW9j1VCrI1Y+RqcMSNxbg5JuCJNL5wfyp
         OS11H+hh01X0kEY0xBvXUbsoaYV+p6z6GX2cLyWlycrFdMsupsNvYXY+7nTHTGyCI8np
         58n3wIWGQIFnNLUPxdYYj9g3QvT7eCgxfcROZvlnXTlzqnP2RD62pnUfHnBPfKXJm07H
         bvbCvF6nhiOGEeJR0d6aUTNOWwtFDeMCvYx7r7RoH9GCjCisbwDb+GgDv0MvlCr5ikVF
         1CHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=l0KI774HR389XRBbuQTXS91pjh6ki8SjSSBbRVuPM0g=;
        b=QKefJUXXMsNpgQClX6sf4fHg5gCCiiXA1FFVwEgbLoKuMY0GO/JCzlB0cio+KOZId1
         G1YzHoZ+7nge2eUv9QxEBEsX2rKCOsmG8cO1ZjjN4N93RoG/BXh/qKa7HitZiK5lzoMq
         0TQYoI5wt9l1xF1BH3VUv/Y6KDWf0qWZX2vkRuL/dwnjWZLlNbncDNY8mqe6ARiBbFYg
         XA7CYJI9bHxsl7nltxU4Zmueq2U0bZnZ+kXOagl+awtxf7xVXFQSvl4ZMxO/1PyKp7DM
         XCDjxlmpMUeGuKamaHHzkIeRA8pUgB+IrcUhIA5FZy86pttlojEH9EbM53GsajR9Lj5P
         xZQw==
X-Gm-Message-State: AOAM530Abwdvp2NkFrJ0IVK52HwayfrJjp0xgD5BRaX4oAvwsAAoHumZ
        +iLzODdteQOpOI3Ue9DBMAStqSgsW31Eoeouvxw=
X-Google-Smtp-Source: ABdhPJyPEh5H+tt0VGPQp9Cic139a4ZkurBO1QvFyUrkp/Fa6ALcLB/WMlMzabDb+LfaK6snTEwcUoZNp7u23obIYJ0=
X-Received: by 2002:a37:aacb:: with SMTP id t194mr4750755qke.453.1598740604965;
 Sat, 29 Aug 2020 15:36:44 -0700 (PDT)
MIME-Version: 1.0
References: <16cee7f2-38d9-13c8-4342-4562be68930b.ref@verizon.net>
 <16cee7f2-38d9-13c8-4342-4562be68930b@verizon.net> <dc91cc7d-02c4-66ee-21b4-bda69be3bbd9@youngman.org.uk>
 <1310d10c-1b83-7031-58e3-0f767b1df71b@gmail.com> <101d4a60-916c-fe30-ae7c-994098fe2ebe@youngman.org.uk>
 <694be035-4317-26fd-5eaf-8fdc20019d9b@gmail.com> <CAAMCDecWsihd4oy1ZAvcVb4aPnntrit2PXx-Zn2uM5rQoKPU=g@mail.gmail.com>
 <d4d38059-eaaa-a577-963a-c348434c260e@verizon.net>
In-Reply-To: <d4d38059-eaaa-a577-963a-c348434c260e@verizon.net>
From:   Drew <drew.kay@gmail.com>
Date:   Sat, 29 Aug 2020 16:36:32 -0600
Message-ID: <CACJz6QvRqq+WLmbOYR=YECNwHzpedUjJEAcoaHseEzEd2Bq8nQ@mail.gmail.com>
Subject: Re: Best way to add caching to a new raid setup.
To:     "R. Ramesh" <rramesh@verizon.net>
Cc:     Ram Ramesh <rramesh2400@gmail.com>,
        antlists <antlists@youngman.org.uk>,
        Linux Raid <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-raid-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

I know what you and Wols are talking about and I think it's actually
two separate things. Wol's is referring to traditional read caching
where it only benefits if you are reading the same thing over and over
again, cache hits. For streaming it won't help as you'll never hit the
cache.

What you are talking about is a write cache, something I have seen
implemented before. Basically the idea is for writes to hit the SSD's
first, the SSD acting as a cache or buffer between the filesystem and
the slower RAID array. To the end process they're just writing to a
disk, they don't see the SSD buffer/cache. QNAP implements this in
their NAS chassis, just not sure what the exact implementation is in
their case.

On Fri, Aug 28, 2020 at 9:14 PM R. Ramesh <rramesh@verizon.net> wrote:
>
> On 8/28/20 7:01 PM, Roger Heflin wrote:
> > Something I would suggest, I have found improves my mythtv experience
> > is:  Get a big enough SSD to hold 12-18 hours of the recording or
> > whatever you do daily, and setup the recordings to go to the SSD.    i
> > defined use the disk with the highest percentage free to be used
> > first, and since my raid6 is always 90% plus the SSD always gets used.
> > Then nightly I move the files from the ssd recordings directory onto
> > the raid6 recordings directory.  This also helps when your disks start
> > going bad and getting badblocks, the badblocks *WILL* cause mythtv to
> > stop recording shows at random because of some prior choices the
> > developers made (sync often, and if you get more than a few seconds
> > behind stop recording, attempting to save some recordings).
> >
> > I also put daily security camera data on the ssd and copy it over to
> > the raid6 device nightly.
> >
> > Using the ssd for recording much reduces the load on the slower raid6
> > spinning disks.
> >
> > You would have to have a large number of people watching at the same
> > time as the watching is relatively easy load, compared to the writes.
> >
> > On Fri, Aug 28, 2020 at 5:42 PM Ram Ramesh <rramesh2400@gmail.com> wrote:
> >> On 8/28/20 5:12 PM, antlists wrote:
> >>> On 28/08/2020 18:25, Ram Ramesh wrote:
> >>>> I am mainly looking for IOP improvement as I want to use this RAID in
> >>>> mythtv environment. So multiple threads will be active and I expect
> >>>> cache to help with random access IOPs.
> >>> ???
> >>>
> >>> Caching will only help in a read-after-write scenario, or a
> >>> read-several-times scenario.
> >>>
> >>> I'm guessing mythtv means it's a film server? Can ALL your films (or
> >>> at least your favourite "watch again and again" ones) fit in the
> >>> cache? If you watch a lot of films, chances are you'll read it from
> >>> disk (no advantage from the cache), and by the time you watch it again
> >>> it will have been evicted so you'll have to read it again.
> >>>
> >>> The other time cache may be useful, is if you're recording one thing
> >>> and watching another. That way, the writes can stall in cache as you
> >>> prioritise reading.
> >>>
> >>> Think about what is actually happening at the i/o level, and will
> >>> cache help?
> >>>
> >>> Cheers,
> >>> Wol
> >> Mythtv is a sever client DVR system. I have a client next to each of my
> >> TVs and one backend with large disk (this will have RAID with cache). At
> >> any time many clients will be accessing different programs and any
> >> scheduled recording will also be going on in parallel. So you will see a
> >> lot of seeks, but still all will be based on limited threads (I only
> >> have 3 TVs and may be one other PC acting as a client) So lots of IOs,
> >> mostly sequential, across small number of threads. I think most cache
> >> algorithms should be able to benefit from random access to blocks in SSD.
> >>
> >> Do you see any flaws in my argument?
> >>
> >> Regards
> >> Ramesh
> >>
> I was hoping SSD caching would do what you are suggesting without daily
> copying. Based on Wol's comments, it does not. May be I misunderstood
> how SSD caching works.  I will try it any way and see what happens. If
> it does not do what I want, I will remove caching and go straight to disks.
>
> Ramesh



-- 
Drew

"Nothing in life is to be feared. It is only to be understood."
--Marie Curie

"This started out as a hobby and spun horribly out of control."
-Unknown
