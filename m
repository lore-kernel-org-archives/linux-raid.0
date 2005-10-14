From: NeilBrown <neilb@suse.de>
Subject: [PATCH md 003 of 8] Minor MD fixes
Date: Fri, 14 Oct 2005 12:26:06 +1000
Message-ID: <1051014022606.11787@suse.de>
References: <20051014122335.11602.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


1/ Use reduce stack usage, because 'gcc' apparently doesn't overlay 
   different variables  that are in separate scopes...

2/ Use test_bit instead of ( .. & 1<< ..) which in this case is buggy.

Thanks to Andrew Morton

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/md.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff ./drivers/md/md.c~current~ ./drivers/md/md.c
--- ./drivers/md/md.c~current~	2005-10-14 12:15:42.000000000 +1000
+++ ./drivers/md/md.c	2005-10-14 12:16:10.000000000 +1000
@@ -698,6 +698,7 @@ static void super_90_sync(mddev_t *mddev
 	struct list_head *tmp;
 	mdk_rdev_t *rdev2;
 	int next_spare = mddev->raid_disks;
+	char nm[20];
 
 	/* make rdev->sb match mddev data..
 	 *
@@ -768,7 +769,6 @@ static void super_90_sync(mddev_t *mddev
 			fixdesc |= (1 << desc_nr);
 			rdev2->desc_nr = desc_nr;
 			if (rdev2->raid_disk >= 0) {
-				char nm[20];
 				sprintf(nm, "rd%d", rdev2->raid_disk);
 				sysfs_remove_link(&mddev->kobj, nm);
 			}
@@ -814,7 +814,6 @@ static void super_90_sync(mddev_t *mddev
 						  &rdev2->bdev->bd_disk->kobj,
 						  "block");
 				if (rdev2->raid_disk >= 0) {
-					char nm[20];
 					sprintf(nm, "rd%d", rdev2->raid_disk);
 					sysfs_create_link(&mddev->kobj,
 							  &rdev2->kobj, nm);
@@ -1722,9 +1721,9 @@ static ssize_t
 md_show_scan(mddev_t *mddev, char *page)
 {
 	char *type = "none";
-	if (mddev->recovery &
-	    ((1<<MD_RECOVERY_RUNNING) || (1<<MD_RECOVERY_NEEDED))) {
-		if (mddev->recovery & (1<<MD_RECOVERY_SYNC)) {
+	if (test_bit(MD_RECOVERY_RUNNING, &mddev->recovery) ||
+	    test_bit(MD_RECOVERY_NEEDED, &mddev->recovery)) {
+		if (test_bit(MD_RECOVERY_SYNC, &mddev->recovery)) {
 			if (!test_bit(MD_RECOVERY_REQUESTED, &mddev->recovery))
 				type = "resync";
 			else if (test_bit(MD_RECOVERY_CHECK, &mddev->recovery))
@@ -1741,8 +1740,9 @@ static ssize_t
 md_store_scan(mddev_t *mddev, const char *page, size_t len)
 {
 	int canscan=0;
-	if (mddev->recovery &
-	    ((1<<MD_RECOVERY_RUNNING) || (1<<MD_RECOVERY_NEEDED)))
+
+	if (test_bit(MD_RECOVERY_RUNNING, &mddev->recovery) ||
+	    test_bit(MD_RECOVERY_NEEDED, &mddev->recovery))
 		return -EBUSY;
 	down(&mddev->reconfig_sem);
 	if (mddev->pers && mddev->pers->sync_request)
