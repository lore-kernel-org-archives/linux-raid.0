From: Shaohua Li <shli@fb.com>
Subject: [PATCH 3/4] raid5-cache: handle flush request for journal hotadd
Date: Tue, 5 Jan 2016 13:26:03 -0800
Message-ID: <7b8a15be93941a393a5a08232659fef9ead4610b.1452028077.git.shli@fb.com>
References: <cover.1452028077.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <cover.1452028077.git.shli@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Kernel-team@fb.com, songliubraving@fb.com, neilb@suse.de
List-Id: linux-raid.ids

When we hotadd journal for array which isn't created with journal, the
array might be running write requests. Such writes aren't protected by
journal yet, so we can't skip disk flush. There is no easy way to know
when all such writes are finished, but the time should be enough after
reclaim runs once.

Signed-off-by: Shaohua Li <shli@fb.com>
---
 drivers/md/raid5-cache.c | 26 ++++++++++++++++++++++++--
 1 file changed, 24 insertions(+), 2 deletions(-)

diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index 5a0f680..fcda2d2 100644
--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -97,6 +97,7 @@ struct r5l_log {
 
 	bool need_cache_flush;
 	bool in_teardown;
+	bool force_flush_all_disks;
 };
 
 /*
@@ -526,10 +527,27 @@ void r5l_write_stripe_run(struct r5conf *conf)
 
 int r5l_handle_flush_request(struct r5conf *conf, struct bio *bio)
 {
-	struct r5l_log *log = ACCESS_ONCE(conf->log);
+	struct r5l_log *log;
 
-	if (!log)
+	/* raid5_remove_disk writes_pending check isn't helpful for flush */
+	rcu_read_lock();
+	log = rcu_dereference(conf->log);
+	if (!log) {
+		rcu_read_unlock();
 		return -ENODEV;
+	}
+
+	/*
+	 * If we add journal to array without journal before, the array might
+	 * run write requests before journal runs. such requests are not
+	 * protected by journal, so we can't skip flush.
+	 */
+	if (log->force_flush_all_disks) {
+		rcu_read_unlock();
+		md_flush_request(log->rdev->mddev, bio);
+		return 0;
+	}
+	rcu_read_unlock();
 	/*
 	 * we flush log disk cache first, then write stripe data to raid disks.
 	 * So if bio is finished, the log disk cache is flushed already. The
@@ -798,6 +816,8 @@ static void r5l_do_reclaim(struct r5l_log *log)
 	log->last_cp_seq = next_cp_seq;
 	mutex_unlock(&log->io_mutex);
 
+	log->force_flush_all_disks = false;
+
 	r5l_run_no_space_stripes(log);
 }
 
@@ -1246,6 +1266,8 @@ int r5l_init_log(struct r5conf *conf, struct md_rdev *rdev)
 	INIT_LIST_HEAD(&log->no_space_stripes);
 	spin_lock_init(&log->no_space_stripes_lock);
 
+	if (test_bit(MD_JOURNAL_NOT_INITIALIZED, &conf->mddev->flags))
+		log->force_flush_all_disks = true;
 	if (r5l_load_log(log))
 		goto error;
 
-- 
2.4.6

