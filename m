From: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Subject: [PATCH v2] md: notify about new spare disk in the container
Date: Fri, 28 Jul 2017 15:49:25 +0200
Message-ID: <20170728134925.11088-1-artur.paszkiewicz@intel.com>
References: <20170721202446.lpy7noq6bbn7g7qt@kernel.org>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170721202446.lpy7noq6bbn7g7qt@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: shli@kernel.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

From: "Alexey Obitotskiy" <aleksey.obitotskiy@intel.com>

In case of external metadata arrays spare disks are added to containers
first. mdadm keeps monitoring /proc/mdstat output and when spare disk is
available, it moves it from the container to the array. The problem is
there is no notification of new spare disk in the container and mdadm
waits a long time (until timeout) before it takes the action.

Signed-off-by: Alexey Obitotskiy <aleksey.obitotskiy@intel.com>
---
 drivers/md/md.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 8cdca0296749..594ebbaf4171 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -4283,6 +4283,8 @@ new_dev_store(struct mddev *mddev, const char *buf, size_t len)
 	if (err)
 		export_rdev(rdev);
 	mddev_unlock(mddev);
+	if (!err)
+		md_new_event(mddev);
 	return err ? err : len;
 }
 
-- 
2.13.1

