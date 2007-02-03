From: Chris Wright <chrisw@sous-sol.org>
Subject: [patch 05/59] md: pass down BIO_RW_SYNC in raid{1,10}
Date: Fri, 02 Feb 2007 18:35:09 -0800
Message-ID: <20070203023816.610328000@sous-sol.org>
References: <20070203023504.435051000@sous-sol.org>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1946236AbXBCCg6@vger.kernel.org>
Content-Disposition: inline; filename=md-pass-down-bio_rw_sync-in-raid-1-10.patch
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, stable@kernel.org, Lars Ellenberg <Lars.Ellenberg@linbit.com>
Cc: Justin Forbes <jmforbes@linuxtx.org>, Zwane Mwaikambo <zwane@arm.linux.org.uk>, Theodore Ts'o <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>, Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>, Chris Wedgwood <reviews@ml.cw.f00f.org>, Michael Krufky <mkrufky@linuxtv.org>, torvalds@linux-foundation.org, akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, Andrew Morton <akpm@osdl.org>, Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org, Ingo Molnar <mingo@redhat.com>, Jens Axboe <jens.axboe@oracle.com>, Lars Ellenberg <lars@linbit.com>
List-Id: linux-raid.ids

-stable review patch.  If anyone has any objections, please let us know.
------------------

From: Lars Ellenberg <Lars.Ellenberg@linbit.com>

md raidX make_request functions strip off the BIO_RW_SYNC flag, thus
introducing additional latency.

Fixing this in raid1 and raid10 seems to be straightforward enough.

For our particular usage case in DRBD, passing this flag improved some
initialization time from ~5 minutes to ~5 seconds.

Acked-by: NeilBrown <neilb@suse.de>
Signed-off-by: Lars Ellenberg <lars@linbit.com>
Acked-by: Jens Axboe <jens.axboe@oracle.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 drivers/md/raid1.c  |   13 +++++++++----
 drivers/md/raid10.c |   11 ++++++++---
 2 files changed, 17 insertions(+), 7 deletions(-)

