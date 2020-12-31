Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C7C0C433E6
	for <linux-raid@archiver.kernel.org>; Thu, 31 Dec 2020 17:32:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E4EF1223DB
	for <linux-raid@archiver.kernel.org>; Thu, 31 Dec 2020 17:32:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727084AbgLaRcD (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 31 Dec 2020 12:32:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726673AbgLaRcD (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 31 Dec 2020 12:32:03 -0500
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A29EC061575
        for <linux-raid@vger.kernel.org>; Thu, 31 Dec 2020 09:31:23 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id be12so10266328plb.4
        for <linux-raid@vger.kernel.org>; Thu, 31 Dec 2020 09:31:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=keRxqz9om0JotSem7GQWbJOQVOrkBUKUd69x4bSIwac=;
        b=qP9NAM+2CPXFPRjiimMw+zeC9GlWpemZmGbfXH71aBifOsEhHpeEL1CE2Zsf4bjku3
         UZhqV0PLf5/86yO7sEDX47Zh25ANl65/WXQzEZa/XN98h7wXy1EAbRwpOyIwgi3L0a7A
         7e8mc/3Mpvpvnoq+iX1xJm0S50OIvfphNBJLGzvOByCV0Qs37OMVXhMabcT1NTvvMlDV
         qRvtgUswZiRae5ZTSLn1PbsgEDi7Br3iKJhBPbKV3W2FuLdxdKAmbT1alxwQuT5799SR
         3EIHHSdDZPGNWCbN4EAONbNp1YdQX3ivUwLCtIUrcy/1ozRsgHcdHTIvvS6ZCwk6NWNp
         O1PQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=keRxqz9om0JotSem7GQWbJOQVOrkBUKUd69x4bSIwac=;
        b=dK265nOpE77iNLtUrPDBrofq9ElhDsV4FQ+LlzGlHYk6Xq8iLCm4NHL0Knw3ktgj2x
         5xJSh9SfYuoN3bt9buJ5YnQAb2ig4C1w/vkoaB2j8Mlah/yAbcp0ZUC7Ckcq0gnT0rof
         xzZM+Z5l3sZahYtJq9pLqwQwzxNv7Yj0dJ+m4T5ynhTZx05lDZrhItsHQWU/QZcmIzj4
         YegfjRFYA8OhvtWCjV0jNKQSkESLHqX4ZtLiUb02M5uWZsAH5dw14uoU0gX76DaRRWTG
         E0zGq6HXHMs3PdcwMRGCPZG2HWqMq06OQa52z7jZVZrb9gh4uCu9qNofEZUXbtxpfQv9
         g+0A==
X-Gm-Message-State: AOAM530t88mED/duZU7VeXVRnrP9PAoxztXwGzTYV7+3x1pUQKfYNbfD
        LCxfMzINENG/aENzzbHYXIE+0wGImWR57Q==
X-Google-Smtp-Source: ABdhPJx39Zx3QUqEboew2B4UaN+0QqS2yKdgU80LYX4/CWdotEkE+v45nI6q8nVn4fxTu4Zk/TsYhQ==
X-Received: by 2002:a17:902:d893:b029:da:8226:5804 with SMTP id b19-20020a170902d893b02900da82265804mr58373757plz.63.1609435882198;
        Thu, 31 Dec 2020 09:31:22 -0800 (PST)
Received: from kvigor-fedora-R90RRLH2.thefacebook.com ([2620:10d:c090:400::5:7c6c])
        by smtp.gmail.com with ESMTPSA id v6sm47105163pfi.31.2020.12.31.09.31.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Dec 2020 09:31:21 -0800 (PST)
From:   Kevin Vigor <kvigor@gmail.com>
To:     linux-raid@vger.kernel.org
Cc:     Kevin Vigor <kvigor@gmail.com>
Subject: [PATCH 2/2] md/raid10: introducing range-based barriers
Date:   Thu, 31 Dec 2020 09:30:01 -0800
Message-Id: <20201231173000.3596606-2-kvigor@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201231173000.3596606-1-kvigor@gmail.com>
References: <20201231173000.3596606-1-kvigor@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Current resync code uses heavyweight barriers: sync requests call
raise_barrier(), which waits for all non-sync traffic to drain; user
requests call wait_barrier() which waits for all sync traffic to drain.
This ensures that there is no consistency error caused by user writes
sneaking in the middle of a resync request, but has severe performance
impact (in test we see user write bandwidth reduced by 70% during check,
even with sync_speed_max set to ridiculously small value such as 1MB/s).

This patch optionally enables range based locking, where only the portion
of the device being synched is locked, significantly improving performance
during a sync operation (in same test above we see user bandwidth reduction
of 15% with resync achieving rates in the 100MB/s range).

The principle is that during a resync, all sync and user write requests
obtain an exclusive lock on the virtual sector range they alter, blocking
if necessary (it is assumed that user reads may safely proceed even when
there is an outstanding sync request, since a resync by definition cannot
change existing correct data). The lock is released when the owning rbio is
completed, i.e. when the entire mirrored operation is complete.

The existing barrier code is left in place since it is used during drains
and reshape operations. The only alteration to the pre-existing barrier
code is that when range based barriers are enabled, sync requests issued in
raid10_sync_request() do not call raise_barrier(), but instead call
lock_range().

Signed-off-by: Kevin Vigor <kvigor@gmail.com>
---
 Documentation/admin-guide/md.rst |  12 ++
 drivers/md/Kconfig               |  20 ++
 drivers/md/raid10.c              | 304 ++++++++++++++++++++++++++++++-
 drivers/md/raid10.h              |  54 ++++++
 4 files changed, 386 insertions(+), 4 deletions(-)

diff --git a/Documentation/admin-guide/md.rst b/Documentation/admin-guide/md.rst
index d8fc9a59c086..ebabd2dad00f 100644
--- a/Documentation/admin-guide/md.rst
+++ b/Documentation/admin-guide/md.rst
@@ -763,3 +763,15 @@ These currently include:
 
   ppl_write_hint
       NVMe stream ID to be set for each PPL write request.
+
+  rangebased_barriers/enabled (currently raid10 only)
+      uses range-based locking instead of coarse barriers to prevent
+      resync IO and user writes from colliding. May improve performance
+      during a resync.
+
+  rangebased_barriers/max_locked_ranges (currently raid10 only)
+      maximum number of sector ranges that may be locked at one time in
+      range-based locking mode.
+
+  rangebased_barriers/stats (currently raid10 only)
+      counters pertinent to range-based locking.
diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
index b7e2d9666614..f6301448fd84 100644
--- a/drivers/md/Kconfig
+++ b/drivers/md/Kconfig
@@ -120,6 +120,26 @@ config MD_RAID10
 
 	  If unsure, say Y.
 
+config MD_RAID10_RBB
+	bool "RAID-10 range-based barriers"
+	depends on MD_RAID10
+	default n
+	help
+	  Enable optional range-based barriers in RAID-10 resync code.
+	  This may improve performance during a resync operation.
+
+	  If unsure, say N.
+
+config MD_RAID10_RBB_CHECKS
+	bool "Sanity checks for RAID-10 range-based barriers"
+	depends on MD_RAID10_RBB
+	default n
+	help
+	  Enable this to turn on some internal sanity checks in RAID-10
+	  range-based barrier code.
+
+	  If unsure, say N.
+
 config MD_RAID456
 	tristate "RAID-4/RAID-5/RAID-6 mode"
 	depends on BLK_DEV_MD
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index f98df9f084c2..01346862e0a8 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -12,6 +12,7 @@
 #include <linux/slab.h>
 #include <linux/delay.h>
 #include <linux/blkdev.h>
+#include <linux/interval_tree_generic.h>
 #include <linux/module.h>
 #include <linux/seq_file.h>
 #include <linux/ratelimit.h>
@@ -23,6 +24,13 @@
 #include "raid0.h"
 #include "md-bitmap.h"
 
+#ifdef CONFIG_MD_RAID10_RBB
+#define R10BIO_START_ADDR(r10bio) ((r10bio)->sector)
+#define R10BIO_END_ADDR(r10bio) ((r10bio)->sector + (r10bio)->sectors - 1)
+INTERVAL_TREE_DEFINE(struct r10bio, rb, sector_t, __subtree_last,
+R10BIO_START_ADDR, R10BIO_END_ADDR, static inline, r10bio_rbtree)
+#endif
+
 /*
  * RAID10 provides a combination of RAID0 and RAID1 functionality.
  * The layout of data is defined by
@@ -73,6 +81,10 @@ static sector_t reshape_request(struct mddev *mddev, sector_t sector_nr,
 static void reshape_request_write(struct mddev *mddev, struct r10bio *r10_bio);
 static void end_reshape_write(struct bio *bio);
 static void end_reshape(struct r10conf *conf);
+static void raise_barrier(struct r10conf *conf, int force);
+static void lower_barrier(struct r10conf *conf);
+static void freeze_array(struct r10conf *conf, int extra);
+static void unfreeze_array(struct r10conf *conf);
 
 #define raid10_log(md, fmt, args...)				\
 	do { if ((md)->queue) blk_add_trace_msg((md)->queue, "raid10 " fmt, ##args); } while (0)
@@ -250,10 +262,218 @@ static void put_all_bios(struct r10conf *conf, struct r10bio *r10_bio)
 	}
 }
 
+#ifdef CONFIG_MD_RAID10_RBB
+static ssize_t stats_show(struct mddev *mddev, char *page)
+{
+	struct r10conf *conf = mddev->private;
+
+	if (!conf)
+		return 0;
+
+	return sprintf(
+		page,
+		"sync blocked: %lld/%lld uio blocked: %lld/%lld inflight %d\n",
+		atomic64_read(&conf->rbb_state.sync_blocked),
+		atomic64_read(&conf->rbb_state.sync_checks),
+		atomic64_read(&conf->rbb_state.uio_blocked),
+		atomic64_read(&conf->rbb_state.uio_checks),
+		atomic_read(&conf->rbb_state.locked_range_count));
+}
+
+static struct md_sysfs_entry
+stats = __ATTR_RO(stats);
+
+static ssize_t
+enabled_store(struct mddev *mddev, const char *page, size_t len)
+{
+	unsigned long new;
+	struct r10conf *conf = mddev->private;
+
+	if (!conf)
+		return -ENODEV;
+	if (len >= PAGE_SIZE)
+		return -EINVAL;
+	if (kstrtoul(page, 10, &new))
+		return -EINVAL;
+	if (new != 0 && new != 1)
+		return -EINVAL;
+
+	if (new != conf->rangebased_barriers) {
+		pr_info("md/raid10:%s: %sabling range based barriers.\n",
+				 mdname(mddev),	new ? "en" : "dis");
+		freeze_array(conf, 0);
+		conf->rangebased_barriers = new;
+		unfreeze_array(conf);
+	}
+
+	return len;
+}
+
+static ssize_t enabled_show(struct mddev *mddev, char *page)
+{
+	struct r10conf *conf = mddev->private;
+
+	if (!conf)
+		return 0;
+
+	return sprintf(page, "%d\n", conf->rangebased_barriers);
+}
+
+static struct md_sysfs_entry
+enabled = __ATTR_RW(enabled);
+
+static ssize_t
+max_locked_ranges_store(struct mddev *mddev, const char *page, size_t len)
+{
+	unsigned long new;
+	struct r10conf *conf = mddev->private;
+
+	if (!conf)
+		return -ENODEV;
+	if (len >= PAGE_SIZE)
+		return -EINVAL;
+	if (kstrtoul(page, 10, &new))
+		return -EINVAL;
+	if (new == 0 || new > UINT_MAX)
+		return -EINVAL;
+
+	conf->rbb_state.max_locked_ranges = new;
+
+	return len;
+}
+
+static ssize_t max_locked_ranges_show(struct mddev *mddev, char *page)
+{
+	struct r10conf *conf = mddev->private;
+
+	if (!conf)
+		return 0;
+
+	return sprintf(
+		page,
+		"%u\n",
+		conf->rbb_state.max_locked_ranges);
+}
+
+static struct md_sysfs_entry
+max_locked_ranges = __ATTR_RW(max_locked_ranges);
+
+static struct attribute *rbb_attrs[] =  {
+	&enabled.attr,
+	&max_locked_ranges.attr,
+	&stats.attr,
+	NULL,
+};
+
+static struct attribute_group rbb_attrs_group = {
+	.name = "rangebased_barriers",
+	.attrs = rbb_attrs,
+};
+
+/* Return non-zero if the virtual sector range described by the given r10 bio
+ * overlaps with any in-flight request.
+ *
+ * Must be called with conf->rbb_state.lock held.
+ */
+static int collides_with_inflight(struct r10conf *conf, const struct r10bio *r10_bio)
+{
+	const int is_sync = test_bit(R10BIO_IsSync, &r10_bio->state) ||
+		test_bit(R10BIO_IsRecover, &r10_bio->state);
+
+	lockdep_assert_held(&conf->rbb_state.lock);
+
+	if (is_sync)
+		atomic64_inc(&conf->rbb_state.sync_checks);
+	else
+		atomic64_inc(&conf->rbb_state.uio_checks);
+
+	if (!r10bio_rbtree_iter_first(&conf->rbb_state.locked_ranges,
+						  R10BIO_START_ADDR(r10_bio),
+						  R10BIO_END_ADDR(r10_bio))) {
+		return 0;
+	}
+	if (is_sync)
+		atomic64_inc(&conf->rbb_state.sync_blocked);
+	else
+		atomic64_inc(&conf->rbb_state.uio_blocked);
+	return 1;
+}
+
+/* Mark the virtual sector range described by the given r10bio as being in
+ * inflight. If there is any existing inflight r10bio that overlaps this
+ * request, we first block until it completes.
+ *
+ * Caller must arrange to call unlock_range() when the r10bio is completed.
+ */
+static void lock_range(struct r10conf *conf, struct r10bio *r10_bio)
+{
+	unsigned long flags;
+
+	might_sleep();
+
+	if (test_and_set_bit(R10BIO_RangeLocked, &r10_bio->state))
+		return;
+	spin_lock_irqsave(&conf->rbb_state.lock, flags);
+	wait_event_lock_irq(conf->rbb_state.wait,
+			    !collides_with_inflight(conf, r10_bio)
+			    && atomic_read(&conf->rbb_state.locked_range_count) <
+					conf->rbb_state.max_locked_ranges,
+			    conf->rbb_state.lock);
+	r10bio_rbtree_insert(r10_bio, &conf->rbb_state.locked_ranges);
+	atomic_inc(&conf->rbb_state.locked_range_count);
+	spin_unlock_irqrestore(&conf->rbb_state.lock, flags);
+}
+
+/* Mark the virtual sector range described by given r10bio as no longer being
+ * inflight, allowing other IO to be issued against this range.
+ */
+static void unlock_range(struct r10conf *conf,
+			      struct r10bio *r10_bio)
+{
+	unsigned long flags;
+
+	if (!test_and_clear_bit(R10BIO_RangeLocked, &r10_bio->state)) {
+		pr_err_ratelimited("md/raid10:%s: r10 bio not locked in %s().\n",
+				mdname(conf->mddev), __func__);
+		return;
+	}
+	spin_lock_irqsave(&conf->rbb_state.lock, flags);
+#ifdef CONFIG_MD_RAID10_RBB_CHECKS
+	if (!r10bio_rbtree_iter_first(&conf->rbb_state.locked_ranges,
+				  R10BIO_START_ADDR(r10_bio),
+				  R10BIO_END_ADDR(r10_bio))) {
+		pr_err_ratelimited(
+			"md/raid10:%s: RBB: range %llu-%llu not in inflight tree!\n",
+			mdname(conf->mddev),
+			R10BIO_START_ADDR(r10_bio), R10BIO_END_ADDR(r10_bio));
+	}
+#endif
+	r10bio_rbtree_remove(r10_bio, &conf->rbb_state.locked_ranges);
+#ifdef CONFIG_MD_RAID10_RBB_CHECKS
+	if (r10bio_rbtree_iter_first(&conf->rbb_state.locked_ranges,
+				  R10BIO_START_ADDR(r10_bio),
+				  R10BIO_END_ADDR(r10_bio))) {
+		pr_err_ratelimited(
+			"md/raid10:%s: RBB: sync range %llu-%llu still in inflight tree!\n",
+			mdname(conf->mddev),
+			R10BIO_START_ADDR(r10_bio), R10BIO_END_ADDR(r10_bio));
+	}
+#endif
+	atomic_dec(&conf->rbb_state.locked_range_count);
+	spin_unlock_irqrestore(&conf->rbb_state.lock, flags);
+	wake_up(&conf->rbb_state.wait);
+}
+#endif /* CONFIG_MD_RAID10_RBB */
+
 static void free_r10bio(struct r10bio *r10_bio)
 {
 	struct r10conf *conf = r10_bio->mddev->private;
 
+#ifdef CONFIG_MD_RAID10_RBB_CHECKS
+    /* Should have unlocked range before freeing request. */
+	WARN_ON(test_bit(R10BIO_RangeLocked, &r10_bio->state));
+#endif
+
 	put_all_bios(conf, r10_bio);
 	mempool_free(r10_bio, &conf->r10bio_pool);
 }
@@ -261,10 +481,22 @@ static void free_r10bio(struct r10bio *r10_bio)
 static void put_buf(struct r10bio *r10_bio)
 {
 	struct r10conf *conf = r10_bio->mddev->private;
+	bool lower = true;
+
+#ifdef CONFIG_MD_RAID10_RBB
+	if (test_bit(R10BIO_RangeLocked, &r10_bio->state)) {
+		/* a sync request obtains either a range lock or a barrier,
+		 * depending on rangebased_barriers, but never both.
+		 */
+		unlock_range(conf, r10_bio);
+		lower = false;
+	}
+#endif
 
 	mempool_free(r10_bio, &conf->r10buf_pool);
 
-	lower_barrier(conf);
+	if (lower)
+		lower_barrier(conf);
 }
 
 static void reschedule_retry(struct r10bio *r10_bio)
@@ -303,7 +535,10 @@ static void raid_end_bio_io(struct r10bio *r10_bio)
 	 * to go idle.
 	 */
 	allow_barrier(conf);
-
+#ifdef CONFIG_MD_RAID10_RBB
+	if (test_bit(R10BIO_RangeLocked, &r10_bio->state))
+		unlock_range(conf, r10_bio);
+#endif
 	free_r10bio(r10_bio);
 }
 
@@ -1455,6 +1690,14 @@ static void raid10_write_request(struct mddev *mddev, struct bio *bio,
 	if (max_sectors < r10_bio->sectors)
 		r10_bio->sectors = max_sectors;
 
+#ifdef CONFIG_MD_RAID10_RBB
+	if (conf->rangebased_barriers &&
+		test_bit(MD_RECOVERY_RUNNING, &conf->mddev->recovery))
+		lock_range(conf, r10_bio); /* unlocked in raid_end_bio_io */
+	else
+		clear_bit(RBBFlag_lockUserWrites, &conf->rbb_state.flags);
+#endif
+
 	if (r10_bio->sectors < bio_sectors(bio)) {
 		struct bio *split = bio_split(bio, r10_bio->sectors,
 					      GFP_NOIO, &conf->bio_split);
@@ -2901,6 +3144,9 @@ static sector_t raid10_sync_request(struct mddev *mddev, sector_t sector_nr,
 	int chunks_skipped = 0;
 	sector_t chunk_mask = conf->geo.chunk_mask;
 	int page_idx = 0;
+#ifdef CONFIG_MD_RAID10_RBB
+	const int rangebased_barriers = conf->rangebased_barriers;
+#endif
 
 	if (!mempool_initialized(&conf->r10buf_pool))
 		if (init_resync(conf))
@@ -2921,6 +3167,19 @@ static sector_t raid10_sync_request(struct mddev *mddev, sector_t sector_nr,
 		return mddev->dev_sectors - sector_nr;
 	}
 
+#ifdef CONFIG_MD_RAID10_RBB
+	if (rangebased_barriers &&
+		!test_and_set_bit(RBBFlag_lockUserWrites, &conf->rbb_state.flags)) {
+		/* Starting a new sync or just enabled range-based.
+		 * Need to flush any existing user writes, so that we are subsequently
+		 * guaranteed that all in-flight writes have a lock on the range they
+		 * alter.
+		 */
+		raise_barrier(conf, 0);
+		lower_barrier(conf);
+	}
+#endif
+
  skipped:
 	max_sector = mddev->dev_sectors;
 	if (test_bit(MD_RECOVERY_SYNC, &mddev->recovery) ||
@@ -3095,7 +3354,10 @@ static sector_t raid10_sync_request(struct mddev *mddev, sector_t sector_nr,
 
 			r10_bio = raid10_alloc_init_r10buf(conf);
 			r10_bio->state = 0;
-			raise_barrier(conf, rb2 != NULL);
+#ifdef CONFIG_MD_RAID10_RBB
+			if (!rangebased_barriers)
+#endif
+				raise_barrier(conf, rb2 != NULL); /* lowered in put_buf() */
 			atomic_set(&r10_bio->remaining, 0);
 
 			r10_bio->master_bio = (struct bio*)rb2;
@@ -3311,7 +3573,10 @@ static sector_t raid10_sync_request(struct mddev *mddev, sector_t sector_nr,
 
 		r10_bio->mddev = mddev;
 		atomic_set(&r10_bio->remaining, 0);
-		raise_barrier(conf, 0);
+#ifdef CONFIG_MD_RAID10_RBB
+		if (!rangebased_barriers)
+#endif
+			raise_barrier(conf, 0);
 		conf->next_resync = sector_nr;
 
 		r10_bio->master_bio = NULL;
@@ -3484,6 +3749,10 @@ static sector_t raid10_sync_request(struct mddev *mddev, sector_t sector_nr,
 
 		if (bio->bi_end_io == end_sync_read) {
 			md_sync_acct_bio(bio, nr_sectors);
+#ifdef CONFIG_MD_RAID10_RBB
+			if (rangebased_barriers)
+				lock_range(conf, r10_bio); /* released in put_buf(). */
+#endif
 			bio->bi_status = 0;
 			submit_bio_noacct(bio);
 		}
@@ -3696,6 +3965,21 @@ static struct r10conf *setup_conf(struct mddev *mddev)
 		goto out;
 
 	conf->mddev = mddev;
+
+#ifdef CONFIG_MD_RAID10_RBB
+	conf->rangebased_barriers = 0;
+	init_waitqueue_head(&conf->rbb_state.wait);
+	spin_lock_init(&conf->rbb_state.lock);
+	conf->rbb_state.flags = 0;
+	conf->rbb_state.locked_ranges = RB_ROOT_CACHED;
+	atomic64_set(&conf->rbb_state.sync_blocked, 0);
+	atomic64_set(&conf->rbb_state.uio_blocked, 0);
+	atomic64_set(&conf->rbb_state.sync_checks, 0);
+	atomic64_set(&conf->rbb_state.uio_checks, 0);
+	atomic_set(&conf->rbb_state.locked_range_count, 0);
+	conf->rbb_state.max_locked_ranges = 10000;
+#endif
+
 	return conf;
 
  out:
@@ -3907,6 +4191,14 @@ static int raid10_run(struct mddev *mddev)
 			goto out_free_conf;
 	}
 
+#ifdef CONFIG_MD_RAID10_RBB
+	if (mddev->to_remove == &rbb_attrs_group)
+		mddev->to_remove = NULL;
+	else if (mddev->kobj.sd &&
+		sysfs_create_group(&mddev->kobj, &rbb_attrs_group))
+		pr_warn("md/raid10: failed to create sysfs attributes for %s\n",
+			mdname(mddev));
+#endif
 	return 0;
 
 out_free_conf:
@@ -3931,6 +4223,10 @@ static void raid10_free(struct mddev *mddev, void *priv)
 	kfree(conf->mirrors_new);
 	bioset_exit(&conf->bio_split);
 	kfree(conf);
+
+#ifdef CONFIG_MD_RAID10_RBB
+	mddev->to_remove = &rbb_attrs_group;
+#endif
 }
 
 static void raid10_quiesce(struct mddev *mddev, int quiesce)
diff --git a/drivers/md/raid10.h b/drivers/md/raid10.h
index 79cd2b7d3128..2e572569b32f 100644
--- a/drivers/md/raid10.h
+++ b/drivers/md/raid10.h
@@ -2,6 +2,8 @@
 #ifndef _RAID10_H
 #define _RAID10_H
 
+#include <linux/rbtree.h>
+
 /* Note: raid10_info.rdev can be set to NULL asynchronously by
  * raid10_remove_disk.
  * There are three safe ways to access raid10_info.rdev.
@@ -25,6 +27,38 @@ struct raid10_info {
 						 */
 };
 
+#ifdef CONFIG_MD_RAID10_RBB
+struct rangebased_barrier_state {
+	/* RBBFlag_ */
+	unsigned long flags;
+	/* interval tree of virtual sector ranges locked by inflight requests. */
+	struct rb_root_cached	locked_ranges;
+	/* lock protects locked_ranges tree. */
+	spinlock_t		lock;
+	/* waitqueue used for waiting on locked_ranges tree changes. */
+	wait_queue_head_t	wait;
+	/* number of requests in locked_ranges */
+	atomic_t locked_range_count;
+	/* Max number of entries in locked_ranges tree. */
+	unsigned int max_locked_ranges;
+
+	/* number of sync r10bios issued while rangebased barriers enabled. */
+	atomic64_t sync_checks;
+	/* number of times a sync r10bio's issue was blocked due to locked range. */
+	atomic64_t sync_blocked;
+	/* number of user r10bios issued while rangebased barriers enabled. */
+	atomic64_t uio_checks;
+	/* number of times a user r10bio's issue was blocked due to locked range. */
+	atomic64_t uio_blocked;
+};
+
+/* bits for rangebased_barrier_state.flags */
+enum rangebased_barrier_state_flags {
+	/* When set, all inflight user writes have a lock on the range they alter. */
+	RBBFlag_lockUserWrites,
+};
+#endif /* CONFIG_MD_RAID10_RBB */
+
 struct r10conf {
 	struct mddev		*mddev;
 	struct raid10_info	*mirrors;
@@ -108,6 +142,14 @@ struct r10conf {
 	 */
 	sector_t		cluster_sync_low;
 	sector_t		cluster_sync_high;
+
+#ifdef CONFIG_MD_RAID10_RBB
+	/*
+	 * Non-zero if we are using range-based sync barriers.
+	 */
+	int				rangebased_barriers;
+	struct rangebased_barrier_state rbb_state;
+#endif
 };
 
 /*
@@ -135,6 +177,11 @@ struct r10bio {
 	int			read_slot;
 
 	struct list_head	retry_list;
+
+	/* rb and __subtree_last used to store in locked_ranges interval tree. */
+	struct rb_node rb;
+	u64 __subtree_last;
+
 	/*
 	 * if the IO is in WRITE direction, then multiple bios are used,
 	 * one for each copy.
@@ -179,5 +226,12 @@ enum r10bio_state {
 	R10BIO_Previous,
 /* failfast devices did receive failfast requests. */
 	R10BIO_FailFast,
+	R10BIO_Discard,
+#ifdef CONFIG_MD_RAID10_RBB
+/* The virtual sector range in this bio has been locked via
+ * range-based barrier.
+ */
+	R10BIO_RangeLocked,
+#endif
 };
 #endif
-- 
2.26.2

