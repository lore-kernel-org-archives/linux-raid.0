From: Song Liu <songliubraving@fb.com>
Subject: [PATCH v6 06/11] md/r5cache: sysfs entry r5c_journal_mode
Date: Thu, 10 Nov 2016 12:46:18 -0800
Message-ID: <20161110204623.3484694-7-songliubraving@fb.com>
References: <20161110204623.3484694-1-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20161110204623.3484694-1-songliubraving@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.com, shli@fb.com, kernel-team@fb.com, dan.j.williams@intel.com, hch@infradead.org, liuzhengyuang521@gmail.com, liuzhengyuan@kylinos.cn, Song Liu <songliubraving@fb.com>
List-Id: linux-raid.ids

With write cache, r5c_journal_mode is the knob to switch between
write-back and write-through.

Below is an example:

root@virt-test:~/# cat /sys/block/md0/md/r5c_state
[write-through] write-back
root@virt-test:~/# echo write-back > /sys/block/md0/md/r5c_state
root@virt-test:~/# cat /sys/block/md0/md/r5c_state
write-through [write-back]

Signed-off-by: Song Liu <songliubraving@fb.com>
---
 drivers/md/raid5-cache.c | 60 ++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/md/raid5.c       |  1 +
 drivers/md/raid5.h       |  1 +
 3 files changed, 62 insertions(+)

diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index 8330053..d2acb69 100644
--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -60,6 +60,8 @@ enum r5c_journal_mode {
 	R5C_JOURNAL_MODE_WRITE_BACK = 1,
 };
 
+static char *r5c_journal_mode_str[] = {"write-through",
+				       "write-back"};
 /*
  * raid5 cache state machine
  *
@@ -1602,6 +1604,64 @@ static void r5l_write_super(struct r5l_log *log, sector_t cp)
 	set_bit(MD_CHANGE_DEVS, &mddev->flags);
 }
 
+static ssize_t r5c_journal_mode_show(struct mddev *mddev, char *page)
+{
+	struct r5conf *conf = mddev->private;
+	int ret;
+
+	if (!conf->log)
+		return 0;
+
+	switch (conf->log->r5c_journal_mode) {
+	case R5C_JOURNAL_MODE_WRITE_THROUGH:
+		ret = snprintf(page, PAGE_SIZE, "[%s] %s\n",
+			       r5c_journal_mode_str[R5C_JOURNAL_MODE_WRITE_THROUGH],
+			       r5c_journal_mode_str[R5C_JOURNAL_MODE_WRITE_BACK]);
+		break;
+	case R5C_JOURNAL_MODE_WRITE_BACK:
+		ret = snprintf(page, PAGE_SIZE, "%s [%s]\n",
+			       r5c_journal_mode_str[R5C_JOURNAL_MODE_WRITE_THROUGH],
+			       r5c_journal_mode_str[R5C_JOURNAL_MODE_WRITE_BACK]);
+		break;
+	default:
+		ret = 0;
+	}
+	return ret;
+}
+
+static ssize_t r5c_journal_mode_store(struct mddev *mddev,
+				      const char *page, size_t len)
+{
+	struct r5conf *conf = mddev->private;
+	struct r5l_log *log = conf->log;
+	int val = -1, i;
+
+	if (!log)
+		return -ENODEV;
+
+	for (i = 0; i < sizeof(r5c_journal_mode_str) / sizeof(r5c_journal_mode_str[0]); i++)
+		if (strlen(r5c_journal_mode_str[i]) == len - 1 &&
+		    strncmp(page, r5c_journal_mode_str[i], len - 1) == 0) {
+			val = i;
+			break;
+		}
+	if (val < R5C_JOURNAL_MODE_WRITE_THROUGH ||
+	    val > R5C_JOURNAL_MODE_WRITE_BACK)
+		return -EINVAL;
+
+	mddev_suspend(mddev);
+	conf->log->r5c_journal_mode = val;
+	mddev_resume(mddev);
+
+	pr_debug("md/raid:%s: setting r5c cache mode to %d: %s\n",
+		 mdname(mddev), val, r5c_journal_mode_str[val]);
+	return len;
+}
+
+struct md_sysfs_entry
+r5c_journal_mode = __ATTR(r5c_journal_mode, S_IRUGO | S_IWUSR,
+			  r5c_journal_mode_show, r5c_journal_mode_store);
+
 int r5c_handle_stripe_dirtying(struct r5conf *conf,
 			       struct stripe_head *sh,
 			       struct stripe_head_state *s,
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 49414f9..e8dace5 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -6306,6 +6306,7 @@ static struct attribute *raid5_attrs[] =  {
 	&raid5_group_thread_cnt.attr,
 	&raid5_skip_copy.attr,
 	&raid5_rmw_level.attr,
+	&r5c_journal_mode.attr,
 	NULL,
 };
 static struct attribute_group raid5_attrs_group = {
diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
index 8a913f9..801722a 100644
--- a/drivers/md/raid5.h
+++ b/drivers/md/raid5.h
@@ -754,4 +754,5 @@ extern void r5c_make_stripe_write_out(struct stripe_head *sh);
 extern void r5c_flush_cache(struct r5conf *conf, int num);
 extern void r5c_check_stripe_cache_usage(struct r5conf *conf);
 extern void r5c_check_cached_full_stripe(struct r5conf *conf);
+extern struct md_sysfs_entry r5c_journal_mode;
 #endif
-- 
2.9.3

