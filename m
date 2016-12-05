From: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Subject: [PATCH v2 12/12] raid5-ppl: runtime PPL enabling or disabling
Date: Mon,  5 Dec 2016 16:31:13 +0100
Message-ID: <20161205153113.7268-13-artur.paszkiewicz@intel.com>
References: <20161205153113.7268-1-artur.paszkiewicz@intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20161205153113.7268-1-artur.paszkiewicz@intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: shli@kernel.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Introduce a sysfs attribute to get or set the current RWH policy. The
raid5_reset_cache function is used to free the stripe cache and allocate
it again. This is needed to allocate or free the ppl_pages for the
stripes in the stripe cache.

When enabling the log at runtime it is necessary to overwrite the PPL
header to avoid recovering from stale PPL data if the log had been used
previously with this array.

Signed-off-by: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
---
 drivers/md/raid5-ppl.c |  38 ++++++++++++++---
 drivers/md/raid5.c     | 109 +++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 142 insertions(+), 5 deletions(-)

diff --git a/drivers/md/raid5-ppl.c b/drivers/md/raid5-ppl.c
index 1a9581c..d0a25da 100644
--- a/drivers/md/raid5-ppl.c
+++ b/drivers/md/raid5-ppl.c
@@ -745,6 +745,27 @@ static int ppl_load(struct r5l_log *log)
 	return ret;
 }
 
+static int ppl_invalidate(struct r5l_log *log)
+{
+	struct ppl_conf *ppl_conf = log->private;
+	int i;
+
+	for (i = 0; i < ppl_conf->count; i++) {
+		struct r5l_log *log_child = ppl_conf->child_logs[i];
+		int ret;
+
+		/* Missing drive */
+		if (!log_child)
+			continue;
+
+		ret = ppl_write_empty_header(log_child);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+
 #define IMSM_MPB_SIG "Intel Raid ISM Cfg Sig. "
 #define IMSM_MPB_ORIG_FAMILY_NUM_OFFSET 64
 
@@ -976,11 +997,18 @@ static int __ppl_init_log(struct r5l_log *log, struct r5conf *conf)
 		ppl_conf->child_logs[i] = log_child;
 	}
 
-	ret = ppl_load(log);
-	if (!ret && mddev->recovery_cp == 0 && !mddev->degraded)
-		mddev->recovery_cp = MaxSector;
-	else if (ret < 0)
-		goto err;
+	if (mddev->pers) {
+		dbg("Array running - invalidate PPL\n");
+		ret = ppl_invalidate(log);
+		if (ret)
+			goto err;
+	} else {
+		ret = ppl_load(log);
+		if (!ret && mddev->recovery_cp == 0 && !mddev->degraded)
+			mddev->recovery_cp = MaxSector;
+		else if (ret < 0)
+			goto err;
+	}
 
 	rcu_assign_pointer(conf->log, log);
 	set_bit(MD_HAS_PPL, &mddev->flags);
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 67c8dce..d829a28 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -6455,6 +6455,114 @@ raid5_group_thread_cnt = __ATTR(group_thread_cnt, S_IRUGO | S_IWUSR,
 				raid5_show_group_thread_cnt,
 				raid5_store_group_thread_cnt);
 
+static ssize_t
+raid5_show_rwh_policy(struct mddev *mddev, char *page)
+{
+	struct r5conf *conf;
+	int ret = 0;
+	spin_lock(&mddev->lock);
+	conf = mddev->private;
+	if (conf) {
+		const char *policy = NULL;
+		if (!conf->log)
+			policy = "off";
+		else if (conf->log->rwh_policy == RWH_POLICY_JOURNAL)
+			policy = "journal";
+		else if (conf->log->rwh_policy == RWH_POLICY_PPL)
+			policy = "ppl";
+		if (policy)
+			ret = sprintf(page, "%s\n", policy);
+	}
+	spin_unlock(&mddev->lock);
+	return ret;
+}
+
+static void raid5_reset_cache(struct mddev *mddev)
+{
+	struct r5conf *conf = mddev->private;
+
+	mutex_lock(&conf->cache_size_mutex);
+	while (conf->max_nr_stripes &&
+		       drop_one_stripe(conf))
+			;
+
+	while (conf->min_nr_stripes > conf->max_nr_stripes)
+		if (!grow_one_stripe(conf, GFP_KERNEL))
+			break;
+	mutex_unlock(&conf->cache_size_mutex);
+}
+
+static ssize_t
+raid5_store_rwh_policy(struct mddev *mddev, const char *page, size_t len)
+{
+	struct r5conf *conf;
+	int err;
+	int new_policy, current_policy;
+
+	if (len >= PAGE_SIZE)
+		return -EINVAL;
+
+	err = mddev_lock(mddev);
+	if (err)
+		return err;
+	conf = mddev->private;
+	if (!conf) {
+		err = -ENODEV;
+		goto out;
+	}
+
+	if (conf->log)
+		current_policy = conf->log->rwh_policy;
+	else
+		current_policy = RWH_POLICY_OFF;
+
+	if (strncmp(page, "off", 3) == 0) {
+		new_policy = RWH_POLICY_OFF;
+	} else if (strncmp(page, "journal", 7) == 0) {
+		new_policy = RWH_POLICY_JOURNAL;
+	} else if (strncmp(page, "ppl", 3) == 0) {
+		new_policy = RWH_POLICY_PPL;
+	} else {
+		err = -EINVAL;
+		goto out;
+	}
+
+	if (new_policy == current_policy)
+		goto out;
+
+	if (current_policy == RWH_POLICY_PPL && new_policy == RWH_POLICY_OFF) {
+		struct r5l_log *log;
+		mddev_suspend(mddev);
+		log = conf->log;
+		conf->log = NULL;
+		synchronize_rcu();
+		r5l_exit_log(log);
+		raid5_reset_cache(mddev);
+		mddev_resume(mddev);
+	} else if (current_policy == RWH_POLICY_OFF &&
+		   new_policy == RWH_POLICY_PPL) {
+		mddev_suspend(mddev);
+		err = r5l_init_log(conf, NULL, new_policy);
+		if (!err)
+			raid5_reset_cache(mddev);
+		mddev_resume(mddev);
+	} else {
+		err = -EINVAL;
+		goto out;
+	}
+
+	md_update_sb(mddev, 1);
+out:
+	mddev_unlock(mddev);
+
+	return err ?: len;
+}
+
+static struct md_sysfs_entry
+raid5_rwh_policy = __ATTR(rwh_policy, S_IRUGO | S_IWUSR,
+				raid5_show_rwh_policy,
+				raid5_store_rwh_policy);
+
 static struct attribute *raid5_attrs[] =  {
 	&raid5_stripecache_size.attr,
 	&raid5_stripecache_active.attr,
@@ -6463,6 +6571,7 @@ static struct attribute *raid5_attrs[] =  {
 	&raid5_skip_copy.attr,
 	&raid5_rmw_level.attr,
 	&r5c_journal_mode.attr,
+	&raid5_rwh_policy.attr,
 	NULL,
 };
 static struct attribute_group raid5_attrs_group = {
-- 
2.10.1

