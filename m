From: Paul Clements <paul.clements@steeleye.com>
Subject: [PATCH 1/3] md bitmap async write enabling
Date: Thu, 17 Mar 2005 15:53:41 -0500
Message-ID: <4239EE55.7040804@steeleye.com>
References: <422F7621.8090602@steeleye.com> <16949.5768.392061.95882@cse.unsw.edu.au> <4239EDCA.4030502@steeleye.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------000205040203070206040304"
In-Reply-To: <4239EDCA.4030502@steeleye.com>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is a multi-part message in MIME format.
--------------000205040203070206040304
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

This patch enables the async write capability in md. It requires the md 
bitmap patches and the 117-WriteMostly-update patch.

--------------000205040203070206040304
Content-Type: text/plain;
 name="md_async_4_0_enabling.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="md_async_4_0_enabling.diff"


Signed-Off-By: Paul Clements <paul.clements@steeleye.com>

 drivers/md/bitmap.c         |   26 ++++++++++++++++++++++----
 drivers/md/md.c             |   13 +++++++++++++
 include/linux/raid/bitmap.h |   17 +++++++++++------
 include/linux/raid/md_k.h   |    3 +++
 4 files changed, 49 insertions(+), 10 deletions(-)
diff -purN --exclude core --exclude-from /export/public/clemep/tmp/dontdiff linux-2.6.11-rc3-mm2-patch-all-write-mostly-max-dev-bug-bitmap-bug-fix/drivers/md/bitmap.c linux-2.6.11-rc3-mm2-patch-all-write-mostly-async-write-bitmap-bug-fix/drivers/md/bitmap.c
--- linux-2.6.11-rc3-mm2-patch-all-write-mostly-max-dev-bug-bitmap-bug-fix/drivers/md/bitmap.c	Thu Mar 10 10:05:35 2005
+++ linux-2.6.11-rc3-mm2-patch-all-write-mostly-async-write-bitmap-bug-fix/drivers/md/bitmap.c	Thu Mar 10 10:13:15 2005
@@ -379,6 +379,7 @@ void bitmap_print_sb(struct bitmap *bitm
 	printk(KERN_DEBUG "  daemon sleep: %ds\n", le32_to_cpu(sb->daemon_sleep));
 	printk(KERN_DEBUG "     sync size: %llu KB\n", (unsigned long long)
 						le64_to_cpu(sb->sync_size) / 2);
+	printk(KERN_DEBUG "  async writes: %d\n", le32_to_cpu(sb->async_writes));
 	kunmap(bitmap->sb_page);
 }
 
