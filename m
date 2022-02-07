Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC08FC433FE
	for <linux-raid@archiver.kernel.org>; Mon,  7 Feb 2022 15:39:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229935AbiBGPid (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 7 Feb 2022 10:38:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233398AbiBGP1n (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 7 Feb 2022 10:27:43 -0500
Received: from mail-il1-x133.google.com (mail-il1-x133.google.com [IPv6:2607:f8b0:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 774A7C0401C1
        for <linux-raid@vger.kernel.org>; Mon,  7 Feb 2022 07:27:39 -0800 (PST)
Received: by mail-il1-x133.google.com with SMTP id z18so11352745ilp.3
        for <linux-raid@vger.kernel.org>; Mon, 07 Feb 2022 07:27:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=digitalocean.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=pVqfPhlZcT84JtUOCIc2KjkVTzP5C+7wK2eQW97bePY=;
        b=JjsiQLF2HXj5yiKncRMtKdgifo1lEkhPKn1sYqNapJ1w9PcD4kjGeYojX+vqLsL6ny
         x1rR+4lTmYxtyqgV1NOLQhBqJW4oFXGAEGhpvT5A6Iwc+2aJyYea/Sj4d3yaXhgW+hgZ
         pqc65eG7ARa3K4fE3bS384kf50e/gibQSvsLg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=pVqfPhlZcT84JtUOCIc2KjkVTzP5C+7wK2eQW97bePY=;
        b=JE9MayrTBtPUqwpU3YWlcu74kAA6+uBIcOZc5TZHNSPR1Ghas/X8FAThuVspPfsDxe
         NEmv9isTs55p9/kZAVIeQV1dAXlDUDSWoEv66MlJUTBnszAFtgwAmwC8mqnB1BrwSd2u
         Nli0y82iCLZC8rlQALRdnIiXDJCcx29GNUBmJirLRVSzs1EcIOBbhDTzW/H2rkYC0RhF
         yT7ftAT8OjVLUn4qjVGjqet4Za5xx+cxYX3VxsAYQ+JdrmDB4l1om2H3EAjLTsLdJl1e
         4arqoHovcjrHd4SdwP7b7Tf3hC4zf40YcsALsMojH1XSYaxcvMM8jHaoxDULdeDl/Ess
         /7dg==
X-Gm-Message-State: AOAM5318aaK8+Dbe+7gyXOlkDnNHnvkVzJojs+I5LrfvQsROMmM6XlS4
        EoDaicfnmBDSVNn5pf10qmwUYHszu7d/KA==
X-Google-Smtp-Source: ABdhPJyWFO9s399Ao+QiarLGeRh//OoZMcCL5cHxnXbA1npCuTtayd9wOeuALPjxtL7SIzA/Ac6Bcw==
X-Received: by 2002:a05:6e02:1527:: with SMTP id i7mr13298ilu.201.1644247658813;
        Mon, 07 Feb 2022 07:27:38 -0800 (PST)
Received: from vverma-s2-cbrunner ([162.243.188.99])
        by smtp.gmail.com with ESMTPSA id y6sm5616738ilj.32.2022.02.07.07.27.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Feb 2022 07:27:38 -0800 (PST)
From:   Vishal Verma <vverma@digitalocean.com>
To:     xni@redhat.com, song@kernel.org
Cc:     linux-raid@vger.kernel.org, Vishal Verma <vverma@digitalocean.com>
Subject: [RFC PATCH] md: raid456 improve discard performance
Date:   Mon,  7 Feb 2022 15:27:35 +0000
Message-Id: <20220207152735.27381-1-vverma@digitalocean.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <CALTww2_ch90DfuEs=U_Epd6=YrPhYR_J3B6E-3B8zBV1Tf3MYg@mail.gmail.com>
References: <CALTww2_ch90DfuEs=U_Epd6=YrPhYR_J3B6E-3B8zBV1Tf3MYg@mail.gmail.com>
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

This patch improves discard performance with raid456 by sending
discard bio directly to the underlying disk just like how raid0/10
handle discard request. Currently, the discard request for raid456
gets sent to the disks on a per stripe basis which involves lots of
bio split/merge and makes it pretty slow performant vs. sending
the requests directly to the disks. This patch is intended to issue
discard request in the  the similar way with patch
29efc390b (md/md0: optimize raid0 discard handling).

Signed-off-by: Vishal Verma <vverma@digitalocean.com>
---
 drivers/md/raid5.c | 182 ++++++++++++++++++++++++---------------------
 1 file changed, 99 insertions(+), 83 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 7c119208a214..a17bc951fb9e 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -5681,93 +5681,110 @@ static void release_stripe_plug(struct mddev *mddev,
 
 static void make_discard_request(struct mddev *mddev, struct bio *bi)
 {
-	struct r5conf *conf = mddev->private;
-	sector_t logical_sector, last_sector;
-	struct stripe_head *sh;
-	int stripe_sectors;
+	struct r5conf *conf = mddev->private;
+	sector_t bio_start, bio_end;
+	unsigned int start_disk_index, end_disk_index;
+	sector_t start_disk_offset, end_disk_offset;
+	sector_t first_stripe_index, last_stripe_index;
+	sector_t split_size;
+	struct bio *split;
+	unsigned int remainder;
+	int d;
+	int stripe_sectors;
+
+	/* We need to handle this when io_uring supports discard/trim */
+	if (WARN_ON_ONCE(bi->bi_opf & REQ_NOWAIT))
+		return;
+
+	/* Skip discard while reshape or resync is happening */
+	if ((mddev->reshape_position != MaxSector) ||
+	    test_bit(MD_RECOVERY_SYNC, &mddev->recovery)) {
+		return;
+	}
 
-	/* We need to handle this when io_uring supports discard/trim */
-	if (WARN_ON_ONCE(bi->bi_opf & REQ_NOWAIT))
-		return;
+	stripe_sectors = conf->chunk_sectors *
+		(conf->raid_disks - conf->max_degraded);
 
-	if (mddev->reshape_position != MaxSector)
-		/* Skip discard while reshape is happening */
+	if (bio_sectors(bi) < stripe_sectors * 2)
 		return;
 
-	logical_sector = bi->bi_iter.bi_sector & ~((sector_t)RAID5_STRIPE_SECTORS(conf)-1);
-	last_sector = bio_end_sector(bi);
-
-	bi->bi_next = NULL;
-
-	stripe_sectors = conf->chunk_sectors *
-		(conf->raid_disks - conf->max_degraded);
-	logical_sector = DIV_ROUND_UP_SECTOR_T(logical_sector,
-					       stripe_sectors);
-	sector_div(last_sector, stripe_sectors);
-
-	logical_sector *= conf->chunk_sectors;
-	last_sector *= conf->chunk_sectors;
-
-	for (; logical_sector < last_sector;
-	     logical_sector += RAID5_STRIPE_SECTORS(conf)) {
-		DEFINE_WAIT(w);
-		int d;
-	again:
-		sh = raid5_get_active_stripe(conf, logical_sector, 0, 0, 0);
-		prepare_to_wait(&conf->wait_for_overlap, &w,
-				TASK_UNINTERRUPTIBLE);
-		set_bit(R5_Overlap, &sh->dev[sh->pd_idx].flags);
-		if (test_bit(STRIPE_SYNCING, &sh->state)) {
-			raid5_release_stripe(sh);
-			schedule();
-			goto again;
-		}
-		clear_bit(R5_Overlap, &sh->dev[sh->pd_idx].flags);
-		spin_lock_irq(&sh->stripe_lock);
-		for (d = 0; d < conf->raid_disks; d++) {
-			if (d == sh->pd_idx || d == sh->qd_idx)
-				continue;
-			if (sh->dev[d].towrite || sh->dev[d].toread) {
-				set_bit(R5_Overlap, &sh->dev[d].flags);
-				spin_unlock_irq(&sh->stripe_lock);
-				raid5_release_stripe(sh);
-				schedule();
-				goto again;
-			}
-		}
-		set_bit(STRIPE_DISCARD, &sh->state);
-		finish_wait(&conf->wait_for_overlap, &w);
-		sh->overwrite_disks = 0;
-		for (d = 0; d < conf->raid_disks; d++) {
-			if (d == sh->pd_idx || d == sh->qd_idx)
-				continue;
-			sh->dev[d].towrite = bi;
-			set_bit(R5_OVERWRITE, &sh->dev[d].flags);
-			bio_inc_remaining(bi);
-			md_write_inc(mddev, bi);
-			sh->overwrite_disks++;
-		}
-		spin_unlock_irq(&sh->stripe_lock);
-		if (conf->mddev->bitmap) {
-			for (d = 0;
-			     d < conf->raid_disks - conf->max_degraded;
-			     d++)
-				md_bitmap_startwrite(mddev->bitmap,
-						     sh->sector,
-						     RAID5_STRIPE_SECTORS(conf),
-						     0);
-			sh->bm_seq = conf->seq_flush + 1;
-			set_bit(STRIPE_BIT_DELAY, &sh->state);
-		}
-
-		set_bit(STRIPE_HANDLE, &sh->state);
-		clear_bit(STRIPE_DELAYED, &sh->state);
-		if (!test_and_set_bit(STRIPE_PREREAD_ACTIVE, &sh->state))
-			atomic_inc(&conf->preread_active_stripes);
-		release_stripe_plug(mddev, sh);
-	}
-
-	bio_endio(bi);
+	bio_start = bi->bi_iter.bi_sector & ~((sector_t)RAID5_STRIPE_SECTORS(conf)-1);
+	bio_end = bio_end_sector(bi);
+
+	/*
+	 * Keep bio aligned with strip size.
+	 */
+	div_u64_rem(bio_start, stripe_sectors, &remainder);
+	if (remainder) {
+		split_size = stripe_sectors - remainder;
+		split = bio_split(bi, split_size, GFP_NOIO, &conf->bio_split);
+		bio_chain(split, bi);
+		/* Resend the fist split part */
+		submit_bio_noacct(split);
+	}
+	div_u64_rem(bio_end-bio_start, stripe_sectors, &remainder);
+	if (remainder) {
+		split_size = bio_sectors(bi) - remainder;
+		split = bio_split(bi, split_size, GFP_NOIO, &conf->bio_split);
+		bio_chain(split, bi);
+		/* Resend the second split part */
+		submit_bio_noacct(bi);
+		bi = split;
+	}
+
+	bio_start = bi->bi_iter.bi_sector & ~((sector_t)RAID5_STRIPE_SECTORS(conf)-1);
+	bio_end = bio_end_sector(bi);
+
+	bi->bi_next = NULL;
+
+	first_stripe_index = bio_start;
+	sector_div(first_stripe_index, stripe_sectors);
+
+	last_stripe_index = bio_end;
+	sector_div(last_stripe_index, stripe_sectors);
+
+	start_disk_index = (int)(bio_start - first_stripe_index * stripe_sectors) /
+		conf->chunk_sectors;
+	start_disk_offset = ((int)(bio_start - first_stripe_index * stripe_sectors) %
+		conf->chunk_sectors) +
+		first_stripe_index * conf->chunk_sectors;
+	end_disk_index = (int)(bio_end - last_stripe_index * stripe_sectors) /
+		conf->chunk_sectors;
+	end_disk_offset = ((int)(bio_end - last_stripe_index * stripe_sectors) %
+		conf->chunk_sectors) +
+		last_stripe_index * conf->chunk_sectors;
+
+	for (d = 0; d < conf->raid_disks; d++) {
+		sector_t dev_start, dev_end;
+		struct md_rdev *rdev = READ_ONCE(conf->disks[d].rdev);
+
+		dev_start = bio_start;
+		dev_end = bio_end;
+
+		if (d < start_disk_index)
+			dev_start = (first_stripe_index + 1) *
+				conf->chunk_sectors;
+		else if (d > start_disk_index)
+			dev_start = first_stripe_index * conf->chunk_sectors;
+		else
+			dev_start = start_disk_offset;
+
+		if (d < end_disk_index)
+			dev_end = (last_stripe_index + 1) * conf->chunk_sectors;
+		else if (d > end_disk_index)
+			dev_end = last_stripe_index * conf->chunk_sectors;
+		else
+			dev_end = end_disk_offset;
+
+		if (dev_end <= dev_start)
+			continue;
+
+		md_submit_discard_bio(mddev, rdev, bi,
+					dev_start + rdev->data_offset,
+					dev_end - dev_start);
+	}
+
+	bio_endio(bi);
 }
 
 static bool raid5_make_request(struct mddev *mddev, struct bio * bi)
-- 
2.17.1

