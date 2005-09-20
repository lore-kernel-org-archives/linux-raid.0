From: "Steinar H. Gunderson" <sgunderson@bigfoot.com>
Subject: [PATCH] Online RAID-5 resizing
Date: Tue, 20 Sep 2005 16:33:46 +0200
Message-ID: <20050920143346.GA5777@uio.no>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="k+w/mQv8wyuph6w0"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--k+w/mQv8wyuph6w0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

(Please Cc me on any replies, I'm not subscribed)

Hi,

Attached is a patch (against 2.6.12) for adding online RAID-5 resize
capabilities to Linux' RAID code. It needs to changes to mdadm (I've only
tested with mdadm 1.12.0, though), you can just do

  mdadm --add /dev/md1 /dev/hd[eg]1
  mdadm --grow /dev/md1 -n 4

and it will restripe /dev/md1; you can still use the volume just fine
during the expand process. (cat /proc/mdstat to get the progress; it will
look like a regular sync, and when the restripe is done the volume will
suddenly get larger and do a regular sync of the new parts.)

The patch is quite rough -- it's my first trip ever into the md code, the
block layer or really kernel code in general, so expect subtle race
conditions and problems here and there. :-) That being said, it seems to be
quite stable on my (SMP) test system now -- I would really take backups
before testing it, though! You have been warned :-)

Things still to do, off the top of my head:

- It's RAID-5 only; I don't really use RAID-0, and RAID-6 would probably be
  more complex.
- It supports only growing, not shrinking. (Not sure if I really care about
  fixing this one.)
- It leaks memory; it doesn't properly free up the old stripes etc. at the
  end of the resize. (This also makes it impossible to do a grow and then
  another grow without stopping and starting the volumes.)
- There is absolutely no crash recovery -- this shouldn't be so hard to do
  (just update the superblock every time, with some progress meter, and
  restart from that spot in case of a crash), but I have no knowledge of the
  on-disk superblock format at all, so some help would be appreciated here.
  Also, I'm not really sure what happens if it encounters a bad block during
  the restripe.
- It's quite slow; on my test system with old IDE disks, it achieves about
  1MB/sec. One could probably make a speed/memory tradeoff here, and move
  more chunks at a time instead of just one by one; I'm a bit concerned
  about the implications of the kernel allocating something like 64MB in one
  go, though :-)
  
