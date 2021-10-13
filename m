Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F00EDC433EF
	for <linux-raid@archiver.kernel.org>; Wed, 13 Oct 2021 16:01:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D9B6461163
	for <linux-raid@archiver.kernel.org>; Wed, 13 Oct 2021 16:01:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237785AbhJMQDD (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 13 Oct 2021 12:03:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235922AbhJMQC5 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 13 Oct 2021 12:02:57 -0400
Received: from mail-qk1-x735.google.com (mail-qk1-x735.google.com [IPv6:2607:f8b0:4864:20::735])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6C42C061749;
        Wed, 13 Oct 2021 09:00:53 -0700 (PDT)
Received: by mail-qk1-x735.google.com with SMTP id t63so2686795qkf.1;
        Wed, 13 Oct 2021 09:00:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4aTU3EupNAF3fXFzgSlutYMVrbUDuqlP4zujHMtjctE=;
        b=h/tWd++epVlpSaGdmTnilIlcyoE4elRhjQ5cQBfgBNNAybjIUgMF7G+BxL4Gz2wyxE
         0QHkDhRjnB65xE1/FxwYiKeBBUyNpqjrhXNEeuAwQK2YgOAWwD3GWnJblUt3hHwlAm0A
         q/xJLwP2grqJWENkukwpicdLRAGXk7bor0Pnf2JQWAoRefnvQfbBtxXm+L7qz+VeaeTD
         sm8GfA57hO9VmllHYZ9HS59wzeMYZWIGl2pK6SKPAFWFqgFhJuRXtz+ysgQSpv/uCGni
         48pLrcUZKicCLOdT/4Tj8qMNu1U/g5KGJHUb4946n0GOQXrrTaNoBbvbKxTe05aqbQKq
         1Abg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4aTU3EupNAF3fXFzgSlutYMVrbUDuqlP4zujHMtjctE=;
        b=tdd0fghaM89iNL/HGMwdebYitWcS6kBrHwvrMo6Jk5IC76Qs8a04Nf6hsmPIvBfCF6
         Cc4F9weHD0sD2p5SmbAdUREeUoEvH29QS81jQciTTZEywJ7+1rVsxHUPEbyAGXx857YU
         taJwxN1xTopSP8Ao+cP12BLS5DdWsQH+T5GeqQspJhxvsn86Ljc+RiYjLBeZCFQEArEU
         jYLMBZ5Sjm7XZAxnN7rvTkxTi3//NSIY7WK10wFtIzNLhaBbtUcT7g+ezu/li2iE6ciX
         5FbUCBL01gDsaGYnHl4UdtBpeiKe5yBBJ16mIcw51TxQYw/Ft0iw5ItYDHPElrfkh8w1
         CkTA==
X-Gm-Message-State: AOAM5317rGmYDkYkaZbiGcDwosdBAsJxGcsZ9dnYNpX8G2nXp+Da40YO
        le3svqCT51tI8uoYrkJmytoQj2eqZxT3
X-Google-Smtp-Source: ABdhPJz99I5rmowhZayl5hxWUYnKdfzZmblaJaKJn+p9JaTKvo8tZHclbJG61WM80PRdLJTYjCPPOg==
X-Received: by 2002:a37:8883:: with SMTP id k125mr100968qkd.144.1634140844944;
        Wed, 13 Oct 2021 09:00:44 -0700 (PDT)
Received: from moria.home.lan (c-73-219-103-14.hsd1.vt.comcast.net. [73.219.103.14])
        by smtp.gmail.com with ESMTPSA id w17sm20161qts.53.2021.10.13.09.00.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Oct 2021 09:00:44 -0700 (PDT)
From:   Kent Overstreet <kent.overstreet@gmail.com>
To:     linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org, linux-raid@vger.kernel.org,
        linux-block@vger.kernel.org, axboe@kernel.dk
Cc:     Kent Overstreet <kent.overstreet@gmail.com>,
        alexander.h.duyck@linux.intel.com
Subject: [PATCH 3/5] mm/page_reporting: Improve control flow
Date:   Wed, 13 Oct 2021 12:00:32 -0400
Message-Id: <20211013160034.3472923-4-kent.overstreet@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211013160034.3472923-1-kent.overstreet@gmail.com>
References: <20211013160034.3472923-1-kent.overstreet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

This splits out page_reporting_get_pages() from page_reporting_cycle(),
which is a considerable simplification and lets us delete some
duplicated code. We're cleaning up code that touches page freelists as
prep work for possibly converting them to radix trees, but this is a
worthy cleanup on its own.

Signed-off-by: Kent Overstreet <kent.overstreet@gmail.com>
---
 mm/page_reporting.c | 154 ++++++++++++++++----------------------------
 1 file changed, 54 insertions(+), 100 deletions(-)

diff --git a/mm/page_reporting.c b/mm/page_reporting.c
index c4362b4b0c..ab2be13d8e 100644
--- a/mm/page_reporting.c
+++ b/mm/page_reporting.c
@@ -71,10 +71,8 @@ void __page_reporting_notify(void)
 
 static void
 page_reporting_drain(struct page_reporting_dev_info *prdev,
-		     struct scatterlist *sgl, unsigned int nents, bool reported)
+		     struct scatterlist *sg, bool reported)
 {
-	struct scatterlist *sg = sgl;
-
 	/*
 	 * Drain the now reported pages back into their respective
 	 * free lists/areas. We assume at least one page is populated.
@@ -100,9 +98,45 @@ page_reporting_drain(struct page_reporting_dev_info *prdev,
 		if (PageBuddy(page) && buddy_order(page) == order)
 			__SetPageReported(page);
 	} while ((sg = sg_next(sg)));
+}
+
+static int
+page_reporting_get_pages(struct page_reporting_dev_info *prdev, struct zone *zone,
+			 unsigned int order, unsigned int mt,
+			 struct scatterlist *sgl)
+{
+	struct page_free_list *list = &zone->free_area[order].free[mt];
+	unsigned int page_len = PAGE_SIZE << order;
+	struct page *page, *next;
+	unsigned nr_got = 0;
+
+	spin_lock_irq(&zone->lock);
+
+	/* loop through free list adding unreported pages to sg list */
+	list_for_each_entry_safe(page, next, &list->list, lru) {
+		/* We are going to skip over the reported pages. */
+		if (PageReported(page))
+			continue;
+
+		/* Attempt to pull page from list and place in scatterlist */
+		if (!__isolate_free_page(page, order)) {
+			next = page;
+			break;
+		}
+
+		sg_set_page(&sgl[nr_got++], page, page_len, 0);
+		if (nr_got == PAGE_REPORTING_CAPACITY)
+			break;
+	}
+
+	/* Rotate any leftover pages to the head of the freelist */
+	if (!list_entry_is_head(next, &list->list, lru) &&
+	    !list_is_first(&next->lru, &list->list))
+		list_rotate_to_front(&next->lru, &list->list);
+
+	spin_unlock_irq(&zone->lock);
 
-	/* reinitialize scatterlist now that it is empty */
-	sg_init_table(sgl, nents);
+	return nr_got;
 }
 
 /*
@@ -113,23 +147,13 @@ page_reporting_drain(struct page_reporting_dev_info *prdev,
 static int
 page_reporting_cycle(struct page_reporting_dev_info *prdev, struct zone *zone,
 		     unsigned int order, unsigned int mt,
-		     struct scatterlist *sgl, unsigned int *offset)
+		     struct scatterlist *sgl)
 {
 	struct page_free_list *list = &zone->free_area[order].free[mt];
-	unsigned int page_len = PAGE_SIZE << order;
-	struct page *page, *next;
+	unsigned nr_pages;
 	long budget;
 	int err = 0;
 
-	/*
-	 * Perform early check, if free area is empty there is
-	 * nothing to process so we can skip this free_list.
-	 */
-	if (list_empty(&list->list))
-		return err;
-
-	spin_lock_irq(&zone->lock);
-
 	/*
 	 * Limit how many calls we will be making to the page reporting
 	 * device for this list. By doing this we avoid processing any
@@ -146,80 +170,25 @@ page_reporting_cycle(struct page_reporting_dev_info *prdev, struct zone *zone,
 	 */
 	budget = DIV_ROUND_UP(list->nr, PAGE_REPORTING_CAPACITY * 16);
 
