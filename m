From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH v2 9/9] md/raid456: distribute raid processing over multiple
	cores
Date: Mon, 31 Aug 2009 09:41:50 -0700
Message-ID: <20090831164150.1696.83369.stgit@dwillia2-linux.ch.intel.com>
References: <20090831163914.1696.55782.stgit@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090831163914.1696.55782.stgit@dwillia2-linux.ch.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, Arjan van de Ven <arjan@linux.intel.com>
List-Id: linux-raid.ids

Now that the resources to handle stripe_head operations are allocated
percpu it is possible for raid5d to distribute stripe handling over
multiple cores.  This conversion also adds a call to cond_resched() in
the non-multicore case to prevent one core from getting monopolized for
raid operations.

Cc: Arjan van de Ven <arjan@linux.intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/md/Kconfig |   11 +++++++++++
 drivers/md/raid5.c |   36 ++++++++++++++++++++++++++++++++++--
 2 files changed, 45 insertions(+), 2 deletions(-)

diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
index abb8636..09c0c6e 100644
--- a/drivers/md/Kconfig
+++ b/drivers/md/Kconfig
@@ -154,6 +154,17 @@ config MD_RAID456
 
 	  If unsure, say Y.
 
+config MULTICORE_RAID456
+	bool "RAID-4/RAID-5/RAID-6 Multicore processing (EXPERIMENTAL)"
+	depends on MD_RAID456
+	depends on SMP
+	depends on EXPERIMENTAL
+	---help---
+	  Enable the raid456 module to dispatch per-stripe raid operations to a
+	  thread pool.
+
+	  If unsure, say N.
+
 config MD_RAID6_PQ
 	tristate
 
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 7c22e19..364ea37 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -47,6 +47,7 @@
 #include <linux/kthread.h>
 #include <linux/raid/pq.h>
 #include <linux/async_tx.h>
+#include <linux/async.h>
 #include <linux/seq_file.h>
 #include <linux/cpu.h>
 #include "md.h"
@@ -4314,6 +4315,36 @@ static int  retry_aligned_read(raid5_conf_t *conf, struct bio *raid_bio)
 	return handled;
 }
 
+#ifdef CONFIG_MULTICORE_RAID456
+static void __process_stripe(void *param, async_cookie_t cookie)
+{
+	struct stripe_head *sh = param;
+
+	handle_stripe(sh);
+	release_stripe(sh);
+}
+
+static void process_stripe(struct stripe_head *sh, struct list_head *domain)
+{
+	async_schedule_domain(__process_stripe, sh, domain);
+}
+
+static void synchronize_stripe_processing(struct list_head *domain)
+{
+	async_synchronize_full_domain(domain);
+}
+#else
+static void process_stripe(struct stripe_head *sh, struct list_head *domain)
+{
+	handle_stripe(sh);
+	release_stripe(sh);
+	cond_resched();
+}
+
+static void synchronize_stripe_processing(struct list_head *domain)
+{
+}
+#endif
 
 
 /*
@@ -4328,6 +4359,7 @@ static void raid5d(mddev_t *mddev)
 	struct stripe_head *sh;
 	raid5_conf_t *conf = mddev_to_conf(mddev);
 	int handled;
+	LIST_HEAD(raid_domain);
 
 	pr_debug("+++ raid5d active\n");
 
@@ -4364,8 +4396,7 @@ static void raid5d(mddev_t *mddev)
 		spin_unlock_irq(&conf->device_lock);
 		
 		handled++;
-		handle_stripe(sh);
-		release_stripe(sh);
+		process_stripe(sh, &raid_domain);
 
 		spin_lock_irq(&conf->device_lock);
 	}
@@ -4373,6 +4404,7 @@ static void raid5d(mddev_t *mddev)
 
 	spin_unlock_irq(&conf->device_lock);
 
+	synchronize_stripe_processing(&raid_domain);
 	async_tx_issue_pending_all();
 	unplug_slaves(mddev);
 

