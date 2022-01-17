Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B807DC433EF
	for <linux-raid@archiver.kernel.org>; Mon, 17 Jan 2022 11:39:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239163AbiAQLjB (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 17 Jan 2022 06:39:01 -0500
Received: from mga02.intel.com ([134.134.136.20]:60115 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239124AbiAQLi7 (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Mon, 17 Jan 2022 06:38:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1642419539; x=1673955539;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=GgRVeLvBcuPEQpk27aQQGXFd/1IzuuaMXpkeQ5eHYT8=;
  b=Y1E5RYtbfv39b1J+5E+CPK0yza8jfl0dgaxefMi+BbDyYrOOF1tbioZw
   xh74lXV6/cm3QqL8L8Z4FieOt51KkcEwnyBPFrDmhsMxY/TIpP2HFlSm/
   jMY1iF0O81qU56qiHPeNg2u4WMvYlCiWf1u8g47zHdA4K6V7CV9LnJg72
   lNKpod4vypbKlb6upKMzjbkRv5XUttceIbsSoR5aRlYzHYdhj6j7BK3OZ
   P8Kpp5rn8J0v1h3F6TaCS+2jqevITMbLvJqsFzdnJRdHwUBGOr+lLt27+
   iBy2d2gUZQ0gLB0ec2Mus3Kitg3747h7KMz8RkfYYUN8lOxzoR0K+VgK1
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10229"; a="231965766"
X-IronPort-AV: E=Sophos;i="5.88,295,1635231600"; 
   d="scan'208";a="231965766"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jan 2022 03:38:58 -0800
X-IronPort-AV: E=Sophos;i="5.88,295,1635231600"; 
   d="scan'208";a="693050117"
Received: from mtkaczyk-devel.igk.intel.com ([10.102.102.23])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jan 2022 03:38:57 -0800
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     song@kernel.org
Cc:     linux-raid@vger.kernel.org
Subject: [PATCH] raid1, raid10: drop pending_cnt.
Date:   Mon, 17 Jan 2022 12:38:47 +0100
Message-Id: <20220117113847.13115-1-mariusz.tkaczyk@linux.intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Those counters are not necessary after commit 11bb45e8aaf6 ("md: drop queue
limitation for RAID1 and RAID10"). Remove them from all code (conf and
plug structs). raid1_plug_cb and raid10_plug_cb are identical, so move
definition of raid1_plug_cb to common raid1-10 definitions and use it for
RAID10 too.

Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
---
 drivers/md/raid1-10.c |  5 +++++
 drivers/md/raid1.c    | 11 -----------
 drivers/md/raid1.h    |  1 -
 drivers/md/raid10.c   | 17 +++--------------
 drivers/md/raid10.h   |  1 -
 5 files changed, 8 insertions(+), 27 deletions(-)

diff --git a/drivers/md/raid1-10.c b/drivers/md/raid1-10.c
index 83f9a4f3d82e..e61f6cad4e08 100644
--- a/drivers/md/raid1-10.c
+++ b/drivers/md/raid1-10.c
@@ -28,6 +28,11 @@ struct resync_pages {
 	struct page	*pages[RESYNC_PAGES];
 };
 
+struct raid1_plug_cb {
+	struct blk_plug_cb	cb;
+	struct bio_list		pending;
+};
+
 static void rbio_pool_free(void *rbio, void *data)
 {
 	kfree(rbio);
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 02db187090fa..b9d563ded8bf 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -824,7 +824,6 @@ static void flush_pending_writes(struct r1conf *conf)
 		struct bio *bio;
 
 		bio = bio_list_get(&conf->pending_bio_list);
-		conf->pending_count = 0;
 		spin_unlock_irq(&conf->device_lock);
 
 		/*
@@ -1166,12 +1165,6 @@ static void alloc_behind_master_bio(struct r1bio *r1_bio,
 	bio_put(behind_bio);
 }
 
-struct raid1_plug_cb {
-	struct blk_plug_cb	cb;
-	struct bio_list		pending;
-	int			pending_cnt;
-};
-
 static void raid1_unplug(struct blk_plug_cb *cb, bool from_schedule)
 {
 	struct raid1_plug_cb *plug = container_of(cb, struct raid1_plug_cb,
@@ -1183,7 +1176,6 @@ static void raid1_unplug(struct blk_plug_cb *cb, bool from_schedule)
 	if (from_schedule || current->bio_list) {
 		spin_lock_irq(&conf->device_lock);
 		bio_list_merge(&conf->pending_bio_list, &plug->pending);
-		conf->pending_count += plug->pending_cnt;
 		spin_unlock_irq(&conf->device_lock);
 		wake_up(&conf->wait_barrier);
 		md_wakeup_thread(mddev->thread);
@@ -1585,11 +1577,9 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
 			plug = NULL;
 		if (plug) {
 			bio_list_add(&plug->pending, mbio);
-			plug->pending_cnt++;
 		} else {
 			spin_lock_irqsave(&conf->device_lock, flags);
 			bio_list_add(&conf->pending_bio_list, mbio);
-			conf->pending_count++;
 			spin_unlock_irqrestore(&conf->device_lock, flags);
 			md_wakeup_thread(mddev->thread);
 		}
@@ -3057,7 +3047,6 @@ static struct r1conf *setup_conf(struct mddev *mddev)
 	init_waitqueue_head(&conf->wait_barrier);
 
 	bio_list_init(&conf->pending_bio_list);
-	conf->pending_count = 0;
 	conf->recovery_disabled = mddev->recovery_disabled - 1;
 
 	err = -EIO;
diff --git a/drivers/md/raid1.h b/drivers/md/raid1.h
index ccf10e59b116..ebb6788820e7 100644
--- a/drivers/md/raid1.h
+++ b/drivers/md/raid1.h
@@ -87,7 +87,6 @@ struct r1conf {
 
 	/* queue pending writes to be submitted on unplug */
 	struct bio_list		pending_bio_list;
-	int			pending_count;
 
 	/* for use when syncing mirrors:
 	 * We don't allow both normal IO and resync/recovery IO at
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 2b969f70a31f..60e96c556540 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -861,7 +861,6 @@ static void flush_pending_writes(struct r10conf *conf)
 		struct bio *bio;
 
 		bio = bio_list_get(&conf->pending_bio_list);
-		conf->pending_count = 0;
 		spin_unlock_irq(&conf->device_lock);
 
 		/*
@@ -1054,16 +1053,9 @@ static sector_t choose_data_offset(struct r10bio *r10_bio,
 		return rdev->new_data_offset;
 }
 
-struct raid10_plug_cb {
-	struct blk_plug_cb	cb;
-	struct bio_list		pending;
-	int			pending_cnt;
-};
-
 static void raid10_unplug(struct blk_plug_cb *cb, bool from_schedule)
 {
-	struct raid10_plug_cb *plug = container_of(cb, struct raid10_plug_cb,
-						   cb);
+	struct raid1_plug_cb *plug = container_of(cb, struct raid1_plug_cb, cb);
 	struct mddev *mddev = plug->cb.data;
 	struct r10conf *conf = mddev->private;
 	struct bio *bio;
@@ -1071,7 +1063,6 @@ static void raid10_unplug(struct blk_plug_cb *cb, bool from_schedule)
 	if (from_schedule || current->bio_list) {
 		spin_lock_irq(&conf->device_lock);
 		bio_list_merge(&conf->pending_bio_list, &plug->pending);
-		conf->pending_count += plug->pending_cnt;
 		spin_unlock_irq(&conf->device_lock);
 		wake_up(&conf->wait_barrier);
 		md_wakeup_thread(mddev->thread);
@@ -1239,7 +1230,7 @@ static void raid10_write_one_disk(struct mddev *mddev, struct r10bio *r10_bio,
 	const unsigned long do_fua = (bio->bi_opf & REQ_FUA);
 	unsigned long flags;
 	struct blk_plug_cb *cb;
-	struct raid10_plug_cb *plug = NULL;
+	struct raid1_plug_cb *plug = NULL;
 	struct r10conf *conf = mddev->private;
 	struct md_rdev *rdev;
 	int devnum = r10_bio->devs[n_copy].devnum;
@@ -1282,16 +1273,14 @@ static void raid10_write_one_disk(struct mddev *mddev, struct r10bio *r10_bio,
 
 	cb = blk_check_plugged(raid10_unplug, mddev, sizeof(*plug));
 	if (cb)
-		plug = container_of(cb, struct raid10_plug_cb, cb);
+		plug = container_of(cb, struct raid1_plug_cb, cb);
 	else
 		plug = NULL;
 	if (plug) {
 		bio_list_add(&plug->pending, mbio);
-		plug->pending_cnt++;
 	} else {
 		spin_lock_irqsave(&conf->device_lock, flags);
 		bio_list_add(&conf->pending_bio_list, mbio);
-		conf->pending_count++;
 		spin_unlock_irqrestore(&conf->device_lock, flags);
 		md_wakeup_thread(mddev->thread);
 	}
diff --git a/drivers/md/raid10.h b/drivers/md/raid10.h
index c34bb196790e..5c0804d8bb1f 100644
--- a/drivers/md/raid10.h
+++ b/drivers/md/raid10.h
@@ -75,7 +75,6 @@ struct r10conf {
 
 	/* queue pending writes and submit them on unplug */
 	struct bio_list		pending_bio_list;
-	int			pending_count;
 
 	spinlock_t		resync_lock;
 	atomic_t		nr_pending;
-- 
2.26.2

