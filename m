From: NeilBrown <neilb@suse.com>
Subject: [md PATCH 08/15] md/raid1,
 raid10: move rXbio accounting closer to allocation.
Date: Wed, 15 Mar 2017 14:05:13 +1100
Message-ID: <148954711347.18641.13034185168501168622.stgit@noble>
References: <148954692173.18641.1294690639716682540.stgit@noble>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <148954692173.18641.1294690639716682540.stgit@noble>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org, hch@lst.de
List-Id: linux-raid.ids

When raid1 or raid10 find they will need to allocate a new
r1bio/r10bio, in order to work around a known bad block, they
account for the allocation well before the allocation is
made.  This separation makes the correctness less obvious
and requires comments.

The accounting needs to be a little before: before the first
rXbio is submitted, but that is all.

So move the accounting down to where it makes more sense.

Signed-off-by: NeilBrown <neilb@suse.com>
---
 drivers/md/raid1.c  |   24 +++++++++++-------------
 drivers/md/raid10.c |   22 +++++++++-------------
 2 files changed, 20 insertions(+), 26 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index d3da6b36e670..7e509a894f15 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1436,18 +1436,9 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio)
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
@@ -1553,10 +1544,17 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio)
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
+
+		r1_bio_write_done(r1_bio);
 		r1_bio = alloc_r1bio(mddev, bio, sectors_handled);
 		goto retry_write;
 	}
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index b1b1f982a722..20029345f8b6 100644
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
 
@@ -1504,10 +1494,16 @@ static void raid10_write_request(struct mddev *mddev, struct bio *bio,
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


