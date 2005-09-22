From: "Steinar H. Gunderson" <sgunderson@bigfoot.com>
Subject: Re: [PATCH] Online RAID-5 resizing
Date: Thu, 22 Sep 2005 22:53:16 +0200
Message-ID: <20050922205316.GA21849@uio.no>
References: <20050920143346.GA5777@uio.no> <17200.9302.242957.23189@cse.unsw.edu.au> <20050920153622.GA14287@uio.no> <17202.55529.310871.877019@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="Nq2Wo0NMKNjxTN9z"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <17202.55529.310871.877019@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--Nq2Wo0NMKNjxTN9z
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

On Thu, Sep 22, 2005 at 06:16:41PM +0200, Neil Brown wrote:
> Yes, that reindenting is a problem as it makes the patch hard to read
> -- it's hard to see which bits need to be checked and which don't.  If
> you could remove them for the next version, it would help....

Here's an updated version of the patch (against raid5.c only, the changes
against raid5.h should be the same) fixed for readability -- almost all
indent-only changes should be fixed now (I have no idea how they got in in
the first place), and I've removed some of the extra debug printk statements.
In addition, it has a bugfix or two over the previous one.

It still corrupts some stripes (usually something like half of a cluster)
when doing I/O against the RAID while it's restriping, and it might still
have the problem with uninterruptable sleep (unsure about the last one,
though).

I haven't done the other changes you proposed (yet).

/* Steinar */
-- 
Homepage: http://www.sesse.net/

--Nq2Wo0NMKNjxTN9z
Content-Type: text/plain; charset=utf-8
Content-Disposition: attachment; filename="raid5-online-expand-02.diff"

--- /usr/src/orig/linux-2.6-2.6.12/drivers/md/raid5.c	2005-06-17 21:48:29.000000000 +0200
+++ drivers/md/raid5.c	2005-09-22 23:04:58.000000000 +0200
@@ -68,19 +68,38 @@
 #endif
 
 static void print_raid5_conf (raid5_conf_t *conf);
+#if RAID5_DEBUG
+static void print_sh (struct stripe_head *sh);
+#endif
+static int sync_request (mddev_t *mddev, sector_t sector_nr, int go_faster);
+static void raid5_finish_expand (raid5_conf_t *conf);
+static sector_t raid5_compute_sector(sector_t r_sector, unsigned int raid_disks,
+			unsigned int data_disks, unsigned int * dd_idx,
+			unsigned int * pd_idx, raid5_conf_t *conf);
 
 static inline void __release_stripe(raid5_conf_t *conf, struct stripe_head *sh)
 {
+	BUG_ON(atomic_read(&sh->count) == 0);
 	if (atomic_dec_and_test(&sh->count)) {
 		if (!list_empty(&sh->lru))
 			BUG();
-		if (atomic_read(&conf->active_stripes)==0)
-			BUG();
+		if (conf->expand_in_progress && sh->disks == conf->raid_disks) {
+			if (atomic_read(&conf->active_stripes_expand)==0)
+				BUG();
+		} else {
+			if (atomic_read(&conf->active_stripes)==0)
+				BUG();
+		}
 		if (test_bit(STRIPE_HANDLE, &sh->state)) {
-			if (test_bit(STRIPE_DELAYED, &sh->state))
+			if (test_bit(STRIPE_DELAY_EXPAND, &sh->state)) {
+				list_add_tail(&sh->lru, &conf->wait_for_expand_list);
+				printk("delaying stripe with sector %llu (expprog=%llu, active=%d)\n", sh->sector,
+					conf->expand_progress, atomic_read(&conf->active_stripes_expand));
+			} else if (test_bit(STRIPE_DELAYED, &sh->state)) {
 				list_add_tail(&sh->lru, &conf->delayed_list);
-			else
+			} else {
 				list_add_tail(&sh->lru, &conf->handle_list);
+			}
 			md_wakeup_thread(conf->mddev->thread);
 		} else {
 			if (test_and_clear_bit(STRIPE_PREREAD_ACTIVE, &sh->state)) {
@@ -88,11 +107,34 @@
 				if (atomic_read(&conf->preread_active_stripes) < IO_THRESHOLD)
 					md_wakeup_thread(conf->mddev->thread);
 			}
-			list_add_tail(&sh->lru, &conf->inactive_list);
-			atomic_dec(&conf->active_stripes);
-			if (!conf->inactive_blocked ||
-			    atomic_read(&conf->active_stripes) < (NR_STRIPES*3/4))
-				wake_up(&conf->wait_for_stripe);
+			if (conf->expand_in_progress && sh->disks == conf->raid_disks) {
+				list_add_tail(&sh->lru, &conf->inactive_list_expand);
+				atomic_dec(&conf->active_stripes_expand);
+			} else {
+				list_add_tail(&sh->lru, &conf->inactive_list);
+				if (conf->expand_in_progress == 2) {
+					// we are in the process of finishing up an expand, see
+					// if we have no active stripes left
+					if (atomic_dec_and_test(&conf->active_stripes)) {
+						printk("Finishing up expand\n");
+						raid5_finish_expand(conf);
+						printk("Expand done.\n");
+					}
+				} else {
+					atomic_dec(&conf->active_stripes);
+				}
+			}
+			if (conf->expand_in_progress && sh->disks == conf->raid_disks) {
+				if (!conf->inactive_blocked_expand ||
+				    atomic_read(&conf->active_stripes_expand) < (NR_STRIPES*3/4)) {
+					wake_up(&conf->wait_for_stripe_expand);
+				}
+			} else {
+				if (!conf->inactive_blocked ||
+				    atomic_read(&conf->active_stripes) < (NR_STRIPES*3/4)) {
+					wake_up(&conf->wait_for_stripe);
+				}
+			}
 		}
 	}
 }
@@ -133,20 +175,44 @@
 
 
 /* find an idle stripe, make sure it is unhashed, and return it. */
