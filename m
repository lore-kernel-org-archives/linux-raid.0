Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB080C433B4
	for <linux-raid@archiver.kernel.org>; Thu,  6 May 2021 05:48:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8E13761176
	for <linux-raid@archiver.kernel.org>; Thu,  6 May 2021 05:48:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229622AbhEFFt4 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 6 May 2021 01:49:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:40858 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231172AbhEFFtz (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Thu, 6 May 2021 01:49:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D02FD613B5
        for <linux-raid@vger.kernel.org>; Thu,  6 May 2021 05:48:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620280137;
        bh=TqlUHULfxBkEDNBb+7u2nZgkUnpbyob9Uc57JdTdhKs=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=U3dYtQ9kWGWcyrdTlQQJoIU8M5/AnpYz2LU4Vbyk4Stpr+2mxOFcgnlzQIuyrly0h
         Ts3Tpp/OVdo2K+NWzYx2LTr6voFxoZ0CqG+rahCqxJe4vL6pGDxa42tEtNZRYezM18
         V1NL6QUDfqwdxK31aTFc6pajPGR3o/2NrIRkhe2T6CSurJ/xdeHMR71lfu4sUQcKqs
         SJwUlUvBQyWkGmjo2evI+qXWWQXhQE0xg+8pX2EWDT7iQpbg9e/Tet9Z92FFmMQJ+o
         0QOJbn907A5KkIB664yg6W3bhkpC2C5MjJAPt7wfeUonsDSMoHPIRo9Z02p4ffMvWs
         szMdfVrbmwIAg==
Received: by mail-lj1-f178.google.com with SMTP id s25so5555085lji.0
        for <linux-raid@vger.kernel.org>; Wed, 05 May 2021 22:48:57 -0700 (PDT)
X-Gm-Message-State: AOAM533vhjakmIG1E5ShUhXzYs83HB6m4/nb2b5rix2fofoCtM24V/1P
        5exzp2KS6x0bPFUnhgibvUhBgNJxrgFZl5YIzCc=
X-Google-Smtp-Source: ABdhPJyPVOdYXorYoZzIUzUxQY+ecTfshqUFHHGefN3E6At8Ulrq5YygREsrvq7aVkVvoq/yE5PxmbSEYP+QNWxZ0ZY=
X-Received: by 2002:a2e:1608:: with SMTP id w8mr1899858ljd.506.1620280136096;
 Wed, 05 May 2021 22:48:56 -0700 (PDT)
MIME-Version: 1.0
References: <CADLTsw2OJtc30HyAHCpQVbbUyoD7P9bK-ZfaH+nrdZc+Je4b6g@mail.gmail.com>
 <ddbacea2-13d9-28ca-7ba2-50b581ac658a@gmail.com> <CAPhsuW743nJCFOv1SHyVU-hcOWMCdFhL4-404e0vE+BdTD3=CQ@mail.gmail.com>
 <CADLTsw340wuEoX02ad-M6mN_48uDdnkj0dZSJGYMFrjgB+y80Q@mail.gmail.com>
In-Reply-To: <CADLTsw340wuEoX02ad-M6mN_48uDdnkj0dZSJGYMFrjgB+y80Q@mail.gmail.com>
From:   Song Liu <song@kernel.org>
Date:   Wed, 5 May 2021 22:48:44 -0700
X-Gmail-Original-Message-ID: <CAPhsuW7ZzhXtg5MikTG+NtpQbYBZfpU5tDWzbZXDF4bhj9wwdA@mail.gmail.com>
Message-ID: <CAPhsuW7ZzhXtg5MikTG+NtpQbYBZfpU5tDWzbZXDF4bhj9wwdA@mail.gmail.com>
Subject: Re: PROBLEM: double fault in md_end_io
To:     =?UTF-8?Q?Pawe=C5=82_Wiejacha?= <pawel.wiejacha@rtbhouse.com>
Cc:     Guoqing Jiang <jgq516@gmail.com>,
        linux-raid <linux-raid@vger.kernel.org>,
        Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Pawe=C5=82,

On Tue, May 4, 2021 at 2:18 PM Pawe=C5=82 Wiejacha
<pawel.wiejacha@rtbhouse.com> wrote:
>
> Guoqing's patch fixes the problem. Here's the actual patch I am using:

Thanks for running the tests.

Hi Guoqing,

Could you please send official patch for this fix?

Thanks,
Song

>
> -static void bio_chain_endio(struct bio *bio)
> +void bio_chain_endio(struct bio *bio)
>  {
>     bio_endio(__bio_chain_endio(bio));
>  }
> +EXPORT_SYMBOL(bio_chain_endio);
>
>  /**
>   * bio_chain - chain bio completions
> diff --git drivers/md/md.c drivers/md/md.c
> index 04384452a7ab..f157bd6e0478 100644
> --- drivers/md/md.c
> +++ drivers/md/md.c
> @@ -507,7 +507,8 @@ static blk_qc_t md_submit_bio(struct bio *bio)
>         return BLK_QC_T_NONE;
>     }
>
> -   if (bio->bi_end_io !=3D md_end_io) {
> +   if (bio->bi_end_io !=3D md_end_io && bio->bi_end_io !=3D
> +                bio_chain_endio) {
>         struct md_io *md_io;
>
>         md_io =3D mempool_alloc(&mddev->md_io_pool, GFP_NOIO);
> diff --git include/linux/bio.h include/linux/bio.h
> index 1edda614f7ce..bfb5bd0be397 100644
> --- include/linux/bio.h
> +++ include/linux/bio.h
> @@ -427,6 +427,7 @@ static inline struct bio *bio_kmalloc(gfp_t
> gfp_mask, unsigned int nr_iovecs)
>  extern blk_qc_t submit_bio(struct bio *);
>
>  extern void bio_endio(struct bio *);
> +extern void bio_chain_endio(struct bio *bio);

[...]
