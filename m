Received: from mail-ej2-f12.google.com (mail-ej2-f12.google.com [74.125.228.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6B324EBAED
	for <linux-raid@vger.kernel.org>; Mon,  7 Sep 2026 13:39:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788788384; cv=none; b=BZH737oreNU7IQurBJzO31127KCRUjfxQ9ponA7hKd5s7Obfjp4c4u+psrR7bF8SZXLTAQbl/dXo2CTUOvfzbZyfAVxSkbwjioG+Bad4vME9dU8h3lFfM0JAzuzv7dGkt6y546BDN+LS0P5wl15p9oYzOkNxgXUY19tMjcLNzGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788788384; c=relaxed/simple;
	bh=bA0dugMMcgla+thapureiuTjx5lv/VXzMsLQPVT9V/A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dD7xJ257MwhAg0md09/ftpjru9LqOnZy31bdpDTsJ8JN4jn7IZxf/Jed+WGnADdu5fD+ZJoPv8AYiOVARcziJEJAOx//lfDfne29i5b8mwrSpCWynfraaLEXJKWGxv0a7o+QTnFpm78jexu1wdMnTP0FNd4j48swajGyTAAWhvk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ionos.com; spf=pass smtp.mailfrom=ionos.com; dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b=QLZj34XH; arc=none smtp.client-ip=74.125.228.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b="QLZj34XH"
Received: by mail-ej2-f12.google.com with SMTP id a640c23a62f3a-c252fb14159so49419166b.1
        for <linux-raid@vger.kernel.org>; Mon, 07 Sep 2026 06:39:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1788788380; x=1789393180; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ef7tRt74/32hJPZX/Kbw3PIctGdA0rrNTIV4VwBkDXo=;
        b=QLZj34XHkfVhvcxdqPna/hCUKStqAia+ba7gLPqkNweiSBiHmgSVwvmWoV/3DTyFM8
         XWjonxe8bjteqa0MNvVcedNJ5t6g1XqvJ+j8T8JQ9xDNrH4cw79/tMo88Ta4sMUdqqPj
         s9pUgpBPvsRj7fW1ae/V7g6/Ohvmesg8Lm8A/smxPL69PXA/IMHY6bqDYHAYQnE7NE2t
         m8YPcJjMPZKAtniEhgbspGMmJFEpHquafQIJqd+S9ogF3NTHZx3R+Y604q9EA3zgJ2CU
         6ZOzD1LEq1q518K5XGKfNqg4r3ukRXw68jZWGdc+1SGEgiTuIvJussOkmemik87aLWNM
         IEjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788788380; x=1789393180;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ef7tRt74/32hJPZX/Kbw3PIctGdA0rrNTIV4VwBkDXo=;
        b=P7AcnuRWYZ+tFE98PaDzraseGWc98HDfc3GzcWdYyvdZe2hjhfpaUt6YMzf0SvxdND
         josYWqHSYCY/Qr+mFfT3AIlUqalaOEaUDL9DV2DAXzc6uKpFT79rtNkdCbNY5BQ/p/FO
         CvV04UXyXoJr/3og9xBBwnjYmVgh+o/6Wag+NJWJ5uebB09zK0mX+ziTz9l4BDcq6A5z
         VTfmfWa4s6ea+fE8Z38s5NJRXmwztklfoC3D8jNle0AkBFdxwm4yJ2fGc8sVBujR5jBy
         fE9vb5sGirDiEkAxhYTJpE9jt4AqE/PkYfrkO6cGfo/FhIa7RjXtiNbfFGBrozYtvj+0
         AoDg==
X-Gm-Message-State: AFuF++mXaRm+YF8damrHXTqkxxdnBto89asXB7FQpQSd77SZJgPdbYai
	M1zb+rHuBwN+jLuyNRpjXkj6pDoo/AzmUwEDuGYQn1s0LF5sjzFXkU1Hy/c4G+H5Qy8=
X-Gm-Gg: AYBFou0m8J+i/fuIUGYP18Vlzweje2rRWNJsnWXbyxkkZnZgGV1k7UyXtjNsZ9jyRXU
	CU+PajdH3MaXM0G6MaEN/jgIRCjD6ECEnnJJziQ/CGT94rAQirMJ5ynBE7Wrpd0+d044hmGub84
	hOm8rTIKKTms8Oc83BqJe4At7LtS2GPtcjVYnMVhZLHMHZR+pP+EpsVnpA4pB9K0byvnE1agLmF
	SpsRpwX5rZepwQLgLedd+1h77iyndzzKwFW0OHN5xxWBgr3RPZ99VCGCv0VTfKadi8v9pGYw4yc
	cumKlt/3Tr4N3H2h9jow1pOAgnXxrjLlj6nEh9XXYMlelPKogfJnfgF0QwoRR6vleeailxXHX62
	g3lTvIfrk1YjSgMURJwTfSfjwRRa9nMr2pmIr2O6+C2ThJV481lfkAiRQqe0VhSgF3ThZuovOJ/
	ZLtibA38eM/RIEpL1q7bxhg4A3XPpbTZ9YRoc0mNkoK+uJ1lqVWgs+Fybsvj5rIL/ecBak7lwoa
	fwoBH6q4FmWMafn6wIZD1oHrzOLoXFxag==
X-Received: by 2002:a17:906:c115:b0:c25:3ec4:9e43 with SMTP id a640c23a62f3a-c2624d2422emr530526266b.0.1788788379684;
        Mon, 07 Sep 2026 06:39:39 -0700 (PDT)
Received: from jwang-ThinkPad-T14-Gen-6.fkb.profitbricks.net ([212.227.34.98])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c262c770678sm314301866b.53.2026.09.07.06.39.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Sep 2026 06:39:39 -0700 (PDT)
From: Jack Wang <jinpu.wang@ionos.com>
To: Nilay Shroff <nilay@linux.ibm.com>,
	abd.masalkhi@gmail.com
Cc: linux-raid <linux-raid@vger.kernel.org>,
	linux-block <linux-block@vger.kernel.org>,
	Song Liu <song@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	Yu Kuai <yukuai@fygo.io>,
	tom.leiming@gmail.com,
	Jack Wang <jinpu.wang@cloud.ionos.com>
Subject: [PATCH 6/6] md: take q->limits_lock before locking and suspending the array
Date: Mon,  7 Sep 2026 15:39:29 +0200
Message-ID: <20260907133929.1081540-7-jinpu.wang@ionos.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260907133929.1081540-1-jinpu.wang@ionos.com>
References: <20260907133929.1081540-1-jinpu.wang@ionos.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Jack Wang <jinpu.wang@cloud.ionos.com>

Writing a queue limits attribute while a spare is re-added deadlocks
the array:

  udev-worker    queue_attr_store() holds q->limits_lock, waits in
                 blk_mq_freeze_queue() for q_usage_counter to drain
  fio            holds a q_usage_counter reference, parked in
                 md_handle_request()'s is_suspended() loop
  mdadm          suspended the array, waits for reconfig_mutex
  md_start_sync  holds reconfig_mutex, waits for q->limits_lock

Blocking on q->limits_lock while holding reconfig_mutex, or with the
array suspended, is waiting for normal I/O, which mddev_suspend()
already warns about:

	 * hold reconfig_mutex to wait for normal io will deadlock, because
	 * other context can't update super_block, and normal io can rely on
	 * updating super_block.
	lockdep_assert_not_held(&mddev->reconfig_mutex);

The lock's holder waits for the queue to drain, and that I/O can be
parked on mddev->suspended, which another task holds while waiting for
reconfig_mutex.  So q->limits_lock has to nest outside both.

Take the update before the array is locked and suspended, and pass it
down so the personality stacks into it:

  - md_start_sync(), at both suspend points
  - md_ioctl() for ADD_NEW_DISK and HOT_REMOVE_DISK
  - rdev_attr_store(), for slot and for state "remove"/"re-add"
  - raid5 skip_copy_store(), which took the lock while suspended

They are converted together because a mix of the two orders is an ABBA.
All of them commit while the array is still quiesced.

Two callers still take the lock inside reconfig_mutex, both with the
array suspended: ->start_reshape() from action_store(), which suspends
before flushing sync_work so the update cannot be held across it, and
raid*_run() -> queue_limits_set() from level_store(), which already
hangs on its own because it freezes the queue while suspended.

Verified with a raid1 of two ram devices, fio in flight and a loop
writing queue/max_sectors_kb: 20 fail/remove/add cycles complete, where
the same test wedges the array before the change.  A reshape and a level
change are not covered by it.

Fixes: c99f66e4084a ("block: fix queue freeze vs limits lock order in sysfs store methods")
Assisted-by: Claude:claude-opus-5
Signed-off-by: Jack Wang <jinpu.wang@ionos.com>
---
 drivers/md/md-autodetect.c |   2 +-
 drivers/md/md.c            | 116 +++++++++++++++++++++++++++++++------
 drivers/md/md.h            |   3 +-
 drivers/md/raid5.c         |  31 +++++++---
 4 files changed, 124 insertions(+), 28 deletions(-)

diff --git a/drivers/md/md-autodetect.c b/drivers/md/md-autodetect.c
index 4b80165afd23..929513109657 100644
--- a/drivers/md/md-autodetect.c
+++ b/drivers/md/md-autodetect.c
@@ -213,7 +213,7 @@ static void __init md_setup_drive(struct md_setup_args *args)
 				(1 << MD_DISK_ACTIVE) | (1 << MD_DISK_SYNC);
 		}
 
-		md_add_new_disk(mddev, &dinfo);
+		md_add_new_disk(mddev, &dinfo, NULL);
 	}
 
 	if (!err)
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 6af11a74db57..c4054d06d107 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -2981,7 +2981,7 @@ void md_update_sb(struct mddev *mddev, int force_change)
 }
 EXPORT_SYMBOL(md_update_sb);
 
