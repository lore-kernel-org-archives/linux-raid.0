Return-Path: <SRS0=1IH2=B7=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 812C6C433DF
	for <linux-raid@archiver.kernel.org>; Fri, 21 Aug 2020 15:42:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 575EF2063A
	for <linux-raid@archiver.kernel.org>; Fri, 21 Aug 2020 15:42:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1598024540;
	bh=v1QhNSU057uBrlS2poETivDHORZi0SeqP/Cc3duKE+o=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=IKO/Xtz7sLYKci5MI/jqC32dpHEWlEm+qaJ+24d5JFPoNyRyzAR+3GtdtNKr4rRG/
	 YVzFdxT2lOn+OjCpgdqOVRCc/tOHXirB/smSlgTVhXVBg+z8FeSMWh/s9mgU7GfLT2
	 eLX8rwdvQDwc4wrk5xYyy5JDkHOmhuO4KRf85Fjg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728169AbgHUPmP (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 21 Aug 2020 11:42:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:47646 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725828AbgHUPmK (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Fri, 21 Aug 2020 11:42:10 -0400
Received: from mail-lj1-f175.google.com (mail-lj1-f175.google.com [209.85.208.175])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D8B302063A
        for <linux-raid@vger.kernel.org>; Fri, 21 Aug 2020 15:42:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598024525;
        bh=v1QhNSU057uBrlS2poETivDHORZi0SeqP/Cc3duKE+o=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=IDUIg0YZHir4f/GqKfaFE/ZQbeQV87TEys4vRYXboxXQ1FBwBNzNAUZIfzJXESW0b
         3IyZznJNMvREUzU0rJftfj9hofdyZ9whwWbVqzYzJ9yQZOhXurZ61kJ5vosd6rrP81
         iHAbdA+V2FbQQGP+DnGugw6XcC873Y7Xwim4MoMA=
Received: by mail-lj1-f175.google.com with SMTP id 185so2326325ljj.7
        for <linux-raid@vger.kernel.org>; Fri, 21 Aug 2020 08:42:04 -0700 (PDT)
X-Gm-Message-State: AOAM531qX48SkEsu5cj8osuxb84K9K53aJ1HxWQCVAkjFmI7Q7kAYXdB
        AIvAr72UemjaMp1aI3s+nvnm2Sh+CRaRwdPZvk8=
X-Google-Smtp-Source: ABdhPJzwwhbq3gbLuX+2p8KERB16OzgNZXr5KtfA3KxczVYLNu85Irrh4C5QODKjC78Lq6afa0AxKM3lU8vWr4TSHlA=
X-Received: by 2002:a2e:81c2:: with SMTP id s2mr1857213ljg.10.1598024523227;
 Fri, 21 Aug 2020 08:42:03 -0700 (PDT)
MIME-Version: 1.0
References: <20200820132214.3749139-1-yuyufen@huawei.com> <CAPhsuW473fmPDanrHYwG6NxU3Ai7kd8oo6siKo4A4j1w-pi7rg@mail.gmail.com>
 <1f99d02f-0104-8c22-78e8-46a90c4f25b4@huawei.com>
In-Reply-To: <1f99d02f-0104-8c22-78e8-46a90c4f25b4@huawei.com>
From:   Song Liu <song@kernel.org>
Date:   Fri, 21 Aug 2020 08:41:52 -0700
X-Gmail-Original-Message-ID: <CAPhsuW5epoHMZgKmSUMKOPSfoYWyh6Dazs=JbesWAD4_30x22Q@mail.gmail.com>
Message-ID: <CAPhsuW5epoHMZgKmSUMKOPSfoYWyh6Dazs=JbesWAD4_30x22Q@mail.gmail.com>
Subject: Re: [PATCH v2 00/10] Save memory for stripe_head buffer
To:     Yufen Yu <yuyufen@huawei.com>
Cc:     linux-raid <linux-raid@vger.kernel.org>,
        Hou Tao <houtao1@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-raid-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Fri, Aug 21, 2020 at 5:20 AM Yufen Yu <yuyufen@huawei.com> wrote:
>
>
>
> On 2020/8/21 13:04, Song Liu wrote:
> > On Thu, Aug 20, 2020 at 6:21 AM Yufen Yu <yuyufen@huawei.com> wrote:
> >>
> > [...]
> >>
> >>   Patch 8 ~ 10 actually implement shared page between multiple devices of
> >>   stripe_head. But they only make sense for PAGE_SIZE != 4096, likely, 64KB arm64
> >>   system. It doesn't make any difference for PAGE_SIZE == 4096 system, likely x86.
> >>
> >>   We have run tests of mdadm for raid456 and test raid6test module.
> >>   Not found obvious errors.
> >
> > Applied series to md-next.
> >
> > I noticed there is another case where we allocate page for
> > sh->dev[i].orig_page in
> > handle_stripe_dirtying(). This only happens with journal devices.
> > Please run tests
> > with journal device.
>
> For now, raid5 journal and PPL feature are both required PAGE_SIZE == 4096.
> (Seen r5l_init_log() and ppl_init_log() return -EINVAL when PAGE_SIZE is not
> 4096). So, in theory, this patch set should not make any different for them.

I see. Missed this part.

Thanks,
Song
