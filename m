From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH md 6 of 6] Fix handling of overlapping requests in raid5
Date: Mon, 07 Feb 2005 13:44:19 +1100
Message-ID: <E1Cxyst-0004fu-PP@notabene.cse.unsw.edu.au>
References: <20050207133555.17870.patches@notabene>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


If we detect an overlap, we set a flag and wait for a wakeup.
When requests are handled, if the flag was set, we perform the
wakeup.

Note that the code currently in -mm is badly broken.  With this
patch applied, it passes tests the use O_DIRECT to cause lots
of overlapping requests.

Signed-off-by: Neil Brown <neilb@cse.unsw.edu.au>

### Diffstat output
 ./drivers/md/raid5.c         |   52 ++++++++++++++++++++++++++++++++---------
 ./drivers/md/raid6main.c     |   54 +++++++++++++++++++++++++++++++++++--------
 ./include/linux/raid/raid5.h |    2 +
 3 files changed, 87 insertions(+), 21 deletions(-)

diff ./drivers/md/raid5.c~current~ ./drivers/md/raid5.c
--- ./drivers/md/raid5.c~current~	2005-02-07 13:34:09.000000000 +1100
+++ ./drivers/md/raid5.c	2005-02-07 13:34:23.000000000 +1100
@@ -49,7 +49,7 @@
  * This macro is used to determine the 'next' bio in the list, given the sector
  * of the current stripe+device
  */
-#define r5_next_bio(bio, sect) ( ( bio->bi_sector + (bio->bi_size>>9) < sect + STRIPE_SECTORS) ? bio->bi_next : NULL)
+#define r5_next_bio(bio, sect) ( ( (bio)->bi_sector + ((bio)->bi_size>>9) < sect + STRIPE_SECTORS) ? (bio)->bi_next : NULL)
 /*
  * The following can be used to debug the driver
  */
