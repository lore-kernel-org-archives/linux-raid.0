From: NeilBrown <neilb@suse.com>
Subject: [md PATCH 1/5] md: always hold reconfig_mutex when calling
 mddev_suspend()
Date: Tue, 17 Oct 2017 13:46:43 +1100
Message-ID: <150820840340.1646.12365558035859364361.stgit@noble>
References: <150820826980.1646.6380214598725492144.stgit@noble>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <150820826980.1646.6380214598725492144.stgit@noble>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Most often mddev_suspend() is called with
reconfig_mutex held.  Make this a requirement in
preparation a subsequent patch.

Taking the mutex in r5c_disable_writeback_async() is
a little tricky as this is called from a work queue
via log->disable_writeback_work, and flush_work()
is called on that while holding ->reconfig_mutex.
If the work item hasn't run before flush_work()
is called, the work function will not be able to
get the mutex.

So we use mddev_trylock() inside the wait_event() call, and have that
abort when conf->log is set to NULL, which happens before
flush_work() is called.

Signed-off-by: NeilBrown <neilb@suse.com>
---
 drivers/md/dm-raid.c     |    5 ++++-
 drivers/md/md.c          |    1 +
 drivers/md/raid5-cache.c |   18 +++++++++++++-----
 3 files changed, 18 insertions(+), 6 deletions(-)

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index 2245d06d2045..cc2fed784a5f 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -3629,8 +3629,11 @@ static void raid_postsuspend(struct dm_target *ti)
 {
 	struct raid_set *rs = ti->private;
 
-	if (!test_and_set_bit(RT_FLAG_RS_SUSPENDED, &rs->runtime_flags))
+	if (!test_and_set_bit(RT_FLAG_RS_SUSPENDED, &rs->runtime_flags)) {
+		mddev_lock_nointr(&rs->md);
 		mddev_suspend(&rs->md);
+		mddev_unlock(&rs->md);
+	}
 
 	rs->md.ro = 1;
 }
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 0ff1bbf6c90e..04538b60f8f3 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -344,6 +344,7 @@ static blk_qc_t md_make_request(struct request_queue *q, struct bio *bio)
 void mddev_suspend(struct mddev *mddev)
 {
 	WARN_ON_ONCE(mddev->thread && current == mddev->thread->tsk);
+	lockdep_assert_held(&mddev->reconfig_mutex);
 	if (mddev->suspended++)
 		return;
 	synchronize_rcu();
diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index 0b7406ac8ce1..6a631dd21f0b 100644
--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -693,6 +693,8 @@ static void r5c_disable_writeback_async(struct work_struct *work)
 	struct r5l_log *log = container_of(work, struct r5l_log,
 					   disable_writeback_work);
 	struct mddev *mddev = log->rdev->mddev;
+	struct r5conf *conf = mddev->private;
+	int locked = 0;
 
 	if (log->r5c_journal_mode == R5C_JOURNAL_MODE_WRITE_THROUGH)
 		return;
@@ -701,11 +703,15 @@ static void r5c_disable_writeback_async(struct work_struct *work)
 
 	/* wait superblock change before suspend */
 	wait_event(mddev->sb_wait,
-		   !test_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags));
-
-	mddev_suspend(mddev);
-	log->r5c_journal_mode = R5C_JOURNAL_MODE_WRITE_THROUGH;
-	mddev_resume(mddev);
+		   conf->log == NULL ||
+		   (!test_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags) &&
+		    (locked = mddev_trylock(mddev))));
+	if (locked) {
+		mddev_suspend(mddev);
+		log->r5c_journal_mode = R5C_JOURNAL_MODE_WRITE_THROUGH;
+		mddev_resume(mddev);
+		mddev_unlock(mddev);
+	}
 }
 
 static void r5l_submit_current_io(struct r5l_log *log)
@@ -3165,6 +3171,8 @@ void r5l_exit_log(struct r5conf *conf)
 	conf->log = NULL;
 	synchronize_rcu();
 
+	/* Ensure disable_writeback_work wakes up and exits */
+	wake_up(&conf->mddev->sb_wait);
 	flush_work(&log->disable_writeback_work);
 	md_unregister_thread(&log->reclaim_thread);
 	mempool_destroy(log->meta_pool);


