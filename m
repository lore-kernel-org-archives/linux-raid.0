From: "majianpeng" <majianpeng@gmail.com>
Subject: md/raid5:Fix recover/replace stop if handle stipe failed
Date: Wed, 14 Mar 2012 15:07:55 +0800
Message-ID: <201203141507458909278@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

From 849df9f6422972452b99a2c2d08d005437a52d72 Mon Sep 17 00:00:00 2001
From: majianpeng <majianpeng@gmail.com>
Date: Wed, 14 Mar 2012 14:41:07 +0800
Subject: [PATCH] md/raid5:Fix recover/replace stop if handle stipe failed. 
 If handled stipe failed when recover/replace,should not first
 call md_done_sync(conf->mddev, STRIPE_SECTORS, 0).Beacause
 this set MD_RECOVERY_INTR and will terminate the
 recover/replace. And the sync_thread will repeatly start
 and stop.


Signed-off-by: majianpeng <majianpeng@gmail.com>
---
 drivers/md/raid5.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 360f2b9..55193ef 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -2472,7 +2472,6 @@ handle_failed_sync(struct r5conf *conf, struct stripe_head *sh,
 	int abort = 0;
 	int i;
 
-	md_done_sync(conf->mddev, STRIPE_SECTORS, 0);
 	clear_bit(STRIPE_SYNCING, &sh->state);
 	s->syncing = 0;
 	s->replacing = 0;
@@ -2480,8 +2479,12 @@ handle_failed_sync(struct r5conf *conf, struct stripe_head *sh,
 	 * For recover/replace we need to record a bad block on all
 	 * non-sync devices, or abort the recovery
 	 */
-	if (!test_bit(MD_RECOVERY_RECOVER, &conf->mddev->recovery))
+	if (!test_bit(MD_RECOVERY_RECOVER, &conf->mddev->recovery)) {
+		md_done_sync(conf->mddev, STRIPE_SECTORS, 0);
 		return;
+	} else
+		md_done_sync(conf->mddev, STRIPE_SECTORS, 1);
+
 	/* During recovery devices cannot be removed, so locking and
 	 * refcounting of rdevs is not needed
 	 */
@@ -2504,6 +2507,7 @@ handle_failed_sync(struct r5conf *conf, struct stripe_head *sh,
 	if (abort) {
 		conf->recovery_disabled = conf->mddev->recovery_disabled;
 		set_bit(MD_RECOVERY_INTR, &conf->mddev->recovery);
+		md_wakeup_thread(conf->mddev->thread);
 	}
 }
 
-- 
1.7.5.4

 				
--------------
majianpeng
2012-03-14

