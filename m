From: Yijing Wang <wangyijing@huawei.com>
Subject: [PATCH v2 1/3] bcache: Remove redundant parameter for cache_alloc()
Date: Fri, 1 Jul 2016 17:37:46 +0800
Message-ID: <1467365866-16290-1-git-send-email-wangyijing@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-bcache-owner@vger.kernel.org>
Sender: linux-bcache-owner@vger.kernel.org
To: axboe@fb.com, Kent Overstreet <kent.overstreet@gmail.com>
Cc: Eric Wheeler <git@linux.ewheeler.net>, Coly Li <colyli@suse.de>, linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, Yijing Wang <wangyijing@huawei.com>
List-Id: linux-raid.ids

Cache_sb is not used in cache_alloc, and we have copied
sb info to cache->sb already, remove it.

Reviewed-by: Coly Li <colyli@suse.de>
Signed-off-by: Yijing Wang <wangyijing@huawei.com>
---
 drivers/md/bcache/super.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index f5dbb4e..aecaace 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -1803,7 +1803,7 @@ void bch_cache_release(struct kobject *kobj)
 	module_put(THIS_MODULE);
 }
 
-static int cache_alloc(struct cache_sb *sb, struct cache *ca)
+static int cache_alloc(struct cache *ca)
 {
 	size_t free;
 	struct bucket *b;
@@ -1858,7 +1858,7 @@ static int register_cache(struct cache_sb *sb, struct page *sb_page,
 	if (blk_queue_discard(bdev_get_queue(ca->bdev)))
 		ca->discard = CACHE_DISCARD(&ca->sb);
 
-	ret = cache_alloc(sb, ca);
+	ret = cache_alloc(ca);
 	if (ret != 0)
 		goto err;
 
-- 
1.7.1
