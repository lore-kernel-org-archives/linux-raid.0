Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6699CC433EF
	for <linux-raid@archiver.kernel.org>; Wed,  1 Jun 2022 22:36:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232338AbiFAWgp (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 1 Jun 2022 18:36:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232334AbiFAWgo (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 1 Jun 2022 18:36:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3376E258;
        Wed,  1 Jun 2022 15:36:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C279AB81CED;
        Wed,  1 Jun 2022 22:36:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A10FC3411D;
        Wed,  1 Jun 2022 22:36:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654123000;
        bh=nHKNB4lpsJXuYXe21iUdgN6lhM5qGZOEhI64aR3yITQ=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=nG9MHsaab+wXkAUwf5xfzdJ8HdnOZva5+0JNJPgHbdjSTuW6jnHTJkRWOHz9/CrbQ
         YsMVqLReDDuUDpKG9Hueae9mPtGlD/Uvob31OAulcrTxZ08nXEfK8s1uUc5rJXJzKs
         fR7Hvp3/cB5P+RJKm3PEV1ohPNfVh9b7GCBmSPCG0J1DpVCSsuH6g6XPe5+1SMb30P
         /LQDQ/LGn1USbMeulwBiCZTTYaSTs50leFGt5NX+NGff7RRD417vA6x4fDBywGWlLZ
         ac5DOID/FSyTVbcUUm27OmonAkncQEzchzHuklJRw4zqvA21rpQGg0oldC5c05/+U0
         wwz94VwR4QVxw==
Received: by mail-yb1-f176.google.com with SMTP id v106so5422846ybi.0;
        Wed, 01 Jun 2022 15:36:40 -0700 (PDT)
X-Gm-Message-State: AOAM5307NZnsj5L4Cqjv4YiDom7ienn++X3F0UvZN4dumUw+kPLK5/G7
        8VXDKU7PEDehJyJWbT21KkqTPI3wE9kyHRaRAWQ=
X-Google-Smtp-Source: ABdhPJxjXgS70z2rd+D/8e2uDI5lK4OCbmnkVMo2ylGOx/Z2W+ilq5g0eGJ/b/MVxPWjPsysA+IYEMLkdAxwF6HfkDo=
X-Received: by 2002:a25:a242:0:b0:651:a78d:4636 with SMTP id
 b60-20020a25a242000000b00651a78d4636mr2199197ybi.9.1654122999274; Wed, 01 Jun
 2022 15:36:39 -0700 (PDT)
MIME-Version: 1.0
References: <20220526163604.32736-1-logang@deltatee.com> <20220526163604.32736-13-logang@deltatee.com>
 <YpRdL+2e7gngOYPa@infradead.org> <c59d233a-c0d1-a3cc-3dad-0a5af449ff83@deltatee.com>
In-Reply-To: <c59d233a-c0d1-a3cc-3dad-0a5af449ff83@deltatee.com>
From:   Song Liu <song@kernel.org>
Date:   Wed, 1 Jun 2022 15:36:28 -0700
X-Gmail-Original-Message-ID: <CAPhsuW56YAwByRKnYDpkbBk1pi01Wdx3NL9yLY2sADWfMmTMeQ@mail.gmail.com>
Message-ID: <CAPhsuW56YAwByRKnYDpkbBk1pi01Wdx3NL9yLY2sADWfMmTMeQ@mail.gmail.com>
Subject: Re: [PATCH v2 12/17] md/raid5-cache: Move struct r5l_log definition
 to raid5-log.h
To:     Logan Gunthorpe <logang@deltatee.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        open list <linux-kernel@vger.kernel.org>,
        linux-raid <linux-raid@vger.kernel.org>,
        Donald Buczek <buczek@molgen.mpg.de>,
        Guoqing Jiang <guoqing.jiang@linux.dev>,
        Xiao Ni <xni@redhat.com>, Stephen Bates <sbates@raithlin.com>,
        Martin Oliveira <Martin.Oliveira@eideticom.com>,
        David Sloan <David.Sloan@eideticom.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Mon, May 30, 2022 at 8:48 AM Logan Gunthorpe <logang@deltatee.com> wrote=
:
>
>
>
> On 2022-05-29 23:59, Christoph Hellwig wrote:
> > On Thu, May 26, 2022 at 10:35:59AM -0600, Logan Gunthorpe wrote:
> >> Move struct r5l_log definition to raid5-log.h. While this reduces
> >> encapsulation, it is necessary for the definition of r5l_log to be
> >> public so that rcu_access_pointer() can be used on conf-log in the
> >> next patch.
> >>
> >> rcu_access_pointer(p) doesn't technically dereference the log pointer
> >> however, it does use typeof(*p) and some older GCC versions (anything
> >> earlier than gcc-10) will wrongly try to dereference the structure:
> >>
> >>     include/linux/rcupdate.h:384:9: error: dereferencing pointer to
> >>                  incomplete type =E2=80=98struct r5l_log=E2=80=99
> >>
> >>       typeof(*p) *local =3D (typeof(*p) *__force)READ_ONCE(p); \
> >>            ^
> >>
> >>     include/linux/rcupdate.h:495:31: note: in expansion of
> >>                   macro =E2=80=98__rcu_access_pointer=E2=80=99
> >>
> >>        #define rcu_access_pointer(p) __rcu_access_pointer((p),
> >>        __UNIQUE_ID(rcu), __rcu)
> >>
> >> To prevent this, simply provide the definition where
> >> rcu_access_pointer() may be used.
> >
> > What about just moving any code that does the rcu_access_pointer on
> > conf->log to raid5-cache.c and doing an out of line call for it
> > instead?
>
> I guess we could do that. All the inline functions in raid5-log.h are
> there to choose between the r5l or the ppl implementaiton. So it that
> would mean the r5l implementation would probably be inlined and ppl
> would be doing a second out of line call. Not sure if that matters, but
> it seems a little odd.

I like the current version better. raid5-log.h is not used in many files an=
yway.

Thanks,
Song
