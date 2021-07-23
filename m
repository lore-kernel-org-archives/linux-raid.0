Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 947A5C4338F
	for <linux-raid@archiver.kernel.org>; Fri, 23 Jul 2021 17:05:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7278860EAF
	for <linux-raid@archiver.kernel.org>; Fri, 23 Jul 2021 17:05:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229949AbhGWQYy (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 23 Jul 2021 12:24:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:40240 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229564AbhGWQYx (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Fri, 23 Jul 2021 12:24:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1844460EAF;
        Fri, 23 Jul 2021 17:05:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627059927;
        bh=gzbBPOiH5w2i76ACZ/O4KOXej6TzticgA1EQwiyI8ek=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=IPnJPMY5QTaxCT0tE54esTaFqzpTHsWK2PDo28kqN8sGebc2FVvYxhfE4hJi0eRx/
         pWwIdb9IHp6XmzS8SjaGcJg6XFrfvyBvivY/EHjK6ma0Jpq+6mTyE2LiY/DqhaVFW3
         fGxu4hXiz3xrP4L4VQgC35yrJSaEZPXvo7ReJ36BuUso5btNeyhdpBxpNE/ns7kMeU
         3ut8NkgGZhcLYSv4v8MOqWSWBwG+UC/bwA6oukDwmJ1WoXIOHQec6b55iPtmZk5J11
         qBI/3uzfSLa2HgBmXG13AVO+m7bXADjMJq7Bwdl6eTxZxsxPtQKHmqjdC6/VJC/b+y
         xyIefJ5FI7Afg==
Received: by mail-lf1-f49.google.com with SMTP id y34so3145122lfa.8;
        Fri, 23 Jul 2021 10:05:27 -0700 (PDT)
X-Gm-Message-State: AOAM530UTEOYf+aLq67qcGVT7wTchY8dP6U2hjG93E8SOMno0Om6bTRt
        wZlUGZqyQsjKMfbP2ASs/qgb+Y/qfFJW6Rxcm0g=
X-Google-Smtp-Source: ABdhPJzK5zfFUjitlrwd5pXZorjbdCJaxI2bI1/V9lUdkxQ7/R+KDei3DkXE3OD1SgKNlLhOHaRMbYNK2Afni2TY1VA=
X-Received: by 2002:ac2:4438:: with SMTP id w24mr3646153lfl.281.1627059925427;
 Fri, 23 Jul 2021 10:05:25 -0700 (PDT)
MIME-Version: 1.0
References: <20210715031533.9553-1-justin.he@arm.com> <20210715031533.9553-12-justin.he@arm.com>
 <51d24b1a-7146-bacd-87ee-4be487c455d8@linux.dev>
In-Reply-To: <51d24b1a-7146-bacd-87ee-4be487c455d8@linux.dev>
From:   Song Liu <song@kernel.org>
Date:   Fri, 23 Jul 2021 10:05:14 -0700
X-Gmail-Original-Message-ID: <CAPhsuW7C5kjnutW1rdkg7jENsrg8k47_+R24G7RZRrM07s2Ymw@mail.gmail.com>
Message-ID: <CAPhsuW7C5kjnutW1rdkg7jENsrg8k47_+R24G7RZRrM07s2Ymw@mail.gmail.com>
Subject: Re: [PATCH RFC 11/13] md/bitmap: simplify the printing with '%pD' specifier
To:     Guoqing Jiang <guoqing.jiang@linux.dev>
Cc:     Jia He <justin.he@arm.com>,
        open list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>, nd@arm.com,
        linux-raid <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Fri, Jul 16, 2021 at 2:41 AM Guoqing Jiang <guoqing.jiang@linux.dev> wrote:
>
>
>
> On 7/15/21 11:15 AM, Jia He wrote:
> > After the behavior of '%pD' is changed to print the full path of file,
> > the log printing can be simplified.
> >
> > Given the space with proper length would be allocated in vprintk_store(),
> > it is worthy of dropping kmalloc()/kfree() to avoid additional space
> > allocation. The error case is well handled in d_path_unsafe(), the error
> > string would be copied in '%pD' buffer, no need to additionally handle
> > IS_ERR().
> >
> > Cc: Song Liu <song@kernel.org>
> > Cc: linux-raid@vger.kernel.org
> > Cc: linux-kernel@vger.kernel.org
> > Signed-off-by: Jia He <justin.he@arm.com>
> > ---
> >   drivers/md/md-bitmap.c | 13 ++-----------
> >   1 file changed, 2 insertions(+), 11 deletions(-)
> >
> > diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
> > index e29c6298ef5c..a82f1c2ef83c 100644
> > --- a/drivers/md/md-bitmap.c
> > +++ b/drivers/md/md-bitmap.c
> > @@ -862,21 +862,12 @@ static void md_bitmap_file_unmap(struct bitmap_storage *store)
> >    */
> >   static void md_bitmap_file_kick(struct bitmap *bitmap)
> >   {
> > -     char *path, *ptr = NULL;
> > -
> >       if (!test_and_set_bit(BITMAP_STALE, &bitmap->flags)) {
> >               md_bitmap_update_sb(bitmap);
> >
> >               if (bitmap->storage.file) {
> > -                     path = kmalloc(PAGE_SIZE, GFP_KERNEL);
> > -                     if (path)
> > -                             ptr = file_path(bitmap->storage.file,
> > -                                          path, PAGE_SIZE);
> > -
> > -                     pr_warn("%s: kicking failed bitmap file %s from array!\n",
> > -                             bmname(bitmap), IS_ERR(ptr) ? "" : ptr);
> > -
> > -                     kfree(path);
> > +                     pr_warn("%s: kicking failed bitmap file %pD from array!\n",
> > +                             bmname(bitmap), bitmap->storage.file);

This is neat!

Acked-by: Song Liu <song@kernel.org>




> >               } else
> >                       pr_warn("%s: disabling internal bitmap due to errors\n",
> >                               bmname(bitmap));
>
> Looks good,  Acked-by: Guoqing Jiang <guoqing.jiang@linux.dev>
