From: NeilBrown <neilb@suse.de>
Subject: [PATCH 14/18] md: md_unregister_thread should cope with being passed
	NULL
Date: Thu, 12 Feb 2009 14:10:11 +1100
Message-ID: <20090212031011.23983.85712.stgit@notabene.brown>
References: <20090212031009.23983.14496.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090212031009.23983.14496.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Mostly md_unregister_thread is only called when we know that the
thread is NULL, but sometimes we need to check first.  It is safer
to put the check inside md_unregister_thread itself.

Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/md.c    |    2 ++
 drivers/md/raid5.c |    3 +--
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index d3c6020..cbe0f20 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -5339,6 +5339,8 @@ mdk_thread_t *md_register_thread(void (*run) (mddev_t *), mddev_t *mddev,
 
 void md_unregister_thread(mdk_thread_t *thread)
 {
+	if (! thread)
+		return;
 	dprintk("interrupting MD-thread pid %d\n", task_pid_nr(thread->tsk));
 
 	kthread_stop(thread->tsk);
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index ee42d1a..6c33add 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -4451,8 +4451,7 @@ abort:
 		kfree(conf->stripe_hashtbl);
 		kfree(conf);
 	}
-	if (mddev->thread)
-		md_unregister_thread(mddev->thread);
+	md_unregister_thread(mddev->thread);
 	mddev->private = NULL;
 	printk(KERN_ALERT "raid5: failed to run raid set %s\n", mdname(mddev));
 	return -EIO;


