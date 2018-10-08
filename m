From: Colin King <colin.king@canonical.com>
Subject: [PATCH][md-next] md: remove redundant code that is no longer reachable
Date: Mon,  8 Oct 2018 22:16:09 +0100
Message-ID: <20181008211609.9650-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>, linux-raid@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

From: Colin Ian King <colin.king@canonical.com>

And earlier commit removed the error label to two statements that
are now never reachable.  Since this code is now dead code, remove it.

Detected by CoverityScan, CID#1462409 ("Structurally dead code")

Fixes: d5d885fd514f ("md: introduce new personality funciton start()")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/md/raid5-cache.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index e6e925add700..ec3a5ef7fee0 100644
--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -3151,8 +3151,6 @@ int r5l_init_log(struct r5conf *conf, struct md_rdev *rdev)
 	set_bit(MD_HAS_JOURNAL, &conf->mddev->flags);
 	return 0;
 
-	rcu_assign_pointer(conf->log, NULL);
-	md_unregister_thread(&log->reclaim_thread);
 reclaim_thread:
 	mempool_exit(&log->meta_pool);
 out_mempool:
-- 
2.17.1
