From: Andre Noll <maan@systemlinux.org>
Subject: [PATCH 3/6] md: Convert mddev->new_chunk to sectors.
Date: Mon, 25 May 2009 11:27:34 +0200
Message-ID: <1243243657-21855-4-git-send-email-maan@systemlinux.org>
References: <1243243657-21855-1-git-send-email-maan@systemlinux.org>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1243243657-21855-1-git-send-email-maan@systemlinux.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, Andre Noll <maan@systemlinux.org>
List-Id: linux-raid.ids

A straight-forward conversion which gets rid of some
multiplications/divisions/shifts. The patch also introduces a couple
of new ones, most of which are due to conf->chunk_size still being
represented in bytes. This will be cleaned up in subsequent patches.

Signed-off-by: Andre Noll <maan@systemlinux.org>
---
 drivers/md/md.c    |   29 +++++++++++++++--------------
 drivers/md/md.h    |    3 ++-
 drivers/md/raid1.c |    4 ++--
 drivers/md/raid5.c |   45 ++++++++++++++++++++++++---------------------
 4 files changed, 43 insertions(+), 38 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 66e32e4..a54ec91 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -886,13 +886,13 @@ static int super_90_validate(mddev_t *mddev, mdk_rdev_t *rdev)
 			mddev->delta_disks = sb->delta_disks;
 			mddev->new_level = sb->new_level;
 			mddev->new_layout = sb->new_layout;
-			mddev->new_chunk = sb->new_chunk;
+			mddev->new_chunk_sectors = sb->new_chunk >> 9;
 		} else {
 			mddev->reshape_position = MaxSector;
 			mddev->delta_disks = 0;
 			mddev->new_level = mddev->level;
 			mddev->new_layout = mddev->layout;
-			mddev->new_chunk = mddev->chunk_sectors << 9;
+			mddev->new_chunk_sectors = mddev->chunk_sectors;
 		}
 
 		if (sb->state & (1<<MD_SB_CLEAN))
@@ -1007,7 +1007,7 @@ static void super_90_sync(mddev_t *mddev, mdk_rdev_t *rdev)
 		sb->new_level = mddev->new_level;
 		sb->delta_disks = mddev->delta_disks;
 		sb->new_layout = mddev->new_layout;
-		sb->new_chunk = mddev->new_chunk;
+		sb->new_chunk = mddev->new_chunk_sectors << 9;
 	}
 	mddev->minor_version = sb->minor_version;
 	if (mddev->in_sync)
@@ -1300,13 +1300,13 @@ static int super_1_validate(mddev_t *mddev, mdk_rdev_t *rdev)
 			mddev->delta_disks = le32_to_cpu(sb->delta_disks);
 			mddev->new_level = le32_to_cpu(sb->new_level);
 			mddev->new_layout = le32_to_cpu(sb->new_layout);
-			mddev->new_chunk = le32_to_cpu(sb->new_chunk)<<9;
+			mddev->new_chunk_sectors = le32_to_cpu(sb->new_chunk);
 		} else {
 			mddev->reshape_position = MaxSector;
 			mddev->delta_disks = 0;
 			mddev->new_level = mddev->level;
 			mddev->new_layout = mddev->layout;
-			mddev->new_chunk = mddev->chunk_sectors << 9;
+			mddev->new_chunk_sectors = mddev->chunk_sectors;
 		}
 
 	} else if (mddev->pers == NULL) {
@@ -1402,7 +1402,7 @@ static void super_1_sync(mddev_t *mddev, mdk_rdev_t *rdev)
 		sb->new_layout = cpu_to_le32(mddev->new_layout);
 		sb->delta_disks = cpu_to_le32(mddev->delta_disks);
 		sb->new_level = cpu_to_le32(mddev->new_level);
-		sb->new_chunk = cpu_to_le32(mddev->new_chunk);
+		sb->new_chunk = cpu_to_le32(mddev->new_chunk_sectors << 9);
 	}
 
 	max_dev = 0;
