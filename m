From: Dan Williams <dan.j.williams@intel.com>
Subject: [md-accel PATCH 06/19] raid5: replace custom debug PRINTKs with
	standard pr_debug
Date: Tue, 26 Jun 2007 18:51:05 -0700
Message-ID: <20070627015105.18962.87896.stgit@dwillia2-linux.ch.intel.com>
References: <20070627014823.18962.96398.stgit@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20070627014823.18962.96398.stgit@dwillia2-linux.ch.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
Cc: neilb@suse.de, akpm@linux-foundation.org, davem@davemloft.net, christopher.leech@intel.com, shannon.nelson@intel.com, herbert@gondor.apana.org.au, jeff@garzik.org
List-Id: linux-raid.ids

Replaces PRINTK with pr_debug, and kills the RAID5_DEBUG definition in
favor of the global DEBUG definition.  To get local debug messages just add
'#define DEBUG' to the top of the file.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---

 drivers/md/raid5.c |  116 ++++++++++++++++++++++++++--------------------------
 1 files changed, 58 insertions(+), 58 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 94e0920..d21fa7a 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -80,7 +80,6 @@
 /*
  * The following can be used to debug the driver
  */
-#define RAID5_DEBUG	0
 #define RAID5_PARANOIA	1
 #if RAID5_PARANOIA && defined(CONFIG_SMP)
 # define CHECK_DEVLOCK() assert_spin_locked(&conf->device_lock)
@@ -88,8 +87,7 @@
 # define CHECK_DEVLOCK()
 #endif
 
-#define PRINTK(x...) ((void)(RAID5_DEBUG && printk(x)))
-#if RAID5_DEBUG
+#ifdef DEBUG
 #define inline
 #define __inline__
 #endif
@@ -152,7 +150,8 @@ static void release_stripe(struct stripe_head *sh)
 
 static inline void remove_hash(struct stripe_head *sh)
 {
-	PRINTK("remove_hash(), stripe %llu\n", (unsigned long long)sh->sector);
+	pr_debug("remove_hash(), stripe %llu\n",
+		(unsigned long long)sh->sector);
 
 	hlist_del_init(&sh->hash);
 }
