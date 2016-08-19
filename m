From: Song Liu <songliubraving@fb.com>
Subject: [PATCH 2/2] r5cache: remove journal support
Date: Fri, 19 Aug 2016 15:34:02 -0700
Message-ID: <1471646042-2366825-2-git-send-email-songliubraving@fb.com>
References: <1471646042-2366825-1-git-send-email-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1471646042-2366825-1-git-send-email-songliubraving@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: shli@fb.com, Song Liu <songliubraving@fb.com>
List-Id: linux-raid.ids

In current r5cache, when the journal device is broken, the raid
array is forced in readonly mode. There is no way to remove the
"journal feature", and thus make the array read-write without
journal.

This patch provides sysfs entry r5c_cache_mode that can be used
to remove journal feature.

r5c_cache_mode has 4 different values:
* no-cache;
* write-through (write journal only);
* write-back (w/ write cache feature, which will be added soon);
* broken-cache (journal missing or Faulty)

By writing into r5c_cache_mode, the array can transit from
broken-cache to no-cache, which removes journal feature for the
array.

Signed-off-by: Song Liu <songliubraving@fb.com>
---
 drivers/md/raid5-cache.c | 64 ++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/md/raid5.c       |  5 ++++
 drivers/md/raid5.h       |  6 +++++
 3 files changed, 75 insertions(+)

diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index 5504ce2..508d470 100644
--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -40,6 +40,16 @@
  */
 #define R5L_POOL_SIZE	4
 
+enum r5c_cache_mode {
+	R5C_MODE_NO_CACHE = 0,
+	R5C_MODE_WRITE_THROUGH = 1,
+	R5C_MODE_WRITE_BACK = 2,
+	R5C_MODE_BROKEN_CACHE = 3,
+};
+
+static char *r5c_cache_mode_str[] = {"no-cache", "write-through",
+				     "write-back", "broken-cache"};
+
 struct r5l_log {
 	struct md_rdev *rdev;
 
@@ -97,6 +107,8 @@ struct r5l_log {
 
 	bool need_cache_flush;
 	bool in_teardown;
+
+	enum r5c_cache_mode cache_mode;
 };
 
 /*
@@ -1193,6 +1205,56 @@ ioerr:
 	return ret;
 }
 
+ssize_t r5c_show_cache_mode(struct mddev *mddev, char *page)
+{
+	struct r5conf *conf = mddev->private;
+	int val = 0;
+	int ret = 0;
+
+	if (conf->log)
+		val = conf->log->cache_mode;
+	else if (test_bit(MD_HAS_JOURNAL, &mddev->flags))
+		val = R5C_MODE_BROKEN_CACHE;
+	ret += snprintf(page, PAGE_SIZE - ret, "%d: %s\n",
+			val, r5c_cache_mode_str[val]);
+	return ret;
+}
+
+ssize_t r5c_store_cache_mode(struct mddev *mddev, const char *page, size_t len)
+{
+	struct r5conf *conf = mddev->private;
+	struct r5l_log *log = conf->log;
+	int val;
+
+	if (kstrtoint(page, 10, &val))
+		return -EINVAL;
+	if (!log && val != R5C_MODE_NO_CACHE)
+		return -EINVAL;
+	/* currently only support write through (write journal) */
+	if (val < R5C_MODE_NO_CACHE || val > R5C_MODE_WRITE_THROUGH)
+		return -EINVAL;
+	if (val == R5C_MODE_NO_CACHE) {
+		if (conf->log &&
+		    !test_bit(Faulty, &log->rdev->flags)) {
+			pr_err("md/raid:%s: journal device is in use, cannot remove it\n",
+			       mdname(mddev));
+			return -EINVAL;
+		}
+	}
+
+	spin_lock_irq(&conf->device_lock);
+	if (log)
+		conf->log->cache_mode = val;
+	if (val == R5C_MODE_NO_CACHE) {
+		clear_bit(MD_HAS_JOURNAL, &mddev->flags);
+		set_bit(MD_UPDATE_SB_FLAGS, &mddev->flags);
+	}
+	spin_unlock_irq(&conf->device_lock);
+	pr_info("%s: setting r5c cache mode to %d: %s\n",
+		       mdname(mddev), val, r5c_cache_mode_str[val]);
+	return len;
+}
+
 int r5l_init_log(struct r5conf *conf, struct md_rdev *rdev)
 {
 	struct request_queue *q = bdev_get_queue(rdev->bdev);
@@ -1246,6 +1308,8 @@ int r5l_init_log(struct r5conf *conf, struct md_rdev *rdev)
 	INIT_LIST_HEAD(&log->no_space_stripes);
 	spin_lock_init(&log->no_space_stripes_lock);
 
+	log->cache_mode = R5C_MODE_WRITE_THROUGH;
+
 	if (r5l_load_log(log))
 		goto error;
 
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 2119e09..665d853 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -6230,6 +6230,10 @@ raid5_group_thread_cnt = __ATTR(group_thread_cnt, S_IRUGO | S_IWUSR,
 				raid5_show_group_thread_cnt,
 				raid5_store_group_thread_cnt);
 
+static struct md_sysfs_entry
+r5c_cache_mode = __ATTR(r5c_cache_mode, S_IRUGO | S_IWUSR,
+			r5c_show_cache_mode, r5c_store_cache_mode);
+
 static struct attribute *raid5_attrs[] =  {
 	&raid5_stripecache_size.attr,
 	&raid5_stripecache_active.attr,
@@ -6237,6 +6241,7 @@ static struct attribute *raid5_attrs[] =  {
 	&raid5_group_thread_cnt.attr,
 	&raid5_skip_copy.attr,
 	&raid5_rmw_level.attr,
+	&r5c_cache_mode.attr,
 	NULL,
 };
 static struct attribute_group raid5_attrs_group = {
diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
index 517d4b6..ace9675 100644
--- a/drivers/md/raid5.h
+++ b/drivers/md/raid5.h
@@ -635,4 +635,10 @@ extern void r5l_stripe_write_finished(struct stripe_head *sh);
 extern int r5l_handle_flush_request(struct r5l_log *log, struct bio *bio);
 extern void r5l_quiesce(struct r5l_log *log, int state);
 extern bool r5l_log_disk_error(struct r5conf *conf);
+
+
+extern ssize_t r5c_show_cache_mode(struct mddev *mddev, char *page);
+extern ssize_t
+r5c_store_cache_mode(struct mddev *mddev, const char *page, size_t len);
+
 #endif
-- 
2.8.0.rc2

