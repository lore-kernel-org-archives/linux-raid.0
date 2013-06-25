From: Robin Dong <robin.k.dong@gmail.com>
Subject: [PATCH v1] md: add sync-bitmap to only resync WRITTEN data when adding new disk in raid array.
Date: Tue, 25 Jun 2013 16:51:36 +0800
Message-ID: <1372150297-31271-1-git-send-email-robin.k.dong@gmail.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Robin Dong <sanbai@taobao.com>, NeilBrown <neilb@suse.de>
List-Id: linux-raid.ids

From: Robin Dong <sanbai@taobao.com>

Add a new bitmap type named "sync-bitmap" for md, all the WRITTEN data will be
marked and when adding a new disk, the md will only resync WRITTEN data to
new disk therefore it will save a lot of time and reduce disk-durability.

We add the "sync-bitmap" behind the "write-intent-bitmap", not closely but
aligned to PAGE_SIZE:

|          page0                       |        page1                   |
+--------------------------------------+--------------------------------+
|bitmap_super and write-intent-bitmap  |         sync-bitmap            |

all the write-operation will set the bit in sync-bitmap.


TEST CASE:

	mdadm --create /dev/md1 --bitmap=internal --chunk=64 --level=1 --raid-devices=2 /dev/sdf missing --assume-clean
	mkfs.ext4 /dev/md1
	mount -t ext4 /dev/md1 /mnt/
	cp kernel.tgz /mnt/
	reboot
	mdadm --assemble /dev/md1 /dev/sdf
	mdadm --add /dev/md1 /dev/sdg
	echo offline > /sys/block/sdf/device/state
	mount -t ext4 /dev/md1 /mnt/ (mount success)
	cksum /mnt/kernel.tgz        (cksum ok)

TODO:

	* Allow "discard" to clear bit in sync-bitmap
	* More complicated test case on raid5

Signed-off-by: Robin Dong <sanbai@taobao.com>
Cc: NeilBrown <neilb@suse.de>
---
 drivers/md/bitmap.c            |  195 ++++++++++++++++++++++++++++++++++++++--
 drivers/md/bitmap.h            |    5 +
 drivers/md/md.c                |    7 ++-
 drivers/md/md.h                |    1 +
 drivers/md/raid1.c             |    7 ++
 drivers/md/raid5.c             |    7 ++
 include/uapi/linux/raid/md_p.h |    2 +
 7 files changed, 217 insertions(+), 7 deletions(-)

diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
index 5a2c754..86279e1 100644
--- a/drivers/md/bitmap.c
+++ b/drivers/md/bitmap.c
@@ -30,6 +30,13 @@
 #include "md.h"
 #include "bitmap.h"
 
+static inline sector_t syncbitmap_offset(struct bitmap *bitmap, sector_t block)
+{
+	return block +
+		(bitmap->syncbitmap_num_pages << bitmap->counts.chunkshift
+		 << PAGE_SHIFT << 3);
+}
+
 static inline char *bmname(struct bitmap *bitmap)
 {
 	return bitmap->mddev ? mdname(bitmap->mddev) : "mdX";
@@ -682,18 +689,40 @@ static inline struct page *filemap_get_page(struct bitmap_storage *store,
 			      - file_page_index(store, 0)];
 }
 
-static int bitmap_storage_alloc(struct bitmap_storage *store,
-				unsigned long chunks, int with_super)
+static void chunks_to_pages(unsigned long chunks, unsigned long *res_bytes,
+			unsigned long *res_pages, int with_super)
 {
-	int pnum;
-	unsigned long num_pages;
 	unsigned long bytes;
 
 	bytes = DIV_ROUND_UP(chunks, 8);
 	if (with_super)
 		bytes += sizeof(bitmap_super_t);
 
-	num_pages = DIV_ROUND_UP(bytes, PAGE_SIZE);
+	if (res_bytes)
+		*res_bytes = bytes;
+	if (res_pages)
+		*res_pages = DIV_ROUND_UP(bytes, PAGE_SIZE);
+}
+
+static int bitmap_storage_alloc(struct bitmap_storage *store,
+				unsigned long chunks, int with_super,
+				int with_sync_bitmap)
+{
+	int pnum;
+	unsigned long num_pages;
+	unsigned long bytes;
+	unsigned long syncbitmap_num_pages;
+
+	chunks_to_pages(chunks, &bytes, &num_pages, with_super);
+	/* we need two bitmaps: write-intent-bitmap and sync-bitmap, sync-bitmap
+	 * locates behind write-intent-bitmap closely. write-intent-bit maps
+	 * "this was written recently, a resync might be needed after a crash"
+	 * and the sync-bit maps "This has been written since array create,
+	 * so the chunk needs to be recovered to any spare".
+	 */
+	chunks_to_pages(chunks, NULL, &syncbitmap_num_pages, 0);
+	if (with_sync_bitmap)
+		num_pages += syncbitmap_num_pages;
 
 	store->filemap = kmalloc(sizeof(struct page *)
 				 * num_pages, GFP_KERNEL);
@@ -853,6 +882,41 @@ static void bitmap_file_set_bit(struct bitmap *bitmap, sector_t block)
 	set_page_attr(bitmap, page->index, BITMAP_PAGE_DIRTY);
 }
 
