Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 012A1C04FF3
	for <linux-raid@archiver.kernel.org>; Mon, 24 May 2021 05:48:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B98BF61132
	for <linux-raid@archiver.kernel.org>; Mon, 24 May 2021 05:48:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231605AbhEXFtz (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 24 May 2021 01:49:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:51474 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229733AbhEXFty (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Mon, 24 May 2021 01:49:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D5CDF61132
        for <linux-raid@vger.kernel.org>; Mon, 24 May 2021 05:48:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621835306;
        bh=uIVQePRoeiB2WqJLZHvn+pXE6TRQWgMcbbB9hcLyUmw=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=ZFKQiGD+MwvP2YTI45WhXIJyy9QNmZkYlmLD7PJzl+wKeVg9dTdFdZ+hFlpQUVFZu
         ahKw9MUipPVF5+3FcKV9fO4vxAy8cQHc9wnuHYQ1nV86f8evJSKiBTeP02eEWfkTUl
         o7xTApjFtOpS4dG9jkQh0k6QI58s4kA7MmyJy+ykX7mt0j1aR/cqhtkrZvYv3UDyJl
         bxs2pCKw/55lm5fYCcQZbrCkc7ChLqCpRDbv4NBSqMKb+ANqmITUDJ3kn3oNvxkF/X
         Tv6pkJrByZniYnTFq21tFR4k2oksxeopGfALxdAYqpVBI7fDIXtPrvBSTCXKrZHXBI
         5G7UVPS89nqRw==
Received: by mail-lj1-f180.google.com with SMTP id f12so32000177ljp.2
        for <linux-raid@vger.kernel.org>; Sun, 23 May 2021 22:48:26 -0700 (PDT)
X-Gm-Message-State: AOAM531FmNZwcq0BxAaoy33Z1ORzHILyUWYTZCHzeB1jEbAolno4NYFj
        gqsT0y7owVZAaA1+OywWUih+g8X2NMop38ehr70=
X-Google-Smtp-Source: ABdhPJzkwU2HgSb4IIDwioJ30yXMVLEm3fb0AVWmrBNVjn/MERHaA208X5VLVZYUItKeUvWzDRWs28bamBXpSyw7WxI=
X-Received: by 2002:a2e:9d09:: with SMTP id t9mr15507367lji.506.1621835305184;
 Sun, 23 May 2021 22:48:25 -0700 (PDT)
MIME-Version: 1.0
References: <20210521005521.713106-1-jiangguoqing@kylinos.cn> <20210521005521.713106-3-jiangguoqing@kylinos.cn>
In-Reply-To: <20210521005521.713106-3-jiangguoqing@kylinos.cn>
From:   Song Liu <song@kernel.org>
Date:   Sun, 23 May 2021 22:48:14 -0700
X-Gmail-Original-Message-ID: <CAPhsuW6qYrDMU8zEsXZQKzn-VwFjoiRKcXax-vwpqPz438KnjQ@mail.gmail.com>
Message-ID: <CAPhsuW6qYrDMU8zEsXZQKzn-VwFjoiRKcXax-vwpqPz438KnjQ@mail.gmail.com>
Subject: Re: [PATCH V2 2/7] md: add accounting_bio for raid0 and raid5
To:     Guoqing Jiang <jgq516@gmail.com>
Cc:     linux-raid <linux-raid@vger.kernel.org>,
        Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Thu, May 20, 2021 at 5:56 PM Guoqing Jiang <jgq516@gmail.com> wrote:
>
> Let's introduce accounting_bio which checks if md needs clone the bio
> for accounting.
>
> And add relevant function to raid0 and raid5 given both don't have
> their own clone infrastrure, also checks if it is split bio.
>
> Signed-off-by: Guoqing Jiang <jiangguoqing@kylinos.cn>
> ---
>  drivers/md/md.h    |  2 ++
>  drivers/md/raid0.c | 14 ++++++++++++++
>  drivers/md/raid5.c | 17 +++++++++++++++++
>  3 files changed, 33 insertions(+)
>
> diff --git a/drivers/md/md.h b/drivers/md/md.h
> index 4da240ffe2c5..5125ccf9df06 100644
> --- a/drivers/md/md.h
> +++ b/drivers/md/md.h
> @@ -605,6 +605,8 @@ struct md_personality
>         void *(*takeover) (struct mddev *mddev);
>         /* Changes the consistency policy of an active array. */
>         int (*change_consistency_policy)(struct mddev *mddev, const char *buf);
> +       /* check if need to clone bio for accounting in md layer */
> +       bool (*accounting_bio)(struct mddev *mddev, struct bio *bio);
>  };
>
>  struct md_sysfs_entry {
> diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
> index e5d7411cba9b..d309b639b5d9 100644
> --- a/drivers/md/raid0.c
> +++ b/drivers/md/raid0.c
> @@ -748,6 +748,19 @@ static void raid0_quiesce(struct mddev *mddev, int quiesce)
>  {
>  }
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

We can simply do "return bio->bi_pool != &mddev->bio_set;". And same for
raid5_accouting_bio.

> +
> +       return ret;
> +}
> +
>  static struct md_personality raid0_personality=
>  {
>         .name           = "raid0",
> @@ -760,6 +773,7 @@ static struct md_personality raid0_personality=
>         .size           = raid0_size,
>         .takeover       = raid0_takeover,
>         .quiesce        = raid0_quiesce,
> +       .accounting_bio = raid0_accounting_bio,
>  };
>
>  static int __init raid0_init (void)
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 841e1c1aa5e6..bcc1ceb69c73 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -8596,6 +8596,20 @@ static void *raid6_takeover(struct mddev *mddev)
>         return setup_conf(mddev);
>  }
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
>  static int raid5_change_consistency_policy(struct mddev *mddev, const char *buf)
>  {
>         struct r5conf *conf;
> @@ -8688,6 +8702,7 @@ static struct md_personality raid6_personality =
>         .quiesce        = raid5_quiesce,
>         .takeover       = raid6_takeover,
>         .change_consistency_policy = raid5_change_consistency_policy,
> +       .accounting_bio = raid5_accounting_bio,
>  };
>  static struct md_personality raid5_personality =
>  {
> @@ -8712,6 +8727,7 @@ static struct md_personality raid5_personality =
>         .quiesce        = raid5_quiesce,
>         .takeover       = raid5_takeover,
>         .change_consistency_policy = raid5_change_consistency_policy,
> +       .accounting_bio = raid5_accounting_bio,
>  };
>
>  static struct md_personality raid4_personality =
> @@ -8737,6 +8753,7 @@ static struct md_personality raid4_personality =
>         .quiesce        = raid5_quiesce,
>         .takeover       = raid4_takeover,
>         .change_consistency_policy = raid5_change_consistency_policy,
> +       .accounting_bio = raid5_accounting_bio,
>  };
>
>  static int __init raid5_init(void)
> --
> 2.25.1
>
