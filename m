From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH] md - 9 of 10 - Discard the mddev_map array.
Date: Fri, 16 Jan 2004 12:19:41 +1100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <E1AhIeD-0002V3-00@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

### Comments for ChangeSet

We only need it occasionally to map unit number to
mddev, and we can use a linear search for that.
This reduces dependance on MAX_MD_DEVS

 ----------- Diffstat output ------------
 ./drivers/md/md.c |   22 ++++++++++------------
 1 files changed, 10 insertions(+), 12 deletions(-)

diff ./drivers/md/md.c~current~ ./drivers/md/md.c
--- ./drivers/md/md.c~current~	2004-01-16 12:07:31.000000000 +1100
+++ ./drivers/md/md.c	2004-01-16 12:08:10.000000000 +1100
@@ -125,7 +125,7 @@ static struct block_device_operations md
 
 /*
  * Enables to iterate over all existing md arrays
- * all_mddevs_lock protects this list as well as mddev_map.
+ * all_mddevs_lock protects this list.
  */
 static LIST_HEAD(all_mddevs);
 static spinlock_t all_mddevs_lock = SPIN_LOCK_UNLOCKED;
@@ -153,8 +153,6 @@ static spinlock_t all_mddevs_lock = SPIN
 		tmp = tmp->next;})					\
 		)
 
-static mddev_t *mddev_map[MAX_MD_DEVS];
-
 static int md_fail_request (request_queue_t *q, struct bio *bio)
 {
 	bio_io_error(bio, bio->bi_size);
@@ -173,7 +171,6 @@ static void mddev_put(mddev_t *mddev)
 		return;
 	if (!mddev->raid_disks && list_empty(&mddev->disks)) {
 		list_del(&mddev->all_mddevs);
-		mddev_map[mdidx(mddev)] = NULL;
 		blk_put_queue(mddev->queue);
 		kfree(mddev);
 	}
@@ -186,15 +183,16 @@ static mddev_t * mddev_find(int unit)
 
  retry:
 	spin_lock(&all_mddevs_lock);
-	if (mddev_map[unit]) {
-		mddev =  mddev_get(mddev_map[unit]);
-		spin_unlock(&all_mddevs_lock);
-		if (new)
-			kfree(new);
-		return mddev;
-	}
+	list_for_each_entry(mddev, &all_mddevs, all_mddevs)
+		if (mdidx(mddev) == unit) {
+			mddev_get(mddev);
+			spin_unlock(&all_mddevs_lock);
+			if (new)
+				kfree(new);
+			return mddev;
+		}
+
 	if (new) {
-		mddev_map[unit] = new;
 		list_add(&new->all_mddevs, &all_mddevs);
 		spin_unlock(&all_mddevs_lock);
 		return new;
