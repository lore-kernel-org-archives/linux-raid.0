Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CAEDDC4338F
	for <linux-raid@archiver.kernel.org>; Fri, 13 Aug 2021 16:16:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A11546109E
	for <linux-raid@archiver.kernel.org>; Fri, 13 Aug 2021 16:16:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229705AbhHMQQk (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 13 Aug 2021 12:16:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:44732 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229471AbhHMQQk (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Fri, 13 Aug 2021 12:16:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2ECD0610A5;
        Fri, 13 Aug 2021 16:16:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628871373;
        bh=exNtTQEXZVA1SbZhCLPoxctZxfVROly9j6q4ACZXMF4=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=WURIjjZsPOyym8iPW4IcM6qtGizJLJHk9XQOZOr9ZFS0bDn+sI5DhZ/E5/v1WRhh1
         Xx2iXF2sksA0409Ch3/0gFUkJ/ABh+jsfKLYEJcyt4peZlQij2/9eZEWoGk6wIHCWi
         sHTIIiFr8si5DGr3L8V5vUIXFbrK9bhJ9acRyt8HOFv9Xuh1do9xjciDRML4M3pn2C
         OALR+P05mJSJ13Bb4QBFHYrgKUeF3rqsUqKLN+qmZG/g3rTqzKQ7TE6+YmSIEPyeRY
         jmfXT9iDezYHYkRwM5beraA6fSRuN4PcNaQk7g85y3Aol2zLSWNFurtkr7tqbzDYvq
         6vGxdxcMoGdaw==
Received: by mail-lf1-f43.google.com with SMTP id w20so20767327lfu.7;
        Fri, 13 Aug 2021 09:16:13 -0700 (PDT)
X-Gm-Message-State: AOAM533H5HcA1ZMkWyUzbdUl/W81P/7P7hGwJKHCgxFn4KYdNTAi7u5e
        cKQjxcZFMV5BY7Ihel7nPG63T61znuFeEg7uiyQ=
X-Google-Smtp-Source: ABdhPJzsoteT06x0RmPU8JlZIfdHKShBIwB38siEctt4CD20hkOjyWOyWXsOc1cxiPop7HzeWwql7LzYMRXn/Lu8cVw=
X-Received: by 2002:ac2:44c3:: with SMTP id d3mr1923014lfm.281.1628871371513;
 Fri, 13 Aug 2021 09:16:11 -0700 (PDT)
MIME-Version: 1.0
References: <tencent_888910D6F881B3D8BD9C3DFED667A5009806@qq.com>
In-Reply-To: <tencent_888910D6F881B3D8BD9C3DFED667A5009806@qq.com>
From:   Song Liu <song@kernel.org>
Date:   Fri, 13 Aug 2021 09:16:00 -0700
X-Gmail-Original-Message-ID: <CAPhsuW7cC+d5mhNjJb0AiHDKCUb5WzYPNzZ5UPOSScdtFuNzww@mail.gmail.com>
Message-ID: <CAPhsuW7cC+d5mhNjJb0AiHDKCUb5WzYPNzZ5UPOSScdtFuNzww@mail.gmail.com>
Subject: Re: [PATCH] drivers:md:fix a potential use-after-free bug
To:     lwt105 <3061522931@qq.com>
Cc:     linux-raid <linux-raid@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Thu, Aug 12, 2021 at 8:46 PM lwt105 <3061522931@qq.com> wrote:
>
> In line 2867, "raid5_release_stripe(sh);" drops the reference to sh and
> may cause sh to be released. However, sh is subsequently used in lines
> 2869 "if (sh->batch_head && sh != sh->batch_head)". This may result in an
> use-after-free bug.
>
> It can be fixed by moving "raid5_release_stripe(sh);" to the bottom of
> the function.
>
> Signed-off-by: lwt105 <3061522931@qq.com>

The fix looks reasonable. I guess lwt105 is not a real name. Please update
the diff with your real name.

Thanks,
Song
> ---
>  drivers/md/raid5.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index b8436e4930ed..16ed44646419 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -2864,10 +2864,10 @@ static void raid5_end_write_request(struct bio *bi)
>         if (!test_and_clear_bit(R5_DOUBLE_LOCKED, &sh->dev[i].flags))
>                 clear_bit(R5_LOCKED, &sh->dev[i].flags);
>         set_bit(STRIPE_HANDLE, &sh->state);
> -       raid5_release_stripe(sh);
>
>         if (sh->batch_head && sh != sh->batch_head)
>                 raid5_release_stripe(sh->batch_head);
> +       raid5_release_stripe(sh);
>  }
>
>  static void raid5_error(struct mddev *mddev, struct md_rdev *rdev)
> --
> 2.25.1
>
