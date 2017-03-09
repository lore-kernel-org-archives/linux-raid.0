From: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Subject: [PATCH v5 7/7] raid5-ppl: runtime PPL enabling or disabling
Date: Thu,  9 Mar 2017 10:00:03 +0100
Message-ID: <20170309090003.13298-8-artur.paszkiewicz@intel.com>
References: <20170309090003.13298-1-artur.paszkiewicz@intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170309090003.13298-1-artur.paszkiewicz@intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: shli@fb.com
Cc: linux-raid@vger.kernel.org, Artur Paszkiewicz <artur.paszkiewicz@intel.com>
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
 drivers/md/md.c        | 12 +++++++++---
 drivers/md/md.h        |  2 ++
 drivers/md/raid5-ppl.c |  4 ++++
 drivers/md/raid5.c     | 53 ++++++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 68 insertions(+), 3 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 1df48f365b3c..8ef2100e2788 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -4995,14 +4995,20 @@ consistency_policy_show(struct mddev *mddev, char *page)
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
index a7b2f16452c4..e0940064c3ec 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -545,6 +545,8 @@ struct md_personality
 	/* congested implements bdi.congested_fn().
 	 * Will not be called while array is 'suspended' */
 	int (*congested)(struct mddev *mddev, int bits);
+	/* Changes the consistency policy of an active array. */
+	int (*change_consistency_policy)(struct mddev *mddev, const char *buf);
 };
 
 struct md_sysfs_entry {
diff --git a/drivers/md/raid5-ppl.c b/drivers/md/raid5-ppl.c
index b5fcf55edee9..ca1ef644351a 100644
--- a/drivers/md/raid5-ppl.c
+++ b/drivers/md/raid5-ppl.c
@@ -1195,6 +1195,10 @@ int ppl_init_log(struct r5conf *conf)
 		 */
 		mddev->recovery_cp = MaxSector;
 		set_bit(MD_SB_CHANGE_CLEAN, &mddev->sb_flags);
+	} else if (mddev->pers && ppl_conf->mismatch_count > 0) {
+		/* no mismatch allowed when enabling PPL for a running array */
+		ret = -EINVAL;
+		goto err;
 	}
 
 	conf->log_private = ppl_conf;
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 8b8f172d6807..7a6a6184e2a7 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -8213,6 +8213,58 @@ static void *raid6_takeover(struct mddev *mddev)
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
+	if (strncmp(buf, "ppl", 3) == 0 && !raid5_has_ppl(conf)) {
+		mddev_suspend(mddev);
+		set_bit(MD_HAS_PPL, &mddev->flags);
+		err = log_init(conf, NULL);
+		if (!err)
+			raid5_reset_stripe_cache(mddev);
+		mddev_resume(mddev);
+	} else if (strncmp(buf, "resync", 6) == 0 && raid5_has_ppl(conf)) {
+		mddev_suspend(mddev);
+		log_exit(conf);
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
@@ -8258,6 +8310,7 @@ static struct md_personality raid5_personality =
 	.quiesce	= raid5_quiesce,
 	.takeover	= raid5_takeover,
 	.congested	= raid5_congested,
+	.change_consistency_policy = raid5_change_consistency_policy,
 };
 
 static struct md_personality raid4_personality =
-- 
2.11.0

