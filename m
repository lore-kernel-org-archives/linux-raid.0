From: Song Liu <songliubraving@fb.com>
Subject: [PATCH 1/2] md/r5cache: move clear_bit STRIPE_R5C_PARTIAL/FULL_STRIPE
Date: Wed, 28 Dec 2016 17:18:01 -0800
Message-ID: <20161229011802.692478-1-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.com, shli@fb.com, kernel-team@fb.com, dan.j.williams@intel.com, hch@infradead.org, liuzhengyuan@kylinos.cn, liuyun01@kylinos.cn, Song Liu <songliubraving@fb.com>, Jes.Sorensen@redhat.com
List-Id: linux-raid.ids

This patch moves clear_bit of STRIPE_R5C_PARTIAL_STRIPE and
STRIPE_R5C_FULL_STRIPE to r5c_finish_stripe_write_out(). This is
to prepare the next patch for chunk_aligned_read with write_back
cache.

Signed-off-by: Song Liu <songliubraving@fb.com>
---
 drivers/md/raid5-cache.c | 21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index ac98a82..817b294 100644
--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -410,16 +410,6 @@ void r5c_make_stripe_write_out(struct stripe_head *sh)
 
 	if (!test_and_set_bit(STRIPE_PREREAD_ACTIVE, &sh->state))
 		atomic_inc(&conf->preread_active_stripes);
-
-	if (test_and_clear_bit(STRIPE_R5C_PARTIAL_STRIPE, &sh->state)) {
-		BUG_ON(atomic_read(&conf->r5c_cached_partial_stripes) == 0);
-		atomic_dec(&conf->r5c_cached_partial_stripes);
-	}
-
-	if (test_and_clear_bit(STRIPE_R5C_FULL_STRIPE, &sh->state)) {
-		BUG_ON(atomic_read(&conf->r5c_cached_full_stripes) == 0);
-		atomic_dec(&conf->r5c_cached_full_stripes);
-	}
 }
 
 static void r5c_handle_data_cached(struct stripe_head *sh)
@@ -2447,8 +2437,19 @@ void r5c_finish_stripe_write_out(struct r5conf *conf,
 	list_del_init(&sh->r5c);
 	spin_unlock_irq(&conf->log->stripe_in_journal_lock);
 	sh->log_start = MaxSector;
+
 	atomic_dec(&conf->log->stripe_in_journal_count);
 	r5c_update_log_state(conf->log);
+
+	if (test_and_clear_bit(STRIPE_R5C_PARTIAL_STRIPE, &sh->state)) {
+		BUG_ON(atomic_read(&conf->r5c_cached_partial_stripes) == 0);
+		atomic_dec(&conf->r5c_cached_partial_stripes);
+	}
+
+	if (test_and_clear_bit(STRIPE_R5C_FULL_STRIPE, &sh->state)) {
+		BUG_ON(atomic_read(&conf->r5c_cached_full_stripes) == 0);
+		atomic_dec(&conf->r5c_cached_full_stripes);
+	}
 }
 
 int
-- 
2.9.3

