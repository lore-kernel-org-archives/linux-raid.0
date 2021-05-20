Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0ABD0C433B4
	for <linux-raid@archiver.kernel.org>; Thu, 20 May 2021 00:45:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C9EE2611C2
	for <linux-raid@archiver.kernel.org>; Thu, 20 May 2021 00:45:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230138AbhETAqe (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 19 May 2021 20:46:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:55732 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229498AbhETAqe (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Wed, 19 May 2021 20:46:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7D7A96112F
        for <linux-raid@vger.kernel.org>; Thu, 20 May 2021 00:45:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621471513;
        bh=ahPVFEAtczQR+rhhlbw7Z8yQVf8QMbbOOrP28SEVwEU=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=HDa01R2jODoCNeu+rQwAJKYf8c8lEw+7LJ+wHY1C/AKq7EY+DYESFuDBbAJaKqSey
         f548kUtwYGNixNPMOQjXmnFsNgVOfETehNH42zC380G8debHrBxfPbB3OJMjnjFYIP
         UW/3c1tLXtruxI/mBuknngO+aPnAcR0HcxO3Nvf07fuSKnAarERn8MrS1NCNBDWnAh
         T3MIl8dAINl9HGFm3kpYmCVIPrbcNBuCJvWxOwn/Vp3g6Qp9j8dsZaNOLABuZJarrm
         GYpQlYqeN3A5mik3B0BwHVO54VsfJCAzfTSGblo4mkQ3I8NT8T/p+RDiwj7eyuHOob
         mIjKviKX7ptkA==
Received: by mail-lf1-f54.google.com with SMTP id m11so21830474lfg.3
        for <linux-raid@vger.kernel.org>; Wed, 19 May 2021 17:45:13 -0700 (PDT)
X-Gm-Message-State: AOAM5331R37PQaxpQ0ffoJev1Cj6E+WVK4B+tQ5h3/H8nk3FwUch7uKU
        jz5QCuAjNP51zeb4cIWwvMx388jfFf5lJXy+oU8=
X-Google-Smtp-Source: ABdhPJy7a5KZxfrxYbnACMzKp0YkAY1SyC6MbMQEOPj5cOtv8xiUvhHEZD5T8m58tx+ZHujTVr15GdtXQoskAgeLALE=
X-Received: by 2002:ac2:5b12:: with SMTP id v18mr1521859lfn.261.1621471511802;
 Wed, 19 May 2021 17:45:11 -0700 (PDT)
MIME-Version: 1.0
References: <20210518053225.641506-1-jiangguoqing@kylinos.cn>
 <20210518053225.641506-3-jiangguoqing@kylinos.cn> <2887bc44-dd0b-0b24-ee97-b0a95f0c4936@intel.com>
 <2bfe7f2b-5b5b-634d-3996-3c4ed77e74ff@gmail.com> <d788bc1f-3fd9-a293-2f2a-6047fdd45625@intel.com>
 <c63b1793-e83e-f729-cd97-2f34b43166dd@gmail.com>
In-Reply-To: <c63b1793-e83e-f729-cd97-2f34b43166dd@gmail.com>
From:   Song Liu <song@kernel.org>
Date:   Wed, 19 May 2021 17:45:00 -0700
X-Gmail-Original-Message-ID: <CAPhsuW5-2=GthpXjVKwQKsLzrAXEjx-gJijwM-JgKXcfo4=QvQ@mail.gmail.com>
Message-ID: <CAPhsuW5-2=GthpXjVKwQKsLzrAXEjx-gJijwM-JgKXcfo4=QvQ@mail.gmail.com>
Subject: Re: [PATCH 2/5] md: the latest try for improve io stats accounting
To:     Guoqing Jiang <jgq516@gmail.com>
Cc:     Artur Paszkiewicz <artur.paszkiewicz@intel.com>,
        linux-raid <linux-raid@vger.kernel.org>,
        Guoqing Jiang <jiangguoqing@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Wed, May 19, 2021 at 1:09 AM Guoqing Jiang <jgq516@gmail.com> wrote:
>
>
>
> On 5/19/21 3:26 PM, Artur Paszkiewicz wrote:
> > On 19.05.2021 03:30, Guoqing Jiang wrote:
> >> Hmm, raid0 allocates split bio from mddev->bio_set, but raid5 is
> >> different, it splits bio from r5conf->bio_split. So either let raid5 also
> >> splits bio from mddev->bio_set, or add an additional checking for
> >> raid5. Thoughts?
> > It looks like raid5 has a different bio set for that because it uses
> > mddev->bio_set for something else - allocating a bio for rdev. So I
> > think it can be changed to split from mddev->bio_set and have a private
> > bio set for the rdev bio allocation.
>
>
> Instead of add a flag, I tried this way:
>
> diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
> index e5d7411cba9b..d309b639b5d9 100644
> --- a/drivers/md/raid0.c
> +++ b/drivers/md/raid0.c
> @@ -748,6 +748,19 @@ static void raid0_quiesce(struct mddev *mddev, int
> quiesce)
>   {
>   }
>
> +/*
> + * Don't account the bio if it was split from mddev->bio_set.
> + */
> +static bool raid0_accounting_bio(struct mddev *mddev, struct bio *bio)
> +{
> +       bool ret = true;
> +
> +       if (bio->bi_pool == &mddev->bio_set)
> +               ret = false;
> +
> +       return ret;
> +}
> +
>   static struct md_personality raid0_personality=
>   {
>          .name           = "raid0",
> @@ -760,6 +773,7 @@ static struct md_personality raid0_personality=
>          .size           = raid0_size,
>          .takeover       = raid0_takeover,
>          .quiesce        = raid0_quiesce,
> +       .accounting_bio = raid0_accounting_bio,
>   };
>
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 841e1c1aa5e6..070ccf55c534 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -8596,6 +8596,20 @@ static void *raid6_takeover(struct mddev *mddev)
>          return setup_conf(mddev);
>   }
>
> +/*
> + * Don't account the bio if it was split from r5conf->bio_split.
> + */
> +static bool raid5_accounting_bio(struct mddev *mddev, struct bio *bio)
> +{
> +       bool ret = true;
> +       struct r5conf *conf = mddev->private;
> +
> +       if (bio->bi_pool == &conf->bio_split)
> +               ret = false;
> +
> +       return ret;
> +}
> +
>   static int raid5_change_consistency_policy(struct mddev *mddev, const
> char *buf)
>   {
>          struct r5conf *conf;
> @@ -8687,6 +8701,7 @@ static struct md_personality raid6_personality =
>          .finish_reshape = raid5_finish_reshape,
>          .quiesce        = raid5_quiesce,
>          .takeover       = raid6_takeover,
> +       .accounting_bio = raid5_accounting_bio,

I like the accounting_bio idea. Let's go with it.

Thanks,
Song
