From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 26/26] md: wakeup thread upon rdev_dec_pending()
Date: Wed, 04 Feb 2015 08:42:30 +1100
Message-ID: <20150203214230.3448.5814.stgit@notabene.brown>
References: <20150203213948.3448.80258.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20150203213948.3448.80258.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

From: Hannes Reinecke <hare@suse.de>

After each call to rdev_dec_pending() we should wakeup the
md thread if the device is found to be faulty.
Otherwise we'll incur heavy delays on failing devices.

Signed-off-by: Neil Brown <nfbrown@suse.de>
Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/md/md.h |   17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/md/md.h b/drivers/md/md.h
index 14367d919351..318ca8fd430f 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -474,13 +474,6 @@ static inline int mddev_trylock(struct mddev *mddev)
 }
 extern void mddev_unlock(struct mddev *mddev);
 
-static inline void rdev_dec_pending(struct md_rdev *rdev, struct mddev *mddev)
-{
-	int faulty = test_bit(Faulty, &rdev->flags);
-	if (atomic_dec_and_test(&rdev->nr_pending) && faulty)
-		set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
-}
-
 static inline void md_sync_acct(struct block_device *bdev, unsigned long nr_sectors)
 {
 	atomic_add(nr_sectors, &bdev->bd_contains->bd_disk->sync_io);
@@ -666,4 +659,14 @@ static inline int mddev_check_plugged(struct mddev *mddev)
 	return !!blk_check_plugged(md_unplug, mddev,
 				   sizeof(struct blk_plug_cb));
 }
+
+static inline void rdev_dec_pending(struct md_rdev *rdev, struct mddev *mddev)
+{
+	int faulty = test_bit(Faulty, &rdev->flags);
+	if (atomic_dec_and_test(&rdev->nr_pending) && faulty) {
+		set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
+		md_wakeup_thread(mddev->thread);
+	}
+}
+
 #endif /* _MD_MD_H */


