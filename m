From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] md: move headers out of include/linux/raid/
Date: Tue, 3 Mar 2009 19:30:16 +0100
Message-ID: <20090303183016.GA28645@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Move the headers with the local structures for the disciplines and
bitmap.h into drivers/md/ so that they are more easily grepable for
hacking and not far away.  md.h is left where it is for now as there
are some uses from the outside.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/drivers/md/bitmap.c
===================================================================
--- linux-2.6.orig/drivers/md/bitmap.c	2009-03-03 19:22:52.666978235 +0100
+++ linux-2.6/drivers/md/bitmap.c	2009-03-03 19:22:55.916008706 +0100
@@ -27,7 +27,7 @@
 #include <linux/mount.h>
 #include <linux/buffer_head.h>
 #include <linux/raid/md.h>
-#include <linux/raid/bitmap.h>
+#include "bitmap.h"
 
 /* debug macros */
 
Index: linux-2.6/drivers/md/bitmap.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6/drivers/md/bitmap.h	2009-03-03 19:22:55.917007158 +0100
@@ -0,0 +1,288 @@
+/*
+ * bitmap.h: Copyright (C) Peter T. Breuer (ptb@ot.uc3m.es) 2003
+ *
+ * additions: Copyright (C) 2003-2004, Paul Clements, SteelEye Technology, Inc.
+ */
+#ifndef BITMAP_H
+#define BITMAP_H 1
+
+#define BITMAP_MAJOR_LO 3
+/* version 4 insists the bitmap is in little-endian order
+ * with version 3, it is host-endian which is non-portable
+ */
+#define BITMAP_MAJOR_HI 4
+#define	BITMAP_MAJOR_HOSTENDIAN 3
+
+#define BITMAP_MINOR 39
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
+ * bit can be cleared aswell, thus setting the counter to 0.
+ * When we set a bit, or in the counter (to start a write), if the fields is
+ * 0, we first set the disk bit and set the counter to 1.
+ *
+ * If the counter is 0, the on-disk bit is clear and the stipe is clean
+ * Anything that dirties the stipe pushes the counter to 2 (at least)
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
+#ifdef __KERNEL__
+
+#define PAGE_BITS (PAGE_SIZE << 3)
+#define PAGE_BIT_SHIFT (PAGE_SHIFT + 3)
+
+typedef __u16 bitmap_counter_t;
+#define COUNTER_BITS 16
+#define COUNTER_BIT_SHIFT 4
+#define COUNTER_BYTE_RATIO (COUNTER_BITS / 8)
+#define COUNTER_BYTE_SHIFT (COUNTER_BIT_SHIFT - 3)
+
+#define NEEDED_MASK ((bitmap_counter_t) (1 << (COUNTER_BITS - 1)))
+#define RESYNC_MASK ((bitmap_counter_t) (1 << (COUNTER_BITS - 2)))
+#define COUNTER_MAX ((bitmap_counter_t) RESYNC_MASK - 1)
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
+#define BITMAP_BLOCK_SIZE 512
+#define BITMAP_BLOCK_SHIFT 9
+
+/* how many blocks per chunk? (this is variable) */
+#define CHUNK_BLOCK_RATIO(bitmap) ((bitmap)->chunksize >> BITMAP_BLOCK_SHIFT)
+#define CHUNK_BLOCK_SHIFT(bitmap) ((bitmap)->chunkshift - BITMAP_BLOCK_SHIFT)
+#define CHUNK_BLOCK_MASK(bitmap) (CHUNK_BLOCK_RATIO(bitmap) - 1)
+
+/* when hijacked, the counters and bits represent even larger "chunks" */
+/* there will be 1024 chunks represented by each counter in the page pointers */
+#define PAGEPTR_BLOCK_RATIO(bitmap) \
+			(CHUNK_BLOCK_RATIO(bitmap) << PAGE_COUNTER_SHIFT >> 1)
+#define PAGEPTR_BLOCK_SHIFT(bitmap) \
+			(CHUNK_BLOCK_SHIFT(bitmap) + PAGE_COUNTER_SHIFT - 1)
+#define PAGEPTR_BLOCK_MASK(bitmap) (PAGEPTR_BLOCK_RATIO(bitmap) - 1)
+
+/*
+ * on-disk bitmap:
+ *
+ * Use one bit per "chunk" (block set). We do the disk I/O on the bitmap
+ * file a page at a time. There's a superblock at the start of the file.
+ */
+
+/* map chunks (bits) to file pages - offset by the size of the superblock */
+#define CHUNK_BIT_OFFSET(chunk) ((chunk) + (sizeof(bitmap_super_t) << 3))
+
+#endif
+
+/*
+ * bitmap structures:
+ */
+
+#define BITMAP_MAGIC 0x6d746962
+
+/* use these for bitmap->flags and bitmap->sb->state bit-fields */
+enum bitmap_state {
+	BITMAP_STALE  = 0x002,  /* the bitmap file is out of date or had -EIO */
+	BITMAP_WRITE_ERROR = 0x004, /* A write error has occurred */
+	BITMAP_HOSTENDIAN = 0x8000,
+};
+
+/* the superblock at the front of the bitmap file -- little endian */
+typedef struct bitmap_super_s {
+	__le32 magic;        /*  0  BITMAP_MAGIC */
+	__le32 version;      /*  4  the bitmap major for now, could change... */
+	__u8  uuid[16];      /*  8  128 bit uuid - must match md device uuid */
+	__le64 events;       /* 24  event counter for the bitmap (1)*/
+	__le64 events_cleared;/*32  event counter when last bit cleared (2) */
+	__le64 sync_size;    /* 40  the size of the md device's sync range(3) */
+	__le32 state;        /* 48  bitmap state information */
+	__le32 chunksize;    /* 52  the bitmap chunk size in bytes */
+	__le32 daemon_sleep; /* 56  seconds between disk flushes */
+	__le32 write_behind; /* 60  number of outstanding write-behind writes */
+
+	__u8  pad[256 - 64]; /* set to zero */
+} bitmap_super_t;
+
+/* notes:
+ * (1) This event counter is updated before the eventcounter in the md superblock
+ *    When a bitmap is loaded, it is only accepted if this event counter is equal
+ *    to, or one greater than, the event counter in the superblock.
+ * (2) This event counter is updated when the other one is *if*and*only*if* the
+ *    array is not degraded.  As bits are not cleared when the array is degraded,
+ *    this represents the last time that any bits were cleared.
+ *    If a device is being added that has an event count with this value or
+ *    higher, it is accepted as conforming to the bitmap.
+ * (3)This is the number of sectors represented by the bitmap, and is the range that
+ *    resync happens across.  For raid1 and raid5/6 it is the size of individual
+ *    devices.  For raid10 it is the size of the array.
+ */
+
+#ifdef __KERNEL__
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
+	 * count of dirty bits on the page
+	 */
+	unsigned int  count:31;
+};
+
+/* keep track of bitmap file pages that have pending writes on them */
+struct page_list {
+	struct list_head list;
+	struct page *page;
+};
+
+/* the main bitmap structure - one per mddev */
+struct bitmap {
+	struct bitmap_page *bp;
+	unsigned long pages; /* total number of pages in the bitmap */
+	unsigned long missing_pages; /* number of pages not yet allocated */
+
+	mddev_t *mddev; /* the md device that the bitmap is for */
+
+	int counter_bits; /* how many bits per block counter */
+
+	/* bitmap chunksize -- how much data does each bit represent? */
+	unsigned long chunksize;
+	unsigned long chunkshift; /* chunksize = 2^chunkshift (for bitops) */
+	unsigned long chunks; /* total number of data chunks for the array */
+
+	/* We hold a count on the chunk currently being synced, and drop
+	 * it when the last block is started.  If the resync is aborted
+	 * midway, we need to be able to drop that count, so we remember
+	 * the counted chunk..
+	 */
+	unsigned long syncchunk;
+
+	__u64	events_cleared;
+	int need_sync;
+
+	/* bitmap spinlock */
+	spinlock_t lock;
+
+	long offset; /* offset from superblock if file is NULL */
+	struct file *file; /* backing disk file */
+	struct page *sb_page; /* cached copy of the bitmap file superblock */
+	struct page **filemap; /* list of cache pages for the file */
+	unsigned long *filemap_attr; /* attributes associated w/ filemap pages */
+	unsigned long file_pages; /* number of pages in the file */
+	int last_page_size; /* bytes in the last page */
+
+	unsigned long flags;
+
+	int allclean;
+
+	unsigned long max_write_behind; /* write-behind mode */
+	atomic_t behind_writes;
+
+	/*
+	 * the bitmap daemon - periodically wakes up and sweeps the bitmap
+	 * file, cleaning up bits and flushing out pages to disk as necessary
+	 */
+	unsigned long daemon_lastrun; /* jiffies of last run */
+	unsigned long daemon_sleep; /* how many seconds between updates? */
+	unsigned long last_end_sync; /* when we lasted called end_sync to
+				      * update bitmap with resync progress */
+
+	atomic_t pending_writes; /* pending writes to the bitmap file */
+	wait_queue_head_t write_wait;
+	wait_queue_head_t overflow_wait;
+
+};
+
+/* the bitmap API */
+
+/* these are used only by md/bitmap */
+int  bitmap_create(mddev_t *mddev);
+void bitmap_flush(mddev_t *mddev);
+void bitmap_destroy(mddev_t *mddev);
+
+void bitmap_print_sb(struct bitmap *bitmap);
+void bitmap_update_sb(struct bitmap *bitmap);
+
+int  bitmap_setallbits(struct bitmap *bitmap);
+void bitmap_write_all(struct bitmap *bitmap);
+
+void bitmap_dirty_bits(struct bitmap *bitmap, unsigned long s, unsigned long e);
+
+/* these are exported */
+int bitmap_startwrite(struct bitmap *bitmap, sector_t offset,
+			unsigned long sectors, int behind);
+void bitmap_endwrite(struct bitmap *bitmap, sector_t offset,
+			unsigned long sectors, int success, int behind);
+int bitmap_start_sync(struct bitmap *bitmap, sector_t offset, int *blocks, int degraded);
+void bitmap_end_sync(struct bitmap *bitmap, sector_t offset, int *blocks, int aborted);
+void bitmap_close_sync(struct bitmap *bitmap);
+void bitmap_cond_end_sync(struct bitmap *bitmap, sector_t sector);
+
+void bitmap_unplug(struct bitmap *bitmap);
+void bitmap_daemon_work(struct bitmap *bitmap);
+#endif
+
+#endif
Index: linux-2.6/drivers/md/linear.c
===================================================================
--- linux-2.6.orig/drivers/md/linear.c	2009-03-03 19:22:52.673978149 +0100
+++ linux-2.6/drivers/md/linear.c	2009-03-03 19:22:55.917007158 +0100
@@ -16,7 +16,7 @@
    Software Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.  
 */
 
