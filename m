Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93251C433F5
	for <linux-raid@archiver.kernel.org>; Tue, 14 Dec 2021 17:08:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236344AbhLNRIz (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 14 Dec 2021 12:08:55 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:59722 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236331AbhLNRIw (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 14 Dec 2021 12:08:52 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4BBF4B81BBA
        for <linux-raid@vger.kernel.org>; Tue, 14 Dec 2021 17:08:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5CC1C34607
        for <linux-raid@vger.kernel.org>; Tue, 14 Dec 2021 17:08:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639501729;
        bh=zY43aHOBJqh+dZCLKCeEjnohUZU1HielHhSTn4qnovw=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=mq/rkiblZ8yHDrnvVIyki0UEwqaSM4v+x91wfXZ2LeZJBj5G9fAW+EJmcg/t9cHB7
         s3RX9zwPnrDPd8zKotnPTvhHjZJJ0fiTz8LplSs3xErIkkUbAMLpqoZWKcZlnwF230
         xQDhl13S5AeN3JmilxvMonNeT5or5nJErkYH7W3tF9nDHDrZotiOqDeYhYMHF/gQzQ
         wYTgq43cjWiImrcu/lqKEgDiiwlhFnwMpIFAj2aGe7gULQ2AybeaIhNjYY+17Z9lvA
         ZnGOeoTEJ6/LkXxWKxJqiZUcPfqhK9ISkj9Y4yI1LyL5G+Fx7G+4uVVnP5QBCsERhY
         yI9dP4jRfsnHA==
Received: by mail-yb1-f175.google.com with SMTP id v203so47898376ybe.6
        for <linux-raid@vger.kernel.org>; Tue, 14 Dec 2021 09:08:49 -0800 (PST)
X-Gm-Message-State: AOAM532K23IMsVQHxmBBd+GdGxiDNIbegfXhFktIc7NtrNF8OKkcVaSo
        O43849MoSEmMAQa+LW6/V6BPjqDIfvfGbyuMK5U=
X-Google-Smtp-Source: ABdhPJzSky3GqDYohbnMnKcUJ0ZVrsmBMQRwztvvKUW0b1zbsBXADDVLqCP4hgrp13jK7311zsNndK/8zi/GxpCf1KQ=
X-Received: by 2002:a25:a283:: with SMTP id c3mr248945ybi.219.1639501728988;
 Tue, 14 Dec 2021 09:08:48 -0800 (PST)
MIME-Version: 1.0
References: <CAPhsuW6mSmxPOmU9=Gq-z_gV4V09+SFqrpKx33LzR=6Rg1fGZw@mail.gmail.com>
 <20211110181441.9263-1-vverma@digitalocean.com> <20211110181441.9263-4-vverma@digitalocean.com>
 <CAPhsuW5drRBWOV9-i7cQWHAwSe5qHff5k23Y2-LsNGS_s8updw@mail.gmail.com>
 <2354ab61-0d13-aec5-a45f-23c5cd3db319@digitalocean.com> <CAPhsuW7r-JX+zOadzbzLDa0WxZdLws9=mTbPc0ci6qNfRBxgjA@mail.gmail.com>
 <998a933f-e3af-2f2c-79c6-ae5a75f286de@digitalocean.com> <b70fded5-8f65-7767-25c1-d45b1dcbbddf@kernel.dk>
 <78d5f029-791e-6d3f-4871-263ec6b5c09b@digitalocean.com> <CAPhsuW6VsNPcG3VSLPk-zq16GYp1CN=X0jk9AGveAWaCBLgoig@mail.gmail.com>
 <255f6109-55ee-a54e-066a-9690da9412ce@digitalocean.com> <07adb65e-d018-e8d4-61e6-3ca3273cc1bd@digitalocean.com>
In-Reply-To: <07adb65e-d018-e8d4-61e6-3ca3273cc1bd@digitalocean.com>
From:   Song Liu <song@kernel.org>
Date:   Tue, 14 Dec 2021 09:08:37 -0800
X-Gmail-Original-Message-ID: <CAPhsuW7OY+5-F6Vk6z=ngSMXEayz3si=Sdf69r4vexRo202X_Q@mail.gmail.com>
Message-ID: <CAPhsuW7OY+5-F6Vk6z=ngSMXEayz3si=Sdf69r4vexRo202X_Q@mail.gmail.com>
Subject: Re: [RFC PATCH v4 4/4] md: raid456 add nowait support
To:     Vishal Verma <vverma@digitalocean.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        linux-raid <linux-raid@vger.kernel.org>, rgoldwyn@suse.de
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Tue, Dec 14, 2021 at 7:30 AM Vishal Verma <vverma@digitalocean.com> wrote:
>
>
> On 12/13/21 6:12 PM, Vishal Verma wrote:
> >
> > On 12/13/21 6:11 PM, Song Liu wrote:
> >> On Mon, Dec 13, 2021 at 4:53 PM Vishal Verma
> >> <vverma@digitalocean.com> wrote:
> >> [...]
> >>> What kernel base are you using for your patches?
> >>>
> >>> These were based out of for-5.16-tag (037c50bfb)
> >> Please rebase on top of md-next branch from here:
> >>
> >> https://git.kernel.org/pub/scm/linux/kernel/git/song/md.git
> >>
> >> Thanks,
> >> Song
> > Ack, will do!
> >
> After rebasing to md-next branch and re-running the tests 100% W, 100%
> R, 70%R30%W with both io_uring and libaio I don't see any issue. Thank you!

That's great! Please address all the feedback and submit v5.

Thanks,
Song