-static int add_bound_rdev(struct md_rdev *rdev)
+static int add_bound_rdev(struct md_rdev *rdev, struct queue_limits *lim)
 {
 	struct mddev *mddev = rdev->mddev;
 	int err = 0;
@@ -2994,7 +2994,7 @@ static int add_bound_rdev(struct md_rdev *rdev)
 		 */
 		super_types[mddev->major_version].
 			validate_super(mddev, NULL/*freshest*/, rdev);
-		err = mddev->pers->hot_add_disk(mddev, rdev, NULL);
+		err = mddev->pers->hot_add_disk(mddev, rdev, lim);
 		if (err) {
 			md_kick_rdev_from_array(rdev);
 			return err;
@@ -3117,7 +3117,7 @@ state_store(struct md_rdev *rdev, const char *buf, size_t len,
 	} else if (cmd_match(buf, "remove")) {
 		if (rdev->mddev->pers) {
 			clear_bit(Blocked, &rdev->flags);
-			remove_and_add_spares(rdev->mddev, rdev, NULL);
+			remove_and_add_spares(rdev->mddev, rdev, lim);
 		}
 		if (rdev->raid_disk >= 0)
 			err = -EBUSY;
@@ -3236,7 +3236,7 @@ state_store(struct md_rdev *rdev, const char *buf, size_t len,
 			if (!mddev_is_clustered(rdev->mddev) ||
 			    (err = mddev->cluster_ops->gather_bitmaps(rdev)) == 0) {
 				clear_bit(Faulty, &rdev->flags);
-				err = add_bound_rdev(rdev);
+				err = add_bound_rdev(rdev, lim);
 			}
 		} else
 			err = -EBUSY;
@@ -3323,7 +3323,7 @@ slot_store(struct md_rdev *rdev, const char *buf, size_t len,
 		if (rdev->mddev->pers->hot_remove_disk == NULL)
 			return -EINVAL;
 		clear_bit(Blocked, &rdev->flags);
-		remove_and_add_spares(rdev->mddev, rdev, NULL);
+		remove_and_add_spares(rdev->mddev, rdev, lim);
 		if (rdev->raid_disk >= 0)
 			return -EBUSY;
 		set_bit(MD_RECOVERY_NEEDED, &rdev->mddev->recovery);
@@ -3354,7 +3354,7 @@ slot_store(struct md_rdev *rdev, const char *buf, size_t len,
 		clear_bit(In_sync, &rdev->flags);
 		clear_bit(Bitmap_sync, &rdev->flags);
 		err = rdev->mddev->pers->hot_add_disk(rdev->mddev, rdev,
-						     NULL);
+						     lim);
 		if (err) {
 			rdev->raid_disk = -1;
 			return err;
@@ -3760,6 +3760,9 @@ rdev_attr_store(struct kobject *kobj, struct attribute *attr,
 	struct rdev_sysfs_entry *entry = container_of(attr, struct rdev_sysfs_entry, attr);
 	struct md_rdev *rdev = container_of(kobj, struct md_rdev, kobj);
 	struct kernfs_node *kn = NULL;
+	struct request_queue *q = NULL;
+	struct queue_limits lim;
+	struct queue_limits *limp = NULL;
 	bool suspend = false;
 	ssize_t rv;
 	struct mddev *mddev = READ_ONCE(rdev->mddev);
@@ -3780,15 +3783,37 @@ rdev_attr_store(struct kobject *kobj, struct attribute *attr,
 			suspend = true;
 	}
 
+	/*
+	 * These can add a leg back, which stacks its limits; the other
+	 * state_store() values never reach ->hot_add_disk().  q->limits_lock
+	 * nests outside the lock and the suspend, see md_start_sync().
+	 */
+	if ((entry->store == slot_store ||
+	     (entry->store == state_store &&
+	      (cmd_match(page, "remove") || cmd_match(page, "re-add")))) &&
+	    !mddev_is_dm(mddev)) {
+		q = mddev->gendisk->queue;
+		lim = queue_limits_start_update(q);
+		limp = &lim;
+	}
+
 	rv = suspend ? mddev_suspend_and_lock(mddev) : mddev_lock(mddev);
 	if (!rv) {
 		if (rdev->mddev == NULL)
 			rv = -ENODEV;
 		else
-			rv = entry->store(rdev, page, length, NULL);
+			rv = entry->store(rdev, page, length, limp);
+		/* apply the limits before the array takes I/O again */
+		if (limp) {
+			queue_limits_commit_update(q, limp);
+			limp = NULL;
+		}
 		suspend ? mddev_unlock_and_resume(mddev) : mddev_unlock(mddev);
 	}
 
+	if (limp)
+		queue_limits_commit_update(q, limp);
+
 	if (kn)
 		sysfs_unbreak_active_protection(kn);
 
@@ -7575,7 +7600,8 @@ static int get_disk_info(struct mddev *mddev, void __user * arg)
 	return 0;
 }
 
-int md_add_new_disk(struct mddev *mddev, struct mdu_disk_info_s *info)
+int md_add_new_disk(struct mddev *mddev, struct mdu_disk_info_s *info,
+		    struct queue_limits *lim)
 {
 	struct md_rdev *rdev;
 	dev_t dev = MKDEV(info->major,info->minor);
@@ -7723,11 +7749,11 @@ int md_add_new_disk(struct mddev *mddev, struct mdu_disk_info_s *info)
 				if (err)
 					mddev->cluster_ops->add_new_disk_cancel(mddev);
 				else
-					err = add_bound_rdev(rdev);
+					err = add_bound_rdev(rdev, lim);
 			}
 
 		} else if (!err)
-			err = add_bound_rdev(rdev);
+			err = add_bound_rdev(rdev, lim);
 
 		return err;
 	}
@@ -7780,7 +7806,8 @@ int md_add_new_disk(struct mddev *mddev, struct mdu_disk_info_s *info)
 	return 0;
 }
 
-static int hot_remove_disk(struct mddev *mddev, dev_t dev)
+static int hot_remove_disk(struct mddev *mddev, dev_t dev,
+			   struct queue_limits *lim)
 {
 	struct md_rdev *rdev;
 
@@ -7795,7 +7822,7 @@ static int hot_remove_disk(struct mddev *mddev, dev_t dev)
 		goto kick_rdev;
 
 	clear_bit(Blocked, &rdev->flags);
-	remove_and_add_spares(mddev, rdev, NULL);
+	remove_and_add_spares(mddev, rdev, lim);
 
 	if (rdev->raid_disk >= 0)
 		goto busy;
@@ -8380,6 +8407,22 @@ static inline int md_ioctl_valid(unsigned int cmd)
 	}
 }
 
+/*
+ * Commands that can reach ->hot_add_disk().  ADD_NEW_DISK only does so for a
+ * journal device or a personality without ->hot_remove_disk, but that depends
+ * on disk info still in user memory here, so it is included as a whole.
+ */
+static bool md_ioctl_may_add_disk(unsigned int cmd)
+{
+	switch (cmd) {
+	case ADD_NEW_DISK:
+	case HOT_REMOVE_DISK:
+		return true;
+	default:
+		return false;
+	}
+}
+
 static bool md_ioctl_need_suspend(unsigned int cmd)
 {
 	switch (cmd) {
@@ -8435,6 +8478,9 @@ static int md_ioctl(struct block_device *bdev, blk_mode_t mode,
 	unsigned int noio_flags = 0;
 	void __user *argp = (void __user *)arg;
 	struct mddev *mddev = NULL;
+	struct request_queue *q = NULL;
+	struct queue_limits lim;
+	struct queue_limits *limp = NULL;
 	bool suspend;
 
 	err = md_ioctl_valid(cmd);
@@ -8485,11 +8531,20 @@ static int md_ioctl(struct block_device *bdev, blk_mode_t mode,
 	if (!md_is_rdwr(mddev))
 		flush_work(&mddev->sync_work);
 
+	/* q->limits_lock nests outside both, see md_start_sync() */
+	if (md_ioctl_may_add_disk(cmd) && !mddev_is_dm(mddev)) {
+		q = mddev->gendisk->queue;
+		lim = queue_limits_start_update(q);
+		limp = &lim;
+	}
+
 	suspend = md_ioctl_need_suspend(cmd);
 	err = suspend ? mddev_suspend_and_lock(mddev) : mddev_lock(mddev);
 	if (err) {
 		pr_debug("md: ioctl lock interrupted, reason %d, cmd %d\n",
 			 err, cmd);
+		if (limp)
+			queue_limits_cancel_update(q);
 		goto out;
 	}
 	if (suspend)
@@ -8531,7 +8586,7 @@ static int md_ioctl(struct block_device *bdev, blk_mode_t mode,
 		goto unlock;
 
 	case HOT_REMOVE_DISK:
-		err = hot_remove_disk(mddev, new_decode_dev(arg));
+		err = hot_remove_disk(mddev, new_decode_dev(arg), limp);
 		goto unlock;
 
 	case ADD_NEW_DISK:
@@ -8547,7 +8602,7 @@ static int md_ioctl(struct block_device *bdev, blk_mode_t mode,
 				/* Need to clear read-only for this */
 				break;
 			else
-				err = md_add_new_disk(mddev, &info);
+				err = md_add_new_disk(mddev, &info, limp);
 			goto unlock;
 		}
 		break;
@@ -8585,7 +8640,7 @@ static int md_ioctl(struct block_device *bdev, blk_mode_t mode,
 		if (copy_from_user(&info, argp, sizeof(info)))
 			err = -EFAULT;
 		else
-			err = md_add_new_disk(mddev, &info);
+			err = md_add_new_disk(mddev, &info, limp);
 		goto unlock;
 	}
 
@@ -8618,6 +8673,9 @@ static int md_ioctl(struct block_device *bdev, blk_mode_t mode,
 	    err != -EINVAL)
 		mddev->hold_active = 0;
 
+	if (limp)
+		queue_limits_commit_update(q, limp);
+
 	if (suspend) {
 		memalloc_noio_restore(noio_flags);
 		mddev_unlock_and_resume(mddev);
@@ -10346,6 +10404,9 @@ static bool md_choose_sync_action(struct mddev *mddev, int *spares,
 static void md_start_sync(struct work_struct *ws)
 {
 	struct mddev *mddev = container_of(ws, struct mddev, sync_work);
+	struct request_queue *q = NULL;
+	struct queue_limits lim;
+	struct queue_limits *limp = NULL;
 	int spares = 0;
 	bool suspend = false;
 	unsigned int noio_flags = 0;
@@ -10357,6 +10418,17 @@ static void md_start_sync(struct work_struct *ws)
 	 */
 	if ((mddev->reshape_position == MaxSector || !md_is_rdwr(mddev)) &&
 	    md_spares_need_change(mddev)) {
+		/*
+		 * Adding a spare below stacks its limits, which needs
+		 * q->limits_lock.  Take it before suspending: its holder
+		 * waits in blk_mq_freeze_queue() for I/O that
+		 * mddev->suspended holds back, so the other order deadlocks.
+		 */
+		if (!mddev_is_dm(mddev)) {
+			q = mddev->gendisk->queue;
+			lim = queue_limits_start_update(q);
+			limp = &lim;
+		}
 		suspend = true;
 		mddev_suspend(mddev, false);
 		noio_flags = memalloc_noio_save();
@@ -10371,6 +10443,12 @@ static void md_start_sync(struct work_struct *ws)
 	if (!suspend && (mddev->reshape_position == MaxSector || !md_is_rdwr(mddev)) &&
 	    md_spares_need_change(mddev)) {
 		mddev_unlock(mddev);
+		/* see above: q->limits_lock nests outside both */
+		if (!mddev_is_dm(mddev)) {
+			q = mddev->gendisk->queue;
+			lim = queue_limits_start_update(q);
+			limp = &lim;
+		}
 		mddev_suspend_and_lock_nointr(mddev);
 		suspend = true;
 		noio_flags = memalloc_noio_save();
@@ -10384,11 +10462,11 @@ static void md_start_sync(struct work_struct *ws)
 		 * As we only add devices that are already in-sync, we can
 		 * activate the spares immediately.
 		 */
-		remove_and_add_spares(mddev, NULL, NULL);
+		remove_and_add_spares(mddev, NULL, limp);
 		goto not_running;
 	}
 
-	if (!md_choose_sync_action(mddev, &spares, NULL))
+	if (!md_choose_sync_action(mddev, &spares, limp))
 		goto not_running;
 
 	if (!mddev->pers->sync_request)
@@ -10419,6 +10497,8 @@ static void md_start_sync(struct work_struct *ws)
 	 *     https://bugzilla.kernel.org/show_bug.cgi?id=218200
 	 * Therefore, use __mddev_resume(mddev, false).
 	 */
+	if (limp)
+		queue_limits_commit_update(q, limp);
 	if (suspend) {
 		memalloc_noio_restore(noio_flags);
 		__mddev_resume(mddev, false);
@@ -10441,6 +10521,8 @@ static void md_start_sync(struct work_struct *ws)
 	 *     https://bugzilla.kernel.org/show_bug.cgi?id=218200
 	 * Therefore, use __mddev_resume(mddev, false).
 	 */
+	if (limp)
+		queue_limits_commit_update(q, limp);
 	if (suspend) {
 		memalloc_noio_restore(noio_flags);
 		__mddev_resume(mddev, false);
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 9e3bd5ab5519..ceca8cfcdcb9 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -1042,7 +1042,8 @@ struct mdu_disk_info_s;
 extern int mdp_major;
 void md_autostart_arrays(int part);
 int md_set_array_info(struct mddev *mddev, struct mdu_array_info_s *info);
-int md_add_new_disk(struct mddev *mddev, struct mdu_disk_info_s *info);
+int md_add_new_disk(struct mddev *mddev, struct mdu_disk_info_s *info,
+		    struct queue_limits *lim);
 int do_md_run(struct mddev *mddev);
 #define MDDEV_STACK_INTEGRITY	(1u << 0)
 int mddev_stack_rdev_limits(struct mddev *mddev, struct queue_limits *lim,
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 3faa2a94c03b..22759c631c4d 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -7288,6 +7288,9 @@ static ssize_t
 raid5_store_skip_copy(struct mddev *mddev, const char *page, size_t len)
 {
 	struct r5conf *conf;
+	struct request_queue *q = NULL;
+	struct queue_limits lim;
+	struct queue_limits *limp = NULL;
 	unsigned long new;
 	int err;
 
@@ -7297,23 +7300,33 @@ raid5_store_skip_copy(struct mddev *mddev, const char *page, size_t len)
 		return -EINVAL;
 	new = !!new;
 
+	/* q->limits_lock nests outside both, see md_start_sync() */
+	if (!mddev_is_dm(mddev)) {
+		q = mddev->gendisk->queue;
+		lim = queue_limits_start_update(q);
+		limp = &lim;
+	}
+
 	err = mddev_suspend_and_lock(mddev);
-	if (err)
+	if (err) {
+		if (limp)
+			queue_limits_cancel_update(q);
 		return err;
+	}
 	conf = mddev->private;
 	if (!conf)
 		err = -ENODEV;
 	else if (new != conf->skip_copy) {
-		struct request_queue *q = mddev->gendisk->queue;
-		struct queue_limits lim = queue_limits_start_update(q);
-
 		conf->skip_copy = new;
-		if (new)
-			lim.features |= BLK_FEAT_STABLE_WRITES;
-		else
-			lim.features &= ~BLK_FEAT_STABLE_WRITES;
-		err = queue_limits_commit_update(q, &lim);
+		if (limp) {
+			if (new)
+				limp->features |= BLK_FEAT_STABLE_WRITES;
+			else
+				limp->features &= ~BLK_FEAT_STABLE_WRITES;
+		}
 	}
+	if (limp)
+		err = queue_limits_commit_update(q, limp) ?: err;
 	mddev_unlock_and_resume(mddev);
 	return err ?: len;
 }
-- 
2.43.0

