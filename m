From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 10/21] block: cleanup how md_autodetect_dev is called
Date: Thu, 12 Mar 2020 16:19:28 +0100
Message-ID: <20200312151939.645254-11-hch@lst.de>
References: <20200312151939.645254-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20200312151939.645254-1-hch@lst.de>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, linux-raid@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ext4@vger.kernel.org, reiserfs-devel@vger.kernel.org
List-Id: linux-raid.ids

Add a new include/linux/raid/detect.h header to declare the
md_autodetect_dev prototype which can be shared between md and
the partition code.  Then use IS_BUILTIN to call it instead of the
ifdef magic.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/partition-generic.c   | 11 ++++-------
 drivers/md/md.c             |  1 +
 include/linux/raid/detect.h |  3 +++
 3 files changed, 8 insertions(+), 7 deletions(-)
 create mode 100644 include/linux/raid/detect.h

diff --git a/block/partition-generic.c b/block/partition-generic.c
index abab0109b69c..febfb8e96abb 100644
--- a/block/partition-generic.c
+++ b/block/partition-generic.c
@@ -18,14 +18,11 @@
 #include <linux/ctype.h>
 #include <linux/genhd.h>
 #include <linux/blktrace_api.h>
+#include <linux/raid/detect.h>
 #include "blk.h"
 
 #include "partitions/check.h"
 
-#ifdef CONFIG_BLK_DEV_MD
-extern void md_autodetect_dev(dev_t dev);
-#endif
- 
 static ssize_t part_partition_show(struct device *dev,
 				   struct device_attribute *attr, char *buf)
 {
@@ -407,10 +404,10 @@ static bool blk_add_partition(struct gendisk *disk, struct block_device *bdev,
 		return true;
 	}
 
-#ifdef CONFIG_BLK_DEV_MD
-	if (state->parts[p].flags & ADDPART_FLAG_RAID)
+	if (IS_BUILTIN(CONFIG_BLK_DEV_MD) &&
+	    (state->parts[p].flags & ADDPART_FLAG_RAID))
 		md_autodetect_dev(part_to_dev(part)->devt);
-#endif
+
 	return true;
 }
 
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 11759f9e328e..dbbec0583e9d 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -58,6 +58,7 @@
 #include <linux/delay.h>
 #include <linux/raid/md_p.h>
 #include <linux/raid/md_u.h>
+#include <linux/raid/detect.h>
 #include <linux/slab.h>
 #include <linux/percpu-refcount.h>
 
diff --git a/include/linux/raid/detect.h b/include/linux/raid/detect.h
new file mode 100644
index 000000000000..37dd3f40cd31
--- /dev/null
+++ b/include/linux/raid/detect.h
@@ -0,0 +1,3 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+void md_autodetect_dev(dev_t dev);
-- 
2.24.1
