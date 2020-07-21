From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 06/24] md: open code vfs_stat in md_setup_drive
Date: Tue, 21 Jul 2020 18:28:00 +0200
Message-ID: <20200721162818.197315-7-hch@lst.de>
References: <20200721162818.197315-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20200721162818.197315-1-hch@lst.de>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Al Viro <viro@zeniv.linux.org.uk>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Rafael J. Wysocki" <rafael@kernel.org>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-raid.ids

Instead of passing a kernel pointer to vfs_stat by relying on the
implicit set_fs(KERNEL_DS) in md_setup_drive, just open code the
trivial getattr, and use the opportunity to move a little bit more
code from the caller into the new helper.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/md-autodetect.c | 29 ++++++++++++++++++++---------
 1 file changed, 20 insertions(+), 9 deletions(-)

diff --git a/drivers/md/md-autodetect.c b/drivers/md/md-autodetect.c
index 14b6e86814c061..1e8f1df257a112 100644
--- a/drivers/md/md-autodetect.c
+++ b/drivers/md/md-autodetect.c
@@ -8,6 +8,7 @@
 #include <linux/raid/detect.h>
 #include <linux/raid/md_u.h>
 #include <linux/raid/md_p.h>
+#include <linux/namei.h>
 #include "md.h"
 
 /*
@@ -119,6 +120,23 @@ static int __init md_setup(char *str)
 	return 1;
 }
 
+static void __init md_lookup_dev(const char *devname, dev_t *dev)
+{
+	struct kstat stat;
+	struct path path;
+	char filename[64];
+
+	if (strncmp(devname, "/dev/", 5) == 0)
+		devname += 5;
+	snprintf(filename, 63, "/dev/%s", devname);
+
+	if (!kern_path(filename, LOOKUP_FOLLOW, &path) &&
+	    !vfs_getattr(&path, &stat, STATX_BASIC_STATS, AT_NO_AUTOMOUNT) &&
+	    S_ISBLK(stat.mode))
+		*dev = new_decode_dev(stat.rdev);
+	path_put(&path);
+}
+
 static void __init md_setup_drive(struct md_setup_args *args)
 {
 	char *devname = args->device_names;
@@ -138,21 +156,14 @@ static void __init md_setup_drive(struct md_setup_args *args)
 	}
 
 	for (i = 0; i < MD_SB_DISKS && devname != NULL; i++) {
-		struct kstat stat;
-		char *p;
-		char comp_name[64];
 		dev_t dev;
+		char *p;
 
 		p = strchr(devname, ',');
 		if (p)
 			*p++ = 0;
-
 		dev = name_to_dev_t(devname);
-		if (strncmp(devname, "/dev/", 5) == 0)
-			devname += 5;
-		snprintf(comp_name, 63, "/dev/%s", devname);
-		if (vfs_stat(comp_name, &stat) == 0 && S_ISBLK(stat.mode))
-			dev = new_decode_dev(stat.rdev);
+		md_lookup_dev(devname, &dev);
 		if (!dev) {
 			pr_warn("md: Unknown device name: %s\n", devname);
 			break;
-- 
2.27.0
