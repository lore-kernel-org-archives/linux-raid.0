From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH md 7 of 7] Modify locking when accessing subdevices in md
Date: Wed, 08 Sep 2004 12:48:10 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <E1C4sVG-0005dy-AI@notabene.cse.unsw.edu.au>
References: <20040908124236.20651.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Each md personality keeps a list of devices that are currently
active in the array (mdk_rdev_t).  As these can potentially
be removed at any time, some locking is needed when accessing
entries in the list.  Currently this involves a spinlock,
but all the spinlocking this imposed in unplug_slaves bothered
me.

So, I have changed it to use rcu locking.  This is more appropriate
as objects are removed only very rarely, and there is no
cost in waiting a little while for a remove to succeed.

Also, all changes to the list of devices are performed by the
per-array thread (calling md_check_recovery) and so are completely
single threaded, so no locking between writers is needed at all.

Finally, devices are never added or removed while resync is happenin,
so resync doesn't need to worry about locking at all.

So with this patch, the spinlocking is replaced with rcu read locking
and synchronize_kernel.
The rcu_read_lock is held while dereferencing a possible device,
and the nr_pending count is atomically incremented if the device is to
be held outside of the rcu_read_lock.

When removing a device, if the nr_pending count appears to be zero, we
set the list entry to NULL and call synchronize_kernel().  If the 
count is still zero after this, we have a safe removal.  If it is non-zero,
then someone has just started using it so we put the pointer back and 
fail the removal.  When the new user finally drops it's reference,
that will cause the per-array thread to wake up again and retry
the removal.


Signed-off-by: Neil Brown <neilb@cse.unsw.edu.au>

### Diffstat output
 ./drivers/md/multipath.c |   54 ++++++++++++++++++++++++----------------
 ./drivers/md/raid1.c     |   61 ++++++++++++++++++++++++----------------------
 ./drivers/md/raid10.c    |   62 +++++++++++++++++++++++++----------------------
 ./drivers/md/raid5.c     |   51 +++++++++++++++++++++-----------------
 ./drivers/md/raid6main.c |   52 +++++++++++++++++++++------------------
 5 files changed, 154 insertions(+), 126 deletions(-)

