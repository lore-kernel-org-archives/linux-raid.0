From: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Subject: [PATCH v3 8/9] raid5-ppl: support disk hot add/remove with PPL
Date: Mon, 30 Jan 2017 19:59:52 +0100
Message-ID: <20170130185953.30428-9-artur.paszkiewicz@intel.com>
References: <20170130185953.30428-1-artur.paszkiewicz@intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170130185953.30428-1-artur.paszkiewicz@intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: shli@fb.com, neilb@suse.com, jes.sorensen@gmail.com, Artur Paszkiewicz <artur.paszkiewicz@intel.com>
List-Id: linux-raid.ids

Add a function to modify the log by removing an rdev when a drive fails
or adding when a spare/replacement is activated as a raid member.

Removing a disk just clears the child log rdev pointer. No new stripes
will be accepted for this child log in ppl_write_stripe() and running io
units will be processed without writing PPL to the device.

Adding a disk sets the child log rdev pointer and writes an empty PPL
header.

Signed-off-by: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
---
 drivers/md/raid5-cache.c |  8 ++++++++
 drivers/md/raid5-cache.h |  9 +++++++++
 drivers/md/raid5-ppl.c   | 48 ++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/md/raid5.c       | 15 +++++++++++++++
 4 files changed, 80 insertions(+)

diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index 7757c5137300..3031c3f720a9 100644
--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -2774,6 +2774,14 @@ void r5l_exit_log(struct r5l_log *log)
 	kfree(log);
 }
 
