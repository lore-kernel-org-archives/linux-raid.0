From: NeilBrown <neilb@suse.de>
Subject: [PATCH md 014 of 18] Attempt to auto-correct read errors in raid1.
Date: Mon, 28 Nov 2005 10:40:48 +1100
Message-ID: <1051127234048.14901@suse.de>
References: <20051128102824.14498.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


On a read-error we suspend the array, then synchronously read the
block from other arrays until we find one where we can read it.  Then
we try writing the good data back everywhere and make sure it works.
If any write or subsequent read fails, only then do we fail the device
out of the array.

To be able to suspend the array, we need to also keep track of how
many requests are queued for handling by raid1d.

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/md.c            |    1 
 ./drivers/md/raid1.c         |  115 +++++++++++++++++++++++++++++++++++++++----
 ./include/linux/raid/raid1.h |    3 +
 3 files changed, 109 insertions(+), 10 deletions(-)

diff ./drivers/md/md.c~current~ ./drivers/md/md.c
--- ./drivers/md/md.c~current~	2005-11-28 10:12:52.000000000 +1100
+++ ./drivers/md/md.c	2005-11-28 10:13:11.000000000 +1100
@@ -461,6 +461,7 @@ int sync_page_io(struct block_device *bd
 	bio_put(bio);
 	return ret;
 }
