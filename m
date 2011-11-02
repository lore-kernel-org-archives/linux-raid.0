From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 01/17] md/raid10: prepare data structures for handling
 replacement.
Date: Wed, 02 Nov 2011 16:25:43 +1100
Message-ID: <20111102052543.17566.75686.stgit@notabene.brown>
References: <20111102051851.17566.52748.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20111102051851.17566.52748.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Allow each slot in the RAID10 to have 2 devices, the replaceable
and the replacement.

Also an r10bio to have 2 bios, and for resync/recovery allocate the
second bio if there are any replacement devices.

Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/raid10.c |   48 ++++++++++++++++++++++++++++++++++------
 drivers/md/raid10.h |   61 +++++++++++++++++++++++++++++++--------------------
 2 files changed, 78 insertions(+), 31 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index e43c55e..93e47f6 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -72,7 +72,8 @@ static void * r10bio_pool_alloc(gfp_t gfp_flags, void *data)
 	struct r10conf *conf = data;
 	int size = offsetof(struct r10bio, devs[conf->copies]);
 
-	/* allocate a r10bio with room for raid_disks entries in the bios array */
+	/* allocate a r10bio with room for raid_disks entries in the
+	 * bios array */
 	return kzalloc(size, gfp_flags);
 }
 
@@ -122,12 +123,19 @@ static void * r10buf_pool_alloc(gfp_t gfp_flags, void *data)
 		if (!bio)
 			goto out_free_bio;
 		r10_bio->devs[j].bio = bio;
+		if (!conf->have_replacement)
+			continue;
+		bio = bio_kmalloc(gfp_flags, RESYNC_PAGES);
+		if (!bio)
+			goto out_free_bio;
+		r10_bio->devs[j].repl_bio = bio;
 	}
 	/*
 	 * Allocate RESYNC_PAGES data pages and attach them
 	 * where needed.
 	 */
 	for (j = 0 ; j < nalloc; j++) {
+		struct bio *rbio = r10_bio->devs[j].repl_bio;
 		bio = r10_bio->devs[j].bio;
 		for (i = 0; i < RESYNC_PAGES; i++) {
 			if (j == 1 && !test_bit(MD_RECOVERY_SYNC,
@@ -142,6 +150,8 @@ static void * r10buf_pool_alloc(gfp_t gfp_flags, void *data)
 				goto out_free_pages;
 
 			bio->bi_io_vec[i].bv_page = page;
+			if (rbio)
+				rbio->bi_io_vec[i].bv_page = page;
 		}
 	}
 
@@ -155,8 +165,11 @@ out_free_pages:
 			safe_put_page(r10_bio->devs[j].bio->bi_io_vec[i].bv_page);
 	j = -1;
 out_free_bio:
-	while ( ++j < nalloc )
+	while (++j < nalloc) {
 		bio_put(r10_bio->devs[j].bio);
+		if (r10_bio->devs[j].repl_bio)
+			bio_put(r10_bio->devs[j].repl_bio);
+	}
 	r10bio_pool_free(r10_bio, conf);
 	return NULL;
 }
@@ -177,6 +190,9 @@ static void r10buf_pool_free(void *__r10_bio, void *data)
 			}
 			bio_put(bio);
 		}
+		bio = r10bio->devs[j].repl_bio;
+		if (bio)
+			bio_put(bio);
 	}
 	r10bio_pool_free(r10bio, conf);
 }
@@ -190,6 +206,10 @@ static void put_all_bios(struct r10conf *conf, struct r10bio *r10_bio)
 		if (!BIO_SPECIAL(*bio))
 			bio_put(*bio);
 		*bio = NULL;
+		bio = &r10_bio->devs[i].repl_bio;
+		if (r10_bio->read_slot < 0 && !BIO_SPECIAL(*bio))
+			bio_put(*bio);
+		*bio = NULL;
 	}
 }
 
@@ -274,19 +294,27 @@ static inline void update_head_pos(int slot, struct r10bio *r10_bio)
  * Find the disk number which triggered given bio
  */
 static int find_bio_disk(struct r10conf *conf, struct r10bio *r10_bio,
-			 struct bio *bio, int *slotp)
+			 struct bio *bio, int *slotp, int *replp)
 {
 	int slot;
+	int repl = 0;
 
-	for (slot = 0; slot < conf->copies; slot++)
+	for (slot = 0; slot < conf->copies; slot++) {
 		if (r10_bio->devs[slot].bio == bio)
 			break;
+		if (r10_bio->devs[slot].repl_bio == bio) {
+			repl = 1;
+			break;
+		}
+	}
 
 	BUG_ON(slot == conf->copies);
 	update_head_pos(slot, r10_bio);
 
 	if (slotp)
 		*slotp = slot;
+	if (replp)
+		*replp = repl;
 	return r10_bio->devs[slot].devnum;
 }
 
@@ -367,7 +395,7 @@ static void raid10_end_write_request(struct bio *bio, int error)
 	struct r10conf *conf = r10_bio->mddev->private;
 	int slot;
 
-	dev = find_bio_disk(conf, r10_bio, bio, &slot);
+	dev = find_bio_disk(conf, r10_bio, bio, &slot, NULL);
 
 	/*
 	 * this branch is our 'one mirror IO has finished' event handler:
@@ -1026,6 +1054,7 @@ read_again:
 	 */
 	plugged = mddev_check_plugged(mddev);
 
+	r10_bio->read_slot = -1; /* make sure repl_bio gets freed */
 	raid10_find_phys(conf, r10_bio);
 retry_write:
 	blocked_rdev = NULL;
@@ -1433,7 +1462,7 @@ static void end_sync_read(struct bio *bio, int error)
 	struct r10conf *conf = r10_bio->mddev->private;
 	int d;
 