@@ -2746,7 +2746,7 @@ level_store(mddev_t *mddev, const char *buf, size_t len)
 	if (IS_ERR(priv)) {
 		mddev->new_level = mddev->level;
 		mddev->new_layout = mddev->layout;
-		mddev->new_chunk = mddev->chunk_sectors << 9;
+		mddev->new_chunk_sectors = mddev->chunk_sectors;
 		mddev->raid_disks -= mddev->delta_disks;
 		mddev->delta_disks = 0;
 		module_put(pers->owner);
@@ -2764,7 +2764,7 @@ level_store(mddev_t *mddev, const char *buf, size_t len)
 	strlcpy(mddev->clevel, pers->name, sizeof(mddev->clevel));
 	mddev->level = mddev->new_level;
 	mddev->layout = mddev->new_layout;
-	mddev->chunk_sectors = mddev->new_chunk >> 9;
+	mddev->chunk_sectors = mddev->new_chunk_sectors;
 	mddev->delta_disks = 0;
 	pers->run(mddev);
 	mddev_resume(mddev);
@@ -2857,8 +2857,9 @@ static ssize_t
 chunk_size_show(mddev_t *mddev, char *page)
 {
 	if (mddev->reshape_position != MaxSector &&
-	    mddev->chunk_sectors << 9 != mddev->new_chunk)
-		return sprintf(page, "%d (%d)\n", mddev->new_chunk,
+	    mddev->chunk_sectors != mddev->new_chunk_sectors)
+		return sprintf(page, "%d (%d)\n",
+			       (int)mddev->new_chunk_sectors << 9,
 			       (int)mddev->chunk_sectors << 9);
 	return sprintf(page, "%d\n", (int)mddev->chunk_sectors << 9);
 }
@@ -2880,7 +2881,7 @@ chunk_size_store(mddev_t *mddev, const char *buf, size_t len)
 		if (err)
 			return err;
 	} else {
-		mddev->new_chunk = n;
+		mddev->new_chunk_sectors = n >> 9;
 		if (mddev->reshape_position == MaxSector)
 			mddev->chunk_sectors = n >> 9;
 	}
@@ -3651,7 +3652,7 @@ reshape_position_store(mddev_t *mddev, const char *buf, size_t len)
 	mddev->delta_disks = 0;
 	mddev->new_level = mddev->level;
 	mddev->new_layout = mddev->layout;
-	mddev->new_chunk = mddev->chunk_sectors << 9;
+	mddev->new_chunk_sectors = mddev->chunk_sectors;
 	return len;
 }
 
@@ -4400,7 +4401,7 @@ static int do_md_stop(mddev_t * mddev, int mode, int is_open)
 		mddev->delta_disks = 0;
 		mddev->new_level = LEVEL_NONE;
 		mddev->new_layout = 0;
-		mddev->new_chunk = 0;
+		mddev->new_chunk_sectors = 0;
 		mddev->curr_resync = 0;
 		mddev->resync_mismatches = 0;
 		mddev->suspend_lo = mddev->suspend_hi = 0;
@@ -5069,7 +5070,7 @@ static int set_array_info(mddev_t * mddev, mdu_array_info_t *info)
 	get_random_bytes(mddev->uuid, 16);
 
 	mddev->new_level = mddev->level;
-	mddev->new_chunk = mddev->chunk_sectors << 9;
+	mddev->new_chunk_sectors = mddev->chunk_sectors;
 	mddev->new_layout = mddev->layout;
 	mddev->delta_disks = 0;
 
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 7cbb895..4274cdc 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -166,7 +166,8 @@ struct mddev_s
 	 * If reshape_position is MaxSector, then no reshape is happening (yet).
 	 */
 	sector_t			reshape_position;
-	int				delta_disks, new_level, new_layout, new_chunk;
+	int				delta_disks, new_level, new_layout;
+	sector_t			new_chunk_sectors;
 
 	struct mdk_thread_s		*thread;	/* management thread */
 	struct mdk_thread_s		*sync_thread;	/* doing resync or reconstruct */
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index b56f075..4692a8a 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -2161,10 +2161,10 @@ static int raid1_reshape(mddev_t *mddev)
 	int d, d2, err;
 
 	/* Cannot change chunk_size, layout, or level */
