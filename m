From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 25/36] md/raid10: avoid reading from known bad blocks -
 part 2
Date: Thu, 21 Jul 2011 12:58:50 +1000
Message-ID: <20110721025849.8422.71112.stgit@notabene.brown>
References: <20110721024556.8422.99443.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110721024556.8422.99443.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

When redirecting a read error to a different device, we must
again avoid bad blocks and possibly split the request.

Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/raid10.c |   45 ++++++++++++++++++++++++++++++++++++++++-----
 1 files changed, 40 insertions(+), 5 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 872bf94..0dcd172 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1746,14 +1746,15 @@ static void handle_read_error(mddev_t *mddev, r10bio_t *r10_bio)
 	rdev_dec_pending(conf->mirrors[mirror].rdev, mddev);
 
 	bio = r10_bio->devs[slot].bio;
+	bdevname(bio->bi_bdev, b);
 	r10_bio->devs[slot].bio =
 		mddev->ro ? IO_BLOCKED : NULL;
+read_more:
 	mirror = read_balance(conf, r10_bio, &max_sectors);
-	if (mirror == -1 || max_sectors < r10_bio->sectors) {
+	if (mirror == -1) {
 		printk(KERN_ALERT "md/raid10:%s: %s: unrecoverable I/O"
 		       " read error for block %llu\n",
-		       mdname(mddev),
-		       bdevname(bio->bi_bdev, b),
+		       mdname(mddev), b,
 		       (unsigned long long)r10_bio->sector);
 		raid_end_bio_io(r10_bio);
 		bio_put(bio);
@@ -1761,7 +1762,8 @@ static void handle_read_error(mddev_t *mddev, r10bio_t *r10_bio)
 	}
 
 	do_sync = (r10_bio->master_bio->bi_rw & REQ_SYNC);
-	bio_put(bio);
+	if (bio)
+		bio_put(bio);
 	slot = r10_bio->read_slot;
 	rdev = conf->mirrors[mirror].rdev;
 	printk_ratelimited(
@@ -1773,6 +1775,9 @@ static void handle_read_error(mddev_t *mddev, r10bio_t *r10_bio)
 		(unsigned long long)r10_bio->sector);
 	bio = bio_clone_mddev(r10_bio->master_bio,
 			      GFP_NOIO, mddev);
+	md_trim_bio(bio,
+		    r10_bio->sector - bio->bi_sector,
+		    max_sectors);
 	r10_bio->devs[slot].bio = bio;
 	bio->bi_sector = r10_bio->devs[slot].addr
 		+ rdev->data_offset;
@@ -1780,7 +1785,37 @@ static void handle_read_error(mddev_t *mddev, r10bio_t *r10_bio)
 	bio->bi_rw = READ | do_sync;
 	bio->bi_private = r10_bio;
 	bio->bi_end_io = raid10_end_read_request;
-	generic_make_request(bio);
+	if (max_sectors < r10_bio->sectors) {
+		/* Drat - have to split this up more */
+		struct bio *mbio = r10_bio->master_bio;
+		int sectors_handled =
+			r10_bio->sector + max_sectors
+			- mbio->bi_sector;
+		r10_bio->sectors = max_sectors;
+		spin_lock_irq(&conf->device_lock);
+		if (mbio->bi_phys_segments == 0)
+			mbio->bi_phys_segments = 2;
+		else
+			mbio->bi_phys_segments++;
+		spin_lock_irq(&conf->device_lock);
+		generic_make_request(bio);
+		bio = NULL;
+
+		r10_bio = mempool_alloc(conf->r10bio_pool,
+					GFP_NOIO);
+		r10_bio->master_bio = mbio;
+		r10_bio->sectors = (mbio->bi_size >> 9)
+			- sectors_handled;
+		r10_bio->state = 0;
+		set_bit(R10BIO_ReadError,
+			&r10_bio->state);
+		r10_bio->mddev = mddev;
+		r10_bio->sector = mbio->bi_sector
+			+ sectors_handled;
+
+		goto read_more;
+	} else
+		generic_make_request(bio);
 }
 
 static void raid10d(mddev_t *mddev)