-	/* loop through free list adding unreported pages to sg list */
-	list_for_each_entry_safe(page, next, &list->list, lru) {
-		/* We are going to skip over the reported pages. */
-		if (PageReported(page))
-			continue;
+	while (budget > 0 && !err) {
+		sg_init_table(sgl, PAGE_REPORTING_CAPACITY);
 
-		/*
-		 * If we fully consumed our budget then update our
-		 * state to indicate that we are requesting additional
-		 * processing and exit this list.
-		 */
-		if (budget < 0) {
-			atomic_set(&prdev->state, PAGE_REPORTING_REQUESTED);
-			next = page;
+		nr_pages = page_reporting_get_pages(prdev, zone, order, mt, sgl);
+		if (!nr_pages)
 			break;
-		}
-
-		/* Attempt to pull page from list and place in scatterlist */
-		if (*offset) {
-			if (!__isolate_free_page(page, order)) {
-				next = page;
-				break;
-			}
-
-			/* Add page to scatter list */
-			--(*offset);
-			sg_set_page(&sgl[*offset], page, page_len, 0);
-
-			continue;
-		}
-
-		/*
-		 * Make the first non-reported page in the free list
-		 * the new head of the free list before we release the
-		 * zone lock.
-		 */
-		if (!list_is_first(&page->lru, &list->list))
-			list_rotate_to_front(&page->lru, &list->list);
-
-		/* release lock before waiting on report processing */
-		spin_unlock_irq(&zone->lock);
-
-		/* begin processing pages in local list */
-		err = prdev->report(prdev, sgl, PAGE_REPORTING_CAPACITY);
 
-		/* reset offset since the full list was reported */
-		*offset = PAGE_REPORTING_CAPACITY;
+		sg_mark_end(sgl + nr_pages);
 
-		/* update budget to reflect call to report function */
-		budget--;
+		budget -= nr_pages;
+		err = prdev->report(prdev, sgl, nr_pages);
 
-		/* reacquire zone lock and resume processing */
 		spin_lock_irq(&zone->lock);
-
-		/* flush reported pages from the sg list */
-		page_reporting_drain(prdev, sgl, PAGE_REPORTING_CAPACITY, !err);
-
-		/*
-		 * Reset next to first entry, the old next isn't valid
-		 * since we dropped the lock to report the pages
-		 */
-		next = list_first_entry(&list->list, struct page, lru);
-
-		/* exit on error */
-		if (err)
-			break;
+		page_reporting_drain(prdev, sgl, !err);
+		spin_unlock_irq(&zone->lock);
 	}
 
-	/* Rotate any leftover pages to the head of the freelist */
-	if (!list_entry_is_head(next, &list->list, lru) &&
-	    !list_is_first(&next->lru, &list->list))
-		list_rotate_to_front(&next->lru, &list->list);
-
-	spin_unlock_irq(&zone->lock);
+	if (budget <= 0 && list->nr)
+		atomic_set(&prdev->state, PAGE_REPORTING_REQUESTED);
 
 	return err;
 }
