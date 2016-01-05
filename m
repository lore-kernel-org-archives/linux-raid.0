From: Shaohua Li <shli@fb.com>
Subject: [PATCH 2/2] raid5-cache: correctly handle stripe with enough journal space
Date: Mon, 4 Jan 2016 16:43:07 -0800
Message-ID: <8bafb456f68b960bebaff8b742021d565554d5d4.1451954517.git.shli@fb.com>
References: <9ab2f48aab9ddc9aa7ac2b9b6a594a97c2d82f5f.1451954517.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <9ab2f48aab9ddc9aa7ac2b9b6a594a97c2d82f5f.1451954517.git.shli@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.de
List-Id: linux-raid.ids

If there are spaces in journal, we do nothing. Likely a typo merging
recent io_unit mempool patch.

Signed-off-by: Shaohua Li <shli@fb.com>
---
 drivers/md/raid5-cache.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index 55a905e..d242a36 100644
--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -494,19 +494,19 @@ int r5l_write_stripe(struct r5l_log *log, struct stripe_head *sh)
 	mutex_lock(&log->io_mutex);
 	/* meta + data */
 	reserve = (1 + write_disks) << (PAGE_SHIFT - 9);
-	if (!r5l_has_free_space(log, reserve)) {
-		spin_lock(&log->no_space_stripes_lock);
-		list_add_tail(&sh->log_list, &log->no_space_stripes);
-		spin_unlock(&log->no_space_stripes_lock);
-
-		r5l_wake_reclaim(log, reserve);
-
+	if (r5l_has_free_space(log, reserve)) {
 		ret = r5l_log_stripe(log, sh, data_pages, parity_pages);
 		if (ret) {
 			spin_lock_irq(&log->io_list_lock);
 			list_add_tail(&sh->log_list, &log->no_mem_stripes);
 			spin_unlock_irq(&log->io_list_lock);
 		}
+	} else {
+		spin_lock(&log->no_space_stripes_lock);
+		list_add_tail(&sh->log_list, &log->no_space_stripes);
+		spin_unlock(&log->no_space_stripes_lock);
+
+		r5l_wake_reclaim(log, reserve);
 	}
 
 	mutex_unlock(&log->io_mutex);
-- 
2.4.6

