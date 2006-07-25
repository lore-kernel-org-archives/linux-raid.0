From: Paul Clements <paul.clements@steeleye.com>
Subject: [PATCH] md: new bitmap sysfs interface
Date: Tue, 25 Jul 2006 02:30:07 -0400
Message-ID: <44C5BA6F.3010404@steeleye.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------020903010203090800000107"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, neilb@suse.de
List-Id: linux-raid.ids

This is a multi-part message in MIME format.
--------------020903010203090800000107
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

This patch (tested against 2.6.18-rc1-mm1) adds a new sysfs interface 
that allows the bitmap of an array to be dirtied. The interface is 
write-only, and is used as follows:

echo "1000" > /sys/block/md2/md/bitmap

(dirty the bit for chunk 1000 [offset 0] in the in-memory and on-disk 
bitmaps of array md2)

echo "1000-2000" > /sys/block/md1/md/bitmap

(dirty the bits for chunks 1000-2000 in md1's bitmap)

This is useful, for example, in cluster environments where you may need 
to combine two disjoint bitmaps into one (following a server failure, 
after a secondary server has taken over the array). By combining the 
bitmaps on the two servers, a full resync can be avoided (This was 
discussed on the list back on March 18, 2005, "[PATCH 1/2] md bitmap bug 
fixes" thread).

Thanks,
Paul

--------------020903010203090800000107
Content-Type: text/plain;
 name="md_bitmap_sysfs-3.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="md_bitmap_sysfs-3.diff"

diff -pur linux-2.6.18-rc1-mm1/drivers/md/bitmap.c linux-2.6.18-rc1-mm1-bitmap-sysfs/drivers/md/bitmap.c
--- linux-2.6.18-rc1-mm1/drivers/md/bitmap.c	2006-07-06 00:09:49.000000000 -0400
+++ linux-2.6.18-rc1-mm1-bitmap-sysfs/drivers/md/bitmap.c	2006-07-24 16:35:18.000000000 -0400
@@ -613,6 +613,7 @@ static inline unsigned long file_page_of
 static inline struct page *filemap_get_page(struct bitmap *bitmap,
 					unsigned long chunk)
 {
+	if (file_page_index(chunk) >= bitmap->file_pages) return NULL;
 	return bitmap->filemap[file_page_index(chunk) - file_page_index(0)];
 }
 
@@ -739,6 +740,7 @@ static void bitmap_file_set_bit(struct b
 	}
 
 	page = filemap_get_page(bitmap, chunk);
+	if (!page) return;
 	bit = file_page_offset(chunk);
 
  	/* set the bit */
@@ -1322,6 +1324,18 @@ static void bitmap_set_memory_bits(struc
 
 }
 
+/* dirty the memory and file bits for bitmap chunks "s" to "e" */
+void bitmap_dirty_bits(struct bitmap *bitmap, unsigned long s, unsigned long e)
+{
+	unsigned long chunk;
+
+	for (chunk = s; chunk <= e; chunk++) {
+		sector_t sec = chunk << CHUNK_BLOCK_SHIFT(bitmap);
+		bitmap_set_memory_bits(bitmap, sec, 1);
+		bitmap_file_set_bit(bitmap, sec);
+	}
+}
+
 /*
  * flush out any pending updates
  */
diff -pur linux-2.6.18-rc1-mm1/drivers/md/md.c linux-2.6.18-rc1-mm1-bitmap-sysfs/drivers/md/md.c
--- linux-2.6.18-rc1-mm1/drivers/md/md.c	2006-07-14 16:10:41.000000000 -0400
+++ linux-2.6.18-rc1-mm1-bitmap-sysfs/drivers/md/md.c	2006-07-18 11:52:11.000000000 -0400
@@ -2507,6 +2507,36 @@ static struct md_sysfs_entry md_new_devi
 __ATTR(new_dev, S_IWUSR, null_show, new_dev_store);
 
 static ssize_t
+bitmap_store(mddev_t *mddev, const char *buf, size_t len)
+{
+	char *end;
+	unsigned long chunk, end_chunk;
+
+	if (!mddev->bitmap)
+		goto out;
+	/* buf should be <chunk> <chunk> ... or <chunk>-<chunk> ... (range) */
+	while (*buf) {
+		chunk = end_chunk = simple_strtoul(buf, &end, 0);
+		if (buf == end) break;
+		if (*end == '-') { /* range */
+			buf = end + 1;
+			end_chunk = simple_strtoul(buf, &end, 0);
+			if (buf == end) break;
+		}
+		if (*end && !isspace(*end)) break;
+		bitmap_dirty_bits(mddev->bitmap, chunk, end_chunk);
+		buf = end;
+		while (isspace(*buf)) buf++;
+	}
+	bitmap_unplug(mddev->bitmap); /* flush the bits to disk */
+out:
+	return len;
+}
+
+static struct md_sysfs_entry md_bitmap =
+__ATTR(bitmap, S_IWUSR, null_show, bitmap_store);
+
+static ssize_t
 size_show(mddev_t *mddev, char *page)
 {
 	return sprintf(page, "%llu\n", (unsigned long long)mddev->size);
@@ -2826,6 +2856,7 @@ static struct attribute *md_redundancy_a
 	&md_sync_completed.attr,
 	&md_suspend_lo.attr,
 	&md_suspend_hi.attr,
+	&md_bitmap.attr,
 	NULL,
 };
 static struct attribute_group md_redundancy_group = {

--------------020903010203090800000107--
