Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60AEF186295;
	Thu, 22 Aug 2024 02:52:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724295145; cv=none; b=VVVFRNGZ/+fLE5gTGHw9aBiSx+nYlSXd4njQvoRFMweTWqTXnBE2bDfSywmXF2Sc3LWCGNnzdYSc/0Vq1CE9avLy9BhR1KhR4n3TbOKtC02ShFEgw40Bspdg3YqEnB+0oA59smq0dL4zcF1ZDIRmp77MC/MNuQmHPavBf/r+v2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724295145; c=relaxed/simple;
	bh=IDwvuHNi+kKU1vh9WljJfnbPa36tdcLojdz9dEGHKmE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=u9ZSVuyCw4IBwE7QdUO0te0nrM4PitP1ObFZ/0BKHVlTHfgPp5GELcF8iA6shrHJose5IMZfpiooCj65UvW9G3E2/qIQGYwl7M3kfEWj0c72s/03cnlXnXYzOGHkKBbtFwodhZGcrbZPKcgKth0CfeeWaAB8NRlKFuKvGmKIpIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4Wq75b3CcZz4f3nJn;
	Thu, 22 Aug 2024 10:52:03 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 91C321A14C4;
	Thu, 22 Aug 2024 10:52:18 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgAXPoTNp8ZmyXl2CQ--.42363S45;
	Thu, 22 Aug 2024 10:52:18 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: song@kernel.org,
	mariusz.tkaczyk@linux.intel.com,
	l@damenly.org,
	xni@redhat.com
Cc: linux-kernel@vger.kernel.org,
	linux-raid@vger.kernel.org,
	yukuai3@huawei.com,
	yukuai1@huaweicloud.com,
	yi.zhang@huawei.com,
	yangerkun@huawei.com
Subject: [PATCH md-6.12 41/41] md/md-bitmap: make in memory structure internal
Date: Thu, 22 Aug 2024 10:47:18 +0800
Message-Id: <20240822024718.2158259-42-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240822024718.2158259-1-yukuai1@huaweicloud.com>
References: <20240822024718.2158259-1-yukuai1@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgAXPoTNp8ZmyXl2CQ--.42363S45
X-Coremail-Antispam: 1UD129KBjvAXoWfWw4UAF1kAr48Zr47Kr45Jrb_yoW8ur4Dto
	WxZwnxZF4rXr1rC3yUAFnxKFW3Z34DKF1Fvw4fCrs8Way7J3WYvrWfWrWxWwn8GF4Ygr17
	Aa4vqw45JF4fJryxn29KB7ZKAUJUUUU8529EdanIXcx71UUUUU7v73VFW2AGmfu7bjvjm3
	AaLaJ3UjIYCTnIWjp_UUUOs7AC8VAFwI0_Wr0E3s1l1xkIjI8I6I8E6xAIw20EY4v20xva
	j40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l82xGYIkIc2x26280x7IE14v26r126s0DM28Irc
	Ia0xkI8VCY1x0267AKxVW5JVCq3wA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK021l
	84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4UJV
	W0owA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq
	3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7
	IYx2IY67AKxVWUGVWUXwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4U
	M4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2
	kIc2xKxwCY1x0262kKe7AKxVWUtVW8ZwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkE
	bVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67
	AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVW7JVWDJwCI
	42IY6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF
	4lIxAIcVC2z280aVAFwI0_Gr0_Cr1lIxAIcVC2z280aVCY1x0267AKxVW8Jr0_Cr1UYxBI
	daVFxhVjvjDU0xZFpf9x0JUWMKtUUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

Now that struct btimap_page and bitmap is not used external anymore,
move them from md-bitmap.h to md-bitmap.c.(expect that dm-raid is still
using define marco 'COUNTER_MAX').

