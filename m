From: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Subject: [PATCH 11/12] raid5-ppl: support disk add/remove with distributed PPL
Date: Thu, 24 Nov 2016 13:28:46 +0100
Message-ID: <20161124122847.16456-12-artur.paszkiewicz@intel.com>
References: <20161124122847.16456-1-artur.paszkiewicz@intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20161124122847.16456-1-artur.paszkiewicz@intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: shli@kernel.org
Cc: linux-raid@vger.kernel.org, Artur Paszkiewicz <artur.paszkiewicz@intel.com>
List-Id: linux-raid.ids

Add a function to modify the log by adding or removing an rdev when a
drive fails or is added as a spare.

Adding a drive to the log is as simple as initializing and adding a new
child log, removing a drive is more complicated because it requires
stopping the child log and freeing all of its resources. In order to do
that, we busy wait for any submitted log bios to complete and then
manually finish and free the io_units. No new log requests will happen
at this point. A new list is added to struct r5l_io_unit to have access
to stripes that have been written to the log but are not completely
processed yet.

Signed-off-by: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
---
 drivers/md/md.c          |  3 +-
 drivers/md/raid5-cache.c | 13 ++++++-
 drivers/md/raid5-cache.h |  3 ++
 drivers/md/raid5-ppl.c   | 89 ++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/md/raid5.c       | 20 +++++++++++
 5 files changed, 126 insertions(+), 2 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 7049833..279e303 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -8334,7 +8334,8 @@ static int remove_and_add_spares(struct mddev *mddev,
 		    !test_bit(Blocked, &rdev->flags) &&
 		    ((test_bit(RemoveSynchronized, &rdev->flags) ||
 		     (!test_bit(In_sync, &rdev->flags) &&
-		      !test_bit(Journal, &rdev->flags))) &&
+		      !test_bit(Journal, &rdev->flags) &&
+		      !test_bit(JournalPpl, &rdev->flags))) &&
 		    atomic_read(&rdev->nr_pending)==0)) {
 			if (mddev->pers->hot_remove_disk(
 				    mddev, rdev) == 0) {
diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index cb764db..fbd8148 100644
--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -345,7 +345,7 @@ void r5l_io_run_stripes(struct r5l_io_unit *io)
 	struct stripe_head *sh, *next;
 
 	list_for_each_entry_safe(sh, next, &io->stripe_list, log_list) {
-		list_del_init(&sh->log_list);
+		list_move_tail(&sh->log_list, &io->stripe_finished_list);
 
 		r5c_finish_cache_stripe(sh);
 
@@ -553,6 +553,7 @@ static struct r5l_io_unit *r5l_new_meta(struct r5l_log *log)
 	io->log = log;
 	INIT_LIST_HEAD(&io->log_sibling);
 	INIT_LIST_HEAD(&io->stripe_list);
+	INIT_LIST_HEAD(&io->stripe_finished_list);
 	bio_list_init(&io->flush_barriers);
 	io->state = IO_UNIT_RUNNING;
 
@@ -2529,6 +2530,16 @@ void r5l_exit_log(struct r5l_log *log)
 	kfree(log);
 }
 
+/*
+ * operation: 0 - remove rdev from log, 1 - add rdev to log
+ */
+int r5l_modify_log(struct r5l_log *log, struct md_rdev *rdev, int operation)
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
index 40bd5ce..8f466c6 100644
--- a/drivers/md/raid5-cache.h
+++ b/drivers/md/raid5-cache.h
@@ -111,6 +111,7 @@ struct r5l_io_unit {
 	sector_t log_end;	/* where the io_unit ends */
 	struct list_head log_sibling; /* log->running_ios */
 	struct list_head stripe_list; /* stripes added to the io_unit */
+	struct list_head stripe_finished_list; /* stripes written to log */
 
 	int state;
 	bool need_split_bio;
@@ -141,6 +142,7 @@ enum r5l_io_unit_state {
 struct r5l_policy {
 	int (*init_log)(struct r5l_log *log, struct r5conf *conf);
 	void (*exit_log)(struct r5l_log *log);
+	int (*modify_log)(struct r5l_log *log, struct md_rdev *rdev, int op);
 	int (*write_stripe)(struct r5l_log *log, struct stripe_head *sh);
 	void (*write_stripe_run)(struct r5l_log *log);
 	void (*flush_stripe_to_raid)(struct r5l_log *log);
@@ -151,6 +153,7 @@ struct r5l_policy {
 
 extern int r5l_init_log(struct r5conf *conf, struct md_rdev *rdev, int policy_type);
 extern void r5l_exit_log(struct r5l_log *log);
+extern int r5l_modify_log(struct r5l_log *log, struct md_rdev *rdev, int operation);
 extern int r5l_write_stripe(struct r5l_log *log, struct stripe_head *sh);
 extern void r5l_write_stripe_run(struct r5l_log *log);
 extern void r5l_flush_stripe_to_raid(struct r5l_log *log);
diff --git a/drivers/md/raid5-ppl.c b/drivers/md/raid5-ppl.c
index 1a00b2d..7ce3ce5 100644
--- a/drivers/md/raid5-ppl.c
+++ b/drivers/md/raid5-ppl.c
@@ -108,6 +108,7 @@ static struct r5l_io_unit *ppl_new_iounit(struct r5l_log *log,
 	io->log = log;
 	INIT_LIST_HEAD(&io->log_sibling);
 	INIT_LIST_HEAD(&io->stripe_list);
+	INIT_LIST_HEAD(&io->stripe_finished_list);
 	io->state = IO_UNIT_RUNNING;
 
 	io->meta_page = mempool_alloc(log->meta_pool, GFP_NOIO);
@@ -960,6 +961,93 @@ static int __ppl_init_log(struct r5l_log *log, struct r5conf *conf)
 	return ret;
 }
 
+static void ppl_log_stop(struct r5l_log *log)
+{
+	struct r5l_io_unit *io, *next;
+	unsigned long flags;
+	bool wait;
+
+	/* wait for in flight ios to complete */
+	do {
+		wait = false;
+		spin_lock_irqsave(&log->io_list_lock, flags);
+		list_for_each_entry(io, &log->running_ios, log_sibling) {
+			if (io->state == IO_UNIT_IO_START) {
+				wait = true;
+				break;
+			}
+		}
+		if (!wait)
+			wait = !list_empty(&log->flushing_ios);
+		spin_unlock_irqrestore(&log->io_list_lock, flags);
+	} while (wait);
+
+	/* clean up iounits */
+	spin_lock_irqsave(&log->io_list_lock, flags);
+
+	list_for_each_entry_safe(io, next, &log->running_ios, log_sibling) {
+		list_move_tail(&io->log_sibling, &log->finished_ios);
+		bio_put(io->current_bio);
+		mempool_free(io->meta_page, log->meta_pool);
+	}
+	list_splice_tail_init(&log->io_end_ios, &log->finished_ios);
+
+	list_for_each_entry_safe(io, next, &log->finished_ios, log_sibling) {
+		struct stripe_head *sh;
+		list_for_each_entry(sh, &io->stripe_list, log_list) {
+			clear_bit(STRIPE_LOG_TRAPPED, &sh->state);
+			sh->log_io = NULL;
+		}
+		r5l_io_run_stripes(io);
+		list_for_each_entry(sh, &io->stripe_finished_list, log_list) {
+			sh->log_io = NULL;
+		}
+		list_del(&io->log_sibling);
+		mempool_free(io, log->io_pool);
+	}
+	r5l_run_no_mem_stripe(log);
+
+	spin_unlock_irqrestore(&log->io_list_lock, flags);
+}
+
+static int __ppl_modify_log(struct r5l_log *log, struct md_rdev *rdev, int op)
+{
+	struct r5l_log *log_child;
+	struct ppl_conf *ppl_conf = log->private;
+
+	if (!rdev)
+		return -EINVAL;
+
+	dbg("rdev->raid_disk: %d op: %d\n", rdev->raid_disk, op);
+
+	if (rdev->raid_disk < 0)
+		return 0;
+
+	if (rdev->raid_disk >= ppl_conf->count)
+		return -ENODEV;
+
+	if (op == 0) {
+		log_child = ppl_conf->child_logs[rdev->raid_disk];
+		if (!log_child)
+			return 0;
+		ppl_conf->child_logs[rdev->raid_disk] = NULL;
+		ppl_log_stop(log_child);
+		ppl_exit_log_child(log_child);
+	} else if (op == 1) {
+		int ret = ppl_init_log_child(log, rdev, &log_child);
+		if (ret)
+			return ret;
+		ret = ppl_write_empty_header(log_child);
+		if (ret)
+			return ret;
+		ppl_conf->child_logs[rdev->raid_disk] = log_child;
+	} else {
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 static int __ppl_write_stripe(struct r5l_log *log, struct stripe_head *sh)
 {
 	struct ppl_conf *ppl_conf = log->private;
@@ -997,6 +1085,7 @@ static void __ppl_flush_stripe_to_raid(struct r5l_log *log)
 struct r5l_policy r5l_ppl = {
 	.init_log = __ppl_init_log,
 	.exit_log = __ppl_exit_log,
+	.modify_log = __ppl_modify_log,
 	.write_stripe = __ppl_write_stripe,
 	.write_stripe_run = __ppl_write_stripe_run,
 	.flush_stripe_to_raid = __ppl_flush_stripe_to_raid,
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 61179fa..7a1a564 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -7403,6 +7403,19 @@ static int raid5_remove_disk(struct mddev *mddev, struct md_rdev *rdev)
 			*rdevp = rdev;
 		}
 	}
+	if (test_bit(JournalPpl, &rdev->flags) && conf->log) {
+		int ret;
+		if (conf->log->rwh_policy != RWH_POLICY_PPL)
+			return -EINVAL;
+		ret = r5l_modify_log(conf->log, rdev, 0);
+		if (ret)
+			return ret;
+		if (p->replacement) {
+			ret = r5l_modify_log(conf->log, p->replacement, 1);
+			if (ret)
+				return ret;
+		}
+	}
 	if (p->replacement) {
 		/* We must have just cleared 'rdev' */
 		p->rdev = p->replacement;
@@ -7495,6 +7508,13 @@ static int raid5_add_disk(struct mddev *mddev, struct md_rdev *rdev)
 		}
 	}
 out:
+	if (conf->log && !test_bit(Replacement, &rdev->flags) &&
+	    conf->log->rwh_policy == RWH_POLICY_PPL) {
+		int ret = r5l_modify_log(conf->log, rdev, 1);
+		if (ret)
+			return ret;
+	}
+
 	print_raid5_conf(conf);
 	return err;
 }
-- 
2.10.1

