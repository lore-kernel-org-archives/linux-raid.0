Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D40CC433EF
	for <linux-raid@archiver.kernel.org>; Wed,  2 Feb 2022 06:57:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233883AbiBBG5w (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 2 Feb 2022 01:57:52 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:47400 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229518AbiBBG5v (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 2 Feb 2022 01:57:51 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5CE5A6173B
        for <linux-raid@vger.kernel.org>; Wed,  2 Feb 2022 06:57:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B24EAC340EC
        for <linux-raid@vger.kernel.org>; Wed,  2 Feb 2022 06:57:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643785070;
        bh=3nNGpIKWAShvhxmRkjg9ACNEoKryUARsN4tAkpqWqiE=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=esV+m+VFWb6Hq4lhgAKsMjZKp0l5TH9brpU54JQQY3yo7SXw7dl+KiVdsUchymHfl
         mbsiF9ibVMXBcBEP+LS5JVW6eub5btk656rnoMW1KV08Cg54oULe9OFf0q9bkCIjtY
         0UBhtyzQ3E3YVl7zUzaVGnSBMfDttbdaXEVcdumcpEjTlQlKTAt8IO+WIZljIJ3hHI
         ZwyvXo/JX5r5JSeEr/yPU177U2gXrP4MSKWxOO6sbSQuLrO2J+pZ9VK1f0GP3TRjtM
         1FU/5Syrn1dDwzZBYBmuIA7pNf1kP4kQ5Xdy1t6npcEhZTT4y4FDbdgMdplnCBO6do
         XA5opE2JkKePw==
Received: by mail-yb1-f181.google.com with SMTP id m6so58052597ybc.9
        for <linux-raid@vger.kernel.org>; Tue, 01 Feb 2022 22:57:50 -0800 (PST)
X-Gm-Message-State: AOAM533XKS6SiSUQ7UwDE9HUME/v16K3GMIp9PJ7EhPHc9D8jGfb5tab
        mgICywtjxTc+xCzfmFCrvgo/Fk6T9RwHwhhLnvA=
X-Google-Smtp-Source: ABdhPJzcMhFYGmRTcy9UjZ4py9L/SKUguv94oU9jn7X/ehFkXLf228/Ba7nxH5UJVHBfbTSNmfeQmrmHgK1JPXPVvVo=
X-Received: by 2002:a25:27c8:: with SMTP id n191mr10213060ybn.670.1643785069826;
 Tue, 01 Feb 2022 22:57:49 -0800 (PST)
MIME-Version: 1.0
References: <a673c90f-d9eb-c6d5-b675-e6c2e1c04e5f@totally.rip>
In-Reply-To: <a673c90f-d9eb-c6d5-b675-e6c2e1c04e5f@totally.rip>
From:   Song Liu <song@kernel.org>
Date:   Tue, 1 Feb 2022 22:57:39 -0800
X-Gmail-Original-Message-ID: <CAPhsuW5H1uROu868FhS5MNXuP=nS_=6b8zUrFv4jBjPEA=joPQ@mail.gmail.com>
Message-ID: <CAPhsuW5H1uROu868FhS5MNXuP=nS_=6b8zUrFv4jBjPEA=joPQ@mail.gmail.com>
Subject: Re: NULL pointer dereference in blk_queue_flag_set
To:     jkhsjdhjs <jkhsjdhjs@totally.rip>
Cc:     linux-raid <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Leon,

On Tue, Feb 1, 2022 at 2:15 PM jkhsjdhjs <jkhsjdhjs@totally.rip> wrote:
>
> Dear Song Liu,
>
> my kernel (5.17-rc2) experiences a NULL pointer dereference when
> activating an LDM (Windows Logical Disk Manager) on Arch Linux using
> ldmtool [1]. I have attached the relevant excerpt of dmesg. This bug
> causes my LDM RAID to fail activating (see ldmtool-status.txt and
> lsblk.txt). Since this worked fine with 5.16 I bisected the kernel and
> found, that commit f51d46d0e7cb5b8494aa534d276a9d8915a2443d [2]
> introduced the issue.
>
> I'm not sure what else to add, if there's more information I can
> provide, please tell me. Otherwise I'll happily assist in fixing this
> issue - if there's something I can do.

Thanks for the report! And sorry for the bug.

For the next step, could you please test whether the following change
fixes the issue?

Best,
Song

diff --git i/drivers/md/md.c w/drivers/md/md.c
index 854cbf4234aa..18e987c644c6 100644
--- i/drivers/md/md.c
+++ w/drivers/md/md.c
@@ -5868,10 +5868,6 @@ int md_run(struct mddev *mddev)
                nowait = nowait && blk_queue_nowait(bdev_get_queue(rdev->bdev));
        }

-       /* Set the NOWAIT flags if all underlying devices support it */
-       if (nowait)
-               blk_queue_flag_set(QUEUE_FLAG_NOWAIT, mddev->queue);
-
        if (!bioset_initialized(&mddev->bio_set)) {
                err = bioset_init(&mddev->bio_set, BIO_POOL_SIZE, 0,
BIOSET_NEED_BVECS);
                if (err)
@@ -6009,6 +6005,10 @@ int md_run(struct mddev *mddev)
                else
                        blk_queue_flag_clear(QUEUE_FLAG_NONROT, mddev->queue);
                blk_queue_flag_set(QUEUE_FLAG_IO_STAT, mddev->queue);
+
+               /* Set the NOWAIT flags if all underlying devices support it */
+               if (nowait)
+                       blk_queue_flag_set(QUEUE_FLAG_NOWAIT, mddev->queue);
        }
        if (pers->sync_request) {
                if (mddev->kobj.sd &&
