From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 2/3] Revert "md/raid456: distribute raid processing over
	multiple cores"
Date: Thu, 01 Oct 2009 18:18:31 -0700
Message-ID: <20091002011831.24095.41501.stgit@dwillia2-linux.ch.intel.com>
References: <20091002011747.24095.70355.stgit@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20091002011747.24095.70355.stgit@dwillia2-linux.ch.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, Holger Kiehl <Holger.Kiehl@dwd.de>
List-Id: linux-raid.ids

The percpu conversion allowed a straightforward handoff of stripe
processing to the async subsytem that initially showed some modest gains
(+4%).  However, this model is too simplistic and leads to stripes
bouncing between raid5d and the async thread pool for every invocation
of handle_stripe().  As reported by Holger this can fall into a
pathological situation severely impacting throughput (6x performance
loss).

Revert this for now, to be resurrected once we have a more workable
thread pool.

Reported-by: Holger Kiehl <Holger.Kiehl@dwd.de>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/md/Kconfig |   11 -----------
 drivers/md/raid5.c |   37 +++----------------------------------
 2 files changed, 3 insertions(+), 45 deletions(-)

diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
index 2158377..f0fac58 100644
--- a/drivers/md/Kconfig
+++ b/drivers/md/Kconfig
@@ -154,17 +154,6 @@ config MD_RAID456
 
 	  If unsure, say Y.
 
-config MULTICORE_RAID456
-	bool "RAID-4/RAID-5/RAID-6 Multicore processing (EXPERIMENTAL)"
-	depends on MD_RAID456
-	depends on SMP
-	depends on EXPERIMENTAL
-	---help---
-	  Enable the raid456 module to dispatch per-stripe raid operations to a
-	  thread pool.
-
-	  If unsure, say N.
-
 config MD_RAID6_PQ
 	tristate
 
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index c21cc50..11cdfe6 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -47,7 +47,6 @@
 #include <linux/kthread.h>
 #include <linux/raid/pq.h>
 #include <linux/async_tx.h>
-#include <linux/async.h>
 #include <linux/seq_file.h>
 #include <linux/cpu.h>
 #include "md.h"
@@ -4349,36 +4348,6 @@ static int  retry_aligned_read(raid5_conf_t *conf, struct bio *raid_bio)
 	return handled;
 }
 
-#ifdef CONFIG_MULTICORE_RAID456
-static void __process_stripe(void *param, async_cookie_t cookie)
-{
-	struct stripe_head *sh = param;
-
-	handle_stripe(sh);
-	release_stripe(sh);
-}
-
-static void process_stripe(struct stripe_head *sh, struct list_head *domain)
-{
-	async_schedule_domain(__process_stripe, sh, domain);
-}
-
-static void synchronize_stripe_processing(struct list_head *domain)
-{
-	async_synchronize_full_domain(domain);
-}
-#else
-static void process_stripe(struct stripe_head *sh, struct list_head *domain)
-{
-	handle_stripe(sh);
-	release_stripe(sh);
-	cond_resched();
-}
-
-static void synchronize_stripe_processing(struct list_head *domain)
-{
-}
-#endif
 
 
 /*
@@ -4393,7 +4362,6 @@ static void raid5d(mddev_t *mddev)
 	struct stripe_head *sh;
 	raid5_conf_t *conf = mddev->private;
 	int handled;
-	LIST_HEAD(raid_domain);
 
 	pr_debug("+++ raid5d active\n");
 
@@ -4430,7 +4398,9 @@ static void raid5d(mddev_t *mddev)
 		spin_unlock_irq(&conf->device_lock);
 		
 		handled++;
-		process_stripe(sh, &raid_domain);
+		handle_stripe(sh);
+		release_stripe(sh);
+		cond_resched();
 
 		spin_lock_irq(&conf->device_lock);
 	}
@@ -4438,7 +4408,6 @@ static void raid5d(mddev_t *mddev)
 
 	spin_unlock_irq(&conf->device_lock);
 
-	synchronize_stripe_processing(&raid_domain);
 	async_tx_issue_pending_all();
 	unplug_slaves(mddev);
 

