From: NeilBrown <neilb@suse.com>
Subject: [PATCH 4/4] md: allow metadata update while suspending.
Date: Tue, 12 Sep 2017 11:49:12 +1000
Message-ID: <150518095224.32691.11820497170759656946.stgit@noble>
References: <150518076229.32691.13542756562323866921.stgit@noble>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <150518076229.32691.13542756562323866921.stgit@noble>
Sender: linux-raid-owner@vger.kernel.org
To: Xiao Ni <xni@redhat.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

There are various deadlock that can occur
when a thread holds reconfig_mutex and calls
->quiesce(mddev, 1).
As the md thread update the metadata while the
reconfig mutex is held, the array may not fully
quiesce.
For example, raid5 will not complete stripes
while a metadata update is pending, and that
prevents raid5_quiesce() from completing.

->quiesce() is now usually called from mddev_suspend(),
and it is always called with reconfig_mutex held.  So
at this time it is safe for the thread to update metadata
without explicitly taking the lock.

So add 2 new flags, one which says the unlocked update is
allowed, and one which ways it is happening.  Then allow
it while the quiesce completes, and then wait for it to finished.

Signed-off-by: NeilBrown <neilb@suse.com>
---
 drivers/md/md.c |   14 ++++++++++++++
 drivers/md/md.h |    6 ++++++
 2 files changed, 20 insertions(+)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 0b167169fef9..f63721109d0e 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -341,8 +341,12 @@ void mddev_suspend(struct mddev *mddev)
 		return;
 	synchronize_rcu();
 	wake_up(&mddev->sb_wait);
+	set_bit(MD_ALLOW_SB_UPDATE, &mddev->flags);
+	smp_mb__after_atomic();
 	wait_event(mddev->sb_wait, atomic_read(&mddev->active_io) == 0);
 	mddev->pers->quiesce(mddev, 1);
+	clear_bit_unlock(MD_ALLOW_SB_UPDATE, &mddev->flags);
+	wait_event(mddev->sb_wait, !test_bit(MD_UPDATING_SB, &mddev->flags));
 
 	del_timer_sync(&mddev->safemode_timer);
 }
@@ -8790,6 +8794,16 @@ void md_check_recovery(struct mddev *mddev)
 	unlock:
 		wake_up(&mddev->sb_wait);
 		mddev_unlock(mddev);
+	} else if (test_bit(MD_ALLOW_SB_UPDATE, &mddev->flags) && mddev->sb_flags) {
+		/* Write superblock - thread that called mddev_suspend()
+		 * holds reconfig_mutex for us.
+		 */
+		set_bit(MD_UPDATING_SB, &mddev->flags);
+		smp_mb__after_atomic();
+		if (test_bit(MD_ALLOW_SB_UPDATE, &mddev->flags))
+			md_update_sb(mddev, 0);
+		clear_bit_unlock(MD_UPDATING_SB, &mddev->flags);
+		wake_up(&mddev->sb_wait);
 	}
 }
 EXPORT_SYMBOL(md_check_recovery);
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 09db03455801..8ab5e1bcb10f 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -236,6 +236,12 @@ enum mddev_flags {
 				 * never cause the array to become failed.
 				 */
 	MD_HAS_PPL,		/* The raid array has PPL feature set */
+	MD_ALLOW_SB_UPDATE,	/* md_check_recovery is allowed to update
+				 * the metadata without taking reconfig_mutex.
+				 */
+	MD_UPDATING_SB,		/* md_check_recovery is updating the metadata
+				 * without explicitly holding reconfig_mutex.
+				 */
 };
 
 enum mddev_sb_flags {


