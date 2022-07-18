Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B98C9C43334
	for <linux-raid@archiver.kernel.org>; Mon, 18 Jul 2022 18:20:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235333AbiGRSUy (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 18 Jul 2022 14:20:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234906AbiGRSUx (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 18 Jul 2022 14:20:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEA032ED7B;
        Mon, 18 Jul 2022 11:20:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5386161625;
        Mon, 18 Jul 2022 18:20:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4401CC341CE;
        Mon, 18 Jul 2022 18:20:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658168451;
        bh=PnxMBy8fxW18f0T5GnUx+lo4QdMgo44VTpGfg/xcKDQ=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=A6HqTKO4Ffmr4pWeTvRmBaTHbh1WQV4vyBSGg/DM7A5hLp4cJKO+7KNEk1HP1gv4M
         NOB7rCMqA2wDbjrZw7GosfIvPoJWF5d8fGxHmcTgERiXT7axZ0kk7rRCYXj7SIX8D+
         4YAAWEnzresDnlKQNWI1a2bsy23gn8LvIK4MmQnBiEc0aHreEPFAwqHhvqHfIEXjJ1
         75/jXDYHySw3DZHw0LLWLaZPcGiy+PdEBzBfyQNJwgHfxLi1YBlcq5AsxNNMgKgiyW
         3fuAZk/dTuCdRChyYHDph0uF7Z/pF73O/wEBhJYoCg9H6owrL0bgFCpT5S4g/jh2zR
         8fW3VwAiYlstg==
Received: by mail-yb1-f170.google.com with SMTP id h62so22265853ybb.11;
        Mon, 18 Jul 2022 11:20:51 -0700 (PDT)
X-Gm-Message-State: AJIora8l57nMrVlk1vAl4dy0nULYZRVgK8nDvRuy121B37ULV+0p34NV
        o4LOQtyTwSLmZuGQGoKE9rWuQ4xQMwJ3lGKrWdo=
X-Google-Smtp-Source: AGRyM1uKWFBosHjgaAbV3yZIw7T4eJxjkO2blUEJbSazn7fbV1jt9DTNa4LNaAt3UUYBZRujPJssQjKWU2RvEEdYDxs=
X-Received: by 2002:a25:8611:0:b0:66e:d9e7:debc with SMTP id
 y17-20020a258611000000b0066ed9e7debcmr28379734ybk.257.1658168450283; Mon, 18
 Jul 2022 11:20:50 -0700 (PDT)
MIME-Version: 1.0
References: <20220718063410.338626-1-hch@lst.de> <20220718063410.338626-10-hch@lst.de>
 <b8521a53-fb41-279c-dc43-580e8d0de045@suse.de>
In-Reply-To: <b8521a53-fb41-279c-dc43-580e8d0de045@suse.de>
From:   Song Liu <song@kernel.org>
Date:   Mon, 18 Jul 2022 11:20:39 -0700
X-Gmail-Original-Message-ID: <CAPhsuW6VYLt0hPsa667mr5+Zn1pxjY_670NaD8+No=2ZjoOzYg@mail.gmail.com>
Message-ID: <CAPhsuW6VYLt0hPsa667mr5+Zn1pxjY_670NaD8+No=2ZjoOzYg@mail.gmail.com>
Subject: Re: [PATCH 09/10] md: only delete entries from all_mddevs when the
 disk is freed
To:     Hannes Reinecke <hare@suse.de>
Cc:     Christoph Hellwig <hch@lst.de>,
        Logan Gunthorpe <logang@deltatee.com>,
        linux-raid <linux-raid@vger.kernel.org>,
        linux-block@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Mon, Jul 18, 2022 at 12:17 AM Hannes Reinecke <hare@suse.de> wrote:
>
> On 7/18/22 08:34, Christoph Hellwig wrote:
> > This ensures device names don't get prematurely reused.  Instead add a
> > deleted flag to skip already deleted devices in mddev_get and other
> > places that only want to see live mddevs.
> >
> > Reported-by; Logan Gunthorpe <logang@deltatee.com>
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > ---
> >   drivers/md/md.c | 56 +++++++++++++++++++++++++++++++++----------------
> >   drivers/md/md.h |  1 +
> >   2 files changed, 39 insertions(+), 18 deletions(-)
> >
> > diff --git a/drivers/md/md.c b/drivers/md/md.c
> > index 805f2b4ed9c0d..08cf21ad4c2d7 100644
> > --- a/drivers/md/md.c
> > +++ b/drivers/md/md.c
> > @@ -625,6 +625,10 @@ EXPORT_SYMBOL(md_flush_request);
> >
> >   static inline struct mddev *mddev_get(struct mddev *mddev)
> >   {
> > +     lockdep_assert_held(&all_mddevs_lock);
> > +
> > +     if (mddev->deleted)
> > +             return NULL;
> >       atomic_inc(&mddev->active);
> >       return mddev;
> >   }
>
> Why can't we use 'atomic_inc_unless_zero' here and do away with the
> additional 'deleted' flag?

Thanks Christoph for the set. And thanks Hannes for the quick review!

I think atomic_inc_unless_zero() should work here. Alternatively, we can
also grab a big from mddev->flags as MD_DELETED.

Thanks,
Song

[...]
