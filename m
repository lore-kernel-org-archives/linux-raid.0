From: Jody McIntyre <scjody@sun.com>
Subject: [PATCH] md: Track raid5/6 statistics
Date: Thu, 12 Mar 2009 16:57:55 -0400
Message-ID: <20090312205754.GH8732@clouds>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, neilb@suse.de, dan.j.williams@intel.com
List-Id: linux-raid.ids

This patch tracks various statistics related to the performance of a RAID 5
or 6 array.  These have been useful to us in the past to help solve
performance issues.  They are reported via the 'stat' file in each device's
'md' sysfs directory, e.g. /sys/class/block/md0/md/stat .

A slight amount of overhead is added by the atomic_inc() and atomic_dec()
calls used in these patches, but it's so low I've been unable to measure it.
Both calls are already used extensively in raid5.c to track internal
counters so I believe this is OK.

Signed-off-by: Jody McIntyre <scjody@sun.com>

Index: linux-2.6/drivers/md/raid5.c
===================================================================
--- linux-2.6.orig/drivers/md/raid5.c
+++ linux-2.6/drivers/md/raid5.c
@@ -136,7 +136,7 @@ static inline int raid6_next_disk(int di
 	return (disk < raid_disks) ? disk : 0;
 }
 
-static void return_io(struct bio *return_bi)
+static void return_io(struct bio *return_bi, raid5_conf_t *conf)
 {
 	struct bio *bi = return_bi;
 	while (bi) {
@@ -145,6 +145,7 @@ static void return_io(struct bio *return
 		bi->bi_next = NULL;
 		bi->bi_size = 0;
 		bio_endio(bi, 0);
+		atomic_dec(&conf->in_reqs_in_queue);
 		bi = return_bi;
 	}
 }
@@ -167,10 +168,12 @@ static void __release_stripe(raid5_conf_
 			if (test_bit(STRIPE_DELAYED, &sh->state)) {
 				list_add_tail(&sh->lru, &conf->delayed_list);
 				blk_plug_device(conf->mddev->queue);
+				atomic_inc(&conf->delayed);
 			} else if (test_bit(STRIPE_BIT_DELAY, &sh->state) &&
 				   sh->bm_seq - conf->seq_write > 0) {
 				list_add_tail(&sh->lru, &conf->bitmap_list);
 				blk_plug_device(conf->mddev->queue);
+				atomic_inc(&conf->bit_delayed);
 			} else {
 				clear_bit(STRIPE_BIT_DELAY, &sh->state);
 				list_add_tail(&sh->lru, &conf->handle_list);
@@ -347,6 +350,7 @@ static struct stripe_head *get_active_st
 			if (noblock && sh == NULL)
 				break;
 			if (!sh) {
+				atomic_inc(&conf->out_of_stripes);
 				conf->inactive_blocked = 1;
 				wait_event_lock_irq(conf->wait_for_stripe,
 						    !list_empty(&conf->inactive_list) &&
@@ -406,10 +410,13 @@ static void ops_run_io(struct stripe_hea
 		bi = &sh->dev[i].req;
 
 		bi->bi_rw = rw;
-		if (rw == WRITE)
+		if (rw == WRITE) {
+			atomic_inc(&conf->writes_out);
 			bi->bi_end_io = raid5_end_write_request;
-		else
+		} else {
+			atomic_inc(&conf->reads_out);
 			bi->bi_end_io = raid5_end_read_request;
+		}
 
 		rcu_read_lock();
 		rdev = rcu_dereference(conf->disks[i].rdev);
@@ -444,6 +451,7 @@ static void ops_run_io(struct stripe_hea
 			    test_bit(R5_ReWrite, &sh->dev[i].flags))
 				atomic_add(STRIPE_SECTORS,
 					&rdev->corrected_errors);
+			atomic_inc(&conf->out_reqs_in_queue);
 			generic_make_request(bi);
 		} else {
 			if (rw == WRITE)
@@ -547,7 +555,7 @@ static void ops_complete_biofill(void *s
 	spin_unlock_irq(&conf->device_lock);
 	clear_bit(STRIPE_BIOFILL_RUN, &sh->state);
 
-	return_io(return_bi);
+	return_io(return_bi, conf);
 
 	set_bit(STRIPE_HANDLE, &sh->state);
 	release_stripe(sh);
@@ -1074,6 +1082,8 @@ static void raid5_end_read_request(struc
 	mdk_rdev_t *rdev;
 
 
+	atomic_dec(&conf->out_reqs_in_queue);
+
 	for (i=0 ; i<disks; i++)
 		if (bi == &sh->dev[i].req)
 			break;
@@ -1153,6 +1163,8 @@ static void raid5_end_write_request(stru
 	int disks = sh->disks, i;
 	int uptodate = test_bit(BIO_UPTODATE, &bi->bi_flags);
 
+	atomic_dec(&conf->out_reqs_in_queue);
+
 	for (i=0 ; i<disks; i++)
 		if (bi == &sh->dev[i].req)
 			break;
@@ -2131,6 +2143,7 @@ static void handle_stripe_dirtying5(raid
 					set_bit(R5_LOCKED, &dev->flags);
 					set_bit(R5_Wantread, &dev->flags);
 					s->locked++;
+					atomic_inc(&conf->reads_for_rmw);
 				} else {
 					set_bit(STRIPE_DELAYED, &sh->state);
 					set_bit(STRIPE_HANDLE, &sh->state);
@@ -2154,6 +2167,7 @@ static void handle_stripe_dirtying5(raid
 					set_bit(R5_LOCKED, &dev->flags);
 					set_bit(R5_Wantread, &dev->flags);
 					s->locked++;
+					atomic_inc(&conf->reads_for_rcw);
 				} else {
 					set_bit(STRIPE_DELAYED, &sh->state);
 					set_bit(STRIPE_HANDLE, &sh->state);
@@ -2219,6 +2233,7 @@ static void handle_stripe_dirtying6(raid
 					set_bit(R5_LOCKED, &dev->flags);
 					set_bit(R5_Wantread, &dev->flags);
 					s->locked++;
+					atomic_inc(&conf->reads_for_rcw);
 				} else {
 					pr_debug("Request delayed stripe %llu "
 						"block %d for Reconstruct\n",
@@ -2789,7 +2804,7 @@ static bool handle_stripe5(struct stripe
 
 	ops_run_io(sh, &s);
 
-	return_io(return_bi);
+	return_io(return_bi, conf);
 
 	return blocked_rdev == NULL;
 }
@@ -3011,7 +3026,7 @@ static bool handle_stripe6(struct stripe
 
 	ops_run_io(sh, &s);
 
-	return_io(return_bi);
+	return_io(return_bi, conf);
 
 	return blocked_rdev == NULL;
 }
@@ -3217,6 +3232,7 @@ static void raid5_align_endio(struct bio
 	raid_bi->bi_next = NULL;
 
 	rdev_dec_pending(rdev, conf->mddev);
+	atomic_dec(&conf->out_reqs_in_queue);
 
 	if (!error && uptodate) {
 		bio_endio(raid_bi, 0);
@@ -3287,6 +3303,7 @@ static int chunk_aligned_read(struct req
 					&pd_idx,
 					conf);
 
+	atomic_dec(&conf->in_reqs_in_queue);
 	rcu_read_lock();
 	rdev = rcu_dereference(conf->disks[dd_idx].rdev);
 	if (rdev && test_bit(In_sync, &rdev->flags)) {
@@ -3311,6 +3328,9 @@ static int chunk_aligned_read(struct req
 		atomic_inc(&conf->active_aligned_reads);
 		spin_unlock_irq(&conf->device_lock);
 
+		atomic_inc(&conf->out_reqs_in_queue);
+		atomic_inc(&conf->aligned_reads);
+		atomic_inc(&conf->reads_out);
 		generic_make_request(align_bi);
 		return 1;
 	} else {
@@ -3384,6 +3404,8 @@ static int make_request(struct request_q
 	const int rw = bio_data_dir(bi);
 	int cpu, remaining;
 
+	atomic_inc(&conf->in_reqs_in_queue);
+
 	if (unlikely(bio_barrier(bi))) {
 		bio_endio(bi, -EOPNOTSUPP);
 		return 0;
@@ -3397,6 +3419,11 @@ static int make_request(struct request_q
 		      bio_sectors(bi));
 	part_stat_unlock();
 
+	if (rw == WRITE)
+		atomic_inc(&conf->writes_in);
+	else
+		atomic_inc(&conf->reads_in);
+
 	if (rw == READ &&
 	     mddev->reshape_position == MaxSector &&
 	     chunk_aligned_read(q,bi))
@@ -3508,6 +3535,7 @@ static int make_request(struct request_q
 
 		if ( rw == WRITE )
 			md_write_end(mddev);
+		atomic_dec(&conf->in_reqs_in_queue);
 
 		bio_endio(bi, 0);
 	}
@@ -3981,10 +4009,37 @@ stripe_cache_active_show(mddev_t *mddev,
 static struct md_sysfs_entry
 raid5_stripecache_active = __ATTR_RO(stripe_cache_active);
 
+static ssize_t
+stat_show(mddev_t *mddev, char *page)
+{
+	raid5_conf_t *conf = mddev_to_conf(mddev);
+	if (conf)
+		return sprintf(page, "%u %u %u %u %u %u %u %u %u %u %u %u %u\n",
+			       atomic_read(&conf->reads_in),
+			       atomic_read(&conf->writes_in),
+			       atomic_read(&conf->reads_out),
+			       atomic_read(&conf->writes_out),
+			       atomic_read(&conf->reads_for_rmw),
+			       atomic_read(&conf->reads_for_rcw),
+			       atomic_read(&conf->aligned_reads),
+			       atomic_read(&conf->active_stripes),
+			       atomic_read(&conf->in_reqs_in_queue),
+			       atomic_read(&conf->out_reqs_in_queue),
+			       atomic_read(&conf->delayed),
+			       atomic_read(&conf->bit_delayed),
+			       atomic_read(&conf->out_of_stripes));
+	else
+		return 0;
+}
+
+static struct md_sysfs_entry
+raid5_stats = __ATTR_RO(stat);
+
 static struct attribute *raid5_attrs[] =  {
 	&raid5_stripecache_size.attr,
 	&raid5_stripecache_active.attr,
 	&raid5_preread_bypass_threshold.attr,
+	&raid5_stats.attr,
 	NULL,
 };
 static struct attribute_group raid5_attrs_group = {
Index: linux-2.6/include/linux/raid/raid5.h
===================================================================
--- linux-2.6.orig/include/linux/raid/raid5.h
+++ linux-2.6/include/linux/raid/raid5.h
@@ -385,6 +385,22 @@ struct raid5_private_data {
 	int			pool_size; /* number of disks in stripeheads in pool */
 	spinlock_t		device_lock;
 	struct disk_info	*disks;
+
+	/*
+	 * Stats
+	 */
+	atomic_t		reads_in;
+	atomic_t		writes_in;
+	atomic_t		reads_out;
+	atomic_t		writes_out;
+	atomic_t		reads_for_rmw;
+	atomic_t		reads_for_rcw;
+	atomic_t		aligned_reads;
+	atomic_t		in_reqs_in_queue;
+	atomic_t		out_reqs_in_queue;
+	atomic_t		delayed;
+	atomic_t		bit_delayed;
+	atomic_t		out_of_stripes;
 };
 
 typedef struct raid5_private_data raid5_conf_t;
Index: linux-2.6/Documentation/md.txt
===================================================================
--- linux-2.6.orig/Documentation/md.txt
+++ linux-2.6/Documentation/md.txt
@@ -484,3 +484,26 @@ These currently include
       to 1.  Setting this to 0 disables bypass accounting and
       requires preread stripes to wait until all full-width stripe-
       writes are complete.  Valid values are 0 to stripe_cache_size.
+  stat (currently raid 5/6 only)
+      Reports various performance statistics related to the array.  In
+      order, separated by spaces:
+	reads in: number of reads submitted to the array
+	writes in: number of writes submitted to the array
+	reads out: number of reads performed on the underlying devices
+	writes out: number of writes performed on the underlying devices
+	reads for rmw: number of reads for read-modify-write operations
+	reads for rcw: number of reads for read-copy-write operations
+	aligned reads: number of reads via the aligned path
+
+	active stripes: number of stripes currently in use
+	in reqs in queue: current number of requests queued on the array
+	out reqs in queue: current number of requests queued for the underlying
+			   devices
+
+	delayed: number of write requests that were delayed to perform reads
+	bit delayed: number of write requests that were delayed to update the
+		     bitmap
+	out of stripes: number of times the array has run out of stripes;
+			if this value is high, increasing the stripe cache
+			may be useful.
+      More statistics may be added at the end of the line in the future.
