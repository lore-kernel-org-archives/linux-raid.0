From: NeilBrown <neilb@suse.de>
Subject: [PATCH 006 of 9] md: Remove the working_disks and failed_disks from raid5 state data.
Date: Mon, 31 Jul 2006 17:32:27 +1000
Message-ID: <1060731073227.24494@suse.de>
References: <20060731172842.24323.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids


They are not needed.
conf->failed_disks is the same as mddev->degraded
and
conf->working_disks is conf->raid_disks - mddev->degraded.

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/raid5.c         |   20 ++++++++------------
 ./include/linux/raid/raid5.h |    2 +-
 2 files changed, 9 insertions(+), 13 deletions(-)

diff .prev/drivers/md/raid5.c ./drivers/md/raid5.c
--- .prev/drivers/md/raid5.c	2006-07-31 17:24:34.000000000 +1000
+++ ./drivers/md/raid5.c	2006-07-31 17:24:35.000000000 +1000
@@ -698,9 +698,7 @@ static void error(mddev_t *mddev, mdk_rd
 	if (!test_bit(Faulty, &rdev->flags)) {
 		set_bit(MD_CHANGE_DEVS, &mddev->flags);
 		if (test_bit(In_sync, &rdev->flags)) {
-			conf->working_disks--;
 			mddev->degraded++;
-			conf->failed_disks++;
 			clear_bit(In_sync, &rdev->flags);
 			/*
 			 * if recovery was running, make sure it aborts.
@@ -711,7 +709,7 @@ static void error(mddev_t *mddev, mdk_rd
 		printk (KERN_ALERT
 			"raid5: Disk failure on %s, disabling device."
 			" Operation continuing on %d devices\n",
-			bdevname(rdev->bdev,b), conf->working_disks);
+			bdevname(rdev->bdev,b), conf->raid_disks - mddev->degraded);
 	}
 }
 
@@ -3074,6 +3072,7 @@ static int run(mddev_t *mddev)
 	mdk_rdev_t *rdev;
 	struct disk_info *disk;
 	struct list_head *tmp;
+	int working_disks = 0;
 
 	if (mddev->level != 5 && mddev->level != 4 && mddev->level != 6) {
 		printk(KERN_ERR "raid5: %s: raid level not set to 4/5/6 (%d)\n",
@@ -3176,14 +3175,14 @@ static int run(mddev_t *mddev)
 			printk(KERN_INFO "raid5: device %s operational as raid"
 				" disk %d\n", bdevname(rdev->bdev,b),
 				raid_disk);
-			conf->working_disks++;
+			working_disks++;
 		}
 	}
 
 	/*
 	 * 0 for a fully functional array, 1 or 2 for a degraded array.
 	 */
-	mddev->degraded = conf->failed_disks = conf->raid_disks - conf->working_disks;
+	mddev->degraded = conf->raid_disks - working_disks;
 	conf->mddev = mddev;
 	conf->chunk_size = mddev->chunk_size;
 	conf->level = mddev->level;
@@ -3218,7 +3217,7 @@ static int run(mddev_t *mddev)
 	if (mddev->degraded > conf->max_degraded) {
 		printk(KERN_ERR "raid5: not enough operational devices for %s"
 			" (%d/%d failed)\n",
-			mdname(mddev), conf->failed_disks, conf->raid_disks);
+			mdname(mddev), mddev->degraded, conf->raid_disks);
 		goto abort;
 	}
 
@@ -3375,7 +3374,7 @@ static void status (struct seq_file *seq
 	int i;
 
 	seq_printf (seq, " level %d, %dk chunk, algorithm %d", mddev->level, mddev->chunk_size >> 10, mddev->layout);
-	seq_printf (seq, " [%d/%d] [", conf->raid_disks, conf->working_disks);
+	seq_printf (seq, " [%d/%d] [", conf->raid_disks, conf->raid_disks - mddev->degraded);
 	for (i = 0; i < conf->raid_disks; i++)
 		seq_printf (seq, "%s",
 			       conf->disks[i].rdev &&
@@ -3397,8 +3396,8 @@ static void print_raid5_conf (raid5_conf
 		printk("(conf==NULL)\n");
 		return;
 	}
-	printk(" --- rd:%d wd:%d fd:%d\n", conf->raid_disks,
-		 conf->working_disks, conf->failed_disks);
+	printk(" --- rd:%d wd:%d\n", conf->raid_disks,
+		 conf->raid_disks - conf->mddev->degraded);
 
 	for (i = 0; i < conf->raid_disks; i++) {
 		char b[BDEVNAME_SIZE];
@@ -3422,8 +3421,6 @@ static int raid5_spare_active(mddev_t *m
 		    && !test_bit(Faulty, &tmp->rdev->flags)
 		    && !test_bit(In_sync, &tmp->rdev->flags)) {
 			mddev->degraded--;
-			conf->failed_disks--;
-			conf->working_disks++;
 			set_bit(In_sync, &tmp->rdev->flags);
 		}
 	}
@@ -3593,7 +3590,6 @@ static int raid5_start_reshape(mddev_t *
 			if (raid5_add_disk(mddev, rdev)) {
 				char nm[20];
 				set_bit(In_sync, &rdev->flags);
-				conf->working_disks++;
 				added_devices++;
 				rdev->recovery_offset = 0;
 				sprintf(nm, "rd%d", rdev->raid_disk);

diff .prev/include/linux/raid/raid5.h ./include/linux/raid/raid5.h
--- .prev/include/linux/raid/raid5.h	2006-07-31 17:23:56.000000000 +1000
+++ ./include/linux/raid/raid5.h	2006-07-31 17:24:35.000000000 +1000
@@ -214,7 +214,7 @@ struct raid5_private_data {
 	struct disk_info	*spare;
 	int			chunk_size, level, algorithm;
 	int			max_degraded;
-	int			raid_disks, working_disks, failed_disks;
+	int			raid_disks;
 	int			max_nr_stripes;
 
 	/* used during an expand */
