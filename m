Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11D98C433E0
	for <linux-raid@archiver.kernel.org>; Thu, 11 Feb 2021 07:29:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C524464E74
	for <linux-raid@archiver.kernel.org>; Thu, 11 Feb 2021 07:29:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229469AbhBKH3F (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 11 Feb 2021 02:29:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:57180 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229451AbhBKH3E (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Thu, 11 Feb 2021 02:29:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7A39E64E77
        for <linux-raid@vger.kernel.org>; Thu, 11 Feb 2021 07:28:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613028503;
        bh=00fzMIXmjYi+3i2nawB8u4ocE2qlSuAO1fpMK/KsmTM=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=uYWfGxQ2v/oNSKnAnrdAkOsOtQ/MJypdvgo/9iQYZhzGvkMLhQFXM3OzTvWU6Z8k0
         Qad47BVkmFrtwnUXFAmYkh53MKVcntHjsN2nJkS8Onm5snC/wx1k/vKifQGHvpDgt6
         TPP093ewHiNVByU4Jyful2JarFsDGHyByr+NI0qqEBQ1zzv72zlW9Ze7W/k6ry4XgK
         aTdPzuHBougNjiOyKP2VaxQK/7jSLtREP6WtfyWKxHxWHYuKkapWoiKse6Nyr72APe
         tMPdEWMKSquuRL3o/7ulzAktRr+5p40IS3OPmEQtD6xZjqhgUCEp+EG84dlJ9bZZ2/
         HtHl9mjnRPgvw==
Received: by mail-lj1-f176.google.com with SMTP id x7so4381487ljc.5
        for <linux-raid@vger.kernel.org>; Wed, 10 Feb 2021 23:28:23 -0800 (PST)
X-Gm-Message-State: AOAM531Sk+goP7RAn1OT1LyRuZBRTsVWR/HVXudFAeI8jfaJKb8XrWFB
        0106e61Yk3q5Em8HOkkM1J8iErvztspusHzQuHo=
X-Google-Smtp-Source: ABdhPJzrDuMyfA84bXB8LbkXHBe7OqyrGTZvzfnRkcBBswC/Dg18hqY1DN2eY3LkPeoD/X10FHGVsoXlPIQLwaScb+c=
X-Received: by 2002:a2e:9898:: with SMTP id b24mr4334713ljj.344.1613028501795;
 Wed, 10 Feb 2021 23:28:21 -0800 (PST)
MIME-Version: 1.0
References: <1612923676-18294-1-git-send-email-guoqing.jiang@cloud.ionos.com>
In-Reply-To: <1612923676-18294-1-git-send-email-guoqing.jiang@cloud.ionos.com>
From:   Song Liu <song@kernel.org>
Date:   Wed, 10 Feb 2021 23:28:10 -0800
X-Gmail-Original-Message-ID: <CAPhsuW5ZU2fpP1smSodKWFCqLu4J91sWqY6DC7ppQ=3VvJM+eQ@mail.gmail.com>
Message-ID: <CAPhsuW5ZU2fpP1smSodKWFCqLu4J91sWqY6DC7ppQ=3VvJM+eQ@mail.gmail.com>
Subject: Re: [PATCH] md: don't unregister sync_thread with reconfig_mutex held
To:     Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
Cc:     linux-raid <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Tue, Feb 9, 2021 at 6:22 PM Guoqing Jiang
<guoqing.jiang@cloud.ionos.com> wrote:
>
> Unregister sync_thread doesn't need to hold reconfig_mutex since it
> doesn't reconfigure array.
>
> And it could cause deadlock problem for raid5 as follows:
>
> 1. process A tried to reap sync thread with reconfig_mutex held after echo
>    idle to sync_action.
> 2. raid5 sync thread was blocked if there were too many active stripes.
> 3. SB_CHANGE_PENDING was set (because of write IO comes from upper layer)
>    which causes the number of active stripes can't be decreased.
> 4. SB_CHANGE_PENDING can't be cleared since md_check_recovery was not able
>    to hold reconfig_mutex.
>
> More details in the link:
> issu://lore.kernel.org/linux-raid/5ed54ffc-ce82-bf66-4eff-390cb23bc1ac@molgen.mpg.de/T/#t
>
> Reported-and-tested-by: Donald Buczek <buczek@molgen.mpg.de>
> Signed-off-by: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>

Thanks for debugging the issue. However, I am not sure whether this is
the proper
fix. For example, would this break dm-raid.c:raid_message()? IIUC,
raid_message()
calls md_reap_sync_thread() without holding reconfigure_mutex, no?

Thanks,
Song

> ---
>  drivers/md/md.c | 5 +++++
>  1 file changed, 5 insertions(+)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index ca40942..eec8c27 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -9365,13 +9365,18 @@ void md_check_recovery(struct mddev *mddev)
>  EXPORT_SYMBOL(md_check_recovery);
>
>  void md_reap_sync_thread(struct mddev *mddev)
> +       __releases(&mddev->reconfig_mutex)
> +       __acquires(&mddev->reconfig_mutex)
> +
>  {
>         struct md_rdev *rdev;
>         sector_t old_dev_sectors = mddev->dev_sectors;
>         bool is_reshaped = false;
>
>         /* resync has finished, collect result */
> +       mddev_unlock(mddev);
>         md_unregister_thread(&mddev->sync_thread);
> +       mddev_lock_nointr(mddev);
>         if (!test_bit(MD_RECOVERY_INTR, &mddev->recovery) &&
>             !test_bit(MD_RECOVERY_REQUESTED, &mddev->recovery) &&
>             mddev->degraded != mddev->raid_disks) {
> --
> 2.7.4
>
