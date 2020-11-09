Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 724AAC2D0A3
	for <linux-raid@archiver.kernel.org>; Mon,  9 Nov 2020 18:01:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 22C212067D
	for <linux-raid@archiver.kernel.org>; Mon,  9 Nov 2020 18:01:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="KI0Fu4kh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729942AbgKISBn (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 9 Nov 2020 13:01:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:48338 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729869AbgKISBn (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Mon, 9 Nov 2020 13:01:43 -0500
Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com [209.85.167.45])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0EF8D2068D
        for <linux-raid@vger.kernel.org>; Mon,  9 Nov 2020 18:01:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604944902;
        bh=VVHkePakr+D7gqtdQssyiGsqJdNgF8mrPx+ABKzzq/I=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=KI0Fu4khl1APc8qW5dJsgt0LzDLI2NWkkHREvYl+pnux29xFPni9ENLqt1Bfl/+AI
         B9KDU3Si674a9BFPl6z7DI/xXl1NZgtf3ubdigPeHf9KfVTVmLCVcQeKIH2vMXSULj
         cjHbPvq3hSmOeg16wh/KNmIC1+6SIFfnTsRHppVI=
Received: by mail-lf1-f45.google.com with SMTP id s30so13708456lfc.4
        for <linux-raid@vger.kernel.org>; Mon, 09 Nov 2020 10:01:41 -0800 (PST)
X-Gm-Message-State: AOAM532Eh/18JyY7xelZID9UtuvOPDzJcWe6vPhpV5mvQ+OZZPMYv9ti
        2jsLEHLWKR8N3Lc675jf1eanoQEP6kEMUQb9aNM=
X-Google-Smtp-Source: ABdhPJzTM9TRdodl/+26qXIfdzCE4Yw8ZmLGbTyQ9q5nBA6pEi0CNnmY2R7d9++VKOROBkNqL/cj2405+DVtev5QI34=
X-Received: by 2002:a19:ae13:: with SMTP id f19mr5791268lfc.193.1604944900197;
 Mon, 09 Nov 2020 10:01:40 -0800 (PST)
MIME-Version: 1.0
References: <1604847181-22086-1-git-send-email-heming.zhao@suse.com> <1604847181-22086-2-git-send-email-heming.zhao@suse.com>
In-Reply-To: <1604847181-22086-2-git-send-email-heming.zhao@suse.com>
From:   Song Liu <song@kernel.org>
Date:   Mon, 9 Nov 2020 10:01:29 -0800
X-Gmail-Original-Message-ID: <CAPhsuW7PpYV4ZKm2y7Fm04_0qjAOSn7jka3+i-gggj8qr3MNHg@mail.gmail.com>
Message-ID: <CAPhsuW7PpYV4ZKm2y7Fm04_0qjAOSn7jka3+i-gggj8qr3MNHg@mail.gmail.com>
Subject: Re: [PATCH 1/2] md/cluster: reshape should returns error when remote
 doing resyncing job
To:     Zhao Heming <heming.zhao@suse.com>
Cc:     linux-raid <linux-raid@vger.kernel.org>,
        Guoqing Jiang <guoqing.jiang@cloud.ionos.com>,
        lidong.zhong@suse.com, Xiao Ni <xni@redhat.com>,
        NeilBrown <neilb@suse.de>, Coly Li <colyli@suse.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Sun, Nov 8, 2020 at 6:53 AM Zhao Heming <heming.zhao@suse.com> wrote:
>
[...]

> How to fix:
>
> The simple & clear solution is block the reshape action in initiator
> side. When node is executing "--grow" and detecting there is ongoing
> resyncing, it should immediately return & report error to user space.
>
> Signed-off-by: Zhao Heming <heming.zhao@suse.com>

The code looks good to me. But please revise the commit log as something
similar to the following.

========================== 8< ==========================
md/cluster: block reshape requests with resync job initiated from remote node

In cluster env, a node can start resync job when the resync cmd was executed
on a different node. Reshape requests should be blocked for resync job initiated
by any node. Current code only <condition to block reshape requests>.
This results
in a dead lock in <condition> (see repro steps below). Fix this by <adding the
extra check>.

Repro steps:
...
========================== 8< ==========================

In this way, whoever reading the commit log, which could be yourself in 2021,
will understand the primary goal of this change quickly.

Does this make sense?

Thanks,
Song

> ---
>  drivers/md/md.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 98bac4f304ae..74280e353b8f 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -7278,6 +7278,7 @@ static int update_raid_disks(struct mddev *mddev, int raid_disks)
>                 return -EINVAL;
>         if (mddev->sync_thread ||
>             test_bit(MD_RECOVERY_RUNNING, &mddev->recovery) ||
> +               test_bit(MD_RESYNCING_REMOTE, &mddev->recovery) ||
>             mddev->reshape_position != MaxSector)
>                 return -EBUSY;
>
> @@ -9662,8 +9663,11 @@ static void check_sb_changes(struct mddev *mddev, struct md_rdev *rdev)
>                 }
>         }
>
> -       if (mddev->raid_disks != le32_to_cpu(sb->raid_disks))
> -               update_raid_disks(mddev, le32_to_cpu(sb->raid_disks));
> +       if (mddev->raid_disks != le32_to_cpu(sb->raid_disks)) {
> +               ret = update_raid_disks(mddev, le32_to_cpu(sb->raid_disks));
> +               if (ret)
> +                       pr_warn("md: updating array disks failed. %d\n", ret);
> +       }
>
>         /*
>          * Since mddev->delta_disks has already updated in update_raid_disks,
> --
> 2.27.0
>
