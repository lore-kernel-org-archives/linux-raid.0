From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: PATCH - md 1 of 2 - get raid5 (and umem) to compile
Date: Fri, 14 Jun 2002 21:33:28 +1000 (EST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <15625.54408.207165.82773@notabene.cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: Linus Torvalds <torvalds@transmeta.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Fix plugging for md/raid5 and umem

With this patch raid5 and umem now compile.

Apart from a couple of tiny fixes (buffer_head -> bio
in size calculation, and uint64 cast before >>32) this
patch makes umem and raid5 work with thenew plugging
infrastructure.

In each case we embed a request_queue_t in the per-device structure
to get access to plugging.

This means that we now have a separate request_queue_t for each device,
rather than one for the whole major number, so the
make_request function doesn't have to fiddle with the
minor number but can just ge tthe per-device struture from
q->queuedata.

When we open an md device that hasn't been initialised yet, we
still get the default request_queue to which has a 
make_request function that always fails.

 ----------- Diffstat output ------------
 ./drivers/block/umem.c       |   44 +++++++++++++++++++++++++++----------------
 ./drivers/md/md.c            |   25 +++++++++++++++++++++---
 ./drivers/md/raid5.c         |   23 +++++++---------------
 ./include/linux/raid/md_k.h  |    2 +
 ./include/linux/raid/raid5.h |    5 ----
 5 files changed, 61 insertions(+), 38 deletions(-)

--- ./include/linux/raid/md_k.h	2002/06/14 10:53:30	1.1
+++ ./include/linux/raid/md_k.h	2002/06/14 11:25:27	1.2
@@ -214,6 +214,8 @@
 	atomic_t			recovery_active; /* blocks scheduled, but not written */
 	wait_queue_head_t		recovery_wait;
 
+	request_queue_t			queue;	/* for plugging ... */
+
 	struct list_head		all_mddevs;
 };
 
--- ./include/linux/raid/raid5.h	2002/06/14 10:53:30	1.1
+++ ./include/linux/raid/raid5.h	2002/06/14 11:25:27	1.2
@@ -176,7 +176,7 @@
  * is put on a "delayed" queue until there are no stripes currently
  * in a pre-read phase.  Further, if the "delayed" queue is empty when
  * a stripe is put on it then we "plug" the queue and do not process it
- * until an unplg call is made. (the tq_disk list is run).
+ * until an unplug call is made. (blk_run_queues is run).
  *
  * When preread is initiated on a stripe, we set PREREAD_ACTIVE and add
  * it to the count of prereading stripes.
@@ -228,9 +228,6 @@
 							 * waiting for 25% to be free
 							 */        
 	spinlock_t		device_lock;
-
-	int			plugged;
-	struct tq_struct	plug_tq;
 };
 
 typedef struct raid5_private_data raid5_conf_t;
--- ./drivers/block/umem.c	2002/06/14 10:53:30	1.1
+++ ./drivers/block/umem.c	2002/06/14 11:25:27	1.2
@@ -128,6 +128,8 @@
 				    */
 	struct bio	*bio, *currentbio, **biotail;
 
