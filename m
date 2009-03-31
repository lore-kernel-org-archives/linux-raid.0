From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 07/14] md/raid5: prepare for allowing reshape to change
	layout
Date: Tue, 31 Mar 2009 15:54:43 +1100
Message-ID: <20090331045443.2589.31639.stgit@notabene.brown>
References: <20090331044827.2589.95894.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090331044827.2589.95894.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: NeilBrown <neilb@suse.de>
List-Id: linux-raid.ids

Add prev_algo to raid5_conf_t along the same lines as prev_chunk
and previous_raid_disks.

Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/raid5.c |   32 +++++++++++++++++++-------------
 drivers/md/raid5.h |    2 +-
 2 files changed, 20 insertions(+), 14 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 7638cc3..80ec9a6 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -1273,6 +1273,8 @@ static sector_t raid5_compute_sector(raid5_conf_t *conf, sector_t r_sector,
 	int pd_idx, qd_idx;
 	int ddf_layout = 0;
 	sector_t new_sector;
+	int algorithm = previous ? conf->prev_algo
+				 : conf->algorithm;
 	int sectors_per_chunk = previous ? (conf->prev_chunk >> 9)
 					 : (conf->chunk_size >> 9);
 	int raid_disks = previous ? conf->previous_raid_disks
@@ -1307,7 +1309,7 @@ static sector_t raid5_compute_sector(raid5_conf_t *conf, sector_t r_sector,
 		pd_idx = data_disks;
 		break;
 	case 5:
-		switch (conf->algorithm) {
+		switch (algorithm) {
 		case ALGORITHM_LEFT_ASYMMETRIC:
 			pd_idx = data_disks - stripe % raid_disks;
 			if (*dd_idx >= pd_idx)
@@ -1335,13 +1337,13 @@ static sector_t raid5_compute_sector(raid5_conf_t *conf, sector_t r_sector,
 			break;
 		default:
 			printk(KERN_ERR "raid5: unsupported algorithm %d\n",
-				conf->algorithm);
+				algorithm);
 			BUG();
 		}
 		break;
 	case 6:
 
-		switch (conf->algorithm) {
+		switch (algorithm) {
 		case ALGORITHM_LEFT_ASYMMETRIC:
 			pd_idx = raid_disks - 1 - (stripe % raid_disks);
 			qd_idx = pd_idx + 1;
@@ -1454,7 +1456,7 @@ static sector_t raid5_compute_sector(raid5_conf_t *conf, sector_t r_sector,
 
 		default:
 			printk(KERN_CRIT "raid6: unsupported algorithm %d\n",
-			       conf->algorithm);
+			       algorithm);
 			BUG();
 		}
 		break;
@@ -1481,6 +1483,8 @@ static sector_t compute_blocknr(struct stripe_head *sh, int i, int previous)
 	sector_t new_sector = sh->sector, check;
 	int sectors_per_chunk = previous ? (conf->prev_chunk >> 9)
 					 : (conf->chunk_size >> 9);
+	int algorithm = previous ? conf->prev_algo
+				 : conf->algorithm;
 	sector_t stripe;
 	int chunk_offset;
 	int chunk_number, dummy1, dd_idx = i;
@@ -1497,7 +1501,7 @@ static sector_t compute_blocknr(struct stripe_head *sh, int i, int previous)
 	switch(conf->level) {
 	case 4: break;
 	case 5:
-		switch (conf->algorithm) {
+		switch (algorithm) {
 		case ALGORITHM_LEFT_ASYMMETRIC:
 		case ALGORITHM_RIGHT_ASYMMETRIC:
 			if (i > sh->pd_idx)
@@ -1516,14 +1520,14 @@ static sector_t compute_blocknr(struct stripe_head *sh, int i, int previous)
 			break;
 		default:
 			printk(KERN_ERR "raid5: unsupported algorithm %d\n",
-			       conf->algorithm);
+			       algorithm);
 			BUG();
 		}
 		break;
 	case 6:
 		if (i == sh->qd_idx)
 			return 0; /* It is the Q disk */
-		switch (conf->algorithm) {
+		switch (algorithm) {
 		case ALGORITHM_LEFT_ASYMMETRIC:
 		case ALGORITHM_RIGHT_ASYMMETRIC:
 		case ALGORITHM_ROTATING_ZERO_RESTART:
@@ -1571,7 +1575,7 @@ static sector_t compute_blocknr(struct stripe_head *sh, int i, int previous)
 			break;
 		default:
 			printk(KERN_CRIT "raid6: unsupported algorithm %d\n",
-			       conf->algorithm);
+			       algorithm);
 			BUG();
 		}
 		break;
@@ -4330,8 +4334,10 @@ static raid5_conf_t *setup_conf(mddev_t *mddev)
 	conf->algorithm = mddev->new_layout;
 	conf->max_nr_stripes = NR_STRIPES;
 	conf->reshape_progress = mddev->reshape_position;
-	if (conf->reshape_progress != MaxSector)
+	if (conf->reshape_progress != MaxSector) {
 		conf->prev_chunk = mddev->chunk_size;
+		conf->prev_algo = mddev->layout;
+	}
 
 	memory = conf->max_nr_stripes * (sizeof(struct stripe_head) +
 		 conf->raid_disks * ((sizeof(struct bio) + PAGE_SIZE))) / 1024;
@@ -4472,14 +4478,14 @@ static int run(mddev_t *mddev)
 
 	if (mddev->degraded == 0)
 		printk("raid5: raid level %d set %s active with %d out of %d"
-			" devices, algorithm %d\n", conf->level, mdname(mddev), 
-			mddev->raid_disks-mddev->degraded, mddev->raid_disks,
-			conf->algorithm);
+		       " devices, algorithm %d\n", conf->level, mdname(mddev),
+		       mddev->raid_disks-mddev->degraded, mddev->raid_disks,
+		       mddev->new_layout);
 	else
 		printk(KERN_ALERT "raid5: raid level %d set %s active with %d"
 			" out of %d devices, algorithm %d\n", conf->level,
 			mdname(mddev), mddev->raid_disks - mddev->degraded,
-			mddev->raid_disks, conf->algorithm);
+			mddev->raid_disks, mddev->new_layout);
 
 	print_raid5_conf(conf);
 
diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
index b9c9328..cdd0456 100644
--- a/drivers/md/raid5.h
+++ b/drivers/md/raid5.h
@@ -350,7 +350,7 @@ struct raid5_private_data {
 	 */
 	sector_t		reshape_safe;
 	int			previous_raid_disks;
-	int			prev_chunk;
+	int			prev_chunk, prev_algo;
 	short			generation; /* increments with every reshape */
 
 	struct list_head	handle_list; /* stripes needing handling */


