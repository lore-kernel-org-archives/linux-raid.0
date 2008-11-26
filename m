From: scjody@sun.com
Subject: [RFC patch 1/1] Track raid5/6 statistics.
Date: Wed, 26 Nov 2008 14:04:53 -0500
Message-ID: <20081126190854.813151413@sun.com>
References: <20081126190452.775333692@sun.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; NAME=raid5-stats.patch
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-disposition: inline; filename=raid5-stats.patch
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, neilb@suse.de
List-Id: linux-raid.ids

This patch tracks various statistics related to the performance of a RAID 5
or 6 array.  These have been useful to us in the past to help solve
performance issues.  They are reported via /proc/mdstat.

I realize that the format of the statistics may not be the best, and
there may be a better location than /proc/mdstat, so I welcome suggestions
on where to put them.

I will add documentation once we've decided on the format and location (or
if nobody objects to the current format and location.)

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
@@ -369,6 +373,10 @@ static struct stripe_head *get_active_st
 				    !test_bit(STRIPE_EXPANDING, &sh->state))
 					BUG();
 				list_del_init(&sh->lru);
+				if (test_bit(STRIPE_DELAYED, &sh->state))
+					atomic_dec(&conf->delayed);
+				if (test_bit(STRIPE_BIT_DELAY, &sh->state))
+					atomic_dec(&conf->bit_delayed);
 			}
 		}
 	} while (sh == NULL);