--- linux-2.6.19.2.orig/drivers/md/raid1.c
+++ linux-2.6.19.2/drivers/md/raid1.c
@@ -775,6 +775,7 @@ static int make_request(request_queue_t 
 	struct bio_list bl;
 	struct page **behind_pages = NULL;
 	const int rw = bio_data_dir(bio);
+	const int do_sync = bio_sync(bio);
 	int do_barriers;
 
 	/*
@@ -835,7 +836,7 @@ static int make_request(request_queue_t 
 		read_bio->bi_sector = r1_bio->sector + mirror->rdev->data_offset;
 		read_bio->bi_bdev = mirror->rdev->bdev;
 		read_bio->bi_end_io = raid1_end_read_request;
-		read_bio->bi_rw = READ;
+		read_bio->bi_rw = READ | do_sync;
 		read_bio->bi_private = r1_bio;
 
 		generic_make_request(read_bio);
@@ -906,7 +907,7 @@ static int make_request(request_queue_t 
 		mbio->bi_sector	= r1_bio->sector + conf->mirrors[i].rdev->data_offset;
 		mbio->bi_bdev = conf->mirrors[i].rdev->bdev;
 		mbio->bi_end_io	= raid1_end_write_request;
-		mbio->bi_rw = WRITE | do_barriers;
+		mbio->bi_rw = WRITE | do_barriers | do_sync;
 		mbio->bi_private = r1_bio;
 
 		if (behind_pages) {
@@ -941,6 +942,8 @@ static int make_request(request_queue_t 
 	blk_plug_device(mddev->queue);
 	spin_unlock_irqrestore(&conf->device_lock, flags);
 
+	if (do_sync)
+		md_wakeup_thread(mddev->thread);
 #if 0
 	while ((bio = bio_list_pop(&bl)) != NULL)
 		generic_make_request(bio);
@@ -1541,6 +1544,7 @@ static void raid1d(mddev_t *mddev)
 			 * We already have a nr_pending reference on these rdevs.
 			 */
 			int i;
+			const int do_sync = bio_sync(r1_bio->master_bio);
 			clear_bit(R1BIO_BarrierRetry, &r1_bio->state);
 			clear_bit(R1BIO_Barrier, &r1_bio->state);
 			for (i=0; i < conf->raid_disks; i++)
@@ -1561,7 +1565,7 @@ static void raid1d(mddev_t *mddev)
 						conf->mirrors[i].rdev->data_offset;
 					bio->bi_bdev = conf->mirrors[i].rdev->bdev;
 					bio->bi_end_io = raid1_end_write_request;
-					bio->bi_rw = WRITE;
+					bio->bi_rw = WRITE | do_sync;
 					bio->bi_private = r1_bio;
 					r1_bio->bios[i] = bio;
 					generic_make_request(bio);
@@ -1593,6 +1597,7 @@ static void raid1d(mddev_t *mddev)
 				       (unsigned long long)r1_bio->sector);
 				raid_end_bio_io(r1_bio);
 			} else {
+				const int do_sync = bio_sync(r1_bio->master_bio);
 				r1_bio->bios[r1_bio->read_disk] =
 					mddev->ro ? IO_BLOCKED : NULL;
 				r1_bio->read_disk = disk;
@@ -1608,7 +1613,7 @@ static void raid1d(mddev_t *mddev)
 				bio->bi_sector = r1_bio->sector + rdev->data_offset;
 				bio->bi_bdev = rdev->bdev;
 				bio->bi_end_io = raid1_end_read_request;
-				bio->bi_rw = READ;
+				bio->bi_rw = READ | do_sync;
 				bio->bi_private = r1_bio;
 				unplug = 1;
 				generic_make_request(bio);
--- linux-2.6.19.2.orig/drivers/md/raid10.c
+++ linux-2.6.19.2/drivers/md/raid10.c
@@ -782,6 +782,7 @@ static int make_request(request_queue_t 
 	int i;
 	int chunk_sects = conf->chunk_mask + 1;
 	const int rw = bio_data_dir(bio);
+	const int do_sync = bio_sync(bio);
 	struct bio_list bl;
 	unsigned long flags;
 
@@ -863,7 +864,7 @@ static int make_request(request_queue_t 
 			mirror->rdev->data_offset;
 		read_bio->bi_bdev = mirror->rdev->bdev;
 		read_bio->bi_end_io = raid10_end_read_request;
-		read_bio->bi_rw = READ;
+		read_bio->bi_rw = READ | do_sync;
 		read_bio->bi_private = r10_bio;
 
 		generic_make_request(read_bio);
@@ -909,7 +910,7 @@ static int make_request(request_queue_t 
 			conf->mirrors[d].rdev->data_offset;
 		mbio->bi_bdev = conf->mirrors[d].rdev->bdev;
 		mbio->bi_end_io	= raid10_end_write_request;
-		mbio->bi_rw = WRITE;
+		mbio->bi_rw = WRITE | do_sync;
 		mbio->bi_private = r10_bio;
 
 		atomic_inc(&r10_bio->remaining);
@@ -922,6 +923,9 @@ static int make_request(request_queue_t 
 	blk_plug_device(mddev->queue);
 	spin_unlock_irqrestore(&conf->device_lock, flags);
 
+	if (do_sync)
+		md_wakeup_thread(mddev->thread);
+
 	return 0;
 }
 
@@ -1563,6 +1567,7 @@ static void raid10d(mddev_t *mddev)
 				       (unsigned long long)r10_bio->sector);
 				raid_end_bio_io(r10_bio);
 			} else {
+				const int do_sync = bio_sync(r10_bio->master_bio);
 				rdev = conf->mirrors[mirror].rdev;
 				if (printk_ratelimit())
 					printk(KERN_ERR "raid10: %s: redirecting sector %llu to"
@@ -1574,7 +1579,7 @@ static void raid10d(mddev_t *mddev)
 				bio->bi_sector = r10_bio->devs[r10_bio->read_slot].addr
 					+ rdev->data_offset;
 				bio->bi_bdev = rdev->bdev;
-				bio->bi_rw = READ;
+				bio->bi_rw = READ | do_sync;
 				bio->bi_private = r10_bio;
 				bio->bi_end_io = raid10_end_read_request;
 				unplug = 1;

--
