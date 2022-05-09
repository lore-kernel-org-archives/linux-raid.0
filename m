Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6FB7C433F5
	for <linux-raid@archiver.kernel.org>; Mon,  9 May 2022 06:28:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233015AbiEIGb3 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 9 May 2022 02:31:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232789AbiEIG2m (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 9 May 2022 02:28:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95B4211E1ED
        for <linux-raid@vger.kernel.org>; Sun,  8 May 2022 23:24:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 97B9D611F1
        for <linux-raid@vger.kernel.org>; Mon,  9 May 2022 06:24:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3956C385A8
        for <linux-raid@vger.kernel.org>; Mon,  9 May 2022 06:24:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652077461;
        bh=yxb9bztzaWyK394ZlGyuiEoTbzpn6ZxLHLAH2JlK1U0=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=FMKlBJAO2HirCfH/YAFRJnHdxoBHx6nUg4dikRy+iETKHJ3PD5pJGbM5ZYhnzz8LU
         ksCurdWvrf6pMFN9yIaZsOIoE1v23zQNFEOi9hz26TLiRCihzS53e/N2cIWg/sh08b
         3j8Ig/ESRPTuNVIUXwE8PFmLwy7YRZAy1PxmWkioNW9oiYvU0nG0gk5M0jQvBBDknJ
         A+05HPC5GQuCIc5bXDMhmaai7KfVZgWJDkyoPrOq1z/0V0SXkjqMNIVYcXgCkJKACP
         ZDp7yYVJH81W5wJE2VxGp/xfGRqUSGhh6zzONnHVetVjoK4I6Hl/HRXJgb4JQpBuW3
         q3GcOGXGJWuNw==
Received: by mail-yb1-f182.google.com with SMTP id y76so23116082ybe.1
        for <linux-raid@vger.kernel.org>; Sun, 08 May 2022 23:24:20 -0700 (PDT)
X-Gm-Message-State: AOAM531ayE5SkF8xvTqKSUn8oudW5CcHSjEGHs4QJbsH9g8KcJK1sSyS
        lkXe4KS3sRwdHzUP9/mIRPtlqZeLSYW1A9Xp7UI=
X-Google-Smtp-Source: ABdhPJwtTxv+A1yV15aJmQxwv2pEiwJrODCs69FlR+wIfttOs6rzacb2W7Dv4YiIydpxRPM76b1cMcQFob5jSbum5Xk=
X-Received: by 2002:a25:54c6:0:b0:648:3e45:3f32 with SMTP id
 i189-20020a2554c6000000b006483e453f32mr11649948ybb.257.1652077460057; Sun, 08
 May 2022 23:24:20 -0700 (PDT)
MIME-Version: 1.0
References: <1651208967-4701-1-git-send-email-xni@redhat.com>
In-Reply-To: <1651208967-4701-1-git-send-email-xni@redhat.com>
From:   Song Liu <song@kernel.org>
Date:   Sun, 8 May 2022 23:24:08 -0700
X-Gmail-Original-Message-ID: <CAPhsuW7J3EQde_XGdysjNGjHjEb+Zq2kXwXsj+4xpXBA_Bq2Eg@mail.gmail.com>
Message-ID: <CAPhsuW7J3EQde_XGdysjNGjHjEb+Zq2kXwXsj+4xpXBA_Bq2Eg@mail.gmail.com>
Subject: Re: [PATCH 1/1] Don't set mddev private to NULL in raid0 pers->free
To:     Xiao Ni <xni@redhat.com>
Cc:     linux-raid <linux-raid@vger.kernel.org>,
        Nigel Croxon <ncroxon@redhat.com>,
        Heinz Mauelshagen <heinzm@redhat.com>,
        Fine Fan <ffan@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Xiao,

Thanks for the patch!

On Thu, Apr 28, 2022 at 10:09 PM Xiao Ni <xni@redhat.com> wrote:
>

prefix the subject with "md:", and provide more details.

> It panics when reshaping from raid0 to other raid levels. raid0 sets
> mddev->private to NULL. It's the reason that causes the problem.
> Function level_store finds new pers and create new conf, then it
> calls oldpers->free. In oldpers->free, raid0 sets mddev->private
> to NULL again. And __md_stop is the right position to set
> mddev->private to NULL.

We need more details here: the panic backtrace, and why it panics.
raid5_free also sets private to NULL. Does it has the same problem?

>
> And this patch also deletes double free memory codes. io_acct_set
> is free in pers->free.

Please put this part in a separate patch.

Thanks,
Song

>
> Fixes: 0c031fd37f69 (md: Move alloc/free acct bioset in to personality)
> Reported-by: Fine Fan <ffan@redhat.com>
> Signed-off-by: Xiao Ni <xni@redhat.com>
> ---
>  drivers/md/md.c    | 4 ----
>  drivers/md/raid0.c | 1 -
>  2 files changed, 5 deletions(-)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 707e802..55b6412e 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -5598,8 +5598,6 @@ static void md_free(struct kobject *ko)
>
>         bioset_exit(&mddev->bio_set);
>         bioset_exit(&mddev->sync_set);
> -       if (mddev->level != 1 && mddev->level != 10)
> -               bioset_exit(&mddev->io_acct_set);
>         kfree(mddev);
>  }
>
> @@ -6285,8 +6283,6 @@ void md_stop(struct mddev *mddev)
>         __md_stop(mddev);
>         bioset_exit(&mddev->bio_set);
>         bioset_exit(&mddev->sync_set);
> -       if (mddev->level != 1 && mddev->level != 10)
> -               bioset_exit(&mddev->io_acct_set);
>  }
>
>  EXPORT_SYMBOL_GPL(md_stop);
> diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
> index e11701e..5fa0d40 100644
> --- a/drivers/md/raid0.c
> +++ b/drivers/md/raid0.c
> @@ -362,7 +362,6 @@ static void free_conf(struct mddev *mddev, struct r0conf *conf)
>         kfree(conf->strip_zone);
>         kfree(conf->devlist);
>         kfree(conf);
> -       mddev->private = NULL;
>  }
>
>  static void raid0_free(struct mddev *mddev, void *priv)
> --
> 2.7.5
>
