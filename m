From: Shaohua Li <shli@fb.com>
Subject: [PATCH 2/8] raid5: fix build error
Date: Wed, 2 Sep 2015 13:49:45 -0700
Message-ID: <70577c27b523e4629c94c546891723c58a92ef11.1441221530.git.shli@fb.com>
References: <cover.1441221530.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <cover.1441221530.git.shli@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Kernel-team@fb.com, songliubraving@fb.com, hch@infradead.org, dan.j.williams@intel.com, neilb@suse.de
List-Id: linux-raid.ids

xchg doesn't work with u64 in 32-bit, so change the data type to
'unsigned long'. In theory we could overflow here, but it's not worthy
worrying about.

Reported-by: kbuild test robot <fengguang.wu@intel.com>
Signed-off-by: Shaohua Li <shli@fb.com>
---
 drivers/md/raid5-cache.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index 52feb90..c85d72a 100644
--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -69,7 +69,7 @@ struct r5l_log {
 	struct kmem_cache *io_kc;
 
 	struct md_thread *reclaim_thread;
-	sector_t reclaim_target; /* number of space that need to be reclaimed.
+	unsigned long reclaim_target; /* number of space that need to be reclaimed.
 				  * if it's 0, reclaim spaces used by io_units
 				  * which are in IO_UNIT_STRIPE_END state (eg,
 				  * reclaim dones't wait for specific io_unit
@@ -701,13 +701,14 @@ static void r5l_reclaim_thread(struct md_thread *thread)
 
 static void r5l_wake_reclaim(struct r5l_log *log, sector_t space)
 {
-	sector_t target;
+	unsigned long target;
+	unsigned long new = (unsigned long)space; /* overflow in theory */
 
 	do {
 		target = log->reclaim_target;
-		if (space < target)
+		if (new < target)
 			return;
-	} while (cmpxchg(&log->reclaim_target, target, space) != target);
+	} while (cmpxchg(&log->reclaim_target, target, new) != target);
 	md_wakeup_thread(log->reclaim_thread);
 }
 
-- 
1.8.1