diff ./drivers/md/multipath.c~current~ ./drivers/md/multipath.c
--- ./drivers/md/multipath.c~current~	2004-09-08 11:57:21.000000000 +1000
+++ ./drivers/md/multipath.c	2004-09-08 11:59:00.000000000 +1000
@@ -66,12 +66,12 @@ static int multipath_map (multipath_conf
 	 * but this does not happen for the last device.
 	 */
  retry:
-	spin_lock_irq(&conf->device_lock);
+	rcu_read_lock();
 	for (i = 0; i < disks; i++) {
 		mdk_rdev_t *rdev = conf->multipaths[i].rdev;
 		if (rdev && rdev->in_sync) {
 			atomic_inc(&rdev->nr_pending);
-			spin_unlock_irq(&conf->device_lock);
+			rcu_read_unlock();
 			return i;
 		}
 		if (rdev) failed = i;
@@ -79,10 +79,10 @@ static int multipath_map (multipath_conf
 	if (!retry && failed >= 0) {
 		mdk_rdev_t *rdev = conf->multipaths[failed].rdev;
 		atomic_inc(&rdev->nr_pending);
-		spin_unlock_irq(&conf->device_lock);
+		rcu_read_unlock();
 		return failed;
 	}
-	spin_unlock_irq(&conf->device_lock);
+	rcu_read_unlock();
 
 	/* sync with any monitoring daemon */
 	wait_event(md_event_waiters,
@@ -154,26 +154,26 @@ static void unplug_slaves(mddev_t *mddev
 {
 	multipath_conf_t *conf = mddev_to_conf(mddev);
 	int i;
-	unsigned long flags;
 
-	spin_lock_irqsave(&conf->device_lock, flags);
+	rcu_read_lock();
 	for (i=0; i<mddev->raid_disks; i++) {
 		mdk_rdev_t *rdev = conf->multipaths[i].rdev;
 		if (rdev && !rdev->faulty && atomic_read(&rdev->nr_pending)) {
 			request_queue_t *r_queue = bdev_get_queue(rdev->bdev);
 
 			atomic_inc(&rdev->nr_pending);
-			spin_unlock_irqrestore(&conf->device_lock, flags);
+			rcu_read_unlock();
 
 			if (r_queue->unplug_fn)
 				r_queue->unplug_fn(r_queue);
 
-			spin_lock_irqsave(&conf->device_lock, flags);
 			rdev_dec_pending(rdev, mddev);
+			rcu_read_lock();
 		}
 	}
-	spin_unlock_irqrestore(&conf->device_lock, flags);
+	rcu_read_unlock();
 }
+
 static void multipath_unplug(request_queue_t *q)
 {
 	unplug_slaves(q->queuedata);
@@ -238,6 +238,7 @@ static int multipath_issue_flush(request
 	multipath_conf_t *conf = mddev_to_conf(mddev);
 	int i, ret = 0;
 
+	rcu_read_lock();
 	for (i=0; i<mddev->raid_disks && ret == 0; i++) {
 		mdk_rdev_t *rdev = conf->multipaths[i].rdev;
 		if (rdev && !rdev->faulty) {
@@ -246,11 +247,17 @@ static int multipath_issue_flush(request
 
 			if (!r_queue->issue_flush_fn)
 				ret = -EOPNOTSUPP;
-			else
+			else {
+				atomic_inc(&rdev->nr_pending);
+				rcu_read_unlock();
 				ret = r_queue->issue_flush_fn(r_queue, bdev->bd_disk,
 							      error_sector);
+				rdev_dec_pending(rdev, mddev);
+				rcu_read_lock();
+			}
 		}
 	}
+	rcu_read_unlock();
 	return ret;
 }
 
@@ -312,10 +319,9 @@ static int multipath_add_disk(mddev_t *m
 	struct multipath_info *p;
 
 	print_multipath_conf(conf);
-	spin_lock_irq(&conf->device_lock);
+
 	for (path=0; path<mddev->raid_disks; path++) 
 		if ((p=conf->multipaths+path)->rdev == NULL) {
-			p->rdev = rdev;
 			blk_queue_stack_limits(mddev->queue,
 					       rdev->bdev->bd_disk->queue);
 
@@ -332,9 +338,9 @@ static int multipath_add_disk(mddev_t *m
 			conf->working_disks++;
 			rdev->raid_disk = path;
 			rdev->in_sync = 1;
+			p->rdev = rdev;
 			found = 1;
 		}
-	spin_unlock_irq(&conf->device_lock);
 
 	print_multipath_conf(conf);
 	return found;
@@ -343,11 +349,11 @@ static int multipath_add_disk(mddev_t *m
 static int multipath_remove_disk(mddev_t *mddev, int number)
 {
 	multipath_conf_t *conf = mddev->private;
-	int err = 1;
+	int err = 0;
+	mdk_rdev_t *rdev;
 	struct multipath_info *p = conf->multipaths + number;
 
 	print_multipath_conf(conf);
-	spin_lock_irq(&conf->device_lock);
 
 	if (conf->working_disks == 0)
 		/* don't remove devices when none seem to be working.
@@ -355,21 +361,25 @@ static int multipath_remove_disk(mddev_t
 		 * is really a device error
 		 */
 		goto abort;
-	if (p->rdev) {
-		if (p->rdev->in_sync ||
-		    atomic_read(&p->rdev->nr_pending)) {
+
+	rdev = p->rdev;
+	if (rdev) {
+		if (rdev->in_sync ||
+		    atomic_read(&rdev->nr_pending)) {
 			printk(KERN_ERR "hot-remove-disk, slot %d is identified"
 			       " but is still operational!\n", number);
 			err = -EBUSY;
 			goto abort;
 		}
 		p->rdev = NULL;
-		err = 0;
+		synchronize_kernel();
+		if (atomic_read(&rdev->nr_pending)) {
+			/* lost the race, try later */
+			err = -EBUSY;
+			p->rdev = rdev;
+		}
 	}
-	if (err)
-		MD_BUG();
 abort:
-	spin_unlock_irq(&conf->device_lock);
 
 	print_multipath_conf(conf);
 	return err;

diff ./drivers/md/raid1.c~current~ ./drivers/md/raid1.c
--- ./drivers/md/raid1.c~current~	2004-09-08 11:57:21.000000000 +1000
+++ ./drivers/md/raid1.c	2004-09-08 11:59:00.000000000 +1000
@@ -339,7 +339,7 @@ static int read_balance(conf_t *conf, r1
 	const int sectors = r1_bio->sectors;
 	sector_t new_distance, current_distance;
 
-	spin_lock_irq(&conf->device_lock);
+	rcu_read_lock();
 	/*
 	 * Check if it if we can balance. We can balance on the whole
 	 * device if no resync is going on, or below the resync window.
@@ -416,7 +416,7 @@ rb_out:
 		conf->last_used = new_disk;
 		atomic_inc(&conf->mirrors[new_disk].rdev->nr_pending);
 	}
-	spin_unlock_irq(&conf->device_lock);
+	rcu_read_unlock();
 
 	return new_disk;
 }
@@ -425,26 +425,26 @@ static void unplug_slaves(mddev_t *mddev
 {
 	conf_t *conf = mddev_to_conf(mddev);
 	int i;
-	unsigned long flags;
 
-	spin_lock_irqsave(&conf->device_lock, flags);
+	rcu_read_lock();
 	for (i=0; i<mddev->raid_disks; i++) {
 		mdk_rdev_t *rdev = conf->mirrors[i].rdev;
 		if (rdev && !rdev->faulty && atomic_read(&rdev->nr_pending)) {
 			request_queue_t *r_queue = bdev_get_queue(rdev->bdev);
 
 			atomic_inc(&rdev->nr_pending);
-			spin_unlock_irqrestore(&conf->device_lock, flags);
+			rcu_read_unlock();
 
 			if (r_queue->unplug_fn)
 				r_queue->unplug_fn(r_queue);
 
-			spin_lock_irqsave(&conf->device_lock, flags);
 			rdev_dec_pending(rdev, mddev);
+			rcu_read_lock();
 		}
 	}
-	spin_unlock_irqrestore(&conf->device_lock, flags);
+	rcu_read_unlock();
 }
+
 static void raid1_unplug(request_queue_t *q)
 {
 	unplug_slaves(q->queuedata);
@@ -455,10 +455,9 @@ static int raid1_issue_flush(request_que
 {
 	mddev_t *mddev = q->queuedata;
 	conf_t *conf = mddev_to_conf(mddev);
-	unsigned long flags;
 	int i, ret = 0;
 
-	spin_lock_irqsave(&conf->device_lock, flags);
+	rcu_read_lock();
 	for (i=0; i<mddev->raid_disks && ret == 0; i++) {
 		mdk_rdev_t *rdev = conf->mirrors[i].rdev;
 		if (rdev && !rdev->faulty) {
@@ -467,12 +466,17 @@ static int raid1_issue_flush(request_que
 
 			if (!r_queue->issue_flush_fn)
 				ret = -EOPNOTSUPP;
-			else
+			else {
+				atomic_inc(&rdev->nr_pending);
+				rcu_read_unlock();
 				ret = r_queue->issue_flush_fn(r_queue, bdev->bd_disk,
 							      error_sector);
+				rdev_dec_pending(rdev, mddev);
+				rcu_read_lock();
+			}
 		}
 	}
-	spin_unlock_irqrestore(&conf->device_lock, flags);
+	rcu_read_unlock();
 	return ret;
 }
 
@@ -579,7 +583,7 @@ static int make_request(request_queue_t 
 	 * bios[x] to bio
 	 */
 	disks = conf->raid_disks;
-	spin_lock_irq(&conf->device_lock);
+	rcu_read_lock();
 	for (i = 0;  i < disks; i++) {
 		if (conf->mirrors[i].rdev &&
 		    !conf->mirrors[i].rdev->faulty) {
@@ -588,7 +592,7 @@ static int make_request(request_queue_t 
 		} else
 			r1_bio->bios[i] = NULL;
 	}
-	spin_unlock_irq(&conf->device_lock);
+	rcu_read_unlock();
 
 	atomic_set(&r1_bio->remaining, 1);
 	md_write_start(mddev);
@@ -710,7 +714,6 @@ static int raid1_spare_active(mddev_t *m
 	conf_t *conf = mddev->private;
 	mirror_info_t *tmp;
 
-	spin_lock_irq(&conf->device_lock);
 	/*
 	 * Find all failed disks within the RAID1 configuration 
 	 * and mark them readable
@@ -725,7 +728,6 @@ static int raid1_spare_active(mddev_t *m
 			tmp->rdev->in_sync = 1;
 		}
 	}
-	spin_unlock_irq(&conf->device_lock);
 
 	print_conf(conf);
 	return 0;
@@ -739,10 +741,8 @@ static int raid1_add_disk(mddev_t *mddev
 	int mirror;
 	mirror_info_t *p;
 
-	spin_lock_irq(&conf->device_lock);
 	for (mirror=0; mirror < mddev->raid_disks; mirror++)
 		if ( !(p=conf->mirrors+mirror)->rdev) {
-			p->rdev = rdev;
 
 			blk_queue_stack_limits(mddev->queue,
 					       rdev->bdev->bd_disk->queue);
@@ -757,9 +757,9 @@ static int raid1_add_disk(mddev_t *mddev
 			p->head_position = 0;
 			rdev->raid_disk = mirror;
 			found = 1;
+			p->rdev = rdev;
 			break;
 		}
-	spin_unlock_irq(&conf->device_lock);
 
 	print_conf(conf);
 	return found;
@@ -768,24 +768,27 @@ static int raid1_add_disk(mddev_t *mddev
 static int raid1_remove_disk(mddev_t *mddev, int number)
 {
 	conf_t *conf = mddev->private;
-	int err = 1;
+	int err = 0;
+	mdk_rdev_t *rdev;
 	mirror_info_t *p = conf->mirrors+ number;
 
 	print_conf(conf);
-	spin_lock_irq(&conf->device_lock);
-	if (p->rdev) {
-		if (p->rdev->in_sync ||
-		    atomic_read(&p->rdev->nr_pending)) {
+	rdev = p->rdev;
+	if (rdev) {
+		if (rdev->in_sync ||
+		    atomic_read(&rdev->nr_pending)) {
 			err = -EBUSY;
 			goto abort;
 		}
 		p->rdev = NULL;
-		err = 0;
+		synchronize_kernel();
+		if (atomic_read(&rdev->nr_pending)) {
+			/* lost the race, try later */
+			err = -EBUSY;
+			p->rdev = rdev;
+		}
 	}
-	if (err)
-		MD_BUG();
 abort:
-	spin_unlock_irq(&conf->device_lock);
 
 	print_conf(conf);
 	return err;
@@ -1022,7 +1025,7 @@ static int sync_request(mddev_t *mddev, 
 	 */
 	disk = conf->last_used;
 	/* make sure disk is operational */
-	spin_lock_irq(&conf->device_lock);
+
 	while (conf->mirrors[disk].rdev == NULL ||
 	       !conf->mirrors[disk].rdev->in_sync) {
 		if (disk <= 0)
@@ -1033,7 +1036,7 @@ static int sync_request(mddev_t *mddev, 
 	}
 	conf->last_used = disk;
 	atomic_inc(&conf->mirrors[disk].rdev->nr_pending);
-	spin_unlock_irq(&conf->device_lock);
+
 
 	mirror = conf->mirrors + disk;
 

diff ./drivers/md/raid10.c~current~ ./drivers/md/raid10.c
--- ./drivers/md/raid10.c~current~	2004-09-08 11:58:02.000000000 +1000
+++ ./drivers/md/raid10.c	2004-09-08 11:59:00.000000000 +1000
@@ -498,7 +498,7 @@ static int read_balance(conf_t *conf, r1
 	sector_t new_distance, current_distance;
 
 	raid10_find_phys(conf, r10_bio);
-	spin_lock_irq(&conf->device_lock);
+	rcu_read_lock();
 	/*
 	 * Check if we can balance. We can balance on the whole
 	 * device if no resync is going on, or below the resync window.
@@ -570,7 +570,7 @@ rb_out:
 
 	if (disk >= 0 && conf->mirrors[disk].rdev)
 		atomic_inc(&conf->mirrors[disk].rdev->nr_pending);
-	spin_unlock_irq(&conf->device_lock);
+	rcu_read_unlock();
 
 	return disk;
 }
@@ -579,26 +579,26 @@ static void unplug_slaves(mddev_t *mddev
 {
 	conf_t *conf = mddev_to_conf(mddev);
 	int i;
-	unsigned long flags;
 
-	spin_lock_irqsave(&conf->device_lock, flags);
+	rcu_read_lock();
 	for (i=0; i<mddev->raid_disks; i++) {
 		mdk_rdev_t *rdev = conf->mirrors[i].rdev;
 		if (rdev && !rdev->faulty && atomic_read(&rdev->nr_pending)) {
 			request_queue_t *r_queue = bdev_get_queue(rdev->bdev);
 
 			atomic_inc(&rdev->nr_pending);
-			spin_unlock_irqrestore(&conf->device_lock, flags);
+			rcu_read_unlock();
 
 			if (r_queue->unplug_fn)
 				r_queue->unplug_fn(r_queue);
 
-			spin_lock_irqsave(&conf->device_lock, flags);
 			rdev_dec_pending(rdev, mddev);
+			rcu_read_lock();
 		}
 	}
-	spin_unlock_irqrestore(&conf->device_lock, flags);
+	rcu_read_unlock();
 }
+
 static void raid10_unplug(request_queue_t *q)
 {
 	unplug_slaves(q->queuedata);
@@ -609,10 +609,9 @@ static int raid10_issue_flush(request_qu
 {
 	mddev_t *mddev = q->queuedata;
 	conf_t *conf = mddev_to_conf(mddev);
-	unsigned long flags;
 	int i, ret = 0;
 
-	spin_lock_irqsave(&conf->device_lock, flags);
+	rcu_read_lock();
 	for (i=0; i<mddev->raid_disks && ret == 0; i++) {
 		mdk_rdev_t *rdev = conf->mirrors[i].rdev;
 		if (rdev && !rdev->faulty) {
@@ -621,12 +620,17 @@ static int raid10_issue_flush(request_qu
 
 			if (!r_queue->issue_flush_fn)
 				ret = -EOPNOTSUPP;
-			else
+			else {
+				atomic_inc(&rdev->nr_pending);
+				rcu_read_unlock();
 				ret = r_queue->issue_flush_fn(r_queue, bdev->bd_disk,
 							      error_sector);
+				rdev_dec_pending(rdev, mddev);
+				rcu_read_lock();
+			}
 		}
 	}
-	spin_unlock_irqrestore(&conf->device_lock, flags);
+	rcu_read_unlock();
 	return ret;
 }
 
@@ -757,7 +761,7 @@ static int make_request(request_queue_t 
 	 * bios[x] to bio
 	 */
 	raid10_find_phys(conf, r10_bio);
-	spin_lock_irq(&conf->device_lock);
+	rcu_read_lock();
 	for (i = 0;  i < conf->copies; i++) {
 		int d = r10_bio->devs[i].devnum;
 		if (conf->mirrors[d].rdev &&
@@ -767,7 +771,7 @@ static int make_request(request_queue_t 
 		} else
 			r10_bio->devs[i].bio = NULL;
 	}
-	spin_unlock_irq(&conf->device_lock);
+	rcu_read_unlock();
 
 	atomic_set(&r10_bio->remaining, 1);
 	md_write_start(mddev);
@@ -900,7 +904,6 @@ static int raid10_spare_active(mddev_t *
 	conf_t *conf = mddev->private;
 	mirror_info_t *tmp;
 
-	spin_lock_irq(&conf->device_lock);
 	/*
 	 * Find all non-in_sync disks within the RAID10 configuration
 	 * and mark them in_sync
@@ -915,7 +918,6 @@ static int raid10_spare_active(mddev_t *
 			tmp->rdev->in_sync = 1;
 		}
 	}
-	spin_unlock_irq(&conf->device_lock);
 
 	print_conf(conf);
 	return 0;
@@ -934,10 +936,9 @@ static int raid10_add_disk(mddev_t *mdde
 		 * very different from resync
 		 */
 		return 0;
-	spin_lock_irq(&conf->device_lock);
+
 	for (mirror=0; mirror < mddev->raid_disks; mirror++)
 		if ( !(p=conf->mirrors+mirror)->rdev) {
-			p->rdev = rdev;
 
 			blk_queue_stack_limits(mddev->queue,
 					       rdev->bdev->bd_disk->queue);
@@ -952,9 +953,9 @@ static int raid10_add_disk(mddev_t *mdde
 			p->head_position = 0;
 			rdev->raid_disk = mirror;
 			found = 1;
+			p->rdev = rdev;
 			break;
 		}
-	spin_unlock_irq(&conf->device_lock);
 
 	print_conf(conf);
 	return found;
@@ -963,24 +964,27 @@ static int raid10_add_disk(mddev_t *mdde
 static int raid10_remove_disk(mddev_t *mddev, int number)
 {
 	conf_t *conf = mddev->private;
-	int err = 1;
+	int err = 0;
+	mdk_rdev_t *rdev;
 	mirror_info_t *p = conf->mirrors+ number;
 
 	print_conf(conf);
-	spin_lock_irq(&conf->device_lock);
-	if (p->rdev) {
-		if (p->rdev->in_sync ||
-		    atomic_read(&p->rdev->nr_pending)) {
+	rdev = p->rdev;
+	if (rdev) {
+		if (rdev->in_sync ||
+		    atomic_read(&rdev->nr_pending)) {
 			err = -EBUSY;
 			goto abort;
 		}
 		p->rdev = NULL;
-		err = 0;
+		synchronize_kernel();
+		if (atomic_read(&rdev->nr_pending)) {
+			/* lost the race, try later */
+			err = -EBUSY;
+			p->rdev = rdev;
+		}
 	}
-	if (err)
-		MD_BUG();
 abort:
-	spin_unlock_irq(&conf->device_lock);
 
 	print_conf(conf);
 	return err;
@@ -1468,7 +1472,7 @@ static int sync_request(mddev_t *mddev, 
 		set_bit(R10BIO_IsSync, &r10_bio->state);
 		raid10_find_phys(conf, r10_bio);
 		r10_bio->sectors = (sector_nr | conf->chunk_mask) - sector_nr +1;
-		spin_lock_irq(&conf->device_lock);
+
 		for (i=0; i<conf->copies; i++) {
 			int d = r10_bio->devs[i].devnum;
 			bio = r10_bio->devs[i].bio;
@@ -1488,7 +1492,7 @@ static int sync_request(mddev_t *mddev, 
 			bio->bi_bdev = conf->mirrors[d].rdev->bdev;
 			count++;
 		}
-		spin_unlock_irq(&conf->device_lock);
+
 		if (count < 2) {
 			for (i=0; i<conf->copies; i++) {
 				int d = r10_bio->devs[i].devnum;

diff ./drivers/md/raid5.c~current~ ./drivers/md/raid5.c
--- ./drivers/md/raid5.c~current~	2004-09-08 11:57:21.000000000 +1000
+++ ./drivers/md/raid5.c	2004-09-08 11:59:00.000000000 +1000
@@ -1247,13 +1247,13 @@ static void handle_stripe(struct stripe_
 		else
 			bi->bi_end_io = raid5_end_read_request;
  
-		spin_lock_irq(&conf->device_lock);
+		rcu_read_lock();
 		rdev = conf->disks[i].rdev;
 		if (rdev && rdev->faulty)
 			rdev = NULL;
 		if (rdev)
 			atomic_inc(&rdev->nr_pending);
-		spin_unlock_irq(&conf->device_lock);
+		rcu_read_unlock();
  
 		if (rdev) {
 			if (test_bit(R5_Syncio, &sh->dev[i].flags))
@@ -1302,25 +1302,24 @@ static void unplug_slaves(mddev_t *mddev
 {
 	raid5_conf_t *conf = mddev_to_conf(mddev);
 	int i;
-	unsigned long flags;
 
-	spin_lock_irqsave(&conf->device_lock, flags);
+	rcu_read_lock();
 	for (i=0; i<mddev->raid_disks; i++) {
 		mdk_rdev_t *rdev = conf->disks[i].rdev;
 		if (rdev && !rdev->faulty && atomic_read(&rdev->nr_pending)) {
 			request_queue_t *r_queue = bdev_get_queue(rdev->bdev);
 
 			atomic_inc(&rdev->nr_pending);
-			spin_unlock_irqrestore(&conf->device_lock, flags);
+			rcu_read_unlock();
 
 			if (r_queue->unplug_fn)
 				r_queue->unplug_fn(r_queue);
 
-			spin_lock_irqsave(&conf->device_lock, flags);
 			rdev_dec_pending(rdev, mddev);
+			rcu_read_lock();
 		}
 	}
-	spin_unlock_irqrestore(&conf->device_lock, flags);
+	rcu_read_unlock();
 }
 
 static void raid5_unplug_device(request_queue_t *q)
@@ -1347,6 +1346,7 @@ static int raid5_issue_flush(request_que
 	raid5_conf_t *conf = mddev_to_conf(mddev);
 	int i, ret = 0;
 
+	rcu_read_lock();
 	for (i=0; i<mddev->raid_disks && ret == 0; i++) {
 		mdk_rdev_t *rdev = conf->disks[i].rdev;
 		if (rdev && !rdev->faulty) {
@@ -1355,11 +1355,17 @@ static int raid5_issue_flush(request_que
 
 			if (!r_queue->issue_flush_fn)
 				ret = -EOPNOTSUPP;
-			else
+			else {
+				atomic_inc(&rdev->nr_pending);
+				rcu_read_unlock();
 				ret = r_queue->issue_flush_fn(r_queue, bdev->bd_disk,
 							      error_sector);
+				rdev_dec_pending(rdev, mddev);
+				rcu_read_lock();
+			}
 		}
 	}
+	rcu_read_unlock();
 	return ret;
 }
 
@@ -1789,7 +1795,6 @@ static int raid5_spare_active(mddev_t *m
 	raid5_conf_t *conf = mddev->private;
 	struct disk_info *tmp;
 
-	spin_lock_irq(&conf->device_lock);
 	for (i = 0; i < conf->raid_disks; i++) {
 		tmp = conf->disks + i;
 		if (tmp->rdev
@@ -1801,7 +1806,6 @@ static int raid5_spare_active(mddev_t *m
 			tmp->rdev->in_sync = 1;
 		}
 	}
-	spin_unlock_irq(&conf->device_lock);
 	print_raid5_conf(conf);
 	return 0;
 }
@@ -1809,25 +1813,28 @@ static int raid5_spare_active(mddev_t *m
 static int raid5_remove_disk(mddev_t *mddev, int number)
 {
 	raid5_conf_t *conf = mddev->private;
-	int err = 1;
+	int err = 0;
+	mdk_rdev_t *rdev;
 	struct disk_info *p = conf->disks + number;
 
 	print_raid5_conf(conf);
-	spin_lock_irq(&conf->device_lock);
-
-	if (p->rdev) {
-		if (p->rdev->in_sync || 
-		    atomic_read(&p->rdev->nr_pending)) {
+	rdev = p->rdev;
+	if (rdev) {
+		if (rdev->in_sync || 
+		    atomic_read(&rdev->nr_pending)) {
 			err = -EBUSY;
 			goto abort;
 		}
 		p->rdev = NULL;
-		err = 0;
+		synchronize_kernel();
+		if (atomic_read(&rdev->nr_pending)) {
+			/* lost the race, try later */
+			err = -EBUSY;
+			p->rdev = rdev;
+		}
 	}
-	if (err)
-		MD_BUG();
 abort:
-	spin_unlock_irq(&conf->device_lock);
+
 	print_raid5_conf(conf);
 	return err;
 }
@@ -1839,19 +1846,17 @@ static int raid5_add_disk(mddev_t *mddev
 	int disk;
 	struct disk_info *p;
 
-	spin_lock_irq(&conf->device_lock);
 	/*
 	 * find the disk ...
 	 */
 	for (disk=0; disk < mddev->raid_disks; disk++)
 		if ((p=conf->disks + disk)->rdev == NULL) {
-			p->rdev = rdev;
 			rdev->in_sync = 0;
 			rdev->raid_disk = disk;
 			found = 1;
+			p->rdev = rdev;
 			break;
 		}
-	spin_unlock_irq(&conf->device_lock);
 	print_raid5_conf(conf);
 	return found;
 }

diff ./drivers/md/raid6main.c~current~ ./drivers/md/raid6main.c
--- ./drivers/md/raid6main.c~current~	2004-09-08 11:57:21.000000000 +1000
+++ ./drivers/md/raid6main.c	2004-09-08 11:59:00.000000000 +1000
@@ -1409,13 +1409,13 @@ static void handle_stripe(struct stripe_
 		else
 			bi->bi_end_io = raid6_end_read_request;
 
-		spin_lock_irq(&conf->device_lock);
+		rcu_read_lock();
 		rdev = conf->disks[i].rdev;
 		if (rdev && rdev->faulty)
 			rdev = NULL;
 		if (rdev)
 			atomic_inc(&rdev->nr_pending);
-		spin_unlock_irq(&conf->device_lock);
+		rcu_read_unlock();
 
 		if (rdev) {
 			if (test_bit(R5_Syncio, &sh->dev[i].flags))
@@ -1464,25 +1464,24 @@ static void unplug_slaves(mddev_t *mddev
 {
 	raid6_conf_t *conf = mddev_to_conf(mddev);
 	int i;
-	unsigned long flags;
 
-	spin_lock_irqsave(&conf->device_lock, flags);
+	rcu_read_lock();
 	for (i=0; i<mddev->raid_disks; i++) {
 		mdk_rdev_t *rdev = conf->disks[i].rdev;
 		if (rdev && !rdev->faulty && atomic_read(&rdev->nr_pending)) {
 			request_queue_t *r_queue = bdev_get_queue(rdev->bdev);
 
 			atomic_inc(&rdev->nr_pending);
-			spin_unlock_irqrestore(&conf->device_lock, flags);
+			rcu_read_unlock();
 
 			if (r_queue->unplug_fn)
 				r_queue->unplug_fn(r_queue);
 
-			spin_lock_irqsave(&conf->device_lock, flags);
 			rdev_dec_pending(rdev, mddev);
+			rcu_read_lock();
 		}
 	}
-	spin_unlock_irqrestore(&conf->device_lock, flags);
+	rcu_read_unlock();
 }
 
 static void raid6_unplug_device(request_queue_t *q)
@@ -1509,6 +1508,7 @@ static int raid6_issue_flush(request_que
 	raid6_conf_t *conf = mddev_to_conf(mddev);
 	int i, ret = 0;
 
+	rcu_read_lock();
 	for (i=0; i<mddev->raid_disks && ret == 0; i++) {
 		mdk_rdev_t *rdev = conf->disks[i].rdev;
 		if (rdev && !rdev->faulty) {
@@ -1517,11 +1517,17 @@ static int raid6_issue_flush(request_que
 
 			if (!r_queue->issue_flush_fn)
 				ret = -EOPNOTSUPP;
-			else
+			else {
+				atomic_inc(&rdev->nr_pending);
+				rcu_read_unlock();
 				ret = r_queue->issue_flush_fn(r_queue, bdev->bd_disk,
 							      error_sector);
+				rdev_dec_pending(rdev, mddev);
+				rcu_read_lock();
+			}
 		}
 	}
+	rcu_read_unlock();
 	return ret;
 }
 
@@ -1958,7 +1964,6 @@ static int raid6_spare_active(mddev_t *m
 	raid6_conf_t *conf = mddev->private;
 	struct disk_info *tmp;
 
-	spin_lock_irq(&conf->device_lock);
 	for (i = 0; i < conf->raid_disks; i++) {
 		tmp = conf->disks + i;
 		if (tmp->rdev
@@ -1970,7 +1975,6 @@ static int raid6_spare_active(mddev_t *m
 			tmp->rdev->in_sync = 1;
 		}
 	}
-	spin_unlock_irq(&conf->device_lock);
 	print_raid6_conf(conf);
 	return 0;
 }
@@ -1978,25 +1982,29 @@ static int raid6_spare_active(mddev_t *m
 static int raid6_remove_disk(mddev_t *mddev, int number)
 {
 	raid6_conf_t *conf = mddev->private;
-	int err = 1;
+	int err = 0;
+	mdk_rdev_t *rdev;
 	struct disk_info *p = conf->disks + number;
 
 	print_raid6_conf(conf);
-	spin_lock_irq(&conf->device_lock);
-
-	if (p->rdev) {
-		if (p->rdev->in_sync ||
-		    atomic_read(&p->rdev->nr_pending)) {
+	rdev = p->rdev;
+	if (rdev) {
+		if (rdev->in_sync ||
+		    atomic_read(&rdev->nr_pending)) {
 			err = -EBUSY;
 			goto abort;
 		}
 		p->rdev = NULL;
-		err = 0;
+		synchronize_kernel();
+		if (atomic_read(&rdev->nr_pending)) {
+			/* lost the race, try later */
+			err = -EBUSY;
+			p->rdev = rdev;
+		}
 	}
-	if (err)
-		MD_BUG();
+
 abort:
-	spin_unlock_irq(&conf->device_lock);
+
 	print_raid6_conf(conf);
 	return err;
 }
@@ -2008,19 +2016,17 @@ static int raid6_add_disk(mddev_t *mddev
 	int disk;
 	struct disk_info *p;
 
-	spin_lock_irq(&conf->device_lock);
 	/*
 	 * find the disk ...
 	 */
 	for (disk=0; disk < mddev->raid_disks; disk++)
 		if ((p=conf->disks + disk)->rdev == NULL) {
-			p->rdev = rdev;
 			rdev->in_sync = 0;
 			rdev->raid_disk = disk;
 			found = 1;
+			p->rdev = rdev;
 			break;
 		}
-	spin_unlock_irq(&conf->device_lock);
 	print_raid6_conf(conf);
 	return found;
 }
