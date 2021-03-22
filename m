Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5FB7C433DB
	for <linux-raid@archiver.kernel.org>; Mon, 22 Mar 2021 17:14:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9136461994
	for <linux-raid@archiver.kernel.org>; Mon, 22 Mar 2021 17:14:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232102AbhCVROP (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 22 Mar 2021 13:14:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:43652 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232021AbhCVRNp (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Mon, 22 Mar 2021 13:13:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 556FB601FB
        for <linux-raid@vger.kernel.org>; Mon, 22 Mar 2021 17:13:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616433224;
        bh=SjfKpTKQIcP9IPhgfbR7R2zwUiDElff6jqpd5qt1xaE=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=k0+kcYczYUte6eLJYst0TE3ACYaXAMfkGhjJGS9PeUdKdBeOw+widQTDuhB7I9f2C
         ig+Qb1McBzOaXxOuhNWiTA7vzfAha1uLNKIL8hx9SAFquNqJsd/Lf6YIn85T0FLxud
         ncU+vtkfV2WysmI2jpPx/wgdpMFgRtcJWG6uu2Oz2x5GSLzP5AT/DvzHKQH/B9DO0p
         p2TOmwwyiKt2BU3eSf7JbOFLBRnF1vGLOd7qZTI5SZpHxm0rshIwb1iX+CmdCuKxjz
         mYAxDYSOnlEmiLkAE/nKk2Zl6MMdF7J86+Ls7/1WW/dA3QKes+MAW1etOrdAzsjKN6
         IlThLoFPahJOQ==
Received: by mail-lj1-f173.google.com with SMTP id s17so22044631ljc.5
        for <linux-raid@vger.kernel.org>; Mon, 22 Mar 2021 10:13:44 -0700 (PDT)
X-Gm-Message-State: AOAM531Vrr/r0qiqNkmehznsRPsuoOYAOrv0z4zq95Bs+FCIeIQqou/l
        OCTFDpPs5bGVJN2nZwU0Vxi0d//mWZ3WwQxcgYc=
X-Google-Smtp-Source: ABdhPJyKFTACDEiXDHqnIcuNqZxZeWejvc2QgAl+7I6iycGMTCwT63qIVbHc2Hgx9AgbyNZRuqdPgkl6txa1dZVeRzs=
X-Received: by 2002:a2e:b895:: with SMTP id r21mr351311ljp.506.1616433222691;
 Mon, 22 Mar 2021 10:13:42 -0700 (PDT)
MIME-Version: 1.0
References: <DAEB6C2F-3AE0-4EBE-8775-7C6292F8749A@snapdragon.cc>
 <CAPhsuW4=XoyQV_HNVnFnMWS2PvvU1+Rtbh9SJB-FQTO3haa3ig@mail.gmail.com>
 <27EE5CBC-B1B8-4463-87F5-2AE73F30941B@snapdragon.cc> <C990C60B-FB5A-4709-949B-6D86AF9FA6B1@snapdragon.cc>
In-Reply-To: <C990C60B-FB5A-4709-949B-6D86AF9FA6B1@snapdragon.cc>
From:   Song Liu <song@kernel.org>
Date:   Mon, 22 Mar 2021 10:13:31 -0700
X-Gmail-Original-Message-ID: <CAPhsuW5urYTuOago=5sGiQ_7huQ6S+2rYkQ=n+_TwxQtxC3tWQ@mail.gmail.com>
Message-ID: <CAPhsuW5urYTuOago=5sGiQ_7huQ6S+2rYkQ=n+_TwxQtxC3tWQ@mail.gmail.com>
Subject: Re: [PATCH] md: warn about using another MD array as write journal
To:     Manuel Riel <manu@snapdragon.cc>
Cc:     Linux-RAID <linux-raid@vger.kernel.org>,
        Vojtech Myslivec <vojtech@xmyslivec.cz>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Sat, Mar 20, 2021 at 9:22 PM Manuel Riel <manu@snapdragon.cc> wrote:
>
> My impression is that the write-journal feature isn't fully stable yet, as was already reported in 2019[^1]. Vojtech and me are seeing the same errors as mentioned there.
>
> No matter if the journal is on a block device or another RAID.
>
> 1: https://www.spinics.net/lists/raid/msg62646.html
>
>
> > On Mar 20, 2021, at 9:12 AM, Manuel Riel <manu@snapdragon.cc> wrote:
> >
> > On Mar 20, 2021, at 7:16 AM, Song Liu <song@kernel.org> wrote:
> >>
> >> Sorry for being late on this issue.
> >>
> >> Manuel and Vojtech, are we confident that this issue only happens when we use
> >> another md array as the journal device?
> >>
> >> Thanks,
> >> Song
> >
> > Hi Song,
> >
> > thanks for getting back.
> >
> > Unfortunately it's still happening, even when using a NVMe partition directly. It just took a long 3 weeks to happen. So discard my patch. Here how it went down yesterday:
> >
> > - process md4_raid6 is running with 100% CPU utilization, all I/O to the array is blocked
> > - no disk activity on the physical drives
> > - soft reboot doesn't work, as md4_raid6 blocks, so hard reset is needed
> > - when booting to rescue mode, it tries to assemble the array and shows the same issue of 100% CPU utilization. Also can't reboot.
> > - when manually assembling it *with* the journal drive, it will read a few GB from the journal device and then get stuck at 100% CPU utilization again without any disk activity.
> >
> > Solution in the end was to avoid assembling the array on reboot, then assemble it *without* the existing journal and add an empty journal drive later. This lead to some data loss and a full resync.

Thanks for the information. Quick question, does the kernel have the
following change?
It fixes an issue at recovery time. Since you see the issue in normal
execution, it is probably
something different.

Thanks,
Song

commit c9020e64cf33f2dd5b2a7295f2bfea787279218a
Author: Song Liu <songliubraving@fb.com>
Date:   9 months ago

    md/raid5-cache: clear MD_SB_CHANGE_PENDING before flushing stripes

    In recovery, if we process too much data, raid5-cache may set
    MD_SB_CHANGE_PENDING, which causes spinning in handle_stripe().
    Fix this issue by clearing the bit before flushing data only
    stripes. This issue was initially discussed in [1].

    [1] https://www.spinics.net/lists/raid/msg64409.html

    Signed-off-by: Song Liu <songliubraving@fb.com>