@@ -387,7 +388,7 @@ static int bitmap_read_sb(struct bitmap 
 {
 	char *reason = NULL;
 	bitmap_super_t *sb;
-	unsigned long chunksize, daemon_sleep;
+	unsigned long chunksize, daemon_sleep, async_writes;
 	unsigned long bytes_read;
 	unsigned long long events;
 	int err = -EINVAL;
@@ -411,6 +412,7 @@ static int bitmap_read_sb(struct bitmap 
 
 	chunksize = le32_to_cpu(sb->chunksize);
 	daemon_sleep = le32_to_cpu(sb->daemon_sleep);
+	async_writes = le32_to_cpu(sb->async_writes);
 
 	/* verify that the bitmap-specific fields are valid */
 	if (sb->magic != cpu_to_le32(BITMAP_MAGIC))
@@ -422,7 +424,9 @@ static int bitmap_read_sb(struct bitmap 
 	else if ((1 << ffz(~chunksize)) != chunksize)
 		reason = "bitmap chunksize not a power of 2";
 	else if (daemon_sleep < 1 || daemon_sleep > 15)
-		reason = "daemon sleep period out of range";
+		reason = "daemon sleep period out of range (1-15s)";
+	else if (async_writes > COUNTER_MAX)
+		reason = "async write limit of range (0 - 16383)";
 	if (reason) {
 		printk(KERN_INFO "%s: invalid bitmap file superblock: %s\n",
 			bmname(bitmap), reason);
@@ -455,6 +459,7 @@ success:
 	/* assign fields using values from superblock */
 	bitmap->chunksize = chunksize;
 	bitmap->daemon_sleep = daemon_sleep;
+	bitmap->async_max_writes = async_writes;
 	bitmap->flags |= sb->state;
 	bitmap->events_cleared = le64_to_cpu(sb->events_cleared);
 	err = 0;
@@ -1196,9 +1201,16 @@ static bitmap_counter_t *bitmap_get_coun
 	}
 }
 
-int bitmap_startwrite(struct bitmap *bitmap, sector_t offset, unsigned long sectors)
+int bitmap_startwrite(struct bitmap *bitmap, sector_t offset, unsigned long sectors, int async)
 {
 	if (!bitmap) return 0;
+
+	if (async) {
+		atomic_inc(&bitmap->async_writes);
+		PRINTK(KERN_DEBUG "inc async write count %d/%d\n",
+		  atomic_read(&bitmap->async_writes), bitmap->async_max_writes);
+	}
+
 	while (sectors) {
 		int blocks;
 		bitmap_counter_t *bmc;
@@ -1233,9 +1245,15 @@ int bitmap_startwrite(struct bitmap *bit
 }
 
 void bitmap_endwrite(struct bitmap *bitmap, sector_t offset, unsigned long sectors,
-		     int success)
+		     int success, int async)
 {
 	if (!bitmap) return;
+	if (async) {
+		atomic_dec(&bitmap->async_writes);
+		PRINTK(KERN_DEBUG "dec async write count %d/%d\n",
+		  atomic_read(&bitmap->async_writes), bitmap->async_max_writes);
+	}
+
 	while (sectors) {
 		int blocks;
 		unsigned long flags;
diff -purN --exclude core --exclude-from /export/public/clemep/tmp/dontdiff linux-2.6.11-rc3-mm2-patch-all-write-mostly-max-dev-bug-bitmap-bug-fix/drivers/md/md.c linux-2.6.11-rc3-mm2-patch-all-write-mostly-async-write-bitmap-bug-fix/drivers/md/md.c
--- linux-2.6.11-rc3-mm2-patch-all-write-mostly-max-dev-bug-bitmap-bug-fix/drivers/md/md.c	Mon Feb 21 14:22:21 2005
+++ linux-2.6.11-rc3-mm2-patch-all-write-mostly-async-write-bitmap-bug-fix/drivers/md/md.c	Fri Mar  4 13:37:57 2005
@@ -2166,6 +2166,8 @@ static int get_disk_info(mddev_t * mddev
 			info.state |= (1<<MD_DISK_ACTIVE);
 			info.state |= (1<<MD_DISK_SYNC);
 		}
+		if (test_bit(WriteMostly, &rdev->flags))
+			info.state |= (1<<MD_DISK_WRITEONLY);
 	} else {
 		info.major = info.minor = 0;
 		info.raid_disk = -1;
@@ -2411,6 +2413,10 @@ static int hot_add_disk(mddev_t * mddev,
 		goto abort_unbind_export;
 	}
 
+	if (mddev->bitmap && mddev->bitmap->async_max_writes)
+		/* array is async, hotadd = write only */
+		set_bit(WriteMostly, &rdev->flags);
+
 	rdev->raid_disk = -1;
 
 	md_update_sb(mddev);
@@ -3290,6 +3296,8 @@ static int md_seq_show(struct seq_file *
 			char b[BDEVNAME_SIZE];
 			seq_printf(seq, " %s[%d]",
 				bdevname(rdev->bdev,b), rdev->desc_nr);
+			if (test_bit(WriteMostly, &rdev->flags))
+				seq_printf(seq, "(W)");
 			if (rdev->faulty) {
 				seq_printf(seq, "(F)");
 				continue;
@@ -3339,6 +3347,11 @@ static int md_seq_show(struct seq_file *
 			seq_printf(seq, "\n");
 			spin_unlock_irqrestore(&bitmap->lock, flags);
 			kfree(buf);
+			if (bitmap->async_max_writes)
+				seq_printf(seq,
+				    "       async: %d/%ld outstanding writes\n",
+				    atomic_read(&bitmap->async_writes),
+				    bitmap->async_max_writes);
 		}
 
 		seq_printf(seq, "\n");
diff -purN --exclude core --exclude-from /export/public/clemep/tmp/dontdiff linux-2.6.11-rc3-mm2-patch-all-write-mostly-max-dev-bug-bitmap-bug-fix/include/linux/raid/bitmap.h linux-2.6.11-rc3-mm2-patch-all-write-mostly-async-write-bitmap-bug-fix/include/linux/raid/bitmap.h
--- linux-2.6.11-rc3-mm2-patch-all-write-mostly-max-dev-bug-bitmap-bug-fix/include/linux/raid/bitmap.h	Fri Feb 18 14:45:25 2005
+++ linux-2.6.11-rc3-mm2-patch-all-write-mostly-async-write-bitmap-bug-fix/include/linux/raid/bitmap.h	Thu Mar 10 11:39:37 2005
@@ -6,8 +6,8 @@
 #ifndef BITMAP_H
 #define BITMAP_H 1
 
-#define BITMAP_MAJOR 3
-#define BITMAP_MINOR 38
+#define BITMAP_MAJOR 4
+#define BITMAP_MINOR 0
 
 /*
  * in-memory bitmap:
@@ -147,8 +147,9 @@ typedef struct bitmap_super_s {
 	__u32 state;        /* 48  bitmap state information */
 	__u32 chunksize;    /* 52  the bitmap chunk size in bytes */
 	__u32 daemon_sleep; /* 56  seconds between disk flushes */
+	__u32 async_writes; /* 60  number of outstanding async writes */
 
-	__u8  pad[256 - 60]; /* set to zero */
+	__u8  pad[256 - 64]; /* set to zero */
 } bitmap_super_t;
 
 /* notes:
@@ -225,6 +226,9 @@ struct bitmap {
 
 	unsigned long flags;
 
+	unsigned long async_max_writes; /* asynchronous write mode */
+	atomic_t async_writes;
+
 	/*
 	 * the bitmap daemon - periodically wakes up and sweeps the bitmap
 	 * file, cleaning up bits and flushing out pages to disk as necessary
@@ -266,9 +270,10 @@ int bitmap_update_sb(struct bitmap *bitm
 int  bitmap_setallbits(struct bitmap *bitmap);
 
 /* these are exported */
-int bitmap_startwrite(struct bitmap *bitmap, sector_t offset, unsigned long sectors);
-void bitmap_endwrite(struct bitmap *bitmap, sector_t offset, unsigned long sectors,
-		     int success);
+int bitmap_startwrite(struct bitmap *bitmap, sector_t offset,
+			unsigned long sectors, int async);
+void bitmap_endwrite(struct bitmap *bitmap, sector_t offset,
+			unsigned long sectors, int success, int async);
 int bitmap_start_sync(struct bitmap *bitmap, sector_t offset, int *blocks);
 void bitmap_end_sync(struct bitmap *bitmap, sector_t offset, int *blocks, int aborted);
 void bitmap_close_sync(struct bitmap *bitmap);
diff -purN --exclude core --exclude-from /export/public/clemep/tmp/dontdiff linux-2.6.11-rc3-mm2-patch-all-write-mostly-max-dev-bug-bitmap-bug-fix/include/linux/raid/md_k.h linux-2.6.11-rc3-mm2-patch-all-write-mostly-async-write-bitmap-bug-fix/include/linux/raid/md_k.h
--- linux-2.6.11-rc3-mm2-patch-all-write-mostly-max-dev-bug-bitmap-bug-fix/include/linux/raid/md_k.h	Fri Feb 18 14:45:47 2005
+++ linux-2.6.11-rc3-mm2-patch-all-write-mostly-async-write-bitmap-bug-fix/include/linux/raid/md_k.h	Wed Feb 23 15:47:30 2005
@@ -274,6 +274,9 @@ struct mddev_s
 	atomic_t			writes_pending; 
 	request_queue_t			*queue;	/* for plugging ... */
 
+	atomic_t                        async_writes; /* outstanding async IO */
+	unsigned int                    async_max_writes; /* 0 = sync */
+
 	struct bitmap                   *bitmap; /* the bitmap for the device */
 	struct file			*bitmap_file; /* the bitmap file */
 

--------------000205040203070206040304--
