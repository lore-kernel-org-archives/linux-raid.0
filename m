From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Subject: [PATCH 09/24] Use separate bitmaps for each nodes in the cluster
Date: Thu, 18 Dec 2014 10:16:56 -0600
Message-ID: <20141218161656.GA29610@shrek.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: lzhong@suse.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On-disk format:

0                    4k                     8k                    12k
-------------------------------------------------------------------
| idle                | md super            | bm super [0] + bits |
| bm bits[0, contd]   | bm super[1] + bits  | bm bits[1, contd]   |
| bm super[2] + bits  | bm bits [2, contd]  | bm super[3] + bits  |
| bm bits [3, contd]  |                     |                     |

Bitmap super has a field nodes, which defines the maximum number
of nodes the device can use. While reading the bitmap super, if
the cluster finds out that the number of nodes is > 0:
1. Requests the md-cluster module.
2. Calls md_cluster_ops->join(), which sets up clustering such as
   joining DLM lockspace.

Since the first time, the first bitmap is read. After the call
to the cluster_setup, the bitmap offset is adjusted and the
superblock is re-read. This also ensures the bitmap is read
the bitmap lock (when bitmap lock is introduced in later patches)

Questions:
1. cluster name is repeated in all bitmap supers. Is that okay?

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
---
 drivers/md/bitmap.c     | 68 ++++++++++++++++++++++++++++++++++++++++---------
 drivers/md/bitmap.h     |  1 +
 drivers/md/md-cluster.c |  7 +++++
 drivers/md/md-cluster.h |  1 -
 4 files changed, 64 insertions(+), 13 deletions(-)

diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
index f4df37c..23a71a7 100644
--- a/drivers/md/bitmap.c
+++ b/drivers/md/bitmap.c
@@ -192,6 +192,10 @@ static int write_sb_page(struct bitmap *bitmap, struct page *page, int wait)
 	struct block_device *bdev;
 	struct mddev *mddev = bitmap->mddev;
 	struct bitmap_storage *store = &bitmap->storage;
