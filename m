From: Zhilong Liu <zlliu@suse.com>
Subject: [PATCH] md:fix a trivial typo in comments
Date: Mon, 13 Mar 2017 13:53:27 +0800
Message-ID: <1489384407-12672-1-git-send-email-zlliu@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: shli@fb.com
Cc: linux-raid@vger.kernel.org, Zhilong Liu <zlliu@suse.com>
List-Id: linux-raid.ids

fix a trivial typo in freeze_array() of raid1.c

Signed-off-by: Zhilong Liu <zlliu@suse.com>
---
 drivers/md/raid1.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 7b0f647..2ec0617 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -958,7 +958,7 @@ static void allow_barrier(struct r1conf *conf, sector_t start_next_window,
 static void freeze_array(struct r1conf *conf, int extra)
 {
 	/* stop syncio and normal IO and wait for everything to
-	 * go quite.
+	 * go quit.
 	 * We wait until nr_pending match nr_queued+extra
 	 * This is called in the context of one normal IO request
 	 * that has failed. Thus any sync request that might be pending
-- 
2.6.6

