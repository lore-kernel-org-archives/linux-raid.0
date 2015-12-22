From: Shraddha Barke <shraddha.6596@gmail.com>
Subject: [PATCH 2/2] md: Replace get_seconds with ktime_get_seconds
Date: Tue, 22 Dec 2015 18:36:42 +0530
Message-ID: <1450789602-31162-1-git-send-email-shraddha.6596@gmail.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.com>
Cc: linux-raid@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, Shraddha Barke <shraddha.6596@gmail.com>
List-Id: linux-raid.ids

32-bit systems using function get_seconds will break in year 2038,
in order to avoid that replace the code with more appropriate function
ktime_get_seconds which is y2038 safe. Function ktime_get_seconds use
monotonic instead of real time and therefore will not cause overflow

Signed-off-by: Shraddha Barke <shraddha.6596@gmail.com>
---
 drivers/md/md.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 807095f..8dd74bb 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -2333,7 +2333,7 @@ repeat:
 
 	spin_lock(&mddev->lock);
 
-	mddev->utime = get_seconds();
+	mddev->utime = ktime_get_seconds();
 
 	if (test_and_clear_bit(MD_CHANGE_DEVS, &mddev->flags))
 		force_change = 1;
@@ -6347,13 +6347,13 @@ static int set_array_info(struct mddev *mddev, mdu_array_info_t *info)
 		/* ensure mddev_put doesn't delete this now that there
 		 * is some minimal configuration.
 		 */
-		mddev->ctime         = get_seconds();
+		mddev->ctime         = ktime_get_seconds();
 		return 0;
 	}
 	mddev->major_version = MD_MAJOR_VERSION;
 	mddev->minor_version = MD_MINOR_VERSION;
 	mddev->patch_version = MD_PATCHLEVEL_VERSION;
-	mddev->ctime         = get_seconds();
+	mddev->ctime         = ktime_get_seconds();
 
 	mddev->level         = info->level;
 	mddev->clevel[0]     = 0;
-- 
2.1.4

