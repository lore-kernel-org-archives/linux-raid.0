Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97516C433FE
	for <linux-raid@archiver.kernel.org>; Wed, 13 Oct 2021 16:01:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7AB7F61168
	for <linux-raid@archiver.kernel.org>; Wed, 13 Oct 2021 16:01:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237769AbhJMQDJ (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 13 Oct 2021 12:03:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237828AbhJMQC7 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 13 Oct 2021 12:02:59 -0400
Received: from mail-qt1-x82b.google.com (mail-qt1-x82b.google.com [IPv6:2607:f8b0:4864:20::82b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72D57C061765;
        Wed, 13 Oct 2021 09:00:55 -0700 (PDT)
Received: by mail-qt1-x82b.google.com with SMTP id i1so2985297qtr.6;
        Wed, 13 Oct 2021 09:00:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SaQNQGKlwsbhCSQSQvDPP/vFHDfDgc8R8QPJSwyWtiI=;
        b=c5BXD9X9PnmMXiwzqVFutWdb7jiQuirFJd4C0vWTBWbTVxyc63GnnIzGpKuf/JeFL9
         V+fAkXXPlbx+doXp3IvbSIKf325ChrHvJDsyJx/PWVKTix17Xgs0alHOuzwPM/COq99R
         IjTyba3Rjk5c0F1LgJmNc5R5IrNrbtfhouKhDjhlXj5ot66pYD9zoiUx/z4tUsUc2UCn
         Ou7fR5ybi/sD7WZQnTfZtDMiwUqqu0lhNHssvEgL9ym36ZsMTrOjdxWUIQj/e9WUEINe
         4oqLdxVg5dZ5sgEcPX9NDcO/GIGQkZJ2q8nGllNFzKLpbFTGN0cnIvLiINaF8HeHpDbl
         ojLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SaQNQGKlwsbhCSQSQvDPP/vFHDfDgc8R8QPJSwyWtiI=;
        b=rIE8e5ZavKMAalOQIC8RSskUduN6jrxAxfVkmbygIvSBQnMxeibf6bYuX6aFwVN4WF
         mL3DXZSifN6YHS+U3pIIR9Zbluuwh6/6g61HmkQUTq3GdwYm1tYvvk6F22Shs/vhy2qe
         MmjBuD1npja4KxFdDNc9BM+8lWy9fr/3ISJkeUN+/T4fCnThUAvDe+3h04+xgir6Nod/
         Qd/kL/HhXuBE/avYQhLxK5OV3DDG8avqG4R+yzUCYdQlQvVf+aeDwTnw0N0Rf40aofRl
         bJ2qDI28t7szKjuIWrQlSsNVzQxTwav7aOi4UkWjuYlcGqr0CT/7Mhk/RqSWfAM0m5rQ
         zgkQ==
X-Gm-Message-State: AOAM533WgNOftsH36R7Xvi/MFBvGldno39pAMtk7E3FDA7DczpS/c2JG
        YKcle7TJEXr6Ja4y071tEuWFkVvPPqIr
X-Google-Smtp-Source: ABdhPJwzZujhU4CzidE3yM7yWt8jzop5KisJSJGDD7J5YyQGAYeYXcAkMpvy5WgnIozmV87HMegSKA==
X-Received: by 2002:a05:622a:4d2:: with SMTP id q18mr145098qtx.84.1634140853713;
        Wed, 13 Oct 2021 09:00:53 -0700 (PDT)
Received: from moria.home.lan (c-73-219-103-14.hsd1.vt.comcast.net. [73.219.103.14])
        by smtp.gmail.com with ESMTPSA id w17sm20161qts.53.2021.10.13.09.00.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Oct 2021 09:00:52 -0700 (PDT)
From:   Kent Overstreet <kent.overstreet@gmail.com>
To:     linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org, linux-raid@vger.kernel.org,
        linux-block@vger.kernel.org, axboe@kernel.dk
Cc:     Kent Overstreet <kent.overstreet@gmail.com>,
        alexander.h.duyck@linux.intel.com
Subject: [PATCH 4/5] md: Kill usage of page->index
Date:   Wed, 13 Oct 2021 12:00:33 -0400
Message-Id: <20211013160034.3472923-5-kent.overstreet@gmail.com>
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
are known from context - as they are here in the md bitmap code.

Signed-off-by: Kent Overstreet <kent.overstreet@gmail.com>
---
 drivers/md/md-bitmap.c | 44 ++++++++++++++++++++----------------------
 1 file changed, 21 insertions(+), 23 deletions(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index e29c6298ef..dcdb4597c5 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -165,10 +165,8 @@ static int read_sb_page(struct mddev *mddev, loff_t offset,
 
 		if (sync_page_io(rdev, target,
 				 roundup(size, bdev_logical_block_size(rdev->bdev)),
-				 page, REQ_OP_READ, 0, true)) {
-			page->index = index;
+				 page, REQ_OP_READ, 0, true))
 			return 0;
-		}
 	}
 	return -EIO;
 }
@@ -209,7 +207,8 @@ static struct md_rdev *next_active_rdev(struct md_rdev *rdev, struct mddev *mdde
 	return NULL;
 }
 
-static int write_sb_page(struct bitmap *bitmap, struct page *page, int wait)
+static int write_sb_page(struct bitmap *bitmap, struct page *page,
+			 unsigned long index, int wait)
 {
 	struct md_rdev *rdev;
 	struct block_device *bdev;
@@ -224,7 +223,7 @@ static int write_sb_page(struct bitmap *bitmap, struct page *page, int wait)
 
 		bdev = (rdev->meta_bdev) ? rdev->meta_bdev : rdev->bdev;
 
-		if (page->index == store->file_pages-1) {
+		if (index == store->file_pages-1) {
 			int last_page_size = store->bytes & (PAGE_SIZE-1);
 			if (last_page_size == 0)
 				last_page_size = PAGE_SIZE;
@@ -236,8 +235,7 @@ static int write_sb_page(struct bitmap *bitmap, struct page *page, int wait)
 		 */
 		if (mddev->external) {
 			/* Bitmap could be anywhere. */
-			if (rdev->sb_start + offset + (page->index
-						       * (PAGE_SIZE/512))
+			if (rdev->sb_start + offset + index * PAGE_SECTORS
 			    > rdev->data_offset
 			    &&
 			    rdev->sb_start + offset
@@ -247,7 +245,7 @@ static int write_sb_page(struct bitmap *bitmap, struct page *page, int wait)
 		} else if (offset < 0) {
 			/* DATA  BITMAP METADATA  */
 			if (offset
-			    + (long)(page->index * (PAGE_SIZE/512))
+			    + (long)(index * PAGE_SECTORS)
 			    + size/512 > 0)
 				/* bitmap runs in to metadata */
 				goto bad_alignment;
@@ -259,7 +257,7 @@ static int write_sb_page(struct bitmap *bitmap, struct page *page, int wait)
 			/* METADATA BITMAP DATA */
 			if (rdev->sb_start
 			    + offset
-			    + page->index*(PAGE_SIZE/512) + size/512
+			    + index * PAGE_SECTORS + size/512
 			    > rdev->data_offset)
 				/* bitmap runs in to data */
 				goto bad_alignment;
@@ -268,7 +266,7 @@ static int write_sb_page(struct bitmap *bitmap, struct page *page, int wait)
 		}
 		md_super_write(mddev, rdev,
 			       rdev->sb_start + offset
-			       + page->index * (PAGE_SIZE/512),
+			       + index * PAGE_SECTORS,
 			       size,
 			       page);
 	}
@@ -285,12 +283,13 @@ static void md_bitmap_file_kick(struct bitmap *bitmap);
 /*
  * write out a page to a file
  */
-static void write_page(struct bitmap *bitmap, struct page *page, int wait)
+static void write_page(struct bitmap *bitmap, struct page *page,
+		       unsigned long index, int wait)
 {
 	struct buffer_head *bh;
 
 	if (bitmap->storage.file == NULL) {
-		switch (write_sb_page(bitmap, page, wait)) {
+		switch (write_sb_page(bitmap, page, index, wait)) {
 		case -EINVAL:
 			set_bit(BITMAP_WRITE_ERROR, &bitmap->flags);
 		}
@@ -399,7 +398,6 @@ static int read_page(struct file *file, unsigned long index,
 		blk_cur++;
 		bh = bh->b_this_page;
 	}
-	page->index = index;
 
 	wait_event(bitmap->write_wait,
 		   atomic_read(&bitmap->pending_writes)==0);
@@ -472,7 +470,7 @@ void md_bitmap_update_sb(struct bitmap *bitmap)
 	sb->sectors_reserved = cpu_to_le32(bitmap->mddev->
 					   bitmap_info.space);
 	kunmap_atomic(sb);
-	write_page(bitmap, bitmap->storage.sb_page, 1);
+	write_page(bitmap, bitmap->storage.sb_page, 0, 1);
 }
 EXPORT_SYMBOL(md_bitmap_update_sb);
 
@@ -524,7 +522,6 @@ static int md_bitmap_new_disk_sb(struct bitmap *bitmap)
 	bitmap->storage.sb_page = alloc_page(GFP_KERNEL | __GFP_ZERO);
 	if (bitmap->storage.sb_page == NULL)
 		return -ENOMEM;
-	bitmap->storage.sb_page->index = 0;
 
 	sb = kmap_atomic(bitmap->storage.sb_page);
 
@@ -802,7 +799,6 @@ static int md_bitmap_storage_alloc(struct bitmap_storage *store,
 	if (store->sb_page) {
 		store->filemap[0] = store->sb_page;
 		pnum = 1;
-		store->sb_page->index = offset;
 	}
 
 	for ( ; pnum < num_pages; pnum++) {
@@ -929,6 +925,7 @@ static void md_bitmap_file_set_bit(struct bitmap *bitmap, sector_t block)
 	unsigned long chunk = block >> bitmap->counts.chunkshift;
 	struct bitmap_storage *store = &bitmap->storage;
 	unsigned long node_offset = 0;
+	unsigned long index = file_page_index(store, chunk);
 
 	if (mddev_is_clustered(bitmap->mddev))
 		node_offset = bitmap->cluster_slot * store->file_pages;
@@ -945,9 +942,9 @@ static void md_bitmap_file_set_bit(struct bitmap *bitmap, sector_t block)
 	else
 		set_bit_le(bit, kaddr);
 	kunmap_atomic(kaddr);
-	pr_debug("set file bit %lu page %lu\n", bit, page->index);
+	pr_debug("set file bit %lu page %lu\n", bit, index);
 	/* record page number so it gets flushed to disk when unplug occurs */
-	set_page_attr(bitmap, page->index - node_offset, BITMAP_PAGE_DIRTY);
+	set_page_attr(bitmap, index - node_offset, BITMAP_PAGE_DIRTY);
 }
 
 static void md_bitmap_file_clear_bit(struct bitmap *bitmap, sector_t block)
@@ -958,6 +955,7 @@ static void md_bitmap_file_clear_bit(struct bitmap *bitmap, sector_t block)
 	unsigned long chunk = block >> bitmap->counts.chunkshift;
 	struct bitmap_storage *store = &bitmap->storage;
 	unsigned long node_offset = 0;
+	unsigned long index = file_page_index(store, chunk);
 
 	if (mddev_is_clustered(bitmap->mddev))
 		node_offset = bitmap->cluster_slot * store->file_pages;
@@ -972,8 +970,8 @@ static void md_bitmap_file_clear_bit(struct bitmap *bitmap, sector_t block)
 	else
 		clear_bit_le(bit, paddr);
 	kunmap_atomic(paddr);
-	if (!test_page_attr(bitmap, page->index - node_offset, BITMAP_PAGE_NEEDWRITE)) {
-		set_page_attr(bitmap, page->index - node_offset, BITMAP_PAGE_PENDING);
+	if (!test_page_attr(bitmap, index - node_offset, BITMAP_PAGE_NEEDWRITE)) {
+		set_page_attr(bitmap, index - node_offset, BITMAP_PAGE_PENDING);
 		bitmap->allclean = 0;
 	}
 }
@@ -1027,7 +1025,7 @@ void md_bitmap_unplug(struct bitmap *bitmap)
 							  "md bitmap_unplug");
 			}
 			clear_page_attr(bitmap, i, BITMAP_PAGE_PENDING);
-			write_page(bitmap, bitmap->storage.filemap[i], 0);
+			write_page(bitmap, bitmap->storage.filemap[i], i, 0);
 			writing = 1;
 		}
 	}
@@ -1137,7 +1135,7 @@ static int md_bitmap_init_from_disk(struct bitmap *bitmap, sector_t start)
 				memset(paddr + offset, 0xff,
 				       PAGE_SIZE - offset);
 				kunmap_atomic(paddr);
-				write_page(bitmap, page, 1);
+				write_page(bitmap, page, index, 1);
 
 				ret = -EIO;
 				if (test_bit(BITMAP_WRITE_ERROR,
@@ -1336,7 +1334,7 @@ void md_bitmap_daemon_work(struct mddev *mddev)
 		if (bitmap->storage.filemap &&
 		    test_and_clear_page_attr(bitmap, j,
 					     BITMAP_PAGE_NEEDWRITE)) {
-			write_page(bitmap, bitmap->storage.filemap[j], 0);
+			write_page(bitmap, bitmap->storage.filemap[j], j, 0);
 		}
 	}
 
-- 
2.33.0

