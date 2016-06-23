From: Alexey Obitotskiy <aleksey.obitotskiy@intel.com>
Subject: [PATCH] Fix kernel module refcount handling
Date: Thu, 23 Jun 2016 12:11:01 +0200
Message-ID: <1466676661-1564-1-git-send-email-aleksey.obitotskiy@intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: shli@kernel.org, Aleksey Obitotskiy <aleksey.obitotskiy@intel.com>
List-Id: linux-raid.ids

md loads raidX modules and increments module refcount each time level
has changed but does not decrement it. You are unable to unload raid0
module after reshape because raid0 reshape changes level to raid4
and back to raid0.

Signed-off-by: Aleksey Obitotskiy <aleksey.obitotskiy@intel.com>
---
 drivers/md/md.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 0963edc..c515e76 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -3590,6 +3590,8 @@ level_store(struct mddev *mddev, const char *buf, size_t len)
 			mddev->to_remove = &md_redundancy_group;
 	}
 
+	module_put(oldpers->owner);
+
 	rdev_for_each(rdev, mddev) {
 		if (rdev->raid_disk < 0)
 			continue;
-- 
2.7.4

