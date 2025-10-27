Received: from www5210.sakura.ne.jp (www5210.sakura.ne.jp [133.167.8.150])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F197309EF8
	for <linux-raid@vger.kernel.org>; Mon, 27 Oct 2025 15:05:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=133.167.8.150
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761577520; cv=none; b=i8btUcdtYoJwGb7h+8sSMFqSs7sb5E/tw8l1MnGZ8gYl6dlPlu/+YK4VAt+/X3uowqIsKpgTh7RqnyGd2+2Yfo5or7gExV632k12SSH8gx5wRm24rD3A9IkNggaT69a1Xpj3wBidAw6CadrosAAY85Rg/YV3B2Uggf9sThbqr9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761577520; c=relaxed/simple;
	bh=PM6Hw2/LEDcPJK1j1iuESreNSJB1IP7lLe9E6WPaptA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HmFdravKhZf5HafC8mNl3RzZ8yrMCN5le7oNUGUfyl2gzTDMi3wp5+BWnvVpLTrXlOeHvM0mI1bzE26Mm/+8H5rZGwh/rXvfl7X8DQgi5UrLcDlCJUAzab8gagFGmGb77/yoXIzhkpoyXzYPHqYL8hwVT/orQeb3BGefYOtUgsg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mgml.me; spf=pass smtp.mailfrom=mgml.me; dkim=pass (2048-bit key) header.d=mgml.me header.i=@mgml.me header.b=PxQAV1tl; arc=none smtp.client-ip=133.167.8.150
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mgml.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mgml.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mgml.me header.i=@mgml.me header.b="PxQAV1tl"
Received: from fedora (p3796170-ipxg00h01tokaisakaetozai.aichi.ocn.ne.jp [180.53.173.170])
	(authenticated bits=0)
	by www5210.sakura.ne.jp (8.16.1/8.16.1) with ESMTPSA id 59RF4hAb090988
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Tue, 28 Oct 2025 00:04:45 +0900 (JST)
	(envelope-from k@mgml.me)
DKIM-Signature: a=rsa-sha256; bh=CBmmouvA1pbrUQTqO+Cc93MjVtgweINh+DXoNfYQxpA=;
        c=relaxed/relaxed; d=mgml.me;
        h=From:To:Subject:Date:Message-ID;
        s=rs20250315; t=1761577485; v=1;
        b=PxQAV1tlkBQIereR8urIM0X2lEL4q+lH7aYEgTAoG6gf+KNQraGeYNDnzn1KQPDZ
         +vJICqNP6dy1tKhWHgNCeqHhrLKF/C25h7laIpkYw5F6nA27fhsWAepwbpEin/0m
         cNyQbDOm9UC5rbeixLV6vNWJb6Lvf8xJfWgy+1/DtGr95inexOXzJ6EhxDXVK4Dp
         pawlZm6MnKQMSLvem5ie2d4Tp+fG6DBt2Me7+YT5vmGWIZJ7xiV1cJz1Yg00OzFt
         F6h5UIbP9EucpQ5S2F9csOWH4rd+eIeNvhWeux8ZVBgWUHlcU+K93XvMCMdrqQiY
         qpfO8kafvLuUsz3zL+hLuw==
From: Kenta Akagi <k@mgml.me>
To: Song Liu <song@kernel.org>, Yu Kuai <yukuai@fnnas.com>,
        Shaohua Li <shli@fb.com>, Mariusz Tkaczyk <mtkaczyk@kernel.org>,
        Guoqing Jiang <jgq516@gmail.com>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kenta Akagi <k@mgml.me>
Subject: [PATCH v5 01/16] md: move device_lock from conf to mddev
Date: Tue, 28 Oct 2025 00:04:18 +0900
Message-ID: <20251027150433.18193-2-k@mgml.me>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20251027150433.18193-1-k@mgml.me>
References: <20251027150433.18193-1-k@mgml.me>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Move device_lock from mddev->private (r1conf, r10conf, r5conf)
to the mddev structure in preparation for serializing md_error() and
introducing new function that conditional md_error() calls to
improvement failfast bio error handling.

This commit only moves the device_lock location with no functional
changes. Subsequent commits will serialize md_error() and introduce
a new function that calls md_error() conditionally.

Signed-off-by: Kenta Akagi <k@mgml.me>
---
 drivers/md/md.c          |   1 +
 drivers/md/md.h          |   2 +
 drivers/md/raid1.c       |  51 +++++++-------
 drivers/md/raid1.h       |   2 -
 drivers/md/raid10.c      |  61 +++++++++--------
 drivers/md/raid10.h      |   1 -
 drivers/md/raid5-cache.c |  16 ++---
 drivers/md/raid5.c       | 139 +++++++++++++++++++--------------------
 drivers/md/raid5.h       |   1 -
 9 files changed, 135 insertions(+), 139 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 6062e0deb616..d667580e3125 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -760,6 +760,7 @@ int mddev_init(struct mddev *mddev)
 	atomic_set(&mddev->openers, 0);
 	atomic_set(&mddev->sync_seq, 0);
 	spin_lock_init(&mddev->lock);
