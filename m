From: NeilBrown <neilb@suse.de>
Subject: [PATCH md 005 of 5] Teach raid5 the difference between 'check' and 'repair'.
Date: Tue, 4 Oct 2005 15:23:53 +1000
Message-ID: <1051004052353.28839@suse.de>
References: <20051004151922.28715.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


With this, raid5 can be asked to check parity without
repairing it.  It also keeps a count of the number of 
incorrect parity blocks found (mismatches) and reports
them through sysfs.
Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/md.c           |   18 ++++++++++++++++--
 ./drivers/md/raid5.c        |    5 +++++
 ./include/linux/raid/md_k.h |    4 ++++
 3 files changed, 25 insertions(+), 2 deletions(-)

diff ./drivers/md/md.c~current~ ./drivers/md/md.c
--- ./drivers/md/md.c~current~	2005-10-04 14:19:35.000000000 +1000
+++ ./drivers/md/md.c	2005-10-04 14:42:04.000000000 +1000
@@ -1758,16 +1758,29 @@ md_store_scan(mddev_t *mddev, const char
 	return len;
 }
 
+static ssize_t
+md_show_mismatch(mddev_t *mddev, char *page)
+{
+	return sprintf(page, "%llu\n",
+		       (unsigned long long) mddev->resync_mismatches);
+}
+
 static struct md_sysfs_entry md_scan_mode = {
 	.attr = {.name = "scan_mode", .mode = S_IRUGO|S_IWUSR },
 	.show = md_show_scan,
 	.store = md_store_scan,
 };
 
+static struct md_sysfs_entry md_mismatches = {
+	.attr = {.name = "mismatch_cnt", .mode = S_IRUGO },
+	.show = md_show_mismatch,
+};
+
 static struct attribute *md_default_attrs[] = {
 	&md_level.attr,
 	&md_raid_disks.attr,
 	&md_scan_mode.attr,
+	&md_mismatches.attr,
 	NULL,
 };
 
@@ -3884,12 +3897,13 @@ static void md_do_sync(mddev_t *mddev)
 		}
 	} while (mddev->curr_resync < 2);
 
-	if (test_bit(MD_RECOVERY_SYNC, &mddev->recovery))
+	if (test_bit(MD_RECOVERY_SYNC, &mddev->recovery)) {
 		/* resync follows the size requested by the personality,
 		 * which defaults to physical size, but can be virtual size
 		 */
 		max_sectors = mddev->resync_max_sectors;
-	else
+		mddev->resync_mismatches = 0;
+	} else
 		/* recovery follows the physical size of devices */
 		max_sectors = mddev->size << 1;
 

diff ./drivers/md/raid5.c~current~ ./drivers/md/raid5.c
--- ./drivers/md/raid5.c~current~	2005-10-04 13:08:44.000000000 +1000
+++ ./drivers/md/raid5.c	2005-10-04 14:42:32.000000000 +1000
@@ -1292,6 +1292,11 @@ static void handle_stripe(struct stripe_
 			    !memcmp(pagea, pagea+4, STRIPE_SIZE-4)) {
 				/* parity is correct (on disc, not in buffer any more) */
 				set_bit(STRIPE_INSYNC, &sh->state);
+			} else {
+				conf->mddev->resync_mismatches += STRIPE_SECTORS;
+				if (test_bit(MD_RECOVERY_CHECK, &conf->mddev->recovery))
+					/* don't try to repair!! */
+					set_bit(STRIPE_INSYNC, &sh->state);
 			}
 		}
 		if (!test_bit(STRIPE_INSYNC, &sh->state)) {

diff ./include/linux/raid/md_k.h~current~ ./include/linux/raid/md_k.h
--- ./include/linux/raid/md_k.h~current~	2005-10-04 14:15:54.000000000 +1000
+++ ./include/linux/raid/md_k.h	2005-10-04 14:35:29.000000000 +1000
@@ -175,6 +175,10 @@ struct mddev_s
 	sector_t			resync_mark_cnt;/* blocks written at resync_mark */
 
 	sector_t			resync_max_sectors; /* may be set by personality */
+
+	sector_t			resync_mismatches; /* count of sectors where
+							    * parity/replica mismatch found
+							    */
 	/* recovery/resync flags 
 	 * NEEDED:   we might need to start a resync/recover
 	 * RUNNING:  a thread is running, or about to be started
