From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 12/24] md/bitmap: use set_bit, test_bit,
 etc for operation on bitmap->flags.
Date: Tue, 17 Apr 2012 18:43:41 +1000
Message-ID: <20120417084341.6433.18861.stgit@notabene.brown>
References: <20120417084324.6433.68345.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120417084324.6433.68345.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

We currently use '&' and '|' which isn't the norm in the kernel
and doesn't allow easy atomicity.
So change to bit numbers and {set,clear,test}_bit.
This allows us to remove a spinlock/unlock (which was dubious anyway)
and some other simplifications.

Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/bitmap.c |   46 +++++++++++++++++++++-------------------------
 drivers/md/bitmap.h |    6 +++---
 2 files changed, 24 insertions(+), 28 deletions(-)

diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
index 1fd07c5..9200ed4 100644
--- a/drivers/md/bitmap.c
+++ b/drivers/md/bitmap.c
@@ -269,7 +269,7 @@ static void write_page(struct bitmap *bitmap, struct page *page, int wait)
 	if (bitmap->storage.file == NULL) {
 		switch (write_sb_page(bitmap, page, wait)) {
 		case -EINVAL:
-			bitmap->flags |= BITMAP_WRITE_ERROR;
+			set_bit(BITMAP_WRITE_ERROR, &bitmap->flags);
 		}
 	} else {
 
@@ -287,20 +287,16 @@ static void write_page(struct bitmap *bitmap, struct page *page, int wait)
 			wait_event(bitmap->write_wait,
 				   atomic_read(&bitmap->pending_writes)==0);
 	}
-	if (bitmap->flags & BITMAP_WRITE_ERROR)
+	if (test_bit(BITMAP_WRITE_ERROR, &bitmap->flags))
 		bitmap_file_kick(bitmap);
 }
 
 static void end_bitmap_write(struct buffer_head *bh, int uptodate)
 {
 	struct bitmap *bitmap = bh->b_private;
-	unsigned long flags;
 
-	if (!uptodate) {
-		spin_lock_irqsave(&bitmap->lock, flags);
-		bitmap->flags |= BITMAP_WRITE_ERROR;
-		spin_unlock_irqrestore(&bitmap->lock, flags);
-	}
+	if (!uptodate)
+		set_bit(BITMAP_WRITE_ERROR, &bitmap->flags);
 	if (atomic_dec_and_test(&bitmap->pending_writes))
 		wake_up(&bitmap->write_wait);
 }
@@ -387,7 +383,7 @@ static int read_page(struct file *file, unsigned long index,
 
 	wait_event(bitmap->write_wait,
 		   atomic_read(&bitmap->pending_writes)==0);
-	if (bitmap->flags & BITMAP_WRITE_ERROR)
+	if (test_bit(BITMAP_WRITE_ERROR, &bitmap->flags))
 		ret = -EIO;
 out:
 	if (ret)
@@ -519,7 +515,7 @@ static int bitmap_new_disk_sb(struct bitmap *bitmap)
 
 	memcpy(sb->uuid, bitmap->mddev->uuid, 16);
 
-	bitmap->flags |= BITMAP_STALE;
+	set_bit(BITMAP_STALE, &bitmap->flags);
 	sb->state = cpu_to_le32(bitmap->flags);
 	bitmap->events_cleared = bitmap->mddev->events;
 	sb->events_cleared = cpu_to_le64(bitmap->mddev->events);
@@ -543,7 +539,7 @@ static int bitmap_read_sb(struct bitmap *bitmap)
 		chunksize = 128 * 1024 * 1024;
 		daemon_sleep = 5 * HZ;
 		write_behind = 0;
-		bitmap->flags = BITMAP_STALE;
+		set_bit(BITMAP_STALE, &bitmap->flags);
 		err = 0;
 		goto out_no_sb;
 	}
@@ -615,20 +611,20 @@ static int bitmap_read_sb(struct bitmap *bitmap)
 			       "-- forcing full recovery\n",
 			       bmname(bitmap), events,
 			       (unsigned long long) bitmap->mddev->events);
-			bitmap->flags |= BITMAP_STALE;
+			set_bit(BITMAP_STALE, &bitmap->flags);
 		}
 	}
 
 	/* assign fields using values from superblock */
 	bitmap->flags |= le32_to_cpu(sb->state);
 	if (le32_to_cpu(sb->version) == BITMAP_MAJOR_HOSTENDIAN)
-		bitmap->flags |= BITMAP_HOSTENDIAN;
+		set_bit(BITMAP_HOSTENDIAN, &bitmap->flags);
 	bitmap->events_cleared = le64_to_cpu(sb->events_cleared);
 	err = 0;
 out:
 	kunmap_atomic(sb);
 out_no_sb:
-	if (bitmap->flags & BITMAP_STALE)
+	if (test_bit(BITMAP_STALE, &bitmap->flags))
 		bitmap->events_cleared = bitmap->mddev->events;
 	bitmap->mddev->bitmap_info.chunksize = chunksize;
 	bitmap->mddev->bitmap_info.daemon_sleep = daemon_sleep;
