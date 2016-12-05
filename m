From: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Subject: [PATCH v2 03/12] raid5-cache: add a new policy
Date: Mon,  5 Dec 2016 16:31:04 +0100
Message-ID: <20161205153113.7268-4-artur.paszkiewicz@intel.com>
References: <20161205153113.7268-1-artur.paszkiewicz@intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20161205153113.7268-1-artur.paszkiewicz@intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: shli@kernel.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Add a source file for the new policy implementation and allow selecting
the policy based on the policy_type parameter in r5l_init_log().

Introduce a new flag for rdev state flags to allow enabling the new
policy from userspace.

Signed-off-by: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
---
 drivers/md/Makefile      |  2 +-
 drivers/md/md.c          |  5 +++++
 drivers/md/md.h          |  3 +++
 drivers/md/raid5-cache.c | 17 +++++++++++++++--
 drivers/md/raid5-cache.h |  9 ++++++++-
 drivers/md/raid5-ppl.c   | 20 ++++++++++++++++++++
 drivers/md/raid5.c       | 42 ++++++++++++++++++++++++++++++++++++------
 7 files changed, 88 insertions(+), 10 deletions(-)
 create mode 100644 drivers/md/raid5-ppl.c

diff --git a/drivers/md/Makefile b/drivers/md/Makefile
index 3cbda1a..4d48714 100644
--- a/drivers/md/Makefile
+++ b/drivers/md/Makefile
@@ -18,7 +18,7 @@ dm-cache-cleaner-y += dm-cache-policy-cleaner.o
 dm-era-y	+= dm-era-target.o
 dm-verity-y	+= dm-verity-target.o
 md-mod-y	+= md.o bitmap.o
-raid456-y	+= raid5.o raid5-cache.o
+raid456-y	+= raid5.o raid5-cache.o raid5-ppl.o
 
 # Note: link order is important.  All raid personalities
 # and must come before md.o, as they each initialise 
diff --git a/drivers/md/md.c b/drivers/md/md.c
index c7894fb..4876687 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -2575,6 +2575,8 @@ state_show(struct md_rdev *rdev, char *page)
 		len += sprintf(page+len, "journal%s", sep);
 	if (test_bit(WriteMostly, &flags))
 		len += sprintf(page+len, "write_mostly%s", sep);
+	if (test_bit(JournalPpl, &flags))
+		len += sprintf(page+len, "journal_ppl%s", sep);
 	if (test_bit(Blocked, &flags) ||
 	    (rdev->badblocks.unacked_exist
 	     && !test_bit(Faulty, &flags)))
