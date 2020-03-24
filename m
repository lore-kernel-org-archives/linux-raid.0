From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 21/21] block: merge partition-generic.c and check.c
Date: Tue, 24 Mar 2020 08:25:30 +0100
Message-ID: <20200324072530.544483-22-hch@lst.de>
References: <20200324072530.544483-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <reiserfs-devel-owner@vger.kernel.org>
In-Reply-To: <20200324072530.544483-1-hch@lst.de>
Sender: reiserfs-devel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, linux-raid@vger.kernel.org, linux-scsi@vger.kernel.org, reiserfs-devel@vger.kernel.org
List-Id: linux-raid.ids

Merge block/partition-generic.c and block/partitions/check.c into
a single block/partitions/core.c as the content is closely related
and both files are tiny.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/Makefile                                |   3 +-
 block/partitions/Makefile                     |   3 +-
 block/partitions/check.c                      | 179 ------------------
 block/partitions/check.h                      |   5 -
 .../core.c}                                   | 178 +++++++++++++++--
 5 files changed, 166 insertions(+), 202 deletions(-)
 delete mode 100644 block/partitions/check.c
 rename block/{partition-generic.c => partitions/core.c} (77%)

diff --git a/block/Makefile b/block/Makefile
index 1a43750f4b01..206b96e9387f 100644
--- a/block/Makefile
+++ b/block/Makefile
@@ -8,8 +8,7 @@ obj-$(CONFIG_BLOCK) := bio.o elevator.o blk-core.o blk-sysfs.o \
 			blk-exec.o blk-merge.o blk-softirq.o blk-timeout.o \
 			blk-lib.o blk-mq.o blk-mq-tag.o blk-stat.o \
 			blk-mq-sysfs.o blk-mq-cpumap.o blk-mq-sched.o ioctl.o \
-			genhd.o partition-generic.o ioprio.o \
-			badblocks.o partitions/ blk-rq-qos.o
+			genhd.o ioprio.o badblocks.o partitions/ blk-rq-qos.o
 
 obj-$(CONFIG_BOUNCE)		+= bounce.o
 obj-$(CONFIG_BLK_SCSI_REQUEST)	+= scsi_ioctl.o
diff --git a/block/partitions/Makefile b/block/partitions/Makefile
index 2f276b677c81..a7f05cdb02a8 100644
--- a/block/partitions/Makefile
+++ b/block/partitions/Makefile
@@ -3,8 +3,7 @@
 # Makefile for the linux kernel.
 #
 
-obj-$(CONFIG_BLOCK) := check.o
-
+obj-$(CONFIG_BLOCK) += core.o
 obj-$(CONFIG_ACORN_PARTITION) += acorn.o
 obj-$(CONFIG_AMIGA_PARTITION) += amiga.o
 obj-$(CONFIG_ATARI_PARTITION) += atari.o
