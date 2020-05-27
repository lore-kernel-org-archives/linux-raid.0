From: Yufen Yu <yuyufen@huawei.com>
Subject: [PATCH v3 03/11] md/raid5: allocate and free pages of r5pages
Date: Wed, 27 May 2020 21:19:25 +0800
Message-ID: <20200527131933.34400-4-yuyufen@huawei.com>
References: <20200527131933.34400-1-yuyufen@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20200527131933.34400-1-yuyufen@huawei.com>
Sender: linux-raid-owner@vger.kernel.org
To: song@kernel.org
Cc: linux-raid@vger.kernel.org, neilb@suse.com, guoqing.jiang@cloud.ionos.com, colyli@suse.de, xni@redhat.com, houtao1@huawei.com, yuyufen@huawei.com
List-Id: linux-raid.ids

When PAGE_SIZE is bigger than STRIPE_SIZE, try to allocate pages of
r5pages in grow_buffres() and free these pages in shrink_buffers().
Then, setting sh->dev[i].page and sh->dev[i].offset as the page in
array. Without enable shared page, we just set offset as value of '0'.

When reshape raid array, the new allocated stripes can reuse old stripe's
pages. By the way, we called resize_stripes() only when grow raid array
disks, so that don't worry about memleak for old r5pages.

Signed-off-by: Yufen Yu <yuyufen@huawei.com>
---
 drivers/md/raid5.c | 142 ++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 128 insertions(+), 14 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 3f96b4406902..57d140c930bd 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -448,20 +448,72 @@ static struct stripe_head *get_free_stripe(struct r5conf *conf, int hash)
 	return sh;
 }
 
