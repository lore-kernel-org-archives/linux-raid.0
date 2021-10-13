Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9DD8C433F5
	for <linux-raid@archiver.kernel.org>; Wed, 13 Oct 2021 16:00:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CD939610FE
	for <linux-raid@archiver.kernel.org>; Wed, 13 Oct 2021 16:00:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237573AbhJMQCs (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 13 Oct 2021 12:02:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237567AbhJMQCq (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 13 Oct 2021 12:02:46 -0400
Received: from mail-qv1-xf36.google.com (mail-qv1-xf36.google.com [IPv6:2607:f8b0:4864:20::f36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39516C061570;
        Wed, 13 Oct 2021 09:00:43 -0700 (PDT)
Received: by mail-qv1-xf36.google.com with SMTP id n12so1975492qvk.3;
        Wed, 13 Oct 2021 09:00:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=pZexP7HogPfyV8yTiXGv7CUWiNgnazFkMB2vWUC/dbo=;
        b=GJh4rtFJ38Z6naQzZ8Xp9sIvZwwAZbpY9qdMZbmiWoeDWkKABOU3kTQVN508osXhEu
         VKW5jW1sgoSolLAwb1r0NnabzjFEaMiy32diG+QLlz+MU0cqbUlTmjbGhHjbTjLxpC1f
         w6mKKLf+9C7rfLd6c3wvqlGFznroCDRis44gi83jSdA2dW3JGegquav69UiEHLxKzNCO
         lBqQNR1LC15JS3OonZU+0n8/1DTjpf2Xnykr8W+bto0CmA+g5Sk2SsMZl5kMfpJ52yZZ
         KzfvEFFuqROwoQNATs36ElJxJO0y7KAv709wsjXk+j4vgqyJO55498hcVI9y9jOqbhzi
         dDxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pZexP7HogPfyV8yTiXGv7CUWiNgnazFkMB2vWUC/dbo=;
        b=mM5/niuJTQANGUFHP+Ts+9bpcZKYbixWuMT+QqPQq6eaY/nF+L9Nku6+HwT4mnKw42
         0p8G+7pyZrXZgaoKSDIxV6RFIzi/6cuSURO5daX3HuvwOSmaGMy0MEH6jnBpANBo2vm9
         tn9tVLfd+eNzw508QzR34Hndj/azEYo79uJdQI6k4+GiTLysgdNC2BsplQYDmi059kmT
         1V8RM6tK1fv0MTcXByYSJofg9n+hqSk5Vw9YvYT3VWKPFeOy9qaLAlF/0ClOJpW/w2eK
         8zcy2Voukeay/5ZasnnPoPU4foEgFb7nwDvs5J+OH714N+WbB6MmJGcJM5WvDUsApGTB
         BBOQ==
X-Gm-Message-State: AOAM531WL4CQDsvdbbNm53Peem+4jOqbirr0yB0Y7sLAzVnybMmcktri
        NkjAVEwDEzVtcmMWAA/McvgHOry/VbBn
X-Google-Smtp-Source: ABdhPJweZh80c8p2kCFXcJDAOtKDvmfyAuC0lF3eF4cM2TDclooX+UDe12liPR44rLkcgU6VXNe+iw==
X-Received: by 2002:a05:6214:1c8d:: with SMTP id ib13mr36691652qvb.10.1634140841945;
        Wed, 13 Oct 2021 09:00:41 -0700 (PDT)
Received: from moria.home.lan (c-73-219-103-14.hsd1.vt.comcast.net. [73.219.103.14])
        by smtp.gmail.com with ESMTPSA id w17sm20161qts.53.2021.10.13.09.00.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Oct 2021 09:00:41 -0700 (PDT)
From:   Kent Overstreet <kent.overstreet@gmail.com>
To:     linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org, linux-raid@vger.kernel.org,
        linux-block@vger.kernel.org, axboe@kernel.dk
Cc:     Kent Overstreet <kent.overstreet@gmail.com>,
        alexander.h.duyck@linux.intel.com
Subject: [PATCH 1/5] mm: Make free_area->nr_free per migratetype
Date:   Wed, 13 Oct 2021 12:00:30 -0400
Message-Id: <20211013160034.3472923-2-kent.overstreet@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211013160034.3472923-1-kent.overstreet@gmail.com>
References: <20211013160034.3472923-1-kent.overstreet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

This is prep work for introducing a struct page_free_list, which will
have a list head and nr_free - it turns out a fair amount of the code
looking at free_area->nr_free actually wants the number of elements on a
particular freelist.

Signed-off-by: Kent Overstreet <kent.overstreet@gmail.com>
---
 include/linux/mmzone.h | 14 ++++++++++++--
 mm/page_alloc.c        | 30 +++++++++++++++++-------------
 mm/page_reporting.c    |  2 +-
 mm/vmstat.c            | 28 +++-------------------------
 4 files changed, 33 insertions(+), 41 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 6a1d79d846..089587b918 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -96,7 +96,7 @@ extern int page_group_by_mobility_disabled;
 
 struct free_area {
 	struct list_head	free_list[MIGRATE_TYPES];
-	unsigned long		nr_free;
+	unsigned long		nr_free[MIGRATE_TYPES];
 };
 
 static inline struct page *get_page_from_free_area(struct free_area *area,
@@ -108,7 +108,17 @@ static inline struct page *get_page_from_free_area(struct free_area *area,
 
 static inline bool free_area_empty(struct free_area *area, int migratetype)
 {
-	return list_empty(&area->free_list[migratetype]);
+	return area->nr_free[migratetype] == 0;
+}
+
+static inline size_t free_area_nr_free(struct free_area *area)
+{
+	unsigned migratetype;
+	size_t nr_free = 0;
+
+	for (migratetype = 0; migratetype < MIGRATE_TYPES; migratetype++)
+		nr_free += area->nr_free[migratetype];
+	return nr_free;
 }
 
 struct pglist_data;
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index b37435c274..8918c00a91 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -966,7 +966,7 @@ static inline void add_to_free_list(struct page *page, struct zone *zone,
 	struct free_area *area = &zone->free_area[order];
 
 	list_add(&page->lru, &area->free_list[migratetype]);
-	area->nr_free++;
+	area->nr_free[migratetype]++;
 }
 
 /* Used for pages not on another list */
@@ -976,7 +976,7 @@ static inline void add_to_free_list_tail(struct page *page, struct zone *zone,
 	struct free_area *area = &zone->free_area[order];
 
 	list_add_tail(&page->lru, &area->free_list[migratetype]);
-	area->nr_free++;
+	area->nr_free[migratetype]++;
 }
 
 /*
@@ -993,7 +993,7 @@ static inline void move_to_free_list(struct page *page, struct zone *zone,
 }
 
 static inline void del_page_from_free_list(struct page *page, struct zone *zone,
-					   unsigned int order)
+					   unsigned int order, int migratetype)
 {
 	/* clear reported state and update reported page count */
 	if (page_reported(page))
@@ -1002,7 +1002,7 @@ static inline void del_page_from_free_list(struct page *page, struct zone *zone,
 	list_del(&page->lru);
 	__ClearPageBuddy(page);
 	set_page_private(page, 0);
-	zone->free_area[order].nr_free--;
+	zone->free_area[order].nr_free[migratetype]--;
 }
 
 /*
@@ -1098,7 +1098,7 @@ static inline void __free_one_page(struct page *page,
 		if (page_is_guard(buddy))
 			clear_page_guard(zone, buddy, order, migratetype);
 		else
-			del_page_from_free_list(buddy, zone, order);
+			del_page_from_free_list(buddy, zone, order, migratetype);
 		combined_pfn = buddy_pfn & pfn;
 		page = page + (combined_pfn - pfn);
 		pfn = combined_pfn;
@@ -2456,7 +2456,7 @@ struct page *__rmqueue_smallest(struct zone *zone, unsigned int order,
 		page = get_page_from_free_area(area, migratetype);
 		if (!page)
 			continue;
-		del_page_from_free_list(page, zone, current_order);
+		del_page_from_free_list(page, zone, current_order, migratetype);
 		expand(zone, page, order, current_order, migratetype);
 		set_pcppage_migratetype(page, migratetype);
 		return page;
@@ -3525,7 +3525,7 @@ int __isolate_free_page(struct page *page, unsigned int order)
 
 	/* Remove page from free list */
 
-	del_page_from_free_list(page, zone, order);
+	del_page_from_free_list(page, zone, order, mt);
 
 	/*
 	 * Set the pageblock if the isolated page is at least half of a
@@ -6038,14 +6038,16 @@ void show_free_areas(unsigned int filter, nodemask_t *nodemask)
 			struct free_area *area = &zone->free_area[order];
 			int type;
 
-			nr[order] = area->nr_free;
-			total += nr[order] << order;
+			nr[order]	= 0;
+			types[order]	= 0;
 
-			types[order] = 0;
 			for (type = 0; type < MIGRATE_TYPES; type++) {
 				if (!free_area_empty(area, type))
 					types[order] |= 1 << type;
+				nr[order] += area->nr_free[type];
 			}
+
+			total += nr[order] << order;
 		}
 		spin_unlock_irqrestore(&zone->lock, flags);
 		for (order = 0; order < MAX_ORDER; order++) {
@@ -6623,7 +6625,7 @@ static void __meminit zone_init_free_lists(struct zone *zone)
 	unsigned int order, t;
 	for_each_migratetype_order(order, t) {
 		INIT_LIST_HEAD(&zone->free_area[order].free_list[t]);
-		zone->free_area[order].nr_free = 0;
+		zone->free_area[order].nr_free[t] = 0;
 	}
 }
 
@@ -9317,6 +9319,7 @@ void __offline_isolated_pages(unsigned long start_pfn, unsigned long end_pfn)
 	struct page *page;
 	struct zone *zone;
 	unsigned int order;
+	unsigned int migratetype;
 	unsigned long flags;
 
 	offline_mem_sections(pfn, end_pfn);
@@ -9346,7 +9349,8 @@ void __offline_isolated_pages(unsigned long start_pfn, unsigned long end_pfn)
 		BUG_ON(page_count(page));
 		BUG_ON(!PageBuddy(page));
 		order = buddy_order(page);
-		del_page_from_free_list(page, zone, order);
+		migratetype = get_pfnblock_migratetype(page, pfn);
+		del_page_from_free_list(page, zone, order, migratetype);
 		pfn += (1 << order);
 	}
 	spin_unlock_irqrestore(&zone->lock, flags);
@@ -9428,7 +9432,7 @@ bool take_page_off_buddy(struct page *page)
 			int migratetype = get_pfnblock_migratetype(page_head,
 								   pfn_head);
 
-			del_page_from_free_list(page_head, zone, page_order);
+			del_page_from_free_list(page_head, zone, page_order, migratetype);
 			break_down_buddy_pages(zone, page_head, page, 0,
 						page_order, migratetype);
 			if (!is_migrate_isolate(migratetype))
diff --git a/mm/page_reporting.c b/mm/page_reporting.c
index 382958eef8..4e45ae95db 100644
--- a/mm/page_reporting.c
+++ b/mm/page_reporting.c
@@ -145,7 +145,7 @@ page_reporting_cycle(struct page_reporting_dev_info *prdev, struct zone *zone,
 	 * The division here should be cheap since PAGE_REPORTING_CAPACITY
 	 * should always be a power of 2.
 	 */
-	budget = DIV_ROUND_UP(area->nr_free, PAGE_REPORTING_CAPACITY * 16);
+	budget = DIV_ROUND_UP(area->nr_free[mt], PAGE_REPORTING_CAPACITY * 16);
 
 	/* loop through free list adding unreported pages to sg list */
 	list_for_each_entry_safe(page, next, list, lru) {
diff --git a/mm/vmstat.c b/mm/vmstat.c
index 8ce2620344..eb46f99c72 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -1071,7 +1071,7 @@ static void fill_contig_page_info(struct zone *zone,
 		unsigned long blocks;
 
 		/* Count number of free blocks */
-		blocks = zone->free_area[order].nr_free;
+		blocks = free_area_nr_free(&zone->free_area[order]);
 		info->free_blocks_total += blocks;
 
 		/* Count free base pages */
@@ -1445,7 +1445,7 @@ static void frag_show_print(struct seq_file *m, pg_data_t *pgdat,
 
 	seq_printf(m, "Node %d, zone %8s ", pgdat->node_id, zone->name);
 	for (order = 0; order < MAX_ORDER; ++order)
-		seq_printf(m, "%6lu ", zone->free_area[order].nr_free);
+		seq_printf(m, "%6zu ", free_area_nr_free(&zone->free_area[order]));
 	seq_putc(m, '\n');
 }
 
@@ -1470,29 +1470,7 @@ static void pagetypeinfo_showfree_print(struct seq_file *m,
 					zone->name,
 					migratetype_names[mtype]);
 		for (order = 0; order < MAX_ORDER; ++order) {
-			unsigned long freecount = 0;
-			struct free_area *area;
-			struct list_head *curr;
-			bool overflow = false;
-
-			area = &(zone->free_area[order]);
-
-			list_for_each(curr, &area->free_list[mtype]) {
-				/*
-				 * Cap the free_list iteration because it might
-				 * be really large and we are under a spinlock
-				 * so a long time spent here could trigger a
-				 * hard lockup detector. Anyway this is a
-				 * debugging tool so knowing there is a handful
-				 * of pages of this order should be more than
-				 * sufficient.
-				 */
-				if (++freecount >= 100000) {
-					overflow = true;
-					break;
-				}
-			}
-			seq_printf(m, "%s%6lu ", overflow ? ">" : "", freecount);
+			seq_printf(m, "%6zu ", zone->free_area[order].nr_free[mtype]);
 			spin_unlock_irq(&zone->lock);
 			cond_resched();
 			spin_lock_irq(&zone->lock);
-- 
2.33.0

