From: Shaohua Li <shli@fb.com>
Subject: [PATCH 2/4] raid5-cache: avoid write failure for journal hotadd
Date: Tue, 5 Jan 2016 13:26:02 -0800
Message-ID: <1eb31e4a94d3bb5d723164cdcb30a76d1feac7ef.1452028077.git.shli@fb.com>
References: <cover.1452028077.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <cover.1452028077.git.shli@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Kernel-team@fb.com, songliubraving@fb.com, neilb@suse.de
List-Id: linux-raid.ids

r5l_log_disk_error() will make write request fail if there is no log,
but MD_HAS_JOURNAL is set. When we hotadd journal, MD_HAS_JOURNAL is set
but the r5l_log isn't fully initialized yet. Adding a new flag to
indicate the situation and let r5l_log_disk_error() handle the
situation.

Based on Song Liu's original patch
Signed-off-by: Shaohua Li <shli@fb.com>
---
 drivers/md/md.c          | 10 +++++++++-
 drivers/md/md.h          |  2 ++
 drivers/md/raid5-cache.c | 16 +++++++++++++---
 3 files changed, 24 insertions(+), 4 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index c0c3e6d..9f1d609 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -6899,8 +6899,16 @@ static int md_ioctl(struct block_device *bdev, fmode_t mode,
 			else if (!(info.state & (1<<MD_DISK_SYNC)))
 				/* Need to clear read-only for this */
 				break;
-			else
+			else {
+				if ((info.state & (1<<MD_DISK_JOURNAL)) &&
+				    !test_bit(MD_HAS_JOURNAL, &mddev->flags))
+					set_bit(MD_JOURNAL_NOT_INITIALIZED,
+						&mddev->flags);
 				err = add_new_disk(mddev, &info);
+				if (err)
+					clear_bit(MD_JOURNAL_NOT_INITIALIZED,
+						&mddev->flags);
+			}
 			goto unlock;
 		}
 		break;
diff --git a/drivers/md/md.h b/drivers/md/md.h
index e16a17c..d18e0d4 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -238,6 +238,8 @@ struct mddev {
 #define MD_RELOAD_SB	7	/* Reload the superblock because another node
 				 * updated it.
 				 */
+#define MD_JOURNAL_NOT_INITIALIZED 8 /* hot add a journal, and journal isn't
+				      * ready to use yet */
 
 	int				suspended;
 	atomic_t			active_io;
diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index 31e0fad..5a0f680 100644
--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -859,9 +859,17 @@ bool r5l_log_disk_error(struct r5conf *conf)
 	rcu_read_lock();
 	log = rcu_dereference(conf->log);
 
-	if (!log)
-		ret = test_bit(MD_HAS_JOURNAL, &conf->mddev->flags);
-	else
+	if (!log) {
+		ret = test_bit(MD_HAS_JOURNAL, &conf->mddev->flags) &&
+		      !test_bit(MD_JOURNAL_NOT_INITIALIZED, &conf->mddev->flags);
+		smp_mb__after_atomic();
+		/*
+		 * r5l_init_log sets ->log first and then clear INITIALIZED, we
+		 * check in reverse order to avoid race condition.
+		 */
+		log = rcu_dereference(conf->log);
+	}
+	if (log)
 		ret = test_bit(Faulty, &log->rdev->flags);
 	rcu_read_unlock();
 	return ret;
@@ -1242,6 +1250,8 @@ int r5l_init_log(struct r5conf *conf, struct md_rdev *rdev)
 		goto error;
 
 	rcu_assign_pointer(conf->log, log);
+	smp_mb__before_atomic();
+	clear_bit(MD_JOURNAL_NOT_INITIALIZED, &conf->mddev->flags);
 	return 0;
 
 error:
-- 
2.4.6

