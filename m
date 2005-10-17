From: "Steinar H. Gunderson" <sgunderson@bigfoot.com>
Subject: Re: [PATCH] Online RAID-5 resizing
Date: Mon, 17 Oct 2005 02:16:37 +0200
Message-ID: <20051017001637.GA15231@samfundet.no>
References: <20050920143346.GA5777@uio.no> <17200.9302.242957.23189@cse.unsw.edu.au> <20050920153622.GA14287@uio.no> <17202.55529.310871.877019@cse.unsw.edu.au> <20050924014412.GA19832@uio.no> <17221.59105.846162.739316@cse.unsw.edu.au> <20051014194621.GA31390@uio.no> <17234.55921.769147.227160@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="envbJBWh7q8WU6mo"
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <17234.55921.769147.227160@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--envbJBWh7q8WU6mo
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

[My mail setup is somewhat broken due to a fried CPU (odd accident involving
 multiple buggy BIOSes), I hope this gets correctly through :-)]

On Mon, Oct 17, 2005 at 08:55:45AM +1000, Neil Brown wrote:
> Half the size sounds like a great step forward!! :-)
> I'll have a close look at all the code sometime today and get back to
> you with any comments.

Here's another version with a few minor (but important) bug fixes. Also, I
removed the “delay stripes” code, as it doesn't look like it's ever used or
needed anymore.

I still see data corruption from time to time, though, and sometimes the
other odd crash (and deadlocks on _something_ holding the mddev semaphore
forever; haven't seen that one in a while, though). I'm a bit unsure as of
what could cause it, but it only seems to happen on I/O, and I think I
reduced a bit with one of the fixes. (The current stripe could have R5_LOCKED
buffers but not have dev->towrite, and I didn't take that into account, so I
could be expanding over an area with one still-dirty stripe referring to it
and thus “leak” a stripe, causing problems.)

I think I want to move the entire restripe logic to the very bottom of
handle_stripe(), that might solve a few problems. Will have to wait for
another day when I get a replacement CPU in, though :-)

/* Steinar */
-- 
Homepage: http://www.sesse.net/


--envbJBWh7q8WU6mo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="raid5-online-exp-06.diff"

--- /usr/src/old/linux-2.6.13/drivers/md/raid5.c	2005-08-29 01:41:01.000000000 +0200
+++ drivers/md/raid5.c	2005-10-16 18:20:39.000000000 +0200
@@ -68,9 +68,18 @@
 #endif
 
 static void print_raid5_conf (raid5_conf_t *conf);