Comments, patches, fixes etc. would be greatly appreciated. (Again, remember
to Cc me, I'm not on the list.)

/* Steinar */
-- 
Homepage: http://www.sesse.net/

--k+w/mQv8wyuph6w0
Content-Type: text/plain; charset=utf-8
Content-Disposition: attachment; filename="raid5-resize.patch"

diff -ur linux-2.6-2.6.12/drivers/md/raid5.c ../linux-2.6-2.6.12/drivers/md/raid5.c
--- linux-2.6-2.6.12/drivers/md/raid5.c	2005-06-17 21:48:29.000000000 +0200
+++ linux-2.6-2.6.12.patch/drivers/md/raid5.c	2005-09-20 00:13:55.000000000 +0200
@@ -68,19 +68,40 @@
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
+	PRINTK("__release_stripe, conf=%p\n", conf);
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
+//				printk("real-delay\n");
 				list_add_tail(&sh->lru, &conf->delayed_list);
-			else
+			} else {
 				list_add_tail(&sh->lru, &conf->handle_list);
+			}
 			md_wakeup_thread(conf->mddev->thread);
 		} else {
 			if (test_and_clear_bit(STRIPE_PREREAD_ACTIVE, &sh->state)) {
@@ -88,11 +109,34 @@
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
@@ -133,20 +177,44 @@
 
 
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
 
@@ -184,7 +252,7 @@
 static inline void init_stripe(struct stripe_head *sh, sector_t sector, int pd_idx)
 {
 	raid5_conf_t *conf = sh->raid_conf;
-	int disks = conf->raid_disks, i;
+	int disks = sh->disks, i;
 
 	if (atomic_read(&sh->count) != 0)
 		BUG();
@@ -245,21 +313,59 @@
 
 	do {
 		sh = __find_stripe(conf, sector);
+
+		// make sure this is of the right size; if not, remove it from the hash
+		if (sh) {
+			int correct_disks = conf->raid_disks;
+			if (conf->expand_in_progress && sector >= conf->expand_progress) {
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
@@ -267,8 +373,13 @@
 				if (!list_empty(&sh->lru))
 					BUG();
 			} else {
-				if (!test_bit(STRIPE_HANDLE, &sh->state))
-					atomic_inc(&conf->active_stripes);
+				if (!test_bit(STRIPE_HANDLE, &sh->state)) {
+					if (conf->expand_in_progress && sector < conf->expand_progress) {
+						atomic_inc(&conf->active_stripes_expand);
+					} else {
+						atomic_inc(&conf->active_stripes);
+					}
+				}
 				if (list_empty(&sh->lru))
 					BUG();
 				list_del_init(&sh->lru);
@@ -283,26 +394,34 @@
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
+		printk("alloc stripe: %p\n", sh);
 		memset(sh, 0, sizeof(*sh) + (devs-1)*sizeof(struct r5dev));
 		sh->raid_conf = conf;
+		sh->disks = conf->raid_disks;
 		spin_lock_init(&sh->lock);
 
 		if (grow_buffers(sh, conf->raid_disks)) {
@@ -312,10 +431,15 @@
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
+	printk("done growing\n");
 	return 0;
 }
 
@@ -325,7 +449,7 @@
 
 	while (1) {
 		spin_lock_irq(&conf->device_lock);
-		sh = get_free_stripe(conf);
+		sh = get_free_stripe(conf, 0);
 		spin_unlock_irq(&conf->device_lock);
 		if (!sh)
 			break;
@@ -344,7 +468,7 @@
 {
  	struct stripe_head *sh = bi->bi_private;
 	raid5_conf_t *conf = sh->raid_conf;
-	int disks = conf->raid_disks, i;
+	int disks = sh->disks, i;
 	int uptodate = test_bit(BIO_UPTODATE, &bi->bi_flags);
 
 	if (bi->bi_size)
@@ -393,6 +517,8 @@
 		set_bit(R5_UPTODATE, &sh->dev[i].flags);
 #endif		
 	} else {
+		printk("received non-up-to-date information for disk %u, sector %llu!\n",
+			i, sh->sector);
 		md_error(conf->mddev, conf->disks[i].rdev);
 		clear_bit(R5_UPTODATE, &sh->dev[i].flags);
 	}
@@ -411,12 +537,93 @@
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
+	// hey, mr. md code: we have more space now!
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
 
@@ -436,8 +643,11 @@
 	}
 
 	spin_lock_irqsave(&conf->device_lock, flags);
-	if (!uptodate)
+	if (!uptodate) {
+		printk("end_write_request ends with error, for disk %u sector %llu\n",
+			i, sh->sector);
 		md_error(conf->mddev, conf->disks[i].rdev);
+	}
 
 	rdev_dec_pending(conf->disks[i].rdev, conf->mddev);
 	
@@ -512,12 +722,14 @@
 	int sectors_per_chunk = conf->chunk_size >> 9;
 
 	/* First compute the information on this sector */
+	PRINTK("r_sector_inp=%llu\n", r_sector);
 
 	/*
 	 * Compute the chunk number and the sector offset inside the chunk
 	 */
 	chunk_offset = sector_div(r_sector, sectors_per_chunk);
 	chunk_number = r_sector;
+	PRINTK("r_sector=%llu, chunk_number=%lu\n", r_sector, chunk_number);
 	BUG_ON(r_sector != chunk_number);
 
 	/*
@@ -556,7 +768,7 @@
 			break;
 		default:
 			printk("raid5: unsupported algorithm %d\n",
-				conf->algorithm);
+					conf->algorithm);
 	}
 
 	/*
@@ -570,7 +782,7 @@
 static sector_t compute_blocknr(struct stripe_head *sh, int i)
 {
 	raid5_conf_t *conf = sh->raid_conf;
-	int raid_disks = conf->raid_disks, data_disks = raid_disks - 1;
+	int raid_disks = sh->disks, data_disks = raid_disks - 1;
 	sector_t new_sector = sh->sector, check;
 	int sectors_per_chunk = conf->chunk_size >> 9;
 	sector_t stripe;
@@ -582,7 +794,7 @@
 	stripe = new_sector;
 	BUG_ON(new_sector != stripe);
 
-	
+
 	switch (conf->algorithm) {
 		case ALGORITHM_LEFT_ASYMMETRIC:
 		case ALGORITHM_RIGHT_ASYMMETRIC:
@@ -597,7 +809,7 @@
 			break;
 		default:
 			printk("raid5: unsupported algorithm %d\n",
-				conf->algorithm);
+					conf->algorithm);
 	}
 
 	chunk_number = stripe * data_disks + i;
@@ -605,7 +817,8 @@
 
 	check = raid5_compute_sector (r_sector, raid_disks, data_disks, &dummy1, &dummy2, conf);
 	if (check != sh->sector || dummy1 != dd_idx || dummy2 != sh->pd_idx) {
-		printk("compute_blocknr: map not correct\n");
+		printk("compute_blocknr: map not correct (%llu,%u,%u vs. %llu,%u,%u) disks=%u offset=%u virtual_dd=%u\n",
+				check, dummy1, dummy2, sh->sector, dd_idx, sh->pd_idx, sh->disks, chunk_offset, i);
 		return 0;
 	}
 	return r_sector;
@@ -620,8 +833,8 @@
  * All iovecs in the bio must be considered.
  */
 static void copy_data(int frombio, struct bio *bio,
-		     struct page *page,
-		     sector_t sector)
+		struct page *page,
+		sector_t sector)
 {
 	char *pa = page_address(page);
 	struct bio_vec *bvl;
@@ -646,7 +859,7 @@
 		if (len > 0 && page_offset + len > STRIPE_SIZE)
 			clen = STRIPE_SIZE - page_offset;
 		else clen = len;
-			
+
 		if (clen > 0) {
 			char *ba = __bio_kmap_atomic(bio, i, KM_USER0);
 			if (frombio)
@@ -662,21 +875,21 @@
 }
 
 #define check_xor() 	do { 						\
-			   if (count == MAX_XOR_BLOCKS) {		\
-				xor_block(count, STRIPE_SIZE, ptr);	\
-				count = 1;				\
-			   }						\
-			} while(0)
+	if (count == MAX_XOR_BLOCKS) {		\
+		xor_block(count, STRIPE_SIZE, ptr);	\
+		count = 1;				\
+	}						\
+} while(0)
 
 
 static void compute_block(struct stripe_head *sh, int dd_idx)
 {
-	raid5_conf_t *conf = sh->raid_conf;
-	int i, count, disks = conf->raid_disks;
+	//	raid5_conf_t *conf = sh->raid_conf;
+	int i, count, disks = sh->disks;
 	void *ptr[MAX_XOR_BLOCKS], *p;
 
 	PRINTK("compute_block, stripe %llu, idx %d\n", 
-		(unsigned long long)sh->sector, dd_idx);
+			(unsigned long long)sh->sector, dd_idx);
 
 	ptr[0] = page_address(sh->dev[dd_idx].page);
 	memset(ptr[0], 0, STRIPE_SIZE);
@@ -689,8 +902,8 @@
 			ptr[count++] = p;
 		else
 			printk("compute_block() %d, stripe %llu, %d"
-				" not present\n", dd_idx,
-				(unsigned long long)sh->sector, i);
+					" not present\n", dd_idx,
+					(unsigned long long)sh->sector, i);
 
 		check_xor();
 	}
@@ -702,59 +915,59 @@
 static void compute_parity(struct stripe_head *sh, int method)
 {
 	raid5_conf_t *conf = sh->raid_conf;
-	int i, pd_idx = sh->pd_idx, disks = conf->raid_disks, count;
+	int i, pd_idx = sh->pd_idx, disks = sh->disks, count;
 	void *ptr[MAX_XOR_BLOCKS];
 	struct bio *chosen;
 
 	PRINTK("compute_parity, stripe %llu, method %d\n",
-		(unsigned long long)sh->sector, method);
+			(unsigned long long)sh->sector, method);
 
 	count = 1;
 	ptr[0] = page_address(sh->dev[pd_idx].page);
 	switch(method) {
-	case READ_MODIFY_WRITE:
-		if (!test_bit(R5_UPTODATE, &sh->dev[pd_idx].flags))
-			BUG();
-		for (i=disks ; i-- ;) {
-			if (i==pd_idx)
-				continue;
-			if (sh->dev[i].towrite &&
-			    test_bit(R5_UPTODATE, &sh->dev[i].flags)) {
-				ptr[count++] = page_address(sh->dev[i].page);
-				chosen = sh->dev[i].towrite;
-				sh->dev[i].towrite = NULL;
-
-				if (test_and_clear_bit(R5_Overlap, &sh->dev[i].flags))
-					wake_up(&conf->wait_for_overlap);
-
-				if (sh->dev[i].written) BUG();
-				sh->dev[i].written = chosen;
-				check_xor();
+		case READ_MODIFY_WRITE:
+			if (!test_bit(R5_UPTODATE, &sh->dev[pd_idx].flags))
+				BUG();
+			for (i=disks ; i-- ;) {
+				if (i==pd_idx)
+					continue;
+				if (sh->dev[i].towrite &&
+						test_bit(R5_UPTODATE, &sh->dev[i].flags)) {
+					ptr[count++] = page_address(sh->dev[i].page);
+					chosen = sh->dev[i].towrite;
+					sh->dev[i].towrite = NULL;
+
+					if (test_and_clear_bit(R5_Overlap, &sh->dev[i].flags))
+						wake_up(&conf->wait_for_overlap);
+
+					if (sh->dev[i].written) BUG();
+					sh->dev[i].written = chosen;
+					check_xor();
+				}
 			}
-		}
-		break;
-	case RECONSTRUCT_WRITE:
-		memset(ptr[0], 0, STRIPE_SIZE);
-		for (i= disks; i-- ;)
-			if (i!=pd_idx && sh->dev[i].towrite) {
-				chosen = sh->dev[i].towrite;
-				sh->dev[i].towrite = NULL;
+			break;
+		case RECONSTRUCT_WRITE:
+			memset(ptr[0], 0, STRIPE_SIZE);
+			for (i= disks; i-- ;)
+				if (i!=pd_idx && sh->dev[i].towrite) {
+					chosen = sh->dev[i].towrite;
+					sh->dev[i].towrite = NULL;
 
-				if (test_and_clear_bit(R5_Overlap, &sh->dev[i].flags))
-					wake_up(&conf->wait_for_overlap);
+					if (test_and_clear_bit(R5_Overlap, &sh->dev[i].flags))
+						wake_up(&conf->wait_for_overlap);
 
-				if (sh->dev[i].written) BUG();
-				sh->dev[i].written = chosen;
-			}
-		break;
-	case CHECK_PARITY:
-		break;
+					if (sh->dev[i].written) BUG();
+					sh->dev[i].written = chosen;
+				}
+			break;
+		case CHECK_PARITY:
+			break;
 	}
 	if (count>1) {
 		xor_block(count, STRIPE_SIZE, ptr);
 		count = 1;
 	}
-	
+
 	for (i = disks; i--;)
 		if (sh->dev[i].written) {
 			sector_t sector = sh->dev[i].sector;
@@ -769,24 +982,24 @@
 		}
 
 	switch(method) {
-	case RECONSTRUCT_WRITE:
-	case CHECK_PARITY:
-		for (i=disks; i--;)
-			if (i != pd_idx) {
-				ptr[count++] = page_address(sh->dev[i].page);
-				check_xor();
-			}
-		break;
-	case READ_MODIFY_WRITE:
-		for (i = disks; i--;)
-			if (sh->dev[i].written) {
-				ptr[count++] = page_address(sh->dev[i].page);
-				check_xor();
-			}
+		case RECONSTRUCT_WRITE:
+		case CHECK_PARITY:
+			for (i=disks; i--;)
+				if (i != pd_idx) {
+					ptr[count++] = page_address(sh->dev[i].page);
+					check_xor();
+				}
+			break;
+		case READ_MODIFY_WRITE:
+			for (i = disks; i--;)
+				if (sh->dev[i].written) {
+					ptr[count++] = page_address(sh->dev[i].page);
+					check_xor();
+				}
 	}
 	if (count != 1)
 		xor_block(count, STRIPE_SIZE, ptr);
-	
+
 	if (method != CHECK_PARITY) {
 		set_bit(R5_UPTODATE, &sh->dev[pd_idx].flags);
 		set_bit(R5_LOCKED,   &sh->dev[pd_idx].flags);
@@ -805,16 +1018,18 @@
 	raid5_conf_t *conf = sh->raid_conf;
 
 	PRINTK("adding bh b#%llu to stripe s#%llu\n",
-		(unsigned long long)bi->bi_sector,
-		(unsigned long long)sh->sector);
+			(unsigned long long)bi->bi_sector,
+			(unsigned long long)sh->sector);
 
 
 	spin_lock(&sh->lock);
 	spin_lock_irq(&conf->device_lock);
+	PRINTK("lock, DISKS: %u\n", sh->disks);
 	if (forwrite)
 		bip = &sh->dev[dd_idx].towrite;
 	else
 		bip = &sh->dev[dd_idx].toread;
+	PRINTK("pip, disk=%u, bip=%p, num_disks=%u\n", dd_idx, bip, sh->disks);
 	while (*bip && (*bip)->bi_sector < bi->bi_sector) {
 		if ((*bip)->bi_sector + ((*bip)->bi_size >> 9) > bi->bi_sector)
 			goto overlap;
@@ -833,16 +1048,16 @@
 	spin_unlock(&sh->lock);
 
 	PRINTK("added bi b#%llu to stripe s#%llu, disk %d.\n",
-		(unsigned long long)bi->bi_sector,
-		(unsigned long long)sh->sector, dd_idx);
+			(unsigned long long)bi->bi_sector,
+			(unsigned long long)sh->sector, dd_idx);
 
 	if (forwrite) {
 		/* check if page is covered */
 		sector_t sector = sh->dev[dd_idx].sector;
 		for (bi=sh->dev[dd_idx].towrite;
-		     sector < sh->dev[dd_idx].sector + STRIPE_SECTORS &&
-			     bi && bi->bi_sector <= sector;
-		     bi = r5_next_bio(bi, sh->dev[dd_idx].sector)) {
+				sector < sh->dev[dd_idx].sector + STRIPE_SECTORS &&
+				bi && bi->bi_sector <= sector;
+				bi = r5_next_bio(bi, sh->dev[dd_idx].sector)) {
 			if (bi->bi_sector + (bi->bi_size>>9) >= sector)
 				sector = bi->bi_sector + (bi->bi_size>>9);
 		}
@@ -851,7 +1066,9 @@
 	}
 	return 1;
 
- overlap:
+overlap:
+	printk("overlap\n");
+
 	set_bit(R5_Overlap, &sh->dev[dd_idx].flags);
 	spin_unlock_irq(&conf->device_lock);
 	spin_unlock(&sh->lock);
@@ -876,11 +1093,11 @@
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
@@ -891,12 +1108,13 @@
 	struct r5dev *dev;
 
 	PRINTK("handling stripe %llu, cnt=%d, pd_idx=%d\n",
-		(unsigned long long)sh->sector, atomic_read(&sh->count),
-		sh->pd_idx);
+			(unsigned long long)sh->sector, atomic_read(&sh->count),
+			sh->pd_idx);
 
 	spin_lock(&sh->lock);
 	clear_bit(STRIPE_HANDLE, &sh->state);
 	clear_bit(STRIPE_DELAYED, &sh->state);
+	clear_bit(STRIPE_DELAY_EXPAND, &sh->state);
 
 	syncing = test_bit(STRIPE_SYNCING, &sh->state);
 	/* Now to look around and see what can be done */
@@ -908,7 +1126,7 @@
 		clear_bit(R5_Syncio, &dev->flags);
 
 		PRINTK("check %d: state 0x%lx read %p write %p written %p\n",
-			i, dev->flags, dev->toread, dev->towrite, dev->written);
+				i, dev->flags, dev->toread, dev->towrite, dev->written);
 		/* maybe we can reply to a read */
 		if (test_bit(R5_UPTODATE, &dev->flags) && dev->toread) {
 			struct bio *rbi, *rbi2;
@@ -936,7 +1154,7 @@
 		if (test_bit(R5_LOCKED, &dev->flags)) locked++;
 		if (test_bit(R5_UPTODATE, &dev->flags)) uptodate++;
 
-		
+
 		if (dev->toread) to_read++;
 		if (dev->towrite) {
 			to_write++;
@@ -945,19 +1163,21 @@
 		}
 		if (dev->written) written++;
 		rdev = conf->disks[i].rdev; /* FIXME, should I be looking rdev */
-		if (!rdev || !rdev->in_sync) {
+		if (!conf->expand_in_progress && (!rdev || !rdev->in_sync)) {
 			failed++;
 			failed_num = i;
+			printk("failing disk %u (%p)!\n", i, rdev);
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
@@ -1012,7 +1232,7 @@
 		}
 		spin_unlock_irq(&conf->device_lock);
 	}
-	if (failed > 1 && syncing) {
+	if (failed > 1 && syncing && !conf->expand_in_progress) {
 		md_done_sync(conf->mddev, STRIPE_SECTORS,0);
 		clear_bit(STRIPE_SYNCING, &sh->state);
 		syncing = 0;
@@ -1023,37 +1243,37 @@
 	 */
 	dev = &sh->dev[sh->pd_idx];
 	if ( written &&
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
-			    spin_unlock_irq(&conf->device_lock);
-		    }
-		}
+			( (test_bit(R5_Insync, &dev->flags) && !test_bit(R5_LOCKED, &dev->flags) &&
+			   test_bit(R5_UPTODATE, &dev->flags))
+			  || (failed == 1 && failed_num == sh->pd_idx))
+	   ) {
+		/* any written block on an uptodate or failed drive can be returned.
+		 * Note that if we 'wrote' to a failed drive, it will be UPTODATE, but 
+		 * never LOCKED, so we don't need to test 'failed' directly.
+		 */
+		for (i=disks; i--; )
+			if (sh->dev[i].written) {
+				dev = &sh->dev[i];
+				if (!test_bit(R5_LOCKED, &dev->flags) &&
+						test_bit(R5_UPTODATE, &dev->flags) ) {
+					/* We can return any write requests */
+					struct bio *wbi, *wbi2;
+					PRINTK("Return write for disc %d\n", i);
+					spin_lock_irq(&conf->device_lock);
+					wbi = dev->written;
+					dev->written = NULL;
+					while (wbi && wbi->bi_sector < dev->sector + STRIPE_SECTORS) {
+						wbi2 = r5_next_bio(wbi, dev->sector);
+						if (--wbi->bi_phys_segments == 0) {
+							md_write_end(conf->mddev);
+							wbi->bi_next = return_bi;
+							return_bi = wbi;
+						}
+						wbi = wbi2;
+					}
+					spin_unlock_irq(&conf->device_lock);
+				}
+			}
 	}
 
 	/* Now we might consider reading some blocks, either to check/generate
@@ -1064,13 +1284,13 @@
 		for (i=disks; i--;) {
 			dev = &sh->dev[i];
 			if (!test_bit(R5_LOCKED, &dev->flags) && !test_bit(R5_UPTODATE, &dev->flags) &&
-			    (dev->toread ||
-			     (dev->towrite && !test_bit(R5_OVERWRITE, &dev->flags)) ||
-			     syncing ||
-			     (failed && (sh->dev[failed_num].toread ||
-					 (sh->dev[failed_num].towrite && !test_bit(R5_OVERWRITE, &sh->dev[failed_num].flags))))
-				    )
-				) {
+					(dev->toread ||
+					 (dev->towrite && !test_bit(R5_OVERWRITE, &dev->flags)) ||
+					 syncing ||
+					 (failed && (sh->dev[failed_num].toread ||
+						     (sh->dev[failed_num].towrite && !test_bit(R5_OVERWRITE, &sh->dev[failed_num].flags))))
+					)
+			   ) {
 				/* we would like to get this block, possibly
 				 * by computing it, but we might not be able to
 				 */
@@ -1085,23 +1305,303 @@
 					/* if I am just reading this block and we don't have
 					   a failed drive, or any pending writes then sidestep the cache */
 					if (sh->bh_read[i] && !sh->bh_read[i]->b_reqnext &&
-					    ! syncing && !failed && !to_write) {
+							! syncing && !failed && !to_write) {
 						sh->bh_cache[i]->b_page =  sh->bh_read[i]->b_page;
 						sh->bh_cache[i]->b_data =  sh->bh_read[i]->b_data;
 					}
 #endif
 					locked++;
 					PRINTK("Reading block %d (sync=%d)\n", 
-						i, syncing);
-					if (syncing)
+							i, syncing);
+					if (syncing && !conf->expand_in_progress)
 						md_sync_acct(conf->disks[i].rdev->bdev,
-							     STRIPE_SECTORS);
+								STRIPE_SECTORS);
 				}
 			}
 		}
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
+		if (((conf->mddev->size << 1) - conf->expand_progress) / STRIPE_SECTORS < needed_uptodate) {
+			needed_uptodate = ((conf->mddev->size << 1) - conf->expand_progress) / STRIPE_SECTORS;
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
+			printk("Expanding onto %llu\n", dest_sector);
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
@@ -1237,7 +1737,9 @@
 		}
 	}
 	if (syncing && locked == 0 && test_bit(STRIPE_INSYNC, &sh->state)) {
-		md_done_sync(conf->mddev, STRIPE_SECTORS,1);
+		if (!conf->expand_in_progress) {
+			md_done_sync(conf->mddev, STRIPE_SECTORS,1);
+		}
 		clear_bit(STRIPE_SYNCING, &sh->state);
 	}
 	
