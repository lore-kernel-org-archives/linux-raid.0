From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 09/16] md: raid5: Convert to hotplug state machine
Date: Thu, 18 Aug 2016 14:57:24 +0200
Message-ID: <20160818125731.27256-10-bigeasy@linutronix.de>
References: <20160818125731.27256-1-bigeasy@linutronix.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160818125731.27256-1-bigeasy@linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, rt@linutronix.de, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Neil Brown <neilb@suse.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Install the callbacks via the state machine and let the core invoke
the callbacks on the already online CPUs.

Cc: Neil Brown <neilb@suse.com>
Cc: linux-raid@vger.kernel.org
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/md/raid5.c         | 83 ++++++++++++++++------------------------------
 drivers/md/raid5.h         |  4 +--
 include/linux/cpuhotplug.h |  1 +
 3 files changed, 30 insertions(+), 58 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index f79b1a57f69a..40ac4c953ff2 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -6344,22 +6344,20 @@ static int alloc_scratch_buffer(struct r5conf *conf, struct raid5_percpu *percpu
 	return 0;
 }
 
+static int raid456_cpu_dead(unsigned int cpu, struct hlist_node *node)
+{
+	struct r5conf *conf = hlist_entry_safe(node, struct r5conf, node);
+
+	free_scratch_buffer(conf, per_cpu_ptr(conf->percpu, cpu));
+	return 0;
+}
+
 static void raid5_free_percpu(struct r5conf *conf)
 {
-	unsigned long cpu;
-
 	if (!conf->percpu)
 		return;
 
-#ifdef CONFIG_HOTPLUG_CPU
-	unregister_cpu_notifier(&conf->cpu_notify);
-#endif
-
-	get_online_cpus();
-	for_each_possible_cpu(cpu)
-		free_scratch_buffer(conf, per_cpu_ptr(conf->percpu, cpu));
-	put_online_cpus();
-
+	cpuhp_state_remove_instance(CPUHP_MD_RAID5_PREPARE, &conf->node);
 	free_percpu(conf->percpu);
 }
 
@@ -6378,64 +6376,28 @@ static void free_conf(struct r5conf *conf)
 	kfree(conf);
 }
 
-#ifdef CONFIG_HOTPLUG_CPU
-static int raid456_cpu_notify(struct notifier_block *nfb, unsigned long action,
-			      void *hcpu)
+static int raid456_cpu_up_prepare(unsigned int cpu, struct hlist_node *node)
 {
-	struct r5conf *conf = container_of(nfb, struct r5conf, cpu_notify);
-	long cpu = (long)hcpu;
+	struct r5conf *conf = hlist_entry_safe(node, struct r5conf, node);
 	struct raid5_percpu *percpu = per_cpu_ptr(conf->percpu, cpu);
 
-	switch (action) {
-	case CPU_UP_PREPARE:
-	case CPU_UP_PREPARE_FROZEN:
-		if (alloc_scratch_buffer(conf, percpu)) {
-			pr_err("%s: failed memory allocation for cpu%ld\n",
-			       __func__, cpu);
-			return notifier_from_errno(-ENOMEM);
-		}
-		break;
-	case CPU_DEAD:
-	case CPU_DEAD_FROZEN:
-	case CPU_UP_CANCELED:
-	case CPU_UP_CANCELED_FROZEN:
-		free_scratch_buffer(conf, per_cpu_ptr(conf->percpu, cpu));
-		break;
-	default:
-		break;
+	if (alloc_scratch_buffer(conf, percpu)) {
+		pr_err("%s: failed memory allocation for cpu%u\n",
+		       __func__, cpu);
+		return -ENOMEM;
 	}
-	return NOTIFY_OK;
+	return 0;
 }
-#endif
 
 static int raid5_alloc_percpu(struct r5conf *conf)
 {
-	unsigned long cpu;
 	int err = 0;
 
 	conf->percpu = alloc_percpu(struct raid5_percpu);
 	if (!conf->percpu)
 		return -ENOMEM;
 
-#ifdef CONFIG_HOTPLUG_CPU
-	conf->cpu_notify.notifier_call = raid456_cpu_notify;
-	conf->cpu_notify.priority = 0;
-	err = register_cpu_notifier(&conf->cpu_notify);
-	if (err)
-		return err;
-#endif
-
-	get_online_cpus();
-	for_each_present_cpu(cpu) {
-		err = alloc_scratch_buffer(conf, per_cpu_ptr(conf->percpu, cpu));
-		if (err) {
-			pr_err("%s: failed memory allocation for cpu%ld\n",
-			       __func__, cpu);
-			break;
-		}
-	}
-	put_online_cpus();
-
+	err = cpuhp_state_add_instance(CPUHP_MD_RAID5_PREPARE, &conf->node);
 	if (!err) {
 		conf->scribble_disks = max(conf->raid_disks,
 			conf->previous_raid_disks);
@@ -7967,10 +7929,20 @@ static struct md_personality raid4_personality =
 
 static int __init raid5_init(void)
 {
+	int ret;
+
 	raid5_wq = alloc_workqueue("raid5wq",
 		WQ_UNBOUND|WQ_MEM_RECLAIM|WQ_CPU_INTENSIVE|WQ_SYSFS, 0);
 	if (!raid5_wq)
 		return -ENOMEM;
+	ret = cpuhp_setup_state_multi(CPUHP_MD_RAID5_PREPARE,
+				      "MD_RAID5_PREPARE",
+				      raid456_cpu_up_prepare,
+				      raid456_cpu_dead);
+	if (ret) {
+		destroy_workqueue(raid5_wq);
+		return ret;
+	}
 	register_md_personality(&raid6_personality);
 	register_md_personality(&raid5_personality);
 	register_md_personality(&raid4_personality);
@@ -7982,6 +7954,7 @@ static void raid5_exit(void)
 	unregister_md_personality(&raid6_personality);
 	unregister_md_personality(&raid5_personality);
 	unregister_md_personality(&raid4_personality);
+	cpuhp_remove_multi_state(CPUHP_MD_RAID5_PREPARE);
 	destroy_workqueue(raid5_wq);
 }
 
diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
index 517d4b68a1be..57ec49f0839e 100644
--- a/drivers/md/raid5.h
+++ b/drivers/md/raid5.h
@@ -512,9 +512,7 @@ struct r5conf {
 	} __percpu *percpu;
 	int scribble_disks;
 	int scribble_sectors;
-#ifdef CONFIG_HOTPLUG_CPU
-	struct notifier_block	cpu_notify;
-#endif
+	struct hlist_node node;
 
 	/*
 	 * Free stripes pool
diff --git a/include/linux/cpuhotplug.h b/include/linux/cpuhotplug.h
index 332b39c21d2e..5811954809af 100644
--- a/include/linux/cpuhotplug.h
+++ b/include/linux/cpuhotplug.h
@@ -28,6 +28,7 @@ enum cpuhp_state {
 	CPUHP_RELAY_PREPARE,
 	CPUHP_SLAB_PREPARE,
 	CPUHP_RCUTREE_PREP,
+	CPUHP_MD_RAID5_PREPARE,
 	CPUHP_NOTIFY_PREPARE,
 	CPUHP_TIMERS_DEAD,
 	CPUHP_BRINGUP_CPU,
-- 
2.9.3