+#if RADI5_DEBUG
+static void print_sh (struct stripe_head *sh);
+#endif
+static sector_t sync_request(mddev_t *mddev, sector_t sector_nr, int *skipped, int go_faster);
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
@@ -133,7 +142,7 @@ static __inline__ void insert_hash(raid5
 
 
 /* find an idle stripe, make sure it is unhashed, and return it. */
-static struct stripe_head *get_free_stripe(raid5_conf_t *conf)
+static struct stripe_head *get_free_stripe(raid5_conf_t *conf, int expand)
 {
 	struct stripe_head *sh = NULL;
 	struct list_head *first;
@@ -146,6 +155,12 @@ static struct stripe_head *get_free_stri
 	list_del_init(first);
 	remove_hash(sh);
 	atomic_inc(&conf->active_stripes);
+
+	if (expand || !conf->expand_in_progress)
+		sh->disks = conf->raid_disks;
+	else
+		sh->disks = conf->previous_raid_disks;
+
 out:
 	return sh;
 }
@@ -184,7 +199,7 @@ static void raid5_build_block (struct st
 static inline void init_stripe(struct stripe_head *sh, sector_t sector, int pd_idx)
 {
 	raid5_conf_t *conf = sh->raid_conf;
-	int disks = conf->raid_disks, i;
+	int i;
 
 	if (atomic_read(&sh->count) != 0)
 		BUG();
@@ -200,8 +215,14 @@ static inline void init_stripe(struct st
 	sh->sector = sector;
 	sh->pd_idx = pd_idx;
 	sh->state = 0;
+	
+	if (conf->expand_in_progress && sector * (conf->raid_disks - 1) >= conf->expand_progress) {
+		sh->disks = conf->previous_raid_disks;
+	} else {
+		sh->disks = conf->raid_disks;
+	}
 
-	for (i=disks; i--; ) {
+	for (i=sh->disks; i--; ) {
 		struct r5dev *dev = &sh->dev[i];
 
 		if (dev->toread || dev->towrite || dev->written ||
@@ -245,9 +266,29 @@ static struct stripe_head *get_active_st
 
 	do {
 		sh = __find_stripe(conf, sector);
+
+		// make sure this is of the right size; if not, remove it from the hash
+		// FIXME: is this needed now?
+		if (sh) {
+			int correct_disks = conf->raid_disks;
+			if (conf->expand_in_progress && sector * (conf->raid_disks - 1) >= conf->expand_progress) {
+				correct_disks = conf->previous_raid_disks;
+			}
+
+			if (sh->disks != correct_disks) {
+				BUG_ON(atomic_read(&sh->count) != 0);
+
+				printk("get_stripe %llu with different number of disks (%u, should be %u)\n",
+					sector, sh->disks, correct_disks);
+
+				remove_hash(sh);
+				sh = NULL;
+			}
+		}
+		
 		if (!sh) {
 			if (!conf->inactive_blocked)
-				sh = get_free_stripe(conf);
+				sh = get_free_stripe(conf, 1);
 			if (noblock && sh == NULL)
 				break;
 			if (!sh) {
@@ -303,6 +344,7 @@ static int grow_stripes(raid5_conf_t *co
 			return 1;
 		memset(sh, 0, sizeof(*sh) + (devs-1)*sizeof(struct r5dev));
 		sh->raid_conf = conf;
+		sh->disks = conf->raid_disks;
 		spin_lock_init(&sh->lock);
 
 		if (grow_buffers(sh, conf->raid_disks)) {
@@ -325,7 +367,7 @@ static void shrink_stripes(raid5_conf_t 
 
 	while (1) {
 		spin_lock_irq(&conf->device_lock);
-		sh = get_free_stripe(conf);
+		sh = get_free_stripe(conf, 0);
 		spin_unlock_irq(&conf->device_lock);
 		if (!sh)
 			break;
@@ -344,7 +386,7 @@ static int raid5_end_read_request (struc
 {
  	struct stripe_head *sh = bi->bi_private;
 	raid5_conf_t *conf = sh->raid_conf;
-	int disks = conf->raid_disks, i;
+	int disks = sh->disks, i;
 	int uptodate = test_bit(BIO_UPTODATE, &bi->bi_flags);
 
 	if (bi->bi_size)
@@ -411,12 +453,60 @@ static int raid5_end_read_request (struc
 	return 0;
 }
 
+							
+static void raid5_finish_expand (raid5_conf_t *conf)
+{
+	int i;
+	struct disk_info *tmp;
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
+	conf->expand_in_progress = 0;
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
 
@@ -570,7 +660,7 @@ static sector_t raid5_compute_sector(sec
 static sector_t compute_blocknr(struct stripe_head *sh, int i)
 {
 	raid5_conf_t *conf = sh->raid_conf;
-	int raid_disks = conf->raid_disks, data_disks = raid_disks - 1;
+	int raid_disks = sh->disks, data_disks = raid_disks - 1;
 	sector_t new_sector = sh->sector, check;
 	int sectors_per_chunk = conf->chunk_size >> 9;
 	sector_t stripe;
@@ -605,7 +695,8 @@ static sector_t compute_blocknr(struct s
 
 	check = raid5_compute_sector (r_sector, raid_disks, data_disks, &dummy1, &dummy2, conf);
 	if (check != sh->sector || dummy1 != dd_idx || dummy2 != sh->pd_idx) {
-		printk("compute_blocknr: map not correct\n");
+		printk("compute_blocknr: map not correct (%llu,%u,%u vs. %llu,%u,%u) disks=%u offset=%u virtual_dd=%u\n",
+				check, dummy1, dummy2, sh->sector, dd_idx, sh->pd_idx, sh->disks, chunk_offset, i);
 		return 0;
 	}
 	return r_sector;
@@ -671,8 +762,7 @@ static void copy_data(int frombio, struc
 
 static void compute_block(struct stripe_head *sh, int dd_idx)
 {
-	raid5_conf_t *conf = sh->raid_conf;
-	int i, count, disks = conf->raid_disks;
+	int i, count, disks = sh->disks;
 	void *ptr[MAX_XOR_BLOCKS], *p;
 
 	PRINTK("compute_block, stripe %llu, idx %d\n", 
@@ -702,7 +792,7 @@ static void compute_block(struct stripe_
 static void compute_parity(struct stripe_head *sh, int method)
 {
 	raid5_conf_t *conf = sh->raid_conf;
-	int i, pd_idx = sh->pd_idx, disks = conf->raid_disks, count;
+	int i, pd_idx = sh->pd_idx, disks = sh->disks, count;
 	void *ptr[MAX_XOR_BLOCKS];
 	struct bio *chosen;
 
@@ -880,7 +970,7 @@ static int add_stripe_bio(struct stripe_
 static void handle_stripe(struct stripe_head *sh)
 {
 	raid5_conf_t *conf = sh->raid_conf;
-	int disks = conf->raid_disks;
+	int disks = sh->disks;
 	struct bio *return_bi= NULL;
 	struct bio *bi;
 	int i;
@@ -945,19 +1035,20 @@ static void handle_stripe(struct stripe_
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
@@ -1012,7 +1103,7 @@ static void handle_stripe(struct stripe_
 		}
 		spin_unlock_irq(&conf->device_lock);
 	}
-	if (failed > 1 && syncing) {
+	if (failed > 1 && syncing && !conf->expand_in_progress) {
 		md_done_sync(conf->mddev, STRIPE_SECTORS,0);
 		clear_bit(STRIPE_SYNCING, &sh->state);
 		syncing = 0;
@@ -1093,7 +1184,7 @@ static void handle_stripe(struct stripe_
 					locked++;
 					PRINTK("Reading block %d (sync=%d)\n", 
 						i, syncing);
-					if (syncing)
+					if (syncing && !conf->expand_in_progress)
 						md_sync_acct(conf->disks[i].rdev->bdev,
 							     STRIPE_SECTORS);
 				}
@@ -1102,6 +1193,193 @@ static void handle_stripe(struct stripe_
 		set_bit(STRIPE_HANDLE, &sh->state);
 	}
 
+	// see if we have the data we need to expand by another block
+	if (conf->expand_in_progress && sh->disks == conf->previous_raid_disks) {
+		int uptodate = 0, d = 0, needed_uptodate = 0;
+		spin_lock_irq(&conf->expand_progress_lock);
+		for (i=0; i<disks; ++i) {
+			sector_t start_sector, dest_sector;
+			unsigned int dd_idx, pd_idx;
+
+			if (i == sh->pd_idx)
+				continue;
+
+			// see what sector this block would land in the new layout
+			start_sector = compute_blocknr(sh, i);
+			dest_sector = raid5_compute_sector(start_sector, conf->raid_disks,
+				conf->raid_disks - 1, &dd_idx, &pd_idx, conf);
+			if (dd_idx > pd_idx)
+				--dd_idx;
+
+			if (dest_sector * (conf->raid_disks - 1) >= conf->expand_progress &&
+ 			    dest_sector * (conf->raid_disks - 1) <  conf->expand_progress + (conf->chunk_size >> 9) * (conf->raid_disks - 1)) {
+				unsigned int ind = (start_sector - conf->expand_progress) / STRIPE_SECTORS;
+				if (test_bit(R5_UPTODATE, &sh->dev[i].flags)) {
+					memcpy(page_address(conf->expand_buffer[ind].page), page_address(sh->dev[i].page), STRIPE_SIZE);
+					conf->expand_buffer[ind].up_to_date = 1;
+				} else {
+					conf->expand_buffer[ind].up_to_date = 0;
+				}
+			}
+		}
+
+		for (i=0; i < (conf->raid_disks - 1) * (conf->chunk_size / STRIPE_SIZE); ++i) {
+			uptodate += conf->expand_buffer[i].up_to_date;
+		}
+		spin_unlock_irq(&conf->expand_progress_lock);
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
+		}
+		if (needed_uptodate > 0 && uptodate == needed_uptodate && conf->expand_stripes_ready == 1) {
+			// we can do an expand!
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
+			// find the parity disk and starting sector
+			dest_sector = raid5_compute_sector(conf->expand_progress, conf->raid_disks,
+				conf->raid_disks - 1, &dummy1, &pd_idx, conf);
+		
+			spin_lock_irq(&conf->device_lock);
+			
+			if (conf->expand_stripes_ready != 1) {
+				// something else just did the expand, we're done here
+				spin_unlock_irq(&conf->device_lock);
+				goto please_wait;
+			}
+			
+			/*
+			 * Check that we won't try to move an area where there's
+			 * still active stripes; if we do, we'll risk inconsistency since we
+			 * suddenly have two different sets of stripes referring to the
+			 * same logical sector.
+			 */
+			{
+				struct stripe_head *ash;
+				unsigned activity = 0, i;
+				sector_t first_touched_sector, last_touched_sector;
+				
+				first_touched_sector = raid5_compute_sector(conf->expand_progress,
+					conf->previous_raid_disks, conf->previous_raid_disks - 1, &dummy1, &dummy2, conf);
+				last_touched_sector = raid5_compute_sector(conf->expand_progress + ((conf->chunk_size * (conf->raid_disks - 1)) >> 9) - 1,
+					conf->previous_raid_disks, conf->previous_raid_disks - 1, &dummy1, &dummy2, conf);
+
+				for (i = 0; i < NR_HASH; i++) {
+					ash = conf->stripe_hashtbl[i];
+					for (; ash; ash = ash->hash_next) {
+						if (sh == ash && atomic_read(&ash->count) == 1 && !to_write && !locked)
+							continue;   // we'll release it shortly, so it's OK (?)
+
+						// is this stripe active, and within the region we're expanding?
+						if (atomic_read(&ash->count) > 0 &&
+						    ash->disks == conf->previous_raid_disks &&
+						    ash->sector >= first_touched_sector &&
+						    ash->sector <= last_touched_sector) {
+							++activity;
+						}
+					}
+				}
+				
+				if (activity > 0) {
+					printk("Aborting, %u active stripes in the area\n", activity);
+					spin_unlock_irq(&conf->device_lock);
+					goto please_wait;
+				}
+			}
+			
+			spin_lock(&conf->expand_progress_lock);
+			conf->expand_progress += advance;
+
+			for (i = 0; i < conf->chunk_size / STRIPE_SIZE; ++i) {
+				struct stripe_head *newsh = conf->expand_stripes[i];
+				if (atomic_read(&newsh->count) != 0)
+					BUG();
+				init_stripe(newsh, dest_sector + i * STRIPE_SECTORS, pd_idx);
+
+				for (d = 0; d < conf->raid_disks; ++d) {
+					if (d == pd_idx) {
+						clear_bit(R5_UPTODATE, &newsh->dev[d].flags);
+						clear_bit(R5_LOCKED, &newsh->dev[d].flags);
+					} else {
+						//struct page *tmp;
+						unsigned di;
+						
+						di = (compute_blocknr(newsh, d) - (conf->expand_progress - advance)) / STRIPE_SECTORS;
+						
+						// swap the two pages, moving the data in place into the stripe
+#if 0
+						// FIXME: this doesn't work. we'll need to fiddle with the bio_vec
+						// as well or we'll simply write out the wrong data.
+						tmp = newsh->dev[d].page;
+						newsh->dev[d].page = conf->expand_buffer[di].page;
+						conf->expand_buffer[di].page = tmp; 
+#else
+						memcpy(page_address(newsh->dev[d].page), page_address(conf->expand_buffer[di].page), STRIPE_SIZE);
+#endif
+					
+						set_bit(R5_UPTODATE, &newsh->dev[d].flags);
+						set_bit(R5_LOCKED, &newsh->dev[d].flags);
+						conf->expand_buffer[di].up_to_date = 0;
+					}
+					set_bit(R5_Wantwrite, &newsh->dev[d].flags);
+				}
+			}
+			conf->expand_stripes_ready = 2;	
+			spin_unlock(&conf->expand_progress_lock);
+			spin_unlock_irq(&conf->device_lock);
+			
+			for (i = 0; i < conf->chunk_size / STRIPE_SIZE; ++i) {
+				struct stripe_head *newsh = conf->expand_stripes[i];
+				
+				compute_block(newsh, newsh->pd_idx);
+
+				spin_lock(&newsh->lock);
+				atomic_inc(&newsh->count);
+				clear_bit(STRIPE_SYNCING, &newsh->state);
+				set_bit(STRIPE_INSYNC, &newsh->state);
+				set_bit(STRIPE_HANDLE, &newsh->state);
+				spin_unlock(&newsh->lock);
+#if 0
+				printk("Releasing stripe %u (%u disks)\n", i, newsh->disks);
+				for (d = 0; d < conf->raid_disks; ++d) {
+					unsigned int *ptr = page_address(newsh->dev[d].page);
+					printk("%u: %08x %08x %08x %08x\n", d, ptr[0], ptr[1], ptr[2], ptr[3]);
+				}
+#endif
+				release_stripe(newsh);
+			}
+			
+			conf->expand_stripes_ready = 0;	
+
+			md_done_sync(conf->mddev, advance, 1);
+			wake_up(&conf->wait_for_expand_progress);
+
+			// see if we are done
+			if (conf->expand_progress >= conf->mddev->array_size << 1) {
+				printk("Expand done, finishing...\n");
+				raid5_finish_expand(conf);
+				printk("...done.\n");
+			}
+
+please_wait:			
+			1;
+		}
+	}
+
 	/* now to consider writing and what else, if anything should be read */
 	if (to_write) {
 		int rmw=0, rcw=0;
@@ -1237,7 +1515,9 @@ static void handle_stripe(struct stripe_
 		}
 	}
 	if (syncing && locked == 0 && test_bit(STRIPE_INSYNC, &sh->state)) {
-		md_done_sync(conf->mddev, STRIPE_SECTORS,1);
+		if (!conf->expand_in_progress) {
+			md_done_sync(conf->mddev, STRIPE_SECTORS,1);
+		}
 		clear_bit(STRIPE_SYNCING, &sh->state);
 	}
 	
@@ -1279,7 +1559,7 @@ static void handle_stripe(struct stripe_
 		rcu_read_unlock();
  
 		if (rdev) {
-			if (test_bit(R5_Syncio, &sh->dev[i].flags))
+			if (test_bit(R5_Syncio, &sh->dev[i].flags) && !conf->expand_in_progress)
 				md_sync_acct(rdev->bdev, STRIPE_SECTORS);
 
 			bi->bi_bdev = rdev->bdev;
@@ -1404,8 +1684,6 @@ static int make_request (request_queue_t
 {
 	mddev_t *mddev = q->queuedata;
 	raid5_conf_t *conf = mddev_to_conf(mddev);
-	const unsigned int raid_disks = conf->raid_disks;
-	const unsigned int data_disks = raid_disks - 1;
 	unsigned int dd_idx, pd_idx;
 	sector_t new_sector;
 	sector_t logical_sector, last_sector;
@@ -1428,18 +1706,55 @@ static int make_request (request_queue_t
 
 	for (;logical_sector < last_sector; logical_sector += STRIPE_SECTORS) {
 		DEFINE_WAIT(w);
+		int disks;
 		
+	retry:
+		disks = conf->raid_disks;
+		if (conf->expand_in_progress) {
+			spin_lock_irq(&conf->expand_progress_lock);
+			if (logical_sector >= conf->expand_progress) {
+				disks = conf->previous_raid_disks;
+			}
+			spin_unlock_irq(&conf->expand_progress_lock);
+		}
 		new_sector = raid5_compute_sector(logical_sector,
-						  raid_disks, data_disks, &dd_idx, &pd_idx, conf);
-
+			disks, disks - 1, &dd_idx, &pd_idx, conf);	
 		PRINTK("raid5: make_request, sector %llu logical %llu\n",
 			(unsigned long long)new_sector, 
 			(unsigned long long)logical_sector);
 
-	retry:
 		prepare_to_wait(&conf->wait_for_overlap, &w, TASK_UNINTERRUPTIBLE);
 		sh = get_active_stripe(conf, new_sector, pd_idx, (bi->bi_rw&RWA_MASK));
 		if (sh) {
+			/*
+			 * At this point, our stripe is active and _will_ get
+			 * counted by handle_stripe() if it decides to do an
+			 * expand (which will delay it if that overlaps over
+			 * us). However, we also need to check that there
+			 * wasn't an expand happening while we waited for our
+			 * stripe in get_active_stripe() (or one is in progress
+			 * right now).
+			 */
+			if (conf->expand_in_progress) {
+				int new_disks;
+
+				spin_lock(&conf->expand_progress_lock);
+
+				// recalculate what side we are on
+				if (logical_sector >= conf->expand_progress) {
+					new_disks = conf->previous_raid_disks;
+				} else {
+					new_disks = conf->raid_disks;
+				}
+
+				spin_unlock(&conf->expand_progress_lock);
+				
+				if (disks != new_disks || sh->disks != disks) {
+					printk("progressed\n");
+					release_stripe(sh);
+					goto retry;
+				}
+			}
 			if (!add_stripe_bio(sh, bi, dd_idx, (bi->bi_rw&RW_MASK))) {
 				/* Add failed due to overlap.  Flush everything
 				 * and wait a while
@@ -1488,7 +1803,14 @@ static sector_t sync_request(mddev_t *md
 	sector_t first_sector;
 	int raid_disks = conf->raid_disks;
 	int data_disks = raid_disks-1;
+	
+	if (conf->expand_in_progress) {
+		raid_disks = conf->previous_raid_disks;
+		data_disks = raid_disks-1;
+	}
 
+	BUG_ON(data_disks == 0 || raid_disks == 0);
+	
 	if (sector_nr >= mddev->size <<1) {
 		/* just being told to finish up .. nothing much to do */
 		unplug_slaves(mddev);
@@ -1503,6 +1825,51 @@ static sector_t sync_request(mddev_t *md
 		*skipped = 1;
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
+
+	/*
+	 * In an expand, we also need to make sure that we have enough destination stripes
+	 * available for writing out the block after we've read in the data, so make sure
+	 * we get them before we start reading any data.
+	 */
+	if (conf->expand_in_progress && conf->expand_stripes_ready == 0) {
+		unsigned i;
+
+		spin_lock_irq(&conf->device_lock);
+		for (i = 0; i < conf->chunk_size / STRIPE_SIZE; ++i) {
+			do {
+				conf->expand_stripes[i] = get_free_stripe(conf, 1);
+
+				if (conf->expand_stripes[i] == NULL) {
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
+			} while (conf->expand_stripes[i] == NULL);
+		}
+		spin_unlock_irq(&conf->device_lock);
+
+		conf->expand_stripes_ready = 1;
+	}
 
 	x = sector_nr;
 	chunk_offset = sector_div(x, sectors_per_chunk);
@@ -1553,6 +1920,8 @@ static void raid5d (mddev_t *mddev)
 	while (1) {
 		struct list_head *first;
 
+		conf = mddev_to_conf(mddev);
+
 		if (list_empty(&conf->handle_list) &&
 		    atomic_read(&conf->preread_active_stripes) < IO_THRESHOLD &&
 		    !blk_queue_plugged(mddev->queue) &&
@@ -1600,7 +1969,7 @@ static int run (mddev_t *mddev)
 	}
 
 	mddev->private = kmalloc (sizeof (raid5_conf_t)
-				  + mddev->raid_disks * sizeof(struct disk_info),
+				  + MAX_MD_DEVS * sizeof(struct disk_info),
 				  GFP_KERNEL);
 	if ((conf = mddev->private) == NULL)
 		goto abort;
@@ -1650,6 +2019,7 @@ static int run (mddev_t *mddev)
 	conf->level = mddev->level;
 	conf->algorithm = mddev->layout;
 	conf->max_nr_stripes = NR_STRIPES;
+	conf->expand_in_progress = 0;
 
 	/* device size must be a multiple of chunk size */
 	mddev->size &= ~(mddev->chunk_size/1024 -1);
@@ -1866,6 +2236,9 @@ static int raid5_remove_disk(mddev_t *md
 	mdk_rdev_t *rdev;
 	struct disk_info *p = conf->disks + number;
 
+	printk("we were asked to remove a disk\n");
+	return -EBUSY;  // FIXME: hack
+	
 	print_raid5_conf(conf);
 	rdev = p->rdev;
 	if (rdev) {
@@ -1904,6 +2277,7 @@ static int raid5_add_disk(mddev_t *mddev
 	 */
 	for (disk=0; disk < mddev->raid_disks; disk++)
 		if ((p=conf->disks + disk)->rdev == NULL) {
+			rdev->faulty = 0;
 			rdev->in_sync = 0;
 			rdev->raid_disk = disk;
 			found = 1;
@@ -1916,6 +2290,7 @@ static int raid5_add_disk(mddev_t *mddev
 
 static int raid5_resize(mddev_t *mddev, sector_t sectors)
 {
+        raid5_conf_t *conf = mddev_to_conf(mddev);
 	/* no resync is happening, and there is enough space
 	 * on all devices, so we can resize.
 	 * We need to make sure resync covers any new space.
@@ -1923,6 +2298,9 @@ static int raid5_resize(mddev_t *mddev, 
 	 * any io in the removed space completes, but it hardly seems
 	 * worth it.
 	 */
+	if (conf->expand_in_progress)
+		return -EBUSY;
+		
 	sectors &= ~((sector_t)mddev->chunk_size/512 - 1);
 	mddev->array_size = (sectors * (mddev->raid_disks-1))>>1;
 	set_capacity(mddev->gendisk, mddev->array_size << 1);
@@ -1936,6 +2314,125 @@ static int raid5_resize(mddev_t *mddev, 
 	return 0;
 }
 
+static int raid5_reshape(mddev_t *mddev, int raid_disks)
+{
+	raid5_conf_t *conf = mddev_to_conf(mddev);
+	struct list_head *tmp;
+	mdk_rdev_t *rdev;
+	unsigned long flags;
+
+	int d, i;
+	
+	if (mddev->degraded >= 1 || conf->expand_in_progress)
+		return -EBUSY;
+	if (conf->raid_disks == raid_disks)
+		return 0;
+	
+	print_raid5_conf(conf);
+	
+	// the old stripes are too small now; remove them (temporarily
+	// stalling the RAID)
+	for (i = 0; i < conf->max_nr_stripes; ++i) {
+		struct stripe_head *sh;
+		
+		spin_lock_irqsave(&conf->device_lock, flags);
+		sh = get_free_stripe(conf, 0);
+		while (sh == NULL) {
+			wait_event_lock_irq(conf->wait_for_stripe,
+					!list_empty(&conf->inactive_list),
+					conf->device_lock,
+					unplug_slaves(conf->mddev);
+					);
+			sh = get_free_stripe(conf, 0);
+		}
+		spin_unlock_irqrestore(&conf->device_lock, flags);
+
+		shrink_buffers(sh, conf->raid_disks);
+		kmem_cache_free(conf->slab_cache, sh);
+		atomic_dec(&conf->active_stripes);
+	}	
+	kmem_cache_destroy(conf->slab_cache);
+	
+	spin_lock_irqsave(&conf->device_lock, flags);
+	
+	for (d= conf->raid_disks; d < MAX_MD_DEVS; d++) {
+		conf->disks[d].rdev = NULL;
+	}
+
+	conf->expand_progress = 0;
+	conf->previous_raid_disks = conf->raid_disks;	
+	conf->raid_disks = mddev->raid_disks = raid_disks;	
+
+	spin_lock_init(&conf->expand_progress_lock);
+	
+	init_waitqueue_head(&conf->wait_for_expand_progress);
+
+	ITERATE_RDEV(mddev,rdev,tmp) {
+		for (d= 0; d < conf->raid_disks; d++) {
+			if (conf->disks[d].rdev == rdev) {
+				goto already_there;
+			}
+		}
+
+		raid5_add_disk(mddev, rdev);
+		conf->failed_disks++;
+		
+already_there:		
+		1;
+	}
+
+	spin_unlock_irqrestore(&conf->device_lock, flags);
+	
+	// allocate space for our temporary expansion buffers
+	conf->expand_buffer = kmalloc (sizeof(struct expand_buf) * (conf->chunk_size / STRIPE_SIZE) * (raid_disks-1), GFP_KERNEL);
+	if (conf->expand_buffer == NULL) {
+		printk(KERN_ERR "raid5: couldn't allocate %dkB for expand buffer\n",
+			(conf->chunk_size * (raid_disks-1)) >> 10);
+		// FIXME
+		return -ENOMEM;
+	}
+
+	conf->expand_stripes = kmalloc (sizeof(struct stripe_head *) * (conf->chunk_size / STRIPE_SIZE), GFP_KERNEL);
+	if (conf->expand_stripes == NULL) {
+		printk(KERN_ERR "raid5: couldn't allocate memory for expand stripe pointers\n");
+		// FIXME
+		return -ENOMEM;
+	}
+	conf->expand_stripes_ready = 0;
+
+	for (i = 0; i < (conf->chunk_size / STRIPE_SIZE) * (raid_disks-1); ++i) {
+		conf->expand_buffer[i].page = alloc_page(GFP_KERNEL);
+		if (conf->expand_buffer[i].page == NULL) {
+			printk(KERN_ERR "raid5: couldn't allocate %dkB for expand buffer\n",
+					(conf->chunk_size * (raid_disks-1)) >> 10);
+			// FIXME
+			return -ENOMEM;
+		}
+		conf->expand_buffer[i].up_to_date = 0;
+	}
+	
+	conf->expand_in_progress = 1;
+	
+	// allocate stripes of the new size, and get the RAID going again
+	if (grow_stripes(conf, conf->max_nr_stripes)) {
+		BUG();  // FIXME
+		return -ENOMEM;
+	}	
+	
+	print_raid5_conf(conf);
+
+	clear_bit(MD_RECOVERY_DONE, &mddev->recovery);
+	set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
+	set_bit(MD_RECOVERY_SYNC, &mddev->recovery);
+	mddev->recovery_cp = 0;
+	md_wakeup_thread(mddev->thread);
+
+	printk("Starting expand.\n");
+	
+	return 0;
+}
+
+
 static mdk_personality_t raid5_personality=
 {
 	.name		= "raid5",
@@ -1950,6 +2447,7 @@ static mdk_personality_t raid5_personali
 	.spare_active	= raid5_spare_active,
 	.sync_request	= sync_request,
 	.resize		= raid5_resize,
+	.reshape	= raid5_reshape
 };
 
 static int __init raid5_init (void)
--- /usr/src/old/linux-2.6.13/include/linux/raid/raid5.h	2005-08-29 01:41:01.000000000 +0200
+++ include/linux/raid/raid5.h	2005-10-16 18:22:51.000000000 +0200
@@ -134,6 +134,7 @@ struct stripe_head {
 	unsigned long		state;			/* state flags */
 	atomic_t		count;			/* nr of active thread/requests */
 	spinlock_t		lock;
+	int			disks;			/* disks in stripe */
 	struct r5dev {
 		struct bio	req;
 		struct bio_vec	vec;
@@ -199,6 +200,10 @@ struct stripe_head {
 struct disk_info {
 	mdk_rdev_t	*rdev;
 };
+struct expand_buf {
+	struct page    	*page;
+	int		up_to_date;
+};
 
 struct raid5_private_data {
 	struct stripe_head	**stripe_hashtbl;
@@ -208,6 +213,17 @@ struct raid5_private_data {
 	int			raid_disks, working_disks, failed_disks;
 	int			max_nr_stripes;
 
+	/* used during an expand */
+	int			expand_in_progress;
+	sector_t		expand_progress;
+	spinlock_t		expand_progress_lock;
+	int			previous_raid_disks;
+	
+	struct expand_buf	*expand_buffer;
+	
+	int			expand_stripes_ready;	
+	struct stripe_head	**expand_stripes;
+
 	struct list_head	handle_list; /* stripes needing handling */
 	struct list_head	delayed_list; /* stripes that have plugged requests */
 	atomic_t		preread_active_stripes; /* stripes with scheduled io */
@@ -220,6 +236,7 @@ struct raid5_private_data {
 	atomic_t		active_stripes;
 	struct list_head	inactive_list;
 	wait_queue_head_t	wait_for_stripe;
+	wait_queue_head_t	wait_for_expand_progress;
 	wait_queue_head_t	wait_for_overlap;
 	int			inactive_blocked;	/* release of inactive stripes blocked,
 							 * waiting for 25% to be free

--envbJBWh7q8WU6mo--
