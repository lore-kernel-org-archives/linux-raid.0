From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH] md - 3 of 3 - Avoid races by never no releasing rdev->sb for faulty devices.
Date: Tue, 17 Dec 2002 13:00:50 +1100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <E18O72Q-0000pZ-00@notabene.cse.unsw.edu.au>
Return-path: <linux-raid-owner@vger.kernel.org>
To: Marcelo Tosatti <marcelo@conectiva.com.br>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



There are races relating to the superblocks being written out
just as a device has failed, and the rdev->sb getting freeing while
it is being written out.  This patch tries to avoid one of the
races by testing the faulty bit in the superblock (which gets set
early) as well as rdev->faulty (which gets set late), and does not
free rdev->sb until the rdev is fully removed, thus making the races
less critical.


 ----------- Diffstat output ------------
 ./drivers/md/md.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff ./drivers/md/md.c~current~ ./drivers/md/md.c
--- ./drivers/md/md.c~current~	2002-12-16 16:29:52.000000000 +1100
+++ ./drivers/md/md.c	2002-12-16 16:30:42.000000000 +1100
@@ -1048,7 +1048,11 @@ repeat:
 			printk("(skipping faulty ");
 		if (rdev->alias_device)
 			printk("(skipping alias ");
-
+		if (disk_faulty(&rdev->sb->this_disk)) {
+			printk("(skipping new-faulty %s )\n",
+			       partition_name(rdev->dev));
+			continue;
+		}
 		printk("%s ", partition_name(rdev->dev));
 		if (!rdev->faulty && !rdev->alias_device) {
 			printk("[events: %08lx]",
@@ -1075,7 +1079,6 @@ repeat:
  *   - the device is nonexistent (zero size)
  *   - the device has no valid superblock
  *
- * a faulty rdev _never_ has rdev->sb set.
  */
 static int md_import_device(kdev_t newdev, int on_disk)
 {
@@ -1147,8 +1150,6 @@ static int md_import_device(kdev_t newde
 	md_list_add(&rdev->all, &all_raid_disks);
 	MD_INIT_LIST_HEAD(&rdev->pending);
 
-	if (rdev->faulty && rdev->sb)
-		free_disk_sb(rdev);
 	return 0;
 
 abort_free:
@@ -3062,7 +3063,6 @@ int md_error(mddev_t *mddev, kdev_t rdev
 		return 0;
 	if (!mddev->pers->error_handler
 			|| mddev->pers->error_handler(mddev,rdev) <= 0) {
-		free_disk_sb(rrdev);
 		rrdev->faulty = 1;
 	} else
 		return 1;
