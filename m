From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Subject: [PATCH 03/24] Create a separate module for clustering support
Date: Thu, 18 Dec 2014 10:15:45 -0600
Message-ID: <20141218161545.GA29581@shrek.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: lzhong@suse.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
---
 drivers/md/Kconfig      | 15 +++++++++++++++
 drivers/md/Makefile     |  1 +
 drivers/md/md-cluster.c | 31 +++++++++++++++++++++++++++++++
 3 files changed, 47 insertions(+)
 create mode 100644 drivers/md/md-cluster.c

diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
index 95ad936..55ea703 100644
--- a/drivers/md/Kconfig
+++ b/drivers/md/Kconfig
@@ -174,6 +174,21 @@ config MD_FAULTY
 
 	  In unsure, say N.
 
+
+config MD_CLUSTER
+	tristate "Cluster Support for MD (EXPERIMENTAL)"
+	depends on BLK_DEV_MD
+	depends on DLM
+	---help---
+	Clustering support for MD devices. This enables locking and
+	synchronization across multiple systems on the cluster, so all
+	nodes in the cluster can access the MD devices simultaneously.
+
+	This brings the redundancy (and uptime) of RAID levels across the
+	nodes of the cluster.
+
+	If unsure, say N.
+
 source "drivers/md/bcache/Kconfig"
 
 config BLK_DEV_DM_BUILTIN
diff --git a/drivers/md/Makefile b/drivers/md/Makefile
index f26d832..a3d7bf6 100644
--- a/drivers/md/Makefile
+++ b/drivers/md/Makefile
@@ -29,6 +29,7 @@ obj-$(CONFIG_MD_RAID10)		+= raid10.o
 obj-$(CONFIG_MD_RAID456)	+= raid456.o
 obj-$(CONFIG_MD_MULTIPATH)	+= multipath.o
 obj-$(CONFIG_MD_FAULTY)		+= faulty.o
+obj-$(CONFIG_MD_CLUSTER)	+= md-cluster.o
 obj-$(CONFIG_BCACHE)		+= bcache/
 obj-$(CONFIG_BLK_DEV_MD)	+= md-mod.o
 obj-$(CONFIG_BLK_DEV_DM)	+= dm-mod.o
diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
new file mode 100644
index 0000000..6f21bba
--- /dev/null
+++ b/drivers/md/md-cluster.c
@@ -0,0 +1,31 @@
+/*
+ * Copyright (C) 2014, SUSE
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2, or (at your option)
+ * any later version.
+ *
+ * You should have received a copy of the GNU General Public License
+ * (for example /usr/src/linux/COPYING); if not, write to the Free
+ * Software Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+
+#include <linux/module.h>
+
+static int __init cluster_init(void)
+{
+	pr_info("Registering Cluster MD functions\n");
+	return 0;
+}
+
+static void cluster_exit(void)
+{
+}
+
+module_init(cluster_init);
+module_exit(cluster_exit);
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("Clustering support for MD");
+
-- 
2.1.2

