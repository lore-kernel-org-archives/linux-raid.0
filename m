From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 13/16] md/raid10: make more use of 'slot' in raid10d.
Date: Wed, 11 May 2011 16:30:31 +1000
Message-ID: <20110511063031.21263.7438.stgit@notabene.brown>
References: <20110511062743.21263.72802.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110511062743.21263.72802.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Now that we have a 'slot' variable, make better use of it to simplify
some code a little.

Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/raid10.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 8e4f469..80cc7e6 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1650,8 +1650,8 @@ static void raid10d(mddev_t *mddev)
 			}
 			rdev_dec_pending(conf->mirrors[mirror].rdev, mddev);
 
-			bio = r10_bio->devs[r10_bio->read_slot].bio;
-			r10_bio->devs[r10_bio->read_slot].bio =
+			bio = r10_bio->devs[slot].bio;
+			r10_bio->devs[slot].bio =
 				mddev->ro ? IO_BLOCKED : NULL;
 			mirror = read_balance(conf, r10_bio);
 			if (mirror == -1) {
@@ -1665,6 +1665,7 @@ static void raid10d(mddev_t *mddev)
 			} else {
 				const unsigned long do_sync = (r10_bio->master_bio->bi_rw & REQ_SYNC);
 				bio_put(bio);
+				slot = r10_bio->read_slot;
 				rdev = conf->mirrors[mirror].rdev;
 				if (printk_ratelimit())
 					printk(KERN_ERR "md/raid10:%s: %s: redirecting sector %llu to"
@@ -1674,8 +1675,8 @@ static void raid10d(mddev_t *mddev)
 					       (unsigned long long)r10_bio->sector);
 				bio = bio_clone_mddev(r10_bio->master_bio,
 						      GFP_NOIO, mddev);
-				r10_bio->devs[r10_bio->read_slot].bio = bio;
-				bio->bi_sector = r10_bio->devs[r10_bio->read_slot].addr
+				r10_bio->devs[slot].bio = bio;
+				bio->bi_sector = r10_bio->devs[slot].addr
 					+ rdev->data_offset;
 				bio->bi_bdev = rdev->bdev;
 				bio->bi_rw = READ | do_sync;


