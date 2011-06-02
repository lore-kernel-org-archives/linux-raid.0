From: Namhyung Kim <namhyung@gmail.com>
Subject: [PATCH 1/2] md: convert double atomic_inc() to atomic_add()
Date: Thu,  2 Jun 2011 13:53:02 +0900
Message-ID: <1306990383-14133-1-git-send-email-namhyung@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 drivers/md/md.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index aa640a85bb21..f210e42a56ca 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -396,8 +396,7 @@ static void submit_flushes(struct work_struct *ws)
 			 * we reclaim rcu_read_lock
 			 */
 			struct bio *bi;
-			atomic_inc(&rdev->nr_pending);
-			atomic_inc(&rdev->nr_pending);
+			atomic_add(2, &rdev->nr_pending);
 			rcu_read_unlock();
 			bi = bio_alloc_mddev(GFP_KERNEL, 0, mddev);
 			bi->bi_end_io = md_end_flush;
-- 
1.7.5.2
