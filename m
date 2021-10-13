Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 058C2C433FE
	for <linux-raid@archiver.kernel.org>; Wed, 13 Oct 2021 16:00:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E115F61163
	for <linux-raid@archiver.kernel.org>; Wed, 13 Oct 2021 16:00:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237700AbhJMQCw (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 13 Oct 2021 12:02:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237585AbhJMQCs (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 13 Oct 2021 12:02:48 -0400
Received: from mail-qt1-x82d.google.com (mail-qt1-x82d.google.com [IPv6:2607:f8b0:4864:20::82d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB1A0C061570;
        Wed, 13 Oct 2021 09:00:44 -0700 (PDT)
Received: by mail-qt1-x82d.google.com with SMTP id r17so2965645qtx.10;
        Wed, 13 Oct 2021 09:00:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ExiMDGbOiJCAEk+N5uuM+TKuKA0rA49Uu1AdlJ97UCo=;
        b=JdtUNo2uMuhB4xHYxxWXnoWBjLnKFx5ffqYUIWfHcOYu2yuZ8hKu7HEaIp6KCMIAP1
         z200x6fijVza031Vgc145jKL2KJ5QHqcJGkx8J7ZuRm9kraci1vMLHWolIypPNJcP6qI
         kMxwbvWJTgxXA9N67G/LFYC8bHbLymJot2bKKJNw1qM7f9RDBN8aBEvt7CQRI1jTKThO
         t8TDKd4taCKcbBbjPQC2cAxqpRY3cHPyl4TzsprIWL5+UtPJPZ3ELKy0yDvZ5QfSIZgp
         LRvqgNbkMjGuwWzw3TTbQmNcZ/zajOgvvlPkNHWMMP9wT8Icf51zb17iTUCbZdv1CoAI
         S51g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ExiMDGbOiJCAEk+N5uuM+TKuKA0rA49Uu1AdlJ97UCo=;
        b=j5tFWV1EpNyP1W2kGvW2zCZxsGCDRk7q/jQ8yDa0TgXi9LzjttSXVyA1OXIViZDLjq
         wPiFLJEYLKyPtgoeFnh8aTnHWQm2uzups7xLLQudym12ZJtvMSvLhHTHIxzH9sXaMOQI
         DHuxq9iRlFtYPa0NfdWUIQPU7aUq29ctAcxDK9WmYZ97O/pjvP0sIEqth/F/CStcqcE9
         9euOC0J2WZouPibpXdIBh4wna1XAafjfnNJmkbNFq9va7it4/+051MT/WFqutbweOCv1
         W528J4SJbvTHOqAm97mpSilCJPP56BJQfTlt2yxkBWvICKUMiqouhU+DcOcenBCSMBdV
         fvCQ==
X-Gm-Message-State: AOAM533NE9IIobEqPaV9s9LuNV+HD+2Cy/wwg8jkgTn//t6kOjKLhEmx
        J+xgiBfMYZOFfM76s0wJrMtfkfc9bvaE
X-Google-Smtp-Source: ABdhPJyr+vj0+AmLaT4apOjAmLNIXpzPBUePVsaTpMuwFMwEuFhb9yVoLOfGZjkU0FPoV9K7FP/lCA==
X-Received: by 2002:aed:2791:: with SMTP id a17mr145086qtd.34.1634140843570;
        Wed, 13 Oct 2021 09:00:43 -0700 (PDT)
Received: from moria.home.lan (c-73-219-103-14.hsd1.vt.comcast.net. [73.219.103.14])
        by smtp.gmail.com with ESMTPSA id w17sm20161qts.53.2021.10.13.09.00.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Oct 2021 09:00:42 -0700 (PDT)
From:   Kent Overstreet <kent.overstreet@gmail.com>
To:     linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org, linux-raid@vger.kernel.org,
        linux-block@vger.kernel.org, axboe@kernel.dk
Cc:     Kent Overstreet <kent.overstreet@gmail.com>,
        alexander.h.duyck@linux.intel.com
Subject: [PATCH 2/5] mm: Introduce struct page_free_list
Date:   Wed, 13 Oct 2021 12:00:31 -0400
Message-Id: <20211013160034.3472923-3-kent.overstreet@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211013160034.3472923-1-kent.overstreet@gmail.com>
References: <20211013160034.3472923-1-kent.overstreet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Small type system cleanup, enabling further cleanups and possibly
switching the freelists from linked lists to radix trees.

Signed-off-by: Kent Overstreet <kent.overstreet@gmail.com>
---
 include/linux/mmzone.h | 14 +++++++++-----
 kernel/crash_core.c    |  4 ++--
 mm/compaction.c        | 20 +++++++++++---------
 mm/page_alloc.c        | 30 +++++++++++++++---------------
 mm/page_reporting.c    | 20 ++++++++++----------
 mm/vmstat.c            |  2 +-
 6 files changed, 48 insertions(+), 42 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 089587b918..1fe820ead2 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -94,21 +94,25 @@ extern int page_group_by_mobility_disabled;
 #define get_pageblock_migratetype(page)					\
 	get_pfnblock_flags_mask(page, page_to_pfn(page), MIGRATETYPE_MASK)
 
+struct page_free_list {
+	struct list_head	list;
+	size_t			nr;
+};
+
 struct free_area {
-	struct list_head	free_list[MIGRATE_TYPES];
-	unsigned long		nr_free[MIGRATE_TYPES];
+	struct page_free_list	free[MIGRATE_TYPES];
 };
 
 static inline struct page *get_page_from_free_area(struct free_area *area,
 					    int migratetype)
 {
-	return list_first_entry_or_null(&area->free_list[migratetype],
+	return list_first_entry_or_null(&area->free[migratetype].list,
 					struct page, lru);
 }
 
 static inline bool free_area_empty(struct free_area *area, int migratetype)
 {
-	return area->nr_free[migratetype] == 0;
+	return area->free[migratetype].nr == 0;
 }
 
 static inline size_t free_area_nr_free(struct free_area *area)
@@ -117,7 +121,7 @@ static inline size_t free_area_nr_free(struct free_area *area)
 	size_t nr_free = 0;
 
 	for (migratetype = 0; migratetype < MIGRATE_TYPES; migratetype++)
-		nr_free += area->nr_free[migratetype];
+		nr_free += area->free[migratetype].nr;
 	return nr_free;
 }
 
diff --git a/kernel/crash_core.c b/kernel/crash_core.c
index eb53f5ec62..f9cc4c3cd1 100644
--- a/kernel/crash_core.c
+++ b/kernel/crash_core.c
@@ -447,14 +447,14 @@ static int __init crash_save_vmcoreinfo_init(void)
 	VMCOREINFO_OFFSET(zone, free_area);
 	VMCOREINFO_OFFSET(zone, vm_stat);
 	VMCOREINFO_OFFSET(zone, spanned_pages);
-	VMCOREINFO_OFFSET(free_area, free_list);
+	VMCOREINFO_OFFSET(free_area, free);
 	VMCOREINFO_OFFSET(list_head, next);
 	VMCOREINFO_OFFSET(list_head, prev);
 	VMCOREINFO_OFFSET(vmap_area, va_start);
 	VMCOREINFO_OFFSET(vmap_area, list);
 	VMCOREINFO_LENGTH(zone.free_area, MAX_ORDER);
 	log_buf_vmcoreinfo_setup();
-	VMCOREINFO_LENGTH(free_area.free_list, MIGRATE_TYPES);
+	VMCOREINFO_LENGTH(free_area.free, MIGRATE_TYPES);
 	VMCOREINFO_NUMBER(NR_FREE_PAGES);
 	VMCOREINFO_NUMBER(PG_lru);
 	VMCOREINFO_NUMBER(PG_private);
diff --git a/mm/compaction.c b/mm/compaction.c
index bfc93da1c2..7a15f350e4 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -1414,19 +1414,21 @@ fast_isolate_freepages(struct compact_control *cc)
 	for (order = cc->search_order;
 	     !page && order >= 0;
 	     order = next_search_order(cc, order)) {
-		struct free_area *area = &cc->zone->free_area[order];
-		struct list_head *freelist;
+		struct page_free_list *free =
+			&cc->zone->free_area[order].free[MIGRATE_MOVABLE];
 		struct page *freepage;
 		unsigned long flags;
 		unsigned int order_scanned = 0;
 		unsigned long high_pfn = 0;
 
-		if (!area->nr_free)
+		spin_lock_irqsave(&cc->zone->lock, flags);
+
+		if (!free->nr) {
+			spin_unlock_irqrestore(&cc->zone->lock, flags);
 			continue;
+		}
 
-		spin_lock_irqsave(&cc->zone->lock, flags);
-		freelist = &area->free_list[MIGRATE_MOVABLE];
-		list_for_each_entry_reverse(freepage, freelist, lru) {
+		list_for_each_entry_reverse(freepage, &free->list, lru) {
 			unsigned long pfn;
 
 			order_scanned++;
@@ -1464,7 +1466,7 @@ fast_isolate_freepages(struct compact_control *cc)
 		}
 
 		/* Reorder to so a future search skips recent pages */
-		move_freelist_head(freelist, freepage);
+		move_freelist_head(&free->list, freepage);
 
 		/* Isolate the page if available */
 		if (page) {
@@ -1786,11 +1788,11 @@ static unsigned long fast_find_migrateblock(struct compact_control *cc)
 		unsigned long flags;
 		struct page *freepage;
 
-		if (!area->nr_free)
+		if (!free_area_nr_free(area))
 			continue;
 
 		spin_lock_irqsave(&cc->zone->lock, flags);
-		freelist = &area->free_list[MIGRATE_MOVABLE];
+		freelist = &area->free[MIGRATE_MOVABLE].list;
 		list_for_each_entry(freepage, freelist, lru) {
 			unsigned long free_pfn;
 
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 8918c00a91..70e4bcd2f3 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -963,20 +963,20 @@ compaction_capture(struct capture_control *capc, struct page *page,
 static inline void add_to_free_list(struct page *page, struct zone *zone,
 				    unsigned int order, int migratetype)
 {
-	struct free_area *area = &zone->free_area[order];
+	struct page_free_list *list = &zone->free_area[order].free[migratetype];
 
-	list_add(&page->lru, &area->free_list[migratetype]);
-	area->nr_free[migratetype]++;
+	list_add(&page->lru, &list->list);
+	list->nr++;
 }
 
 /* Used for pages not on another list */
 static inline void add_to_free_list_tail(struct page *page, struct zone *zone,
 					 unsigned int order, int migratetype)
 {
-	struct free_area *area = &zone->free_area[order];
+	struct page_free_list *list = &zone->free_area[order].free[migratetype];
 
-	list_add_tail(&page->lru, &area->free_list[migratetype]);
-	area->nr_free[migratetype]++;
+	list_add_tail(&page->lru, &list->list);
+	list->nr++;
 }
 
 /*
@@ -987,9 +987,9 @@ static inline void add_to_free_list_tail(struct page *page, struct zone *zone,
 static inline void move_to_free_list(struct page *page, struct zone *zone,
 				     unsigned int order, int migratetype)
 {
-	struct free_area *area = &zone->free_area[order];
+	struct page_free_list *list = &zone->free_area[order].free[migratetype];
 
-	list_move_tail(&page->lru, &area->free_list[migratetype]);
+	list_move_tail(&page->lru, &list->list);
 }
 
 static inline void del_page_from_free_list(struct page *page, struct zone *zone,
@@ -1002,7 +1002,7 @@ static inline void del_page_from_free_list(struct page *page, struct zone *zone,
 	list_del(&page->lru);
 	__ClearPageBuddy(page);
 	set_page_private(page, 0);
-	zone->free_area[order].nr_free[migratetype]--;
+	zone->free_area[order].free[migratetype].nr--;
 }
 
 /*
@@ -2734,7 +2734,7 @@ int find_suitable_fallback(struct free_area *area, unsigned int order,
 	int i;
 	int fallback_mt;
 
-	if (area->nr_free == 0)
+	if (free_area_nr_free(area) == 0)
 		return -1;
 
 	*can_steal = false;
@@ -3290,7 +3290,7 @@ void mark_free_pages(struct zone *zone)
 
 	for_each_migratetype_order(order, t) {
 		list_for_each_entry(page,
-				&zone->free_area[order].free_list[t], lru) {
+				&zone->free_area[order].free[t].list, lru) {
 			unsigned long i;
 
 			pfn = page_to_pfn(page);
@@ -3886,7 +3886,7 @@ bool __zone_watermark_ok(struct zone *z, unsigned int order, unsigned long mark,
 		struct free_area *area = &z->free_area[o];
 		int mt;
 
-		if (!area->nr_free)
+		if (!free_area_nr_free(area))
 			continue;
 
 		for (mt = 0; mt < MIGRATE_PCPTYPES; mt++) {
@@ -6044,7 +6044,7 @@ void show_free_areas(unsigned int filter, nodemask_t *nodemask)
 			for (type = 0; type < MIGRATE_TYPES; type++) {
 				if (!free_area_empty(area, type))
 					types[order] |= 1 << type;
-				nr[order] += area->nr_free[type];
+				nr[order] += area->free[type].nr;
 			}
 
 			total += nr[order] << order;
@@ -6624,8 +6624,8 @@ static void __meminit zone_init_free_lists(struct zone *zone)
 {
 	unsigned int order, t;
 	for_each_migratetype_order(order, t) {
-		INIT_LIST_HEAD(&zone->free_area[order].free_list[t]);
-		zone->free_area[order].nr_free[t] = 0;
+		INIT_LIST_HEAD(&zone->free_area[order].free[t].list);
+		zone->free_area[order].free[t].nr = 0;
 	}
 }
 
diff --git a/mm/page_reporting.c b/mm/page_reporting.c
index 4e45ae95db..c4362b4b0c 100644
--- a/mm/page_reporting.c
+++ b/mm/page_reporting.c
@@ -115,8 +115,7 @@ page_reporting_cycle(struct page_reporting_dev_info *prdev, struct zone *zone,
 		     unsigned int order, unsigned int mt,
 		     struct scatterlist *sgl, unsigned int *offset)
 {
-	struct free_area *area = &zone->free_area[order];
-	struct list_head *list = &area->free_list[mt];
+	struct page_free_list *list = &zone->free_area[order].free[mt];
 	unsigned int page_len = PAGE_SIZE << order;
 	struct page *page, *next;
 	long budget;
@@ -126,7 +125,7 @@ page_reporting_cycle(struct page_reporting_dev_info *prdev, struct zone *zone,
 	 * Perform early check, if free area is empty there is
 	 * nothing to process so we can skip this free_list.
 	 */
-	if (list_empty(list))
+	if (list_empty(&list->list))
 		return err;
 
 	spin_lock_irq(&zone->lock);
@@ -145,10 +144,10 @@ page_reporting_cycle(struct page_reporting_dev_info *prdev, struct zone *zone,
 	 * The division here should be cheap since PAGE_REPORTING_CAPACITY
 	 * should always be a power of 2.
 	 */
-	budget = DIV_ROUND_UP(area->nr_free[mt], PAGE_REPORTING_CAPACITY * 16);
+	budget = DIV_ROUND_UP(list->nr, PAGE_REPORTING_CAPACITY * 16);
 
 	/* loop through free list adding unreported pages to sg list */
-	list_for_each_entry_safe(page, next, list, lru) {
+	list_for_each_entry_safe(page, next, &list->list, lru) {
 		/* We are going to skip over the reported pages. */
 		if (PageReported(page))
 			continue;
@@ -183,8 +182,8 @@ page_reporting_cycle(struct page_reporting_dev_info *prdev, struct zone *zone,
 		 * the new head of the free list before we release the
 		 * zone lock.
 		 */
-		if (!list_is_first(&page->lru, list))
-			list_rotate_to_front(&page->lru, list);
+		if (!list_is_first(&page->lru, &list->list))
+			list_rotate_to_front(&page->lru, &list->list);
 
 		/* release lock before waiting on report processing */
 		spin_unlock_irq(&zone->lock);
@@ -208,7 +207,7 @@ page_reporting_cycle(struct page_reporting_dev_info *prdev, struct zone *zone,
 		 * Reset next to first entry, the old next isn't valid
 		 * since we dropped the lock to report the pages
 		 */
-		next = list_first_entry(list, struct page, lru);
+		next = list_first_entry(&list->list, struct page, lru);
 
 		/* exit on error */
 		if (err)
@@ -216,8 +215,9 @@ page_reporting_cycle(struct page_reporting_dev_info *prdev, struct zone *zone,
 	}
 
 	/* Rotate any leftover pages to the head of the freelist */
-	if (!list_entry_is_head(next, list, lru) && !list_is_first(&next->lru, list))
-		list_rotate_to_front(&next->lru, list);
+	if (!list_entry_is_head(next, &list->list, lru) &&
+	    !list_is_first(&next->lru, &list->list))
+		list_rotate_to_front(&next->lru, &list->list);
 
 	spin_unlock_irq(&zone->lock);
 
diff --git a/mm/vmstat.c b/mm/vmstat.c
index eb46f99c72..1620dc120f 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -1470,7 +1470,7 @@ static void pagetypeinfo_showfree_print(struct seq_file *m,
 					zone->name,
 					migratetype_names[mtype]);
 		for (order = 0; order < MAX_ORDER; ++order) {
-			seq_printf(m, "%6zu ", zone->free_area[order].nr_free[mtype]);
+			seq_printf(m, "%6zu ", zone->free_area[order].free[mtype].nr);
 			spin_unlock_irq(&zone->lock);
 			cond_resched();
 			spin_lock_irq(&zone->lock);
-- 
2.33.0

