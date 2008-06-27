From: NeilBrown <neilb@suse.de>
Subject: [PATCH 012 of 29] md: rationalise return value for ->hot_add_disk method.
Date: Fri, 27 Jun 2008 16:50:38 +1000
Message-ID: <1080627065038.10491@suse.de>
References: <20080627164503.9671.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids


For all array types but linear, ->hot_add_disk returns 1 on
success, 0 on failure.
For linear, it returns 0 on success and -errno on failure.

This doesn't cause a functional problem because the ->hot_add_disk
function of linear is used quite differently to the others.
However it is confusing.

So convert all to return 0 for success or -errno on failure
and fix call sites to match.

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/md.c        |    7 +++----
 ./drivers/md/multipath.c |    8 +++++---
 ./drivers/md/raid1.c     |    6 +++---
 ./drivers/md/raid10.c    |   10 +++++-----
 ./drivers/md/raid5.c     |   10 +++++-----
 5 files changed, 21 insertions(+), 20 deletions(-)

diff .prev/drivers/md/md.c ./drivers/md/md.c
--- .prev/drivers/md/md.c	2008-06-27 16:20:35.000000000 +1000
+++ ./drivers/md/md.c	2008-06-27 16:20:38.000000000 +1000
@@ -1977,10 +1977,8 @@ slot_store(mdk_rdev_t *rdev, const char 
 			rdev->saved_raid_disk = -1;
 		err = rdev->mddev->pers->
 			hot_add_disk(rdev->mddev, rdev);
-		if (err != 1) {
+		if (err) {
 			rdev->raid_disk = -1;
-			if (err == 0)
-				return -EEXIST;
 			return err;
 		}
 		sprintf(nm, "rd%d", rdev->raid_disk);
@@ -5920,7 +5918,8 @@ static int remove_and_add_spares(mddev_t
 			if (rdev->raid_disk < 0
 			    && !test_bit(Faulty, &rdev->flags)) {
 				rdev->recovery_offset = 0;
-				if (mddev->pers->hot_add_disk(mddev,rdev)) {
+				if (mddev->pers->
+				    hot_add_disk(mddev, rdev) == 0) {
 					char nm[20];
 					sprintf(nm, "rd%d", rdev->raid_disk);
 					if (sysfs_create_link(&mddev->kobj,

diff .prev/drivers/md/multipath.c ./drivers/md/multipath.c
--- .prev/drivers/md/multipath.c	2008-06-27 16:20:35.000000000 +1000
+++ ./drivers/md/multipath.c	2008-06-27 16:20:38.000000000 +1000
@@ -281,7 +281,7 @@ static int multipath_add_disk(mddev_t *m
 {
 	multipath_conf_t *conf = mddev->private;
 	struct request_queue *q;
-	int found = 0;
+	int err = -EEXIST;
 	int path;
 	struct multipath_info *p;
 	int first = 0;
@@ -312,11 +312,13 @@ static int multipath_add_disk(mddev_t *m
 			rdev->raid_disk = path;
 			set_bit(In_sync, &rdev->flags);
 			rcu_assign_pointer(p->rdev, rdev);
-			found = 1;
+			err = 0;
+			break;
 		}
 
 	print_multipath_conf(conf);
-	return found;
+
+	return err;
 }
 
 static int multipath_remove_disk(mddev_t *mddev, int number)

diff .prev/drivers/md/raid10.c ./drivers/md/raid10.c
--- .prev/drivers/md/raid10.c	2008-06-27 16:20:35.000000000 +1000
+++ ./drivers/md/raid10.c	2008-06-27 16:20:38.000000000 +1000
@@ -1113,7 +1113,7 @@ static int raid10_spare_active(mddev_t *
 static int raid10_add_disk(mddev_t *mddev, mdk_rdev_t *rdev)
 {
 	conf_t *conf = mddev->private;
-	int found = 0;
+	int err = -EEXIST;
 	int mirror;
 	mirror_info_t *p;
 	int first = 0;
@@ -1123,9 +1123,9 @@ static int raid10_add_disk(mddev_t *mdde
 		/* only hot-add to in-sync arrays, as recovery is
 		 * very different from resync
 		 */
-		return 0;
+		return -EBUSY;
 	if (!enough(conf))
-		return 0;
+		return -EINVAL;
 
 	if (rdev->raid_disk)
 		first = last = rdev->raid_disk;
@@ -1151,7 +1151,7 @@ static int raid10_add_disk(mddev_t *mdde
 
 			p->head_position = 0;
 			rdev->raid_disk = mirror;
-			found = 1;
+			err = 0;
 			if (rdev->saved_raid_disk != mirror)
 				conf->fullsync = 1;
 			rcu_assign_pointer(p->rdev, rdev);
@@ -1159,7 +1159,7 @@ static int raid10_add_disk(mddev_t *mdde
 		}
 
 	print_conf(conf);
-	return found;
+	return err;
 }
 
 static int raid10_remove_disk(mddev_t *mddev, int number)

diff .prev/drivers/md/raid1.c ./drivers/md/raid1.c
--- .prev/drivers/md/raid1.c	2008-06-27 16:20:35.000000000 +1000
+++ ./drivers/md/raid1.c	2008-06-27 16:20:38.000000000 +1000
@@ -1100,7 +1100,7 @@ static int raid1_spare_active(mddev_t *m
 static int raid1_add_disk(mddev_t *mddev, mdk_rdev_t *rdev)
 {
 	conf_t *conf = mddev->private;
-	int found = 0;
+	int err = -EEXIST;
 	int mirror = 0;
 	mirror_info_t *p;
 	int first = 0;
@@ -1124,7 +1124,7 @@ static int raid1_add_disk(mddev_t *mddev
 
 			p->head_position = 0;
 			rdev->raid_disk = mirror;
-			found = 1;
+			err = 0;
 			/* As all devices are equivalent, we don't need a full recovery
 			 * if this was recently any drive of the array
 			 */
@@ -1135,7 +1135,7 @@ static int raid1_add_disk(mddev_t *mddev
 		}
 
 	print_conf(conf);
-	return found;
+	return err;
 }
 
 static int raid1_remove_disk(mddev_t *mddev, int number)

diff .prev/drivers/md/raid5.c ./drivers/md/raid5.c
--- .prev/drivers/md/raid5.c	2008-06-27 16:20:35.000000000 +1000
+++ ./drivers/md/raid5.c	2008-06-27 16:20:58.000000000 +1000
@@ -4604,7 +4604,7 @@ abort:
 static int raid5_add_disk(mddev_t *mddev, mdk_rdev_t *rdev)
 {
 	raid5_conf_t *conf = mddev->private;
-	int found = 0;
+	int err = -EEXIST;
 	int disk;
 	struct disk_info *p;
 	int first = 0;
@@ -4612,7 +4612,7 @@ static int raid5_add_disk(mddev_t *mddev
 
 	if (mddev->degraded > conf->max_degraded)
 		/* no point adding a device */
-		return 0;
+		return -EINVAL;
 
 	if (rdev->raid_disk >= 0)
 		first = last = rdev->raid_disk;
@@ -4631,14 +4631,14 @@ static int raid5_add_disk(mddev_t *mddev
 		if ((p=conf->disks + disk)->rdev == NULL) {
 			clear_bit(In_sync, &rdev->flags);
 			rdev->raid_disk = disk;
-			found = 1;
+			err = 0;
 			if (rdev->saved_raid_disk != disk)
 				conf->fullsync = 1;
 			rcu_assign_pointer(p->rdev, rdev);
 			break;
 		}
 	print_raid5_conf(conf);
-	return found;
+	return err;
 }
 
 static int raid5_resize(mddev_t *mddev, sector_t sectors)
@@ -4739,7 +4739,7 @@ static int raid5_start_reshape(mddev_t *
 	rdev_for_each(rdev, rtmp, mddev)
 		if (rdev->raid_disk < 0 &&
 		    !test_bit(Faulty, &rdev->flags)) {
-			if (raid5_add_disk(mddev, rdev)) {
+			if (raid5_add_disk(mddev, rdev) == 0) {
 				char nm[20];
 				set_bit(In_sync, &rdev->flags);
 				added_devices++;
