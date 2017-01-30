From: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Subject: [PATCH v3 9/9] raid5-ppl: runtime PPL enabling or disabling
Date: Mon, 30 Jan 2017 19:59:53 +0100
Message-ID: <20170130185953.30428-10-artur.paszkiewicz@intel.com>
References: <20170130185953.30428-1-artur.paszkiewicz@intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170130185953.30428-1-artur.paszkiewicz@intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: shli@fb.com, neilb@suse.com, jes.sorensen@gmail.com, Artur Paszkiewicz <artur.paszkiewicz@intel.com>
List-Id: linux-raid.ids

Allow writing to 'consistency_policy' attribute when the array is
active. Add a new function 'change_consistency_policy' to the
md_personality operations structure to handle the change in the
personality code. Values "ppl" and "resync" are accepted and
turn PPL on and off respectively.

When enabling PPL its location and size should first be set using
'ppl_sector' and 'ppl_size' attributes and a valid PPL header should be
written at this location on each member device.

Enabling or disabling PPL is performed under a suspended array.  The
raid5_reset_stripe_cache function frees the stripe cache and allocates
it again in order to allocate or free the ppl_pages for the stripes in
the stripe cache.

Signed-off-by: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
---
 drivers/md/md.c        | 12 +++++++---
 drivers/md/md.h        |  2 ++
 drivers/md/raid5-ppl.c | 19 +++++++++++++++-
 drivers/md/raid5.c     | 61 ++++++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 90 insertions(+), 4 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 47ab3afe87cb..efbaa2f90eb0 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -5051,14 +5051,20 @@ consistency_policy_show(struct mddev *mddev, char *page)
 static ssize_t
 consistency_policy_store(struct mddev *mddev, const char *buf, size_t len)
 {
+	int err = 0;
+
 	if (mddev->pers) {
-		return -EBUSY;
+		if (mddev->pers->change_consistency_policy)
+			err = mddev->pers->change_consistency_policy(mddev, buf);
+		else
+			err = -EBUSY;
 	} else if (mddev->external && strncmp(buf, "ppl", 3) == 0) {
 		set_bit(MD_HAS_PPL, &mddev->flags);
-		return len;
 	} else {
-		return -EINVAL;
+		err = -EINVAL;
 	}
+
+	return err ? err : len;
 }
 
 static struct md_sysfs_entry md_consistency_policy =
diff --git a/drivers/md/md.h b/drivers/md/md.h
index abdb5f2ed2d3..ead1aeff9302 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -548,6 +548,8 @@ struct md_personality
 	/* congested implements bdi.congested_fn().
 	 * Will not be called while array is 'suspended' */
 	int (*congested)(struct mddev *mddev, int bits);
+	/* Changes the consistency policy of an active array. */
+	int (*change_consistency_policy)(struct mddev *mddev, const char *buf);
 };
 
 struct md_sysfs_entry {
diff --git a/drivers/md/raid5-ppl.c b/drivers/md/raid5-ppl.c
index 87e718f5b29f..5a8e7a56eac6 100644
--- a/drivers/md/raid5-ppl.c
+++ b/drivers/md/raid5-ppl.c
@@ -873,7 +873,20 @@ static void __ppl_exit_log(struct r5l_log *log)
 {
 	struct ppl_conf *ppl_conf = log->private;
 
-	kfree(ppl_conf->child_logs);
+	if (ppl_conf->child_logs) {
+		struct r5l_log *log_child;
+		int i;
+
+		for (i = 0; i < ppl_conf->count; i++) {
+			log_child = &ppl_conf->child_logs[i];
+			if (log_child->rdev) {
+				log_child->rdev->ppl.offset = 0;
+				log_child->rdev->ppl.sector = 0;
+				log_child->rdev->ppl.size = 0;
+			}
+		}
+		kfree(ppl_conf->child_logs);
+	}
 	kfree(ppl_conf);
 
 	mempool_destroy(log->meta_pool);
@@ -1004,6 +1017,10 @@ static int __ppl_init_log(struct r5l_log *log, struct r5conf *conf)
 		 */
 		mddev->recovery_cp = MaxSector;
 		set_bit(MD_SB_CHANGE_CLEAN, &mddev->sb_flags);
+	} else if (mddev->pers && ppl_conf->mismatch_count > 0) {
+		/* no mismatch allowed when enabling PPL for a running array */
+		ret = -EINVAL;
+		goto err;
 	}
 
 	conf->log = log;
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index a711bf940116..a095ac2f5d64 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -8272,6 +8272,66 @@ static void *raid6_takeover(struct mddev *mddev)
 	return setup_conf(mddev);
 }
 
+static void raid5_reset_stripe_cache(struct mddev *mddev)
+{
+	struct r5conf *conf = mddev->private;
+
+	mutex_lock(&conf->cache_size_mutex);
+	while (conf->max_nr_stripes &&
+	       drop_one_stripe(conf))
+		;
+	while (conf->min_nr_stripes > conf->max_nr_stripes &&
+	       grow_one_stripe(conf, GFP_KERNEL))
+		;
+	mutex_unlock(&conf->cache_size_mutex);
+}
+
+static int raid5_change_consistency_policy(struct mddev *mddev, const char *buf)
+{
+	struct r5conf *conf;
+	int err;
+
+	err = mddev_lock(mddev);
+	if (err)
+		return err;
+	conf = mddev->private;
+	if (!conf) {
+		mddev_unlock(mddev);
+		return -ENODEV;
+	}
+
+	if (strncmp(buf, "ppl", 3) == 0 &&
+	    !test_bit(MD_HAS_PPL, &mddev->flags) &&
+	    !test_bit(MD_HAS_JOURNAL, &mddev->flags) &&
+	    !mddev->bitmap) {
+		mddev_suspend(mddev);
+		set_bit(MD_HAS_PPL, &mddev->flags);
+		err = r5l_init_log(conf, NULL);
+		if (err)
+			clear_bit(MD_HAS_PPL, &mddev->flags);
+		else
+			raid5_reset_stripe_cache(mddev);
+		mddev_resume(mddev);
+	} else if (strncmp(buf, "resync", 6) == 0 &&
+		   test_bit(MD_HAS_PPL, &mddev->flags)) {
+		mddev_suspend(mddev);
+		r5l_exit_log(conf->log);
+		conf->log = NULL;
+		clear_bit(MD_HAS_PPL, &mddev->flags);
+		raid5_reset_stripe_cache(mddev);
+		mddev_resume(mddev);
+	} else {
+		err = -EINVAL;
+	}
+
+	if (!err)
+		md_update_sb(mddev, 1);
+
+	mddev_unlock(mddev);
+
+	return err;
+}
+
 static struct md_personality raid6_personality =
 {
 	.name		= "raid6",
@@ -8317,6 +8377,7 @@ static struct md_personality raid5_personality =
 	.quiesce	= raid5_quiesce,
 	.takeover	= raid5_takeover,
 	.congested	= raid5_congested,
+	.change_consistency_policy = raid5_change_consistency_policy,
 };
 
 static struct md_personality raid4_personality =
-- 
2.11.0

