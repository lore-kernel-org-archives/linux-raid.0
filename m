Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5284FC433EF
	for <linux-raid@archiver.kernel.org>; Tue, 19 Jul 2022 06:28:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237021AbiGSG2X (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 19 Jul 2022 02:28:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233462AbiGSG2W (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 19 Jul 2022 02:28:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6CB429823;
        Mon, 18 Jul 2022 23:28:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 51D6461617;
        Tue, 19 Jul 2022 06:28:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89F8DC341CF;
        Tue, 19 Jul 2022 06:28:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658212100;
        bh=pmlMG++zqHQj0OyID0dPPzRqeQKzC3n5GPfYbSfT0UM=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=tGYmpHKWF++d1y0eKtPMeJkjdpdRkbPxMJdfq1BZfI6xy63XZbkmgkp/ByBvmksel
         D7xs+HLIJ9txeSnu6kLiVUVFAXrTHFrJcPSQBwcXLquFQ2QKc9nNaXkdvpEl/d6Put
         aP7T4pC1UNYL3gKl3mxQjvcjQsU4/tPXEDCAyr8S0KvNo4DdK3LRuf/lr3u11MF23H
         ejPdgaUm9qxvTPCsOYFbP4oyQjAtZPnoeylCtCiuS5YhDBPwf2kB5MMFmcnM44So7i
         KXdBS3Q+h8wkRIM0gW8HlIoaGuAy2yfQn3j8sulfNUYMptKqzMHOqBbFQIyYyFRU5t
         Wyz0nRqzzhTrA==
Received: by mail-yw1-f170.google.com with SMTP id 00721157ae682-2ef5380669cso130330967b3.9;
        Mon, 18 Jul 2022 23:28:20 -0700 (PDT)
X-Gm-Message-State: AJIora+C4VcqyNcI0D0UZoC947CulUnKO3dUfOHFVxWkIbykbRiIrdWS
        8daoG4d1SuzlkoZZfKovHTtUMBNJdGeBEMXmDQE=
X-Google-Smtp-Source: AGRyM1t81YwATsnzSHGjuIh63Qqc6VwB06Wj8xfg2TV7BAmtvtY2tRAiMpvCpsCRqIDBdqgrRZ5pDP4GII7s+Ezcjhg=
X-Received: by 2002:a0d:d606:0:b0:31e:5634:ea45 with SMTP id
 y6-20020a0dd606000000b0031e5634ea45mr3267181ywd.447.1658212099619; Mon, 18
 Jul 2022 23:28:19 -0700 (PDT)
MIME-Version: 1.0
References: <20220718063410.338626-1-hch@lst.de> <20220718063410.338626-10-hch@lst.de>
 <b8521a53-fb41-279c-dc43-580e8d0de045@suse.de> <CAPhsuW6VYLt0hPsa667mr5+Zn1pxjY_670NaD8+No=2ZjoOzYg@mail.gmail.com>
 <20220719050655.GA26785@lst.de>
In-Reply-To: <20220719050655.GA26785@lst.de>
From:   Song Liu <song@kernel.org>
Date:   Mon, 18 Jul 2022 23:28:08 -0700
X-Gmail-Original-Message-ID: <CAPhsuW4Nz51-XTqYSiftji_baV_DR+P3UsHV0RiwyhKwrbs_Jw@mail.gmail.com>
Message-ID: <CAPhsuW4Nz51-XTqYSiftji_baV_DR+P3UsHV0RiwyhKwrbs_Jw@mail.gmail.com>
Subject: Re: [PATCH 09/10] md: only delete entries from all_mddevs when the
 disk is freed
To:     Christoph Hellwig <hch@lst.de>
Cc:     Hannes Reinecke <hare@suse.de>,
        Logan Gunthorpe <logang@deltatee.com>,
        linux-raid <linux-raid@vger.kernel.org>,
        linux-block@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Mon, Jul 18, 2022 at 10:07 PM Christoph Hellwig <hch@lst.de> wrote:
>
> On Mon, Jul 18, 2022 at 11:20:39AM -0700, Song Liu wrote:
> > > >   static inline struct mddev *mddev_get(struct mddev *mddev)
> > > >   {
> > > > +     lockdep_assert_held(&all_mddevs_lock);
> > > > +
> > > > +     if (mddev->deleted)
> > > > +             return NULL;
> > > >       atomic_inc(&mddev->active);
> > > >       return mddev;
> > > >   }
> > >
> > > Why can't we use 'atomic_inc_unless_zero' here and do away with the
> > > additional 'deleted' flag?
>
> > I think atomic_inc_unless_zero() should work here. Alternatively, we can
> > also grab a big from mddev->flags as MD_DELETED.
>
> s/big/bit/ ?
yeah, bit...

>
> Yes, this could use mddev->flags.  I don't think atomic_inc_unless_zero
> would work, as an array can have a refcount of 0 but we still allow
> to take new references to it, the deletion only happens if the other
> conditions in mddev_put are met.
>
> Do you want me to repin the series using a flag?

Respin the series sounds good. Please also address Hannes' feedback
on 8/10.

Thanks,
Song