@@ -228,7 +197,7 @@ static int
 page_reporting_process_zone(struct page_reporting_dev_info *prdev,
 			    struct scatterlist *sgl, struct zone *zone)
 {
-	unsigned int order, mt, leftover, offset = PAGE_REPORTING_CAPACITY;
+	unsigned int order, mt;
 	unsigned long watermark;
 	int err = 0;
 
@@ -250,25 +219,12 @@ page_reporting_process_zone(struct page_reporting_dev_info *prdev,
 			if (is_migrate_isolate(mt))
 				continue;
 
-			err = page_reporting_cycle(prdev, zone, order, mt,
-						   sgl, &offset);
+			err = page_reporting_cycle(prdev, zone, order, mt, sgl);
 			if (err)
 				return err;
 		}
 	}
 
-	/* report the leftover pages before going idle */
-	leftover = PAGE_REPORTING_CAPACITY - offset;
-	if (leftover) {
-		sgl = &sgl[offset];
-		err = prdev->report(prdev, sgl, leftover);
-
-		/* flush any remaining pages out from the last report */
-		spin_lock_irq(&zone->lock);
-		page_reporting_drain(prdev, sgl, leftover, !err);
-		spin_unlock_irq(&zone->lock);
-	}
-
 	return err;
 }
 
@@ -294,8 +250,6 @@ static void page_reporting_process(struct work_struct *work)
 	if (!sgl)
 		goto err_out;
 
-	sg_init_table(sgl, PAGE_REPORTING_CAPACITY);
-
 	for_each_zone(zone) {
 		err = page_reporting_process_zone(prdev, sgl, zone);
 		if (err)
-- 
2.33.0

