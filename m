From: NeilBrown <neilb@suse.de>
Subject: [PATCH md 009 of 10] Improve 'scan_mode' and rename it to 'sync_action'
Date: Wed, 2 Nov 2005 21:15:55 +1100
Message-ID: <1051102101555.23969@suse.de>
References: <20051102205640.22689.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org, Greg KH <greg@kroah.com>
List-Id: linux-raid.ids


The current sync_action for an array can be one of 

   idle  - nothing happening
   resync - reduncancy being recalcualted
   recover - missing device being recoverred to spare
   check   - user initiated check of redundancy
   repair  - like resync but user-initiated and ignores 
             bitmap optimisation.

Each of these strings can also be written to the 'sync_action'
file to cause that action to happen (if appropriate).

While 'sync' is not technically correct, as a recovery is *not* a 
'sync', I think it is the most servicable word here.  Also
'action' is a strong word than 'mode'.


Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/md.c |   48 +++++++++++++++++++++++++++++-------------------
 1 file changed, 29 insertions(+), 19 deletions(-)

diff ./drivers/md/md.c~current~ ./drivers/md/md.c
--- ./drivers/md/md.c~current~	2005-11-02 17:33:34.000000000 +1100
+++ ./drivers/md/md.c	2005-11-02 17:33:35.000000000 +1100
@@ -1746,9 +1746,9 @@ raid_disks_show(mddev_t *mddev, char *pa
 static struct md_sysfs_entry md_raid_disks = __ATTR_RO(raid_disks);
 
 static ssize_t
-md_show_scan(mddev_t *mddev, char *page)
+action_show(mddev_t *mddev, char *page)
 {
-	char *type = "none";
+	char *type = "idle";
 	if (test_bit(MD_RECOVERY_RUNNING, &mddev->recovery) ||
 	    test_bit(MD_RECOVERY_NEEDED, &mddev->recovery)) {
 		if (test_bit(MD_RECOVERY_SYNC, &mddev->recovery)) {
@@ -1765,27 +1765,37 @@ md_show_scan(mddev_t *mddev, char *page)
 }
 
 static ssize_t
-md_store_scan(mddev_t *mddev, const char *page, size_t len)
+action_store(mddev_t *mddev, const char *page, size_t len)
 {
-	int canscan=0;
+	if (!mddev->pers || !mddev->pers->sync_request)
+		return -EINVAL;
+
+	if (strcmp(page, "idle")==0 || strcmp(page, "idle\n")==0) {
+		if (mddev->sync_thread) {
+			set_bit(MD_RECOVERY_INTR, &mddev->recovery);
+			md_unregister_thread(mddev->sync_thread);
+			mddev->sync_thread = NULL;
+			mddev->recovery = 0;
+			printk("stop at %llu\n", (unsigned long long)mddev->recovery_cp);
+		}
+		return len;
+	}
 
 	if (test_bit(MD_RECOVERY_RUNNING, &mddev->recovery) ||
 	    test_bit(MD_RECOVERY_NEEDED, &mddev->recovery))
 		return -EBUSY;
-
-	if (mddev->pers && mddev->pers->sync_request)
-		canscan=1;
-
-	if (!canscan)
-		return -EINVAL;
-
-	if (strcmp(page, "check")==0 || strcmp(page, "check\n")==0)
-		set_bit(MD_RECOVERY_CHECK, &mddev->recovery);
-	else if (strcmp(page, "repair")!=0 && strcmp(page, "repair\n")!=0)
-		return -EINVAL;
-	set_bit(MD_RECOVERY_REQUESTED, &mddev->recovery);
-	set_bit(MD_RECOVERY_SYNC, &mddev->recovery);
-	set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
+	if (strcmp(page, "resync")==0 || strcmp(page, "resync\n")==0 ||
+	    strcmp(page, "recover")==0 || strcmp(page, "recover\n")==0)
+		set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
+	else {
+		if (strcmp(page, "check")==0 || strcmp(page, "check\n")==0)
+			set_bit(MD_RECOVERY_CHECK, &mddev->recovery);
+		else if (strcmp(page, "repair")!=0 && strcmp(page, "repair\n")!=0)
+			return -EINVAL;
+		set_bit(MD_RECOVERY_REQUESTED, &mddev->recovery);
+		set_bit(MD_RECOVERY_SYNC, &mddev->recovery);
+		set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
+	}
 	md_wakeup_thread(mddev->thread);
 	return len;
 }
@@ -1798,7 +1808,7 @@ mismatch_cnt_show(mddev_t *mddev, char *
 }
 
 static struct md_sysfs_entry
-md_scan_mode = __ATTR(scan_mode, S_IRUGO|S_IWUSR, md_show_scan, md_store_scan);
+md_scan_mode = __ATTR(sync_action, S_IRUGO|S_IWUSR, action_show, action_store);
 
 
 static struct md_sysfs_entry
