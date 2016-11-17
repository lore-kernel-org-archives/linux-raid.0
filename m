From: Song Liu <songliubraving@fb.com>
Subject: [PATCH v7 06/10] md/r5cache: sysfs entry journal_mode
Date: Thu, 17 Nov 2016 15:24:41 -0800
Message-ID: <20161117232445.1798305-7-songliubraving@fb.com>
References: <20161117232445.1798305-1-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20161117232445.1798305-1-songliubraving@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.com, shli@fb.com, kernel-team@fb.com, dan.j.williams@intel.com, hch@infradead.org, liuzhengyuang521@gmail.com, liuzhengyuan@kylinos.cn, Song Liu <songliubraving@fb.com>
List-Id: linux-raid.ids

With write cache, journal_mode is the knob to switch between
write-back and write-through.

Below is an example:

root@virt-test:~/# cat /sys/block/md0/md/journal_mode
[write-through] write-back
root@virt-test:~/# echo write-back > /sys/block/md0/md/journal_mode
root@virt-test:~/# cat /sys/block/md0/md/journal_mode
write-through [write-back]

Signed-off-by: Song Liu <songliubraving@fb.com>
---
 drivers/md/raid5-cache.c | 65 ++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/md/raid5.c       |  1 +
 drivers/md/raid5.h       |  1 +
 3 files changed, 67 insertions(+)

diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index 7dec2a0..b9ad0e8 100644
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
@@ -1617,6 +1619,69 @@ static void r5l_write_super(struct r5l_log *log, sector_t cp)
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
+		ret = snprintf(
+			page, PAGE_SIZE, "[%s] %s\n",
+			r5c_journal_mode_str[R5C_JOURNAL_MODE_WRITE_THROUGH],
+			r5c_journal_mode_str[R5C_JOURNAL_MODE_WRITE_BACK]);
+		break;
+	case R5C_JOURNAL_MODE_WRITE_BACK:
+		ret = snprintf(
+			page, PAGE_SIZE, "%s [%s]\n",
+			r5c_journal_mode_str[R5C_JOURNAL_MODE_WRITE_THROUGH],
+			r5c_journal_mode_str[R5C_JOURNAL_MODE_WRITE_BACK]);
+		break;
+	default:
+		ret = 0;
+	}
+	return ret;
+}
+
+static ssize_t r5c_journal_mode_store(struct mddev *mddev,
+				      const char *page, size_t length)
+{
+	struct r5conf *conf = mddev->private;
+	struct r5l_log *log = conf->log;
+	int val = -1, i;
+	int len = length;
+
+	if (!log)
+		return -ENODEV;
+
+	if (len && page[len - 1] == '\n')
+		len -= 1;
+	for (i = 0; i < ARRAY_SIZE(r5c_journal_mode_str); i++)
+		if (strlen(r5c_journal_mode_str[i]) == len &&
+		    strncmp(page, r5c_journal_mode_str[i], len) == 0) {
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
+	return length;
+}
+
+struct md_sysfs_entry
+r5c_journal_mode = __ATTR(journal_mode, 0644,
+			  r5c_journal_mode_show, r5c_journal_mode_store);
+
 /*
  * Try handle write operation in caching phase. This function should only
  * be called in write-back mode.
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 90638ba..17cf98e 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -6319,6 +6319,7 @@ static struct attribute *raid5_attrs[] =  {
 	&raid5_group_thread_cnt.attr,
 	&raid5_skip_copy.attr,
 	&raid5_rmw_level.attr,
+	&r5c_journal_mode.attr,
 	NULL,
 };
 static struct attribute_group raid5_attrs_group = {
diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
index 35b4c0f..a698113 100644
--- a/drivers/md/raid5.h
+++ b/drivers/md/raid5.h
@@ -773,4 +773,5 @@ extern void r5c_make_stripe_write_out(struct stripe_head *sh);
 extern void r5c_flush_cache(struct r5conf *conf, int num);
 extern void r5c_check_stripe_cache_usage(struct r5conf *conf);
 extern void r5c_check_cached_full_stripe(struct r5conf *conf);
+extern struct md_sysfs_entry r5c_journal_mode;
 #endif
-- 
2.9.3