-	d = find_bio_disk(conf, r10_bio, bio, NULL);
+	d = find_bio_disk(conf, r10_bio, bio, NULL, NULL);
 
 	if (test_bit(BIO_UPTODATE, &bio->bi_flags))
 		set_bit(R10BIO_Uptodate, &r10_bio->state);
@@ -1495,7 +1524,7 @@ static void end_sync_write(struct bio *bio, int error)
 	int bad_sectors;
 	int slot;
 
-	d = find_bio_disk(conf, r10_bio, bio, &slot);
+	d = find_bio_disk(conf, r10_bio, bio, &slot, NULL);
 
 	if (!uptodate) {
 		set_bit(WriteErrorSeen, &conf->mirrors[d].rdev->flags);
@@ -2273,9 +2302,14 @@ static void raid10d(struct mddev *mddev)
 static int init_resync(struct r10conf *conf)
 {
 	int buffs;
+	int i;
 
 	buffs = RESYNC_WINDOW / RESYNC_BLOCK_SIZE;
 	BUG_ON(conf->r10buf_pool);
+	conf->have_replacement = 0;
+	for (i = 0; i < conf->raid_disks; i++)
+		if (conf->mirrors[i].replacement)
+			conf->have_replacement = 1;
 	conf->r10buf_pool = mempool_create(buffs, r10buf_pool_alloc, r10buf_pool_free, conf);
 	if (!conf->r10buf_pool)
 		return -ENOMEM;
diff --git a/drivers/md/raid10.h b/drivers/md/raid10.h
index 7facfdf..7c615613 100644
--- a/drivers/md/raid10.h
+++ b/drivers/md/raid10.h
@@ -2,7 +2,7 @@
 #define _RAID10_H
 
 struct mirror_info {
-	struct md_rdev	*rdev;
+	struct md_rdev	*rdev, *replacement;
 	sector_t	head_position;
 	int		recovery_disabled;	/* matches
 						 * mddev->recovery_disabled
@@ -18,12 +18,13 @@ struct r10conf {
 	spinlock_t		device_lock;
 
 	/* geometry */
-	int			near_copies;  /* number of copies laid out raid0 style */
+	int			near_copies;  /* number of copies laid out
+					       * raid0 style */
 	int 			far_copies;   /* number of copies laid out
 					       * at large strides across drives
 					       */
-	int			far_offset;   /* far_copies are offset by 1 stripe
-					       * instead of many
+	int			far_offset;   /* far_copies are offset by 1
+					       * stripe instead of many
 					       */
 	int			copies;	      /* near_copies * far_copies.
 					       * must be <= raid_disks
@@ -34,10 +35,11 @@ struct r10conf {
 					       * 1 stripe.
 					       */
 
-	sector_t		dev_sectors;  /* temp copy of mddev->dev_sectors */
+	sector_t		dev_sectors;  /* temp copy of
+					       * mddev->dev_sectors */
 
-	int chunk_shift; /* shift from chunks to sectors */
-	sector_t chunk_mask;
+	int			chunk_shift; /* shift from chunks to sectors */
+	sector_t		chunk_mask;
 
 	struct list_head	retry_list;
 	/* queue pending writes and submit them on unplug */
@@ -45,20 +47,22 @@ struct r10conf {
 	int			pending_count;
 
 	spinlock_t		resync_lock;
-	int nr_pending;
-	int nr_waiting;
-	int nr_queued;
-	int barrier;
+	int			nr_pending;
+	int			nr_waiting;
+	int			nr_queued;
+	int			barrier;
 	sector_t		next_resync;
 	int			fullsync;  /* set to 1 if a full sync is needed,
 					    * (fresh device added).
 					    * Cleared when a sync completes.
 					    */
-
+	int			have_replacement; /* There is at least one
+						   * replacement device.
+						   */
 	wait_queue_head_t	wait_barrier;
 
-	mempool_t *r10bio_pool;
-	mempool_t *r10buf_pool;
+	mempool_t		*r10bio_pool;
+	mempool_t		*r10buf_pool;
 	struct page		*tmppage;
 
 	/* When taking over an array from a different personality, we store
@@ -98,11 +102,18 @@ struct r10bio {
 	 * When resyncing we also use one for each copy.
 	 * When reconstructing, we use 2 bios, one for read, one for write.
 	 * We choose the number when they are allocated.
+	 * We sometimes need an extra bio to write to the replacement.
 	 */
 	struct {
-		struct bio		*bio;
-		sector_t addr;
-		int devnum;
+		struct bio	*bio;
+		union {
+			struct bio	*repl_bio; /* used for resync and
+						    * writes */
+			struct md_rdev	*rdev;	   /* used for reads
+						    * (read_slot >= 0) */
+		};
+		sector_t	addr;
+		int		devnum;
 	} devs[0];
 };
 
@@ -121,17 +132,19 @@ struct r10bio {
 #define BIO_SPECIAL(bio) ((unsigned long)bio <= 2)
 
 /* bits for r10bio.state */
-#define	R10BIO_Uptodate	0
-#define	R10BIO_IsSync	1
-#define	R10BIO_IsRecover 2
-#define	R10BIO_Degraded 3
+enum r10bio_state {
+	R10BIO_Uptodate,
+	R10BIO_IsSync,
+	R10BIO_IsRecover,
+	R10BIO_Degraded,
 /* Set ReadError on bios that experience a read error
  * so that raid10d knows what to do with them.
  */
-#define	R10BIO_ReadError 4
+	R10BIO_ReadError,
 /* If a write for this request means we can clear some
  * known-bad-block records, we set this flag.
  */
-#define	R10BIO_MadeGood 5
-#define	R10BIO_WriteError 6
+	R10BIO_MadeGood,
+	R10BIO_WriteError,
+};
 #endif