-#include <linux/raid/linear.h>
+#include "linear.h"
 
 /*
  * find which device holds a particular offset 
Index: linux-2.6/drivers/md/linear.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6/drivers/md/linear.h	2009-03-03 19:22:55.917996320 +0100
@@ -0,0 +1,31 @@
+#ifndef _LINEAR_H
+#define _LINEAR_H
+
+#include <linux/raid/md.h>
+
+struct dev_info {
+	mdk_rdev_t	*rdev;
+	sector_t	num_sectors;
+	sector_t	start_sector;
+};
+
+typedef struct dev_info dev_info_t;
+
+struct linear_private_data
+{
+	struct linear_private_data *prev;	/* earlier version */
+	dev_info_t		**hash_table;
+	sector_t		spacing;
+	sector_t		array_sectors;
+	int			sector_shift;	/* shift before dividing
+						 * by spacing
+						 */
+	dev_info_t		disks[0];
+};
+
+
+typedef struct linear_private_data linear_conf_t;
+
+#define mddev_to_conf(mddev) ((linear_conf_t *) mddev->private)
+
+#endif
Index: linux-2.6/drivers/md/md.c
===================================================================
--- linux-2.6.orig/drivers/md/md.c	2009-03-03 19:22:52.681977911 +0100
+++ linux-2.6/drivers/md/md.c	2009-03-03 19:22:55.919007762 +0100
@@ -34,7 +34,6 @@
 
 #include <linux/kthread.h>
 #include <linux/raid/md.h>
-#include <linux/raid/bitmap.h>
 #include <linux/sysctl.h>
 #include <linux/buffer_head.h> /* for invalidate_bdev */
 #include <linux/poll.h>
@@ -45,6 +44,7 @@
 #include <linux/reboot.h>
 #include <linux/file.h>
 #include <linux/delay.h>
+#include "bitmap.h"
 
 /* 63 partitions with the alternate major number (mdp) */
 #define MdpMinorShift 6
Index: linux-2.6/drivers/md/raid1.c
===================================================================
--- linux-2.6.orig/drivers/md/raid1.c	2009-03-03 19:22:52.686978757 +0100
+++ linux-2.6/drivers/md/raid1.c	2009-03-03 19:22:55.923028944 +0100
@@ -33,8 +33,8 @@
 
 #include "dm-bio-list.h"
 #include <linux/delay.h>
-#include <linux/raid/raid1.h>
-#include <linux/raid/bitmap.h>
+#include "raid1.h"
+#include "bitmap.h"
 
 #define DEBUG 0
 #if DEBUG
Index: linux-2.6/drivers/md/raid10.c
===================================================================
--- linux-2.6.orig/drivers/md/raid10.c	2009-03-03 19:22:52.690979057 +0100
+++ linux-2.6/drivers/md/raid10.c	2009-03-03 19:22:55.924981916 +0100
@@ -20,8 +20,8 @@
 
 #include "dm-bio-list.h"
 #include <linux/delay.h>
-#include <linux/raid/raid10.h>
-#include <linux/raid/bitmap.h>
+#include "raid10.h"
+#include "bitmap.h"
 
 /*
  * RAID10 provides a combination of RAID0 and RAID1 functionality.
Index: linux-2.6/drivers/md/raid5.c
===================================================================
--- linux-2.6.orig/drivers/md/raid5.c	2009-03-03 19:22:52.695978506 +0100
+++ linux-2.6/drivers/md/raid5.c	2009-03-03 19:22:55.926008094 +0100
@@ -44,10 +44,9 @@
  */
 
 #include <linux/kthread.h>
-#include "raid6.h"
-
-#include <linux/raid/bitmap.h>
 #include <linux/async_tx.h>
+#include "raid6.h"
+#include "bitmap.h"
 
 /*
  * Stripe cache
Index: linux-2.6/include/linux/raid/bitmap.h
===================================================================
--- linux-2.6.orig/include/linux/raid/bitmap.h	2009-03-03 19:22:52.747978843 +0100
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,288 +0,0 @@
-/*
- * bitmap.h: Copyright (C) Peter T. Breuer (ptb@ot.uc3m.es) 2003
- *
- * additions: Copyright (C) 2003-2004, Paul Clements, SteelEye Technology, Inc.
- */
-#ifndef BITMAP_H
-#define BITMAP_H 1
-
-#define BITMAP_MAJOR_LO 3
-/* version 4 insists the bitmap is in little-endian order
- * with version 3, it is host-endian which is non-portable
- */
-#define BITMAP_MAJOR_HI 4
-#define	BITMAP_MAJOR_HOSTENDIAN 3
-
-#define BITMAP_MINOR 39
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
- * bit can be cleared aswell, thus setting the counter to 0.
- * When we set a bit, or in the counter (to start a write), if the fields is
- * 0, we first set the disk bit and set the counter to 1.
- *
- * If the counter is 0, the on-disk bit is clear and the stipe is clean
- * Anything that dirties the stipe pushes the counter to 2 (at least)
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
-
-typedef __u16 bitmap_counter_t;
-#define COUNTER_BITS 16
-#define COUNTER_BIT_SHIFT 4
-#define COUNTER_BYTE_RATIO (COUNTER_BITS / 8)
-#define COUNTER_BYTE_SHIFT (COUNTER_BIT_SHIFT - 3)
-
-#define NEEDED_MASK ((bitmap_counter_t) (1 << (COUNTER_BITS - 1)))
-#define RESYNC_MASK ((bitmap_counter_t) (1 << (COUNTER_BITS - 2)))
-#define COUNTER_MAX ((bitmap_counter_t) RESYNC_MASK - 1)
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
-#define BITMAP_BLOCK_SIZE 512
-#define BITMAP_BLOCK_SHIFT 9
-
-/* how many blocks per chunk? (this is variable) */
-#define CHUNK_BLOCK_RATIO(bitmap) ((bitmap)->chunksize >> BITMAP_BLOCK_SHIFT)
-#define CHUNK_BLOCK_SHIFT(bitmap) ((bitmap)->chunkshift - BITMAP_BLOCK_SHIFT)
-#define CHUNK_BLOCK_MASK(bitmap) (CHUNK_BLOCK_RATIO(bitmap) - 1)
-
-/* when hijacked, the counters and bits represent even larger "chunks" */
-/* there will be 1024 chunks represented by each counter in the page pointers */
-#define PAGEPTR_BLOCK_RATIO(bitmap) \
-			(CHUNK_BLOCK_RATIO(bitmap) << PAGE_COUNTER_SHIFT >> 1)
-#define PAGEPTR_BLOCK_SHIFT(bitmap) \
-			(CHUNK_BLOCK_SHIFT(bitmap) + PAGE_COUNTER_SHIFT - 1)
-#define PAGEPTR_BLOCK_MASK(bitmap) (PAGEPTR_BLOCK_RATIO(bitmap) - 1)
-
-/*
- * on-disk bitmap:
- *
- * Use one bit per "chunk" (block set). We do the disk I/O on the bitmap
- * file a page at a time. There's a superblock at the start of the file.
- */
-
-/* map chunks (bits) to file pages - offset by the size of the superblock */
-#define CHUNK_BIT_OFFSET(chunk) ((chunk) + (sizeof(bitmap_super_t) << 3))
-
-#endif
-
-/*
- * bitmap structures:
- */
-
-#define BITMAP_MAGIC 0x6d746962
-
-/* use these for bitmap->flags and bitmap->sb->state bit-fields */
-enum bitmap_state {
-	BITMAP_STALE  = 0x002,  /* the bitmap file is out of date or had -EIO */
-	BITMAP_WRITE_ERROR = 0x004, /* A write error has occurred */
-	BITMAP_HOSTENDIAN = 0x8000,
-};
-
-/* the superblock at the front of the bitmap file -- little endian */
-typedef struct bitmap_super_s {
-	__le32 magic;        /*  0  BITMAP_MAGIC */
-	__le32 version;      /*  4  the bitmap major for now, could change... */
-	__u8  uuid[16];      /*  8  128 bit uuid - must match md device uuid */
-	__le64 events;       /* 24  event counter for the bitmap (1)*/
-	__le64 events_cleared;/*32  event counter when last bit cleared (2) */
-	__le64 sync_size;    /* 40  the size of the md device's sync range(3) */
-	__le32 state;        /* 48  bitmap state information */
-	__le32 chunksize;    /* 52  the bitmap chunk size in bytes */
-	__le32 daemon_sleep; /* 56  seconds between disk flushes */
-	__le32 write_behind; /* 60  number of outstanding write-behind writes */
-
-	__u8  pad[256 - 64]; /* set to zero */
-} bitmap_super_t;
-
-/* notes:
- * (1) This event counter is updated before the eventcounter in the md superblock
- *    When a bitmap is loaded, it is only accepted if this event counter is equal
- *    to, or one greater than, the event counter in the superblock.
- * (2) This event counter is updated when the other one is *if*and*only*if* the
- *    array is not degraded.  As bits are not cleared when the array is degraded,
- *    this represents the last time that any bits were cleared.
- *    If a device is being added that has an event count with this value or
- *    higher, it is accepted as conforming to the bitmap.
- * (3)This is the number of sectors represented by the bitmap, and is the range that
- *    resync happens across.  For raid1 and raid5/6 it is the size of individual
- *    devices.  For raid10 it is the size of the array.
- */
-
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
-	 * count of dirty bits on the page
-	 */
-	unsigned int  count:31;
-};
-
-/* keep track of bitmap file pages that have pending writes on them */
-struct page_list {
-	struct list_head list;
-	struct page *page;
-};
-
-/* the main bitmap structure - one per mddev */
-struct bitmap {
-	struct bitmap_page *bp;
-	unsigned long pages; /* total number of pages in the bitmap */
-	unsigned long missing_pages; /* number of pages not yet allocated */
-
-	mddev_t *mddev; /* the md device that the bitmap is for */
-
-	int counter_bits; /* how many bits per block counter */
-
-	/* bitmap chunksize -- how much data does each bit represent? */
-	unsigned long chunksize;
-	unsigned long chunkshift; /* chunksize = 2^chunkshift (for bitops) */
-	unsigned long chunks; /* total number of data chunks for the array */
-
-	/* We hold a count on the chunk currently being synced, and drop
-	 * it when the last block is started.  If the resync is aborted
-	 * midway, we need to be able to drop that count, so we remember
-	 * the counted chunk..
-	 */
-	unsigned long syncchunk;
-
-	__u64	events_cleared;
-	int need_sync;
-
-	/* bitmap spinlock */
-	spinlock_t lock;
-
-	long offset; /* offset from superblock if file is NULL */
-	struct file *file; /* backing disk file */
-	struct page *sb_page; /* cached copy of the bitmap file superblock */
-	struct page **filemap; /* list of cache pages for the file */
-	unsigned long *filemap_attr; /* attributes associated w/ filemap pages */
-	unsigned long file_pages; /* number of pages in the file */
-	int last_page_size; /* bytes in the last page */
-
-	unsigned long flags;
-
-	int allclean;
-
-	unsigned long max_write_behind; /* write-behind mode */
-	atomic_t behind_writes;
-
-	/*
-	 * the bitmap daemon - periodically wakes up and sweeps the bitmap
-	 * file, cleaning up bits and flushing out pages to disk as necessary
-	 */
-	unsigned long daemon_lastrun; /* jiffies of last run */
-	unsigned long daemon_sleep; /* how many seconds between updates? */
-	unsigned long last_end_sync; /* when we lasted called end_sync to
-				      * update bitmap with resync progress */
-
-	atomic_t pending_writes; /* pending writes to the bitmap file */
-	wait_queue_head_t write_wait;
-	wait_queue_head_t overflow_wait;
-
-};
-
-/* the bitmap API */
-
-/* these are used only by md/bitmap */
-int  bitmap_create(mddev_t *mddev);
-void bitmap_flush(mddev_t *mddev);
-void bitmap_destroy(mddev_t *mddev);
-
-void bitmap_print_sb(struct bitmap *bitmap);
-void bitmap_update_sb(struct bitmap *bitmap);
-
-int  bitmap_setallbits(struct bitmap *bitmap);
-void bitmap_write_all(struct bitmap *bitmap);
-
-void bitmap_dirty_bits(struct bitmap *bitmap, unsigned long s, unsigned long e);
-
-/* these are exported */
-int bitmap_startwrite(struct bitmap *bitmap, sector_t offset,
-			unsigned long sectors, int behind);
-void bitmap_endwrite(struct bitmap *bitmap, sector_t offset,
-			unsigned long sectors, int success, int behind);
-int bitmap_start_sync(struct bitmap *bitmap, sector_t offset, int *blocks, int degraded);
-void bitmap_end_sync(struct bitmap *bitmap, sector_t offset, int *blocks, int aborted);
-void bitmap_close_sync(struct bitmap *bitmap);
-void bitmap_cond_end_sync(struct bitmap *bitmap, sector_t sector);
-
-void bitmap_unplug(struct bitmap *bitmap);
-void bitmap_daemon_work(struct bitmap *bitmap);
-#endif
-
-#endif
Index: linux-2.6/include/linux/raid/linear.h
===================================================================
--- linux-2.6.orig/include/linux/raid/linear.h	2009-03-03 19:22:52.750978736 +0100
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,31 +0,0 @@
-#ifndef _LINEAR_H
-#define _LINEAR_H
-
-#include <linux/raid/md.h>
-
-struct dev_info {
-	mdk_rdev_t	*rdev;
-	sector_t	num_sectors;
-	sector_t	start_sector;
-};
-
-typedef struct dev_info dev_info_t;
-
-struct linear_private_data
-{
-	struct linear_private_data *prev;	/* earlier version */
-	dev_info_t		**hash_table;
-	sector_t		spacing;
-	sector_t		array_sectors;
-	int			sector_shift;	/* shift before dividing
-						 * by spacing
-						 */
-	dev_info_t		disks[0];
-};
-
-
-typedef struct linear_private_data linear_conf_t;
-
-#define mddev_to_conf(mddev) ((linear_conf_t *) mddev->private)
-
-#endif
Index: linux-2.6/drivers/md/multipath.c
===================================================================
--- linux-2.6.orig/drivers/md/multipath.c	2009-03-03 19:22:52.699979016 +0100
+++ linux-2.6/drivers/md/multipath.c	2009-03-03 19:22:55.928007650 +0100
@@ -19,7 +19,7 @@
  * Software Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
