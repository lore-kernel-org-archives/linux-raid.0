Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14918C43217
	for <linux-raid@archiver.kernel.org>; Wed, 13 Oct 2021 16:01:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EFAD861168
	for <linux-raid@archiver.kernel.org>; Wed, 13 Oct 2021 16:01:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237830AbhJMQDG (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 13 Oct 2021 12:03:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237837AbhJMQDA (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 13 Oct 2021 12:03:00 -0400
Received: from mail-qt1-x82d.google.com (mail-qt1-x82d.google.com [IPv6:2607:f8b0:4864:20::82d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBBC8C061766;
        Wed, 13 Oct 2021 09:00:56 -0700 (PDT)
Received: by mail-qt1-x82d.google.com with SMTP id r17so2966381qtx.10;
        Wed, 13 Oct 2021 09:00:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JqXrOW1sz81l7piXeJ6TmVlYLqW03X51G3JR7Qr/jYw=;
        b=mpN2Ljf6OWSB7Vva54RoUDfZ6Q3KNqIBKGRBHhpr6j0955npGcPr5zboDSUBt8+OMH
         EbZ15JvJ8T9M34AHEeXip3qHWrrwS+RDrwcbLh6ae9OehrnQuln0mj6XWCG8yRJggHON
         0pj2mXcE83TZsXJ+XFyx2B5Ab/O3ZD3l+KemPRGhyWYRAb4xLaMriSsH93pgR9KJuZE9
         yMiHo+XQJe1ULyeEfm3PFiC1JJH0+eqWGovjNWEmDK0d4rHzyZsOvvtoPEw+Bl+fEnGj
         T70aXIcDaPrG2hp+p06tgaDc78NMCEQ4yfI9X+tHBnhAr+cT+KfhdmpwvJXgtLkumthE
         OU0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JqXrOW1sz81l7piXeJ6TmVlYLqW03X51G3JR7Qr/jYw=;
        b=3NMlPSOYk7nv8PmoMxHVQaBDIywu5nMbJYhjx875NMlsNIixHWtzSKxsTf3il3qgEu
         CHq2ykdYX19bWCkmFXMTGwDl8ZSgpDMCil4HT/C1jv+UlKGVkmPszV91Cb8Kor+zpmPJ
         GiQZjz86dirbHJ1NKzsG0vHCs6i6HFgNAYXMIgVSahv2S5udfmUk7mbT12zTi1uDBhuj
         hgzgxa+WrbRyF19m7P2y1Lznj5uIIhSTB0r65FUkBzWWT42HdKls7pPgsqo4SC3DG5Jq
         NpG7QMsTVgAD7tIl6u80On1ph2b9kIG3SjJwAqwys7JLDdAKvlgntQvd2Rvm+k++4pU4
         ccHA==
X-Gm-Message-State: AOAM531ew/WfJlLgUTLdq5XB3I6EvVdrgMf2siuzq2givs237NIKSKLU
        1GSqhX6air5i8Z7erx30h32I2xMtVSzW
X-Google-Smtp-Source: ABdhPJx1ckUYAdslQAAfyG6CdVNk5O/7d27iKRx/bXp+Qol0mRi3VXuk+NUm3TZhT+H2RMTyLjJvOw==
X-Received: by 2002:a05:622a:186:: with SMTP id s6mr58015qtw.323.1634140855563;
        Wed, 13 Oct 2021 09:00:55 -0700 (PDT)
Received: from moria.home.lan (c-73-219-103-14.hsd1.vt.comcast.net. [73.219.103.14])
        by smtp.gmail.com with ESMTPSA id w17sm20161qts.53.2021.10.13.09.00.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Oct 2021 09:00:54 -0700 (PDT)
From:   Kent Overstreet <kent.overstreet@gmail.com>
To:     linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org, linux-raid@vger.kernel.org,
        linux-block@vger.kernel.org, axboe@kernel.dk
Cc:     Kent Overstreet <kent.overstreet@gmail.com>,
        alexander.h.duyck@linux.intel.com
Subject: [PATCH 5/5] brd: Kill usage of page->index
Date:   Wed, 13 Oct 2021 12:00:34 -0400
Message-Id: <20211013160034.3472923-6-kent.overstreet@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211013160034.3472923-1-kent.overstreet@gmail.com>
References: <20211013160034.3472923-1-kent.overstreet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

As part of the struct page cleanups underway, we want to remove as much
usage of page->mapping and page->index as possible, as frequently they
are known from context.

In the brd code, we're never actually reading from page->index except in
assertions, so references to it can be safely deleted.

Signed-off-by: Kent Overstreet <kent.overstreet@gmail.com>
---
 drivers/block/brd.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/block/brd.c b/drivers/block/brd.c
index 58ec167aa0..0a55aed832 100644
--- a/drivers/block/brd.c
+++ b/drivers/block/brd.c
@@ -72,8 +72,6 @@ static struct page *brd_lookup_page(struct brd_device *brd, sector_t sector)
 	page = radix_tree_lookup(&brd->brd_pages, idx);
 	rcu_read_unlock();
 
-	BUG_ON(page && page->index != idx);
-
 	return page;
 }
 
@@ -108,12 +106,10 @@ static struct page *brd_insert_page(struct brd_device *brd, sector_t sector)
 
 	spin_lock(&brd->brd_lock);
 	idx = sector >> PAGE_SECTORS_SHIFT;
-	page->index = idx;
 	if (radix_tree_insert(&brd->brd_pages, idx, page)) {
 		__free_page(page);
 		page = radix_tree_lookup(&brd->brd_pages, idx);
 		BUG_ON(!page);
-		BUG_ON(page->index != idx);
 	} else {
 		brd->brd_nr_pages++;
 	}
-- 
2.33.0

