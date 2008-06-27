From: NeilBrown <neilb@suse.de>
Subject: [PATCH 014 of 29] md: Make sure all changes to md/array_state are notified.
Date: Fri, 27 Jun 2008 16:50:50 +1000
Message-ID: <1080627065050.10526@suse.de>
References: <20080627164503.9671.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids


Changes in md/array_state could be of interest to a monitoring
program.  So make sure all changes trigger a notification.

Exceptions:
   changing active_idle to active is not reported because it
      is frequent and not interesting.
   changing active to active_idle is only reported on arrays
      with externally managed metadata, as it is not interesting
      otherwise.
      
Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./Documentation/md.txt |    5 +++++
 ./drivers/md/md.c      |   29 ++++++++++++++++++++++++-----
 2 files changed, 29 insertions(+), 5 deletions(-)

diff .prev/Documentation/md.txt ./Documentation/md.txt
--- .prev/Documentation/md.txt	2008-06-27 16:20:34.000000000 +1000
+++ ./Documentation/md.txt	2008-06-27 16:22:01.000000000 +1000
@@ -236,6 +236,11 @@ All md devices contain:
      writing the word for the desired state, however some states
      cannot be explicitly set, and some transitions are not allowed.
 
+     Select/poll works on this file.  All changes except between
+     	active_idle and active (which can be frequent and are not
+	very interesting) are notified.  active->active_idle is
+	reported if the metadata is externally managed.
+
      clear
          No devices, no size, no level
          Writing is equivalent to STOP_ARRAY ioctl

diff .prev/drivers/md/md.c ./drivers/md/md.c
--- .prev/drivers/md/md.c	2008-06-27 16:22:01.000000000 +1000
+++ ./drivers/md/md.c	2008-06-27 16:22:01.000000000 +1000
@@ -2716,8 +2716,10 @@ array_state_store(mddev_t *mddev, const 
 	}
 	if (err)
 		return err;
-	else
+	else {
+		sysfs_notify(&mddev->kobj, NULL, "array_state");
 		return len;
+	}
 }
 static struct md_sysfs_entry md_array_state =
 __ATTR(array_state, S_IRUGO|S_IWUSR, array_state_show, array_state_store);
@@ -3408,7 +3410,11 @@ static void md_safemode_timeout(unsigned
 {
 	mddev_t *mddev = (mddev_t *) data;
 
-	mddev->safemode = 1;
+	if (!atomic_read(&mddev->writes_pending)) {
+		mddev->safemode = 1;
+		if (mddev->external)
+			sysfs_notify(&mddev->kobj, NULL, "array_state");
+	}
 	md_wakeup_thread(mddev->thread);
 }
 
@@ -3675,6 +3681,7 @@ static int do_md_run(mddev_t * mddev)
 
 	mddev->changed = 1;
 	md_new_event(mddev);
+	sysfs_notify(&mddev->kobj, NULL, "array_state");
 	kobject_uevent(&mddev->gendisk->dev.kobj, KOBJ_CHANGE);
 	return 0;
 }
@@ -3709,6 +3716,8 @@ static int restart_array(mddev_t *mddev)
 		md_wakeup_thread(mddev->thread);
 		md_wakeup_thread(mddev->sync_thread);
 		err = 0;
+		sysfs_notify(&mddev->kobj, NULL, "array_state");
+
 	} else
 		err = -EINVAL;
 
@@ -3879,6 +3888,7 @@ static int do_md_stop(mddev_t * mddev, i
 			mdname(mddev));
 	err = 0;
 	md_new_event(mddev);
+	sysfs_notify(&mddev->kobj, NULL, "array_state");
 out:
 	return err;
 }
@@ -4876,8 +4886,9 @@ static int md_ioctl(struct inode *inode,
 	    mddev->ro && mddev->pers) {
 		if (mddev->ro == 2) {
 			mddev->ro = 0;
-		set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
-		md_wakeup_thread(mddev->thread);
+			sysfs_notify(&mddev->kobj, NULL, "array_state");
+			set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
+			md_wakeup_thread(mddev->thread);
 
 		} else {
 			err = -EROFS;
@@ -5516,6 +5527,7 @@ void md_done_sync(mddev_t *mddev, int bl
  */
 void md_write_start(mddev_t *mddev, struct bio *bi)
 {
+	int did_change = 0;
 	if (bio_data_dir(bi) != WRITE)
 		return;
 
@@ -5526,6 +5538,7 @@ void md_write_start(mddev_t *mddev, stru
 		set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
 		md_wakeup_thread(mddev->thread);
 		md_wakeup_thread(mddev->sync_thread);
+		did_change = 1;
 	}
 	atomic_inc(&mddev->writes_pending);
 	if (mddev->safemode == 1)
@@ -5536,10 +5549,12 @@ void md_write_start(mddev_t *mddev, stru
 			mddev->in_sync = 0;
 			set_bit(MD_CHANGE_CLEAN, &mddev->flags);
 			md_wakeup_thread(mddev->thread);
+			did_change = 1;
 		}
 		spin_unlock_irq(&mddev->write_lock);
-		sysfs_notify(&mddev->kobj, NULL, "array_state");
 	}
+	if (did_change)
+		sysfs_notify(&mddev->kobj, NULL, "array_state");
 	wait_event(mddev->sb_wait,
 		   !test_bit(MD_CHANGE_CLEAN, &mddev->flags) &&
 		   !test_bit(MD_CHANGE_PENDING, &mddev->flags));
@@ -5991,18 +6006,22 @@ void md_check_recovery(mddev_t *mddev)
 		int spares = 0;
 
 		if (!mddev->external) {
+			int did_change = 0;
 			spin_lock_irq(&mddev->write_lock);
 			if (mddev->safemode &&
 			    !atomic_read(&mddev->writes_pending) &&
 			    !mddev->in_sync &&
 			    mddev->recovery_cp == MaxSector) {
 				mddev->in_sync = 1;
+				did_change = 1;
 				if (mddev->persistent)
 					set_bit(MD_CHANGE_CLEAN, &mddev->flags);
 			}
 			if (mddev->safemode == 1)
 				mddev->safemode = 0;
 			spin_unlock_irq(&mddev->write_lock);
+			if (did_change)
+				sysfs_notify(&mddev->kobj, NULL, "array_state");
 		}
 
 		if (mddev->flags)
