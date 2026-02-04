Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFE654218A0
	for <linux-raid@vger.kernel.org>; Wed,  4 Feb 2026 14:59:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770217167; cv=none; b=KTotA2TOctg+NotSedOEs6GBzst9sDCHnAlLqT/+WThx3huEcd9qFaguipIsUSj1ow3ef+CiumOOpyUuSgNh0H4BWFhFWw53G1UFYMgOoJvP9MxzgtToicVCZ4b6gs/e0m2JiG/BtXE5O/2MLjdH5UieAIphVTF4rlvitvb0wU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770217167; c=relaxed/simple;
	bh=gu/o3WUEsSounTpnS9gC8+/f5HXRqdckLgfPXbu4He4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZHOUumW4My0SKP2/pniqJvKx7xzwHqDdSv9+HrFdqZ9dt4x5IaDyNudcxFS2GEr6Qj3TbPbqHRpgBQEFdFBsdkqBWQM3J1CoLllafuNxLhEQqUKONniFE1SCf709HHDaktJFuqQ1izACAYhZsOkhr32jE9AxKHz/eGWErjc/ZFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YvDxCgzw; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YvDxCgzw"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770217165;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=z1RXk0VYNTnS5HsgmgCu9CVEYcbbAT8XpS0XeCrsuTk=;
	b=YvDxCgzwSiW3t6q2d6rrEJuvdImEVGq43nFO1z89awadopxoFkJag8x27ovwuukb4xcWVu
	n6MUSn+ZAMhdke3Q+KdT0JVh67UrZW58vSarxxBqSdvYLTLVWugLxeOpJPYQYdzg4iaQPI
	aqD4ppDIvyEajI56gT/pWTxEQ/upHvQ=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-665-F1pUrhsnNyeQ5arvmTP_8g-1; Wed,
 04 Feb 2026 09:59:22 -0500
X-MC-Unique: F1pUrhsnNyeQ5arvmTP_8g-1
X-Mimecast-MFC-AGG-ID: F1pUrhsnNyeQ5arvmTP_8g_1770217161
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7398719560B5;
	Wed,  4 Feb 2026 14:59:21 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.112.66])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id D35A019560A3;
	Wed,  4 Feb 2026 14:59:19 +0000 (UTC)
From: Xiao Ni <xni@redhat.com>
To: yukuai@fnnas.com
Cc: linux-raid@vger.kernel.org
Subject: [PATCH RFC 2/3] md/raid1: fix data corruption by moving serialization to mddev level
Date: Wed,  4 Feb 2026 22:58:56 +0800
Message-ID: <20260204145912.9463-3-xni@redhat.com>
In-Reply-To: <20260204145912.9463-1-xni@redhat.com>
References: <20260204145912.9463-1-xni@redhat.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

Overlap io request is handled in per-rdev serialization now. Overlap io
requests need to wait and are woken up when one overlap io returns. But
the sequence of getting the lock after waking up maybe different in
member disks.

For example:
bio1 (100,200)
bio2 (150,200)
bio3 (160,200)
bio1 is writing and bio2/bio3 are waiting. It wakes up bio2/bio3 when bio1
finishes. bio2 gets the lock and is submitted to disk0. But in disk1, bio3
gets the lock and is submitted. Finally, the data on member disks are
different. Even if they get locks in the same order, the lower drivers
don't guarantee the sequence that bios are landed in disks. It still has
a risk that member disks have different data.

So per-rdev serialization cannot guarantee ordering across different
member disks when multiple requests are queued. Each disk's wake_up()
independently wakes waiters, but the order they reacquire locks is
undefined.

Fix by moving serialization from per-rdev to per-mddev level:
- Change serial data structure from rdev->serial to mddev->serial
- Call wait_for_serialization() once per r1_bio at mddev level
  before submitting to any disk
- Call remove_serial() once in r1_bio_write_done() after all disks
  complete, instead of per-rdev in raid1_end_write_request()