@@ -794,8 +790,7 @@ static void bitmap_file_kick(struct bitmap *bitmap)
 {
 	char *path, *ptr = NULL;
 
-	if (!(bitmap->flags & BITMAP_STALE)) {
-		bitmap->flags |= BITMAP_STALE;
+	if (!test_and_set_bit(BITMAP_STALE, &bitmap->flags)) {
 		bitmap_update_sb(bitmap);
 
 		if (bitmap->storage.file) {
@@ -866,7 +861,7 @@ static void bitmap_file_set_bit(struct bitmap *bitmap, sector_t block)
 
 	/* set the bit */
 	kaddr = kmap_atomic(page);
-	if (bitmap->flags & BITMAP_HOSTENDIAN)
+	if (test_bit(BITMAP_HOSTENDIAN, &bitmap->flags))
 		set_bit(bit, kaddr);
 	else
 		__set_bit_le(bit, kaddr);
@@ -888,7 +883,7 @@ static void bitmap_file_clear_bit(struct bitmap *bitmap, sector_t block)
 		return;
 	bit = file_page_offset(&bitmap->storage, chunk);
 	paddr = kmap_atomic(page);
-	if (bitmap->flags & BITMAP_HOSTENDIAN)
+	if (test_bit(BITMAP_HOSTENDIAN, &bitmap->flags))
 		clear_bit(bit, paddr);
 	else
 		__clear_bit_le(bit, paddr);
@@ -939,7 +934,7 @@ void bitmap_unplug(struct bitmap *bitmap)
 		else
 			md_super_wait(bitmap->mddev);
 	}
-	if (bitmap->flags & BITMAP_WRITE_ERROR)
+	if (test_bit(BITMAP_WRITE_ERROR, &bitmap->flags))
 		bitmap_file_kick(bitmap);
 }
 EXPORT_SYMBOL(bitmap_unplug);
@@ -986,7 +981,7 @@ static int bitmap_init_from_disk(struct bitmap *bitmap, sector_t start)
 		return 0;
 	}
 
-	outofdate = bitmap->flags & BITMAP_STALE;
+	outofdate = test_bit(BITMAP_STALE, &bitmap->flags);
 	if (outofdate)
 		printk(KERN_INFO "%s: bitmap file is out of date, doing full "
 			"recovery\n", bmname(bitmap));
@@ -1043,12 +1038,13 @@ static int bitmap_init_from_disk(struct bitmap *bitmap, sector_t start)
 				write_page(bitmap, page, 1);
 
 				ret = -EIO;
-				if (bitmap->flags & BITMAP_WRITE_ERROR)
+				if (test_bit(BITMAP_WRITE_ERROR,
+					     &bitmap->flags))
 					goto err;
 			}
 		}
 		paddr = kmap_atomic(page);
-		if (bitmap->flags & BITMAP_HOSTENDIAN)
+		if (test_bit(BITMAP_HOSTENDIAN, &bitmap->flags))
 			b = test_bit(bit, paddr);
 		else
 			b = test_bit_le(bit, paddr);
@@ -1757,7 +1753,7 @@ int bitmap_create(struct mddev *mddev)
 	mddev->bitmap = bitmap;
 
 
-	return (bitmap->flags & BITMAP_WRITE_ERROR) ? -EIO : 0;
+	return test_bit(BITMAP_WRITE_ERROR, &bitmap->flags) ? -EIO : 0;
 
  error:
 	bitmap_free(bitmap);
@@ -1798,7 +1794,7 @@ int bitmap_load(struct mddev *mddev)
 
 	if (err)
 		goto out;
-	bitmap->flags &= ~BITMAP_STALE;
+	clear_bit(BITMAP_STALE, &bitmap->flags);
 
 	/* Kick recovery in case any bits were set */
 	set_bit(MD_RECOVERY_NEEDED, &bitmap->mddev->recovery);
@@ -1808,7 +1804,7 @@ int bitmap_load(struct mddev *mddev)
 
 	bitmap_update_sb(bitmap);
 
-	if (bitmap->flags & BITMAP_WRITE_ERROR)
+	if (test_bit(BITMAP_WRITE_ERROR, &bitmap->flags))
 		err = -EIO;
 out:
 	return err;
diff --git a/drivers/md/bitmap.h b/drivers/md/bitmap.h
index 987ad3c..ede1084 100644
--- a/drivers/md/bitmap.h
+++ b/drivers/md/bitmap.h
@@ -114,9 +114,9 @@ typedef __u16 bitmap_counter_t;
 
 /* use these for bitmap->flags and bitmap->sb->state bit-fields */
 enum bitmap_state {
-	BITMAP_STALE  = 0x002,  /* the bitmap file is out of date or had -EIO */
-	BITMAP_WRITE_ERROR = 0x004, /* A write error has occurred */
-	BITMAP_HOSTENDIAN = 0x8000,
+	BITMAP_STALE	   = 1,  /* the bitmap file is out of date or had -EIO */
+	BITMAP_WRITE_ERROR = 2, /* A write error has occurred */
+	BITMAP_HOSTENDIAN  =15,
 };
 
 /* the superblock at the front of the bitmap file -- little endian */


