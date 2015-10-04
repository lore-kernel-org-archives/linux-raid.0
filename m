From: Shaohua Li <shli@fb.com>
Subject: [PATCH 2/6] raid5-cache: move reclaim stop to quiesce
Date: Sun, 4 Oct 2015 09:20:12 -0700
Message-ID: <66f502d2f0187e6e4ab725a6a3c76cb5cc7730f3.1443973492.git.shli@fb.com>
References: <cover.1443973492.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <cover.1443973492.git.shli@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Kernel-team@fb.com, songliubraving@fb.com, hch@infradead.org, dan.j.williams@intel.com, neilb@suse.de
List-Id: linux-raid.ids

Move reclaim stop to quiesce handling, where is safer for this stuff.

Signed-off-by: Shaohua Li <shli@fb.com>
---
 drivers/md/raid5-cache.c | 30 ++++++++++++++++++------------
 drivers/md/raid5.c       |  1 +
 drivers/md/raid5.h       |  1 +
 3 files changed, 20 insertions(+), 12 deletions(-)

diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index a02f9ce..93097a8 100644
--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -748,6 +748,24 @@ static void r5l_wake_reclaim(struct r5l_log *log, sector_t space)
 	md_wakeup_thread(log->reclaim_thread);
 }
 
+void r5l_quiesce(struct r5l_log *log, int state)
+{
+	if (!log || state == 2)
+		return;
+	if (state == 0) {
+		log->reclaim_thread = md_register_thread(r5l_reclaim_thread,
+					log->rdev->mddev, "reclaim");
+	} else if (state == 1) {
+		/*
+		 * at this point all stripes are finished, so io_unit is at
+		 * least in STRIPE_END state
+		 */
+		r5l_wake_reclaim(log, -1L);
+		md_unregister_thread(&log->reclaim_thread);
+		r5l_do_reclaim(log);
+	}
+}
+
 struct r5l_recovery_ctx {
 	struct page *meta_page;		/* current meta */
 	sector_t meta_total_blocks;	/* total size of current meta and data */
@@ -1120,19 +1138,7 @@ int r5l_init_log(struct r5conf *conf, struct md_rdev *rdev)
 
 void r5l_exit_log(struct r5l_log *log)
 {
-	/*
-	 * at this point all stripes are finished, so io_unit is at least in
-	 * STRIPE_END state
-	 */
-	r5l_wake_reclaim(log, -1L);
 	md_unregister_thread(&log->reclaim_thread);
-	r5l_do_reclaim(log);
-	/*
-	 * force a super update, r5l_do_reclaim might updated the super.
-	 * mddev->thread is already stopped
-	 */
-	md_update_sb(log->rdev->mddev, 1);
-
 	kmem_cache_destroy(log->io_kc);
 	kfree(log);
 }
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index a622ccb..216fa3c 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -7582,6 +7582,7 @@ static void raid5_quiesce(struct mddev *mddev, int state)
 		unlock_all_device_hash_locks_irq(conf);
 		break;
 	}
+	r5l_quiesce(conf->log, state);
 }
 
 static void *raid45_takeover_raid0(struct mddev *mddev, int level)
diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
index 32c8ce8..1ab534c 100644
--- a/drivers/md/raid5.h
+++ b/drivers/md/raid5.h
@@ -630,4 +630,5 @@ extern void r5l_write_stripe_run(struct r5l_log *log);
 extern void r5l_flush_stripe_to_raid(struct r5l_log *log);
 extern void r5l_stripe_write_finished(struct stripe_head *sh);
 extern int r5l_handle_flush_request(struct r5l_log *log, struct bio *bio);
+extern void r5l_quiesce(struct r5l_log *log, int state);
 #endif
-- 
2.4.6

