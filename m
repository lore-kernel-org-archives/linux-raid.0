Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 376BEC433EF
	for <linux-raid@archiver.kernel.org>; Thu, 14 Oct 2021 14:30:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2115E61151
	for <linux-raid@archiver.kernel.org>; Thu, 14 Oct 2021 14:30:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231560AbhJNOce (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 14 Oct 2021 10:32:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230126AbhJNOcd (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 14 Oct 2021 10:32:33 -0400
Received: from mail-qv1-xf32.google.com (mail-qv1-xf32.google.com [IPv6:2607:f8b0:4864:20::f32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B40B8C061570;
        Thu, 14 Oct 2021 07:30:28 -0700 (PDT)
Received: by mail-qv1-xf32.google.com with SMTP id g14so3865333qvb.0;
        Thu, 14 Oct 2021 07:30:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=5D2sj3VCZnzWYTEq7JOwoxSAP+dFgEKkYuHF951TfRk=;
        b=oksyokA0+2RU1b8CDeTR1xxp0EeRYjS53Xsn4K4orfgMbe3FSYC9m6dIi+DVhkktgu
         6SLC2P+TCPZyVA/MF6r24lpkmm2rV3RL3652D5hatr3pGm3mE3qxW9I+rFKblAnaKuJr
         z1NqGuFx9KT1SiteTGPRK83ZwV9jx93PKWqIVCwkUs2oFUKTCBWjiJbYWoa2/d6XDn9S
         O3Qw6OVlA4xTTIuey+mCUIx2VWausvl/gQrJxbUirKRpU5kW0cghKemkn44F7YuPhxb4
         UO/MeOxjWt6mdONYi/1P0zUfBkBfVXE5qESNxtQffdAzzA4Lci72J7upmUf6V/Arh2kN
         dcwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=5D2sj3VCZnzWYTEq7JOwoxSAP+dFgEKkYuHF951TfRk=;
        b=2P8QZxYUTZFBXkIXo6uJ0zpDSrhuxlGnFa5jj/pFBM5Iv3R03IajK6LS6t2GQJwpfH
         oXwPkSVTphPA1ihkyHaYepQ/ytgjm4zpyncM2CIqZK9QBWupPwQzTcJoBvAs/fF9BA1d
         rVAsQ28dLD0uOMh3W4K5wDgrcBN/quQ3hrRi4hSvpzZUNHPLkSqfZIqy0u3k8iVnblAD
         5B1mD4NBEtTlJD/HgYCxruXdCj+tyWPmUGLPk9rUgorMSw5ICRwN1xia0enBm7DMbAT+
         gzx5z3lvuRgqhzYYyY4Lcncpl9HNDia+I9ZTEa2vzgUNpAQpZvfc8tRh7jV/3IhbCODg
         qE5g==
X-Gm-Message-State: AOAM533pS2GjhmLnVstQnPpa2W5uP64YRnBao6ujIt8XUKoaIvjmWwWY
        pjMdmtlaRlV5GutNr85f2vLPiubfZtHV
X-Google-Smtp-Source: ABdhPJxbOW6V4XQT7fNf9TONTy7cOM6vz8scFxCGaMmHU8dcMId/GeRe5iOF6Uc7ULwz2ADtv1xh8w==
X-Received: by 2002:a0c:b412:: with SMTP id u18mr5871074qve.14.1634221827756;
        Thu, 14 Oct 2021 07:30:27 -0700 (PDT)
Received: from moria.home.lan (c-73-219-103-14.hsd1.vt.comcast.net. [73.219.103.14])
        by smtp.gmail.com with ESMTPSA id g4sm1442019qtp.43.2021.10.14.07.30.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Oct 2021 07:30:26 -0700 (PDT)
Date:   Thu, 14 Oct 2021 10:30:24 -0400
From:   Kent Overstreet <kent.overstreet@gmail.com>
To:     "heming.zhao@suse.com" <heming.zhao@suse.com>
Cc:     Guoqing Jiang <guoqing.jiang@linux.dev>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org, linux-raid@vger.kernel.org,
        linux-block@vger.kernel.org, axboe@kernel.dk,
        alexander.h.duyck@linux.intel.com
Subject: [PATCH v2] md: Kill usage of page->index
Message-ID: <YWg/AGR50Vw7DDuU@moria.home.lan>
References: <20211013160034.3472923-1-kent.overstreet@gmail.com>
 <20211013160034.3472923-5-kent.overstreet@gmail.com>
 <bcdd4b56-9b6b-c5cb-2eb7-540fa003d692@linux.dev>
 <04714b0e-297b-7383-ed4f-e39ae5e56433@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <04714b0e-297b-7383-ed4f-e39ae5e56433@suse.com>
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Thu, Oct 14, 2021 at 04:58:46PM +0800, heming.zhao@suse.com wrote:
> Hello all,
> 
> The page->index takes an important role for cluster-md module.
> i.e, a two-node HA env, node A bitmap may be managed in first 4K area, then
> node B bitmap is in 8K area (the second page). this patch removes the index
> and fix/hardcode index with value 0, which will only operate first node bitmap.
> 
> If this serial patches are important and must be merged in mainline, we should
> redesign code logic for the related code.
> 
> Thanks,
> Heming

Can you look at and test the updated patch below? The more I look at the md
bitmap code the more it scares me.

-- >8 --
Subject: [PATCH] md: Kill usage of page->index

As part of the struct page cleanups underway, we want to remove as much
usage of page->mapping and page->index as possible, as frequently they
are known from context - as they are here in the md bitmap code.

Signed-off-by: Kent Overstreet <kent.overstreet@gmail.com>
---
 drivers/md/md-bitmap.c | 49 ++++++++++++++++++++----------------------
 drivers/md/md-bitmap.h |  1 +
 2 files changed, 24 insertions(+), 26 deletions(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index e29c6298ef..316e4cd5a7 100644
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
+	write_page(bitmap, bitmap->storage.sb_page, bitmap->storage.sb_index, 1);
 }
 EXPORT_SYMBOL(md_bitmap_update_sb);
 
@@ -524,7 +522,6 @@ static int md_bitmap_new_disk_sb(struct bitmap *bitmap)
 	bitmap->storage.sb_page = alloc_page(GFP_KERNEL | __GFP_ZERO);
 	if (bitmap->storage.sb_page == NULL)
 		return -ENOMEM;
-	bitmap->storage.sb_page->index = 0;
 
 	sb = kmap_atomic(bitmap->storage.sb_page);
 
@@ -776,7 +773,7 @@ static int md_bitmap_storage_alloc(struct bitmap_storage *store,
 				   unsigned long chunks, int with_super,
 				   int slot_number)
 {
-	int pnum, offset = 0;
+	int pnum;
 	unsigned long num_pages;
 	unsigned long bytes;
 
@@ -785,7 +782,7 @@ static int md_bitmap_storage_alloc(struct bitmap_storage *store,
 		bytes += sizeof(bitmap_super_t);
 
 	num_pages = DIV_ROUND_UP(bytes, PAGE_SIZE);
-	offset = slot_number * num_pages;
+	store->sb_index = slot_number * num_pages;
 
 	store->filemap = kmalloc_array(num_pages, sizeof(struct page *),
 				       GFP_KERNEL);
@@ -802,7 +799,6 @@ static int md_bitmap_storage_alloc(struct bitmap_storage *store,
 	if (store->sb_page) {
 		store->filemap[0] = store->sb_page;
 		pnum = 1;
-		store->sb_page->index = offset;
 	}
 
 	for ( ; pnum < num_pages; pnum++) {
@@ -811,7 +807,6 @@ static int md_bitmap_storage_alloc(struct bitmap_storage *store,
 			store->file_pages = pnum;
 			return -ENOMEM;
 		}
-		store->filemap[pnum]->index = pnum + offset;
 	}
 	store->file_pages = pnum;
 
@@ -929,6 +924,7 @@ static void md_bitmap_file_set_bit(struct bitmap *bitmap, sector_t block)
 	unsigned long chunk = block >> bitmap->counts.chunkshift;
 	struct bitmap_storage *store = &bitmap->storage;
 	unsigned long node_offset = 0;
+	unsigned long index = file_page_index(store, chunk);
 
 	if (mddev_is_clustered(bitmap->mddev))
 		node_offset = bitmap->cluster_slot * store->file_pages;
@@ -945,9 +941,9 @@ static void md_bitmap_file_set_bit(struct bitmap *bitmap, sector_t block)
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
@@ -958,6 +954,7 @@ static void md_bitmap_file_clear_bit(struct bitmap *bitmap, sector_t block)
 	unsigned long chunk = block >> bitmap->counts.chunkshift;
 	struct bitmap_storage *store = &bitmap->storage;
 	unsigned long node_offset = 0;
+	unsigned long index = file_page_index(store, chunk);
 
 	if (mddev_is_clustered(bitmap->mddev))
 		node_offset = bitmap->cluster_slot * store->file_pages;
@@ -972,8 +969,8 @@ static void md_bitmap_file_clear_bit(struct bitmap *bitmap, sector_t block)
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
@@ -1027,7 +1024,7 @@ void md_bitmap_unplug(struct bitmap *bitmap)
 							  "md bitmap_unplug");
 			}
 			clear_page_attr(bitmap, i, BITMAP_PAGE_PENDING);
-			write_page(bitmap, bitmap->storage.filemap[i], 0);
+			write_page(bitmap, bitmap->storage.filemap[i], i, 0);
 			writing = 1;
 		}
 	}
@@ -1137,7 +1134,7 @@ static int md_bitmap_init_from_disk(struct bitmap *bitmap, sector_t start)
 				memset(paddr + offset, 0xff,
 				       PAGE_SIZE - offset);
 				kunmap_atomic(paddr);
-				write_page(bitmap, page, 1);
+				write_page(bitmap, page, index, 1);
 
 				ret = -EIO;
 				if (test_bit(BITMAP_WRITE_ERROR,
@@ -1336,7 +1333,7 @@ void md_bitmap_daemon_work(struct mddev *mddev)
 		if (bitmap->storage.filemap &&
 		    test_and_clear_page_attr(bitmap, j,
 					     BITMAP_PAGE_NEEDWRITE)) {
-			write_page(bitmap, bitmap->storage.filemap[j], 0);
+			write_page(bitmap, bitmap->storage.filemap[j], j, 0);
 		}
 	}
 
diff --git a/drivers/md/md-bitmap.h b/drivers/md/md-bitmap.h
index cfd7395de8..6e820eea32 100644
--- a/drivers/md/md-bitmap.h
+++ b/drivers/md/md-bitmap.h
@@ -207,6 +207,7 @@ struct bitmap {
 						 * w/ filemap pages */
 		unsigned long file_pages;	/* number of pages in the file*/
 		unsigned long bytes;		/* total bytes in the bitmap */
+		unsigned long sb_index;		/* sb page index */
 	} storage;
 
 	unsigned long flags;
-- 
2.33.0

