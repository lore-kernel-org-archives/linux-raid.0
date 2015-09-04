From: Shaohua Li <shli@fb.com>
Subject: [PATCH] raid5-cache: don't delay stripe captured in log
Date: Fri, 4 Sep 2015 14:14:16 -0700
Message-ID: <5d4ccda3c53d97e90d96bd250df1c9b701e2f01a.1441390510.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Kernel-team@fb.com, songliubraving@fb.com, hch@infradead.org, dan.j.williams@intel.com, neilb@suse.de
List-Id: linux-raid.ids

There is a case a stripe gets delayed forever.
1. a stripe finishes construction
2. a new bio hits the stripe
3. handle_stripe runs for the stripe. The stripe gets DELAYED bit set
since construction can't run for new bio (the stripe is locked since
step 1)

Without log, handle_stripe will call ops_run_io. After IO finishes, the
stripe gets unlocked and the stripe will restart and run construction
for the new bio. With log, ops_run_io need to run two times. If the
DELAYED bit set, the stripe can't enter into the handle_list, so the
second ops_run_io doesn't run, which leaves the stripe stalled.

Signed-off-by: Shaohua Li <shli@fb.com>
---
 drivers/md/raid5-cache.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index 2dea05f..785749b1 100644
--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -474,6 +474,11 @@ int r5l_write_stripe(struct r5l_log *log, struct stripe_head *sh)
 		return -EINVAL;
 
 	set_bit(STRIPE_LOG_TRAPPED, &sh->state);
+	/*
+	 * The stripe must enter state machine again to finish the write, so
+	 * don't delay.
+	 * */
+	clear_bit(STRIPE_DELAYED, &sh->state);
 	atomic_inc(&sh->count);
 
 	mutex_lock(&log->io_mutex);
-- 
1.8.1

