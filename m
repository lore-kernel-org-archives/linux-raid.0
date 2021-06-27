Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 153A1C49EA6
	for <linux-raid@archiver.kernel.org>; Sun, 27 Jun 2021 03:13:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DD7FB61438
	for <linux-raid@archiver.kernel.org>; Sun, 27 Jun 2021 03:13:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230388AbhF0DP7 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 26 Jun 2021 23:15:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230214AbhF0DP7 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 26 Jun 2021 23:15:59 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8EEBC061574
        for <linux-raid@vger.kernel.org>; Sat, 26 Jun 2021 20:13:34 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id j11-20020a05600c1c0bb02901e23d4c0977so10509984wms.0
        for <linux-raid@vger.kernel.org>; Sat, 26 Jun 2021 20:13:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorremedies-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6QD87azr6hI4KW+iNRICm7JVXult4E4niwwuQi68CJE=;
        b=eILCz3N0ADdVApWkrEuoxxVs22W6ugeciLPbuKl0TDNJMx3TGesFrW5IsylfyLEfce
         6DwA5KHJ+P+S6gHTEvl4N62BdY50m785v5sz1bymzEugG18ZJxYYDRTimSTlG1ogGyTR
         ICNlbwjrG4pQtqt0IGUqWzi0ao0GBD60KhkjUda4tM8Fb+DR7sNTyFdxUSN4e9MoPThz
         16I/G8p+5RPvBXIyijS8/xvBde14dv+TtJPV4a4zI5IXqH75Ph41SNisOnbkVzKKA7u7
         SEVNFPlZkMmUzQ7ayU/0XvbDyGGhHygSItpVZLlxj1Ns3i2EE2VODOR466uu6+9HBAsl
         nfbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6QD87azr6hI4KW+iNRICm7JVXult4E4niwwuQi68CJE=;
        b=HEVmS6MXpqIX7WJWErJwuM3EXPVVIlQnWgCR48bYM0wnACBvTvwcqvSYfNHtPrBnBV
         wsCQ3mswN0Y/3h2wV+s3eiY+sip1xbm9dH+FJ9edVuv71l189uVNufI9PmLGwZwKZ6p6
         EC5ffFL6EB9ToC2VmOsVZWNNAb5oZSuUZz9zt7a7AjK3tqSuhZ+jKyVRPSq0rrPJRp6S
         jPM9txevyNNfNMd5zYM2T2BfTkOCluPuVZSR/4atW9tJe031ZoxwALHz9BzjaSeY1SBD
         gQyiX38lsFXs5R2vr1/LPy9DobMuQbTHX02zI8IrYdQ8jT2VATco/mg3nh7Z+kokbs4o
         sjtg==
X-Gm-Message-State: AOAM532mC7tqPnvSqFGXC0pO5mVWC4J/AQrhCjypptoiSw9gp5AxtEEt
        HQJYevpNgmprCbYLC3qvH3mwB5eeyGh7jJlux7iBhNCtALxkjhamyME=
X-Google-Smtp-Source: ABdhPJxStiVJy12zAeyXAUX39dfzfG9DnIvkiGaJ/U0YsHWOkB4sSdn8KkI23qnsj8RJHEbZMYwclZMhen71gt5PcWw=
X-Received: by 2002:a05:600c:3589:: with SMTP id p9mr9765050wmq.182.1624763612549;
 Sat, 26 Jun 2021 20:13:32 -0700 (PDT)
MIME-Version: 1.0
References: <CACsGCyRLJ7Lr5rpxUDaNRzZr=s0LjK8wwOENC2RXmNsHvz4HaA@mail.gmail.com>
 <20210625220845.57wcwz4sppavywf6@bitfolk.com> <afbb6970-72ac-6900-8bf9-ba84bc6f3ffb@turmel.org>
In-Reply-To: <afbb6970-72ac-6900-8bf9-ba84bc6f3ffb@turmel.org>
From:   Chris Murphy <lists@colorremedies.com>
Date:   Sat, 26 Jun 2021 21:13:16 -0600
Message-ID: <CAJCQCtQ0i2cOUnWZ-SAZMcf3m4jsmJz7wUpUzU+Ge3xL=dT+9A@mail.gmail.com>
Subject: Re: Redundant EFI Systemp Partitions (Was Re: How does one enable
 SCTERC on an NVMe drive (and other install questions))
To:     Phil Turmel <philip@turmel.org>
Cc:     Linux-RAID <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Sat, Jun 26, 2021 at 8:36 AM Phil Turmel <philip@turmel.org> wrote:

> > You could lie to the firmware and tell it that each MD member device
> > is an ESP, but it isn't. This will probably work as long as you use
> > the correct metadata format (so the MD metadata is at the end and
> > the firmware is fooled that the member device is just a normal
> > partition). BUT it is in theory possible for the firmware to write
> > to the ESP and that would cause a broken array when you boot, which
> > you'd then recover by randomly choosing one of the member devices as
> > the "correct" one.
>
> Pretty low risk, I think, but yes.  If you construct the raid with what
> the EFI system thinks as the "first" bootable ESP as member role 0,
> mdadm will sync correctly.  Fragile, but generally works.

I think it's unreliable. GRUB can write to the ESP when grubenv is on
it. And sd-boot likewise can write to the ESP as part of
https://systemd.io/AUTOMATIC_BOOT_ASSESSMENT/

And the firmware itself can write to the ESP for any reason but most
commonly when cleaning up after firmware updates. Any of these events
would write to just one of the members, and involve file system
writes. So now what happens when they're assembled by mdadm as a raid,
and the two member devices have the same event count, and yet now
completely different file system states? I think it's a train wreck.



-- 
Chris Murphy
