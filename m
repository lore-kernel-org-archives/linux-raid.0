From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: PATCH - raid in 2.5.15 - 3 of 3 - Initial md/raid5 support for 2.5 (with bio)
Date: Wed, 15 May 2002 15:25:02 +1000 (EST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <15585.61742.704378.111531@notabene.cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: Linus Torvalds <torvalds@transmeta.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



With this patch raid5 works.  There is still some more
work to though.

- uses bio instead of buffer_head
- stripe cache is now a fixed size.  
   If read requests are smaller, we read the whole block anyway
   If write reqeusts are smaller, we pre-read.
- stripe_head is now variable sized with an array of structures at
  the end.  We allocate extra space depending on how many devices
  are in the array.
  stripe_head has it's very own slab cache.
- store and use bdev for each device in array

by-passing the cache for reads is currently disabled.  I need to
think through the implications (and implementation) of allowing
large bion that are larger than the stripe cache to go directly
to the device (if it isn't failed of-course).

 ----------- Diffstat output ------------
 ./drivers/md/raid5.c         |  740 +++++++++++++++++++++++--------------------
 ./drivers/md/xor.c           |   13 
 ./include/linux/raid/raid5.h |   44 +-
 ./include/linux/raid/xor.h   |    2 
 4 files changed, 439 insertions(+), 360 deletions(-)

--- ./include/linux/raid/raid5.h	2002/05/15 04:23:59	1.2
+++ ./include/linux/raid/raid5.h	2002/05/15 05:00:01	1.3
@@ -7,21 +7,21 @@
 /*
  *
  * Each stripe contains one buffer per disc.  Each buffer can be in
- * one of a number of states determined by bh_state.  Changes between
+ * one of a number of states stored in "flags".  Changes between
  * these states happen *almost* exclusively under a per-stripe
- * spinlock.  Some very specific changes can happen in b_end_io, and
+ * spinlock.  Some very specific changes can happen in bi_end_io, and
  * these are not protected by the spin lock.
  *
- * The bh_state bits that are used to represent these states are:
- *   BH_Uptodate, BH_Lock
+ * The flag bits that are used to represent these states are:
+ *   R5_UPTODATE and R5_LOCKED
  *
- * State Empty == !Uptodate, !Lock
+ * State Empty == !UPTODATE, !LOCK
  *        We have no data, and there is no active request
- * State Want == !Uptodate, Lock
+ * State Want == !UPTODATE, LOCK
  *        A read request is being submitted for this block
- * State Dirty == Uptodate, Lock
+ * State Dirty == UPTODATE, LOCK
  *        Some new data is in this buffer, and it is being written out
- * State Clean == Uptodate, !Lock
+ * State Clean == UPTODATE, !LOCK
  *        We have valid data which is the same as on disc
  *
  * The possible state transitions are:
@@ -124,24 +124,29 @@
  * plus raid5d if it is handling it, plus one for each active request
  * on a cached buffer.
  */
+
 struct stripe_head {
 	struct stripe_head	*hash_next, **hash_pprev; /* hash pointers */
 	struct list_head	lru;			/* inactive_list or handle_list */
 	struct raid5_private_data	*raid_conf;
-	struct buffer_head	*bh_cache[MD_SB_DISKS];	/* buffered copy */
-	struct buffer_head	*bh_read[MD_SB_DISKS];	/* read request buffers of the MD device */
-	struct buffer_head	*bh_write[MD_SB_DISKS];	/* write request buffers of the MD device */
-	struct buffer_head	*bh_written[MD_SB_DISKS]; /* write request buffers of the MD device that have been scheduled for write */
-	struct page		*bh_page[MD_SB_DISKS];	/* saved bh_cache[n]->b_page when reading around the cache */
-	unsigned long		sector;			/* sector of this row */
-	int			size;			/* buffers size */
+	sector_t		sector;			/* sector of this row */
 	int			pd_idx;			/* parity disk index */
 	unsigned long		state;			/* state flags */
 	atomic_t		count;			/* nr of active thread/requests */
 	spinlock_t		lock;
-	int			sync_redone;
+	struct r5dev {
+		struct bio	req;
+		struct bio_vec	vec;
+		struct page	*page;
+		struct bio	*toread, *towrite, *written;
+		sector_t	sector;			/* sector of this page */
+		unsigned long	flags;
+	} dev[1]; /* allocated with extra space depending of RAID geometry */
 };
-
+/* Flags */
+#define	R5_UPTODATE	0	/* page contains current data */
+#define	R5_LOCKED	1	/* IO has been submitted on "req" */
+#define	R5_OVERWRITE	2	/* towrite covers whole page */
 
 /*
  * Write method
@@ -187,6 +192,7 @@
 
 struct disk_info {
 	kdev_t	dev;
+	struct block_device *bdev;
 	int	operational;
 	int	number;
 	int	raid_disk;
@@ -201,7 +207,6 @@
 	mdk_thread_t		*thread, *resync_thread;
 	struct disk_info	disks[MD_SB_DISKS];
 	struct disk_info	*spare;
-	int			buffer_size;
 	int			chunk_size, level, algorithm;
 	int			raid_disks, working_disks, failed_disks;
 	int			resync_parity;
@@ -210,6 +215,9 @@
 	struct list_head	handle_list; /* stripes needing handling */
 	struct list_head	delayed_list; /* stripes that have plugged requests */
 	atomic_t		preread_active_stripes; /* stripes with scheduled io */
+
+	char			cache_name[20];
+	kmem_cache_t		*slab_cache; /* for allocating stripes */
 	/*
 	 * Free stripes pool
 	 */
--- ./include/linux/raid/xor.h	2002/05/14 05:38:33	1.1
+++ ./include/linux/raid/xor.h	2002/05/15 05:00:01	1.2
@@ -5,7 +5,7 @@
 
 #define MAX_XOR_BLOCKS 5
 
-extern void xor_block(unsigned int count, struct buffer_head **bh_ptr);
+extern void xor_block(unsigned int count, unsigned int bytes, void **ptr);
 
 struct xor_block_template {
         struct xor_block_template *next;
--- ./drivers/md/raid5.c	2002/05/15 04:23:59	1.2
+++ ./drivers/md/raid5.c	2002/05/15 05:00:01	1.3
@@ -24,19 +24,19 @@
 #include <asm/bitops.h>
 #include <asm/atomic.h>
 
-static mdk_personality_t raid5_personality;
-
 /*
  * Stripe cache
  */
 
 #define NR_STRIPES		256
+#define STRIPE_SIZE		PAGE_SIZE
+#define STRIPE_SECTORS		(STRIPE_SIZE>>9)
 #define	IO_THRESHOLD		1
 #define HASH_PAGES		1
 #define HASH_PAGES_ORDER	0
 #define NR_HASH			(HASH_PAGES * PAGE_SIZE / sizeof(struct stripe_head *))
 #define HASH_MASK		(NR_HASH - 1)
-#define stripe_hash(conf, sect)	((conf)->stripe_hashtbl[((sect) / ((conf)->buffer_size >> 9)) & HASH_MASK])
+#define stripe_hash(conf, sect)	((conf)->stripe_hashtbl[((sect) / STRIPE_SECTORS) & HASH_MASK])
 
 /*
  * The following can be used to debug the driver
@@ -142,47 +142,36 @@
 
 static void shrink_buffers(struct stripe_head *sh, int num)
 {
-	struct buffer_head *bh;
+	struct page *p;
 	int i;
 
 	for (i=0; i<num ; i++) {
-		bh = sh->bh_cache[i];
-		if (!bh)
-			return;
-		sh->bh_cache[i] = NULL;
-		free_page((unsigned long) bh->b_data);
-		kfree(bh);
+		p = sh->dev[i].page;
+		if (!p)
+			continue;
+		sh->dev[i].page = NULL;
+		page_cache_release(p);
 	}
 }
 
-static int grow_buffers(struct stripe_head *sh, int num, int b_size, int priority)
+static int grow_buffers(struct stripe_head *sh, int num)
 {
-	struct buffer_head *bh;
 	int i;
 
 	for (i=0; i<num; i++) {
 		struct page *page;
-		bh = kmalloc(sizeof(struct buffer_head), priority);
-		if (!bh)
-			return 1;
-		memset(bh, 0, sizeof (struct buffer_head));
-		if ((page = alloc_page(priority)))
-			bh->b_data = page_address(page);
-		else {
-			kfree(bh);
+
+		if (!(page = alloc_page(GFP_KERNEL))) {
 			return 1;
 		}
-		atomic_set(&bh->b_count, 0);
-		bh->b_page = page;
-		sh->bh_cache[i] = bh;
-
+		sh->dev[i].page = page;
 	}
 	return 0;
 }
 
-static struct buffer_head *raid5_build_block (struct stripe_head *sh, int i);
+static void raid5_build_block (struct stripe_head *sh, int i);
 
-static inline void init_stripe(struct stripe_head *sh, unsigned long sector)
+static inline void init_stripe(struct stripe_head *sh, unsigned long sector, int pd_idx)
 {
 	raid5_conf_t *conf = sh->raid_conf;
 	int disks = conf->raid_disks, i;
@@ -198,40 +187,26 @@
 	remove_hash(sh);
 	
 	sh->sector = sector;
-	sh->size = conf->buffer_size;
+	sh->pd_idx = pd_idx;
 	sh->state = 0;
 
 	for (i=disks; i--; ) {
-		if (sh->bh_read[i] || sh->bh_write[i] || sh->bh_written[i] ||
-		    buffer_locked(sh->bh_cache[i])) {
+		struct r5dev *dev = &sh->dev[i];
+
+		if (dev->toread || dev->towrite || dev->written ||
+		    test_bit(R5_LOCKED, &dev->flags)) {
 			printk("sector=%lx i=%d %p %p %p %d\n",
-			       sh->sector, i, sh->bh_read[i],
-			       sh->bh_write[i], sh->bh_written[i],
-			       buffer_locked(sh->bh_cache[i]));
+			       sh->sector, i, dev->toread,
+			       dev->towrite, dev->written,
+			       test_bit(R5_LOCKED, &dev->flags));
 			BUG();
 		}
-		clear_buffer_uptodate(sh->bh_cache[i]);
+		dev->flags = 0;
 		raid5_build_block(sh, i);
 	}
 	insert_hash(conf, sh);
 }
 
-/* the buffer size has changed, so unhash all stripes
- * as active stripes complete, they will go onto inactive list
- */
-static void shrink_stripe_cache(raid5_conf_t *conf)
-{
-	int i;
-	CHECK_DEVLOCK();
-	if (atomic_read(&conf->active_stripes))
-		BUG();
-	for (i=0; i < NR_HASH; i++) {
-		struct stripe_head *sh;
-		while ((sh = conf->stripe_hashtbl[i])) 
-			remove_hash(sh);
-	}
-}
-
 static struct stripe_head *__find_stripe(raid5_conf_t *conf, unsigned long sector)
 {
 	struct stripe_head *sh;
@@ -245,7 +220,8 @@
 	return NULL;
 }
 
-static struct stripe_head *get_active_stripe(raid5_conf_t *conf, unsigned long sector, int size, int noblock) 
+static struct stripe_head *get_active_stripe(raid5_conf_t *conf, unsigned long sector, 
+					     int pd_idx, int noblock) 
 {
 	struct stripe_head *sh;
 
@@ -254,44 +230,6 @@
 	spin_lock_irq(&conf->device_lock);
 
 	do {
-		if (conf->buffer_size == 0 ||
-		    (size && size != conf->buffer_size)) {
-			/* either the size is being changed (buffer_size==0) or
-			 * we need to change it.
-			 * If size==0, we can proceed as soon as buffer_size gets set.
-			 * If size>0, we can proceed when active_stripes reaches 0, or
-			 * when someone else sets the buffer_size to size.
-			 * If someone sets the buffer size to something else, we will need to
-			 * assert that we want to change it again
-			 */
-			int oldsize = conf->buffer_size;
-			PRINTK("get_stripe %ld/%d buffer_size is %d, %d active\n", sector, size, conf->buffer_size, atomic_read(&conf->active_stripes));
-			if (size==0)
-				wait_event_lock_irq(conf->wait_for_stripe,
-						    conf->buffer_size,
-						    conf->device_lock);
-			else {
-				while (conf->buffer_size != size && atomic_read(&conf->active_stripes)) {
-					conf->buffer_size = 0;
-					wait_event_lock_irq(conf->wait_for_stripe,
-							    atomic_read(&conf->active_stripes)==0 || conf->buffer_size,
-							    conf->device_lock);
-					PRINTK("waited and now  %ld/%d buffer_size is %d - %d active\n", sector, size,
-					       conf->buffer_size, atomic_read(&conf->active_stripes));
-				}
-
-				if (conf->buffer_size != size) {
-					printk("raid5: switching cache buffer size, %d --> %d\n", oldsize, size);
-					shrink_stripe_cache(conf);
-					if (size==0) BUG();
-					conf->buffer_size = size;
-					PRINTK("size now %d\n", conf->buffer_size);
-				}
-			}
-		}
-		if (size == 0)
-			sector -= sector & ((conf->buffer_size>>9)-1);
-
 		sh = __find_stripe(conf, sector);
 		if (!sh) {
 			if (!conf->inactive_blocked)
@@ -307,7 +245,7 @@
 						    conf->device_lock);
 				conf->inactive_blocked = 0;
 			} else
-				init_stripe(sh, sector);
+				init_stripe(sh, sector, pd_idx);
 		} else {
 			if (atomic_read(&sh->count)) {
 				if (!list_empty(&sh->lru))
@@ -329,21 +267,31 @@
 	return sh;
 }
 
-static int grow_stripes(raid5_conf_t *conf, int num, int priority)
+static int grow_stripes(raid5_conf_t *conf, int num)
 {
 	struct stripe_head *sh;
+	kmem_cache_t *sc;
+	int devs = conf->raid_disks;
+
+	sprintf(conf->cache_name, "md/raid5-%d", conf->mddev->__minor);
 
+	sc = kmem_cache_create(conf->cache_name, 
+			       sizeof(struct stripe_head)+(devs-1)*sizeof(struct r5dev),
+			       0, 0, NULL, NULL);
+	if (!sc)
+		return 1;
+	conf->slab_cache = sc;
 	while (num--) {
-		sh = kmalloc(sizeof(struct stripe_head), priority);
+		sh = kmem_cache_alloc(sc, GFP_KERNEL);
 		if (!sh)
 			return 1;
-		memset(sh, 0, sizeof(*sh));
+		memset(sh, 0, sizeof(*sh) + (devs-1)*sizeof(struct r5dev));
 		sh->raid_conf = conf;
 		sh->lock = SPIN_LOCK_UNLOCKED;
 
-		if (grow_buffers(sh, conf->raid_disks, PAGE_SIZE, priority)) {
+		if (grow_buffers(sh, conf->raid_disks)) {
 			shrink_buffers(sh, conf->raid_disks);
-			kfree(sh);
+			kmem_cache_free(sc, sh);
 			return 1;
 		}
 		/* we just created an active stripe so... */
@@ -355,11 +303,11 @@
 	return 0;
 }
 
-static void shrink_stripes(raid5_conf_t *conf, int num)
+static void shrink_stripes(raid5_conf_t *conf)
 {
 	struct stripe_head *sh;
 
-	while (num--) {
+	while (1) {
 		spin_lock_irq(&conf->device_lock);
 		sh = get_free_stripe(conf);
 		spin_unlock_irq(&conf->device_lock);
@@ -368,21 +316,22 @@
 		if (atomic_read(&sh->count))
 			BUG();
 		shrink_buffers(sh, conf->raid_disks);
-		kfree(sh);
+		kmem_cache_free(conf->slab_cache, sh);
 		atomic_dec(&conf->active_stripes);
 	}
+	kmem_cache_destroy(conf->slab_cache);
+	conf->slab_cache = NULL;
 }
 
-
-static void raid5_end_read_request (struct buffer_head * bh, int uptodate)
+static void raid5_end_read_request (struct bio * bi)
 {
- 	struct stripe_head *sh = bh->b_private;
+ 	struct stripe_head *sh = bi->bi_private;
 	raid5_conf_t *conf = sh->raid_conf;
 	int disks = conf->raid_disks, i;
-	unsigned long flags;
+	int uptodate = test_bit(BIO_UPTODATE, &bi->bi_flags);
 
 	for (i=0 ; i<disks; i++)
-		if (bh == sh->bh_cache[i])
+		if (bi == &sh->dev[i].req)
 			break;
 
 	PRINTK("end_read_request %lu/%d, count: %d, uptodate %d.\n", sh->sector, i, atomic_read(&sh->count), uptodate);
@@ -392,7 +341,9 @@
 	}
 
 	if (uptodate) {
-		struct buffer_head *buffer;
+#if 0
+		struct bio *bio;
+		unsigned long flags;
 		spin_lock_irqsave(&conf->device_lock, flags);
 		/* we can return a buffer if we bypassed the cache or
 		 * if the top buffer is not in highmem.  If there are
@@ -409,38 +360,43 @@
 		} else
 			buffer = NULL;
 		spin_unlock_irqrestore(&conf->device_lock, flags);
-		if (sh->bh_page[i]==NULL)
+		if (sh->bh_page[i]==bh->b_page)
 			set_buffer_uptodate(bh);
 		if (buffer) {
 			if (buffer->b_page != bh->b_page)
 				memcpy(buffer->b_data, bh->b_data, bh->b_size);
 			buffer->b_end_io(buffer, 1);
 		}
+#else
+		set_bit(R5_UPTODATE, &sh->dev[i].flags);
+#endif		
 	} else {
-		md_error(conf->mddev, bh->b_bdev);
-		clear_buffer_uptodate(bh);
+		md_error(conf->mddev, bi->bi_bdev);
+		clear_bit(R5_UPTODATE, &sh->dev[i].flags);
 	}
+#if 0
 	/* must restore b_page before unlocking buffer... */
-	if (sh->bh_page[i]) {
+	if (sh->bh_page[i] != bh->b_page) {
 		bh->b_page = sh->bh_page[i];
 		bh->b_data = page_address(bh->b_page);
-		sh->bh_page[i] = NULL;
 		clear_buffer_uptodate(bh);
 	}
-	clear_buffer_locked(bh);
+#endif
+	clear_bit(R5_LOCKED, &sh->dev[i].flags);
 	set_bit(STRIPE_HANDLE, &sh->state);
 	release_stripe(sh);
 }
 
-static void raid5_end_write_request (struct buffer_head *bh, int uptodate)
+static void raid5_end_write_request (struct bio *bi)
 {
- 	struct stripe_head *sh = bh->b_private;
+ 	struct stripe_head *sh = bi->bi_private;
 	raid5_conf_t *conf = sh->raid_conf;
 	int disks = conf->raid_disks, i;
 	unsigned long flags;
+	int uptodate = test_bit(BIO_UPTODATE, &bi->bi_flags);
 
 	for (i=0 ; i<disks; i++)
-		if (bh == sh->bh_cache[i])
+		if (bi == &sh->dev[i].req)
 			break;
 
 	PRINTK("end_write_request %lu/%d, count %d, uptodate: %d.\n", sh->sector, i, atomic_read(&sh->count), uptodate);
@@ -451,29 +407,36 @@
 
 	spin_lock_irqsave(&conf->device_lock, flags);
 	if (!uptodate)
-		md_error(conf->mddev, bh->b_bdev);
-	clear_buffer_locked(bh);
+		md_error(conf->mddev, bi->bi_bdev);
+	
+	clear_bit(R5_LOCKED, &sh->dev[i].flags);
 	set_bit(STRIPE_HANDLE, &sh->state);
 	__release_stripe(conf, sh);
 	spin_unlock_irqrestore(&conf->device_lock, flags);
 }
-	
 
 
-static struct buffer_head *raid5_build_block (struct stripe_head *sh, int i)
+static unsigned long compute_blocknr(struct stripe_head *sh, int i);
+	
+static void raid5_build_block (struct stripe_head *sh, int i)
 {
 	raid5_conf_t *conf = sh->raid_conf;
-	struct buffer_head *bh = sh->bh_cache[i];
-	unsigned long block = sh->sector / (sh->size >> 9);
+	struct r5dev *dev = &sh->dev[i];
 
-	init_buffer(bh, raid5_end_read_request, sh);
-	bh->b_dev       = conf->disks[i].dev;
-	/* FIXME - later we will need bdev here */
-	bh->b_blocknr   = block;
-
-	bh->b_state	= (1 << BH_Req) | (1 << BH_Mapped);
-	bh->b_size	= sh->size;
-	return bh;
+	bio_init(&dev->req);
+	dev->req.bi_io_vec = &dev->vec;
+	dev->req.bi_vcnt++;
+	dev->vec.bv_page = dev->page;
+	dev->vec.bv_len = STRIPE_SIZE;
+	dev->vec.bv_offset = 0;
+
+	dev->req.bi_bdev = conf->disks[i].bdev;
+	dev->req.bi_sector = sh->sector;
+	dev->req.bi_private = sh;
+
+	dev->flags = 0;
+	if (i != sh->pd_idx)
+		dev->sector = compute_blocknr(sh, i);
 }
 
 static int error (mddev_t *mddev, kdev_t dev)
@@ -544,14 +507,14 @@
  * Input: a 'big' sector number,
  * Output: index of the data and parity disk, and the sector # in them.
  */
-static unsigned long raid5_compute_sector(unsigned long r_sector, unsigned int raid_disks,
+static unsigned long raid5_compute_sector(sector_t r_sector, unsigned int raid_disks,
 			unsigned int data_disks, unsigned int * dd_idx,
 			unsigned int * pd_idx, raid5_conf_t *conf)
 {
-	unsigned long stripe;
+	sector_t stripe;
 	unsigned long chunk_number;
 	unsigned int chunk_offset;
-	unsigned long new_sector;
+	sector_t new_sector;
 	int sectors_per_chunk = conf->chunk_size >> 9;
 
 	/* First compute the information on this sector */
@@ -607,17 +570,17 @@
 	return new_sector;
 }
 
-#if 0
-static unsigned long compute_blocknr(struct stripe_head *sh, int i)
+
+static sector_t compute_blocknr(struct stripe_head *sh, int i)
 {
 	raid5_conf_t *conf = sh->raid_conf;
 	int raid_disks = conf->raid_disks, data_disks = raid_disks - 1;
-	unsigned long new_sector = sh->sector, check;
+	sector_t new_sector = sh->sector, check;
 	int sectors_per_chunk = conf->chunk_size >> 9;
-	unsigned long stripe = new_sector / sectors_per_chunk;
+	sector_t stripe = new_sector / sectors_per_chunk;
 	int chunk_offset = new_sector % sectors_per_chunk;
 	int chunk_number, dummy1, dummy2, dd_idx = i;
-	unsigned long r_sector, blocknr;
+	sector_t r_sector;
 
 	switch (conf->algorithm) {
 		case ALGORITHM_LEFT_ASYMMETRIC:
@@ -637,22 +600,72 @@
 
 	chunk_number = stripe * data_disks + i;
 	r_sector = chunk_number * sectors_per_chunk + chunk_offset;
-	blocknr = r_sector / (sh->size >> 9);
 
 	check = raid5_compute_sector (r_sector, raid_disks, data_disks, &dummy1, &dummy2, conf);
 	if (check != sh->sector || dummy1 != dd_idx || dummy2 != sh->pd_idx) {
 		printk("compute_blocknr: map not correct\n");
 		return 0;
 	}
-	return blocknr;
+	return r_sector;
+}
+
+
+
+/*
+ * Copy data between a page in the stripe cache, and one or more bion
+ * The page could align with the middle of the bio, or there could be 
+ * several bion, each with several bio_vecs, which cover part of the page
+ * Multiple bion are linked together on bi_next.  There may be extras
+ * at the end of this list.  We ignore them.
+ */
+static void copy_data(int frombio, struct bio *bio,
+		     struct page *page,
+		     sector_t sector)
+{
+	char *pa = page_address(page);
+	struct bio_vec *bvl;
+	int i;
+
+	for (;bio && bio->bi_sector < sector+STRIPE_SECTORS;
+		bio = bio->bi_next) {
+		int page_offset;
+		if (bio->bi_sector >= sector)
+			page_offset = (signed)(bio->bi_sector - sector) * 512;
+		else 
+			page_offset = (signed)(sector - bio->bi_sector) * -512;
+		bio_for_each_segment(bvl, bio, i) {
+			char *ba = __bio_kmap(bio, i);
+			int len = bio_iovec_idx(bio,i)->bv_len;
+			int clen;
+			int b_offset = 0;			
+
+			if (page_offset < 0) {
+				b_offset = -page_offset;
+				page_offset += b_offset;
+				len -= b_offset;
+			}
+
+			if (len > 0 && page_offset + len > STRIPE_SIZE)
+				clen = STRIPE_SIZE - page_offset;	
+			else clen = len;
+			
+			if (len > 0) {
+				if (frombio)
+					memcpy(pa+page_offset, ba+b_offset, clen);
+				else
+					memcpy(ba+b_offset, pa+page_offset, clen);
+			}
+			__bio_kunmap(bio, i);
+			page_offset +=  len;
+		}
+	}
 }
-#endif
 
-#define check_xor() 	do { 					\
-			   if (count == MAX_XOR_BLOCKS) {	\
-				xor_block(count, bh_ptr);	\
-				count = 1;			\
-			   }					\
+#define check_xor() 	do { 						\
+			   if (count == MAX_XOR_BLOCKS) {		\
+				xor_block(count, STRIPE_SIZE, ptr);	\
+				count = 1;				\
+			   }						\
 			} while(0)
 
 
@@ -660,88 +673,84 @@
 {
 	raid5_conf_t *conf = sh->raid_conf;
 	int i, count, disks = conf->raid_disks;
-	struct buffer_head *bh_ptr[MAX_XOR_BLOCKS], *bh;
+	void *ptr[MAX_XOR_BLOCKS], *p;
 
 	PRINTK("compute_block, stripe %lu, idx %d\n", sh->sector, dd_idx);
 
-
-	memset(sh->bh_cache[dd_idx]->b_data, 0, sh->size);
-	bh_ptr[0] = sh->bh_cache[dd_idx];
+	ptr[0] = page_address(sh->dev[dd_idx].page);
+	memset(ptr[0], 0, STRIPE_SIZE);
 	count = 1;
 	for (i = disks ; i--; ) {
 		if (i == dd_idx)
 			continue;
-		bh = sh->bh_cache[i];
-		if (buffer_uptodate(bh))
-			bh_ptr[count++] = bh;
+		p = page_address(sh->dev[i].page);
+		if (test_bit(R5_UPTODATE, &sh->dev[i].flags))
+			ptr[count++] = p;
 		else
 			printk("compute_block() %d, stripe %lu, %d not present\n", dd_idx, sh->sector, i);
 
 		check_xor();
 	}
 	if (count != 1)
-		xor_block(count, bh_ptr);
-	set_buffer_uptodate(sh->bh_cache[dd_idx]);
+		xor_block(count, STRIPE_SIZE, ptr);
+	set_bit(R5_UPTODATE, &sh->dev[i].flags);
 }
 
 static void compute_parity(struct stripe_head *sh, int method)
 {
 	raid5_conf_t *conf = sh->raid_conf;
 	int i, pd_idx = sh->pd_idx, disks = conf->raid_disks, count;
-	struct buffer_head *bh_ptr[MAX_XOR_BLOCKS];
-	struct buffer_head *chosen[MD_SB_DISKS];
+	void *ptr[MAX_XOR_BLOCKS];
+	struct bio *chosen[MD_SB_DISKS];
 
 	PRINTK("compute_parity, stripe %lu, method %d\n", sh->sector, method);
 	memset(chosen, 0, sizeof(chosen));
 
 	count = 1;
-	bh_ptr[0] = sh->bh_cache[pd_idx];
+	ptr[0] = page_address(sh->dev[pd_idx].page);
 	switch(method) {
 	case READ_MODIFY_WRITE:
-		if (!buffer_uptodate(sh->bh_cache[pd_idx]))
+		if (!test_bit(R5_UPTODATE, &sh->dev[pd_idx].flags))
 			BUG();
 		for (i=disks ; i-- ;) {
 			if (i==pd_idx)
 				continue;
-			if (sh->bh_write[i] &&
-			    buffer_uptodate(sh->bh_cache[i])) {
-				bh_ptr[count++] = sh->bh_cache[i];
-				chosen[i] = sh->bh_write[i];
-				sh->bh_write[i] = sh->bh_write[i]->b_reqnext;
-				chosen[i]->b_reqnext = sh->bh_written[i];
-				sh->bh_written[i] = chosen[i];
+			if (sh->dev[i].towrite &&
+			    test_bit(R5_UPTODATE, &sh->dev[i].flags)) {
+				ptr[count++] = page_address(sh->dev[i].page);
+				chosen[i] = sh->dev[i].towrite;
+				sh->dev[i].towrite = NULL;
+				if (sh->dev[i].written) BUG();
+				sh->dev[i].written = chosen[i];
 				check_xor();
 			}
 		}
 		break;
 	case RECONSTRUCT_WRITE:
-		memset(sh->bh_cache[pd_idx]->b_data, 0, sh->size);
+		memset(ptr[0], 0, STRIPE_SIZE);
 		for (i= disks; i-- ;)
-			if (i!=pd_idx && sh->bh_write[i]) {
-				chosen[i] = sh->bh_write[i];
-				sh->bh_write[i] = sh->bh_write[i]->b_reqnext;
-				chosen[i]->b_reqnext = sh->bh_written[i];
-				sh->bh_written[i] = chosen[i];
+			if (i!=pd_idx && sh->dev[i].towrite) {
+				chosen[i] = sh->dev[i].towrite;
+				sh->dev[i].towrite = NULL;
+				if (sh->dev[i].written) BUG();
+				sh->dev[i].written = chosen[i];
 			}
 		break;
 	case CHECK_PARITY:
 		break;
 	}
 	if (count>1) {
-		xor_block(count, bh_ptr);
+		xor_block(count, STRIPE_SIZE, ptr);
 		count = 1;
 	}
 	
 	for (i = disks; i--;)
 		if (chosen[i]) {
-			struct buffer_head *bh = sh->bh_cache[i];
-			char *bdata;
-			bdata = bh_kmap(chosen[i]);
-			memcpy(bh->b_data,
-			       bdata,sh->size);
-			bh_kunmap(chosen[i]);
-			set_buffer_locked(bh);
-			set_buffer_uptodate(bh);
+			sector_t sector = sh->dev[i].sector;
+			copy_data(1, chosen[i], sh->dev[i].page, sector);
+
+			set_bit(R5_LOCKED, &sh->dev[i].flags);
+			set_bit(R5_UPTODATE, &sh->dev[i].flags);
 		}
 
 	switch(method) {
@@ -749,55 +758,74 @@
 	case CHECK_PARITY:
 		for (i=disks; i--;)
 			if (i != pd_idx) {
-				bh_ptr[count++] = sh->bh_cache[i];
+				ptr[count++] = page_address(sh->dev[i].page);
 				check_xor();
 			}
 		break;
 	case READ_MODIFY_WRITE:
 		for (i = disks; i--;)
 			if (chosen[i]) {
-				bh_ptr[count++] = sh->bh_cache[i];
+				ptr[count++] = page_address(sh->dev[i].page);
 				check_xor();
 			}
 	}
 	if (count != 1)
-		xor_block(count, bh_ptr);
+		xor_block(count, STRIPE_SIZE, ptr);
 	
 	if (method != CHECK_PARITY) {
-		set_buffer_uptodate(sh->bh_cache[pd_idx]);
-		set_buffer_locked(sh->bh_cache[pd_idx]);
+		set_bit(R5_UPTODATE, &sh->dev[pd_idx].flags);
+		set_bit(R5_LOCKED,   &sh->dev[pd_idx].flags);
 	} else
-		clear_buffer_uptodate(sh->bh_cache[pd_idx]);
+		clear_bit(R5_UPTODATE, &sh->dev[pd_idx].flags);
 }
 
-static void add_stripe_bh (struct stripe_head *sh, struct buffer_head *bh, int dd_idx, int rw)
+/*
+ * Each stripe/dev can have one or more bion attached.
+ * toread/towrite point to the first in a chain. 
+ * The bi_next chain must be in order.
+ */
+static void add_stripe_bio (struct stripe_head *sh, struct bio *bi, int dd_idx, int forwrite)
 {
-	struct buffer_head **bhp;
+	struct bio **bip;
 	raid5_conf_t *conf = sh->raid_conf;
 
-	PRINTK("adding bh b#%lu to stripe s#%lu\n", bh->b_blocknr, sh->sector);
+	PRINTK("adding bh b#%lu to stripe s#%lu\n", bi->bi_sector, sh->sector);
 
 
 	spin_lock(&sh->lock);
 	spin_lock_irq(&conf->device_lock);
-	bh->b_reqnext = NULL;
-	if (rw == READ)
-		bhp = &sh->bh_read[dd_idx];
+	if (forwrite)
+		bip = &sh->dev[dd_idx].towrite;
 	else
-		bhp = &sh->bh_write[dd_idx];
-	while (*bhp) {
-		printk(KERN_NOTICE "raid5: multiple %d requests for sector %ld\n", rw, sh->sector);
-		bhp = & (*bhp)->b_reqnext;
-	}
-	*bhp = bh;
+		bip = &sh->dev[dd_idx].toread;
+	while (*bip && (*bip)->bi_sector < bi->bi_sector)
+		bip = & (*bip)->bi_next;
+/* FIXME do I need to worry about overlapping bion */
+	if (*bip && bi->bi_next && (*bip) != bi->bi_next)
+		BUG();
+	if (*bip)
+		bi->bi_next = *bip;
+	*bip = bi;
+	bi->bi_phys_segments ++;
 	spin_unlock_irq(&conf->device_lock);
 	spin_unlock(&sh->lock);
 
-	PRINTK("added bh b#%lu to stripe s#%lu, disk %d.\n", bh->b_blocknr, sh->sector, dd_idx);
-}
-
-
+	if (forwrite) {
+		/* check if page is coverred */
+		sector_t sector = sh->dev[dd_idx].sector;
+		for (bi=sh->dev[dd_idx].towrite;
+		     sector < sh->dev[dd_idx].sector + STRIPE_SECTORS &&
+			     bi && bi->bi_sector <= sector;
+		     bi = bi->bi_next) {
+			if (bi->bi_sector + (bi->bi_size>>9) >= sector)
+				sector = bi->bi_sector + (bi->bi_size>>9);
+		}
+		if (sector >= sh->dev[dd_idx].sector + STRIPE_SECTORS)
+			set_bit(R5_OVERWRITE, &sh->dev[dd_idx].flags);
+	}
 
+	PRINTK("added bi b#%lu to stripe s#%lu, disk %d.\n", bi->bi_sector, sh->sector, dd_idx);
+}
 
 
 /*
@@ -822,13 +850,14 @@
 {
 	raid5_conf_t *conf = sh->raid_conf;
 	int disks = conf->raid_disks;
-	struct buffer_head *return_ok= NULL, *return_fail = NULL;
+	struct bio *return_bi= NULL;
+	struct bio *bi;
 	int action[MD_SB_DISKS];
 	int i;
 	int syncing;
 	int locked=0, uptodate=0, to_read=0, to_write=0, failed=0, written=0;
 	int failed_num=0;
-	struct buffer_head *bh;
+	struct r5dev *dev;
 
 	PRINTK("handling stripe %ld, cnt=%d, pd_idx=%d\n", sh->sector, atomic_read(&sh->count), sh->pd_idx);
 	memset(action, 0, sizeof(action));
@@ -841,36 +870,38 @@
 	/* Now to look around and see what can be done */
 
 	for (i=disks; i--; ) {
-		bh = sh->bh_cache[i];
-		PRINTK("check %d: state 0x%lx read %p write %p written %p\n", i, bh->b_state, sh->bh_read[i], sh->bh_write[i], sh->bh_written[i]);
+		dev = &sh->dev[i];
+		PRINTK("check %d: state 0x%lx read %p write %p written %p\n", i, 
+		       dev->flags, dev->toread, dev->towrite, dev->written);
 		/* maybe we can reply to a read */
-		if (buffer_uptodate(bh) && sh->bh_read[i]) {
-			struct buffer_head *rbh, *rbh2;
+		if (test_bit(R5_UPTODATE, &dev->flags) && dev->toread) {
+			struct bio *rbi, *rbi2;
 			PRINTK("Return read for disc %d\n", i);
 			spin_lock_irq(&conf->device_lock);
-			rbh = sh->bh_read[i];
-			sh->bh_read[i] = NULL;
+			rbi = dev->toread;
+			dev->toread = NULL;
 			spin_unlock_irq(&conf->device_lock);
-			while (rbh) {
-				char *bdata;
-				bdata = bh_kmap(rbh);
-				memcpy(bdata, bh->b_data, bh->b_size);
-				bh_kunmap(rbh);
-				rbh2 = rbh->b_reqnext;
-				rbh->b_reqnext = return_ok;
-				return_ok = rbh;
-				rbh = rbh2;
+			while (rbi && rbi->bi_sector < dev->sector + STRIPE_SECTORS) {
+				copy_data(0, rbi, dev->page, dev->sector);
+				rbi2 = rbi->bi_next;
+				spin_lock_irq(&conf->device_lock);
+				if (--rbi->bi_phys_segments == 0) {
+					rbi->bi_next = return_bi;
+					return_bi = rbi;
+				}
+				spin_unlock_irq(&conf->device_lock);
+				rbi = rbi2;
 			}
 		}
 
 		/* now count some things */
-		if (buffer_locked(bh)) locked++;
-		if (buffer_uptodate(bh)) uptodate++;
+		if (test_bit(R5_LOCKED, &dev->flags)) locked++;
+		if (test_bit(R5_UPTODATE, &dev->flags)) uptodate++;
 
 		
-		if (sh->bh_read[i]) to_read++;
-		if (sh->bh_write[i]) to_write++;
-		if (sh->bh_written[i]) written++;
+		if (dev->toread) to_read++;
+		if (dev->towrite) to_write++;
+		if (dev->written) written++;
 		if (!conf->disks[i].operational) {
 			failed++;
 			failed_num = i;
@@ -882,29 +913,42 @@
 	 * need to be failed
 	 */
 	if (failed > 1 && to_read+to_write) {
+		spin_lock_irq(&conf->device_lock);
 		for (i=disks; i--; ) {
 			/* fail all writes first */
-			if (sh->bh_write[i]) to_write--;
-			while ((bh = sh->bh_write[i])) {
-				sh->bh_write[i] = bh->b_reqnext;
-				bh->b_reqnext = return_fail;
-				return_fail = bh;
+			bi = sh->dev[i].towrite;
+			sh->dev[i].towrite = NULL;
+			if (bi) to_write--;
+
+			while (bi && bi->bi_sector < sh->dev[i].sector + STRIPE_SECTORS){
+				struct bio *nextbi = bi->bi_next;
+				clear_bit(BIO_UPTODATE, &bi->bi_flags);
+				if (--bi->bi_phys_segments == 0) {
+					bi->bi_next = return_bi;
+					return_bi = bi;
+				}
+				bi = nextbi;
 			}
 			/* fail any reads if this device is non-operational */
 			if (!conf->disks[i].operational) {
-				spin_lock_irq(&conf->device_lock);
-				if (sh->bh_read[i]) to_read--;
-				while ((bh = sh->bh_read[i])) {
-					sh->bh_read[i] = bh->b_reqnext;
-					bh->b_reqnext = return_fail;
-					return_fail = bh;
+				bi = sh->dev[i].toread;
+				sh->dev[i].toread = NULL;
+				if (bi) to_read--;
+				while (bi && bi->bi_sector < sh->dev[i].sector + STRIPE_SECTORS){
+					struct bio *nextbi = bi->bi_next;
+					clear_bit(BIO_UPTODATE, &bi->bi_flags);
+					if (--bi->bi_phys_segments == 0) {
+						bi->bi_next = return_bi;
+						return_bi = bi;
+					}
+					bi = nextbi;
 				}
-				spin_unlock_irq(&conf->device_lock);
 			}
 		}
+		spin_unlock_irq(&conf->device_lock);
 	}
 	if (failed > 1 && syncing) {
-		md_done_sync(conf->mddev, (sh->size>>9) - sh->sync_redone,0);
+		md_done_sync(conf->mddev, STRIPE_SECTORS,0);
 		clear_bit(STRIPE_SYNCING, &sh->state);
 		syncing = 0;
 	}
@@ -912,40 +956,43 @@
 	/* might be able to return some write requests if the parity block
 	 * is safe, or on a failed drive
 	 */
-	bh = sh->bh_cache[sh->pd_idx];
+	dev = &sh->dev[sh->pd_idx];
 	if ( written &&
-	     ( (conf->disks[sh->pd_idx].operational && !buffer_locked(bh) && buffer_uptodate(bh))
+	     ( (conf->disks[sh->pd_idx].operational && !test_bit(R5_LOCKED, &dev->flags) &&
+		test_bit(R5_UPTODATE, &dev->flags))
 	       || (failed == 1 && failed_num == sh->pd_idx))
 	    ) {
-	    /* any written block on a uptodate or failed drive can be returned */
+	    /* any written block on an uptodate or failed drive can be returned */
 	    for (i=disks; i--; )
-		if (sh->bh_written[i]) {
-		    bh = sh->bh_cache[i];
+		if (sh->dev[i].written) {
+		    dev = &sh->dev[i];
 		    if (!conf->disks[sh->pd_idx].operational ||
-			(!buffer_locked(bh) && buffer_uptodate(bh)) ) {
+			(!test_bit(R5_LOCKED, &dev->flags) && test_bit(R5_UPTODATE, &dev->flags)) ) {
 			/* maybe we can return some write requests */
-			struct buffer_head *wbh, *wbh2;
-			PRINTK("Return write for disc %d\n", i);
-			wbh = sh->bh_written[i];
-			sh->bh_written[i] = NULL;
-			while (wbh) {
-			    wbh2 = wbh->b_reqnext;
-			    wbh->b_reqnext = return_ok;
-			    return_ok = wbh;
-			    wbh = wbh2;
-			}
+			    struct bio *wbi, *wbi2;
+			    PRINTK("Return write for disc %d\n", i);
+			    wbi = dev->written;
+			    dev->written = NULL;
+			    while (wbi && wbi->bi_sector < dev->sector + STRIPE_SECTORS) {
+				    wbi2 = wbi->bi_next;
+				    if (--wbi->bi_phys_segments == 0) {
+					    wbi->bi_next = return_bi;
+					    return_bi = wbi;
+				    }
+				    wbi = wbi2;
+			    }
 		    }
 		}
 	}
-		
+
 	/* Now we might consider reading some blocks, either to check/generate
 	 * parity, or to satisfy requests
 	 */
 	if (to_read || (syncing && (uptodate+failed < disks))) {
 		for (i=disks; i--;) {
-			bh = sh->bh_cache[i];
-			if (!buffer_locked(bh) && !buffer_uptodate(bh) &&
-			    (sh->bh_read[i] || syncing || (failed && sh->bh_read[failed_num]))) {
+			dev = &sh->dev[i];
+			if (!test_bit(R5_LOCKED, &dev->flags) && !test_bit(R5_UPTODATE, &dev->flags) &&
+			    (dev->toread || syncing || (failed && sh->dev[failed_num].toread))) {
 				/* we would like to get this block, possibly
 				 * by computing it, but we might not be able to
 				 */
@@ -954,21 +1001,21 @@
 					compute_block(sh, i);
 					uptodate++;
 				} else if (conf->disks[i].operational) {
-					set_buffer_locked(bh);
+					set_bit(R5_LOCKED, &dev->flags);
 					action[i] = READ+1;
+#if 0
 					/* if I am just reading this block and we don't have
 					   a failed drive, or any pending writes then sidestep the cache */
-					if (sh->bh_page[i]) BUG();
 					if (sh->bh_read[i] && !sh->bh_read[i]->b_reqnext &&
 					    ! syncing && !failed && !to_write) {
-						sh->bh_page[i] = sh->bh_cache[i]->b_page;
 						sh->bh_cache[i]->b_page =  sh->bh_read[i]->b_page;
 						sh->bh_cache[i]->b_data =  sh->bh_read[i]->b_data;
 					}
+#endif
 					locked++;
 					PRINTK("Reading block %d (sync=%d)\n", i, syncing);
 					if (syncing)
-						md_sync_acct(conf->disks[i].dev, bh->b_size>>9);
+						md_sync_acct(conf->disks[i].dev, STRIPE_SECTORS);
 				}
 			}
 		}
@@ -980,10 +1027,14 @@
 		int rmw=0, rcw=0;
 		for (i=disks ; i--;) {
 			/* would I have to read this buffer for read_modify_write */
-			bh = sh->bh_cache[i];
-			if ((sh->bh_write[i] || i == sh->pd_idx) &&
-			    (!buffer_locked(bh) || sh->bh_page[i]) &&
-			    !buffer_uptodate(bh)) {
+			dev = &sh->dev[i];
+			if ((dev->towrite || i == sh->pd_idx) &&
+			    (!test_bit(R5_LOCKED, &dev->flags) 
+#if 0
+|| sh->bh_page[i]!=bh->b_page
+#endif
+				    ) &&
+			    !test_bit(R5_UPTODATE, &dev->flags)) {
 				if (conf->disks[i].operational 
 /*				    && !(conf->resync_parity && i == sh->pd_idx) */
 					)
@@ -991,9 +1042,13 @@
 				else rmw += 2*disks;  /* cannot read it */
 			}
 			/* Would I have to read this buffer for reconstruct_write */
-			if (!sh->bh_write[i] && i != sh->pd_idx &&
-			    (!buffer_locked(bh) || sh->bh_page[i]) &&
-			    !buffer_uptodate(bh)) {
+			if (!test_bit(R5_OVERWRITE, &dev->flags) && i != sh->pd_idx &&
+			    (!test_bit(R5_LOCKED, &dev->flags) 
+#if 0
+|| sh->bh_page[i] != bh->b_page
+#endif
+				    ) &&
+			    !test_bit(R5_UPTODATE, &dev->flags)) {
 				if (conf->disks[i].operational) rcw++;
 				else rcw += 2*disks;
 			}
@@ -1003,14 +1058,14 @@
 		if (rmw < rcw && rmw > 0)
 			/* prefer read-modify-write, but need to get some data */
 			for (i=disks; i--;) {
-				bh = sh->bh_cache[i];
-				if ((sh->bh_write[i] || i == sh->pd_idx) &&
-				    !buffer_locked(bh) && !buffer_uptodate(bh) &&
+				dev = &sh->dev[i];
+				if ((dev->towrite || i == sh->pd_idx) &&
+				    !test_bit(R5_LOCKED, &dev->flags) && !test_bit(R5_UPTODATE, &dev->flags) &&
 				    conf->disks[i].operational) {
 					if (test_bit(STRIPE_PREREAD_ACTIVE, &sh->state))
 					{
 						PRINTK("Read_old block %d for r-m-w\n", i);
-						set_buffer_locked(bh);
+						set_bit(R5_LOCKED, &dev->flags);
 						action[i] = READ+1;
 						locked++;
 					} else {
@@ -1022,14 +1077,14 @@
 		if (rcw <= rmw && rcw > 0)
 			/* want reconstruct write, but need to get some data */
 			for (i=disks; i--;) {
-				bh = sh->bh_cache[i];
-				if (!sh->bh_write[i]  && i != sh->pd_idx &&
-				    !buffer_locked(bh) && !buffer_uptodate(bh) &&
+				dev = &sh->dev[i];
+				if (!test_bit(R5_OVERWRITE, &dev->flags) && i != sh->pd_idx &&
+				    !test_bit(R5_LOCKED, &dev->flags) && !test_bit(R5_UPTODATE, &dev->flags) &&
 				    conf->disks[i].operational) {
 					if (test_bit(STRIPE_PREREAD_ACTIVE, &sh->state))
 					{
 						PRINTK("Read_old block %d for Reconstruct\n", i);
-						set_buffer_locked(bh);
+						set_bit(R5_LOCKED, &dev->flags);
 						action[i] = READ+1;
 						locked++;
 					} else {
@@ -1044,7 +1099,7 @@
 			compute_parity(sh, rcw==0 ? RECONSTRUCT_WRITE : READ_MODIFY_WRITE);
 			/* now every locked buffer is ready to be written */
 			for (i=disks; i--;)
-				if (buffer_locked(sh->bh_cache[i])) {
+				if (test_bit(R5_LOCKED, &sh->dev[i].flags)) {
 					PRINTK("Writing block %d\n", i);
 					locked++;
 					action[i] = WRITE+1;
@@ -1068,13 +1123,14 @@
 	    !test_bit(STRIPE_INSYNC, &sh->state) && failed <= 1) {
 		set_bit(STRIPE_HANDLE, &sh->state);
 		if (failed == 0) {
+			char *pagea;
 			if (uptodate != disks)
 				BUG();
 			compute_parity(sh, CHECK_PARITY);
 			uptodate--;
-			bh = sh->bh_cache[sh->pd_idx];
-			if ((*(u32*)bh->b_data) == 0 &&
-			    !memcmp(bh->b_data, bh->b_data+4, bh->b_size-4)) {
+			pagea = page_address(sh->dev[sh->pd_idx].page);
+			if ((*(u32*)pagea) == 0 &&
+			    !memcmp(pagea, pagea+4, STRIPE_SIZE-4)) {
 				/* parity is correct (on disc, not in buffer any more) */
 				set_bit(STRIPE_INSYNC, &sh->state);
 			}
@@ -1084,7 +1140,7 @@
 			if (failed==0)
 				failed_num = sh->pd_idx;
 			/* should be able to compute the missing block and write it to spare */
-			if (!buffer_uptodate(sh->bh_cache[failed_num])) {
+			if (!test_bit(R5_UPTODATE, &sh->dev[failed_num].flags)) {
 				if (uptodate+1 != disks)
 					BUG();
 				compute_block(sh, failed_num);
@@ -1092,60 +1148,62 @@
 			}
 			if (uptodate != disks)
 				BUG();
-			bh = sh->bh_cache[failed_num];
-			set_buffer_locked(bh);
+			dev = &sh->dev[failed_num];
+			set_bit(R5_LOCKED, &dev->flags);
 			action[failed_num] = WRITE+1;
 			locked++;
 			set_bit(STRIPE_INSYNC, &sh->state);
 			if (conf->disks[failed_num].operational)
-				md_sync_acct(conf->disks[failed_num].dev, bh->b_size>>9);
+				md_sync_acct(conf->disks[failed_num].dev, STRIPE_SECTORS);
 			else if ((spare=conf->spare))
-				md_sync_acct(spare->dev, bh->b_size>>9);
+				md_sync_acct(spare->dev, STRIPE_SECTORS);
 
 		}
 	}
 	if (syncing && locked == 0 && test_bit(STRIPE_INSYNC, &sh->state)) {
-		md_done_sync(conf->mddev, (sh->size>>9) - sh->sync_redone,1);
+		md_done_sync(conf->mddev, STRIPE_SECTORS,1);
 		clear_bit(STRIPE_SYNCING, &sh->state);
 	}
 	
-	
 	spin_unlock(&sh->lock);
 
-	while ((bh=return_ok)) {
-		return_ok = bh->b_reqnext;
-		bh->b_reqnext = NULL;
-		bh->b_end_io(bh, 1);
-	}
-	while ((bh=return_fail)) {
-		return_fail = bh->b_reqnext;
-		bh->b_reqnext = NULL;
-		bh->b_end_io(bh, 0);
+	while ((bi=return_bi)) {
+		return_bi = bi->bi_next;
+		bi->bi_next = NULL;
+		bi->bi_end_io(bi);
 	}
 	for (i=disks; i-- ;) 
 		if (action[i]) {
-			struct buffer_head *bh = sh->bh_cache[i];
+			struct bio *bi = &sh->dev[i].req;
 			struct disk_info *spare = conf->spare;
 			int skip = 0;
 			if (action[i] == READ+1)
-				bh->b_end_io = raid5_end_read_request;
+				bi->bi_end_io = raid5_end_read_request;
 			else
-				bh->b_end_io = raid5_end_write_request;
+				bi->bi_end_io = raid5_end_write_request;
 			if (conf->disks[i].operational)
-				bh->b_dev = conf->disks[i].dev;
+				bi->bi_bdev = conf->disks[i].bdev;
 			else if (spare && action[i] == WRITE+1)
-				bh->b_dev = spare->dev;
+				bi->bi_bdev = spare->bdev;
 			else skip=1;
-			/* FIXME - later we will need bdev here */
 			if (!skip) {
 				PRINTK("for %ld schedule op %d on disc %d\n", sh->sector, action[i]-1, i);
 				atomic_inc(&sh->count);
-				bh->b_rdev = bh->b_dev;
-				bh->b_rsector = bh->b_blocknr * (bh->b_size>>9);
-				generic_make_request(action[i]-1, bh);
+				bi->bi_sector = sh->sector;
+				if (action[i] == READ+1) 
+					bi->bi_rw = 0;
+				else
+					bi->bi_rw = 1;
+				bi->bi_flags = 0;
+				bi->bi_vcnt = 1;	
+				bi->bi_idx = 0;
+				bi->bi_io_vec = &sh->dev[i].vec;
+				bi->bi_size = STRIPE_SIZE;
+				bi->bi_next = NULL;
+				generic_make_request(bi);
 			} else {
 				PRINTK("skip op %d on disc %d for sector %ld\n", action[i]-1, i, sh->sector);
-				clear_buffer_locked(bh);
+				clear_bit(R5_LOCKED, &dev->flags);
 				set_bit(STRIPE_HANDLE, &sh->state);
 			}
 		}
@@ -1192,13 +1250,14 @@
 	spin_unlock_irq(&conf->device_lock);
 }
 
-static int make_request (mddev_t *mddev, int rw, struct buffer_head * bh)
+static int make_request (mddev_t *mddev, int rw, struct bio * bi)
 {
 	raid5_conf_t *conf = (raid5_conf_t *) mddev->private;
 	const unsigned int raid_disks = conf->raid_disks;
 	const unsigned int data_disks = raid_disks - 1;
 	unsigned int dd_idx, pd_idx;
-	unsigned long new_sector;
+	sector_t new_sector;
+	sector_t logical_sector, last_sector;
 	int read_ahead = 0;
 
 	struct stripe_head *sh;
@@ -1208,25 +1267,39 @@
 		read_ahead=1;
 	}
 
-	new_sector = raid5_compute_sector(bh->b_rsector,
-			raid_disks, data_disks, &dd_idx, &pd_idx, conf);
+	logical_sector = bi->bi_sector & ~(STRIPE_SECTORS-1);
+	last_sector = bi->bi_sector + (bi->bi_size>>9);
 
-	PRINTK("raid5: make_request, sector %lu\n", new_sector);
-	sh = get_active_stripe(conf, new_sector, bh->b_size, read_ahead);
-	if (sh) {
-		sh->pd_idx = pd_idx;
+	bi->bi_next = NULL;
+	set_bit(BIO_UPTODATE, &bi->bi_flags); /* will be cleared if error detected */
+	bi->bi_phys_segments = 1;	/* over-loaded to count active stripes */
+	for (;logical_sector < last_sector; logical_sector += STRIPE_SECTORS) {
+		
+		new_sector = raid5_compute_sector(logical_sector,
+						  raid_disks, data_disks, &dd_idx, &pd_idx, conf);
 
-		add_stripe_bh(sh, bh, dd_idx, rw);
+		PRINTK("raid5: make_request, sector %ul logical %ul\n", 
+		       new_sector, logical_sector);
 
-		raid5_plug_device(conf);
-		handle_stripe(sh);
-		release_stripe(sh);
-	} else
-		bh->b_end_io(bh, buffer_uptodate(bh));
+		sh = get_active_stripe(conf, new_sector, pd_idx, read_ahead);
+		if (sh) {
+
+			add_stripe_bio(sh, bi, dd_idx, rw);
+
+			raid5_plug_device(conf);
+			handle_stripe(sh);
+			release_stripe(sh);
+		}
+	}
+	spin_lock_irq(&conf->device_lock);
+	if (--bi->bi_phys_segments == 0) 
+		bi->bi_end_io(bi);
+	spin_unlock_irq(&conf->device_lock);
 	return 0;
 }
 
-static int sync_request (mddev_t *mddev, unsigned long sector_nr)
+/* FIXME go_faster isn't used */
+static int sync_request (mddev_t *mddev, sector_t sector_nr, int go_faster)
 {
 	raid5_conf_t *conf = (raid5_conf_t *) mddev->private;
 	struct stripe_head *sh;
@@ -1237,25 +1310,19 @@
 	unsigned long first_sector;
 	int raid_disks = conf->raid_disks;
 	int data_disks = raid_disks-1;
-	int redone = 0;
-	int bufsize;
 
-	sh = get_active_stripe(conf, sector_nr, 0, 0);
-	bufsize = sh->size;
-	redone = sector_nr - sh->sector;
 	first_sector = raid5_compute_sector(stripe*data_disks*sectors_per_chunk
 		+ chunk_offset, raid_disks, data_disks, &dd_idx, &pd_idx, conf);
-	sh->pd_idx = pd_idx;
+	sh = get_active_stripe(conf, sector_nr, pd_idx, 0);
 	spin_lock(&sh->lock);	
 	set_bit(STRIPE_SYNCING, &sh->state);
 	clear_bit(STRIPE_INSYNC, &sh->state);
-	sh->sync_redone = redone;
 	spin_unlock(&sh->lock);
 
 	handle_stripe(sh);
 	release_stripe(sh);
 
-	return (bufsize>>9)-redone;
+	return STRIPE_SECTORS;
 }
 
 /*
@@ -1376,7 +1443,6 @@
 	INIT_LIST_HEAD(&conf->inactive_list);
 	atomic_set(&conf->active_stripes, 0);
 	atomic_set(&conf->preread_active_stripes, 0);
-	conf->buffer_size = PAGE_SIZE; /* good default for rebuild */
 
 	conf->plugged = 0;
 	conf->plug_tq.sync = 0;
@@ -1404,6 +1470,7 @@
 			disk->number = desc->number;
 			disk->raid_disk = raid_disk;
 			disk->dev = rdev->dev;
+			disk->bdev = rdev->bdev;
 
 			disk->operational = 0;
 			disk->write_only = 0;
@@ -1430,6 +1497,7 @@
 			disk->number = desc->number;
 			disk->raid_disk = raid_disk;
 			disk->dev = rdev->dev;
+			disk->bdev = rdev->bdev;
 			disk->operational = 1;
 			disk->used_slot = 1;
 
@@ -1442,6 +1510,7 @@
 			disk->number = desc->number;
 			disk->raid_disk = raid_disk;
 			disk->dev = rdev->dev;
+			disk->bdev = rdev->bdev;
 
 			disk->operational = 0;
 			disk->write_only = 0;
@@ -1461,6 +1530,7 @@
 			disk->number = desc->number;
 			disk->raid_disk = raid_disk;
 			disk->dev = NODEV;
+			disk->bdev = NULL;
 
 			disk->operational = 0;
 			disk->write_only = 0;
@@ -1518,9 +1588,9 @@
 
 	memory = conf->max_nr_stripes * (sizeof(struct stripe_head) +
 		 conf->raid_disks * ((sizeof(struct buffer_head) + PAGE_SIZE))) / 1024;
-	if (grow_stripes(conf, conf->max_nr_stripes, GFP_KERNEL)) {
+	if (grow_stripes(conf, conf->max_nr_stripes)) {
 		printk(KERN_ERR "raid5: couldn't allocate %dkB for buffers\n", memory);
-		shrink_stripes(conf, conf->max_nr_stripes);
+		shrink_stripes(conf);
 		goto abort;
 	} else
 		printk(KERN_INFO "raid5: allocated %dkB for md%d\n", memory, mdidx(mddev));
@@ -1623,7 +1693,7 @@
 	if (conf->resync_thread)
 		md_unregister_thread(conf->resync_thread);
 	md_unregister_thread(conf->thread);
-	shrink_stripes(conf, conf->max_nr_stripes);
+	shrink_stripes(conf);
 	free_pages((unsigned long) conf->stripe_hashtbl, HASH_PAGES_ORDER);
 	kfree(conf);
 	mddev->private = NULL;
@@ -1636,12 +1706,11 @@
 {
 	int i;
 
-	printk("sh %lu, size %d, pd_idx %d, state %ld.\n", sh->sector, sh->size, sh->pd_idx, sh->state);
+	printk("sh %lu, pd_idx %d, state %ld.\n", sh->sector, sh->pd_idx, sh->state);
 	printk("sh %lu,  count %d.\n", sh->sector, atomic_read(&sh->count));
 	printk("sh %lu, ", sh->sector);
-	for (i = 0; i < MD_SB_DISKS; i++) {
-		if (sh->bh_cache[i])
-			printk("(cache%d: %p %ld) ", i, sh->bh_cache[i], sh->bh_cache[i]->b_state);
+	for (i = 0; i < sh->raid_conf->raid_disks; i++) {
+		printk("(cache%d: %p %ld) ", i, sh->dev[i].page, sh->dev[i].flags);
 	}
 	printk("\n");
 }
@@ -1948,6 +2017,7 @@
 			goto abort;
 		}
 		rdisk->dev = NODEV;
+		rdisk->bdev = NULL;
 		rdisk->used_slot = 0;
 
 		break;
@@ -1965,6 +2035,8 @@
 		adisk->number = added_desc->number;
 		adisk->raid_disk = added_desc->raid_disk;
 		adisk->dev = mk_kdev(added_desc->major,added_desc->minor);
+		/* it will be held open by rdev */
+		adisk->bdev = bdget(kdev_t_to_nr(adisk->dev));
 
 		adisk->operational = 0;
 		adisk->write_only = 0;
--- ./drivers/md/xor.c	2002/05/15 04:23:59	1.2
+++ ./drivers/md/xor.c	2002/05/15 05:00:01	1.3
@@ -26,31 +26,30 @@
 static struct xor_block_template *active_template;
 
 void
-xor_block(unsigned int count, struct buffer_head **bh_ptr)
+xor_block(unsigned int count, unsigned int bytes, void **ptr)
 {
 	unsigned long *p0, *p1, *p2, *p3, *p4;
-	unsigned long bytes = bh_ptr[0]->b_size;
 
-	p0 = (unsigned long *) bh_ptr[0]->b_data;
-	p1 = (unsigned long *) bh_ptr[1]->b_data;
+	p0 = (unsigned long *) ptr[0];
+	p1 = (unsigned long *) ptr[1];
 	if (count == 2) {
 		active_template->do_2(bytes, p0, p1);
 		return;
 	}
 
-	p2 = (unsigned long *) bh_ptr[2]->b_data;
+	p2 = (unsigned long *) ptr[2];
 	if (count == 3) {
 		active_template->do_3(bytes, p0, p1, p2);
 		return;
 	}
 
-	p3 = (unsigned long *) bh_ptr[3]->b_data;
+	p3 = (unsigned long *) ptr[3];
 	if (count == 4) {
 		active_template->do_4(bytes, p0, p1, p2, p3);
 		return;
 	}
 
-	p4 = (unsigned long *) bh_ptr[4]->b_data;
+	p4 = (unsigned long *) ptr[4];
 	active_template->do_5(bytes, p0, p1, p2, p3, p4);
 }
 
