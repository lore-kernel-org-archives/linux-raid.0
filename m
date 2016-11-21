From: NeilBrown <neilb@suse.com>
Subject: [md PATCH 1/5] md: optimize md_write_start() slightly.
Date: Mon, 21 Nov 2016 12:19:43 +1100
Message-ID: <147969118311.5434.4562756561505136744.stgit@noble>
References: <147969099621.5434.12384452255155063186.stgit@noble>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <147969099621.5434.12384452255155063186.stgit@noble>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>, Christoph Hellwig <hch@lst.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

If md_write_start() finds that ->writes_pending is non-zero, it
should be able to avoid most of the other checks.

To ensure that a non-zero ->writes_pending does mean that other checks
have completed, move it down until after ->in_sync is known to be
clear.  To avoid races with places like array_state_store() which
possible sets ->in_sync, we need to increment ->write_pending inside
the locked region.  As ->writes_pending is now incremented *after*
->in_sync is tested, we must always take the spin_lock, but only if
->writes_pending was found to be zero.

If ->writes_pending is found to be non-zero, we still need to wait it
MD_CHANGE_PENDING is true.

In the common case, md_write_start() will now only
 - check if data_dir is WRITE
 - increment ->writes_pending
 - check MD_CHANGE_PENDING is cleared.

Signed-off-by: NeilBrown <neilb@suse.com>
---
 drivers/md/md.c |   32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 1f1c7f007b68..2f21f6c7156f 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -7686,20 +7686,18 @@ void md_write_start(struct mddev *mddev, struct bio *bi)
 	int did_change = 0;
 	if (bio_data_dir(bi) != WRITE)
 		return;
-
-	BUG_ON(mddev->ro == 1);
-	if (mddev->ro == 2) {
-		/* need to switch to read/write */
-		mddev->ro = 0;
-		set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
-		md_wakeup_thread(mddev->thread);
-		md_wakeup_thread(mddev->sync_thread);
-		did_change = 1;
-	}
-	atomic_inc(&mddev->writes_pending);
-	if (mddev->safemode == 1)
-		mddev->safemode = 0;
-	if (mddev->in_sync) {
+	if (!atomic_inc_not_zero(&mddev->writes_pending)) {
+		BUG_ON(mddev->ro == 1);
+		if (mddev->ro == 2) {
+			/* need to switch to read/write */
+			mddev->ro = 0;
+			set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
+			md_wakeup_thread(mddev->thread);
+			md_wakeup_thread(mddev->sync_thread);
+			did_change = 1;
+		}
+		if (mddev->safemode == 1)
+			mddev->safemode = 0;
 		spin_lock(&mddev->lock);
 		if (mddev->in_sync) {
 			mddev->in_sync = 0;
@@ -7708,10 +7706,12 @@ void md_write_start(struct mddev *mddev, struct bio *bi)
 			md_wakeup_thread(mddev->thread);
 			did_change = 1;
 		}
+		atomic_inc(&mddev->writes_pending);
 		spin_unlock(&mddev->lock);
+
+		if (did_change)
+			sysfs_notify_dirent_safe(mddev->sysfs_state);
 	}
-	if (did_change)
-		sysfs_notify_dirent_safe(mddev->sysfs_state);
 	wait_event(mddev->sb_wait,
 		   !test_bit(MD_CHANGE_PENDING, &mddev->flags));
 }