-	if (mddev->chunk_sectors << 9 != mddev->new_chunk ||
+	if (mddev->chunk_sectors != mddev->new_chunk_sectors ||
 	    mddev->layout != mddev->new_layout ||
 	    mddev->level != mddev->new_level) {
-		mddev->new_chunk = mddev->chunk_sectors << 9;
+		mddev->new_chunk_sectors = mddev->chunk_sectors;
 		mddev->new_layout = mddev->layout;
 		mddev->new_level = mddev->level;
 		return -EINVAL;
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 85653e5..ab89dd0 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -3358,8 +3358,8 @@ static int raid5_mergeable_bvec(struct request_queue *q,
 	if ((bvm->bi_rw & 1) == WRITE)
 		return biovec->bv_len; /* always allow writes to be mergeable */
 
-	if (mddev->new_chunk < mddev->chunk_sectors << 9)
-		chunk_sectors = mddev->new_chunk >> 9;
+	if (mddev->new_chunk_sectors < mddev->chunk_sectors)
+		chunk_sectors = mddev->new_chunk_sectors;
 	max =  (chunk_sectors - ((sector & (chunk_sectors - 1)) + bio_sectors)) << 9;
 	if (max < 0) max = 0;
 	if (max <= biovec->bv_len && bio_sectors == 0)
@@ -3375,8 +3375,8 @@ static int in_chunk_boundary(mddev_t *mddev, struct bio *bio)
 	unsigned int chunk_sectors = mddev->chunk_sectors;
 	unsigned int bio_sectors = bio->bi_size >> 9;
 
-	if (mddev->new_chunk < mddev->chunk_sectors << 9)
-		chunk_sectors = mddev->new_chunk >> 9;
+	if (mddev->new_chunk_sectors < mddev->chunk_sectors)
+		chunk_sectors = mddev->new_chunk_sectors;
 	return  chunk_sectors >=
 		((sector & (chunk_sectors - 1)) + bio_sectors);
 }
@@ -3791,8 +3791,8 @@ static sector_t reshape_request(mddev_t *mddev, sector_t sector_nr, int *skipped
 	 * If old and new chunk sizes differ, we need to process the
 	 * largest of these
 	 */
-	if (mddev->new_chunk > mddev->chunk_sectors << 9)
-		reshape_sectors = mddev->new_chunk / 512;
+	if (mddev->new_chunk_sectors > mddev->chunk_sectors)
+		reshape_sectors = mddev->new_chunk_sectors;
 	else
 		reshape_sectors = mddev->chunk_sectors;
 
@@ -4304,7 +4304,7 @@ raid5_size(mddev_t *mddev, sector_t sectors, int raid_disks)
 	}
 
 	sectors &= ~(mddev->chunk_sectors - 1);
-	sectors &= ~((sector_t)mddev->new_chunk/512 - 1);
+	sectors &= ~(mddev->new_chunk_sectors - 1);
 	return sectors * (raid_disks - conf->max_degraded);
 }
 
@@ -4336,10 +4336,11 @@ static raid5_conf_t *setup_conf(mddev_t *mddev)
 		return ERR_PTR(-EINVAL);
 	}
 
-	if (!mddev->new_chunk || mddev->new_chunk % PAGE_SIZE ||
-	    !is_power_of_2(mddev->new_chunk)) {
+	if (!mddev->new_chunk_sectors ||
+	    (mddev->new_chunk_sectors << 9) % PAGE_SIZE ||
+	    !is_power_of_2(mddev->new_chunk_sectors)) {
 		printk(KERN_ERR "raid5: invalid chunk size %d for %s\n",
-			mddev->new_chunk, mdname(mddev));
+			(int)mddev->new_chunk_sectors << 9, mdname(mddev));
 		return ERR_PTR(-EINVAL);
 	}
 
@@ -4402,7 +4403,7 @@ static raid5_conf_t *setup_conf(mddev_t *mddev)
 			conf->fullsync = 1;
 	}
 
-	conf->chunk_size = mddev->new_chunk;
+	conf->chunk_size = mddev->new_chunk_sectors << 9;
 	conf->level = mddev->new_level;
 	if (conf->level == 6)
 		conf->max_degraded = 2;
@@ -4476,7 +4477,7 @@ static int run(mddev_t *mddev)
 		 * geometry.
 		 */
 		here_new = mddev->reshape_position;
