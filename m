From: Andre Noll <maan@systemlinux.org>
Subject: [PATCH] md: raid0: Remove hash table.
Date: Thu, 14 May 2009 12:43:49 +0200
Message-ID: <1242297833-13908-3-git-send-email-maan@systemlinux.org>
References: <1242297833-13908-1-git-send-email-maan@systemlinux.org>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1242297833-13908-1-git-send-email-maan@systemlinux.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: raziebe@gmail.com, linux-raid@vger.kernel.org, Andre Noll <maan@systemlinux.org>
List-Id: linux-raid.ids

The raid0 hash table has become unused due to the changes in the
previous patch. This patch removes the hash table allocation and
setup code and kills the hash_table field of struct raid0_private_data.

Signed-off-by: Andre Noll <maan@systemlinux.org>
---
 drivers/md/raid0.c |   12 ------------
 drivers/md/raid0.h |    1 -
 2 files changed, 0 insertions(+), 13 deletions(-)

diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index 9fd3c3c..6bae90c 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -330,22 +330,14 @@ static int raid0_run (mddev_t *mddev)
 		nb_zone = s + round;
 	}
 	printk(KERN_INFO "raid0 : nb_zone is %d.\n", nb_zone);
-
-	printk(KERN_INFO "raid0 : Allocating %zu bytes for hash.\n",
-				nb_zone*sizeof(struct strip_zone*));
-	conf->hash_table = kmalloc (sizeof (struct strip_zone *)*nb_zone, GFP_KERNEL);
-	if (!conf->hash_table)
-		goto out_free_conf;
 	sectors = conf->strip_zone[cur].sectors;
 
-	conf->hash_table[0] = conf->strip_zone + cur;
 	for (i=1; i< nb_zone; i++) {
 		while (sectors <= conf->spacing) {
 			cur++;
 			sectors += conf->strip_zone[cur].sectors;
 		}
 		sectors -= conf->spacing;
-		conf->hash_table[i] = conf->strip_zone + cur;
 	}
 	if (conf->sector_shift) {
 		conf->spacing >>= conf->sector_shift;
@@ -388,8 +380,6 @@ static int raid0_stop (mddev_t *mddev)
 	raid0_conf_t *conf = mddev_to_conf(mddev);
 
 	blk_sync_queue(mddev->queue); /* the unplug fn references 'conf'*/
-	kfree(conf->hash_table);
-	conf->hash_table = NULL;
 	kfree(conf->strip_zone);
 	conf->strip_zone = NULL;
 	kfree(conf);
@@ -502,8 +492,6 @@ static void raid0_status (struct seq_file *seq, mddev_t *mddev)
 	h = 0;
 	for (j = 0; j < conf->nr_strip_zones; j++) {
 		seq_printf(seq, "      z%d", j);
-		if (conf->hash_table[h] == conf->strip_zone+j)
-			seq_printf(seq, "(h%d)", h++);
 		seq_printf(seq, "=[");
 		for (k = 0; k < conf->strip_zone[j].nb_dev; k++)
 			seq_printf(seq, "%s/", bdevname(
diff --git a/drivers/md/raid0.h b/drivers/md/raid0.h
index 824b12e..aac3613 100644
--- a/drivers/md/raid0.h
+++ b/drivers/md/raid0.h
@@ -12,7 +12,6 @@ struct strip_zone
 
 struct raid0_private_data
 {
-	struct strip_zone **hash_table; /* Table of indexes into strip_zone */
 	struct strip_zone *strip_zone;
 	mdk_rdev_t **devlist; /* lists of rdevs, pointed to by strip_zone->dev */
 	int nr_strip_zones;
-- 
1.5.4.3

