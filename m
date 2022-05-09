Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 842F0C43219
	for <linux-raid@archiver.kernel.org>; Mon,  9 May 2022 06:48:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230501AbiEIGuf (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 9 May 2022 02:50:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233984AbiEIGnV (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 9 May 2022 02:43:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23107190D39
        for <linux-raid@vger.kernel.org>; Sun,  8 May 2022 23:39:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6A881B80ECB
        for <linux-raid@vger.kernel.org>; Mon,  9 May 2022 06:39:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 225FBC385AE
        for <linux-raid@vger.kernel.org>; Mon,  9 May 2022 06:39:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652078358;
        bh=cwX24avHeN2vNEm+oxOZ9bdMgpz2s62OXVsqa0MtqG8=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=HI/ZpSHRAgdd7Qg+pZgMf//PShKv94JYb1tJw8jCjK+BZDWrBJzYPk32nPVK5bRCj
         fDJXMOyog1YdRbpkgM3JNQL/9Z2VphEjn1SzxbhudXEvbjq2OfT6OyotcO/uYPmzj7
         3aNYvam+XTxr9nn2RfWjcMqqRZN1F61bhWHvtGrhmYookqzFFTW3ZRMb8BhhlI/Xqp
         ZSRpHnqH+OxBQ47oBNjfaxogl9tcT3OFpjuQPvRrW3GNRms5l+xN1oZ14SYyFJ112A
         x7AtfauSA5S86pri9/L0tn68gwS5vYBYhAVKGAyQOTAdWDBBnVeXpUoJ8QDV8IL7q4
         0C4/DHi6V92fQ==
Received: by mail-yb1-f180.google.com with SMTP id w187so23144225ybe.2
        for <linux-raid@vger.kernel.org>; Sun, 08 May 2022 23:39:18 -0700 (PDT)
X-Gm-Message-State: AOAM532U7fm2pM9bwHJREkzEsrdZPCBKvIDK7PDDFI4xUim5HzpoaGWr
        ZfcK9i0ZslycxtGElHB56wcJ7CmzkPH8A9FS0L0=
X-Google-Smtp-Source: ABdhPJyLkbgmzo9MvsqT3ZcyxbC+z0kMBL4CJkpjmxgfosELaVoiWwbQiL/OKZKMij2izsIZZqcxK6H6o9gihpPJsUg=
X-Received: by 2002:a25:395:0:b0:645:8146:9a9e with SMTP id
 143-20020a250395000000b0064581469a9emr11439109ybd.389.1652078357203; Sun, 08
 May 2022 23:39:17 -0700 (PDT)
MIME-Version: 1.0
References: <20220505081641.21500-1-guoqing.jiang@linux.dev> <20220505081641.21500-3-guoqing.jiang@linux.dev>
In-Reply-To: <20220505081641.21500-3-guoqing.jiang@linux.dev>
From:   Song Liu <song@kernel.org>
Date:   Sun, 8 May 2022 23:39:06 -0700
X-Gmail-Original-Message-ID: <CAPhsuW4EhdQ6-t8hOyznn0XF2REWLXBCLKh1ru9NZHz9xF5raQ@mail.gmail.com>
Message-ID: <CAPhsuW4EhdQ6-t8hOyznn0XF2REWLXBCLKh1ru9NZHz9xF5raQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] md: protect md_unregister_thread from reentrancy
To:     Guoqing Jiang <guoqing.jiang@linux.dev>
Cc:     Donald Buczek <buczek@molgen.mpg.de>,
        linux-raid <linux-raid@vger.kernel.org>,
        Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Thu, May 5, 2022 at 1:18 AM Guoqing Jiang <guoqing.jiang@linux.dev> wrote:
>
> From: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
>
> Generally, the md_unregister_thread is called with reconfig_mutex, but
> raid_message in dm-raid doesn't hold reconfig_mutex to unregister thread,
> so md_unregister_thread can be called simulitaneously from two call sites
> in theory.

Can we add lock/unlock into raid_message? Are there some constraints here?

Thanks,
Song

>
> Then after previous commit which remove the protection of reconfig_mutex
> for md_unregister_thread completely, the potential issue could be worse
> than before.
>
> Let's take pers_lock at the beginning of function to ensure reentrancy.
>
> Reported-by: Donald Buczek <buczek@molgen.mpg.de>
> Signed-off-by: Guoqing Jiang <guoqing.jiang@linux.dev>
> ---
>  drivers/md/md.c | 15 ++++++++++-----
>  1 file changed, 10 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index a70e7f0f9268..c401e063bec8 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -7962,17 +7962,22 @@ EXPORT_SYMBOL(md_register_thread);
>
>  void md_unregister_thread(struct md_thread **threadp)
>  {
> -       struct md_thread *thread = *threadp;
> -       if (!thread)
> -               return;
> -       pr_debug("interrupting MD-thread pid %d\n", task_pid_nr(thread->tsk));
> -       /* Locking ensures that mddev_unlock does not wake_up a
> +       struct md_thread *thread;
> +
> +       /*
> +        * Locking ensures that mddev_unlock does not wake_up a
>          * non-existent thread
>          */
>         spin_lock(&pers_lock);
> +       thread = *threadp;
> +       if (!thread) {
> +               spin_unlock(&pers_lock);
> +               return;
> +       }
>         *threadp = NULL;
>         spin_unlock(&pers_lock);
>
> +       pr_debug("interrupting MD-thread pid %d\n", task_pid_nr(thread->tsk));
>         kthread_stop(thread->tsk);
>         kfree(thread);
>  }
> --
> 2.31.1
>
