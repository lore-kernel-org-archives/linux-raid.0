From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 03/11] md/raid5: initialize conf->device_lock earlier
Date: Fri, 16 Oct 2009 16:49:18 +1100
Message-ID: <20091016054918.24208.4222.stgit@notabene.brown>
References: <20091016054316.24208.33818.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20091016054316.24208.33818.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Dan Williams <dan.j.williams@intel.com>, NeilBrown <neilb@suse.de>
List-Id: linux-raid.ids

From: Dan Williams <dan.j.williams@intel.com>

Deallocating a raid5_conf_t structure requires taking 'device_lock'.
Ensure it is initialized before it is used, i.e. initialize the lock
before attempting any further initializations that might fail.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/raid5.c |   25 ++++++++++++-------------
 1 files changed, 12 insertions(+), 13 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index ec14ff5..c3e5967 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -4715,6 +4715,18 @@ static raid5_conf_t *setup_conf(mddev_t *mddev)
 	conf = kzalloc(sizeof(raid5_conf_t), GFP_KERNEL);
 	if (conf == NULL)
 		goto abort;
+	spin_lock_init(&conf->device_lock);
+	init_waitqueue_head(&conf->wait_for_stripe);
+	init_waitqueue_head(&conf->wait_for_overlap);
+	INIT_LIST_HEAD(&conf->handle_list);
+	INIT_LIST_HEAD(&conf->hold_list);
+	INIT_LIST_HEAD(&conf->delayed_list);
+	INIT_LIST_HEAD(&conf->bitmap_list);
+	INIT_LIST_HEAD(&conf->inactive_list);
+	atomic_set(&conf->active_stripes, 0);
+	atomic_set(&conf->preread_active_stripes, 0);
+	atomic_set(&conf->active_aligned_reads, 0);
+	conf->bypass_threshold = BYPASS_THRESHOLD;
 
 	conf->raid_disks = mddev->raid_disks;
 	conf->scribble_len = scribble_len(conf->raid_disks);
@@ -4737,19 +4749,6 @@ static raid5_conf_t *setup_conf(mddev_t *mddev)
 	if (raid5_alloc_percpu(conf) != 0)
 		goto abort;
 
-	spin_lock_init(&conf->device_lock);
-	init_waitqueue_head(&conf->wait_for_stripe);
-	init_waitqueue_head(&conf->wait_for_overlap);
-	INIT_LIST_HEAD(&conf->handle_list);
-	INIT_LIST_HEAD(&conf->hold_list);
-	INIT_LIST_HEAD(&conf->delayed_list);
-	INIT_LIST_HEAD(&conf->bitmap_list);
-	INIT_LIST_HEAD(&conf->inactive_list);
-	atomic_set(&conf->active_stripes, 0);
-	atomic_set(&conf->preread_active_stripes, 0);
-	atomic_set(&conf->active_aligned_reads, 0);
-	conf->bypass_threshold = BYPASS_THRESHOLD;
-
 	pr_debug("raid5: run(%s) called.\n", mdname(mddev));
 
 	list_for_each_entry(rdev, &mddev->disks, same_set) {


