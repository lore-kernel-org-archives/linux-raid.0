From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH md 8 of 9] raid1 support for bitmap intent logging
Date: Fri, 18 Feb 2005 11:40:44 +1100
Message-ID: <E1D1wCK-0000Xa-Ng@notabene.cse.unsw.edu.au>
References: <20050218111131.790.patches@notabene>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



Signed-off-by: Neil Brown <neilb@cse.unsw.edu.au>

### Diffstat output
 ./drivers/md/raid1.c         |  184 ++++++++++++++++++++++++++++++++++=
++-------
 ./include/linux/raid/raid1.h |   16 +++
 2 files changed, 169 insertions(+), 31 deletions(-)

diff ./drivers/md/raid1.c~current~ ./drivers/md/raid1.c
--- ./drivers/md/raid1.c~current~	2005-02-18 11:11:26.000000000 +1100
+++ ./drivers/md/raid1.c	2005-02-18 11:11:26.000000000 +1100
@@ -12,6 +12,15 @@
  * Fixes to reconstruction by Jakob =D8stergaard" <jakob@ostenfeld.dk>
  * Various fixes by Neil Brown <neilb@cse.unsw.edu.au>
  *
+ * Changes by Peter T. Breuer <ptb@it.uc3m.es> 31/1/2003 to support
+ * bitmapped intelligence in resync:
+ *
+ *      - bitmap marked during normal i/o
+ *      - bitmap used to skip nondirty blocks during sync
+ *
+ * Additions to bitmap code, (C) 2003-2004 Paul Clements, SteelEye Tec=
hnology:
+ * - persistent bitmap code
+ *
  * This program is free software; you can redistribute it and/or modif=
y
  * it under the terms of the GNU General Public License as published b=
y
  * the Free Software Foundation; either version 2, or (at your option)
@@ -22,7 +31,16 @@
  * Software Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
=20
+#include "dm-bio-list.h"
 #include <linux/raid/raid1.h>
+#include <linux/raid/bitmap.h>
+
+#define DEBUG 0
+#if DEBUG
+#define PRINTK(x...) printk(x)
+#else
+#define PRINTK(x...)
+#endif
=20
 /*
  * Number of guaranteed r1bios in case of extreme VM load:
@@ -287,9 +305,11 @@ static int raid1_end_write_request(struc
 	/*
 	 * this branch is our 'one mirror IO has finished' event handler:
 	 */
-	if (!uptodate)
+	if (!uptodate) {
 		md_error(r1_bio->mddev, conf->mirrors[mirror].rdev);
-	else
+		/* an I/O failed, we can't clear the bitmap */
+		set_bit(R1BIO_Degraded, &r1_bio->state);
+	} else
 		/*
 		 * Set R1BIO_Uptodate in our master bio, so that
 		 * we will return a good error code for to the higher
@@ -309,6 +329,10 @@ static int raid1_end_write_request(struc
 	 * already.
 	 */
 	if (atomic_dec_and_test(&r1_bio->remaining)) {
+		/* clear the bitmap if all writes complete successfully */
+		bitmap_endwrite(r1_bio->mddev->bitmap, r1_bio->sector,
+				r1_bio->sectors,
+				!test_bit(R1BIO_Degraded, &r1_bio->state));
 		md_write_end(r1_bio->mddev);
 		raid_end_bio_io(r1_bio);
 	}
@@ -458,7 +482,10 @@ static void unplug_slaves(mddev_t *mddev
=20
 static void raid1_unplug(request_queue_t *q)
 {
-	unplug_slaves(q->queuedata);
+	mddev_t *mddev =3D q->queuedata;
+
+	unplug_slaves(mddev);
+	md_wakeup_thread(mddev->thread);
 }
=20
 static int raid1_issue_flush(request_queue_t *q, struct gendisk *disk,
@@ -501,16 +528,16 @@ static void device_barrier(conf_t *conf,
 {
 	spin_lock_irq(&conf->resync_lock);
 	wait_event_lock_irq(conf->wait_idle, !waitqueue_active(&conf->wait_re=
sume),
-			    conf->resync_lock, unplug_slaves(conf->mddev));
+			    conf->resync_lock, raid1_unplug(conf->mddev->queue));
 =09
 	if (!conf->barrier++) {
 		wait_event_lock_irq(conf->wait_idle, !conf->nr_pending,
-				    conf->resync_lock, unplug_slaves(conf->mddev));
+				    conf->resync_lock, raid1_unplug(conf->mddev->queue));
 		if (conf->nr_pending)
 			BUG();
 	}
 	wait_event_lock_irq(conf->wait_resume, conf->barrier < RESYNC_DEPTH,
-			    conf->resync_lock, unplug_slaves(conf->mddev));
+			    conf->resync_lock, raid1_unplug(conf->mddev->queue));
 	conf->next_resync =3D sect;
 	spin_unlock_irq(&conf->resync_lock);
 }
