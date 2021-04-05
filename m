Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BA31C433B4
	for <linux-raid@archiver.kernel.org>; Mon,  5 Apr 2021 21:02:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3D36A6139F
	for <linux-raid@archiver.kernel.org>; Mon,  5 Apr 2021 21:02:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241211AbhDEVCm (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 5 Apr 2021 17:02:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237300AbhDEVCl (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 5 Apr 2021 17:02:41 -0400
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44C0DC061756
        for <linux-raid@vger.kernel.org>; Mon,  5 Apr 2021 14:02:34 -0700 (PDT)
Received: by mail-lf1-x12f.google.com with SMTP id v140so1524785lfa.4
        for <linux-raid@vger.kernel.org>; Mon, 05 Apr 2021 14:02:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dHCWAaYdMY+2nJCeYueGDqKcmaYN4wBenrdE/OegoJU=;
        b=ROBEmN6VGZIC4JbZorbTOy0AGPLxEOv476eq7vB18FhGfUgeKuC5R7a8bJpOJY+WL9
         lMWVUPXn0vQNSqbTghZzfcYEcnFhABLjrS1SN9DY3ixVOvtPOdLDmHEpGo90yWbtl7na
         Kvh+dgixfwvYrzkUxKTieuo+hv0Yu77tFK8kP2rap18ewNih0yX7IPa1e2AYnk7HsF+R
         awKzIYsW6aYlNzdSnC2KiW/d5fcEKpQVE50OuxR5gPpGCJwI/9usbdAtx0G9MkaKfIhp
         yin9ElnTpc9jguzj6jDvK0cFunPH+Y+aImmBGaDKv+o4XeTIJrcLCM0GcrtQIhzXyixY
         wDqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dHCWAaYdMY+2nJCeYueGDqKcmaYN4wBenrdE/OegoJU=;
        b=crX5RlSsWLHCmh+p8Fr7wS29T0SzcJmR3hHpczkDJs2UU2WqymikC6ZihbAgNcwdro
         TB5dAEHAmakGA4y4dMdPT1N/QYR3ZnG4OcIpE4OS3kJse5oNrbxCGhEcEdYIAVClOlgP
         ULmM+PLUGdHRMAK2oxurebmkvvKCL+t8G05f7pp2jJh603jiVxfW4lT4i1SzKwoUZV5u
         PO2X2WqmvpRCML437cre/Ztw2lzmO3p4C+1izdI29yQoRbqbjVvcq0CZuL3iW+Bd+MqS
         kLLo4pf61Xw72nUurPRZFQTmUEFsEq/u4k5L8xUFy5X2kUa0ZxleUnB2S1hpbshoH3CD
         I93Q==
X-Gm-Message-State: AOAM532LJysaMRhCdIwa5xV4xyTW3YZWlLt0xy+m2u3Fi2xiXruViptV
        R2iVtLEsMKHX9TbTWiaBhiFsuYZyYCaKOSlgX+NIQa8y
X-Google-Smtp-Source: ABdhPJz0Uz5ajrsYPZBUBKhBHQK1+pxJbGBoZFFQiAMtFGbR8nbgh5+ktTKpOmyFwHSSJ4+nqLIsMkWc3dwTMnD5rCk=
X-Received: by 2002:ac2:4e82:: with SMTP id o2mr18502007lfr.489.1617656552708;
 Mon, 05 Apr 2021 14:02:32 -0700 (PDT)
MIME-Version: 1.0
References: <20210328021210.GA1415@justpickone.org> <20210402004001.GH1711@justpickone.org>
 <62cc89ea-b9cf-d8a3-3d52-499fd84f7cc3@youngman.org.uk> <20210402050554.GF1415@justpickone.org>
 <CAAMCDecNM8X9tdWo-WKpQA3BE=_J=XKc1D75rcQiQN0owZ9kJQ@mail.gmail.com>
 <20210405034659.GG1415@justpickone.org> <CAAMCDecX3nawcYC4hFX+VjQTiHPaZDUb1RcM66=OBFoxhLwY4Q@mail.gmail.com>
 <5f58e78d-8d8c-c66c-7674-79832e22f200@youngman.org.uk>
In-Reply-To: <5f58e78d-8d8c-c66c-7674-79832e22f200@youngman.org.uk>
From:   Roger Heflin <rogerheflin@gmail.com>
Date:   Mon, 5 Apr 2021 16:02:19 -0500
Message-ID: <CAAMCDedUf4viKzfoLYtMR7G=Or4h_zJt3Mm7-FhLbuVHv5QTzw@mail.gmail.com>
Subject: Re: bitmaps on xfs (was "Re: how do i bring this disk back into the fold?")
To:     antlists <antlists@youngman.org.uk>
Cc:     David T-G <davidtg-robot@justpickone.org>,
        Linux RAID list <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

I have read the analysis on data corruption in disks setups.    From
what I can tell they are using incorrect assumptions and models and
the estimates of risk are a fair number of orders of higher that is
actually the case.

Because of that I am not that worried about the risks to my data.
If I lose a few blocks of data it is not the end of the world and
there is a performance impact.  The data I have would be annoying to
lose parts of it, but it is only annoying.

I have been managing large environments for 20+ years with 1000's
petabyte years.    I have seen a total of 3 events where undetected
corruptions happened, and the way they were detected makes it pretty
unlikely there are more than 2x that number of undetected corruptions
total in the environment.

One was a pci controller being bad corrupting reads (confirmed writes
failed at least 100x less).
One was a pci bus set too fast corrupting reads (confirmed writes
failed at least 100x less).

The 3rd was the worst.  It was an enterprise/near enterprise 1st
vendor array where a very small number (5 out of 1000's of ssds) would
reboot/reset unexpectedly when not completely written data in them.
And I believe they did have the drive write caches disabled, but the
way the SSD's firmware worked if it lost power at the wrong time the
data was not yet really written and was lost.  The 5 disks themselves
seem to be broken.   The biggest mistake the vendor made was not
immediately booting off the array any device that randomly "rebooted"
and or reset without being told to.

On Mon, Apr 5, 2021 at 12:29 PM antlists <antlists@youngman.org.uk> wrote:
>
> On 05/04/2021 12:30, Roger Heflin wrote:
> >>    diskfarm:~ # grep /mnt/ssd /etc/fstab
> >>    LABEL=diskfarm-ssd      /mnt/ssd        xfs     defaults        0  0
> >>
> >> will work for my bitmap files target, since all I see is that it must be
> >> an ext2 or ext3 (not ext4? old news?) device.
>
> Bear in mind you're better off using a journal (and bitmaps and journals
> are incompatible).
>
> "not ext4" seems odd to me because - from a kernel point of view - ext's
> 2 and 3 no longer longer exist.
> >>
> > I don't know, I have always done mine internal.   I could see some
> > advantage to have it on a SSD vs internally.  I may have to try that,
> > I am about to do some array reworks to go from all 3tb disks to start
> > using some 6tb disks.   If the file was pre-allocated I would not
> > think it would matter which.    The page is dated 2011 so that would
> > have been old enough that no one tested ext4/xfs.
> >
> Umm... don't use all the space on your 6TB disks. I'm planning to build
> my arrays on dm-integrity, which will make raid 5 a bit more trustworthy.
>
> > I was going to tell you you could just create a LV and format it ext3
> > and use it, but I see it appears you are using direct partitions only.
>
> Ny new system? 4TB disks, with one terabyte raided and lvm on top for
> root partitions (I'll be configuring it multi-boot or VMs...). Then
> three terabytes with dm-integrity at the bottom, then raid, then lvm on
> top for /home and backup snapshots.
>
> Cheers,
> Wol
