From: Junxiao Bi <junxiao.bi@oracle.com>
Subject: [PATCH] md: get sysfs entry after redundancy attr group create
Date: Tue,  4 Aug 2020 17:27:18 -0700
Message-ID: <20200805002718.50839-1-junxiao.bi@oracle.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: songliubraving@fb.com, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

"sync_completed" and "degraded" belongs to redundancy attr group,
it was not exist yet when md device was created.

Reported-by: kernel test robot <rong.a.chen@intel.com>
Fixes: e1a86dbbbd6a ("md: fix deadlock causing by sysfs_notify")
Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
---
 drivers/md/md.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index fee8943ead7b..60d2142c4693 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -846,7 +846,13 @@ void mddev_unlock(struct mddev *mddev)
 				sysfs_remove_group(&mddev->kobj, &md_redundancy_group);
 				if (mddev->sysfs_action)
 					sysfs_put(mddev->sysfs_action);
+				if (mddev->sysfs_completed)
+					sysfs_put(mddev->sysfs_completed);
+				if (mddev->sysfs_degraded)
+					sysfs_put(mddev->sysfs_degraded);
 				mddev->sysfs_action = NULL;
+				mddev->sysfs_completed = NULL;
+				mddev->sysfs_degraded = NULL;
 			}
 		}
 		mddev->sysfs_active = 0;
@@ -4036,6 +4042,8 @@ level_store(struct mddev *mddev, const char *buf, size_t len)
 			pr_warn("md: cannot register extra attributes for %s\n",
 				mdname(mddev));
 		mddev->sysfs_action = sysfs_get_dirent(mddev->kobj.sd, "sync_action");
+		mddev->sysfs_completed = sysfs_get_dirent_safe(mddev->kobj.sd, "sync_completed");
+		mddev->sysfs_degraded = sysfs_get_dirent_safe(mddev->kobj.sd, "degraded");
 	}
 	if (oldpers->sync_request != NULL &&
 	    pers->sync_request == NULL) {
@@ -5542,14 +5550,9 @@ static void md_free(struct kobject *ko)
 
 	if (mddev->sysfs_state)
 		sysfs_put(mddev->sysfs_state);
-	if (mddev->sysfs_completed)
-		sysfs_put(mddev->sysfs_completed);
-	if (mddev->sysfs_degraded)
-		sysfs_put(mddev->sysfs_degraded);
 	if (mddev->sysfs_level)
 		sysfs_put(mddev->sysfs_level);
 
-
 	if (mddev->gendisk)
 		del_gendisk(mddev->gendisk);
 	if (mddev->queue)
@@ -5710,8 +5713,6 @@ static int md_alloc(dev_t dev, char *name)
 	if (!error && mddev->kobj.sd) {
 		kobject_uevent(&mddev->kobj, KOBJ_ADD);
 		mddev->sysfs_state = sysfs_get_dirent_safe(mddev->kobj.sd, "array_state");
-		mddev->sysfs_completed = sysfs_get_dirent_safe(mddev->kobj.sd, "sync_completed");
-		mddev->sysfs_degraded = sysfs_get_dirent_safe(mddev->kobj.sd, "degraded");
 		mddev->sysfs_level = sysfs_get_dirent_safe(mddev->kobj.sd, "level");
 	}
 	mddev_put(mddev);
@@ -5991,6 +5992,8 @@ int md_run(struct mddev *mddev)
 			pr_warn("md: cannot register extra attributes for %s\n",
 				mdname(mddev));
 		mddev->sysfs_action = sysfs_get_dirent_safe(mddev->kobj.sd, "sync_action");
+		mddev->sysfs_completed = sysfs_get_dirent_safe(mddev->kobj.sd, "sync_completed");
+		mddev->sysfs_degraded = sysfs_get_dirent_safe(mddev->kobj.sd, "degraded");
 	} else if (mddev->ro == 2) /* auto-readonly not meaningful */
 		mddev->ro = 0;
 
-- 
2.20.1 (Apple Git-117)
