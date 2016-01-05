From: Shaohua Li <shli@fb.com>
Subject: [PATCH 1/2] raid5-cache: destroy mempool
Date: Mon, 4 Jan 2016 16:43:06 -0800
Message-ID: <9ab2f48aab9ddc9aa7ac2b9b6a594a97c2d82f5f.1451954517.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.de
List-Id: linux-raid.ids

io_unit mempool isn't destroied with recent changes.

Signed-off-by: Shaohua Li <shli@fb.com>
---
 drivers/md/raid5-cache.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index d992d62..55a905e 100644
--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -1257,6 +1257,7 @@ void r5l_exit_log(struct r5l_log *log)
 	md_unregister_thread(&log->reclaim_thread);
 	mempool_destroy(log->meta_pool);
 	bioset_free(log->bs);
+	mempool_destroy(log->io_pool);
 	kmem_cache_destroy(log->io_kc);
 	kfree(log);
 }
-- 
2.4.6