This ensures:
- All member disks see identical write ordering
- Only one wait queue exists for each sector range
- Wake-up ordering issues cannot cause cross-disk inconsistency

Signed-off-by: Xiao Ni <xni@redhat.com>
---
 drivers/md/md.c    | 143 ++++++++++++---------------------------------
 drivers/md/md.h    |  28 ++++-----
 drivers/md/raid1.c |  45 +++++++-------
 3 files changed, 71 insertions(+), 145 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 115df70354ed..c113af3865ac 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -152,69 +152,37 @@ static int sync_io_depth(struct mddev *mddev)
 		mddev->sync_io_depth : sysctl_sync_io_depth;
 }
 
-static void rdev_uninit_serial(struct md_rdev *rdev)
+static void mddev_uninit_serial(struct mddev *mddev)
 {
-	if (!test_and_clear_bit(CollisionCheck, &rdev->flags))
-		return;
-
-	kvfree(rdev->serial);
-	rdev->serial = NULL;
+	kvfree(mddev->serial);
+	mddev->serial = NULL;
 }
 
-static void rdevs_uninit_serial(struct mddev *mddev)
-{
-	struct md_rdev *rdev;
-
-	rdev_for_each(rdev, mddev)
-		rdev_uninit_serial(rdev);
-}
-
-static int rdev_init_serial(struct md_rdev *rdev)
+static int mddev_init_serial(struct mddev *mddev)
 {
 	/* serial_nums equals with BARRIER_BUCKETS_NR */
 	int i, serial_nums = 1 << ((PAGE_SHIFT - ilog2(sizeof(atomic_t))));
-	struct serial_in_rdev *serial = NULL;
-
-	if (test_bit(CollisionCheck, &rdev->flags))
-		return 0;
+	struct serial *serial = NULL;
 
-	serial = kvmalloc(sizeof(struct serial_in_rdev) * serial_nums,
+	serial = kvmalloc_array(serial_nums, sizeof(struct serial),
 			  GFP_KERNEL);
-	if (!serial)
+	if (!serial) {
+		pr_err("failed to alloc serial\n");
 		return -ENOMEM;
+	}
 
 	for (i = 0; i < serial_nums; i++) {
-		struct serial_in_rdev *serial_tmp = &serial[i];
+		struct serial *serial_tmp = &serial[i];
 
 		spin_lock_init(&serial_tmp->serial_lock);
 		serial_tmp->serial_rb = RB_ROOT_CACHED;
 		init_waitqueue_head(&serial_tmp->serial_io_wait);
 	}
 
-	rdev->serial = serial;
-	set_bit(CollisionCheck, &rdev->flags);
-
+	mddev->serial = serial;
 	return 0;
 }
 
-static int rdevs_init_serial(struct mddev *mddev)
-{
-	struct md_rdev *rdev;
-	int ret = 0;
-
-	rdev_for_each(rdev, mddev) {
-		ret = rdev_init_serial(rdev);
-		if (ret)
-			break;
-	}
-
-	/* Free all resources if pool is not existed */
-	if (ret && !mddev->serial_info_pool)
-		rdevs_uninit_serial(mddev);
-
-	return ret;
-}
-
 /*
  * rdev needs to enable serial stuffs if it meets the conditions:
  * 1. it is multi-queue device flaged with writemostly.
@@ -236,72 +204,40 @@ int mddev_create_serial_pool(struct mddev *mddev, struct md_rdev *rdev)
 {
 	int ret = 0;
 
-	if (rdev && !rdev_need_serial(rdev) &&
-	    !test_bit(CollisionCheck, &rdev->flags))
+	if (mddev->serial_info_pool)
 		return ret;
 
-	if (!rdev)
-		ret = rdevs_init_serial(mddev);
-	else
-		ret = rdev_init_serial(rdev);
-	if (ret)
+	/* return success if rdev doesn't support serial */
+	if (rdev && !rdev_need_serial(rdev))
 		return ret;
 
-	if (mddev->serial_info_pool == NULL) {
-		/*
-		 * already in memalloc noio context by
-		 * mddev_suspend()
-		 */
-		mddev->serial_info_pool =
-			mempool_create_kmalloc_pool(NR_SERIAL_INFOS,
-						sizeof(struct serial_info));
-		if (!mddev->serial_info_pool) {
-			rdevs_uninit_serial(mddev);
-			pr_err("can't alloc memory pool for serialization\n");
-			ret = -ENOMEM;
-		}
+	ret = mddev_init_serial(mddev);
+	if (ret)
+		return ret;
+	/*
+	 * already in memalloc noio context by
+	 * mddev_suspend()
+	 */
+	mddev->serial_info_pool = mempool_create_kmalloc_pool(
+			NR_SERIAL_INFOS, sizeof(struct serial_info));
+	if (!mddev->serial_info_pool) {
+		mddev_uninit_serial(mddev);
+		pr_err("can't alloc memory pool for serialization\n");
+		ret = -ENOMEM;
 	}
 
+	set_bit(MD_SERIAL, &mddev->flags);
 	return ret;
 }
 
-/*
- * Free resource from rdev(s), and destroy serial_info_pool under conditions:
- * 1. rdev is the last device flaged with CollisionCheck.
- * 2. when bitmap is destroyed while policy is not enabled.
- * 3. for disable policy, the pool is destroyed only when no rdev needs it.
- */
 void mddev_destroy_serial_pool(struct mddev *mddev, struct md_rdev *rdev)
 {
-	if (rdev && !test_bit(CollisionCheck, &rdev->flags))
+	if (!mddev->serial_info_pool)
 		return;
-
-	if (mddev->serial_info_pool) {
-		struct md_rdev *temp;
-		int num = 0; /* used to track if other rdevs need the pool */
-
-		rdev_for_each(temp, mddev) {
-			if (!rdev) {
-				if (!mddev->serialize_policy ||
-				    !rdev_need_serial(temp))
-					rdev_uninit_serial(temp);
-				else
-					num++;
-			} else if (temp != rdev &&
-				   test_bit(CollisionCheck, &temp->flags))
-				num++;
-		}
-
-		if (rdev)
-			rdev_uninit_serial(rdev);
-
-		if (num)
-			pr_info("The mempool could be used by other devices\n");
-		else {
-			mempool_destroy(mddev->serial_info_pool);
-			mddev->serial_info_pool = NULL;
-		}
-	}
+	mddev_uninit_serial(mddev);
+	mempool_destroy(mddev->serial_info_pool);
+	mddev->serial_info_pool = NULL;
+	clear_bit(MD_SERIAL, &mddev->flags);
 }
 
 static struct ctl_table_header *raid_table_header;
@@ -6633,18 +6569,13 @@ int md_run(struct mddev *mddev)
 		bool create_pool = false;
 
 		rdev_for_each(rdev, mddev) {
-			if (test_bit(WriteMostly, &rdev->flags) &&
-			    rdev_init_serial(rdev))
+			if (test_bit(WriteMostly, &rdev->flags))
 				create_pool = true;
 		}
-		if (create_pool && mddev->serial_info_pool == NULL) {
-			mddev->serial_info_pool =
-				mempool_create_kmalloc_pool(NR_SERIAL_INFOS,
-						    sizeof(struct serial_info));
-			if (!mddev->serial_info_pool) {
-				err = -ENOMEM;
+		if (create_pool) {
+			err = mddev_create_serial_pool(mddev, NULL);
+			if (err)
 				goto bitmap_abort;
-			}
 		}
 	}
 
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 3c4edc6ed50e..7fc6d03b0c33 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -116,15 +116,6 @@ enum sync_action {
 	NR_SYNC_ACTIONS,
 };
 
-/*
- * The struct embedded in rdev is used to serialize IO.
- */
-struct serial_in_rdev {
-	struct rb_root_cached serial_rb;
-	spinlock_t serial_lock;
-	wait_queue_head_t serial_io_wait;
-};
-
 /*
  * MD's 'extended' device
  */
@@ -204,8 +195,6 @@ struct md_rdev {
 					   * in superblock.
 					   */
 
-	struct serial_in_rdev *serial;  /* used for raid1 io serialization */
-
 	struct kernfs_node *sysfs_state; /* handle for 'state'
 					   * sysfs entry */
 	/* handle for 'unacknowledged_bad_blocks' sysfs dentry */
@@ -286,10 +275,6 @@ enum flag_bits {
 				 * it didn't fail, so don't use FailFast
 				 * any more for metadata
 				 */
-	CollisionCheck,		/*
-				 * check if there is collision between raid1
-				 * serial bios.
-				 */
 	Nonrot,			/* non-rotational device (SSD) */
 };
 
@@ -356,6 +341,7 @@ enum mddev_flags {
 	MD_BROKEN,
 	MD_DO_DELETE,
 	MD_DELETED,
+	MD_SERIAL,
 };
 
 enum mddev_sb_flags {
@@ -389,6 +375,15 @@ enum {
 	MD_RESYNC_ACTIVE = 3,
 };
 
+/*
+ * The struct embedded is used to serialize IO.
+ */
+struct serial {
+	struct rb_root_cached serial_rb;
+	spinlock_t serial_lock;
+	wait_queue_head_t serial_io_wait;
+};
+
 struct mddev {
 	void				*private;
 	struct md_personality		*pers;
@@ -607,7 +602,8 @@ struct mddev {
 	struct bio_set			io_clone_set;
 
 	struct work_struct event_work;	/* used by dm to report failure event */
-	mempool_t *serial_info_pool;
+	mempool_t				*serial_info_pool;
+	struct serial			*serial;  /* used for raid1 io serialization */
 	void (*sync_super)(struct mddev *mddev, struct md_rdev *rdev);
 	struct md_cluster_info		*cluster_info;
 	struct md_cluster_operations *cluster_ops;
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 57d50465eed1..029aa458ffb2 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -56,14 +56,14 @@ static void raid1_free(struct mddev *mddev, void *priv);
 INTERVAL_TREE_DEFINE(struct serial_info, node, sector_t, _subtree_last,
 		     START, LAST, static inline, raid1_rb);
 
-static int check_and_add_serial(struct md_rdev *rdev, struct r1bio *r1_bio,
+static int check_and_add_serial(struct mddev *mddev, struct r1bio *r1_bio,
 				struct serial_info *si, int idx)
 {
 	unsigned long flags;
 	int ret = 0;
 	sector_t lo = r1_bio->sector;
 	sector_t hi = lo + r1_bio->sectors;
-	struct serial_in_rdev *serial = &rdev->serial[idx];
+	struct serial *serial = &mddev->serial[idx];
 
 	spin_lock_irqsave(&serial->serial_lock, flags);
 	/* collision happened */
@@ -79,28 +79,33 @@ static int check_and_add_serial(struct md_rdev *rdev, struct r1bio *r1_bio,
 	return ret;
 }
 
-static void wait_for_serialization(struct md_rdev *rdev, struct r1bio *r1_bio)
+static void wait_for_serialization(struct mddev *mddev, struct r1bio *r1_bio)
 {
-	struct mddev *mddev = rdev->mddev;
 	struct serial_info *si;
 	int idx = sector_to_idx(r1_bio->sector);
-	struct serial_in_rdev *serial = &rdev->serial[idx];
+	struct serial *serial = &mddev->serial[idx];
 
-	if (WARN_ON(!mddev->serial_info_pool))
+	if (!test_bit(MD_SERIAL, &mddev->flags))
 		return;
+
 	si = mempool_alloc(mddev->serial_info_pool, GFP_NOIO);
 	wait_event(serial->serial_io_wait,
-		   check_and_add_serial(rdev, r1_bio, si, idx) == 0);
+		   check_and_add_serial(mddev, r1_bio, si, idx) == 0);
 }
 
-static void remove_serial(struct md_rdev *rdev, sector_t lo, sector_t hi)
+static void remove_serial(struct r1bio *r1_bio)
 {
 	struct serial_info *si;
 	unsigned long flags;
 	int found = 0;
-	struct mddev *mddev = rdev->mddev;
+	struct mddev *mddev = r1_bio->mddev;
+	sector_t lo = r1_bio->sector;
+	sector_t hi = r1_bio->sector + r1_bio->sectors;
 	int idx = sector_to_idx(lo);
-	struct serial_in_rdev *serial = &rdev->serial[idx];
+	struct serial *serial = &mddev->serial[idx];
+
+	if (!test_bit(MD_SERIAL, &mddev->flags))
+		return;
 
 	spin_lock_irqsave(&serial->serial_lock, flags);
 	for (si = raid1_rb_iter_first(&serial->serial_rb, lo, hi);
@@ -433,6 +438,8 @@ static void r1_bio_write_done(struct r1bio *r1_bio)
 	if (!atomic_dec_and_test(&r1_bio->remaining))
 		return;
 
+	remove_serial(r1_bio);
+
 	if (test_bit(R1BIO_WriteError, &r1_bio->state))
 		reschedule_retry(r1_bio);
 	else {
@@ -452,8 +459,6 @@ static void raid1_end_write_request(struct bio *bio)
 	struct bio *to_put = NULL;
 	int mirror = find_bio_disk(r1_bio, bio);
 	struct md_rdev *rdev = conf->mirrors[mirror].rdev;
-	sector_t lo = r1_bio->sector;
-	sector_t hi = r1_bio->sector + r1_bio->sectors;
 	bool ignore_error = !raid1_should_handle_error(bio) ||
 		(bio->bi_status && bio_op(bio) == REQ_OP_DISCARD);
 
@@ -518,8 +523,6 @@ static void raid1_end_write_request(struct bio *bio)
 	}
 
 	if (behind) {
-		if (test_bit(CollisionCheck, &rdev->flags))
-			remove_serial(rdev, lo, hi);
 		if (test_bit(WriteMostly, &rdev->flags))
 			atomic_dec(&r1_bio->behind_remaining);
 
@@ -542,8 +545,8 @@ static void raid1_end_write_request(struct bio *bio)
 				call_bio_endio(r1_bio);
 			}
 		}
-	} else if (rdev->mddev->serialize_policy)
-		remove_serial(rdev, lo, hi);
+	}
+
 	if (r1_bio->bios[mirror] == NULL)
 		rdev_dec_pending(rdev, conf->mddev);
 
@@ -1620,6 +1623,8 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
 
 	first_clone = 1;
 
+	wait_for_serialization(mddev, r1_bio);
+
 	for (i = 0; i < disks; i++) {
 		struct bio *mbio = NULL;
 		struct md_rdev *rdev = conf->mirrors[i].rdev;
@@ -1636,18 +1641,12 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
 			mbio = bio_alloc_clone(rdev->bdev,
 					       r1_bio->behind_master_bio,
 					       GFP_NOIO, &mddev->bio_set);
-			if (test_bit(CollisionCheck, &rdev->flags))
-				wait_for_serialization(rdev, r1_bio);
 			if (test_bit(WriteMostly, &rdev->flags))
 				atomic_inc(&r1_bio->behind_remaining);
-		} else {
+		} else
 			mbio = bio_alloc_clone(rdev->bdev, bio, GFP_NOIO,
 					       &mddev->bio_set);
 
-			if (mddev->serialize_policy)
-				wait_for_serialization(rdev, r1_bio);
-		}
-
 		mbio->bi_opf &= ~REQ_NOWAIT;
 		r1_bio->bios[i] = mbio;
 
-- 
2.50.1 (Apple Git-155)

