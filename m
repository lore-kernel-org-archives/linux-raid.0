From: Julia Lawall <Julia.Lawall@lip6.fr>
Subject: [PATCH 15/39] bcache: drop null test before destroy functions
Date: Sun, 13 Sep 2015 14:15:08 +0200
Message-ID: <1442146532-9100-16-git-send-email-Julia.Lawall@lip6.fr>
References: <1442146532-9100-1-git-send-email-Julia.Lawall@lip6.fr>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1442146532-9100-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
To: Kent Overstreet <kent.overstreet@gmail.com>
Cc: sergey.senozhatsky@gmail.com, kernel-janitors@vger.kernel.org, Neil Brown <neilb@suse.com>, linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

Remove unneeded NULL test.

The semantic patch that makes this change is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@ expression x; @@
-if (x != NULL)
  \(kmem_cache_destroy\|mempool_destroy\|dma_pool_destroy\)(x);
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/md/bcache/bset.c    |    3 +--
 drivers/md/bcache/request.c |    3 +--
 drivers/md/bcache/super.c   |    9 +++------
 3 files changed, 5 insertions(+), 10 deletions(-)

diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
index 8e9877b..bd4678c 100644
--- a/drivers/md/bcache/request.c
+++ b/drivers/md/bcache/request.c
@@ -1145,8 +1145,7 @@ void bch_flash_dev_request_init(struct bcache_device *d)
 
 void bch_request_exit(void)
 {
-	if (bch_search_cache)
-		kmem_cache_destroy(bch_search_cache);
+	kmem_cache_destroy(bch_search_cache);
 }
 
 int __init bch_request_init(void)
diff --git a/drivers/md/bcache/bset.c b/drivers/md/bcache/bset.c
index 646fe85..479117c 100644
--- a/drivers/md/bcache/bset.c
+++ b/drivers/md/bcache/bset.c
@@ -1116,8 +1116,7 @@ struct bkey *bch_btree_iter_next_filter(struct btree_iter *iter,
 
 void bch_bset_sort_state_free(struct bset_sort_state *state)
 {
-	if (state->pool)
-		mempool_destroy(state->pool);
+	mempool_destroy(state->pool);
 }
 
 int bch_bset_sort_state_init(struct bset_sort_state *state, unsigned page_order)
diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index 679a093..c27a0ff 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -1335,12 +1335,9 @@ static void cache_set_free(struct closure *cl)
 		destroy_workqueue(c->moving_gc_wq);
 	if (c->bio_split)
 		bioset_free(c->bio_split);
-	if (c->fill_iter)
-		mempool_destroy(c->fill_iter);
-	if (c->bio_meta)
-		mempool_destroy(c->bio_meta);
-	if (c->search)
-		mempool_destroy(c->search);
+	mempool_destroy(c->fill_iter);
+	mempool_destroy(c->bio_meta);
+	mempool_destroy(c->search);
 	kfree(c->devices);
 
 	mutex_lock(&bch_register_lock);