@@ -2753,6 +2755,9 @@ state_store(struct md_rdev *rdev, const char *buf, size_t len)
 	} else if (cmd_match(buf, "-external_bbl") && (rdev->mddev->external)) {
 		clear_bit(ExternalBbl, &rdev->flags);
 		err = 0;
+	} else if (cmd_match(buf, "journal_ppl")) {
+		set_bit(JournalPpl, &rdev->flags);
+		err = 0;
 	}
 	if (!err)
 		sysfs_notify_dirent_safe(rdev->sysfs_state);
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 5c08f84..2fc75ac 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -172,6 +172,9 @@ enum flag_bits {
 				 * Usually, this device should be faster
 				 * than other devices in the array
 				 */
+	JournalPpl,		/* This device is used for raid5
+				 * Partial Parity Log.
+				 */
 	ClusterRemove,
 	RemoveSynchronized,	/* synchronize_rcu() was called after
 				 * this device was known to be faulty,
diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index 74a0eda..fa82b9a 100644
--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -2556,16 +2556,29 @@ struct r5l_policy r5l_journal = {
 	.handle_flush_request = __r5l_handle_flush_request,
 	.quiesce = __r5l_quiesce,
 };
+extern struct r5l_policy r5l_ppl;
 
-int r5l_init_log(struct r5conf *conf, struct md_rdev *rdev)
+int r5l_init_log(struct r5conf *conf, struct md_rdev *rdev, int policy_type)
 {
 	int ret;
 	struct r5l_log *log = kzalloc(sizeof(*log), GFP_KERNEL);
 	if (!log)
 		return -ENOMEM;
 
+	switch (policy_type) {
+	case RWH_POLICY_JOURNAL:
+		log->policy = &r5l_journal;
+		break;
+	case RWH_POLICY_PPL:
+		log->policy = &r5l_ppl;
+		break;
+	default:
+		kfree(log);
+		return -EINVAL;
+	}
+
 	log->rdev = rdev;
-	log->policy = &r5l_journal;
+	log->rwh_policy = policy_type;
 
 	ret = log->policy->init_log(log, conf);
 	if (ret)
diff --git a/drivers/md/raid5-cache.h b/drivers/md/raid5-cache.h
index 52cfef4..4ba11d3 100644
--- a/drivers/md/raid5-cache.h
+++ b/drivers/md/raid5-cache.h
@@ -80,6 +80,13 @@ struct r5l_log {
 	struct work_struct deferred_io_work;
 
 	struct r5l_policy *policy;
+	enum {
+		RWH_POLICY_OFF,
+		RWH_POLICY_JOURNAL,
+		RWH_POLICY_PPL,
+	} rwh_policy;
+
+	void *private;
 };
 
 /*
@@ -140,7 +147,7 @@ struct r5l_policy {
 	void (*quiesce)(struct r5l_log *log, int state);
 };
 
-extern int r5l_init_log(struct r5conf *conf, struct md_rdev *rdev);
+extern int r5l_init_log(struct r5conf *conf, struct md_rdev *rdev, int policy_type);
 extern void r5l_exit_log(struct r5l_log *log);
 extern int r5l_write_stripe(struct r5l_log *log, struct stripe_head *sh);
 extern void r5l_write_stripe_run(struct r5l_log *log);
diff --git a/drivers/md/raid5-ppl.c b/drivers/md/raid5-ppl.c
new file mode 100644
index 0000000..263fad7
--- /dev/null
+++ b/drivers/md/raid5-ppl.c
@@ -0,0 +1,20 @@
+/*
+ * Partial Parity Log for closing the RAID5 write hole
+ * Copyright (c) 2016, Intel Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ */
+
+#include <linux/kernel.h>
+#include <linux/blkdev.h>
+#include "raid5.h"
+#include "raid5-cache.h"
+
+struct r5l_policy r5l_ppl;
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index fe8c1a7..9f07769 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -6833,8 +6833,10 @@ static int raid5_run(struct mddev *mddev)
 	struct r5conf *conf;
 	int working_disks = 0;
 	int dirty_parity_disks = 0;
+	int ppl_disks = 0;
 	struct md_rdev *rdev;
 	struct md_rdev *journal_dev = NULL;
+	int rwh_policy = RWH_POLICY_OFF;
 	sector_t reshape_offset = 0;
 	int i;
 	long long min_offset_diff = 0;
@@ -6847,6 +6849,10 @@ static int raid5_run(struct mddev *mddev)
 	rdev_for_each(rdev, mddev) {
 		long long diff;
 
+		if (test_bit(JournalPpl, &rdev->flags) &&
+		    test_bit(In_sync, &rdev->flags))
+			ppl_disks++;
+
 		if (test_bit(Journal, &rdev->flags)) {
 			journal_dev = rdev;
 			continue;
@@ -7037,6 +7043,22 @@ static int raid5_run(struct mddev *mddev)
 		goto abort;
 	}
 
+	if (ppl_disks) {
+		if (ppl_disks != working_disks) {
+			pr_err("md/raid:%s: distributed PPL must be enabled on all member devices - aborting\n",
+			       mdname(mddev));
+			goto abort;
+		}
+		rwh_policy = RWH_POLICY_PPL;
+	}
+
+	if (journal_dev) {
+		if (ppl_disks)
+			pr_warn("md/raid:%s: using journal device and PPL not allowed - ignoring PPL\n",
+				mdname(mddev));
+		rwh_policy = RWH_POLICY_JOURNAL;
+	}
+
 	/* device size must be a multiple of chunk size */
 	mddev->dev_sectors &= ~(mddev->chunk_sectors - 1);
 	mddev->resync_max_sectors = mddev->dev_sectors;
@@ -7171,12 +7193,17 @@ static int raid5_run(struct mddev *mddev)
 		blk_queue_max_hw_sectors(mddev->queue, UINT_MAX);
 	}
 
-	if (journal_dev) {
-		char b[BDEVNAME_SIZE];
+	if (rwh_policy) {
+		if (journal_dev) {
+			char b[BDEVNAME_SIZE];
 
-		pr_debug("md/raid:%s: using device %s as journal\n",
-			 mdname(mddev), bdevname(journal_dev->bdev, b));
-		if (r5l_init_log(conf, journal_dev))
+			pr_debug("md/raid:%s: using device %s as journal\n",
+				 mdname(mddev), bdevname(journal_dev->bdev, b));
+		} else if (rwh_policy == RWH_POLICY_PPL) {
+			pr_debug("md/raid:%s: enabling distributed PPL journal\n",
+				 mdname(mddev));
+		}
+		if (r5l_init_log(conf, journal_dev, rwh_policy))
 			goto abort;
 	}
 
@@ -7372,6 +7399,7 @@ static int raid5_add_disk(struct mddev *mddev, struct md_rdev *rdev)
 
 	if (test_bit(Journal, &rdev->flags)) {
 		char b[BDEVNAME_SIZE];
+		int ret;
 		if (conf->log)
 			return -EBUSY;
 
@@ -7380,7 +7408,9 @@ static int raid5_add_disk(struct mddev *mddev, struct md_rdev *rdev)
 		 * The array is in readonly mode if journal is missing, so no
 		 * write requests running. We should be safe
 		 */
-		r5l_init_log(conf, rdev);
+		ret = r5l_init_log(conf, rdev, RWH_POLICY_JOURNAL);
+		if (ret)
+			return ret;
 		pr_debug("md/raid:%s: using device %s as journal\n",
 			 mdname(mddev), bdevname(rdev->bdev, b));
 		return 0;
-- 
2.10.1