-static struct stripe_head *get_free_stripe(raid5_conf_t *conf)
+static struct stripe_head *get_free_stripe(raid5_conf_t *conf, int expand)
 {
 	struct stripe_head *sh = NULL;
 	struct list_head *first;
 
 	CHECK_DEVLOCK();
-	if (list_empty(&conf->inactive_list))
-		goto out;
-	first = conf->inactive_list.next;
-	sh = list_entry(first, struct stripe_head, lru);
-	list_del_init(first);
-	remove_hash(sh);
-	atomic_inc(&conf->active_stripes);
+
+	if (expand) {
+		if (list_empty(&conf->inactive_list_expand))
+			goto out;
+		first = conf->inactive_list_expand.next;
+		sh = list_entry(first, struct stripe_head, lru);
+		list_del_init(first);
+		remove_hash(sh);
+		atomic_inc(&conf->active_stripes_expand);
+	} else {
+		if (list_empty(&conf->inactive_list))
+			goto out;
+		first = conf->inactive_list.next;
+		sh = list_entry(first, struct stripe_head, lru);
+		list_del_init(first);
+		remove_hash(sh);
+		atomic_inc(&conf->active_stripes);
+	}
 out:
+
+	if (sh) {
+		if (conf->expand_in_progress) {
+			if (expand)
+				BUG_ON(sh->disks != conf->raid_disks);
+			else
+				BUG_ON(sh->disks != conf->previous_raid_disks);
+		} else {
+			BUG_ON(expand);
+			BUG_ON(sh->disks != conf->raid_disks);
+		}
+	}
+
 	return sh;
 }
 
