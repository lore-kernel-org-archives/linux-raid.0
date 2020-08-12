From: Yufen Yu <yuyufen@huawei.com>
Subject: [PATCH 10/12] md/raid5: let multiple devices of stripe_head share page
Date: Wed, 12 Aug 2020 08:49:29 -0400
Message-ID: <20200812124931.2584743-11-yuyufen@huawei.com>
References: <20200812124931.2584743-1-yuyufen@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20200812124931.2584743-1-yuyufen@huawei.com>
Sender: linux-raid-owner@vger.kernel.org
To: song@kernel.org
Cc: linux-raid@vger.kernel.org, neilb@suse.com, guoqing.jiang@cloud.ionos.com, houtao1@huawei.com, yuyufen@huawei.com
List-Id: linux-raid.ids

In current implementation, grow_buffers() uses alloc_page() to
allocate the buffers for each stripe_head, i.e. allocate a page
for each dev[i] in stripe_head.

After setting stripe_size as a configurable value by writing
sysfs entry, it means that we always allocate 64K buffers, but
just use 4K of them when stripe_size is 4K in 64KB arm64.

To avoid wasting memory, we try to let multiple sh->dev share
one real page. That means, multiple sh->dev[i].page will point
to the only page with different offset. Example of 64K PAGE_SIZE
and 4K stripe_size as following:

                    64K PAGE_SIZE
          +---+---+---+---+------------------------------+
          |   |   |   |   |
          |   |   |   |   |
          +-+-+-+-+-+-+-+-+------------------------------+
            ^   ^   ^   ^
            |   |   |   +----------------------------+
            |   |   |                                |
            |   |   +-------------------+            |
            |   |                       |            |
            |   +----------+            |            |
            |              |            |            |
            +-+            |            |            |
              |            |            |            |
        +-----+-----+------+-----+------+-----+------+------+
sh      | offset(0) | offset(4K) | offset(8K) | offset(12K) |
 +      +-----------+------------+------------+-------------+
 +----> dev[0].page  dev[1].page  dev[2].page  dev[3].page

A new 'pages' array will be added into stripe_head to record shared
page used by this stripe_head. Allocate them when grow_buffers()
and free them when shrink_buffers().

After trying to share page, the users of sh->dev[i].page need to take
care of the related page offset: page into issued bio and page passed
to xor compution functions. But thanks for previous different page offset
supported. Here, we just need to set corrent dev[i].offset.

Signed-off-by: Yufen Yu <yuyufen@huawei.com>
---
 drivers/md/raid5.c | 89 ++++++++++++++++++++++++++++++++++++++++++++--
 drivers/md/raid5.h | 28 ++++++++++++++-
 2 files changed, 114 insertions(+), 3 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index dfe29d5fc9ad..189ef51e853a 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -448,13 +448,74 @@ static struct stripe_head *get_free_stripe(struct r5conf *conf, int hash)
 	return sh;
 }
 
-static void shrink_buffers(struct stripe_head *sh)
+#if PAGE_SIZE != DEFAULT_STRIPE_SIZE
+static void free_stripe_pages(struct stripe_head *sh)
+{
+	int i;
+	struct page *p;
+
+	/* Have not allocate page pool */
+	if (!sh->pages)
+		return;
+
+	for (i = 0; i < sh->nr_pages; i++) {
+		p = sh->pages[i];
+		if (p)
+			put_page(p);
+		sh->pages[i] = NULL;
+	}
+}
+
+static int alloc_stripe_pages(struct stripe_head *sh, gfp_t gfp)
 {
+	int i;
 	struct page *p;
+
+	for (i = 0; i < sh->nr_pages; i++) {
+		/* The page have allocated. */
+		if (sh->pages[i])
+			continue;
+
+		p = alloc_page(gfp);
+		if (!p) {
+			free_stripe_pages(sh);
+			return -ENOMEM;
+		}
+		sh->pages[i] = p;
+	}
+	return 0;
+}
+
+static int
+init_stripe_shared_pages(struct stripe_head *sh, struct r5conf *conf)
+{
+	int nr_pages, cnt;
+
+	if (sh->pages)
+		return 0;
+
+	/* Each of the sh->dev[i] need one conf->stripe_size */
+	cnt = PAGE_SIZE / conf->stripe_size;
+	nr_pages = (conf->raid_disks + cnt - 1) / cnt;
+
+	sh->pages = kcalloc(nr_pages, sizeof(struct page *), GFP_KERNEL);
+	if (!sh->pages)
+		return -ENOMEM;
+	sh->nr_pages = nr_pages;
+	sh->stripes_per_page = cnt;
+	return 0;
+}
+#endif
+
+static void shrink_buffers(struct stripe_head *sh)
+{
 	int i;
 	int num = sh->raid_conf->pool_size;
 
+#if PAGE_SIZE == DEFAULT_STRIPE_SIZE
 	for (i = 0; i < num ; i++) {
+		struct page *p;
+
 		WARN_ON(sh->dev[i].page != sh->dev[i].orig_page);
 		p = sh->dev[i].page;
 		if (!p)
@@ -462,6 +523,11 @@ static void shrink_buffers(struct stripe_head *sh)
 		sh->dev[i].page = NULL;
 		put_page(p);
 	}
+#else
+	for (i = 0; i < num; i++)
+		sh->dev[i].page = NULL;
+	free_stripe_pages(sh); /* Free pages */
+#endif
 }
 
 static int grow_buffers(struct stripe_head *sh, gfp_t gfp)