@@ -522,8 +549,12 @@ static int make_request(request_queue_t=20
 	mirror_info_t *mirror;
 	r1bio_t *r1_bio;
 	struct bio *read_bio;
-	int i, disks;
+	int i, targets =3D 0, disks;
 	mdk_rdev_t *rdev;
+	struct bitmap *bitmap =3D mddev->bitmap;
+	unsigned long flags;
+	struct bio_list bl;
+
=20
 	/*
 	 * Register the new request and wait if the reconstruction
@@ -554,7 +585,7 @@ static int make_request(request_queue_t=20
=20
 	r1_bio->master_bio =3D bio;
 	r1_bio->sectors =3D bio->bi_size >> 9;
-
+	r1_bio->state =3D 0;
 	r1_bio->mddev =3D mddev;
 	r1_bio->sector =3D bio->bi_sector;
=20
@@ -597,6 +628,13 @@ static int make_request(request_queue_t=20
 	 * bios[x] to bio
 	 */
 	disks =3D conf->raid_disks;
+#if 0
+	{ static int first=3D1;
+	if (first) printk("First Write sector %llu disks %d\n",
+			  (unsigned long long)r1_bio->sector, disks);
+	first =3D 0;
+	}
+#endif
 	rcu_read_lock();
 	for (i =3D 0;  i < disks; i++) {
 		if ((rdev=3Dconf->mirrors[i].rdev) !=3D NULL &&
@@ -607,13 +645,21 @@ static int make_request(request_queue_t=20
 				r1_bio->bios[i] =3D NULL;
 			} else
 				r1_bio->bios[i] =3D bio;
+			targets++;
 		} else
 			r1_bio->bios[i] =3D NULL;
 	}
 	rcu_read_unlock();
=20
-	atomic_set(&r1_bio->remaining, 1);
+	if (targets < conf->raid_disks) {
+		/* array is degraded, we will not clear the bitmap
+		 * on I/O completion (see raid1_end_write_request) */
+		set_bit(R1BIO_Degraded, &r1_bio->state);
+	}
+
+	atomic_set(&r1_bio->remaining, 0);
=20
+	bio_list_init(&bl);
 	for (i =3D 0; i < disks; i++) {
 		struct bio *mbio;
 		if (!r1_bio->bios[i])
@@ -629,14 +675,23 @@ static int make_request(request_queue_t=20
 		mbio->bi_private =3D r1_bio;
=20
 		atomic_inc(&r1_bio->remaining);
-		generic_make_request(mbio);
-	}
=20
-	if (atomic_dec_and_test(&r1_bio->remaining)) {
-		md_write_end(mddev);
-		raid_end_bio_io(r1_bio);
+		bio_list_add(&bl, mbio);
 	}
=20
+	bitmap_startwrite(bitmap, bio->bi_sector, r1_bio->sectors);
+	spin_lock_irqsave(&conf->device_lock, flags);
+	bio_list_merge(&conf->pending_bio_list, &bl);
+	bio_list_init(&bl);
+
+	blk_plug_device(mddev->queue);
+	spin_unlock_irqrestore(&conf->device_lock, flags);
+=09
+#if 0
+	while ((bio =3D bio_list_pop(&bl)) !=3D NULL)=20
+		generic_make_request(bio);
+#endif
+
 	return 0;
 }
=20
@@ -716,7 +771,7 @@ static void close_sync(conf_t *conf)
 {
 	spin_lock_irq(&conf->resync_lock);
 	wait_event_lock_irq(conf->wait_resume, !conf->barrier,
-			    conf->resync_lock, 	unplug_slaves(conf->mddev));
+			    conf->resync_lock, 	raid1_unplug(conf->mddev->queue));
 	spin_unlock_irq(&conf->resync_lock);
=20
 	if (conf->barrier) BUG();
@@ -830,10 +885,11 @@ static int end_sync_read(struct bio *bio
 	 * or re-read if the read failed.
 	 * We don't do much here, just schedule handling by raid1d
 	 */
-	if (!uptodate)
+	if (!uptodate) {
 		md_error(r1_bio->mddev,
 			 conf->mirrors[r1_bio->read_disk].rdev);
-	else
+		set_bit(R1BIO_Degraded, &r1_bio->state);
+	} else
 		set_bit(R1BIO_Uptodate, &r1_bio->state);
 	rdev_dec_pending(conf->mirrors[r1_bio->read_disk].rdev, conf->mddev);
 	reschedule_retry(r1_bio);
@@ -857,8 +913,10 @@ static int end_sync_write(struct bio *bi
 			mirror =3D i;
 			break;
 		}
-	if (!uptodate)
+	if (!uptodate) {
 		md_error(mddev, conf->mirrors[mirror].rdev);
+		set_bit(R1BIO_Degraded, &r1_bio->state);
+	}
 	update_head_pos(mirror, r1_bio);
=20
 	if (atomic_dec_and_test(&r1_bio->remaining)) {
@@ -878,6 +936,9 @@ static void sync_request_write(mddev_t *
=20
 	bio =3D r1_bio->bios[r1_bio->read_disk];
=20
+/*
+	if (r1_bio->sector =3D=3D 0) printk("First sync write startss\n");
+*/
 	/*
 	 * schedule writes
 	 */
@@ -905,10 +966,12 @@ static void sync_request_write(mddev_t *
 		atomic_inc(&conf->mirrors[i].rdev->nr_pending);
 		atomic_inc(&r1_bio->remaining);
 		md_sync_acct(conf->mirrors[i].rdev->bdev, wbio->bi_size >> 9);
+
 		generic_make_request(wbio);
 	}
=20
 	if (atomic_dec_and_test(&r1_bio->remaining)) {
+		/* if we're here, all write(s) have completed, so clean up */
 		md_done_sync(mddev, r1_bio->sectors, 1);
 		put_buf(r1_bio);
 	}
@@ -937,6 +1000,26 @@ static void raid1d(mddev_t *mddev)
 	for (;;) {
 		char b[BDEVNAME_SIZE];
 		spin_lock_irqsave(&conf->device_lock, flags);
+
+		if (conf->pending_bio_list.head) {
+			bio =3D bio_list_get(&conf->pending_bio_list);
+			blk_remove_plug(mddev->queue);
+			spin_unlock_irqrestore(&conf->device_lock, flags);
+			/* flush any pending bitmap writes to disk before proceeding w/ I/O=
 */
+			if (bitmap_unplug(mddev->bitmap) !=3D 0)
+				printk("%s: bitmap file write failed!\n", mdname(mddev));
+
+			while (bio) { /* submit pending writes */
+				struct bio *next =3D bio->bi_next;
+				bio->bi_next =3D NULL;
+				generic_make_request(bio);
+				bio =3D next;
+			}
+			unplug =3D 1;
+
+			continue;
+		}
+
 		if (list_empty(head))
 			break;
 		r1_bio =3D list_entry(head->prev, r1bio_t, retry_list);
@@ -1020,17 +1103,43 @@ static sector_t sync_request(mddev_t *md
 	int disk;
 	int i;
 	int write_targets =3D 0;
+	int sync_blocks;
=20
-	if (!conf->r1buf_pool)
+	if (!conf->r1buf_pool)=20
+	{
+/*
+		printk("sync start - bitmap %p\n", mddev->bitmap);
+*/
 		if (init_resync(conf))
 			return 0;
+	}
=20
 	max_sector =3D mddev->size << 1;
 	if (sector_nr >=3D max_sector) {
+		/* If we aborted, we need to abort the
+		 * sync on the 'current' bitmap chunk (there will
+		 * only be one in raid1 resync.
+		 * We can find the current addess in mddev->curr_resync
+		 */
+		if (!conf->fullsync) {
+			if (mddev->curr_resync < max_sector)
+				bitmap_end_sync(mddev->bitmap,
+						mddev->curr_resync,
+						&sync_blocks, 1);
+			bitmap_close_sync(mddev->bitmap);
+		}
+		if (mddev->curr_resync >=3D max_sector)
+			conf->fullsync =3D 0;
 		close_sync(conf);
 		return 0;
 	}
=20
+	if (!conf->fullsync &&
+	    !bitmap_start_sync(mddev->bitmap, sector_nr, &sync_blocks)) {
+		/* We can skip this block, and probably several more */
+		*skipped =3D 1;
+		return sync_blocks;
+	}
 	/*
 	 * If there is non-resync activity waiting for us then
 	 * put in a delay to throttle resync.
@@ -1069,6 +1178,7 @@ static sector_t sync_request(mddev_t *md
=20
 	r1_bio->mddev =3D mddev;
 	r1_bio->sector =3D sector_nr;
+	r1_bio->state =3D 0;
 	set_bit(R1BIO_IsSync, &r1_bio->state);
 	r1_bio->read_disk =3D disk;
=20
@@ -1103,6 +1213,11 @@ static sector_t sync_request(mddev_t *md
 		bio->bi_bdev =3D conf->mirrors[i].rdev->bdev;
 		bio->bi_private =3D r1_bio;
 	}
+
+	if (write_targets + 1 < conf->raid_disks)
+		/* array degraded, can't clear bitmap */
+		set_bit(R1BIO_Degraded, &r1_bio->state);
+
 	if (write_targets =3D=3D 0) {
 		/* There is nowhere to write, so all non-sync
 		 * drives must be failed - so we are finished
@@ -1122,6 +1237,14 @@ static sector_t sync_request(mddev_t *md
 			len =3D (max_sector - sector_nr) << 9;
 		if (len =3D=3D 0)
 			break;
+		if (!conf->fullsync && sync_blocks =3D=3D 0)
+			if (!bitmap_start_sync(mddev->bitmap,=20
+					       sector_nr, &sync_blocks))=20
+				break;
+		if (sync_blocks < (PAGE_SIZE>>9))
+			BUG();
+		if (len > (sync_blocks<<9)) len =3D sync_blocks<<9;
+
 		for (i=3D0 ; i < conf->raid_disks; i++) {
 			bio =3D r1_bio->bios[i];
 			if (bio->bi_end_io) {
@@ -1144,6 +1267,7 @@ static sector_t sync_request(mddev_t *md
 		}
 		nr_sectors +=3D len>>9;
 		sector_nr +=3D len>>9;
+		sync_blocks -=3D (len>>9);
 	} while (r1_bio->bios[disk]->bi_vcnt < RESYNC_PAGES);
  bio_full:
 	bio =3D r1_bio->bios[disk];
@@ -1236,6 +1360,9 @@ static int run(mddev_t *mddev)
 	init_waitqueue_head(&conf->wait_idle);
 	init_waitqueue_head(&conf->wait_resume);
=20
+	bio_list_init(&conf->pending_bio_list);
+	bio_list_init(&conf->flushing_bio_list);
+
 	if (!conf->working_disks) {
 		printk(KERN_ERR "raid1: no operational mirrors for %s\n",
 			mdname(mddev));
@@ -1264,16 +1391,15 @@ static int run(mddev_t *mddev)
 	conf->last_used =3D j;
=20
=20
-
-	{
-		mddev->thread =3D md_register_thread(raid1d, mddev, "%s_raid1");
-		if (!mddev->thread) {
-			printk(KERN_ERR=20
-				"raid1: couldn't allocate thread for %s\n",=20
-				mdname(mddev));
-			goto out_free_conf;
-		}
+	mddev->thread =3D md_register_thread(raid1d, mddev, "%s_raid1");
+	if (!mddev->thread) {
+		printk(KERN_ERR=20
+		       "raid1: couldn't allocate thread for %s\n",=20
+		       mdname(mddev));
+		goto out_free_conf;
 	}
+	if (mddev->bitmap) mddev->thread->timeout =3D mddev->bitmap->daemon_s=
leep * HZ;
+
 	printk(KERN_INFO=20
 		"raid1: raid set %s active with %d out of %d mirrors\n",
 		mdname(mddev), mddev->raid_disks - mddev->degraded,=20
@@ -1386,7 +1512,7 @@ static int raid1_reshape(mddev_t *mddev,
 	spin_lock_irq(&conf->resync_lock);
 	conf->barrier++;
 	wait_event_lock_irq(conf->wait_idle, !conf->nr_pending,
-			    conf->resync_lock, unplug_slaves(mddev));
+			    conf->resync_lock, raid1_unplug(mddev->queue));
 	spin_unlock_irq(&conf->resync_lock);
=20
 	/* ok, everything is stopped */

diff ./include/linux/raid/raid1.h~current~ ./include/linux/raid/raid1.h
--- ./include/linux/raid/raid1.h~current~	2005-02-18 11:08:39.000000000=
 +1100
+++ ./include/linux/raid/raid1.h	2005-02-18 11:11:26.000000000 +1100
@@ -36,12 +36,21 @@ struct r1_private_data_s {
 	spinlock_t		device_lock;
=20
 	struct list_head	retry_list;
+	/* queue pending writes and submit them on unplug */
+	struct bio_list		pending_bio_list;
+	/* queue of writes that have been unplugged */
+	struct bio_list		flushing_bio_list;
+
 	/* for use when syncing mirrors: */
=20
 	spinlock_t		resync_lock;
-	int nr_pending;
-	int barrier;
+	int			nr_pending;
+	int			barrier;
 	sector_t		next_resync;
+	int			fullsync;  /* set to 1 if a full sync is needed,
+					    * (fresh device added).
+					    * Cleared when a sync completes.
+					    */
=20
 	wait_queue_head_t	wait_idle;
 	wait_queue_head_t	wait_resume;
@@ -85,14 +94,17 @@ struct r1bio_s {
 	int			read_disk;
=20
 	struct list_head	retry_list;
+	struct bitmap_update	*bitmap_update;
 	/*
 	 * if the IO is in WRITE direction, then multiple bios are used.
 	 * We choose the number when they are allocated.
 	 */
 	struct bio		*bios[0];
+	/* DO NOT PUT ANY NEW FIELDS HERE - bios array is contiguously alloce=
d*/
 };
=20
 /* bits for r1bio.state */
 #define	R1BIO_Uptodate	0
 #define	R1BIO_IsSync	1
+#define	R1BIO_Degraded	2
 #endif
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
