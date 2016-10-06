From: Song Liu <songliubraving@fb.com>
Subject: [PATCH v3 6/8] md/r5cache: sysfs entry r5c_state
Date: Thu, 6 Oct 2016 00:14:14 -0700
Message-ID: <20161006071416.3295093-7-songliubraving@fb.com>
References: <20161006071416.3295093-1-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20161006071416.3295093-1-songliubraving@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.com, shli@fb.com, kernel-team@fb.com, dan.j.williams@intel.com, hch@infradead.org, liuzhengyuang521@gmail.com, liuzhengyuan@kylinos.cn, Song Liu <songliubraving@fb.com>
List-Id: linux-raid.ids

r5c_state have 4 states:
* no-cache;
* write-through (write journal only);
* write-back (w/ write cache);
* cache-broken (journal missing or Faulty)

When there is functional write cache, r5c_state is a knob to
switch between write-back and write-through.

When the journal device is broken, the raid array is forced
in readonly mode. In this case, r5c_state can be used to
remove "journal feature", and thus make the array read-write
without journal. By writing into r5c_cache_mode, the array
can transit from cache-broken to no-cache, which removes
journal feature for the array.

To remove the journal feature:
- When journal fails, the raid array is forced readonly mode
  (enforced by kernel)
- User uses the new interface to remove journal (writing 0
  to r5c_state, I will add a mdadm option for that later)
- User forces array read-write;
- Kernel updates superblock and array can run read/write.

Signed-off-by: Song Liu <songliubraving@fb.com>
---
 drivers/md/raid5-cache.c | 58 ++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/md/raid5.c       |  1 +
 drivers/md/raid5.h       |  1 +
 3 files changed, 60 insertions(+)

diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index 688dae1..c1288a7 100644
--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -57,6 +57,8 @@ enum r5c_state {
 	R5C_STATE_CACHE_BROKEN = 3,
 };
 
+static char *r5c_state_str[] = {"no-cache", "write-through",
+				"write-back", "cache-broken"};
 /*
  * raid5 cache state machine
  *
@@ -1516,6 +1518,62 @@ int r5c_flush_cache(struct r5conf *conf, int num)
 	return count;
 }
 
+ssize_t r5c_state_show(struct mddev *mddev, char *page)
+{
+	struct r5conf *conf = mddev->private;
+	int val = 0;
+	int ret = 0;
+
+	if (conf->log)
+		val = conf->log->r5c_state;
+	else if (test_bit(MD_HAS_JOURNAL, &mddev->flags))
+		val = R5C_STATE_CACHE_BROKEN;
+	ret += snprintf(page, PAGE_SIZE - ret, "%d: %s\n",
+			val, r5c_state_str[val]);
+	return ret;
+}
+
+ssize_t r5c_state_store(struct mddev *mddev, const char *page, size_t len)
+{
+	struct r5conf *conf = mddev->private;
+	struct r5l_log *log = conf->log;
+	int val;
+
+	if (kstrtoint(page, 10, &val))
+		return -EINVAL;
+	if (!log && val != R5C_STATE_NO_CACHE)
+		return -EINVAL;
+
+	if (val < R5C_STATE_NO_CACHE || val > R5C_STATE_WRITE_BACK)
+		return -EINVAL;
+	if (val == R5C_STATE_NO_CACHE) {
+		if (conf->log &&
+		    !test_bit(Faulty, &log->rdev->flags)) {
+			pr_err("md/raid:%s: journal device is in use, cannot remove it\n",
+			       mdname(mddev));
+			return -EINVAL;
+		}
+	}
+
+	if (log) {
+		mddev_suspend(mddev);
+		conf->log->r5c_state = val;
+		mddev_resume(mddev);
+	}
+
+	if (val == R5C_STATE_NO_CACHE) {
+		clear_bit(MD_HAS_JOURNAL, &mddev->flags);
+		set_bit(MD_UPDATE_SB_FLAGS, &mddev->flags);
+	}
+	pr_info("md/raid:%s: setting r5c cache mode to %d: %s\n",
+		mdname(mddev), val, r5c_state_str[val]);
+	return len;
+}
+
+struct md_sysfs_entry
+r5c_state = __ATTR(r5c_state, S_IRUGO | S_IWUSR,
+		   r5c_state_show, r5c_state_store);
+
 int r5c_handle_stripe_dirtying(struct r5conf *conf,
 			       struct stripe_head *sh,
 			       struct stripe_head_state *s,
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 5977d44..ec51129 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -6297,6 +6297,7 @@ static struct attribute *raid5_attrs[] =  {
 	&raid5_group_thread_cnt.attr,
 	&raid5_skip_copy.attr,
 	&raid5_rmw_level.attr,
+	&r5c_state.attr,
 	NULL,
 };
 static struct attribute_group raid5_attrs_group = {
diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
index d17eed4..6898a76 100644
--- a/drivers/md/raid5.h
+++ b/drivers/md/raid5.h
@@ -758,5 +758,6 @@ extern void r5c_do_reclaim(struct r5conf *conf);
 extern int r5c_flush_cache(struct r5conf *conf, int num);
 extern void r5c_check_stripe_cache_usage(struct r5conf *conf);
 extern void r5c_check_cached_full_stripe(struct r5conf *conf);
+extern struct md_sysfs_entry r5c_state;
 
 #endif
-- 
2.9.3

