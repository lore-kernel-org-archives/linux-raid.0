From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 1/3] md/raid5: initialize conf->device_lock earlier
Date: Thu, 01 Oct 2009 18:18:26 -0700
Message-ID: <20091002011825.24095.44406.stgit@dwillia2-linux.ch.intel.com>
References: <20091002011747.24095.70355.stgit@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20091002011747.24095.70355.stgit@dwillia2-linux.ch.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Deallocating a raid5_conf_t structure requires taking 'device_lock'.
Ensure it is initialized before it is used, i.e. initialize the lock
before attempting any further initializations that might fail.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/md/raid5.c |   25 ++++++++++++-------------
 1 files changed, 12 insertions(+), 13 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 9482980..c21cc50 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -4722,6 +4722,18 @@ static raid5_conf_t *setup_conf(mddev_t *mddev)
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
@@ -4744,19 +4756,6 @@ static raid5_conf_t *setup_conf(mddev_t *mddev)
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

