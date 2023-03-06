Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F47AC64EC4
	for <linux-raid@archiver.kernel.org>; Mon,  6 Mar 2023 21:30:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230157AbjCFVas (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 6 Mar 2023 16:30:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230083AbjCFV3j (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 6 Mar 2023 16:29:39 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9C5F3D0B9
        for <linux-raid@vger.kernel.org>; Mon,  6 Mar 2023 13:28:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678138111;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NbYC7cvdSambF8fncErMOXj4kA6EKmZhrBtrxt8Y9hQ=;
        b=RCgS0vzSD1ThQrlX6lW0l6HWnjhQU9cwbJYxOqUbvUPBHGY4NrxdEEf1nx2VdoNJHTnhiZ
        RO3nm3TB5puAyOdDF++xRLGOsUPj21GRH1Q5wfbu7CV6eIp4c/zKgKVIEBzLdIVe14pNfD
        HsrLM8uCErzmiktW4U8H4hgwm9FZ/+E=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-446-89-R8mkzP1iAFQFCAwe7Og-1; Mon, 06 Mar 2023 16:28:29 -0500
X-MC-Unique: 89-R8mkzP1iAFQFCAwe7Og-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7D920858F0E
        for <linux-raid@vger.kernel.org>; Mon,  6 Mar 2023 21:28:29 +0000 (UTC)
Received: from o.redhat.com (unknown [10.39.192.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A9EF140B40E4;
        Mon,  6 Mar 2023 21:28:28 +0000 (UTC)
From:   heinzm@redhat.com
To:     linux-raid@vger.kernel.org
Cc:     ncroxon@redhat.com, xni@redhat.com, dkeefe@redhat.com
Subject: [PATCH 30/34] md: prefer kmap_local_page() instead of deprecated kmap_atomic() [WARNING]
Date:   Mon,  6 Mar 2023 22:27:53 +0100
Message-Id: <5425053387501dd0e9ce027557987561118495cf.1678136717.git.heinzm@redhat.com>
In-Reply-To: <cover.1678136717.git.heinzm@redhat.com>
References: <cover.1678136717.git.heinzm@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

From: Heinz Mauelshagen <heinzm@redhat.com>

Signed-off-by: heinzm <heinzm@redhat.com>
---
 drivers/md/md-bitmap.c   | 42 ++++++++++++++++++++--------------------
 drivers/md/md-cluster.c  | 10 +++++-----
 drivers/md/raid5-cache.c | 16 +++++++--------
 3 files changed, 34 insertions(+), 34 deletions(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index 25895ec7d89a..dd752f04e3af 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -450,7 +450,7 @@ void md_bitmap_update_sb(struct bitmap *bitmap)
 		return;
 	if (!bitmap->storage.sb_page) /* no superblock */
 		return;
-	sb = kmap_atomic(bitmap->storage.sb_page);
+	sb = kmap_local_page(bitmap->storage.sb_page);
 	sb->events = cpu_to_le64(bitmap->mddev->events);
 	if (bitmap->mddev->events < bitmap->events_cleared)
 		/* rocking back to read-only */
@@ -469,7 +469,7 @@ void md_bitmap_update_sb(struct bitmap *bitmap)
 	sb->chunksize = cpu_to_le32(bitmap->mddev->bitmap_info.chunksize);
 	sb->nodes = cpu_to_le32(bitmap->mddev->bitmap_info.nodes);
 	sb->sectors_reserved = cpu_to_le32(bitmap->mddev->bitmap_info.space);
-	kunmap_atomic(sb);
+	kunmap_local(sb);
 	write_page(bitmap, bitmap->storage.sb_page, 1);
 }
 EXPORT_SYMBOL(md_bitmap_update_sb);
@@ -481,7 +481,7 @@ void md_bitmap_print_sb(struct bitmap *bitmap)
 
 	if (!bitmap || !bitmap->storage.sb_page)
 		return;
-	sb = kmap_atomic(bitmap->storage.sb_page);
+	sb = kmap_local_page(bitmap->storage.sb_page);
 	pr_debug("%s: bitmap file superblock:\n", bmname(bitmap));
 	pr_debug("         magic: %08x\n", le32_to_cpu(sb->magic));
 	pr_debug("       version: %u\n", le32_to_cpu(sb->version));
@@ -500,7 +500,7 @@ void md_bitmap_print_sb(struct bitmap *bitmap)
 	pr_debug("     sync size: %llu KB\n",
 		 (unsigned long long)le64_to_cpu(sb->sync_size)/2);
 	pr_debug("max write behind: %u\n", le32_to_cpu(sb->write_behind));
-	kunmap_atomic(sb);
+	kunmap_local(sb);
 }
 
 /*
@@ -524,7 +524,7 @@ static int md_bitmap_new_disk_sb(struct bitmap *bitmap)
 		return -ENOMEM;
 	bitmap->storage.sb_page->index = 0;
 
-	sb = kmap_atomic(bitmap->storage.sb_page);
+	sb = kmap_local_page(bitmap->storage.sb_page);
 
 	sb->magic = cpu_to_le32(BITMAP_MAGIC);
 	sb->version = cpu_to_le32(BITMAP_MAJOR_HI);
@@ -532,7 +532,7 @@ static int md_bitmap_new_disk_sb(struct bitmap *bitmap)
 	chunksize = bitmap->mddev->bitmap_info.chunksize;
 	BUG_ON(!chunksize);
 	if (!is_power_of_2(chunksize)) {
-		kunmap_atomic(sb);
+		kunmap_local(sb);
 		pr_warn("bitmap chunksize not a power of 2\n");
 		return -EINVAL;
 	}
@@ -567,7 +567,7 @@ static int md_bitmap_new_disk_sb(struct bitmap *bitmap)
 	sb->events_cleared = cpu_to_le64(bitmap->mddev->events);
 	bitmap->mddev->bitmap_info.nodes = 0;
 
-	kunmap_atomic(sb);
+	kunmap_local(sb);
 
 	return 0;
 }
@@ -631,7 +631,7 @@ static int md_bitmap_read_sb(struct bitmap *bitmap)
 		return err;
 
 	err = -EINVAL;
-	sb = kmap_atomic(sb_page);
+	sb = kmap_local_page(sb_page);
 
 	chunksize = le32_to_cpu(sb->chunksize);
 	daemon_sleep = le32_to_cpu(sb->daemon_sleep) * HZ;
@@ -698,7 +698,7 @@ static int md_bitmap_read_sb(struct bitmap *bitmap)
 	err = 0;
 
 out:
-	kunmap_atomic(sb);
+	kunmap_local(sb);
 	if (err == 0 && nodes && (bitmap->cluster_slot < 0)) {
 		/* Assigning chunksize is required for "re_read" */
 		bitmap->mddev->bitmap_info.chunksize = chunksize;
@@ -939,12 +939,12 @@ static void md_bitmap_file_set_bit(struct bitmap *bitmap, sector_t block)
 	bit = file_page_offset(&bitmap->storage, chunk);
 
 	/* set the bit */
-	kaddr = kmap_atomic(page);
+	kaddr = kmap_local_page(page);
 	if (test_bit(BITMAP_HOSTENDIAN, &bitmap->flags))
 		set_bit(bit, kaddr);
 	else
 		set_bit_le(bit, kaddr);
-	kunmap_atomic(kaddr);
+	kunmap_local(kaddr);
 	pr_debug("set file bit %lu page %lu\n", bit, page->index);
 	/* record page number so it gets flushed to disk when unplug occurs */
 	set_page_attr(bitmap, page->index - node_offset, BITMAP_PAGE_DIRTY);
@@ -966,12 +966,12 @@ static void md_bitmap_file_clear_bit(struct bitmap *bitmap, sector_t block)
 	if (!page)
 		return;
 	bit = file_page_offset(&bitmap->storage, chunk);
-	paddr = kmap_atomic(page);
+	paddr = kmap_local_page(page);
 	if (test_bit(BITMAP_HOSTENDIAN, &bitmap->flags))
 		clear_bit(bit, paddr);
 	else
 		clear_bit_le(bit, paddr);
-	kunmap_atomic(paddr);
+	kunmap_local(paddr);
 	if (!test_page_attr(bitmap, page->index - node_offset, BITMAP_PAGE_NEEDWRITE)) {
 		set_page_attr(bitmap, page->index - node_offset, BITMAP_PAGE_PENDING);
 		bitmap->allclean = 0;
@@ -990,12 +990,12 @@ static int md_bitmap_file_test_bit(struct bitmap *bitmap, sector_t block)
 	if (!page)
 		return -EINVAL;
 	bit = file_page_offset(&bitmap->storage, chunk);
-	paddr = kmap_atomic(page);
+	paddr = kmap_local_page(page);
 	if (test_bit(BITMAP_HOSTENDIAN, &bitmap->flags))
 		set = test_bit(bit, paddr);
 	else
 		set = test_bit_le(bit, paddr);
-	kunmap_atomic(paddr);
+	kunmap_local(paddr);
 	return set;
 }
 
@@ -1134,10 +1134,10 @@ static int md_bitmap_init_from_disk(struct bitmap *bitmap, sector_t start)
 				 * if bitmap is out of date, dirty the
 				 * whole page and write it out
 				 */
-				paddr = kmap_atomic(page);
+				paddr = kmap_local_page(page);
 				memset(paddr + offset, 0xff,
 				       PAGE_SIZE - offset);
-				kunmap_atomic(paddr);
+				kunmap_local(paddr);
 				write_page(bitmap, page, 1);
 
 				ret = -EIO;
@@ -1146,12 +1146,12 @@ static int md_bitmap_init_from_disk(struct bitmap *bitmap, sector_t start)
 					goto err;
 			}
 		}
-		paddr = kmap_atomic(page);
+		paddr = kmap_local_page(page);
 		if (test_bit(BITMAP_HOSTENDIAN, &bitmap->flags))
 			b = test_bit(bit, paddr);
 		else
 			b = test_bit_le(bit, paddr);
-		kunmap_atomic(paddr);
+		kunmap_local(paddr);
 		if (b) {
 			/* if the disk bit is set, set the memory bit */
 			int needed = ((sector_t)(i+1) << bitmap->counts.chunkshift
@@ -1273,10 +1273,10 @@ void md_bitmap_daemon_work(struct mddev *mddev)
 
 		bitmap->need_sync = 0;
 		if (bitmap->storage.filemap) {
-			sb = kmap_atomic(bitmap->storage.sb_page);
+			sb = kmap_local_page(bitmap->storage.sb_page);
 			sb->events_cleared =
 				cpu_to_le64(bitmap->events_cleared);
-			kunmap_atomic(sb);
+			kunmap_local(sb);
 			set_page_attr(bitmap, 0,
 				      BITMAP_PAGE_NEEDWRITE);
 		}
diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
index e115603ff0d9..ac3a8afc28ee 100644
--- a/drivers/md/md-cluster.c
+++ b/drivers/md/md-cluster.c
@@ -1203,9 +1203,9 @@ static int cluster_check_sync_size(struct mddev *mddev)
 	char str[64];
 	struct dlm_lock_resource *bm_lockres;
 
-	sb = kmap_atomic(bitmap->storage.sb_page);
+	sb = kmap_local_page(bitmap->storage.sb_page);
 	my_sync_size = sb->sync_size;
-	kunmap_atomic(sb);
+	kunmap_local(sb);
 
 	for (i = 0; i < node_num; i++) {
 		if (i == current_slot)
@@ -1234,15 +1234,15 @@ static int cluster_check_sync_size(struct mddev *mddev)
 			md_bitmap_update_sb(bitmap);
 		lockres_free(bm_lockres);
 
-		sb = kmap_atomic(bitmap->storage.sb_page);
+		sb = kmap_local_page(bitmap->storage.sb_page);
 		if (sync_size == 0)
 			sync_size = sb->sync_size;
 		else if (sync_size != sb->sync_size) {
-			kunmap_atomic(sb);
+			kunmap_local(sb);
 			md_bitmap_free(bitmap);
 			return -1;
 		}
-		kunmap_atomic(sb);
+		kunmap_local(sb);
 		md_bitmap_free(bitmap);
 	}
 
diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index f40ee2101796..3da3e96d61f7 100644
--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -1021,10 +1021,10 @@ int r5l_write_stripe(struct r5l_log *log, struct stripe_head *sh)
 		/* checksum is already calculated in last run */
 		if (test_bit(STRIPE_LOG_TRAPPED, &sh->state))
 			continue;
-		addr = kmap_atomic(sh->dev[i].page);
+		addr = kmap_local_page(sh->dev[i].page);
 		sh->dev[i].log_checksum = crc32c_le(log->uuid_checksum,
 						    addr, PAGE_SIZE);
-		kunmap_atomic(addr);
+		kunmap_local(addr);
 	}
 	parity_pages = 1 + !!(sh->qd_idx >= 0);
 	data_pages = write_disks - parity_pages;
@@ -1983,9 +1983,9 @@ r5l_recovery_verify_data_checksum(struct r5l_log *log,
 	u32 checksum;
 
 	r5l_recovery_read_page(log, ctx, page, log_offset);
-	addr = kmap_atomic(page);
+	addr = kmap_local_page(page);
 	checksum = crc32c_le(log->uuid_checksum, addr, PAGE_SIZE);
-	kunmap_atomic(addr);
+	kunmap_local(addr);
 	return (le32_to_cpu(log_checksum) == checksum) ? 0 : -EINVAL;
 }
 
@@ -2386,11 +2386,11 @@ r5c_recovery_rewrite_data_only_stripes(struct r5l_log *log,
 				payload->size = cpu_to_le32(BLOCK_SECTORS);
 				payload->location = cpu_to_le64(
 					raid5_compute_blocknr(sh, i, 0));
-				addr = kmap_atomic(dev->page);
+				addr = kmap_local_page(dev->page);
 				payload->checksum[0] = cpu_to_le32(
 					crc32c_le(log->uuid_checksum, addr,
 						  PAGE_SIZE));
-				kunmap_atomic(addr);
+				kunmap_local(addr);
 				sync_page_io(log->rdev, write_pos, PAGE_SIZE,
 					     dev->page, REQ_OP_WRITE, false);
 				write_pos = r5l_ring_add(log, write_pos,
@@ -2899,10 +2899,10 @@ int r5c_cache_data(struct r5l_log *log, struct stripe_head *sh)
 
 		if (!test_bit(R5_Wantwrite, &sh->dev[i].flags))
 			continue;
-		addr = kmap_atomic(sh->dev[i].page);
+		addr = kmap_local_page(sh->dev[i].page);
 		sh->dev[i].log_checksum = crc32c_le(log->uuid_checksum,
 						    addr, PAGE_SIZE);
-		kunmap_atomic(addr);
+		kunmap_local(addr);
 		pages++;
 	}
 	WARN_ON(pages == 0);
-- 
2.39.2

