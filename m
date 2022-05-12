Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2336CC4332F
	for <linux-raid@archiver.kernel.org>; Thu, 12 May 2022 16:26:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356452AbiELQ0i (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 12 May 2022 12:26:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356471AbiELQ0P (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 12 May 2022 12:26:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F2DD1D0C0
        for <linux-raid@vger.kernel.org>; Thu, 12 May 2022 09:26:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DDD9961FC0
        for <linux-raid@vger.kernel.org>; Thu, 12 May 2022 16:26:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 486C4C34100
        for <linux-raid@vger.kernel.org>; Thu, 12 May 2022 16:26:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652372773;
        bh=SDd7uldEo9wEuFrc0sb/P5IBpSG8j4kl7ls5k21WzDw=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=GIlQwUGRKuYax/mO26p7FV1W4fnsAeT2QTWgszcK/q+++AVXNZxElMRXX3ri6W+Y1
         hdpk7lf3KBsfGKEcHch5wuEhorZQGkpG7yt8R1TasSfktV1GaiqTigMOsFy/s765DR
         jVJC8eIrYRtL0zq4guJrc5NxCuQAO/ZLVJE8Fmk/HdWmF3dytHACPc0kN6y4AaAQdx
         Mr586YIAruZWnYfSkN/1r3eJvf13kRyj2RfuC+4aOPNJVGkqvkLZPXv/vCGSeJGsBx
         J9jeSEuxvIy4VCwk1WjwEyYbKyZ95ztvJbCtmE4KUQyf/Zm512sNfQaZ0yPtTAIuHZ
         Z4fjrct3OYU4A==
Received: by mail-yb1-f175.google.com with SMTP id x17so10771259ybj.3
        for <linux-raid@vger.kernel.org>; Thu, 12 May 2022 09:26:13 -0700 (PDT)
X-Gm-Message-State: AOAM5307IOerIUYynwAHf7mdACjPhFZGZKWFQc5+T9P5T+3XE44twxiq
        W2M3QnEM/t3qAifQ+jJ1VB+pCS1M/izqYPXbfqQ=
X-Google-Smtp-Source: ABdhPJwSQtQVryjbO4NPxkA0Fkez+S6ncU87DduDhEDbfDFp4ZZCJ7LJkN2NP0m+QmdaeR0Lx91tQKKZMxhX7E4TU30=
X-Received: by 2002:a25:d9d5:0:b0:648:e2a8:c4f2 with SMTP id
 q204-20020a25d9d5000000b00648e2a8c4f2mr637820ybg.322.1652372772331; Thu, 12
 May 2022 09:26:12 -0700 (PDT)
MIME-Version: 1.0
References: <20220512092109.41606-1-xni@redhat.com> <20220512092109.41606-3-xni@redhat.com>
In-Reply-To: <20220512092109.41606-3-xni@redhat.com>
From:   Song Liu <song@kernel.org>
Date:   Thu, 12 May 2022 09:26:01 -0700
X-Gmail-Original-Message-ID: <CAPhsuW6i5yGj1dKD4uCTym8HCYhveb0MYtBnB8uyPyHer0+kSw@mail.gmail.com>
Message-ID: <CAPhsuW6i5yGj1dKD4uCTym8HCYhveb0MYtBnB8uyPyHer0+kSw@mail.gmail.com>
Subject: Re: [PATCH 2/2] md: Double free io_acct_set bioset
To:     Xiao Ni <xni@redhat.com>
Cc:     linux-raid <linux-raid@vger.kernel.org>,
        Nigel Croxon <ncroxon@redhat.com>,
        Heinz Mauelshagen <heinzm@redhat.com>,
        Fine Fan <ffan@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Thu, May 12, 2022 at 2:21 AM Xiao Ni <xni@redhat.com> wrote:
>
> Now io_acct_set is alloc and free in personality. Remove the codes that
> free io_acct_set in md_free and md_stop.
>
> Fixes: 0c031fd37f69 (md: Move alloc/free acct bioset in to personality)
> Signed-off-by: Xiao Ni <xni@redhat.com>

Applied the set to md-next. Changed the subject of 2/2 as
 md: *fix* double free of io_acct_set bioset

Thanks,
Song

> ---
>  drivers/md/md.c | 4 ----
>  1 file changed, 4 deletions(-)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 53787a32166d..91c6cb3da470 100644
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
> --
> 2.32.0 (Apple Git-132)
>
