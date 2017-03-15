From: NeilBrown <neilb@suse.com>
Subject: [md PATCH 12/15] md: factor out set_in_sync()
Date: Wed, 15 Mar 2017 14:05:14 +1100
Message-ID: <148954711419.18641.11688242579664607023.stgit@noble>
References: <148954692173.18641.1294690639716682540.stgit@noble>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <148954692173.18641.1294690639716682540.stgit@noble>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org, hch@lst.de
List-Id: linux-raid.ids

Three separate places in md.c check if the number of active
writes is zero and, if so, sets mddev->in_sync.

There are a few differences, but there shouldn't be:
- it is always appropriate to notify the change in
  sysfs_state, and there is no need to do this outside a
  spin-locked region.
- we never need to check ->recovery_cp.  The state of resync
  is not relevant for whether there are any pending writes
  or not (which is what ->in_sync reports).

So create set_in_sync() which does the correct tests and
makes the correct changes, and call this in all three
places.

Any behaviour changes here a minor and cosmetic.

Signed-off-by: NeilBrown <neilb@suse.com>
---
 drivers/md/md.c |   54 ++++++++++++++++++++----------------------------------
 1 file changed, 20 insertions(+), 34 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index bad5771bced4..2fa8048894e6 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -2252,6 +2252,21 @@ static void export_array(struct mddev *mddev)
 	mddev->major_version = 0;
 }
 
+static bool set_in_sync(struct mddev *mddev)
+{
+	WARN_ON_ONCE(!spin_is_locked(&mddev->lock));
+	if (atomic_read(&mddev->writes_pending) == 0) {
+		if (mddev->in_sync == 0) {
+			mddev->in_sync = 1;
+			set_bit(MD_SB_CHANGE_CLEAN, &mddev->sb_flags);
+			sysfs_notify_dirent_safe(mddev->sysfs_state);
+		}
+	}
+	if (mddev->safemode == 1)
+		mddev->safemode = 0;
+	return mddev->in_sync;
+}
+
 static void sync_sbs(struct mddev *mddev, int nospares)
 {
 	/* Update each superblock (in-memory image), but
@@ -4024,7 +4039,7 @@ static int restart_array(struct mddev *mddev);
 static ssize_t
 array_state_store(struct mddev *mddev, const char *buf, size_t len)
 {
-	int err;
+	int err = 0;
 	enum array_state st = match_word(buf, array_states);
 
 	if (mddev->pers && (st == active || st == clean) && mddev->ro != 1) {
@@ -4037,18 +4052,9 @@ array_state_store(struct mddev *mddev, const char *buf, size_t len)
 			clear_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags);
 			md_wakeup_thread(mddev->thread);
 			wake_up(&mddev->sb_wait);
-			err = 0;
 		} else /* st == clean */ {
 			restart_array(mddev);
-			if (atomic_read(&mddev->writes_pending) == 0) {
-				if (mddev->in_sync == 0) {
-					mddev->in_sync = 1;
-					if (mddev->safemode == 1)
-						mddev->safemode = 0;
-					set_bit(MD_SB_CHANGE_CLEAN, &mddev->sb_flags);
-				}
-				err = 0;
-			} else
+			if (!set_in_sync(mddev))
 				err = -EBUSY;
 		}
 		if (!err)
@@ -4106,15 +4112,7 @@ array_state_store(struct mddev *mddev, const char *buf, size_t len)
 			if (err)
 				break;
 			spin_lock(&mddev->lock);
-			if (atomic_read(&mddev->writes_pending) == 0) {
-				if (mddev->in_sync == 0) {
-					mddev->in_sync = 1;
-					if (mddev->safemode == 1)
-						mddev->safemode = 0;
-					set_bit(MD_SB_CHANGE_CLEAN, &mddev->sb_flags);
-				}
-				err = 0;
-			} else
+			if (!set_in_sync(mddev))
 				err = -EBUSY;
 			spin_unlock(&mddev->lock);
 		} else
@@ -8591,22 +8589,10 @@ void md_check_recovery(struct mddev *mddev)
 			}
 		}
 
-		if (!mddev->external) {
-			int did_change = 0;
+		if (!mddev->external && !mddev->in_sync) {
 			spin_lock(&mddev->lock);
-			if (mddev->safemode &&
-			    !atomic_read(&mddev->writes_pending) &&
-			    !mddev->in_sync &&
-			    mddev->recovery_cp == MaxSector) {
-				mddev->in_sync = 1;
-				did_change = 1;
-				set_bit(MD_SB_CHANGE_CLEAN, &mddev->sb_flags);
-			}
-			if (mddev->safemode == 1)
-				mddev->safemode = 0;
+			set_in_sync(mddev);
 			spin_unlock(&mddev->lock);
-			if (did_change)
-				sysfs_notify_dirent_safe(mddev->sysfs_state);
 		}
 
 		if (mddev->sb_flags)


