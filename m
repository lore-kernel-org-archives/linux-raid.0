From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Subject: [PATCH 05/24] Introduce md_cluster_operations to handle cluster
 functions
Date: Thu, 18 Dec 2014 10:16:17 -0600
Message-ID: <20141218161617.GA29593@shrek.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: lzhong@suse.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This allows dynamic registering of cluster hooks.

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
---
 drivers/md/md-cluster.c | 18 +++++++++++++++++
 drivers/md/md-cluster.h | 15 +++++++++++++++
 drivers/md/md.c         | 51 +++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/md/md.h         |  7 +++++++
 4 files changed, 91 insertions(+)
 create mode 100644 drivers/md/md-cluster.h

diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
index e555b76..d2d4d33 100644
--- a/drivers/md/md-cluster.c
+++ b/drivers/md/md-cluster.c
@@ -16,6 +16,7 @@
 #include <linux/dlm.h>
 #include <linux/sched.h>
 #include "md.h"
+#include "md-cluster.h"
 
 #define LVB_SIZE	64
 
@@ -118,14 +119,31 @@ static void lockres_free(struct dlm_lock_resource *res)
 	return;
 }
 
+static int join(struct mddev *md, int nodes)
+{
+	return 0;
+}
+
+static int leave(struct mddev *md)
+{
+	return 0;
+}
+
+static struct md_cluster_operations cluster_ops = {
+	.join   = join,
+	.leave  = leave,
+};
+
 static int __init cluster_init(void)
 {
 	pr_info("Registering Cluster MD functions\n");
+	register_md_cluster_operations(&cluster_ops, THIS_MODULE);
 	return 0;
 }
 
 static void cluster_exit(void)
 {
+	unregister_md_cluster_operations();
 }
 
 module_init(cluster_init);
diff --git a/drivers/md/md-cluster.h b/drivers/md/md-cluster.h
new file mode 100644
index 0000000..aa9f07b
--- /dev/null
+++ b/drivers/md/md-cluster.h
@@ -0,0 +1,15 @@
+
+
+#ifndef _MD_CLUSTER_H
+#define _MD_CLUSTER_H
+
+#include "md.h"
+
+struct mddev;
+
+struct md_cluster_operations {
+	int (*join)(struct mddev *mddev);
+	int (*leave)(struct mddev *mddev);
+};
+
+#endif /* _MD_CLUSTER_H */
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 40959ee..795d925 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -53,6 +53,7 @@
 #include <linux/slab.h>
 #include "md.h"
 #include "bitmap.h"
+#include "md-cluster.h"
 
 #ifndef MODULE
 static void autostart_arrays(int part);
@@ -66,6 +67,10 @@ static void autostart_arrays(int part);
 static LIST_HEAD(pers_list);
 static DEFINE_SPINLOCK(pers_lock);
 
+struct md_cluster_operations *md_cluster_ops;
+struct module *md_cluster_mod;
+EXPORT_SYMBOL(md_cluster_mod);
+
 static void md_print_devices(void);
 
 static DECLARE_WAIT_QUEUE_HEAD(resync_wait);
@@ -7228,6 +7233,52 @@ int unregister_md_personality(struct md_personality *p)
 	return 0;
 }
 
+int register_md_cluster_operations(struct md_cluster_operations *ops, struct module *module)
+{
+	if (md_cluster_ops != NULL)
+		return -EALREADY;
+	spin_lock(&pers_lock);
+	md_cluster_ops = ops;
+	md_cluster_mod = module;
+	spin_unlock(&pers_lock);
+	return 0;
+}
+EXPORT_SYMBOL(register_md_cluster_operations);
+
+int unregister_md_cluster_operations(void)
+{
+	spin_lock(&pers_lock);
+	md_cluster_ops = NULL;
+	spin_unlock(&pers_lock);
+	return 0;
+}
+EXPORT_SYMBOL(unregister_md_cluster_operations);
+
+int md_setup_cluster(struct mddev *mddev, int nodes)
+{
+	int err;
+	err = request_module("md-cluster");
+	if (err) {
+		pr_err("md-cluster module not found.\n");
+		return err;
+	}
+
+	spin_lock(&pers_lock);
+	if (!md_cluster_ops || !try_module_get(md_cluster_mod)) {
+		spin_unlock(&pers_lock);
+		return -ENOENT;
+	}
+	spin_unlock(&pers_lock);
+
+	return md_cluster_ops->join(mddev);
+}
+
+void md_cluster_stop(struct mddev *mddev)
+{
+	md_cluster_ops->leave(mddev);
+	module_put(md_cluster_mod);
+}
+
 static int is_mddev_idle(struct mddev *mddev, int init)
 {
 	struct md_rdev * rdev;
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 07bba96..076e1ae 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -23,6 +23,7 @@
 #include <linux/timer.h>
 #include <linux/wait.h>
 #include <linux/workqueue.h>
+#include "md-cluster.h"
 
 #define MaxSector (~(sector_t)0)
 
@@ -575,6 +576,11 @@ static inline void safe_put_page(struct page *p)
 
 extern int register_md_personality(struct md_personality *p);
 extern int unregister_md_personality(struct md_personality *p);
+extern int register_md_cluster_operations(struct md_cluster_operations *ops,
+		struct module *module);
+extern int unregister_md_cluster_operations(void);
+extern int md_setup_cluster(struct mddev *mddev, int nodes);
+extern void md_cluster_stop(struct mddev *mddev);
 extern struct md_thread *md_register_thread(
 	void (*run)(struct md_thread *thread),
 	struct mddev *mddev,
@@ -627,4 +633,5 @@ static inline int mddev_check_plugged(struct mddev *mddev)
 	return !!blk_check_plugged(md_unplug, mddev,
 				   sizeof(struct blk_plug_cb));
 }
+extern struct md_cluster_operations *md_cluster_ops;
 #endif /* _MD_MD_H */
-- 
2.1.2

