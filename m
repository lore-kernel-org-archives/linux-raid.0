Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBEC5C433F5
	for <linux-raid@archiver.kernel.org>; Thu,  7 Oct 2021 06:32:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B30246105A
	for <linux-raid@archiver.kernel.org>; Thu,  7 Oct 2021 06:32:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240213AbhJGGem (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 7 Oct 2021 02:34:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:59482 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229582AbhJGGel (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Thu, 7 Oct 2021 02:34:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7387D60F59
        for <linux-raid@vger.kernel.org>; Thu,  7 Oct 2021 06:32:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633588368;
        bh=nGOoOfJOlMhNzUbMWHnhxq5S1KjjqBSaOO9Hm8nmWPw=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=uIL4YQ2BpeXoW0Beni1RJuKqXbiqgccH3yN8fvNFNJur4fQY7ILIEALLRNmWVNgfT
         cQX3Sba1RfVhDYoFUjixb+Mz0UdlqLVDFAR58pEPwprJTERqYErVDHLubhty0eeRfI
         v0xuWCWM3dkR1zPTKT/MJiIVp7Gq9GZiHvb+qDDXEor0hH04fXwussCNygwsUGdE2z
         KtpkUg2sNTcl8W+iCKQ1wrAAGbTLA0/8JPec1WE62uq9UOmOT/m9ZXxxzDFqspCfZs
         pVcXnjWt8iVv8FwnLmCbzqp4HpYLwQGszgcMBuqVbk04+t/s+C0Cc0Yh3fFQavTNL1
         9KOG+t6vM+N9Q==
Received: by mail-lf1-f53.google.com with SMTP id u18so20131846lfd.12
        for <linux-raid@vger.kernel.org>; Wed, 06 Oct 2021 23:32:48 -0700 (PDT)
X-Gm-Message-State: AOAM530hN2uZOwCkjiaCbIC8zuRmSc7DnLrV16xiWkacABmYHiRVeg6f
        KQWcg7p93F4Tw3Lv/rU8YszAeg0H0tNCT6WDWX4=
X-Google-Smtp-Source: ABdhPJy17fsaF8Q4YYxN3/6IZtyOiMWfmh+iIHWHNf+XSOzmlR4ECXqgDJtqjaZE8uzykVsFAvGKs9CUqV4ZlO7ASiQ=
X-Received: by 2002:a05:6512:3d93:: with SMTP id k19mr2619417lfv.114.1633588366818;
 Wed, 06 Oct 2021 23:32:46 -0700 (PDT)
MIME-Version: 1.0
References: <20211004153453.14051-1-guoqing.jiang@linux.dev>
In-Reply-To: <20211004153453.14051-1-guoqing.jiang@linux.dev>
From:   Song Liu <song@kernel.org>
Date:   Wed, 6 Oct 2021 23:32:36 -0700
X-Gmail-Original-Message-ID: <CAPhsuW6kLBkw7kRr1K-0onfVaKq+xg0fxQn-teoJcCuS3=g_gA@mail.gmail.com>
Message-ID: <CAPhsuW6kLBkw7kRr1K-0onfVaKq+xg0fxQn-teoJcCuS3=g_gA@mail.gmail.com>
Subject: Re: [PATCH 0/6] Misc changes for md
To:     Guoqing Jiang <guoqing.jiang@linux.dev>
Cc:     linux-raid <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Mon, Oct 4, 2021 at 8:40 AM Guoqing Jiang <guoqing.jiang@linux.dev> wrote:
>
> Hello,
>
> The first patch fixes the same calltrace as commit 6607cd319b6b ("raid1:
> ensure write behind bio has less than BIO_MAX_VECS sectors") tried
> before, but unfortunately the calltrace still could happen if array
> without write mostly device is configured with write-behind enabled.
> So the first patch is suitable for fix branch which others are materials
> for next branch.
>
> Pls review.
>
> Thanks,
> Guoqing
>
> Guoqing Jiang (6):
>   md/raid1: only allocate write behind bio for WriteMostly device
>   md/bitmap: don't set max_write_behind if there is no write mostly
>     device
>   md/raid1: use rdev in raid1_write_request directly
>   md/raid10: add 'read_err' to raid10_read_request
>   md/raid5: call roundup_pow_of_two in raid5_run
>   md: remove unused argument from md_new_event

Thanks for these fixes and cleanups! I applied 1, 3, 5, 6 to md-next.

Song
