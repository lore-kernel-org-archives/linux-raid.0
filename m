From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 03/17] md: replace the RAID_AUTORUN ioctl with a direct function call
Date: Thu,  9 Jul 2020 17:18:00 +0200
Message-ID: <20200709151814.110422-4-hch@lst.de>
References: <20200709151814.110422-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20200709151814.110422-1-hch@lst.de>
Sender: linux-raid-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>, Song Liu <song@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, Linus Torvalds <torvalds@linux-foundation.org>, linux-raid@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-Id: linux-raid.ids

Instead of using a spcial RAID_AUTORUN ioctl that only exists for
non-modular builds and is only called from the early init code, just
call the actual function directly.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/md-autodetect.c | 10 ++--------
 drivers/md/md.c            | 14 +-------------
 drivers/md/md.h            |  3 +++
 3 files changed, 6 insertions(+), 21 deletions(-)

diff --git a/drivers/md/md-autodetect.c b/drivers/md/md-autodetect.c
index fe806f7b9759a1..0eb746211ed53c 100644
--- a/drivers/md/md-autodetect.c
+++ b/drivers/md/md-autodetect.c
@@ -9,6 +9,7 @@
 #include <linux/raid/detect.h>
 #include <linux/raid/md_u.h>
 #include <linux/raid/md_p.h>
+#include "md.h"
 
 /*
  * When md (and any require personalities) are compiled into the kernel
@@ -285,8 +286,6 @@ __setup("md=", md_setup);
 
 static void __init autodetect_raid(void)
 {
-	int fd;
-
 	/*
 	 * Since we don't want to detect and use half a raid array, we need to
 	 * wait for the known devices to complete their probing
@@ -295,12 +294,7 @@ static void __init autodetect_raid(void)
 	printk(KERN_INFO "md: If you don't use raid, use raid=noautodetect\n");
 
 	wait_for_device_probe();
-
-	fd = ksys_open("/dev/md0", 0, 0);
-	if (fd >= 0) {
-		ksys_ioctl(fd, RAID_AUTORUN, raid_autopart);
-		ksys_close(fd);
-	}
+	md_autostart_arrays(raid_autopart);
 }
 
 void __init md_run_setup(void)
diff --git a/drivers/md/md.c b/drivers/md/md.c
index f567f536b529bd..6e9a48da474848 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -68,10 +68,6 @@
 #include "md-bitmap.h"
 #include "md-cluster.h"
 
-#ifndef MODULE
-static void autostart_arrays(int part);
-#endif
-
 /* pers_list is a list of registered personalities protected
  * by pers_lock.
  * pers_lock does extra service to protect accesses to
@@ -7421,7 +7417,6 @@ static inline bool md_ioctl_valid(unsigned int cmd)
 	case GET_DISK_INFO:
 	case HOT_ADD_DISK:
 	case HOT_REMOVE_DISK:
-	case RAID_AUTORUN:
 	case RAID_VERSION:
 	case RESTART_ARRAY_RW:
 	case RUN_ARRAY:
@@ -7467,13 +7462,6 @@ static int md_ioctl(struct block_device *bdev, fmode_t mode,
 	case RAID_VERSION:
 		err = get_version(argp);
 		goto out;
-
-#ifndef MODULE
-	case RAID_AUTORUN:
-		err = 0;
-		autostart_arrays(arg);
-		goto out;
-#endif
 	default:;
 	}
 
@@ -9721,7 +9709,7 @@ void md_autodetect_dev(dev_t dev)
 	}
 }
 
-static void autostart_arrays(int part)
+void md_autostart_arrays(int part)
 {
 	struct md_rdev *rdev;
 	struct detected_devices_node *node_detected_dev;
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 612814d07d35ab..37315a3f28e97d 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -800,4 +800,7 @@ static inline void mddev_check_write_zeroes(struct mddev *mddev, struct bio *bio
 	    !bio->bi_disk->queue->limits.max_write_zeroes_sectors)
 		mddev->queue->limits.max_write_zeroes_sectors = 0;
 }
+
+void md_autostart_arrays(int part);
+
 #endif /* _MD_MD_H */
-- 
2.26.2
