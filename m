From: NeilBrown <neilb@suse.com>
Subject: [md PATCH 12/14] md: factor out set_in_sync()
Date: Thu, 16 Feb 2017 15:39:03 +1100
Message-ID: <148721994297.7521.6251174495409181904.stgit@noble>
References: <148721992248.7521.17160361058957519076.stgit@noble>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <148721992248.7521.17160361058957519076.stgit@noble>
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
 drivers/md/md.c |   57 ++++++++++++++++++++++---------------------------------
 1 file changed, 23 insertions(+), 34 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 01175dac0db6..1d5fdc4a659d 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -2250,6 +2250,24 @@ static void export_array(struct mddev *mddev)
 	mddev->major_version = 0;
 }
 
+static bool set_in_sync(struct mddev *mddev)
+{
+	bool ret = false;
+
+	WARN_ON_ONCE(!spin_is_locked(&mddev->lock));
+	if (atomic_read(&mddev->writes_pending) == 0) {
+		if (mddev->in_sync == 0) {
+			mddev->in_sync = 1;
+			set_bit(MD_SB_CHANGE_CLEAN, &mddev->sb_flags);
+			sysfs_notify_dirent_safe(mddev->sysfs_state);
+		}
+		ret = true;
+	}
+	if (mddev->safemode == 1)
+		mddev->safemode = 0;
+	return ret;
+}
+
 static void sync_sbs(struct mddev *mddev, int nospares)
 {
 	/* Update each superblock (in-memory image), but
@@ -3948,7 +3966,7 @@ static int restart_array(struct mddev *mddev);
 static ssize_t
 array_state_store(struct mddev *mddev, const char *buf, size_t len)
 {
-	int err;
+	int err = 0;
 	enum array_state st = match_word(buf, array_states);
 
 	if (mddev->pers && (st == active || st == clean) && mddev->ro != 1) {
@@ -3961,18 +3979,9 @@ array_state_store(struct mddev *mddev, const char *buf, size_t len)
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
@@ -4030,15 +4039,7 @@ array_state_store(struct mddev *mddev, const char *buf, size_t len)
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
@@ -8450,22 +8451,10 @@ void md_check_recovery(struct mddev *mddev)
 				md_reload_sb(mddev, mddev->good_device_nr);
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


