Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B664C2B9F7
	for <linux-raid@archiver.kernel.org>; Wed, 26 May 2021 06:32:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E06B1613D3
	for <linux-raid@archiver.kernel.org>; Wed, 26 May 2021 06:32:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232725AbhEZGe2 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 26 May 2021 02:34:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:56136 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232591AbhEZGeX (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Wed, 26 May 2021 02:34:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CD2E261090
        for <linux-raid@vger.kernel.org>; Wed, 26 May 2021 06:32:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622010772;
        bh=snoTxATMVFviVqaSJA/d/JX/I5y9MBOKdWzF3m9oZl4=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=RET/O+e3pDpnX4ySTMLerg3qUjtXKJKYSH5taMNp21O817h7AY6xWYOHTLtL0RMDe
         XDq2o3tWwH3SN356ndQRMdSskx4xWICRmTOltkjXaDAOQyKTf7o1EPl4xq+5XCLM9K
         94wn5JHRneKlDnWwfMXgRQblItFdl6VfdUazQyg97nSChaUduSTuc31/A4TJVjCq8s
         dIrkHkK7V1Rs57YrYgewopqSpwdCbUClJTotJj9iS+Yrnp3h1NOWT5FBYYeZrpFEgH
         FLIcz3tlRzm7N1Nc2uQ2w15aVNDO9xporNxbmte35N3lkxjgGQvSuKx5lPk0aAwVTa
         bco2KrVI1+E8Q==
Received: by mail-lf1-f43.google.com with SMTP id j6so820913lfr.11
        for <linux-raid@vger.kernel.org>; Tue, 25 May 2021 23:32:52 -0700 (PDT)
X-Gm-Message-State: AOAM533PCMn5N7vVVqD0HOxBQ7t7RSf7+0E8lr1kwfXfuiL4vW47N2Rp
        r2MF9x59dI1zSh2LoilMwalxFVrowOp1e5iznEc=
X-Google-Smtp-Source: ABdhPJwa6/leLjjVWwvMNDbizZDRW298WAh4qjZPxfZMb8jTlbCsZP+z+1gThNCvmkngcLIgA639KESvzMBvf920zm8=
X-Received: by 2002:a19:ee17:: with SMTP id g23mr1057304lfb.438.1622010771111;
 Tue, 25 May 2021 23:32:51 -0700 (PDT)
MIME-Version: 1.0
References: <20210525094623.763195-1-jiangguoqing@kylinos.cn> <20210525094623.763195-3-jiangguoqing@kylinos.cn>
In-Reply-To: <20210525094623.763195-3-jiangguoqing@kylinos.cn>
From:   Song Liu <song@kernel.org>
Date:   Tue, 25 May 2021 23:32:40 -0700
X-Gmail-Original-Message-ID: <CAPhsuW6WyvFtvJVw1q5tpx9C9wWMh8YDEd8v+xdY=P4yLiKELA@mail.gmail.com>
Message-ID: <CAPhsuW6WyvFtvJVw1q5tpx9C9wWMh8YDEd8v+xdY=P4yLiKELA@mail.gmail.com>
Subject: Re: [PATCH V3 2/8] md: add io accounting for raid0 and raid5
To:     Guoqing Jiang <jgq516@gmail.com>
Cc:     linux-raid <linux-raid@vger.kernel.org>,
        Artur Paszkiewicz <artur.paszkiewicz@intel.com>,
        Christoph Hellwig <hch@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Tue, May 25, 2021 at 2:47 AM Guoqing Jiang <jgq516@gmail.com> wrote:
>
> We introduce a new bioset (io_acct_set) for raid0 and raid5 since they
> don't own clone infrastructure to accounting io. And the bioset is added
> to mddev instead of to raid0 and raid5 layer, because with this way, we
> can put common functions to md.h and reuse them in raid0 and raid5.
>
> Also struct md_io_acct is added accordingly which includes io start_time,
> the origin bio and cloned bio. Then we can call bio_{start,end}_io_acct
> to get related io status.
>
> Signed-off-by: Guoqing Jiang <jiangguoqing@kylinos.cn>

Applied the set to md-next, with some changes on this one. Please take a look at
these changes.

Thanks,
Song

[...]

> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -2340,7 +2340,8 @@ int md_integrity_register(struct mddev *mddev)
>                                bdev_get_integrity(reference->bdev));
>
>         pr_debug("md: data integrity enabled on %s\n", mdname(mddev));
> -       if (bioset_integrity_create(&mddev->bio_set, BIO_POOL_SIZE)) {
> +       if (bioset_integrity_create(&mddev->bio_set, BIO_POOL_SIZE) ||
> +           bioset_integrity_create(&mddev->io_acct_set, BIO_POOL_SIZE)) {

Added better error handling here.

>                 pr_err("md: failed to create integrity pool for %s\n",
>                        mdname(mddev));
>                 return -EINVAL;
> @@ -5569,6 +5570,7 @@ static void md_free(struct kobject *ko)
>
>         bioset_exit(&mddev->bio_set);
>         bioset_exit(&mddev->sync_set);
> +       bioset_exit(&mddev->io_acct_set);
>         kfree(mddev);
>  }
>
> @@ -5864,6 +5866,12 @@ int md_run(struct mddev *mddev)
>                 if (err)
>                         return err;
>         }
> +       if (!bioset_initialized(&mddev->io_acct_set)) {
> +               err = bioset_init(&mddev->io_acct_set, BIO_POOL_SIZE,
> +                                 offsetof(struct md_io_acct, bio_clone), 0);
> +               if (err)
> +                       return err;
> +       }

And here (for the other two bioset_initialized calls).

>
>         spin_lock(&pers_lock);
>         pers = find_pers(mddev->level, mddev->clevel);

[...]

> +
> +       if (!blk_queue_io_stat((*bio)->bi_bdev->bd_disk->queue))
> +               return;

Added blk_queue_flag_set(QUEUE_FLAG_IO_STAT, mddev->queue); to md_run.
We still need it as md doesn't use mq. Without it, the default iostats is 0.

[...]