+int r5l_modify_log(struct r5l_log *log, struct md_rdev *rdev,
+		   enum r5l_modify_log_operation operation)
+{
+	if (log && log->policy->modify_log)
+		return log->policy->modify_log(log, rdev, operation);
+	return 0;
+}
+
 struct r5l_policy r5l_journal = {
 	.init_log = __r5l_init_log,
 	.exit_log = __r5l_exit_log,
diff --git a/drivers/md/raid5-cache.h b/drivers/md/raid5-cache.h
index 6b622c2742de..9e351708c247 100644
--- a/drivers/md/raid5-cache.h
+++ b/drivers/md/raid5-cache.h
@@ -138,9 +138,16 @@ enum r5l_io_unit_state {
 	IO_UNIT_STRIPE_END = 3,	/* stripes data finished writing to raid */
 };
 
+enum r5l_modify_log_operation {
+	R5L_MODIFY_LOG_DISK_REMOVE,
+	R5L_MODIFY_LOG_DISK_ADD,
+};
+
 struct r5l_policy {
 	int (*init_log)(struct r5l_log *log, struct r5conf *conf);
 	void (*exit_log)(struct r5l_log *log);
+	int (*modify_log)(struct r5l_log *log, struct md_rdev *rdev,
+			  enum r5l_modify_log_operation operation);
 	int (*write_stripe)(struct r5l_log *log, struct stripe_head *sh);
 	void (*write_stripe_run)(struct r5l_log *log);
 	void (*flush_stripe_to_raid)(struct r5l_log *log);
@@ -151,6 +158,8 @@ struct r5l_policy {
 
 extern int r5l_init_log(struct r5conf *conf, struct md_rdev *rdev);
 extern void r5l_exit_log(struct r5l_log *log);
+extern int r5l_modify_log(struct r5l_log *log, struct md_rdev *rdev,
+			  enum r5l_modify_log_operation operation);
 extern int r5l_write_stripe(struct r5l_log *log, struct stripe_head *sh);
 extern void r5l_write_stripe_run(struct r5l_log *log);
 extern void r5l_flush_stripe_to_raid(struct r5l_log *log);
diff --git a/drivers/md/raid5-ppl.c b/drivers/md/raid5-ppl.c
index b21b3bfa8f36..87e718f5b29f 100644
--- a/drivers/md/raid5-ppl.c
+++ b/drivers/md/raid5-ppl.c
@@ -291,6 +291,12 @@ static void ppl_submit_iounit(struct r5l_io_unit *io)
 
 	bio = bio_alloc_bioset(GFP_NOIO, BIO_MAX_PAGES, log->bs);
 	bio->bi_private = io;
+
+	if (!log->rdev || test_bit(Faulty, &log->rdev->flags)) {
+		ppl_log_endio(bio);
+		return;
+	}
+
 	bio->bi_end_io = ppl_log_endio;
 	bio->bi_opf = REQ_OP_WRITE | REQ_FUA;
 	bio->bi_bdev = log->rdev->bdev;
@@ -1008,6 +1014,47 @@ static int __ppl_init_log(struct r5l_log *log, struct r5conf *conf)
 	return ret;
 }
 
+static int __ppl_modify_log(struct r5l_log *log, struct md_rdev *rdev,
+			    enum r5l_modify_log_operation operation)
+{
+	struct r5l_log *log_child;
+	struct ppl_conf *ppl_conf = log->private;
+	int ret = 0;
+	char b[BDEVNAME_SIZE];
+
+	if (!rdev)
+		return -EINVAL;
+
+	pr_debug("%s: disk: %d operation: %s dev: %s\n",
+		 __func__, rdev->raid_disk,
+		 operation == R5L_MODIFY_LOG_DISK_REMOVE ? "remove" :
+		 (operation == R5L_MODIFY_LOG_DISK_ADD ? "add" : "?"),
+		 bdevname(rdev->bdev, b));
+
+	if (rdev->raid_disk < 0)
+		return 0;
+
+	if (rdev->raid_disk >= ppl_conf->count)
+		return -ENODEV;
+
+	log_child = &ppl_conf->child_logs[rdev->raid_disk];
+
+	mutex_lock(&log_child->io_mutex);
+	if (operation == R5L_MODIFY_LOG_DISK_REMOVE) {
+		log_child->rdev = NULL;
+	} else if (operation == R5L_MODIFY_LOG_DISK_ADD) {
+		log_child->rdev = rdev;
+		if (rdev->mddev->external)
+			log_child->uuid_checksum = log->uuid_checksum;
+		ret = ppl_write_empty_header(log_child);
+	} else {
+		ret = -EINVAL;
+	}
+	mutex_unlock(&log_child->io_mutex);
+
+	return ret;
+}
+
 static int __ppl_write_stripe(struct r5l_log *log, struct stripe_head *sh)
 {
 	struct ppl_conf *ppl_conf = log->private;
@@ -1027,6 +1074,7 @@ static void __ppl_write_stripe_run(struct r5l_log *log)
 struct r5l_policy r5l_ppl = {
 	.init_log = __ppl_init_log,
 	.exit_log = __ppl_exit_log,
+	.modify_log = __ppl_modify_log,
 	.write_stripe = __ppl_write_stripe,
 	.write_stripe_run = __ppl_write_stripe_run,
 	.flush_stripe_to_raid = NULL,
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index c015925710f5..a711bf940116 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -7576,6 +7576,12 @@ static int raid5_remove_disk(struct mddev *mddev, struct md_rdev *rdev)
 			*rdevp = rdev;
 		}
 	}
+	if (test_bit(MD_HAS_PPL, &mddev->flags)) {
+		err = r5l_modify_log(conf->log, rdev,
+				     R5L_MODIFY_LOG_DISK_REMOVE);
+		if (err)
+			goto abort;
+	}
 	if (p->replacement) {
 		/* We must have just cleared 'rdev' */
 		p->rdev = p->replacement;
@@ -7585,6 +7591,10 @@ static int raid5_remove_disk(struct mddev *mddev, struct md_rdev *rdev)
 			   */
 		p->replacement = NULL;
 		clear_bit(WantReplacement, &rdev->flags);
+
+		if (test_bit(MD_HAS_PPL, &mddev->flags))
+			err = r5l_modify_log(conf->log, p->rdev,
+					     R5L_MODIFY_LOG_DISK_ADD);
 	} else
 		/* We might have just removed the Replacement as faulty-
 		 * clear the bit just in case
@@ -7648,6 +7658,11 @@ static int raid5_add_disk(struct mddev *mddev, struct md_rdev *rdev)
 			if (rdev->saved_raid_disk != disk)
 				conf->fullsync = 1;
 			rcu_assign_pointer(p->rdev, rdev);
+
+			if (test_bit(MD_HAS_PPL, &mddev->flags))
+				err = r5l_modify_log(conf->log, rdev,
+						     R5L_MODIFY_LOG_DISK_ADD);
+
 			goto out;
 		}
 	}
-- 
2.11.0

