From: Shaohua Li <shli@fb.com>
Subject: [PATCH 1/2] RAID5: check_reshape() shouldn't call mddev_suspend
Date: Thu, 25 Feb 2016 10:45:03 -0800
Message-ID: <b228d35f9a8e94969d667edbcc9d7f613d706b02.1456424579.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: artur.paszkiewicz@intel.com, neilb@suse.com
List-Id: linux-raid.ids

check_reshape() is called from raid5d thread. raid5d thread shouldn't
call mddev_suspend(), because mddev_suspend() waits for all IO finish
but IO is handled in raid5d thread, we could easily deadlock here.

Artur,
It would be great if you can verify this works for your test.

Reported-by: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Cc: NeilBrown <neilb@suse.com>
Signed-off-by: Shaohua Li <shli@fb.com>
---
 drivers/md/raid5.c | 18 ++++++++++++++++++
 drivers/md/raid5.h |  2 ++
 2 files changed, 20 insertions(+)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 7f770b0..c7fd070 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -2089,6 +2089,14 @@ static int resize_chunks(struct r5conf *conf, int new_disks, int new_sectors)
 	unsigned long cpu;
 	int err = 0;
 
+	/*
+	 * Never shrink. And mddev_suspend() could deadlock if this is called
+	 * from raid5d. In that case, scribble_disks and scribble_sectors
+	 * should equal to new_disks and new_sectors
+	 */
+	if (conf->scribble_disks >= new_disks &&
+	    conf->scribble_sectors >= new_sectors)
+		return 0;
 	mddev_suspend(conf->mddev);
 	get_online_cpus();
 	for_each_present_cpu(cpu) {
@@ -2110,6 +2118,10 @@ static int resize_chunks(struct r5conf *conf, int new_disks, int new_sectors)
 	}
 	put_online_cpus();
 	mddev_resume(conf->mddev);
+	if (!err) {
+		conf->scribble_disks = new_disks;
+		conf->scribble_sectors = new_sectors;
+	}
 	return err;
 }
 
@@ -6413,6 +6425,12 @@ static int raid5_alloc_percpu(struct r5conf *conf)
 	}
 	put_online_cpus();
 
+	if (!err) {
+		conf->scribble_disks = max(conf->raid_disks,
+			conf->previous_raid_disks);
+		conf->scribble_sectors = max(conf->chunk_sectors,
+			conf->prev_chunk_sectors) / STRIPE_SECTORS;
+	}
 	return err;
 }
 
diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
index a415e1c..ae6068d 100644
--- a/drivers/md/raid5.h
+++ b/drivers/md/raid5.h
@@ -510,6 +510,8 @@ struct r5conf {
 					      * conversions
 					      */
 	} __percpu *percpu;
+	int scribble_disks;
+	int scribble_sectors;
 #ifdef CONFIG_HOTPLUG_CPU
 	struct notifier_block	cpu_notify;
 #endif
-- 
2.6.5

