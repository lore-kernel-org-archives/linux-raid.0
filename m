Return-Path: <SRS0=xKAG=B6=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6998EC433E4
	for <linux-raid@archiver.kernel.org>; Thu, 20 Aug 2020 13:28:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 44620208A9
	for <linux-raid@archiver.kernel.org>; Thu, 20 Aug 2020 13:28:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728417AbgHTNW7 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 20 Aug 2020 09:22:59 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:10238 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728472AbgHTNVz (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Thu, 20 Aug 2020 09:21:55 -0400
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 7A87B78F3DD0B4D4AA3E;
        Thu, 20 Aug 2020 21:21:51 +0800 (CST)
Received: from huawei.com (10.175.101.6) by DGGEMS406-HUB.china.huawei.com
 (10.3.19.206) with Microsoft SMTP Server id 14.3.487.0; Thu, 20 Aug 2020
 21:21:45 +0800
From:   Yufen Yu <yuyufen@huawei.com>
To:     <song@kernel.org>
CC:     <linux-raid@vger.kernel.org>, <houtao1@huawei.com>
Subject: [PATCH v2 08/10] md/raid5: let multiple devices of stripe_head share page
Date:   Thu, 20 Aug 2020 09:22:12 -0400
Message-ID: <20200820132214.3749139-9-yuyufen@huawei.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200820132214.3749139-1-yuyufen@huawei.com>
References: <20200820132214.3749139-1-yuyufen@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.101.6]
X-CFilter-Loop: Reflected
Sender: linux-raid-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

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
care of the related page offset: page of issued bio and page passed
to xor compution functions. But thanks for previous different page offset
supported. Here, we just need to set correct dev[i].offset.

Signed-off-by: Yufen Yu <yuyufen@huawei.com>
---
 drivers/md/raid5.c | 89 ++++++++++++++++++++++++++++++++++++++++++++--
 drivers/md/raid5.h | 28 ++++++++++++++-
 2 files changed, 114 insertions(+), 3 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 8ed4610deeb2..c038be864257 100644
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
+init_stripe_shared_pages(struct stripe_head *sh, struct r5conf *conf, int disks)
+{
+	int nr_pages, cnt;
+
+	if (sh->pages)
+		return 0;
+
+	/* Each of the sh->dev[i] need one conf->stripe_size */
+	cnt = PAGE_SIZE / conf->stripe_size;
+	nr_pages = (disks + cnt - 1) / cnt;
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
 
@@ -2205,6 +2281,9 @@ static void raid_run_ops(struct stripe_head *sh, unsigned long ops_request)
 
 static void free_stripe(struct kmem_cache *sc, struct stripe_head *sh)
 {
+#if PAGE_SIZE != DEFAULT_STRIPE_SIZE
+	kfree(sh->pages);
+#endif
 	if (sh->ppl_page)
 		__free_page(sh->ppl_page);
 	kmem_cache_free(sc, sh);
@@ -2238,9 +2317,15 @@ static struct stripe_head *alloc_stripe(struct kmem_cache *sc, gfp_t gfp,
 			sh->ppl_page = alloc_page(gfp);
 			if (!sh->ppl_page) {
 				free_stripe(sc, sh);
-				sh = NULL;
+				return NULL;
 			}
 		}
+#if PAGE_SIZE != DEFAULT_STRIPE_SIZE
+		if (init_stripe_shared_pages(sh, conf, disks)) {
+			free_stripe(sc, sh);
+			return NULL;
+		}
+#endif
 	}
 	return sh;
 }
diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
index 6afdd3a78580..5c05acf20e1f 100644
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

