From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 04/16] md: change hot_remove_disk to take an rdev rather
 than a number.
Date: Wed, 26 Oct 2011 12:43:00 +1100
Message-ID: <20111026014300.21110.88211.stgit@notabene.brown>
References: <20111026014240.21110.28487.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20111026014240.21110.28487.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Soon an array will be able to have multiple devices with the
same raid_disk number (an original and a replacement).  So removing
a device based on the number won't work.  So pass the actual device
handle instead.

Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/md.c        |    6 +++---
 drivers/md/md.h        |    2 +-
 drivers/md/multipath.c |    7 +++----
 drivers/md/raid1.c     |    7 +++----
 drivers/md/raid10.c    |    7 +++----
 drivers/md/raid5.c     |    9 ++++-----
 6 files changed, 17 insertions(+), 21 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 5164856..182056a 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -2691,7 +2691,7 @@ slot_store(struct md_rdev *rdev, const char *buf, size_t len)
 		if (rdev->mddev->pers->hot_remove_disk == NULL)
 			return -EINVAL;
 		err = rdev->mddev->pers->
-			hot_remove_disk(rdev->mddev, rdev->raid_disk);
+			hot_remove_disk(rdev->mddev, rdev);
 		if (err)
 			return err;
 		sysfs_unlink_rdev(rdev->mddev, rdev);
@@ -7335,7 +7335,7 @@ static int remove_and_add_spares(struct mddev *mddev)
 		     ! test_bit(In_sync, &rdev->flags)) &&
 		    atomic_read(&rdev->nr_pending)==0) {
 			if (mddev->pers->hot_remove_disk(
-				    mddev, rdev->raid_disk)==0) {
+				    mddev, rdev)==0) {
 				sysfs_unlink_rdev(mddev, rdev);
 				rdev->raid_disk = -1;
 			}
@@ -7473,7 +7473,7 @@ void md_check_recovery(struct mddev *mddev)
 				    test_bit(Faulty, &rdev->flags) &&
 				    atomic_read(&rdev->nr_pending)==0) {
 					if (mddev->pers->hot_remove_disk(
-						    mddev, rdev->raid_disk)==0) {
+						    mddev, rdev)==0) {
 						sysfs_unlink_rdev(mddev, rdev);
 						rdev->raid_disk = -1;
 					}
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 51c1d91..15a0346 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -428,7 +428,7 @@ struct md_personality
 	 */
 	void (*error_handler)(struct mddev *mddev, struct md_rdev *rdev);
 	int (*hot_add_disk) (struct mddev *mddev, struct md_rdev *rdev);
-	int (*hot_remove_disk) (struct mddev *mddev, int number);
+	int (*hot_remove_disk) (struct mddev *mddev, struct md_rdev *rdev);
 	int (*spare_active) (struct mddev *mddev);
 	sector_t (*sync_request)(struct mddev *mddev, sector_t sector_nr, int *skipped, int go_faster);
 	int (*resize) (struct mddev *mddev, sector_t sectors);
diff --git a/drivers/md/multipath.c b/drivers/md/multipath.c
index d32c785..164f074 100644
--- a/drivers/md/multipath.c
+++ b/drivers/md/multipath.c
@@ -291,17 +291,16 @@ static int multipath_add_disk(struct mddev *mddev, struct md_rdev *rdev)
 	return err;
 }
 
-static int multipath_remove_disk(struct mddev *mddev, int number)
+static int multipath_remove_disk(struct mddev *mddev, struct md_rdev *rdev)
 {
 	struct mpconf *conf = mddev->private;
 	int err = 0;
-	struct md_rdev *rdev;
+	int number = rdev->raid_disk;
 	struct multipath_info *p = conf->multipaths + number;
 
 	print_multipath_conf(conf);
 
-	rdev = p->rdev;
-	if (rdev) {
+	if (rdev == p->rdev) {
 		if (test_bit(In_sync, &rdev->flags) ||
 		    atomic_read(&rdev->nr_pending)) {
 			printk(KERN_ERR "hot-remove-disk, slot %d is identified"
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 4602fc5..a52979b 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1328,16 +1328,15 @@ static int raid1_add_disk(struct mddev *mddev, struct md_rdev *rdev)
 	return err;
 }
 
-static int raid1_remove_disk(struct mddev *mddev, int number)
+static int raid1_remove_disk(struct mddev *mddev, struct md_rdev *rdev)
 {
 	struct r1conf *conf = mddev->private;
 	int err = 0;
-	struct md_rdev *rdev;
+	int number = rdev->raid_disk;
 	struct mirror_info *p = conf->mirrors+ number;
 
 	print_conf(conf);
-	rdev = p->rdev;
-	if (rdev) {
+	if (rdev == p->rdev) {
 		if (test_bit(In_sync, &rdev->flags) ||
 		    atomic_read(&rdev->nr_pending)) {
 			err = -EBUSY;
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 132c18e..aa3796d 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1387,16 +1387,15 @@ static int raid10_add_disk(struct mddev *mddev, struct md_rdev *rdev)
 	return err;
 }
 
-static int raid10_remove_disk(struct mddev *mddev, int number)
+static int raid10_remove_disk(struct mddev *mddev, struct md_rdev *rdev)
 {
 	struct r10conf *conf = mddev->private;
 	int err = 0;
-	struct md_rdev *rdev;
+	int number = rdev->raid_disk;
 	struct mirror_info *p = conf->mirrors+ number;
 
 	print_conf(conf);
-	rdev = p->rdev;
-	if (rdev) {
+	if (rdev == p->rdev) {
 		if (test_bit(In_sync, &rdev->flags) ||
 		    atomic_read(&rdev->nr_pending)) {
 			err = -EBUSY;
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index f6fe053..27056d3 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -5020,16 +5020,15 @@ static int raid5_spare_active(struct mddev *mddev)
 	return count;
 }
 
-static int raid5_remove_disk(struct mddev *mddev, int number)
+static int raid5_remove_disk(struct mddev *mddev, struct md_rdev *rdev)
 {
 	struct r5conf *conf = mddev->private;
 	int err = 0;
-	struct md_rdev *rdev;
+	int number = rdev->raid_disk;
 	struct disk_info *p = conf->disks + number;
 
 	print_raid5_conf(conf);
-	rdev = p->rdev;
-	if (rdev) {
+	if (rdev == p->rdev) {
 		if (number >= conf->raid_disks &&
 		    conf->reshape_progress == MaxSector)
 			clear_bit(In_sync, &rdev->flags);
@@ -5355,7 +5354,7 @@ static void raid5_finish_reshape(struct mddev *mddev)
 			     d < conf->raid_disks - mddev->delta_disks;
 			     d++) {
 				struct md_rdev *rdev = conf->disks[d].rdev;
-				if (rdev && raid5_remove_disk(mddev, d) == 0) {
+				if (rdev && raid5_remove_disk(mddev, rdev) == 0) {
 					sysfs_unlink_rdev(mddev, rdev);
 					rdev->raid_disk = -1;
 				}


