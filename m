From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 02/17] md/raid10:  change read_balance to return an rdev
Date: Wed, 02 Nov 2011 16:25:43 +1100
Message-ID: <20111102052543.17566.51222.stgit@notabene.brown>
References: <20111102051851.17566.52748.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20111102051851.17566.52748.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

It makes more sense to return an rdev than just an index as
read_balance() gets a reference to the rdev and so returning
the pointer make this more idiomatic.

This will be needed in a future patch when we might return
a 'replacement' rdev instead of the main rdev.

Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/raid10.c |   27 +++++++++++++--------------
 1 files changed, 13 insertions(+), 14 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 93e47f6..254a6ce 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -589,7 +589,9 @@ static int raid10_mergeable_bvec(struct request_queue *q,
  * FIXME: possibly should rethink readbalancing and do it differently
  * depending on near_copies / far_copies geometry.
  */
-static int read_balance(struct r10conf *conf, struct r10bio *r10_bio, int *max_sectors)
+static struct md_rdev *read_balance(struct r10conf *conf,
+				    struct r10bio *r10_bio,
+				    int *max_sectors)
 {
 	const sector_t this_sector = r10_bio->sector;
 	int disk, slot;
@@ -702,11 +704,11 @@ retry:
 		}
 		r10_bio->read_slot = slot;
 	} else
-		disk = -1;
+		rdev = NULL;
 	rcu_read_unlock();
 	*max_sectors = best_good_sectors;
 
-	return disk;
+	return rdev;
 }
 
 static int raid10_congested(void *data, int bits)
@@ -873,7 +875,6 @@ static void unfreeze_array(struct r10conf *conf)
 static int make_request(struct mddev *mddev, struct bio * bio)
 {
 	struct r10conf *conf = mddev->private;
-	struct mirror_info *mirror;
 	struct r10bio *r10_bio;
 	struct bio *read_bio;
 	int i;
@@ -974,17 +975,16 @@ static int make_request(struct mddev *mddev, struct bio * bio)
 		/*
 		 * read balancing logic:
 		 */
-		int disk;
+		struct md_rdev *rdev;
 		int slot;
 
 read_again:
-		disk = read_balance(conf, r10_bio, &max_sectors);
-		slot = r10_bio->read_slot;
-		if (disk < 0) {
+		rdev = read_balance(conf, r10_bio, &max_sectors);
+		if (!rdev) {
 			raid_end_bio_io(r10_bio);
 			return 0;
 		}
-		mirror = conf->mirrors + disk;
+		slot = r10_bio->read_slot;
 
 		read_bio = bio_clone_mddev(bio, GFP_NOIO, mddev);
 		md_trim_bio(read_bio, r10_bio->sector - bio->bi_sector,
@@ -993,8 +993,8 @@ read_again:
 		r10_bio->devs[slot].bio = read_bio;
 
 		read_bio->bi_sector = r10_bio->devs[slot].addr +
-			mirror->rdev->data_offset;
-		read_bio->bi_bdev = mirror->rdev->bdev;
+			rdev->data_offset;
+		read_bio->bi_bdev = rdev->bdev;
 		read_bio->bi_end_io = raid10_end_read_request;
 		read_bio->bi_rw = READ | do_sync;
 		read_bio->bi_private = r10_bio;
@@ -2118,8 +2118,8 @@ static void handle_read_error(struct mddev *mddev, struct r10bio *r10_bio)
 	r10_bio->devs[slot].bio =
 		mddev->ro ? IO_BLOCKED : NULL;
 read_more:
-	mirror = read_balance(conf, r10_bio, &max_sectors);
-	if (mirror == -1) {
+	rdev = read_balance(conf, r10_bio, &max_sectors);
+	if (rdev == NULL) {
 		printk(KERN_ALERT "md/raid10:%s: %s: unrecoverable I/O"
 		       " read error for block %llu\n",
 		       mdname(mddev), b,
@@ -2133,7 +2133,6 @@ read_more:
 	if (bio)
 		bio_put(bio);
 	slot = r10_bio->read_slot;
-	rdev = conf->mirrors[mirror].rdev;
 	printk_ratelimited(
 		KERN_ERR
 		"md/raid10:%s: %s: redirecting"


