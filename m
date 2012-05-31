From: Yuanhan Liu <yuanhan.liu@linux.intel.com>
Subject: [PATCH 4/4] md: put EXPORT_SYMBOL macro immediately after the corresponding function
Date: Thu, 31 May 2012 18:18:48 +0800
Message-ID: <1338459528-24490-4-git-send-email-yuanhan.liu@linux.intel.com>
References: <1338459528-24490-1-git-send-email-yuanhan.liu@linux.intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1338459528-24490-1-git-send-email-yuanhan.liu@linux.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, Yuanhan Liu <yuanhan.liu@linux.intel.com>
List-Id: linux-raid.ids

Just as Documentation/CodingStyle Chapter 6: Functions says:

   If the function is exported, the EXPORT* macro for it should
   follow immediately after the closing function brace line.

Signed-off-by: Yuanhan Liu <yuanhan.liu@linux.intel.com>
---
 drivers/md/md.c |   20 ++++++++++----------
 1 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 87e5ce8..8a430e7 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -6751,6 +6751,7 @@ void md_wakeup_thread(struct md_thread *thread)
 		wake_up(&thread->wqueue);
 	}
 }
+EXPORT_SYMBOL(md_wakeup_thread);
 
 struct md_thread *md_register_thread(void (*run) (struct mddev *), struct mddev *mddev,
 				 const char *name)
@@ -6776,6 +6777,7 @@ struct md_thread *md_register_thread(void (*run) (struct mddev *), struct mddev
 	}
 	return thread;
 }
+EXPORT_SYMBOL(md_register_thread);
 
 void md_unregister_thread(struct md_thread **threadp)
 {
@@ -6793,6 +6795,7 @@ void md_unregister_thread(struct md_thread **threadp)
 	kthread_stop(thread->tsk);
 	kfree(thread);
 }
+EXPORT_SYMBOL(md_unregister_thread);
 
 void md_error(struct mddev *mddev, struct md_rdev *rdev)
 {
@@ -6817,6 +6820,7 @@ void md_error(struct mddev *mddev, struct md_rdev *rdev)
 		queue_work(md_misc_wq, &mddev->event_work);
 	md_new_event_inintr(mddev);
 }
+EXPORT_SYMBOL(md_error);
 
 /* seq_file implementation /proc/mdstat */
 
@@ -7144,6 +7148,7 @@ int register_md_personality(struct md_personality *p)
 	spin_unlock(&pers_lock);
 	return 0;
 }
+EXPORT_SYMBOL(register_md_personality);
 
 int unregister_md_personality(struct md_personality *p)
 {
@@ -7153,6 +7158,7 @@ int unregister_md_personality(struct md_personality *p)
 	spin_unlock(&pers_lock);
 	return 0;
 }
+EXPORT_SYMBOL(unregister_md_personality);
 
 static int is_mddev_idle(struct mddev *mddev, int init)
 {
@@ -7209,6 +7215,7 @@ void md_done_sync(struct mddev *mddev, int blocks, int ok)
 		// stop recovery, signal do_sync ....
 	}
 }
+EXPORT_SYMBOL(md_done_sync);
 
 
 /* md_write_start(mddev, bi)
@@ -7250,6 +7257,7 @@ void md_write_start(struct mddev *mddev, struct bio *bi)
 	wait_event(mddev->sb_wait,
 		   !test_bit(MD_CHANGE_PENDING, &mddev->flags));
 }
+EXPORT_SYMBOL(md_write_start);
 
 void md_write_end(struct mddev *mddev)
 {
@@ -7260,6 +7268,7 @@ void md_write_end(struct mddev *mddev)
 			mod_timer(&mddev->safemode_timer, jiffies + mddev->safemode_delay);
 	}
 }
+EXPORT_SYMBOL(md_write_end);
 
 /* md_allow_write(mddev)
  * Calling this ensures that the array is marked 'active' so that writes
@@ -7901,6 +7910,7 @@ void md_check_recovery(struct mddev *mddev)
 		mddev_unlock(mddev);
 	}
 }
+EXPORT_SYMBOL(md_check_recovery);
 
 void md_wait_for_blocked_rdev(struct md_rdev *rdev, struct mddev *mddev)
 {
@@ -8616,16 +8626,6 @@ module_param(start_dirty_degraded, int, S_IRUGO|S_IWUSR);
 
 module_param_call(new_array, add_named_array, NULL, NULL, S_IWUSR);
 
-EXPORT_SYMBOL(register_md_personality);
-EXPORT_SYMBOL(unregister_md_personality);
-EXPORT_SYMBOL(md_error);
-EXPORT_SYMBOL(md_done_sync);
-EXPORT_SYMBOL(md_write_start);
-EXPORT_SYMBOL(md_write_end);
-EXPORT_SYMBOL(md_register_thread);
-EXPORT_SYMBOL(md_unregister_thread);
-EXPORT_SYMBOL(md_wakeup_thread);
-EXPORT_SYMBOL(md_check_recovery);
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("MD RAID framework");
 MODULE_ALIAS("md");
-- 
1.7.7.6

