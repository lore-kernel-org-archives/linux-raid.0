Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66A6BC433F5
	for <linux-raid@archiver.kernel.org>; Sat, 25 Dec 2021 02:14:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229469AbhLYCOT (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 24 Dec 2021 21:14:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbhLYCOS (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 24 Dec 2021 21:14:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74513C061401
        for <linux-raid@vger.kernel.org>; Fri, 24 Dec 2021 18:14:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 49492B82358
        for <linux-raid@vger.kernel.org>; Sat, 25 Dec 2021 02:14:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20B94C36AEA
        for <linux-raid@vger.kernel.org>; Sat, 25 Dec 2021 02:14:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640398456;
        bh=HnSEy5ETxT1TzOv6YWf+AU0Ld/INn79dQF45I0Ew1gc=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=avFva7O5qXCoD6kcyI3L3ll2g22+5h/Ee6K4ROKBXcR13izVm5mp/pVOqictf1FHY
         Br4z8tVy/OjENfLTidx12tgMTpPW1h/Iar1yKcBT6XTVzlEq5zwzManOvEAIF+IRxK
         cegMxjD8tiZPv7JewSmWJZ0PiURStISk33xWxfbZPh4dexR75anOyZDyf6oMITw5mK
         6f22TfGmZVtPSLJvu7pj7wBsg6MjzfsUZeEJxvZ2MXnC/KSI8JUGf4tjrxILiCWyPT
         sFJdzCR9FiTj/miVZJVyVMW39zGTqNuRKmFulZ73VrUnxYQJcOXkejrfF9dr3ppXs1
         KWni+n5xcyF+g==
Received: by mail-yb1-f174.google.com with SMTP id k69so11697538ybf.1
        for <linux-raid@vger.kernel.org>; Fri, 24 Dec 2021 18:14:16 -0800 (PST)
X-Gm-Message-State: AOAM532GapWgPSEUz+NHpamKzaLB5dpAHcmYnOHELE/deDdlcMVAi4s8
        hwDW8d5Ml+XGsZGwA7JS/lVweM4djnOQ0JawfrE=
X-Google-Smtp-Source: ABdhPJy1Oy/+Awekv+5ngJ9OjPm4SGthz/wqJuC8jXFaBFVlsgzK4XpBJ1EeGCiZKZenZE5rRTJtAXLijmk1rkgiU8k=
X-Received: by 2002:a25:3fc5:: with SMTP id m188mr4847379yba.282.1640398455203;
 Fri, 24 Dec 2021 18:14:15 -0800 (PST)
MIME-Version: 1.0
References: <f5b0b47f-cf0b-f74a-b8b6-80aeaa9b400d@digitalocean.com>
 <20211221200622.29795-1-vverma@digitalocean.com> <20211221200622.29795-4-vverma@digitalocean.com>
In-Reply-To: <20211221200622.29795-4-vverma@digitalocean.com>
From:   Song Liu <song@kernel.org>
Date:   Fri, 24 Dec 2021 18:14:04 -0800
X-Gmail-Original-Message-ID: <CAPhsuW6ugK+6fcA9d4Jkx8+i9=1cMfrfJE7ZY4WH6TKrWLxP=g@mail.gmail.com>
Message-ID: <CAPhsuW6ugK+6fcA9d4Jkx8+i9=1cMfrfJE7ZY4WH6TKrWLxP=g@mail.gmail.com>
Subject: Re: [PATCH v6 4/4] md: raid456 add nowait support
To:     Vishal Verma <vverma@digitalocean.com>
Cc:     linux-raid <linux-raid@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>, rgoldwyn@suse.de
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Tue, Dec 21, 2021 at 12:06 PM Vishal Verma <vverma@digitalocean.com> wrote:
>
> Returns EAGAIN in case the raid456 driver would block
> waiting for situations like:
>
>   - Reshape operation,
>   - Discard operation.
>
> Signed-off-by: Vishal Verma <vverma@digitalocean.com>

I think we will need the following fix for raid456:

============================ 8< ============================

diff --git i/drivers/md/raid5.c w/drivers/md/raid5.c
index 6ab22f29dacd..55d372ce3300 100644
--- i/drivers/md/raid5.c
+++ w/drivers/md/raid5.c
@@ -5717,6 +5717,7 @@ static void make_discard_request(struct mddev
*mddev, struct bio *bi)
                        raid5_release_stripe(sh);
                        /* Bail out if REQ_NOWAIT is set */
                        if (bi->bi_opf & REQ_NOWAIT) {
+                               finish_wait(&conf->wait_for_overlap, &w);
                                bio_wouldblock_error(bi);
                                return;
                        }
@@ -5734,6 +5735,7 @@ static void make_discard_request(struct mddev
*mddev, struct bio *bi)
                                raid5_release_stripe(sh);
                                /* Bail out if REQ_NOWAIT is set */
                                if (bi->bi_opf & REQ_NOWAIT) {
+
finish_wait(&conf->wait_for_overlap, &w);
                                        bio_wouldblock_error(bi);
                                        return;
                                }
@@ -5829,7 +5831,6 @@ static bool raid5_make_request(struct mddev
*mddev, struct bio * bi)
        last_sector = bio_end_sector(bi);
        bi->bi_next = NULL;

-       md_account_bio(mddev, &bi);
        /* Bail out if REQ_NOWAIT is set */
        if ((bi->bi_opf & REQ_NOWAIT) &&
            (conf->reshape_progress != MaxSector) &&
@@ -5837,9 +5838,11 @@ static bool raid5_make_request(struct mddev
*mddev, struct bio * bi)
            ? (logical_sector > conf->reshape_progress &&
logical_sector <= conf->reshape_safe)
            : (logical_sector >= conf->reshape_safe && logical_sector
< conf->reshape_progress))) {
                bio_wouldblock_error(bi);
+               if (rw == WRITE)
+                       md_write_end(mddev);
                return true;
        }
-
+       md_account_bio(mddev, &bi);
        prepare_to_wait(&conf->wait_for_overlap, &w, TASK_UNINTERRUPTIBLE);
        for (; logical_sector < last_sector; logical_sector +=
RAID5_STRIPE_SECTORS(conf)) {
                int previous;

============================ 8< ============================

Vishal, please try to trigger all these conditions (including raid1,
raid10) and make sure
they work properly.

For example, I triggered raid5 reshape and used something like the
following to make
sure the logic is triggered:

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 55d372ce3300..e79de48a0027 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -5840,6 +5840,11 @@ static bool raid5_make_request(struct mddev
*mddev, struct bio * bi)
                bio_wouldblock_error(bi);
                if (rw == WRITE)
                        md_write_end(mddev);
+               {
+                       static int count = 0;
+                       if (count++ < 10)
+                               pr_info("%s REQ_NOWAIT return\n", __func__);
+               }
                return true;
        }
        md_account_bio(mddev, &bi);

Thanks,
Song
