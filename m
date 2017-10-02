From: Bart Van Assche <bart.vanassche@wdc.com>
Subject: [PATCH v5 2/8] md: Neither resync nor reshape while the system is frozen
Date: Mon,  2 Oct 2017 15:52:12 -0700
Message-ID: <20171002225218.18548-3-bart.vanassche@wdc.com>
References: <20171002225218.18548-1-bart.vanassche@wdc.com>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20171002225218.18548-1-bart.vanassche@wdc.com>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, Christoph Hellwig <hch@lst.de>, "Martin K . Petersen" <martin.petersen@oracle.com>, =Oleksandr Natalenko <oleksandr@natalenko.name>, "Luis R . Rodriguez" <mcgrof@kernel.org>, Bart Van Assche <bart.vanassche@wdc.com>, Shaohua Li <shli@kernel.org>, linux-raid@vger.kernel.org, Ming Lei <ming.lei@redhat.com>, Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>
List-Id: linux-raid.ids

Some people use the md driver on laptops and use the suspend and
resume functionality. Since it is essential that submitting of
new I/O requests stops before a hibernation image is created,
interrupt the md resync and reshape actions if the system is
being frozen. Note: the resync and reshape will restart after
the system is resumed and a message similar to the following
will appear in the system log:

md: md0: data-check interrupted.

Additionally, only allow resync or reshape activity to be
started after system freezing is over.

Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
Cc: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org
Cc: Ming Lei <ming.lei@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.com>
Cc: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/md/md.c | 37 ++++++++++++++++++++++++++++++++++++-
 1 file changed, 36 insertions(+), 1 deletion(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 3f7426120a3b..a2cf2a93b0cb 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -66,6 +66,7 @@
 #include <linux/raid/md_u.h>
 #include <linux/slab.h>
 #include <linux/percpu-refcount.h>
+#include <linux/suspend.h>
 
 #include <trace/events/block.h>
 #include "md.h"
@@ -7450,7 +7451,8 @@ static int md_thread(void *arg)
 
 		wait_event_interruptible_timeout
 			(thread->wqueue,
-			 test_bit(THREAD_WAKEUP, &thread->flags)
+			 (test_bit(THREAD_WAKEUP, &thread->flags) &&
+			  atomic_read(&system_freezing_cnt) == 0)
 			 || kthread_should_stop() || kthread_should_park(),
 			 thread->timeout);
 
@@ -8961,6 +8963,37 @@ static void md_stop_all_writes(void)
 		mdelay(1000*1);
 }
 
+/*
+ * Ensure that neither resyncing nor reshaping occurs while the system is
+ * frozen.
+ */
+static int md_notify_pm(struct notifier_block *bl, unsigned long state,
+			void *unused)
+{
+	struct mddev *mddev;
+	struct list_head *tmp;
+
+	pr_debug("%s: state = %ld; system_freezing_cnt = %d\n", __func__, state,
+		 atomic_read(&system_freezing_cnt));
+
+	switch (state) {
+	case PM_HIBERNATION_PREPARE:
+		md_stop_all_writes();
+		break;
+	case PM_POST_HIBERNATION:
+		rcu_read_lock();
+		for_each_mddev(mddev, tmp)
+			wake_up(&mddev->thread->wqueue);
+		rcu_read_unlock();
+		break;
+	}
+	return NOTIFY_DONE;
+}
+
+static struct notifier_block md_pm_notifier = {
+	.notifier_call	= md_notify_pm,
+};
+
 static int md_notify_reboot(struct notifier_block *this,
 			    unsigned long code, void *x)
 {
@@ -9007,6 +9040,7 @@ static int __init md_init(void)
 			    md_probe, NULL, NULL);
 
 	register_reboot_notifier(&md_reboot_notifier);
+	register_pm_notifier(&md_pm_notifier);
 	raid_table_header = register_sysctl_table(raid_root_table);
 
 	md_geninit();
@@ -9246,6 +9280,7 @@ static __exit void md_exit(void)
 
 	unregister_blkdev(MD_MAJOR,"md");
 	unregister_blkdev(mdp_major, "mdp");
+	unregister_pm_notifier(&md_pm_notifier);
 	unregister_reboot_notifier(&md_reboot_notifier);
 	unregister_sysctl_table(raid_table_header);
 
-- 
2.14.1
