From: "Kwolek, Adam" <adam.kwolek@intel.com>
Subject: [md PATCH 4/8] Enable OLCE for external IMSM metadata
Date: Wed, 24 Feb 2010 07:43:27 +0000
Message-ID: <905EDD02F158D948B186911EB64DB3D1016F65BC@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: "Neil Brown (neilb@suse.de)" <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>
List-Id: linux-raid.ids

From fac54a63ceb2212dd20a61ae99ebf28ca5f2a190 Mon Sep 17 00:00:00 2001
From: Adam Kwolek <adam.kwolek@intel.com>
Date: Thu, 18 Feb 2010 11:26:06 +0100
Subject: [PATCH] OLCE: Synchronization with mdmon

Changes to be committed:
	modified:   md.c
	modified:   md.h

Enable mdmon synchronization.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---
 drivers/md/md.c |   73 +++++++++++++++++++++++++++++++++++++++++++++++++++++-
 drivers/md/md.h |    6 ++++
 2 files changed, 77 insertions(+), 2 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index fce7d44..c7d32c9 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -2050,6 +2050,9 @@ repeat:
 		/* OLCE: reshape for external meta */
 		if (mddev->external &&
 		    test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery)) {
+			/* clear single notification guard */
+			clear_bit(MD_CHANGE_PENDING_EXT, &mddev->flags);
+
 			/* for external meta clean MD_CHANGE_PENDING flag
 			 * as changes will be made by user space code
 			 */
@@ -3655,6 +3658,16 @@ sync_completed_store(mddev_t *mddev, const char *buf, size_t len)
 	if (!mddev->external)
 		return -EINVAL;
 
+	/* put notification for external meta on any value put in **/
+	if (test_and_clear_bit(MD_CHANGE_PENDING_EXT, &mddev->flags)) {
+		/* reentry bit clear */
+		clear_bit(MD_CHANGE_PENDING_EXT, &mddev->flags);
+
+		/* wake up */
+		clear_bit(MD_CHANGE_DEVS, &mddev->flags);
+		wake_up(&mddev->sb_wait);
+	}
+
 	/* check if numeric */
 	if (strict_strtoull(buf, 10, &passedValue))
 		return -EINVAL;
@@ -6774,8 +6787,65 @@ void md_check_recovery(mddev_t *mddev)
 		(mddev->external == 0 && mddev->safemode == 1) ||
 		(mddev->safemode == 2 && ! atomic_read(&mddev->writes_pending)
 		 && !mddev->in_sync && mddev->recovery_cp == MaxSector)
-		))
+		)) {
+		/* OLCE */
+		if (mddev->external) {
+			int send_Notification = 0;
+
+			/* reentry check */
+			if (!test_bit(MD_CHANGE_PENDING_EXT, &mddev->flags)) {
+				/* triger monitor and wait for uptate meta */
+				if ((mddev->reshape_position > 0) &&
+				    (mddev->reshape_position != MaxSector)) {
+					/* signal user space if reshape is in progress only
+					 * use  single notification guard
+					 */
+					set_bit(MD_CHANGE_PENDING_EXT, &mddev->flags);
+					/* Notify reshape_position */
+					send_Notification = 1;
+				}
+			} else {
+				/* for external meta, when we are blocked
+				 * on flag we have to check if
+				 * kthread_should_stop().  if so,
+				 * kick it internally
+				 * (user space part can be unavailable
+				 * to complete action, this allows thread
+				 * to wake up and terminate)
+				 */
+				if (kthread_should_stop()) {
+					/* clean single notification guard */
+					clear_bit(MD_CHANGE_PENDING_EXT, &mddev->flags);
+					/* notification */
+					clear_bit(MD_CHANGE_DEVS, &mddev->flags);
+					wake_up(&mddev->sb_wait);
+				} else {
+					/* check if user space (mdmon is alive */
+					/* nothing changed */
+					if (mddev->reshape_position == mddev->reshape_position_sent) {
+						if ((get_seconds() - mddev->reshape_position_sent_timestamp) > 15) {
+							printk(KERN_INFO "OLCE: mdmon is dead ?\n");
+							send_Notification = 1;
+						}
+					}
+				}
+			}
+
+			if (send_Notification) {
+				/* turn off hand shake with mdmon
+				 * - at this moment checkpointing is implemented in md
+				 */
+				/*
+				sysfs_notify(&mddev->kobj, NULL, "reshape_position");
+				mddev->reshape_position_sent = mddev->reshape_position;
+				mddev->reshape_position_sent_timestamp = get_seconds();
+				*/
+
+				md_update_sb(mddev, 0);
+			}
+		}
 		return;
+	}
 
 	if (mddev_trylock(mddev)) {
 		int spares = 0;
@@ -6807,7 +6877,6 @@ void md_check_recovery(mddev_t *mddev)
 			if (did_change)
 				sysfs_notify_dirent(mddev->sysfs_state);
 		}
-
 		if (mddev->flags)
 			md_update_sb(mddev, 0);
 
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 9ac5940..11885c8 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -121,6 +121,7 @@ struct mddev_s
 
 #define MD_SYNC_COMPLETED_SHOW_0 3  /* force to show in sync complete 0 */
 				    /*  when it is set from user space  */
+#define MD_CHANGE_PENDING_EXT 4	/* superblock update in progress external */
 	int				suspended;
 	atomic_t			active_io;
 	int				ro;
@@ -161,6 +162,11 @@ struct mddev_s
 	 * If reshape_position is MaxSector, then no reshape is happening (yet).
 	 */
 	sector_t			reshape_position;
+	/* last reshape position sent to user space for external meta update */
+	sector_t			reshape_position_sent;
+	/* when last last reshape position was sent to user space */
+	/* it allows to check if mdmon in user space is alive */
+	time_t				reshape_position_sent_timestamp;
 	int				delta_disks, new_level, new_layout;
 	int				new_chunk_sectors;
 
-- 
1.6.0.2