@@ -722,6 +722,10 @@ static void compute_parity(struct stripe
 				ptr[count++] = page_address(sh->dev[i].page);
 				chosen = sh->dev[i].towrite;
 				sh->dev[i].towrite = NULL;
+
+				if (test_and_clear_bit(R5_Overlap, &sh->dev[i].flags))
+					wake_up(&conf->wait_for_overlap);
+
 				if (sh->dev[i].written) BUG();
 				sh->dev[i].written = chosen;
 				check_xor();
@@ -734,6 +738,10 @@ static void compute_parity(struct stripe
 			if (i!=pd_idx && sh->dev[i].towrite) {
 				chosen = sh->dev[i].towrite;
 				sh->dev[i].towrite = NULL;
+
+				if (test_and_clear_bit(R5_Overlap, &sh->dev[i].flags))
+					wake_up(&conf->wait_for_overlap);
+
 				if (sh->dev[i].written) BUG();
 				sh->dev[i].written = chosen;
 			}
@@ -790,7 +798,7 @@ static void compute_parity(struct stripe
  * toread/towrite point to the first in a chain. 
  * The bi_next chain must be in order.
  */
-static int add_stripe_bio (struct stripe_head *sh, struct bio *bi, int dd_idx, int forwrite)
+static int add_stripe_bio(struct stripe_head *sh, struct bio *bi, int dd_idx, int forwrite)
 {
 	struct bio **bip;
 	raid5_conf_t *conf = sh->raid_conf;
@@ -808,9 +816,12 @@ static int add_stripe_bio (struct stripe
 		bip = &sh->dev[dd_idx].toread;
 	while (*bip && (*bip)->bi_sector < bi->bi_sector) {
 		if ((*bip)->bi_sector + ((*bip)->bi_size >> 9) > bi->bi_sector)
-			return 0; /* cannot add just now due to overlap */
+			goto overlap;
 		bip = & (*bip)->bi_next;
 	}
+	if (*bip && (*bip)->bi_sector < bi->bi_sector + ((bi->bi_size)>>9)) 
+		goto overlap;
+
 	if (*bip && bi->bi_next && (*bip) != bi->bi_next)
 		BUG();
 	if (*bip)
@@ -825,7 +836,7 @@ static int add_stripe_bio (struct stripe
 		(unsigned long long)sh->sector, dd_idx);
 
 	if (forwrite) {
-		/* check if page is coverred */
+		/* check if page is covered */
 		sector_t sector = sh->dev[dd_idx].sector;
 		for (bi=sh->dev[dd_idx].towrite;
 		     sector < sh->dev[dd_idx].sector + STRIPE_SECTORS &&
@@ -838,6 +849,12 @@ static int add_stripe_bio (struct stripe
 			set_bit(R5_OVERWRITE, &sh->dev[dd_idx].flags);
 	}
 	return 1;
+
+ overlap:
+	set_bit(R5_Overlap, &sh->dev[dd_idx].flags);
+	spin_unlock_irq(&conf->device_lock);
+	spin_unlock(&sh->lock);
+	return 0;
 }
 
 
@@ -898,6 +915,8 @@ static void handle_stripe(struct stripe_
 			spin_lock_irq(&conf->device_lock);
 			rbi = dev->toread;
 			dev->toread = NULL;
+			if (test_and_clear_bit(R5_Overlap, &dev->flags))
+				wake_up(&conf->wait_for_overlap);
 			spin_unlock_irq(&conf->device_lock);
 			while (rbi && rbi->bi_sector < dev->sector + STRIPE_SECTORS) {
 				copy_data(0, rbi, dev->page, dev->sector);
@@ -945,6 +964,9 @@ static void handle_stripe(struct stripe_
 			sh->dev[i].towrite = NULL;
 			if (bi) to_write--;
 
+			if (test_and_clear_bit(R5_Overlap, &sh->dev[i].flags))
+				wake_up(&conf->wait_for_overlap);
+
 			while (bi && bi->bi_sector < sh->dev[i].sector + STRIPE_SECTORS){
 				struct bio *nextbi = r5_next_bio(bi, sh->dev[i].sector);
 				clear_bit(BIO_UPTODATE, &bi->bi_flags);
@@ -973,6 +995,8 @@ static void handle_stripe(struct stripe_
 			if (!test_bit(R5_Insync, &sh->dev[i].flags)) {
 				bi = sh->dev[i].toread;
 				sh->dev[i].toread = NULL;
+				if (test_and_clear_bit(R5_Overlap, &sh->dev[i].flags))
+					wake_up(&conf->wait_for_overlap);
 				if (bi) to_read--;
 				while (bi && bi->bi_sector < sh->dev[i].sector + STRIPE_SECTORS){
 					struct bio *nextbi = r5_next_bio(bi, sh->dev[i].sector);
@@ -1400,6 +1424,7 @@ static int make_request (request_queue_t
 	if ( bio_data_dir(bi) == WRITE )
 		md_write_start(mddev);
 	for (;logical_sector < last_sector; logical_sector += STRIPE_SECTORS) {
+		DEFINE_WAIT(w);
 		
 		new_sector = raid5_compute_sector(logical_sector,
 						  raid_disks, data_disks, &dd_idx, &pd_idx, conf);
@@ -1408,25 +1433,29 @@ static int make_request (request_queue_t
 			(unsigned long long)new_sector, 
 			(unsigned long long)logical_sector);
 
+		prepare_to_wait(&conf->wait_for_overlap, &w, TASK_UNINTERRUPTIBLE);
+
+	retry:
 		sh = get_active_stripe(conf, new_sector, pd_idx, (bi->bi_rw&RWA_MASK));
 		if (sh) {
-
-			while (!add_stripe_bio(sh, bi, dd_idx, (bi->bi_rw&RW_MASK))) {
-				/* add failed due to overlap.  Flush everything
+			if (!add_stripe_bio(sh, bi, dd_idx, (bi->bi_rw&RW_MASK))) {
+				/* Add failed due to overlap.  Flush everything
 				 * and wait a while
-				 * FIXME - overlapping requests should be handled better
 				 */
 				raid5_unplug_device(mddev->queue);
-				set_current_state(TASK_UNINTERRUPTIBLE);
-				schedule_timeout(1);
+				release_stripe(sh);
+				schedule();
+				goto retry;
 			}
-
+			finish_wait(&conf->wait_for_overlap, &w);
 			raid5_plug_device(conf);
 			handle_stripe(sh);
 			release_stripe(sh);
+			
 		} else {
 			/* cannot get stripe for read-ahead, just give-up */
 			clear_bit(BIO_UPTODATE, &bi->bi_flags);
+			finish_wait(&conf->wait_for_overlap, &w);
 			break;
 		}
 			
@@ -1574,6 +1603,7 @@ static int run (mddev_t *mddev)
 
 	spin_lock_init(&conf->device_lock);
 	init_waitqueue_head(&conf->wait_for_stripe);
+	init_waitqueue_head(&conf->wait_for_overlap);
 	INIT_LIST_HEAD(&conf->handle_list);
 	INIT_LIST_HEAD(&conf->delayed_list);
 	INIT_LIST_HEAD(&conf->inactive_list);

diff ./drivers/md/raid6main.c~current~ ./drivers/md/raid6main.c
--- ./drivers/md/raid6main.c~current~	2005-02-07 13:34:09.000000000 +1100
+++ ./drivers/md/raid6main.c	2005-02-07 13:34:23.000000000 +1100
@@ -54,7 +54,7 @@
  * This macro is used to determine the 'next' bio in the list, given the sector
  * of the current stripe+device
  */
-#define r5_next_bio(bio, sect) ( ( bio->bi_sector + (bio->bi_size>>9) < sect + STRIPE_SECTORS) ? bio->bi_next : NULL)
+#define r5_next_bio(bio, sect) ( ( (bio)->bi_sector + ((bio)->bi_size>>9) < sect + STRIPE_SECTORS) ? (bio)->bi_next : NULL)
 /*
  * The following can be used to debug the driver
  */
@@ -690,7 +690,7 @@ static void copy_data(int frombio, struc
 		if (len > 0 && page_offset + len > STRIPE_SIZE)
 			clen = STRIPE_SIZE - page_offset;	
 		else clen = len;
-			
+		
 		if (clen > 0) {
 			char *ba = __bio_kmap_atomic(bio, i, KM_USER0);
 			if (frombio)
@@ -735,6 +735,10 @@ static void compute_parity(struct stripe
 			if ( i != pd_idx && i != qd_idx && sh->dev[i].towrite ) {
 				chosen = sh->dev[i].towrite;
 				sh->dev[i].towrite = NULL;
+
+				if (test_and_clear_bit(R5_Overlap, &sh->dev[i].flags))
+					wake_up(&conf->wait_for_overlap);
+
 				if (sh->dev[i].written) BUG();
 				sh->dev[i].written = chosen;
 			}
@@ -897,7 +901,7 @@ static void compute_block_2(struct strip
  * toread/towrite point to the first in a chain.
  * The bi_next chain must be in order.
  */
-static void add_stripe_bio (struct stripe_head *sh, struct bio *bi, int dd_idx, int forwrite)
+static int add_stripe_bio(struct stripe_head *sh, struct bio *bi, int dd_idx, int forwrite)
 {
 	struct bio **bip;
 	raid6_conf_t *conf = sh->raid_conf;
@@ -914,10 +918,13 @@ static void add_stripe_bio (struct strip
 	else
 		bip = &sh->dev[dd_idx].toread;
 	while (*bip && (*bip)->bi_sector < bi->bi_sector) {
-		BUG_ON((*bip)->bi_sector + ((*bip)->bi_size >> 9) > bi->bi_sector);
-		bip = & (*bip)->bi_next;
+		if ((*bip)->bi_sector + ((*bip)->bi_size >> 9) > bi->bi_sector)
+			goto overlap;
+		bip = &(*bip)->bi_next;
 	}
-/* FIXME do I need to worry about overlapping bion */
+	if (*bip && (*bip)->bi_sector < bi->bi_sector + ((bi->bi_size)>>9)) 
+		goto overlap;
+
 	if (*bip && bi->bi_next && (*bip) != bi->bi_next)
 		BUG();
 	if (*bip)
@@ -932,7 +939,7 @@ static void add_stripe_bio (struct strip
 		(unsigned long long)sh->sector, dd_idx);
 
 	if (forwrite) {
-		/* check if page is coverred */
+		/* check if page is covered */
 		sector_t sector = sh->dev[dd_idx].sector;
 		for (bi=sh->dev[dd_idx].towrite;
 		     sector < sh->dev[dd_idx].sector + STRIPE_SECTORS &&
@@ -944,6 +951,13 @@ static void add_stripe_bio (struct strip
 		if (sector >= sh->dev[dd_idx].sector + STRIPE_SECTORS)
 			set_bit(R5_OVERWRITE, &sh->dev[dd_idx].flags);
 	}
+	return 1;
+
+ overlap:
+	set_bit(R5_Overlap, &sh->dev[dd_idx].flags);
+	spin_unlock_irq(&conf->device_lock);
+	spin_unlock(&sh->lock);
+	return 0;
 }
 
 
@@ -1007,6 +1021,8 @@ static void handle_stripe(struct stripe_
 			spin_lock_irq(&conf->device_lock);
 			rbi = dev->toread;
 			dev->toread = NULL;
+			if (test_and_clear_bit(R5_Overlap, &dev->flags))
+				wake_up(&conf->wait_for_overlap);
 			spin_unlock_irq(&conf->device_lock);
 			while (rbi && rbi->bi_sector < dev->sector + STRIPE_SECTORS) {
 				copy_data(0, rbi, dev->page, dev->sector);
@@ -1056,6 +1072,9 @@ static void handle_stripe(struct stripe_
 			sh->dev[i].towrite = NULL;
 			if (bi) to_write--;
 
+			if (test_and_clear_bit(R5_Overlap, &sh->dev[i].flags))
+				wake_up(&conf->wait_for_overlap);
+
 			while (bi && bi->bi_sector < sh->dev[i].sector + STRIPE_SECTORS){
 				struct bio *nextbi = r5_next_bio(bi, sh->dev[i].sector);
 				clear_bit(BIO_UPTODATE, &bi->bi_flags);
@@ -1084,6 +1103,8 @@ static void handle_stripe(struct stripe_
 			if (!test_bit(R5_Insync, &sh->dev[i].flags)) {
 				bi = sh->dev[i].toread;
 				sh->dev[i].toread = NULL;
+				if (test_and_clear_bit(R5_Overlap, &sh->dev[i].flags))
+					wake_up(&conf->wait_for_overlap);
 				if (bi) to_read--;
 				while (bi && bi->bi_sector < sh->dev[i].sector + STRIPE_SECTORS){
 					struct bio *nextbi = r5_next_bio(bi, sh->dev[i].sector);
@@ -1563,6 +1584,7 @@ static int make_request (request_queue_t
 	if ( bio_data_dir(bi) == WRITE )
 		md_write_start(mddev);
 	for (;logical_sector < last_sector; logical_sector += STRIPE_SECTORS) {
+		DEFINE_WAIT(w);
 
 		new_sector = raid6_compute_sector(logical_sector,
 						  raid_disks, data_disks, &dd_idx, &pd_idx, conf);
@@ -1571,17 +1593,28 @@ static int make_request (request_queue_t
 		       (unsigned long long)new_sector,
 		       (unsigned long long)logical_sector);
 
+		prepare_to_wait(&conf->wait_for_overlap, &w, TASK_UNINTERRUPTIBLE);
+
+	retry:
 		sh = get_active_stripe(conf, new_sector, pd_idx, (bi->bi_rw&RWA_MASK));
 		if (sh) {
-
-			add_stripe_bio(sh, bi, dd_idx, (bi->bi_rw&RW_MASK));
-
+			if (!add_stripe_bio(sh, bi, dd_idx, (bi->bi_rw&RW_MASK))) {
+				/* Add failed due to overlap.  Flush everything
+				 * and wait a while
+				 */
+				raid6_unplug_device(mddev->queue);
+				release_stripe(sh);
+				schedule();
+				goto retry;
+			}
+			finish_wait(&conf->wait_for_overlap, &w);
 			raid6_plug_device(conf);
 			handle_stripe(sh);
 			release_stripe(sh);
 		} else {
 			/* cannot get stripe for read-ahead, just give-up */
 			clear_bit(BIO_UPTODATE, &bi->bi_flags);
+			finish_wait(&conf->wait_for_overlap, &w);
 			break;
 		}
 
@@ -1729,6 +1762,7 @@ static int run (mddev_t *mddev)
 
 	spin_lock_init(&conf->device_lock);
 	init_waitqueue_head(&conf->wait_for_stripe);
+	init_waitqueue_head(&conf->wait_for_overlap);
 	INIT_LIST_HEAD(&conf->handle_list);
 	INIT_LIST_HEAD(&conf->delayed_list);
 	INIT_LIST_HEAD(&conf->inactive_list);

diff ./include/linux/raid/raid5.h~current~ ./include/linux/raid/raid5.h
--- ./include/linux/raid/raid5.h~current~	2005-02-07 13:31:05.000000000 +1100
+++ ./include/linux/raid/raid5.h	2005-02-07 13:34:23.000000000 +1100
@@ -152,6 +152,7 @@ struct stripe_head {
 #define	R5_Wantread	4	/* want to schedule a read */
 #define	R5_Wantwrite	5
 #define	R5_Syncio	6	/* this io need to be accounted as resync io */
+#define	R5_Overlap	7	/* There is a pending overlapping request on this block */
 
 /*
  * Write method
@@ -219,6 +220,7 @@ struct raid5_private_data {
 	atomic_t		active_stripes;
 	struct list_head	inactive_list;
 	wait_queue_head_t	wait_for_stripe;
+	wait_queue_head_t	wait_for_overlap;
 	int			inactive_blocked;	/* release of inactive stripes blocked,
 							 * waiting for 25% to be free
 							 */        
