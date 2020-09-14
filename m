Return-Path: <SRS0=PPQD=CX=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BC18C43461
	for <linux-raid@archiver.kernel.org>; Mon, 14 Sep 2020 14:49:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 188C3207EA
	for <linux-raid@archiver.kernel.org>; Mon, 14 Sep 2020 14:49:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="h8fYpB+L"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726762AbgINOtR (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 14 Sep 2020 10:49:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726865AbgINOsv (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 14 Sep 2020 10:48:51 -0400
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 330D9C06174A
        for <linux-raid@vger.kernel.org>; Mon, 14 Sep 2020 07:48:51 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id x77so13759805lfa.0
        for <linux-raid@vger.kernel.org>; Mon, 14 Sep 2020 07:48:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pHpkplQIkgbga1oxfqjPLJp4TrqK643UVsxq0c3h9zg=;
        b=h8fYpB+LyOK/XXKiuROk0lBvlKoZriX9DQjhM1JoVPRKDVE1jBJKO7nwzPMk1MmkWQ
         S1dSOieiFUFZcexJw/ncT2DvfRN9gDfGDYlZHQP/a/WVR64Zz/vT+0Il8gLTyjbdilD9
         aPZnhR0nRwQYjqWF4fih0jeTlDv5W9BNUkDjVcA6z1XdJxVt8yUxcC79vNOi/LI6v3Kb
         DrwtOt2i0BxX3dKhIFRjS47Q7O4TgO8PsxsQpqn4uKLKQP+zeeVLgEMn7gQ5qMhRbKBz
         Qgb7n1fyeGYZDGbaaRt/Prx+icXXSnpyo08MWIAaYBF+48iIwX/ctrZpeLUwnatTMyeT
         JqeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pHpkplQIkgbga1oxfqjPLJp4TrqK643UVsxq0c3h9zg=;
        b=InaIA140x6A881bO1b4/dAfwxFbRmiavXo8u2DGZwX/xAD5sVtxXZUXC7yoHMzOXbV
         f2UHiMXlZ6tXcldR1S1a5/9a5I9B09T+bCC+izjUnCbyMRcSqBjCMZ8zW8WfItHpKvJU
         posGkM+5g0DvZBKl+cvzK0rAx5piY1OiXcNqjGegHdr5bfS/sou4pjpZRVMh/9tI1TLn
         fxaMfNQW/1927hG+SP2iENYnFZ+HM3P/LpcNWBSWxe6AxgNdc3xg9I/V040eNMsIdAuL
         NlLt6b9dhiCQDG1ZTYpaP/o1g+SqehKqC9G9JO88dhxwhEKnxvpRk7JxwxJvnTJTXrlU
         4OBw==
X-Gm-Message-State: AOAM530nLIS1uiX8+babl0ZauONd4R3mS+z0K9YmWzqAOdM0nwXQ4n8d
        9ewYLeqyPgEBucDRZGer6zX/FyQ/sn47VF3yJDA=
X-Google-Smtp-Source: ABdhPJztu4eV/iRU9VHqQmfzruI3gn+tDg9bMIIfpBULOKpSxpmVyVAbnx0eL/7oShT/C8VKMspHH2Sx/owtNBA5SIc=
X-Received: by 2002:a19:c6c8:: with SMTP id w191mr4161645lff.348.1600094925283;
 Mon, 14 Sep 2020 07:48:45 -0700 (PDT)
MIME-Version: 1.0
References: <16cee7f2-38d9-13c8-4342-4562be68930b.ref@verizon.net>
 <16cee7f2-38d9-13c8-4342-4562be68930b@verizon.net> <dc91cc7d-02c4-66ee-21b4-bda69be3bbd9@youngman.org.uk>
 <1310d10c-1b83-7031-58e3-0f767b1df71b@gmail.com> <101d4a60-916c-fe30-ae7c-994098fe2ebe@youngman.org.uk>
 <694be035-4317-26fd-5eaf-8fdc20019d9b@gmail.com> <CAAMCDecWsihd4oy1ZAvcVb4aPnntrit2PXx-Zn2uM5rQoKPU=g@mail.gmail.com>
 <d4d38059-eaaa-a577-963a-c348434c260e@verizon.net> <CACJz6QvRqq+WLmbOYR=YECNwHzpedUjJEAcoaHseEzEd2Bq8nQ@mail.gmail.com>
 <79c15e0e-5f34-2b1a-282c-8bb36f2e3e81@gmail.com> <87v9ggzivk.fsf@esperi.org.uk>
 <74d07a6c-799b-2ebb-cc7a-0d3ccd19150c@gmail.com>
In-Reply-To: <74d07a6c-799b-2ebb-cc7a-0d3ccd19150c@gmail.com>
From:   Roger Heflin <rogerheflin@gmail.com>
Date:   Mon, 14 Sep 2020 09:48:34 -0500
Message-ID: <CAAMCDecjgMvXPPwhWZKi5VmJEPeLzFkUuQ2M_EwxnDxd=ntSZA@mail.gmail.com>
Subject: Re: Best way to add caching to a new raid setup.
To:     Ram Ramesh <rramesh2400@gmail.com>
Cc:     Nix <nix@esperi.org.uk>, Drew <drew.kay@gmail.com>,
        antlists <antlists@youngman.org.uk>,
        Linux Raid <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-raid-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

It should be noted that mythtv is a badly behaved IO application, it
does a lot of sync calls that effectively for the most part makes
linux's write cache small.

That code was apparently done on the idea that the syncs would take
too long when too many recordings were being done and a few would
timeout and then kill a few of them so that at least some recordings
will work.  A number of people believe its usage of sync is badly
designed (me included) but last a saw the dev's were arguing for it.
It is a decent assumption if recordings we being done on a single
spinning disk, but it is not so good when there are multiple spindles
under it and the disks would be able to cache up.  I had recordings
being killed when a single spinning disk in the array with the SCTERC
set to 7seconds happened, and that is part of the reason why I went to
SSD.  With old disks the disk block replacements is going to happen
often enough that with the sync/kill crap recordings aren't reliable.

On Mon, Sep 14, 2020 at 9:37 AM Ram Ramesh <rramesh2400@gmail.com> wrote:
>
> On 9/14/20 6:40 AM, Nix wrote:
> > On 1 Sep 2020, Ram Ramesh uttered the following:
> >
> >> After thinking through this, I really like the idea of simply
> >> recording programs to SSD and move one file at a time based on some
> >> aging algorithms of my own. I will move files back and forth as needed
> >> during overnight hours creating my own caching effect.
> > I don't really see the benefit here for a mythtv installation in
> > particular. I/O patterns for large media are extremely non-seeky: even
> > with multiple live recordings at once, an HDD would easily be able to
> > keep up since it'd only have to seek a few times per 30s period given
> > the size of most plausible write caches.
> >
> > In general, doing the hierarchical storage thing is useful if you have
> > stuff you will almost never access that you can keep on slower media
> > (or, in this case, stuff whose access patterns are non-seeky that you
> > can keep on media with a high seek time). But in this case, that would
> > be 'all of it'. Even if it weren't, by-hand copying won't deal with the
> > thing you really need to keep on fast-seek media: metadata. You can't
> > build your own filesystem with metadata on SSD and data on non-SSD this
> > way! But both LVM caching and bcache do exactly that.
> Agreed, all I need is a file level LRU caching effect. All recently
> accessed/created files in SSD and the ones untouched for a while in
> spinning disks. I was trying to get this done using a block level
> caching methods which is too complicated for the purpose.
>
> My aim is not to improve the performance, instead improve on power. I
> want my raid disks to be mostly sitting idle holding files and spin up
> and serve only when called for. Most of the time, I am
> watching/recording recent shows/programs or popular movies and typically
> that is about 200-400GB of storage. With ultraviolet, prime, netflix and
> disney, movies are more often sourced from online content and TV shows
> get deleted after watching and new ones gets added in that space. So,
> typical usage seem ideal for popular SSD size (with a large backup store
> in spinning disk), I think. This means my spinning disks are going to
> wake up once a day or two at most. More often I expect it to be once a
> week or have periods of high activity and die down to nothing for a
> while.  Instead, currently they are running 24x7 which does not make sense.
>
> Regards
> Ramesh
>
