Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41EBEC433F5
	for <linux-raid@archiver.kernel.org>; Mon,  1 Nov 2021 21:52:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 200C260EE3
	for <linux-raid@archiver.kernel.org>; Mon,  1 Nov 2021 21:52:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231126AbhKAVyu (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 1 Nov 2021 17:54:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229896AbhKAVyt (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 1 Nov 2021 17:54:49 -0400
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 890AAC061714
        for <linux-raid@vger.kernel.org>; Mon,  1 Nov 2021 14:52:15 -0700 (PDT)
Received: by mail-io1-xd36.google.com with SMTP id d63so23338158iof.4
        for <linux-raid@vger.kernel.org>; Mon, 01 Nov 2021 14:52:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=digitalocean.com; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=0BQwu+7ERavI+hzceYuuaq3Ohmmfycn8qltkFgDkZYE=;
        b=WZgnXGSxbX89ekhzL/a3XLSgtyqF+cACFVkaF4pNvflJm9dIpWLato1OcgtJkjA7sf
         wboT6EMo6JptTe3RPtPLqNxTweQ9JXc841w9OUqRBVi0j35UBzfYIwpbfnIyxs0OjxSh
         wlId3jsS7ErTFeNQiu+WK9nz7BtW3HNdhZDE8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=0BQwu+7ERavI+hzceYuuaq3Ohmmfycn8qltkFgDkZYE=;
        b=J2Fm9v4JqhubAqOFhnhprIILinycKKQhZ8qvymO+dzhJp/QrBXjO7D7zP1Hx3gl5UH
         GLUnPeYm5UzSCHOUugpgdFkbjkmq7QHdYIjvV/aDA684Me4goqzX2bHe7koJAggwt5kG
         Nh4FUULGkKqcMtjRm0Sm+tt+LRu9NlxGsEfEuvYoDUuyquu4lamHD58CI11+u3eqKV5a
         9UsW07pc9gblr56iLAUBkjkvrle4lJ/rorUJPJnQvgnekut8oQLCsEXgwLtWt6yaiNx4
         lcoN5X7/gXOGVx0FLlGNVcyHDUUbfc19LX07BPo4EAz8F22hxZ5ML+zuyrw06mpV2lgU
         VbjA==
X-Gm-Message-State: AOAM533KyAfcnn65la7TLiG7029OqnMpcdHP53UnbG2aCGcpyDXwESfH
        Ei9EZ4fTl/+UHLWYUoU8fuwl8hF12fpZTQ==
X-Google-Smtp-Source: ABdhPJwAiDzCXYnitoUg8HPw6b8JuRKKGMA2eJXR8McGaHCjxIFC2hK1m2yKrClNwKlLQ5RLX50QUg==
X-Received: by 2002:a5e:d80a:: with SMTP id l10mr22816892iok.182.1635803534807;
        Mon, 01 Nov 2021 14:52:14 -0700 (PDT)
Received: from vverma-s2-cbrunner ([162.243.188.99])
        by smtp.gmail.com with ESMTPSA id j23sm8153683iog.53.2021.11.01.14.52.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Nov 2021 14:52:14 -0700 (PDT)
From:   Vishal Verma <vverma@digitalocean.com>
To:     song@kernel.org, linux-raid@vger.kernel.org, rgoldwyn@suse.com
Cc:     Vishal Verma <vverma@digitalocean.com>
Subject: [PATCH] md: add support for REQ_NOWAIT
Date:   Mon,  1 Nov 2021 21:51:43 +0000
Message-Id: <20211101215143.1580-1-vverma@digitalocean.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

commit 021a24460dc2 ("block: add QUEUE_FLAG_NOWAIT") added support
for checking whether a given bdev supports handling of REQ_NOWAIT or not.
Since then commit 6abc49468eea ("dm: add support for REQ_NOWAIT and enable
it for linear target") added support for REQ_NOWAIT for dm. This uses
a similar approach to incorporate REQ_NOWAIT for md based bios.

Signed-off-by: Vishal Verma <vverma@digitalocean.com>
---
 drivers/md/md.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 5111ed966947..51b2df32aed5 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -419,6 +419,12 @@ void md_handle_request(struct mddev *mddev, struct bio *bio)
 	if (is_suspended(mddev, bio)) {
 		DEFINE_WAIT(__wait);
 		for (;;) {
+			/* Bail out if REQ_NOWAIT is set for the bio */
+			if (bio->bi_opf & REQ_NOWAIT) {
+				bio_wouldblock_error(bio);
+				break;
+			}
+
 			prepare_to_wait(&mddev->sb_wait, &__wait,
 					TASK_UNINTERRUPTIBLE);
 			if (!is_suspended(mddev, bio))
@@ -5792,6 +5798,7 @@ int md_run(struct mddev *mddev)
 	int err;
 	struct md_rdev *rdev;
 	struct md_personality *pers;
+	bool nowait = true;
 
 	if (list_empty(&mddev->disks))
 		/* cannot run an array with no devices.. */
@@ -5862,8 +5869,14 @@ int md_run(struct mddev *mddev)
 			}
 		}
 		sysfs_notify_dirent_safe(rdev->sysfs_state);
+		if (!blk_queue_nowait(bdev_get_queue(rdev->bdev)))
+			nowait = false;
 	}
 
+	/* Set the NOWAIT flags if all underlying devices support it */
+	if (nowait)
+		blk_queue_flag_set(QUEUE_FLAG_NOWAIT, mddev->queue);
+
 	if (!bioset_initialized(&mddev->bio_set)) {
 		err = bioset_init(&mddev->bio_set, BIO_POOL_SIZE, 0, BIOSET_NEED_BVECS);
 		if (err)
@@ -7007,6 +7020,14 @@ static int hot_add_disk(struct mddev *mddev, dev_t dev)
 	set_bit(MD_SB_CHANGE_DEVS, &mddev->sb_flags);
 	if (!mddev->thread)
 		md_update_sb(mddev, 1);
+	/* If the new disk does not support REQ_NOWAIT,
+	 * disable on the whole MD.
+	 */
+	if (!blk_queue_nowait(bdev_get_queue(rdev->bdev))) {
+		pr_info("%s: Disabling nowait because %s does not support nowait\n",
+			mdname(mddev), bdevname(rdev->bdev, b));
+		blk_queue_flag_clear(QUEUE_FLAG_NOWAIT, mddev->queue);
+	}
 	/*
 	 * Kick recovery, maybe this spare has to be added to the
 	 * array immediately.
-- 
2.17.1