Also fix some checkpatch warnings.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/md-bitmap.c  | 247 ++++++++++++++++++++++++++++++++++++----
 drivers/md/md-bitmap.h  | 189 +-----------------------------
 drivers/md/md-cluster.c |   4 +-
 drivers/md/md.h         |   2 +-
 drivers/md/raid1.c      |   5 +-
 5 files changed, 235 insertions(+), 212 deletions(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index 48a81c144daf..4f278cdf7b99 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -32,6 +32,186 @@
 #include "md.h"
 #include "md-bitmap.h"
 
+#define BITMAP_MAJOR_LO 3
+/* version 4 insists the bitmap is in little-endian order
+ * with version 3, it is host-endian which is non-portable
+ * Version 5 is currently set only for clustered devices
+ */
+#define BITMAP_MAJOR_HI 4
+#define BITMAP_MAJOR_CLUSTERED 5
+#define	BITMAP_MAJOR_HOSTENDIAN 3
+
+/*
+ * in-memory bitmap:
+ *
+ * Use 16 bit block counters to track pending writes to each "chunk".
+ * The 2 high order bits are special-purpose, the first is a flag indicating
+ * whether a resync is needed.  The second is a flag indicating whether a
+ * resync is active.
+ * This means that the counter is actually 14 bits:
+ *
+ * +--------+--------+------------------------------------------------+
+ * | resync | resync |               counter                          |
+ * | needed | active |                                                |
+ * |  (0-1) |  (0-1) |              (0-16383)                         |
+ * +--------+--------+------------------------------------------------+
+ *
+ * The "resync needed" bit is set when:
+ *    a '1' bit is read from storage at startup.
+ *    a write request fails on some drives
+ *    a resync is aborted on a chunk with 'resync active' set
+ * It is cleared (and resync-active set) when a resync starts across all drives
+ * of the chunk.
+ *
+ *
+ * The "resync active" bit is set when:
+ *    a resync is started on all drives, and resync_needed is set.
+ *       resync_needed will be cleared (as long as resync_active wasn't already set).
+ * It is cleared when a resync completes.
+ *
+ * The counter counts pending write requests, plus the on-disk bit.
+ * When the counter is '1' and the resync bits are clear, the on-disk
+ * bit can be cleared as well, thus setting the counter to 0.
+ * When we set a bit, or in the counter (to start a write), if the fields is
+ * 0, we first set the disk bit and set the counter to 1.
+ *
+ * If the counter is 0, the on-disk bit is clear and the stripe is clean
+ * Anything that dirties the stripe pushes the counter to 2 (at least)
+ * and sets the on-disk bit (lazily).
+ * If a periodic sweep find the counter at 2, it is decremented to 1.
+ * If the sweep find the counter at 1, the on-disk bit is cleared and the
+ * counter goes to zero.
+ *
+ * Also, we'll hijack the "map" pointer itself and use it as two 16 bit block
+ * counters as a fallback when "page" memory cannot be allocated:
+ *
+ * Normal case (page memory allocated):
+ *
+ *     page pointer (32-bit)
+ *
+ *     [ ] ------+
+ *               |
+ *               +-------> [   ][   ]..[   ] (4096 byte page == 2048 counters)
+ *                          c1   c2    c2048
+ *
+ * Hijacked case (page memory allocation failed):
+ *
+ *     hijacked page pointer (32-bit)
+ *
+ *     [		  ][		  ] (no page memory allocated)
+ *      counter #1 (16-bit) counter #2 (16-bit)
+ *
+ */
+
+#define PAGE_BITS (PAGE_SIZE << 3)
+#define PAGE_BIT_SHIFT (PAGE_SHIFT + 3)
+
+#define NEEDED(x) (((bitmap_counter_t) x) & NEEDED_MASK)
+#define RESYNC(x) (((bitmap_counter_t) x) & RESYNC_MASK)
+#define COUNTER(x) (((bitmap_counter_t) x) & COUNTER_MAX)
+
+/* how many counters per page? */
+#define PAGE_COUNTER_RATIO (PAGE_BITS / COUNTER_BITS)
+/* same, except a shift value for more efficient bitops */
+#define PAGE_COUNTER_SHIFT (PAGE_BIT_SHIFT - COUNTER_BIT_SHIFT)
+/* same, except a mask value for more efficient bitops */
+#define PAGE_COUNTER_MASK  (PAGE_COUNTER_RATIO - 1)
+
+#define BITMAP_BLOCK_SHIFT 9
+
+/*
+ * bitmap structures:
+ */
+
+/* the in-memory bitmap is represented by bitmap_pages */
+struct bitmap_page {
+	/*
+	 * map points to the actual memory page
+	 */
+	char *map;
+	/*
+	 * in emergencies (when map cannot be alloced), hijack the map
+	 * pointer and use it as two counters itself
+	 */
+	unsigned int hijacked:1;
+	/*
+	 * If any counter in this page is '1' or '2' - and so could be
+	 * cleared then that page is marked as 'pending'
+	 */
+	unsigned int pending:1;
+	/*
+	 * count of dirty bits on the page
+	 */
+	unsigned int  count:30;
+};
+
+/* the main bitmap structure - one per mddev */
+struct bitmap {
+
+	struct bitmap_counts {
+		spinlock_t lock;
+		struct bitmap_page *bp;
+		/* total number of pages in the bitmap */
+		unsigned long pages;
+		/* number of pages not yet allocated */
+		unsigned long missing_pages;
+		/* chunksize = 2^chunkshift (for bitops) */
+		unsigned long chunkshift;
+		/* total number of data chunks for the array */
+		unsigned long chunks;
+	} counts;
+
+	struct mddev *mddev; /* the md device that the bitmap is for */
+
+	__u64	events_cleared;
+	int need_sync;
+
+	struct bitmap_storage {
+		/* backing disk file */
+		struct file *file;
+		/* cached copy of the bitmap file superblock */
+		struct page *sb_page;
+		unsigned long sb_index;
+		/* list of cache pages for the file */
+		struct page **filemap;
+		/* attributes associated filemap pages */
+		unsigned long *filemap_attr;
+		/* number of pages in the file */
+		unsigned long file_pages;
+		/* total bytes in the bitmap */
+		unsigned long bytes;
+	} storage;
+
+	unsigned long flags;
+
+	int allclean;
+
+	atomic_t behind_writes;
+	/* highest actual value at runtime */
+	unsigned long behind_writes_used;
+
+	/*
+	 * the bitmap daemon - periodically wakes up and sweeps the bitmap
+	 * file, cleaning up bits and flushing out pages to disk as necessary
+	 */
+	unsigned long daemon_lastrun; /* jiffies of last run */
+	/*
+	 * when we lasted called end_sync to update bitmap with resync
+	 * progress.
+	 */
+	unsigned long last_end_sync;
+
+	/* pending writes to the bitmap file */
+	atomic_t pending_writes;
+	wait_queue_head_t write_wait;
+	wait_queue_head_t overflow_wait;
+	wait_queue_head_t behind_wait;
+
+	struct kernfs_node *sysfs_can_clear;
+	/* slot offset for clustered env */
+	int cluster_slot;
+};
+
 static int bitmap_resize(struct mddev *mddev, sector_t blocks, int chunksize,
 			 bool init);
 
@@ -491,9 +671,10 @@ static void md_bitmap_wait_writes(struct bitmap *bitmap)
 
 
 /* update the event counter and sync the superblock to disk */
-static void bitmap_update_sb(struct bitmap *bitmap)
+static void bitmap_update_sb(void *data)
 {
 	bitmap_super_t *sb;
+	struct bitmap *bitmap = data;
 
 	if (!bitmap || !bitmap->mddev) /* no bitmap for this array */
 		return;
@@ -1844,10 +2025,11 @@ static void bitmap_flush(struct mddev *mddev)
 	bitmap_update_sb(bitmap);
 }
 
-static void md_bitmap_free(struct bitmap *bitmap)
+static void md_bitmap_free(void *data)
 {
 	unsigned long k, pages;
 	struct bitmap_page *bp;
+	struct bitmap *bitmap = data;
 
 	if (!bitmap) /* there was no bitmap */
 		return;
@@ -2075,7 +2257,7 @@ static int bitmap_load(struct mddev *mddev)
 }
 
 /* caller need to free returned bitmap with md_bitmap_free() */
-static struct bitmap *bitmap_get_from_slot(struct mddev *mddev, int slot)
+static void *bitmap_get_from_slot(struct mddev *mddev, int slot)
 {
 	int rv = 0;
 	struct bitmap *bitmap;
@@ -2142,15 +2324,18 @@ static int bitmap_copy_from_slot(struct mddev *mddev, int slot, sector_t *low,
 	return rv;
 }
 
-static void bitmap_set_pages(struct bitmap *bitmap, unsigned long pages)
+static void bitmap_set_pages(void *data, unsigned long pages)
 {
+	struct bitmap *bitmap = data;
+
 	bitmap->counts.pages = pages;
 }
 
-static int bitmap_get_stats(struct bitmap *bitmap, struct md_bitmap_stats *stats)
+static int bitmap_get_stats(void *data, struct md_bitmap_stats *stats)
 {
 	struct bitmap_storage *storage;
 	struct bitmap_counts *counts;
+	struct bitmap *bitmap = data;
 	bitmap_super_t *sb;
 
 	if (!bitmap)
@@ -2502,6 +2687,7 @@ space_show(struct mddev *mddev, char *page)
 static ssize_t
 space_store(struct mddev *mddev, const char *buf, size_t len)
 {
+	struct bitmap *bitmap;
 	unsigned long sectors;
 	int rv;
 
@@ -2512,8 +2698,8 @@ space_store(struct mddev *mddev, const char *buf, size_t len)
 	if (sectors == 0)
 		return -EINVAL;
 
-	if (mddev->bitmap &&
-	    sectors < (mddev->bitmap->storage.bytes + 511) >> 9)
+	bitmap = mddev->bitmap;
+	if (bitmap && sectors < (bitmap->storage.bytes + 511) >> 9)
 		return -EFBIG; /* Bitmap is too big for this small space */
 
 	/* could make sure it isn't too big, but that isn't really
@@ -2690,10 +2876,13 @@ __ATTR(metadata, S_IRUGO|S_IWUSR, metadata_show, metadata_store);
 static ssize_t can_clear_show(struct mddev *mddev, char *page)
 {
 	int len;
+	struct bitmap *bitmap;
+
 	spin_lock(&mddev->lock);
-	if (mddev->bitmap)
-		len = sprintf(page, "%s\n", (mddev->bitmap->need_sync ?
-					     "false" : "true"));
+	bitmap = mddev->bitmap;
+	if (bitmap)
+		len = sprintf(page, "%s\n", (bitmap->need_sync ? "false" :
+								 "true"));
 	else
 		len = sprintf(page, "\n");
 	spin_unlock(&mddev->lock);
@@ -2702,17 +2891,24 @@ static ssize_t can_clear_show(struct mddev *mddev, char *page)
 
 static ssize_t can_clear_store(struct mddev *mddev, const char *buf, size_t len)
 {
-	if (mddev->bitmap == NULL)
+	struct bitmap *bitmap = mddev->bitmap;
+
+	if (!bitmap)
 		return -ENOENT;
-	if (strncmp(buf, "false", 5) == 0)
-		mddev->bitmap->need_sync = 1;
-	else if (strncmp(buf, "true", 4) == 0) {
+
+	if (strncmp(buf, "false", 5) == 0) {
+		bitmap->need_sync = 1;
+		return len;
+	}
+
+	if (strncmp(buf, "true", 4) == 0) {
 		if (mddev->degraded)
 			return -EBUSY;
-		mddev->bitmap->need_sync = 0;
-	} else
-		return -EINVAL;
-	return len;
+		bitmap->need_sync = 0;
+		return len;
+	}
+
+	return -EINVAL;
 }
 
 static struct md_sysfs_entry bitmap_can_clear =
@@ -2722,21 +2918,26 @@ static ssize_t
 behind_writes_used_show(struct mddev *mddev, char *page)
 {
 	ssize_t ret;
+	struct bitmap *bitmap;
+
 	spin_lock(&mddev->lock);
-	if (mddev->bitmap == NULL)
+	bitmap = mddev->bitmap;
+	if (!bitmap)
 		ret = sprintf(page, "0\n");
 	else
-		ret = sprintf(page, "%lu\n",
-			      mddev->bitmap->behind_writes_used);
+		ret = sprintf(page, "%lu\n", bitmap->behind_writes_used);
 	spin_unlock(&mddev->lock);
+
 	return ret;
 }
 
 static ssize_t
 behind_writes_used_reset(struct mddev *mddev, const char *buf, size_t len)
 {
-	if (mddev->bitmap)
-		mddev->bitmap->behind_writes_used = 0;
+	struct bitmap *bitmap = mddev->bitmap;
+
+	if (bitmap)
+		bitmap->behind_writes_used = 0;
 	return len;
 }
 
diff --git a/drivers/md/md-bitmap.h b/drivers/md/md-bitmap.h
index c720729687e2..662e6fc141a7 100644
--- a/drivers/md/md-bitmap.h
+++ b/drivers/md/md-bitmap.h
@@ -7,81 +7,7 @@
 #ifndef BITMAP_H
 #define BITMAP_H 1
 
-#define BITMAP_MAJOR_LO 3
-/* version 4 insists the bitmap is in little-endian order
- * with version 3, it is host-endian which is non-portable
- * Version 5 is currently set only for clustered devices
- */
-#define BITMAP_MAJOR_HI 4
-#define BITMAP_MAJOR_CLUSTERED 5
-#define	BITMAP_MAJOR_HOSTENDIAN 3
-
-/*
- * in-memory bitmap:
- *
- * Use 16 bit block counters to track pending writes to each "chunk".
- * The 2 high order bits are special-purpose, the first is a flag indicating
- * whether a resync is needed.  The second is a flag indicating whether a
- * resync is active.
- * This means that the counter is actually 14 bits:
- *
- * +--------+--------+------------------------------------------------+
- * | resync | resync |               counter                          |
- * | needed | active |                                                |
- * |  (0-1) |  (0-1) |              (0-16383)                         |
- * +--------+--------+------------------------------------------------+
- *
- * The "resync needed" bit is set when:
- *    a '1' bit is read from storage at startup.
- *    a write request fails on some drives
- *    a resync is aborted on a chunk with 'resync active' set
- * It is cleared (and resync-active set) when a resync starts across all drives
- * of the chunk.
- *
- *
- * The "resync active" bit is set when:
- *    a resync is started on all drives, and resync_needed is set.
- *       resync_needed will be cleared (as long as resync_active wasn't already set).
- * It is cleared when a resync completes.
- *
- * The counter counts pending write requests, plus the on-disk bit.
- * When the counter is '1' and the resync bits are clear, the on-disk
- * bit can be cleared as well, thus setting the counter to 0.
- * When we set a bit, or in the counter (to start a write), if the fields is
- * 0, we first set the disk bit and set the counter to 1.
- *
- * If the counter is 0, the on-disk bit is clear and the stripe is clean
- * Anything that dirties the stripe pushes the counter to 2 (at least)
- * and sets the on-disk bit (lazily).
- * If a periodic sweep find the counter at 2, it is decremented to 1.
- * If the sweep find the counter at 1, the on-disk bit is cleared and the
- * counter goes to zero.
- *
- * Also, we'll hijack the "map" pointer itself and use it as two 16 bit block
- * counters as a fallback when "page" memory cannot be allocated:
- *
- * Normal case (page memory allocated):
- *
- *     page pointer (32-bit)
- *
- *     [ ] ------+
- *               |
- *               +-------> [   ][   ]..[   ] (4096 byte page == 2048 counters)
- *                          c1   c2    c2048
- *
- * Hijacked case (page memory allocation failed):
- *
- *     hijacked page pointer (32-bit)
- *
- *     [		  ][		  ] (no page memory allocated)
- *      counter #1 (16-bit) counter #2 (16-bit)
- *
- */
-
-#ifdef __KERNEL__
-
-#define PAGE_BITS (PAGE_SIZE << 3)
-#define PAGE_BIT_SHIFT (PAGE_SHIFT + 3)
+#define BITMAP_MAGIC 0x6d746962
 
 typedef __u16 bitmap_counter_t;
 #define COUNTER_BITS 16
@@ -91,26 +17,6 @@ typedef __u16 bitmap_counter_t;
 #define NEEDED_MASK ((bitmap_counter_t) (1 << (COUNTER_BITS - 1)))
 #define RESYNC_MASK ((bitmap_counter_t) (1 << (COUNTER_BITS - 2)))
 #define COUNTER_MAX ((bitmap_counter_t) RESYNC_MASK - 1)
-#define NEEDED(x) (((bitmap_counter_t) x) & NEEDED_MASK)
-#define RESYNC(x) (((bitmap_counter_t) x) & RESYNC_MASK)
-#define COUNTER(x) (((bitmap_counter_t) x) & COUNTER_MAX)
-
-/* how many counters per page? */
-#define PAGE_COUNTER_RATIO (PAGE_BITS / COUNTER_BITS)
-/* same, except a shift value for more efficient bitops */
-#define PAGE_COUNTER_SHIFT (PAGE_BIT_SHIFT - COUNTER_BIT_SHIFT)
-/* same, except a mask value for more efficient bitops */
-#define PAGE_COUNTER_MASK  (PAGE_COUNTER_RATIO - 1)
-
-#define BITMAP_BLOCK_SHIFT 9
-
-#endif
-
-/*
- * bitmap structures:
- */
-
-#define BITMAP_MAGIC 0x6d746962
 
 /* use these for bitmap->flags and bitmap->sb->state bit-fields */
 enum bitmap_state {
@@ -152,88 +58,6 @@ typedef struct bitmap_super_s {
  *    devices.  For raid10 it is the size of the array.
  */
 
-#ifdef __KERNEL__
-
-/* the in-memory bitmap is represented by bitmap_pages */
-struct bitmap_page {
-	/*
-	 * map points to the actual memory page
-	 */
-	char *map;
-	/*
-	 * in emergencies (when map cannot be alloced), hijack the map
-	 * pointer and use it as two counters itself
-	 */
-	unsigned int hijacked:1;
-	/*
-	 * If any counter in this page is '1' or '2' - and so could be
-	 * cleared then that page is marked as 'pending'
-	 */
-	unsigned int pending:1;
-	/*
-	 * count of dirty bits on the page
-	 */
-	unsigned int  count:30;
-};
-
-/* the main bitmap structure - one per mddev */
-struct bitmap {
-
-	struct bitmap_counts {
-		spinlock_t lock;
-		struct bitmap_page *bp;
-		unsigned long pages;		/* total number of pages
-						 * in the bitmap */
-		unsigned long missing_pages;	/* number of pages
-						 * not yet allocated */
-		unsigned long chunkshift;	/* chunksize = 2^chunkshift
-						 * (for bitops) */
-		unsigned long chunks;		/* Total number of data
-						 * chunks for the array */
-	} counts;
-
-	struct mddev *mddev; /* the md device that the bitmap is for */
-
-	__u64	events_cleared;
-	int need_sync;
-
-	struct bitmap_storage {
-		struct file *file;		/* backing disk file */
-		struct page *sb_page;		/* cached copy of the bitmap
-						 * file superblock */
-		unsigned long sb_index;
-		struct page **filemap;		/* list of cache pages for
-						 * the file */
-		unsigned long *filemap_attr;	/* attributes associated
-						 * w/ filemap pages */
-		unsigned long file_pages;	/* number of pages in the file*/
-		unsigned long bytes;		/* total bytes in the bitmap */
-	} storage;
-
-	unsigned long flags;
-
-	int allclean;
-
-	atomic_t behind_writes;
-	unsigned long behind_writes_used; /* highest actual value at runtime */
-
-	/*
-	 * the bitmap daemon - periodically wakes up and sweeps the bitmap
-	 * file, cleaning up bits and flushing out pages to disk as necessary
-	 */
-	unsigned long daemon_lastrun; /* jiffies of last run */
-	unsigned long last_end_sync; /* when we lasted called end_sync to
-				      * update bitmap with resync progress */
-
-	atomic_t pending_writes; /* pending writes to the bitmap file */
-	wait_queue_head_t write_wait;
-	wait_queue_head_t overflow_wait;
-	wait_queue_head_t behind_wait;
-
-	struct kernfs_node *sysfs_can_clear;
-	int cluster_slot;		/* Slot offset for clustered env */
-};
-
 struct md_bitmap_stats {
 	u64		events_cleared;
 	int		behind_writes;
@@ -272,21 +96,20 @@ struct bitmap_operations {
 	void (*cond_end_sync)(struct mddev *mddev, sector_t sector, bool force);
 	void (*close_sync)(struct mddev *mddev);
 
-	void (*update_sb)(struct bitmap *bitmap);
-	int (*get_stats)(struct bitmap *bitmap, struct md_bitmap_stats *stats);
+	void (*update_sb)(void *data);
+	int (*get_stats)(void *data, struct md_bitmap_stats *stats);
 
 	void (*sync_with_cluster)(struct mddev *mddev,
 				  sector_t old_lo, sector_t old_hi,
 				  sector_t new_lo, sector_t new_hi);
-	struct bitmap *(*get_from_slot)(struct mddev *mddev, int slot);
+	void *(*get_from_slot)(struct mddev *mddev, int slot);
 	int (*copy_from_slot)(struct mddev *mddev, int slot, sector_t *lo,
 			      sector_t *hi, bool clear_bits);
-	void (*set_pages)(struct bitmap *bitmap, unsigned long pages);
-	void (*free)(struct bitmap *bitmap);
+	void (*set_pages)(void *data, unsigned long pages);
+	void (*free)(void *data);
 };
 
 /* the bitmap API */
 void mddev_set_bitmap_ops(struct mddev *mddev);
 
 #endif
-#endif
diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
index 7647ce4f76fa..6595f89becdb 100644
--- a/drivers/md/md-cluster.c
+++ b/drivers/md/md-cluster.c
@@ -1144,7 +1144,7 @@ static int update_bitmap_size(struct mddev *mddev, sector_t size)
 
 static int resize_bitmaps(struct mddev *mddev, sector_t newsize, sector_t oldsize)
 {
-	struct bitmap *bitmap = mddev->bitmap;
+	void *bitmap = mddev->bitmap;
 	struct md_bitmap_stats stats;
 	unsigned long my_pages;
 	int i, rv;
@@ -1218,9 +1218,9 @@ static int cluster_check_sync_size(struct mddev *mddev)
 {
 	int current_slot = md_cluster_ops->slot_number(mddev);
 	int node_num = mddev->bitmap_info.nodes;
-	struct bitmap *bitmap = mddev->bitmap;
 	struct dlm_lock_resource *bm_lockres;
 	struct md_bitmap_stats stats;
+	void *bitmap = mddev->bitmap;
 	unsigned long sync_size = 0;
 	unsigned long my_sync_size;
 	char str[64];
diff --git a/drivers/md/md.h b/drivers/md/md.h
index e56193f71ab4..1c6a5f41adca 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -535,7 +535,7 @@ struct mddev {
 	struct percpu_ref		writes_pending;
 	int				sync_checkers;	/* # of threads checking writes_pending */
 
-	struct bitmap			*bitmap; /* the bitmap for the device */
+	void				*bitmap; /* the bitmap for the device */
 	struct bitmap_operations	*bitmap_ops;
 	struct {
 		struct file		*file; /* the bitmap file */
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 52a707e39a4d..6093df281eb1 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1425,7 +1425,6 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
 	struct r1conf *conf = mddev->private;
 	struct r1bio *r1_bio;
 	int i, disks;
-	struct bitmap *bitmap = mddev->bitmap;
 	unsigned long flags;
 	struct md_rdev *blocked_rdev;
 	int first_clone;
@@ -1578,7 +1577,7 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
 	 * at a time and thus needs a new bio that can fit the whole payload
 	 * this bio in page sized chunks.
 	 */
-	if (write_behind && bitmap)
+	if (write_behind && mddev->bitmap)
 		max_sectors = min_t(int, max_sectors,
 				    BIO_MAX_VECS * (PAGE_SIZE >> 9));
 	if (max_sectors < bio_sectors(bio)) {
@@ -1614,7 +1613,7 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
 			 * Not if there are too many, or cannot
 			 * allocate memory, or a reader on WriteMostly
 			 * is waiting for behind writes to flush */
-			err = mddev->bitmap_ops->get_stats(bitmap, &stats);
+			err = mddev->bitmap_ops->get_stats(mddev->bitmap, &stats);
 			if (!err && write_behind && !stats.behind_wait &&
 			    stats.behind_writes < max_write_behind)
 				alloc_behind_master_bio(r1_bio, bio);
-- 
2.39.2