+static int syncbitmap_file_test_bit(struct bitmap *bitmap, sector_t block)
+{
+	unsigned long bit;
+	struct page *page;
+	void *kaddr;
+	unsigned long chunk;
+	int res;
+
+	chunk = syncbitmap_offset(bitmap, block) >> bitmap->counts.chunkshift;
+
+	page = filemap_get_page(&bitmap->storage, chunk);
+	if (!page)
+		return 1;
+	bit = file_page_offset(&bitmap->storage, chunk);
+
+	/* set the bit */
+	kaddr = kmap_atomic(page);
+	if (test_bit(BITMAP_HOSTENDIAN, &bitmap->flags))
+		res = test_bit(bit, kaddr);
+	else
+		res = test_bit_le(bit, kaddr);
+	kunmap_atomic(kaddr);
+	pr_debug("test syncbitmap bit %lu page %lu\n", bit, page->index);
+	return res;
+}
+
+/*
+ * syncbitmap_file_set_bit -- set the bit in sync-bitmap, just jump out
+ * the offset of write-intent-bitmap.
+ */
+static void syncbitmap_file_set_bit(struct bitmap *bitmap, sector_t block)
+{
+	bitmap_file_set_bit(bitmap, syncbitmap_offset(bitmap, block));
+}
+
 static void bitmap_file_clear_bit(struct bitmap *bitmap, sector_t block)
 {
 	unsigned long bit;
@@ -1038,6 +1102,61 @@ static int bitmap_init_from_disk(struct bitmap *bitmap, sector_t start)
 		offset = 0;
 	}
 
