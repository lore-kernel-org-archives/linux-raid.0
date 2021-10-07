Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0020C433FE
	for <linux-raid@archiver.kernel.org>; Thu,  7 Oct 2021 06:26:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7EF7F61262
	for <linux-raid@archiver.kernel.org>; Thu,  7 Oct 2021 06:26:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232454AbhJGG15 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 7 Oct 2021 02:27:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:58250 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232418AbhJGG14 (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Thu, 7 Oct 2021 02:27:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6493E61260
        for <linux-raid@vger.kernel.org>; Thu,  7 Oct 2021 06:26:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633587963;
        bh=bJJMo4QsucR/+WfA1XsWxH78ecgszN4c6hUg7SNUXQw=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=iX0/YQhnEV9CrBOR397B+c+Fu2KGJ4qyGzGSdsuD1XiKCSBS09/BM6hkYeuAXoSuT
         0BDSbRc9cRgCTgbvaddRpovp+JzBEG2I2aljXNFNhDP5lCZ4C/tmcoLqC89AB95etB
         fAmAO1qtE62CwWKuai0mPV7XHLqFAEoZ5e8lfUHXxLLjDt7XjCgyJlULdKOyWrpz+D
         ErHWELeTEufpoED3ioz5CsWpV5rP0JNHj+4s6cO/SEejNxq/IGJGMejebHpJMBnB+P
         1Bpr7kOyXhFYPXtVwJFHR14abHZG0BNS8Z5w9H99FycQudWmLRE0DKGCb8c70u8Wd2
         40tsrm64HR5EQ==
Received: by mail-lf1-f49.google.com with SMTP id r19so19347668lfe.10
        for <linux-raid@vger.kernel.org>; Wed, 06 Oct 2021 23:26:03 -0700 (PDT)
X-Gm-Message-State: AOAM532qz3gYJH7THICRdNInnRprs6obOMkJtD1U2wtdFCXIf9qHF6i+
        2M1euwUYgMpzydCmkoDEUWF3Dqvg3Wl9ssrz2vo=
X-Google-Smtp-Source: ABdhPJzs4hu98UsF4rmmuiQH05Qe/DMRUCn9VCbYkNmyRvJmCqSteqcDKYO9TElCExBIfJO3JZmmPGwI2ICdXYldhJM=
X-Received: by 2002:ac2:41d4:: with SMTP id d20mr2538657lfi.598.1633587961799;
 Wed, 06 Oct 2021 23:26:01 -0700 (PDT)
MIME-Version: 1.0
References: <20211004153453.14051-1-guoqing.jiang@linux.dev> <20211004153453.14051-3-guoqing.jiang@linux.dev>
In-Reply-To: <20211004153453.14051-3-guoqing.jiang@linux.dev>
From:   Song Liu <song@kernel.org>
Date:   Wed, 6 Oct 2021 23:25:50 -0700
X-Gmail-Original-Message-ID: <CAPhsuW58FyoNgttdXiPUoCdA9Rfr8+yeq4xe9GdGp2F8+2b+OA@mail.gmail.com>
Message-ID: <CAPhsuW58FyoNgttdXiPUoCdA9Rfr8+yeq4xe9GdGp2F8+2b+OA@mail.gmail.com>
Subject: Re: [PATCH 2/6] md/bitmap: don't set max_write_behind if there is no
 write mostly device
To:     Guoqing Jiang <guoqing.jiang@linux.dev>
Cc:     linux-raid <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Mon, Oct 4, 2021 at 8:40 AM Guoqing Jiang <guoqing.jiang@linux.dev> wrote:
>
> We shouldn't set it since write behind IO should only happen to write
> mostly device.
>
> Signed-off-by: Guoqing Jiang <guoqing.jiang@linux.dev>
> ---
>  drivers/md/md-bitmap.c | 17 +++++++++++++++++
>  1 file changed, 17 insertions(+)
>
> diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
> index e29c6298ef5c..0346281b1555 100644
> --- a/drivers/md/md-bitmap.c
> +++ b/drivers/md/md-bitmap.c
> @@ -2469,11 +2469,28 @@ backlog_store(struct mddev *mddev, const char *buf, size_t len)
>  {
>         unsigned long backlog;
>         unsigned long old_mwb = mddev->bitmap_info.max_write_behind;
> +       struct md_rdev *rdev;
> +       bool has_write_mostly = false;
>         int rv = kstrtoul(buf, 10, &backlog);
>         if (rv)
>                 return rv;
>         if (backlog > COUNTER_MAX)
>                 return -EINVAL;
> +
> +       /*
> +        * Without write mostly device, it doesn't make sense to set
> +        * backlog for max_write_behind.
> +        */
> +       rdev_for_each(rdev, mddev)
> +               if (test_bit(WriteMostly, &rdev->flags)) {
> +                       has_write_mostly = true;
> +                       break;
> +               }
> +       if (!has_write_mostly) {
> +               pr_warn_ratelimited("md: No write mostly device available\n");

Most of these _store functions do not print warnings for invalid changes. So
I am not sure whether we want to add this one. If we do want it, we should
make it clear, as
"md: No write mostly device available. Cannot set backlog\n".
We may also add the device name there.

Thanks,
Song

> +               return -EINVAL;
> +       }
> +
>         mddev->bitmap_info.max_write_behind = backlog;
>         if (!backlog && mddev->serial_info_pool) {
>                 /* serial_info_pool is not needed if backlog is zero */
> --
> 2.31.1
>