+	request_queue_t queue;
+
 	struct mm_page {
 		dma_addr_t		page_dma;
 		struct mm_dma_desc	*desc;
@@ -141,8 +143,6 @@
 	struct tasklet_struct	tasklet;
 	unsigned int dma_status;
 
-	struct tq_struct plug_tq;
-
 	struct {
 		int		good;
 		int		warned;
@@ -292,7 +292,7 @@
  * Whenever IO on the active page completes, the Ready page is activated
  * and the ex-Active page is clean out and made Ready.
  * Otherwise the Ready page is only activated when it becomes full, or
- * when mm_unplug_device is called via run_task_queue(&tq_disk).
+ * when mm_unplug_device is called via blk_run_queues().
  *
  * If a request arrives while both pages a full, it is queued, and b_rdev is
  * overloaded to record whether it was a read or a write.
@@ -340,8 +340,9 @@
 	offset = ((char*)desc) - ((char*)page->desc);
 	writel(cpu_to_le32((page->page_dma+offset)&0xffffffff),
 	       card->csr_remap + DMA_DESCRIPTOR_ADDR);
-	/* if sizeof(dma_addr_t) == 32, this will generate a warning, sorry */
-	writel(cpu_to_le32((page->page_dma)>>32),
+	/* Force the value to u64 before shifting otherwise >> 32 is undefined C
+	 * and on some ports will do nothing ! */
+	writel(cpu_to_le32(((u64)page->page_dma)>>32),
 	       card->csr_remap + DMA_DESCRIPTOR_ADDR + 4);
 
 	/* Go, go, go */
@@ -383,10 +384,12 @@
 
 static void mm_unplug_device(void *data)
 {
-	struct cardinfo *card = data;
+	request_queue_t *q = data;
+	struct cardinfo *card = q->queuedata;
 
 	spin_lock_bh(&card->lock);
-	activate(card);
+	if (blk_remove_plug(q))
+		activate(card);
 	spin_unlock_bh(&card->lock);
 }
 
@@ -564,8 +567,7 @@
 */
 static int mm_make_request(request_queue_t *q, struct bio *bio)
 {
-	struct cardinfo *card = &cards[DEVICE_NR(
-		bio->bi_bdev->bd_dev)];
+	struct cardinfo *card = q->queuedata;
 	PRINTK("mm_make_request %ld %d\n", bh->b_rsector, bh->b_size);
 
 	/* set uptodate now, and clear it if there are any errors */
@@ -575,9 +577,9 @@
 	*card->biotail = bio;
 	bio->bi_next = NULL;
 	card->biotail = &bio->bi_next;
+	blk_plug_device(q);
 	spin_unlock_bh(&card->lock);
 
-	queue_task(&card->plug_tq, &tq_disk);
 	return 0;
 }
 
@@ -1064,11 +1066,12 @@
 	card->bio = NULL;
 	card->biotail = &card->bio;
 
+	blk_queue_make_request(&card->queue, mm_make_request);
+	card->queue.queuedata = card;
+	card->queue.unplug_fn = mm_unplug_device;
+
 	tasklet_init(&card->tasklet, process_page, (unsigned long)card);
 
-	card->plug_tq.sync = 0;
-	card->plug_tq.routine = &mm_unplug_device;
-	card->plug_tq.data = card;
 	card->check_batteries = 0;
 	
 	mem_present = readb(card->csr_remap + MEMCTRLSTATUS_MEMORY);
@@ -1236,6 +1239,17 @@
 --                               mm_init
 -----------------------------------------------------------------------------------
 */
+
+static request_queue_t * mm_queue_proc(kdev_t dev)
+{
+	int c = DEVICE_NR(kdev_val(dev));
+
+	if (c < MM_MAXCARDS)
+		return &cards[c].queue;
+	else
+		return BLK_DEFAULT_QUEUE(MAJOR_NR);
+}
+	
 int __init mm_init(void)
 {
 	int retval, i;
@@ -1275,10 +1289,8 @@
 	mm_gendisk.part      = mm_partitions;
 	mm_gendisk.nr_real   = num_cards;
 
+	blk_dev[MAJOR_NR].queue = mm_queue_proc;
 	add_gendisk(&mm_gendisk);
-
-	blk_queue_make_request(BLK_DEFAULT_QUEUE(MAJOR_NR),
-			       mm_make_request);
 
         blk_size[MAJOR_NR]      = mm_gendisk.sizes;
         for (i = 0; i < num_cards; i++) {
--- ./drivers/md/raid5.c	2002/06/14 10:53:30	1.1
+++ ./drivers/md/raid5.c	2002/06/14 11:25:27	1.2
@@ -1225,14 +1225,14 @@
 }
 static void raid5_unplug_device(void *data)
 {
-	raid5_conf_t *conf = (raid5_conf_t *)data;
+	request_queue_t *q = data;
+	raid5_conf_t *conf = q->queuedata;
 	unsigned long flags;
 
 	spin_lock_irqsave(&conf->device_lock, flags);
 
-	raid5_activate_delayed(conf);
-	
-	conf->plugged = 0;
+	if (blk_remove_plug(q))
+		raid5_activate_delayed(conf);
 	md_wakeup_thread(conf->thread);
 
 	spin_unlock_irqrestore(&conf->device_lock, flags);
@@ -1241,11 +1241,7 @@
 static inline void raid5_plug_device(raid5_conf_t *conf)
 {
 	spin_lock_irq(&conf->device_lock);
-	if (list_empty(&conf->delayed_list))
-		if (!conf->plugged) {
-			conf->plugged = 1;
-			queue_task(&conf->plug_tq, &tq_disk);
-		}
+	blk_plug_device(&conf->mddev->queue);
 	spin_unlock_irq(&conf->device_lock);
 }
 
@@ -1352,7 +1348,7 @@
 
 		if (list_empty(&conf->handle_list) &&
 		    atomic_read(&conf->preread_active_stripes) < IO_THRESHOLD &&
-		    !conf->plugged &&
+		    !blk_queue_plugged(&mddev->queue) &&
 		    !list_empty(&conf->delayed_list))
 			raid5_activate_delayed(conf);
 
@@ -1443,10 +1439,7 @@
 	atomic_set(&conf->active_stripes, 0);
 	atomic_set(&conf->preread_active_stripes, 0);
 
-	conf->plugged = 0;
-	conf->plug_tq.sync = 0;
-	conf->plug_tq.routine = &raid5_unplug_device;
-	conf->plug_tq.data = conf;
+	mddev->queue.unplug_fn = raid5_unplug_device;
 
 	PRINTK("raid5: run(md%d) called.\n", mdidx(mddev));
 
@@ -1586,7 +1579,7 @@
 	}
 
 	memory = conf->max_nr_stripes * (sizeof(struct stripe_head) +
-		 conf->raid_disks * ((sizeof(struct buffer_head) + PAGE_SIZE))) / 1024;
+		 conf->raid_disks * ((sizeof(struct bio) + PAGE_SIZE))) / 1024;
 	if (grow_stripes(conf, conf->max_nr_stripes)) {
 		printk(KERN_ERR "raid5: couldn't allocate %dkB for buffers\n", memory);
 		shrink_stripes(conf);
--- ./drivers/md/md.c	2002/06/14 10:53:30	1.1
+++ ./drivers/md/md.c	2002/06/14 11:25:27	1.2
@@ -172,7 +172,7 @@
 
 static int md_make_request (request_queue_t *q, struct bio *bio)
 {
-	mddev_t *mddev = kdev_to_mddev(to_kdev_t(bio->bi_bdev->bd_dev));
+	mddev_t *mddev = q->queuedata;
 
 	if (mddev && mddev->pers)
 		return mddev->pers->make_request(mddev, bio_rw(bio), bio);
@@ -182,6 +182,12 @@
 	}
 }
 
+static int md_fail_request (request_queue_t *q, struct bio *bio)
+{
+	bio_io_error(bio);
+	return 0;
+}
+
 static mddev_t * alloc_mddev(kdev_t dev)
 {
 	mddev_t *mddev;
@@ -1711,6 +1717,9 @@
 	}
 	mddev->pers = pers[pnum];
 
+	blk_queue_make_request(&mddev->queue, md_make_request);
+	mddev->queue.queuedata = mddev;
+
 	err = mddev->pers->run(mddev);
 	if (err) {
 		printk(KERN_ERR "md: pers->run() failed ...\n");
@@ -3616,6 +3625,15 @@
 #endif
 }
 
+request_queue_t * md_queue_proc(kdev_t dev)
+{
+	mddev_t *mddev = kdev_to_mddev(dev);
+	if (mddev == NULL)
+		return BLK_DEFAULT_QUEUE(MAJOR_NR);
+	else
+		return &mddev->queue;
+}
+
 int __init md_init(void)
 {
 	static char * name = "mdrecoveryd";
@@ -3640,8 +3658,9 @@
 			S_IFBLK | S_IRUSR | S_IWUSR, &md_fops, NULL);
 	}
 
-	/* forward all md request to md_make_request */
-	blk_queue_make_request(BLK_DEFAULT_QUEUE(MAJOR_NR), md_make_request);
+	/* all requests on an uninitialised device get failed... */
+	blk_queue_make_request(BLK_DEFAULT_QUEUE(MAJOR_NR), md_fail_request);
+	blk_dev[MAJOR_NR].queue = md_queue_proc;
 
 	add_gendisk(&md_gendisk);
 
