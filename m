From: "Ahmed S. Darwish" <darwish.07@gmail.com>
Subject: [PATCH 2.6.20] drivers/md.c: Use ARRAY_SIZE macro when appropriate
Date: Tue, 6 Feb 2007 18:06:57 +0200
Message-ID: <20070206160657.GI8991@Ahmed>
References: <20070206160204.GA8991@Ahmed>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S932965AbXBFQHW@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20070206160204.GA8991@Ahmed>
Sender: linux-kernel-owner@vger.kernel.org
To: mingo@redhat.com
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all,

A patch to use ARRAY_SIZE macro already defined in kernel.h

Signed-off-by: Ahmed S. Darwish <darwish.07@gmail.com>
---
diff --git a/drivers/md/md.c b/drivers/md/md.c
index e8807ea..6f6d9e5 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -33,6 +33,7 @@
 */
 
 #include <linux/module.h>
+#include <linux/kernel.h>
 #include <linux/kthread.h>
 #include <linux/linkage.h>
 #include <linux/raid/md.h>
@@ -2635,8 +2636,7 @@ metadata_store(mddev_t *mddev, const char *buf, size_t len)
 	minor = simple_strtoul(buf, &e, 10);
 	if (e==buf || (*e && *e != '\n') )
 		return -EINVAL;
-	if (major >= sizeof(super_types)/sizeof(super_types[0]) ||
-	    super_types[major].name == NULL)
+	if (major >= ARRAY_SIZE(super_types) || super_types[major].name == NULL)
 		return -ENOENT;
 	mddev->major_version = major;
 	mddev->minor_version = minor;
@@ -3973,7 +3973,7 @@ static int set_array_info(mddev_t * mddev, mdu_array_info_t *info)
 	if (info->raid_disks == 0) {
 		/* just setting version number for superblock loading */
 		if (info->major_version < 0 ||
-		    info->major_version >= sizeof(super_types)/sizeof(super_types[0]) ||
+		    info->major_version >= ARRAY_SIZE(super_types) ||
 		    super_types[info->major_version].name == NULL) {
 			/* maybe try to auto-load a module? */
 			printk(KERN_INFO 


-- 
Ahmed S. Darwish
http://darwish-07.blogspot.com
