From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 23/24] md/raid10: resize bitmap when required during
 reshape.
Date: Tue, 17 Apr 2012 18:43:42 +1000
Message-ID: <20120417084342.6433.40249.stgit@notabene.brown>
References: <20120417084324.6433.68345.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120417084324.6433.68345.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

If a reshape changes the size of the array, then we can now
update the bitmap to suit - so do so.

Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/raid10.c |   37 ++++++++++++++++++++++++-------------
 1 file changed, 24 insertions(+), 13 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index cd64c89..1019f63 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -3776,8 +3776,6 @@ static int raid10_check_reshape(struct mddev *mddev)
 	if (mddev->delta_disks < 0)
 		return -EINVAL;
 
-	if (mddev->bitmap)
-		return -EBUSY;
 	if (!enough(conf, -1))
 		return -EINVAL;
 
@@ -3872,6 +3870,7 @@ static int raid10_start_reshape(struct mddev *mddev)
 	struct r10conf *conf = mddev->private;
 	struct md_rdev *rdev;
 	int spares = 0;
+	int ret;
 
 	if (test_bit(MD_RECOVERY_RUNNING, &mddev->recovery))
 		return -EBUSY;
@@ -3928,6 +3927,14 @@ static int raid10_start_reshape(struct mddev *mddev)
 	spin_unlock_irq(&conf->device_lock);
 
 	if (mddev->delta_disks > 0) {
+		if (mddev->bitmap) {
+			ret = bitmap_resize(mddev->bitmap,
+					    raid10_size(mddev, 0,
+							conf->geo.raid_disks),
+					    0, 0);
+			if (ret)
+				goto abort;
+		}
 		rdev_for_each(rdev, mddev)
 			if (rdev->raid_disk < 0 &&
 			    !test_bit(Faulty, &rdev->flags)) {
@@ -3967,22 +3974,26 @@ static int raid10_start_reshape(struct mddev *mddev)
 	mddev->sync_thread = md_register_thread(md_do_sync, mddev,
 						"reshape");
 	if (!mddev->sync_thread) {
-		mddev->recovery = 0;
-		spin_lock_irq(&conf->device_lock);
-		conf->geo = conf->prev;
-		mddev->raid_disks = conf->geo.raid_disks;
-		rdev_for_each(rdev, mddev)
-			rdev->new_data_offset = rdev->data_offset;
-		smp_wmb();
-		conf->reshape_progress = MaxSector;
-		mddev->reshape_position = MaxSector;
-		spin_unlock_irq(&conf->device_lock);
-		return -EAGAIN;
+		ret = -EAGAIN;
+		goto abort;
 	}
 	conf->reshape_checkpoint = jiffies;
 	md_wakeup_thread(mddev->sync_thread);
 	md_new_event(mddev);
 	return 0;
+
+abort:
+	mddev->recovery = 0;
+	spin_lock_irq(&conf->device_lock);
+	conf->geo = conf->prev;
+	mddev->raid_disks = conf->geo.raid_disks;
+	rdev_for_each(rdev, mddev)
+		rdev->new_data_offset = rdev->data_offset;
+	smp_wmb();
+	conf->reshape_progress = MaxSector;
+	mddev->reshape_position = MaxSector;
+	spin_unlock_irq(&conf->device_lock);
+	return ret;
 }
 
 /* Calculate the last device-address that could contain


