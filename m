From: Guoqing Jiang <gqjiang@suse.com>
Subject: [PATCH Resend V2 1/2] md-cluster: Defer MD reloading to mddev->thread
Date: Sun, 29 Nov 2015 16:57:11 +0800
Message-ID: <1448787432-4138-1-git-send-email-gqjiang@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.com
Cc: linux-raid@vger.kernel.org, rgoldwyn@suse.com
List-Id: linux-raid.ids

Reloading of superblock must be performed under reconfig_mutex. However,
this cannot be done with md_reload_sb because it would deadlock with
the message DLM lock. So, we defer it in md_check_recovery() which is
executed by mddev->thread.

This introduces a new flag, MD_RELOAD_SB, which if set, will reload the
superblock. And good_device_nr is also added to 'struct mddev' which is
used to get the num of the good device within cluster raid.

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
---
v2 changes: remove atomic and add good_device_nr to struct mddev

 drivers/md/md-cluster.c | 4 +++-
 drivers/md/md.c         | 4 ++++
 drivers/md/md.h         | 4 ++++
 3 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
index db9375f..b659ef7 100644
--- a/drivers/md/md-cluster.c
+++ b/drivers/md/md-cluster.c
@@ -432,8 +432,10 @@ static void process_add_new_disk(struct mddev *mddev, struct cluster_msg *cmsg)
 static void process_metadata_update(struct mddev *mddev, struct cluster_msg *msg)
 {
 	struct md_cluster_info *cinfo = mddev->cluster_info;
-	md_reload_sb(mddev, le32_to_cpu(msg->raid_slot));
+	mddev->good_device_nr = le32_to_cpu(msg->raid_slot);
+	set_bit(MD_RELOAD_SB, &mddev->flags);
 	dlm_lock_sync(cinfo->no_new_dev_lockres, DLM_LOCK_CR);
+	md_wakeup_thread(mddev->thread);
 }
 
 static void process_remove_disk(struct mddev *mddev, struct cluster_msg *msg)
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 642c87c..5ee18a0 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -8273,6 +8273,7 @@ void md_check_recovery(struct mddev *mddev)
 		(mddev->flags & MD_UPDATE_SB_FLAGS & ~ (1<<MD_CHANGE_PENDING)) ||
 		test_bit(MD_RECOVERY_NEEDED, &mddev->recovery) ||
 		test_bit(MD_RECOVERY_DONE, &mddev->recovery) ||
+		test_bit(MD_RELOAD_SB, &mddev->flags) ||
 		(mddev->external == 0 && mddev->safemode == 1) ||
 		(mddev->safemode == 2 && ! atomic_read(&mddev->writes_pending)
 		 && !mddev->in_sync && mddev->recovery_cp == MaxSector)
@@ -8321,6 +8322,9 @@ void md_check_recovery(struct mddev *mddev)
 						rdev->raid_disk < 0)
 					md_kick_rdev_from_array(rdev);
 			}
+
+			if (test_and_clear_bit(MD_RELOAD_SB, &mddev->flags))
+				md_reload_sb(mddev, mddev->good_device_nr);
 		}
 
 		if (!mddev->external) {
diff --git a/drivers/md/md.h b/drivers/md/md.h
index f5b9aad..7a6da5c 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -235,6 +235,9 @@ struct mddev {
 				 */
 #define MD_JOURNAL_CLEAN 5	/* A raid with journal is already clean */
 #define MD_HAS_JOURNAL	6	/* The raid array has journal feature set */
+#define MD_RELOAD_SB	7	/* Reload the superblock because another node
+				 * updated it.
+				 */
 
 	int				suspended;
 	atomic_t			active_io;
@@ -465,6 +468,7 @@ struct mddev {
 	struct work_struct event_work;	/* used by dm to report failure event */
 	void (*sync_super)(struct mddev *mddev, struct md_rdev *rdev);
 	struct md_cluster_info		*cluster_info;
+	unsigned int			good_device_nr;	/* good device num within cluster raid */
 };
 
 static inline int __must_check mddev_lock(struct mddev *mddev)
-- 
2.1.4

