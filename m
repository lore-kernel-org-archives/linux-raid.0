Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA555C47089
	for <linux-raid@archiver.kernel.org>; Thu, 27 May 2021 06:14:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8F142613D4
	for <linux-raid@archiver.kernel.org>; Thu, 27 May 2021 06:14:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232896AbhE0GQA (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 27 May 2021 02:16:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:54956 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229590AbhE0GP7 (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Thu, 27 May 2021 02:15:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 09D3B613D4
        for <linux-raid@vger.kernel.org>; Thu, 27 May 2021 06:14:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622096067;
        bh=Gl8L/L2dzrLVNS14+C86G8Lcvaarbdrm3nOFhV60UyY=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=rD2z9PfQF4i4xFqmimrAvioysrZmnocv6de65XKLldziX8+tfbGSr3Qe5czbK1Lzv
         v6Tl80xwgne+hcsdtRilRIT1JV2/sHkjHdn7BykMq+yirsqytGy5n3ICSIqiPs2vjT
         wFNrCelh/q/hSYIGd7HQCmVfmf+ffz5u/iNihVraeDI09EluxYrhvafsNyuwwH5DgC
         1VWGYeS3ppuv+I+kLSuVtJggcxXgelJE0MepAKic1xntbWGBmDscFcgw1lqv8AvdjY
         i4A8+bUiQE9rezvojUyBMVNkKRbbQP5cUm581tUboLc1TCEsQTwkmRE5dTVH3uMaZn
         yAmex6kt60ftw==
Received: by mail-lf1-f51.google.com with SMTP id v8so6247447lft.8
        for <linux-raid@vger.kernel.org>; Wed, 26 May 2021 23:14:26 -0700 (PDT)
X-Gm-Message-State: AOAM532pcEb4B+jvA4vY9aTK2bzWO61oX7ugiVV50812BhCRfPVeGRUY
        gPqD/NLqa9YhO85USqut8bSZcKE4mYdYK9qnSQA=
X-Google-Smtp-Source: ABdhPJyl8TJjGfY4pQAKT1Hp7nW43rglyfvpkml3fmNzc2MmLRG37FalVdFE/YjuBTs9057GJ4c/yrt/FO5Y1eCDNu4=
X-Received: by 2002:a19:6a10:: with SMTP id u16mr1257215lfu.281.1622096065385;
 Wed, 26 May 2021 23:14:25 -0700 (PDT)
MIME-Version: 1.0
References: <20210525094623.763195-1-jiangguoqing@kylinos.cn>
 <20210525094623.763195-3-jiangguoqing@kylinos.cn> <CAPhsuW6WyvFtvJVw1q5tpx9C9wWMh8YDEd8v+xdY=P4yLiKELA@mail.gmail.com>
 <a2342aab-28da-64a2-9591-bc7b482e1751@gmail.com> <CAPhsuW7Xz6nOPFsn64qLhvDtNGDGX6Pf_U3Tb=d0KiL4+9_h=Q@mail.gmail.com>
 <20118145-e993-b11f-8907-5e2f1cc44ddb@gmail.com>
In-Reply-To: <20118145-e993-b11f-8907-5e2f1cc44ddb@gmail.com>
From:   Song Liu <song@kernel.org>
Date:   Wed, 26 May 2021 23:14:14 -0700
X-Gmail-Original-Message-ID: <CAPhsuW7hj1pRN8tPLPMr0YGaMG0z5-EKztqoph7sALrW4c+4bA@mail.gmail.com>
Message-ID: <CAPhsuW7hj1pRN8tPLPMr0YGaMG0z5-EKztqoph7sALrW4c+4bA@mail.gmail.com>
Subject: Re: [PATCH V3 2/8] md: add io accounting for raid0 and raid5
To:     Guoqing Jiang <jgq516@gmail.com>
Cc:     linux-raid <linux-raid@vger.kernel.org>,
        Artur Paszkiewicz <artur.paszkiewicz@intel.com>,
        Christoph Hellwig <hch@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Wed, May 26, 2021 at 7:00 PM Guoqing Jiang <jgq516@gmail.com> wrote:
>

[...]

> >> (bioset_exit -> bioset_integrity_free) is triggered.
> >>
> >> I thought we probably need a comment here given it is not explicit.
> > I think it is better to handle it within this function. Does it have
> > any downside
> > to call bioset_integrity_free(&mddev->bio_set) here?
> >
> > [...]
>
> md_run has to deal with failure path by call bioset_exit, which
> already call bioset_integrity_free implicitly. Why the additional
> call of bioset_integrity_free would be helpful? Or do you want
> to remove bioset_exit from md_run as well?

I guess you are right. Removing this one.

>
> >>>> +
> >>>> +       if (!blk_queue_io_stat((*bio)->bi_bdev->bd_disk->queue))
> >>>> +               return;
> >>> Added blk_queue_flag_set(QUEUE_FLAG_IO_STAT, mddev->queue); to md_run.
> >>> We still need it as md doesn't use mq. Without it, the default iostats is 0.
> >>>
> >> It enables io accounting by default, so raid5 and raid0 users have to
> >> disable it if they don't want the additional latency.
> > iostats was on by default before this set, as we didn't check
> > blk_queue_io_stat().
> > So it is better to keep the same behavior.
>
> Could you point the place where md enables iostats before the set?
> I can't find relevant code for it.

Before this set, we did not set QUEUE_FLAG_IO_STAT, and we didn't
check blk_queue_io_stat() either. So even with /sys/block/mdX/queue/iostats
of 0, we still get iostats for the md device. By setting QUEUE_FLAG_IO_STAT
with the patch, the users still get iostats working by default.

Does this make sense?
Thanks,
Song