diff --git a/block/partitions/check.c b/block/partitions/check.c
deleted file mode 100644
index 944c478b6f0b..000000000000
--- a/block/partitions/check.c
+++ /dev/null
@@ -1,179 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
-/*
- *  fs/partitions/check.c
- *
- *  Code extracted from drivers/block/genhd.c
- *  Copyright (C) 1991-1998  Linus Torvalds
- *  Re-organised Feb 1998 Russell King
- *
- *  We now have independent partition support from the
- *  block drivers, which allows all the partition code to
- *  be grouped in one location, and it to be mostly self
- *  contained.
- *
- *  Added needed MAJORS for new pairs, {hdi,hdj}, {hdk,hdl}
- */
-
-#include <linux/slab.h>
-#include <linux/vmalloc.h>
-#include <linux/ctype.h>
-#include <linux/genhd.h>
-
-#include "check.h"
-
-static int (*check_part[])(struct parsed_partitions *) = {
-	/*
-	 * Probe partition formats with tables at disk address 0
-	 * that also have an ADFS boot block at 0xdc0.
-	 */
-#ifdef CONFIG_ACORN_PARTITION_ICS
-	adfspart_check_ICS,
-#endif
-#ifdef CONFIG_ACORN_PARTITION_POWERTEC
-	adfspart_check_POWERTEC,
-#endif
-#ifdef CONFIG_ACORN_PARTITION_EESOX
-	adfspart_check_EESOX,
-#endif
-
-	/*
-	 * Now move on to formats that only have partition info at
-	 * disk address 0xdc0.  Since these may also have stale
-	 * PC/BIOS partition tables, they need to come before
-	 * the msdos entry.
-	 */
-#ifdef CONFIG_ACORN_PARTITION_CUMANA
-	adfspart_check_CUMANA,
-#endif
-#ifdef CONFIG_ACORN_PARTITION_ADFS
-	adfspart_check_ADFS,
-#endif
-
-#ifdef CONFIG_CMDLINE_PARTITION
-	cmdline_partition,
-#endif
-#ifdef CONFIG_EFI_PARTITION
-	efi_partition,		/* this must come before msdos */
-#endif
-#ifdef CONFIG_SGI_PARTITION
-	sgi_partition,
-#endif
-#ifdef CONFIG_LDM_PARTITION
-	ldm_partition,		/* this must come before msdos */
-#endif
-#ifdef CONFIG_MSDOS_PARTITION
-	msdos_partition,
-#endif
-#ifdef CONFIG_OSF_PARTITION
-	osf_partition,
-#endif
-#ifdef CONFIG_SUN_PARTITION
-	sun_partition,
-#endif
-#ifdef CONFIG_AMIGA_PARTITION
-	amiga_partition,
-#endif
-#ifdef CONFIG_ATARI_PARTITION
-	atari_partition,
-#endif
-#ifdef CONFIG_MAC_PARTITION
-	mac_partition,
-#endif
-#ifdef CONFIG_ULTRIX_PARTITION
-	ultrix_partition,
-#endif
-#ifdef CONFIG_IBM_PARTITION
-	ibm_partition,
-#endif
-#ifdef CONFIG_KARMA_PARTITION
-	karma_partition,
-#endif
-#ifdef CONFIG_SYSV68_PARTITION
-	sysv68_partition,
-#endif
-	NULL
-};
-
-static struct parsed_partitions *allocate_partitions(struct gendisk *hd)
-{
-	struct parsed_partitions *state;
-	int nr;
-
-	state = kzalloc(sizeof(*state), GFP_KERNEL);
-	if (!state)
-		return NULL;
-
-	nr = disk_max_parts(hd);
-	state->parts = vzalloc(array_size(nr, sizeof(state->parts[0])));
-	if (!state->parts) {
-		kfree(state);
-		return NULL;
-	}
-
-	state->limit = nr;
-
-	return state;
-}
-
-void free_partitions(struct parsed_partitions *state)
-{
-	vfree(state->parts);
-	kfree(state);
-}
-
-struct parsed_partitions *
-check_partition(struct gendisk *hd, struct block_device *bdev)
-{
-	struct parsed_partitions *state;
-	int i, res, err;
-
-	state = allocate_partitions(hd);
-	if (!state)
-		return NULL;
-	state->pp_buf = (char *)__get_free_page(GFP_KERNEL);
-	if (!state->pp_buf) {
-		free_partitions(state);
-		return NULL;
-	}
-	state->pp_buf[0] = '\0';
-
-	state->bdev = bdev;
-	disk_name(hd, 0, state->name);
-	snprintf(state->pp_buf, PAGE_SIZE, " %s:", state->name);
-	if (isdigit(state->name[strlen(state->name)-1]))
-		sprintf(state->name, "p");
-
-	i = res = err = 0;
-	while (!res && check_part[i]) {
-		memset(state->parts, 0, state->limit * sizeof(state->parts[0]));
-		res = check_part[i++](state);
-		if (res < 0) {
-			/* We have hit an I/O error which we don't report now.
-		 	* But record it, and let the others do their job.
-		 	*/
-			err = res;
-			res = 0;
-		}
-
-	}
-	if (res > 0) {
-		printk(KERN_INFO "%s", state->pp_buf);
-
-		free_page((unsigned long)state->pp_buf);
-		return state;
-	}
-	if (state->access_beyond_eod)
-		err = -ENOSPC;
-	if (err)
-	/* The partition is unrecognized. So report I/O errors if there were any */
-		res = err;
-	if (res) {
-		strlcat(state->pp_buf,
-			" unable to read partition table\n", PAGE_SIZE);
-		printk(KERN_INFO "%s", state->pp_buf);
-	}
-
-	free_page((unsigned long)state->pp_buf);
-	free_partitions(state);
-	return ERR_PTR(res);
-}
diff --git a/block/partitions/check.h b/block/partitions/check.h
index 23e7adb79617..f845355489ec 100644
--- a/block/partitions/check.h
+++ b/block/partitions/check.h
@@ -23,11 +23,6 @@ struct parsed_partitions {
 	char *pp_buf;
 };
 
