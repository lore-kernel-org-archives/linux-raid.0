From: NeilBrown <neilb@suse.de>
Subject: [PATCH 004 of 6] md: Change INTERATE_MDDEV to for_each_mddev
Date: Mon, 14 Jan 2008 12:45:43 +1100
Message-ID: <1080114014543.20385@suse.de>
References: <20080114123726.19968.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids


As this is more consistent with kernel style.

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/md.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff .prev/drivers/md/md.c ./drivers/md/md.c
--- .prev/drivers/md/md.c	2008-01-14 12:24:54.000000000 +1100
+++ ./drivers/md/md.c	2008-01-14 12:26:04.000000000 +1100
@@ -195,7 +195,7 @@ static DEFINE_SPINLOCK(all_mddevs_lock);
  * Any code which breaks out of this loop while own
  * a reference to the current mddev and must mddev_put it.
  */
-#define ITERATE_MDDEV(mddev,tmp)					\
+#define for_each_mddev(mddev,tmp)					\
 									\
 	for (({ spin_lock(&all_mddevs_lock); 				\
 		tmp = all_mddevs.next;					\
@@ -1596,7 +1596,7 @@ static void md_print_devices(void)
 	printk("md:	**********************************\n");
 	printk("md:	* <COMPLETE RAID STATE PRINTOUT> *\n");
 	printk("md:	**********************************\n");
-	ITERATE_MDDEV(mddev,tmp) {
+	for_each_mddev(mddev, tmp) {
 
 		if (mddev->bitmap)
 			bitmap_print_sb(mddev->bitmap);
@@ -2014,7 +2014,7 @@ rdev_size_store(mdk_rdev_t *rdev, const 
 		struct list_head *tmp, *tmp2;
 
 		mddev_unlock(rdev->mddev);
-		ITERATE_MDDEV(mddev, tmp) {
+		for_each_mddev(mddev, tmp) {
 			mdk_rdev_t *rdev2;
 
 			mddev_lock(mddev);
@@ -5464,7 +5464,7 @@ void md_do_sync(mddev_t *mddev)
 			set_bit(MD_RECOVERY_INTR, &mddev->recovery);
 			goto skip;
 		}
-		ITERATE_MDDEV(mddev2,tmp) {
+		for_each_mddev(mddev2, tmp) {
 			if (mddev2 == mddev)
 				continue;
 			if (mddev2->curr_resync && 
@@ -5912,7 +5912,7 @@ static int md_notify_reboot(struct notif
 
 		printk(KERN_INFO "md: stopping all md devices.\n");
 
-		ITERATE_MDDEV(mddev,tmp)
+		for_each_mddev(mddev, tmp)
 			if (mddev_trylock(mddev)) {
 				do_md_stop (mddev, 1);
 				mddev_unlock(mddev);
@@ -6046,7 +6046,7 @@ static __exit void md_exit(void)
 	unregister_reboot_notifier(&md_notifier);
 	unregister_sysctl_table(raid_table_header);
 	remove_proc_entry("mdstat", NULL);
-	ITERATE_MDDEV(mddev,tmp) {
+	for_each_mddev(mddev, tmp) {
 		struct gendisk *disk = mddev->gendisk;
 		if (!disk)
 			continue;