+/*
+ * Try to free all pages in r5pages array.
+ */
+static void free_stripe_pages(struct stripe_head *sh)
+{
+	int i;
+	struct page *p;
+
+	/* Have not allocate page pool */
+	if (!sh->pages.page)
+		return;
+
+	for (i = 0; i < sh->pages.size; i++) {
+		p = sh->pages.page[i];
+		if (p)
+			put_page(p);
+		sh->pages.page[i] = NULL;
+	}
+}
+
+/*
+ * Allocate pages for r5pages.
+ */
+static int alloc_stripe_pages(struct stripe_head *sh, gfp_t gfp)
+{
+	int i;
+	struct page *p;
+
+	for (i = 0; i < sh->pages.size; i++) {
+		/* The page have allocated. */
+		if (sh->pages.page[i])
+			continue;
+
+		p = alloc_page(gfp);
+		if (!p) {
+			free_stripe_pages(sh);
+			return -ENOMEM;
+		}
+		sh->pages.page[i] = p;
+	}
+	return 0;
+}
+
 static void shrink_buffers(struct stripe_head *sh)
 {
 	struct page *p;
 	int i;
 	int num = sh->raid_conf->pool_size;
 
-	for (i = 0; i < num ; i++) {
+	if (raid5_stripe_pages_shared(sh->raid_conf))
+		free_stripe_pages(sh); /* Free pages in r5pages */
+
+	for (i = 0; i < num; i++) {
 		WARN_ON(sh->dev[i].page != sh->dev[i].orig_page);
 		p = sh->dev[i].page;
-		if (!p)
+
+		/*
+		 * If we use pages in r5pages, these pages have been
+		 * freed in free_stripe_pages().
+		 */
+		if (raid5_stripe_pages_shared(sh->raid_conf) || !p)
 			continue;
 		sh->dev[i].page = NULL;
 		put_page(p);
 	}
+
 }
 
 static int grow_buffers(struct stripe_head *sh, gfp_t gfp)
@@ -469,14 +521,26 @@ static int grow_buffers(struct stripe_head *sh, gfp_t gfp)
 	int i;
 	int num = sh->raid_conf->pool_size;
 
+	if (raid5_stripe_pages_shared(sh->raid_conf) &&
+			alloc_stripe_pages(sh, gfp))
+		return -ENOMEM;
+
 	for (i = 0; i < num; i++) {
 		struct page *page;
+		unsigned int offset;
 
-		if (!(page = alloc_page(gfp))) {
-			return 1;
+		if (raid5_stripe_pages_shared(sh->raid_conf)) {
+			page = raid5_get_dev_page(sh, i);
+			offset = raid5_get_page_offset(sh, i);
+		} else {
+			page = alloc_page(gfp);
+			if (!page)
+				return -ENOMEM;
+			offset = 0;
 		}
 		sh->dev[i].page = page;
 		sh->dev[i].orig_page = page;
+		sh->dev[i].offset = offset;
 	}
 
 	return 0;
@@ -2123,6 +2187,9 @@ static void raid_run_ops(struct stripe_head *sh, unsigned long ops_request)
 
 static void free_stripe(struct kmem_cache *sc, struct stripe_head *sh)
 {
+	if (sh->pages.page)
+		kfree(sh->pages.page);
+
 	if (sh->ppl_page)
 		__free_page(sh->ppl_page);
 	kmem_cache_free(sc, sh);
@@ -2154,14 +2221,28 @@ static struct stripe_head *alloc_stripe(struct kmem_cache *sc, gfp_t gfp,
 
 		if (raid5_has_ppl(conf)) {
 			sh->ppl_page = alloc_page(gfp);
-			if (!sh->ppl_page) {
-				free_stripe(sc, sh);
-				sh = NULL;
-			}
+			if (!sh->ppl_page)
+				goto fail;
+		}
+
+		if (raid5_stripe_pages_shared(conf)) {
+			int nr_page;
+
+			/* Each of the sh->dev[i] need one STRIPE_SIZE */
+			nr_page = (disks * STRIPE_SIZE + PAGE_SIZE - 1) / PAGE_SIZE;
+			sh->pages.page = kzalloc(sizeof(struct page *) * nr_page, gfp);
+			if (!sh->pages.page)
+				goto fail;
+			sh->pages.size = nr_page;
 		}
 	}
 	return sh;
+
+fail:
+	free_stripe(sc, sh);
+	return NULL;
 }
+
 static int grow_one_stripe(struct r5conf *conf, gfp_t gfp)
 {
 	struct stripe_head *sh;
@@ -2360,10 +2441,18 @@ static int resize_stripes(struct r5conf *conf, int newsize)
 		osh = get_free_stripe(conf, hash);
 		unlock_device_hash_lock(conf, hash);
 
-		for(i=0; i<conf->pool_size; i++) {
+		if (raid5_stripe_pages_shared(conf)) {
+			/* We reuse pages in r5pages of old stripe head */
+			for (i = 0; i < osh->pages.size; i++)
+				nsh->pages.page[i] = osh->pages.page[i];
+		}
+
+		for (i = 0; i < conf->pool_size; i++) {
 			nsh->dev[i].page = osh->dev[i].page;
 			nsh->dev[i].orig_page = osh->dev[i].page;
+			nsh->dev[i].offset = osh->dev[i].offset;
 		}
+
 		nsh->hash_lock_index = hash;
 		free_stripe(conf->slab_cache, osh);
 		cnt++;
@@ -2410,17 +2499,42 @@ static int resize_stripes(struct r5conf *conf, int newsize)
 
 	/* Step 4, return new stripes to service */
 	while(!list_empty(&newstripes)) {
+		struct page *p;
+		unsigned int offset;
 		nsh = list_entry(newstripes.next, struct stripe_head, lru);
 		list_del_init(&nsh->lru);
 
-		for (i=conf->raid_disks; i < newsize; i++)
-			if (nsh->dev[i].page == NULL) {
-				struct page *p = alloc_page(GFP_NOIO);
-				nsh->dev[i].page = p;
-				nsh->dev[i].orig_page = p;
+		/*
+		 * If we use r5pages, means, pages.size is not zero,
+		 * allocate pages it needed for new stripe_head.
+		 */
+		for (i = 0; i < nsh->pages.size; i++) {
+			if (nsh->pages.page[i] == NULL) {
+				p = alloc_page(GFP_NOIO);
 				if (!p)
 					err = -ENOMEM;
+				nsh->pages.page[i] = p;
 			}
+		}
+
+		for (i = conf->raid_disks; i < newsize; i++) {
+			if (nsh->dev[i].page)
+				continue;
+
+			if (raid5_stripe_pages_shared(conf)) {
+				p = raid5_get_dev_page(nsh, i);
+				offset = raid5_get_page_offset(nsh, i);
+			} else {
+				p = alloc_page(GFP_NOIO);
+				if (!p)
+					err = -ENOMEM;
+				offset = 0;
+			}
+
+			nsh->dev[i].page = p;
+			nsh->dev[i].orig_page = p;
+			nsh->dev[i].offset = offset;
+		}
 		raid5_release_stripe(nsh);
 	}
 	/* critical section pass, GFP_NOIO no longer needed */
-- 
2.21.3