-void free_partitions(struct parsed_partitions *state);
-
-struct parsed_partitions *
-check_partition(struct gendisk *, struct block_device *);
-
 typedef struct {
 	struct page *v;
 } Sector;
diff --git a/block/partition-generic.c b/block/partitions/core.c
similarity index 77%
rename from block/partition-generic.c
rename to block/partitions/core.c
index 4d771ae835ed..b442bc209b86 100644
--- a/block/partition-generic.c
+++ b/block/partitions/core.c
@@ -1,27 +1,177 @@
 // SPDX-License-Identifier: GPL-2.0
 /*
- *  Code extracted from drivers/block/genhd.c
- *  Copyright (C) 1991-1998  Linus Torvalds
- *  Re-organised Feb 1998 Russell King
- *
- *  We now have independent partition support from the
- *  block drivers, which allows all the partition code to
- *  be grouped in one location, and it to be mostly self
- *  contained.
+ * Copyright (C) 1991-1998  Linus Torvalds
+ * Re-organised Feb 1998 Russell King
  */
-
-#include <linux/init.h>
-#include <linux/module.h>
 #include <linux/fs.h>
 #include <linux/slab.h>
-#include <linux/kmod.h>
 #include <linux/ctype.h>
 #include <linux/genhd.h>
+#include <linux/vmalloc.h>
 #include <linux/blktrace_api.h>
 #include <linux/raid/detect.h>