+	spin_lock_init(&mddev->device_lock);
 	init_waitqueue_head(&mddev->sb_wait);
 	init_waitqueue_head(&mddev->recovery_wait);
 	mddev->reshape_position = MaxSector;
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 5d5f780b8447..64ac22edf372 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -543,6 +543,8 @@ struct mddev {
 	/* used for register new sync thread */
 	struct work_struct sync_work;
 
+	spinlock_t			device_lock;
+
 	/* "lock" protects:
 	 *   flush_bio transition from NULL to !NULL
 	 *   rdev superblocks, events
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 592a40233004..7924d5ee189d 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -282,10 +282,10 @@ static void reschedule_retry(struct r1bio *r1_bio)
 	int idx;
 
 	idx = sector_to_idx(r1_bio->sector);
-	spin_lock_irqsave(&conf->device_lock, flags);
+	spin_lock_irqsave(&conf->mddev->device_lock, flags);
 	list_add(&r1_bio->retry_list, &conf->retry_list);
 	atomic_inc(&conf->nr_queued[idx]);
-	spin_unlock_irqrestore(&conf->device_lock, flags);
+	spin_unlock_irqrestore(&conf->mddev->device_lock, flags);
 
 	wake_up(&conf->wait_barrier);
 	md_wakeup_thread(mddev->thread);
@@ -387,12 +387,12 @@ static void raid1_end_read_request(struct bio *bio)
 		 * Here we redefine "uptodate" to mean "Don't want to retry"
 		 */
 		unsigned long flags;
-		spin_lock_irqsave(&conf->device_lock, flags);
+		spin_lock_irqsave(&conf->mddev->device_lock, flags);
 		if (r1_bio->mddev->degraded == conf->raid_disks ||
 		    (r1_bio->mddev->degraded == conf->raid_disks-1 &&
 		     test_bit(In_sync, &rdev->flags)))
 			uptodate = 1;
-		spin_unlock_irqrestore(&conf->device_lock, flags);
+		spin_unlock_irqrestore(&conf->mddev->device_lock, flags);
 	}
 
 	if (uptodate) {
@@ -917,14 +917,14 @@ static void flush_pending_writes(struct r1conf *conf)
 	/* Any writes that have been queued but are awaiting
 	 * bitmap updates get flushed here.
 	 */
-	spin_lock_irq(&conf->device_lock);
+	spin_lock_irq(&conf->mddev->device_lock);
 
 	if (conf->pending_bio_list.head) {
 		struct blk_plug plug;
 		struct bio *bio;
 
 		bio = bio_list_get(&conf->pending_bio_list);
-		spin_unlock_irq(&conf->device_lock);
+		spin_unlock_irq(&conf->mddev->device_lock);
 
 		/*
 		 * As this is called in a wait_event() loop (see freeze_array),
@@ -940,7 +940,7 @@ static void flush_pending_writes(struct r1conf *conf)
 		flush_bio_list(conf, bio);
 		blk_finish_plug(&plug);
 	} else
-		spin_unlock_irq(&conf->device_lock);
+		spin_unlock_irq(&conf->mddev->device_lock);
 }
 
 /* Barriers....
@@ -1274,9 +1274,9 @@ static void raid1_unplug(struct blk_plug_cb *cb, bool from_schedule)
 	struct bio *bio;
 
 	if (from_schedule) {
-		spin_lock_irq(&conf->device_lock);
+		spin_lock_irq(&conf->mddev->device_lock);
 		bio_list_merge(&conf->pending_bio_list, &plug->pending);
-		spin_unlock_irq(&conf->device_lock);
+		spin_unlock_irq(&conf->mddev->device_lock);
 		wake_up_barrier(conf);
 		md_wakeup_thread(mddev->thread);
 		kfree(plug);
@@ -1664,9 +1664,9 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
 		/* flush_pending_writes() needs access to the rdev so...*/
 		mbio->bi_bdev = (void *)rdev;
 		if (!raid1_add_bio_to_plug(mddev, mbio, raid1_unplug, disks)) {
-			spin_lock_irqsave(&conf->device_lock, flags);
+			spin_lock_irqsave(&conf->mddev->device_lock, flags);
 			bio_list_add(&conf->pending_bio_list, mbio);
-			spin_unlock_irqrestore(&conf->device_lock, flags);
+			spin_unlock_irqrestore(&conf->mddev->device_lock, flags);
 			md_wakeup_thread(mddev->thread);
 		}
 	}
@@ -1753,7 +1753,7 @@ static void raid1_error(struct mddev *mddev, struct md_rdev *rdev)
 	struct r1conf *conf = mddev->private;
 	unsigned long flags;
 
-	spin_lock_irqsave(&conf->device_lock, flags);
+	spin_lock_irqsave(&conf->mddev->device_lock, flags);
 
 	if (test_bit(In_sync, &rdev->flags) &&
 	    (conf->raid_disks - mddev->degraded) == 1) {
@@ -1761,7 +1761,7 @@ static void raid1_error(struct mddev *mddev, struct md_rdev *rdev)
 
 		if (!mddev->fail_last_dev) {
 			conf->recovery_disabled = mddev->recovery_disabled;
-			spin_unlock_irqrestore(&conf->device_lock, flags);
+			spin_unlock_irqrestore(&conf->mddev->device_lock, flags);
 			return;
 		}
 	}
@@ -1769,7 +1769,7 @@ static void raid1_error(struct mddev *mddev, struct md_rdev *rdev)
 	if (test_and_clear_bit(In_sync, &rdev->flags))
 		mddev->degraded++;
 	set_bit(Faulty, &rdev->flags);
-	spin_unlock_irqrestore(&conf->device_lock, flags);
+	spin_unlock_irqrestore(&conf->mddev->device_lock, flags);
 	/*
 	 * if recovery is running, make sure it aborts.
 	 */
@@ -1831,7 +1831,7 @@ static int raid1_spare_active(struct mddev *mddev)
 	 * device_lock used to avoid races with raid1_end_read_request
 	 * which expects 'In_sync' flags and ->degraded to be consistent.
 	 */
-	spin_lock_irqsave(&conf->device_lock, flags);
+	spin_lock_irqsave(&conf->mddev->device_lock, flags);
 	for (i = 0; i < conf->raid_disks; i++) {
 		struct md_rdev *rdev = conf->mirrors[i].rdev;
 		struct md_rdev *repl = conf->mirrors[conf->raid_disks + i].rdev;
@@ -1863,7 +1863,7 @@ static int raid1_spare_active(struct mddev *mddev)
 		}
 	}
 	mddev->degraded -= count;
-	spin_unlock_irqrestore(&conf->device_lock, flags);
+	spin_unlock_irqrestore(&conf->mddev->device_lock, flags);
 
 	print_conf(conf);
 	return count;