+	if (bitmap->mddev->bitmap_info.sync_bitmap) {
+		for (i = 0; i < chunks; i++) {
+			int b;
+			index = file_page_index(&bitmap->storage, i) +
+				bitmap->syncbitmap_num_pages;
+			bit = file_page_offset(&bitmap->storage, i);
+			if (index != oldindex) {
+				/* this is a new page, read it in */
+				page = store->filemap[index];
+				if (file)
+					ret = read_page(file, index, bitmap,
+							PAGE_SIZE, page);
+				else
+					ret = read_sb_page(
+						bitmap->mddev,
+						bitmap->mddev->bitmap_info.offset,
+						page,
+						index, PAGE_SIZE);
+				if (ret)
+					goto err;
+
+				oldindex = index;
+
+				if (outofdate) {
+					/*
+					 * if bitmap is out of date, dirty the
+					 * whole page and write it out
+					 */
+					paddr = kmap_atomic(page);
+					memset(paddr + offset, 0xff,
+						   PAGE_SIZE - offset);
+					kunmap_atomic(paddr);
+					write_page(bitmap, page, 1);
+
+					ret = -EIO;
+					if (test_bit(BITMAP_WRITE_ERROR,
+							 &bitmap->flags))
+						goto err;
+				}
+			}
+			paddr = kmap_atomic(page);
+			if (test_bit(BITMAP_HOSTENDIAN, &bitmap->flags))
+				b = test_bit(bit, paddr);
+			else
+				b = test_bit_le(bit, paddr);
+			kunmap_atomic(paddr);
+			if (b) {
+				/* if the disk bit is set, set the memory bit */
+				syncbitmap_file_set_bit(bitmap, (sector_t)i <<
+						bitmap->counts.chunkshift);
+				bit_cnt++;
+			}
+			offset = 0;
+		}
+	}
 	printk(KERN_INFO "%s: bitmap initialized from disk: "
 	       "read %lu pages, set %lu of %lu bits\n",
 	       bmname(bitmap), store->file_pages,
@@ -1303,6 +1422,7 @@ int bitmap_startwrite(struct bitmap *bitmap, sector_t offset, unsigned long sect
 			continue;
 		}
 
+		syncbitmap_file_set_bit(bitmap, offset);
 		switch (*bmc) {
 		case 0:
 			bitmap_file_set_bit(bitmap, offset);
@@ -1431,6 +1551,42 @@ int bitmap_start_sync(struct bitmap *bitmap, sector_t offset, sector_t *blocks,
 }
 EXPORT_SYMBOL(bitmap_start_sync);
 
+int __syncbitmap_start_sync(struct bitmap *bitmap, sector_t offset,
+						sector_t *blocks)
+{
+	int res;
+	unsigned long csize;
+	if (bitmap == NULL) {
+		*blocks = 1024;
+		return 1;
+	}
+
+	spin_lock_irq(&bitmap->counts.lock);
+	res = syncbitmap_file_test_bit(bitmap, offset);
+	if (res) {
+		csize = ((sector_t)1) << bitmap->counts.chunkshift;
+		*blocks = csize - (offset & (csize - 1));
+	}
+	spin_unlock_irq(&bitmap->counts.lock);
+	return res;
+}
+
+int syncbitmap_start_sync(struct bitmap *bitmap, sector_t offset,
+						sector_t *blocks)
+{
+	int rv = 0;
+	sector_t blocks1;
+
+	*blocks = 0;
+	while (*blocks < (PAGE_SIZE>>9)) {
+		rv |= __syncbitmap_start_sync(bitmap, offset, &blocks1);
+		offset += blocks1;
+		*blocks += blocks1;
+	}
+	return rv;
+}
+EXPORT_SYMBOL(syncbitmap_start_sync);
+
 void bitmap_end_sync(struct bitmap *bitmap, sector_t offset, sector_t *blocks, int aborted)
 {
 	bitmap_counter_t *bmc;
@@ -1805,6 +1961,7 @@ int bitmap_resize(struct bitmap *bitmap, sector_t blocks,
 	sector_t old_blocks, new_blocks;
 	int chunkshift;
 	int ret = 0;
+	unsigned long pnum, old_pnum, num_pages, old_num_pages;
 	long pages;
 	struct bitmap_page *new_bp;
 
@@ -1842,7 +1999,8 @@ int bitmap_resize(struct bitmap *bitmap, sector_t blocks,
 	memset(&store, 0, sizeof(store));
 	if (bitmap->mddev->bitmap_info.offset || bitmap->mddev->bitmap_info.file)
 		ret = bitmap_storage_alloc(&store, chunks,
-					   !bitmap->mddev->bitmap_info.external);
+				!bitmap->mddev->bitmap_info.external,
+				bitmap->mddev->bitmap_info.sync_bitmap);
 	if (ret)
 		goto err;
 
@@ -1865,6 +2023,31 @@ int bitmap_resize(struct bitmap *bitmap, sector_t blocks,
 		memcpy(page_address(store.sb_page),
 		       page_address(bitmap->storage.sb_page),
 		       sizeof(bitmap_super_t));
+	if (bitmap->mddev->bitmap_info.sync_bitmap) {
+		/* copy old sync-bitmap to new one */
+		chunks_to_pages(chunks, NULL, &pnum,
+					!bitmap->mddev->bitmap_info.external);
+		bitmap->syncbitmap_num_pages = pnum;
+		if (bitmap->storage.filemap) {
+			chunks_to_pages(bitmap->counts.chunks, NULL, &old_pnum,
+				!bitmap->mddev->bitmap_info.external);
+			num_pages = pnum * 2;
+			old_num_pages = old_pnum * 2;
+			pnum++;
+			old_pnum++;
+			for (; pnum <= num_pages && old_pnum <= old_num_pages;
+					pnum++, old_pnum++) {
+				memcpy(store.filemap[pnum],
+					bitmap->storage.filemap[old_pnum],
+					PAGE_SIZE);
+				/* All new sync-bitmap data
+				 * shoule be write out */
+				set_bit((pnum << 2) + BITMAP_PAGE_DIRTY,
+					store.filemap_attr);
+			}
+		}
+	}
+
 	bitmap_file_unmap(&bitmap->storage);
 	bitmap->storage = store;
 
diff --git a/drivers/md/bitmap.h b/drivers/md/bitmap.h
index df4aeb6..87c4686 100644
--- a/drivers/md/bitmap.h
+++ b/drivers/md/bitmap.h
@@ -226,6 +226,7 @@ struct bitmap {
 	wait_queue_head_t behind_wait;
 
 	struct sysfs_dirent *sysfs_can_clear;
+	unsigned long syncbitmap_num_pages;
 };
 
 /* the bitmap API */
@@ -252,6 +253,10 @@ void bitmap_endwrite(struct bitmap *bitmap, sector_t offset,
 			unsigned long sectors, int success, int behind);
 int bitmap_start_sync(struct bitmap *bitmap, sector_t offset, sector_t *blocks, int degraded);
 void bitmap_end_sync(struct bitmap *bitmap, sector_t offset, sector_t *blocks, int aborted);
+
+int syncbitmap_start_sync(struct bitmap *bitmap, sector_t offset,
+						sector_t *blocks);
+
 void bitmap_close_sync(struct bitmap *bitmap);
 void bitmap_cond_end_sync(struct bitmap *bitmap, sector_t sector);
 
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 681d109..fb81a01 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -1621,6 +1621,7 @@ static int super_1_validate(struct mddev *mddev, struct md_rdev *rdev)
 		mddev->events = ev1;
 		mddev->bitmap_info.offset = 0;
 		mddev->bitmap_info.space = 0;
+		mddev->bitmap_info.sync_bitmap = 0;
 		/* Default location for bitmap is 1K after superblock
 		 * using 3K - total of 4K
 		 */
@@ -1652,6 +1653,9 @@ static int super_1_validate(struct mddev *mddev, struct md_rdev *rdev)
 					-mddev->bitmap_info.offset;
 		}
 
+		if (le32_to_cpu(sb->feature_map) & MD_FEATURE_SYNCBITMAP)
+			mddev->bitmap_info.sync_bitmap = 1;
+
 		if ((le32_to_cpu(sb->feature_map) & MD_FEATURE_RESHAPE_ACTIVE)) {
 			mddev->reshape_position = le64_to_cpu(sb->reshape_position);
 			mddev->delta_disks = le32_to_cpu(sb->delta_disks);
@@ -1762,7 +1766,8 @@ static void super_1_sync(struct mddev *mddev, struct md_rdev *rdev)
 
 	if (mddev->bitmap && mddev->bitmap_info.file == NULL) {
 		sb->bitmap_offset = cpu_to_le32((__u32)mddev->bitmap_info.offset);
-		sb->feature_map = cpu_to_le32(MD_FEATURE_BITMAP_OFFSET);
+		sb->feature_map = cpu_to_le32(MD_FEATURE_BITMAP_OFFSET |
+					MD_FEATURE_SYNCBITMAP);
 	}
 
 	if (rdev->raid_disk >= 0 &&
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 653f992..1cef001 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -404,6 +404,7 @@ struct mddev {
 		unsigned long		daemon_sleep; /* how many jiffies between updates? */
 		unsigned long		max_write_behind; /* write-behind mode */
 		int			external;
+		int			sync_bitmap;
 	} bitmap_info;
 
 	atomic_t 			max_corr_read_errors; /* max read retries */
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 5595118..ba47ee7 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -2396,6 +2396,13 @@ static sector_t sync_request(struct mddev *mddev, sector_t sector_nr, int *skipp
 		*skipped = 1;
 		return sync_blocks;
 	}
+
+	if (conf->fullsync && !syncbitmap_start_sync(mddev->bitmap,
+				sector_nr, &sync_blocks)) {
+		*skipped = 1;
+		return sync_blocks;
+	}
+
 	/*
 	 * If there is non-resync activity waiting for a turn,
 	 * and resync is going fast enough,
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 9359828..7528aa8 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -4688,6 +4688,13 @@ static inline sector_t sync_request(struct mddev *mddev, sector_t sector_nr, int
 		return sync_blocks * STRIPE_SECTORS; /* keep things rounded to whole stripes */
 	}
 
+	if (conf->fullsync && sync_blocks >= STRIPE_SECTORS &&
+	    !syncbitmap_start_sync(mddev->bitmap, sector_nr, &sync_blocks)) {
+		sync_blocks /= STRIPE_SECTORS;
+		*skipped = 1;
+		return sync_blocks * STRIPE_SECTORS;
+	}
+
 	bitmap_cond_end_sync(mddev->bitmap, sector_nr);
 
 	sh = get_active_stripe(conf, sector_nr, 0, 1, 0);
diff --git a/include/uapi/linux/raid/md_p.h b/include/uapi/linux/raid/md_p.h
index fe1a540..7949f61 100644
--- a/include/uapi/linux/raid/md_p.h
+++ b/include/uapi/linux/raid/md_p.h
@@ -291,6 +291,7 @@ struct mdp_superblock_1 {
 					    * backwards anyway.
 					    */
 #define	MD_FEATURE_NEW_OFFSET		64 /* new_offset must be honoured */
+#define	MD_FEATURE_SYNCBITMAP		128
 #define	MD_FEATURE_ALL			(MD_FEATURE_BITMAP_OFFSET	\
 					|MD_FEATURE_RECOVERY_OFFSET	\
 					|MD_FEATURE_RESHAPE_ACTIVE	\
@@ -298,6 +299,7 @@ struct mdp_superblock_1 {
 					|MD_FEATURE_REPLACEMENT		\
 					|MD_FEATURE_RESHAPE_BACKWARDS	\
 					|MD_FEATURE_NEW_OFFSET		\
+					|MD_FEATURE_SYNCBITMAP		\
 					)
 
 #endif 
-- 
1.7.1

