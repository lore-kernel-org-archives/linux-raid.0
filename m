From: Jonathan Brassow <jbrassow@f14.redhat.com>
Subject: [PATCH] MD:  move thread wakeups into resume
Date: Tue, 24 May 2011 15:56:26 -0500
Message-ID: <201105242056.p4OKuQKw011764@f14.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Patch name: md-move-thread-wakeups-into-resume.patch

Move personality and sync/recovery thread starting outside md_run.

Moving the wakeup's of the personality and sync/recovery threads out of
md_run and into do_md_run and mddev_resume solves two issues:
1) It allows bitmap_load to be called before the sync_thread is run and
2) when MD personalities are used by device-mapper (dm-raid.c), the start-up
of the array is better alligned with device-mapper primatives
(CTR/resume/suspend/DTR).  I/O - in this case, recovery operations - should
not happen until after a resume has taken place.

RFC-by: Jonathan Brassow <jbrassow@redhat.com>

Index: linux-2.6/drivers/md/md.c
===================================================================
--- linux-2.6.orig/drivers/md/md.c
+++ linux-2.6/drivers/md/md.c
@@ -351,6 +351,9 @@ void mddev_resume(mddev_t *mddev)
 	mddev->suspended = 0;
 	wake_up(&mddev->sb_wait);
 	mddev->pers->quiesce(mddev, 0);
+
+	md_wakeup_thread(mddev->thread);
+	md_wakeup_thread(mddev->sync_thread); /* possibly kick off a reshape */
 }
 EXPORT_SYMBOL_GPL(mddev_resume);
 
@@ -4948,9 +4951,6 @@ int md_run(mddev_t *mddev)
 	if (mddev->flags)
 		md_update_sb(mddev, 0);
 
-	md_wakeup_thread(mddev->thread);
-	md_wakeup_thread(mddev->sync_thread); /* possibly kick off a reshape */
-
 	md_new_event(mddev);
 	sysfs_notify_dirent_safe(mddev->sysfs_state);
 	sysfs_notify_dirent_safe(mddev->sysfs_action);
@@ -4971,6 +4971,10 @@ static int do_md_run(mddev_t *mddev)
 		bitmap_destroy(mddev);
 		goto out;
 	}
+
+	md_wakeup_thread(mddev->thread);
+	md_wakeup_thread(mddev->sync_thread); /* possibly kick off a reshape */
+
 	set_capacity(mddev->gendisk, mddev->array_sectors);
 	revalidate_disk(mddev->gendisk);
 	mddev->changed = 1;
