Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89BCCC433EF
	for <linux-raid@archiver.kernel.org>; Tue,  4 Jan 2022 16:42:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235461AbiADQmp (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 4 Jan 2022 11:42:45 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:39458 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233941AbiADQmp (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 4 Jan 2022 11:42:45 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 131946152C
        for <linux-raid@vger.kernel.org>; Tue,  4 Jan 2022 16:42:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76FA8C36AEF
        for <linux-raid@vger.kernel.org>; Tue,  4 Jan 2022 16:42:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641314564;
        bh=GS6Fbg4pa7mi1LDshi0bN5DHuoB90xJH/Gg9xDCrURY=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=aAZVyHZXPp25ERdHQjwK31jOWqhM6IovyS2KJuMLcvPpnzyvf4Rl7W6QDQW3a3wVg
         Sixi5gwTLdw/0Lq2nCAgf1dMnaDfj1MoztlRdLCWCA2FlDw2JrfRfF7H3sPb8Uzs63
         PtUUgooYND0Iz1aAAIR/gRgjo8+eNXIC9AQLISTv1aYEEoYzxSvc3SFfILfpZpy8yR
         cDrZRalXMaXVSRbKswJKvgqZkgABGqlLFqmhs1lBZNZIDHTXwnSr/Wyu4e4al45ykt
         mEI8VsrHY9YHVlESzrRr4D41WEBk0XIGBFKPIcPcAP9SLvd3ozVP/Y6LqlOxMLdTdd
         WbgWzuTTHX+/g==
Received: by mail-yb1-f181.google.com with SMTP id o185so82600880ybo.12
        for <linux-raid@vger.kernel.org>; Tue, 04 Jan 2022 08:42:44 -0800 (PST)
X-Gm-Message-State: AOAM532anjlJJIyWvsdhfF455uxa1HOGV9wyCsTY+nyPmrOshxu+iCxb
        HIvqgydjpdSSPYccnpDuqQFkmtjPDYB8w+R318I=
X-Google-Smtp-Source: ABdhPJwaRuEQW7rcXEhxHwCpEAkzrOJ+u6iYMZeSu8O/uv+eMvFTPiAnJ6iyfBCJz5MaT+P6KYbtTRFT8qUbsTWFivo=
X-Received: by 2002:a5b:c01:: with SMTP id f1mr65535430ybq.47.1641314563624;
 Tue, 04 Jan 2022 08:42:43 -0800 (PST)
MIME-Version: 1.0
References: <20211217092955.24010-1-mariusz.tkaczyk@linux.intel.com>
 <CAPhsuW4LGpGKOSLLCH2_2m1f_OHCdbyCNStjXswEOL7A2hp0Lw@mail.gmail.com> <20220103161204.00003025@linux.intel.com>
In-Reply-To: <20220103161204.00003025@linux.intel.com>
From:   Song Liu <song@kernel.org>
Date:   Tue, 4 Jan 2022 08:42:30 -0800
X-Gmail-Original-Message-ID: <CAPhsuW5PabOGtqSeqfyqCR+Cw6hn_R_xu1h=PDo=JEnFTbuj6A@mail.gmail.com>
Message-ID: <CAPhsuW5PabOGtqSeqfyqCR+Cw6hn_R_xu1h=PDo=JEnFTbuj6A@mail.gmail.com>
Subject: Re: [PATCH] md: drop queue limitation for RAID1 and RAID10
To:     Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Cc:     linux-raid <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Mon, Jan 3, 2022 at 7:33 AM Mariusz Tkaczyk
<mariusz.tkaczyk@linux.intel.com> wrote:
>
> On Sat, 1 Jan 2022 16:30:07 -0800
> Song Liu <song@kernel.org> wrote:
>
> > On Fri, Dec 17, 2021 at 1:30 AM Mariusz Tkaczyk
> > <mariusz.tkaczyk@linux.intel.com> wrote:
> > >
> > > As suggested by Neil Brown[1], this limitation seems to be
> > > deprecated.
> > >
> > > With plugging in use, writes are processed behind the raid thread
> > > and conf->pending_count is not increased. This limitation occurs
> > > only if caller doesn't use plugs.
> > >
> > > It can be avoided and often it is (with plugging). There are no
> > > reports that queue is growing to enormous size so remove queue
> > > limitation for non-plugged IOs too.
> > >
> > > [1]
> > > https://lore.kernel.org/linux-raid/162496301481.7211.18031090130574610495@noble.neil.brown.name
> > >
> > > Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
> >
> > I applied this patch to md-next, cecause it helps simplify Vishal's
> > patches for REQ_NOWAIT. However, I think this change is not complete,
> > as we can now remove pending_count from r1conf and r10conf. Please
> > send patch on top of md-next to clean up pending_count.
> >
> Should I also remove pending_cnt from raid1_plug_cb and raid10_plug_cb?

Yeah, I think we should also remove pending_cnt.

Thanks,
Song
