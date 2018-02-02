From: Mariusz Dabrowski <mariusz.dabrowski@intel.com>
Subject: [PATCH 3/5] raid5: sysfs attribute for write hint policy
Date: Fri,  2 Feb 2018 14:50:37 +0100
Message-ID: <20180202135039.32086-4-mariusz.dabrowski@intel.com>
References: <20180202135039.32086-1-mariusz.dabrowski@intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20180202135039.32086-1-mariusz.dabrowski@intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: shli@kernel.org
Cc: linux-raid@vger.kernel.org, Mariusz Dabrowski <mariusz.dabrowski@intel.com>
List-Id: linux-raid.ids

Added new sysfs attribute to change write hint classification for parity

Signed-off-by: Mariusz Dabrowski <mariusz.dabrowski@intel.com>
Reviewed-by: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Reviewed-by: Pawel Baldysiak <pawel.baldysiak@intel.com>
---
 drivers/md/raid5.c | 62 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/md/raid5.h |  5 +++++
 2 files changed, 67 insertions(+)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index bd99f1651b66..088b97bbcbe2 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -6631,6 +6631,67 @@ raid5_group_thread_cnt = __ATTR(group_thread_cnt, S_IRUGO | S_IWUSR,
 				raid5_show_group_thread_cnt,
 				raid5_store_group_thread_cnt);
 
+static ssize_t
+raid5_show_write_hint_policy(struct mddev *mddev, char *buf)
+{
+	char *sep = ",";
+	size_t len = 0;
+	unsigned long flags = 0;
+	struct r5conf *conf;
+
+	spin_lock(&mddev->lock);
+	conf = mddev->private;
+	if (conf) {
+		flags = conf->write_hint_flags;
+
+		if (!flags) {
+			len = sprintf(buf, "off");
+		} else {
+			if (test_bit(WH_POLICY_PARITY, &flags))
+				len += sprintf(buf+len, "parity%s", sep);
+			len -= strlen(sep);
+		}
+	}
+	spin_unlock(&mddev->lock);
+	len += sprintf(buf + len, "\n");
+
+	return len;
+}
+
+static ssize_t
+raid5_store_write_hint_policy(struct mddev *mddev, const char *page, size_t len)
+{
+	struct r5conf *conf;
+	int err = 0;
+
+	err = mddev_lock(mddev);
+	if (err)
+		return err;
+
+	conf = mddev->private;
+	if (!conf) {
+		err = -ENODEV;
+	} else {
+		if (strncmp(page, "parity", 6) == 0)
+			set_bit(WH_POLICY_PARITY, &conf->write_hint_flags);
+		else if (strncmp(page, "-parity", 7) == 0)
+			clear_bit(WH_POLICY_PARITY, &conf->write_hint_flags);
+		else if (strncmp(page, "off", 3) == 0)
+			conf->write_hint_flags = 0;
+		else
+			err = -EINVAL;
+	}
+
+	mddev_unlock(mddev);
+
+	return err ?: len;
+}
+
+static struct md_sysfs_entry
+raid5_write_hint_policy = __ATTR(write_hint_policy, S_IRUGO | S_IWUSR,
+				 raid5_show_write_hint_policy,
+				 raid5_store_write_hint_policy);
+
 static struct attribute *raid5_attrs[] =  {
 	&raid5_stripecache_size.attr,
 	&raid5_stripecache_active.attr,
@@ -6639,6 +6700,7 @@ static struct attribute *raid5_attrs[] =  {
 	&raid5_skip_copy.attr,
 	&raid5_rmw_level.attr,
 	&r5c_journal_mode.attr,
+	&raid5_write_hint_policy.attr,
 	NULL,
 };
 static struct attribute_group raid5_attrs_group = {
diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
index 69686616d2ca..e08071dc4202 100644
--- a/drivers/md/raid5.h
+++ b/drivers/md/raid5.h
@@ -195,6 +195,10 @@ enum reconstruct_states {
 	reconstruct_state_result,
 };
 
+enum write_hint_flags {
+	WH_POLICY_PARITY = 0,
+};
+
 struct stripe_head {
 	struct hlist_node	hash;
 	struct list_head	lru;	      /* inactive_list or handle_list */
@@ -565,6 +569,7 @@ struct r5conf {
 	int			raid_disks;
 	int			max_nr_stripes;
 	int			min_nr_stripes;
+	unsigned long		write_hint_flags;
 
 	/* reshape_progress is the leading edge of a 'reshape'
 	 * It has value MaxSector when no reshape is happening
-- 
2.16.1

