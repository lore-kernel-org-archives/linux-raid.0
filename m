From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH md 12 of 12] Allow md intent bitmap to be stored near the superblock.
Date: Wed, 23 Mar 2005 16:47:11 +1100
Message-ID: <E1DDyhz-0004H6-RL@notabene.cse.unsw.edu.au>
References: <20050323164208.16240.patches@notabene>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


This provides an alternate to storing the bitmap in a separate file.
The bitmap can be stored at a given offset from the superblock.
Obviously the creator of the array must make sure this doesn't
intersect with data....
After is good for version-0.90 superblocks.

Signed-off-by: Neil Brown <neilb@cse.unsw.edu.au>
Only write bitmap to devices which are in-sync


Signed-off-by: Neil Brown <neilb@cse.unsw.edu.au>

### Diffstat output
 ./drivers/md/bitmap.c         |  132 +++++++++++++++++++++++++++++++++---------
 ./drivers/md/md.c             |   40 ++++++++++++
 ./include/linux/raid/bitmap.h |    2 
 ./include/linux/raid/md.h     |   15 ++++
 ./include/linux/raid/md_k.h   |    4 +
 ./include/linux/raid/md_p.h   |    7 +-
 6 files changed, 170 insertions(+), 30 deletions(-)

diff ./drivers/md/bitmap.c~current~ ./drivers/md/bitmap.c
--- ./drivers/md/bitmap.c~current~	2005-03-23 16:18:51.000000000 +1100
+++ ./drivers/md/bitmap.c	2005-03-23 16:29:56.000000000 +1100
@@ -116,7 +116,7 @@ static unsigned char *bitmap_alloc_page(
 	if (!page)
 		printk("%s: bitmap_alloc_page FAILED\n", bmname(bitmap));
 	else
-		printk("%s: bitmap_alloc_page: allocated page at %p\n",
+		PRINTK("%s: bitmap_alloc_page: allocated page at %p\n",
 			bmname(bitmap), page);
 	return page;
 }
@@ -258,13 +258,61 @@ char *file_path(struct file *file, char 
  * basic page I/O operations
  */
 
+/* IO operations when bitmap is stored near all superblocks */
+static struct page *read_sb_page(mddev_t *mddev, long offset, unsigned long index)
+{
+	/* choose a good rdev and read the page from there */
+
+	mdk_rdev_t *rdev;
+	struct list_head *tmp;
+	struct page *page = alloc_page(GFP_KERNEL);
+	sector_t target;
+
+	if (!page)
+		return ERR_PTR(-ENOMEM);
+	do {
+		ITERATE_RDEV(mddev, rdev, tmp)
+			if (rdev->in_sync && !rdev->faulty)
+				goto found;
+		return ERR_PTR(-EIO);
+
+	found:
+		target = (rdev->sb_offset << 1) + offset + index * (PAGE_SIZE/512);
+
+	} while (!sync_page_io(rdev->bdev, target, PAGE_SIZE, page, READ));
+
+	page->index = index;
+	return page;
+}
+
+static int write_sb_page(mddev_t *mddev, long offset, struct page *page, int wait)
+{
+	mdk_rdev_t *rdev;
+	struct list_head *tmp;
+
+	ITERATE_RDEV(mddev, rdev, tmp) 
+		if (rdev->in_sync && !rdev->faulty)
+			md_super_write(mddev, rdev, 
+				       (rdev->sb_offset<<1) + offset
+				       + page->index * (PAGE_SIZE/512),
+				       PAGE_SIZE,
+				       page);
+
+	if (wait)
+		wait_event(mddev->sb_wait, atomic_read(&mddev->pending_writes)==0);
+	return 0;
+}
+
 /*
- * write out a page
+ * write out a page to a file
  */
 static int write_page(struct bitmap *bitmap, struct page *page, int wait)
 {
 	int ret = -ENOMEM;
 
+	if (bitmap->file == NULL)
+		return write_sb_page(bitmap->mddev, bitmap->offset, page, wait);
+
 	lock_page(page);
 
 	ret = page->mapping->a_ops->prepare_write(NULL, page, 0, PAGE_SIZE);
@@ -394,7 +442,12 @@ static int bitmap_read_sb(struct bitmap 
 	int err = -EINVAL;
 
 	/* page 0 is the superblock, read it... */
-	bitmap->sb_page = read_page(bitmap->file, 0, &bytes_read);
+	if (bitmap->file)
+		bitmap->sb_page = read_page(bitmap->file, 0, &bytes_read);
+	else {
+		bitmap->sb_page = read_sb_page(bitmap->mddev, bitmap->offset, 0);
+		bytes_read = PAGE_SIZE;
+	}
 	if (IS_ERR(bitmap->sb_page)) {
 		err = PTR_ERR(bitmap->sb_page);
 		bitmap->sb_page = NULL;
@@ -625,14 +678,16 @@ static void bitmap_file_kick(struct bitm
 	bitmap_mask_state(bitmap, BITMAP_STALE, MASK_SET);
 	bitmap_update_sb(bitmap);
 
-	path = kmalloc(PAGE_SIZE, GFP_KERNEL);
-	if (path)
-		ptr = file_path(bitmap->file, path, PAGE_SIZE);
+	if (bitmap->file) {
+		path = kmalloc(PAGE_SIZE, GFP_KERNEL);
+		if (path)
+			ptr = file_path(bitmap->file, path, PAGE_SIZE);
 
-	printk(KERN_ALERT "%s: kicking failed bitmap file %s from array!\n",
-		bmname(bitmap), ptr ? ptr : "");
+		printk(KERN_ALERT "%s: kicking failed bitmap file %s from array!\n",
+		       bmname(bitmap), ptr ? ptr : "");
 
-	kfree(path);
+		kfree(path);
+	}
 
 	bitmap_file_put(bitmap);
 
@@ -676,7 +731,7 @@ static void bitmap_file_set_bit(struct b
 	void *kaddr;
 	unsigned long chunk = block >> CHUNK_BLOCK_SHIFT(bitmap);
 
-	if (!bitmap->file || !bitmap->filemap) {
+	if (!bitmap->filemap) {
 		return;
 	}
 
@@ -715,7 +770,7 @@ int bitmap_unplug(struct bitmap *bitmap)
 	 * flushed out to disk */
 	for (i = 0; i < bitmap->file_pages; i++) {
 		spin_lock_irqsave(&bitmap->lock, flags);
-		if (!bitmap->file || !bitmap->filemap) {
+		if (!bitmap->filemap) {
 			spin_unlock_irqrestore(&bitmap->lock, flags);
 			return 0;
 		}
@@ -732,11 +787,15 @@ int bitmap_unplug(struct bitmap *bitmap)
 				return 1;
 	}
 	if (wait) { /* if any writes were performed, we need to wait on them */
-		spin_lock_irq(&bitmap->write_lock);
-		wait_event_lock_irq(bitmap->write_wait,
-			list_empty(&bitmap->complete_pages), bitmap->write_lock,
-			wake_up_process(bitmap->writeback_daemon->tsk));
-		spin_unlock_irq(&bitmap->write_lock);
+		if (bitmap->file) {
+			spin_lock_irq(&bitmap->write_lock);
+			wait_event_lock_irq(bitmap->write_wait,
+					    list_empty(&bitmap->complete_pages), bitmap->write_lock,
+					    wake_up_process(bitmap->writeback_daemon->tsk));
+			spin_unlock_irq(&bitmap->write_lock);
+		} else
+			wait_event(bitmap->mddev->sb_wait,
+				   atomic_read(&bitmap->mddev->pending_writes)==0);
 	}
 	return 0;
 }
@@ -764,7 +823,7 @@ static int bitmap_init_from_disk(struct 
 	chunks = bitmap->chunks;
 	file = bitmap->file;
 
-	BUG_ON(!file);
+	BUG_ON(!file && !bitmap->offset);
 
 #if INJECT_FAULTS_3
 	outofdate = 1;
@@ -779,7 +838,7 @@ static int bitmap_init_from_disk(struct 
 
 	num_pages = (bytes + sizeof(bitmap_super_t) + PAGE_SIZE - 1) / PAGE_SIZE;
 
-	if (i_size_read(file->f_mapping->host) < bytes + sizeof(bitmap_super_t)) {
+	if (file && i_size_read(file->f_mapping->host) < bytes + sizeof(bitmap_super_t)) {
 		printk(KERN_INFO "%s: bitmap file too short %lu < %lu\n",
 			bmname(bitmap),
 			(unsigned long) i_size_read(file->f_mapping->host),
@@ -816,14 +875,18 @@ static int bitmap_init_from_disk(struct 
 				 */
 				page = bitmap->sb_page;
 				offset = sizeof(bitmap_super_t);
-			} else {
+			} else if (file) {
 				page = read_page(file, index, &dummy);
-				if (IS_ERR(page)) { /* read error */
-					ret = PTR_ERR(page);
-					goto out;
-				}
 				offset = 0;
+			} else {
+				page = read_sb_page(bitmap->mddev, bitmap->offset, index);
+				offset = 0;
+			}
+			if (IS_ERR(page)) { /* read error */
+				ret = PTR_ERR(page);
+				goto out;
 			}
+
 			oldindex = index;
 			oldpage = page;
 			kmap(page);
@@ -874,6 +937,19 @@ out:
 	return ret;
 }
 
+void bitmap_write_all(struct bitmap *bitmap)
+{
+	/* We don't actually write all bitmap blocks here,
+	 * just flag them as needing to be written
+	 */
+
+	unsigned long chunks = bitmap->chunks;
+	unsigned long bytes = (chunks+7)/8 + sizeof(bitmap_super_t);
+	unsigned long num_pages = (bytes + PAGE_SIZE-1) / PAGE_SIZE;
+	while (num_pages--)
+		bitmap->filemap_attr[num_pages] |= BITMAP_PAGE_NEEDWRITE;
+}
+
 
 static void bitmap_count_page(struct bitmap *bitmap, sector_t offset, int inc)
 {
@@ -913,7 +989,7 @@ int bitmap_daemon_work(struct bitmap *bi
 	for (j = 0; j < bitmap->chunks; j++) {
 		bitmap_counter_t *bmc;
 		spin_lock_irqsave(&bitmap->lock, flags);
-		if (!bitmap->file || !bitmap->filemap) {
+		if (!bitmap->filemap) {
 			/* error or shutdown */
 			spin_unlock_irqrestore(&bitmap->lock, flags);
 			break;
@@ -1072,6 +1148,7 @@ static int bitmap_start_daemon(struct bi
 
 	spin_lock_irqsave(&bitmap->lock, flags);
 	*ptr = NULL;
+
 	if (!bitmap->file) /* no need for daemon if there's no backing file */
 		goto out_unlock;
 
@@ -1416,9 +1493,11 @@ int bitmap_create(mddev_t *mddev)
 
 	BUG_ON(sizeof(bitmap_super_t) != 256);
 
-	if (!file) /* bitmap disabled, nothing to do */
+	if (!file && !mddev->bitmap_offset) /* bitmap disabled, nothing to do */
 		return 0;
 
+	BUG_ON(file && mddev->bitmap_offset);
+
 	bitmap = kmalloc(sizeof(*bitmap), GFP_KERNEL);
 	if (!bitmap)
 		return -ENOMEM;
@@ -1438,7 +1517,8 @@ int bitmap_create(mddev_t *mddev)
 		return -ENOMEM;
 
 	bitmap->file = file;
-	get_file(file);
+	bitmap->offset = mddev->bitmap_offset;
+	if (file) get_file(file);
 	/* read superblock from bitmap file (this sets bitmap->chunksize) */
 	err = bitmap_read_sb(bitmap);
 	if (err)

diff ./drivers/md/md.c~current~ ./drivers/md/md.c
--- ./drivers/md/md.c~current~	2005-03-23 16:18:51.000000000 +1100
+++ ./drivers/md/md.c	2005-03-23 16:21:14.000000000 +1100
@@ -371,7 +371,7 @@ static int bi_complete(struct bio *bio, 
 	return 0;
 }
 
-static int sync_page_io(struct block_device *bdev, sector_t sector, int size,
+int sync_page_io(struct block_device *bdev, sector_t sector, int size,
 		   struct page *page, int rw)
 {
 	struct bio *bio = bio_alloc(GFP_KERNEL, 1);
@@ -643,6 +643,17 @@ static int super_90_validate(mddev_t *md
 		memcpy(mddev->uuid+12,&sb->set_uuid3, 4);
 
 		mddev->max_disks = MD_SB_DISKS;
+
+		if (sb->state & (1<<MD_SB_BITMAP_PRESENT) && 
+		    mddev->bitmap_file == NULL) {
+			if (mddev->level != 1) {
+				/* FIXME use a better test */
+				printk(KERN_WARNING "md: bitmaps only support for raid1\n");
+				return -EINVAL;
+			}
+			mddev->bitmap_offset = (MD_SB_BYTES >> 9);
+		}
+
 	} else if (mddev->pers == NULL) {
 		/* Insist on good event counter while assembling */
 		__u64 ev1 = md_event(sb);
@@ -736,6 +747,9 @@ static void super_90_sync(mddev_t *mddev
 	sb->layout = mddev->layout;
 	sb->chunk_size = mddev->chunk_size;
 
+	if (mddev->bitmap && mddev->bitmap_file == NULL)
+		sb->state |= (1<<MD_SB_BITMAP_PRESENT);
+
 	sb->disks[0].state = (1<<MD_DISK_REMOVED);
 	ITERATE_RDEV(mddev,rdev2,tmp) {
 		mdp_disk_t *d;
@@ -932,6 +946,15 @@ static int super_1_validate(mddev_t *mdd
 		memcpy(mddev->uuid, sb->set_uuid, 16);
 
 		mddev->max_disks =  (4096-256)/2;
+
+		if ((le32_to_cpu(sb->feature_map) & 1) &&
+		    mddev->bitmap_file == NULL ) {
+			if (mddev->level != 1) {
+				printk(KERN_WARNING "md: bitmaps only supported for raid1\n");
+				return -EINVAL;
+			}
+			mddev->bitmap_offset = (__s32)le32_to_cpu(sb->bitmap_offset);
+		}
 	} else if (mddev->pers == NULL) {
 		/* Insist of good event counter while assembling */
 		__u64 ev1 = le64_to_cpu(sb->events);
@@ -994,6 +1017,11 @@ static void super_1_sync(mddev_t *mddev,
 	else
 		sb->resync_offset = cpu_to_le64(0);
 
+	if (mddev->bitmap && mddev->bitmap_file == NULL) {
+		sb->bitmap_offset = cpu_to_le32((__u32)mddev->bitmap_offset);
+		sb->feature_map = cpu_to_le32(1);
+	}
+
 	max_dev = 0;
 	ITERATE_RDEV(mddev,rdev2,tmp)
 		if (rdev2->desc_nr+1 > max_dev)
@@ -2426,7 +2454,8 @@ static int set_bitmap_file(mddev_t *mdde
 			mdname(mddev));
 		fput(mddev->bitmap_file);
 		mddev->bitmap_file = NULL;
-	}
+	} else
+		mddev->bitmap_offset = 0; /* file overrides offset */
 	return err;
 }
 
@@ -3801,6 +3830,13 @@ void md_check_recovery(mddev_t *mddev)
 			set_bit(MD_RECOVERY_RUNNING, &mddev->recovery);
 			if (!spares)
 				set_bit(MD_RECOVERY_SYNC, &mddev->recovery);
+			if (spares && mddev->bitmap && ! mddev->bitmap->file) {
+				/* We are adding a device or devices to an array 
+				 * which has the bitmap stored on all devices.
+				 * So make sure all bitmap pages get written
+				 */
+				bitmap_write_all(mddev->bitmap);
+			}
 			mddev->sync_thread = md_register_thread(md_do_sync,
 								mddev,
 								"%s_resync");

diff ./include/linux/raid/bitmap.h~current~ ./include/linux/raid/bitmap.h
--- ./include/linux/raid/bitmap.h~current~	2005-03-23 16:18:51.000000000 +1100
+++ ./include/linux/raid/bitmap.h	2005-03-23 16:26:00.000000000 +1100
@@ -217,6 +217,7 @@ struct bitmap {
 	/* bitmap spinlock */
 	spinlock_t lock;
 
+	long offset; /* offset from superblock if file is NULL */
 	struct file *file; /* backing disk file */
 	struct page *sb_page; /* cached copy of the bitmap file superblock */
 	struct page **filemap; /* list of cache pages for the file */
@@ -255,6 +256,7 @@ void bitmap_print_sb(struct bitmap *bitm
 int bitmap_update_sb(struct bitmap *bitmap);
 
 int  bitmap_setallbits(struct bitmap *bitmap);
+void bitmap_write_all(struct bitmap *bitmap);
 
 /* these are exported */
 int bitmap_startwrite(struct bitmap *bitmap, sector_t offset, unsigned long sectors);

diff ./include/linux/raid/md.h~current~ ./include/linux/raid/md.h
--- ./include/linux/raid/md.h~current~	2005-03-23 16:18:51.000000000 +1100
+++ ./include/linux/raid/md.h	2005-03-22 17:32:05.000000000 +1100
@@ -60,7 +60,14 @@
  */
 #define MD_MAJOR_VERSION                0
 #define MD_MINOR_VERSION                90
-#define MD_PATCHLEVEL_VERSION           1
+/*
+ * MD_PATCHLEVEL_VERSION indicates kernel functionality.
+ * >=1 means different superblock formats are selectable using SET_ARRAY_INFO
+ *     and major_version/minor_version accordingly
+ * >=2 means that Internal bitmaps are supported by setting MD_SB_BITMAP_PRESENT
+ *     in the super status byte
+ */
+#define MD_PATCHLEVEL_VERSION           2
 
 extern int register_md_personality (int p_num, mdk_personality_t *p);
 extern int unregister_md_personality (int p_num);
@@ -78,6 +85,12 @@ extern void md_unplug_mddev(mddev_t *mdd
 
 extern void md_print_devices (void);
 
+extern void md_super_write(mddev_t *mddev, mdk_rdev_t *rdev,
+			   sector_t sector, int size, struct page *page);
+extern int sync_page_io(struct block_device *bdev, sector_t sector, int size,
+			struct page *page, int rw);
+
+
 #define MD_BUG(x...) { printk("md: bug in file %s, line %d\n", __FILE__, __LINE__); md_print_devices(); }
 
 #endif 

diff ./include/linux/raid/md_k.h~current~ ./include/linux/raid/md_k.h
--- ./include/linux/raid/md_k.h~current~	2005-03-23 16:18:51.000000000 +1100
+++ ./include/linux/raid/md_k.h	2005-03-22 17:32:05.000000000 +1100
@@ -274,6 +274,10 @@ struct mddev_s
 
 	struct bitmap                   *bitmap; /* the bitmap for the device */
 	struct file			*bitmap_file; /* the bitmap file */
+	long				bitmap_offset; /* offset from superblock of
+							* start of bitmap. May be 
+							* negative, but not '0'
+							*/
 
 	struct list_head		all_mddevs;
 };

diff ./include/linux/raid/md_p.h~current~ ./include/linux/raid/md_p.h
--- ./include/linux/raid/md_p.h~current~	2005-03-23 16:18:51.000000000 +1100
+++ ./include/linux/raid/md_p.h	2005-03-22 17:32:05.000000000 +1100
@@ -96,6 +96,7 @@ typedef struct mdp_device_descriptor_s {
 #define MD_SB_CLEAN		0
 #define MD_SB_ERRORS		1
 
+#define	MD_SB_BITMAP_PRESENT	8 /* bitmap may be present nearby */
 typedef struct mdp_superblock_s {
 	/*
 	 * Constant generic information
@@ -184,7 +185,7 @@ struct mdp_superblock_1 {
 	/* constant array information - 128 bytes */
 	__u32	magic;		/* MD_SB_MAGIC: 0xa92b4efc - little endian */
 	__u32	major_version;	/* 1 */
-	__u32	feature_map;	/* 0 for now */
+	__u32	feature_map;	/* bit 0 set if 'bitmap_offset' is meaningful */
 	__u32	pad0;		/* always set to 0 when writing */
 
 	__u8	set_uuid[16];	/* user-space generated. */
@@ -197,6 +198,10 @@ struct mdp_superblock_1 {
 
 	__u32	chunksize;	/* in 512byte sectors */
 	__u32	raid_disks;
+	__u32	bitmap_offset;	/* sectors after start of superblock that bitmap starts
+				 * NOTE: signed, so bitmap can be before superblock
+				 * only meaningful of feature_map[0] is set.
+				 */
 	__u8	pad1[128-96];	/* set to 0 when written */
 
 	/* constant this-device information - 64 bytes */
