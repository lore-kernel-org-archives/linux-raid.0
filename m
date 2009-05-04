From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 7/7] md: remove rd%d links immediately after stopping an
	array.
Date: Mon, 04 May 2009 16:58:51 +1000
Message-ID: <20090504065850.11688.1906.stgit@notabene.brown>
References: <20090504065540.11688.39505.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090504065540.11688.39505.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: NeilBrown <neilb@suse.de>
List-Id: linux-raid.ids

md maintains link in sys/mdXX/md/ to identify which device has
which role in the array. e.g.
   rd2 -> dev-sda

indicates that the device with role '2' in the array is sda.

These links are only present when the array is active.  They are
created immediately after ->run is called, and so should be removed
immediately after ->stop is called.
However they are currently removed a little bit later, and it is
possible for ->run to be called again, thus adding these links, before
they are removed.

So move the removal earlier so they are consistently only present when
the array is active.

Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/md.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 1dd723d..fccc834 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -4294,6 +4294,7 @@ static int do_md_stop(mddev_t * mddev, int mode, int is_open)
 {
 	int err = 0;
 	struct gendisk *disk = mddev->gendisk;
+	mdk_rdev_t *rdev;
 
 	if (atomic_read(&mddev->openers) > is_open) {
 		printk("md: %s still in use.\n",mdname(mddev));
@@ -4336,6 +4337,13 @@ static int do_md_stop(mddev_t * mddev, int mode, int is_open)
 			/* tell userspace to handle 'inactive' */
 			sysfs_notify_dirent(mddev->sysfs_state);
 
+			list_for_each_entry(rdev, &mddev->disks, same_set)
+				if (rdev->raid_disk >= 0) {
+					char nm[20];
+					sprintf(nm, "rd%d", rdev->raid_disk);
+					sysfs_remove_link(&mddev->kobj, nm);
+				}
+
 			set_capacity(disk, 0);
 			mddev->changed = 1;
 
@@ -4356,7 +4364,6 @@ static int do_md_stop(mddev_t * mddev, int mode, int is_open)
 	 * Free resources if final stop
 	 */
 	if (mode == 0) {
-		mdk_rdev_t *rdev;
 
 		printk(KERN_INFO "md: %s stopped.\n", mdname(mddev));
 
@@ -4368,13 +4375,6 @@ static int do_md_stop(mddev_t * mddev, int mode, int is_open)
 		}
 		mddev->bitmap_offset = 0;
 
-		list_for_each_entry(rdev, &mddev->disks, same_set)
-			if (rdev->raid_disk >= 0) {
-				char nm[20];
-				sprintf(nm, "rd%d", rdev->raid_disk);
-				sysfs_remove_link(&mddev->kobj, nm);
-			}
-
 		/* make sure all md_delayed_delete calls have finished */
 		flush_scheduled_work();
 


