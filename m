From: raz ben yehuda <raziebe@gmail.com>
Subject: Subject:[PATCH 003:013]: raid0: raid0_size to support reshape
Date: Wed, 17 Jun 2009 00:53:01 +0300
Message-ID: <1245189181.3478.98.camel@raz>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux raid <linux-raid@vger.kernel.org>, Neil Brown <neilb@suse.de>
List-Id: linux-raid.ids

have raid0_size sum only In_sync disks

 raid0.c |   17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

Signed-off-by: razb <raziebe@gmail.com>
---
diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index 8870acc..6160374 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -296,15 +296,18 @@ static int raid0_mergeable_bvec(struct request_queue *q,
 
 static sector_t raid0_size(mddev_t *mddev, sector_t sectors, int raid_disks)
 {
-	sector_t array_sectors = 0;
+	int i;
 	mdk_rdev_t *rdev;
+	sector_t array_sectors = 0;
+	raid0_conf_t *conf = mddev->private;
+	mdk_rdev_t **devlist = conf->devlist;
 
-	WARN_ONCE(sectors || raid_disks,
-		  "%s does not support generic reshape\n", __func__);
-
-	list_for_each_entry(rdev, &mddev->disks, same_set)
-		array_sectors += rdev->sectors;
-
+	for (i = 0; i < mddev->raid_disks; i++) {
+		rdev = devlist[i];
+		/* in reshape, spare disk is not in sync */
+		if (test_bit(In_sync, &rdev->flags))
+			array_sectors += rdev->sectors;
+	}
 	return array_sectors;
 }
 



