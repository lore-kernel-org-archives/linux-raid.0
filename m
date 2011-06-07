From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH 7 of 8] MD:  add bitmap support
Date: Tue, 07 Jun 2011 17:52:39 -0500
Message-ID: <1307487159.31279.17.camel@f14.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Add bitmap support to the device-mapper specific metadata area.

This patch allows the creation of the bitmap metadata area upon initial array
creation via device-mapper.

Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>

Index: linux-2.6/drivers/md/bitmap.c
===================================================================
--- linux-2.6.orig/drivers/md/bitmap.c
+++ linux-2.6/drivers/md/bitmap.c
@@ -534,6 +534,84 @@ void bitmap_print_sb(struct bitmap *bitm
 	kunmap_atomic(sb, KM_USER0);
 }
 
+/*
+ * bitmap_new_disk_sb
+ * @bitmap
+ *
+ * This function is somewhat the reverse of bitmap_read_sb.  bitmap_read_sb
+ * reads and verifies the on-disk bitmap superblock and populates bitmap_info.
+ * This function verifies 'bitmap_info' and populates the on-disk bitmap
+ * structure, which is to be written to disk.
+ *
+ * Returns: 0 on success, -Exxx on error
+ */
+static int bitmap_new_disk_sb(struct bitmap *bitmap)
+{
+	bitmap_super_t *sb;
+	unsigned long chunksize, daemon_sleep, write_behind;
+	int err = -EINVAL;
+
+	/* page 0 is the superblock, read it... */
+	bitmap->sb_page = read_sb_page(bitmap->mddev,
+				       bitmap->mddev->bitmap_info.offset,
+				       NULL, 0, sizeof(bitmap_super_t));
+
+	if (IS_ERR(bitmap->sb_page)) {
+		err = PTR_ERR(bitmap->sb_page);
+		bitmap->sb_page = NULL;
+		return err;
+	}
+
+	sb = kmap_atomic(bitmap->sb_page, KM_USER0);
+
+	sb->magic = cpu_to_le32(BITMAP_MAGIC);
+	sb->version = cpu_to_le32(BITMAP_MAJOR_HI);
+
+	chunksize = bitmap->mddev->bitmap_info.chunksize;
+	BUG_ON(!chunksize);
+	if ((1 << ffz(~chunksize)) != chunksize) {
+		kunmap_atomic(sb, KM_USER0);
+		printk(KERN_ERR "bitmap chunksize not a power of 2\n");
+		return -EINVAL;
+	}
+	sb->chunksize = cpu_to_le32(chunksize);
+
+	daemon_sleep = bitmap->mddev->bitmap_info.daemon_sleep;
+	if (!daemon_sleep ||
+	    (daemon_sleep < 1) || (daemon_sleep > MAX_SCHEDULE_TIMEOUT)) {
+		printk(KERN_INFO "Choosing daemon_sleep default (5 sec)\n");
+		daemon_sleep = 5 * HZ;
+	}
+	sb->daemon_sleep = cpu_to_le32(daemon_sleep);
+	bitmap->mddev->bitmap_info.daemon_sleep = daemon_sleep;
+
+	/*
+	 * FIXME: write_behind for RAID1.  If not specified, what
+	 * is a good choice?  We choose COUNTER_MAX / 2 arbitrarily.
+	 */
+	write_behind = bitmap->mddev->bitmap_info.max_write_behind;
+	if (write_behind > COUNTER_MAX)
+		write_behind = COUNTER_MAX / 2;
+	sb->write_behind = cpu_to_le32(write_behind);
+	bitmap->mddev->bitmap_info.max_write_behind = write_behind;
+
+	/* keep the array size field of the bitmap superblock up to date */
+	sb->sync_size = cpu_to_le64(bitmap->mddev->resync_max_sectors);
+
+	memcpy(sb->uuid, bitmap->mddev->uuid, 16);
+
+	bitmap->flags |= BITMAP_STALE;
+	sb->state |= cpu_to_le32(BITMAP_STALE);
+	bitmap->events_cleared = bitmap->mddev->events;
+	sb->events_cleared = cpu_to_le64(bitmap->mddev->events);
+
+	bitmap->flags |= BITMAP_HOSTENDIAN;
+	sb->version = cpu_to_le32(BITMAP_MAJOR_HOSTENDIAN);
+
+	kunmap_atomic(sb, KM_USER0);
+	return 0;
+}
+
 /* read the superblock from the bitmap file and initialize some bitmap fields */
 static int bitmap_read_sb(struct bitmap *bitmap)
 {
@@ -1076,8 +1154,8 @@ static int bitmap_init_from_disk(struct 
 	}
 
 	printk(KERN_INFO "%s: bitmap initialized from disk: "
-		"read %lu/%lu pages, set %lu bits\n",
-		bmname(bitmap), bitmap->file_pages, num_pages, bit_cnt);
+	       "read %lu/%lu pages, set %lu of %lu bits\n",
+	       bmname(bitmap), bitmap->file_pages, num_pages, bit_cnt, chunks);
 
 	return 0;
 
@@ -1728,9 +1806,16 @@ int bitmap_create(mddev_t *mddev)
 		vfs_fsync(file, 1);
 	}
 	/* read superblock from bitmap file (this sets mddev->bitmap_info.chunksize) */
-	if (!mddev->bitmap_info.external)
-		err = bitmap_read_sb(bitmap);
-	else {
+	if (!mddev->bitmap_info.external) {
+		/*
+		 * If 'MD_ARRAY_FIRST_USE' is set, then device-mapper is
+		 * instructing us to create a new on-disk bitmap instance.
+		 */
+		if (test_and_clear_bit(MD_ARRAY_FIRST_USE, &mddev->flags))
+			err = bitmap_new_disk_sb(bitmap);
+		else
+			err = bitmap_read_sb(bitmap);
+	} else {
 		err = 0;
 		if (mddev->bitmap_info.chunksize == 0 ||
 		    mddev->bitmap_info.daemon_sleep == 0)
Index: linux-2.6/drivers/md/md.h
===================================================================
--- linux-2.6.orig/drivers/md/md.h
+++ linux-2.6/drivers/md/md.h
@@ -124,6 +124,7 @@ struct mddev_s
 #define MD_CHANGE_DEVS	0	/* Some device status has changed */
 #define MD_CHANGE_CLEAN 1	/* transition to or from 'clean' */
 #define MD_CHANGE_PENDING 2	/* switch from 'clean' to 'active' in progress */
+#define MD_ARRAY_FIRST_USE 3    /* First use of array, needs initialization */
 
 	int				suspended;
 	atomic_t			active_io;


