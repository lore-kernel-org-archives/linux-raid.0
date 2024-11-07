Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 099B1212634;
	Thu,  7 Nov 2024 13:02:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730984569; cv=none; b=XDe/0bUM3fF2WNweouiT0mgkqJd8e/7qWSLS5bckuyIlavS9TsFDOS4eVZDQoJVxlRwH1iHjKrU3fd+2U/+PMhz0ng6Hzj1nvRhOKt9goxL4CJg2ptC26CFf4Vkb3vzWlW5L60IWkNBdZIV8kJjeM7eC6HPsfxQg/AmNLurYa7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730984569; c=relaxed/simple;
	bh=IjjSs46jT58D/Li22f7HxuUtahIsOudiCpRxFXd0QWc=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=JIt4yT3arrIMxF+FD13UsahooYAtZq84/4f2CnagrbTXgJo1sI8/f6HMwkj6KeN1fx214hC4C6t2vJRCSoVe0BzunhfsoKJHVEfxSEdxvOoUP5y/VxYn5y0gvuj6iRakwUspE1Ja3bGh/a48lNEsA7E2eCeKoPHmgNRiR3hcjes=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4Xkj0J51G1z4f3jdh;
	Thu,  7 Nov 2024 21:02:24 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id B21F21A06D7;
	Thu,  7 Nov 2024 21:02:42 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgBHIoZxuixn3O1yBA--.8734S4;
	Thu, 07 Nov 2024 21:02:42 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: song@kernel.org
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	yukuai3@huawei.com,
	yukuai1@huaweicloud.com,
	yi.zhang@huawei.com,
	yangerkun@huawei.com
Subject: [PATCH md-6.13] md: remove bitmap file support
Date: Thu,  7 Nov 2024 20:59:11 +0800
Message-Id: <20241107125911.311347-1-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgBHIoZxuixn3O1yBA--.8734S4
X-Coremail-Antispam: 1UD129KBjvAXoWfWr1fXFWfCr1rGF1rZF48tFb_yoW5Xw4DJo
	Z3ZwnIqw4rWr1rXrWUArySqFy7WFyqkwnYyw4rCrZ0gF4UZw1jvrWfWrW3J3Z0qF15KF1x
	tF97Xw1rJF4xJrW7n29KB7ZKAUJUUUU8529EdanIXcx71UUUUU7v73VFW2AGmfu7bjvjm3
	AaLaJ3UjIYCTnIWjp_UUUYF7AC8VAFwI0_Gr0_Xr1l1xkIjI8I6I8E6xAIw20EY4v20xva
	j40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2
	x7M28EF7xvwVC0I7IYx2IY67AKxVW5JVW7JwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVWx
	JVW8Jr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_JrI_JrylYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lc7CjxVAaw2AFwI0_
	JF0_Jw1l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67
	AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1DMIIY
	rxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14
	v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVW8JVWx
	JwCI42IY6I8E87Iv6xkF7I0E14v26r4UJVWxJrUvcSsGvfC2KfnxnUUI43ZEXa7VU18sqt
	UUUUU==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

