Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80002C43381
	for <linux-raid@archiver.kernel.org>; Tue, 29 Dec 2020 09:29:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4E4E2207D1
	for <linux-raid@archiver.kernel.org>; Tue, 29 Dec 2020 09:29:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726278AbgL2J3L (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 29 Dec 2020 04:29:11 -0500
Received: from mail.synology.com ([211.23.38.101]:43844 "EHLO synology.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725986AbgL2J3K (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Tue, 29 Dec 2020 04:29:10 -0500
Received: from localhost.localdomain (unknown [10.17.198.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        by synology.com (Postfix) with ESMTPSA id 1876FCE781A7;
        Tue, 29 Dec 2020 17:21:11 +0800 (CST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synology.com; s=123;
        t=1609233671; bh=jpzBEgsS3XGxpGhcKo+9a8VwP0KuPU+cSqae0gJ3gEs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=bvBzQwdXzEtioLAnF6SsyCdog9JJo8iv5WsQpCP7CVXgKtzvUMjvT2S4CsGU7H59e
         a2U/7iyCP+5t/kJYgUqZIBb/A5dCnNbdgbCR8RaCrIPpG555B+YDHwCX4ITOT/fmUA
         HBJLOuNl1zNDwlqpe4aU3OpsSz/2a9kLBkB6ZTGI=
From:   dannyshih <dannyshih@synology.com>
To:     axboe@kernel.dk
Cc:     agk@redhat.com, snitzer@redhat.com, dm-devel@redhat.com,
        song@kernel.org, linux-block@vger.kernel.org,
        linux-raid@vger.kernel.org, Danny Shih <dannyshih@synology.com>
Subject: [PATCH 1/4] block: introduce submit_bio_noacct_add_head
Date:   Tue, 29 Dec 2020 17:18:39 +0800
Message-Id: <1609233522-25837-2-git-send-email-dannyshih@synology.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1609233522-25837-1-git-send-email-dannyshih@synology.com>
References: <1609233522-25837-1-git-send-email-dannyshih@synology.com>
X-Synology-MCP-Status: no
X-Synology-Spam-Flag: no
X-Synology-Spam-Status: score=0, required 6, WHITELIST_FROM_ADDRESS 0
X-Synology-Virus-Status: no
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

From: Danny Shih <dannyshih@synology.com>

Porvide a way for stacking block device to re-submit the bio
which sholud be handled firstly.

Signed-off-by: Danny Shih <dannyshih@synology.com>
Reviewed-by: Allen Peng <allenpeng@synology.com>
Reviewed-by: Alex Wu <alexwu@synology.com>
---
 block/blk-core.c       | 44 +++++++++++++++++++++++++++++++++-----------
 include/linux/blkdev.h |  1 +
 2 files changed, 34 insertions(+), 11 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 96e5fcd..693dc83 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1031,16 +1031,7 @@ static blk_qc_t __submit_bio_noacct_mq(struct bio *bio)
 	return ret;
 }
 
-/**
- * submit_bio_noacct - re-submit a bio to the block device layer for I/O
- * @bio:  The bio describing the location in memory and on the device.
- *
- * This is a version of submit_bio() that shall only be used for I/O that is
- * resubmitted to lower level drivers by stacking block drivers.  All file
- * systems and other upper level users of the block layer should use
- * submit_bio() instead.
- */
-blk_qc_t submit_bio_noacct(struct bio *bio)
+static blk_qc_t do_submit_bio_noacct(struct bio *bio, bool add_head)
 {
 	if (!submit_bio_checks(bio))
 		return BLK_QC_T_NONE;
@@ -1052,7 +1043,10 @@ blk_qc_t submit_bio_noacct(struct bio *bio)
 	 * it is active, and then process them after it returned.
 	 */
 	if (current->bio_list) {
-		bio_list_add(&current->bio_list[0], bio);
+		if (add_head)
+			bio_list_add_head(&current->bio_list[0], bio);
+		else
+			bio_list_add(&current->bio_list[0], bio);
 		return BLK_QC_T_NONE;
 	}
 
@@ -1060,9 +1054,37 @@ blk_qc_t submit_bio_noacct(struct bio *bio)
 		return __submit_bio_noacct_mq(bio);
 	return __submit_bio_noacct(bio);
 }
+
+/**
+ * submit_bio_noacct - re-submit a bio to the block device layer for I/O
+ * @bio:  The bio describing the location in memory and on the device.
+ *
+ * This is a version of submit_bio() that shall only be used for I/O that is
+ * resubmitted to lower level drivers by stacking block drivers.  All file
+ * systems and other upper level users of the block layer should use
+ * submit_bio() instead.
+ */
+blk_qc_t submit_bio_noacct(struct bio *bio)
+{
+	return do_submit_bio_noacct(bio, false);
+}
 EXPORT_SYMBOL(submit_bio_noacct);
 
 /**
+ * submit_bio_noacct - re-submit a bio, which needs to be handle firstly,
+ *                     to the block device layer for I/O
+ * @bio:  The bio describing the location in memory and on the device.
+ *
+ * alternative submit_bio_noacct() which add bio to the head of
+ * current->bio_list.
+ */
+blk_qc_t submit_bio_noacct_add_head(struct bio *bio)
+{
+	return do_submit_bio_noacct(bio, true);
+}
+EXPORT_SYMBOL(submit_bio_noacct_add_head);
+
+/**
  * submit_bio - submit a bio to the block device layer for I/O
  * @bio: The &struct bio which describes the I/O
  *
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 070de09..b0080d0 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -905,6 +905,7 @@ static inline void rq_flush_dcache_pages(struct request *rq)
 extern int blk_register_queue(struct gendisk *disk);
 extern void blk_unregister_queue(struct gendisk *disk);
 blk_qc_t submit_bio_noacct(struct bio *bio);
+blk_qc_t submit_bio_noacct_add_head(struct bio *bio);
 extern void blk_rq_init(struct request_queue *q, struct request *rq);
 extern void blk_put_request(struct request *);
 extern struct request *blk_get_request(struct request_queue *, unsigned int op,
-- 
2.7.4

