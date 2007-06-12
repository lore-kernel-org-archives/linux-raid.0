From: Dan Williams <dan.j.williams@intel.com>
Subject: raid5: coding style cleanup / refactor
Date: Tue, 12 Jun 2007 10:41:03 -0700
Message-ID: <1181670063.12913.5.camel@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1756814AbXFLRlZ@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, NeilBrown <neilb@suse.de>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


From: Dan Williams <dan.j.williams@intel.com>

Most of the raid5 code predates git so the coding style violations have
been present for a long time.  However, now that major new patches are
arriving, checkpatch.pl complains about these old violations.  Instead of
attempting to justify the warnings as "this is what raid5 used to do", this
patch brings the code in line with the current style.

Note that this is more than a simple reformatting.  The majority of the
80-column violations were in the handle_stripe5 and handle_stripe6
routines.  By introducing the 'stripe_head_state' and 'r6_state' objects
large portions of the logic could be moved to sub-routines, reclaiming a
column's worth of indentation.

'stripe_head_state' consumes all of the automatic variables that previously
stood alone in handle_stripe.  'r6_state' contains the handle_stripe6
specific variables like p_failed and q_failed.  

One of the nice side effects of the 'stripe_head_state' change is that it
allows for further reductions in code duplication between raid5 and raid6
(note: unfortunately the other 80-column violations hide the code
duplication-removal effect in the diffstat).  The following new routines
are shared between raid5 and raid6:

	handle_completed_write_requests
	handle_requests_to_failed_array
	handle_stripe_expansion

Trivia:
* PRINTK and RAID5_DEBUG is replaced with pr_debug
* struct field comments moved to the top (kernel-doc format)

Cc: NeilBrown <neilb@suse.de>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
Note, I have not rebased git-md-accel yet.  While that is happening I
wanted to have this patch out for review.

 drivers/md/raid5.c         | 1888 ++++++++++++++++++++++----------------------
 include/linux/raid/raid5.h |  174 +++-
 2 files changed, 1063 insertions(+), 999 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 061375e..3b09436 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -57,15 +57,16 @@
  * Stripe cache
  */
 
-#define NR_STRIPES		256
-#define STRIPE_SIZE		PAGE_SIZE
-#define STRIPE_SHIFT		(PAGE_SHIFT - 9)
-#define STRIPE_SECTORS		(STRIPE_SIZE>>9)
-#define	IO_THRESHOLD		1
-#define NR_HASH			(PAGE_SIZE / sizeof(struct hlist_head))
-#define HASH_MASK		(NR_HASH - 1)
+#define NR_STRIPES	 256
+#define STRIPE_SIZE	 PAGE_SIZE
+#define STRIPE_SHIFT	 (PAGE_SHIFT - 9)
+#define STRIPE_SECTORS	 (STRIPE_SIZE>>9)
+#define IO_THRESHOLD	 1
+#define NR_HASH	 (PAGE_SIZE / sizeof(struct hlist_head))
+#define HASH_MASK	 (NR_HASH - 1)
 
-#define stripe_hash(conf, sect)	(&((conf)->stripe_hashtbl[((sect) >> STRIPE_SHIFT) & HASH_MASK]))
+#define stripe_hash(conf, sect) \
+	(&((conf)->stripe_hashtbl[((sect) >> STRIPE_SHIFT) & HASH_MASK]))
 
 /* bio's attached to a stripe+device for I/O are linked together in bi_sector
  * order without overlap.  There may be several bio's per stripe+device, and
@@ -76,11 +77,12 @@
  * This macro is used to determine the 'next' bio in the list, given the sector
  * of the current stripe+device
  */
-#define r5_next_bio(bio, sect) ( ( (bio)->bi_sector + ((bio)->bi_size>>9) < sect + STRIPE_SECTORS) ? (bio)->bi_next : NULL)
+#define r5_next_bio(bio, sect) \
+	(((bio)->bi_sector + ((bio)->bi_size >> 9) < \
+		sect + STRIPE_SECTORS) ? (bio)->bi_next : NULL)
 /*
  * The following can be used to debug the driver
  */
-#define RAID5_DEBUG	0
 #define RAID5_PARANOIA	1
 #if RAID5_PARANOIA && defined(CONFIG_SMP)
 # define CHECK_DEVLOCK() assert_spin_locked(&conf->device_lock)
@@ -88,8 +90,7 @@
 # define CHECK_DEVLOCK()
 #endif
 
-#define PRINTK(x...) ((void)(RAID5_DEBUG && printk(x)))
-#if RAID5_DEBUG
+#ifdef DEBUG
 #define inline
 #define __inline__
 #endif
