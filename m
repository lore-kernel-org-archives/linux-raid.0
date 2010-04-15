From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 19/28] md: factor do_md_run to separate accesses to
	->gendisk
Date: Thu, 15 Apr 2010 16:21:08 +1000
Message-ID: <20100415062108.5126.84022.stgit@notabene.brown>
References: <20100415061516.5126.53068.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100415061516.5126.53068.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

As part of relaxing the binding between an mddev and gendisk,
we separate do_md_run into two functions.
  md_run does all the work internal to md
  do_md_run calls md_run and makes and changes to gendisk
     that are required.

Signed-off-by: NeilBrown <neilb@suse.de>
---
 drivers/md/md.c |   24 ++++++++++++++++--------
 1 files changed, 16 insertions(+), 8 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 06100d9..91333fe 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -4296,11 +4296,10 @@ static void md_safemode_timeout(unsigned long data)
 
 static int start_dirty_degraded;
 
-static int do_md_run(mddev_t * mddev)
+static int md_run(mddev_t *mddev)
 {
 	int err;
 	mdk_rdev_t *rdev;
-	struct gendisk *disk;
 	struct mdk_personality *pers;
 
 	if (list_empty(&mddev->disks))
@@ -4365,8 +4364,6 @@ static int do_md_run(mddev_t * mddev)
 		sysfs_notify_dirent(rdev->sysfs_state);
 	}
 
-	disk = mddev->gendisk;
-
 	spin_lock(&pers_lock);
 	pers = find_pers(mddev->level, mddev->clevel);
 	if (!pers || !try_module_get(pers->owner)) {
@@ -4494,21 +4491,32 @@ static int do_md_run(mddev_t * mddev)
 	if (mddev->flags)
 		md_update_sb(mddev, 0);
 
-	set_capacity(disk, mddev->array_sectors);
-
 	md_wakeup_thread(mddev->thread);
 	md_wakeup_thread(mddev->sync_thread); /* possibly kick off a reshape */
 
-	revalidate_disk(mddev->gendisk);
 	md_new_event(mddev);
 	sysfs_notify_dirent(mddev->sysfs_state);
 	if (mddev->sysfs_action)
 		sysfs_notify_dirent(mddev->sysfs_action);
 	sysfs_notify(&mddev->kobj, NULL, "degraded");
-	kobject_uevent(&disk_to_dev(mddev->gendisk)->kobj, KOBJ_CHANGE);
 	return 0;
 }
 
+static int do_md_run(mddev_t *mddev)
+{
+	int err;
+
+	err = md_run(mddev);
+	if (err)
+		goto out;
+
+	set_capacity(mddev->gendisk, mddev->array_sectors);
+	revalidate_disk(mddev->gendisk);
+	kobject_uevent(&disk_to_dev(mddev->gendisk)->kobj, KOBJ_CHANGE);
+out:
+	return err;
+}
+
 static int restart_array(mddev_t *mddev)
 {
 	struct gendisk *disk = mddev->gendisk;


