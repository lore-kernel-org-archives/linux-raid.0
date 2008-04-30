From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 1/3] md: ping userspace on 'write-pending' events
Date: Tue, 29 Apr 2008 18:19:33 -0700
Message-ID: <20080430011933.20468.45086.stgit@dwillia2-linux.ch.intel.com>
References: <20080430011826.20468.93265.stgit@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20080430011826.20468.93265.stgit@dwillia2-linux.ch.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Also, when userspace writes 'active', clear all mddev->flags to satisfy
md_write_start (the other bits do not matter to external-metadata arrays).

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---

 drivers/md/md.c |   19 +++++++++++++++----
 1 files changed, 15 insertions(+), 4 deletions(-)


diff --git a/drivers/md/md.c b/drivers/md/md.c
index 6859bcd..ad53035 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -2664,7 +2664,7 @@ array_state_store(mddev_t *mddev, const char *buf, size_t len)
 		if (mddev->pers) {
 			restart_array(mddev);
 			if (mddev->external)
-				clear_bit(MD_CHANGE_CLEAN, &mddev->flags);
+				mddev->flags = 0;
 			wake_up(&mddev->sb_wait);
 			err = 0;
 		} else {
@@ -5413,9 +5413,14 @@ void md_write_start(mddev_t *mddev, struct bio *bi)
 		if (mddev->in_sync) {
 			mddev->in_sync = 0;
 			set_bit(MD_CHANGE_CLEAN, &mddev->flags);
+			spin_unlock_irq(&mddev->write_lock);
+
+			/* notify userspace to handle clean->dirty */
+			if (mddev->external)
+				sysfs_notify(&mddev->kobj, NULL, "array_state");
 			md_wakeup_thread(mddev->thread);
-		}
-		spin_unlock_irq(&mddev->write_lock);
+		} else
+			spin_unlock_irq(&mddev->write_lock);
 	}
 	wait_event(mddev->sb_wait, mddev->flags==0);
 }
@@ -5451,7 +5456,13 @@ void md_allow_write(mddev_t *mddev)
 		    mddev->safemode == 0)
 			mddev->safemode = 1;
 		spin_unlock_irq(&mddev->write_lock);
-		md_update_sb(mddev, 0);
+
+		/* wait for the dirty state to be recorded in the metadata */
+		if (mddev->external) {
+			sysfs_notify(&mddev->kobj, NULL, "array_state");
+			wait_event(mddev->sb_wait, mddev->flags == 0);
+		} else
+			md_update_sb(mddev, 0);
 	} else
 		spin_unlock_irq(&mddev->write_lock);
 }