@@ -125,9 +126,11 @@ static void __release_stripe(raid5_conf_t *conf, struct stripe_head *sh)
 			}
 			md_wakeup_thread(conf->mddev->thread);
 		} else {
-			if (test_and_clear_bit(STRIPE_PREREAD_ACTIVE, &sh->state)) {
+			if (test_and_clear_bit(
+				STRIPE_PREREAD_ACTIVE, &sh->state)) {
 				atomic_dec(&conf->preread_active_stripes);
-				if (atomic_read(&conf->preread_active_stripes) < IO_THRESHOLD)
+				if (atomic_read(&conf->preread_active_stripes) <
+					IO_THRESHOLD)
 					md_wakeup_thread(conf->mddev->thread);
 			}
 			atomic_dec(&conf->active_stripes);
@@ -152,7 +155,8 @@ static void release_stripe(struct stripe_head *sh)
 
 static inline void remove_hash(struct stripe_head *sh)
 {
-	PRINTK("remove_hash(), stripe %llu\n", (unsigned long long)sh->sector);
+	pr_debug("remove_hash(), stripe %llu\n",
+		(unsigned long long)sh->sector);
 
 	hlist_del_init(&sh->hash);
 }
@@ -161,7 +165,8 @@ static inline void insert_hash(raid5_conf_t *conf, struct stripe_head *sh)
 {
 	struct hlist_head *hp = stripe_hash(conf, sh->sector);
 
-	PRINTK("insert_hash(), stripe %llu\n", (unsigned long long)sh->sector);
+	pr_debug("insert_hash(), stripe %llu\n",
+		(unsigned long long)sh->sector);
 
 	CHECK_DEVLOCK();
 	hlist_add_head(&sh->hash, hp);
@@ -204,7 +209,7 @@ static int grow_buffers(struct stripe_head *sh, int num)
 {
 	int i;
 
-	for (i=0; i<num; i++) {
+	for (i = 0; i < num; i++) {
 		struct page *page;
 
 		if (!(page = alloc_page(GFP_KERNEL))) {
@@ -217,7 +222,8 @@ static int grow_buffers(struct stripe_head *sh, int num)
 
 static void raid5_build_block (struct stripe_head *sh, int i);
 
-static void init_stripe(struct stripe_head *sh, sector_t sector, int pd_idx, int disks)
+static void
+init_stripe(struct stripe_head *sh, sector_t sector, int pd_idx, int disks)
 {
 	raid5_conf_t *conf = sh->raid_conf;
 	int i;
@@ -226,7 +232,7 @@ static void init_stripe(struct stripe_head *sh, sector_t sector, int pd_idx, int
 	BUG_ON(test_bit(STRIPE_HANDLE, &sh->state));
 	
 	CHECK_DEVLOCK();
-	PRINTK("init_stripe called, stripe %llu\n", 
+	pr_debug("init_stripe called, stripe %llu\n",
 		(unsigned long long)sh->sector);
 
 	remove_hash(sh);
@@ -254,29 +260,31 @@ static void init_stripe(struct stripe_head *sh, sector_t sector, int pd_idx, int
 	insert_hash(conf, sh);
 }
 
-static struct stripe_head *__find_stripe(raid5_conf_t *conf, sector_t sector, int disks)
+static struct stripe_head *
+__find_stripe(raid5_conf_t *conf, sector_t sector, int disks)
 {
 	struct stripe_head *sh;
 	struct hlist_node *hn;
 
 	CHECK_DEVLOCK();
-	PRINTK("__find_stripe, sector %llu\n", (unsigned long long)sector);
+	pr_debug("__find_stripe, sector %llu\n", (unsigned long long)sector);
 	hlist_for_each_entry(sh, hn, stripe_hash(conf, sector), hash)
 		if (sh->sector == sector && sh->disks == disks)
 			return sh;
-	PRINTK("__stripe %llu not in cache\n", (unsigned long long)sector);
+	pr_debug("__stripe %llu not in cache\n", (unsigned long long)sector);
 	return NULL;
 }
 
 static void unplug_slaves(mddev_t *mddev);
 static void raid5_unplug_device(request_queue_t *q);
 
-static struct stripe_head *get_active_stripe(raid5_conf_t *conf, sector_t sector, int disks,
-					     int pd_idx, int noblock)
+static struct stripe_head *
+get_active_stripe(raid5_conf_t *conf, sector_t sector, int disks,
+		     int pd_idx, int noblock)
 {
 	struct stripe_head *sh;
 
-	PRINTK("get_stripe, sector %llu\n", (unsigned long long)sector);
+	pr_debug("get_stripe, sector %llu\n", (unsigned long long)sector);
 
 	spin_lock_irq(&conf->device_lock);
 
@@ -293,12 +301,12 @@ static struct stripe_head *get_active_stripe(raid5_conf_t *conf, sector_t sector
 			if (!sh) {
 				conf->inactive_blocked = 1;
 				wait_event_lock_irq(conf->wait_for_stripe,
-						    !list_empty(&conf->inactive_list) &&
-						    (atomic_read(&conf->active_stripes)
-						     < (conf->max_nr_stripes *3/4)
-						     || !conf->inactive_blocked),
-						    conf->device_lock,
-						    raid5_unplug_device(conf->mddev->queue)
+					!list_empty(&conf->inactive_list) &&
+					(atomic_read(&conf->active_stripes) <
+					 (conf->max_nr_stripes *3/4) ||
+					  !conf->inactive_blocked),
+					  conf->device_lock,
+					 raid5_unplug_device(conf->mddev->queue)
 					);
 				conf->inactive_blocked = 0;
 			} else
@@ -357,8 +365,8 @@ static int grow_stripes(raid5_conf_t *conf, int num)
 	sprintf(conf->cache_name[1], "raid5-%s-alt", mdname(conf->mddev));
 	conf->active_name = 0;
 	sc = kmem_cache_create(conf->cache_name[conf->active_name],
-			       sizeof(struct stripe_head)+(devs-1)*sizeof(struct r5dev),
-			       0, 0, NULL, NULL);
+		       sizeof(struct stripe_head)+(devs-1)*sizeof(struct r5dev),
+		       0, 0, NULL, NULL);
 	if (!sc)
 		return 1;
 	conf->slab_cache = sc;
@@ -409,8 +417,8 @@ static int resize_stripes(raid5_conf_t *conf, int newsize)
 
 	/* Step 1 */
 	sc = kmem_cache_create(conf->cache_name[1-conf->active_name],
-			       sizeof(struct stripe_head)+(newsize-1)*sizeof(struct r5dev),
-			       0, 0, NULL, NULL);
+		    sizeof(struct stripe_head)+(newsize-1)*sizeof(struct r5dev),
+		    0, 0, NULL, NULL);
 	if (!sc)
 		return -ENOMEM;
 
@@ -429,7 +437,8 @@ static int resize_stripes(raid5_conf_t *conf, int newsize)
 	if (i) {
 		/* didn't get enough, give up */
 		while (!list_empty(&newstripes)) {
-			nsh = list_entry(newstripes.next, struct stripe_head, lru);
+			nsh =
+			   list_entry(newstripes.next, struct stripe_head, lru);
 			list_del(&nsh->lru);
 			kmem_cache_free(sc, nsh);
 		}
@@ -537,8 +546,8 @@ static int raid5_end_read_request(struct bio * bi, unsigned int bytes_done,
 		if (bi == &sh->dev[i].req)
 			break;
 
-	PRINTK("end_read_request %llu/%d, count: %d, uptodate %d.\n", 
-		(unsigned long long)sh->sector, i, atomic_read(&sh->count), 
+	pr_debug("end_read_request %llu/%d, count: %d, uptodate %d.\n",
+		(unsigned long long)sh->sector, i, atomic_read(&sh->count),
 		uptodate);
 	if (i == disks) {
 		BUG();
@@ -549,10 +558,12 @@ static int raid5_end_read_request(struct bio * bi, unsigned int bytes_done,
 		set_bit(R5_UPTODATE, &sh->dev[i].flags);
 		if (test_bit(R5_ReadError, &sh->dev[i].flags)) {
 			rdev = conf->disks[i].rdev;
-			printk(KERN_INFO "raid5:%s: read error corrected (%lu sectors at %llu on %s)\n",
+			printk(KERN_INFO
+				"raid5:%s: read error corrected "
+				"(%lu sectors at %llu on %s)\n",
 			       mdname(conf->mddev), STRIPE_SECTORS,
-			       (unsigned long long)sh->sector + rdev->data_offset,
-			       bdevname(rdev->bdev, b));
+			       (unsigned long long)sh->sector +
+			       rdev->data_offset, bdevname(rdev->bdev, b));
 			clear_bit(R5_ReadError, &sh->dev[i].flags);
 			clear_bit(R5_ReWrite, &sh->dev[i].flags);
 		}
@@ -566,21 +577,25 @@ static int raid5_end_read_request(struct bio * bi, unsigned int bytes_done,
 		clear_bit(R5_UPTODATE, &sh->dev[i].flags);
 		atomic_inc(&rdev->read_errors);
 		if (conf->mddev->degraded)
-			printk(KERN_WARNING "raid5:%s: read error not correctable (sector %llu on %s).\n",
+			printk(KERN_WARNING
+				"raid5:%s: read error not correctable "
+				"(sector %llu on %s).\n",
 			       mdname(conf->mddev),
-			       (unsigned long long)sh->sector + rdev->data_offset,
-			       bdn);
+			       (unsigned long long)sh->sector +
+				rdev->data_offset, bdn);
 		else if (test_bit(R5_ReWrite, &sh->dev[i].flags))
 			/* Oh, no!!! */
-			printk(KERN_WARNING "raid5:%s: read error NOT corrected!! (sector %llu on %s).\n",
+			printk(KERN_WARNING
+				"raid5:%s: read error NOT corrected!! "
+				"(sector %llu on %s).\n",
 			       mdname(conf->mddev),
-			       (unsigned long long)sh->sector + rdev->data_offset,
-			       bdn);
+			       (unsigned long long)sh->sector +
+				rdev->data_offset, bdn);
 		else if (atomic_read(&rdev->read_errors)
 			 > conf->max_nr_stripes)
 			printk(KERN_WARNING
-			       "raid5:%s: Too many read errors, failing device %s.\n",
-			       mdname(conf->mddev), bdn);
+			       "raid5:%s: Too many read errors, failing device "
+			       "%s.\n", mdname(conf->mddev), bdn);
 		else
 			retry = 1;
 		if (retry)
@@ -613,7 +628,7 @@ static int raid5_end_write_request (struct bio *bi, unsigned int bytes_done,
 		if (bi == &sh->dev[i].req)
 			break;
 
-	PRINTK("end_write_request %llu/%d, count %d, uptodate: %d.\n", 
+	pr_debug("end_write_request %llu/%d, count %d, uptodate: %d.\n",
 		(unsigned long long)sh->sector, i, atomic_read(&sh->count),
 		uptodate);
 	if (i == disks) {
@@ -658,7 +673,7 @@ static void error(mddev_t *mddev, mdk_rdev_t *rdev)
 {
 	char b[BDEVNAME_SIZE];
 	raid5_conf_t *conf = (raid5_conf_t *) mddev->private;
-	PRINTK("raid5: error called\n");
+	pr_debug("raid5: error called\n");
 
 	if (!test_bit(Faulty, &rdev->flags)) {
 		set_bit(MD_CHANGE_DEVS, &mddev->flags);
@@ -676,7 +691,8 @@ static void error(mddev_t *mddev, mdk_rdev_t *rdev)
 		printk (KERN_ALERT
 			"raid5: Disk failure on %s, disabling device."
 			" Operation continuing on %d devices\n",
-			bdevname(rdev->bdev,b), conf->raid_disks - mddev->degraded);
+			bdevname(rdev->bdev, b),
+				conf->raid_disks - mddev->degraded);
 	}
 }
 
@@ -684,7 +700,8 @@ static void error(mddev_t *mddev, mdk_rdev_t *rdev)
  * Input: a 'big' sector number,
  * Output: index of the data and parity disk, and the sector # in them.
  */
-static sector_t raid5_compute_sector(sector_t r_sector, unsigned int raid_disks,
+static sector_t
+raid5_compute_sector(sector_t r_sector, unsigned int raid_disks,
 			unsigned int data_disks, unsigned int * dd_idx,
 			unsigned int * pd_idx, raid5_conf_t *conf)
 {
@@ -929,7 +946,7 @@ static void compute_block(struct stripe_head *sh, int dd_idx)
 	int i, count, disks = sh->disks;
 	void *ptr[MAX_XOR_BLOCKS], *p;
 
-	PRINTK("compute_block, stripe %llu, idx %d\n", 
+	pr_debug("compute_block, stripe %llu, idx %d\n",
 		(unsigned long long)sh->sector, dd_idx);
 
 	ptr[0] = page_address(sh->dev[dd_idx].page);
@@ -960,7 +977,7 @@ static void compute_parity5(struct stripe_head *sh, int method)
 	void *ptr[MAX_XOR_BLOCKS];
 	struct bio *chosen;
 
-	PRINTK("compute_parity5, stripe %llu, method %d\n",
+	pr_debug("compute_parity5, stripe %llu, method %d\n",
 		(unsigned long long)sh->sector, method);
 
 	count = 1;
@@ -977,7 +994,8 @@ static void compute_parity5(struct stripe_head *sh, int method)
 				chosen = sh->dev[i].towrite;
 				sh->dev[i].towrite = NULL;
 
-				if (test_and_clear_bit(R5_Overlap, &sh->dev[i].flags))
+				if (test_and_clear_bit(
+					R5_Overlap, &sh->dev[i].flags))
 					wake_up(&conf->wait_for_overlap);
 
 				BUG_ON(sh->dev[i].written);
@@ -993,7 +1011,8 @@ static void compute_parity5(struct stripe_head *sh, int method)
 				chosen = sh->dev[i].towrite;
 				sh->dev[i].towrite = NULL;
 
-				if (test_and_clear_bit(R5_Overlap, &sh->dev[i].flags))
+				if (test_and_clear_bit(
+					R5_Overlap, &sh->dev[i].flags))
 					wake_up(&conf->wait_for_overlap);
 
 				BUG_ON(sh->dev[i].written);
@@ -1012,7 +1031,8 @@ static void compute_parity5(struct stripe_head *sh, int method)
 		if (sh->dev[i].written) {
 			sector_t sector = sh->dev[i].sector;
 			struct bio *wbi = sh->dev[i].written;
-			while (wbi && wbi->bi_sector < sector + STRIPE_SECTORS) {
+			while (wbi &&
+				wbi->bi_sector < sector + STRIPE_SECTORS) {
 				copy_data(1, wbi, sh->dev[i].page, sector);
 				wbi = r5_next_bio(wbi, sector);
 			}
@@ -1058,7 +1078,7 @@ static void compute_parity6(struct stripe_head *sh, int method)
 	qd_idx = raid6_next_disk(pd_idx, disks);
 	d0_idx = raid6_next_disk(qd_idx, disks);
 
-	PRINTK("compute_parity, stripe %llu, method %d\n",
+	pr_debug("compute_parity, stripe %llu, method %d\n",
 		(unsigned long long)sh->sector, method);
 
 	switch(method) {
@@ -1066,11 +1086,12 @@ static void compute_parity6(struct stripe_head *sh, int method)
 		BUG();		/* READ_MODIFY_WRITE N/A for RAID-6 */
 	case RECONSTRUCT_WRITE:
 		for (i= disks; i-- ;)
-			if ( i != pd_idx && i != qd_idx && sh->dev[i].towrite ) {
+			if (i != pd_idx && i != qd_idx && sh->dev[i].towrite) {
 				chosen = sh->dev[i].towrite;
 				sh->dev[i].towrite = NULL;
 
-				if (test_and_clear_bit(R5_Overlap, &sh->dev[i].flags))
+				if (test_and_clear_bit(
+					R5_Overlap, &sh->dev[i].flags))
 					wake_up(&conf->wait_for_overlap);
 
 				BUG_ON(sh->dev[i].written);
@@ -1085,7 +1106,8 @@ static void compute_parity6(struct stripe_head *sh, int method)
 		if (sh->dev[i].written) {
 			sector_t sector = sh->dev[i].sector;
 			struct bio *wbi = sh->dev[i].written;
-			while (wbi && wbi->bi_sector < sector + STRIPE_SECTORS) {
+			while (wbi &&
+				wbi->bi_sector < sector + STRIPE_SECTORS) {
 				copy_data(1, wbi, sh->dev[i].page, sector);
 				wbi = r5_next_bio(wbi, sector);
 			}
@@ -1094,22 +1116,21 @@ static void compute_parity6(struct stripe_head *sh, int method)
 			set_bit(R5_UPTODATE, &sh->dev[i].flags);
 		}
 
-//	switch(method) {
-//	case RECONSTRUCT_WRITE:
-//	case CHECK_PARITY:
-//	case UPDATE_PARITY:
-		/* Note that unlike RAID-5, the ordering of the disks matters greatly. */
+		/* Note that unlike RAID-5, the ordering of the disks matters
+		 * greatly.
+		 */
 		/* FIX: Is this ordering of drives even remotely optimal? */
 		count = 0;
 		i = d0_idx;
 		do {
 			ptrs[count++] = page_address(sh->dev[i].page);
-			if (count <= disks-2 && !test_bit(R5_UPTODATE, &sh->dev[i].flags))
-				printk("block %d/%d not uptodate on parity calc\n", i,count);
+			if (count <= disks-2 &&
+			    !test_bit(R5_UPTODATE, &sh->dev[i].flags))
+				printk(KERN_WARNING
+				    "block %d/%d not uptodate on parity calc\n",
+				    i, count);
 			i = raid6_next_disk(i, disks);
-		} while ( i != d0_idx );
-//		break;
-//	}
+		} while (i != d0_idx);
 
 	raid6_call.gen_syndrome(disks, STRIPE_SIZE, ptrs);
 
@@ -1136,7 +1157,7 @@ static void compute_block_1(struct stripe_head *sh, int dd_idx, int nozero)
 	int pd_idx = sh->pd_idx;
 	int qd_idx = raid6_next_disk(pd_idx, disks);
 
-	PRINTK("compute_block_1, stripe %llu, idx %d\n",
+	pr_debug("compute_block_1, stripe %llu, idx %d\n",
 		(unsigned long long)sh->sector, dd_idx);
 
 	if ( dd_idx == qd_idx ) {
@@ -1183,7 +1204,7 @@ static void compute_block_2(struct stripe_head *sh, int dd_idx1, int dd_idx2)
 	BUG_ON(faila == failb);
 	if ( failb < faila ) { int tmp = faila; faila = failb; failb = tmp; }
 
-	PRINTK("compute_block_2, stripe %llu, idx %d,%d (%d,%d)\n",
+	pr_debug("compute_block_2, stripe %llu, idx %d,%d (%d,%d)\n",
 	       (unsigned long long)sh->sector, dd_idx1, dd_idx2, faila, failb);
 
 	if ( failb == disks-1 ) {
@@ -1194,15 +1215,19 @@ static void compute_block_2(struct stripe_head *sh, int dd_idx1, int dd_idx2)
 			return;
 		} else {
 			/* We're missing D+Q; recompute D from P */
-			compute_block_1(sh, (dd_idx1 == qd_idx) ? dd_idx2 : dd_idx1, 0);
-			compute_parity6(sh, UPDATE_PARITY); /* Is this necessary? */
+			compute_block_1(sh,
+				(dd_idx1 == qd_idx) ? dd_idx2 : dd_idx1, 0);
+			/* Is this necessary? */
+			compute_parity6(sh, UPDATE_PARITY);
 			return;
 		}
 	}
 
 	/* We're missing D+P or D+D; build pointer table */
 	{
-		/**** FIX THIS: This could be very bad if disks is close to 256 ****/
+		/****
+		 * FIX THIS: This could be very bad if disks is close to 256
+		 ****/
 		void *ptrs[disks];
 
 		count = 0;
@@ -1212,7 +1237,9 @@ static void compute_block_2(struct stripe_head *sh, int dd_idx1, int dd_idx2)
 			i = raid6_next_disk(i, disks);
 			if (i != dd_idx1 && i != dd_idx2 &&
 			    !test_bit(R5_UPTODATE, &sh->dev[i].flags))
-				printk("compute_2 with missing block %d/%d\n", count, i);
+				printk(KERN_WARNING
+					"compute_2 with missing block %d/%d\n",
+					count, i);
 		} while ( i != d0_idx );
 
 		if ( failb == disks-2 ) {
@@ -1220,7 +1247,8 @@ static void compute_block_2(struct stripe_head *sh, int dd_idx1, int dd_idx2)
 			raid6_datap_recov(disks, STRIPE_SIZE, faila, ptrs);
 		} else {
 			/* We're missing D+D. */
-			raid6_2data_recov(disks, STRIPE_SIZE, faila, failb, ptrs);
+			raid6_2data_recov(disks, STRIPE_SIZE, faila, failb,
+					ptrs);
 		}
 
 		/* Both the above update both missing blocks */
@@ -1236,13 +1264,14 @@ static void compute_block_2(struct stripe_head *sh, int dd_idx1, int dd_idx2)
  * toread/towrite point to the first in a chain.
  * The bi_next chain must be in order.
  */
-static int add_stripe_bio(struct stripe_head *sh, struct bio *bi, int dd_idx, int forwrite)
+static int add_stripe_bio(struct stripe_head *sh, struct bio *bi, int dd_idx,
+			int forwrite)
 {
 	struct bio **bip;
 	raid5_conf_t *conf = sh->raid_conf;
 	int firstwrite=0;
 
-	PRINTK("adding bh b#%llu to stripe s#%llu\n",
+	pr_debug("adding bh b#%llu to stripe s#%llu\n",
 		(unsigned long long)bi->bi_sector,
 		(unsigned long long)sh->sector);
 
@@ -1271,7 +1300,7 @@ static int add_stripe_bio(struct stripe_head *sh, struct bio *bi, int dd_idx, in
 	spin_unlock_irq(&conf->device_lock);
 	spin_unlock(&sh->lock);
 
-	PRINTK("added bi b#%llu to stripe s#%llu, disk %d.\n",
+	pr_debug("added bi b#%llu to stripe s#%llu, disk %d.\n",
 		(unsigned long long)bi->bi_sector,
 		(unsigned long long)sh->sector, dd_idx);
 
@@ -1326,6 +1355,605 @@ static int stripe_to_pdidx(sector_t stripe, raid5_conf_t *conf, int disks)
 	return pd_idx;
 }
 
+static void
+handle_requests_to_failed_array(raid5_conf_t *conf, struct stripe_head *sh,
+				struct stripe_head_state *s, int disks,
+				struct bio **return_bi)
+{
+	int i;
+	for (i = disks; i--; ) {
+		struct bio *bi;
+		int bitmap_end = 0;
+
+		if (test_bit(R5_ReadError, &sh->dev[i].flags)) {
+			mdk_rdev_t *rdev;
+			rcu_read_lock();
+			rdev = rcu_dereference(conf->disks[i].rdev);
+			if (rdev && test_bit(In_sync, &rdev->flags))
+				/* multiple read failures in one stripe */
+				md_error(conf->mddev, rdev);
+			rcu_read_unlock();
+		}
+		spin_lock_irq(&conf->device_lock);
+		/* fail all writes first */
+		bi = sh->dev[i].towrite;
+		sh->dev[i].towrite = NULL;
+		if (bi) {
+			s->to_write--;
+			bitmap_end = 1;
+		}
+
+		if (test_and_clear_bit(R5_Overlap, &sh->dev[i].flags))
+			wake_up(&conf->wait_for_overlap);
+
+		while (bi && bi->bi_sector <
+			sh->dev[i].sector + STRIPE_SECTORS) {
+			struct bio *nextbi = r5_next_bio(bi, sh->dev[i].sector);
+			clear_bit(BIO_UPTODATE, &bi->bi_flags);
+			if (--bi->bi_phys_segments == 0) {
+				md_write_end(conf->mddev);
+				bi->bi_next = *return_bi;
+				*return_bi = bi;
+			}
+			bi = nextbi;
+		}
+		/* and fail all 'written' */
+		bi = sh->dev[i].written;
+		sh->dev[i].written = NULL;
+		if (bi) bitmap_end = 1;
+		while (bi && bi->bi_sector <
+		       sh->dev[i].sector + STRIPE_SECTORS) {
+			struct bio *bi2 = r5_next_bio(bi, sh->dev[i].sector);
+			clear_bit(BIO_UPTODATE, &bi->bi_flags);
+			if (--bi->bi_phys_segments == 0) {
+				md_write_end(conf->mddev);
+				bi->bi_next = *return_bi;
+				*return_bi = bi;
+			}
+			bi = bi2;
+		}
+
+		/* fail any reads if this device is non-operational */
+		if (!test_bit(R5_Insync, &sh->dev[i].flags) ||
+		    test_bit(R5_ReadError, &sh->dev[i].flags)) {
+			bi = sh->dev[i].toread;
+			sh->dev[i].toread = NULL;
+			if (test_and_clear_bit(R5_Overlap, &sh->dev[i].flags))
+				wake_up(&conf->wait_for_overlap);
+			if (bi) s->to_read--;
+			while (bi && bi->bi_sector <
+			       sh->dev[i].sector + STRIPE_SECTORS) {
+				struct bio *nextbi =
+					r5_next_bio(bi, sh->dev[i].sector);
+				clear_bit(BIO_UPTODATE, &bi->bi_flags);
+				if (--bi->bi_phys_segments == 0) {
+					bi->bi_next = *return_bi;
+					*return_bi = bi;
+				}
+				bi = nextbi;
+			}
+		}
+		spin_unlock_irq(&conf->device_lock);
+		if (bitmap_end)
+			bitmap_endwrite(conf->mddev->bitmap, sh->sector,
+					STRIPE_SECTORS, 0, 0);
+	}
+
+}
+
+static void handle_issuing_new_read_requests5(struct stripe_head *sh,
+			struct stripe_head_state *s, int disks)
+{
+	int i;
+	for (i = disks; i--;) {
+		struct r5dev *dev = &sh->dev[i];
+		if (!test_bit(R5_LOCKED, &dev->flags) &&
+		    !test_bit(R5_UPTODATE, &dev->flags) &&
+		    (dev->toread ||
+		     (dev->towrite && !test_bit(R5_OVERWRITE, &dev->flags)) ||
+		     s->syncing || s->expanding ||
+		     (s->failed && (sh->dev[s->failed_num].toread ||
+			(sh->dev[s->failed_num].towrite &&
+			!test_bit(R5_OVERWRITE, &sh->dev[s->failed_num].flags))
+		      )))) {
+			/* we would like to get this block, possibly
+			 * by computing it, but we might not be able to
+			 */
+			if (s->uptodate == disks-1) {
+				pr_debug("Computing block %d\n", i);
+				compute_block(sh, i);
+				s->uptodate++;
+			} else if (test_bit(R5_Insync, &dev->flags)) {
+				set_bit(R5_LOCKED, &dev->flags);
+				set_bit(R5_Wantread, &dev->flags);
+				s->locked++;
+				pr_debug("Reading block %d (sync=%d)\n",
+					i, s->syncing);
+			}
+		}
+	}
+	set_bit(STRIPE_HANDLE, &sh->state);
+}
+
+static void handle_issuing_new_read_requests6(struct stripe_head *sh,
+			struct stripe_head_state *s, struct r6_state *r6s,
+			int disks)
+{
+	int i;
+	for (i = disks; i--;) {
+		struct r5dev *dev = &sh->dev[i];
+		if (!test_bit(R5_LOCKED, &dev->flags) &&
+		    !test_bit(R5_UPTODATE, &dev->flags) &&
+		    (dev->toread || (dev->towrite &&
+		     !test_bit(R5_OVERWRITE, &dev->flags)) ||
+		     s->syncing || s->expanding ||
+		     (s->failed >= 1 &&
+		      (sh->dev[r6s->failed_num[0]].toread ||
+		       s->to_write)) ||
+		     (s->failed >= 2 &&
+		      (sh->dev[r6s->failed_num[1]].toread ||
+		       s->to_write)))) {
+			/* we would like to get this block, possibly
+			 * by computing it, but we might not be able to
+			 */
+			if (s->uptodate == disks-1) {
+				pr_debug("Computing stripe %llu block %d\n",
+				       (unsigned long long)sh->sector, i);
+				compute_block_1(sh, i, 0);
+				s->uptodate++;
+			} else if ( s->uptodate == disks-2 && s->failed >= 2 ) {
+				/* Computing 2-failure is *very* expensive; only
+				 * do it if failed >= 2
+				 */
+				int other;
+				for (other = disks; other--;) {
+					if (other == i)
+						continue;
+					if (!test_bit(R5_UPTODATE,
+					      &sh->dev[other].flags))
+						break;
+				}
+				BUG_ON(other < 0);
+				pr_debug("Computing stripe %llu blocks %d,%d\n",
+				       (unsigned long long)sh->sector,
+				       i, other);
+				compute_block_2(sh, i, other);
+				s->uptodate += 2;
+			} else if (test_bit(R5_Insync, &dev->flags)) {
+				set_bit(R5_LOCKED, &dev->flags);
+				set_bit(R5_Wantread, &dev->flags);
+				s->locked++;
+				pr_debug("Reading block %d (sync=%d)\n",
+					i, s->syncing);
+			}
+		}
+	}
+	set_bit(STRIPE_HANDLE, &sh->state);
+}
+
+
+/* handle_completed_write_requests
+ * any written block on an uptodate or failed drive can be returned.
+ * Note that if we 'wrote' to a failed drive, it will be UPTODATE, but
+ * never LOCKED, so we don't need to test 'failed' directly.
+ */
+static void handle_completed_write_requests(raid5_conf_t *conf,
+	struct stripe_head *sh, int disks, struct bio **return_bi)
+{
+	int i;
+	struct r5dev *dev;
+
+	for (i = disks; i--;)
+		if (sh->dev[i].written) {
+			dev = &sh->dev[i];
+			if (!test_bit(R5_LOCKED, &dev->flags) &&
+				test_bit(R5_UPTODATE, &dev->flags)) {
+				/* We can return any write requests */
+				struct bio *wbi, *wbi2;
+				int bitmap_end = 0;
+				pr_debug("Return write for disc %d\n", i);
+				spin_lock_irq(&conf->device_lock);
+				wbi = dev->written;
+				dev->written = NULL;
+				while (wbi && wbi->bi_sector <
+					dev->sector + STRIPE_SECTORS) {
+					wbi2 = r5_next_bio(wbi, dev->sector);
+					if (--wbi->bi_phys_segments == 0) {
+						md_write_end(conf->mddev);
+						wbi->bi_next = *return_bi;
+						*return_bi = wbi;
+					}
+					wbi = wbi2;
+				}
+				if (dev->towrite == NULL)
+					bitmap_end = 1;
+				spin_unlock_irq(&conf->device_lock);
+				if (bitmap_end)
+					bitmap_endwrite(conf->mddev->bitmap,
+							sh->sector,
+							STRIPE_SECTORS,
+					 !test_bit(STRIPE_DEGRADED, &sh->state),
+							0);
+			}
+		}
+}
+
+static void handle_issuing_new_write_requests5(raid5_conf_t *conf,
+		struct stripe_head *sh,	struct stripe_head_state *s, int disks)
+{
+	int rmw = 0, rcw = 0, i;
+	for (i = disks ; i--;) {
+		/* would I have to read this buffer for read_modify_write */
+		struct r5dev *dev = &sh->dev[i];
+		if ((dev->towrite || i == sh->pd_idx) &&
+		    !test_bit(R5_LOCKED, &dev->flags) &&
+		    !test_bit(R5_UPTODATE, &dev->flags)) {
+			if (test_bit(R5_Insync, &dev->flags))
+				rmw++;
+			else rmw += 2*disks;  /* cannot read it */
+		}
+		/* Would I have to read this buffer for reconstruct_write */
+		if (!test_bit(R5_OVERWRITE, &dev->flags) && i != sh->pd_idx &&
+		    !test_bit(R5_LOCKED, &dev->flags) &&
+		    !test_bit(R5_UPTODATE, &dev->flags)) {
+			if (test_bit(R5_Insync, &dev->flags)) rcw++;
+			else rcw += 2*disks;
+		}
+	}
+	pr_debug("for sector %llu, rmw=%d rcw=%d\n",
+		(unsigned long long)sh->sector, rmw, rcw);
+	set_bit(STRIPE_HANDLE, &sh->state);
+	if (rmw < rcw && rmw > 0)
+		/* prefer read-modify-write, but need to get some data */
+		for (i = disks; i--;) {
+			struct r5dev *dev = &sh->dev[i];
+			if ((dev->towrite || i == sh->pd_idx) &&
+			    !test_bit(R5_LOCKED, &dev->flags) &&
+			    !test_bit(R5_UPTODATE, &dev->flags) &&
+			    test_bit(R5_Insync, &dev->flags)) {
+				if (
+				  test_bit(STRIPE_PREREAD_ACTIVE, &sh->state)) {
+					pr_debug("Read_old block "
+						"%d for r-m-w\n", i);
+					set_bit(R5_LOCKED, &dev->flags);
+					set_bit(R5_Wantread, &dev->flags);
+					s->locked++;
+				} else {
+					set_bit(STRIPE_DELAYED, &sh->state);
+					set_bit(STRIPE_HANDLE, &sh->state);
+				}
+			}
+		}
+	if (rcw <= rmw && rcw > 0)
+		/* want reconstruct write, but need to get some data */
+		for (i = disks; i--;) {
+			struct r5dev *dev = &sh->dev[i];
+			if (!test_bit(R5_OVERWRITE, &dev->flags) &&
+			    i != sh->pd_idx &&
+			    !test_bit(R5_LOCKED, &dev->flags) &&
+			    !test_bit(R5_UPTODATE, &dev->flags) &&
+			    test_bit(R5_Insync, &dev->flags)) {
+				if (
+				  test_bit(STRIPE_PREREAD_ACTIVE, &sh->state)) {
+					pr_debug("Read_old block "
+						"%d for Reconstruct\n", i);
+					set_bit(R5_LOCKED, &dev->flags);
+					set_bit(R5_Wantread, &dev->flags);
+					s->locked++;
+				} else {
+					set_bit(STRIPE_DELAYED, &sh->state);
+					set_bit(STRIPE_HANDLE, &sh->state);
+				}
+			}
+		}
+	/* now if nothing is locked, and if we have enough data,
+	 * we can start a write request
+	 */
+	if (s->locked == 0 && (rcw == 0 || rmw == 0) &&
+	    !test_bit(STRIPE_BIT_DELAY, &sh->state)) {
+		pr_debug("Computing parity...\n");
+		compute_parity5(sh, rcw == 0 ?
+			RECONSTRUCT_WRITE : READ_MODIFY_WRITE);
+		/* now every locked buffer is ready to be written */
+		for (i = disks; i--;)
+			if (test_bit(R5_LOCKED, &sh->dev[i].flags)) {
+				pr_debug("Writing block %d\n", i);
+				s->locked++;
+				set_bit(R5_Wantwrite, &sh->dev[i].flags);
+				if (!test_bit(R5_Insync, &sh->dev[i].flags)
+				    || (i == sh->pd_idx && s->failed == 0))
+					set_bit(STRIPE_INSYNC, &sh->state);
+			}
+		if (test_and_clear_bit(STRIPE_PREREAD_ACTIVE, &sh->state)) {
+			atomic_dec(&conf->preread_active_stripes);
+			if (atomic_read(&conf->preread_active_stripes) <
+			    IO_THRESHOLD)
+				md_wakeup_thread(conf->mddev->thread);
+		}
+	}
+}
+
+static void handle_issuing_new_write_requests6(raid5_conf_t *conf,
+		struct stripe_head *sh,	struct stripe_head_state *s,
+		struct r6_state *r6s, int disks)
+{
+	int rcw = 0, must_compute = 0, pd_idx = sh->pd_idx, i;
+	int qd_idx = r6s->qd_idx;
+	for (i = disks ; i--;) {
+		struct r5dev *dev = &sh->dev[i];
+		/* Would I have to read this buffer for reconstruct_write */
+		if (!test_bit(R5_OVERWRITE, &dev->flags)
+		    && i != pd_idx && i != qd_idx
+		    && (!test_bit(R5_LOCKED, &dev->flags)
+			    ) &&
+		    !test_bit(R5_UPTODATE, &dev->flags)) {
+			if (test_bit(R5_Insync, &dev->flags)) rcw++;
+			else {
+				pr_debug("raid6: must_compute: "
+					"disk %d flags=%#lx\n", i, dev->flags);
+				must_compute++;
+			}
+		}
+	}
+	pr_debug("for sector %llu, rcw=%d, must_compute=%d\n",
+	       (unsigned long long)sh->sector, rcw, must_compute);
+	set_bit(STRIPE_HANDLE, &sh->state);
+
+	if (rcw > 0)
+		/* want reconstruct write, but need to get some data */
+		for (i = disks; i--;) {
+			struct r5dev *dev = &sh->dev[i];
+			if (!test_bit(R5_OVERWRITE, &dev->flags)
+			    && !(s->failed == 0 && (i == pd_idx || i == qd_idx))
+			    && !test_bit(R5_LOCKED, &dev->flags) &&
+			    !test_bit(R5_UPTODATE, &dev->flags) &&
+			    test_bit(R5_Insync, &dev->flags)) {
+				if (
+				  test_bit(STRIPE_PREREAD_ACTIVE, &sh->state)) {
+					pr_debug("Read_old stripe %llu "
+						"block %d for Reconstruct\n",
+					     (unsigned long long)sh->sector, i);
+					set_bit(R5_LOCKED, &dev->flags);
+					set_bit(R5_Wantread, &dev->flags);
+					s->locked++;
+				} else {
+					pr_debug("Request delayed stripe %llu "
+						"block %d for Reconstruct\n",
+					     (unsigned long long)sh->sector, i);
+					set_bit(STRIPE_DELAYED, &sh->state);
+					set_bit(STRIPE_HANDLE, &sh->state);
+				}
+			}
+		}
+	/* now if nothing is locked, and if we have enough data, we can start a
+	 * write request
+	 */
+	if (s->locked == 0 && rcw == 0 &&
+	    !test_bit(STRIPE_BIT_DELAY, &sh->state)) {
+		if (must_compute > 0) {
+			/* We have failed blocks and need to compute them */
+			switch (s->failed) {
+			case 0:
+				BUG();
+			case 1:
+				compute_block_1(sh, r6s->failed_num[0], 0);
+				break;
+			case 2:
+				compute_block_2(sh, r6s->failed_num[0],
+						r6s->failed_num[1]);
+				break;
+			default: /* This request should have been failed? */
+				BUG();
+			}
+		}
+
+		pr_debug("Computing parity for stripe %llu\n",
+			(unsigned long long)sh->sector);
+		compute_parity6(sh, RECONSTRUCT_WRITE);
+		/* now every locked buffer is ready to be written */
+		for (i = disks; i--;)
+			if (test_bit(R5_LOCKED, &sh->dev[i].flags)) {
+				pr_debug("Writing stripe %llu block %d\n",
+				       (unsigned long long)sh->sector, i);
+				s->locked++;
+				set_bit(R5_Wantwrite, &sh->dev[i].flags);
+			}
+		/* after a RECONSTRUCT_WRITE, the stripe MUST be in-sync */
+		set_bit(STRIPE_INSYNC, &sh->state);
+
+		if (test_and_clear_bit(STRIPE_PREREAD_ACTIVE, &sh->state)) {
+			atomic_dec(&conf->preread_active_stripes);
+			if (atomic_read(&conf->preread_active_stripes) <
+			    IO_THRESHOLD)
+				md_wakeup_thread(conf->mddev->thread);
+		}
+	}
+}
+
+static void handle_parity_checks5(raid5_conf_t *conf, struct stripe_head *sh,
+				struct stripe_head_state *s, int disks)
+{
+	set_bit(STRIPE_HANDLE, &sh->state);
+	if (s->failed == 0) {
+		BUG_ON(s->uptodate != disks);
+		compute_parity5(sh, CHECK_PARITY);
+		s->uptodate--;
+		if (page_is_zero(sh->dev[sh->pd_idx].page)) {
+			/* parity is correct (on disc, not in buffer any more)
+			 */
+			set_bit(STRIPE_INSYNC, &sh->state);
+		} else {
+			conf->mddev->resync_mismatches += STRIPE_SECTORS;
+			if (test_bit(MD_RECOVERY_CHECK, &conf->mddev->recovery))
+				/* don't try to repair!! */
+				set_bit(STRIPE_INSYNC, &sh->state);
+			else {
+				compute_block(sh, sh->pd_idx);
+				s->uptodate++;
+			}
+		}
+	}
+	if (!test_bit(STRIPE_INSYNC, &sh->state)) {
+		struct r5dev *dev;
+		/* either failed parity check, or recovery is happening */
+		if (s->failed == 0)
+			s->failed_num = sh->pd_idx;
+		dev = &sh->dev[s->failed_num];
+		BUG_ON(!test_bit(R5_UPTODATE, &dev->flags));
+		BUG_ON(s->uptodate != disks);
+
+		set_bit(R5_LOCKED, &dev->flags);
+		set_bit(R5_Wantwrite, &dev->flags);
+		clear_bit(STRIPE_DEGRADED, &sh->state);
+		s->locked++;
+		set_bit(STRIPE_INSYNC, &sh->state);
+	}
+}
+
+
+static void handle_parity_checks6(raid5_conf_t *conf, struct stripe_head *sh,
+				struct stripe_head_state *s,
+				struct r6_state *r6s, struct page *tmp_page,
+				int disks)
+{
+	int update_p = 0, update_q = 0;
+	struct r5dev *dev;
+	int pd_idx = sh->pd_idx;
+	int qd_idx = r6s->qd_idx;
+
+	set_bit(STRIPE_HANDLE, &sh->state);
+
+	BUG_ON(s->failed > 2);
+	BUG_ON(s->uptodate < disks);
+	/* Want to check and possibly repair P and Q.
+	 * However there could be one 'failed' device, in which
+	 * case we can only check one of them, possibly using the
+	 * other to generate missing data
+	 */
+
+	/* If !tmp_page, we cannot do the calculations,
+	 * but as we have set STRIPE_HANDLE, we will soon be called
+	 * by stripe_handle with a tmp_page - just wait until then.
+	 */
+	if (tmp_page) {
+		if (s->failed == r6s->q_failed) {
+			/* The only possible failed device holds 'Q', so it
+			 * makes sense to check P (If anything else were failed,
+			 * we would have used P to recreate it).
+			 */
+			compute_block_1(sh, pd_idx, 1);
+			if (!page_is_zero(sh->dev[pd_idx].page)) {
+				compute_block_1(sh, pd_idx, 0);
+				update_p = 1;
+			}
+		}
+		if (!r6s->q_failed && s->failed < 2) {
+			/* q is not failed, and we didn't use it to generate
+			 * anything, so it makes sense to check it
+			 */
+			memcpy(page_address(tmp_page),
+			       page_address(sh->dev[qd_idx].page),
+			       STRIPE_SIZE);
+			compute_parity6(sh, UPDATE_PARITY);
+			if (memcmp(page_address(tmp_page),
+				   page_address(sh->dev[qd_idx].page),
+				   STRIPE_SIZE) != 0) {
+				clear_bit(STRIPE_INSYNC, &sh->state);
+				update_q = 1;
+			}
+		}
+		if (update_p || update_q) {
+			conf->mddev->resync_mismatches += STRIPE_SECTORS;
+			if (test_bit(MD_RECOVERY_CHECK, &conf->mddev->recovery))
+				/* don't try to repair!! */
+				update_p = update_q = 0;
+		}
+
+		/* now write out any block on a failed drive,
+		 * or P or Q if they need it
+		 */
+
+		if (s->failed == 2) {
+			dev = &sh->dev[r6s->failed_num[1]];
+			s->locked++;
+			set_bit(R5_LOCKED, &dev->flags);
+			set_bit(R5_Wantwrite, &dev->flags);
+		}
+		if (s->failed >= 1) {
+			dev = &sh->dev[r6s->failed_num[0]];
+			s->locked++;
+			set_bit(R5_LOCKED, &dev->flags);
+			set_bit(R5_Wantwrite, &dev->flags);
+		}
+
+		if (update_p) {
+			dev = &sh->dev[pd_idx];
+			s->locked ++;
+			set_bit(R5_LOCKED, &dev->flags);
+			set_bit(R5_Wantwrite, &dev->flags);
+		}
+		if (update_q) {
+			dev = &sh->dev[qd_idx];
+			s->locked++;
+			set_bit(R5_LOCKED, &dev->flags);
+			set_bit(R5_Wantwrite, &dev->flags);
+		}
+		clear_bit(STRIPE_DEGRADED, &sh->state);
+
+		set_bit(STRIPE_INSYNC, &sh->state);
+	}
+}
+
+static void handle_stripe_expansion(raid5_conf_t *conf, struct stripe_head *sh,
+				struct stripe_head_state *s,
+				struct r6_state *r6s)
+{
+	int i;
+
+	/* We have read all the blocks in this stripe and now we need to
+	 * copy some of them into a target stripe for expand.
+	 */
+	clear_bit(STRIPE_EXPAND_SOURCE, &sh->state);
+	for (i = 0; i < sh->disks; i++)
+		if (i != sh->pd_idx && (r6s && i != r6s->qd_idx)) {
+			int dd_idx, pd_idx, j;
+			struct stripe_head *sh2;
+
+			sector_t bn = compute_blocknr(sh, i);
+			sector_t s = raid5_compute_sector(bn, conf->raid_disks,
+						conf->raid_disks-1, &dd_idx,
+						&pd_idx, conf);
+			sh2 = get_active_stripe(conf, s, conf->raid_disks,
+						pd_idx, 1);
+			if (sh2 == NULL)
+				/* so far only the early blocks of this stripe
+				 * have been requested.  When later blocks
+				 * get requested, we will try again
+				 */
+				continue;
+			if (!test_bit(STRIPE_EXPANDING, &sh2->state) ||
+			   test_bit(R5_Expanded, &sh2->dev[dd_idx].flags)) {
+				/* must have already done this block */
+				release_stripe(sh2);
+				continue;
+			}
+			memcpy(page_address(sh2->dev[dd_idx].page),
+			       page_address(sh->dev[i].page),
+			       STRIPE_SIZE);
+			set_bit(R5_Expanded, &sh2->dev[dd_idx].flags);
+			set_bit(R5_UPTODATE, &sh2->dev[dd_idx].flags);
+			for (j = 0; j < conf->raid_disks; j++)
+				if (j != sh2->pd_idx &&
+				    (r6s && j != r6s->qd_idx) &&
+				    !test_bit(R5_Expanded, &sh2->dev[j].flags))
+					break;
+			if (j == conf->raid_disks) {
+				set_bit(STRIPE_EXPAND_READY, &sh2->state);
+				set_bit(STRIPE_HANDLE, &sh2->state);
+			}
+			release_stripe(sh2);
+		}
+}
 
 /*
  * handle_stripe - do things to a stripe.
@@ -1348,17 +1976,13 @@ static int stripe_to_pdidx(sector_t stripe, raid5_conf_t *conf, int disks)
 static void handle_stripe5(struct stripe_head *sh)
 {
 	raid5_conf_t *conf = sh->raid_conf;
-	int disks = sh->disks;
-	struct bio *return_bi= NULL;
-	struct bio *bi;
-	int i;
-	int syncing, expanding, expanded;
-	int locked=0, uptodate=0, to_read=0, to_write=0, failed=0, written=0;
-	int non_overwrite = 0;
-	int failed_num=0;
+	int disks = sh->disks, i;
+	struct bio *return_bi = NULL, *bi;
+	struct stripe_head_state s;
 	struct r5dev *dev;
 
-	PRINTK("handling stripe %llu, cnt=%d, pd_idx=%d\n",
+	memset(&s, 0, sizeof(s));
+	pr_debug("handling stripe %llu, cnt=%d, pd_idx=%d\n",
 		(unsigned long long)sh->sector, atomic_read(&sh->count),
 		sh->pd_idx);
 
@@ -1366,30 +1990,31 @@ static void handle_stripe5(struct stripe_head *sh)
 	clear_bit(STRIPE_HANDLE, &sh->state);
 	clear_bit(STRIPE_DELAYED, &sh->state);
 
-	syncing = test_bit(STRIPE_SYNCING, &sh->state);
-	expanding = test_bit(STRIPE_EXPAND_SOURCE, &sh->state);
-	expanded = test_bit(STRIPE_EXPAND_READY, &sh->state);
+	s.syncing = test_bit(STRIPE_SYNCING, &sh->state);
+	s.expanding = test_bit(STRIPE_EXPAND_SOURCE, &sh->state);
+	s.expanded = test_bit(STRIPE_EXPAND_READY, &sh->state);
 	/* Now to look around and see what can be done */
 
 	rcu_read_lock();
-	for (i=disks; i--; ) {
+	for (i = disks; i--;) {
 		mdk_rdev_t *rdev;
-		dev = &sh->dev[i];
+		struct r5dev *dev = &sh->dev[i];
 		clear_bit(R5_Insync, &dev->flags);
 
-		PRINTK("check %d: state 0x%lx read %p write %p written %p\n",
+		pr_debug("check %d: state 0x%lx read %p write %p written %p\n",
 			i, dev->flags, dev->toread, dev->towrite, dev->written);
 		/* maybe we can reply to a read */
 		if (test_bit(R5_UPTODATE, &dev->flags) && dev->toread) {
 			struct bio *rbi, *rbi2;
-			PRINTK("Return read for disc %d\n", i);
+			pr_debug("Return read for disc %d\n", i);
 			spin_lock_irq(&conf->device_lock);
 			rbi = dev->toread;
 			dev->toread = NULL;
 			if (test_and_clear_bit(R5_Overlap, &dev->flags))
 				wake_up(&conf->wait_for_overlap);
 			spin_unlock_irq(&conf->device_lock);
-			while (rbi && rbi->bi_sector < dev->sector + STRIPE_SECTORS) {
+			while (rbi && rbi->bi_sector <
+			       dev->sector + STRIPE_SECTORS) {
 				copy_data(0, rbi, dev->page, dev->sector);
 				rbi2 = r5_next_bio(rbi, dev->sector);
 				spin_lock_irq(&conf->device_lock);
@@ -1403,426 +2028,141 @@ static void handle_stripe5(struct stripe_head *sh)
 		}
 
 		/* now count some things */
-		if (test_bit(R5_LOCKED, &dev->flags)) locked++;
-		if (test_bit(R5_UPTODATE, &dev->flags)) uptodate++;
-
+		if (test_bit(R5_LOCKED, &dev->flags)) s.locked++;
+		if (test_bit(R5_UPTODATE, &dev->flags)) s.uptodate++;
 		
-		if (dev->toread) to_read++;
+		if (dev->toread)
+			s.to_read++;
 		if (dev->towrite) {
-			to_write++;
+			s.to_write++;
 			if (!test_bit(R5_OVERWRITE, &dev->flags))
-				non_overwrite++;
+				s.non_overwrite++;
 		}
-		if (dev->written) written++;
+		if (dev->written)
+			s.written++;
 		rdev = rcu_dereference(conf->disks[i].rdev);
 		if (!rdev || !test_bit(In_sync, &rdev->flags)) {
 			/* The ReadError flag will just be confusing now */
 			clear_bit(R5_ReadError, &dev->flags);
 			clear_bit(R5_ReWrite, &dev->flags);
 		}
-		if (!rdev || !test_bit(In_sync, &rdev->flags)
-		    || test_bit(R5_ReadError, &dev->flags)) {
-			failed++;
-			failed_num = i;
+		if (!rdev || !test_bit(In_sync, &rdev->flags) ||
+		    test_bit(R5_ReadError, &dev->flags)) {
+			s.failed++;
+			s.failed_num = i;
 		} else
 			set_bit(R5_Insync, &dev->flags);
 	}
 	rcu_read_unlock();
-	PRINTK("locked=%d uptodate=%d to_read=%d"
+	pr_debug("locked=%d uptodate=%d to_read=%d"
 		" to_write=%d failed=%d failed_num=%d\n",
-		locked, uptodate, to_read, to_write, failed, failed_num);
-	/* check if the array has lost two devices and, if so, some requests might
-	 * need to be failed
+		s.locked, s.uptodate, s.to_read, s.to_write,
+		s.failed, s.failed_num);
+	/* check if the array has lost two devices and, if so, some requests
+	 * might need to be failed
 	 */
-	if (failed > 1 && to_read+to_write+written) {
-		for (i=disks; i--; ) {
-			int bitmap_end = 0;
-
-			if (test_bit(R5_ReadError, &sh->dev[i].flags)) {
-				mdk_rdev_t *rdev;
-				rcu_read_lock();
-				rdev = rcu_dereference(conf->disks[i].rdev);
-				if (rdev && test_bit(In_sync, &rdev->flags))
-					/* multiple read failures in one stripe */
-					md_error(conf->mddev, rdev);
-				rcu_read_unlock();
-			}
-
-			spin_lock_irq(&conf->device_lock);
-			/* fail all writes first */
-			bi = sh->dev[i].towrite;
-			sh->dev[i].towrite = NULL;
-			if (bi) { to_write--; bitmap_end = 1; }
-
-			if (test_and_clear_bit(R5_Overlap, &sh->dev[i].flags))
-				wake_up(&conf->wait_for_overlap);
-
-			while (bi && bi->bi_sector < sh->dev[i].sector + STRIPE_SECTORS){
-				struct bio *nextbi = r5_next_bio(bi, sh->dev[i].sector);
-				clear_bit(BIO_UPTODATE, &bi->bi_flags);
-				if (--bi->bi_phys_segments == 0) {
-					md_write_end(conf->mddev);
-					bi->bi_next = return_bi;
-					return_bi = bi;
-				}
-				bi = nextbi;
-			}
-			/* and fail all 'written' */
-			bi = sh->dev[i].written;
-			sh->dev[i].written = NULL;
-			if (bi) bitmap_end = 1;
-			while (bi && bi->bi_sector < sh->dev[i].sector + STRIPE_SECTORS) {
-				struct bio *bi2 = r5_next_bio(bi, sh->dev[i].sector);
-				clear_bit(BIO_UPTODATE, &bi->bi_flags);
-				if (--bi->bi_phys_segments == 0) {
-					md_write_end(conf->mddev);
-					bi->bi_next = return_bi;
-					return_bi = bi;
-				}
-				bi = bi2;
-			}
-
-			/* fail any reads if this device is non-operational */
-			if (!test_bit(R5_Insync, &sh->dev[i].flags) ||
-			    test_bit(R5_ReadError, &sh->dev[i].flags)) {
-				bi = sh->dev[i].toread;
-				sh->dev[i].toread = NULL;
-				if (test_and_clear_bit(R5_Overlap, &sh->dev[i].flags))
-					wake_up(&conf->wait_for_overlap);
-				if (bi) to_read--;
-				while (bi && bi->bi_sector < sh->dev[i].sector + STRIPE_SECTORS){
-					struct bio *nextbi = r5_next_bio(bi, sh->dev[i].sector);
-					clear_bit(BIO_UPTODATE, &bi->bi_flags);
-					if (--bi->bi_phys_segments == 0) {
-						bi->bi_next = return_bi;
-						return_bi = bi;
-					}
-					bi = nextbi;
-				}
-			}
-			spin_unlock_irq(&conf->device_lock);
-			if (bitmap_end)
-				bitmap_endwrite(conf->mddev->bitmap, sh->sector,
-						STRIPE_SECTORS, 0, 0);
-		}
-	}
-	if (failed > 1 && syncing) {
+	if (s.failed > 1 && s.to_read+s.to_write+s.written)
+		handle_requests_to_failed_array(conf, sh, &s, disks,
+						&return_bi);
+	if (s.failed > 1 && s.syncing) {
 		md_done_sync(conf->mddev, STRIPE_SECTORS,0);
 		clear_bit(STRIPE_SYNCING, &sh->state);
-		syncing = 0;
+		s.syncing = 0;
 	}
 
 	/* might be able to return some write requests if the parity block
 	 * is safe, or on a failed drive
 	 */
 	dev = &sh->dev[sh->pd_idx];
-	if ( written &&
-	     ( (test_bit(R5_Insync, &dev->flags) && !test_bit(R5_LOCKED, &dev->flags) &&
-		test_bit(R5_UPTODATE, &dev->flags))
-	       || (failed == 1 && failed_num == sh->pd_idx))
-	    ) {
-	    /* any written block on an uptodate or failed drive can be returned.
-	     * Note that if we 'wrote' to a failed drive, it will be UPTODATE, but 
-	     * never LOCKED, so we don't need to test 'failed' directly.
-	     */
-	    for (i=disks; i--; )
-		if (sh->dev[i].written) {
-		    dev = &sh->dev[i];
-		    if (!test_bit(R5_LOCKED, &dev->flags) &&
-			 test_bit(R5_UPTODATE, &dev->flags) ) {
-			/* We can return any write requests */
-			    struct bio *wbi, *wbi2;
-			    int bitmap_end = 0;
-			    PRINTK("Return write for disc %d\n", i);
-			    spin_lock_irq(&conf->device_lock);
-			    wbi = dev->written;
-			    dev->written = NULL;
-			    while (wbi && wbi->bi_sector < dev->sector + STRIPE_SECTORS) {
-				    wbi2 = r5_next_bio(wbi, dev->sector);
-				    if (--wbi->bi_phys_segments == 0) {
-					    md_write_end(conf->mddev);
-					    wbi->bi_next = return_bi;
-					    return_bi = wbi;
-				    }
-				    wbi = wbi2;
-			    }
-			    if (dev->towrite == NULL)
-				    bitmap_end = 1;
-			    spin_unlock_irq(&conf->device_lock);
-			    if (bitmap_end)
-				    bitmap_endwrite(conf->mddev->bitmap, sh->sector,
-						    STRIPE_SECTORS,
-						    !test_bit(STRIPE_DEGRADED, &sh->state), 0);
-		    }
-		}
-	}
+	if ( s.written &&
+	     ((test_bit(R5_Insync, &dev->flags) &&
+	       !test_bit(R5_LOCKED, &dev->flags) &&
+	       test_bit(R5_UPTODATE, &dev->flags)) ||
+		(s.failed == 1 && s.failed_num == sh->pd_idx)))
+		handle_completed_write_requests(conf, sh, disks, &return_bi);
 
 	/* Now we might consider reading some blocks, either to check/generate
 	 * parity, or to satisfy requests
 	 * or to load a block that is being partially written.
 	 */
-	if (to_read || non_overwrite || (syncing && (uptodate < disks)) || expanding) {
-		for (i=disks; i--;) {
-			dev = &sh->dev[i];
-			if (!test_bit(R5_LOCKED, &dev->flags) && !test_bit(R5_UPTODATE, &dev->flags) &&
-			    (dev->toread ||
-			     (dev->towrite && !test_bit(R5_OVERWRITE, &dev->flags)) ||
-			     syncing ||
-			     expanding ||
-			     (failed && (sh->dev[failed_num].toread ||
-					 (sh->dev[failed_num].towrite && !test_bit(R5_OVERWRITE, &sh->dev[failed_num].flags))))
-				    )
-				) {
-				/* we would like to get this block, possibly
-				 * by computing it, but we might not be able to
-				 */
-				if (uptodate == disks-1) {
-					PRINTK("Computing block %d\n", i);
-					compute_block(sh, i);
-					uptodate++;
-				} else if (test_bit(R5_Insync, &dev->flags)) {
-					set_bit(R5_LOCKED, &dev->flags);
-					set_bit(R5_Wantread, &dev->flags);
-					locked++;
-					PRINTK("Reading block %d (sync=%d)\n", 
-						i, syncing);
-				}
-			}
-		}
-		set_bit(STRIPE_HANDLE, &sh->state);
-	}
+	if (s.to_read || s.non_overwrite ||
+		(s.syncing && (s.uptodate < disks)) || s.expanding)
+		handle_issuing_new_read_requests5(sh, &s, disks);
 
 	/* now to consider writing and what else, if anything should be read */
-	if (to_write) {
-		int rmw=0, rcw=0;
-		for (i=disks ; i--;) {
-			/* would I have to read this buffer for read_modify_write */
-			dev = &sh->dev[i];
-			if ((dev->towrite || i == sh->pd_idx) &&
-			    (!test_bit(R5_LOCKED, &dev->flags) 
-				    ) &&
-			    !test_bit(R5_UPTODATE, &dev->flags)) {
-				if (test_bit(R5_Insync, &dev->flags)
-/*				    && !(!mddev->insync && i == sh->pd_idx) */
-					)
-					rmw++;
-				else rmw += 2*disks;  /* cannot read it */
-			}
-			/* Would I have to read this buffer for reconstruct_write */
-			if (!test_bit(R5_OVERWRITE, &dev->flags) && i != sh->pd_idx &&
-			    (!test_bit(R5_LOCKED, &dev->flags) 
-				    ) &&
-			    !test_bit(R5_UPTODATE, &dev->flags)) {
-				if (test_bit(R5_Insync, &dev->flags)) rcw++;
-				else rcw += 2*disks;
-			}
-		}
-		PRINTK("for sector %llu, rmw=%d rcw=%d\n", 
-			(unsigned long long)sh->sector, rmw, rcw);
-		set_bit(STRIPE_HANDLE, &sh->state);
-		if (rmw < rcw && rmw > 0)
-			/* prefer read-modify-write, but need to get some data */
-			for (i=disks; i--;) {
-				dev = &sh->dev[i];
-				if ((dev->towrite || i == sh->pd_idx) &&
-				    !test_bit(R5_LOCKED, &dev->flags) && !test_bit(R5_UPTODATE, &dev->flags) &&
-				    test_bit(R5_Insync, &dev->flags)) {
-					if (test_bit(STRIPE_PREREAD_ACTIVE, &sh->state))
-					{
-						PRINTK("Read_old block %d for r-m-w\n", i);
-						set_bit(R5_LOCKED, &dev->flags);
-						set_bit(R5_Wantread, &dev->flags);
-						locked++;
-					} else {
-						set_bit(STRIPE_DELAYED, &sh->state);
-						set_bit(STRIPE_HANDLE, &sh->state);
-					}
-				}
-			}
-		if (rcw <= rmw && rcw > 0)
-			/* want reconstruct write, but need to get some data */
-			for (i=disks; i--;) {
-				dev = &sh->dev[i];
-				if (!test_bit(R5_OVERWRITE, &dev->flags) && i != sh->pd_idx &&
-				    !test_bit(R5_LOCKED, &dev->flags) && !test_bit(R5_UPTODATE, &dev->flags) &&
-				    test_bit(R5_Insync, &dev->flags)) {
-					if (test_bit(STRIPE_PREREAD_ACTIVE, &sh->state))
-					{
-						PRINTK("Read_old block %d for Reconstruct\n", i);
-						set_bit(R5_LOCKED, &dev->flags);
-						set_bit(R5_Wantread, &dev->flags);
-						locked++;
-					} else {
-						set_bit(STRIPE_DELAYED, &sh->state);
-						set_bit(STRIPE_HANDLE, &sh->state);
-					}
-				}
-			}
-		/* now if nothing is locked, and if we have enough data, we can start a write request */
-		if (locked == 0 && (rcw == 0 ||rmw == 0) &&
-		    !test_bit(STRIPE_BIT_DELAY, &sh->state)) {
-			PRINTK("Computing parity...\n");
-			compute_parity5(sh, rcw==0 ? RECONSTRUCT_WRITE : READ_MODIFY_WRITE);
-			/* now every locked buffer is ready to be written */
-			for (i=disks; i--;)
-				if (test_bit(R5_LOCKED, &sh->dev[i].flags)) {
-					PRINTK("Writing block %d\n", i);
-					locked++;
-					set_bit(R5_Wantwrite, &sh->dev[i].flags);
-					if (!test_bit(R5_Insync, &sh->dev[i].flags)
-					    || (i==sh->pd_idx && failed == 0))
-						set_bit(STRIPE_INSYNC, &sh->state);
-				}
-			if (test_and_clear_bit(STRIPE_PREREAD_ACTIVE, &sh->state)) {
-				atomic_dec(&conf->preread_active_stripes);
-				if (atomic_read(&conf->preread_active_stripes) < IO_THRESHOLD)
-					md_wakeup_thread(conf->mddev->thread);
-			}
-		}
-	}
+	if (s.to_write)
+		handle_issuing_new_write_requests5(conf, sh, &s, disks);
 
 	/* maybe we need to check and possibly fix the parity for this stripe
-	 * Any reads will already have been scheduled, so we just see if enough data
-	 * is available
+	 * Any reads will already have been scheduled, so we just see if enough
+	 * data is available
 	 */
-	if (syncing && locked == 0 &&
-	    !test_bit(STRIPE_INSYNC, &sh->state)) {
-		set_bit(STRIPE_HANDLE, &sh->state);
-		if (failed == 0) {
-			BUG_ON(uptodate != disks);
-			compute_parity5(sh, CHECK_PARITY);
-			uptodate--;
-			if (page_is_zero(sh->dev[sh->pd_idx].page)) {
-				/* parity is correct (on disc, not in buffer any more) */
-				set_bit(STRIPE_INSYNC, &sh->state);
-			} else {
-				conf->mddev->resync_mismatches += STRIPE_SECTORS;
-				if (test_bit(MD_RECOVERY_CHECK, &conf->mddev->recovery))
-					/* don't try to repair!! */
-					set_bit(STRIPE_INSYNC, &sh->state);
-				else {
-					compute_block(sh, sh->pd_idx);
-					uptodate++;
-				}
-			}
-		}
-		if (!test_bit(STRIPE_INSYNC, &sh->state)) {
-			/* either failed parity check, or recovery is happening */
-			if (failed==0)
-				failed_num = sh->pd_idx;
-			dev = &sh->dev[failed_num];
-			BUG_ON(!test_bit(R5_UPTODATE, &dev->flags));
-			BUG_ON(uptodate != disks);
-
-			set_bit(R5_LOCKED, &dev->flags);
-			set_bit(R5_Wantwrite, &dev->flags);
-			clear_bit(STRIPE_DEGRADED, &sh->state);
-			locked++;
-			set_bit(STRIPE_INSYNC, &sh->state);
-		}
-	}
-	if (syncing && locked == 0 && test_bit(STRIPE_INSYNC, &sh->state)) {
+	if (s.syncing && s.locked == 0 &&
+	    !test_bit(STRIPE_INSYNC, &sh->state))
+		handle_parity_checks5(conf, sh, &s, disks);
+	if (s.syncing && s.locked == 0 && test_bit(STRIPE_INSYNC, &sh->state)) {
 		md_done_sync(conf->mddev, STRIPE_SECTORS,1);
 		clear_bit(STRIPE_SYNCING, &sh->state);
 	}
 
-	/* If the failed drive is just a ReadError, then we might need to progress
-	 * the repair/check process
+	/* If the failed drive is just a ReadError, then we might need to
+	 * progress the repair/check process
 	 */
-	if (failed == 1 && ! conf->mddev->ro &&
-	    test_bit(R5_ReadError, &sh->dev[failed_num].flags)
-	    && !test_bit(R5_LOCKED, &sh->dev[failed_num].flags)
-	    && test_bit(R5_UPTODATE, &sh->dev[failed_num].flags)
+	if (s.failed == 1 && !conf->mddev->ro &&
+	    test_bit(R5_ReadError, &sh->dev[s.failed_num].flags)
+	    && !test_bit(R5_LOCKED, &sh->dev[s.failed_num].flags)
+	    && test_bit(R5_UPTODATE, &sh->dev[s.failed_num].flags)
 		) {
-		dev = &sh->dev[failed_num];
+		dev = &sh->dev[s.failed_num];
 		if (!test_bit(R5_ReWrite, &dev->flags)) {
 			set_bit(R5_Wantwrite, &dev->flags);
 			set_bit(R5_ReWrite, &dev->flags);
 			set_bit(R5_LOCKED, &dev->flags);
-			locked++;
+			s.locked++;
 		} else {
 			/* let's read it back */
 			set_bit(R5_Wantread, &dev->flags);
 			set_bit(R5_LOCKED, &dev->flags);
-			locked++;
+			s.locked++;
 		}
 	}
 
-	if (expanded && test_bit(STRIPE_EXPANDING, &sh->state)) {
+	if (s.expanded && test_bit(STRIPE_EXPANDING, &sh->state)) {
 		/* Need to write out all blocks after computing parity */
 		sh->disks = conf->raid_disks;
-		sh->pd_idx = stripe_to_pdidx(sh->sector, conf, conf->raid_disks);
+		sh->pd_idx =
+			stripe_to_pdidx(sh->sector, conf, conf->raid_disks);
 		compute_parity5(sh, RECONSTRUCT_WRITE);
 		for (i= conf->raid_disks; i--;) {
 			set_bit(R5_LOCKED, &sh->dev[i].flags);
-			locked++;
+			s.locked++;
 			set_bit(R5_Wantwrite, &sh->dev[i].flags);
 		}
 		clear_bit(STRIPE_EXPANDING, &sh->state);
-	} else if (expanded) {
+	} else if (s.expanded) {
 		clear_bit(STRIPE_EXPAND_READY, &sh->state);
 		atomic_dec(&conf->reshape_stripes);
 		wake_up(&conf->wait_for_overlap);
 		md_done_sync(conf->mddev, STRIPE_SECTORS, 1);
 	}
 
-	if (expanding && locked == 0) {
-		/* We have read all the blocks in this stripe and now we need to
-		 * copy some of them into a target stripe for expand.
-		 */
-		clear_bit(STRIPE_EXPAND_SOURCE, &sh->state);
-		for (i=0; i< sh->disks; i++)
-			if (i != sh->pd_idx) {
-				int dd_idx, pd_idx, j;
-				struct stripe_head *sh2;
-
-				sector_t bn = compute_blocknr(sh, i);
-				sector_t s = raid5_compute_sector(bn, conf->raid_disks,
-								  conf->raid_disks-1,
-								  &dd_idx, &pd_idx, conf);
-				sh2 = get_active_stripe(conf, s, conf->raid_disks, pd_idx, 1);
-				if (sh2 == NULL)
-					/* so far only the early blocks of this stripe
-					 * have been requested.  When later blocks
-					 * get requested, we will try again
-					 */
-					continue;
-				if(!test_bit(STRIPE_EXPANDING, &sh2->state) ||
-				   test_bit(R5_Expanded, &sh2->dev[dd_idx].flags)) {
-					/* must have already done this block */
-					release_stripe(sh2);
-					continue;
-				}
-				memcpy(page_address(sh2->dev[dd_idx].page),
-				       page_address(sh->dev[i].page),
-				       STRIPE_SIZE);
-				set_bit(R5_Expanded, &sh2->dev[dd_idx].flags);
-				set_bit(R5_UPTODATE, &sh2->dev[dd_idx].flags);
-				for (j=0; j<conf->raid_disks; j++)
-					if (j != sh2->pd_idx &&
-					    !test_bit(R5_Expanded, &sh2->dev[j].flags))
-						break;
-				if (j == conf->raid_disks) {
-					set_bit(STRIPE_EXPAND_READY, &sh2->state);
-					set_bit(STRIPE_HANDLE, &sh2->state);
-				}
-				release_stripe(sh2);
-			}
-	}
+	if (s.expanding && s.locked == 0)
+		handle_stripe_expansion(conf, sh, &s, NULL);
 
 	spin_unlock(&sh->lock);
 
-	while ((bi=return_bi)) {
+	bi = return_bi;
+	while (bi) {
 		int bytes = bi->bi_size;
 
 		return_bi = bi->bi_next;
 		bi->bi_next = NULL;
 		bi->bi_size = 0;
 		bi->bi_end_io(bi, bytes,
-			      test_bit(BIO_UPTODATE, &bi->bi_flags)
-			        ? 0 : -EIO);
+			test_bit(BIO_UPTODATE, &bi->bi_flags) ? 0 : -EIO);
+		bi = return_bi;
 	}
-	for (i=disks; i-- ;) {
+	for (i = disks; i--;) {
 		int rw;
 		struct bio *bi;
 		mdk_rdev_t *rdev;
@@ -1850,16 +2190,16 @@ static void handle_stripe5(struct stripe_head *sh)
 		rcu_read_unlock();
  
 		if (rdev) {
-			if (syncing || expanding || expanded)
+			if (s.syncing || s.expanding || s.expanded)
 				md_sync_acct(rdev->bdev, STRIPE_SECTORS);
 
 			bi->bi_bdev = rdev->bdev;
-			PRINTK("for %llu schedule op %ld on disc %d\n",
+			pr_debug("for %llu schedule op %ld on disc %d\n",
 				(unsigned long long)sh->sector, bi->bi_rw, i);
 			atomic_inc(&sh->count);
 			bi->bi_sector = sh->sector + rdev->data_offset;
 			bi->bi_flags = 1 << BIO_UPTODATE;
-			bi->bi_vcnt = 1;	
+			bi->bi_vcnt = 1;
 			bi->bi_max_vecs = 1;
 			bi->bi_idx = 0;
 			bi->bi_io_vec = &sh->dev[i].vec;
@@ -1869,12 +2209,13 @@ static void handle_stripe5(struct stripe_head *sh)
 			bi->bi_next = NULL;
 			if (rw == WRITE &&
 			    test_bit(R5_ReWrite, &sh->dev[i].flags))
-				atomic_add(STRIPE_SECTORS, &rdev->corrected_errors);
+				atomic_add(STRIPE_SECTORS,
+					&rdev->corrected_errors);
 			generic_make_request(bi);
 		} else {
 			if (rw == WRITE)
 				set_bit(STRIPE_DEGRADED, &sh->state);
-			PRINTK("skip op %ld on disc %d for sector %llu\n",
+			pr_debug("skip op %ld on disc %d for sector %llu\n",
 				bi->bi_rw, i, (unsigned long long)sh->sector);
 			clear_bit(R5_LOCKED, &sh->dev[i].flags);
 			set_bit(STRIPE_HANDLE, &sh->state);
@@ -1886,29 +2227,27 @@ static void handle_stripe6(struct stripe_head *sh, struct page *tmp_page)
 {
 	raid6_conf_t *conf = sh->raid_conf;
 	int disks = sh->disks;
-	struct bio *return_bi= NULL;
+	struct bio *return_bi = NULL;
 	struct bio *bi;
-	int i;
-	int syncing, expanding, expanded;
-	int locked=0, uptodate=0, to_read=0, to_write=0, failed=0, written=0;
-	int non_overwrite = 0;
-	int failed_num[2] = {0, 0};
+	int i, pd_idx = sh->pd_idx;
+	struct stripe_head_state s;
+	struct r6_state r6s;
 	struct r5dev *dev, *pdev, *qdev;
-	int pd_idx = sh->pd_idx;
-	int qd_idx = raid6_next_disk(pd_idx, disks);
-	int p_failed, q_failed;
 
-	PRINTK("handling stripe %llu, state=%#lx cnt=%d, pd_idx=%d, qd_idx=%d\n",
-	       (unsigned long long)sh->sector, sh->state, atomic_read(&sh->count),
-	       pd_idx, qd_idx);
+	r6s.qd_idx = raid6_next_disk(pd_idx, disks);
+	pr_debug("handling stripe %llu, state=%#lx cnt=%d, "
+		"pd_idx=%d, qd_idx=%d\n",
+	       (unsigned long long)sh->sector, sh->state,
+	       atomic_read(&sh->count), pd_idx, r6s.qd_idx);
+	memset(&s, 0, sizeof(s));
 
 	spin_lock(&sh->lock);
 	clear_bit(STRIPE_HANDLE, &sh->state);
 	clear_bit(STRIPE_DELAYED, &sh->state);
 
-	syncing = test_bit(STRIPE_SYNCING, &sh->state);
-	expanding = test_bit(STRIPE_EXPAND_SOURCE, &sh->state);
-	expanded = test_bit(STRIPE_EXPAND_READY, &sh->state);
+	s.syncing = test_bit(STRIPE_SYNCING, &sh->state);
+	s.expanding = test_bit(STRIPE_EXPAND_SOURCE, &sh->state);
+	s.expanded = test_bit(STRIPE_EXPAND_READY, &sh->state);
 	/* Now to look around and see what can be done */
 
 	rcu_read_lock();
@@ -1917,19 +2256,20 @@ static void handle_stripe6(struct stripe_head *sh, struct page *tmp_page)
 		dev = &sh->dev[i];
 		clear_bit(R5_Insync, &dev->flags);
 
-		PRINTK("check %d: state 0x%lx read %p write %p written %p\n",
+		pr_debug("check %d: state 0x%lx read %p write %p written %p\n",
 			i, dev->flags, dev->toread, dev->towrite, dev->written);
 		/* maybe we can reply to a read */
 		if (test_bit(R5_UPTODATE, &dev->flags) && dev->toread) {
 			struct bio *rbi, *rbi2;
-			PRINTK("Return read for disc %d\n", i);
+			pr_debug("Return read for disc %d\n", i);
 			spin_lock_irq(&conf->device_lock);
 			rbi = dev->toread;
 			dev->toread = NULL;
 			if (test_and_clear_bit(R5_Overlap, &dev->flags))
 				wake_up(&conf->wait_for_overlap);
 			spin_unlock_irq(&conf->device_lock);
-			while (rbi && rbi->bi_sector < dev->sector + STRIPE_SECTORS) {
+			while (rbi && rbi->bi_sector <
+			       dev->sector + STRIPE_SECTORS) {
 				copy_data(0, rbi, dev->page, dev->sector);
 				rbi2 = r5_next_bio(rbi, dev->sector);
 				spin_lock_irq(&conf->device_lock);
@@ -1943,17 +2283,19 @@ static void handle_stripe6(struct stripe_head *sh, struct page *tmp_page)
 		}
 
 		/* now count some things */
-		if (test_bit(R5_LOCKED, &dev->flags)) locked++;
-		if (test_bit(R5_UPTODATE, &dev->flags)) uptodate++;
+		if (test_bit(R5_LOCKED, &dev->flags)) s.locked++;
+		if (test_bit(R5_UPTODATE, &dev->flags)) s.uptodate++;
 
 
-		if (dev->toread) to_read++;
+		if (dev->toread)
+			s.to_read++;
 		if (dev->towrite) {
-			to_write++;
+			s.to_write++;
 			if (!test_bit(R5_OVERWRITE, &dev->flags))
-				non_overwrite++;
+				s.non_overwrite++;
 		}
-		if (dev->written) written++;
+		if (dev->written)
+			s.written++;
 		rdev = rcu_dereference(conf->disks[i].rdev);
 		if (!rdev || !test_bit(In_sync, &rdev->flags)) {
 			/* The ReadError flag will just be confusing now */
@@ -1962,96 +2304,27 @@ static void handle_stripe6(struct stripe_head *sh, struct page *tmp_page)
 		}
 		if (!rdev || !test_bit(In_sync, &rdev->flags)
 		    || test_bit(R5_ReadError, &dev->flags)) {
-			if ( failed < 2 )
-				failed_num[failed] = i;
-			failed++;
+			if (s.failed < 2)
+				r6s.failed_num[s.failed] = i;
+			s.failed++;
 		} else
 			set_bit(R5_Insync, &dev->flags);
 	}
 	rcu_read_unlock();
-	PRINTK("locked=%d uptodate=%d to_read=%d"
+	pr_debug("locked=%d uptodate=%d to_read=%d"
 	       " to_write=%d failed=%d failed_num=%d,%d\n",
-	       locked, uptodate, to_read, to_write, failed,
-	       failed_num[0], failed_num[1]);
-	/* check if the array has lost >2 devices and, if so, some requests might
-	 * need to be failed
+	       s.locked, s.uptodate, s.to_read, s.to_write, s.failed,
+	       r6s.failed_num[0], r6s.failed_num[1]);
+	/* check if the array has lost >2 devices and, if so, some requests
+	 * might need to be failed
 	 */
-	if (failed > 2 && to_read+to_write+written) {
-		for (i=disks; i--; ) {
-			int bitmap_end = 0;
-
-			if (test_bit(R5_ReadError, &sh->dev[i].flags)) {
-				mdk_rdev_t *rdev;
-				rcu_read_lock();
-				rdev = rcu_dereference(conf->disks[i].rdev);
-				if (rdev && test_bit(In_sync, &rdev->flags))
-					/* multiple read failures in one stripe */
-					md_error(conf->mddev, rdev);
-				rcu_read_unlock();
-			}
-
-			spin_lock_irq(&conf->device_lock);
-			/* fail all writes first */
-			bi = sh->dev[i].towrite;
-			sh->dev[i].towrite = NULL;
-			if (bi) { to_write--; bitmap_end = 1; }
-
-			if (test_and_clear_bit(R5_Overlap, &sh->dev[i].flags))
-				wake_up(&conf->wait_for_overlap);
-
-			while (bi && bi->bi_sector < sh->dev[i].sector + STRIPE_SECTORS){
-				struct bio *nextbi = r5_next_bio(bi, sh->dev[i].sector);
-				clear_bit(BIO_UPTODATE, &bi->bi_flags);
-				if (--bi->bi_phys_segments == 0) {
-					md_write_end(conf->mddev);
-					bi->bi_next = return_bi;
-					return_bi = bi;
-				}
-				bi = nextbi;
-			}
-			/* and fail all 'written' */
-			bi = sh->dev[i].written;
-			sh->dev[i].written = NULL;
-			if (bi) bitmap_end = 1;
-			while (bi && bi->bi_sector < sh->dev[i].sector + STRIPE_SECTORS) {
-				struct bio *bi2 = r5_next_bio(bi, sh->dev[i].sector);
-				clear_bit(BIO_UPTODATE, &bi->bi_flags);
-				if (--bi->bi_phys_segments == 0) {
-					md_write_end(conf->mddev);
-					bi->bi_next = return_bi;
-					return_bi = bi;
-				}
-				bi = bi2;
-			}
-
-			/* fail any reads if this device is non-operational */
-			if (!test_bit(R5_Insync, &sh->dev[i].flags) ||
-			    test_bit(R5_ReadError, &sh->dev[i].flags)) {
-				bi = sh->dev[i].toread;
-				sh->dev[i].toread = NULL;
-				if (test_and_clear_bit(R5_Overlap, &sh->dev[i].flags))
-					wake_up(&conf->wait_for_overlap);
-				if (bi) to_read--;
-				while (bi && bi->bi_sector < sh->dev[i].sector + STRIPE_SECTORS){
-					struct bio *nextbi = r5_next_bio(bi, sh->dev[i].sector);
-					clear_bit(BIO_UPTODATE, &bi->bi_flags);
-					if (--bi->bi_phys_segments == 0) {
-						bi->bi_next = return_bi;
-						return_bi = bi;
-					}
-					bi = nextbi;
-				}
-			}
-			spin_unlock_irq(&conf->device_lock);
-			if (bitmap_end)
-				bitmap_endwrite(conf->mddev->bitmap, sh->sector,
-						STRIPE_SECTORS, 0, 0);
-		}
-	}
-	if (failed > 2 && syncing) {
+	if (s.failed > 2 && s.to_read+s.to_write+s.written)
+		handle_requests_to_failed_array(conf, sh, &s, disks,
+						&return_bi);
+	if (s.failed > 2 && s.syncing) {
 		md_done_sync(conf->mddev, STRIPE_SECTORS,0);
 		clear_bit(STRIPE_SYNCING, &sh->state);
-		syncing = 0;
+		s.syncing = 0;
 	}
 
 	/*
@@ -2059,279 +2332,41 @@ static void handle_stripe6(struct stripe_head *sh, struct page *tmp_page)
 	 * are safe, or on a failed drive
 	 */
 	pdev = &sh->dev[pd_idx];
-	p_failed = (failed >= 1 && failed_num[0] == pd_idx)
-		|| (failed >= 2 && failed_num[1] == pd_idx);
-	qdev = &sh->dev[qd_idx];
-	q_failed = (failed >= 1 && failed_num[0] == qd_idx)
-		|| (failed >= 2 && failed_num[1] == qd_idx);
-
-	if ( written &&
-	     ( p_failed || ((test_bit(R5_Insync, &pdev->flags)
+	r6s.p_failed = (s.failed >= 1 && r6s.failed_num[0] == pd_idx)
+		|| (s.failed >= 2 && r6s.failed_num[1] == pd_idx);
+	qdev = &sh->dev[r6s.qd_idx];
+	r6s.q_failed = (s.failed >= 1 && r6s.failed_num[0] == r6s.qd_idx)
+		|| (s.failed >= 2 && r6s.failed_num[1] == r6s.qd_idx);
+
+	if ( s.written &&
+	     ( r6s.p_failed || ((test_bit(R5_Insync, &pdev->flags)
 			     && !test_bit(R5_LOCKED, &pdev->flags)
-			     && test_bit(R5_UPTODATE, &pdev->flags))) ) &&
-	     ( q_failed || ((test_bit(R5_Insync, &qdev->flags)
+			     && test_bit(R5_UPTODATE, &pdev->flags)))) &&
+	     ( r6s.q_failed || ((test_bit(R5_Insync, &qdev->flags)
 			     && !test_bit(R5_LOCKED, &qdev->flags)
-			     && test_bit(R5_UPTODATE, &qdev->flags))) ) ) {
-		/* any written block on an uptodate or failed drive can be
-		 * returned.  Note that if we 'wrote' to a failed drive,
-		 * it will be UPTODATE, but never LOCKED, so we don't need
-		 * to test 'failed' directly.
-		 */
-		for (i=disks; i--; )
-			if (sh->dev[i].written) {
-				dev = &sh->dev[i];
-				if (!test_bit(R5_LOCKED, &dev->flags) &&
-				    test_bit(R5_UPTODATE, &dev->flags) ) {
-					/* We can return any write requests */
-					int bitmap_end = 0;
-					struct bio *wbi, *wbi2;
-					PRINTK("Return write for stripe %llu disc %d\n",
-					       (unsigned long long)sh->sector, i);
-					spin_lock_irq(&conf->device_lock);
-					wbi = dev->written;
-					dev->written = NULL;
-					while (wbi && wbi->bi_sector < dev->sector + STRIPE_SECTORS) {
-						wbi2 = r5_next_bio(wbi, dev->sector);
-						if (--wbi->bi_phys_segments == 0) {
-							md_write_end(conf->mddev);
-							wbi->bi_next = return_bi;
-							return_bi = wbi;
-						}
-						wbi = wbi2;
-					}
-					if (dev->towrite == NULL)
-						bitmap_end = 1;
-					spin_unlock_irq(&conf->device_lock);
-					if (bitmap_end)
-						bitmap_endwrite(conf->mddev->bitmap, sh->sector,
-								STRIPE_SECTORS,
-								!test_bit(STRIPE_DEGRADED, &sh->state), 0);
-				}
-			}
-	}
+			     && test_bit(R5_UPTODATE, &qdev->flags)))))
+		handle_completed_write_requests(conf, sh, disks, &return_bi);
 
 	/* Now we might consider reading some blocks, either to check/generate
 	 * parity, or to satisfy requests
 	 * or to load a block that is being partially written.
 	 */
-	if (to_read || non_overwrite || (to_write && failed) ||
-	    (syncing && (uptodate < disks)) || expanding) {
-		for (i=disks; i--;) {
-			dev = &sh->dev[i];
-			if (!test_bit(R5_LOCKED, &dev->flags) && !test_bit(R5_UPTODATE, &dev->flags) &&
-			    (dev->toread ||
-			     (dev->towrite && !test_bit(R5_OVERWRITE, &dev->flags)) ||
-			     syncing ||
-			     expanding ||
-			     (failed >= 1 && (sh->dev[failed_num[0]].toread || to_write)) ||
-			     (failed >= 2 && (sh->dev[failed_num[1]].toread || to_write))
-				    )
-				) {
-				/* we would like to get this block, possibly
-				 * by computing it, but we might not be able to
-				 */
-				if (uptodate == disks-1) {
-					PRINTK("Computing stripe %llu block %d\n",
-					       (unsigned long long)sh->sector, i);
-					compute_block_1(sh, i, 0);
-					uptodate++;
-				} else if ( uptodate == disks-2 && failed >= 2 ) {
-					/* Computing 2-failure is *very* expensive; only do it if failed >= 2 */
-					int other;
-					for (other=disks; other--;) {
-						if ( other == i )
-							continue;
-						if ( !test_bit(R5_UPTODATE, &sh->dev[other].flags) )
-							break;
-					}
-					BUG_ON(other < 0);
-					PRINTK("Computing stripe %llu blocks %d,%d\n",
-					       (unsigned long long)sh->sector, i, other);
-					compute_block_2(sh, i, other);
-					uptodate += 2;
-				} else if (test_bit(R5_Insync, &dev->flags)) {
-					set_bit(R5_LOCKED, &dev->flags);
-					set_bit(R5_Wantread, &dev->flags);
-					locked++;
-					PRINTK("Reading block %d (sync=%d)\n",
-						i, syncing);
-				}
-			}
-		}
-		set_bit(STRIPE_HANDLE, &sh->state);
-	}
+	if (s.to_read || s.non_overwrite || (s.to_write && s.failed) ||
+	    (s.syncing && (s.uptodate < disks)) || s.expanding)
+		handle_issuing_new_read_requests6(sh, &s, &r6s, disks);
 
 	/* now to consider writing and what else, if anything should be read */
-	if (to_write) {
-		int rcw=0, must_compute=0;
-		for (i=disks ; i--;) {
-			dev = &sh->dev[i];
-			/* Would I have to read this buffer for reconstruct_write */
-			if (!test_bit(R5_OVERWRITE, &dev->flags)
-			    && i != pd_idx && i != qd_idx
-			    && (!test_bit(R5_LOCKED, &dev->flags)
-				    ) &&
-			    !test_bit(R5_UPTODATE, &dev->flags)) {
-				if (test_bit(R5_Insync, &dev->flags)) rcw++;
-				else {
-					PRINTK("raid6: must_compute: disk %d flags=%#lx\n", i, dev->flags);
-					must_compute++;
-				}
-			}
-		}
-		PRINTK("for sector %llu, rcw=%d, must_compute=%d\n",
-		       (unsigned long long)sh->sector, rcw, must_compute);
-		set_bit(STRIPE_HANDLE, &sh->state);
-
-		if (rcw > 0)
-			/* want reconstruct write, but need to get some data */
-			for (i=disks; i--;) {
-				dev = &sh->dev[i];
-				if (!test_bit(R5_OVERWRITE, &dev->flags)
-				    && !(failed == 0 && (i == pd_idx || i == qd_idx))
-				    && !test_bit(R5_LOCKED, &dev->flags) && !test_bit(R5_UPTODATE, &dev->flags) &&
-				    test_bit(R5_Insync, &dev->flags)) {
-					if (test_bit(STRIPE_PREREAD_ACTIVE, &sh->state))
-					{
-						PRINTK("Read_old stripe %llu block %d for Reconstruct\n",
-						       (unsigned long long)sh->sector, i);
-						set_bit(R5_LOCKED, &dev->flags);
-						set_bit(R5_Wantread, &dev->flags);
-						locked++;
-					} else {
-						PRINTK("Request delayed stripe %llu block %d for Reconstruct\n",
-						       (unsigned long long)sh->sector, i);
-						set_bit(STRIPE_DELAYED, &sh->state);
-						set_bit(STRIPE_HANDLE, &sh->state);
-					}
-				}
-			}
-		/* now if nothing is locked, and if we have enough data, we can start a write request */
-		if (locked == 0 && rcw == 0 &&
-		    !test_bit(STRIPE_BIT_DELAY, &sh->state)) {
-			if ( must_compute > 0 ) {
-				/* We have failed blocks and need to compute them */
-				switch ( failed ) {
-				case 0:	BUG();
-				case 1: compute_block_1(sh, failed_num[0], 0); break;
-				case 2: compute_block_2(sh, failed_num[0], failed_num[1]); break;
-				default: BUG();	/* This request should have been failed? */
-				}
-			}
-
-			PRINTK("Computing parity for stripe %llu\n", (unsigned long long)sh->sector);
-			compute_parity6(sh, RECONSTRUCT_WRITE);
-			/* now every locked buffer is ready to be written */
-			for (i=disks; i--;)
-				if (test_bit(R5_LOCKED, &sh->dev[i].flags)) {
-					PRINTK("Writing stripe %llu block %d\n",
-					       (unsigned long long)sh->sector, i);
-					locked++;
-					set_bit(R5_Wantwrite, &sh->dev[i].flags);
-				}
-			/* after a RECONSTRUCT_WRITE, the stripe MUST be in-sync */
-			set_bit(STRIPE_INSYNC, &sh->state);
-
-			if (test_and_clear_bit(STRIPE_PREREAD_ACTIVE, &sh->state)) {
-				atomic_dec(&conf->preread_active_stripes);
-				if (atomic_read(&conf->preread_active_stripes) < IO_THRESHOLD)
-					md_wakeup_thread(conf->mddev->thread);
-			}
-		}
-	}
+	if (s.to_write)
+		handle_issuing_new_write_requests6(conf, sh, &s, &r6s, disks);
 
 	/* maybe we need to check and possibly fix the parity for this stripe
-	 * Any reads will already have been scheduled, so we just see if enough data
-	 * is available
+	 * Any reads will already have been scheduled, so we just see if enough
+	 * data is available
 	 */
-	if (syncing && locked == 0 && !test_bit(STRIPE_INSYNC, &sh->state)) {
-		int update_p = 0, update_q = 0;
-		struct r5dev *dev;
-
-		set_bit(STRIPE_HANDLE, &sh->state);
-
-		BUG_ON(failed>2);
-		BUG_ON(uptodate < disks);
-		/* Want to check and possibly repair P and Q.
-		 * However there could be one 'failed' device, in which
-		 * case we can only check one of them, possibly using the
-		 * other to generate missing data
-		 */
-
-		/* If !tmp_page, we cannot do the calculations,
-		 * but as we have set STRIPE_HANDLE, we will soon be called
-		 * by stripe_handle with a tmp_page - just wait until then.
-		 */
-		if (tmp_page) {
-			if (failed == q_failed) {
-				/* The only possible failed device holds 'Q', so it makes
-				 * sense to check P (If anything else were failed, we would
-				 * have used P to recreate it).
-				 */
-				compute_block_1(sh, pd_idx, 1);
-				if (!page_is_zero(sh->dev[pd_idx].page)) {
-					compute_block_1(sh,pd_idx,0);
-					update_p = 1;
-				}
-			}
-			if (!q_failed && failed < 2) {
-				/* q is not failed, and we didn't use it to generate
-				 * anything, so it makes sense to check it
-				 */
-				memcpy(page_address(tmp_page),
-				       page_address(sh->dev[qd_idx].page),
-				       STRIPE_SIZE);
-				compute_parity6(sh, UPDATE_PARITY);
-				if (memcmp(page_address(tmp_page),
-					   page_address(sh->dev[qd_idx].page),
-					   STRIPE_SIZE)!= 0) {
-					clear_bit(STRIPE_INSYNC, &sh->state);
-					update_q = 1;
-				}
-			}
-			if (update_p || update_q) {
-				conf->mddev->resync_mismatches += STRIPE_SECTORS;
-				if (test_bit(MD_RECOVERY_CHECK, &conf->mddev->recovery))
-					/* don't try to repair!! */
-					update_p = update_q = 0;
-			}
-
-			/* now write out any block on a failed drive,
-			 * or P or Q if they need it
-			 */
-
-			if (failed == 2) {
-				dev = &sh->dev[failed_num[1]];
-				locked++;
-				set_bit(R5_LOCKED, &dev->flags);
-				set_bit(R5_Wantwrite, &dev->flags);
-			}
-			if (failed >= 1) {
-				dev = &sh->dev[failed_num[0]];
-				locked++;
-				set_bit(R5_LOCKED, &dev->flags);
-				set_bit(R5_Wantwrite, &dev->flags);
-			}
-
-			if (update_p) {
-				dev = &sh->dev[pd_idx];
-				locked ++;
-				set_bit(R5_LOCKED, &dev->flags);
-				set_bit(R5_Wantwrite, &dev->flags);
-			}
-			if (update_q) {
-				dev = &sh->dev[qd_idx];
-				locked++;
-				set_bit(R5_LOCKED, &dev->flags);
-				set_bit(R5_Wantwrite, &dev->flags);
-			}
-			clear_bit(STRIPE_DEGRADED, &sh->state);
-
-			set_bit(STRIPE_INSYNC, &sh->state);
-		}
-	}
+	if (s.syncing && s.locked == 0 && !test_bit(STRIPE_INSYNC, &sh->state))
+		handle_parity_checks6(conf, sh, &s, &r6s, tmp_page, disks);
 
-	if (syncing && locked == 0 && test_bit(STRIPE_INSYNC, &sh->state)) {
+	if (s.syncing && s.locked == 0 && test_bit(STRIPE_INSYNC, &sh->state)) {
 		md_done_sync(conf->mddev, STRIPE_SECTORS,1);
 		clear_bit(STRIPE_SYNCING, &sh->state);
 	}
@@ -2339,9 +2374,9 @@ static void handle_stripe6(struct stripe_head *sh, struct page *tmp_page)
 	/* If the failed drives are just a ReadError, then we might need
 	 * to progress the repair/check process
 	 */
-	if (failed <= 2 && ! conf->mddev->ro)
-		for (i=0; i<failed;i++) {
-			dev = &sh->dev[failed_num[i]];
+	if (s.failed <= 2 && !conf->mddev->ro)
+		for (i = 0; i < s.failed; i++) {
+			dev = &sh->dev[r6s.failed_num[i]];
 			if (test_bit(R5_ReadError, &dev->flags)
 			    && !test_bit(R5_LOCKED, &dev->flags)
 			    && test_bit(R5_UPTODATE, &dev->flags)
@@ -2358,7 +2393,7 @@ static void handle_stripe6(struct stripe_head *sh, struct page *tmp_page)
 			}
 		}
 
-	if (expanded && test_bit(STRIPE_EXPANDING, &sh->state)) {
+	if (s.expanded && test_bit(STRIPE_EXPANDING, &sh->state)) {
 		/* Need to write out all blocks after computing P&Q */
 		sh->disks = conf->raid_disks;
 		sh->pd_idx = stripe_to_pdidx(sh->sector, conf,
@@ -2366,83 +2401,34 @@ static void handle_stripe6(struct stripe_head *sh, struct page *tmp_page)
 		compute_parity6(sh, RECONSTRUCT_WRITE);
 		for (i = conf->raid_disks ; i-- ;  ) {
 			set_bit(R5_LOCKED, &sh->dev[i].flags);
-			locked++;
+			s.locked++;
 			set_bit(R5_Wantwrite, &sh->dev[i].flags);
 		}
 		clear_bit(STRIPE_EXPANDING, &sh->state);
-	} else if (expanded) {
+	} else if (s.expanded) {
 		clear_bit(STRIPE_EXPAND_READY, &sh->state);
 		atomic_dec(&conf->reshape_stripes);
 		wake_up(&conf->wait_for_overlap);
 		md_done_sync(conf->mddev, STRIPE_SECTORS, 1);
 	}
 
-	if (expanding && locked == 0) {
-		/* We have read all the blocks in this stripe and now we need to
-		 * copy some of them into a target stripe for expand.
-		 */
-		clear_bit(STRIPE_EXPAND_SOURCE, &sh->state);
-		for (i = 0; i < sh->disks ; i++)
-			if (i != pd_idx && i != qd_idx) {
-				int dd_idx2, pd_idx2, j;
-				struct stripe_head *sh2;
-
-				sector_t bn = compute_blocknr(sh, i);
-				sector_t s = raid5_compute_sector(
-					bn, conf->raid_disks,
-					conf->raid_disks - conf->max_degraded,
-					&dd_idx2, &pd_idx2, conf);
-				sh2 = get_active_stripe(conf, s,
-							conf->raid_disks,
-						       pd_idx2, 1);
-				if (sh2 == NULL)
-					/* so for only the early blocks of
-					 * this stripe have been requests.
-					 * When later blocks get requests, we
-					 * will try again
-					 */
-					continue;
-				if (!test_bit(STRIPE_EXPANDING, &sh2->state) ||
-				    test_bit(R5_Expanded,
-					     &sh2->dev[dd_idx2].flags)) {
-					/* must have already done this block */
-					release_stripe(sh2);
-					continue;
-				}
-				memcpy(page_address(sh2->dev[dd_idx2].page),
-				       page_address(sh->dev[i].page),
-				       STRIPE_SIZE);
-				set_bit(R5_Expanded, &sh2->dev[dd_idx2].flags);
-				set_bit(R5_UPTODATE, &sh2->dev[dd_idx2].flags);
-				for (j = 0 ; j < conf->raid_disks ; j++)
-					if (j != sh2->pd_idx &&
-					    j != raid6_next_disk(sh2->pd_idx,
-							   sh2->disks) &&
-					    !test_bit(R5_Expanded,
-						      &sh2->dev[j].flags))
-						break;
-				if (j == conf->raid_disks) {
-					set_bit(STRIPE_EXPAND_READY,
-						&sh2->state);
-					set_bit(STRIPE_HANDLE, &sh2->state);
-				}
-				release_stripe(sh2);
-			}
-	}
+	if (s.expanding && s.locked == 0)
+		handle_stripe_expansion(conf, sh, &s, &r6s);
 
 	spin_unlock(&sh->lock);
 
-	while ((bi=return_bi)) {
+	bi = return_bi;
+	while (bi) {
 		int bytes = bi->bi_size;
 
 		return_bi = bi->bi_next;
 		bi->bi_next = NULL;
 		bi->bi_size = 0;
 		bi->bi_end_io(bi, bytes,
-			      test_bit(BIO_UPTODATE, &bi->bi_flags)
-			        ? 0 : -EIO);
+			test_bit(BIO_UPTODATE, &bi->bi_flags) ? 0 : -EIO);
+		bi = return_bi;
 	}
-	for (i=disks; i-- ;) {
+	for (i = disks; i--;) {
 		int rw;
 		struct bio *bi;
 		mdk_rdev_t *rdev;
@@ -2470,11 +2456,11 @@ static void handle_stripe6(struct stripe_head *sh, struct page *tmp_page)
 		rcu_read_unlock();
 
 		if (rdev) {
-			if (syncing || expanding || expanded)
+			if (s.syncing || s.expanding || s.expanded)
 				md_sync_acct(rdev->bdev, STRIPE_SECTORS);
 
 			bi->bi_bdev = rdev->bdev;
-			PRINTK("for %llu schedule op %ld on disc %d\n",
+			pr_debug("for %llu schedule op %ld on disc %d\n",
 				(unsigned long long)sh->sector, bi->bi_rw, i);
 			atomic_inc(&sh->count);
 			bi->bi_sector = sh->sector + rdev->data_offset;
@@ -2489,12 +2475,13 @@ static void handle_stripe6(struct stripe_head *sh, struct page *tmp_page)
 			bi->bi_next = NULL;
 			if (rw == WRITE &&
 			    test_bit(R5_ReWrite, &sh->dev[i].flags))
-				atomic_add(STRIPE_SECTORS, &rdev->corrected_errors);
+				atomic_add(STRIPE_SECTORS,
+					&rdev->corrected_errors);
 			generic_make_request(bi);
 		} else {
 			if (rw == WRITE)
 				set_bit(STRIPE_DEGRADED, &sh->state);
-			PRINTK("skip op %ld on disc %d for sector %llu\n",
+			pr_debug("skip op %ld on disc %d for sector %llu\n",
 				bi->bi_rw, i, (unsigned long long)sh->sector);
 			clear_bit(R5_LOCKED, &sh->dev[i].flags);
 			set_bit(STRIPE_HANDLE, &sh->state);
@@ -2521,7 +2508,8 @@ static void raid5_activate_delayed(raid5_conf_t *conf)
 			sh = list_entry(l, struct stripe_head, lru);
 			list_del_init(l);
 			clear_bit(STRIPE_DELAYED, &sh->state);
-			if (!test_and_set_bit(STRIPE_PREREAD_ACTIVE, &sh->state))
+			if (!test_and_set_bit(STRIPE_PREREAD_ACTIVE,
+			    &sh->state))
 				atomic_inc(&conf->preread_active_stripes);
 			list_add_tail(&sh->lru, &conf->handle_list);
 		}
@@ -2550,7 +2538,8 @@ static void unplug_slaves(mddev_t *mddev)
 	rcu_read_lock();
 	for (i=0; i<mddev->raid_disks; i++) {
 		mdk_rdev_t *rdev = rcu_dereference(conf->disks[i].rdev);
-		if (rdev && !test_bit(Faulty, &rdev->flags) && atomic_read(&rdev->nr_pending)) {
+		if (rdev && !test_bit(Faulty, &rdev->flags) &&
+		    atomic_read(&rdev->nr_pending)) {
 			request_queue_t *r_queue = bdev_get_queue(rdev->bdev);
 
 			atomic_inc(&rdev->nr_pending);
@@ -2604,8 +2593,9 @@ static int raid5_issue_flush(request_queue_t *q, struct gendisk *disk,
 			else {
 				atomic_inc(&rdev->nr_pending);
 				rcu_read_unlock();
-				ret = r_queue->issue_flush_fn(r_queue, bdev->bd_disk,
-							      error_sector);
+				ret = r_queue->issue_flush_fn(r_queue,
+							bdev->bd_disk,
+							error_sector);
 				rdev_dec_pending(rdev, mddev);
 				rcu_read_lock();
 			}
@@ -2647,7 +2637,8 @@ static int raid5_mergeable_bvec(request_queue_t *q, struct bio *bio, struct bio_
 	if (bio_data_dir(bio) == WRITE)
 		return biovec->bv_len; /* always allow writes to be mergeable */
 
-	max =  (chunk_sectors - ((sector & (chunk_sectors - 1)) + bio_sectors)) << 9;
+	max = (chunk_sectors -
+		((sector & (chunk_sectors - 1)) + bio_sectors))	<< 9;
 	if (max < 0) max = 0;
 	if (max <= biovec->bv_len && bio_sectors == 0)
 		return biovec->bv_len;
@@ -2738,7 +2729,7 @@ static int raid5_align_endio(struct bio *bi, unsigned int bytes, int error)
 	}
 
 
-	PRINTK("raid5_align_endio : io error...handing IO for a retry\n");
+	pr_debug("raid5_align_endio : io error...handing IO for a retry\n");
 
 	add_bio_to_retry(raid_bi, conf);
 	return 0;
@@ -2776,7 +2767,7 @@ static int chunk_aligned_read(request_queue_t *q, struct bio * raid_bio)
 	mdk_rdev_t *rdev;
 
 	if (!in_chunk_boundary(mddev, raid_bio)) {
-		PRINTK("chunk_aligned_read : non aligned\n");
+		pr_debug("chunk_aligned_read : non aligned\n");
 		return 0;
 	}
 	/*
@@ -2864,14 +2855,15 @@ static int make_request(request_queue_t *q, struct bio * bi)
 	logical_sector = bi->bi_sector & ~((sector_t)STRIPE_SECTORS-1);
 	last_sector = bi->bi_sector + (bi->bi_size>>9);
 	bi->bi_next = NULL;
-	bi->bi_phys_segments = 1;	/* over-loaded to count active stripes */
+	bi->bi_phys_segments = 1; /* over-loaded to count active stripes */
 
 	for (;logical_sector < last_sector; logical_sector += STRIPE_SECTORS) {
 		DEFINE_WAIT(w);
 		int disks, data_disks;
 
 	retry:
-		prepare_to_wait(&conf->wait_for_overlap, &w, TASK_UNINTERRUPTIBLE);
+		prepare_to_wait(&conf->wait_for_overlap, &w,
+				TASK_UNINTERRUPTIBLE);
 		if (likely(conf->expand_progress == MaxSector))
 			disks = conf->raid_disks;
 		else {
@@ -2898,22 +2890,24 @@ static int make_request(request_queue_t *q, struct bio * bi)
 		}
 		data_disks = disks - conf->max_degraded;
 
- 		new_sector = raid5_compute_sector(logical_sector, disks, data_disks,
-						  &dd_idx, &pd_idx, conf);
-		PRINTK("raid5: make_request, sector %llu logical %llu\n",
+		new_sector = raid5_compute_sector(logical_sector, disks,
+					data_disks, &dd_idx, &pd_idx, conf);
+		pr_debug("raid5: make_request, sector %llu logical %llu\n",
 			(unsigned long long)new_sector, 
 			(unsigned long long)logical_sector);
 
-		sh = get_active_stripe(conf, new_sector, disks, pd_idx, (bi->bi_rw&RWA_MASK));
+		sh = get_active_stripe(conf, new_sector, disks, pd_idx,
+				(bi->bi_rw&RWA_MASK));
 		if (sh) {
 			if (unlikely(conf->expand_progress != MaxSector)) {
-				/* expansion might have moved on while waiting for a
-				 * stripe, so we must do the range check again.
-				 * Expansion could still move past after this
-				 * test, but as we are holding a reference to
-				 * 'sh', we know that if that happens,
-				 *  STRIPE_EXPANDING will get set and the expansion
-				 * won't proceed until we finish with the stripe.
+				/* expansion might have moved on while waiting
+				 * for a stripe, so we must do the range check
+				 * again.  Expansion could still move past after
+				 * this test, but as we are holding a reference
+				 * to 'sh', we know that if that happens,
+				 * STRIPE_EXPANDING will get set and the
+				 * expansion won't proceed until we finish with
+				 * the stripe.
 				 */
 				int must_retry = 0;
 				spin_lock_irq(&conf->device_lock);
@@ -2938,8 +2932,8 @@ static int make_request(request_queue_t *q, struct bio * bi)
 			}
 
 			if (test_bit(STRIPE_EXPANDING, &sh->state) ||
-			    !add_stripe_bio(sh, bi, dd_idx, (bi->bi_rw&RW_MASK))) {
-				/* Stripe is busy expanding or
+			 !add_stripe_bio(sh, bi, dd_idx, (bi->bi_rw&RW_MASK))) {
+				/* Stripe is busy s.expanding or
 				 * add failed due to overlap.  Flush everything
 				 * and wait a while
 				 */
@@ -2975,7 +2969,8 @@ static int make_request(request_queue_t *q, struct bio * bi)
 	return 0;
 }
 
-static sector_t reshape_request(mddev_t *mddev, sector_t sector_nr, int *skipped)
+static sector_t
+reshape_request(mddev_t *mddev, sector_t sector_nr, int *skipped)
 {
 	/* reshaping is quite different to recovery/resync so it is
 	 * handled quite separately ... here.
@@ -3171,7 +3166,8 @@ static inline sector_t sync_request(mddev_t *mddev, sector_t sector_nr, int *ski
 		if (conf->disks[i].rdev == NULL)
 			still_degraded = 1;
 
-	bitmap_start_sync(mddev->bitmap, sector_nr, &sync_blocks, still_degraded);
+	bitmap_start_sync(mddev->bitmap, sector_nr, &sync_blocks,
+			still_degraded);
 
 	spin_lock(&sh->lock);
 	set_bit(STRIPE_SYNCING, &sh->state);
@@ -3221,7 +3217,8 @@ static int  retry_aligned_read(raid5_conf_t *conf, struct bio *raid_bio)
 			/* already done this stripe */
 			continue;
 
-		sh = get_active_stripe(conf, sector, conf->raid_disks, pd_idx, 1);
+		sh = get_active_stripe(conf, sector, conf->raid_disks,
+			pd_idx, 1);
 
 		if (!sh) {
 			/* failed to get a stripe - must wait */
@@ -3273,7 +3270,7 @@ static void raid5d (mddev_t *mddev)
 	raid5_conf_t *conf = mddev_to_conf(mddev);
 	int handled;
 
-	PRINTK("+++ raid5d active\n");
+	pr_debug("+++ raid5d active\n");
 
 	md_check_recovery(mddev);
 
@@ -3325,13 +3322,13 @@ static void raid5d (mddev_t *mddev)
 
 		spin_lock_irq(&conf->device_lock);
 	}
-	PRINTK("%d stripes handled\n", handled);
+	pr_debug("%d stripes handled\n", handled);
 
 	spin_unlock_irq(&conf->device_lock);
 
 	unplug_slaves(mddev);
 
-	PRINTK("--- raid5d inactive\n");
+	pr_debug("--- raid5d inactive\n");
 }
 
 static ssize_t
@@ -3385,7 +3382,8 @@ stripe_cache_active_show(mddev_t *mddev, char *page)
 {
 	raid5_conf_t *conf = mddev_to_conf(mddev);
 	if (conf)
-		return sprintf(page, "%d\n", atomic_read(&conf->active_stripes));
+		return sprintf(page, "%d\n",
+			atomic_read(&conf->active_stripes));
 	else
 		return 0;
 }
@@ -3475,10 +3473,12 @@ static int run(mddev_t *mddev)
 	if ((conf = mddev->private) == NULL)
 		goto abort;
 	if (mddev->reshape_position == MaxSector) {
-		conf->previous_raid_disks = conf->raid_disks = mddev->raid_disks;
+		conf->previous_raid_disks = conf->raid_disks =
+			mddev->raid_disks;
 	} else {
 		conf->raid_disks = mddev->raid_disks;
-		conf->previous_raid_disks = mddev->raid_disks - mddev->delta_disks;
+		conf->previous_raid_disks = mddev->raid_disks -
+					mddev->delta_disks;
 	}
 
 	conf->disks = kzalloc(conf->raid_disks * sizeof(struct disk_info),
@@ -3507,7 +3507,7 @@ static int run(mddev_t *mddev)
 	atomic_set(&conf->preread_active_stripes, 0);
 	atomic_set(&conf->active_aligned_reads, 0);
 
-	PRINTK("raid5: run(%s) called.\n", mdname(mddev));
+	pr_debug("raid5: run(%s) called.\n", mdname(mddev));
 
 	ITERATE_RDEV(mddev,rdev,tmp) {
 		raid_disk = rdev->raid_disk;
@@ -3547,8 +3547,8 @@ static int run(mddev_t *mddev)
 	mddev->resync_max_sectors = mddev->size << 1;
 
 	if (conf->level == 6 && conf->raid_disks < 4) {
-		printk(KERN_ERR "raid6: not enough configured devices for %s (%d, minimum 4)\n",
-		       mdname(mddev), conf->raid_disks);
+		printk(KERN_ERR "raid6: not enough configured devices for %s "
+			"(%d, minimum 4)\n", mdname(mddev), conf->raid_disks);
 		goto abort;
 	}
 	if (!conf->chunk_size || conf->chunk_size % 4) {
@@ -3578,8 +3578,8 @@ static int run(mddev_t *mddev)
 			       mdname(mddev));
 		else {
 			printk(KERN_ERR
-			       "raid5: cannot start dirty degraded array for %s\n",
-			       mdname(mddev));
+			       "raid5: cannot start dirty degraded array for "
+			       "%s\n", mdname(mddev));
 			goto abort;
 		}
 	}
@@ -3690,7 +3690,7 @@ static int stop(mddev_t *mddev)
 	return 0;
 }
 
-#if RAID5_DEBUG
+#ifdef DEBUG
 static void print_sh (struct seq_file *seq, struct stripe_head *sh)
 {
 	int i;
@@ -3725,25 +3725,27 @@ static void printall (struct seq_file *seq, raid5_conf_t *conf)
 }
 #endif
 
-static void status (struct seq_file *seq, mddev_t *mddev)
+static void status(struct seq_file *seq, mddev_t *mddev)
 {
 	raid5_conf_t *conf = (raid5_conf_t *) mddev->private;
 	int i;
 
-	seq_printf (seq, " level %d, %dk chunk, algorithm %d", mddev->level, mddev->chunk_size >> 10, mddev->layout);
-	seq_printf (seq, " [%d/%d] [", conf->raid_disks, conf->raid_disks - mddev->degraded);
+	seq_printf (seq, " level %d, %dk chunk, algorithm %d",
+		mddev->level, mddev->chunk_size >> 10, mddev->layout);
+	seq_printf (seq, " [%d/%d] [", conf->raid_disks,
+		conf->raid_disks - mddev->degraded);
 	for (i = 0; i < conf->raid_disks; i++)
-		seq_printf (seq, "%s",
-			       conf->disks[i].rdev &&
-			       test_bit(In_sync, &conf->disks[i].rdev->flags) ? "U" : "_");
+		seq_printf(seq, "%s",
+		    conf->disks[i].rdev &&
+		    test_bit(In_sync, &conf->disks[i].rdev->flags) ? "U" : "_");
 	seq_printf (seq, "]");
-#if RAID5_DEBUG
+#ifdef DEBUG
 	seq_printf (seq, "\n");
 	printall(seq, conf);
 #endif
 }
 
-static void print_raid5_conf (raid5_conf_t *conf)
+static void print_raid5_conf(raid5_conf_t *conf)
 {
 	int i;
 	struct disk_info *tmp;
@@ -3862,14 +3864,15 @@ static int raid5_resize(mddev_t *mddev, sector_t sectors)
 	raid5_conf_t *conf = mddev_to_conf(mddev);
 
 	sectors &= ~((sector_t)mddev->chunk_size/512 - 1);
-	mddev->array_size = (sectors * (mddev->raid_disks-conf->max_degraded))>>1;
+	mddev->array_size =
+		(sectors * (mddev->raid_disks-conf->max_degraded)) >> 1;
 	set_capacity(mddev->gendisk, mddev->array_size << 1);
 	mddev->changed = 1;
 	if (sectors/2  > mddev->size && mddev->recovery_cp == MaxSector) {
 		mddev->recovery_cp = mddev->size << 1;
 		set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
 	}
-	mddev->size = sectors /2;
+	mddev->size = sectors / 2;
 	mddev->resync_max_sectors = sectors;
 	return 0;
 }
@@ -3896,8 +3899,8 @@ static int raid5_check_reshape(mddev_t *mddev)
 	 */
 	if ((mddev->chunk_size / STRIPE_SIZE) * 4 > conf->max_nr_stripes ||
 	    (mddev->new_chunk / STRIPE_SIZE) * 4 > conf->max_nr_stripes) {
-		printk(KERN_WARNING "raid5: reshape: not enough stripes.  Needed %lu\n",
-		       (mddev->chunk_size / STRIPE_SIZE)*4);
+		printk(KERN_WARNING "raid5: reshape: not enough stripes.  "
+			"Needed %lu\n", (mddev->chunk_size / STRIPE_SIZE) * 4);
 		return -ENOSPC;
 	}
 
@@ -3980,7 +3983,8 @@ static int raid5_start_reshape(mddev_t *mddev)
 	if (!mddev->sync_thread) {
 		mddev->recovery = 0;
 		spin_lock_irq(&conf->device_lock);
-		mddev->raid_disks = conf->raid_disks = conf->previous_raid_disks;
+		mddev->raid_disks = conf->raid_disks =
+			conf->previous_raid_disks;
 		conf->expand_progress = MaxSector;
 		spin_unlock_irq(&conf->device_lock);
 		return -EAGAIN;
@@ -3998,13 +4002,15 @@ static void end_reshape(raid5_conf_t *conf)
 	if (!test_bit(MD_RECOVERY_INTR, &conf->mddev->recovery)) {
 		conf->mddev->array_size = conf->mddev->size *
 			(conf->raid_disks - conf->max_degraded);
-		set_capacity(conf->mddev->gendisk, conf->mddev->array_size << 1);
+		set_capacity(conf->mddev->gendisk,
+			conf->mddev->array_size << 1);
 		conf->mddev->changed = 1;
 
 		bdev = bdget_disk(conf->mddev->gendisk, 0);
 		if (bdev) {
 			mutex_lock(&bdev->bd_inode->i_mutex);
-			i_size_write(bdev->bd_inode, (loff_t)conf->mddev->array_size << 10);
+			i_size_write(bdev->bd_inode,
+				(loff_t)conf->mddev->array_size << 10);
 			mutex_unlock(&bdev->bd_inode->i_mutex);
 			bdput(bdev);
 		}
@@ -4014,14 +4020,18 @@ static void end_reshape(raid5_conf_t *conf)
 		conf->mddev->reshape_position = MaxSector;
 
 		/* read-ahead size must cover two whole stripes, which is
-		 * 2 * (datadisks) * chunksize where 'n' is the number of raid devices
+		 * 2 * (datadisks) * chunksize where 'n' is the number of raid
+		 * devices
 		 */
 		{
-			int data_disks = conf->previous_raid_disks - conf->max_degraded;
+			int data_disks = conf->previous_raid_disks -
+						conf->max_degraded;
 			int stripe = data_disks *
 				(conf->mddev->chunk_size / PAGE_SIZE);
-			if (conf->mddev->queue->backing_dev_info.ra_pages < 2 * stripe)
-				conf->mddev->queue->backing_dev_info.ra_pages = 2 * stripe;
+			if (conf->mddev->queue->backing_dev_info.ra_pages <
+				2 * stripe)
+				conf->mddev->queue->backing_dev_info.ra_pages =
+					2 * stripe;
 		}
 	}
 }
@@ -4039,8 +4049,8 @@ static void raid5_quiesce(mddev_t *mddev, int state)
 		spin_lock_irq(&conf->device_lock);
 		conf->quiesce = 1;
 		wait_event_lock_irq(conf->wait_for_stripe,
-				    atomic_read(&conf->active_stripes) == 0 &&
-				    atomic_read(&conf->active_aligned_reads) == 0,
+			atomic_read(&conf->active_stripes) == 0 &&
+			atomic_read(&conf->active_aligned_reads) == 0,
 				    conf->device_lock, /* nothing */);
 		spin_unlock_irq(&conf->device_lock);
 		break;
diff --git a/include/linux/raid/raid5.h b/include/linux/raid/raid5.h
index d8286db..3514a3c 100644
--- a/include/linux/raid/raid5.h
+++ b/include/linux/raid/raid5.h
@@ -27,13 +27,15 @@
  * The possible state transitions are:
  *
  *  Empty -> Want   - on read or write to get old data for  parity calc
- *  Empty -> Dirty  - on compute_parity to satisfy write/sync request.(RECONSTRUCT_WRITE)
+ *  Empty -> Dirty  - on compute_parity to satisfy write/sync request.
+ *		 	(RECONSTRUCT_WRITE)
  *  Empty -> Clean  - on compute_block when computing a block for failed drive
  *  Want  -> Empty  - on failed read
  *  Want  -> Clean  - on successful completion of read request
  *  Dirty -> Clean  - on successful completion of write request
  *  Dirty -> Clean  - on failed write
- *  Clean -> Dirty  - on compute_parity to satisfy write/sync (RECONSTRUCT or RMW)
+ *  Clean -> Dirty  - on compute_parity to satisfy write/sync
+ *			(RECONSTRUCT or RMW)
  *
  * The Want->Empty, Want->Clean, Dirty->Clean, transitions
  * all happen in b_end_io at interrupt time.
@@ -116,35 +118,72 @@
  *  attach a request to an active stripe (add_stripe_bh())
  *     lockdev attach-buffer unlockdev
  *  handle a stripe (handle_stripe())
- *     lockstripe clrSTRIPE_HANDLE ... (lockdev check-buffers unlockdev) .. change-state .. record io needed unlockstripe schedule io
+ *     lockstripe clrSTRIPE_HANDLE ...
+ *		(lockdev check-buffers unlockdev) ..
+ * 		change-state ..
+ *		record io needed unlockstripe schedule io
  *  release an active stripe (release_stripe())
- *     lockdev if (!--cnt) { if  STRIPE_HANDLE, add to handle_list else add to inactive-list } unlockdev
+ *     lockdev if (!--cnt) {
+ *		if  STRIPE_HANDLE,
+ *			add to handle_list
+ *		else
+ *			add to inactive-list
+ *		}
+ *	unlockdev
  *
  * The refcount counts each thread that have activated the stripe,
  * plus raid5d if it is handling it, plus one for each active request
  * on a cached buffer.
  */
 
+/* stripe_head
+ * @lru - inactive_list or handle_list
+ * @pd_idx - parity disk index
+ * @state - state flags
+ * @count - nr of active thread/requests
+ * @bm_seq - sequence number for bitmap flushes
+ * @lock - taken to examining/manipulating the stripe state
+ * @disks - disks in stripe
+ */
 struct stripe_head {
-	struct hlist_node	hash;
-	struct list_head	lru;			/* inactive_list or handle_list */
+	struct hlist_node		hash;
+	struct list_head		lru;
 	struct raid5_private_data	*raid_conf;
-	sector_t		sector;			/* sector of this row */
-	int			pd_idx;			/* parity disk index */
-	unsigned long		state;			/* state flags */
-	atomic_t		count;			/* nr of active thread/requests */
-	spinlock_t		lock;
-	int			bm_seq;	/* sequence number for bitmap flushes */
-	int			disks;			/* disks in stripe */
+	sector_t			sector;
+	int				pd_idx;
+	unsigned long			state;
+	atomic_t			count;
+	spinlock_t			lock; /* serializes handle_stripe */
+	int				bm_seq;
+	int				disks;
+	/* r5dev
+	 * @sector - disk sector of this page
+	 */
 	struct r5dev {
-		struct bio	req;
-		struct bio_vec	vec;
-		struct page	*page;
-		struct bio	*toread, *towrite, *written;
-		sector_t	sector;			/* sector of this page */
-		unsigned long	flags;
+		struct bio		req;
+		struct bio_vec		vec;
+		struct page		*page;
+		struct bio		*toread, *towrite, *written;
+		sector_t		sector;
+		unsigned long		flags;
 	} dev[1]; /* allocated with extra space depending of RAID geometry */
 };
+
+/* stripe_head_state - collects and tracks the dynamic state of a stripe_head
+ *	for handle_stripe.  It is only valid under spin_lock(sh->lock);
+ */
+struct stripe_head_state {
+	int syncing, expanding, expanded;
+	int locked, uptodate, to_read, to_write, failed, written;
+	int to_fill, compute, non_overwrite, dirty;
+	int failed_num;
+};
+
+/* r6_state - extra state data only relevant to r6 */
+struct r6_state {
+	int p_failed, q_failed, qd_idx, failed_num[2];
+};
+
 /* Flags */
 #define	R5_UPTODATE	0	/* page contains current data */
 #define	R5_LOCKED	1	/* IO has been submitted on "req" */
@@ -153,32 +192,39 @@ struct stripe_head {
 #define	R5_Insync	3	/* rdev && rdev->in_sync at start */
 #define	R5_Wantread	4	/* want to schedule a read */
 #define	R5_Wantwrite	5
-#define	R5_Overlap	7	/* There is a pending overlapping request on this block */
+#define	R5_Overlap	7	/* There is a pending overlapping request
+					 * on this block */
 #define	R5_ReadError	8	/* seen a read error here recently */
-#define	R5_ReWrite	9	/* have tried to over-write the readerror */
-
+#define	R5_ReWrite	9	/* have tried to over-write the readerror
+					 */
 #define	R5_Expanded	10	/* This block now has post-expand data */
+
 /*
  * Write method
  */
 #define RECONSTRUCT_WRITE	1
 #define READ_MODIFY_WRITE	2
 /* not a write method, but a compute_parity mode */
-#define	CHECK_PARITY		3
+#define CHECK_PARITY		3
 
 /*
  * Stripe state
  */
 #define STRIPE_HANDLE		2
-#define	STRIPE_SYNCING		3
-#define	STRIPE_INSYNC		4
-#define	STRIPE_PREREAD_ACTIVE	5
-#define	STRIPE_DELAYED		6
-#define	STRIPE_DEGRADED		7
-#define	STRIPE_BIT_DELAY	8
-#define	STRIPE_EXPANDING	9
-#define	STRIPE_EXPAND_SOURCE	10
-#define	STRIPE_EXPAND_READY	11
+#define STRIPE_SYNCING		3
+#define STRIPE_INSYNC		4
+#define STRIPE_PREREAD_ACTIVE	5
+#define STRIPE_DELAYED		6
+#define STRIPE_DEGRADED	7
+#define STRIPE_BIT_DELAY	8
+#define STRIPE_EXPANDING	9
+#define STRIPE_EXPAND_SOURCE	10
+#define STRIPE_EXPAND_READY	11
+
+struct disk_info {
+	mdk_rdev_t	*rdev;
+};
+
 /*
  * Plugging:
  *
@@ -199,15 +245,29 @@ struct stripe_head {
  * move any strips from delayed to handle and clear the DELAYED flag and set
  * PREREAD_ACTIVE.
  * In stripe_handle, if we find pre-reading is necessary, we do it if
- * PREREAD_ACTIVE is set, else we set DELAYED which will send it to the delayed queue.
- * HANDLE gets cleared if stripe_handle leave nothing locked.
+ * PREREAD_ACTIVE is set, else we set DELAYED which will send it to the delayed
+ * queue.  HANDLE gets cleared if stripe_handle leave nothing locked.
  */
- 
-
-struct disk_info {
-	mdk_rdev_t	*rdev;
-};
 
+/* raid5_private_data
+ * @expand_progress - MaxSector when no expand happening
+ * @expand_lo - from here up to expand_progress it out-of-bounds as we haven't
+ *	flushed the metadata yet
+ * @handle_list - stripes needing handling
+ * @delayed_list - stripes that have plugged requests
+ * @bitmap_list - stripes delaying awaiting bitmap update
+ * @retry_read_aligned - currently retrying aligned bios
+ * @retry_read_aligned_list - aligned bios retry list
+ * @preread_active_stripes - stripes with scheduled io
+ * @reshape_stripes - stripes with pending writes for reshape
+ * @slab_cache - for allocating stripes
+ * @full_sync - set to 1 if a full sync is needed, (fresh device added).
+ *	Cleared when a sync completes.
+ * @spare_page - Used when checking P/Q in raid6
+ * @inactive_blocked - release of inactive stripes blocked, waiting for 25% to
+ *	be free
+ * @pool_size - number of disks in stripeheads in pool
+ */
 struct raid5_private_data {
 	struct hlist_head	*stripe_hashtbl;
 	mddev_t			*mddev;
@@ -218,37 +278,33 @@ struct raid5_private_data {
 	int			max_nr_stripes;
 
 	/* used during an expand */
-	sector_t		expand_progress;	/* MaxSector when no expand happening */
-	sector_t		expand_lo; /* from here up to expand_progress it out-of-bounds
-					    * as we haven't flushed the metadata yet
-					    */
+	sector_t		expand_progress;
+	sector_t		expand_lo;
 	int			previous_raid_disks;
 
-	struct list_head	handle_list; /* stripes needing handling */
-	struct list_head	delayed_list; /* stripes that have plugged requests */
-	struct list_head	bitmap_list; /* stripes delaying awaiting bitmap update */
-	struct bio		*retry_read_aligned; /* currently retrying aligned bios   */
-	struct bio		*retry_read_aligned_list; /* aligned bios retry list  */
-	atomic_t		preread_active_stripes; /* stripes with scheduled io */
+	struct list_head	handle_list;
+	struct list_head	delayed_list;
+	struct list_head	bitmap_list;
+	struct bio		*retry_read_aligned;
+	struct bio		*retry_read_aligned_list;
+	atomic_t		preread_active_stripes;
 	atomic_t		active_aligned_reads;
 
-	atomic_t		reshape_stripes; /* stripes with pending writes for reshape */
+	atomic_t		reshape_stripes;
+
 	/* unfortunately we need two cache names as we temporarily have
 	 * two caches.
 	 */
 	int			active_name;
 	char			cache_name[2][20];
-	struct kmem_cache		*slab_cache; /* for allocating stripes */
+	struct kmem_cache	*slab_cache;
 
 	int			seq_flush, seq_write;
 	int			quiesce;
 
-	int			fullsync;  /* set to 1 if a full sync is needed,
-					    * (fresh device added).
-					    * Cleared when a sync completes.
-					    */
+	int			fullsync;
 
-	struct page 		*spare_page; /* Used when checking P/Q in raid6 */
+	struct page 		*spare_page;
 
 	/*
 	 * Free stripes pool
@@ -257,10 +313,8 @@ struct raid5_private_data {
 	struct list_head	inactive_list;
 	wait_queue_head_t	wait_for_stripe;
 	wait_queue_head_t	wait_for_overlap;
-	int			inactive_blocked;	/* release of inactive stripes blocked,
-							 * waiting for 25% to be free
-							 */
-	int			pool_size; /* number of disks in stripeheads in pool */
+	int			inactive_blocked;
+	int			pool_size;
 	spinlock_t		device_lock;
 	struct disk_info	*disks;
 };
