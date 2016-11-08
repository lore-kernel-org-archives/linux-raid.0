From: NeilBrown <neilb@suse.com>
Subject: [md PATCH 3/3] md: define mddev flags,
 recovery flags and r1bio state bits using enums
Date: Wed, 09 Nov 2016 10:21:33 +1100
Message-ID: <147864729298.1076.2506132363008045138.stgit@noble>
References: <147864718560.1076.2148299631932240330.stgit@noble>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <147864718560.1076.2148299631932240330.stgit@noble>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is less error prone than using individual #defines.

Signed-off-by: NeilBrown <neilb@suse.com>
---
 drivers/md/md.h    |   76 +++++++++++++++++++++++++---------------------------
 drivers/md/raid1.h |   18 +++++++-----
 2 files changed, 46 insertions(+), 48 deletions(-)

diff --git a/drivers/md/md.h b/drivers/md/md.h
index 21bd94fad96a..af6b33c30d2d 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -192,6 +192,25 @@ extern int rdev_clear_badblocks(struct md_rdev *rdev, sector_t s, int sectors,
 				int is_new);
 struct md_cluster_info;
 
+enum mddev_flags {
+	MD_CHANGE_DEVS,		/* Some device status has changed */
+	MD_CHANGE_CLEAN,	/* transition to or from 'clean' */
+	MD_CHANGE_PENDING,	/* switch from 'clean' to 'active' in progress */
+	MD_ARRAY_FIRST_USE,	/* First use of array, needs initialization */
+	MD_CLOSING,		/* If set, we are closing the array, do not open
+				 * it then */
+	MD_JOURNAL_CLEAN,	/* A raid with journal is already clean */
+	MD_HAS_JOURNAL,		/* The raid array has journal feature set */
+	MD_RELOAD_SB,		/* Reload the superblock because another node
+				 * updated it.
+				 */
+	MD_CLUSTER_RESYNC_LOCKED, /* cluster raid only, which means node
+				   * already took resync lock, need to
+				   * release the lock */
+};
+#define MD_UPDATE_SB_FLAGS (BIT(MD_CHANGE_DEVS) | \
+			    BIT(MD_CHANGE_CLEAN) | \
+			    BIT(MD_CHANGE_PENDING))	/* If these are set, md_update_sb needed */
 struct mddev {
 	void				*private;
 	struct md_personality		*pers;
@@ -199,21 +218,6 @@ struct mddev {
 	int				md_minor;
 	struct list_head		disks;
 	unsigned long			flags;
-#define MD_CHANGE_DEVS	0	/* Some device status has changed */
-#define MD_CHANGE_CLEAN 1	/* transition to or from 'clean' */
-#define MD_CHANGE_PENDING 2	/* switch from 'clean' to 'active' in progress */
-#define MD_UPDATE_SB_FLAGS (1 | 2 | 4)	/* If these are set, md_update_sb needed */
-#define MD_ARRAY_FIRST_USE 3    /* First use of array, needs initialization */
-#define MD_CLOSING	4	/* If set, we are closing the array, do not open
-				 * it then */
-#define MD_JOURNAL_CLEAN 5	/* A raid with journal is already clean */
-#define MD_HAS_JOURNAL	6	/* The raid array has journal feature set */
-#define MD_RELOAD_SB	7	/* Reload the superblock because another node
-				 * updated it.
-				 */
-#define MD_CLUSTER_RESYNC_LOCKED 8 /* cluster raid only, which means node
-				    * already took resync lock, need to
-				    * release the lock */
 
 	int				suspended;
 	atomic_t			active_io;
@@ -307,31 +311,6 @@ struct mddev {
 	int				parallel_resync;
 
 	int				ok_start_degraded;
-	/* recovery/resync flags
-	 * NEEDED:   we might need to start a resync/recover
-	 * RUNNING:  a thread is running, or about to be started
-	 * SYNC:     actually doing a resync, not a recovery
-	 * RECOVER:  doing recovery, or need to try it.
-	 * INTR:     resync needs to be aborted for some reason
-	 * DONE:     thread is done and is waiting to be reaped
-	 * REQUEST:  user-space has requested a sync (used with SYNC)
-	 * CHECK:    user-space request for check-only, no repair
-	 * RESHAPE:  A reshape is happening
-	 * ERROR:    sync-action interrupted because io-error
-	 *
-	 * If neither SYNC or RESHAPE are set, then it is a recovery.
-	 */
-#define	MD_RECOVERY_RUNNING	0
-#define	MD_RECOVERY_SYNC	1
-#define	MD_RECOVERY_RECOVER	2
-#define	MD_RECOVERY_INTR	3
-#define	MD_RECOVERY_DONE	4
-#define	MD_RECOVERY_NEEDED	5
-#define	MD_RECOVERY_REQUESTED	6
-#define	MD_RECOVERY_CHECK	7
-#define MD_RECOVERY_RESHAPE	8
-#define	MD_RECOVERY_FROZEN	9
-#define	MD_RECOVERY_ERROR	10
 
 	unsigned long			recovery;
 	/* If a RAID personality determines that recovery (of a particular
@@ -445,6 +424,23 @@ struct mddev {
 	unsigned int			good_device_nr;	/* good device num within cluster raid */
 };
 
+enum recovery_flags {
+	/*
+	 * If neither SYNC or RESHAPE are set, then it is a recovery.
+	 */
+	MD_RECOVERY_RUNNING,	/* a thread is running, or about to be started */
+	MD_RECOVERY_SYNC,	/* actually doing a resync, not a recovery */
+	MD_RECOVERY_RECOVER,	/* doing recovery, or need to try it. */
+	MD_RECOVERY_INTR,	/* resync needs to be aborted for some reason */
+	MD_RECOVERY_DONE,	/* thread is done and is waiting to be reaped */
+	MD_RECOVERY_NEEDED,	/* we might need to start a resync/recover */
+	MD_RECOVERY_REQUESTED,	/* user-space has requested a sync (used with SYNC) */
+	MD_RECOVERY_CHECK,	/* user-space request for check-only, no repair */
+	MD_RECOVERY_RESHAPE,	/* A reshape is happening */
+	MD_RECOVERY_FROZEN,	/* User request to abort, and not restart, any action */
+	MD_RECOVERY_ERROR,	/* sync-action interrupted because io-error */
+};
+
 static inline int __must_check mddev_lock(struct mddev *mddev)
 {
 	return mutex_lock_interruptible(&mddev->reconfig_mutex);
diff --git a/drivers/md/raid1.h b/drivers/md/raid1.h
index 61c39b390cd8..5ec19449779d 100644
--- a/drivers/md/raid1.h
+++ b/drivers/md/raid1.h
@@ -161,14 +161,15 @@ struct r1bio {
 };
 
 /* bits for r1bio.state */
-#define	R1BIO_Uptodate	0
-#define	R1BIO_IsSync	1
-#define	R1BIO_Degraded	2
-#define	R1BIO_BehindIO	3
+enum r1bio_state {
+	R1BIO_Uptodate,
+	R1BIO_IsSync,
+	R1BIO_Degraded,
+	R1BIO_BehindIO,
 /* Set ReadError on bios that experience a readerror so that
  * raid1d knows what to do with them.
  */
-#define R1BIO_ReadError 4
+	R1BIO_ReadError,
 /* For write-behind requests, we call bi_end_io when
  * the last non-write-behind device completes, providing
  * any write was successful.  Otherwise we call when
@@ -176,10 +177,11 @@ struct r1bio {
  * with failure when last write completes (and all failed).
  * Record that bi_end_io was called with this flag...
  */
-#define	R1BIO_Returned 6
+	R1BIO_Returned,
 /* If a write for this request means we can clear some
  * known-bad-block records, we set this flag
  */
-#define	R1BIO_MadeGood 7
-#define	R1BIO_WriteError 8
+	R1BIO_MadeGood,
+	R1BIO_WriteError,
+};
 #endif


