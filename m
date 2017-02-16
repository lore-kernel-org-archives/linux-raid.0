From: NeilBrown <neilb@suse.com>
Subject: [md PATCH 08/14] md/raid1,
 raid10: move rXbio accounting closer to allocation.
Date: Thu, 16 Feb 2017 15:39:02 +1100
Message-ID: <148721994238.7521.906707300050565451.stgit@noble>
References: <148721992248.7521.17160361058957519076.stgit@noble>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <148721992248.7521.17160361058957519076.stgit@noble>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org, hch@lst.de
List-Id: linux-raid.ids

When raid1 or raid10 need find they will need to allocate
a new r1bio/r10bio, in order to work around a known bad block,
the account for the allocation well before the allocation
is made.  This separation makes the correctness less obvious and
requires comments.

The accounting needs to be a little before: before the first rXbio is
submitted, but that is all.

So move the accounting down to where it makes more sense.

Signed-off-by: NeilBrown <neilb@suse.com>
---
 drivers/md/raid1.c  |   23 ++++++++++-------------
 drivers/md/raid10.c |   22 +++++++++-------------
 2 files changed, 19 insertions(+), 26 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 7b0f647bcccb..c1d0675880fb 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1326,18 +1326,9 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
 		goto retry_write;
 	}
 
-	if (max_sectors < r1_bio->sectors) {
-		/* We are splitting this write into multiple parts, so
-		 * we need to prepare for allocating another r1_bio.
-		 */
+	if (max_sectors < r1_bio->sectors)
 		r1_bio->sectors = max_sectors;
-		spin_lock_irq(&conf->device_lock);
-		if (bio->bi_phys_segments == 0)
-			bio->bi_phys_segments = 2;
-		else
-			bio->bi_phys_segments++;
-		spin_unlock_irq(&conf->device_lock);
-	}
+
 	sectors_handled = r1_bio->sector + max_sectors - bio->bi_iter.bi_sector;
 
 	atomic_set(&r1_bio->remaining, 1);
@@ -1426,10 +1417,16 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
 	 * as it could result in the bio being freed.
 	 */
 	if (sectors_handled < bio_sectors(bio)) {
-		r1_bio_write_done(r1_bio);
-		/* We need another r1_bio.  It has already been counted
+		/* We need another r1_bio, which must be accounted
 		 * in bio->bi_phys_segments
 		 */
+		spin_lock_irq(&conf->device_lock);
+		if (bio->bi_phys_segments == 0)
+			bio->bi_phys_segments = 2;
+		else
+			bio->bi_phys_segments++;
+		spin_unlock_irq(&conf->device_lock);
+		r1_bio_write_done(r1_bio);
 		r1_bio = mempool_alloc(conf->r1bio_pool, GFP_NOIO);
 		r1_bio->master_bio = bio;
 		r1_bio->sectors = bio_sectors(bio) - sectors_handled;
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 1920756828df..9258cbe233bb 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1383,18 +1383,8 @@ static void raid10_write_request(struct mddev *mddev, struct bio *bio,
 		goto retry_write;
 	}
 
-	if (max_sectors < r10_bio->sectors) {
-		/* We are splitting this into multiple parts, so
-		 * we need to prepare for allocating another r10_bio.
-		 */
+	if (max_sectors < r10_bio->sectors)
 		r10_bio->sectors = max_sectors;
-		spin_lock_irq(&conf->device_lock);
-		if (bio->bi_phys_segments == 0)
-			bio->bi_phys_segments = 2;
-		else
-			bio->bi_phys_segments++;
-		spin_unlock_irq(&conf->device_lock);
-	}
 	sectors_handled = r10_bio->sector + max_sectors -
 		bio->bi_iter.bi_sector;
 
@@ -1491,10 +1481,16 @@ static void raid10_write_request(struct mddev *mddev, struct bio *bio,
 	 */
 
 	if (sectors_handled < bio_sectors(bio)) {
-		one_write_done(r10_bio);
-		/* We need another r10_bio.  It has already been counted
+		/* We need another r10_bio and it needs to be counted
 		 * in bio->bi_phys_segments.
 		 */
+		spin_lock_irq(&conf->device_lock);
+		if (bio->bi_phys_segments == 0)
+			bio->bi_phys_segments = 2;
+		else
+			bio->bi_phys_segments++;
+		spin_unlock_irq(&conf->device_lock);
+		one_write_done(r10_bio);
 		r10_bio = mempool_alloc(conf->r10bio_pool, GFP_NOIO);
 
 		r10_bio->master_bio = bio;