-		if (sector_div(here_new, (mddev->new_chunk>>9)*
+		if (sector_div(here_new, mddev->new_chunk_sectors *
 			       (mddev->raid_disks - max_degraded))) {
 			printk(KERN_ERR "raid5: reshape_position not "
 			       "on a stripe boundary\n");
@@ -4499,7 +4500,7 @@ static int run(mddev_t *mddev)
 	} else {
 		BUG_ON(mddev->level != mddev->new_level);
 		BUG_ON(mddev->layout != mddev->new_layout);
-		BUG_ON(mddev->chunk_sectors << 9 != mddev->new_chunk);
+		BUG_ON(mddev->chunk_sectors != mddev->new_chunk_sectors);
 		BUG_ON(mddev->delta_disks != 0);
 	}
 
@@ -4851,7 +4852,7 @@ static int raid5_check_reshape(mddev_t *mddev)
 
 	if (mddev->delta_disks == 0 &&
 	    mddev->new_layout == mddev->layout &&
-	    mddev->new_chunk == mddev->chunk_sectors << 9)
+	    mddev->new_chunk_sectors == mddev->chunk_sectors)
 		return -EINVAL; /* nothing to do */
 	if (mddev->bitmap)
 		/* Cannot grow a bitmap yet */
@@ -4881,9 +4882,11 @@ static int raid5_check_reshape(mddev_t *mddev)
 	 */
 	if (((mddev->chunk_sectors << 9) / STRIPE_SIZE) * 4
 		> conf->max_nr_stripes ||
-	    (mddev->new_chunk / STRIPE_SIZE) * 4 > conf->max_nr_stripes) {
+	    ((mddev->new_chunk_sectors << 9) / STRIPE_SIZE) * 4
+		> conf->max_nr_stripes) {
 		printk(KERN_WARNING "raid5: reshape: not enough stripes.  Needed %lu\n",
-		       (max((int)mddev->chunk_sectors << 9, mddev->new_chunk)
+		       (max(mddev->chunk_sectors << 9,
+			mddev->new_chunk_sectors << 9)
 			/ STRIPE_SIZE)*4);
 		return -ENOSPC;
 	}
@@ -4929,7 +4932,7 @@ static int raid5_start_reshape(mddev_t *mddev)
 	conf->previous_raid_disks = conf->raid_disks;
 	conf->raid_disks += mddev->delta_disks;
 	conf->prev_chunk = conf->chunk_size;
-	conf->chunk_size = mddev->new_chunk;
+	conf->chunk_size = mddev->new_chunk_sectors << 9;
 	conf->prev_algo = conf->algorithm;
 	conf->algorithm = mddev->new_layout;
 	if (mddev->delta_disks < 0)
@@ -5114,7 +5117,7 @@ static void *raid5_takeover_raid1(mddev_t *mddev)
 
 	mddev->new_level = 5;
 	mddev->new_layout = ALGORITHM_LEFT_SYMMETRIC;
-	mddev->new_chunk = chunksect << 9;
+	mddev->new_chunk_sectors = chunksect;
 
 	return setup_conf(mddev);
 }
@@ -5185,7 +5188,7 @@ static int raid5_reconfig(mddev_t *mddev, int new_layout, int new_chunk)
 		}
 		if (new_chunk > 0) {
 			conf->chunk_size = new_chunk;
-			mddev->new_chunk = new_chunk;
+			mddev->new_chunk_sectors = new_chunk >> 9;
 			mddev->chunk_sectors = new_chunk >> 9;
 		}
 		set_bit(MD_CHANGE_DEVS, &mddev->flags);
@@ -5194,7 +5197,7 @@ static int raid5_reconfig(mddev_t *mddev, int new_layout, int new_chunk)
 		if (new_layout >= 0)
 			mddev->new_layout = new_layout;
 		if (new_chunk > 0)
-			mddev->new_chunk = new_chunk;
+			mddev->new_chunk_sectors = new_chunk >> 9;
 	}
 	return 0;
 }
@@ -5219,7 +5222,7 @@ static int raid6_reconfig(mddev_t *mddev, int new_layout, int new_chunk)
 	if (new_layout >= 0)
 		mddev->new_layout = new_layout;
 	if (new_chunk > 0)
-		mddev->new_chunk = new_chunk;
+		mddev->new_chunk_sectors = new_chunk >> 9;
 
 	return 0;
 }
-- 
1.5.4.3

