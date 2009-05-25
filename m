From: Andre Noll <maan@systemlinux.org>
Subject: [PATCH 4/6] md: convert conf->chunk_size and conf->prev_chunk to sectors.
Date: Mon, 25 May 2009 11:27:35 +0200
Message-ID: <1243243657-21855-5-git-send-email-maan@systemlinux.org>
References: <1243243657-21855-1-git-send-email-maan@systemlinux.org>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1243243657-21855-1-git-send-email-maan@systemlinux.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, Andre Noll <maan@systemlinux.org>
List-Id: linux-raid.ids

This kills some more shifts.

Signed-off-by: Andre Noll <maan@systemlinux.org>
---
 drivers/md/raid5.c |   31 +++++++++++++++----------------
 drivers/md/raid5.h |    6 ++++--
 2 files changed, 19 insertions(+), 18 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index ab89dd0..e7952f0 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -1274,8 +1274,8 @@ static sector_t raid5_compute_sector(raid5_conf_t *conf, sector_t r_sector,
 	sector_t new_sector;
 	int algorithm = previous ? conf->prev_algo
 				 : conf->algorithm;
-	int sectors_per_chunk = previous ? (conf->prev_chunk >> 9)
-					 : (conf->chunk_size >> 9);
+	int sectors_per_chunk = previous ? conf->prev_chunk_sectors
+					 : conf->chunk_sectors;
 	int raid_disks = previous ? conf->previous_raid_disks
 				  : conf->raid_disks;
 	int data_disks = raid_disks - conf->max_degraded;
@@ -1480,8 +1480,8 @@ static sector_t compute_blocknr(struct stripe_head *sh, int i, int previous)
 	int raid_disks = sh->disks;
 	int data_disks = raid_disks - conf->max_degraded;
 	sector_t new_sector = sh->sector, check;
-	int sectors_per_chunk = previous ? (conf->prev_chunk >> 9)
-					 : (conf->chunk_size >> 9);
+	int sectors_per_chunk = previous ? conf->prev_chunk_sectors
+					 : conf->chunk_sectors;
 	int algorithm = previous ? conf->prev_algo
 				 : conf->algorithm;
 	sector_t stripe;
@@ -1997,8 +1997,7 @@ static void stripe_set_idx(sector_t stripe, raid5_conf_t *conf, int previous,
 			    struct stripe_head *sh)
 {
 	int sectors_per_chunk =
-		previous ? (conf->prev_chunk >> 9)
-			 : (conf->chunk_size >> 9);
+		previous ? conf->prev_chunk_sectors : conf->chunk_sectors;
 	int dd_idx;
 	int chunk_offset = sector_div(stripe, sectors_per_chunk);
 	int disks = previous ? conf->previous_raid_disks : conf->raid_disks;
@@ -3916,9 +3915,9 @@ static sector_t reshape_request(mddev_t *mddev, sector_t sector_nr, int *skipped
 		raid5_compute_sector(conf, stripe_addr*(new_data_disks),
 				     1, &dd_idx, NULL);
 	last_sector =
-		raid5_compute_sector(conf, ((stripe_addr+conf->chunk_size/512)
-					    *(new_data_disks) - 1),
-				     1, &dd_idx, NULL);
+		raid5_compute_sector(conf, (stripe_addr + conf->chunk_sectors)
+					   * new_data_disks - 1,
+					   1, &dd_idx, NULL);
 	if (last_sector >= mddev->dev_sectors)
 		last_sector = mddev->dev_sectors - 1;
 	while (first_sector <= last_sector) {
@@ -4403,7 +4402,7 @@ static raid5_conf_t *setup_conf(mddev_t *mddev)
 			conf->fullsync = 1;
 	}
 
-	conf->chunk_size = mddev->new_chunk_sectors << 9;
+	conf->chunk_sectors = mddev->new_chunk_sectors;
 	conf->level = mddev->new_level;
 	if (conf->level == 6)
 		conf->max_degraded = 2;
@@ -4413,7 +4412,7 @@ static raid5_conf_t *setup_conf(mddev_t *mddev)
 	conf->max_nr_stripes = NR_STRIPES;
 	conf->reshape_progress = mddev->reshape_position;
 	if (conf->reshape_progress != MaxSector) {
-		conf->prev_chunk = mddev->chunk_sectors << 9;
+		conf->prev_chunk_sectors = mddev->chunk_sectors;
 		conf->prev_algo = mddev->layout;
 	}
 
@@ -4931,8 +4930,8 @@ static int raid5_start_reshape(mddev_t *mddev)
 	spin_lock_irq(&conf->device_lock);
 	conf->previous_raid_disks = conf->raid_disks;
 	conf->raid_disks += mddev->delta_disks;
-	conf->prev_chunk = conf->chunk_size;
-	conf->chunk_size = mddev->new_chunk_sectors << 9;
+	conf->prev_chunk_sectors = conf->chunk_sectors;
+	conf->chunk_sectors = mddev->new_chunk_sectors;
 	conf->prev_algo = conf->algorithm;
 	conf->algorithm = mddev->new_layout;
 	if (mddev->delta_disks < 0)
@@ -5014,7 +5013,7 @@ static void end_reshape(raid5_conf_t *conf)
 		 */
 		{
 			int data_disks = conf->raid_disks - conf->max_degraded;
-			int stripe = data_disks * (conf->chunk_size
+			int stripe = data_disks * ((conf->chunk_sectors << 9)
 						   / PAGE_SIZE);
 			if (conf->mddev->queue->backing_dev_info.ra_pages < 2 * stripe)
 				conf->mddev->queue->backing_dev_info.ra_pages = 2 * stripe;
@@ -5059,7 +5058,7 @@ static void raid5_finish_reshape(mddev_t *mddev)
 				raid5_remove_disk(mddev, d);
 		}
 		mddev->layout = conf->algorithm;
-		mddev->chunk_sectors = conf->chunk_size >> 9;
+		mddev->chunk_sectors = conf->chunk_sectors;
 		mddev->reshape_position = MaxSector;
 		mddev->delta_disks = 0;
 	}
@@ -5187,7 +5186,7 @@ static int raid5_reconfig(mddev_t *mddev, int new_layout, int new_chunk)
 			mddev->layout = mddev->new_layout = new_layout;
 		}
 		if (new_chunk > 0) {
-			conf->chunk_size = new_chunk;
+			conf->chunk_sectors = new_chunk >> 9;
 			mddev->new_chunk_sectors = new_chunk >> 9;
 			mddev->chunk_sectors = new_chunk >> 9;
 		}
diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
index 1a25c9e..f2e1259 100644
--- a/drivers/md/raid5.h
+++ b/drivers/md/raid5.h
@@ -334,7 +334,8 @@ struct raid5_private_data {
 	struct hlist_head	*stripe_hashtbl;
 	mddev_t			*mddev;
 	struct disk_info	*spare;
-	int			chunk_size, level, algorithm;
+	sector_t		chunk_sectors;
+	int			level, algorithm;
 	int			max_degraded;
 	int			raid_disks;
 	int			max_nr_stripes;
@@ -350,7 +351,8 @@ struct raid5_private_data {
 	 */
 	sector_t		reshape_safe;
 	int			previous_raid_disks;
-	int			prev_chunk, prev_algo;
+	sector_t		prev_chunk_sectors;
+	int			prev_algo;
 	short			generation; /* increments with every reshape */
 	unsigned long		reshape_checkpoint; /* Time we last updated
 						     * metadata */
-- 
1.5.4.3

