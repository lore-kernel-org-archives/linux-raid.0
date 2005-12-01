From: NeilBrown <neilb@suse.de>
Subject: [PATCH md 004 of 14] auto-correct correctable read errors in raid10
Date: Thu, 1 Dec 2005 14:23:06 +1100
Message-ID: <1051201032306.29593@suse.de>
References: <20051201141508.29384.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Largely just a cross-port from raid1.

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/raid10.c         |  127 +++++++++++++++++++++++++++++++++++++-----
 ./include/linux/raid/raid10.h |    2 
 2 files changed, 114 insertions(+), 15 deletions(-)

diff ./drivers/md/raid10.c~current~ ./drivers/md/raid10.c
--- ./drivers/md/raid10.c~current~	2005-11-29 10:27:40.000000000 +1100
+++ ./drivers/md/raid10.c	2005-11-29 11:04:22.000000000 +1100
@@ -209,6 +209,7 @@ static void reschedule_retry(r10bio_t *r
 
 	spin_lock_irqsave(&conf->device_lock, flags);
 	list_add(&r10_bio->retry_list, &conf->retry_list);
+	conf->nr_queued ++;
 	spin_unlock_irqrestore(&conf->device_lock, flags);
 
 	md_wakeup_thread(mddev->thread);
@@ -254,9 +255,9 @@ static int raid10_end_read_request(struc
 	/*
 	 * this branch is our 'one mirror IO has finished' event handler:
 	 */
-	if (!uptodate)
-		md_error(r10_bio->mddev, conf->mirrors[dev].rdev);
-	else
+	update_head_pos(slot, r10_bio);
+
+	if (uptodate) {
 		/*
 		 * Set R10BIO_Uptodate in our master bio, so that
 		 * we will return a good error code to the higher
@@ -267,15 +268,8 @@ static int raid10_end_read_request(struc
 		 * wait for the 'master' bio.
 		 */
 		set_bit(R10BIO_Uptodate, &r10_bio->state);
-
-	update_head_pos(slot, r10_bio);
-
-	/*
-	 * we have only one bio on the read side
-	 */
-	if (uptodate)
 		raid_end_bio_io(r10_bio);
-	else {
+	} else {
 		/*
 		 * oops, read error:
 		 */
@@ -714,6 +708,33 @@ static void allow_barrier(conf_t *conf)
 	wake_up(&conf->wait_barrier);
 }
 
+static void freeze_array(conf_t *conf)
+{
+	/* stop syncio and normal IO and wait for everything to
+	 * go quite.
+	 * We increment barrier and nr_waiting, and then
+	 * wait until barrier+nr_pending match nr_queued+2
+	 */
+	spin_lock_irq(&conf->resync_lock);
+	conf->barrier++;
+	conf->nr_waiting++;
+	wait_event_lock_irq(conf->wait_barrier,
+			    conf->barrier+conf->nr_pending == conf->nr_queued+2,
+			    conf->resync_lock,
+			    raid10_unplug(conf->mddev->queue));
+	spin_unlock_irq(&conf->resync_lock);
+}
+
+static void unfreeze_array(conf_t *conf)
+{
+	/* reverse the effect of the freeze */
+	spin_lock_irq(&conf->resync_lock);
+	conf->barrier--;
+	conf->nr_waiting--;
+	wake_up(&conf->wait_barrier);
+	spin_unlock_irq(&conf->resync_lock);
+}
+
 static int make_request(request_queue_t *q, struct bio * bio)
 {
 	mddev_t *mddev = q->queuedata;
@@ -1338,6 +1359,7 @@ static void raid10d(mddev_t *mddev)
 			break;
 		r10_bio = list_entry(head->prev, r10bio_t, retry_list);
 		list_del(head->prev);
+		conf->nr_queued--;
 		spin_unlock_irqrestore(&conf->device_lock, flags);
 
 		mddev = r10_bio->mddev;
@@ -1350,6 +1372,78 @@ static void raid10d(mddev_t *mddev)
 			unplug = 1;
 		} else {
 			int mirror;
+			/* we got a read error. Maybe the drive is bad.  Maybe just
+			 * the block and we can fix it.
+			 * We freeze all other IO, and try reading the block from
+			 * other devices.  When we find one, we re-write
+			 * and check it that fixes the read error.
+			 * This is all done synchronously while the array is
+			 * frozen.
+			 */
+			int sect = 0; /* Offset from r10_bio->sector */
+			int sectors = r10_bio->sectors;
+			freeze_array(conf);
+			if (mddev->ro == 0) while(sectors) {
+				int s = sectors;
+				int sl = r10_bio->read_slot;
+				int success = 0;
+
+				if (s > (PAGE_SIZE>>9))
+					s = PAGE_SIZE >> 9;
+
+				do {
+					int d = r10_bio->devs[sl].devnum;
+					rdev = conf->mirrors[d].rdev;
+					if (rdev &&
+					    test_bit(In_sync, &rdev->flags) &&
+					    sync_page_io(rdev->bdev,
+							 r10_bio->devs[sl].addr +
+							 sect + rdev->data_offset,
+							 s<<9,
+							 conf->tmppage, READ))
+						success = 1;
+					else {
+						sl++;
+						if (sl == conf->copies)
+							sl = 0;
+					}
+				} while (!success && sl != r10_bio->read_slot);
+
+				if (success) {
+					/* write it back and re-read */
+					while (sl != r10_bio->read_slot) {
+						int d;
+						if (sl==0)
+							sl = conf->copies;
+						sl--;
+						d = r10_bio->devs[sl].devnum;
+						rdev = conf->mirrors[d].rdev;
+						if (rdev &&
+						    test_bit(In_sync, &rdev->flags)) {
+							if (sync_page_io(rdev->bdev,
+									 r10_bio->devs[sl].addr +
+									 sect + rdev->data_offset,
+									 s<<9, conf->tmppage, WRITE) == 0 ||
+							    sync_page_io(rdev->bdev,
+									 r10_bio->devs[sl].addr +
+									 sect + rdev->data_offset,
+									 s<<9, conf->tmppage, READ) == 0) {
+								/* Well, this device is dead */
+								md_error(mddev, rdev);
+							}
+						}
+					}
+				} else {
+					/* Cannot read from anywhere -- bye bye array */
+					md_error(mddev, conf->mirrors[r10_bio->devs[r10_bio->read_slot].devnum].rdev);
+					break;
+				}
+				sectors -= s;
+				sect += s;
+			}
+
+			unfreeze_array(conf);
+
 			bio = r10_bio->devs[r10_bio->read_slot].bio;
 			r10_bio->devs[r10_bio->read_slot].bio = NULL;
 			bio_put(bio);
@@ -1793,22 +1887,24 @@ static int run(mddev_t *mddev)
 	 * bookkeeping area. [whatever we allocate in run(),
 	 * should be freed in stop()]
 	 */
-	conf = kmalloc(sizeof(conf_t), GFP_KERNEL);
+	conf = kzalloc(sizeof(conf_t), GFP_KERNEL);
 	mddev->private = conf;
 	if (!conf) {
 		printk(KERN_ERR "raid10: couldn't allocate memory for %s\n",
 			mdname(mddev));
 		goto out;
 	}
-	memset(conf, 0, sizeof(*conf));
-	conf->mirrors = kmalloc(sizeof(struct mirror_info)*mddev->raid_disks,
+	conf->mirrors = kzalloc(sizeof(struct mirror_info)*mddev->raid_disks,
 				 GFP_KERNEL);
 	if (!conf->mirrors) {
 		printk(KERN_ERR "raid10: couldn't allocate memory for %s\n",
 		       mdname(mddev));
 		goto out_free_conf;
 	}
-	memset(conf->mirrors, 0, sizeof(struct mirror_info)*mddev->raid_disks);
+
+	conf->tmppage = alloc_page(GFP_KERNEL);
+	if (!conf->tmppage)
+		goto out_free_conf;
 
 	conf->near_copies = nc;
 	conf->far_copies = fc;
@@ -1918,6 +2014,7 @@ static int run(mddev_t *mddev)
 out_free_conf:
 	if (conf->r10bio_pool)
 		mempool_destroy(conf->r10bio_pool);
+	put_page(conf->tmppage);
 	kfree(conf->mirrors);
 	kfree(conf);
 	mddev->private = NULL;

diff ./include/linux/raid/raid10.h~current~ ./include/linux/raid/raid10.h
--- ./include/linux/raid/raid10.h~current~	2005-11-29 10:27:40.000000000 +1100
+++ ./include/linux/raid/raid10.h	2005-11-29 11:04:56.000000000 +1100
@@ -42,6 +42,7 @@ struct r10_private_data_s {
 	spinlock_t		resync_lock;
 	int nr_pending;
 	int nr_waiting;
+	int nr_queued;
 	int barrier;
 	sector_t		next_resync;
 	int			fullsync;  /* set to 1 if a full sync is needed,
@@ -53,6 +54,7 @@ struct r10_private_data_s {
 
 	mempool_t *r10bio_pool;
 	mempool_t *r10buf_pool;
+	struct page		*tmppage;
 };
 
 typedef struct r10_private_data_s conf_t;
