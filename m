Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 773B9C433EF
	for <linux-raid@archiver.kernel.org>; Tue, 21 Dec 2021 20:06:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232360AbhLUUGv (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 21 Dec 2021 15:06:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229916AbhLUUGu (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 21 Dec 2021 15:06:50 -0500
Received: from mail-qk1-x736.google.com (mail-qk1-x736.google.com [IPv6:2607:f8b0:4864:20::736])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D947C061574
        for <linux-raid@vger.kernel.org>; Tue, 21 Dec 2021 12:06:50 -0800 (PST)
Received: by mail-qk1-x736.google.com with SMTP id de30so231627qkb.0
        for <linux-raid@vger.kernel.org>; Tue, 21 Dec 2021 12:06:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=digitalocean.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=H5NAIDer27EGCzDY5acInkISXYKyvu0wOLjj7+etOww=;
        b=JKJB+Ml3CcLZ/FcHv3ydNw7EOXX7K/0X3uONRsE3ywWgU40RcroJJ4M6dRA+tifK6o
         ponRDn+wYVWoXH1Yw18yZIdjPGRlZ/9LCXzbElNxtEtvNrMHv4vAWXRoPKfwydxchMEC
         uB9hxnYk5aQHeO1LdF1DJugD9gy5pUXxa7ypI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=H5NAIDer27EGCzDY5acInkISXYKyvu0wOLjj7+etOww=;
        b=5F8K+d7H939r9UDaf1L7AvTcDFMV4M+Zi7QtFRErvpaWXtx3T+KlWC6+h5vWLY24zQ
         LlUaEQb2ecLP/uJLSnnAxhzSi8WLrnlMIxjy2k0tAylbeceWY9mtPlWw1pGNbG0ewzYG
         T8lT9gaqsk+xh+3WCyDj3QVqME7fqzeMjnIWN60+5pvUIzatN4ZYBzKq1KCYE8hlojST
         RdjK771Rq7FAkCuOuHYxHRzu4s1UL2VFV++B8s1X6ecjOBxfOVe2YLOMMw6rO/EdQJbz
         PC7hZFpT+/dzMJImlgod/oJMzdobvK1yc3zTWI90xkfAhEgerOhKf2moZYdzvt6dha8/
         XNbA==
X-Gm-Message-State: AOAM5300o2ug4b6HUskn6jqOe/8VHuC/ihLNQvbfqWgB6hK3PmmhwglK
        tBrGpSRgMZRZVj3bo8sXuUOrrw==
X-Google-Smtp-Source: ABdhPJwv0gi8wBfCYe9lAmThtxi1KIxFzQo4zMZPlta2FUdcurRBHjnGMQhHYg8zrvji04s2zi1GxA==
X-Received: by 2002:a37:a78a:: with SMTP id q132mr3257810qke.712.1640117209361;
        Tue, 21 Dec 2021 12:06:49 -0800 (PST)
Received: from vverma-s2-cbrunner ([162.243.188.99])
        by smtp.gmail.com with ESMTPSA id m4sm16777169qtu.87.2021.12.21.12.06.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Dec 2021 12:06:48 -0800 (PST)
From:   Vishal Verma <vverma@digitalocean.com>
To:     song@kernel.org, linux-raid@vger.kernel.org
Cc:     axboe@kernel.dk, rgoldwyn@suse.de,
        Vishal Verma <vverma@digitalocean.com>
Subject: [PATCH v6 4/4] md: raid456 add nowait support
Date:   Tue, 21 Dec 2021 20:06:22 +0000
Message-Id: <20211221200622.29795-4-vverma@digitalocean.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211221200622.29795-1-vverma@digitalocean.com>
References: <f5b0b47f-cf0b-f74a-b8b6-80aeaa9b400d@digitalocean.com>
 <20211221200622.29795-1-vverma@digitalocean.com>
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Returns EAGAIN in case the raid456 driver would block
waiting for situations like:

  - Reshape operation,
  - Discard operation.

Signed-off-by: Vishal Verma <vverma@digitalocean.com>
---
 drivers/md/raid5.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 9c1a5877cf9f..d9647c384820 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -5715,6 +5715,11 @@ static void make_discard_request(struct mddev *mddev, struct bio *bi)
 		set_bit(R5_Overlap, &sh->dev[sh->pd_idx].flags);
 		if (test_bit(STRIPE_SYNCING, &sh->state)) {
 			raid5_release_stripe(sh);
+			/* Bail out if REQ_NOWAIT is set */
+			if (bi->bi_opf & REQ_NOWAIT) {
+				bio_wouldblock_error(bi);
+				return;
+			}
 			schedule();
 			goto again;
 		}
@@ -5727,6 +5732,11 @@ static void make_discard_request(struct mddev *mddev, struct bio *bi)
 				set_bit(R5_Overlap, &sh->dev[d].flags);
 				spin_unlock_irq(&sh->stripe_lock);
 				raid5_release_stripe(sh);
+				/* Bail out if REQ_NOWAIT is set */
+				if (bi->bi_opf & REQ_NOWAIT) {
+					bio_wouldblock_error(bi);
+					return;
+				}
 				schedule();
 				goto again;
 			}
@@ -5820,6 +5830,16 @@ static bool raid5_make_request(struct mddev *mddev, struct bio * bi)
 	bi->bi_next = NULL;
 
 	md_account_bio(mddev, &bi);
+	/* Bail out if REQ_NOWAIT is set */
+	if ((bi->bi_opf & REQ_NOWAIT) &&
+	    (conf->reshape_progress != MaxSector) &&
+	    (mddev->reshape_backwards
+	    ? (logical_sector > conf->reshape_progress && logical_sector <= conf->reshape_safe)
+	    : (logical_sector >= conf->reshape_safe && logical_sector < conf->reshape_progress))) {
+		bio_wouldblock_error(bi);
+		return true;
+	}
+
 	prepare_to_wait(&conf->wait_for_overlap, &w, TASK_UNINTERRUPTIBLE);
 	for (; logical_sector < last_sector; logical_sector += RAID5_STRIPE_SECTORS(conf)) {
 		int previous;
-- 
2.17.1

