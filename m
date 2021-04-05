Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 416D9C43460
	for <linux-raid@archiver.kernel.org>; Mon,  5 Apr 2021 11:30:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1DFE161396
	for <linux-raid@archiver.kernel.org>; Mon,  5 Apr 2021 11:30:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234736AbhDELax (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 5 Apr 2021 07:30:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230032AbhDELaw (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 5 Apr 2021 07:30:52 -0400
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B829EC061756
        for <linux-raid@vger.kernel.org>; Mon,  5 Apr 2021 04:30:45 -0700 (PDT)
Received: by mail-lf1-x135.google.com with SMTP id w28so16905182lfn.2
        for <linux-raid@vger.kernel.org>; Mon, 05 Apr 2021 04:30:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=h+xy/pq6CFIy6Q7xr2S7J5J/vfPKxJ5XwS41MZxFt4E=;
        b=i/spc+1XVHQxQNtmh1+vxxI3cqXF1E9Zk9Mve94aUCgGpbDfROeRgEBAmTDmfrg5Ea
         M+dVOQIJ0kQivHSbzTJWv326puLGUi4NfOqmVWbZ79Zke+1pVDt7xS4mbs2GnHyY3ayY
         TpBQdNJW2YGpKaIJf1g+s5NYC7UI/pUasbRTohDcIsg1iW+nEA06eEkMpV/ky1gshXl5
         RBpeXb3ImkxGE/GF7LejjQ5BQGAwrQqQQM7vHDHRi/h1n2GW8YoJPX1G4FpzSiVBNbNX
         V8eEnHfZT/X2hw82UiKoST0TJhbE4WrmMGeaFZRG76NeQAEqpEwmmq2zgJF5fNbFEs1u
         fHGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=h+xy/pq6CFIy6Q7xr2S7J5J/vfPKxJ5XwS41MZxFt4E=;
        b=LU+1XlwgsWwNdeLhm7QxbZ29PaI1gd0YCo9A0bR4GsxWEbd8mY0+RjhGyDAnsDqmgP
         cE9MfYryq4qbVh4ps96bQihjdOFl5T7/bsErsNeIDx2kj6oNrGmlzvfo7qbtnVAF4H2J
         jmClunIxpsnjtwsGtQHe9KZCQghShbDHlExeE2JV3etKxwW3hRnFE6prrifiuURbIdUT
         KfkN/YtroUiYqYibppO5McFb1qcaooO60gDN1wq3YV1CLKYIEWdH6SEH2Km7Rg3nCau9
         7PnrxL8mmblBotI9dSrunzlLPDompjdpBJBl/pHY03kE/RaKL0DYAIo8SheysHJGR0iX
         NaBA==
X-Gm-Message-State: AOAM531XqyCieBrE3GmAjuBWQHJ92ChLetXvVcAskiebQh4BTXJm76vs
        XnCqWgmLooMwsoxcnOCng1VRBbEw2XElEzVse8qrXblt3zw=
X-Google-Smtp-Source: ABdhPJwFH/L9fzrp1vM7qgunLE6ZjmQSJNfc8Be4fEarECXkSZ7YQlgVRilHMPoWlCAEFtqu5WA7XL3cjYVJEiqmlyE=
X-Received: by 2002:ac2:4e82:: with SMTP id o2mr17162158lfr.489.1617622243964;
 Mon, 05 Apr 2021 04:30:43 -0700 (PDT)
MIME-Version: 1.0
References: <20210328021210.GA1415@justpickone.org> <20210402004001.GH1711@justpickone.org>
 <62cc89ea-b9cf-d8a3-3d52-499fd84f7cc3@youngman.org.uk> <20210402050554.GF1415@justpickone.org>
 <CAAMCDecNM8X9tdWo-WKpQA3BE=_J=XKc1D75rcQiQN0owZ9kJQ@mail.gmail.com> <20210405034659.GG1415@justpickone.org>
In-Reply-To: <20210405034659.GG1415@justpickone.org>
From:   Roger Heflin <rogerheflin@gmail.com>
Date:   Mon, 5 Apr 2021 06:30:32 -0500
Message-ID: <CAAMCDecX3nawcYC4hFX+VjQTiHPaZDUb1RcM66=OBFoxhLwY4Q@mail.gmail.com>
Subject: Re: bitmaps on xfs (was "Re: how do i bring this disk back into the fold?")
To:     David T-G <davidtg-robot@justpickone.org>
Cc:     Linux RAID list <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Sun, Apr 4, 2021 at 10:47 PM David T-G <davidtg-robot@justpickone.org> wrote:
>
> Roger, et al --
>
> ...and then Roger Heflin said...
> %
> % The re-add will only work if the array has bitmaps.  For quick disk
>
> Ahhhhh...  Good point.
>
> It didn't really take 9 hours; a few minutes later it was up to 60+
> hours, and then it dropped to a couple of hours and was done the next
> time I looked.  I also forced the other array using just the last two
> drives and saw everything happy, so I then added the "first" drive and
> now it's all happy as well.  Woo hoo.
>
>
> % hiccups the re-add is nice because instead of 9 hours, often it
> % finishes in only a few minutes assuming the disk has not been out of
> % the array for long.
>
> I love the idea.  I've been reading up, and in addition to questions of
> what size bitmap I need for my sizes
>
>   diskfarm:~ # df -kh /mnt/4Traid5md/ /mnt/750Graid5md/
>   Filesystem      Size  Used Avail Use% Mounted on
>   /dev/md0p1       11T   11T  309G  98% /mnt/4Traid5md
>   /dev/md127p1    1.4T  1.4T   14G 100% /mnt/750Graid5md
>
> and how to tell it (or *if* I tell it; that still isn't clear) there's
> also the question of whether or not xfs

Easy enough to tell if it is working:
md14 : active raid6 sdh4[11] sdg4[6] sdf4[10] sdd4[5] sdc4[9] sdb4[7] sde4[1]
      3612623360 blocks super 1.2 level 6, 512k chunk, algorithm 2
[7/7] [UUUUUUU]
      bitmap: 1/6 pages [4KB], 65536KB chunk

I also hack my disks into several partitions such that I have 4 raid6
arrays.   This helps because the rebuild time on the entire disk is
days, and it makes me feel better when expanding the arrays as it
makes the chunks smaller.    The biggest help is when I start getting
bad blocks on one of the disks typically it is only 1 of the 4
arrays/disk sections are having bad blocks.  I also made sure that
md*4 always has partition sd*4 so to reduce the thinking about what
was where.

>
>   diskfarm:~ # grep /mnt/ssd /etc/fstab
>   LABEL=diskfarm-ssd      /mnt/ssd        xfs     defaults        0  0
>
> will work for my bitmap files target, since all I see is that it must be
> an ext2 or ext3 (not ext4? old news?) device.
>
I don't know, I have always done mine internal.   I could see some
advantage to have it on a SSD vs internally.  I may have to try that,
I am about to do some array reworks to go from all 3tb disks to start
using some 6tb disks.   If the file was pre-allocated I would not
think it would matter which.    The page is dated 2011 so that would
have been old enough that no one tested ext4/xfs.

I was going to tell you you could just create a LV and format it ext3
and use it, but I see it appears you are using direct partitions only.