-#include <linux/raid/multipath.h>
+#include "multipath.h"
 
 #define MAX_WORK_PER_DISK 128
 
Index: linux-2.6/drivers/md/multipath.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6/drivers/md/multipath.h	2009-03-03 19:22:55.929008616 +0100
@@ -0,0 +1,42 @@
+#ifndef _MULTIPATH_H
+#define _MULTIPATH_H
+
+#include <linux/raid/md.h>
+
+struct multipath_info {
+	mdk_rdev_t	*rdev;
+};
+
+struct multipath_private_data {
+	mddev_t			*mddev;
+	struct multipath_info	*multipaths;
+	int			raid_disks;
+	int			working_disks;
+	spinlock_t		device_lock;
+	struct list_head	retry_list;
+
+	mempool_t		*pool;
+};
+
+typedef struct multipath_private_data multipath_conf_t;
+
+/*
+ * this is the only point in the RAID code where we violate
+ * C type safety. mddev->private is an 'opaque' pointer.
+ */
+#define mddev_to_conf(mddev) ((multipath_conf_t *) mddev->private)
+
+/*
+ * this is our 'private' 'collective' MULTIPATH buffer head.
+ * it contains information about what kind of IO operations were started
+ * for this MULTIPATH operation, and about their status:
+ */
+
+struct multipath_bh {
+	mddev_t			*mddev;
+	struct bio		*master_bio;
+	struct bio		bio;
+	int			path;
+	struct list_head	retry_list;
+};
+#endif
Index: linux-2.6/include/linux/raid/multipath.h
===================================================================
--- linux-2.6.orig/include/linux/raid/multipath.h	2009-03-03 19:22:52.754978966 +0100
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,42 +0,0 @@
-#ifndef _MULTIPATH_H
-#define _MULTIPATH_H
-
-#include <linux/raid/md.h>
-
-struct multipath_info {
-	mdk_rdev_t	*rdev;
-};
-
-struct multipath_private_data {
-	mddev_t			*mddev;
-	struct multipath_info	*multipaths;
-	int			raid_disks;
-	int			working_disks;
-	spinlock_t		device_lock;
-	struct list_head	retry_list;
-
-	mempool_t		*pool;
-};
-
-typedef struct multipath_private_data multipath_conf_t;
-
-/*
- * this is the only point in the RAID code where we violate
- * C type safety. mddev->private is an 'opaque' pointer.
- */
-#define mddev_to_conf(mddev) ((multipath_conf_t *) mddev->private)
-
-/*
- * this is our 'private' 'collective' MULTIPATH buffer head.
- * it contains information about what kind of IO operations were started
- * for this MULTIPATH operation, and about their status:
- */
-
-struct multipath_bh {
-	mddev_t			*mddev;
-	struct bio		*master_bio;
-	struct bio		bio;
-	int			path;
-	struct list_head	retry_list;
-};
-#endif
Index: linux-2.6/drivers/md/raid0.c
===================================================================
--- linux-2.6.orig/drivers/md/raid0.c	2009-03-03 19:22:52.724978288 +0100
+++ linux-2.6/drivers/md/raid0.c	2009-03-03 19:22:55.929008616 +0100
@@ -18,7 +18,7 @@
    Software Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.  
 */
 