+EXPORT_SYMBOL(sync_page_io);
 
 static int read_disk_sb(mdk_rdev_t * rdev, int size)
 {

diff ./drivers/md/raid1.c~current~ ./drivers/md/raid1.c
--- ./drivers/md/raid1.c~current~	2005-11-28 10:12:40.000000000 +1100
+++ ./drivers/md/raid1.c	2005-11-28 10:13:11.000000000 +1100
@@ -191,6 +191,7 @@ static void reschedule_retry(r1bio_t *r1
 
 	spin_lock_irqsave(&conf->device_lock, flags);
 	list_add(&r1_bio->retry_list, &conf->retry_list);
+	conf->nr_queued ++;
 	spin_unlock_irqrestore(&conf->device_lock, flags);
 
 	wake_up(&conf->wait_barrier);
@@ -245,9 +246,9 @@ static int raid1_end_read_request(struct
 	/*
 	 * this branch is our 'one mirror IO has finished' event handler:
 	 */
-	if (!uptodate)
-		md_error(r1_bio->mddev, conf->mirrors[mirror].rdev);
-	else
+	update_head_pos(mirror, r1_bio);
+
+	if (uptodate || conf->working_disks <= 1) {
 		/*
 		 * Set R1BIO_Uptodate in our master bio, so that
 		 * we will return a good error code for to the higher
@@ -259,14 +260,8 @@ static int raid1_end_read_request(struct
 		 */
 		set_bit(R1BIO_Uptodate, &r1_bio->state);
 
-	update_head_pos(mirror, r1_bio);
-
-	/*
-	 * we have only one bio on the read side
-	 */
-	if (uptodate)
 		raid_end_bio_io(r1_bio);
-	else {
+	} else {
 		/*
 		 * oops, read error:
 		 */
@@ -652,6 +647,32 @@ static void allow_barrier(conf_t *conf)
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
+			    raid1_unplug(conf->mddev->queue));
+	spin_unlock_irq(&conf->resync_lock);
+}
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
 
 /* duplicate the data pages for behind I/O */
 static struct page **alloc_behind_pages(struct bio *bio)
@@ -1195,6 +1216,7 @@ static void raid1d(mddev_t *mddev)
 			break;
 		r1_bio = list_entry(head->prev, r1bio_t, retry_list);
 		list_del(head->prev);
+		conf->nr_queued--;
 		spin_unlock_irqrestore(&conf->device_lock, flags);
 
 		mddev = r1_bio->mddev;
@@ -1234,6 +1256,74 @@ static void raid1d(mddev_t *mddev)
 				}
 		} else {
 			int disk;
+
+			/* we got a read error. Maybe the drive is bad.  Maybe just
+			 * the block and we can fix it.
+			 * We freeze all other IO, and try reading the block from
+			 * other devices.  When we find one, we re-write
+			 * and check it that fixes the read error.
+			 * This is all done synchronously while the array is
+			 * frozen
+			 */
+			sector_t sect = r1_bio->sector;
+			int sectors = r1_bio->sectors;
+			freeze_array(conf);
+			while(sectors) {
+				int s = sectors;
+				int d = r1_bio->read_disk;
+				int success = 0;
+
+				if (s > (PAGE_SIZE>>9))
+					s = PAGE_SIZE >> 9;
+
+				do {
+					rdev = conf->mirrors[d].rdev;
+					if (rdev &&
+					    test_bit(In_sync, &rdev->flags) &&
+					    sync_page_io(rdev->bdev,
+							 sect + rdev->data_offset,
+							 s<<9,
+							 conf->tmppage, READ))
+						success = 1;
+					else {
+						d++;
+						if (d == conf->raid_disks)
+							d = 0;
+					}
+				} while (!success && d != r1_bio->read_disk);
+
+				if (success) {
+					/* write it back and re-read */
+					while (d != r1_bio->read_disk) {
+						if (d==0)
+							d = conf->raid_disks;
+						d--;
+						rdev = conf->mirrors[d].rdev;
+						if (rdev &&
+						    test_bit(In_sync, &rdev->flags)) {
+							if (sync_page_io(rdev->bdev,
+									 sect + rdev->data_offset,
+									 s<<9, conf->tmppage, WRITE) == 0 ||
+							    sync_page_io(rdev->bdev,
+									 sect + rdev->data_offset,
+									 s<<9, conf->tmppage, READ) == 0) {
+								/* Well, this device is dead */
+								md_error(mddev, rdev);
+							}
+						}
+					}
+				} else {
+					/* Cannot read from anywhere -- bye bye array */
+					md_error(mddev, conf->mirrors[r1_bio->read_disk].rdev);
+					break;
+				}
+				sectors -= s;
+				sect += s;
+			}
+
+
+			unfreeze_array(conf);
+
 			bio = r1_bio->bios[r1_bio->read_disk];
 			if ((disk=read_balance(conf, r1_bio)) == -1) {
 				printk(KERN_ALERT "raid1: %s: unrecoverable I/O"
@@ -1528,6 +1618,10 @@ static int run(mddev_t *mddev)
 
 	memset(conf->mirrors, 0, sizeof(struct mirror_info)*mddev->raid_disks);
 
+	conf->tmppage = alloc_page(GFP_KERNEL);
+	if (!conf->tmppage)
+		goto out_no_mem;
+
 	conf->poolinfo = kmalloc(sizeof(*conf->poolinfo), GFP_KERNEL);
 	if (!conf->poolinfo)
 		goto out_no_mem;
@@ -1634,6 +1728,7 @@ out_free_conf:
 		if (conf->r1bio_pool)
 			mempool_destroy(conf->r1bio_pool);
 		kfree(conf->mirrors);
+		__free_page(conf->tmppage);
 		kfree(conf->poolinfo);
 		kfree(conf);
 		mddev->private = NULL;

diff ./include/linux/raid/raid1.h~current~ ./include/linux/raid/raid1.h
--- ./include/linux/raid/raid1.h~current~	2005-11-28 10:12:17.000000000 +1100
+++ ./include/linux/raid/raid1.h	2005-11-28 10:13:11.000000000 +1100
@@ -46,6 +46,7 @@ struct r1_private_data_s {
 	spinlock_t		resync_lock;
 	int			nr_pending;
 	int			nr_waiting;
+	int			nr_queued;
 	int			barrier;
 	sector_t		next_resync;
 	int			fullsync;  /* set to 1 if a full sync is needed,
@@ -57,6 +58,8 @@ struct r1_private_data_s {
 
 	struct pool_info	*poolinfo;
 
+	struct page		*tmppage;
+
 	mempool_t *r1bio_pool;
 	mempool_t *r1buf_pool;
 };
