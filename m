Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D95CCC77B76
	for <linux-raid@archiver.kernel.org>; Mon, 24 Apr 2023 22:14:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233053AbjDXWOV (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 24 Apr 2023 18:14:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232439AbjDXWOT (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 24 Apr 2023 18:14:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42AAF5FE4
        for <linux-raid@vger.kernel.org>; Mon, 24 Apr 2023 15:14:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C76D9629A3
        for <linux-raid@vger.kernel.org>; Mon, 24 Apr 2023 22:14:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3070CC4339B
        for <linux-raid@vger.kernel.org>; Mon, 24 Apr 2023 22:14:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682374457;
        bh=T4r8vIyeln0F3tM0SWc07qubkfDoNqa5HnVT6WFyheU=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=F+aucq9ehVuLcFs9MqgDAVHxZQwzrARJiXTDQPDdF+9imSnwAXVmUOxPlMeqWbRns
         pckOUUZKKhtwnSxZmgzwDW0eTdyrQjV21Wutrab7nMQjJMwKWArJzecH9/3Gm5/6sr
         K8RVLluWjio+bfGB64viiVWZHh47mVaZ3vaZElAgbQp45FCJVjuWSak8Q2gAdBG7XW
         IEU6mqLxfbFUiIGIsEW1deWYD/6ra10BZStcOYsFbjjcdsiBCdoXlcR9Y4ccg2+RqS
         R6Z0Dbo6wX8AlHpGcmGnmMEUc1a4o92t0019KrFNRkv8rtykxEsW/vh+J2pEJEI1kk
         fdext0bTK2n8w==
Received: by mail-lj1-f177.google.com with SMTP id 38308e7fff4ca-2a8b3ecf59fso47998941fa.0
        for <linux-raid@vger.kernel.org>; Mon, 24 Apr 2023 15:14:17 -0700 (PDT)
X-Gm-Message-State: AAQBX9efvpyI3HFKRdyqjGduxcRU0Bc7nKRy/GAG2ToBPyZUBtwD5k/2
        y2WwvX+O8ZANz+5IIjHlZzLURE0F3sNYREA1YCs=
X-Google-Smtp-Source: AKy350ZAhAnkV9IurTEM/X6/29/B00wQB51z3K20l5BgrJCu8vMB+8UIXFLSfKCipFOBDuYak2d4OGfqKnONHXVVGaA=
X-Received: by 2002:a2e:908a:0:b0:2aa:3c81:dba1 with SMTP id
 l10-20020a2e908a000000b002aa3c81dba1mr2797617ljg.33.1682374455185; Mon, 24
 Apr 2023 15:14:15 -0700 (PDT)
MIME-Version: 1.0
References: <2dc52026-8261-49da-90c8-55cd5c5c6959@kili.mountain>
 <CAPhsuW6nb+9kVmCi2j93zWPxZ6UcQQBSnHFSCp1c7Bi3+xUZXA@mail.gmail.com> <3eb2ccba-9b0c-b740-f303-1c9920ebbd84@linux.dev>
In-Reply-To: <3eb2ccba-9b0c-b740-f303-1c9920ebbd84@linux.dev>
From:   Song Liu <song@kernel.org>
Date:   Mon, 24 Apr 2023 15:14:03 -0700
X-Gmail-Original-Message-ID: <CAPhsuW6HuaUJ5WcyPajVgUfkQFYp2D_cy1g6qxN4CU_gP2=z7g@mail.gmail.com>
Message-ID: <CAPhsuW6HuaUJ5WcyPajVgUfkQFYp2D_cy1g6qxN4CU_gP2=z7g@mail.gmail.com>
Subject: Re: [bug report] md: Fix types in sb writer
To:     Jonathan Derrick <jonathan.derrick@linux.dev>
Cc:     Dan Carpenter <dan.carpenter@linaro.org>,
        linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Mon, Apr 24, 2023 at 1:13=E2=80=AFPM Jonathan Derrick
<jonathan.derrick@linux.dev> wrote:
>
>
>
> On 4/24/23 12:00 PM, Song Liu wrote:
> > Hi Dan,
> >
> > Thanks for the report!.
> >
> > On Fri, Apr 21, 2023 at 3:45=E2=80=AFAM Dan Carpenter <dan.carpenter@li=
naro.org> wrote:
> >>
> >> Hello Jon Derrick,
> >>
> >> The patch 10172f200b67: "md: Fix types in sb writer" from Feb 24,
> >> 2023, leads to the following Smatch static checker warning:
> >>
> >>          drivers/md/md-bitmap.c:265 __write_sb_page()
> >>          warn: unsigned 'offset' is never less than zero.
> >>
> >> drivers/md/md-bitmap.c
> >>      234 static int __write_sb_page(struct md_rdev *rdev, struct bitma=
p *bitmap,
> >>      235                            struct page *page)
> >>      236 {
> >>      237         struct block_device *bdev;
> >>      238         struct mddev *mddev =3D bitmap->mddev;
> >>      239         struct bitmap_storage *store =3D &bitmap->storage;
> >>      240         sector_t offset =3D mddev->bitmap_info.offset;
> >>                  ^^^^^^^^
> >> offset used to be llof_t which is s64.
> >
> > Hi Jon,
> >
> > Please look into this soon.
> >
> > Thanks,
> > Song
> >
> >>
> >>      241         sector_t ps, sboff, doff;
> >>      242         unsigned int size =3D PAGE_SIZE;
> >>      243         unsigned int opt_size =3D PAGE_SIZE;
> >>      244
> >>      245         bdev =3D (rdev->meta_bdev) ? rdev->meta_bdev : rdev->=
bdev;
> >>      246         if (page->index =3D=3D store->file_pages - 1) {
> >>      247                 unsigned int last_page_size =3D store->bytes =
& (PAGE_SIZE - 1);
> >>      248
> >>      249                 if (last_page_size =3D=3D 0)
> >>      250                         last_page_size =3D PAGE_SIZE;
> >>      251                 size =3D roundup(last_page_size, bdev_logical=
_block_size(bdev));
> >>      252                 opt_size =3D optimal_io_size(bdev, last_page_=
size, size);
> >>      253         }
> >>      254
> >>      255         ps =3D page->index * PAGE_SIZE / SECTOR_SIZE;
> >>      256         sboff =3D rdev->sb_start + offset;
> >>      257         doff =3D rdev->data_offset;
> >>      258
> >>      259         /* Just make sure we aren't corrupting data or metada=
ta */
> >>      260         if (mddev->external) {
> >>      261                 /* Bitmap could be anywhere. */
> >>      262                 if (sboff + ps > doff &&
> >>      263                     sboff < (doff + mddev->dev_sectors + PAGE=
_SIZE / SECTOR_SIZE))
> >>      264                         return -EINVAL;
> >> --> 265         } else if (offset < 0) {
> >>                             ^^^^^^^^^^
> >> Now that it's a sector_t this is impossible.
> >>
> >>      266                 /* DATA  BITMAP METADATA  */
> >>      267                 size =3D bitmap_io_size(size, opt_size, offse=
t + ps, 0);
> >>      268                 if (size =3D=3D 0)
> >>      269                         /* bitmap runs in to metadata */
> >>      270                         return -EINVAL;
> >>      271
> >>      272                 if (doff + mddev->dev_sectors > sboff)
> >>      273                         /* data runs in to bitmap */
> >>      274                         return -EINVAL;
> >>      275         } else if (rdev->sb_start < rdev->data_offset) {
> >>      276                 /* METADATA BITMAP DATA */
> >>      277                 size =3D bitmap_io_size(size, opt_size, sboff=
 + ps, doff);
> >>      278                 if (size =3D=3D 0)
> >>      279                         /* bitmap runs in to data */
> >>      280                         return -EINVAL;
> >>      281         } else {
> >>      282                 /* DATA METADATA BITMAP - no problems */
> >>      283         }
> >>      284
> >>      285         md_super_write(mddev, rdev, sboff + ps, (int) size, p=
age);
> >>      286         return 0;
> >>      287 }
> >>
> >> regards,
> >> dan carpenter
>
> Seems like just changing it (and sboff) back to loff_t would be acceptabl=
e.

Yes, that should work.

>
> Do you want a follow-up, or a series respin?

Please send a follow-up patch.

Thanks,
Song