The bitmap file has been marked as deprecated for more than a year now,
let's remove it, and we don't need to care about this case in the new
bitmap.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/md-bitmap.c | 269 +++++------------------------------------
 drivers/md/md-bitmap.h |   1 -
 drivers/md/md.c        | 195 ++++-------------------------
 drivers/md/md.h        |  53 ++++----
 drivers/md/raid5-ppl.c |   2 +-
 drivers/md/raid5.c     |   2 +-
 6 files changed, 79 insertions(+), 443 deletions(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index 29da10e6f703..6895883fc622 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -167,8 +167,6 @@ struct bitmap {
 	int need_sync;
 
 	struct bitmap_storage {
-		/* backing disk file */
-		struct file *file;
 		/* cached copy of the bitmap file superblock */
 		struct page *sb_page;
 		unsigned long sb_index;
@@ -495,135 +493,6 @@ static void write_sb_page(struct bitmap *bitmap, unsigned long pg_index,
 
 static void md_bitmap_file_kick(struct bitmap *bitmap);
 
-#ifdef CONFIG_MD_BITMAP_FILE
-static void write_file_page(struct bitmap *bitmap, struct page *page, int wait)
-{
-	struct buffer_head *bh = page_buffers(page);
-
-	while (bh && bh->b_blocknr) {
-		atomic_inc(&bitmap->pending_writes);
-		set_buffer_locked(bh);
-		set_buffer_mapped(bh);
-		submit_bh(REQ_OP_WRITE | REQ_SYNC, bh);
-		bh = bh->b_this_page;
-	}
-
-	if (wait)
-		wait_event(bitmap->write_wait,
-			   atomic_read(&bitmap->pending_writes) == 0);
-}
-
-static void end_bitmap_write(struct buffer_head *bh, int uptodate)
-{
-	struct bitmap *bitmap = bh->b_private;
-
-	if (!uptodate)
-		set_bit(BITMAP_WRITE_ERROR, &bitmap->flags);
-	if (atomic_dec_and_test(&bitmap->pending_writes))
-		wake_up(&bitmap->write_wait);
-}
-
-static void free_buffers(struct page *page)
-{
-	struct buffer_head *bh;
-
-	if (!PagePrivate(page))
-		return;
-
-	bh = page_buffers(page);
-	while (bh) {
-		struct buffer_head *next = bh->b_this_page;
-		free_buffer_head(bh);
-		bh = next;
-	}
-	detach_page_private(page);
-	put_page(page);
-}
-
-/* read a page from a file.
- * We both read the page, and attach buffers to the page to record the
- * address of each block (using bmap).  These addresses will be used
- * to write the block later, completely bypassing the filesystem.
- * This usage is similar to how swap files are handled, and allows us
- * to write to a file with no concerns of memory allocation failing.
- */
-static int read_file_page(struct file *file, unsigned long index,
-		struct bitmap *bitmap, unsigned long count, struct page *page)
-{
-	int ret = 0;
-	struct inode *inode = file_inode(file);
-	struct buffer_head *bh;
-	sector_t block, blk_cur;
-	unsigned long blocksize = i_blocksize(inode);
-
-	pr_debug("read bitmap file (%dB @ %llu)\n", (int)PAGE_SIZE,
-		 (unsigned long long)index << PAGE_SHIFT);
-
-	bh = alloc_page_buffers(page, blocksize);
-	if (!bh) {
-		ret = -ENOMEM;
-		goto out;
-	}
-	attach_page_private(page, bh);
-	blk_cur = index << (PAGE_SHIFT - inode->i_blkbits);
-	while (bh) {
-		block = blk_cur;
-
-		if (count == 0)
-			bh->b_blocknr = 0;
-		else {
-			ret = bmap(inode, &block);
-			if (ret || !block) {
-				ret = -EINVAL;
-				bh->b_blocknr = 0;
-				goto out;
-			}
-
-			bh->b_blocknr = block;
-			bh->b_bdev = inode->i_sb->s_bdev;
-			if (count < blocksize)
-				count = 0;
-			else
-				count -= blocksize;
-
-			bh->b_end_io = end_bitmap_write;
-			bh->b_private = bitmap;
-			atomic_inc(&bitmap->pending_writes);
-			set_buffer_locked(bh);
-			set_buffer_mapped(bh);
-			submit_bh(REQ_OP_READ, bh);
-		}
-		blk_cur++;
-		bh = bh->b_this_page;
-	}
-
-	wait_event(bitmap->write_wait,
-		   atomic_read(&bitmap->pending_writes)==0);
-	if (test_bit(BITMAP_WRITE_ERROR, &bitmap->flags))
-		ret = -EIO;
-out:
-	if (ret)
-		pr_err("md: bitmap read error: (%dB @ %llu): %d\n",
-		       (int)PAGE_SIZE,
-		       (unsigned long long)index << PAGE_SHIFT,
-		       ret);
-	return ret;
-}
-#else /* CONFIG_MD_BITMAP_FILE */
-static void write_file_page(struct bitmap *bitmap, struct page *page, int wait)
-{
-}
-static int read_file_page(struct file *file, unsigned long index,
-		struct bitmap *bitmap, unsigned long count, struct page *page)
-{
-	return -EIO;
-}
-static void free_buffers(struct page *page)
-{
-	put_page(page);
-}
-#endif /* CONFIG_MD_BITMAP_FILE */
-
 /*
  * bitmap file superblock operations
  */
@@ -642,10 +511,7 @@ static void filemap_write_page(struct bitmap *bitmap, unsigned long pg_index,
 		pg_index += store->sb_index;
 	}
 
-	if (store->file)
-		write_file_page(bitmap, page, wait);
-	else
-		write_sb_page(bitmap, pg_index, page, wait);
+	write_sb_page(bitmap, pg_index, page, wait);
 }
 
 /*
@@ -655,18 +521,15 @@ static void filemap_write_page(struct bitmap *bitmap, unsigned long pg_index,
  */
 static void md_bitmap_wait_writes(struct bitmap *bitmap)
 {
-	if (bitmap->storage.file)
-		wait_event(bitmap->write_wait,
-			   atomic_read(&bitmap->pending_writes)==0);
-	else
-		/* Note that we ignore the return value.  The writes
-		 * might have failed, but that would just mean that
-		 * some bits which should be cleared haven't been,
-		 * which is safe.  The relevant bitmap blocks will
-		 * probably get written again, but there is no great
-		 * loss if they aren't.
-		 */
-		md_super_wait(bitmap->mddev);
+	/*
+	 * Note that we ignore the return value.  The writes
+	 * might have failed, but that would just mean that
+	 * some bits which should be cleared haven't been,
+	 * which is safe.  The relevant bitmap blocks will
+	 * probably get written again, but there is no great
+	 * loss if they aren't.
+	 */
+	md_super_wait(bitmap->mddev);
 }
 
 
@@ -704,11 +567,8 @@ static void bitmap_update_sb(void *data)
 					   bitmap_info.space);
 	kunmap_atomic(sb);
 
-	if (bitmap->storage.file)
-		write_file_page(bitmap, bitmap->storage.sb_page, 1);
-	else
-		write_sb_page(bitmap, bitmap->storage.sb_index,
-			      bitmap->storage.sb_page, 1);
+	write_sb_page(bitmap, bitmap->storage.sb_index, bitmap->storage.sb_page,
+		      1);
 }
 
 static void bitmap_print_sb(struct bitmap *bitmap)
@@ -821,7 +681,7 @@ static int md_bitmap_read_sb(struct bitmap *bitmap)
 	struct page *sb_page;
 	loff_t offset = 0;
 
-	if (!bitmap->storage.file && !bitmap->mddev->bitmap_info.offset) {
+	if (!bitmap->mddev->bitmap_info.offset) {
 		chunksize = 128 * 1024 * 1024;
 		daemon_sleep = 5 * HZ;
 		write_behind = 0;
@@ -851,16 +711,8 @@ static int md_bitmap_read_sb(struct bitmap *bitmap)
 			bitmap->cluster_slot, offset);
 	}
 
-	if (bitmap->storage.file) {
-		loff_t isize = i_size_read(bitmap->storage.file->f_mapping->host);
-		int bytes = isize > PAGE_SIZE ? PAGE_SIZE : isize;
-
-		err = read_file_page(bitmap->storage.file, 0,
-				bitmap, bytes, sb_page);
-	} else {
-		err = read_sb_page(bitmap->mddev, offset, sb_page, 0,
-				   sizeof(bitmap_super_t));
-	}
+	err = read_sb_page(bitmap->mddev, offset, sb_page, 0,
+			   sizeof(bitmap_super_t));
 	if (err)
 		return err;
 
@@ -1062,25 +914,18 @@ static int md_bitmap_storage_alloc(struct bitmap_storage *store,
 
 static void md_bitmap_file_unmap(struct bitmap_storage *store)
 {
-	struct file *file = store->file;
 	struct page *sb_page = store->sb_page;
 	struct page **map = store->filemap;
 	int pages = store->file_pages;
 
 	while (pages--)
 		if (map[pages] != sb_page) /* 0 is sb_page, release it below */
-			free_buffers(map[pages]);
+			put_page(map[pages]);
 	kfree(map);
 	kfree(store->filemap_attr);
 
 	if (sb_page)
-		free_buffers(sb_page);
-
-	if (file) {
-		struct inode *inode = file_inode(file);
-		invalidate_mapping_pages(inode->i_mapping, 0, -1);
-		fput(file);
-	}
+		put_page(sb_page);
 }
 
 /*
@@ -1092,14 +937,8 @@ static void md_bitmap_file_kick(struct bitmap *bitmap)
 {
 	if (!test_and_set_bit(BITMAP_STALE, &bitmap->flags)) {
 		bitmap_update_sb(bitmap);
-
-		if (bitmap->storage.file) {
-			pr_warn("%s: kicking failed bitmap file %pD4 from array!\n",
-				bmname(bitmap), bitmap->storage.file);
-
-		} else
-			pr_warn("%s: disabling internal bitmap due to errors\n",
-				bmname(bitmap));
+		pr_warn("%s: disabling internal bitmap due to errors\n",
+			bmname(bitmap));
 	}
 }
 
@@ -1319,13 +1158,12 @@ static int md_bitmap_init_from_disk(struct bitmap *bitmap, sector_t start)
 	struct mddev *mddev = bitmap->mddev;
 	unsigned long chunks = bitmap->counts.chunks;
 	struct bitmap_storage *store = &bitmap->storage;
-	struct file *file = store->file;
 	unsigned long node_offset = 0;
 	unsigned long bit_cnt = 0;
 	unsigned long i;
 	int ret;
 
-	if (!file && !mddev->bitmap_info.offset) {
+	if (!mddev->bitmap_info.offset) {
 		/* No permanent bitmap - fill with '1s'. */
 		store->filemap = NULL;
 		store->file_pages = 0;
@@ -1340,15 +1178,6 @@ static int md_bitmap_init_from_disk(struct bitmap *bitmap, sector_t start)
 		return 0;
 	}
 
-	if (file && i_size_read(file->f_mapping->host) < store->bytes) {
-		pr_warn("%s: bitmap file too short %lu < %lu\n",
-			bmname(bitmap),
-			(unsigned long) i_size_read(file->f_mapping->host),
-			store->bytes);
-		ret = -ENOSPC;
-		goto err;
-	}
-
 	if (mddev_is_clustered(mddev))
 		node_offset = bitmap->cluster_slot * (DIV_ROUND_UP(store->bytes, PAGE_SIZE));
 
@@ -1362,11 +1191,7 @@ static int md_bitmap_init_from_disk(struct bitmap *bitmap, sector_t start)
 		else
 			count = PAGE_SIZE;
 
-		if (file)
-			ret = read_file_page(file, i, bitmap, count, page);
-		else
-			ret = read_sb_page(mddev, 0, page, i + node_offset,
-					   count);
+		ret = read_sb_page(mddev, 0, page, i + node_offset, count);
 		if (ret)
 			goto err;
 	}
