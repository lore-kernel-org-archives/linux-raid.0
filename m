Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB59EC7618E
	for <linux-raid@archiver.kernel.org>; Mon, 24 Apr 2023 18:01:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231646AbjDXSBD (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 24 Apr 2023 14:01:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231140AbjDXSBC (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 24 Apr 2023 14:01:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F3A56A42
        for <linux-raid@vger.kernel.org>; Mon, 24 Apr 2023 11:01:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C3591627AD
        for <linux-raid@vger.kernel.org>; Mon, 24 Apr 2023 18:01:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35203C4339C
        for <linux-raid@vger.kernel.org>; Mon, 24 Apr 2023 18:01:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682359260;
        bh=vFqBDWD2n1bSeMxBtaE/RKfCVSsRlmmUWTRcoVuT5yQ=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=tZvXs4VO6kNvzDEu0k/iPw0A+AmF4FUX799lK7kptE4nO3LYY1O+AE6KCr0VwZFVM
         irmY4afe6GYRX7ZiPJwVEij05JiuPEG8CLt3O/GMc5ObVKA5WIk02Uy9yD3kj0fhrI
         RuNcYbqrY8uP2AzvazOhLH88dv/xiT7ASAUBDahYJleQQAvTtdeCkJccbq/3py7I7q
         EEWfvKNhVrW48c8M/2m+QdhCFWjCp2uWu2KktZKRvFXkOOqUyCO3wELqsXo7F4VZHq
         oL9CsIOobYBnBriomh2Ek77WNcj5Md+hwxEnHLnOeq7vwyUQ/6ywB+Ey1h0zQKptHm
         RKHIoQmJ0lneQ==
Received: by mail-lj1-f173.google.com with SMTP id 38308e7fff4ca-2a7b02615f1so46551301fa.0
        for <linux-raid@vger.kernel.org>; Mon, 24 Apr 2023 11:01:00 -0700 (PDT)
X-Gm-Message-State: AAQBX9cwfUDSvdto1r792esAF4hEGgqrf/VU0jgywvQzwIq9C9lpFSol
        zbYYIbwRhoEFGgjuYUrw/8PNfVltZ61Fwy8V3/w=
X-Google-Smtp-Source: AKy350bfP5iO49zBpYTrOQ48OYfYJjc8DMnYWlD2+YSi4d72RJGfYLlRDNhqsSFUF8+OMSFpyR7rIsEKIfOdIqLblRM=
X-Received: by 2002:a2e:9bd3:0:b0:2a7:8582:f4f2 with SMTP id
 w19-20020a2e9bd3000000b002a78582f4f2mr2858215ljj.32.1682359258169; Mon, 24
 Apr 2023 11:00:58 -0700 (PDT)
MIME-Version: 1.0
References: <2dc52026-8261-49da-90c8-55cd5c5c6959@kili.mountain>
In-Reply-To: <2dc52026-8261-49da-90c8-55cd5c5c6959@kili.mountain>
From:   Song Liu <song@kernel.org>
Date:   Mon, 24 Apr 2023 11:00:45 -0700
X-Gmail-Original-Message-ID: <CAPhsuW6nb+9kVmCi2j93zWPxZ6UcQQBSnHFSCp1c7Bi3+xUZXA@mail.gmail.com>
Message-ID: <CAPhsuW6nb+9kVmCi2j93zWPxZ6UcQQBSnHFSCp1c7Bi3+xUZXA@mail.gmail.com>
Subject: Re: [bug report] md: Fix types in sb writer
To:     Dan Carpenter <dan.carpenter@linaro.org>,
        jonathan.derrick@linux.dev
Cc:     linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Dan,

Thanks for the report!.

On Fri, Apr 21, 2023 at 3:45=E2=80=AFAM Dan Carpenter <dan.carpenter@linaro=
.org> wrote:
>
> Hello Jon Derrick,
>
> The patch 10172f200b67: "md: Fix types in sb writer" from Feb 24,
> 2023, leads to the following Smatch static checker warning:
>
>         drivers/md/md-bitmap.c:265 __write_sb_page()
>         warn: unsigned 'offset' is never less than zero.
>
> drivers/md/md-bitmap.c
>     234 static int __write_sb_page(struct md_rdev *rdev, struct bitmap *b=
itmap,
>     235                            struct page *page)
>     236 {
>     237         struct block_device *bdev;
>     238         struct mddev *mddev =3D bitmap->mddev;
>     239         struct bitmap_storage *store =3D &bitmap->storage;
>     240         sector_t offset =3D mddev->bitmap_info.offset;
>                 ^^^^^^^^
> offset used to be llof_t which is s64.

Hi Jon,

Please look into this soon.

Thanks,
Song

>
>     241         sector_t ps, sboff, doff;
>     242         unsigned int size =3D PAGE_SIZE;
>     243         unsigned int opt_size =3D PAGE_SIZE;
>     244
>     245         bdev =3D (rdev->meta_bdev) ? rdev->meta_bdev : rdev->bdev=
;
>     246         if (page->index =3D=3D store->file_pages - 1) {
>     247                 unsigned int last_page_size =3D store->bytes & (P=
AGE_SIZE - 1);
>     248
>     249                 if (last_page_size =3D=3D 0)
>     250                         last_page_size =3D PAGE_SIZE;
>     251                 size =3D roundup(last_page_size, bdev_logical_blo=
ck_size(bdev));
>     252                 opt_size =3D optimal_io_size(bdev, last_page_size=
, size);
>     253         }
>     254
>     255         ps =3D page->index * PAGE_SIZE / SECTOR_SIZE;
>     256         sboff =3D rdev->sb_start + offset;
>     257         doff =3D rdev->data_offset;
>     258
>     259         /* Just make sure we aren't corrupting data or metadata *=
/
>     260         if (mddev->external) {
>     261                 /* Bitmap could be anywhere. */
>     262                 if (sboff + ps > doff &&
>     263                     sboff < (doff + mddev->dev_sectors + PAGE_SIZ=
E / SECTOR_SIZE))
>     264                         return -EINVAL;
> --> 265         } else if (offset < 0) {
>                            ^^^^^^^^^^
> Now that it's a sector_t this is impossible.
>
>     266                 /* DATA  BITMAP METADATA  */
>     267                 size =3D bitmap_io_size(size, opt_size, offset + =
ps, 0);
>     268                 if (size =3D=3D 0)
>     269                         /* bitmap runs in to metadata */
>     270                         return -EINVAL;
>     271
>     272                 if (doff + mddev->dev_sectors > sboff)
>     273                         /* data runs in to bitmap */
>     274                         return -EINVAL;
>     275         } else if (rdev->sb_start < rdev->data_offset) {
>     276                 /* METADATA BITMAP DATA */
>     277                 size =3D bitmap_io_size(size, opt_size, sboff + p=
s, doff);
>     278                 if (size =3D=3D 0)
>     279                         /* bitmap runs in to data */
>     280                         return -EINVAL;
>     281         } else {
>     282                 /* DATA METADATA BITMAP - no problems */
>     283         }
>     284
>     285         md_super_write(mddev, rdev, sboff + ps, (int) size, page)=
;
>     286         return 0;
>     287 }
>
> regards,
> dan carpenter
