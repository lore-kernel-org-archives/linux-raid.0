From: Alexey Obitotskiy <aleksey.obitotskiy@intel.com>
Subject: [PATCH] md: notify about new spare disk in the container
Date: Fri, 21 Jul 2017 12:19:04 +0200
Message-ID: <1500632344-22339-1-git-send-email-aleksey.obitotskiy@intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: shli@kernel.org
List-Id: linux-raid.ids

In case of external metadata arrays spare disks are added to containers
first. mdadm keeps monitoring /proc/mdstat output and when spare disk is
available, it moves it from the container to the array. The problem is
there is no notification of new spare disk in the container and mdadm
waits a long time (until timeout) before it takes the action.

Signed-off-by: Alexey Obitotskiy <aleksey.obitotskiy@intel.com>
---
 drivers/md/md.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 66f6b92..02f4c6f 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -4283,6 +4283,7 @@ new_dev_store(struct mddev *mddev, const char *buf, size_t len)
 	if (err)
 		export_rdev(rdev);
 	mddev_unlock(mddev);
+	md_new_event(mddev);
 	return err ? err : len;
 }
 
-- 
2.7.4