@@ -1444,10 +1269,6 @@ static void bitmap_write_all(struct mddev *mddev)
 	if (!bitmap || !bitmap->storage.filemap)
 		return;
 
-	/* Only one copy, so nothing needed */
-	if (bitmap->storage.file)
-		return;
-
 	for (i = 0; i < bitmap->storage.file_pages; i++)
 		set_page_attr(bitmap, i, BITMAP_PAGE_NEEDWRITE);
 	bitmap->allclean = 0;
@@ -2105,14 +1926,11 @@ static struct bitmap *__bitmap_create(struct mddev *mddev, int slot)
 {
 	struct bitmap *bitmap;
 	sector_t blocks = mddev->resync_max_sectors;
-	struct file *file = mddev->bitmap_info.file;
 	int err;
 	struct kernfs_node *bm = NULL;
 
 	BUILD_BUG_ON(sizeof(bitmap_super_t) != 256);
 
-	BUG_ON(file && mddev->bitmap_info.offset);
-
 	if (test_bit(MD_HAS_JOURNAL, &mddev->flags)) {
 		pr_notice("md/raid:%s: array with journal cannot have bitmap\n",
 			  mdname(mddev));
@@ -2140,15 +1958,6 @@ static struct bitmap *__bitmap_create(struct mddev *mddev, int slot)
 	} else
 		bitmap->sysfs_can_clear = NULL;
 
-	bitmap->storage.file = file;
-	if (file) {
-		get_file(file);
-		/* As future accesses to this file will use bmap,
-		 * and bypass the page cache, we must sync the file
-		 * first.
-		 */
-		vfs_fsync(file, 1);
-	}
 	/* read superblock from bitmap file (this sets mddev->bitmap_info.chunksize) */
 	if (!mddev->bitmap_info.external) {
 		/*
@@ -2352,7 +2161,6 @@ static int bitmap_get_stats(void *data, struct md_bitmap_stats *stats)
 
 	storage = &bitmap->storage;
 	stats->file_pages = storage->file_pages;
-	stats->file = storage->file;
 
 	stats->behind_writes = atomic_read(&bitmap->behind_writes);
 	stats->behind_wait = wq_has_sleeper(&bitmap->behind_wait);
@@ -2383,11 +2191,6 @@ static int __bitmap_resize(struct bitmap *bitmap, sector_t blocks,
 	long pages;
 	struct bitmap_page *new_bp;
 
-	if (bitmap->storage.file && !init) {
-		pr_info("md: cannot resize file-based bitmap\n");
-		return -EINVAL;
-	}
-
 	if (chunksize == 0) {
 		/* If there is enough space, leave the chunk size unchanged,
 		 * else increase by factor of two until there is enough space.
@@ -2421,7 +2224,7 @@ static int __bitmap_resize(struct bitmap *bitmap, sector_t blocks,
 
 	chunks = DIV_ROUND_UP_SECTOR_T(blocks, 1 << chunkshift);
 	memset(&store, 0, sizeof(store));
-	if (bitmap->mddev->bitmap_info.offset || bitmap->mddev->bitmap_info.file)
+	if (bitmap->mddev->bitmap_info.offset)
 		ret = md_bitmap_storage_alloc(&store, chunks,
 					      !bitmap->mddev->bitmap_info.external,
 					      mddev_is_clustered(bitmap->mddev)
@@ -2443,9 +2246,6 @@ static int __bitmap_resize(struct bitmap *bitmap, sector_t blocks,
 	if (!init)
 		bitmap->mddev->pers->quiesce(bitmap->mddev, 1);
 
-	store.file = bitmap->storage.file;
-	bitmap->storage.file = NULL;
-
 	if (store.sb_page && bitmap->storage.sb_page)
 		memcpy(page_address(store.sb_page),
 		       page_address(bitmap->storage.sb_page),
@@ -2582,9 +2382,7 @@ static ssize_t
 location_show(struct mddev *mddev, char *page)
 {
 	ssize_t len;
-	if (mddev->bitmap_info.file)
-		len = sprintf(page, "file");
-	else if (mddev->bitmap_info.offset)
+	if (mddev->bitmap_info.offset)
 		len = sprintf(page, "%+lld", (long long)mddev->bitmap_info.offset);
 	else
 		len = sprintf(page, "none");
@@ -2608,8 +2406,7 @@ location_store(struct mddev *mddev, const char *buf, size_t len)
 		}
 	}
 
-	if (mddev->bitmap || mddev->bitmap_info.file ||
-	    mddev->bitmap_info.offset) {
+	if (mddev->bitmap || mddev->bitmap_info.offset) {
 		/* bitmap already configured.  Only option is to clear it */
 		if (strncmp(buf, "none", 4) != 0) {
 			rv = -EBUSY;
@@ -2618,22 +2415,11 @@ location_store(struct mddev *mddev, const char *buf, size_t len)
 
 		bitmap_destroy(mddev);
 		mddev->bitmap_info.offset = 0;
-		if (mddev->bitmap_info.file) {
-			struct file *f = mddev->bitmap_info.file;
-			mddev->bitmap_info.file = NULL;
-			fput(f);
-		}
 	} else {
 		/* No bitmap, OK to set a location */
 		long long offset;
 
-		if (strncmp(buf, "none", 4) == 0)
-			/* nothing to be done */;
-		else if (strncmp(buf, "file:", 5) == 0) {
-			/* Not supported yet */
-			rv = -EINVAL;
-			goto out;
-		} else {
+		if (strncmp(buf, "none", 4) != 0) {
 			if (buf[0] == '+')
 				rv = kstrtoll(buf+1, 10, &offset);
 			else
@@ -2864,10 +2650,9 @@ static ssize_t metadata_show(struct mddev *mddev, char *page)
 
 static ssize_t metadata_store(struct mddev *mddev, const char *buf, size_t len)
 {
-	if (mddev->bitmap ||
-	    mddev->bitmap_info.file ||
-	    mddev->bitmap_info.offset)
+	if (mddev->bitmap || mddev->bitmap_info.offset)
 		return -EBUSY;
+
 	if (strncmp(buf, "external", 8) == 0)
 		mddev->bitmap_info.external = 1;
 	else if ((strncmp(buf, "internal", 8) == 0) ||
diff --git a/drivers/md/md-bitmap.h b/drivers/md/md-bitmap.h
index 662e6fc141a7..4b386954f5f5 100644
--- a/drivers/md/md-bitmap.h
+++ b/drivers/md/md-bitmap.h
@@ -67,7 +67,6 @@ struct md_bitmap_stats {
 	unsigned long	file_pages;
 	unsigned long	sync_size;
 	unsigned long	pages;
-	struct file	*file;
 };
 
 struct bitmap_operations {
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 35c2e1e761aa..03f2a9fafea2 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -1155,7 +1155,7 @@ struct super_type  {
  */
 int md_check_no_bitmap(struct mddev *mddev)
 {
-	if (!mddev->bitmap_info.file && !mddev->bitmap_info.offset)
+	if (!mddev->bitmap_info.offset)
 		return 0;
 	pr_warn("%s: bitmaps are not supported for %s\n",
 		mdname(mddev), mddev->pers->name);
@@ -1349,8 +1349,7 @@ static int super_90_validate(struct mddev *mddev, struct md_rdev *freshest, stru
 
 		mddev->max_disks = MD_SB_DISKS;
 
-		if (sb->state & (1<<MD_SB_BITMAP_PRESENT) &&
-		    mddev->bitmap_info.file == NULL) {
+		if (sb->state & (1<<MD_SB_BITMAP_PRESENT)) {
 			mddev->bitmap_info.offset =
 				mddev->bitmap_info.default_offset;
 			mddev->bitmap_info.space =
@@ -1476,7 +1475,7 @@ static void super_90_sync(struct mddev *mddev, struct md_rdev *rdev)
 	sb->layout = mddev->layout;
 	sb->chunk_size = mddev->chunk_sectors << 9;
 
-	if (mddev->bitmap && mddev->bitmap_info.file == NULL)
+	if (mddev->bitmap)
 		sb->state |= (1<<MD_SB_BITMAP_PRESENT);
 
 	sb->disks[0].state = (1<<MD_DISK_REMOVED);
@@ -1824,8 +1823,7 @@ static int super_1_validate(struct mddev *mddev, struct md_rdev *freshest, struc
 
 		mddev->max_disks =  (4096-256)/2;
 
-		if ((le32_to_cpu(sb->feature_map) & MD_FEATURE_BITMAP_OFFSET) &&
-		    mddev->bitmap_info.file == NULL) {
+		if (le32_to_cpu(sb->feature_map) & MD_FEATURE_BITMAP_OFFSET) {
 			mddev->bitmap_info.offset =
 				(__s32)le32_to_cpu(sb->bitmap_offset);
 			/* Metadata doesn't record how much space is available.
@@ -2030,7 +2028,7 @@ static void super_1_sync(struct mddev *mddev, struct md_rdev *rdev)
 	sb->data_offset = cpu_to_le64(rdev->data_offset);
 	sb->data_size = cpu_to_le64(rdev->sectors);
 
-	if (mddev->bitmap && mddev->bitmap_info.file == NULL) {
+	if (mddev->bitmap) {
 		sb->bitmap_offset = cpu_to_le32((__u32)mddev->bitmap_info.offset);
 		sb->feature_map = cpu_to_le32(MD_FEATURE_BITMAP_OFFSET);
 	}
@@ -2227,6 +2225,10 @@ static int
 super_1_allow_new_offset(struct md_rdev *rdev,
 			 unsigned long long new_offset)
 {
+	struct mddev *mddev = rdev->mddev;
+	struct md_bitmap_stats stats;
+	int err;
+
 	/* All necessary checks on new >= old have been done */
 	if (new_offset >= rdev->data_offset)
 		return 1;
@@ -2245,21 +2247,12 @@ super_1_allow_new_offset(struct md_rdev *rdev,
 	if (rdev->sb_start + (32+4)*2 > new_offset)
 		return 0;
 
-	if (!rdev->mddev->bitmap_info.file) {
-		struct mddev *mddev = rdev->mddev;
-		struct md_bitmap_stats stats;
-		int err;
-
-		err = mddev->bitmap_ops->get_stats(mddev->bitmap, &stats);
-		if (!err && rdev->sb_start + mddev->bitmap_info.offset +
-		    stats.file_pages * (PAGE_SIZE >> 9) > new_offset)
-			return 0;
-	}
-
-	if (rdev->badblocks.sector + rdev->badblocks.size > new_offset)
-		return 0;
+	err = mddev->bitmap_ops->get_stats(mddev->bitmap, &stats);
+	if (err)
+		return 1;
 
-	return 1;
+	return rdev->sb_start + mddev->bitmap_info.offset +
+		stats.file_pages * (PAGE_SIZE >> 9) <= new_offset;
 }
 
 static struct super_type super_types[] = {
@@ -6150,8 +6143,7 @@ int md_run(struct mddev *mddev)
 			(unsigned long long)pers->size(mddev, 0, 0) / 2);
 		err = -EINVAL;
 	}
-	if (err == 0 && pers->sync_request &&
-	    (mddev->bitmap_info.file || mddev->bitmap_info.offset)) {
+	if (err == 0 && pers->sync_request && mddev->bitmap_info.offset) {
 		err = mddev->bitmap_ops->create(mddev, -1);
 		if (err)
 			pr_warn("%s: failed to create bitmap (%d)\n",
@@ -6563,17 +6555,8 @@ static int do_md_stop(struct mddev *mddev, int mode)
 	if (mode == 0) {
 		pr_info("md: %s stopped.\n", mdname(mddev));
 
-		if (mddev->bitmap_info.file) {
-			struct file *f = mddev->bitmap_info.file;
-			spin_lock(&mddev->lock);
-			mddev->bitmap_info.file = NULL;
-			spin_unlock(&mddev->lock);
-			fput(f);
-		}
 		mddev->bitmap_info.offset = 0;
-
 		export_array(mddev);
-
 		md_clean(mddev);
 		if (mddev->hold_active == UNTIL_STOP)
 			mddev->hold_active = 0;
@@ -6767,38 +6750,6 @@ static int get_array_info(struct mddev *mddev, void __user *arg)
 	return 0;
 }
 
-static int get_bitmap_file(struct mddev *mddev, void __user * arg)
-{
-	mdu_bitmap_file_t *file = NULL; /* too big for stack allocation */
-	char *ptr;
-	int err;
-
-	file = kzalloc(sizeof(*file), GFP_NOIO);
-	if (!file)
-		return -ENOMEM;
-
-	err = 0;
-	spin_lock(&mddev->lock);
-	/* bitmap enabled */
-	if (mddev->bitmap_info.file) {
-		ptr = file_path(mddev->bitmap_info.file, file->pathname,
-				sizeof(file->pathname));
-		if (IS_ERR(ptr))
-			err = PTR_ERR(ptr);
-		else
-			memmove(file->pathname, ptr,
-				sizeof(file->pathname)-(ptr-file->pathname));
-	}
-	spin_unlock(&mddev->lock);
-
-	if (err == 0 &&
-	    copy_to_user(arg, file, sizeof(*file)))
-		err = -EFAULT;
-
-	kfree(file);
-	return err;
-}
-
 static int get_disk_info(struct mddev *mddev, void __user * arg)
 {
 	mdu_disk_info_t info;
@@ -7153,92 +7104,6 @@ static int hot_add_disk(struct mddev *mddev, dev_t dev)
 	return err;
 }
 
-static int set_bitmap_file(struct mddev *mddev, int fd)
-{
-	int err = 0;
-
-	if (mddev->pers) {
-		if (!mddev->pers->quiesce || !mddev->thread)
-			return -EBUSY;
-		if (mddev->recovery || mddev->sync_thread)
-			return -EBUSY;
-		/* we should be able to change the bitmap.. */
-	}
-
-	if (fd >= 0) {
-		struct inode *inode;
-		struct file *f;
-
-		if (mddev->bitmap || mddev->bitmap_info.file)
-			return -EEXIST; /* cannot add when bitmap is present */
-
-		if (!IS_ENABLED(CONFIG_MD_BITMAP_FILE)) {
-			pr_warn("%s: bitmap files not supported by this kernel\n",
-				mdname(mddev));
-			return -EINVAL;
-		}
-		pr_warn("%s: using deprecated bitmap file support\n",
-			mdname(mddev));
-
-		f = fget(fd);
-
-		if (f == NULL) {
-			pr_warn("%s: error: failed to get bitmap file\n",
-				mdname(mddev));
-			return -EBADF;
-		}
-
-		inode = f->f_mapping->host;
-		if (!S_ISREG(inode->i_mode)) {
-			pr_warn("%s: error: bitmap file must be a regular file\n",
-				mdname(mddev));
-			err = -EBADF;
-		} else if (!(f->f_mode & FMODE_WRITE)) {
-			pr_warn("%s: error: bitmap file must open for write\n",
-				mdname(mddev));
-			err = -EBADF;
-		} else if (atomic_read(&inode->i_writecount) != 1) {
-			pr_warn("%s: error: bitmap file is already in use\n",
-				mdname(mddev));
-			err = -EBUSY;
-		}
-		if (err) {
-			fput(f);
-			return err;
-		}
-		mddev->bitmap_info.file = f;
-		mddev->bitmap_info.offset = 0; /* file overrides offset */
-	} else if (mddev->bitmap == NULL)
-		return -ENOENT; /* cannot remove what isn't there */
-	err = 0;
-	if (mddev->pers) {
-		if (fd >= 0) {
-			err = mddev->bitmap_ops->create(mddev, -1);
-			if (!err)
-				err = mddev->bitmap_ops->load(mddev);
-
-			if (err) {
-				mddev->bitmap_ops->destroy(mddev);
-				fd = -1;
-			}
-		} else if (fd < 0) {
-			mddev->bitmap_ops->destroy(mddev);
-		}
-	}
-
-	if (fd < 0) {
-		struct file *f = mddev->bitmap_info.file;
-		if (f) {
-			spin_lock(&mddev->lock);
-			mddev->bitmap_info.file = NULL;
-			spin_unlock(&mddev->lock);
-			fput(f);
-		}
-	}
-
-	return err;
-}
-
 /*
  * md_set_array_info is used two different ways
  * The original usage is when creating a new array.
@@ -7520,11 +7385,6 @@ static int update_array_info(struct mddev *mddev, mdu_array_info_t *info)
 			if (rv)
 				goto err;
 
-			if (stats.file) {
-				rv = -EINVAL;
-				goto err;
-			}
-
 			if (mddev->bitmap_info.nodes) {
 				/* hold PW on all the bitmap lock */
 				if (md_cluster_ops->lock_all_bitmaps(mddev) <= 0) {
@@ -7589,18 +7449,19 @@ static int md_getgeo(struct block_device *bdev, struct hd_geometry *geo)
 static inline int md_ioctl_valid(unsigned int cmd)
 {
 	switch (cmd) {
+	case GET_BITMAP_FILE:
+	case SET_BITMAP_FILE:
+		return -EOPNOTSUPP;
 	case GET_ARRAY_INFO:
 	case GET_DISK_INFO:
 	case RAID_VERSION:
 		return 0;
 	case ADD_NEW_DISK:
-	case GET_BITMAP_FILE:
 	case HOT_ADD_DISK:
 	case HOT_REMOVE_DISK:
 	case RESTART_ARRAY_RW:
 	case RUN_ARRAY:
 	case SET_ARRAY_INFO:
-	case SET_BITMAP_FILE:
 	case SET_DISK_FAULTY:
 	case STOP_ARRAY:
 	case STOP_ARRAY_RO:
@@ -7619,7 +7480,6 @@ static bool md_ioctl_need_suspend(unsigned int cmd)
 	case ADD_NEW_DISK:
 	case HOT_ADD_DISK:
 	case HOT_REMOVE_DISK:
-	case SET_BITMAP_FILE:
 	case SET_ARRAY_INFO:
 		return true;
 	default:
@@ -7699,9 +7559,6 @@ static int md_ioctl(struct block_device *bdev, blk_mode_t mode,
 
 	case SET_DISK_FAULTY:
 		return set_disk_faulty(mddev, new_decode_dev(arg));
-
-	case GET_BITMAP_FILE:
-		return get_bitmap_file(mddev, argp);
 	}
 
 	if (cmd == STOP_ARRAY || cmd == STOP_ARRAY_RO) {
@@ -7734,10 +7591,8 @@ static int md_ioctl(struct block_device *bdev, blk_mode_t mode,
 	 */
 	/* if we are not initialised yet, only ADD_NEW_DISK, STOP_ARRAY,
 	 * RUN_ARRAY, and GET_ and SET_BITMAP_FILE are allowed */
-	if ((!mddev->raid_disks && !mddev->external)
-	    && cmd != ADD_NEW_DISK && cmd != STOP_ARRAY
-	    && cmd != RUN_ARRAY && cmd != SET_BITMAP_FILE
-	    && cmd != GET_BITMAP_FILE) {
+	if (!mddev->raid_disks && !mddev->external && cmd != ADD_NEW_DISK &&
+	    cmd != STOP_ARRAY && cmd != RUN_ARRAY) {
 		err = -ENODEV;
 		goto unlock;
 	}
@@ -7833,10 +7688,6 @@ static int md_ioctl(struct block_device *bdev, blk_mode_t mode,
 		err = do_md_run(mddev);
 		goto unlock;
 
-	case SET_BITMAP_FILE:
-		err = set_bitmap_file(mddev, (int)arg);
-		goto unlock;
-
 	default:
 		err = -EINVAL;
 		goto unlock;
@@ -7855,6 +7706,7 @@ static int md_ioctl(struct block_device *bdev, blk_mode_t mode,
 		clear_bit(MD_CLOSING, &mddev->flags);
 	return err;
 }
+
 #ifdef CONFIG_COMPAT
 static int md_compat_ioctl(struct block_device *bdev, blk_mode_t mode,
 		    unsigned int cmd, unsigned long arg)
@@ -8328,11 +8180,6 @@ static void md_bitmap_status(struct seq_file *seq, struct mddev *mddev)
 		   chunk_kb ? chunk_kb : mddev->bitmap_info.chunksize,
 		   chunk_kb ? "KB" : "B");
 
-	if (stats.file) {
-		seq_puts(seq, ", file: ");
-		seq_file_path(seq, stats.file, " \t\n");
-	}
-
 	seq_putc(seq, '\n');
 }
 
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 4ba93af36126..bae257bc630c 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -360,6 +360,34 @@ enum {
 	MD_RESYNC_ACTIVE = 3,
 };
 
+struct bitmap_info {
+	/*
+	 * offset from superblock of start of bitmap. May be negative, but not
+	 * '0' For external metadata, offset from start of device.
+	 */
+	loff_t			offset;
+	/* space available at this offset */
+	unsigned long		space;
+	/*
+	 * this is the offset to use when hot-adding a bitmap.  It should
+	 * eventually be settable by sysfs.
+	 */
+	loff_t			default_offset;
+	/* space available at default offset */
+	unsigned long		default_space;
+	struct mutex		mutex;
+	unsigned long		chunksize;
+	/* how many jiffies between updates? */
+	unsigned long		daemon_sleep;
+	/* write-behind mode */
+	unsigned long		max_write_behind;
+	int			external;
+	/* Maximum number of nodes in the cluster */
+	int			nodes;
+	/* Name of the cluster */
+	char                    cluster_name[64];
+};
+
 struct mddev {
 	void				*private;
 	struct md_personality		*pers;
@@ -519,7 +547,6 @@ struct mddev {
 	 *   in_sync - and related safemode and MD_CHANGE changes
 	 *   pers (also protected by reconfig_mutex and pending IO).
 	 *   clearing ->bitmap
-	 *   clearing ->bitmap_info.file
 	 *   changing ->resync_{min,max}
 	 *   setting MD_RECOVERY_RUNNING (which interacts with resync_{min,max})
 	 */
@@ -537,29 +564,7 @@ struct mddev {
 
 	void				*bitmap; /* the bitmap for the device */
 	struct bitmap_operations	*bitmap_ops;
-	struct {
-		struct file		*file; /* the bitmap file */
-		loff_t			offset; /* offset from superblock of
-						 * start of bitmap. May be
-						 * negative, but not '0'
-						 * For external metadata, offset
-						 * from start of device.
-						 */
-		unsigned long		space; /* space available at this offset */
-		loff_t			default_offset; /* this is the offset to use when
-							 * hot-adding a bitmap.  It should
-							 * eventually be settable by sysfs.
-							 */
-		unsigned long		default_space; /* space available at
-							* default offset */
-		struct mutex		mutex;
-		unsigned long		chunksize;
-		unsigned long		daemon_sleep; /* how many jiffies between updates? */
-		unsigned long		max_write_behind; /* write-behind mode */
-		int			external;
-		int			nodes; /* Maximum number of nodes in the cluster */
-		char                    cluster_name[64]; /* Name of the cluster */
-	} bitmap_info;
+	struct bitmap_info		bitmap_info;
 
 	atomic_t			max_corr_read_errors; /* max read retries */
 	struct list_head		all_mddevs;
diff --git a/drivers/md/raid5-ppl.c b/drivers/md/raid5-ppl.c
index 37c4da5311ca..6a1c8d6e1849 100644
--- a/drivers/md/raid5-ppl.c
+++ b/drivers/md/raid5-ppl.c
@@ -1332,7 +1332,7 @@ int ppl_init_log(struct r5conf *conf)
 		return -EINVAL;
 	}
 
-	if (mddev->bitmap_info.file || mddev->bitmap_info.offset) {
+	if (mddev->bitmap_info.offset) {
 		pr_warn("md/raid:%s PPL is not compatible with bitmap\n",
 			mdname(mddev));
 		return -EINVAL;
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index f5ac81dd21b2..296501838a60 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -7811,7 +7811,7 @@ static int raid5_run(struct mddev *mddev)
 	}
 
 	if ((test_bit(MD_HAS_JOURNAL, &mddev->flags) || journal_dev) &&
-	    (mddev->bitmap_info.offset || mddev->bitmap_info.file)) {
+	    (mddev->bitmap_info.offset)) {
 		pr_notice("md/raid:%s: array cannot have both journal and bitmap\n",
 			  mdname(mddev));
 		return -EINVAL;
-- 
2.39.2