+	int node_offset = 0;
+
+	if (mddev_is_clustered(bitmap->mddev))
+		node_offset = bitmap->cluster_slot * store->file_pages;
 
 	while ((rdev = next_active_rdev(rdev, mddev)) != NULL) {
 		int size = PAGE_SIZE;
@@ -536,6 +540,7 @@ static int bitmap_read_sb(struct bitmap *bitmap)
 	unsigned long sectors_reserved = 0;
 	int err = -EINVAL;
 	struct page *sb_page;
+	int cluster_setup_done = 0;
 
 	if (!bitmap->storage.file && !bitmap->mddev->bitmap_info.offset) {
 		chunksize = 128 * 1024 * 1024;
@@ -551,6 +556,7 @@ static int bitmap_read_sb(struct bitmap *bitmap)
 		return -ENOMEM;
 	bitmap->storage.sb_page = sb_page;
 
+re_read:
 	if (bitmap->storage.file) {
 		loff_t isize = i_size_read(bitmap->storage.file->f_mapping->host);
 		int bytes = isize > PAGE_SIZE ? PAGE_SIZE : isize;
@@ -566,6 +572,7 @@ static int bitmap_read_sb(struct bitmap *bitmap)
 	if (err)
 		return err;
 
+	err = -EINVAL;
 	sb = kmap_atomic(sb_page);
 
 	chunksize = le32_to_cpu(sb->chunksize);
@@ -573,6 +580,7 @@ static int bitmap_read_sb(struct bitmap *bitmap)
 	write_behind = le32_to_cpu(sb->write_behind);
 	sectors_reserved = le32_to_cpu(sb->sectors_reserved);
 	nodes = le32_to_cpu(sb->nodes);
+	strlcpy(bitmap->mddev->bitmap_info.cluster_name, sb->cluster_name, 64);
 
 	/* verify that the bitmap-specific fields are valid */
 	if (sb->magic != cpu_to_le32(BITMAP_MAGIC))
@@ -609,7 +617,7 @@ static int bitmap_read_sb(struct bitmap *bitmap)
 			goto out;
 		}
 		events = le64_to_cpu(sb->events);
-		if (events < bitmap->mddev->events) {
+		if (!nodes && (events < bitmap->mddev->events)) {
 			printk(KERN_INFO
 			       "%s: bitmap file is out of date (%llu < %llu) "
 			       "-- forcing full recovery\n",
@@ -626,8 +634,32 @@ static int bitmap_read_sb(struct bitmap *bitmap)
 	bitmap->events_cleared = le64_to_cpu(sb->events_cleared);
 	strlcpy(bitmap->mddev->bitmap_info.cluster_name, sb->cluster_name, 64);
 	err = 0;
+
 out:
 	kunmap_atomic(sb);
+	if (nodes && !cluster_setup_done) {
+		sector_t bm_blocks = sector_div(bitmap->mddev->resync_max_sectors,(chunksize >> 9));
+		bm_blocks = bm_blocks << 3;
+		/* We have bitmap supers at 4k boundaries, hence this
+		 * is hardcoded */
+		bm_blocks = DIV_ROUND_UP(bm_blocks, 4096);
+		err = md_setup_cluster(bitmap->mddev, nodes);
+		if (err) {
+			pr_err("%s: Could not setup cluster service (%d)\n",
+					bmname(bitmap), err);
+			goto out_no_sb;
+		}
+		bitmap->cluster_slot = md_cluster_ops->slot_number(bitmap->mddev);
+		bitmap->mddev->bitmap_info.offset +=
+			bitmap->cluster_slot * (bm_blocks << 3);
+		printk("%s:%d bm slot: %d offset: %llu\n", __func__, __LINE__,
+			bitmap->cluster_slot,
+			(unsigned long long)bitmap->mddev->bitmap_info.offset);
+		cluster_setup_done = 1;
+		goto re_read;
+	}
+
+
 out_no_sb:
 	if (test_bit(BITMAP_STALE, &bitmap->flags))
 		bitmap->events_cleared = bitmap->mddev->events;
@@ -638,8 +670,11 @@ out_no_sb:
 	if (bitmap->mddev->bitmap_info.space == 0 ||
 	    bitmap->mddev->bitmap_info.space > sectors_reserved)
 		bitmap->mddev->bitmap_info.space = sectors_reserved;
-	if (err)
+	if (err) {
 		bitmap_print_sb(bitmap);
+		if (cluster_setup_done)
+			md_cluster_stop(bitmap->mddev);
+	}
 	return err;
 }
 
@@ -683,14 +718,14 @@ static inline struct page *filemap_get_page(struct bitmap_storage *store,
 {
 	if (file_page_index(store, chunk) >= store->file_pages)
 		return NULL;
-	return store->filemap[file_page_index(store, chunk)
-			      - file_page_index(store, 0)];
+	return store->filemap[file_page_index(store, chunk)];
 }
 
 static int bitmap_storage_alloc(struct bitmap_storage *store,
-				unsigned long chunks, int with_super)
+				unsigned long chunks, int with_super,
+				int slot_number)
 {
-	int pnum;
+	int pnum, offset = 0;
 	unsigned long num_pages;
 	unsigned long bytes;
 
@@ -699,6 +734,7 @@ static int bitmap_storage_alloc(struct bitmap_storage *store,
 		bytes += sizeof(bitmap_super_t);
 
 	num_pages = DIV_ROUND_UP(bytes, PAGE_SIZE);
+	offset = slot_number * (num_pages - 1);
 
 	store->filemap = kmalloc(sizeof(struct page *)
 				 * num_pages, GFP_KERNEL);
@@ -709,20 +745,22 @@ static int bitmap_storage_alloc(struct bitmap_storage *store,
 		store->sb_page = alloc_page(GFP_KERNEL|__GFP_ZERO);
 		if (store->sb_page == NULL)
 			return -ENOMEM;
-		store->sb_page->index = 0;
 	}
+
 	pnum = 0;
 	if (store->sb_page) {
 		store->filemap[0] = store->sb_page;
 		pnum = 1;
+		store->sb_page->index = offset;
 	}
+
 	for ( ; pnum < num_pages; pnum++) {
 		store->filemap[pnum] = alloc_page(GFP_KERNEL|__GFP_ZERO);
 		if (!store->filemap[pnum]) {
 			store->file_pages = pnum;
 			return -ENOMEM;
 		}
-		store->filemap[pnum]->index = pnum;
+		store->filemap[pnum]->index = pnum + offset;
 	}
 	store->file_pages = pnum;
 
@@ -935,7 +973,7 @@ static void bitmap_set_memory_bits(struct bitmap *bitmap, sector_t offset, int n
  */
 static int bitmap_init_from_disk(struct bitmap *bitmap, sector_t start)
 {
-	unsigned long i, chunks, index, oldindex, bit;
+	unsigned long i, chunks, index, oldindex, bit, node_offset = 0;
 	struct page *page = NULL;
 	unsigned long bit_cnt = 0;
 	struct file *file;
@@ -981,6 +1019,9 @@ static int bitmap_init_from_disk(struct bitmap *bitmap, sector_t start)
 	if (!bitmap->mddev->bitmap_info.external)
 		offset = sizeof(bitmap_super_t);
 
+	if (mddev_is_clustered(bitmap->mddev))
+		node_offset = bitmap->cluster_slot * (DIV_ROUND_UP(store->bytes, PAGE_SIZE));
+
 	for (i = 0; i < chunks; i++) {
 		int b;
 		index = file_page_index(&bitmap->storage, i);
@@ -1001,7 +1042,7 @@ static int bitmap_init_from_disk(struct bitmap *bitmap, sector_t start)
 					bitmap->mddev,
 					bitmap->mddev->bitmap_info.offset,
 					page,
-					index, count);
+					index + node_offset, count);
 
 			if (ret)
 				goto err;
@@ -1207,7 +1248,6 @@ void bitmap_daemon_work(struct mddev *mddev)
 	     j < bitmap->storage.file_pages
 		     && !test_bit(BITMAP_STALE, &bitmap->flags);
 	     j++) {
-
 		if (test_page_attr(bitmap, j,
 				   BITMAP_PAGE_DIRTY))
 			/* bitmap_unplug will handle the rest */
@@ -1591,6 +1631,9 @@ static void bitmap_free(struct bitmap *bitmap)
 	if (!bitmap) /* there was no bitmap */
 		return;
 
+	if (mddev_is_clustered(bitmap->mddev) && bitmap->mddev->cluster_info)
+		md_cluster_stop(bitmap->mddev);
+
 	/* Shouldn't be needed - but just in case.... */
 	wait_event(bitmap->write_wait,
 		   atomic_read(&bitmap->pending_writes) == 0);
@@ -1847,7 +1890,8 @@ int bitmap_resize(struct bitmap *bitmap, sector_t blocks,
 	memset(&store, 0, sizeof(store));
 	if (bitmap->mddev->bitmap_info.offset || bitmap->mddev->bitmap_info.file)
 		ret = bitmap_storage_alloc(&store, chunks,
-					   !bitmap->mddev->bitmap_info.external);
+					   !bitmap->mddev->bitmap_info.external,
+					   bitmap->cluster_slot);
 	if (ret)
 		goto err;
 
diff --git a/drivers/md/bitmap.h b/drivers/md/bitmap.h
index 49163b6..2e0f540 100644
--- a/drivers/md/bitmap.h
+++ b/drivers/md/bitmap.h
@@ -227,6 +227,7 @@ struct bitmap {
 	wait_queue_head_t behind_wait;
 
 	struct kernfs_node *sysfs_can_clear;
+	int cluster_slot;		/* Slot offset for clustered env */
 };
 
 /* the bitmap API */
diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
index 98e45e1..43b3cda 100644
--- a/drivers/md/md-cluster.c
+++ b/drivers/md/md-cluster.c
@@ -199,6 +199,13 @@ static int join(struct mddev *mddev, int nodes)
 	if (ret)
 		goto err;
 	wait_for_completion(&cinfo->completion);
+	if (nodes <= cinfo->slot_number) {
+		pr_err("md-cluster: Slot allotted(%d) greater than"
+			"available slots(%d)", cinfo->slot_number - 1,
+			nodes);
+		ret = -ERANGE;
+		goto err;
+	}
 	cinfo->sb_lock = lockres_init(mddev, "cmd-super",
 					NULL, 0);
 	if (!cinfo->sb_lock) {
diff --git a/drivers/md/md-cluster.h b/drivers/md/md-cluster.h
index d9a1d88..52a21e0 100644
--- a/drivers/md/md-cluster.h
+++ b/drivers/md/md-cluster.h
@@ -11,7 +11,6 @@ struct md_cluster_operations {
 	int (*join)(struct mddev *mddev, int nodes);
 	int (*leave)(struct mddev *mddev);
 	int (*slot_number)(struct mddev *mddev);
-
 };
 
 #endif /* _MD_CLUSTER_H */
-- 
2.1.2