-#include "blk.h"
+#include "../blk.h"
+#include "check.h"
+
+static int (*check_part[])(struct parsed_partitions *) = {
+	/*
+	 * Probe partition formats with tables at disk address 0
+	 * that also have an ADFS boot block at 0xdc0.
+	 */
+#ifdef CONFIG_ACORN_PARTITION_ICS
+	adfspart_check_ICS,
+#endif
+#ifdef CONFIG_ACORN_PARTITION_POWERTEC
+	adfspart_check_POWERTEC,
+#endif
+#ifdef CONFIG_ACORN_PARTITION_EESOX
+	adfspart_check_EESOX,
+#endif
+
+	/*
+	 * Now move on to formats that only have partition info at
+	 * disk address 0xdc0.  Since these may also have stale
+	 * PC/BIOS partition tables, they need to come before
+	 * the msdos entry.
+	 */
+#ifdef CONFIG_ACORN_PARTITION_CUMANA
+	adfspart_check_CUMANA,
+#endif
+#ifdef CONFIG_ACORN_PARTITION_ADFS
+	adfspart_check_ADFS,
+#endif
+
+#ifdef CONFIG_CMDLINE_PARTITION
+	cmdline_partition,
+#endif
+#ifdef CONFIG_EFI_PARTITION
+	efi_partition,		/* this must come before msdos */
+#endif
+#ifdef CONFIG_SGI_PARTITION
+	sgi_partition,
+#endif
+#ifdef CONFIG_LDM_PARTITION
+	ldm_partition,		/* this must come before msdos */
+#endif
+#ifdef CONFIG_MSDOS_PARTITION
+	msdos_partition,
+#endif
+#ifdef CONFIG_OSF_PARTITION
+	osf_partition,
+#endif
+#ifdef CONFIG_SUN_PARTITION
+	sun_partition,
+#endif
+#ifdef CONFIG_AMIGA_PARTITION
+	amiga_partition,
+#endif
+#ifdef CONFIG_ATARI_PARTITION
+	atari_partition,
+#endif
+#ifdef CONFIG_MAC_PARTITION
+	mac_partition,
+#endif
+#ifdef CONFIG_ULTRIX_PARTITION
+	ultrix_partition,
+#endif
+#ifdef CONFIG_IBM_PARTITION
+	ibm_partition,
+#endif
+#ifdef CONFIG_KARMA_PARTITION
+	karma_partition,
+#endif
+#ifdef CONFIG_SYSV68_PARTITION
+	sysv68_partition,
+#endif
+	NULL
+};
+
+static struct parsed_partitions *allocate_partitions(struct gendisk *hd)
+{
+	struct parsed_partitions *state;
+	int nr;
 
-#include "partitions/check.h"
+	state = kzalloc(sizeof(*state), GFP_KERNEL);
+	if (!state)
+		return NULL;
+
+	nr = disk_max_parts(hd);
+	state->parts = vzalloc(array_size(nr, sizeof(state->parts[0])));
+	if (!state->parts) {
+		kfree(state);
+		return NULL;
+	}
+
+	state->limit = nr;
+
+	return state;
+}
+
+static void free_partitions(struct parsed_partitions *state)
+{
+	vfree(state->parts);
+	kfree(state);
+}
+
+static struct parsed_partitions *check_partition(struct gendisk *hd,
+		struct block_device *bdev)
+{
+	struct parsed_partitions *state;
+	int i, res, err;
+
+	state = allocate_partitions(hd);
+	if (!state)
+		return NULL;
+	state->pp_buf = (char *)__get_free_page(GFP_KERNEL);
+	if (!state->pp_buf) {
+		free_partitions(state);
+		return NULL;
+	}
+	state->pp_buf[0] = '\0';
+
+	state->bdev = bdev;
+	disk_name(hd, 0, state->name);
+	snprintf(state->pp_buf, PAGE_SIZE, " %s:", state->name);
+	if (isdigit(state->name[strlen(state->name)-1]))
+		sprintf(state->name, "p");
+
+	i = res = err = 0;
+	while (!res && check_part[i]) {
+		memset(state->parts, 0, state->limit * sizeof(state->parts[0]));
+		res = check_part[i++](state);
+		if (res < 0) {
+			/*
+			 * We have hit an I/O error which we don't report now.
+			 * But record it, and let the others do their job.
+			 */
+			err = res;
+			res = 0;
+		}
+
+	}
+	if (res > 0) {
+		printk(KERN_INFO "%s", state->pp_buf);
+
+		free_page((unsigned long)state->pp_buf);
+		return state;
+	}
+	if (state->access_beyond_eod)
+		err = -ENOSPC;
+	/*
+	 * The partition is unrecognized. So report I/O errors if there were any
+	 */
+	if (err)
+		res = err;
+	if (res) {
+		strlcat(state->pp_buf,
+			" unable to read partition table\n", PAGE_SIZE);
+		printk(KERN_INFO "%s", state->pp_buf);
+	}
+
+	free_page((unsigned long)state->pp_buf);
+	free_partitions(state);
+	return ERR_PTR(res);
+}
 
 static ssize_t part_partition_show(struct device *dev,
 				   struct device_attribute *attr, char *buf)
-- 
2.25.1
