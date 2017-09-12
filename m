From: NeilBrown <neilb@suse.com>
Subject: [PATCH 1/4] md: always hold reconfig_mutex when calling
 mddev_suspend()
Date: Tue, 12 Sep 2017 11:49:12 +1000
Message-ID: <150518095211.32691.5131214910102889465.stgit@noble>
References: <150518076229.32691.13542756562323866921.stgit@noble>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <150518076229.32691.13542756562323866921.stgit@noble>
Sender: linux-raid-owner@vger.kernel.org
To: Xiao Ni <xni@redhat.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Most often mddev_suspend() is called with
reconfig_mutex held.  Make this a requirement in
preparation a subsequent patch.

Signed-off-by: NeilBrown <neilb@suse.com>
---
 drivers/md/dm-raid.c     |    5 ++++-
 drivers/md/md.c          |    1 +
 drivers/md/raid5-cache.c |    2 ++
 3 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index 5bfe285ea9d1..f013b03e15c3 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -3628,8 +3628,11 @@ static void raid_postsuspend(struct dm_target *ti)
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
index b01e458d31e9..675c9e6495e4 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -336,6 +336,7 @@ static blk_qc_t md_make_request(struct request_queue *q, struct bio *bio)
 void mddev_suspend(struct mddev *mddev)
 {
 	WARN_ON_ONCE(mddev->thread && current == mddev->thread->tsk);
+	lockdep_assert_held(&mddev->reconfig_mutex);
 	if (mddev->suspended++)
 		return;
 	synchronize_rcu();
diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index 2dcbafa8e66c..8d09c2fa3d63 100644
--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -703,9 +703,11 @@ static void r5c_disable_writeback_async(struct work_struct *work)
 	wait_event(mddev->sb_wait,
 		   !test_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags));
 
+	mddev_lock_nointr(mddev);
 	mddev_suspend(mddev);
 	log->r5c_journal_mode = R5C_JOURNAL_MODE_WRITE_THROUGH;
 	mddev_resume(mddev);
+	mddev_unlock(mddev);
 }
 
 static void r5l_submit_current_io(struct r5l_log *log)


