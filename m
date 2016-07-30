From: shli@kernel.org
Subject: [PATCH 1/3] MD: hold mddev lock for .quiesce in md_do_sync
Date: Sat, 30 Jul 2016 16:54:38 -0700
Message-ID: <515fa68e5c4784b08f2ce99c082c923f6b02a3c9.1469922791.git.shli@fb.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Shaohua Li <shli@fb.com>, NeilBrown <neilb@suse.com>
List-Id: linux-raid.ids

From: Shaohua Li <shli@fb.com>

.quiesce is called with mddev lock hold at most places. There are few
exceptions. Calling .quesce without the lock hold could create races. For
example, the .quesce of raid1 can't be recursively. The purpose of the patches
is to fix a race in raid5-cache. The raid5-cache .quesce will write md
superblock and should be called with mddev lock hold.

Cc: NeilBrown <neilb@suse.com>
Signed-off-by: Shaohua Li <shli@fb.com>
---
 drivers/md/md.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 2c3ab6f..0550445 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -7945,8 +7945,10 @@ void md_do_sync(struct md_thread *thread)
 		 * region.
 		 */
 		if (mddev->bitmap) {
+			mddev_lock_nointr(mddev);
 			mddev->pers->quiesce(mddev, 1);
 			mddev->pers->quiesce(mddev, 0);
+			mddev_unlock(mddev);
 		}
 	}
 
-- 
2.7.4