@@ -1279,7 +1781,7 @@
 		rcu_read_unlock();
  
 		if (rdev) {
-			if (test_bit(R5_Syncio, &sh->dev[i].flags))
+			if (test_bit(R5_Syncio, &sh->dev[i].flags) && !conf->expand_in_progress)
 				md_sync_acct(rdev->bdev, STRIPE_SECTORS);
 
 			bi->bi_bdev = rdev->bdev;
@@ -1308,6 +1810,7 @@
 
 static inline void raid5_activate_delayed(raid5_conf_t *conf)
 {
+	PRINTK("raid5_activate_delayed\n");
 	if (atomic_read(&conf->preread_active_stripes) < IO_THRESHOLD) {
 		while (!list_empty(&conf->delayed_list)) {
 			struct list_head *l = conf->delayed_list.next;
@@ -1428,8 +1931,15 @@
 	for (;logical_sector < last_sector; logical_sector += STRIPE_SECTORS) {
 		DEFINE_WAIT(w);
 		
-		new_sector = raid5_compute_sector(logical_sector,
-						  raid_disks, data_disks, &dd_idx, &pd_idx, conf);
+		if (conf->expand_in_progress && logical_sector >= conf->expand_progress) {
+			PRINTK("GEOM: old\n");
+			new_sector = raid5_compute_sector(logical_sector,
+				conf->previous_raid_disks, conf->previous_raid_disks - 1, &dd_idx, &pd_idx, conf);
+		} else {
+			PRINTK("GEOM: new\n");
+			new_sector = raid5_compute_sector(logical_sector,
+				 raid_disks, data_disks, &dd_idx, &pd_idx, conf);
+		}
 
 		PRINTK("raid5: make_request, sector %llu logical %llu\n",
 			(unsigned long long)new_sector, 
@@ -1488,6 +1998,13 @@
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
@@ -1499,17 +2016,41 @@
 	 */
 	if (mddev->degraded >= 1 && test_bit(MD_RECOVERY_SYNC, &mddev->recovery)) {
 		int rv = (mddev->size << 1) - sector_nr;
+		printk("md_done_sync()\n");
 		md_done_sync(mddev, rv, 1);
 		return rv;
 	}
+	
+	/* if we're in an expand, we can't allow the process
+	 * to keep reading in stripes; we might not have enough buffer
+	 * space to keep it all in RAM.
+	 */
+	if (conf->expand_in_progress && sector_nr >= conf->expand_progress + (conf->chunk_size >> 9) * (conf->raid_disks - 1)) {
+		//printk("DELAY\n");
+		//printall(conf);
+		//printk("progress = %llu\n", conf->expand_progress);
+		spin_lock_irq(&conf->device_lock);
+		wait_event_lock_irq(conf->wait_for_expand_progress,
+			    sector_nr < conf->expand_progress + (conf->chunk_size >> 9) * (conf->raid_disks - 1),
+			    conf->device_lock,
+			    unplug_slaves(conf->mddev);
+		);
+		spin_unlock_irq(&conf->device_lock);
+		//printk("DELAY DONE\n");
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
-		+ chunk_offset, raid_disks, data_disks, &dd_idx, &pd_idx, conf);
+			+ chunk_offset, raid_disks, data_disks, &dd_idx, &pd_idx, conf);
 	sh = get_active_stripe(conf, sector_nr, pd_idx, 1);
 	if (sh == NULL) {
 		sh = get_active_stripe(conf, sector_nr, pd_idx, 0);
@@ -1553,18 +2094,29 @@
 	while (1) {
 		struct list_head *first;
 
+		conf = mddev_to_conf(mddev);
+
 		if (list_empty(&conf->handle_list) &&
 		    atomic_read(&conf->preread_active_stripes) < IO_THRESHOLD &&
 		    !blk_queue_plugged(mddev->queue) &&
-		    !list_empty(&conf->delayed_list))
+		    !list_empty(&conf->delayed_list)) {
+			PRINTK("activate delayed\n");
 			raid5_activate_delayed(conf);
+		}
 
 		if (list_empty(&conf->handle_list))
 			break;
 
 		first = conf->handle_list.next;
+		PRINTK("first: %p\n", first);
+		
 		sh = list_entry(first, struct stripe_head, lru);
 
+#if RAID5_DEBUG
+		PRINTK("sh: %p\n", sh);
+		print_sh(sh);
+#endif
+
 		list_del_init(first);
 		atomic_inc(&sh->count);
 		if (atomic_read(&sh->count)!= 1)
@@ -1577,7 +2129,7 @@
 
 		spin_lock_irq(&conf->device_lock);
 	}
-	PRINTK("%d stripes handled\n", handled);
+//	PRINTK("%d stripes handled\n", handled);
 
 	spin_unlock_irq(&conf->device_lock);
 
@@ -1594,6 +2146,8 @@
 	struct disk_info *disk;
 	struct list_head *tmp;
 
+	printk("run()!\n");
+	
 	if (mddev->level != 5 && mddev->level != 4) {
 		printk("raid5: %s: raid level not set to 4/5 (%d)\n", mdname(mddev), mddev->level);
 		return -EIO;
@@ -1650,6 +2204,7 @@
 	conf->level = mddev->level;
 	conf->algorithm = mddev->layout;
 	conf->max_nr_stripes = NR_STRIPES;
+	conf->expand_in_progress = 0;
 
 	/* device size must be a multiple of chunk size */
 	mddev->size &= ~(mddev->chunk_size/1024 -1);
@@ -1691,7 +2246,7 @@
 	}
 memory = conf->max_nr_stripes * (sizeof(struct stripe_head) +
 		 conf->raid_disks * ((sizeof(struct bio) + PAGE_SIZE))) / 1024;
-	if (grow_stripes(conf, conf->max_nr_stripes)) {
+	if (grow_stripes(conf, conf->max_nr_stripes, 0)) {
 		printk(KERN_ERR 
 			"raid5: couldn't allocate %dkB for buffers\n", memory);
 		shrink_stripes(conf);
@@ -1767,8 +2322,8 @@
 
 	printk("sh %llu, pd_idx %d, state %ld.\n",
 		(unsigned long long)sh->sector, sh->pd_idx, sh->state);
-	printk("sh %llu,  count %d.\n",
-		(unsigned long long)sh->sector, atomic_read(&sh->count));
+	printk("sh %llu,  count %d, disks %d.\n",
+		(unsigned long long)sh->sector, atomic_read(&sh->count), sh->disks);
 	printk("sh %llu, ", (unsigned long long)sh->sector);
 	for (i = 0; i < sh->raid_conf->raid_disks; i++) {
 		printk("(cache%d: %p %ld) ", 
@@ -1865,6 +2420,9 @@
 	mdk_rdev_t *rdev;
 	struct disk_info *p = conf->disks + number;
 
+	printk("we were asked to remove a disk\n");
+	return -EBUSY;  // sesse hack
+	
 	print_raid5_conf(conf);
 	rdev = p->rdev;
 	if (rdev) {
@@ -1894,27 +2452,37 @@
 	int disk;
 	struct disk_info *p;
 
-	if (mddev->degraded > 1)
+	printk("RAID5 ADD DISK PLZ: %p\n", rdev);
+	
+	if (mddev->degraded > 1) {
+		printk("GAVE UP\n");
+		
 		/* no point adding a device */
 		return 0;
+	}
 
 	/*
 	 * find the disk ...
 	 */
-	for (disk=0; disk < mddev->raid_disks; disk++)
+	for (disk=0; disk < mddev->raid_disks; disk++) {
 		if ((p=conf->disks + disk)->rdev == NULL) {
+			printk("adding disk to %u\n", disk);
+			
+			rdev->faulty = 0;
 			rdev->in_sync = 0;
 			rdev->raid_disk = disk;
 			found = 1;
 			p->rdev = rdev;
 			break;
 		}
+	}
 	print_raid5_conf(conf);
 	return found;
 }
 
 static int raid5_resize(mddev_t *mddev, sector_t sectors)
 {
+        raid5_conf_t *conf = mddev_to_conf(mddev);
 	/* no resync is happening, and there is enough space
 	 * on all devices, so we can resize.
 	 * We need to make sure resync covers any new space.
@@ -1922,8 +2490,14 @@
 	 * any io in the removed space completes, but it hardly seems
 	 * worth it.
 	 */
+	printk("asked to resize\n");
+	if (conf->expand_in_progress)
+		return -EBUSY;
+		
 	sectors &= ~((sector_t)mddev->chunk_size/512 - 1);
+	printk("old array_size: %llu\n", mddev->array_size);
 	mddev->array_size = (sectors * (mddev->raid_disks-1))>>1;
+	printk("new array_size: %llu (%llu x %u)\n", mddev->array_size, sectors, mddev->raid_disks - 1);
 	set_capacity(mddev->gendisk, mddev->array_size << 1);
 	mddev->changed = 1;
 	if (sectors/2  > mddev->size && mddev->recovery_cp == MaxSector) {
@@ -1934,6 +2508,221 @@
 	return 0;
 }
 
+static int raid5_reshape(mddev_t *mddev, int raid_disks)
+{
+        raid5_conf_t *conf = mddev_to_conf(mddev);
+	raid5_conf_t *newconf;
+        struct list_head *tmp;
+	mdk_rdev_t *rdev;
+	unsigned long flags;
+
+        int d, i;
+
+	if (mddev->degraded >= 1 || conf->expand_in_progress)
+		return -EBUSY;
+	
+	printk("sesse was here: reshape to %u disks\n", raid_disks);
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
+        set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
+        set_bit(MD_RECOVERY_SYNC, &mddev->recovery);
+	mddev->recovery_cp = 0;
+        md_wakeup_thread(mddev->thread);
+//        md_check_recovery(mddev);
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
@@ -1948,6 +2737,7 @@
 	.spare_active	= raid5_spare_active,
 	.sync_request	= sync_request,
 	.resize		= raid5_resize,
+	.reshape	= raid5_reshape
 };
 
 static int __init raid5_init (void)
diff -ur linux-2.6-2.6.12/include/linux/raid/raid5.h ../linux-2.6-2.6.12/include/linux/raid/raid5.h
--- linux-2.6-2.6.12/include/linux/raid/raid5.h	2005-06-17 21:48:29.000000000 +0200
+++ linux-2.6-2.6.12.patch/include/linux/raid/raid5.h	2005-09-17 00:47:25.000000000 +0200
@@ -92,7 +92,11 @@
  * stripe is also (potentially) linked to a hash bucket in the hash
  * table so that it can be found by sector number.  Stripes that are
  * not hashed must be on the inactive_list, and will normally be at
- * the front.  All stripes start life this way.
+ * the front.  All stripes start life this way. There is also a
+ * "inactive_list_expand"; this is only used during an expand, and
+ * it contains stripes with "disks" set to the correct number of disks
+ * after the expand (and with the correct amount of memory allocated,
+ * of course).
  *
  * The inactive_list, handle_list and hash bucket lists are all protected by the
  * device_lock.
@@ -134,6 +138,7 @@
 	unsigned long		state;			/* state flags */
 	atomic_t		count;			/* nr of active thread/requests */
 	spinlock_t		lock;
+	int			disks;			/* disks in stripe */
 	struct r5dev {
 		struct bio	req;
 		struct bio_vec	vec;
@@ -171,6 +176,7 @@
 #define	STRIPE_INSYNC		4
 #define	STRIPE_PREREAD_ACTIVE	5
 #define	STRIPE_DELAYED		6
+#define	STRIPE_DELAY_EXPAND	7
 
 /*
  * Plugging:
@@ -199,6 +205,10 @@
 struct disk_info {
 	mdk_rdev_t	*rdev;
 };
+struct expand_buf {
+	struct page     *page;
+	int		up_to_date;
+};
 
 struct raid5_private_data {
 	struct stripe_head	**stripe_hashtbl;
@@ -208,22 +218,38 @@
 	int			raid_disks, working_disks, failed_disks;
 	int			max_nr_stripes;
 
+	/* used during an expand */
+	int			expand_in_progress;
+	sector_t		expand_progress;
+	int			previous_raid_disks;
+	struct list_head	wait_for_expand_list;
+	
+	struct expand_buf	*expand_buffer;
+
 	struct list_head	handle_list; /* stripes needing handling */
 	struct list_head	delayed_list; /* stripes that have plugged requests */
 	atomic_t		preread_active_stripes; /* stripes with scheduled io */
 
 	char			cache_name[20];
+	char			cache_name_expand[20];
 	kmem_cache_t		*slab_cache; /* for allocating stripes */
+	kmem_cache_t		*slab_cache_expand;
+	
 	/*
 	 * Free stripes pool
 	 */
 	atomic_t		active_stripes;
+	atomic_t		active_stripes_expand;
 	struct list_head	inactive_list;
+	struct list_head	inactive_list_expand;
 	wait_queue_head_t	wait_for_stripe;
+	wait_queue_head_t	wait_for_stripe_expand;
+	wait_queue_head_t	wait_for_expand_progress;
 	wait_queue_head_t	wait_for_overlap;
 	int			inactive_blocked;	/* release of inactive stripes blocked,
 							 * waiting for 25% to be free
-							 */        
+							 */       
+	int			inactive_blocked_expand;
 	spinlock_t		device_lock;
 	struct disk_info	disks[0];
 };

--k+w/mQv8wyuph6w0--