@@ -406,10 +414,13 @@ static void ops_run_io(struct stripe_hea
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
@@ -444,6 +455,7 @@ static void ops_run_io(struct stripe_hea
 			    test_bit(R5_ReWrite, &sh->dev[i].flags))
 				atomic_add(STRIPE_SECTORS,
 					&rdev->corrected_errors);
+			atomic_inc(&conf->out_reqs_in_queue);
 			generic_make_request(bi);
 		} else {
 			if (rw == WRITE)
@@ -547,7 +559,7 @@ static void ops_complete_biofill(void *s
 	spin_unlock_irq(&conf->device_lock);
 	clear_bit(STRIPE_BIOFILL_RUN, &sh->state);
 
-	return_io(return_bi);
+	return_io(return_bi, conf);
 
 	set_bit(STRIPE_HANDLE, &sh->state);
 	release_stripe(sh);
@@ -1074,6 +1086,8 @@ static void raid5_end_read_request(struc
 	mdk_rdev_t *rdev;
 
 
+	atomic_dec(&conf->out_reqs_in_queue);
+
 	for (i=0 ; i<disks; i++)
 		if (bi == &sh->dev[i].req)
 			break;
@@ -1153,6 +1167,8 @@ static void raid5_end_write_request(stru
 	int disks = sh->disks, i;
 	int uptodate = test_bit(BIO_UPTODATE, &bi->bi_flags);
 
+	atomic_dec(&conf->out_reqs_in_queue);
+
 	for (i=0 ; i<disks; i++)
 		if (bi == &sh->dev[i].req)
 			break;
@@ -2131,6 +2147,7 @@ static void handle_stripe_dirtying5(raid
 					set_bit(R5_LOCKED, &dev->flags);
 					set_bit(R5_Wantread, &dev->flags);
 					s->locked++;
+					atomic_inc(&conf->reads_for_rmw);
 				} else {
 					set_bit(STRIPE_DELAYED, &sh->state);
 					set_bit(STRIPE_HANDLE, &sh->state);
@@ -2154,6 +2171,7 @@ static void handle_stripe_dirtying5(raid
 					set_bit(R5_LOCKED, &dev->flags);
 					set_bit(R5_Wantread, &dev->flags);
 					s->locked++;
+					atomic_inc(&conf->reads_for_rcw);
 				} else {
 					set_bit(STRIPE_DELAYED, &sh->state);
 					set_bit(STRIPE_HANDLE, &sh->state);
@@ -2219,6 +2237,7 @@ static void handle_stripe_dirtying6(raid
 					set_bit(R5_LOCKED, &dev->flags);
 					set_bit(R5_Wantread, &dev->flags);
 					s->locked++;
+					atomic_inc(&conf->reads_for_rcw);
 				} else {
 					pr_debug("Request delayed stripe %llu "
 						"block %d for Reconstruct\n",
@@ -2556,6 +2575,8 @@ static bool handle_stripe5(struct stripe
 	clear_bit(STRIPE_HANDLE, &sh->state);
 	clear_bit(STRIPE_DELAYED, &sh->state);
 
+	atomic_inc(&conf->handle_called);
+
 	s.syncing = test_bit(STRIPE_SYNCING, &sh->state);
 	s.expanding = test_bit(STRIPE_EXPAND_SOURCE, &sh->state);
 	s.expanded = test_bit(STRIPE_EXPAND_READY, &sh->state);
@@ -2789,7 +2810,7 @@ static bool handle_stripe5(struct stripe
 
 	ops_run_io(sh, &s);
 
-	return_io(return_bi);
+	return_io(return_bi, conf);
 
 	return blocked_rdev == NULL;
 }
@@ -2816,6 +2837,8 @@ static bool handle_stripe6(struct stripe
 	clear_bit(STRIPE_HANDLE, &sh->state);
 	clear_bit(STRIPE_DELAYED, &sh->state);
 
+	atomic_inc(&conf->handle_called);
+
 	s.syncing = test_bit(STRIPE_SYNCING, &sh->state);
 	s.expanding = test_bit(STRIPE_EXPAND_SOURCE, &sh->state);
 	s.expanded = test_bit(STRIPE_EXPAND_READY, &sh->state);
@@ -3011,7 +3034,7 @@ static bool handle_stripe6(struct stripe
 
 	ops_run_io(sh, &s);
 
-	return_io(return_bi);
+	return_io(return_bi, conf);
 
 	return blocked_rdev == NULL;
 }
@@ -3039,6 +3062,7 @@ static void raid5_activate_delayed(raid5
 			if (!test_and_set_bit(STRIPE_PREREAD_ACTIVE, &sh->state))
 				atomic_inc(&conf->preread_active_stripes);
 			list_add_tail(&sh->lru, &conf->hold_list);
+			atomic_dec(&conf->delayed);
 		}
 	} else
 		blk_plug_device(conf->mddev->queue);
@@ -3217,6 +3241,7 @@ static void raid5_align_endio(struct bio
 	raid_bi->bi_next = NULL;
 
 	rdev_dec_pending(rdev, conf->mddev);
+	atomic_dec(&conf->out_reqs_in_queue);
 
 	if (!error && uptodate) {
 		bio_endio(raid_bi, 0);
@@ -3265,6 +3290,7 @@ static int chunk_aligned_read(struct req
 		pr_debug("chunk_aligned_read : non aligned\n");
 		return 0;
 	}
+	atomic_inc(&conf->aligned_reads);
 	/*
  	 * use bio_clone to make a copy of the bio
 	 */
@@ -3287,11 +3313,13 @@ static int chunk_aligned_read(struct req
 					&pd_idx,
 					conf);
 
+	atomic_dec(&conf->in_reqs_in_queue);
 	rcu_read_lock();
 	rdev = rcu_dereference(conf->disks[dd_idx].rdev);
 	if (rdev && test_bit(In_sync, &rdev->flags)) {
 		atomic_inc(&rdev->nr_pending);
 		rcu_read_unlock();
+		atomic_inc(&conf->reads_out);
 		raid_bio->bi_next = (void*)rdev;
 		align_bi->bi_bdev =  rdev->bdev;
 		align_bi->bi_flags &= ~(1 << BIO_SEG_VALID);
@@ -3311,6 +3339,7 @@ static int chunk_aligned_read(struct req
 		atomic_inc(&conf->active_aligned_reads);
 		spin_unlock_irq(&conf->device_lock);
 
+		atomic_inc(&conf->out_reqs_in_queue);
 		generic_make_request(align_bi);
 		return 1;
 	} else {
@@ -3384,6 +3413,8 @@ static int make_request(struct request_q
 	const int rw = bio_data_dir(bi);
 	int cpu, remaining;
 
+	atomic_inc(&conf->in_reqs_in_queue);
+
 	if (unlikely(bio_barrier(bi))) {
 		bio_endio(bi, -EOPNOTSUPP);
 		return 0;
@@ -3397,6 +3428,11 @@ static int make_request(struct request_q
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
@@ -3508,6 +3544,7 @@ static int make_request(struct request_q
 
 		if ( rw == WRITE )
 			md_write_end(mddev);
+		atomic_dec(&conf->in_reqs_in_queue);
 
 		bio_endio(bi, 0);
 	}
@@ -3862,6 +3899,7 @@ static void raid5d(mddev_t *mddev)
 			if (!ok)
 				break;
 			handled++;
+			atomic_inc(&conf->handled_in_raid5d);
 		}
 
 		sh = __get_priority_stripe(conf);
@@ -3871,6 +3909,7 @@ static void raid5d(mddev_t *mddev)
 		spin_unlock_irq(&conf->device_lock);
 		
 		handled++;
+		atomic_inc(&conf->handled_in_raid5d);
 		handle_stripe(sh, conf->spare_page);
 		release_stripe(sh);
 
@@ -4330,15 +4369,37 @@ static void status(struct seq_file *seq,
 	raid5_conf_t *conf = (raid5_conf_t *) mddev->private;
 	int i;
 
-	seq_printf (seq, " level %d, %dk chunk, algorithm %d", mddev->level, mddev->chunk_size >> 10, mddev->layout);
-	seq_printf (seq, " [%d/%d] [", conf->raid_disks, conf->raid_disks - mddev->degraded);
+	seq_printf(seq, " level %d, %dk chunk, algorithm %d", mddev->level,
+				mddev->chunk_size >> 10, mddev->layout);
+	seq_printf(seq, " [%d/%d] [", conf->raid_disks,
+				conf->raid_disks - mddev->degraded);
 	for (i = 0; i < conf->raid_disks; i++)
-		seq_printf (seq, "%s",
+		seq_printf(seq, "%s",
 			       conf->disks[i].rdev &&
 			       test_bit(In_sync, &conf->disks[i].rdev->flags) ? "U" : "_");
-	seq_printf (seq, "]");
+	seq_printf(seq, "]\n");
+	seq_printf(seq, "\tin: %u reads, %u writes; out: %u reads, %u writes\n",
+			atomic_read(&conf->reads_in),
+			atomic_read(&conf->writes_in),
+			atomic_read(&conf->reads_out),
+			atomic_read(&conf->writes_out));
+	seq_printf(seq, "\t%u in raid5d, %u out of stripes, %u handle called\n",
+			atomic_read(&conf->handled_in_raid5d),
+			atomic_read(&conf->out_of_stripes),
+			atomic_read(&conf->handle_called));
+	seq_printf(seq, "\treads: %u for rmw, %u for rcw, %u aligned,\n",
+			atomic_read(&conf->reads_for_rmw),
+			atomic_read(&conf->reads_for_rcw),
+			atomic_read(&conf->aligned_reads));
+	seq_printf(seq, "\t%u delayed, %u bit delayed, %u active, ",
+			atomic_read(&conf->delayed),
+			atomic_read(&conf->bit_delayed),
+			atomic_read(&conf->active_stripes));
+	seq_printf(seq, "queues: %u in, %u out\n",
+			atomic_read(&conf->in_reqs_in_queue),
+			atomic_read(&conf->out_reqs_in_queue));
 #ifdef DEBUG
-	seq_printf (seq, "\n");
+	seq_printf(seq, "\n");
 	printall(seq, conf);
 #endif
 }
Index: linux-2.6/include/linux/raid/raid5.h
===================================================================
--- linux-2.6.orig/include/linux/raid/raid5.h
+++ linux-2.6/include/linux/raid/raid5.h
@@ -385,6 +385,26 @@ struct raid5_private_data {
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
+	atomic_t		handled_in_raid5d;
+	atomic_t		out_of_stripes;
+	atomic_t		reads_for_rmw;
+	atomic_t		reads_for_rcw;
+	atomic_t		aligned_reads;
+	atomic_t		writes_zcopy;
+	atomic_t		writes_copied;
+	atomic_t		handle_called;
+	atomic_t		delayed;
+	atomic_t		bit_delayed;
+	atomic_t		in_reqs_in_queue;
+	atomic_t		out_reqs_in_queue;
 };
 
 typedef struct raid5_private_data raid5_conf_t;

-- 
