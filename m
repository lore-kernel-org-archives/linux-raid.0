From: Sebastian Riemer <sebastian.riemer@profitbricks.com>
Subject: [PATCH v2] md: also hot remove disk from pers when hot removing
Date: Fri, 16 Nov 2012 17:04:09 +0100
Message-ID: <1353081849-10516-1-git-send-email-sebastian.riemer@profitbricks.com>
Reply-To: linux-raid <linux-raid@vger.kernel.org>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
Cc: Sebastian Riemer <sebastian.riemer@profitbricks.com>
List-Id: linux-raid.ids

If hot adding a disk not as spare but at the same slot, the disk isn't added
correctly in the pers and it is possible to cause a kernel panic/oops due to
the invalid pointer to the old rdev in the pers. So hot remove the disk from
the personality before removing it from the array.

Tested with raid1.

Signed-off-by: Sebastian Riemer <sebastian.riemer@profitbricks.com>
---
 drivers/md/md.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 9ab768a..1fc545b 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -5852,6 +5852,7 @@ static int hot_remove_disk(struct mddev * mddev, dev_t dev)
 {
 	char b[BDEVNAME_SIZE];
 	struct md_rdev *rdev;
+	int err;
 
 	rdev = find_rdev(mddev, dev);
 	if (!rdev)
@@ -5860,6 +5861,12 @@ static int hot_remove_disk(struct mddev * mddev, dev_t dev)
 	if (rdev->raid_disk >= 0)
 		goto busy;
 
+	if (mddev->pers && mddev->pers->hot_remove_disk) {
+		err = mddev->pers->hot_remove_disk(mddev, rdev);
+		if (err)
+			return err;
+		sysfs_unlink_rdev(mddev, rdev);
+	}
 	kick_rdev_from_array(rdev);
 	md_update_sb(mddev, 1);
 	md_new_event(mddev);
-- 
1.7.1

