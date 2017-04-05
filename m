From: NeilBrown <neilb@suse.com>
Subject: [md PATCH 08/10] md/raid5: make chunk_aligned_read() split bios
 more cleanly.
Date: Wed, 05 Apr 2017 14:05:51 +1000
Message-ID: <149136515124.25893.6650408840570246136.stgit@noble>
References: <149136485390.25893.1797855041954158826.stgit@noble>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <149136485390.25893.1797855041954158826.stgit@noble>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

chunk_aligned_read() currently uses fs_bio_set - which is meant for
filesystems to use - and loops if multiple splits are needed, which is
not best practice.
As this is only used for READ requests, not writes, it is unlikely
to cause a problem.  However it is best to be consistent in how
we split bios, and to follow the pattern used in raid1/raid10.

So create a private bioset, bio_split, and use it to perform a single
split, submitting the remainder to generic_make_request() for later
processing.

Signed-off-by: NeilBrown <neilb@suse.com>
---
 drivers/md/raid5.c |   33 +++++++++++++++++----------------
 drivers/md/raid5.h |    1 +
 2 files changed, 18 insertions(+), 16 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 6036d5e41ddd..c523fd69a7bc 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -5234,24 +5234,20 @@ static int raid5_read_one_chunk(struct mddev *mddev, struct bio *raid_bio)
 static struct bio *chunk_aligned_read(struct mddev *mddev, struct bio *raid_bio)
 {
 	struct bio *split;
+	sector_t sector = raid_bio->bi_iter.bi_sector;
+	unsigned chunk_sects = mddev->chunk_sectors;
+	unsigned sectors = chunk_sects - (sector & (chunk_sects-1));
 
-	do {
-		sector_t sector = raid_bio->bi_iter.bi_sector;
-		unsigned chunk_sects = mddev->chunk_sectors;
-		unsigned sectors = chunk_sects - (sector & (chunk_sects-1));
-
-		if (sectors < bio_sectors(raid_bio)) {
-			split = bio_split(raid_bio, sectors, GFP_NOIO, fs_bio_set);
-			bio_chain(split, raid_bio);
-		} else
-			split = raid_bio;
+	if (sectors < bio_sectors(raid_bio)) {
+		struct r5conf *conf = mddev->private;
+		split = bio_split(raid_bio, sectors, GFP_NOIO, conf->bio_split);
+		bio_chain(split, raid_bio);
+		generic_make_request(raid_bio);
+		raid_bio = split;
+	}
 
-		if (!raid5_read_one_chunk(mddev, split)) {
-			if (split != raid_bio)
-				generic_make_request(raid_bio);
-			return split;
-		}
-	} while (split != raid_bio);
+	if (!raid5_read_one_chunk(mddev, raid_bio))
+		return split;
 
 	return NULL;
 }
@@ -6735,6 +6731,8 @@ static void free_conf(struct r5conf *conf)
 		if (conf->disks[i].extra_page)
 			put_page(conf->disks[i].extra_page);
 	kfree(conf->disks);
+	if (conf->bio_split)
+		bioset_free(conf->bio_split);
 	kfree(conf->stripe_hashtbl);
 	kfree(conf->pending_data);
 	kfree(conf);
@@ -6910,6 +6908,9 @@ static struct r5conf *setup_conf(struct mddev *mddev)
 			goto abort;
 	}
 
+	conf->bio_split = bioset_create(BIO_POOL_SIZE, 0);
+	if (!conf->bio_split)
+		goto abort;
 	conf->mddev = mddev;
 
 	if ((conf->stripe_hashtbl = kzalloc(PAGE_SIZE, GFP_KERNEL)) == NULL)
diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
index cdc7f92e1806..625c7f16fd6b 100644
--- a/drivers/md/raid5.h
+++ b/drivers/md/raid5.h
@@ -646,6 +646,7 @@ struct r5conf {
 	int			pool_size; /* number of disks in stripeheads in pool */
 	spinlock_t		device_lock;
 	struct disk_info	*disks;
+	struct bio_set		*bio_split;
 
 	/* When taking over an array from a different personality, we store
 	 * the new thread here until we fully activate the array.