@@ -184,7 +250,7 @@
 static inline void init_stripe(struct stripe_head *sh, sector_t sector, int pd_idx)
 {
 	raid5_conf_t *conf = sh->raid_conf;
-	int disks = conf->raid_disks, i;
+	int disks = sh->disks, i;
 
 	if (atomic_read(&sh->count) != 0)
 		BUG();
@@ -245,21 +311,59 @@
 
 	do {
 		sh = __find_stripe(conf, sector);
+
+		// make sure this is of the right size; if not, remove it from the hash
+		if (sh) {
+			int correct_disks = conf->raid_disks;
+			if (conf->expand_in_progress && sector * (conf->raid_disks - 1) >= conf->expand_progress) {
+				correct_disks = conf->previous_raid_disks;
+			}
+
+			if (sh->disks != correct_disks) {
+				BUG_ON(atomic_read(&sh->count) != 0);
+
+				remove_hash(sh);
+				sh = NULL;
+			}
+		}
+		
 		if (!sh) {
-			if (!conf->inactive_blocked)
-				sh = get_free_stripe(conf);
+			if (conf->expand_in_progress && sector * (conf->raid_disks - 1) < conf->expand_progress) {
+				if (!conf->inactive_blocked_expand) {
+					sh = get_free_stripe(conf, 1);
+				}
+			} else {
+				if (!conf->inactive_blocked) {
+					sh = get_free_stripe(conf, 0);
+				}
+			}
 			if (noblock && sh == NULL)
 				break;
 			if (!sh) {
-				conf->inactive_blocked = 1;
-				wait_event_lock_irq(conf->wait_for_stripe,
-						    !list_empty(&conf->inactive_list) &&
-						    (atomic_read(&conf->active_stripes) < (NR_STRIPES *3/4)
-						     || !conf->inactive_blocked),
-						    conf->device_lock,
-						    unplug_slaves(conf->mddev);
-					);
-				conf->inactive_blocked = 0;
+				if (conf->expand_in_progress && sector * (conf->raid_disks - 1) < conf->expand_progress) {
+//					printk("WAITING FOR AN EXPAND STRIPE\n");
+					conf->inactive_blocked_expand = 1;
+					wait_event_lock_irq(conf->wait_for_stripe_expand,
+							    !list_empty(&conf->inactive_list_expand) &&
+							    (atomic_read(&conf->active_stripes_expand) < (NR_STRIPES *3/4)
+							     || !conf->inactive_blocked_expand),
+							    conf->device_lock,
+							    unplug_slaves(conf->mddev);
+						);
+					conf->inactive_blocked_expand = 0;
+				} else {
+//					printk("WAITING FOR A NON-EXPAND STRIPE, sector=%llu\n", sector);
+					conf->inactive_blocked = 1;
+					wait_event_lock_irq(conf->wait_for_stripe,
+							    !list_empty(&conf->inactive_list) &&
+							    (atomic_read(&conf->active_stripes) < (NR_STRIPES *3/4)
+							     || !conf->inactive_blocked),
+							    conf->device_lock,
+							    unplug_slaves(conf->mddev);
+						);
+					conf->inactive_blocked = 0;
+				}
+//				printk("INACTIVITY DONE\n");
 			} else
 				init_stripe(sh, sector, pd_idx);
 		} else {
@@ -267,8 +371,13 @@
 				if (!list_empty(&sh->lru))
 					BUG();
 			} else {
-				if (!test_bit(STRIPE_HANDLE, &sh->state))
-					atomic_inc(&conf->active_stripes);
+				if (!test_bit(STRIPE_HANDLE, &sh->state)) {
+					if (conf->expand_in_progress && sector * (conf->raid_disks - 1) < conf->expand_progress) {
+						atomic_inc(&conf->active_stripes_expand);
+					} else {
+						atomic_inc(&conf->active_stripes);
+					}
+				}
 				if (list_empty(&sh->lru))
 					BUG();
 				list_del_init(&sh->lru);
@@ -283,26 +392,33 @@
 	return sh;
 }
 
-static int grow_stripes(raid5_conf_t *conf, int num)
+static int grow_stripes(raid5_conf_t *conf, int num, int expand)
 {
 	struct stripe_head *sh;
 	kmem_cache_t *sc;
 	int devs = conf->raid_disks;
 
-	sprintf(conf->cache_name, "raid5/%s", mdname(conf->mddev));
+	if (expand)
+		sprintf(conf->cache_name, "raid5e/%s", mdname(conf->mddev));
+	else
+		sprintf(conf->cache_name, "raid5/%s", mdname(conf->mddev));
 
 	sc = kmem_cache_create(conf->cache_name, 
 			       sizeof(struct stripe_head)+(devs-1)*sizeof(struct r5dev),
 			       0, 0, NULL, NULL);
 	if (!sc)
 		return 1;
-	conf->slab_cache = sc;
+	if (expand)
+		conf->slab_cache_expand = sc;
+	else
+		conf->slab_cache = sc;
 	while (num--) {
 		sh = kmem_cache_alloc(sc, GFP_KERNEL);
 		if (!sh)
 			return 1;
 		memset(sh, 0, sizeof(*sh) + (devs-1)*sizeof(struct r5dev));
 		sh->raid_conf = conf;
+		sh->disks = conf->raid_disks;
 		spin_lock_init(&sh->lock);
 
 		if (grow_buffers(sh, conf->raid_disks)) {
@@ -312,7 +428,11 @@
 		}
 		/* we just created an active stripe so... */
 		atomic_set(&sh->count, 1);
-		atomic_inc(&conf->active_stripes);
+		if (expand) {
+			atomic_inc(&conf->active_stripes_expand);
+		} else {
+			atomic_inc(&conf->active_stripes);
+		}
 		INIT_LIST_HEAD(&sh->lru);
 		release_stripe(sh);
 	}
@@ -325,7 +445,7 @@
 
 	while (1) {
 		spin_lock_irq(&conf->device_lock);
-		sh = get_free_stripe(conf);
+		sh = get_free_stripe(conf, 0);
 		spin_unlock_irq(&conf->device_lock);
 		if (!sh)
 			break;
@@ -344,7 +464,7 @@
 {
  	struct stripe_head *sh = bi->bi_private;
 	raid5_conf_t *conf = sh->raid_conf;
-	int disks = conf->raid_disks, i;
+	int disks = sh->disks, i;
 	int uptodate = test_bit(BIO_UPTODATE, &bi->bi_flags);
 
 	if (bi->bi_size)
@@ -411,12 +531,93 @@
 	return 0;
 }
 
+							
+static void raid5_finish_expand (raid5_conf_t *conf)
+{
+	int i;
+	struct disk_info *tmp;
+//	shrink_stripes(conf);
+	
+	conf->expand_in_progress = 0;
+	conf->active_stripes = conf->active_stripes_expand;
+	conf->inactive_list = conf->inactive_list_expand;
+	conf->wait_for_stripe = conf->wait_for_stripe_expand;
+	conf->slab_cache = conf->slab_cache_expand;
+	conf->inactive_blocked = conf->inactive_blocked_expand;
+
+	// fix up linked list
+	conf->inactive_list.next->prev = &conf->inactive_list;
+	{
+		struct list_head *first = &conf->inactive_list;
+		while (1) {
+			if (first->next == &conf->inactive_list_expand) {
+				first->next = &conf->inactive_list;
+				break;
+			}
+
+			first = first->next;
+		}
+	}
+
+	conf->wait_for_stripe.task_list.next->prev = &conf->wait_for_stripe.task_list;
+	{
+		struct list_head *first = &conf->wait_for_stripe.task_list;
+		while (1) {
+			if (first->next == &conf->wait_for_stripe_expand.task_list) {
+				first->next = &conf->wait_for_stripe.task_list;
+				break;
+			}
+
+			first = first->next;
+		}
+	}
+
+	for (i = conf->previous_raid_disks; i < conf->raid_disks; i++) {
+		tmp = conf->disks + i;
+		if (tmp->rdev
+		    && !tmp->rdev->faulty
+		    && !tmp->rdev->in_sync) {
+			conf->mddev->degraded--;
+			conf->failed_disks--;
+			conf->working_disks++;
+			tmp->rdev->in_sync = 1;
+		}
+	}
+
+	// inform the md code that we have more space now
+ 	{	
+		struct block_device *bdev;
+		sector_t sync_sector;
+		unsigned dummy1, dummy2;
+
+		conf->mddev->array_size = conf->mddev->size * (conf->mddev->raid_disks-1);
+		set_capacity(conf->mddev->gendisk, conf->mddev->array_size << 1);
+		conf->mddev->changed = 1;
+
+		sync_sector = raid5_compute_sector(conf->expand_progress, conf->raid_disks,
+			conf->raid_disks - 1, &dummy1, &dummy2, conf);
+		
+		conf->mddev->recovery_cp = sync_sector << 1;    // FIXME: hum, hum
+		set_bit(MD_RECOVERY_NEEDED, &conf->mddev->recovery);
+
+		bdev = bdget_disk(conf->mddev->gendisk, 0);
+		if (bdev) {
+			down(&bdev->bd_inode->i_sem);
+			i_size_write(bdev->bd_inode, conf->mddev->array_size << 10);
+			up(&bdev->bd_inode->i_sem);
+			bdput(bdev);
+		}
+	}
+	
+	/* FIXME: free old stuff here! (what are we missing?) */
+}
+
 static int raid5_end_write_request (struct bio *bi, unsigned int bytes_done,
 				    int error)
 {
  	struct stripe_head *sh = bi->bi_private;
 	raid5_conf_t *conf = sh->raid_conf;
-	int disks = conf->raid_disks, i;
+	int disks = sh->disks, i;
 	unsigned long flags;
 	int uptodate = test_bit(BIO_UPTODATE, &bi->bi_flags);
 
@@ -436,7 +637,7 @@
 	}
 
 	spin_lock_irqsave(&conf->device_lock, flags);
-	if (!uptodate)
+	if (!uptodate) 
 		md_error(conf->mddev, conf->disks[i].rdev);
 
 	rdev_dec_pending(conf->disks[i].rdev, conf->mddev);
@@ -570,7 +771,7 @@
 static sector_t compute_blocknr(struct stripe_head *sh, int i)
 {
 	raid5_conf_t *conf = sh->raid_conf;
-	int raid_disks = conf->raid_disks, data_disks = raid_disks - 1;
+	int raid_disks = sh->disks, data_disks = raid_disks - 1;
 	sector_t new_sector = sh->sector, check;
 	int sectors_per_chunk = conf->chunk_size >> 9;
 	sector_t stripe;
@@ -605,7 +806,8 @@
 
 	check = raid5_compute_sector (r_sector, raid_disks, data_disks, &dummy1, &dummy2, conf);
 	if (check != sh->sector || dummy1 != dd_idx || dummy2 != sh->pd_idx) {
-		printk("compute_blocknr: map not correct\n");
+		printk("compute_blocknr: map not correct (%llu,%u,%u vs. %llu,%u,%u) disks=%u offset=%u virtual_dd=%u\n",
+				check, dummy1, dummy2, sh->sector, dd_idx, sh->pd_idx, sh->disks, chunk_offset, i);
 		return 0;
 	}
 	return r_sector;
@@ -671,8 +873,7 @@
 
 static void compute_block(struct stripe_head *sh, int dd_idx)
 {
-	raid5_conf_t *conf = sh->raid_conf;
-	int i, count, disks = conf->raid_disks;
+	int i, count, disks = sh->disks;
 	void *ptr[MAX_XOR_BLOCKS], *p;
 
 	PRINTK("compute_block, stripe %llu, idx %d\n", 
@@ -691,7 +892,6 @@
 			printk("compute_block() %d, stripe %llu, %d"
 				" not present\n", dd_idx,
 				(unsigned long long)sh->sector, i);
-
 		check_xor();
 	}
 	if (count != 1)
@@ -702,7 +902,7 @@
 static void compute_parity(struct stripe_head *sh, int method)
 {
 	raid5_conf_t *conf = sh->raid_conf;
-	int i, pd_idx = sh->pd_idx, disks = conf->raid_disks, count;
+	int i, pd_idx = sh->pd_idx, disks = sh->disks, count;
 	void *ptr[MAX_XOR_BLOCKS];
 	struct bio *chosen;
 
@@ -876,11 +1076,11 @@
  * get BH_Lock set before the stripe lock is released.
  *
  */
- 
+
 static void handle_stripe(struct stripe_head *sh)
 {
 	raid5_conf_t *conf = sh->raid_conf;
-	int disks = conf->raid_disks;
+	int disks = sh->disks;
 	struct bio *return_bi= NULL;
 	struct bio *bi;
 	int i;
@@ -897,6 +1097,7 @@
 	spin_lock(&sh->lock);
 	clear_bit(STRIPE_HANDLE, &sh->state);
 	clear_bit(STRIPE_DELAYED, &sh->state);
+	clear_bit(STRIPE_DELAY_EXPAND, &sh->state);
 
 	syncing = test_bit(STRIPE_SYNCING, &sh->state);
 	/* Now to look around and see what can be done */
@@ -945,19 +1146,20 @@
 		}
 		if (dev->written) written++;
 		rdev = conf->disks[i].rdev; /* FIXME, should I be looking rdev */
-		if (!rdev || !rdev->in_sync) {
+		if (!conf->expand_in_progress && (!rdev || !rdev->in_sync)) {
 			failed++;
 			failed_num = i;
 		} else
 			set_bit(R5_Insync, &dev->flags);
 	}
-	PRINTK("locked=%d uptodate=%d to_read=%d"
-		" to_write=%d failed=%d failed_num=%d\n",
-		locked, uptodate, to_read, to_write, failed, failed_num);
 	/* check if the array has lost two devices and, if so, some requests might
 	 * need to be failed
 	 */
 	if (failed > 1 && to_read+to_write+written) {
+		printk("Need to fail requests!\n");
+		printk("locked=%d uptodate=%d to_read=%d"
+			" to_write=%d failed=%d failed_num=%d disks=%d\n",
+			locked, uptodate, to_read, to_write, failed, failed_num, disks);
 		spin_lock_irq(&conf->device_lock);
 		for (i=disks; i--; ) {
 			/* fail all writes first */
@@ -1012,7 +1214,7 @@
 		}
 		spin_unlock_irq(&conf->device_lock);
 	}
-	if (failed > 1 && syncing) {
+	if (failed > 1 && syncing && !conf->expand_in_progress) {
 		md_done_sync(conf->mddev, STRIPE_SECTORS,0);
 		clear_bit(STRIPE_SYNCING, &sh->state);
 		syncing = 0;
@@ -1085,7 +1287,7 @@
 					/* if I am just reading this block and we don't have
 					   a failed drive, or any pending writes then sidestep the cache */
 					if (sh->bh_read[i] && !sh->bh_read[i]->b_reqnext &&
-					    ! syncing && !failed && !to_write) {
+						! syncing && !failed && !to_write) {
 						sh->bh_cache[i]->b_page =  sh->bh_read[i]->b_page;
 						sh->bh_cache[i]->b_data =  sh->bh_read[i]->b_data;
 					}
@@ -1093,7 +1295,7 @@
 					locked++;
 					PRINTK("Reading block %d (sync=%d)\n", 
 						i, syncing);
-					if (syncing)
+					if (syncing && !conf->expand_in_progress)
 						md_sync_acct(conf->disks[i].rdev->bdev,
 							     STRIPE_SECTORS);
 				}
@@ -1102,6 +1304,288 @@
 		set_bit(STRIPE_HANDLE, &sh->state);
 	}
 
+	// see if we have the data we need to expand by another block
+	if (conf->expand_in_progress && sh->disks == conf->previous_raid_disks) {
+		int uptodate = 0, delay_to_future=0, d = 0, count = 0, needed_uptodate = 0;
+		for (i=0; i<disks; ++i) {
+			sector_t start_sector, dest_sector;
+			unsigned int dd_idx, pd_idx;
+
+			if (i == sh->pd_idx)
+				continue;
+
+			start_sector = sh->sector * (conf->previous_raid_disks - 1) + d * (conf->chunk_size >> 9);
+			++d;
+
+			// see what sector this block would land in the new layout
+			dest_sector = raid5_compute_sector(start_sector, conf->raid_disks,
+				conf->raid_disks - 1, &dd_idx, &pd_idx, conf);
+			if (dd_idx > pd_idx)
+				--dd_idx;
+
+/*			printk("start_sector = %llu (base=%llu, i=%u, d=%u) || dest_stripe = %llu\n", start_sector, sh->sector,
+				i, d, dest_stripe); */
+			
+			if (dest_sector * (conf->raid_disks - 1) >= conf->expand_progress &&
+ 			    dest_sector * (conf->raid_disks - 1) <  conf->expand_progress + (conf->chunk_size >> 9) * (conf->raid_disks - 1)) {
+/*				printk("UPDATING CHUNK %u FROM DISK %u (sec=%llu, dest_sector=%llu, uptodate=%u)\n",
+					dd_idx, i, start_sector, dest_sector, test_bit(R5_UPTODATE, &sh->dev[i].flags)); */
+				unsigned int buf_sector;
+				sector_t base = conf->expand_progress;
+				sector_div(base, conf->raid_disks - 1);
+
+				buf_sector = dd_idx * (conf->chunk_size / STRIPE_SIZE) + (dest_sector - base) / STRIPE_SECTORS;
+				
+				if (test_bit(R5_UPTODATE, &sh->dev[i].flags)) {
+					conf->expand_buffer[buf_sector].up_to_date = 1;
+//					printk("memcpy device %u/%u: %p <- %p\n", i, sh->disks,
+//						page_address(conf->expand_buffer[buf_sector].page), page_address(sh->dev[i].page));
+					memcpy(page_address(conf->expand_buffer[buf_sector].page), page_address(sh->dev[i].page), STRIPE_SIZE);
+//					printk("memcpy done\n");
+					count = 1;
+					PRINTK("Updating %u\n", buf_sector);
+				} else {
+					conf->expand_buffer[buf_sector].up_to_date = 0;
+				}
+			} else if (dest_sector * (conf->raid_disks - 1) >= conf->expand_progress + (conf->chunk_size >> 9) * (conf->raid_disks - 1) &&
+				   dest_sector * (conf->raid_disks - 1) < conf->expand_progress + (conf->chunk_size >> 9) * (conf->raid_disks - 1) * 2 &&
+				   syncing) {
+				delay_to_future = 1;
+			}
+		}
+
+		for (i=0; i < (conf->raid_disks - 1) * (conf->chunk_size / STRIPE_SIZE); ++i) {
+			uptodate += conf->expand_buffer[i].up_to_date;
+		}
+		if (count) 
+			PRINTK("%u/%lu is up to date\n", uptodate, (conf->raid_disks - 1) * (conf->chunk_size / STRIPE_SIZE));
+	
+		/*
+		 * Figure out how many stripes we need for this chunk to be complete.
+		 * In almost all cases, this will be a full destination stripe, but our
+		 * original volume might not be big enough for that at the very end --
+		 * so use the rest of the volume then.
+	         */
+		needed_uptodate = (conf->raid_disks - 1) * (conf->chunk_size / STRIPE_SIZE);
+		if (((conf->mddev->array_size << 1) - conf->expand_progress) / STRIPE_SECTORS < needed_uptodate) {
+			needed_uptodate = ((conf->mddev->array_size << 1) - conf->expand_progress) / STRIPE_SECTORS;
+//			printk("reading partial block at the end: %u\n", needed_uptodate);
+		}
+		if (needed_uptodate > 0 && uptodate == needed_uptodate) {
+			// we can do an expand!
+			struct stripe_head *newsh[256];   // FIXME: dynamic allocation somewhere instead?
+			sector_t dest_sector, advance;
+			unsigned i;
+			unsigned int dummy1, dummy2, pd_idx;
+
+			if ((conf->mddev->size << 1) - conf->expand_progress > (conf->chunk_size >> 9) * (conf->raid_disks - 1)) {
+				advance = (conf->chunk_size * (conf->raid_disks - 1)) >> 9;
+			} else {
+				advance = (conf->mddev->size << 1) - conf->expand_progress;
+			}
+
+//			sector_div(new_sector, (conf->raid_disks - 1));
+//			printk("EXPANDING ONTO SECTOR %llu\n", conf->expand_progress);
+//			printk("EXPAND => %llu/%llu\n", conf->expand_progress, conf->mddev->size << 1);
+			
+			// find the parity disk and starting sector
+			dest_sector = raid5_compute_sector(conf->expand_progress, conf->raid_disks,
+				conf->raid_disks - 1, &dummy1, &pd_idx, conf);
+//			printk("Expanding onto %llu\n", dest_sector);
+		
+			spin_lock_irq(&conf->device_lock);
+			
+			/*
+			 * Check that we won't try to expand over an area where there's
+			 * still active stripes; if we do, we'll risk inconsistency since we
+			 * suddenly have two different sets of stripes referring to the
+			 * same logical sector.
+			 */
+			{
+				struct stripe_head *ash;
+				int activity = 0, i;
+				sector_t first_touched_sector, last_touched_sector;
+				
+				first_touched_sector = raid5_compute_sector(conf->expand_progress,
+					conf->previous_raid_disks, conf->previous_raid_disks - 1, &dummy1, &dummy2, conf);
+				last_touched_sector = raid5_compute_sector(conf->expand_progress + ((conf->chunk_size * (conf->previous_raid_disks - 1)) >> 9) - 1,
+					conf->previous_raid_disks, conf->previous_raid_disks - 1, &dummy1, &dummy2, conf);
+
+				for (i = 0; i < NR_HASH; i++) {
+					ash = conf->stripe_hashtbl[i];
+					for (; ash; ash = ash->hash_next) {						
+						if (sh == ash && atomic_read(&ash->count) == 1 && !to_write)
+							continue;   // we'll release it shortly, so it's OK (?)
+
+						// is this stripe active, and within the region we're expanding?
+						if (atomic_read(&ash->count) > 0 &&
+						    ash->disks == conf->previous_raid_disks &&
+						    ash->sector >= first_touched_sector &&
+						    ash->sector <= last_touched_sector) {
+							activity = 1;
+							break;
+						}
+					}
+				}
+				
+				if (activity) {
+					printk("Aborting, active stripes in the area\n");
+					spin_unlock_irq(&conf->device_lock);
+					goto please_wait;
+				}
+			}
+
+			/*
+			 * Check that we have enough free stripes to write out our
+			 * entire chunk in the new layout. If not, we'll have to wait
+			 * until some writes have been retired. We can't just do
+			 * as in get_active_stripe() and sleep here until enough are
+			 * free, since all busy stripes might have STRIPE_HANDLE set
+			 * and thus won't be retired until somebody (our thread!) takes
+			 * care of them.
+			 */	
+			
+			{
+				int not_enough_free = 0;
+				
+				for (i = 0; i < conf->chunk_size / STRIPE_SIZE; ++i) {
+					newsh[i] = get_free_stripe(conf, 1);
+					if (newsh[i] == NULL) {
+						not_enough_free = 1;
+						break;
+					}
+					init_stripe(newsh[i], dest_sector + i * STRIPE_SECTORS, pd_idx);		
+				}
+
+				if (not_enough_free) {
+					// release all the stripes we allocated
+					for (i = 0; i < conf->chunk_size / STRIPE_SIZE; ++i) {
+						if (newsh[i] == NULL)
+							break;
+						atomic_inc(&newsh[i]->count);
+						__release_stripe(conf, newsh[i]);
+					}
+					printk("Aborting, not enough destination stripes free\n");
+					spin_unlock_irq(&conf->device_lock);
+					goto please_wait;
+				}
+			}
+
+			for (i = 0; i < conf->chunk_size / STRIPE_SIZE; ++i) {
+				for (d = 0; d < conf->raid_disks; ++d) {
+					unsigned dd_idx = d;
+					
+					if (d != pd_idx) {
+						if (dd_idx > pd_idx)
+							--dd_idx;
+
+						memcpy(page_address(newsh[i]->dev[d].page), page_address(conf->expand_buffer[dd_idx * conf->chunk_size / STRIPE_SIZE + i].page), STRIPE_SIZE);
+					}
+					set_bit(R5_Wantwrite, &newsh[i]->dev[d].flags);
+					set_bit(R5_Syncio, &newsh[i]->dev[d].flags);
+				}
+			}
+			
+			for (i=0; i < (conf->raid_disks - 1) * (conf->chunk_size / STRIPE_SIZE); ++i) {
+				conf->expand_buffer[i].up_to_date = 0;
+			}
+
+			conf->expand_progress += advance;
+			
+			spin_unlock_irq(&conf->device_lock);
+			
+			for (i = 0; i < conf->chunk_size / STRIPE_SIZE; ++i) {
+				compute_parity(newsh[i], RECONSTRUCT_WRITE);
+					
+				atomic_inc(&newsh[i]->count);
+				set_bit(STRIPE_INSYNC, &newsh[i]->state);
+				set_bit(STRIPE_HANDLE, &newsh[i]->state);
+				release_stripe(newsh[i]);
+			}
+
+			spin_lock_irq(&conf->device_lock);
+			md_done_sync(conf->mddev, advance, 1);
+			wake_up(&conf->wait_for_expand_progress);
+			spin_unlock_irq(&conf->device_lock);
+
+//			md_sync_acct(conf->disks[0].rdev->bdev, STRIPE_SECTORS * (conf->raid_disks - 1));
+
+			// see if we have delayed data that we can process now
+			{			
+				struct list_head *l, *next;
+				
+				spin_lock_irq(&conf->device_lock);
+				l = conf->wait_for_expand_list.next;
+
+//				printk("printing delay list:\n");
+				while (l != &conf->wait_for_expand_list) {
+					int i, d = 0;
+					int do_process = 0;
+					
+					struct stripe_head *dsh;
+					dsh = list_entry(l, struct stripe_head, lru);
+//					printk("sector: %llu\n", dsh->sector);
+					
+					for (i=0; i<disks; ++i) {
+						sector_t start_sector, dest_sector;
+						unsigned int dd_idx, pd_idx;
+
+						if (i == dsh->pd_idx)
+							continue;
+
+						start_sector = dsh->sector * (conf->previous_raid_disks - 1) + d * (conf->chunk_size >> 9);
+
+						// see what sector this block would land in in the new layout
+						dest_sector = raid5_compute_sector(start_sector, conf->raid_disks,
+								conf->raid_disks - 1, &dd_idx, &pd_idx, conf);
+						if (/*dest_sector * (conf->raid_disks - 1) >= conf->expand_progress &&*/
+						    dest_sector * (conf->raid_disks - 1) <  conf->expand_progress + (conf->raid_disks - 1) * (conf->chunk_size >> 9)) {
+							do_process = 1;
+						}
+
+						++d;
+					}
+					
+					next = l->next;
+					
+					if (do_process) {
+						list_del_init(l);
+
+						set_bit(STRIPE_HANDLE, &dsh->state);
+						clear_bit(STRIPE_DELAYED, &dsh->state);
+						clear_bit(STRIPE_DELAY_EXPAND, &dsh->state);
+						atomic_inc(&dsh->count);
+						atomic_inc(&dsh->count);
+						printk("pulling in stuff from delayed, sector=%llu\n",
+							dsh->sector);
+						__release_stripe(conf, dsh);
+					} else {
+						printk("still there\n");
+					}
+
+					l = next;
+				}
+
+				spin_unlock_irq(&conf->device_lock);
+			}
+
+			// see if we are done
+			if (conf->expand_progress >= conf->mddev->array_size << 1) {
+				printk("expand done, waiting for last activity to settle...\n");
+//				conf->mddev->raid_disks = conf->raid_disks;
+//				raid5_resize(conf->mddev, conf->mddev->size << 1);
+				conf->expand_in_progress = 2;
+			}
+
+please_wait:			
+			1;
+		}
+
+		if (delay_to_future) { // && atomic_dec_and_test(&sh->count)) {
+			set_bit(STRIPE_DELAY_EXPAND, &sh->state);
+		}
+	}
+
 	/* now to consider writing and what else, if anything should be read */
 	if (to_write) {
 		int rmw=0, rcw=0;
@@ -1237,7 +1721,9 @@
 		}
 	}
 	if (syncing && locked == 0 && test_bit(STRIPE_INSYNC, &sh->state)) {
-		md_done_sync(conf->mddev, STRIPE_SECTORS,1);
+		if (!conf->expand_in_progress) {
+			md_done_sync(conf->mddev, STRIPE_SECTORS,1);
+		}
 		clear_bit(STRIPE_SYNCING, &sh->state);
 	}
 	
@@ -1279,7 +1765,7 @@
 		rcu_read_unlock();
  
 		if (rdev) {
-			if (test_bit(R5_Syncio, &sh->dev[i].flags))
+			if (test_bit(R5_Syncio, &sh->dev[i].flags) && !conf->expand_in_progress)
 				md_sync_acct(rdev->bdev, STRIPE_SECTORS);
 
 			bi->bi_bdev = rdev->bdev;
@@ -1427,9 +1913,18 @@
 		md_write_start(mddev);
 	for (;logical_sector < last_sector; logical_sector += STRIPE_SECTORS) {
 		DEFINE_WAIT(w);
+		int disks;
 		
-		new_sector = raid5_compute_sector(logical_sector,
-						  raid_disks, data_disks, &dd_idx, &pd_idx, conf);
+	recalculate:		
+		if (conf->expand_in_progress && logical_sector >= conf->expand_progress) {
+			new_sector = raid5_compute_sector(logical_sector,
+				conf->previous_raid_disks, conf->previous_raid_disks - 1, &dd_idx, &pd_idx, conf);
+			disks = conf->previous_raid_disks;
+		} else {
+			new_sector = raid5_compute_sector(logical_sector,
+				 raid_disks, data_disks, &dd_idx, &pd_idx, conf);
+			disks = conf->raid_disks;
+		}
 
 		PRINTK("raid5: make_request, sector %llu logical %llu\n",
 			(unsigned long long)new_sector, 
@@ -1438,15 +1933,21 @@
 	retry:
 		prepare_to_wait(&conf->wait_for_overlap, &w, TASK_UNINTERRUPTIBLE);
 		sh = get_active_stripe(conf, new_sector, pd_idx, (bi->bi_rw&RWA_MASK));
-		if (sh) {
-			if (!add_stripe_bio(sh, bi, dd_idx, (bi->bi_rw&RW_MASK))) {
+		if (sh) {			
+			if (sh->disks != disks || !add_stripe_bio(sh, bi, dd_idx, (bi->bi_rw&RW_MASK))) {
 				/* Add failed due to overlap.  Flush everything
 				 * and wait a while
 				 */
 				raid5_unplug_device(mddev->queue);
 				release_stripe(sh);
 				schedule();
-				goto retry;
+				if (sh->disks != disks) {
+					// just expanded past this point! re-process using the new structure
+					printk("recalculate!\n");
+					finish_wait(&conf->wait_for_overlap, &w);
+					goto recalculate;
+				} else
+					goto retry;
 			}
 			finish_wait(&conf->wait_for_overlap, &w);
 			raid5_plug_device(conf);
@@ -1488,6 +1989,13 @@
 	int raid_disks = conf->raid_disks;
 	int data_disks = raid_disks-1;
 
+	if (conf->expand_in_progress) {
+		raid_disks = conf->previous_raid_disks;
+		data_disks = raid_disks-1;
+	}
+
+	BUG_ON(data_disks == 0 || raid_disks == 0);
+	
 	if (sector_nr >= mddev->size <<1) {
 		/* just being told to finish up .. nothing much to do */
 		unplug_slaves(mddev);
@@ -1502,12 +2010,31 @@
 		md_done_sync(mddev, rv, 1);
 		return rv;
 	}
+	
+	/* if we're in an expand, we can't allow the process
+	 * to keep reading in stripes; we might not have enough buffer
+	 * space to keep it all in RAM.
+	 */
+	if (conf->expand_in_progress && sector_nr >= conf->expand_progress + (conf->chunk_size >> 9) * (conf->raid_disks - 1)) {
+		spin_lock_irq(&conf->device_lock);
+		wait_event_lock_irq(conf->wait_for_expand_progress,
+			    sector_nr < conf->expand_progress + (conf->chunk_size >> 9) * (conf->raid_disks - 1),
+			    conf->device_lock,
+			    unplug_slaves(conf->mddev);
+		);
+		spin_unlock_irq(&conf->device_lock);
+	}
 
 	x = sector_nr;
 	chunk_offset = sector_div(x, sectors_per_chunk);
 	stripe = x;
 	BUG_ON(x != stripe);
-
+	
+	PRINTK("sync_request:%llu/%llu, %u+%u active, pr=%llu v. %llu\n", sector_nr, mddev->size<<1,
+		atomic_read(&conf->active_stripes), atomic_read(&conf->active_stripes_expand),
+		sector_nr,
+		conf->expand_progress + (conf->chunk_size >> 9) * (conf->raid_disks - 1)); 
+ 
 	first_sector = raid5_compute_sector((sector_t)stripe*data_disks*sectors_per_chunk
 		+ chunk_offset, raid_disks, data_disks, &dd_idx, &pd_idx, conf);
 	sh = get_active_stripe(conf, sector_nr, pd_idx, 1);
@@ -1553,6 +2080,8 @@
 	while (1) {
 		struct list_head *first;
 
+		conf = mddev_to_conf(mddev);
+
 		if (list_empty(&conf->handle_list) &&
 		    atomic_read(&conf->preread_active_stripes) < IO_THRESHOLD &&
 		    !blk_queue_plugged(mddev->queue) &&
@@ -1650,6 +2179,7 @@
 	conf->level = mddev->level;
 	conf->algorithm = mddev->layout;
 	conf->max_nr_stripes = NR_STRIPES;
+	conf->expand_in_progress = 0;
 
 	/* device size must be a multiple of chunk size */
 	mddev->size &= ~(mddev->chunk_size/1024 -1);
@@ -1691,7 +2221,7 @@
 	}
 memory = conf->max_nr_stripes * (sizeof(struct stripe_head) +
 		 conf->raid_disks * ((sizeof(struct bio) + PAGE_SIZE))) / 1024;
-	if (grow_stripes(conf, conf->max_nr_stripes)) {
+	if (grow_stripes(conf, conf->max_nr_stripes, 0)) {
 		printk(KERN_ERR 
 			"raid5: couldn't allocate %dkB for buffers\n", memory);
 		shrink_stripes(conf);
@@ -1767,8 +2297,8 @@
 
 	printk("sh %llu, pd_idx %d, state %ld.\n",
 		(unsigned long long)sh->sector, sh->pd_idx, sh->state);
-	printk("sh %llu,  count %d.\n",
-		(unsigned long long)sh->sector, atomic_read(&sh->count));
+	printk("sh %llu,  count %d, disks %d.\n",
+		(unsigned long long)sh->sector, atomic_read(&sh->count), sh->disks);
 	printk("sh %llu, ", (unsigned long long)sh->sector);
 	for (i = 0; i < sh->raid_conf->raid_disks; i++) {
 		printk("(cache%d: %p %ld) ", 
@@ -1865,6 +2395,9 @@
 	mdk_rdev_t *rdev;
 	struct disk_info *p = conf->disks + number;
 
+	printk("we were asked to remove a disk\n");
+	return -EBUSY;  // FIXME: hack
+	
 	print_raid5_conf(conf);
 	rdev = p->rdev;
 	if (rdev) {
@@ -1903,6 +2436,7 @@
 	 */
 	for (disk=0; disk < mddev->raid_disks; disk++)
 		if ((p=conf->disks + disk)->rdev == NULL) {
+			rdev->faulty = 0;
 			rdev->in_sync = 0;
 			rdev->raid_disk = disk;
 			found = 1;
@@ -1915,6 +2449,7 @@
 
 static int raid5_resize(mddev_t *mddev, sector_t sectors)
 {
+        raid5_conf_t *conf = mddev_to_conf(mddev);
 	/* no resync is happening, and there is enough space
 	 * on all devices, so we can resize.
 	 * We need to make sure resync covers any new space.
@@ -1922,6 +2457,9 @@
 	 * any io in the removed space completes, but it hardly seems
 	 * worth it.
 	 */
+	if (conf->expand_in_progress)
+		return -EBUSY;
+		
 	sectors &= ~((sector_t)mddev->chunk_size/512 - 1);
 	mddev->array_size = (sectors * (mddev->raid_disks-1))>>1;
 	set_capacity(mddev->gendisk, mddev->array_size << 1);
@@ -1934,6 +2472,219 @@
 	return 0;
 }
 
+static int raid5_reshape(mddev_t *mddev, int raid_disks)
+{
+	raid5_conf_t *conf = mddev_to_conf(mddev);
+	raid5_conf_t *newconf;
+	struct list_head *tmp;
+	mdk_rdev_t *rdev;
+	unsigned long flags;
+
+	int d, i;
+
+	if (mddev->degraded >= 1 || conf->expand_in_progress)
+		return -EBUSY;
+	
+	print_raid5_conf(conf);
+	
+	newconf = kmalloc (sizeof (raid5_conf_t)
+			+ raid_disks * sizeof(struct disk_info),
+			GFP_KERNEL);
+	if (newconf == NULL)
+		return -ENOMEM;	
+	
+	memset(newconf, 0, sizeof (raid5_conf_t) + raid_disks * sizeof(struct disk_info));
+	memcpy(newconf, conf, sizeof (raid5_conf_t) + conf->raid_disks * sizeof(struct disk_info));
+
+	newconf->expand_in_progress = 1;
+	newconf->expand_progress = 0;
+	newconf->raid_disks = mddev->raid_disks = raid_disks;	
+	newconf->previous_raid_disks = conf->raid_disks;	
+	
+	INIT_LIST_HEAD(&newconf->inactive_list_expand);
+	
+	
+	spin_lock_irqsave(&conf->device_lock, flags);
+	mddev->private = newconf;
+
+	printk("conf=%p newconf=%p\n", conf, newconf);
+	
+	if (newconf->handle_list.next)
+		newconf->handle_list.next->prev = &newconf->handle_list;
+	if (newconf->delayed_list.next)
+		newconf->delayed_list.next->prev = &newconf->delayed_list;
+	if (newconf->inactive_list.next)
+		newconf->inactive_list.next->prev = &newconf->inactive_list;
+
+	if (newconf->handle_list.prev == &conf->handle_list)
+		newconf->handle_list.prev = &newconf->handle_list;
+	if (newconf->delayed_list.prev == &conf->delayed_list)
+		newconf->delayed_list.prev = &newconf->delayed_list;
+	if (newconf->inactive_list.prev == &conf->inactive_list)
+		newconf->inactive_list.prev = &newconf->inactive_list;
+	
+	if (newconf->wait_for_stripe.task_list.prev == &conf->wait_for_stripe.task_list)
+		newconf->wait_for_stripe.task_list.prev = &newconf->wait_for_stripe.task_list;
+	if (newconf->wait_for_overlap.task_list.prev == &conf->wait_for_overlap.task_list)
+		newconf->wait_for_overlap.task_list.prev = &newconf->wait_for_overlap.task_list;
+	
+	init_waitqueue_head(&newconf->wait_for_stripe_expand);
+	init_waitqueue_head(&newconf->wait_for_expand_progress);
+	INIT_LIST_HEAD(&newconf->wait_for_expand_list);
+	
+	// update all the stripes
+	for (i = 0; i < NR_STRIPES; ++i) {
+		struct stripe_head *sh = newconf->stripe_hashtbl[i];
+		while (sh) {
+			sh->raid_conf = newconf;
+			
+			if (sh->lru.next == &conf->inactive_list)
+				sh->lru.next = &newconf->inactive_list;
+			if (sh->lru.next == &conf->handle_list)
+				sh->lru.next = &newconf->handle_list;
+
+			sh = sh->hash_next;
+		}
+	}
+
+	// ...and all on the inactive queue
+	{
+		struct list_head *first = newconf->inactive_list.next;
+		
+		while (1) {
+			struct stripe_head *sh = list_entry(first, struct stripe_head, lru);
+			sh->raid_conf = newconf;
+		
+			if (sh->lru.next == &conf->inactive_list)
+				sh->lru.next = &newconf->inactive_list;
+			if (sh->lru.next == &conf->handle_list)
+				sh->lru.next = &newconf->handle_list;
+
+			if (first->next == &conf->inactive_list || first->next == &newconf->inactive_list) {
+				first->next = &newconf->inactive_list;
+				break;
+			}
+					
+			first = first->next;
+		};
+	}
+
+	// update the pointer for the other lists as well
+	{
+		struct list_head *first = &newconf->handle_list;
+		while (1) {
+			if (first->next == &conf->handle_list) {
+				first->next = &newconf->handle_list;
+				break;
+			}
+					
+			first = first->next;
+		};
+	}
+	{
+		struct list_head *first = &newconf->delayed_list;
+		while (1) {
+			if (first->next == &conf->delayed_list) {
+				first->next = &newconf->delayed_list;
+				break;
+			}
+					
+			first = first->next;
+		};
+	}
+	{
+		struct list_head *first = &newconf->wait_for_stripe.task_list;
+		while (1) {
+			if (first->next == &conf->wait_for_stripe.task_list) {
+				first->next = &newconf->wait_for_stripe.task_list;
+				break;
+			}
+					
+			first = first->next;
+		};
+	}
+	{
+		struct list_head *first = &newconf->wait_for_overlap.task_list;
+		while (1) {
+			if (first->next == &conf->wait_for_overlap.task_list) {
+				first->next = &newconf->wait_for_overlap.task_list;
+				break;
+			}
+					
+			first = first->next;
+		};
+	}
+	
+	ITERATE_RDEV(mddev,rdev,tmp) {
+		printk("disk: %p\n", rdev);
+		for (d= 0; d < newconf->raid_disks; d++) {
+			if (newconf->disks[d].rdev == rdev) {
+				goto already_there;
+			}
+		}
+
+		raid5_add_disk(mddev, rdev);
+		newconf->failed_disks++;
+		
+already_there:		
+		1;
+	}
+
+	// argh! we can't hold this lock while allocating memory
+	spin_unlock_irqrestore(&conf->device_lock, flags);
+	
+	// allocate new stripes
+	atomic_set(&newconf->active_stripes_expand, 0);
+	if (grow_stripes(newconf, newconf->max_nr_stripes, 1)) {
+		int memory = newconf->max_nr_stripes * (sizeof(struct stripe_head) +
+			newconf->raid_disks * ((sizeof(struct bio) + PAGE_SIZE))) / 1024;
+		printk(KERN_ERR "raid5: couldn't allocate %dkB for expand stripes\n", memory);
+		shrink_stripes(newconf);
+		kfree(newconf);
+		return -ENOMEM;
+	}
+
+	// and space for our temporary expansion buffers
+	newconf->expand_buffer = kmalloc (sizeof(struct expand_buf) * (conf->chunk_size / STRIPE_SIZE) * (raid_disks-1), GFP_KERNEL);
+	if (newconf->expand_buffer == NULL) {
+		printk(KERN_ERR "raid5: couldn't allocate %dkB for expand buffer\n",
+			(conf->chunk_size * (raid_disks-1)) >> 10);
+		shrink_stripes(newconf);
+		kfree(newconf);
+		return -ENOMEM;
+	}
+	
+	for (i = 0; i < (conf->chunk_size / STRIPE_SIZE) * (raid_disks-1); ++i) {
+		newconf->expand_buffer[i].page = alloc_page(GFP_KERNEL);
+		if (newconf->expand_buffer[i].page == NULL) {
+			printk(KERN_ERR "raid5: couldn't allocate %dkB for expand buffer\n",
+				(conf->chunk_size * (raid_disks-1)) >> 10);
+			shrink_stripes(newconf);
+			kfree(newconf);
+			return -ENOMEM;
+		}
+		newconf->expand_buffer[i].up_to_date = 0;
+	}
+	
+	spin_lock_irqsave(&conf->device_lock, flags);
+	
+	print_raid5_conf(newconf);
+
+	clear_bit(MD_RECOVERY_DONE, &mddev->recovery);
+	set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
+	set_bit(MD_RECOVERY_SYNC, &mddev->recovery);
+	mddev->recovery_cp = 0;
+	md_wakeup_thread(mddev->thread);
+	spin_unlock_irqrestore(&conf->device_lock, flags);
+
+	kfree(conf);
+
+	printk("Starting expand.\n");
+	
+        return 0;
+}
+
+
 static mdk_personality_t raid5_personality=
 {
 	.name		= "raid5",
@@ -1948,6 +2699,7 @@
 	.spare_active	= raid5_spare_active,
 	.sync_request	= sync_request,
 	.resize		= raid5_resize,
+	.reshape	= raid5_reshape
 };
 
 static int __init raid5_init (void)

--Nq2Wo0NMKNjxTN9z--