@@ -469,6 +535,7 @@ static int grow_buffers(struct stripe_head *sh, gfp_t gfp)
 	int i;
 	int num = sh->raid_conf->pool_size;
 
+#if PAGE_SIZE == DEFAULT_STRIPE_SIZE
 	for (i = 0; i < num; i++) {
 		struct page *page;
 
@@ -479,7 +546,16 @@ static int grow_buffers(struct stripe_head *sh, gfp_t gfp)
 		sh->dev[i].orig_page = page;
 		sh->dev[i].offset = 0;
 	}
+#else
+	if (alloc_stripe_pages(sh, gfp))
+		return -ENOMEM;
 
+	for (i = 0; i < num; i++) {
+		sh->dev[i].page = raid5_get_dev_page(sh, i);
+		sh->dev[i].orig_page = sh->dev[i].page;
+		sh->dev[i].offset = raid5_get_page_offset(sh, i);
+	}
+#endif
 	return 0;
 }
 
@@ -2203,6 +2279,9 @@ static void raid_run_ops(struct stripe_head *sh, unsigned long ops_request)
 
 static void free_stripe(struct kmem_cache *sc, struct stripe_head *sh)
 {
+#if PAGE_SIZE != DEFAULT_STRIPE_SIZE
+	kfree(sh->pages);
+#endif
 	if (sh->ppl_page)
 		__free_page(sh->ppl_page);
 	kmem_cache_free(sc, sh);
@@ -2236,9 +2315,15 @@ static struct stripe_head *alloc_stripe(struct kmem_cache *sc, gfp_t gfp,
 			sh->ppl_page = alloc_page(gfp);
 			if (!sh->ppl_page) {
 				free_stripe(sc, sh);
-				sh = NULL;
+				return NULL;
 			}
 		}
+#if PAGE_SIZE != DEFAULT_STRIPE_SIZE
+		if (init_stripe_shared_pages(sh, conf)) {
+			free_stripe(sc, sh);
+			return NULL;
+		}
+#endif
 	}
 	return sh;
 }
diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
index 6b019cbe0fba..5244b7627296 100644
--- a/drivers/md/raid5.h
+++ b/drivers/md/raid5.h
@@ -195,6 +195,7 @@ enum reconstruct_states {
 	reconstruct_state_result,
 };
 
+#define DEFAULT_STRIPE_SIZE	4096
 struct stripe_head {
 	struct hlist_node	hash;
 	struct list_head	lru;	      /* inactive_list or handle_list */
@@ -246,6 +247,13 @@ struct stripe_head {
 		int 		     target, target2;
 		enum sum_check_flags zero_sum_result;
 	} ops;
+
+#if PAGE_SIZE != DEFAULT_STRIPE_SIZE
+	/* These pages will be used by bios in dev[i] */
+	struct page	**pages;
+	int	nr_pages;	/* page array size */
+	int	stripes_per_page;
+#endif
 	struct r5dev {
 		/* rreq and rvec are used for the replacement device when
 		 * writing data to both devices.
@@ -473,7 +481,6 @@ struct disk_info {
  */
 
 #define NR_STRIPES		256
-#define DEFAULT_STRIPE_SIZE	4096
 
 #if PAGE_SIZE == DEFAULT_STRIPE_SIZE
 #define STRIPE_SIZE		PAGE_SIZE
@@ -772,6 +779,25 @@ static inline int algorithm_is_DDF(int layout)
 	return layout >= 8 && layout <= 10;
 }
 
+#if PAGE_SIZE != DEFAULT_STRIPE_SIZE
+/*
+ * Return offset of the corresponding page for r5dev.
+ */
+static inline int raid5_get_page_offset(struct stripe_head *sh, int disk_idx)
+{
+	return (disk_idx % sh->stripes_per_page) * RAID5_STRIPE_SIZE(sh->raid_conf);
+}
+
+/*
+ * Return corresponding page address for r5dev.
+ */
+static inline struct page *
+raid5_get_dev_page(struct stripe_head *sh, int disk_idx)
+{
+	return sh->pages[disk_idx / sh->stripes_per_page];
+}
+#endif
+
 extern void md_raid5_kick_device(struct r5conf *conf);
 extern int raid5_set_cache_size(struct mddev *mddev, int size);
 extern sector_t raid5_compute_blocknr(struct stripe_head *sh, int i, int previous);
-- 
2.25.4
