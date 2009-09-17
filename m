From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH] md: set the md raid 4,5,6  thead name by its level
Date: Thu, 17 Sep 2009 11:36:52 +1000
Message-ID: <19121.37556.237576.950694@notabene.brown>
References: <1253091297-3889-1-git-send-email-zhenchengjin@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1760649AbZIQBfs@vger.kernel.org>
In-Reply-To: message from Jinzc on Wednesday September 16
Sender: linux-kernel-owner@vger.kernel.org
To: Jinzc <zhenchengjin@gmail.com>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday September 16, zhenchengjin@gmail.com wrote:
> the current edition, if you create a md raid 4,5,6
> the name of md thread is mdx_raid5. If you create a raid 4,6
> the name mdx_raid4, mdx_raid6 are better than mdx_raid5.

Thanks for the suggestion and the patch.

I would like to achieve the same thing a little differently.
Primarily I am using the personality name rather than combining the
level number with "raid".  The result is the same.
See below.

Thanks,
NeilBrown


From: NeilBrown <neilb@suse.de>
Date: Thu, 17 Sep 2009 11:34:57 +1000
Subject: [PATCH] md: Improve name of threads created by md_register_thread

The management thread for raid4,5,6 arrays are all called
mdX_raid5, independent of the actual raid level, which is wrong and
can be confusion.

So change md_register_thread to use the name from the personality
unless no alternate name (like 'resync' or 'reshape') is given.

This is simpler and more correct.

Cc: Jinzc <zhenchengjin@gmail.com>
Signed-off-by: NeilBrown <neilb@suse.de>
---
 drivers/md/md.c        |    9 ++++++---
 drivers/md/multipath.c |    2 +-
 drivers/md/raid1.c     |    2 +-
 drivers/md/raid10.c    |    2 +-
 drivers/md/raid5.c     |    6 +++---
 5 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 84e358d..878773a 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -4371,7 +4371,7 @@ static int do_md_run(mddev_t * mddev)
 			set_bit(MD_RECOVERY_RUNNING, &mddev->recovery);
 			mddev->sync_thread = md_register_thread(md_do_sync,
 								mddev,
-								"%s_resync");
+								"resync");
 			if (!mddev->sync_thread) {
 				printk(KERN_ERR "%s: could not start resync"
 				       " thread...\n",
@@ -5784,7 +5784,10 @@ mdk_thread_t *md_register_thread(void (*run) (mddev_t *), mddev_t *mddev,
 	thread->run = run;
 	thread->mddev = mddev;
 	thread->timeout = MAX_SCHEDULE_TIMEOUT;
-	thread->tsk = kthread_run(md_thread, thread, name, mdname(thread->mddev));
+	thread->tsk = kthread_run(md_thread, thread,
+				  "%s_%s",
+				  mdname(thread->mddev),
+				  name ?: mddev->pers->name);
 	if (IS_ERR(thread->tsk)) {
 		kfree(thread);
 		return NULL;
@@ -6898,7 +6901,7 @@ void md_check_recovery(mddev_t *mddev)
 			}
 			mddev->sync_thread = md_register_thread(md_do_sync,
 								mddev,
-								"%s_resync");
+								"resync");
 			if (!mddev->sync_thread) {
 				printk(KERN_ERR "%s: could not start resync"
 					" thread...\n", 
diff --git a/drivers/md/multipath.c b/drivers/md/multipath.c
index 17b2bf1..5277b35 100644
--- a/drivers/md/multipath.c
+++ b/drivers/md/multipath.c
@@ -503,7 +503,7 @@ static int multipath_run (mddev_t *mddev)
 	}
 
 	{
-		mddev->thread = md_register_thread(multipathd, mddev, "%s_multipath");
+		mddev->thread = md_register_thread(multipathd, mddev, NULL);
 		if (!mddev->thread) {
 			printk(KERN_ERR "multipath: couldn't allocate thread"
 				" for %s\n", mdname(mddev));
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 8726fd7..f1db87c 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -2045,7 +2045,7 @@ static int run(mddev_t *mddev)
 	conf->last_used = j;
 
 
-	mddev->thread = md_register_thread(raid1d, mddev, "%s_raid1");
+	mddev->thread = md_register_thread(raid1d, mddev, NULL);
 	if (!mddev->thread) {
 		printk(KERN_ERR
 		       "raid1: couldn't allocate thread for %s\n",
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 8befc3e..a9bf503 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -2188,7 +2188,7 @@ static int run(mddev_t *mddev)
 	}
 
 
-	mddev->thread = md_register_thread(raid10d, mddev, "%s_raid10");
+	mddev->thread = md_register_thread(raid10d, mddev, NULL);
 	if (!mddev->thread) {
 		printk(KERN_ERR
 		       "raid10: couldn't allocate thread for %s\n",
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 5d5dce5..958bf02 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -4448,7 +4448,7 @@ static raid5_conf_t *setup_conf(mddev_t *mddev)
 		printk(KERN_INFO "raid5: allocated %dkB for %s\n",
 			memory, mdname(mddev));
 
-	conf->thread = md_register_thread(raid5d, mddev, "%s_raid5");
+	conf->thread = md_register_thread(raid5d, mddev, NULL);
 	if (!conf->thread) {
 		printk(KERN_ERR
 		       "raid5: couldn't allocate thread for %s\n",
@@ -4614,7 +4614,7 @@ static int run(mddev_t *mddev)
 		set_bit(MD_RECOVERY_RESHAPE, &mddev->recovery);
 		set_bit(MD_RECOVERY_RUNNING, &mddev->recovery);
 		mddev->sync_thread = md_register_thread(md_do_sync, mddev,
-							"%s_reshape");
+							"reshape");
 	}
 
 	/* read-ahead size must cover two whole stripes, which is
@@ -5032,7 +5032,7 @@ static int raid5_start_reshape(mddev_t *mddev)
 	set_bit(MD_RECOVERY_RESHAPE, &mddev->recovery);
 	set_bit(MD_RECOVERY_RUNNING, &mddev->recovery);
 	mddev->sync_thread = md_register_thread(md_do_sync, mddev,
-						"%s_reshape");
+						"reshape");
 	if (!mddev->sync_thread) {
 		mddev->recovery = 0;
 		spin_lock_irq(&conf->device_lock);
-- 
1.6.3.3
