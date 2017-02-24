From: Guoqing Jiang <gqjiang@suse.com>
Subject: [PATCH 13/14] md: move funcs from pers->resize to update_size
Date: Fri, 24 Feb 2017 11:15:23 +0800
Message-ID: <1487906124-20107-14-git-send-email-gqjiang@suse.com>
References: <1487906124-20107-1-git-send-email-gqjiang@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1487906124-20107-1-git-send-email-gqjiang@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: shli@fb.com, neilb@suse.de, Guoqing Jiang <gqjiang@suse.com>
List-Id: linux-raid.ids

raid1_resize and raid5_resize should also check the
mddev->queue if run underneath dm-raid.

And both set_capacity and revalidate_disk are used in
pers->resize such as raid1, raid10 and raid5. So
move them from personality file to common code.

Reviewed-by: NeilBrown <neilb@suse.com>
Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
---
 drivers/md/md.c     | 8 ++++++--
 drivers/md/raid1.c  | 2 --
 drivers/md/raid10.c | 4 ----
 drivers/md/raid5.c  | 2 --
 4 files changed, 6 insertions(+), 10 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 7bcc757386e1..975c9dd60c05 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -6534,8 +6534,12 @@ static int update_size(struct mddev *mddev, sector_t num_sectors)
 			return -ENOSPC;
 	}
 	rv = mddev->pers->resize(mddev, num_sectors);
-	if (!rv)
-		revalidate_disk(mddev->gendisk);
+	if (!rv) {
+		if (mddev->queue) {
+			set_capacity(mddev->gendisk, mddev->array_sectors);
+			revalidate_disk(mddev->gendisk);
+		}
+	}
 	return rv;
 }
 
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index d4e8796b4569..9688f81ea7e9 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -3246,8 +3246,6 @@ static int raid1_resize(struct mddev *mddev, sector_t sectors)
 			return ret;
 	}
 	md_set_array_sectors(mddev, newsize);
-	set_capacity(mddev->gendisk, mddev->array_sectors);
-	revalidate_disk(mddev->gendisk);
 	if (sectors > mddev->dev_sectors &&
 	    mddev->recovery_cp > mddev->dev_sectors) {
 		mddev->recovery_cp = mddev->dev_sectors;
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index ade7d69234d5..59533cbea446 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -3943,10 +3943,6 @@ static int raid10_resize(struct mddev *mddev, sector_t sectors)
 			return ret;
 	}
 	md_set_array_sectors(mddev, size);
-	if (mddev->queue) {
-		set_capacity(mddev->gendisk, mddev->array_sectors);
-		revalidate_disk(mddev->gendisk);
-	}
 	if (sectors > mddev->dev_sectors &&
 	    mddev->recovery_cp > oldsize) {
 		mddev->recovery_cp = oldsize;
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 7b7722bb2e8d..df63cd7830ce 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -7603,8 +7603,6 @@ static int raid5_resize(struct mddev *mddev, sector_t sectors)
 			return ret;
 	}
 	md_set_array_sectors(mddev, newsize);
-	set_capacity(mddev->gendisk, mddev->array_sectors);
-	revalidate_disk(mddev->gendisk);
 	if (sectors > mddev->dev_sectors &&
 	    mddev->recovery_cp > mddev->dev_sectors) {
 		mddev->recovery_cp = mddev->dev_sectors;
-- 
2.6.2

