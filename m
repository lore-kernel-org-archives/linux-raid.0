Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EAA58C47082
	for <linux-raid@archiver.kernel.org>; Wed, 26 May 2021 16:00:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CC340613AC
	for <linux-raid@archiver.kernel.org>; Wed, 26 May 2021 16:00:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235438AbhEZQBw (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 26 May 2021 12:01:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:57580 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235338AbhEZQBu (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Wed, 26 May 2021 12:01:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EFEC0613D4
        for <linux-raid@vger.kernel.org>; Wed, 26 May 2021 16:00:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622044818;
        bh=nipLXuj75FBBbLn1bWJhrlYLciICSiSRlcH/PGqt438=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=eTJ6N0aT1+WwX+ROAe+t/O22go57jtT4UKkhXCMFPt7UYQasJv2Q7NHt2Hv2zC73v
         p3w4NqH034iXH6+hd3q060rDH7eJdzSIiZWCofC9ie6JdRIPSZ34226iKgSxSsczD8
         L3A7UGZkFP6lYuoBUhCBi2Fvz7myG1UGQNSheHDmxONjyTfRa3g3H9NriVdsZIDJSm
         G8Z+p1wC2X4cnpxkoshKLG2PB1b0lUYumkSDYyeKkDm1cecDyvHdvPHauW8Fj2vkfo
         UL25tfSSBIMl3cDxcbdpcRGiNNeXE+91jxXiH4caewBiSXiCnerx6IP5blkTzN9UfT
         mVFVaQpYPejkQ==
Received: by mail-lj1-f176.google.com with SMTP id w15so2306724ljo.10
        for <linux-raid@vger.kernel.org>; Wed, 26 May 2021 09:00:17 -0700 (PDT)
X-Gm-Message-State: AOAM533UScGnruxiOFN1AxQaIqpp76fk8/9WwKyK2p/GnTYy+TtPPz/3
        ZQAbykB0M5SgDBzzY0IXlpW1gP5XQXwQup7U2rU=
X-Google-Smtp-Source: ABdhPJwPh8U1FFLMB0SNQIz+giz5vTc0FvXtL4DhdHQgdQOAvBwKmhPlj0NXn1TIFa1AiP5QudxMaZpYzu3kivPvS0A=
X-Received: by 2002:a2e:7119:: with SMTP id m25mr2716309ljc.177.1622044816283;
 Wed, 26 May 2021 09:00:16 -0700 (PDT)
MIME-Version: 1.0
References: <20210525094623.763195-1-jiangguoqing@kylinos.cn>
 <20210525094623.763195-3-jiangguoqing@kylinos.cn> <CAPhsuW6WyvFtvJVw1q5tpx9C9wWMh8YDEd8v+xdY=P4yLiKELA@mail.gmail.com>
 <a2342aab-28da-64a2-9591-bc7b482e1751@gmail.com>
In-Reply-To: <a2342aab-28da-64a2-9591-bc7b482e1751@gmail.com>
From:   Song Liu <song@kernel.org>
Date:   Wed, 26 May 2021 09:00:05 -0700
X-Gmail-Original-Message-ID: <CAPhsuW7Xz6nOPFsn64qLhvDtNGDGX6Pf_U3Tb=d0KiL4+9_h=Q@mail.gmail.com>
Message-ID: <CAPhsuW7Xz6nOPFsn64qLhvDtNGDGX6Pf_U3Tb=d0KiL4+9_h=Q@mail.gmail.com>
Subject: Re: [PATCH V3 2/8] md: add io accounting for raid0 and raid5
To:     Guoqing Jiang <jgq516@gmail.com>
Cc:     linux-raid <linux-raid@vger.kernel.org>,
        Artur Paszkiewicz <artur.paszkiewicz@intel.com>,
        Christoph Hellwig <hch@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Wed, May 26, 2021 at 12:53 AM Guoqing Jiang <jgq516@gmail.com> wrote:
>
>
>
> On 5/26/21 2:32 PM, Song Liu wrote:
> > On Tue, May 25, 2021 at 2:47 AM Guoqing Jiang <jgq516@gmail.com> wrote:
> >
> >
> >> --- a/drivers/md/md.c
> >> +++ b/drivers/md/md.c
> >> @@ -2340,7 +2340,8 @@ int md_integrity_register(struct mddev *mddev)
> >>                                 bdev_get_integrity(reference->bdev));
> >>
> >>          pr_debug("md: data integrity enabled on %s\n", mdname(mddev));
> >> -       if (bioset_integrity_create(&mddev->bio_set, BIO_POOL_SIZE)) {
> >> +       if (bioset_integrity_create(&mddev->bio_set, BIO_POOL_SIZE) ||
> >> +           bioset_integrity_create(&mddev->io_acct_set, BIO_POOL_SIZE)) {
> > Added better error handling here.
>
> No need to do it here, because md_integrity_register is called from
> md_run() -> pers->run(), if above returns failure, then the path
> (bioset_exit -> bioset_integrity_free) is triggered.
>
> I thought we probably need a comment here given it is not explicit.

I think it is better to handle it within this function. Does it have
any downside
to call bioset_integrity_free(&mddev->bio_set) here?

[...]

> >> +
> >> +       if (!blk_queue_io_stat((*bio)->bi_bdev->bd_disk->queue))
> >> +               return;
> > Added blk_queue_flag_set(QUEUE_FLAG_IO_STAT, mddev->queue); to md_run.
> > We still need it as md doesn't use mq. Without it, the default iostats is 0.
> >
>
> It enables io accounting by default, so raid5 and raid0 users have to
> disable it if they don't want the additional latency.

iostats was on by default before this set, as we didn't check
blk_queue_io_stat().
So it is better to keep the same behavior.

Thanks,
Song
