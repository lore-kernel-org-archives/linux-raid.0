From: NeilBrown <neilb@suse.de>
Subject: [PATCH md 007 of 8] Make md on-disk bitmaps not host-endian
Date: Fri, 14 Oct 2005 12:26:30 +1000
Message-ID: <1051014022630.11847@suse.de>
References: <20051014122335.11602.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Current bitmaps use set_bit et.al and so are host-endian,
which means not-portable.  Oops.

Define a new version number (4) for which bitmaps are 
little-endian.

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/bitmap.c         |   22 ++++++++++++++++++----
 ./drivers/md/md.c             |    2 +-
 ./include/linux/raid/bitmap.h |   11 +++++++++--
 ./include/linux/raid/md.h     |    4 +++-
 4 files changed, 31 insertions(+), 8 deletions(-)

diff ./drivers/md/bitmap.c~current~ ./drivers/md/bitmap.c
--- ./drivers/md/bitmap.c~current~	2005-10-14 12:18:10.000000000 +1000
+++ ./drivers/md/bitmap.c	2005-10-14 12:18:21.000000000 +1000
@@ -483,7 +483,8 @@ static int bitmap_read_sb(struct bitmap 
 	/* verify that the bitmap-specific fields are valid */
 	if (sb->magic != cpu_to_le32(BITMAP_MAGIC))
 		reason = "bad magic";
-	else if (sb->version != cpu_to_le32(BITMAP_MAJOR))
+	else if (le32_to_cpu(sb->version) < BITMAP_MAJOR_LO ||
+		 le32_to_cpu(sb->version) > BITMAP_MAJOR_HI)
 		reason = "unrecognized superblock version";
 	else if (chunksize < 512 || chunksize > (1024 * 1024 * 4))
 		reason = "bitmap chunksize out of range (512B - 4MB)";
@@ -528,6 +529,8 @@ success:
 	bitmap->daemon_lastrun = jiffies;
 	bitmap->max_write_behind = write_behind;
 	bitmap->flags |= sb->state;
+	if (le32_to_cpu(sb->version) == BITMAP_MAJOR_HOSTENDIAN)
+		bitmap->flags |= BITMAP_HOSTENDIAN;
 	bitmap->events_cleared = le64_to_cpu(sb->events_cleared);
 	if (sb->state & BITMAP_STALE)
 		bitmap->events_cleared = bitmap->mddev->events;
@@ -765,7 +768,10 @@ static void bitmap_file_set_bit(struct b
 
  	/* set the bit */
 	kaddr = kmap_atomic(page, KM_USER0);
-	set_bit(bit, kaddr);
+	if (bitmap->flags & BITMAP_HOSTENDIAN)
+		set_bit(bit, kaddr);
+	else
+		ext2_set_bit(bit, kaddr);
 	kunmap_atomic(kaddr, KM_USER0);
 	PRINTK("set file bit %lu page %lu\n", bit, page->index);
 
@@ -892,6 +898,7 @@ static int bitmap_init_from_disk(struct 
 	oldindex = ~0L;
 
 	for (i = 0; i < chunks; i++) {
+		int b;
 		index = file_page_index(i);
 		bit = file_page_offset(i);
 		if (index != oldindex) { /* this is a new page, read it in */
@@ -940,7 +947,11 @@ static int bitmap_init_from_disk(struct 
 
 			bitmap->filemap[bitmap->file_pages++] = page;
 		}
-		if (test_bit(bit, page_address(page))) {
+		if (bitmap->flags & BITMAP_HOSTENDIAN)
+			b = test_bit(bit, page_address(page));
+		else
+			b = ext2_test_bit(bit, page_address(page));
+		if (b) {
 			/* if the disk bit is set, set the memory bit */
 			bitmap_set_memory_bits(bitmap, i << CHUNK_BLOCK_SHIFT(bitmap),
 					       ((i+1) << (CHUNK_BLOCK_SHIFT(bitmap)) >= start)
@@ -1098,7 +1109,10 @@ int bitmap_daemon_work(struct bitmap *bi
 						  -1);
 
 				/* clear the bit */
-				clear_bit(file_page_offset(j), page_address(page));
+				if (bitmap->flags & BITMAP_HOSTENDIAN)
+					clear_bit(file_page_offset(j), page_address(page));
+				else
+					ext2_clear_bit(file_page_offset(j), page_address(page));
 			}
 		}
 		spin_unlock_irqrestore(&bitmap->lock, flags);

diff ./drivers/md/md.c~current~ ./drivers/md/md.c
--- ./drivers/md/md.c~current~	2005-10-14 12:18:10.000000000 +1000
+++ ./drivers/md/md.c	2005-10-14 12:18:21.000000000 +1000
@@ -4277,7 +4277,7 @@ static int __init md_init(void)
 			" MD_SB_DISKS=%d\n",
 			MD_MAJOR_VERSION, MD_MINOR_VERSION,
 			MD_PATCHLEVEL_VERSION, MAX_MD_DEVS, MD_SB_DISKS);
-	printk(KERN_INFO "md: bitmap version %d.%d\n", BITMAP_MAJOR,
+	printk(KERN_INFO "md: bitmap version %d.%d\n", BITMAP_MAJOR_HI,
 			BITMAP_MINOR);
 
 	if (register_blkdev(MAJOR_NR, "md"))

diff ./include/linux/raid/bitmap.h~current~ ./include/linux/raid/bitmap.h
--- ./include/linux/raid/bitmap.h~current~	2005-10-14 12:01:38.000000000 +1000
+++ ./include/linux/raid/bitmap.h	2005-10-14 12:18:21.000000000 +1000
@@ -6,7 +6,13 @@
 #ifndef BITMAP_H
 #define BITMAP_H 1
 
-#define BITMAP_MAJOR 3
+#define BITMAP_MAJOR_LO 3
+/* version 4 insists the bitmap is in little-endian order
+ * with version 3, it is host-endian which is non-portable
+ */
+#define BITMAP_MAJOR_HI 4
+#define	BITMAP_MAJOR_HOSTENDIAN 3
+
 #define BITMAP_MINOR 39
 
 /*
@@ -133,7 +139,8 @@ typedef __u16 bitmap_counter_t;
 /* use these for bitmap->flags and bitmap->sb->state bit-fields */
 enum bitmap_state {
 	BITMAP_ACTIVE = 0x001, /* the bitmap is in use */
-	BITMAP_STALE  = 0x002  /* the bitmap file is out of date or had -EIO */
+	BITMAP_STALE  = 0x002,  /* the bitmap file is out of date or had -EIO */
+	BITMAP_HOSTENDIAN = 0x8000,
 };
 
 /* the superblock at the front of the bitmap file -- little endian */

diff ./include/linux/raid/md.h~current~ ./include/linux/raid/md.h
--- ./include/linux/raid/md.h~current~	2005-10-14 12:01:38.000000000 +1000
+++ ./include/linux/raid/md.h	2005-10-14 12:18:21.000000000 +1000
@@ -66,8 +66,10 @@
  *     and major_version/minor_version accordingly
  * >=2 means that Internal bitmaps are supported by setting MD_SB_BITMAP_PRESENT
  *     in the super status byte
+ * >=3 means that bitmap superblock version 4 is supported, which uses
+ *     little-ending representation rather than host-endian
  */
-#define MD_PATCHLEVEL_VERSION           2
+#define MD_PATCHLEVEL_VERSION           3
 
 extern int register_md_personality (int p_num, mdk_personality_t *p);
 extern int unregister_md_personality (int p_num);