@@ -2605,11 +2605,11 @@ static void handle_write_finished(struct r1conf *conf, struct r1bio *r1_bio)
 					 conf->mddev);
 		}
 	if (fail) {
-		spin_lock_irq(&conf->device_lock);
+		spin_lock_irq(&conf->mddev->device_lock);
 		list_add(&r1_bio->retry_list, &conf->bio_end_io_list);
 		idx = sector_to_idx(r1_bio->sector);
 		atomic_inc(&conf->nr_queued[idx]);
-		spin_unlock_irq(&conf->device_lock);
+		spin_unlock_irq(&conf->mddev->device_lock);
 		/*
 		 * In case freeze_array() is waiting for condition
 		 * get_unqueued_pending() == extra to be true.
@@ -2681,10 +2681,10 @@ static void raid1d(struct md_thread *thread)
 	if (!list_empty_careful(&conf->bio_end_io_list) &&
 	    !test_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags)) {
 		LIST_HEAD(tmp);
-		spin_lock_irqsave(&conf->device_lock, flags);
+		spin_lock_irqsave(&conf->mddev->device_lock, flags);
 		if (!test_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags))
 			list_splice_init(&conf->bio_end_io_list, &tmp);
-		spin_unlock_irqrestore(&conf->device_lock, flags);
+		spin_unlock_irqrestore(&conf->mddev->device_lock, flags);
 		while (!list_empty(&tmp)) {
 			r1_bio = list_first_entry(&tmp, struct r1bio,
 						  retry_list);
@@ -2702,16 +2702,16 @@ static void raid1d(struct md_thread *thread)
 
 		flush_pending_writes(conf);
 
-		spin_lock_irqsave(&conf->device_lock, flags);
+		spin_lock_irqsave(&conf->mddev->device_lock, flags);
 		if (list_empty(head)) {
-			spin_unlock_irqrestore(&conf->device_lock, flags);
+			spin_unlock_irqrestore(&conf->mddev->device_lock, flags);
 			break;
 		}
 		r1_bio = list_entry(head->prev, struct r1bio, retry_list);
 		list_del(head->prev);
 		idx = sector_to_idx(r1_bio->sector);
 		atomic_dec(&conf->nr_queued[idx]);
-		spin_unlock_irqrestore(&conf->device_lock, flags);
+		spin_unlock_irqrestore(&conf->mddev->device_lock, flags);
 
 		mddev = r1_bio->mddev;
 		conf = mddev->private;
@@ -3131,7 +3131,6 @@ static struct r1conf *setup_conf(struct mddev *mddev)
 		goto abort;
 
 	err = -EINVAL;
-	spin_lock_init(&conf->device_lock);
 	conf->raid_disks = mddev->raid_disks;
 	rdev_for_each(rdev, mddev) {
 		int disk_idx = rdev->raid_disk;
@@ -3429,9 +3428,9 @@ static int raid1_reshape(struct mddev *mddev)
 	kfree(conf->mirrors);
 	conf->mirrors = newmirrors;
 
-	spin_lock_irqsave(&conf->device_lock, flags);
+	spin_lock_irqsave(&conf->mddev->device_lock, flags);
 	mddev->degraded += (raid_disks - conf->raid_disks);
-	spin_unlock_irqrestore(&conf->device_lock, flags);
+	spin_unlock_irqrestore(&conf->mddev->device_lock, flags);
 	conf->raid_disks = mddev->raid_disks = raid_disks;
 	mddev->delta_disks = 0;
 
diff --git a/drivers/md/raid1.h b/drivers/md/raid1.h
index 2ebe35aaa534..7af8e294e7ae 100644
--- a/drivers/md/raid1.h
+++ b/drivers/md/raid1.h
@@ -57,8 +57,6 @@ struct r1conf {
 	int			raid_disks;
 	int			nonrot_disks;
 
-	spinlock_t		device_lock;
-
 	/* list of 'struct r1bio' that need to be processed by raid1d,
 	 * whether to retry a read, writeout a resync or recovery
 	 * block, or anything else.
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 14dcd5142eb4..57c887070df3 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -301,10 +301,10 @@ static void reschedule_retry(struct r10bio *r10_bio)
 	struct mddev *mddev = r10_bio->mddev;
 	struct r10conf *conf = mddev->private;
 
-	spin_lock_irqsave(&conf->device_lock, flags);
+	spin_lock_irqsave(&conf->mddev->device_lock, flags);
 	list_add(&r10_bio->retry_list, &conf->retry_list);
 	conf->nr_queued ++;
-	spin_unlock_irqrestore(&conf->device_lock, flags);
+	spin_unlock_irqrestore(&conf->mddev->device_lock, flags);
 
 	/* wake up frozen array... */
 	wake_up(&conf->wait_barrier);
@@ -863,14 +863,14 @@ static void flush_pending_writes(struct r10conf *conf)
 	/* Any writes that have been queued but are awaiting
 	 * bitmap updates get flushed here.
 	 */
-	spin_lock_irq(&conf->device_lock);
+	spin_lock_irq(&conf->mddev->device_lock);
 
 	if (conf->pending_bio_list.head) {
 		struct blk_plug plug;
 		struct bio *bio;
 
 		bio = bio_list_get(&conf->pending_bio_list);
-		spin_unlock_irq(&conf->device_lock);
+		spin_unlock_irq(&conf->mddev->device_lock);
 
 		/*
 		 * As this is called in a wait_event() loop (see freeze_array),
@@ -896,7 +896,7 @@ static void flush_pending_writes(struct r10conf *conf)
 		}
 		blk_finish_plug(&plug);
 	} else
-		spin_unlock_irq(&conf->device_lock);
+		spin_unlock_irq(&conf->mddev->device_lock);
 }
 
 /* Barriers....
@@ -1089,9 +1089,9 @@ static void raid10_unplug(struct blk_plug_cb *cb, bool from_schedule)
 	struct bio *bio;
 
 	if (from_schedule) {
-		spin_lock_irq(&conf->device_lock);
+		spin_lock_irq(&conf->mddev->device_lock);
 		bio_list_merge(&conf->pending_bio_list, &plug->pending);
-		spin_unlock_irq(&conf->device_lock);
+		spin_unlock_irq(&conf->mddev->device_lock);
 		wake_up_barrier(conf);
 		md_wakeup_thread(mddev->thread);
 		kfree(plug);
@@ -1278,9 +1278,9 @@ static void raid10_write_one_disk(struct mddev *mddev, struct r10bio *r10_bio,
 	atomic_inc(&r10_bio->remaining);
 
 	if (!raid1_add_bio_to_plug(mddev, mbio, raid10_unplug, conf->copies)) {
-		spin_lock_irqsave(&conf->device_lock, flags);
+		spin_lock_irqsave(&conf->mddev->device_lock, flags);
 		bio_list_add(&conf->pending_bio_list, mbio);
-		spin_unlock_irqrestore(&conf->device_lock, flags);
+		spin_unlock_irqrestore(&conf->mddev->device_lock, flags);
 		md_wakeup_thread(mddev->thread);
 	}
 }
@@ -1997,13 +1997,13 @@ static void raid10_error(struct mddev *mddev, struct md_rdev *rdev)
 	struct r10conf *conf = mddev->private;
 	unsigned long flags;
 
-	spin_lock_irqsave(&conf->device_lock, flags);
+	spin_lock_irqsave(&conf->mddev->device_lock, flags);
 
 	if (test_bit(In_sync, &rdev->flags) && !enough(conf, rdev->raid_disk)) {
 		set_bit(MD_BROKEN, &mddev->flags);
 
 		if (!mddev->fail_last_dev) {
-			spin_unlock_irqrestore(&conf->device_lock, flags);
+			spin_unlock_irqrestore(&conf->mddev->device_lock, flags);
 			return;
 		}
 	}
@@ -2015,7 +2015,7 @@ static void raid10_error(struct mddev *mddev, struct md_rdev *rdev)
 	set_bit(Faulty, &rdev->flags);
 	set_mask_bits(&mddev->sb_flags, 0,
 		      BIT(MD_SB_CHANGE_DEVS) | BIT(MD_SB_CHANGE_PENDING));
-	spin_unlock_irqrestore(&conf->device_lock, flags);
+	spin_unlock_irqrestore(&conf->mddev->device_lock, flags);
 	pr_crit("md/raid10:%s: Disk failure on %pg, disabling device.\n"
 		"md/raid10:%s: Operation continuing on %d devices.\n",
 		mdname(mddev), rdev->bdev,
@@ -2094,9 +2094,9 @@ static int raid10_spare_active(struct mddev *mddev)
 			sysfs_notify_dirent_safe(tmp->rdev->sysfs_state);
 		}
 	}
-	spin_lock_irqsave(&conf->device_lock, flags);
+	spin_lock_irqsave(&conf->mddev->device_lock, flags);
 	mddev->degraded -= count;
-	spin_unlock_irqrestore(&conf->device_lock, flags);
+	spin_unlock_irqrestore(&conf->mddev->device_lock, flags);
 
 	print_conf(conf);
 	return count;
@@ -2951,10 +2951,10 @@ static void handle_write_completed(struct r10conf *conf, struct r10bio *r10_bio)
 			}
 		}
 		if (fail) {
-			spin_lock_irq(&conf->device_lock);
+			spin_lock_irq(&conf->mddev->device_lock);
 			list_add(&r10_bio->retry_list, &conf->bio_end_io_list);
 			conf->nr_queued++;
-			spin_unlock_irq(&conf->device_lock);
+			spin_unlock_irq(&conf->mddev->device_lock);
 			/*
 			 * In case freeze_array() is waiting for condition
 			 * nr_pending == nr_queued + extra to be true.
@@ -2984,14 +2984,14 @@ static void raid10d(struct md_thread *thread)
 	if (!list_empty_careful(&conf->bio_end_io_list) &&
 	    !test_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags)) {
 		LIST_HEAD(tmp);
-		spin_lock_irqsave(&conf->device_lock, flags);
+		spin_lock_irqsave(&conf->mddev->device_lock, flags);
 		if (!test_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags)) {
 			while (!list_empty(&conf->bio_end_io_list)) {
 				list_move(conf->bio_end_io_list.prev, &tmp);
 				conf->nr_queued--;
 			}
 		}
-		spin_unlock_irqrestore(&conf->device_lock, flags);
+		spin_unlock_irqrestore(&conf->mddev->device_lock, flags);
 		while (!list_empty(&tmp)) {
 			r10_bio = list_first_entry(&tmp, struct r10bio,
 						   retry_list);
@@ -3009,15 +3009,15 @@ static void raid10d(struct md_thread *thread)
 
 		flush_pending_writes(conf);
 
-		spin_lock_irqsave(&conf->device_lock, flags);
+		spin_lock_irqsave(&conf->mddev->device_lock, flags);
 		if (list_empty(head)) {
-			spin_unlock_irqrestore(&conf->device_lock, flags);
+			spin_unlock_irqrestore(&conf->mddev->device_lock, flags);
 			break;
 		}
 		r10_bio = list_entry(head->prev, struct r10bio, retry_list);
 		list_del(head->prev);
 		conf->nr_queued--;
-		spin_unlock_irqrestore(&conf->device_lock, flags);
+		spin_unlock_irqrestore(&conf->mddev->device_lock, flags);
 
 		mddev = r10_bio->mddev;
 		conf = mddev->private;
@@ -3960,7 +3960,6 @@ static struct r10conf *setup_conf(struct mddev *mddev)
 			conf->prev.stride = conf->dev_sectors;
 	}
 	conf->reshape_safe = conf->reshape_progress;
-	spin_lock_init(&conf->device_lock);
 	INIT_LIST_HEAD(&conf->retry_list);
 	INIT_LIST_HEAD(&conf->bio_end_io_list);
 
@@ -4467,7 +4466,7 @@ static int raid10_start_reshape(struct mddev *mddev)
 		return -EINVAL;
 
 	conf->offset_diff = min_offset_diff;
-	spin_lock_irq(&conf->device_lock);
+	spin_lock_irq(&conf->mddev->device_lock);
 	if (conf->mirrors_new) {
 		memcpy(conf->mirrors_new, conf->mirrors,
 		       sizeof(struct raid10_info)*conf->prev.raid_disks);
@@ -4482,7 +4481,7 @@ static int raid10_start_reshape(struct mddev *mddev)
 	if (mddev->reshape_backwards) {
 		sector_t size = raid10_size(mddev, 0, 0);
 		if (size < mddev->array_sectors) {
-			spin_unlock_irq(&conf->device_lock);
+			spin_unlock_irq(&conf->mddev->device_lock);
 			pr_warn("md/raid10:%s: array size must be reduce before number of disks\n",
 				mdname(mddev));
 			return -EINVAL;
@@ -4492,7 +4491,7 @@ static int raid10_start_reshape(struct mddev *mddev)
 	} else
 		conf->reshape_progress = 0;
 	conf->reshape_safe = conf->reshape_progress;
-	spin_unlock_irq(&conf->device_lock);
+	spin_unlock_irq(&conf->mddev->device_lock);
 
 	if (mddev->delta_disks && mddev->bitmap) {
 		struct mdp_superblock_1 *sb = NULL;
@@ -4561,9 +4560,9 @@ static int raid10_start_reshape(struct mddev *mddev)
 	 * ->degraded is measured against the larger of the
 	 * pre and  post numbers.
 	 */
-	spin_lock_irq(&conf->device_lock);
+	spin_lock_irq(&conf->mddev->device_lock);
 	mddev->degraded = calc_degraded(conf);
-	spin_unlock_irq(&conf->device_lock);
+	spin_unlock_irq(&conf->mddev->device_lock);
 	mddev->raid_disks = conf->geo.raid_disks;
 	mddev->reshape_position = conf->reshape_progress;
 	set_bit(MD_SB_CHANGE_DEVS, &mddev->sb_flags);
@@ -4579,7 +4578,7 @@ static int raid10_start_reshape(struct mddev *mddev)
 
 abort:
 	mddev->recovery = 0;
-	spin_lock_irq(&conf->device_lock);
+	spin_lock_irq(&conf->mddev->device_lock);
 	conf->geo = conf->prev;
 	mddev->raid_disks = conf->geo.raid_disks;
 	rdev_for_each(rdev, mddev)
@@ -4588,7 +4587,7 @@ static int raid10_start_reshape(struct mddev *mddev)
 	conf->reshape_progress = MaxSector;
 	conf->reshape_safe = MaxSector;
 	mddev->reshape_position = MaxSector;
-	spin_unlock_irq(&conf->device_lock);
+	spin_unlock_irq(&conf->mddev->device_lock);
 	return ret;
 }
 
@@ -4947,13 +4946,13 @@ static void end_reshape(struct r10conf *conf)
 	if (test_bit(MD_RECOVERY_INTR, &conf->mddev->recovery))
 		return;
 
-	spin_lock_irq(&conf->device_lock);
+	spin_lock_irq(&conf->mddev->device_lock);
 	conf->prev = conf->geo;
 	md_finish_reshape(conf->mddev);
 	smp_wmb();
 	conf->reshape_progress = MaxSector;
 	conf->reshape_safe = MaxSector;
-	spin_unlock_irq(&conf->device_lock);
+	spin_unlock_irq(&conf->mddev->device_lock);
 
 	mddev_update_io_opt(conf->mddev, raid10_nr_stripes(conf));
 	conf->fullsync = 0;
diff --git a/drivers/md/raid10.h b/drivers/md/raid10.h
index da00a55f7a55..5f6c8b21ecd0 100644
--- a/drivers/md/raid10.h
+++ b/drivers/md/raid10.h
@@ -29,7 +29,6 @@ struct r10conf {
 	struct mddev		*mddev;
 	struct raid10_info	*mirrors;
 	struct raid10_info	*mirrors_new, *mirrors_old;
-	spinlock_t		device_lock;
 
 	/* geometry */
 	struct geom {
diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index ba768ca7f422..177759b18c72 100644
--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -1356,7 +1356,7 @@ static void r5l_write_super_and_discard_space(struct r5l_log *log,
  * r5c_flush_stripe moves stripe from cached list to handle_list. When called,
  * the stripe must be on r5c_cached_full_stripes or r5c_cached_partial_stripes.
  *
- * must hold conf->device_lock
+ * must hold conf->mddev->device_lock
  */
 static void r5c_flush_stripe(struct r5conf *conf, struct stripe_head *sh)
 {
@@ -1366,10 +1366,10 @@ static void r5c_flush_stripe(struct r5conf *conf, struct stripe_head *sh)
 
 	/*
 	 * The stripe is not ON_RELEASE_LIST, so it is safe to call
-	 * raid5_release_stripe() while holding conf->device_lock
+	 * raid5_release_stripe() while holding conf->mddev->device_lock
 	 */
 	BUG_ON(test_bit(STRIPE_ON_RELEASE_LIST, &sh->state));
-	lockdep_assert_held(&conf->device_lock);
+	lockdep_assert_held(&conf->mddev->device_lock);
 
 	list_del_init(&sh->lru);
 	atomic_inc(&sh->count);
@@ -1396,7 +1396,7 @@ void r5c_flush_cache(struct r5conf *conf, int num)
 	int count;
 	struct stripe_head *sh, *next;
 
-	lockdep_assert_held(&conf->device_lock);
+	lockdep_assert_held(&conf->mddev->device_lock);
 	if (!READ_ONCE(conf->log))
 		return;
 
@@ -1455,15 +1455,15 @@ static void r5c_do_reclaim(struct r5conf *conf)
 		stripes_to_flush = -1;
 
 	if (stripes_to_flush >= 0) {
-		spin_lock_irqsave(&conf->device_lock, flags);
+		spin_lock_irqsave(&conf->mddev->device_lock, flags);
 		r5c_flush_cache(conf, stripes_to_flush);
-		spin_unlock_irqrestore(&conf->device_lock, flags);
+		spin_unlock_irqrestore(&conf->mddev->device_lock, flags);
 	}
 
 	/* if log space is tight, flush stripes on stripe_in_journal_list */
 	if (test_bit(R5C_LOG_TIGHT, &conf->cache_state)) {
 		spin_lock_irqsave(&log->stripe_in_journal_lock, flags);
-		spin_lock(&conf->device_lock);
+		spin_lock(&conf->mddev->device_lock);
 		list_for_each_entry(sh, &log->stripe_in_journal_list, r5c) {
 			/*
 			 * stripes on stripe_in_journal_list could be in any
@@ -1481,7 +1481,7 @@ static void r5c_do_reclaim(struct r5conf *conf)
 					break;
 			}
 		}
-		spin_unlock(&conf->device_lock);
+		spin_unlock(&conf->mddev->device_lock);
 		spin_unlock_irqrestore(&log->stripe_in_journal_lock, flags);
 	}
 
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 24b32a0c95b4..3350dcf9cab6 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -83,34 +83,34 @@ static inline int stripe_hash_locks_hash(struct r5conf *conf, sector_t sect)
 }
 
 static inline void lock_device_hash_lock(struct r5conf *conf, int hash)
-	__acquires(&conf->device_lock)
+	__acquires(&conf->mddev->device_lock)
 {
 	spin_lock_irq(conf->hash_locks + hash);
-	spin_lock(&conf->device_lock);
+	spin_lock(&conf->mddev->device_lock);
 }
 
 static inline void unlock_device_hash_lock(struct r5conf *conf, int hash)
-	__releases(&conf->device_lock)
+	__releases(&conf->mddev->device_lock)
 {
-	spin_unlock(&conf->device_lock);
+	spin_unlock(&conf->mddev->device_lock);
 	spin_unlock_irq(conf->hash_locks + hash);
 }
 
 static inline void lock_all_device_hash_locks_irq(struct r5conf *conf)
-	__acquires(&conf->device_lock)
+	__acquires(&conf->mddev->device_lock)
 {
 	int i;
 	spin_lock_irq(conf->hash_locks);
 	for (i = 1; i < NR_STRIPE_HASH_LOCKS; i++)
 		spin_lock_nest_lock(conf->hash_locks + i, conf->hash_locks);
-	spin_lock(&conf->device_lock);
+	spin_lock(&conf->mddev->device_lock);
 }
 
 static inline void unlock_all_device_hash_locks_irq(struct r5conf *conf)
-	__releases(&conf->device_lock)
+	__releases(&conf->mddev->device_lock)
 {
 	int i;
-	spin_unlock(&conf->device_lock);
+	spin_unlock(&conf->mddev->device_lock);
 	for (i = NR_STRIPE_HASH_LOCKS - 1; i; i--)
 		spin_unlock(conf->hash_locks + i);
 	spin_unlock_irq(conf->hash_locks);
@@ -172,7 +172,7 @@ static bool stripe_is_lowprio(struct stripe_head *sh)
 }
 
 static void raid5_wakeup_stripe_thread(struct stripe_head *sh)
-	__must_hold(&sh->raid_conf->device_lock)
+	__must_hold(&sh->raid_conf->mddev->device_lock)
 {
 	struct r5conf *conf = sh->raid_conf;
 	struct r5worker_group *group;
@@ -220,7 +220,7 @@ static void raid5_wakeup_stripe_thread(struct stripe_head *sh)
 
 static void do_release_stripe(struct r5conf *conf, struct stripe_head *sh,
 			      struct list_head *temp_inactive_list)
-	__must_hold(&conf->device_lock)
+	__must_hold(&conf->mddev->device_lock)
 {
 	int i;
 	int injournal = 0;	/* number of date pages with R5_InJournal */
@@ -306,7 +306,7 @@ static void do_release_stripe(struct r5conf *conf, struct stripe_head *sh,
 
 static void __release_stripe(struct r5conf *conf, struct stripe_head *sh,
 			     struct list_head *temp_inactive_list)
-	__must_hold(&conf->device_lock)
+	__must_hold(&conf->mddev->device_lock)
 {
 	if (atomic_dec_and_test(&sh->count))
 		do_release_stripe(conf, sh, temp_inactive_list);
@@ -363,7 +363,7 @@ static void release_inactive_stripe_list(struct r5conf *conf,
 
 static int release_stripe_list(struct r5conf *conf,
 			       struct list_head *temp_inactive_list)
-	__must_hold(&conf->device_lock)
+	__must_hold(&conf->mddev->device_lock)
 {
 	struct stripe_head *sh, *t;
 	int count = 0;
@@ -412,11 +412,11 @@ void raid5_release_stripe(struct stripe_head *sh)
 	return;
 slow_path:
 	/* we are ok here if STRIPE_ON_RELEASE_LIST is set or not */
-	if (atomic_dec_and_lock_irqsave(&sh->count, &conf->device_lock, flags)) {
+	if (atomic_dec_and_lock_irqsave(&sh->count, &conf->mddev->device_lock, flags)) {
 		INIT_LIST_HEAD(&list);
 		hash = sh->hash_lock_index;
 		do_release_stripe(conf, sh, &list);
-		spin_unlock_irqrestore(&conf->device_lock, flags);
+		spin_unlock_irqrestore(&conf->mddev->device_lock, flags);
 		release_inactive_stripe_list(conf, &list, hash);
 	}
 }
@@ -647,7 +647,7 @@ static struct stripe_head *find_get_stripe(struct r5conf *conf,
 	 * references it with the device_lock held.
 	 */
 
-	spin_lock(&conf->device_lock);
+	spin_lock(&conf->mddev->device_lock);
 	if (!atomic_read(&sh->count)) {
 		if (!test_bit(STRIPE_HANDLE, &sh->state))
 			atomic_inc(&conf->active_stripes);
@@ -666,7 +666,7 @@ static struct stripe_head *find_get_stripe(struct r5conf *conf,
 		}
 	}
 	atomic_inc(&sh->count);
-	spin_unlock(&conf->device_lock);
+	spin_unlock(&conf->mddev->device_lock);
 
 	return sh;
 }
@@ -684,7 +684,7 @@ static struct stripe_head *find_get_stripe(struct r5conf *conf,
  * of the two sections, and some non-in_sync devices may
  * be insync in the section most affected by failed devices.
  *
- * Most calls to this function hold &conf->device_lock. Calls
+ * Most calls to this function hold &conf->mddev->device_lock. Calls
  * in raid5_run() do not require the lock as no other threads
  * have been started yet.
  */
@@ -2913,7 +2913,7 @@ static void raid5_error(struct mddev *mddev, struct md_rdev *rdev)
 	pr_crit("md/raid:%s: Disk failure on %pg, disabling device.\n",
 		mdname(mddev), rdev->bdev);
 
-	spin_lock_irqsave(&conf->device_lock, flags);
+	spin_lock_irqsave(&conf->mddev->device_lock, flags);
 	set_bit(Faulty, &rdev->flags);
 	clear_bit(In_sync, &rdev->flags);
 	mddev->degraded = raid5_calc_degraded(conf);
@@ -2929,7 +2929,7 @@ static void raid5_error(struct mddev *mddev, struct md_rdev *rdev)
 			mdname(mddev), conf->raid_disks - mddev->degraded);
 	}
 
-	spin_unlock_irqrestore(&conf->device_lock, flags);
+	spin_unlock_irqrestore(&conf->mddev->device_lock, flags);
 	set_bit(MD_RECOVERY_INTR, &mddev->recovery);
 
 	set_bit(Blocked, &rdev->flags);
@@ -5294,7 +5294,7 @@ static void handle_stripe(struct stripe_head *sh)
 }
 
 static void raid5_activate_delayed(struct r5conf *conf)
-	__must_hold(&conf->device_lock)
+	__must_hold(&conf->mddev->device_lock)
 {
 	if (atomic_read(&conf->preread_active_stripes) < IO_THRESHOLD) {
 		while (!list_empty(&conf->delayed_list)) {
@@ -5313,7 +5313,7 @@ static void raid5_activate_delayed(struct r5conf *conf)
 
 static void activate_bit_delay(struct r5conf *conf,
 		struct list_head *temp_inactive_list)
-	__must_hold(&conf->device_lock)
+	__must_hold(&conf->mddev->device_lock)
 {
 	struct list_head head;
 	list_add(&head, &conf->bitmap_list);
@@ -5348,12 +5348,12 @@ static void add_bio_to_retry(struct bio *bi,struct r5conf *conf)
 {
 	unsigned long flags;
 
-	spin_lock_irqsave(&conf->device_lock, flags);
+	spin_lock_irqsave(&conf->mddev->device_lock, flags);
 
 	bi->bi_next = conf->retry_read_aligned_list;
 	conf->retry_read_aligned_list = bi;
 
-	spin_unlock_irqrestore(&conf->device_lock, flags);
+	spin_unlock_irqrestore(&conf->mddev->device_lock, flags);
 	md_wakeup_thread(conf->mddev->thread);
 }
 
@@ -5472,11 +5472,11 @@ static int raid5_read_one_chunk(struct mddev *mddev, struct bio *raid_bio)
 		 */
 		if (did_inc && atomic_dec_and_test(&conf->active_aligned_reads))
 			wake_up(&conf->wait_for_quiescent);
-		spin_lock_irq(&conf->device_lock);
+		spin_lock_irq(&conf->mddev->device_lock);
 		wait_event_lock_irq(conf->wait_for_quiescent, conf->quiesce == 0,
-				    conf->device_lock);
+				    conf->mddev->device_lock);
 		atomic_inc(&conf->active_aligned_reads);
-		spin_unlock_irq(&conf->device_lock);
+		spin_unlock_irq(&conf->mddev->device_lock);
 	}
 
 	mddev_trace_remap(mddev, align_bio, raid_bio->bi_iter.bi_sector);
@@ -5516,7 +5516,7 @@ static struct bio *chunk_aligned_read(struct mddev *mddev, struct bio *raid_bio)
  * handle_list.
  */
 static struct stripe_head *__get_priority_stripe(struct r5conf *conf, int group)
-	__must_hold(&conf->device_lock)
+	__must_hold(&conf->mddev->device_lock)
 {
 	struct stripe_head *sh, *tmp;
 	struct list_head *handle_list = NULL;
@@ -5625,7 +5625,7 @@ static void raid5_unplug(struct blk_plug_cb *blk_cb, bool from_schedule)
 	int hash;
 
 	if (cb->list.next && !list_empty(&cb->list)) {
-		spin_lock_irq(&conf->device_lock);
+		spin_lock_irq(&conf->mddev->device_lock);
 		while (!list_empty(&cb->list)) {
 			sh = list_first_entry(&cb->list, struct stripe_head, lru);
 			list_del_init(&sh->lru);
@@ -5644,7 +5644,7 @@ static void raid5_unplug(struct blk_plug_cb *blk_cb, bool from_schedule)
 			__release_stripe(conf, sh, &cb->temp_inactive_list[hash]);
 			cnt++;
 		}
-		spin_unlock_irq(&conf->device_lock);
+		spin_unlock_irq(&conf->mddev->device_lock);
 	}
 	release_inactive_stripe_list(conf, cb->temp_inactive_list,
 				     NR_STRIPE_HASH_LOCKS);
@@ -5793,14 +5793,14 @@ static bool stripe_ahead_of_reshape(struct mddev *mddev, struct r5conf *conf,
 		max_sector = max(max_sector, sh->dev[dd_idx].sector);
 	}
 
-	spin_lock_irq(&conf->device_lock);
+	spin_lock_irq(&conf->mddev->device_lock);
 
 	if (!range_ahead_of_reshape(mddev, min_sector, max_sector,
 				     conf->reshape_progress))
 		/* mismatch, need to try again */
 		ret = true;
 
-	spin_unlock_irq(&conf->device_lock);
+	spin_unlock_irq(&conf->mddev->device_lock);
 
 	return ret;
 }
@@ -5880,10 +5880,10 @@ static enum reshape_loc get_reshape_loc(struct mddev *mddev,
 	 * to the stripe that we think it is, we will have
 	 * to check again.
 	 */
-	spin_lock_irq(&conf->device_lock);
+	spin_lock_irq(&conf->mddev->device_lock);
 	reshape_progress = conf->reshape_progress;
 	reshape_safe = conf->reshape_safe;
-	spin_unlock_irq(&conf->device_lock);
+	spin_unlock_irq(&conf->mddev->device_lock);
 	if (reshape_progress == MaxSector)
 		return LOC_NO_RESHAPE;
 	if (ahead_of_reshape(mddev, logical_sector, reshape_progress))
@@ -6373,9 +6373,9 @@ static sector_t reshape_request(struct mddev *mddev, sector_t sector_nr, int *sk
 			   test_bit(MD_RECOVERY_INTR, &mddev->recovery));
 		if (test_bit(MD_RECOVERY_INTR, &mddev->recovery))
 			return 0;
-		spin_lock_irq(&conf->device_lock);
+		spin_lock_irq(&conf->mddev->device_lock);
 		conf->reshape_safe = mddev->reshape_position;
-		spin_unlock_irq(&conf->device_lock);
+		spin_unlock_irq(&conf->mddev->device_lock);
 		wake_up(&conf->wait_for_reshape);
 		sysfs_notify_dirent_safe(mddev->sysfs_completed);
 	}
@@ -6413,12 +6413,12 @@ static sector_t reshape_request(struct mddev *mddev, sector_t sector_nr, int *sk
 		}
 		list_add(&sh->lru, &stripes);
 	}
-	spin_lock_irq(&conf->device_lock);
+	spin_lock_irq(&conf->mddev->device_lock);
 	if (mddev->reshape_backwards)
 		conf->reshape_progress -= reshape_sectors * new_data_disks;
 	else
 		conf->reshape_progress += reshape_sectors * new_data_disks;
-	spin_unlock_irq(&conf->device_lock);
+	spin_unlock_irq(&conf->mddev->device_lock);
 	/* Ok, those stripe are ready. We can start scheduling
 	 * reads on the source stripes.
 	 * The source stripes are determined by mapping the first and last
@@ -6482,9 +6482,9 @@ static sector_t reshape_request(struct mddev *mddev, sector_t sector_nr, int *sk
 			   || test_bit(MD_RECOVERY_INTR, &mddev->recovery));
 		if (test_bit(MD_RECOVERY_INTR, &mddev->recovery))
 			goto ret;
-		spin_lock_irq(&conf->device_lock);
+		spin_lock_irq(&conf->mddev->device_lock);
 		conf->reshape_safe = mddev->reshape_position;
-		spin_unlock_irq(&conf->device_lock);
+		spin_unlock_irq(&conf->mddev->device_lock);
 		wake_up(&conf->wait_for_reshape);
 		sysfs_notify_dirent_safe(mddev->sysfs_completed);
 	}
@@ -6651,7 +6651,7 @@ static int  retry_aligned_read(struct r5conf *conf, struct bio *raid_bio,
 static int handle_active_stripes(struct r5conf *conf, int group,
 				 struct r5worker *worker,
 				 struct list_head *temp_inactive_list)
-		__must_hold(&conf->device_lock)
+		__must_hold(&conf->mddev->device_lock)
 {
 	struct stripe_head *batch[MAX_STRIPE_BATCH], *sh;
 	int i, batch_size = 0, hash;
@@ -6666,21 +6666,21 @@ static int handle_active_stripes(struct r5conf *conf, int group,
 			if (!list_empty(temp_inactive_list + i))
 				break;
 		if (i == NR_STRIPE_HASH_LOCKS) {
-			spin_unlock_irq(&conf->device_lock);
+			spin_unlock_irq(&conf->mddev->device_lock);
 			log_flush_stripe_to_raid(conf);
-			spin_lock_irq(&conf->device_lock);
+			spin_lock_irq(&conf->mddev->device_lock);
 			return batch_size;
 		}
 		release_inactive = true;
 	}
-	spin_unlock_irq(&conf->device_lock);
+	spin_unlock_irq(&conf->mddev->device_lock);
 
 	release_inactive_stripe_list(conf, temp_inactive_list,
 				     NR_STRIPE_HASH_LOCKS);
 
 	r5l_flush_stripe_to_raid(conf->log);
 	if (release_inactive) {
-		spin_lock_irq(&conf->device_lock);
+		spin_lock_irq(&conf->mddev->device_lock);
 		return 0;
 	}
 
@@ -6690,7 +6690,7 @@ static int handle_active_stripes(struct r5conf *conf, int group,
 
 	cond_resched();
 
-	spin_lock_irq(&conf->device_lock);
+	spin_lock_irq(&conf->mddev->device_lock);
 	for (i = 0; i < batch_size; i++) {
 		hash = batch[i]->hash_lock_index;
 		__release_stripe(conf, batch[i], &temp_inactive_list[hash]);
@@ -6712,7 +6712,7 @@ static void raid5_do_work(struct work_struct *work)
 
 	blk_start_plug(&plug);
 	handled = 0;
-	spin_lock_irq(&conf->device_lock);
+	spin_lock_irq(&conf->mddev->device_lock);
 	while (1) {
 		int batch_size, released;
 
@@ -6726,11 +6726,11 @@ static void raid5_do_work(struct work_struct *work)
 		handled += batch_size;
 		wait_event_lock_irq(mddev->sb_wait,
 			!test_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags),
-			conf->device_lock);
+			conf->mddev->device_lock);
 	}
 	pr_debug("%d stripes handled\n", handled);
 
-	spin_unlock_irq(&conf->device_lock);
+	spin_unlock_irq(&conf->mddev->device_lock);
 
 	flush_deferred_bios(conf);
 
@@ -6762,7 +6762,7 @@ static void raid5d(struct md_thread *thread)
 
 	blk_start_plug(&plug);
 	handled = 0;
-	spin_lock_irq(&conf->device_lock);
+	spin_lock_irq(&conf->mddev->device_lock);
 	while (1) {
 		struct bio *bio;
 		int batch_size, released;
@@ -6779,10 +6779,10 @@ static void raid5d(struct md_thread *thread)
 		    !list_empty(&conf->bitmap_list)) {
 			/* Now is a good time to flush some bitmap updates */
 			conf->seq_flush++;
-			spin_unlock_irq(&conf->device_lock);
+			spin_unlock_irq(&conf->mddev->device_lock);
 			if (md_bitmap_enabled(mddev, true))
 				mddev->bitmap_ops->unplug(mddev, true);
-			spin_lock_irq(&conf->device_lock);
+			spin_lock_irq(&conf->mddev->device_lock);
 			conf->seq_write = conf->seq_flush;
 			activate_bit_delay(conf, conf->temp_inactive_list);
 		}
@@ -6790,9 +6790,9 @@ static void raid5d(struct md_thread *thread)
 
 		while ((bio = remove_bio_from_retry(conf, &offset))) {
 			int ok;
-			spin_unlock_irq(&conf->device_lock);
+			spin_unlock_irq(&conf->mddev->device_lock);
 			ok = retry_aligned_read(conf, bio, offset);
-			spin_lock_irq(&conf->device_lock);
+			spin_lock_irq(&conf->mddev->device_lock);
 			if (!ok)
 				break;
 			handled++;
@@ -6805,14 +6805,14 @@ static void raid5d(struct md_thread *thread)
 		handled += batch_size;
 
 		if (mddev->sb_flags & ~(1 << MD_SB_CHANGE_PENDING)) {
-			spin_unlock_irq(&conf->device_lock);
+			spin_unlock_irq(&conf->mddev->device_lock);
 			md_check_recovery(mddev);
-			spin_lock_irq(&conf->device_lock);
+			spin_lock_irq(&conf->mddev->device_lock);
 		}
 	}
 	pr_debug("%d stripes handled\n", handled);
 
-	spin_unlock_irq(&conf->device_lock);
+	spin_unlock_irq(&conf->mddev->device_lock);
 	if (test_and_clear_bit(R5_ALLOC_MORE, &conf->cache_state) &&
 	    mutex_trylock(&conf->cache_size_mutex)) {
 		grow_one_stripe(conf, __GFP_NOWARN);
@@ -7197,11 +7197,11 @@ raid5_store_group_thread_cnt(struct mddev *mddev, const char *page, size_t len)
 
 		err = alloc_thread_groups(conf, new, &group_cnt, &new_groups);
 		if (!err) {
-			spin_lock_irq(&conf->device_lock);
+			spin_lock_irq(&conf->mddev->device_lock);
 			conf->group_cnt = group_cnt;
 			conf->worker_cnt_per_group = new;
 			conf->worker_groups = new_groups;
-			spin_unlock_irq(&conf->device_lock);
+			spin_unlock_irq(&conf->mddev->device_lock);
 
 			if (old_groups)
 				kfree(old_groups[0].workers);
@@ -7504,8 +7504,7 @@ static struct r5conf *setup_conf(struct mddev *mddev)
 		conf->worker_groups = new_group;
 	} else
 		goto abort;
-	spin_lock_init(&conf->device_lock);
-	seqcount_spinlock_init(&conf->gen_lock, &conf->device_lock);
+	seqcount_spinlock_init(&conf->gen_lock, &conf->mddev->device_lock);
 	mutex_init(&conf->cache_size_mutex);
 
 	init_waitqueue_head(&conf->wait_for_quiescent);
@@ -8151,9 +8150,9 @@ static int raid5_spare_active(struct mddev *mddev)
 			sysfs_notify_dirent_safe(rdev->sysfs_state);
 		}
 	}
-	spin_lock_irqsave(&conf->device_lock, flags);
+	spin_lock_irqsave(&conf->mddev->device_lock, flags);
 	mddev->degraded = raid5_calc_degraded(conf);
-	spin_unlock_irqrestore(&conf->device_lock, flags);
+	spin_unlock_irqrestore(&conf->mddev->device_lock, flags);
 	print_raid5_conf(conf);
 	return count;
 }
@@ -8474,7 +8473,7 @@ static int raid5_start_reshape(struct mddev *mddev)
 	}
 
 	atomic_set(&conf->reshape_stripes, 0);
-	spin_lock_irq(&conf->device_lock);
+	spin_lock_irq(&conf->mddev->device_lock);
 	write_seqcount_begin(&conf->gen_lock);
 	conf->previous_raid_disks = conf->raid_disks;
 	conf->raid_disks += mddev->delta_disks;
@@ -8493,7 +8492,7 @@ static int raid5_start_reshape(struct mddev *mddev)
 		conf->reshape_progress = 0;
 	conf->reshape_safe = conf->reshape_progress;
 	write_seqcount_end(&conf->gen_lock);
-	spin_unlock_irq(&conf->device_lock);
+	spin_unlock_irq(&conf->mddev->device_lock);
 
 	/* Now make sure any requests that proceeded on the assumption
 	 * the reshape wasn't running - like Discard or Read - have
@@ -8533,9 +8532,9 @@ static int raid5_start_reshape(struct mddev *mddev)
 		 * ->degraded is measured against the larger of the
 		 * pre and post number of devices.
 		 */
-		spin_lock_irqsave(&conf->device_lock, flags);
+		spin_lock_irqsave(&conf->mddev->device_lock, flags);
 		mddev->degraded = raid5_calc_degraded(conf);
-		spin_unlock_irqrestore(&conf->device_lock, flags);
+		spin_unlock_irqrestore(&conf->mddev->device_lock, flags);
 	}
 	mddev->raid_disks = conf->raid_disks;
 	mddev->reshape_position = conf->reshape_progress;
@@ -8560,7 +8559,7 @@ static void end_reshape(struct r5conf *conf)
 	if (!test_bit(MD_RECOVERY_INTR, &conf->mddev->recovery)) {
 		struct md_rdev *rdev;
 
-		spin_lock_irq(&conf->device_lock);
+		spin_lock_irq(&conf->mddev->device_lock);
 		conf->previous_raid_disks = conf->raid_disks;
 		md_finish_reshape(conf->mddev);
 		smp_wmb();
@@ -8571,7 +8570,7 @@ static void end_reshape(struct r5conf *conf)
 			    !test_bit(Journal, &rdev->flags) &&
 			    !test_bit(In_sync, &rdev->flags))
 				rdev->recovery_offset = MaxSector;
-		spin_unlock_irq(&conf->device_lock);
+		spin_unlock_irq(&conf->mddev->device_lock);
 		wake_up(&conf->wait_for_reshape);
 
 		mddev_update_io_opt(conf->mddev,
@@ -8591,9 +8590,9 @@ static void raid5_finish_reshape(struct mddev *mddev)
 
 		if (mddev->delta_disks <= 0) {
 			int d;
-			spin_lock_irq(&conf->device_lock);
+			spin_lock_irq(&conf->mddev->device_lock);
 			mddev->degraded = raid5_calc_degraded(conf);
-			spin_unlock_irq(&conf->device_lock);
+			spin_unlock_irq(&conf->mddev->device_lock);
 			for (d = conf->raid_disks ;
 			     d < conf->raid_disks - mddev->delta_disks;
 			     d++) {
diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
index eafc6e9ed6ee..8ec60e06dc05 100644
--- a/drivers/md/raid5.h
+++ b/drivers/md/raid5.h
@@ -668,7 +668,6 @@ struct r5conf {
 	unsigned long		cache_state;
 	struct shrinker		*shrinker;
 	int			pool_size; /* number of disks in stripeheads in pool */
-	spinlock_t		device_lock;
 	struct disk_info	*disks;
 	struct bio_set		bio_split;
 
-- 
2.50.1

