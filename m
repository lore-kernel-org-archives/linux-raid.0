Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7A09C433F5
	for <linux-raid@archiver.kernel.org>; Fri, 17 Dec 2021 09:30:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231653AbhLQJaU (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 17 Dec 2021 04:30:20 -0500
Received: from mga14.intel.com ([192.55.52.115]:37614 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230497AbhLQJaT (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Fri, 17 Dec 2021 04:30:19 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10200"; a="239943189"
X-IronPort-AV: E=Sophos;i="5.88,213,1635231600"; 
   d="scan'208";a="239943189"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Dec 2021 01:30:19 -0800
X-IronPort-AV: E=Sophos;i="5.88,213,1635231600"; 
   d="scan'208";a="506702024"
Received: from mtkaczyk-devel.igk.intel.com ([10.102.102.23])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Dec 2021 01:30:18 -0800
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     song@kernel.org
Cc:     linux-raid@vger.kernel.org
Subject: [PATCH] md: drop queue limitation for RAID1 and RAID10
Date:   Fri, 17 Dec 2021 10:29:55 +0100
Message-Id: <20211217092955.24010-1-mariusz.tkaczyk@linux.intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

As suggested by Neil Brown[1], this limitation seems to be
deprecated.

With plugging in use, writes are processed behind the raid thread
and conf->pending_count is not increased. This limitation occurs only
if caller doesn't use plugs.

It can be avoided and often it is (with plugging). There are no reports
that queue is growing to enormous size so remove queue limitation for
non-plugged IOs too.

[1] https://lore.kernel.org/linux-raid/162496301481.7211.18031090130574610495@noble.neil.brown.name

Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
---
 drivers/md/raid1-10.c | 6 ------
 drivers/md/raid1.c    | 7 -------
 drivers/md/raid10.c   | 7 -------
 3 files changed, 20 deletions(-)

diff --git a/drivers/md/raid1-10.c b/drivers/md/raid1-10.c
index 54db34163968..83f9a4f3d82e 100644
--- a/drivers/md/raid1-10.c
+++ b/drivers/md/raid1-10.c
@@ -22,12 +22,6 @@
 
 #define BIO_SPECIAL(bio) ((unsigned long)bio <= 2)
 
-/* When there are this many requests queue to be written by
- * the raid thread, we become 'congested' to provide back-pressure
- * for writeback.
- */
-static int max_queued_requests = 1024;
-
 /* for managing resync I/O pages */
 struct resync_pages {
 	void		*raid_bio;
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 7dc8026cf6ee..eeaedd6e0ce1 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1358,12 +1358,6 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
 	r1_bio = alloc_r1bio(mddev, bio);
 	r1_bio->sectors = max_write_sectors;
 
-	if (conf->pending_count >= max_queued_requests) {
-		md_wakeup_thread(mddev->thread);
-		raid1_log(mddev, "wait queued");
-		wait_event(conf->wait_barrier,
-			   conf->pending_count < max_queued_requests);
-	}
 	/* first select target devices under rcu_lock and
 	 * inc refcount on their rdev.  Record them by setting
 	 * bios[x] to bio
@@ -3410,4 +3404,3 @@ MODULE_ALIAS("md-personality-3"); /* RAID1 */
 MODULE_ALIAS("md-raid1");
 MODULE_ALIAS("md-level-1");
 
-module_param(max_queued_requests, int, S_IRUGO|S_IWUSR);
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index dde98f65bd04..c683ba138b58 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1387,12 +1387,6 @@ static void raid10_write_request(struct mddev *mddev, struct bio *bio,
 		conf->reshape_safe = mddev->reshape_position;
 	}
 
-	if (conf->pending_count >= max_queued_requests) {
-		md_wakeup_thread(mddev->thread);
-		raid10_log(mddev, "wait queued");
-		wait_event(conf->wait_barrier,
-			   conf->pending_count < max_queued_requests);
-	}
 	/* first select target devices under rcu_lock and
 	 * inc refcount on their rdev.  Record them by setting
 	 * bios[x] to bio
@@ -5243,4 +5237,3 @@ MODULE_ALIAS("md-personality-9"); /* RAID10 */
 MODULE_ALIAS("md-raid10");
 MODULE_ALIAS("md-level-10");
 
-module_param(max_queued_requests, int, S_IRUGO|S_IWUSR);
-- 
2.26.2