@@ -161,7 +160,8 @@ static inline void insert_hash(raid5_conf_t *conf, struct stripe_head *sh)
 {
 	struct hlist_head *hp = stripe_hash(conf, sh->sector);
 
-	PRINTK("insert_hash(), stripe %llu\n", (unsigned long long)sh->sector);
+	pr_debug("insert_hash(), stripe %llu\n",
+		(unsigned long long)sh->sector);
 
 	CHECK_DEVLOCK();
 	hlist_add_head(&sh->hash, hp);
@@ -226,7 +226,7 @@ static void init_stripe(struct stripe_head *sh, sector_t sector, int pd_idx, int
 	BUG_ON(test_bit(STRIPE_HANDLE, &sh->state));
 	
 	CHECK_DEVLOCK();
-	PRINTK("init_stripe called, stripe %llu\n", 
+	pr_debug("init_stripe called, stripe %llu\n",
 		(unsigned long long)sh->sector);
 
 	remove_hash(sh);
@@ -260,11 +260,11 @@ static struct stripe_head *__find_stripe(raid5_conf_t *conf, sector_t sector, in
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
 
@@ -276,7 +276,7 @@ static struct stripe_head *get_active_stripe(raid5_conf_t *conf, sector_t sector
 {
 	struct stripe_head *sh;
 
-	PRINTK("get_stripe, sector %llu\n", (unsigned long long)sector);
+	pr_debug("get_stripe, sector %llu\n", (unsigned long long)sector);
 
 	spin_lock_irq(&conf->device_lock);
 
@@ -537,8 +537,8 @@ static int raid5_end_read_request(struct bio * bi, unsigned int bytes_done,
 		if (bi == &sh->dev[i].req)
 			break;
 
-	PRINTK("end_read_request %llu/%d, count: %d, uptodate %d.\n", 
-		(unsigned long long)sh->sector, i, atomic_read(&sh->count), 
+	pr_debug("end_read_request %llu/%d, count: %d, uptodate %d.\n",
+		(unsigned long long)sh->sector, i, atomic_read(&sh->count),
 		uptodate);
 	if (i == disks) {
 		BUG();
@@ -613,7 +613,7 @@ static int raid5_end_write_request (struct bio *bi, unsigned int bytes_done,
 		if (bi == &sh->dev[i].req)
 			break;
 
-	PRINTK("end_write_request %llu/%d, count %d, uptodate: %d.\n", 
+	pr_debug("end_write_request %llu/%d, count %d, uptodate: %d.\n",
 		(unsigned long long)sh->sector, i, atomic_read(&sh->count),
 		uptodate);
 	if (i == disks) {
@@ -658,7 +658,7 @@ static void error(mddev_t *mddev, mdk_rdev_t *rdev)
 {
 	char b[BDEVNAME_SIZE];
 	raid5_conf_t *conf = (raid5_conf_t *) mddev->private;
-	PRINTK("raid5: error called\n");
+	pr_debug("raid5: error called\n");
 
 	if (!test_bit(Faulty, &rdev->flags)) {
 		set_bit(MD_CHANGE_DEVS, &mddev->flags);
@@ -929,7 +929,7 @@ static void compute_block(struct stripe_head *sh, int dd_idx)
 	int i, count, disks = sh->disks;
 	void *ptr[MAX_XOR_BLOCKS], *dest, *p;
 
-	PRINTK("compute_block, stripe %llu, idx %d\n", 
+	pr_debug("compute_block, stripe %llu, idx %d\n",
 		(unsigned long long)sh->sector, dd_idx);
 
 	dest = page_address(sh->dev[dd_idx].page);
@@ -960,7 +960,7 @@ static void compute_parity5(struct stripe_head *sh, int method)
 	void *ptr[MAX_XOR_BLOCKS], *dest;
 	struct bio *chosen;
 
-	PRINTK("compute_parity5, stripe %llu, method %d\n",
+	pr_debug("compute_parity5, stripe %llu, method %d\n",
 		(unsigned long long)sh->sector, method);
 
 	count = 0;
@@ -1058,7 +1058,7 @@ static void compute_parity6(struct stripe_head *sh, int method)
 	qd_idx = raid6_next_disk(pd_idx, disks);
 	d0_idx = raid6_next_disk(qd_idx, disks);
 
-	PRINTK("compute_parity, stripe %llu, method %d\n",
+	pr_debug("compute_parity, stripe %llu, method %d\n",
 		(unsigned long long)sh->sector, method);
 
 	switch(method) {
@@ -1136,7 +1136,7 @@ static void compute_block_1(struct stripe_head *sh, int dd_idx, int nozero)
 	int pd_idx = sh->pd_idx;
 	int qd_idx = raid6_next_disk(pd_idx, disks);
 
-	PRINTK("compute_block_1, stripe %llu, idx %d\n",
+	pr_debug("compute_block_1, stripe %llu, idx %d\n",
 		(unsigned long long)sh->sector, dd_idx);
 
 	if ( dd_idx == qd_idx ) {
@@ -1183,7 +1183,7 @@ static void compute_block_2(struct stripe_head *sh, int dd_idx1, int dd_idx2)
 	BUG_ON(faila == failb);
 	if ( failb < faila ) { int tmp = faila; faila = failb; failb = tmp; }
 
-	PRINTK("compute_block_2, stripe %llu, idx %d,%d (%d,%d)\n",
+	pr_debug("compute_block_2, stripe %llu, idx %d,%d (%d,%d)\n",
 	       (unsigned long long)sh->sector, dd_idx1, dd_idx2, faila, failb);
 
 	if ( failb == disks-1 ) {
@@ -1242,7 +1242,7 @@ static int add_stripe_bio(struct stripe_head *sh, struct bio *bi, int dd_idx, in
 	raid5_conf_t *conf = sh->raid_conf;
 	int firstwrite=0;
 
-	PRINTK("adding bh b#%llu to stripe s#%llu\n",
+	pr_debug("adding bh b#%llu to stripe s#%llu\n",
 		(unsigned long long)bi->bi_sector,
 		(unsigned long long)sh->sector);
 
@@ -1271,7 +1271,7 @@ static int add_stripe_bio(struct stripe_head *sh, struct bio *bi, int dd_idx, in
 	spin_unlock_irq(&conf->device_lock);
 	spin_unlock(&sh->lock);
 
-	PRINTK("added bi b#%llu to stripe s#%llu, disk %d.\n",
+	pr_debug("added bi b#%llu to stripe s#%llu, disk %d.\n",
 		(unsigned long long)bi->bi_sector,
 		(unsigned long long)sh->sector, dd_idx);
 
@@ -1431,14 +1431,14 @@ static void handle_issuing_new_read_requests5(struct stripe_head *sh,
 			 * by computing it, but we might not be able to
 			 */
 			if (s->uptodate == disks-1) {
-				PRINTK("Computing block %d\n", i);
+				pr_debug("Computing block %d\n", i);
 				compute_block(sh, i);
 				s->uptodate++;
 			} else if (test_bit(R5_Insync, &dev->flags)) {
 				set_bit(R5_LOCKED, &dev->flags);
 				set_bit(R5_Wantread, &dev->flags);
 				s->locked++;
-				PRINTK("Reading block %d (sync=%d)\n",
+				pr_debug("Reading block %d (sync=%d)\n",
 					i, s->syncing);
 			}
 		}
@@ -1468,7 +1468,7 @@ static void handle_issuing_new_read_requests6(struct stripe_head *sh,
 			 * by computing it, but we might not be able to
 			 */
 			if (s->uptodate == disks-1) {
-				PRINTK("Computing stripe %llu block %d\n",
+				pr_debug("Computing stripe %llu block %d\n",
 				       (unsigned long long)sh->sector, i);
 				compute_block_1(sh, i, 0);
 				s->uptodate++;
@@ -1485,7 +1485,7 @@ static void handle_issuing_new_read_requests6(struct stripe_head *sh,
 						break;
 				}
 				BUG_ON(other < 0);
-				PRINTK("Computing stripe %llu blocks %d,%d\n",
+				pr_debug("Computing stripe %llu blocks %d,%d\n",
 				       (unsigned long long)sh->sector,
 				       i, other);
 				compute_block_2(sh, i, other);
@@ -1494,7 +1494,7 @@ static void handle_issuing_new_read_requests6(struct stripe_head *sh,
 				set_bit(R5_LOCKED, &dev->flags);
 				set_bit(R5_Wantread, &dev->flags);
 				s->locked++;
-				PRINTK("Reading block %d (sync=%d)\n",
+				pr_debug("Reading block %d (sync=%d)\n",
 					i, s->syncing);
 			}
 		}
@@ -1522,7 +1522,7 @@ static void handle_completed_write_requests(raid5_conf_t *conf,
 				/* We can return any write requests */
 				struct bio *wbi, *wbi2;
 				int bitmap_end = 0;
-				PRINTK("Return write for disc %d\n", i);
+				pr_debug("Return write for disc %d\n", i);
 				spin_lock_irq(&conf->device_lock);
 				wbi = dev->written;
 				dev->written = NULL;
@@ -1574,7 +1574,7 @@ static void handle_issuing_new_write_requests5(raid5_conf_t *conf,
 				rcw += 2*disks;
 		}
 	}
-	PRINTK("for sector %llu, rmw=%d rcw=%d\n",
+	pr_debug("for sector %llu, rmw=%d rcw=%d\n",
 		(unsigned long long)sh->sector, rmw, rcw);
 	set_bit(STRIPE_HANDLE, &sh->state);
 	if (rmw < rcw && rmw > 0)
@@ -1587,7 +1587,7 @@ static void handle_issuing_new_write_requests5(raid5_conf_t *conf,
 			    test_bit(R5_Insync, &dev->flags)) {
 				if (
 				  test_bit(STRIPE_PREREAD_ACTIVE, &sh->state)) {
-					PRINTK("Read_old block "
+					pr_debug("Read_old block "
 						"%d for r-m-w\n", i);
 					set_bit(R5_LOCKED, &dev->flags);
 					set_bit(R5_Wantread, &dev->flags);
@@ -1609,7 +1609,7 @@ static void handle_issuing_new_write_requests5(raid5_conf_t *conf,
 			    test_bit(R5_Insync, &dev->flags)) {
 				if (
 				  test_bit(STRIPE_PREREAD_ACTIVE, &sh->state)) {
-					PRINTK("Read_old block "
+					pr_debug("Read_old block "
 						"%d for Reconstruct\n", i);
 					set_bit(R5_LOCKED, &dev->flags);
 					set_bit(R5_Wantread, &dev->flags);
@@ -1625,13 +1625,13 @@ static void handle_issuing_new_write_requests5(raid5_conf_t *conf,
 	 */
 	if (s->locked == 0 && (rcw == 0 || rmw == 0) &&
 	    !test_bit(STRIPE_BIT_DELAY, &sh->state)) {
-		PRINTK("Computing parity...\n");
+		pr_debug("Computing parity...\n");
 		compute_parity5(sh, rcw == 0 ?
 			RECONSTRUCT_WRITE : READ_MODIFY_WRITE);
 		/* now every locked buffer is ready to be written */
 		for (i = disks; i--; )
 			if (test_bit(R5_LOCKED, &sh->dev[i].flags)) {
-				PRINTK("Writing block %d\n", i);
+				pr_debug("Writing block %d\n", i);
 				s->locked++;
 				set_bit(R5_Wantwrite, &sh->dev[i].flags);
 				if (!test_bit(R5_Insync, &sh->dev[i].flags)
@@ -1663,13 +1663,13 @@ static void handle_issuing_new_write_requests6(raid5_conf_t *conf,
 		    !test_bit(R5_UPTODATE, &dev->flags)) {
 			if (test_bit(R5_Insync, &dev->flags)) rcw++;
 			else {
-				PRINTK("raid6: must_compute: "
+				pr_debug("raid6: must_compute: "
 					"disk %d flags=%#lx\n", i, dev->flags);
 				must_compute++;
 			}
 		}
 	}
-	PRINTK("for sector %llu, rcw=%d, must_compute=%d\n",
+	pr_debug("for sector %llu, rcw=%d, must_compute=%d\n",
 	       (unsigned long long)sh->sector, rcw, must_compute);
 	set_bit(STRIPE_HANDLE, &sh->state);
 
@@ -1684,14 +1684,14 @@ static void handle_issuing_new_write_requests6(raid5_conf_t *conf,
 			    test_bit(R5_Insync, &dev->flags)) {
 				if (
 				  test_bit(STRIPE_PREREAD_ACTIVE, &sh->state)) {
-					PRINTK("Read_old stripe %llu "
+					pr_debug("Read_old stripe %llu "
 						"block %d for Reconstruct\n",
 					     (unsigned long long)sh->sector, i);
 					set_bit(R5_LOCKED, &dev->flags);
 					set_bit(R5_Wantread, &dev->flags);
 					s->locked++;
 				} else {
-					PRINTK("Request delayed stripe %llu "
+					pr_debug("Request delayed stripe %llu "
 						"block %d for Reconstruct\n",
 					     (unsigned long long)sh->sector, i);
 					set_bit(STRIPE_DELAYED, &sh->state);
@@ -1721,13 +1721,13 @@ static void handle_issuing_new_write_requests6(raid5_conf_t *conf,
 			}
 		}
 
-		PRINTK("Computing parity for stripe %llu\n",
+		pr_debug("Computing parity for stripe %llu\n",
 			(unsigned long long)sh->sector);
 		compute_parity6(sh, RECONSTRUCT_WRITE);
 		/* now every locked buffer is ready to be written */
 		for (i = disks; i--; )
 			if (test_bit(R5_LOCKED, &sh->dev[i].flags)) {
-				PRINTK("Writing stripe %llu block %d\n",
+				pr_debug("Writing stripe %llu block %d\n",
 				       (unsigned long long)sh->sector, i);
 				s->locked++;
 				set_bit(R5_Wantwrite, &sh->dev[i].flags);
@@ -1956,7 +1956,7 @@ static void handle_stripe5(struct stripe_head *sh)
 	struct r5dev *dev;
 
 	memset(&s, 0, sizeof(s));
-	PRINTK("handling stripe %llu, cnt=%d, pd_idx=%d\n",
+	pr_debug("handling stripe %llu, cnt=%d, pd_idx=%d\n",
 		(unsigned long long)sh->sector, atomic_read(&sh->count),
 		sh->pd_idx);
 
@@ -1975,12 +1975,12 @@ static void handle_stripe5(struct stripe_head *sh)
 		struct r5dev *dev = &sh->dev[i];
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
@@ -2027,7 +2027,7 @@ static void handle_stripe5(struct stripe_head *sh)
 			set_bit(R5_Insync, &dev->flags);
 	}
 	rcu_read_unlock();
-	PRINTK("locked=%d uptodate=%d to_read=%d"
+	pr_debug("locked=%d uptodate=%d to_read=%d"
 		" to_write=%d failed=%d failed_num=%d\n",
 		s.locked, s.uptodate, s.to_read, s.to_write,
 		s.failed, s.failed_num);
@@ -2165,7 +2165,7 @@ static void handle_stripe5(struct stripe_head *sh)
 				md_sync_acct(rdev->bdev, STRIPE_SECTORS);
 
 			bi->bi_bdev = rdev->bdev;
-			PRINTK("for %llu schedule op %ld on disc %d\n",
+			pr_debug("for %llu schedule op %ld on disc %d\n",
 				(unsigned long long)sh->sector, bi->bi_rw, i);
 			atomic_inc(&sh->count);
 			bi->bi_sector = sh->sector + rdev->data_offset;
@@ -2185,7 +2185,7 @@ static void handle_stripe5(struct stripe_head *sh)
 		} else {
 			if (rw == WRITE)
 				set_bit(STRIPE_DEGRADED, &sh->state);
-			PRINTK("skip op %ld on disc %d for sector %llu\n",
+			pr_debug("skip op %ld on disc %d for sector %llu\n",
 				bi->bi_rw, i, (unsigned long long)sh->sector);
 			clear_bit(R5_LOCKED, &sh->dev[i].flags);
 			set_bit(STRIPE_HANDLE, &sh->state);
@@ -2205,7 +2205,7 @@ static void handle_stripe6(struct stripe_head *sh, struct page *tmp_page)
 	struct r5dev *dev, *pdev, *qdev;
 
 	r6s.qd_idx = raid6_next_disk(pd_idx, disks);
-	PRINTK("handling stripe %llu, state=%#lx cnt=%d, "
+	pr_debug("handling stripe %llu, state=%#lx cnt=%d, "
 		"pd_idx=%d, qd_idx=%d\n",
 	       (unsigned long long)sh->sector, sh->state,
 	       atomic_read(&sh->count), pd_idx, r6s.qd_idx);
@@ -2226,12 +2226,12 @@ static void handle_stripe6(struct stripe_head *sh, struct page *tmp_page)
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
@@ -2280,7 +2280,7 @@ static void handle_stripe6(struct stripe_head *sh, struct page *tmp_page)
 			set_bit(R5_Insync, &dev->flags);
 	}
 	rcu_read_unlock();
-	PRINTK("locked=%d uptodate=%d to_read=%d"
+	pr_debug("locked=%d uptodate=%d to_read=%d"
 	       " to_write=%d failed=%d failed_num=%d,%d\n",
 	       s.locked, s.uptodate, s.to_read, s.to_write, s.failed,
 	       r6s.failed_num[0], r6s.failed_num[1]);
@@ -2428,7 +2428,7 @@ static void handle_stripe6(struct stripe_head *sh, struct page *tmp_page)
 				md_sync_acct(rdev->bdev, STRIPE_SECTORS);
 
 			bi->bi_bdev = rdev->bdev;
-			PRINTK("for %llu schedule op %ld on disc %d\n",
+			pr_debug("for %llu schedule op %ld on disc %d\n",
 				(unsigned long long)sh->sector, bi->bi_rw, i);
 			atomic_inc(&sh->count);
 			bi->bi_sector = sh->sector + rdev->data_offset;
@@ -2448,7 +2448,7 @@ static void handle_stripe6(struct stripe_head *sh, struct page *tmp_page)
 		} else {
 			if (rw == WRITE)
 				set_bit(STRIPE_DEGRADED, &sh->state);
-			PRINTK("skip op %ld on disc %d for sector %llu\n",
+			pr_debug("skip op %ld on disc %d for sector %llu\n",
 				bi->bi_rw, i, (unsigned long long)sh->sector);
 			clear_bit(R5_LOCKED, &sh->dev[i].flags);
 			set_bit(STRIPE_HANDLE, &sh->state);
@@ -2692,7 +2692,7 @@ static int raid5_align_endio(struct bio *bi, unsigned int bytes, int error)
 	}
 
 
-	PRINTK("raid5_align_endio : io error...handing IO for a retry\n");
+	pr_debug("raid5_align_endio : io error...handing IO for a retry\n");
 
 	add_bio_to_retry(raid_bi, conf);
 	return 0;
@@ -2730,7 +2730,7 @@ static int chunk_aligned_read(request_queue_t *q, struct bio * raid_bio)
 	mdk_rdev_t *rdev;
 
 	if (!in_chunk_boundary(mddev, raid_bio)) {
-		PRINTK("chunk_aligned_read : non aligned\n");
+		pr_debug("chunk_aligned_read : non aligned\n");
 		return 0;
 	}
 	/*
@@ -2854,7 +2854,7 @@ static int make_request(request_queue_t *q, struct bio * bi)
 
  		new_sector = raid5_compute_sector(logical_sector, disks, data_disks,
 						  &dd_idx, &pd_idx, conf);
-		PRINTK("raid5: make_request, sector %llu logical %llu\n",
+		pr_debug("raid5: make_request, sector %llu logical %llu\n",
 			(unsigned long long)new_sector, 
 			(unsigned long long)logical_sector);
 
@@ -3227,7 +3227,7 @@ static void raid5d (mddev_t *mddev)
 	raid5_conf_t *conf = mddev_to_conf(mddev);
 	int handled;
 
-	PRINTK("+++ raid5d active\n");
+	pr_debug("+++ raid5d active\n");
 
 	md_check_recovery(mddev);
 
@@ -3279,13 +3279,13 @@ static void raid5d (mddev_t *mddev)
 
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
@@ -3461,7 +3461,7 @@ static int run(mddev_t *mddev)
 	atomic_set(&conf->preread_active_stripes, 0);
 	atomic_set(&conf->active_aligned_reads, 0);
 
-	PRINTK("raid5: run(%s) called.\n", mdname(mddev));
+	pr_debug("raid5: run(%s) called.\n", mdname(mddev));
 
 	ITERATE_RDEV(mddev,rdev,tmp) {
 		raid_disk = rdev->raid_disk;
@@ -3644,7 +3644,7 @@ static int stop(mddev_t *mddev)
 	return 0;
 }
 
-#if RAID5_DEBUG
+#ifdef DEBUG
 static void print_sh (struct seq_file *seq, struct stripe_head *sh)
 {
 	int i;
@@ -3691,7 +3691,7 @@ static void status (struct seq_file *seq, mddev_t *mddev)
 			       conf->disks[i].rdev &&
 			       test_bit(In_sync, &conf->disks[i].rdev->flags) ? "U" : "_");
 	seq_printf (seq, "]");
-#if RAID5_DEBUG
+#ifdef DEBUG
 	seq_printf (seq, "\n");
 	printall(seq, conf);
 #endif
