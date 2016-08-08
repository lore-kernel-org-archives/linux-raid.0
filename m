From: shli@kernel.org
Subject: [PATCH 2/2] MD: make sure raid5-cache superblock write with reconfig_mutex hold
Date: Mon,  8 Aug 2016 08:37:04 -0700
Message-ID: <5e9e2bf77911f0d8e7480fef9b68bcfc1f7f7ec2.1470670241.git.shli@fb.com>
References: <2a17e29eea7636568f6327f4de5fbe90b861fb04.1470670241.git.shli@fb.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <2a17e29eea7636568f6327f4de5fbe90b861fb04.1470670241.git.shli@fb.com>
In-Reply-To: <2a17e29eea7636568f6327f4de5fbe90b861fb04.1470670241.git.shli@fb.com>
References: <2a17e29eea7636568f6327f4de5fbe90b861fb04.1470670241.git.shli@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: yizhan@redhat.com, gqjiang@suse.com, neilb@suse.com, Shaohua Li <shli@fb.com>
List-Id: linux-raid.ids

From: Shaohua Li <shli@fb.com>

The raid5-cache .quiesce assumes it's called with reconfig_mutex hold. It's
true at most time but there are some exceptions. Since raid5-cache .quiesce
could write superblock, it must be called with reconfig_mutex hold. We already
have facility in .quiesce to indicate if it's called with the mutex hold. This
patch makes raid5-cache .quiesce use the facility.

Signed-off-by: Shaohua Li <shli@fb.com>
---
 drivers/md/raid5-cache.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index 551158c..e4070d2 100644
--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -97,6 +97,7 @@ struct r5l_log {
 
 	bool need_cache_flush;
 	bool in_teardown;
+	bool reconfig_mutex_locked;
 };
 
 /*
@@ -712,7 +713,7 @@ static void r5l_write_super_and_discard_space(struct r5l_log *log,
 	 * md_check_recovery() fails, so the PENDING never get cleared. The
 	 * in_teardown check workaround this issue.
 	 */
-	if (!log->in_teardown) {
+	if (!log->in_teardown || !log->reconfig_mutex_locked) {
 		set_mask_bits(&mddev->flags, 0,
 			      BIT(MD_CHANGE_DEVS) | BIT(MD_CHANGE_PENDING));
 		md_wakeup_thread(mddev->thread);
@@ -826,6 +827,7 @@ void r5l_quiesce(struct r5l_log *log, int state, bool reconfig_mutex_locked)
 	struct mddev *mddev;
 	if (!log || state == 2)
 		return;
+	log->reconfig_mutex_locked = reconfig_mutex_locked;
 	if (state == 0) {
 		log->in_teardown = 0;
 		/*
@@ -850,6 +852,7 @@ void r5l_quiesce(struct r5l_log *log, int state, bool reconfig_mutex_locked)
 		md_unregister_thread(&log->reclaim_thread);
 		r5l_do_reclaim(log);
 	}
+	log->reconfig_mutex_locked = false;
 }
 
 bool r5l_log_disk_error(struct r5conf *conf)
-- 
2.7.4

