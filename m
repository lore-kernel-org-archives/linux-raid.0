From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH v3 06/14] md/raid6: move the spare page to a percpu allocation
Date: Sat, 29 Aug 2009 19:30:31 -0700
Message-ID: <20090830023031.5934.53814.stgit@dwillia2-linux.ch.intel.com>
References: <20090830022908.5934.72142.stgit@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090830022908.5934.72142.stgit@dwillia2-linux.ch.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

In preparation for asynchronous handling of raid6 operations move the
spare page to a percpu allocation to allow multiple simultaneous
synchronous raid6 recovery operations.

Make this allocation cpu hotplug aware to maximize allocation
efficiency.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/md/raid5.c |  252 +++++++++++++++++++++++++++++++++++-----------------
 drivers/md/raid5.h |    9 +-
 2 files changed, 175 insertions(+), 86 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 9411466..5359236 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -48,6 +48,7 @@
 #include <linux/raid/pq.h>
 #include <linux/async_tx.h>
 #include <linux/seq_file.h>
+#include <linux/cpu.h>
 #include "md.h"
 #include "raid5.h"
 #include "bitmap.h"
@@ -2565,14 +2566,15 @@ static void handle_parity_checks5(raid5_conf_t *conf, struct stripe_head *sh,
 
 
 static void handle_parity_checks6(raid5_conf_t *conf, struct stripe_head *sh,
-				struct stripe_head_state *s,
-				struct r6_state *r6s, struct page *tmp_page,
-				int disks)
+				  struct stripe_head_state *s,
+				  struct r6_state *r6s, int disks)
 {
 	int update_p = 0, update_q = 0;
 	struct r5dev *dev;
 	int pd_idx = sh->pd_idx;
 	int qd_idx = sh->qd_idx;
+	unsigned long cpu;
+	struct page *tmp_page;
 
 	set_bit(STRIPE_HANDLE, &sh->state);
 
@@ -2583,78 +2585,75 @@ static void handle_parity_checks6(raid5_conf_t *conf, struct stripe_head *sh,
 	 * case we can only check one of them, possibly using the
 	 * other to generate missing data
 	 */
-
-	/* If !tmp_page, we cannot do the calculations,
-	 * but as we have set STRIPE_HANDLE, we will soon be called
-	 * by stripe_handle with a tmp_page - just wait until then.
-	 */
-	if (tmp_page) {
-		if (s->failed == r6s->q_failed) {
-			/* The only possible failed device holds 'Q', so it
-			 * makes sense to check P (If anything else were failed,
-			 * we would have used P to recreate it).
-			 */
-			compute_block_1(sh, pd_idx, 1);
-			if (!page_is_zero(sh->dev[pd_idx].page)) {
-				compute_block_1(sh, pd_idx, 0);
-				update_p = 1;
-			}
-		}
-		if (!r6s->q_failed && s->failed < 2) {
-			/* q is not failed, and we didn't use it to generate
-			 * anything, so it makes sense to check it
-			 */
-			memcpy(page_address(tmp_page),
-			       page_address(sh->dev[qd_idx].page),
-			       STRIPE_SIZE);
-			compute_parity6(sh, UPDATE_PARITY);
-			if (memcmp(page_address(tmp_page),
-				   page_address(sh->dev[qd_idx].page),
-				   STRIPE_SIZE) != 0) {
-				clear_bit(STRIPE_INSYNC, &sh->state);
-				update_q = 1;
-			}
+	cpu = get_cpu();
+	tmp_page = per_cpu_ptr(conf->percpu, cpu)->spare_page;
+	if (s->failed == r6s->q_failed) {
+		/* The only possible failed device holds 'Q', so it
+		 * makes sense to check P (If anything else were failed,
+		 * we would have used P to recreate it).
+		 */
+		compute_block_1(sh, pd_idx, 1);
+		if (!page_is_zero(sh->dev[pd_idx].page)) {
+			compute_block_1(sh, pd_idx, 0);
+			update_p = 1;
 		}
-		if (update_p || update_q) {
-			conf->mddev->resync_mismatches += STRIPE_SECTORS;
-			if (test_bit(MD_RECOVERY_CHECK, &conf->mddev->recovery))
-				/* don't try to repair!! */
-				update_p = update_q = 0;
+	}
+	if (!r6s->q_failed && s->failed < 2) {
+		/* q is not failed, and we didn't use it to generate
+		 * anything, so it makes sense to check it
+		 */
+		memcpy(page_address(tmp_page),
+		       page_address(sh->dev[qd_idx].page),
+		       STRIPE_SIZE);
+		compute_parity6(sh, UPDATE_PARITY);
+		if (memcmp(page_address(tmp_page),
+			   page_address(sh->dev[qd_idx].page),
+			   STRIPE_SIZE) != 0) {
+			clear_bit(STRIPE_INSYNC, &sh->state);
+			update_q = 1;
 		}
+	}
+	put_cpu();
 
-		/* now write out any block on a failed drive,
-		 * or P or Q if they need it
-		 */
+	if (update_p || update_q) {
+		conf->mddev->resync_mismatches += STRIPE_SECTORS;
+		if (test_bit(MD_RECOVERY_CHECK, &conf->mddev->recovery))
+			/* don't try to repair!! */
+			update_p = update_q = 0;
+	}
 
-		if (s->failed == 2) {
-			dev = &sh->dev[r6s->failed_num[1]];
-			s->locked++;
-			set_bit(R5_LOCKED, &dev->flags);
-			set_bit(R5_Wantwrite, &dev->flags);
-		}
-		if (s->failed >= 1) {
-			dev = &sh->dev[r6s->failed_num[0]];
-			s->locked++;
-			set_bit(R5_LOCKED, &dev->flags);
-			set_bit(R5_Wantwrite, &dev->flags);
-		}
+	/* now write out any block on a failed drive,
+	 * or P or Q if they need it
+	 */
 
-		if (update_p) {
-			dev = &sh->dev[pd_idx];
-			s->locked++;
-			set_bit(R5_LOCKED, &dev->flags);
-			set_bit(R5_Wantwrite, &dev->flags);
-		}
-		if (update_q) {
-			dev = &sh->dev[qd_idx];
-			s->locked++;
-			set_bit(R5_LOCKED, &dev->flags);
-			set_bit(R5_Wantwrite, &dev->flags);
-		}
-		clear_bit(STRIPE_DEGRADED, &sh->state);
+	if (s->failed == 2) {
+		dev = &sh->dev[r6s->failed_num[1]];
+		s->locked++;
+		set_bit(R5_LOCKED, &dev->flags);
+		set_bit(R5_Wantwrite, &dev->flags);
+	}
+	if (s->failed >= 1) {
+		dev = &sh->dev[r6s->failed_num[0]];
+		s->locked++;
+		set_bit(R5_LOCKED, &dev->flags);
+		set_bit(R5_Wantwrite, &dev->flags);
+	}
 
-		set_bit(STRIPE_INSYNC, &sh->state);
+	if (update_p) {
+		dev = &sh->dev[pd_idx];
+		s->locked++;
+		set_bit(R5_LOCKED, &dev->flags);
+		set_bit(R5_Wantwrite, &dev->flags);
+	}
+	if (update_q) {
+		dev = &sh->dev[qd_idx];
+		s->locked++;
+		set_bit(R5_LOCKED, &dev->flags);
+		set_bit(R5_Wantwrite, &dev->flags);
 	}
+	clear_bit(STRIPE_DEGRADED, &sh->state);
+
+	set_bit(STRIPE_INSYNC, &sh->state);
 }
 
 static void handle_stripe_expansion(raid5_conf_t *conf, struct stripe_head *sh,
@@ -3009,7 +3008,7 @@ static bool handle_stripe5(struct stripe_head *sh)
 	return blocked_rdev == NULL;
 }
 
-static bool handle_stripe6(struct stripe_head *sh, struct page *tmp_page)
+static bool handle_stripe6(struct stripe_head *sh)
 {
 	raid5_conf_t *conf = sh->raid_conf;
 	int disks = sh->disks;
@@ -3164,7 +3163,7 @@ static bool handle_stripe6(struct stripe_head *sh, struct page *tmp_page)
 	 * data is available
 	 */
 	if (s.syncing && s.locked == 0 && !test_bit(STRIPE_INSYNC, &sh->state))
-		handle_parity_checks6(conf, sh, &s, &r6s, tmp_page, disks);
+		handle_parity_checks6(conf, sh, &s, &r6s, disks);
 
 	if (s.syncing && s.locked == 0 && test_bit(STRIPE_INSYNC, &sh->state)) {
 		md_done_sync(conf->mddev, STRIPE_SECTORS,1);
@@ -3247,16 +3246,14 @@ static bool handle_stripe6(struct stripe_head *sh, struct page *tmp_page)
 }
 
 /* returns true if the stripe was handled */
-static bool handle_stripe(struct stripe_head *sh, struct page *tmp_page)
+static bool handle_stripe(struct stripe_head *sh)
 {
 	if (sh->raid_conf->level == 6)
-		return handle_stripe6(sh, tmp_page);
+		return handle_stripe6(sh);
 	else
 		return handle_stripe5(sh);
 }
 
-
-
 static void raid5_activate_delayed(raid5_conf_t *conf)
 {
 	if (atomic_read(&conf->preread_active_stripes) < IO_THRESHOLD) {
@@ -4047,7 +4044,7 @@ static inline sector_t sync_request(mddev_t *mddev, sector_t sector_nr, int *ski
 	spin_unlock(&sh->lock);
 
 	/* wait for any blocked device to be handled */
-	while(unlikely(!handle_stripe(sh, NULL)))
+	while (unlikely(!handle_stripe(sh)))
 		;
 	release_stripe(sh);
 
@@ -4104,7 +4101,7 @@ static int  retry_aligned_read(raid5_conf_t *conf, struct bio *raid_bio)
 			return handled;
 		}
 
-		handle_stripe(sh, NULL);
+		handle_stripe(sh);
 		release_stripe(sh);
 		handled++;
 	}
@@ -4168,7 +4165,7 @@ static void raid5d(mddev_t *mddev)
 		spin_unlock_irq(&conf->device_lock);
 		
 		handled++;
-		handle_stripe(sh, conf->spare_page);
+		handle_stripe(sh);
 		release_stripe(sh);
 
 		spin_lock_irq(&conf->device_lock);
@@ -4309,15 +4306,104 @@ raid5_size(mddev_t *mddev, sector_t sectors, int raid_disks)
 	return sectors * (raid_disks - conf->max_degraded);
 }
 
+static void raid5_free_percpu(raid5_conf_t *conf)
+{
+	struct raid5_percpu *percpu;
+	unsigned long cpu;
+
+	if (!conf->percpu)
+		return;
+
+	get_online_cpus();
+	for_each_possible_cpu(cpu) {
+		percpu = per_cpu_ptr(conf->percpu, cpu);
+		safe_put_page(percpu->spare_page);
+	}
+#ifdef CONFIG_HOTPLUG_CPU
+	unregister_cpu_notifier(&conf->cpu_notify);
+#endif
+	put_online_cpus();
+
+	free_percpu(conf->percpu);
+}
+
 static void free_conf(raid5_conf_t *conf)
 {
 	shrink_stripes(conf);
-	safe_put_page(conf->spare_page);
+	raid5_free_percpu(conf);
 	kfree(conf->disks);
 	kfree(conf->stripe_hashtbl);
 	kfree(conf);
 }
 
+#ifdef CONFIG_HOTPLUG_CPU
+static int raid456_cpu_notify(struct notifier_block *nfb, unsigned long action,
+			      void *hcpu)
+{
+	raid5_conf_t *conf = container_of(nfb, raid5_conf_t, cpu_notify);
+	long cpu = (long)hcpu;
+	struct raid5_percpu *percpu = per_cpu_ptr(conf->percpu, cpu);
+
+	switch (action) {
+	case CPU_UP_PREPARE:
+	case CPU_UP_PREPARE_FROZEN:
+		if (!percpu->spare_page)
+			percpu->spare_page = alloc_page(GFP_KERNEL);
+		if (!percpu->spare_page) {
+			pr_err("%s: failed memory allocation for cpu%ld\n",
+			       __func__, cpu);
+			return NOTIFY_BAD;
+		}
+		break;
+	case CPU_DEAD:
+	case CPU_DEAD_FROZEN:
+		safe_put_page(percpu->spare_page);
+		percpu->spare_page = NULL;
+		break;
+	default:
+		break;
+	}
+	return NOTIFY_OK;
+}
+#endif
+
+static int raid5_alloc_percpu(raid5_conf_t *conf)
+{
+	unsigned long cpu;
+	struct page *spare_page;
+	struct raid5_percpu *allcpus;
+	int err;
+
+	/* the only percpu data is the raid6 spare page */
+	if (conf->level != 6)
+		return 0;
+
+	allcpus = alloc_percpu(struct raid5_percpu);
+	if (!allcpus)
+		return -ENOMEM;
+	conf->percpu = allcpus;
+
+	get_online_cpus();
+	err = 0;
+	for_each_present_cpu(cpu) {
+		spare_page = alloc_page(GFP_KERNEL);
+		if (!spare_page) {
+			err = -ENOMEM;
+			break;
+		}
+		per_cpu_ptr(conf->percpu, cpu)->spare_page = spare_page;
+	}
+#ifdef CONFIG_HOTPLUG_CPU
+	conf->cpu_notify.notifier_call = raid456_cpu_notify;
+	conf->cpu_notify.priority = 0;
+	if (err == 0)
+		err = register_cpu_notifier(&conf->cpu_notify);
+#endif
+	put_online_cpus();
+
+	return err;
+}
+
 static raid5_conf_t *setup_conf(mddev_t *mddev)
 {
 	raid5_conf_t *conf;
@@ -4372,11 +4458,10 @@ static raid5_conf_t *setup_conf(mddev_t *mddev)
 	if ((conf->stripe_hashtbl = kzalloc(PAGE_SIZE, GFP_KERNEL)) == NULL)
 		goto abort;
 
-	if (mddev->new_level == 6) {
-		conf->spare_page = alloc_page(GFP_KERNEL);
-		if (!conf->spare_page)
-			goto abort;
-	}
+	conf->level = mddev->new_level;
+	if (raid5_alloc_percpu(conf) != 0)
+		goto abort;
+
 	spin_lock_init(&conf->device_lock);
 	init_waitqueue_head(&conf->wait_for_stripe);
 	init_waitqueue_head(&conf->wait_for_overlap);
@@ -4412,7 +4497,6 @@ static raid5_conf_t *setup_conf(mddev_t *mddev)
 	}
 
 	conf->chunk_size = mddev->new_chunk;
-	conf->level = mddev->new_level;
 	if (conf->level == 6)
 		conf->max_degraded = 2;
 	else
diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
index 52ba999..07a7a41 100644
--- a/drivers/md/raid5.h
+++ b/drivers/md/raid5.h
@@ -383,8 +383,13 @@ struct raid5_private_data {
 					    * (fresh device added).
 					    * Cleared when a sync completes.
 					    */
-
-	struct page 		*spare_page; /* Used when checking P/Q in raid6 */
+	/* per cpu variables */
+	struct raid5_percpu {
+		struct page	*spare_page; /* Used when checking P/Q in raid6 */
+	} *percpu;
+#ifdef CONFIG_HOTPLUG_CPU
+	struct notifier_block	cpu_notify;
+#endif
 
 	/*
 	 * Free stripes pool

