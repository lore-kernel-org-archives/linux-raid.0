Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33D33C433F5
	for <linux-raid@archiver.kernel.org>; Fri,  8 Apr 2022 00:16:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232787AbiDHAS6 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 7 Apr 2022 20:18:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230079AbiDHAS4 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 7 Apr 2022 20:18:56 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3253C26ACF
        for <linux-raid@vger.kernel.org>; Thu,  7 Apr 2022 17:16:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 57653CE0A36
        for <linux-raid@vger.kernel.org>; Fri,  8 Apr 2022 00:16:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FB84C385A5
        for <linux-raid@vger.kernel.org>; Fri,  8 Apr 2022 00:16:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649377011;
        bh=XVKr66To61u270zRQi35Uk+XOnmxnI4aasdsoxVKasg=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=B34q5nIF7ad2QzuMRHHDx3U5nIP3Iemlfs69OP5JgFAv1WnZ2JMIyAewFgXAb9LLT
         LKOC09DLi55DTzbyTKBL6GYijdpiSAbU8AGlbSIS54lpLNCDwhZJIFsVdZw7AdS/sO
         5idW5GLkWmvyUchZXSr2i0hJHs282KnK3gKTYvDihTV1BRBSvmxkgys3qggMfTelIe
         uiGNuCEQm6cBmbCqyxlHwCGX2NDu5qDzt0SkOuI1QqMM8aVqjoZMVry38IPMNoUMKf
         qFFlLXjfMAT9PVBs/BVtuzzyExoOb6KtHLdPP/FB7mTC0jk+ypM+LGMYCNEXZi4mP6
         aG6VgtXyRkYAw==
Received: by mail-yb1-f176.google.com with SMTP id r5so2675356ybd.8
        for <linux-raid@vger.kernel.org>; Thu, 07 Apr 2022 17:16:51 -0700 (PDT)
X-Gm-Message-State: AOAM531d9FMOCyBQWAo8lkzKfzKy7LTdRbMU8FCvezPbkqSKKHb1mgGw
        hMaEsMLKP2Cu9HqqT9AqpxauYyARDLUU/Y4z4Mw=
X-Google-Smtp-Source: ABdhPJxYb3bz1DZuDhXalcsoJltmsLg0HOrIsZDSdf++sgXmkbTgqMqEKlEQX5m4c5BFXnPQ2X/KF8gWpSxYwZ7DrsM=
X-Received: by 2002:a05:6902:1026:b0:63d:cb9f:6e03 with SMTP id
 x6-20020a056902102600b0063dcb9f6e03mr12348799ybt.9.1649377010446; Thu, 07 Apr
 2022 17:16:50 -0700 (PDT)
MIME-Version: 1.0
References: <20220322152339.11892-1-mariusz.tkaczyk@linux.intel.com> <20220322152339.11892-2-mariusz.tkaczyk@linux.intel.com>
In-Reply-To: <20220322152339.11892-2-mariusz.tkaczyk@linux.intel.com>
From:   Song Liu <song@kernel.org>
Date:   Thu, 7 Apr 2022 17:16:37 -0700
X-Gmail-Original-Message-ID: <CAPhsuW6dgAHAFhTwPFZOz8=uxPU9V5H=+hzNY3dXyNxtcr+PMw@mail.gmail.com>
Message-ID: <CAPhsuW6dgAHAFhTwPFZOz8=uxPU9V5H=+hzNY3dXyNxtcr+PMw@mail.gmail.com>
Subject: Re: [PATCH 1/3] raid0, linear, md: add error_handlers for raid0 and linear
To:     Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Cc:     linux-raid <linux-raid@vger.kernel.org>,
        Guoqing Jiang <guoqing.jiang@linux.dev>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Tue, Mar 22, 2022 at 8:24 AM Mariusz Tkaczyk
<mariusz.tkaczyk@linux.intel.com> wrote:
>
> Patch 62f7b1989c0 ("md raid0/linear: Mark array as 'broken' and fail BIOs
> if a member is gone") allowed to finish writes earlier (before level
> dependent actions) for non-redundant arrays.
>
> To achieve that MD_BROKEN is added to mddev->flags if drive disappearance
> is detected. This is done in is_mddev_broken() which is confusing and not
> consistent with other levels where error_handler() is used.
> This patch adds appropriate error_handler for raid0 and linear and adopt
> md_error() to the change.
>
> Usage of error_handler causes that disk failure can be requested from
> userspace. User can fail the array via #mdadm --set-faulty command. This
> is not safe and will be fixed in mdadm. It is correctable because failed
> state is not recorded in the metadata. After next assembly array will be
> read-write again. For safety reason is better to keep MD_BROKEN in
> runtime only.
>
> Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>

Sorry for the late response.

> ---
>  drivers/md/md-linear.c | 14 +++++++++++++-
>  drivers/md/md.c        |  6 +++++-
>  drivers/md/md.h        | 10 ++--------
>  drivers/md/raid0.c     | 14 +++++++++++++-
>  4 files changed, 33 insertions(+), 11 deletions(-)
>
> diff --git a/drivers/md/md-linear.c b/drivers/md/md-linear.c
> index 1ff51647a682..c33cd28f1dba 100644
> --- a/drivers/md/md-linear.c
> +++ b/drivers/md/md-linear.c
> @@ -233,7 +233,8 @@ static bool linear_make_request(struct mddev *mddev, struct bio *bio)
>                      bio_sector < start_sector))
>                 goto out_of_bounds;
>
> -       if (unlikely(is_mddev_broken(tmp_dev->rdev, "linear"))) {
> +       if (unlikely(is_rdev_broken(tmp_dev->rdev))) {
> +               md_error(mddev, tmp_dev->rdev);

I apologize if we discussed this before. Shall we just call linear_error()
here?If we go this way, we don't really need ...

>                 bio_io_error(bio);
>                 return true;
>         }
> @@ -281,6 +282,16 @@ static void linear_status (struct seq_file *seq, struct mddev *mddev)
>         seq_printf(seq, " %dk rounding", mddev->chunk_sectors / 2);
>  }
>
> +static void linear_error(struct mddev *mddev, struct md_rdev *rdev)
> +{
> +       if (!test_and_set_bit(MD_BROKEN, &mddev->flags)) {
> +               char *md_name = mdname(mddev);
> +
> +               pr_crit("md/linear%s: Disk failure on %pg detected, failing array.\n",
> +                       md_name, rdev->bdev);
> +       }
> +}
> +
>  static void linear_quiesce(struct mddev *mddev, int state)
>  {
>  }
> @@ -297,6 +308,7 @@ static struct md_personality linear_personality =
>         .hot_add_disk   = linear_add,
>         .size           = linear_size,
>         .quiesce        = linear_quiesce,
> +       .error_handler  = linear_error,

... set error_handler here, and ...

>  };
>
>  static int __init linear_init (void)
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 0a89f072dae0..3354afc9d2a3 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -7985,7 +7985,11 @@ void md_error(struct mddev *mddev, struct md_rdev *rdev)
>
>         if (!mddev->pers || !mddev->pers->error_handler)
>                 return;
> -       mddev->pers->error_handler(mddev,rdev);
> +       mddev->pers->error_handler(mddev, rdev);
> +
> +       if (mddev->pers->level == 0 || mddev->pers->level == LEVEL_LINEAR)
> +               return;

... this check here.

Did I miss something?

Thanks,
Song

[...]
