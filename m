From: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Subject: [PATCH v5 6/7] raid5-ppl: support disk hot add/remove with PPL
Date: Thu,  9 Mar 2017 10:00:02 +0100
Message-ID: <20170309090003.13298-7-artur.paszkiewicz@intel.com>
References: <20170309090003.13298-1-artur.paszkiewicz@intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170309090003.13298-1-artur.paszkiewicz@intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: shli@fb.com
Cc: linux-raid@vger.kernel.org, Artur Paszkiewicz <artur.paszkiewicz@intel.com>
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
 drivers/md/raid5-log.h |  9 +++++++++
 drivers/md/raid5-ppl.c | 45 ++++++++++++++++++++++++++++++++++++++++++++-
 drivers/md/raid5.c     | 12 +++++++++++-
 3 files changed, 64 insertions(+), 2 deletions(-)

diff --git a/drivers/md/raid5-log.h b/drivers/md/raid5-log.h
index a67fb58513b9..4f5a0f4e0b1f 100644
--- a/drivers/md/raid5-log.h
+++ b/drivers/md/raid5-log.h
@@ -39,6 +39,7 @@ extern void ppl_exit_log(struct r5conf *conf);
 extern int ppl_write_stripe(struct r5conf *conf, struct stripe_head *sh);
 extern void ppl_write_stripe_run(struct r5conf *conf);
 extern void ppl_stripe_write_finished(struct stripe_head *sh);
+extern int ppl_modify_log(struct r5conf *conf, struct md_rdev *rdev, bool add);
 
 static inline bool raid5_has_ppl(struct r5conf *conf)
 {
@@ -102,4 +103,12 @@ static inline int log_init(struct r5conf *conf, struct md_rdev *journal_dev)
 	return 0;
 }
 
+static inline int log_modify(struct r5conf *conf, struct md_rdev *rdev, bool add)
+{
+	if (raid5_has_ppl(conf))
+		return ppl_modify_log(conf, rdev, add);
+
+	return 0;
+}
+
 #endif
diff --git a/drivers/md/raid5-ppl.c b/drivers/md/raid5-ppl.c
index 548d1028a3ce..b5fcf55edee9 100644
--- a/drivers/md/raid5-ppl.c
+++ b/drivers/md/raid5-ppl.c
@@ -400,6 +400,13 @@ static void ppl_submit_iounit(struct ppl_io_unit *io)
 	struct stripe_head *sh;
 	int i;
 
+	bio->bi_private = io;
+
+	if (!log->rdev || test_bit(Faulty, &log->rdev->flags)) {
+		ppl_log_endio(bio);
+		return;
+	}
+
 	for (i = 0; i < io->entries_count; i++) {
 		struct ppl_header_entry *e = &pplhdr->entries[i];
 
@@ -415,7 +422,6 @@ static void ppl_submit_iounit(struct ppl_io_unit *io)
 	pplhdr->entries_count = cpu_to_le32(io->entries_count);
 	pplhdr->checksum = cpu_to_le32(~crc32c_le(~0, pplhdr, PPL_HEADER_SIZE));
 
-	bio->bi_private = io;
 	bio->bi_end_io = ppl_log_endio;
 	bio->bi_opf = REQ_OP_WRITE | REQ_FUA;
 	bio->bi_bdev = log->rdev->bdev;
@@ -1198,3 +1204,40 @@ int ppl_init_log(struct r5conf *conf)
 	__ppl_exit_log(ppl_conf);
 	return ret;
 }
+
+int ppl_modify_log(struct r5conf *conf, struct md_rdev *rdev, bool add)
+{
+	struct ppl_conf *ppl_conf = conf->log_private;
+	struct ppl_log *log;
+	int ret = 0;
+	char b[BDEVNAME_SIZE];
+
+	if (!rdev)
+		return -EINVAL;
+
+	pr_debug("%s: disk: %d operation: %s dev: %s\n",
+		 __func__, rdev->raid_disk, add ? "add" : "remove",
+		 bdevname(rdev->bdev, b));
+
+	if (rdev->raid_disk < 0)
+		return 0;
+
+	if (rdev->raid_disk >= ppl_conf->count)
+		return -ENODEV;
+
+	log = &ppl_conf->child_logs[rdev->raid_disk];
+
+	mutex_lock(&log->io_mutex);
+	if (add) {
+		ret = ppl_validate_rdev(rdev);
+		if (!ret) {
+			log->rdev = rdev;
+			ret = ppl_write_empty_header(log);
+		}
+	} else {
+		log->rdev = NULL;
+	}
+	mutex_unlock(&log->io_mutex);
+
+	return ret;
+}
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index f032af4d0421..8b8f172d6807 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -7527,6 +7527,11 @@ static int raid5_remove_disk(struct mddev *mddev, struct md_rdev *rdev)
 			*rdevp = rdev;
 		}
 	}
+	if (!err) {
+		err = log_modify(conf, rdev, false);
+		if (err)
+			goto abort;
+	}
 	if (p->replacement) {
 		/* We must have just cleared 'rdev' */
 		p->rdev = p->replacement;
@@ -7536,6 +7541,9 @@ static int raid5_remove_disk(struct mddev *mddev, struct md_rdev *rdev)
 			   */
 		p->replacement = NULL;
 		clear_bit(WantReplacement, &rdev->flags);
+
+		if (!err)
+			err = log_modify(conf, p->rdev, true);
 	} else
 		/* We might have just removed the Replacement as faulty-
 		 * clear the bit just in case
@@ -7592,10 +7600,12 @@ static int raid5_add_disk(struct mddev *mddev, struct md_rdev *rdev)
 		if (p->rdev == NULL) {
 			clear_bit(In_sync, &rdev->flags);
 			rdev->raid_disk = disk;
-			err = 0;
 			if (rdev->saved_raid_disk != disk)
 				conf->fullsync = 1;
 			rcu_assign_pointer(p->rdev, rdev);
+
+			err = log_modify(conf, rdev, true);
+
 			goto out;
 		}
 	}
-- 
2.11.0

