From: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
Subject: [PATCH 5/5] md: remove the extra line for ->hot_add_disk
Date: Sat,  4 Apr 2020 23:57:11 +0200
Message-ID: <20200404215711.4272-6-guoqing.jiang@cloud.ionos.com>
References: <20200404215711.4272-1-guoqing.jiang@cloud.ionos.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20200404215711.4272-1-guoqing.jiang@cloud.ionos.com>
Sender: linux-raid-owner@vger.kernel.org
To: songliubraving@fb.com
Cc: linux-raid@vger.kernel.org, Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
List-Id: linux-raid.ids

It is not not necessary to add a newline for them since they don't exceed
80 characters, and it is not intutive to distinguish ->hot_add_disk() from
hot_add_disk() too.

Signed-off-by: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
---
 drivers/md/md.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 2bd2d91f2015..a378b6d63fa9 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -3190,8 +3190,7 @@ slot_store(struct md_rdev *rdev, const char *buf, size_t len)
 			rdev->saved_raid_disk = -1;
 		clear_bit(In_sync, &rdev->flags);
 		clear_bit(Bitmap_sync, &rdev->flags);
-		err = rdev->mddev->pers->
-			hot_add_disk(rdev->mddev, rdev);
+		err = rdev->mddev->pers->hot_add_disk(rdev->mddev, rdev);
 		if (err) {
 			rdev->raid_disk = -1;
 			return err;
@@ -9056,8 +9055,7 @@ static int remove_and_add_spares(struct mddev *mddev,
 
 			rdev->recovery_offset = 0;
 		}
-		if (mddev->pers->
-		    hot_add_disk(mddev, rdev) == 0) {
+		if (mddev->pers->hot_add_disk(mddev, rdev) == 0) {
 			if (sysfs_link_rdev(mddev, rdev))
 				/* failure here is OK */;
 			if (!test_bit(Journal, &rdev->flags))
-- 
2.17.1
