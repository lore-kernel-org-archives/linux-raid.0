Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BF04C64EC4
	for <linux-raid@archiver.kernel.org>; Mon,  6 Mar 2023 21:30:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230183AbjCFVad (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 6 Mar 2023 16:30:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230071AbjCFV3d (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 6 Mar 2023 16:29:33 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 764DC31E02
        for <linux-raid@vger.kernel.org>; Mon,  6 Mar 2023 13:28:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678138107;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6XKi5VY6Rp84wZMBpkkKbYYGrfu/Fh2vlS1LChd6ALs=;
        b=Z3AePu2kInFRVc7RExPBPt0MtzeFWX9UQAh3nTu6OccULgG5enkAgTQ+lps5UzsDJsejCU
        6LbjA8TS3tEMATaNxu3E1eJIJWWY8oP7QIRE1+3uKRiLX7QtzJC2248AIZzoy0c44IIJ/E
        XPBdW19NAIbWs8z84UvMSUS1tcTvcsk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-218-aq4Hzee9Orivlo-jD0h1_w-1; Mon, 06 Mar 2023 16:28:17 -0500
X-MC-Unique: aq4Hzee9Orivlo-jD0h1_w-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8092A803471
        for <linux-raid@vger.kernel.org>; Mon,  6 Mar 2023 21:28:15 +0000 (UTC)
Received: from o.redhat.com (unknown [10.39.192.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BD86840C83B6;
        Mon,  6 Mar 2023 21:28:14 +0000 (UTC)
From:   heinzm@redhat.com
To:     linux-raid@vger.kernel.org
Cc:     ncroxon@redhat.com, xni@redhat.com, dkeefe@redhat.com
Subject: [PATCH 16/34] md: fix block comments [WARNING]
Date:   Mon,  6 Mar 2023 22:27:39 +0100
Message-Id: <309d10f7fe5326585c314317e87056907ec51537.1678136717.git.heinzm@redhat.com>
In-Reply-To: <cover.1678136717.git.heinzm@redhat.com>
References: <cover.1678136717.git.heinzm@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

From: Heinz Mauelshagen <heinzm@redhat.com>

Signed-off-by: heinzm <heinzm@redhat.com>
---
 drivers/md/md-bitmap.c   |  30 +++++-----
 drivers/md/md-cluster.c  |  17 ++++--
 drivers/md/md-linear.c   |  16 +++---
 drivers/md/md.c          | 121 ++++++++++++++++++++-------------------
 drivers/md/raid0.c       |  31 +++++-----
 drivers/md/raid1.c       |  18 +++---
 drivers/md/raid10.c      |  23 ++++----
 drivers/md/raid5-cache.c |  24 ++++----
 drivers/md/raid5-ppl.c   |  11 ++--
 drivers/md/raid5.c       |  15 +++--
 include/linux/raid/pq.h  |   5 +-
 11 files changed, 159 insertions(+), 152 deletions(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index fcf516d7fcff..9f1e25927d13 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -95,8 +95,7 @@ __acquires(bitmap->lock)
 		/* We don't support hijack for cluster raid */
 		if (no_hijack)
 			return -ENOMEM;
-		/* failed - set the hijacked flag so that we can use the
-		 * pointer as a counter */
+		/* failed - set the hijacked flag so that we can use the pointer as a counter */
 		if (!bitmap->bp[page].map)
 			bitmap->bp[page].hijacked = 1;
 	} else if (bitmap->bp[page].map ||
@@ -815,8 +814,7 @@ static int md_bitmap_storage_alloc(struct bitmap_storage *store,
 	}
 	store->file_pages = pnum;
 
-	/* We need 4 bits per page, rounded up to a multiple
-	 * of sizeof(unsigned long) */
+	/* We need 4 bits per page, rounded up to a multiple of sizeof(unsigned long) */
 	store->filemap_attr = kzalloc(
 		roundup(DIV_ROUND_UP(num_pages*4, 8), sizeof(unsigned long)),
 		GFP_KERNEL);
@@ -887,7 +885,8 @@ static void md_bitmap_file_kick(struct bitmap *bitmap)
 enum bitmap_page_attr {
 	BITMAP_PAGE_DIRTY = 0,     /* there are set bits that need to be synced */
 	BITMAP_PAGE_PENDING = 1,   /* there are bits that are being cleaned.
-				    * i.e. counter is 1 or 2. */
+				    * i.e. counter is 1 or 2.
+				    */
 	BITMAP_PAGE_NEEDWRITE = 2, /* there are cleared bits that need to be synced */
 };
 
@@ -1003,7 +1002,8 @@ static int md_bitmap_file_test_bit(struct bitmap *bitmap, sector_t block)
 
 /* this gets called when the md device is ready to unplug its underlying
  * (slave) device queues -- before we let any writes go down, we need to
- * sync the dirty pages of the bitmap file to disk */
+ * sync the dirty pages of the bitmap file to disk
+ */
 void md_bitmap_unplug(struct bitmap *bitmap)
 {
 	unsigned long i;
@@ -1014,8 +1014,7 @@ void md_bitmap_unplug(struct bitmap *bitmap)
 	    test_bit(BITMAP_STALE, &bitmap->flags))
 		return;
 
-	/* look at each page to see if there are any set bits that need to be
-	 * flushed out to disk */
+	/* look at each page to see if there are any set bits that need to be flushed out to disk */
 	for (i = 0; i < bitmap->storage.file_pages; i++) {
 		dirty = test_and_clear_page_attr(bitmap, i, BITMAP_PAGE_DIRTY);
 		need_write = test_and_clear_page_attr(bitmap, i,
@@ -1269,8 +1268,7 @@ void md_bitmap_daemon_work(struct mddev *mddev)
 
 	if (bitmap->need_sync &&
 	    mddev->bitmap_info.external == 0) {
-		/* Arrange for superblock update as well as
-		 * other changes */
+		/* Arrange for superblock update as well as other changes */
 		bitmap_super_t *sb;
 
 		bitmap->need_sync = 0;
@@ -1383,8 +1381,7 @@ __acquires(bitmap->lock)
 	/* now locked ... */
 
 	if (bitmap->bp[page].hijacked) { /* hijacked pointer */
-		/* should we use the first or second counter field
-		 * of the hijacked pointer? */
+		/* should we use the first or second counter field of the hijacked pointer? */
 		int hi = (pageoff > PAGE_COUNTER_MASK);
 
 		return  &((bitmap_counter_t *)
@@ -1879,8 +1876,7 @@ struct bitmap *md_bitmap_create(struct mddev *mddev, int slot)
 		err = 0;
 		if (mddev->bitmap_info.chunksize == 0 ||
 		    mddev->bitmap_info.daemon_sleep == 0)
-			/* chunksize and time_base need to be
-			 * set first. */
+			/* chunksize and time_base need to be set first. */
 			err = -EINVAL;
 	}
 	if (err)
@@ -1936,8 +1932,7 @@ int md_bitmap_load(struct mddev *mddev)
 
 	if (mddev->degraded == 0
 	    || bitmap->events_cleared == mddev->events)
-		/* no need to keep dirty bits to optimise a
-		 * re-add of a missing device */
+		/* no need to keep dirty bits to optimise a re-add of a missing device */
 		start = mddev->recovery_cp;
 
 	mutex_lock(&mddev->bitmap_info.mutex);
@@ -2018,7 +2013,8 @@ int md_bitmap_copy_from_slot(struct mddev *mddev, int slot,
 	if (clear_bits) {
 		md_bitmap_update_sb(bitmap);
 		/* BITMAP_PAGE_PENDING is set, but bitmap_unplug needs
-		 * BITMAP_PAGE_DIRTY or _NEEDWRITE to write ... */
+		 * BITMAP_PAGE_DIRTY or _NEEDWRITE to write ...
+		 */
 		for (i = 0; i < bitmap->storage.file_pages; i++)
 			if (test_page_attr(bitmap, i, BITMAP_PAGE_PENDING))
 				set_page_attr(bitmap, i, BITMAP_PAGE_NEEDWRITE);
diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
index b61b1fba1c77..7ad5e1a97638 100644
--- a/drivers/md/md-cluster.c
+++ b/drivers/md/md-cluster.c
@@ -52,7 +52,8 @@ struct resync_info {
  */
 #define		MD_CLUSTER_SEND_LOCKED_ALREADY		5
 /* We should receive message after node joined cluster and
- * set up all the related infos such as bitmap and personality */
+ * set up all the related infos such as bitmap and personalityi
+ */
 #define		MD_CLUSTER_ALREADY_IN_CLUSTER		6
 #define		MD_CLUSTER_PENDING_RECV_EVENT		7
 #define		MD_CLUSTER_HOLDING_MUTEX_FOR_RECVD	8
@@ -331,7 +332,8 @@ static void recover_bitmaps(struct md_thread *thread)
 			if (lo < mddev->recovery_cp)
 				mddev->recovery_cp = lo;
 			/* wake up thread to continue resync in case resync
-			 * is not finished */
+			 * is not finished
+			 */
 			if (mddev->recovery_cp != MaxSector) {
 				/*
 				 * clear the REMOTE flag since we will launch
@@ -383,7 +385,8 @@ static void recover_slot(void *arg, struct dlm_slot *slot)
 			slot->nodeid, slot->slot,
 			cinfo->slot_number);
 	/* deduct one since dlm slot starts from one while the num of
-	 * cluster-md begins with 0 */
+	 * cluster-md begins with 0
+	 */
 	__recover_slot(mddev, slot->slot - 1);
 }
 
@@ -396,7 +399,8 @@ static void recover_done(void *arg, struct dlm_slot *slots,
 
 	cinfo->slot_number = our_slot;
 	/* completion is only need to be complete when node join cluster,
-	 * it doesn't need to run during another node's failure */
+	 * it doesn't need to run during another node's failure
+	 */
 	if (test_bit(MD_CLUSTER_BEGIN_JOIN_CLUSTER, &cinfo->state)) {
 		complete(&cinfo->completion);
 		clear_bit(MD_CLUSTER_BEGIN_JOIN_CLUSTER, &cinfo->state);
@@ -405,7 +409,8 @@ static void recover_done(void *arg, struct dlm_slot *slots,
 }
 
 /* the ops is called when node join the cluster, and do lock recovery
- * if node failure occurs */
+ * if node failure occurs
+ */
 static const struct dlm_lockspace_ops md_ls_ops = {
 	.recover_prep = recover_prep,
 	.recover_slot = recover_slot,
@@ -1443,7 +1448,7 @@ static int add_new_disk(struct mddev *mddev, struct md_rdev *rdev)
 		 *
 		 * For other failure cases, metadata_update_cancel and
 		 * add_new_disk_cancel also clear below bit as well.
-		 * */
+		 */
 		set_bit(MD_CLUSTER_SEND_LOCKED_ALREADY, &cinfo->state);
 		wake_up(&cinfo->wait);
 	}
diff --git a/drivers/md/md-linear.c b/drivers/md/md-linear.c
index 35383589ec77..dc307ea05fe1 100644
--- a/drivers/md/md-linear.c
+++ b/drivers/md/md-linear.c
@@ -1,13 +1,13 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
 /*
-   linear.c : Multiple Devices driver for Linux
-	      Copyright (C) 1994-96 Marc ZYNGIER
-	      <zyngier@ufr-info-p7.ibp.fr> or
-	      <maz@gloups.fdn.fr>
-
-   Linear mode management functions.
-
-*/
+ * linear.c : Multiple Devices driver for Linux
+ *	      Copyright (C) 1994-96 Marc ZYNGIER
+ *	      <zyngier@ufr-info-p7.ibp.fr> or
+ *	      <maz@gloups.fdn.fr>
+ *
+ * Linear mode management functions.
+ *
+ */
 
 #include <linux/blkdev.h>
 #include <linux/raid/md_u.h>
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 187fe8a25fc1..e63543c98ba6 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -1,40 +1,39 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
 /*
-   md.c : Multiple Devices driver for Linux
-     Copyright (C) 1998, 1999, 2000 Ingo Molnar
-
-     completely rewritten, based on the MD driver code from Marc Zyngier
-
-   Changes:
-
-   - RAID-1/RAID-5 extensions by Miguel de Icaza, Gadi Oxman, Ingo Molnar
-   - RAID-6 extensions by H. Peter Anvin <hpa@zytor.com>
-   - boot support for linear and striped mode by Harald Hoyer <HarryH@Royal.Net>
-   - kerneld support by Boris Tobotras <boris@xtalk.msk.su>
-   - kmod support by: Cyrus Durgin
-   - RAID0 bugfixes: Mark Anthony Lisher <markal@iname.com>
-   - Devfs support by Richard Gooch <rgooch@atnf.csiro.au>
-
-   - lots of fixes and improvements to the RAID1/RAID5 and generic
-     RAID code (such as request based resynchronization):
-
-     Neil Brown <neilb@cse.unsw.edu.au>.
-
-   - persistent bitmap code
-     Copyright (C) 2003-2004, Paul Clements, SteelEye Technology, Inc.
-
-
-   Errors, Warnings, etc.
-   Please use:
-     pr_crit() for error conditions that risk data loss
-     pr_err()  for error conditions that are unexpected, like an IO error or internal inconsistency
-     pr_warn() for error conditions that could have been predicated, like
-	       adding a device to an array when it has incompatible metadata
-     pr_info() for every interesting, very rare events, like an array starting
-	       for stopping, or resync starting or stopping
-     pr_debug() for everything else.
-
-*/
+ * md.c : Multiple Devices driver for Linux
+ *   Copyright (C) 1998, 1999, 2000 Ingo Molnar
+ *
+ *   completely rewritten, based on the MD driver code from Marc Zyngier
+ *
+ * Changes:
+ *
+ * - RAID-1/RAID-5 extensions by Miguel de Icaza, Gadi Oxman, Ingo Molnar
+ * - RAID-6 extensions by H. Peter Anvin <hpa@zytor.com>
+ * - boot support for linear and striped mode by Harald Hoyer <HarryH@Royal.Net>
+ * - kerneld support by Boris Tobotras <boris@xtalk.msk.su>
+ * - kmod support by: Cyrus Durgin
+ * - RAID0 bugfixes: Mark Anthony Lisher <markal@iname.com>
+ * - Devfs support by Richard Gooch <rgooch@atnf.csiro.au>
+ *
+ * - lots of fixes and improvements to the RAID1/RAID5 and generic
+ *   RAID code (such as request based resynchronization):
+ *
+ *   Neil Brown <neilb@cse.unsw.edu.au>.
+ *
+ * - persistent bitmap code
+ *   Copyright (C) 2003-2004, Paul Clements, SteelEye Technology, Inc.
+ *
+ *
+ * Errors, Warnings, etc.
+ * Please use:
+ *   pr_crit() for error conditions that risk data loss
+ *   pr_err()  for error conditions that are unexpected, like an IO error or internal inconsistency
+ *   pr_warn() for error conditions that could have been predicated, like
+ *	       adding a device to an array when it has incompatible metadata
+ *   pr_info() for every interesting, very rare events, like an array starting
+ *	       for stopping, or resync starting or stopping
+ *   pr_debug() for everything else.
+ */
 
 #include <linux/sched/mm.h>
 #include <linux/sched/signal.h>
@@ -655,8 +654,7 @@ void mddev_put(struct mddev *mddev)
 		return;
 	if (!mddev->raid_disks && list_empty(&mddev->disks) &&
 	    mddev->ctime == 0 && !mddev->hold_active) {
-		/* Array is not configured at all, and not held active,
-		 * so destroy it */
+		/* Array is not configured at all, and not held active, so destroy it */
 		set_bit(MD_DELETED, &mddev->flags);
 
 		/*
@@ -1353,7 +1351,8 @@ static int super_90_validate(struct mddev *mddev, struct md_rdev *rdev)
 
 	} else if (mddev->pers == NULL) {
 		/* Insist on good event counter while assembling, except
-		 * for spares (which don't need an event count) */
+		 * for spares (which don't need an event count)
+		 */
 		++ev1;
 		if (sb->disks[rdev->desc_nr].state & (
 			    (1<<MD_DISK_SYNC) | (1 << MD_DISK_ACTIVE)))
@@ -1378,15 +1377,16 @@ static int super_90_validate(struct mddev *mddev, struct md_rdev *rdev)
 
 		if (desc->state & (1<<MD_DISK_FAULTY))
 			set_bit(Faulty, &rdev->flags);
-		else if (desc->state & (1<<MD_DISK_SYNC) /* &&
-			    desc->raid_disk < mddev->raid_disks */) {
+		else if (desc->state & (1<<MD_DISK_SYNC)
+			/* && desc->raid_disk < mddev->raid_disks */) {
 			set_bit(In_sync, &rdev->flags);
 			rdev->raid_disk = desc->raid_disk;
 			rdev->saved_raid_disk = desc->raid_disk;
 		} else if (desc->state & (1<<MD_DISK_ACTIVE)) {
 			/* active but not in sync implies recovery up to
 			 * reshape position.  We don't know exactly where
-			 * that is, so set to zero for now */
+			 * that is, so set to zero for now
+			 */
 			if (mddev->minor_version >= 91) {
 				rdev->recovery_offset = 0;
 				rdev->raid_disk = desc->raid_disk;
@@ -1886,7 +1886,8 @@ static int super_1_validate(struct mddev *mddev, struct md_rdev *rdev)
 		}
 	} else if (mddev->pers == NULL) {
 		/* Insist of good event counter while assembling, except for
-		 * spares (which don't need an event count) */
+		 * spares (which don't need an event count)
+		 */
 		++ev1;
 		if (rdev->desc_nr >= 0 &&
 		    rdev->desc_nr < le32_to_cpu(sb->max_dev) &&
@@ -2214,8 +2215,7 @@ super_1_allow_new_offset(struct md_rdev *rdev,
 	if (new_offset >= rdev->data_offset)
 		return 1;
 
-	/* with 1.0 metadata, there is no metadata to tread on
-	 * so we can always move back */
+	/* with 1.0 metadata, there is no metadata to tread on so we can always move back */
 	if (rdev->mddev->minor_version == 0)
 		return 1;
 
@@ -2729,7 +2729,8 @@ void md_update_sb(struct mddev *mddev, int force_change)
 	sync_req = mddev->in_sync;
 
 	/* If this is just a dirty<->clean transition, and the array is clean
-	 * and 'events' is odd, we can roll back to the previous clean state */
+	 * and 'events' is odd, we can roll back to the previous clean state
+	 */
 	if (nospares
 	    && (mddev->in_sync && mddev->recovery_cp == MaxSector)
 	    && mddev->can_decrease_events
@@ -3237,8 +3238,7 @@ offset_store(struct md_rdev *rdev, const char *buf, size_t len)
 	if (rdev->mddev->pers && rdev->raid_disk >= 0)
 		return -EBUSY;
 	if (rdev->sectors && rdev->mddev->external)
-		/* Must set offset before size, so overlap checks
-		 * can be sane */
+		/* Must set offset before size, so overlap checks can be sane */
 		return -EBUSY;
 	rdev->data_offset = offset;
 	rdev->new_data_offset = offset;
@@ -4324,9 +4324,9 @@ __ATTR_PREALLOC(resync_start, S_IRUGO|S_IWUSR,
  *     like active, but no writes have been seen for a while (100msec).
  *
  * broken
-*     Array is failed. It's useful because mounted-arrays aren't stopped
-*     when array is failed, so this state will at least alert the user that
-*     something is wrong.
+ *     Array is failed. It's useful because mounted-arrays aren't stopped
+ *     when array is failed, so this state will at least alert the user that
+ *     something is wrong.
  */
 enum array_state { clear, inactive, suspended, readonly, read_auto, clean, active,
 		   write_pending, active_idle, broken, bad_word};
@@ -6317,7 +6317,8 @@ static int md_set_readonly(struct mddev *mddev, struct block_device *bdev)
 		set_bit(MD_RECOVERY_INTR, &mddev->recovery);
 	if (mddev->sync_thread)
 		/* Thread might be blocked waiting for metadata update
-		 * which will now never happen */
+		 * which will now never happen
+		 */
 		wake_up_process(mddev->sync_thread->tsk);
 
 	if (mddev->external && test_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags))
@@ -6381,7 +6382,8 @@ static int do_md_stop(struct mddev *mddev, int mode,
 		set_bit(MD_RECOVERY_INTR, &mddev->recovery);
 	if (mddev->sync_thread)
 		/* Thread might be blocked waiting for metadata update
-		 * which will now never happen */
+		 * which will now never happen
+		 */
 		wake_up_process(mddev->sync_thread->tsk);
 
 	mddev_unlock(mddev);
@@ -7649,7 +7651,8 @@ static int md_ioctl(struct block_device *bdev, fmode_t mode,
 	 * Commands querying/configuring an existing array:
 	 */
 	/* if we are not initialised yet, only ADD_NEW_DISK, STOP_ARRAY,
-	 * RUN_ARRAY, and GET_ and SET_BITMAP_FILE are allowed */
+	 * RUN_ARRAY, and GET_ and SET_BITMAP_FILE are allowed
+	 */
 	if ((!mddev->raid_disks && !mddev->external)
 	    && cmd != ADD_NEW_DISK && cmd != STOP_ARRAY
 	    && cmd != RUN_ARRAY && cmd != SET_BITMAP_FILE
@@ -9126,9 +9129,9 @@ void md_do_sync(struct md_thread *thread)
 		}
 	}
  skip:
-	/* set CHANGE_PENDING here since maybe another update is needed,
-	 * so other nodes are informed. It should be harmless for normal
-	 * raid */
+	/* set CHANGE_PENDING here since maybe another update is needed, so other
+	 * so other nodes are informed. It should be harmless for normal raid
+	 */
 	set_mask_bits(&mddev->sb_flags, 0,
 		      BIT(MD_SB_CHANGE_PENDING) | BIT(MD_SB_CHANGE_DEVS));
 
@@ -9522,7 +9525,8 @@ void md_reap_sync_thread(struct mddev *mddev)
 	md_update_sb(mddev, 1);
 	/* MD_SB_CHANGE_PENDING should be cleared by md_update_sb, so we can
 	 * call resync_finish here if MD_CLUSTER_RESYNC_LOCKED is set by
-	 * clustered raid */
+	 * clustered raidxi
+	 */
 	if (test_and_clear_bit(MD_CLUSTER_RESYNC_LOCKED, &mddev->flags))
 		md_cluster_ops->resync_finish(mddev);
 	clear_bit(MD_RECOVERY_RUNNING, &mddev->recovery);
@@ -9760,7 +9764,8 @@ static void check_sb_changes(struct mddev *mddev, struct md_rdev *rdev)
 				pr_info("Activated spare: %pg\n",
 					rdev2->bdev);
 				/* wakeup mddev->thread here, so array could
-				 * perform resync with the new activated disk */
+				 * perform resync with the new activated disk
+				 */
 				set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
 				md_wakeup_thread(mddev->thread);
 			}
diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index 0fb47f4d78bf..0089f0657651 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -1,14 +1,14 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
 /*
-   raid0.c : Multiple Devices driver for Linux
-	     Copyright (C) 1994-96 Marc ZYNGIER
-	     <zyngier@ufr-info-p7.ibp.fr> or
-	     <maz@gloups.fdn.fr>
-	     Copyright (C) 1999, 2000 Ingo Molnar, Red Hat
-
-   RAID-0 management functions.
-
-*/
+ * raid0.c : Multiple Devices driver for Linux
+ *	     Copyright (C) 1994-96 Marc ZYNGIER
+ *	     <zyngier@ufr-info-p7.ibp.fr> or
+ *	     <maz@gloups.fdn.fr>
+ *	     Copyright (C) 1999, 2000 Ingo Molnar, Red Hat
+ *
+ * RAID-0 management functions.
+ *
+ */
 
 #include <linux/blkdev.h>
 #include <linux/seq_file.h>
@@ -31,7 +31,7 @@ module_param(default_layout, int, 0644);
 
 /*
  * inform the user of the raid configuration
-*/
+ */
 static void dump_zones(struct mddev *mddev)
 {
 	int j, k;
@@ -304,7 +304,7 @@ static struct strip_zone *find_zone(struct r0conf *conf,
 /*
  * remaps the bio to the target device. we separate two flows.
  * power 2 flow and a general flow for the sake of performance
-*/
+ */
 static struct md_rdev *map_sector(struct mddev *mddev, struct strip_zone *zone,
 				sector_t sector, sector_t *sector_offset)
 {
@@ -328,11 +328,10 @@ static struct md_rdev *map_sector(struct mddev *mddev, struct strip_zone *zone,
 		chunk = *sector_offset;
 		sector_div(chunk, chunk_sects * zone->nb_dev);
 	}
-	/*
-	*  position the bio over the real device
-	*  real sector = chunk in device + starting of zone
-	*	+ the position in the chunk
-	*/
+	/*  position the bio over the real device
+	 *  real sector = chunk in device + starting of zone
+	 *	+ the position in the chunk
+	 */
 	*sector_offset = (chunk * chunk_sects) + sect_in_chunk;
 	return conf->devlist[(zone - conf->strip_zone)*raid_disks
 			     + sector_div(sector, zone->nb_dev)];
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 42671d0147ea..5b7d1dea889d 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -380,8 +380,7 @@ static void raid1_end_read_request(struct bio *bio)
 		set_bit(R1BIO_Uptodate, &r1_bio->state);
 	else if (test_bit(FailFast, &rdev->flags) &&
 		 test_bit(R1BIO_FailFast, &r1_bio->state))
-		/* This was a fail-fast read so we definitely
-		 * want to retry */
+		/* This was a fail-fast read so we definitely want to retry */
 		;
 	else {
 		/* If all other devices have failed, we want to return
@@ -656,8 +655,7 @@ static int read_balance(struct r1conf *conf, struct r1bio *r1_bio, int *max_sect
 		    rdev->recovery_offset < this_sector + sectors)
 			continue;
 		if (test_bit(WriteMostly, &rdev->flags)) {
-			/* Don't balance among write-mostly, just
-			 * use the first as a last resort */
+			/* Don't balance among write-mostly, just use the first as a last resort */
 			if (best_dist_disk < 0) {
 				if (is_badblock(rdev, this_sector, sectors,
 						&first_bad, &bad_sectors)) {
@@ -1438,8 +1436,7 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
 			is_bad = is_badblock(rdev, r1_bio->sector, max_sectors,
 					     &first_bad, &bad_sectors);
 			if (is_bad < 0) {
-				/* mustn't write here until the bad block is
-				 * acknowledged*/
+				/* mustn't write here until the bad block is acknowledge */
 				set_bit(BlockedBadBlocks, &rdev->flags);
 				blocked_rdev = rdev;
 				break;
@@ -1533,7 +1530,8 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
 			/* do behind I/O ?
 			 * Not if there are too many, or cannot
 			 * allocate memory, or a reader on WriteMostly
-			 * is waiting for behind writes to flush */
+			 * is waiting for behind writes to flush
+			 */
 			if (bitmap &&
 			    test_bit(WriteMostly, &rdev->flags) &&
 			    (atomic_read(&bitmap->behind_writes)
@@ -2042,7 +2040,8 @@ static int fix_sync_read_error(struct r1bio *r1_bio)
 	rdev = conf->mirrors[r1_bio->read_disk].rdev;
 	if (test_bit(FailFast, &rdev->flags)) {
 		/* Don't try recovering from here - just fail it
-		 * ... unless it is the last working device of course */
+		 * ... unless it is the last working device of course
+		 */
 		md_error(mddev, rdev);
 		if (test_bit(Faulty, &rdev->flags))
 			/* Don't try to read from here, but make sure
@@ -2879,8 +2878,7 @@ static sector_t raid1_sync_request(struct mddev *mddev, sector_t sector_nr,
 
 	}
 	if (min_bad > 0 && min_bad < good_sectors) {
-		/* only resync enough to reach the next bad->good
-		 * transition */
+		/* only resync enough to reach the next bad->good transition */
 		good_sectors = min_bad;
 	}
 
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 61eb64ecd373..510000de0886 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -108,8 +108,7 @@ static void *r10bio_pool_alloc(gfp_t gfp_flags, void *data)
 	struct r10conf *conf = data;
 	int size = offsetof(struct r10bio, devs[conf->geo.raid_disks]);
 
-	/* allocate a r10bio with room for raid_disks entries in the
-	 * bios array */
+	/* allocate a r10bio with room for raid_disks entries in the bios array */
 	return kzalloc(size, gfp_flags);
 }
 
@@ -905,8 +904,7 @@ static void flush_pending_writes(struct r10conf *conf)
 		__set_current_state(TASK_RUNNING);
 
 		blk_start_plug(&plug);
-		/* flush any pending bitmap writes to disk
-		 * before proceeding w/ I/O */
+		/* flush any pending bitmap writes to disk before proceeding w/ I/O */
 		md_bitmap_unplug(conf->mddev->bitmap);
 		wake_up(&conf->wait_barrier);
 
@@ -2082,7 +2080,8 @@ static void print_conf(struct r10conf *conf)
 		 conf->geo.raid_disks);
 
 	/* This is only called with ->reconfix_mutex held, so
-	 * rcu protection of rdev is not needed */
+	 * rcu protection of rdev is not needed
+	 */
 	for (i = 0; i < conf->geo.raid_disks; i++) {
 		rdev = conf->mirrors[i].rdev;
 		if (rdev)
@@ -2744,8 +2743,7 @@ static void fix_read_error(struct r10conf *conf, struct mddev *mddev, struct r10
 	rdev = conf->mirrors[d].rdev;
 
 	if (test_bit(Faulty, &rdev->flags))
-		/* drive has already been failed, just ignore any
-		   more fix_read_error() attempts */
+		/* drive has already been failed, just ignore any more fix_read_error() attempts */
 		return;
 
 	check_decay_read_errors(mddev, rdev);
@@ -3625,8 +3623,7 @@ static sector_t raid10_sync_request(struct mddev *mddev, sector_t sector_nr,
 			}
 			rcu_read_unlock();
 			if (j == conf->copies) {
-				/* Cannot recover, so abort the recovery or
-				 * record a bad block */
+				/* Cannot recover, so abort the recovery or record a bad block */
 				if (any_working) {
 					/* problem is that there are bad blocks
 					 * on other device(s)
@@ -4000,8 +3997,7 @@ static int setup_geo(struct geom *geo, struct mddev *mddev, enum geo_type new)
 		disks = mddev->raid_disks;
 		break;
 	default: /* avoid 'may be unused' warnings */
-	case geo_start: /* new when starting reshape - raid_disks not
-			 * updated yet. */
+	case geo_start: /* new when starting reshape - raid_disks not updated yet. */
 		layout = mddev->new_layout;
 		chunk = mddev->new_chunk_sectors;
 		disks = mddev->raid_disks + mddev->delta_disks;
@@ -4024,7 +4020,8 @@ static int setup_geo(struct geom *geo, struct mddev *mddev, enum geo_type new)
 		geo->far_set_size = disks;
 		break;
 	case 1: /* "improved" layout which was buggy.  Hopefully no-one is
-		 * actually using this, but leave code here just in case.*/
+		 * actually using this, but leave code here just in case.
+		 */
 		geo->far_set_size = disks/fc;
 		WARN(geo->far_set_size < fc,
 		     "This RAID10 layout does not provide data safety - please backup and create new array\n");
@@ -4962,7 +4959,7 @@ static sector_t reshape_request(struct mddev *mddev, sector_t sector_nr,
 	/*
 	 * Broadcast RESYNC message to other nodes, so all nodes would not
 	 * write to the region to avoid conflict.
-	*/
+	 */
 	if (mddev_is_clustered(mddev) && conf->cluster_sync_high <= sector_nr) {
 		struct mdp_superblock_1 *sb = NULL;
 		int sb_reshape_pos = 0;
diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index 123cc38d4a02..f40ee2101796 100644
--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -84,13 +84,10 @@ struct r5l_log {
 
 	u32 uuid_checksum;
 
-	sector_t device_size;		/* log device size, round to
-					 * BLOCK_SECTORS */
-	sector_t max_free_space;	/* reclaim run if free space is at
-					 * this size */
+	sector_t device_size;		/* log device size, round to BLOCK_SECTORS */
+	sector_t max_free_space;	/* reclaim run if free space is at this size */
 
-	sector_t last_checkpoint;	/* log tail. where recovery scan
-					 * starts from */
+	sector_t last_checkpoint;	/* log tail. where recovery scan starts from */
 	u64 last_cp_seq;		/* log tail sequence */
 
 	sector_t log_start;		/* log head. where new data appends */
@@ -104,12 +101,13 @@ struct r5l_log {
 	spinlock_t io_list_lock;
 	struct list_head running_ios;	/* io_units which are still running,
 					 * and have not yet been completely
-					 * written to the log */
+					 * written to the log
+					 */
 	struct list_head io_end_ios;	/* io_units which have been completely
 					 * written to the log but not yet written
-					 * to the RAID */
-	struct list_head flushing_ios;	/* io_units which are waiting for log
-					 * cache flush */
+					 * to the RAID
+					 */
+	struct list_head flushing_ios;	/* io_units which are waiting for log cache flush */
 	struct list_head finished_ios;	/* io_units which settle down in log disk */
 	struct bio flush_bio;
 
@@ -127,7 +125,8 @@ struct r5l_log {
 					 * IO_UNIT_STRIPE_END state (eg, reclaim
 					 * doesn't wait for specific io_unit
 					 * switching to IO_UNIT_STRIPE_END
-					 * state) */
+					 * state)
+					 */
 	wait_queue_head_t iounit_wait;
 
 	struct list_head no_space_stripes; /* pending stripes, log has no space */
@@ -242,7 +241,8 @@ struct r5l_io_unit {
 enum r5l_io_unit_state {
 	IO_UNIT_RUNNING = 0,	/* accepting new IO */
 	IO_UNIT_IO_START = 1,	/* io_unit bio start writing to log,
-				 * don't accepting new bio */
+				 * don't accepting new bio
+				 */
 	IO_UNIT_IO_END = 2,	/* io_unit bio finish writing to log */
 	IO_UNIT_STRIPE_END = 3,	/* stripes data finished writing to raid */
 };
diff --git a/drivers/md/raid5-ppl.c b/drivers/md/raid5-ppl.c
index 3ba595ec6ad8..cfff345951db 100644
--- a/drivers/md/raid5-ppl.c
+++ b/drivers/md/raid5-ppl.c
@@ -92,7 +92,8 @@ struct ppl_conf {
 	int count;
 
 	int block_size;		/* the logical block size used for data_sector
-				 * in ppl_header_entry */
+				 * in ppl_header_entryxi
+				 */
 	u32 signature;		/* raid array identifier */
 	atomic64_t seq;		/* current log write sequence number */
 
@@ -115,11 +116,13 @@ struct ppl_conf {
 struct ppl_log {
 	struct ppl_conf *ppl_conf;	/* shared between all log instances */
 
-	struct md_rdev *rdev;		/* array member disk associated with
-					 * this log instance */
+	struct md_rdev *rdev;		/* array member disk associated
+					 * with this log instance
+					 */
 	struct mutex io_mutex;
 	struct ppl_io_unit *current_io;	/* current io_unit accepting new data
-					 * always at the end of io_list */
+					 * always at the end of io_list
+					 */
 	spinlock_t io_list_lock;
 	struct list_head io_list;	/* all io_units of this log */
 
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 55afe09202c0..08a0ee77cacb 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -1233,7 +1233,8 @@ static void ops_run_io(struct stripe_head *sh, struct stripe_head_state *s)
 					/* It is very unlikely, but we might
 					 * still need to write out the
 					 * bad block log - better give it
-					 * a chance*/
+					 * a chance
+					 */
 					md_check_recovery(conf->mddev);
 				}
 				/*
@@ -4837,7 +4838,8 @@ static void analyse_stripe(struct stripe_head *sh, struct stripe_head_state *s)
 
 		if (test_bit(R5_WriteError, &dev->flags)) {
 			/* This flag does not apply to '.replacement'
-			 * only to .rdev, so make sure to check that*/
+			 * only to .rdev, so make sure to check that
+			 */
 			struct md_rdev *rdev2 = rcu_dereference(
 				conf->disks[i].rdev);
 			if (rdev2 == rdev)
@@ -4850,7 +4852,8 @@ static void analyse_stripe(struct stripe_head *sh, struct stripe_head_state *s)
 		}
 		if (test_bit(R5_MadeGood, &dev->flags)) {
 			/* This flag does not apply to '.replacement'
-			 * only to .rdev, so make sure to check that*/
+			 * only to .rdev, so make sure to check that
+			 */
 			struct md_rdev *rdev2 = rcu_dereference(
 				conf->disks[i].rdev);
 			if (rdev2 && !test_bit(Faulty, &rdev2->flags)) {
@@ -5035,7 +5038,8 @@ static void handle_stripe(struct stripe_head *sh)
 
 	if (test_and_set_bit_lock(STRIPE_ACTIVE, &sh->state)) {
 		/* already being handled, ensure it gets handled
-		 * again when current action finishes */
+		 * again when current action finishes
+		 */
 		set_bit(STRIPE_HANDLE, &sh->state);
 		return;
 	}
@@ -7874,8 +7878,7 @@ static int raid5_run(struct mddev *mddev)
 		/* here_new is the stripe we will write to */
 		here_old = mddev->reshape_position;
 		sector_div(here_old, chunk_sectors * (old_disks-max_degraded));
-		/* here_old is the first stripe that we might need to read
-		 * from */
+		/* here_old is the first stripe that we might need to read from */
 		if (mddev->delta_disks == 0) {
 			/* We cannot be sure it is safe to start an in-place
 			 * reshape.  It is only safe if user-space is monitoring
diff --git a/include/linux/raid/pq.h b/include/linux/raid/pq.h
index 9e7088e03852..7fa2bef58ff3 100644
--- a/include/linux/raid/pq.h
+++ b/include/linux/raid/pq.h
@@ -1,9 +1,10 @@
 /* SPDX-License-Identifier: GPL-2.0-or-later */
-/* -*- linux-c -*- ------------------------------------------------------- *
+/* -*- linux-c -*- -------------------------------------------------------
  *
  *   Copyright 2003 H. Peter Anvin - All Rights Reserved
  *
- * ----------------------------------------------------------------------- */
+ * -----------------------------------------------------------------------
+ */
 
 #ifndef LINUX_RAID_RAID6_H
 #define LINUX_RAID_RAID6_H
-- 
2.39.2