-#include <linux/raid/raid0.h>
+#include "raid0.h"
 
 static void raid0_unplug(struct request_queue *q)
 {
Index: linux-2.6/drivers/md/raid0.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6/drivers/md/raid0.h	2009-03-03 19:22:55.930011118 +0100
@@ -0,0 +1,30 @@
+#ifndef _RAID0_H
+#define _RAID0_H
+
+#include <linux/raid/md.h>
+
+struct strip_zone
+{
+	sector_t zone_start;	/* Zone offset in md_dev (in sectors) */
+	sector_t dev_start;	/* Zone offset in real dev (in sectors) */
+	sector_t sectors;	/* Zone size in sectors */
+	int nb_dev;		/* # of devices attached to the zone */
+	mdk_rdev_t **dev;	/* Devices attached to the zone */
+};
+
+struct raid0_private_data
+{
+	struct strip_zone **hash_table; /* Table of indexes into strip_zone */
+	struct strip_zone *strip_zone;
+	mdk_rdev_t **devlist; /* lists of rdevs, pointed to by strip_zone->dev */
+	int nr_strip_zones;
+
+	sector_t spacing;
+	int sector_shift; /* shift this before divide by spacing */
+};
+
+typedef struct raid0_private_data raid0_conf_t;
+
+#define mddev_to_conf(mddev) ((raid0_conf_t *) mddev->private)
+
+#endif
Index: linux-2.6/drivers/md/raid1.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6/drivers/md/raid1.h	2009-03-03 19:22:55.930011118 +0100
@@ -0,0 +1,134 @@
+#ifndef _RAID1_H
+#define _RAID1_H
+
+#include <linux/raid/md.h>
+
+typedef struct mirror_info mirror_info_t;
+
+struct mirror_info {
+	mdk_rdev_t	*rdev;
+	sector_t	head_position;
+};
+
+/*
+ * memory pools need a pointer to the mddev, so they can force an unplug
+ * when memory is tight, and a count of the number of drives that the
+ * pool was allocated for, so they know how much to allocate and free.
+ * mddev->raid_disks cannot be used, as it can change while a pool is active
+ * These two datums are stored in a kmalloced struct.
+ */
+
+struct pool_info {
+	mddev_t *mddev;
+	int	raid_disks;
+};
+
+
+typedef struct r1bio_s r1bio_t;
+
+struct r1_private_data_s {
+	mddev_t			*mddev;
+	mirror_info_t		*mirrors;
+	int			raid_disks;
+	int			last_used;
+	sector_t		next_seq_sect;
+	spinlock_t		device_lock;
+
+	struct list_head	retry_list;
+	/* queue pending writes and submit them on unplug */
+	struct bio_list		pending_bio_list;
+	/* queue of writes that have been unplugged */
+	struct bio_list		flushing_bio_list;
+
+	/* for use when syncing mirrors: */
+
+	spinlock_t		resync_lock;
+	int			nr_pending;
+	int			nr_waiting;
+	int			nr_queued;
+	int			barrier;
+	sector_t		next_resync;
+	int			fullsync;  /* set to 1 if a full sync is needed,
+					    * (fresh device added).
+					    * Cleared when a sync completes.
+					    */
+
+	wait_queue_head_t	wait_barrier;
+
+	struct pool_info	*poolinfo;
+
+	struct page		*tmppage;
+
+	mempool_t *r1bio_pool;
+	mempool_t *r1buf_pool;
+};
+
+typedef struct r1_private_data_s conf_t;
+
+/*
+ * this is the only point in the RAID code where we violate
+ * C type safety. mddev->private is an 'opaque' pointer.
+ */
+#define mddev_to_conf(mddev) ((conf_t *) mddev->private)
+
+/*
+ * this is our 'private' RAID1 bio.
+ *
+ * it contains information about what kind of IO operations were started
+ * for this RAID1 operation, and about their status:
+ */
+
+struct r1bio_s {
+	atomic_t		remaining; /* 'have we finished' count,
+					    * used from IRQ handlers
+					    */
+	atomic_t		behind_remaining; /* number of write-behind ios remaining
+						 * in this BehindIO request
+						 */
+	sector_t		sector;
+	int			sectors;
+	unsigned long		state;
+	mddev_t			*mddev;
+	/*
+	 * original bio going to /dev/mdx
+	 */
+	struct bio		*master_bio;
+	/*
+	 * if the IO is in READ direction, then this is where we read
+	 */
+	int			read_disk;
+
+	struct list_head	retry_list;
+	struct bitmap_update	*bitmap_update;
+	/*
+	 * if the IO is in WRITE direction, then multiple bios are used.
+	 * We choose the number when they are allocated.
+	 */
+	struct bio		*bios[0];
+	/* DO NOT PUT ANY NEW FIELDS HERE - bios array is contiguously alloced*/
+};
+
+/* when we get a read error on a read-only array, we redirect to another
+ * device without failing the first device, or trying to over-write to
+ * correct the read error.  To keep track of bad blocks on a per-bio
+ * level, we store IO_BLOCKED in the appropriate 'bios' pointer
+ */
+#define IO_BLOCKED ((struct bio*)1)
+
+/* bits for r1bio.state */
+#define	R1BIO_Uptodate	0
+#define	R1BIO_IsSync	1
+#define	R1BIO_Degraded	2
+#define	R1BIO_BehindIO	3
+#define	R1BIO_Barrier	4
+#define R1BIO_BarrierRetry 5
+/* For write-behind requests, we call bi_end_io when
+ * the last non-write-behind device completes, providing
+ * any write was successful.  Otherwise we call when
+ * any write-behind write succeeds, otherwise we call
+ * with failure when last write completes (and all failed).
+ * Record that bi_end_io was called with this flag...
+ */
+#define	R1BIO_Returned 6
+
+#endif
Index: linux-2.6/drivers/md/raid10.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6/drivers/md/raid10.h	2009-03-03 19:22:55.931007474 +0100
@@ -0,0 +1,123 @@
+#ifndef _RAID10_H
+#define _RAID10_H
+
+#include <linux/raid/md.h>
+
+typedef struct mirror_info mirror_info_t;
+
+struct mirror_info {
+	mdk_rdev_t	*rdev;
+	sector_t	head_position;
+};
+
+typedef struct r10bio_s r10bio_t;
+
+struct r10_private_data_s {
+	mddev_t			*mddev;
+	mirror_info_t		*mirrors;
+	int			raid_disks;
+	spinlock_t		device_lock;
+
+	/* geometry */
+	int			near_copies;  /* number of copies layed out raid0 style */
+	int 			far_copies;   /* number of copies layed out
+					       * at large strides across drives
+					       */
+	int			far_offset;   /* far_copies are offset by 1 stripe
+					       * instead of many
+					       */
+	int			copies;	      /* near_copies * far_copies.
+					       * must be <= raid_disks
+					       */
+	sector_t		stride;	      /* distance between far copies.
+					       * This is size / far_copies unless
+					       * far_offset, in which case it is
+					       * 1 stripe.
+					       */
+
+	int chunk_shift; /* shift from chunks to sectors */
+	sector_t chunk_mask;
+
+	struct list_head	retry_list;
+	/* queue pending writes and submit them on unplug */
+	struct bio_list		pending_bio_list;
+
+
+	spinlock_t		resync_lock;
+	int nr_pending;
+	int nr_waiting;
+	int nr_queued;
+	int barrier;
+	sector_t		next_resync;
+	int			fullsync;  /* set to 1 if a full sync is needed,
+					    * (fresh device added).
+					    * Cleared when a sync completes.
+					    */
+
+	wait_queue_head_t	wait_barrier;
+
+	mempool_t *r10bio_pool;
+	mempool_t *r10buf_pool;
+	struct page		*tmppage;
+};
+
+typedef struct r10_private_data_s conf_t;
+
+/*
+ * this is the only point in the RAID code where we violate
+ * C type safety. mddev->private is an 'opaque' pointer.
+ */
+#define mddev_to_conf(mddev) ((conf_t *) mddev->private)
+
+/*
+ * this is our 'private' RAID10 bio.
+ *
+ * it contains information about what kind of IO operations were started
+ * for this RAID10 operation, and about their status:
+ */
+
+struct r10bio_s {
+	atomic_t		remaining; /* 'have we finished' count,
+					    * used from IRQ handlers
+					    */
+	sector_t		sector;	/* virtual sector number */
+	int			sectors;
+	unsigned long		state;
+	mddev_t			*mddev;
+	/*
+	 * original bio going to /dev/mdx
+	 */
+	struct bio		*master_bio;
+	/*
+	 * if the IO is in READ direction, then this is where we read
+	 */
+	int			read_slot;
+
+	struct list_head	retry_list;
+	/*
+	 * if the IO is in WRITE direction, then multiple bios are used,
+	 * one for each copy.
+	 * When resyncing we also use one for each copy.
+	 * When reconstructing, we use 2 bios, one for read, one for write.
+	 * We choose the number when they are allocated.
+	 */
+	struct {
+		struct bio		*bio;
+		sector_t addr;
+		int devnum;
+	} devs[0];
+};
+
+/* when we get a read error on a read-only array, we redirect to another
+ * device without failing the first device, or trying to over-write to
+ * correct the read error.  To keep track of bad blocks on a per-bio
+ * level, we store IO_BLOCKED in the appropriate 'bios' pointer
+ */
+#define IO_BLOCKED ((struct bio*)1)
+
+/* bits for r10bio.state */
+#define	R10BIO_Uptodate	0
+#define	R10BIO_IsSync	1
+#define	R10BIO_IsRecover 2
+#define	R10BIO_Degraded 3
+#endif
Index: linux-2.6/include/linux/raid/raid0.h
===================================================================
--- linux-2.6.orig/include/linux/raid/raid0.h	2009-03-03 19:22:52.758977799 +0100
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,30 +0,0 @@
-#ifndef _RAID0_H
-#define _RAID0_H
-
-#include <linux/raid/md.h>
-
-struct strip_zone
-{
-	sector_t zone_start;	/* Zone offset in md_dev (in sectors) */
-	sector_t dev_start;	/* Zone offset in real dev (in sectors) */
-	sector_t sectors;	/* Zone size in sectors */
-	int nb_dev;		/* # of devices attached to the zone */
-	mdk_rdev_t **dev;	/* Devices attached to the zone */
-};
-
-struct raid0_private_data
-{
-	struct strip_zone **hash_table; /* Table of indexes into strip_zone */
-	struct strip_zone *strip_zone;
-	mdk_rdev_t **devlist; /* lists of rdevs, pointed to by strip_zone->dev */
-	int nr_strip_zones;
-
-	sector_t spacing;
-	int sector_shift; /* shift this before divide by spacing */
-};
-
-typedef struct raid0_private_data raid0_conf_t;
-
-#define mddev_to_conf(mddev) ((raid0_conf_t *) mddev->private)
-
-#endif
Index: linux-2.6/include/linux/raid/raid1.h
===================================================================
--- linux-2.6.orig/include/linux/raid/raid1.h	2009-03-03 19:22:52.762978518 +0100
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,134 +0,0 @@
-#ifndef _RAID1_H
-#define _RAID1_H
-
-#include <linux/raid/md.h>
-
-typedef struct mirror_info mirror_info_t;
-
-struct mirror_info {
-	mdk_rdev_t	*rdev;
-	sector_t	head_position;
-};
-
-/*
- * memory pools need a pointer to the mddev, so they can force an unplug
- * when memory is tight, and a count of the number of drives that the
- * pool was allocated for, so they know how much to allocate and free.
- * mddev->raid_disks cannot be used, as it can change while a pool is active
- * These two datums are stored in a kmalloced struct.
- */
-
-struct pool_info {
-	mddev_t *mddev;
-	int	raid_disks;
-};
-
-
-typedef struct r1bio_s r1bio_t;
-
-struct r1_private_data_s {
-	mddev_t			*mddev;
-	mirror_info_t		*mirrors;
-	int			raid_disks;
-	int			last_used;
-	sector_t		next_seq_sect;
-	spinlock_t		device_lock;
-
-	struct list_head	retry_list;
-	/* queue pending writes and submit them on unplug */
-	struct bio_list		pending_bio_list;
-	/* queue of writes that have been unplugged */
-	struct bio_list		flushing_bio_list;
-
-	/* for use when syncing mirrors: */
-
-	spinlock_t		resync_lock;
-	int			nr_pending;
-	int			nr_waiting;
-	int			nr_queued;
-	int			barrier;
-	sector_t		next_resync;
-	int			fullsync;  /* set to 1 if a full sync is needed,
-					    * (fresh device added).
-					    * Cleared when a sync completes.
-					    */
-
-	wait_queue_head_t	wait_barrier;
-
-	struct pool_info	*poolinfo;
-
-	struct page		*tmppage;
-
-	mempool_t *r1bio_pool;
-	mempool_t *r1buf_pool;
-};
-
-typedef struct r1_private_data_s conf_t;
-
-/*
- * this is the only point in the RAID code where we violate
- * C type safety. mddev->private is an 'opaque' pointer.
- */
-#define mddev_to_conf(mddev) ((conf_t *) mddev->private)
-
-/*
- * this is our 'private' RAID1 bio.
- *
- * it contains information about what kind of IO operations were started
- * for this RAID1 operation, and about their status:
- */
-
-struct r1bio_s {
-	atomic_t		remaining; /* 'have we finished' count,
-					    * used from IRQ handlers
-					    */
-	atomic_t		behind_remaining; /* number of write-behind ios remaining
-						 * in this BehindIO request
-						 */
-	sector_t		sector;
-	int			sectors;
-	unsigned long		state;
-	mddev_t			*mddev;
-	/*
-	 * original bio going to /dev/mdx
-	 */
-	struct bio		*master_bio;
-	/*
-	 * if the IO is in READ direction, then this is where we read
-	 */
-	int			read_disk;
-
-	struct list_head	retry_list;
-	struct bitmap_update	*bitmap_update;
-	/*
-	 * if the IO is in WRITE direction, then multiple bios are used.
-	 * We choose the number when they are allocated.
-	 */
-	struct bio		*bios[0];
-	/* DO NOT PUT ANY NEW FIELDS HERE - bios array is contiguously alloced*/
-};
-
-/* when we get a read error on a read-only array, we redirect to another
- * device without failing the first device, or trying to over-write to
- * correct the read error.  To keep track of bad blocks on a per-bio
- * level, we store IO_BLOCKED in the appropriate 'bios' pointer
- */
-#define IO_BLOCKED ((struct bio*)1)
-
-/* bits for r1bio.state */
-#define	R1BIO_Uptodate	0
-#define	R1BIO_IsSync	1
-#define	R1BIO_Degraded	2
-#define	R1BIO_BehindIO	3
-#define	R1BIO_Barrier	4
-#define R1BIO_BarrierRetry 5
-/* For write-behind requests, we call bi_end_io when
- * the last non-write-behind device completes, providing
- * any write was successful.  Otherwise we call when
- * any write-behind write succeeds, otherwise we call
- * with failure when last write completes (and all failed).
- * Record that bi_end_io was called with this flag...
- */
-#define	R1BIO_Returned 6
-
-#endif
Index: linux-2.6/include/linux/raid/raid10.h
===================================================================
--- linux-2.6.orig/include/linux/raid/raid10.h	2009-03-03 19:22:52.766978678 +0100
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,123 +0,0 @@
-#ifndef _RAID10_H
-#define _RAID10_H
-
-#include <linux/raid/md.h>
-
-typedef struct mirror_info mirror_info_t;
-
-struct mirror_info {
-	mdk_rdev_t	*rdev;
-	sector_t	head_position;
-};
-
-typedef struct r10bio_s r10bio_t;
-
-struct r10_private_data_s {
-	mddev_t			*mddev;
-	mirror_info_t		*mirrors;
-	int			raid_disks;
-	spinlock_t		device_lock;
-
-	/* geometry */
-	int			near_copies;  /* number of copies layed out raid0 style */
-	int 			far_copies;   /* number of copies layed out
-					       * at large strides across drives
-					       */
-	int			far_offset;   /* far_copies are offset by 1 stripe
-					       * instead of many
-					       */
-	int			copies;	      /* near_copies * far_copies.
-					       * must be <= raid_disks
-					       */
-	sector_t		stride;	      /* distance between far copies.
-					       * This is size / far_copies unless
-					       * far_offset, in which case it is
-					       * 1 stripe.
-					       */
-
-	int chunk_shift; /* shift from chunks to sectors */
-	sector_t chunk_mask;
-
-	struct list_head	retry_list;
-	/* queue pending writes and submit them on unplug */
-	struct bio_list		pending_bio_list;
-
-
-	spinlock_t		resync_lock;
-	int nr_pending;
-	int nr_waiting;
-	int nr_queued;
-	int barrier;
-	sector_t		next_resync;
-	int			fullsync;  /* set to 1 if a full sync is needed,
-					    * (fresh device added).
-					    * Cleared when a sync completes.
-					    */
-
-	wait_queue_head_t	wait_barrier;
-
-	mempool_t *r10bio_pool;
-	mempool_t *r10buf_pool;
-	struct page		*tmppage;
-};
-
-typedef struct r10_private_data_s conf_t;
-
-/*
- * this is the only point in the RAID code where we violate
- * C type safety. mddev->private is an 'opaque' pointer.
- */
-#define mddev_to_conf(mddev) ((conf_t *) mddev->private)
-
-/*
- * this is our 'private' RAID10 bio.
- *
- * it contains information about what kind of IO operations were started
- * for this RAID10 operation, and about their status:
- */
-
-struct r10bio_s {
-	atomic_t		remaining; /* 'have we finished' count,
-					    * used from IRQ handlers
-					    */
-	sector_t		sector;	/* virtual sector number */
-	int			sectors;
-	unsigned long		state;
-	mddev_t			*mddev;
-	/*
-	 * original bio going to /dev/mdx
-	 */
-	struct bio		*master_bio;
-	/*
-	 * if the IO is in READ direction, then this is where we read
-	 */
-	int			read_slot;
-
-	struct list_head	retry_list;
-	/*
-	 * if the IO is in WRITE direction, then multiple bios are used,
-	 * one for each copy.
-	 * When resyncing we also use one for each copy.
-	 * When reconstructing, we use 2 bios, one for read, one for write.
-	 * We choose the number when they are allocated.
-	 */
-	struct {
-		struct bio		*bio;
-		sector_t addr;
-		int devnum;
-	} devs[0];
-};
-
-/* when we get a read error on a read-only array, we redirect to another
- * device without failing the first device, or trying to over-write to
- * correct the read error.  To keep track of bad blocks on a per-bio
- * level, we store IO_BLOCKED in the appropriate 'bios' pointer
- */
-#define IO_BLOCKED ((struct bio*)1)
-
-/* bits for r10bio.state */
-#define	R10BIO_Uptodate	0
-#define	R10BIO_IsSync	1
-#define	R10BIO_IsRecover 2
-#define	R10BIO_Degraded 3
-#endif
Index: linux-2.6/drivers/md/raid6.h
===================================================================
--- linux-2.6.orig/drivers/md/raid6.h	2009-03-03 19:22:52.738978814 +0100
+++ linux-2.6/drivers/md/raid6.h	2009-03-03 19:22:55.932007880 +0100
@@ -19,7 +19,7 @@
 #define RAID6_USE_EMPTY_ZERO_PAGE 0
 
 #include <linux/raid/md.h>
-#include <linux/raid/raid5.h>
+#include "raid5.h"
 
 typedef raid5_conf_t raid6_conf_t; /* Same configuration */
 
Index: linux-2.6/drivers/md/raid5.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6/drivers/md/raid5.h	2009-03-03 19:22:55.932007880 +0100
@@ -0,0 +1,402 @@
+#ifndef _RAID5_H
+#define _RAID5_H
+
+#include <linux/raid/md.h>
+#include <linux/raid/xor.h>
+
+/*
+ *
+ * Each stripe contains one buffer per disc.  Each buffer can be in
+ * one of a number of states stored in "flags".  Changes between
+ * these states happen *almost* exclusively under a per-stripe
+ * spinlock.  Some very specific changes can happen in bi_end_io, and
+ * these are not protected by the spin lock.
+ *
+ * The flag bits that are used to represent these states are:
+ *   R5_UPTODATE and R5_LOCKED
+ *
+ * State Empty == !UPTODATE, !LOCK
+ *        We have no data, and there is no active request
+ * State Want == !UPTODATE, LOCK
+ *        A read request is being submitted for this block
+ * State Dirty == UPTODATE, LOCK
+ *        Some new data is in this buffer, and it is being written out
+ * State Clean == UPTODATE, !LOCK
+ *        We have valid data which is the same as on disc
+ *
+ * The possible state transitions are:
+ *
+ *  Empty -> Want   - on read or write to get old data for  parity calc
+ *  Empty -> Dirty  - on compute_parity to satisfy write/sync request.(RECONSTRUCT_WRITE)
+ *  Empty -> Clean  - on compute_block when computing a block for failed drive
+ *  Want  -> Empty  - on failed read
+ *  Want  -> Clean  - on successful completion of read request
+ *  Dirty -> Clean  - on successful completion of write request
+ *  Dirty -> Clean  - on failed write
+ *  Clean -> Dirty  - on compute_parity to satisfy write/sync (RECONSTRUCT or RMW)
+ *
+ * The Want->Empty, Want->Clean, Dirty->Clean, transitions
+ * all happen in b_end_io at interrupt time.
+ * Each sets the Uptodate bit before releasing the Lock bit.
+ * This leaves one multi-stage transition:
+ *    Want->Dirty->Clean
+ * This is safe because thinking that a Clean buffer is actually dirty
+ * will at worst delay some action, and the stripe will be scheduled
+ * for attention after the transition is complete.
+ *
+ * There is one possibility that is not covered by these states.  That
+ * is if one drive has failed and there is a spare being rebuilt.  We
+ * can't distinguish between a clean block that has been generated
+ * from parity calculations, and a clean block that has been
+ * successfully written to the spare ( or to parity when resyncing).
+ * To distingush these states we have a stripe bit STRIPE_INSYNC that
+ * is set whenever a write is scheduled to the spare, or to the parity
+ * disc if there is no spare.  A sync request clears this bit, and
+ * when we find it set with no buffers locked, we know the sync is
+ * complete.
+ *
+ * Buffers for the md device that arrive via make_request are attached
+ * to the appropriate stripe in one of two lists linked on b_reqnext.
+ * One list (bh_read) for read requests, one (bh_write) for write.
+ * There should never be more than one buffer on the two lists
+ * together, but we are not guaranteed of that so we allow for more.
+ *
+ * If a buffer is on the read list when the associated cache buffer is
+ * Uptodate, the data is copied into the read buffer and it's b_end_io
+ * routine is called.  This may happen in the end_request routine only
+ * if the buffer has just successfully been read.  end_request should
+ * remove the buffers from the list and then set the Uptodate bit on
+ * the buffer.  Other threads may do this only if they first check
+ * that the Uptodate bit is set.  Once they have checked that they may
+ * take buffers off the read queue.
+ *
+ * When a buffer on the write list is committed for write it is copied
+ * into the cache buffer, which is then marked dirty, and moved onto a
+ * third list, the written list (bh_written).  Once both the parity
+ * block and the cached buffer are successfully written, any buffer on
+ * a written list can be returned with b_end_io.
+ *
+ * The write list and read list both act as fifos.  The read list is
+ * protected by the device_lock.  The write and written lists are
+ * protected by the stripe lock.  The device_lock, which can be
+ * claimed while the stipe lock is held, is only for list
+ * manipulations and will only be held for a very short time.  It can
+ * be claimed from interrupts.
+ *
+ *
+ * Stripes in the stripe cache can be on one of two lists (or on
+ * neither).  The "inactive_list" contains stripes which are not
+ * currently being used for any request.  They can freely be reused
+ * for another stripe.  The "handle_list" contains stripes that need
+ * to be handled in some way.  Both of these are fifo queues.  Each
+ * stripe is also (potentially) linked to a hash bucket in the hash
+ * table so that it can be found by sector number.  Stripes that are
+ * not hashed must be on the inactive_list, and will normally be at
+ * the front.  All stripes start life this way.
+ *
+ * The inactive_list, handle_list and hash bucket lists are all protected by the
+ * device_lock.
+ *  - stripes on the inactive_list never have their stripe_lock held.
+ *  - stripes have a reference counter. If count==0, they are on a list.
+ *  - If a stripe might need handling, STRIPE_HANDLE is set.
+ *  - When refcount reaches zero, then if STRIPE_HANDLE it is put on
+ *    handle_list else inactive_list
+ *
+ * This, combined with the fact that STRIPE_HANDLE is only ever
+ * cleared while a stripe has a non-zero count means that if the
+ * refcount is 0 and STRIPE_HANDLE is set, then it is on the
+ * handle_list and if recount is 0 and STRIPE_HANDLE is not set, then
+ * the stripe is on inactive_list.
+ *
+ * The possible transitions are:
+ *  activate an unhashed/inactive stripe (get_active_stripe())
+ *     lockdev check-hash unlink-stripe cnt++ clean-stripe hash-stripe unlockdev
+ *  activate a hashed, possibly active stripe (get_active_stripe())
+ *     lockdev check-hash if(!cnt++)unlink-stripe unlockdev
+ *  attach a request to an active stripe (add_stripe_bh())
+ *     lockdev attach-buffer unlockdev
+ *  handle a stripe (handle_stripe())
+ *     lockstripe clrSTRIPE_HANDLE ...
+ *		(lockdev check-buffers unlockdev) ..
+ *		change-state ..
+ *		record io/ops needed unlockstripe schedule io/ops
+ *  release an active stripe (release_stripe())
+ *     lockdev if (!--cnt) { if  STRIPE_HANDLE, add to handle_list else add to inactive-list } unlockdev
+ *
+ * The refcount counts each thread that have activated the stripe,
+ * plus raid5d if it is handling it, plus one for each active request
+ * on a cached buffer, and plus one if the stripe is undergoing stripe
+ * operations.
+ *
+ * Stripe operations are performed outside the stripe lock,
+ * the stripe operations are:
+ * -copying data between the stripe cache and user application buffers
+ * -computing blocks to save a disk access, or to recover a missing block
+ * -updating the parity on a write operation (reconstruct write and
+ *  read-modify-write)
+ * -checking parity correctness
+ * -running i/o to disk
+ * These operations are carried out by raid5_run_ops which uses the async_tx
+ * api to (optionally) offload operations to dedicated hardware engines.
+ * When requesting an operation handle_stripe sets the pending bit for the
+ * operation and increments the count.  raid5_run_ops is then run whenever
+ * the count is non-zero.
+ * There are some critical dependencies between the operations that prevent some
+ * from being requested while another is in flight.
+ * 1/ Parity check operations destroy the in cache version of the parity block,
+ *    so we prevent parity dependent operations like writes and compute_blocks
+ *    from starting while a check is in progress.  Some dma engines can perform
+ *    the check without damaging the parity block, in these cases the parity
+ *    block is re-marked up to date (assuming the check was successful) and is
+ *    not re-read from disk.
+ * 2/ When a write operation is requested we immediately lock the affected
+ *    blocks, and mark them as not up to date.  This causes new read requests
+ *    to be held off, as well as parity checks and compute block operations.
+ * 3/ Once a compute block operation has been requested handle_stripe treats
+ *    that block as if it is up to date.  raid5_run_ops guaruntees that any
+ *    operation that is dependent on the compute block result is initiated after
+ *    the compute block completes.
+ */
+
+/*
+ * Operations state - intermediate states that are visible outside of sh->lock
+ * In general _idle indicates nothing is running, _run indicates a data
+ * processing operation is active, and _result means the data processing result
+ * is stable and can be acted upon.  For simple operations like biofill and
+ * compute that only have an _idle and _run state they are indicated with
+ * sh->state flags (STRIPE_BIOFILL_RUN and STRIPE_COMPUTE_RUN)
+ */
+/**
+ * enum check_states - handles syncing / repairing a stripe
+ * @check_state_idle - check operations are quiesced
+ * @check_state_run - check operation is running
+ * @check_state_result - set outside lock when check result is valid
+ * @check_state_compute_run - check failed and we are repairing
+ * @check_state_compute_result - set outside lock when compute result is valid
+ */
+enum check_states {
+	check_state_idle = 0,
+	check_state_run, /* parity check */
+	check_state_check_result,
+	check_state_compute_run, /* parity repair */
+	check_state_compute_result,
+};
+
+/**
+ * enum reconstruct_states - handles writing or expanding a stripe
+ */
+enum reconstruct_states {
+	reconstruct_state_idle = 0,
+	reconstruct_state_prexor_drain_run,	/* prexor-write */
+	reconstruct_state_drain_run,		/* write */
+	reconstruct_state_run,			/* expand */
+	reconstruct_state_prexor_drain_result,
+	reconstruct_state_drain_result,
+	reconstruct_state_result,
+};
+
+struct stripe_head {
+	struct hlist_node	hash;
+	struct list_head	lru;			/* inactive_list or handle_list */
+	struct raid5_private_data	*raid_conf;
+	sector_t		sector;			/* sector of this row */
+	int			pd_idx;			/* parity disk index */
+	unsigned long		state;			/* state flags */
+	atomic_t		count;			/* nr of active thread/requests */
+	spinlock_t		lock;
+	int			bm_seq;	/* sequence number for bitmap flushes */
+	int			disks;			/* disks in stripe */
+	enum check_states	check_state;
+	enum reconstruct_states reconstruct_state;
+	/* stripe_operations
+	 * @target - STRIPE_OP_COMPUTE_BLK target
+	 */
+	struct stripe_operations {
+		int		   target;
+		u32		   zero_sum_result;
+	} ops;
+	struct r5dev {
+		struct bio	req;
+		struct bio_vec	vec;
+		struct page	*page;
+		struct bio	*toread, *read, *towrite, *written;
+		sector_t	sector;			/* sector of this page */
+		unsigned long	flags;
+	} dev[1]; /* allocated with extra space depending of RAID geometry */
+};
+
+/* stripe_head_state - collects and tracks the dynamic state of a stripe_head
+ *     for handle_stripe.  It is only valid under spin_lock(sh->lock);
+ */
+struct stripe_head_state {
+	int syncing, expanding, expanded;
+	int locked, uptodate, to_read, to_write, failed, written;
+	int to_fill, compute, req_compute, non_overwrite;
+	int failed_num;
+	unsigned long ops_request;
+};
+
+/* r6_state - extra state data only relevant to r6 */
+struct r6_state {
+	int p_failed, q_failed, qd_idx, failed_num[2];
+};
+
+/* Flags */
+#define	R5_UPTODATE	0	/* page contains current data */
+#define	R5_LOCKED	1	/* IO has been submitted on "req" */
+#define	R5_OVERWRITE	2	/* towrite covers whole page */
+/* and some that are internal to handle_stripe */
+#define	R5_Insync	3	/* rdev && rdev->in_sync at start */
+#define	R5_Wantread	4	/* want to schedule a read */
+#define	R5_Wantwrite	5
+#define	R5_Overlap	7	/* There is a pending overlapping request on this block */
+#define	R5_ReadError	8	/* seen a read error here recently */
+#define	R5_ReWrite	9	/* have tried to over-write the readerror */
+
+#define	R5_Expanded	10	/* This block now has post-expand data */
+#define	R5_Wantcompute	11 /* compute_block in progress treat as
+				    * uptodate
+				    */
+#define	R5_Wantfill	12 /* dev->toread contains a bio that needs
+				    * filling
+				    */
+#define R5_Wantdrain	13 /* dev->towrite needs to be drained */
+/*
+ * Write method
+ */
+#define RECONSTRUCT_WRITE	1
+#define READ_MODIFY_WRITE	2
+/* not a write method, but a compute_parity mode */
+#define	CHECK_PARITY		3
+
+/*
+ * Stripe state
+ */
+#define STRIPE_HANDLE		2
+#define	STRIPE_SYNCING		3
+#define	STRIPE_INSYNC		4
+#define	STRIPE_PREREAD_ACTIVE	5
+#define	STRIPE_DELAYED		6
+#define	STRIPE_DEGRADED		7
+#define	STRIPE_BIT_DELAY	8
+#define	STRIPE_EXPANDING	9
+#define	STRIPE_EXPAND_SOURCE	10
+#define	STRIPE_EXPAND_READY	11
+#define	STRIPE_IO_STARTED	12 /* do not count towards 'bypass_count' */
+#define	STRIPE_FULL_WRITE	13 /* all blocks are set to be overwritten */
+#define	STRIPE_BIOFILL_RUN	14
+#define	STRIPE_COMPUTE_RUN	15
+/*
+ * Operation request flags
+ */
+#define STRIPE_OP_BIOFILL	0
+#define STRIPE_OP_COMPUTE_BLK	1
+#define STRIPE_OP_PREXOR	2
+#define STRIPE_OP_BIODRAIN	3
+#define STRIPE_OP_POSTXOR	4
+#define STRIPE_OP_CHECK	5
+
+/*
+ * Plugging:
+ *
+ * To improve write throughput, we need to delay the handling of some
+ * stripes until there has been a chance that several write requests
+ * for the one stripe have all been collected.
+ * In particular, any write request that would require pre-reading
+ * is put on a "delayed" queue until there are no stripes currently
+ * in a pre-read phase.  Further, if the "delayed" queue is empty when
+ * a stripe is put on it then we "plug" the queue and do not process it
+ * until an unplug call is made. (the unplug_io_fn() is called).
+ *
+ * When preread is initiated on a stripe, we set PREREAD_ACTIVE and add
+ * it to the count of prereading stripes.
+ * When write is initiated, or the stripe refcnt == 0 (just in case) we
+ * clear the PREREAD_ACTIVE flag and decrement the count
+ * Whenever the 'handle' queue is empty and the device is not plugged, we
+ * move any strips from delayed to handle and clear the DELAYED flag and set
+ * PREREAD_ACTIVE.
+ * In stripe_handle, if we find pre-reading is necessary, we do it if
+ * PREREAD_ACTIVE is set, else we set DELAYED which will send it to the delayed queue.
+ * HANDLE gets cleared if stripe_handle leave nothing locked.
+ */
+
+
+struct disk_info {
+	mdk_rdev_t	*rdev;
+};
+
+struct raid5_private_data {
+	struct hlist_head	*stripe_hashtbl;
+	mddev_t			*mddev;
+	struct disk_info	*spare;
+	int			chunk_size, level, algorithm;
+	int			max_degraded;
+	int			raid_disks;
+	int			max_nr_stripes;
+
+	/* used during an expand */
+	sector_t		expand_progress;	/* MaxSector when no expand happening */
+	sector_t		expand_lo; /* from here up to expand_progress it out-of-bounds
+					    * as we haven't flushed the metadata yet
+					    */
+	int			previous_raid_disks;
+
+	struct list_head	handle_list; /* stripes needing handling */
+	struct list_head	hold_list; /* preread ready stripes */
+	struct list_head	delayed_list; /* stripes that have plugged requests */
+	struct list_head	bitmap_list; /* stripes delaying awaiting bitmap update */
+	struct bio		*retry_read_aligned; /* currently retrying aligned bios   */
+	struct bio		*retry_read_aligned_list; /* aligned bios retry list  */
+	atomic_t		preread_active_stripes; /* stripes with scheduled io */
+	atomic_t		active_aligned_reads;
+	atomic_t		pending_full_writes; /* full write backlog */
+	int			bypass_count; /* bypassed prereads */
+	int			bypass_threshold; /* preread nice */
+	struct list_head	*last_hold; /* detect hold_list promotions */
+
+	atomic_t		reshape_stripes; /* stripes with pending writes for reshape */
+	/* unfortunately we need two cache names as we temporarily have
+	 * two caches.
+	 */
+	int			active_name;
+	char			cache_name[2][20];
+	struct kmem_cache		*slab_cache; /* for allocating stripes */
+
+	int			seq_flush, seq_write;
+	int			quiesce;
+
+	int			fullsync;  /* set to 1 if a full sync is needed,
+					    * (fresh device added).
+					    * Cleared when a sync completes.
+					    */
+
+	struct page 		*spare_page; /* Used when checking P/Q in raid6 */
+
+	/*
+	 * Free stripes pool
+	 */
+	atomic_t		active_stripes;
+	struct list_head	inactive_list;
+	wait_queue_head_t	wait_for_stripe;
+	wait_queue_head_t	wait_for_overlap;
+	int			inactive_blocked;	/* release of inactive stripes blocked,
+							 * waiting for 25% to be free
+							 */
+	int			pool_size; /* number of disks in stripeheads in pool */
+	spinlock_t		device_lock;
+	struct disk_info	*disks;
+};
+
+typedef struct raid5_private_data raid5_conf_t;
+
+#define mddev_to_conf(mddev) ((raid5_conf_t *) mddev->private)
+
+/*
+ * Our supported algorithms
+ */
+#define ALGORITHM_LEFT_ASYMMETRIC	0
+#define ALGORITHM_RIGHT_ASYMMETRIC	1
+#define ALGORITHM_LEFT_SYMMETRIC	2
+#define ALGORITHM_RIGHT_SYMMETRIC	3
+
+#endif
Index: linux-2.6/include/linux/raid/raid5.h
===================================================================
--- linux-2.6.orig/include/linux/raid/raid5.h	2009-03-03 19:22:52.773978592 +0100
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,402 +0,0 @@
-#ifndef _RAID5_H
-#define _RAID5_H
-
-#include <linux/raid/md.h>
-#include <linux/raid/xor.h>
-
-/*
- *
- * Each stripe contains one buffer per disc.  Each buffer can be in
- * one of a number of states stored in "flags".  Changes between
- * these states happen *almost* exclusively under a per-stripe
- * spinlock.  Some very specific changes can happen in bi_end_io, and
- * these are not protected by the spin lock.
- *
- * The flag bits that are used to represent these states are:
- *   R5_UPTODATE and R5_LOCKED
- *
- * State Empty == !UPTODATE, !LOCK
- *        We have no data, and there is no active request
- * State Want == !UPTODATE, LOCK
- *        A read request is being submitted for this block
- * State Dirty == UPTODATE, LOCK
- *        Some new data is in this buffer, and it is being written out
- * State Clean == UPTODATE, !LOCK
- *        We have valid data which is the same as on disc
- *
- * The possible state transitions are:
- *
- *  Empty -> Want   - on read or write to get old data for  parity calc
- *  Empty -> Dirty  - on compute_parity to satisfy write/sync request.(RECONSTRUCT_WRITE)
- *  Empty -> Clean  - on compute_block when computing a block for failed drive
- *  Want  -> Empty  - on failed read
- *  Want  -> Clean  - on successful completion of read request
- *  Dirty -> Clean  - on successful completion of write request
- *  Dirty -> Clean  - on failed write
- *  Clean -> Dirty  - on compute_parity to satisfy write/sync (RECONSTRUCT or RMW)
- *
- * The Want->Empty, Want->Clean, Dirty->Clean, transitions
- * all happen in b_end_io at interrupt time.
- * Each sets the Uptodate bit before releasing the Lock bit.
- * This leaves one multi-stage transition:
- *    Want->Dirty->Clean
- * This is safe because thinking that a Clean buffer is actually dirty
- * will at worst delay some action, and the stripe will be scheduled
- * for attention after the transition is complete.
- *
- * There is one possibility that is not covered by these states.  That
- * is if one drive has failed and there is a spare being rebuilt.  We
- * can't distinguish between a clean block that has been generated
- * from parity calculations, and a clean block that has been
- * successfully written to the spare ( or to parity when resyncing).
- * To distingush these states we have a stripe bit STRIPE_INSYNC that
- * is set whenever a write is scheduled to the spare, or to the parity
- * disc if there is no spare.  A sync request clears this bit, and
- * when we find it set with no buffers locked, we know the sync is
- * complete.
- *
- * Buffers for the md device that arrive via make_request are attached
- * to the appropriate stripe in one of two lists linked on b_reqnext.
- * One list (bh_read) for read requests, one (bh_write) for write.
- * There should never be more than one buffer on the two lists
- * together, but we are not guaranteed of that so we allow for more.
- *
- * If a buffer is on the read list when the associated cache buffer is
- * Uptodate, the data is copied into the read buffer and it's b_end_io
- * routine is called.  This may happen in the end_request routine only
- * if the buffer has just successfully been read.  end_request should
- * remove the buffers from the list and then set the Uptodate bit on
- * the buffer.  Other threads may do this only if they first check
- * that the Uptodate bit is set.  Once they have checked that they may
- * take buffers off the read queue.
- *
- * When a buffer on the write list is committed for write it is copied
- * into the cache buffer, which is then marked dirty, and moved onto a
- * third list, the written list (bh_written).  Once both the parity
- * block and the cached buffer are successfully written, any buffer on
- * a written list can be returned with b_end_io.
- *
- * The write list and read list both act as fifos.  The read list is
- * protected by the device_lock.  The write and written lists are
- * protected by the stripe lock.  The device_lock, which can be
- * claimed while the stipe lock is held, is only for list
- * manipulations and will only be held for a very short time.  It can
- * be claimed from interrupts.
- *
- *
- * Stripes in the stripe cache can be on one of two lists (or on
- * neither).  The "inactive_list" contains stripes which are not
- * currently being used for any request.  They can freely be reused
- * for another stripe.  The "handle_list" contains stripes that need
- * to be handled in some way.  Both of these are fifo queues.  Each
- * stripe is also (potentially) linked to a hash bucket in the hash
- * table so that it can be found by sector number.  Stripes that are
- * not hashed must be on the inactive_list, and will normally be at
- * the front.  All stripes start life this way.
- *
- * The inactive_list, handle_list and hash bucket lists are all protected by the
- * device_lock.
- *  - stripes on the inactive_list never have their stripe_lock held.
- *  - stripes have a reference counter. If count==0, they are on a list.
- *  - If a stripe might need handling, STRIPE_HANDLE is set.
- *  - When refcount reaches zero, then if STRIPE_HANDLE it is put on
- *    handle_list else inactive_list
- *
- * This, combined with the fact that STRIPE_HANDLE is only ever
- * cleared while a stripe has a non-zero count means that if the
- * refcount is 0 and STRIPE_HANDLE is set, then it is on the
- * handle_list and if recount is 0 and STRIPE_HANDLE is not set, then
- * the stripe is on inactive_list.
- *
- * The possible transitions are:
- *  activate an unhashed/inactive stripe (get_active_stripe())
- *     lockdev check-hash unlink-stripe cnt++ clean-stripe hash-stripe unlockdev
- *  activate a hashed, possibly active stripe (get_active_stripe())
- *     lockdev check-hash if(!cnt++)unlink-stripe unlockdev
- *  attach a request to an active stripe (add_stripe_bh())
- *     lockdev attach-buffer unlockdev
- *  handle a stripe (handle_stripe())
- *     lockstripe clrSTRIPE_HANDLE ...
- *		(lockdev check-buffers unlockdev) ..
- *		change-state ..
- *		record io/ops needed unlockstripe schedule io/ops
- *  release an active stripe (release_stripe())
- *     lockdev if (!--cnt) { if  STRIPE_HANDLE, add to handle_list else add to inactive-list } unlockdev
- *
- * The refcount counts each thread that have activated the stripe,
- * plus raid5d if it is handling it, plus one for each active request
- * on a cached buffer, and plus one if the stripe is undergoing stripe
- * operations.
- *
- * Stripe operations are performed outside the stripe lock,
- * the stripe operations are:
- * -copying data between the stripe cache and user application buffers
- * -computing blocks to save a disk access, or to recover a missing block
- * -updating the parity on a write operation (reconstruct write and
- *  read-modify-write)
- * -checking parity correctness
- * -running i/o to disk
- * These operations are carried out by raid5_run_ops which uses the async_tx
- * api to (optionally) offload operations to dedicated hardware engines.
- * When requesting an operation handle_stripe sets the pending bit for the
- * operation and increments the count.  raid5_run_ops is then run whenever
- * the count is non-zero.
- * There are some critical dependencies between the operations that prevent some
- * from being requested while another is in flight.
- * 1/ Parity check operations destroy the in cache version of the parity block,
- *    so we prevent parity dependent operations like writes and compute_blocks
- *    from starting while a check is in progress.  Some dma engines can perform
- *    the check without damaging the parity block, in these cases the parity
- *    block is re-marked up to date (assuming the check was successful) and is
- *    not re-read from disk.
- * 2/ When a write operation is requested we immediately lock the affected
- *    blocks, and mark them as not up to date.  This causes new read requests
- *    to be held off, as well as parity checks and compute block operations.
- * 3/ Once a compute block operation has been requested handle_stripe treats
- *    that block as if it is up to date.  raid5_run_ops guaruntees that any
- *    operation that is dependent on the compute block result is initiated after
- *    the compute block completes.
- */
-
-/*
- * Operations state - intermediate states that are visible outside of sh->lock
- * In general _idle indicates nothing is running, _run indicates a data
- * processing operation is active, and _result means the data processing result
- * is stable and can be acted upon.  For simple operations like biofill and
- * compute that only have an _idle and _run state they are indicated with
- * sh->state flags (STRIPE_BIOFILL_RUN and STRIPE_COMPUTE_RUN)
- */
-/**
- * enum check_states - handles syncing / repairing a stripe
- * @check_state_idle - check operations are quiesced
- * @check_state_run - check operation is running
- * @check_state_result - set outside lock when check result is valid
- * @check_state_compute_run - check failed and we are repairing
- * @check_state_compute_result - set outside lock when compute result is valid
- */
-enum check_states {
-	check_state_idle = 0,
-	check_state_run, /* parity check */
-	check_state_check_result,
-	check_state_compute_run, /* parity repair */
-	check_state_compute_result,
-};
-
-/**
- * enum reconstruct_states - handles writing or expanding a stripe
- */
-enum reconstruct_states {
-	reconstruct_state_idle = 0,
-	reconstruct_state_prexor_drain_run,	/* prexor-write */
-	reconstruct_state_drain_run,		/* write */
-	reconstruct_state_run,			/* expand */
-	reconstruct_state_prexor_drain_result,
-	reconstruct_state_drain_result,
-	reconstruct_state_result,
-};
-
-struct stripe_head {
-	struct hlist_node	hash;
-	struct list_head	lru;			/* inactive_list or handle_list */
-	struct raid5_private_data	*raid_conf;
-	sector_t		sector;			/* sector of this row */
-	int			pd_idx;			/* parity disk index */
-	unsigned long		state;			/* state flags */
-	atomic_t		count;			/* nr of active thread/requests */
-	spinlock_t		lock;
-	int			bm_seq;	/* sequence number for bitmap flushes */
-	int			disks;			/* disks in stripe */
-	enum check_states	check_state;
-	enum reconstruct_states reconstruct_state;
-	/* stripe_operations
-	 * @target - STRIPE_OP_COMPUTE_BLK target
-	 */
-	struct stripe_operations {
-		int		   target;
-		u32		   zero_sum_result;
-	} ops;
-	struct r5dev {
-		struct bio	req;
-		struct bio_vec	vec;
-		struct page	*page;
-		struct bio	*toread, *read, *towrite, *written;
-		sector_t	sector;			/* sector of this page */
-		unsigned long	flags;
-	} dev[1]; /* allocated with extra space depending of RAID geometry */
-};
-
-/* stripe_head_state - collects and tracks the dynamic state of a stripe_head
- *     for handle_stripe.  It is only valid under spin_lock(sh->lock);
- */
-struct stripe_head_state {
-	int syncing, expanding, expanded;
-	int locked, uptodate, to_read, to_write, failed, written;
-	int to_fill, compute, req_compute, non_overwrite;
-	int failed_num;
-	unsigned long ops_request;
-};
-
-/* r6_state - extra state data only relevant to r6 */
-struct r6_state {
-	int p_failed, q_failed, qd_idx, failed_num[2];
-};
-
-/* Flags */
-#define	R5_UPTODATE	0	/* page contains current data */
-#define	R5_LOCKED	1	/* IO has been submitted on "req" */
-#define	R5_OVERWRITE	2	/* towrite covers whole page */
-/* and some that are internal to handle_stripe */
-#define	R5_Insync	3	/* rdev && rdev->in_sync at start */
-#define	R5_Wantread	4	/* want to schedule a read */
-#define	R5_Wantwrite	5
-#define	R5_Overlap	7	/* There is a pending overlapping request on this block */
-#define	R5_ReadError	8	/* seen a read error here recently */
-#define	R5_ReWrite	9	/* have tried to over-write the readerror */
-
-#define	R5_Expanded	10	/* This block now has post-expand data */
-#define	R5_Wantcompute	11 /* compute_block in progress treat as
-				    * uptodate
-				    */
-#define	R5_Wantfill	12 /* dev->toread contains a bio that needs
-				    * filling
-				    */
-#define R5_Wantdrain	13 /* dev->towrite needs to be drained */
-/*
- * Write method
- */
-#define RECONSTRUCT_WRITE	1
-#define READ_MODIFY_WRITE	2
-/* not a write method, but a compute_parity mode */
-#define	CHECK_PARITY		3
-
-/*
- * Stripe state
- */
-#define STRIPE_HANDLE		2
-#define	STRIPE_SYNCING		3
-#define	STRIPE_INSYNC		4
-#define	STRIPE_PREREAD_ACTIVE	5
-#define	STRIPE_DELAYED		6
-#define	STRIPE_DEGRADED		7
-#define	STRIPE_BIT_DELAY	8
-#define	STRIPE_EXPANDING	9
-#define	STRIPE_EXPAND_SOURCE	10
-#define	STRIPE_EXPAND_READY	11
-#define	STRIPE_IO_STARTED	12 /* do not count towards 'bypass_count' */
-#define	STRIPE_FULL_WRITE	13 /* all blocks are set to be overwritten */
-#define	STRIPE_BIOFILL_RUN	14
-#define	STRIPE_COMPUTE_RUN	15
-/*
- * Operation request flags
- */
-#define STRIPE_OP_BIOFILL	0
-#define STRIPE_OP_COMPUTE_BLK	1
-#define STRIPE_OP_PREXOR	2
-#define STRIPE_OP_BIODRAIN	3
-#define STRIPE_OP_POSTXOR	4
-#define STRIPE_OP_CHECK	5
-
-/*
- * Plugging:
- *
- * To improve write throughput, we need to delay the handling of some
- * stripes until there has been a chance that several write requests
- * for the one stripe have all been collected.
- * In particular, any write request that would require pre-reading
- * is put on a "delayed" queue until there are no stripes currently
- * in a pre-read phase.  Further, if the "delayed" queue is empty when
- * a stripe is put on it then we "plug" the queue and do not process it
- * until an unplug call is made. (the unplug_io_fn() is called).
- *
- * When preread is initiated on a stripe, we set PREREAD_ACTIVE and add
- * it to the count of prereading stripes.
- * When write is initiated, or the stripe refcnt == 0 (just in case) we
- * clear the PREREAD_ACTIVE flag and decrement the count
- * Whenever the 'handle' queue is empty and the device is not plugged, we
- * move any strips from delayed to handle and clear the DELAYED flag and set
- * PREREAD_ACTIVE.
- * In stripe_handle, if we find pre-reading is necessary, we do it if
- * PREREAD_ACTIVE is set, else we set DELAYED which will send it to the delayed queue.
- * HANDLE gets cleared if stripe_handle leave nothing locked.
- */
- 
-
-struct disk_info {
-	mdk_rdev_t	*rdev;
-};
-
-struct raid5_private_data {
-	struct hlist_head	*stripe_hashtbl;
-	mddev_t			*mddev;
-	struct disk_info	*spare;
-	int			chunk_size, level, algorithm;
-	int			max_degraded;
-	int			raid_disks;
-	int			max_nr_stripes;
-
-	/* used during an expand */
-	sector_t		expand_progress;	/* MaxSector when no expand happening */
-	sector_t		expand_lo; /* from here up to expand_progress it out-of-bounds
-					    * as we haven't flushed the metadata yet
-					    */
-	int			previous_raid_disks;
-
-	struct list_head	handle_list; /* stripes needing handling */
-	struct list_head	hold_list; /* preread ready stripes */
-	struct list_head	delayed_list; /* stripes that have plugged requests */
-	struct list_head	bitmap_list; /* stripes delaying awaiting bitmap update */
-	struct bio		*retry_read_aligned; /* currently retrying aligned bios   */
-	struct bio		*retry_read_aligned_list; /* aligned bios retry list  */
-	atomic_t		preread_active_stripes; /* stripes with scheduled io */
-	atomic_t		active_aligned_reads;
-	atomic_t		pending_full_writes; /* full write backlog */
-	int			bypass_count; /* bypassed prereads */
-	int			bypass_threshold; /* preread nice */
-	struct list_head	*last_hold; /* detect hold_list promotions */
-
-	atomic_t		reshape_stripes; /* stripes with pending writes for reshape */
-	/* unfortunately we need two cache names as we temporarily have
-	 * two caches.
-	 */
-	int			active_name;
-	char			cache_name[2][20];
-	struct kmem_cache		*slab_cache; /* for allocating stripes */
-
-	int			seq_flush, seq_write;
-	int			quiesce;
-
-	int			fullsync;  /* set to 1 if a full sync is needed,
-					    * (fresh device added).
-					    * Cleared when a sync completes.
-					    */
-
-	struct page 		*spare_page; /* Used when checking P/Q in raid6 */
-
-	/*
-	 * Free stripes pool
-	 */
-	atomic_t		active_stripes;
-	struct list_head	inactive_list;
-	wait_queue_head_t	wait_for_stripe;
-	wait_queue_head_t	wait_for_overlap;
-	int			inactive_blocked;	/* release of inactive stripes blocked,
-							 * waiting for 25% to be free
-							 */
-	int			pool_size; /* number of disks in stripeheads in pool */
-	spinlock_t		device_lock;
-	struct disk_info	*disks;
-};
-
-typedef struct raid5_private_data raid5_conf_t;
-
-#define mddev_to_conf(mddev) ((raid5_conf_t *) mddev->private)
-
-/*
- * Our supported algorithms
- */
-#define ALGORITHM_LEFT_ASYMMETRIC	0
-#define ALGORITHM_RIGHT_ASYMMETRIC	1
-#define ALGORITHM_LEFT_SYMMETRIC	2
-#define ALGORITHM_RIGHT_SYMMETRIC	3
-
-#endif
