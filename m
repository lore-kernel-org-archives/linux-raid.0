From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 36/36] md/raid10: handle further errors during
 fix_read_error better.
Date: Thu, 21 Jul 2011 12:58:51 +1000
Message-ID: <20110721025851.8422.93455.stgit@notabene.brown>
References: <20110721024556.8422.99443.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110721024556.8422.99443.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

If we find more read/write errors we should record a bad block before
failing the device.

Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/raid10.c |   59 ++++++++++++++++++++++++++++++++++++++-------------
 1 files changed, 44 insertions(+), 15 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index b02e384..9214e08 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1749,6 +1749,26 @@ static void check_decay_read_errors(mddev_t *mddev, mdk_rdev_t *rdev)
 		atomic_set(&rdev->read_errors, read_errors >> hours_since_last);
 }
 
+static int r10_sync_page_io(mdk_rdev_t *rdev, sector_t sector,
+			    int sectors, struct page *page, int rw)
+{
+	sector_t first_bad;
+	int bad_sectors;
+
+	if (is_badblock(rdev, sector, sectors, &first_bad, &bad_sectors)
+	    && (rw == READ || test_bit(WriteErrorSeen, &rdev->flags)))
+		return -1;
+	if (sync_page_io(rdev, sector, sectors << 9, page, rw, false))
+		/* success */
+		return 1;
+	if (rw == WRITE)
+		set_bit(WriteErrorSeen, &rdev->flags);
+	/* need to record an error - either for the block or the device */
+	if (!rdev_set_badblocks(rdev, sector, sectors, 0))
+		md_error(rdev->mddev, rdev);
+	return 0;
+}
+
 /*
  * This is a kernel thread which:
  *
@@ -1832,9 +1852,19 @@ static void fix_read_error(conf_t *conf, mddev_t *mddev, r10bio_t *r10_bio)
 		rcu_read_unlock();
 
 		if (!success) {
-			/* Cannot read from anywhere -- bye bye array */
+			/* Cannot read from anywhere, just mark the block
+			 * as bad on the first device to discourage future
+			 * reads.
+			 */
 			int dn = r10_bio->devs[r10_bio->read_slot].devnum;
-			md_error(mddev, conf->mirrors[dn].rdev);
+			rdev = conf->mirrors[dn].rdev;
+
+			if (!rdev_set_badblocks(
+				    rdev,
+				    r10_bio->devs[r10_bio->read_slot].addr
+				    + sect,
+				    s, 0))
+				md_error(mddev, rdev);
 			break;
 		}
 
@@ -1855,10 +1885,10 @@ static void fix_read_error(conf_t *conf, mddev_t *mddev, r10bio_t *r10_bio)
 
 			atomic_inc(&rdev->nr_pending);
 			rcu_read_unlock();
-			if (sync_page_io(rdev,
-					 r10_bio->devs[sl].addr +
-					 sect,
-					 s<<9, conf->tmppage, WRITE, false)
+			if (r10_sync_page_io(rdev,
+					     r10_bio->devs[sl].addr +
+					     sect,
+					     s<<9, conf->tmppage, WRITE)
 			    == 0) {
 				/* Well, this device is dead */
 				printk(KERN_NOTICE
@@ -1873,7 +1903,6 @@ static void fix_read_error(conf_t *conf, mddev_t *mddev, r10bio_t *r10_bio)
 				       "drive\n",
 				       mdname(mddev),
 				       bdevname(rdev->bdev, b));
-				md_error(mddev, rdev);
 			}
 			rdev_dec_pending(rdev, mddev);
 			rcu_read_lock();
@@ -1893,11 +1922,12 @@ static void fix_read_error(conf_t *conf, mddev_t *mddev, r10bio_t *r10_bio)
 
 			atomic_inc(&rdev->nr_pending);
 			rcu_read_unlock();
-			if (sync_page_io(rdev,
-					 r10_bio->devs[sl].addr +
-					 sect,
-					 s<<9, conf->tmppage,
-					 READ, false) == 0) {
+			switch (r10_sync_page_io(rdev,
+					     r10_bio->devs[sl].addr +
+					     sect,
+					     s<<9, conf->tmppage,
+						 READ)) {
+			case 0:
 				/* Well, this device is dead */
 				printk(KERN_NOTICE
 				       "md/raid10:%s: unable to read back "
@@ -1911,9 +1941,8 @@ static void fix_read_error(conf_t *conf, mddev_t *mddev, r10bio_t *r10_bio)
 				       "drive\n",
 				       mdname(mddev),
 				       bdevname(rdev->bdev, b));
-
-				md_error(mddev, rdev);
-			} else {
+				break;
+			case 1:
 				printk(KERN_INFO
 				       "md/raid10:%s: read error corrected"
 				       " (%d sectors at %llu on %s)\n",


