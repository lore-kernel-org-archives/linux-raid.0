Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91454C77B73
	for <linux-raid@archiver.kernel.org>; Wed, 31 May 2023 07:23:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234469AbjEaHW4 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 31 May 2023 03:22:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234641AbjEaHWi (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 31 May 2023 03:22:38 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CD9510F3
        for <linux-raid@vger.kernel.org>; Wed, 31 May 2023 00:21:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1685517673;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Meyf/XHmfDbzkq87alDHYkBlXs+wlr8Q7mduutGuIR0=;
        b=Eg5z0b0Lg7BFoQTq9U7RN9NJxr5gmtMJliLl1irukDYcNKf/CjDh1jwacHGGu431ICqwlA
        4z+lHBOovcdF/W51w24i+MpzQy7/ar2BimwbJ5KwqkCqluMVJTcm//Ta6B4rO3I6YlXI9e
        /n8HGyx/VdtiQeIuK6u12NvlrG293/Y=
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com
 [209.85.215.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-319-RLLxBPFkPj-r5QkpLy9ygg-1; Wed, 31 May 2023 03:21:12 -0400
X-MC-Unique: RLLxBPFkPj-r5QkpLy9ygg-1
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-51b743d592dso417994a12.0
        for <linux-raid@vger.kernel.org>; Wed, 31 May 2023 00:21:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685517671; x=1688109671;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Meyf/XHmfDbzkq87alDHYkBlXs+wlr8Q7mduutGuIR0=;
        b=Lr5PAZzH2YB1o6C6D+e0wYj1M3TjnBB01xlPHpTcVTPZdIyRpgmLX/VvVd55eSrmyA
         VFOt+z0BXSwRYbIa76vXlj/pVhAz2XDD9V1lJ+/5e57E3Lu7XR8f6Y0yAP4zwlyy0KUu
         +aXIak48lDcXAIOOmegcTYHJSczwDuUWR6vzwNWB4q7aD2FKaG11XNfrOLlWRI7r1ew1
         cVYGcYWUCRPgufiZ52qZdE0SVYhS77s8gwJcHe3LLaMsAlSFGMUabIAi6SYARqaywMYN
         heAOGauCXEzTKDJhBe2RgLTsAYwrXnbg7JK2aokW5E1g6GnXnaV3HZJBHDIbu4TFS/6T
         EtqA==
X-Gm-Message-State: AC+VfDwd7n2EzIdF9dNCWQ02/UC6jdfftUBfTi7uy2fGk83EEf2Yfma6
        NQNcTsCJb0aqmgUMz5E40IpxKbGJSvjD7RC8r9Ger0ttkW7XZ0T4a+SZIwiKWAljF+vrWmYDSwg
        v+Q01cVnYg6bMfQQh0TJyDO63HriilC0Q9BT5Cg==
X-Received: by 2002:a17:90a:3d43:b0:250:50c5:cabc with SMTP id o3-20020a17090a3d4300b0025050c5cabcmr14294151pjf.3.1685517671322;
        Wed, 31 May 2023 00:21:11 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6Xr2yPl0eRj04AKYLMozSgF8t55H6LRqpy/8SnKUtzxcgZY3K/m9auMoo9kMmyTGnPCK6MHDfI9L0x45szauI=
X-Received: by 2002:a17:90a:3d43:b0:250:50c5:cabc with SMTP id
 o3-20020a17090a3d4300b0025050c5cabcmr14294137pjf.3.1685517671046; Wed, 31 May
 2023 00:21:11 -0700 (PDT)
MIME-Version: 1.0
References: <20230529131106.2123367-1-yukuai1@huaweicloud.com> <20230529131106.2123367-4-yukuai1@huaweicloud.com>
In-Reply-To: <20230529131106.2123367-4-yukuai1@huaweicloud.com>
From:   Xiao Ni <xni@redhat.com>
Date:   Wed, 31 May 2023 15:20:59 +0800
Message-ID: <CALTww29_d7H6DG+qZOOJvQ5A8AieXkDfKWgN38HeCP9W-r5RQg@mail.gmail.com>
Subject: Re: [PATCH -next v3 3/7] md/raid1-10: factor out a helper to submit
 normal write
To:     Yu Kuai <yukuai1@huaweicloud.com>
Cc:     song@kernel.org, neilb@suse.de, akpm@osdl.org,
        linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
        yukuai3@huawei.com, yi.zhang@huawei.com, yangerkun@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Mon, May 29, 2023 at 9:14=E2=80=AFPM Yu Kuai <yukuai1@huaweicloud.com> w=
rote:
>
> From: Yu Kuai <yukuai3@huawei.com>
>
> There are multiple places to do the same thing, factor out a helper to
> prevent redundant code, and the helper will be used in following patch
> as well.
>
> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
> ---
>  drivers/md/raid1-10.c | 17 +++++++++++++++++
>  drivers/md/raid1.c    | 13 ++-----------
>  drivers/md/raid10.c   | 26 ++++----------------------
>  3 files changed, 23 insertions(+), 33 deletions(-)
>
> diff --git a/drivers/md/raid1-10.c b/drivers/md/raid1-10.c
> index 9bf19a3409ce..506299bd55cb 100644
> --- a/drivers/md/raid1-10.c
> +++ b/drivers/md/raid1-10.c
> @@ -110,6 +110,23 @@ static void md_bio_reset_resync_pages(struct bio *bi=
o, struct resync_pages *rp,
>         } while (idx++ < RESYNC_PAGES && size > 0);
>  }
>
> +
> +static inline void raid1_submit_write(struct bio *bio)

Hi Kuai

Is it better to change the name to rdev_submit_write? It's just a
suggestion. The patch looks good to me.

Regards
Xiao

> +{
> +       struct md_rdev *rdev =3D (struct md_rdev *)bio->bi_bdev;
> +
> +       bio->bi_next =3D NULL;
> +       bio_set_dev(bio, rdev->bdev);
> +       if (test_bit(Faulty, &rdev->flags))
> +               bio_io_error(bio);
> +       else if (unlikely(bio_op(bio) =3D=3D  REQ_OP_DISCARD &&
> +                         !bdev_max_discard_sectors(bio->bi_bdev)))
> +               /* Just ignore it */
> +               bio_endio(bio);
> +       else
> +               submit_bio_noacct(bio);
> +}
> +
>  static inline bool raid1_add_bio_to_plug(struct mddev *mddev, struct bio=
 *bio,
>                                       blk_plug_cb_fn unplug)
>  {
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index e86c5e71c604..0778e398584c 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -799,17 +799,8 @@ static void flush_bio_list(struct r1conf *conf, stru=
ct bio *bio)
>
>         while (bio) { /* submit pending writes */
>                 struct bio *next =3D bio->bi_next;
> -               struct md_rdev *rdev =3D (void *)bio->bi_bdev;
> -               bio->bi_next =3D NULL;
> -               bio_set_dev(bio, rdev->bdev);
> -               if (test_bit(Faulty, &rdev->flags)) {
> -                       bio_io_error(bio);
> -               } else if (unlikely((bio_op(bio) =3D=3D REQ_OP_DISCARD) &=
&
> -                                   !bdev_max_discard_sectors(bio->bi_bde=
v)))
> -                       /* Just ignore it */
> -                       bio_endio(bio);
> -               else
> -                       submit_bio_noacct(bio);
> +
> +               raid1_submit_write(bio);
>                 bio =3D next;
>                 cond_resched();
>         }
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index 18702051ebd1..6640507ecb0d 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -909,17 +909,8 @@ static void flush_pending_writes(struct r10conf *con=
f)
>
>                 while (bio) { /* submit pending writes */
>                         struct bio *next =3D bio->bi_next;
> -                       struct md_rdev *rdev =3D (void*)bio->bi_bdev;
> -                       bio->bi_next =3D NULL;
> -                       bio_set_dev(bio, rdev->bdev);
> -                       if (test_bit(Faulty, &rdev->flags)) {
> -                               bio_io_error(bio);
> -                       } else if (unlikely((bio_op(bio) =3D=3D  REQ_OP_D=
ISCARD) &&
> -                                           !bdev_max_discard_sectors(bio=
->bi_bdev)))
> -                               /* Just ignore it */
> -                               bio_endio(bio);
> -                       else
> -                               submit_bio_noacct(bio);
> +
> +                       raid1_submit_write(bio);
>                         bio =3D next;
>                         cond_resched();
>                 }
> @@ -1134,17 +1125,8 @@ static void raid10_unplug(struct blk_plug_cb *cb, =
bool from_schedule)
>
>         while (bio) { /* submit pending writes */
>                 struct bio *next =3D bio->bi_next;
> -               struct md_rdev *rdev =3D (void*)bio->bi_bdev;
> -               bio->bi_next =3D NULL;
> -               bio_set_dev(bio, rdev->bdev);
> -               if (test_bit(Faulty, &rdev->flags)) {
> -                       bio_io_error(bio);
> -               } else if (unlikely((bio_op(bio) =3D=3D  REQ_OP_DISCARD) =
&&
> -                                   !bdev_max_discard_sectors(bio->bi_bde=
v)))
> -                       /* Just ignore it */
> -                       bio_endio(bio);
> -               else
> -                       submit_bio_noacct(bio);
> +
> +               raid1_submit_write(bio);
>                 bio =3D next;
>                 cond_resched();
>         }
> --
> 2.39.2
>

