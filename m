From: "majianpeng" <majianpeng@gmail.com>
Subject: [PATCH] md:Fix name of raid thread when raid takeovered
Date: Thu, 31 May 2012 15:41:22 +0800
Message-ID: <201205311541185787676@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

When raid takeovered, it used old personality to set task->comm.

Signed-off-by: majianpeng <majianpeng@gmail.com>
---
 drivers/md/md.c |   15 +++++++++++++++
 1 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 1c2f904..93e20ea 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -32,6 +32,7 @@
    Software Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 */
 
+#include <linux/sched.h>
 #include <linux/kthread.h>
 #include <linux/blkdev.h>
 #include <linux/sysctl.h>
@@ -3513,6 +3514,7 @@ level_store(struct mddev *mddev, const char *buf, size_t len)
 	long level;
 	void *priv;
 	struct md_rdev *rdev;
+	char *tmp;
 
 	if (mddev->pers == NULL) {
 		if (len == 0)
@@ -3674,6 +3676,19 @@ level_store(struct mddev *mddev, const char *buf, size_t len)
 		del_timer_sync(&mddev->safemode_timer);
 	}
 	pers->run(mddev);
+	/*
+	 * when raid takeover using old personality,so mddev->thread->tsk
+	 * name is wrong.
+	 * if kzalloc error, only using wrong name.
+	 */
+	len = strlen(mdname(mddev)) + strlen(mddev->pers->name);
+	tmp = kzalloc(len + 2, GFP_KERNEL);
+	if (tmp) {
+		sprintf(tmp, "%s_%s", mdname(mddev), mddev->pers->name);
+		set_task_comm(mddev->thread->tsk, tmp);
+		kfree(tmp);
+	}
+
 	set_bit(MD_CHANGE_DEVS, &mddev->flags);
 	mddev_resume(mddev);
 	sysfs_notify(&mddev->kobj, NULL, "level");
-- 
1.7.5.4

 				
--------------
majianpeng
2012-05-31

