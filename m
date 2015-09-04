From: Song Liu <songliubraving@fb.com>
Subject: [PATCH] enable bypass raid5 journal for full stripe writes
Date: Thu, 3 Sep 2015 23:01:27 -0700
Message-ID: <1441346487-4011056-1-git-send-email-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: shli@fb.com, neilb@suse.de, hch@infradead.org, dan.j.williams@intel.com, hch@lst.de, Kernel-team@fb.com, Song Liu <songliubraving@fb.com>
List-Id: linux-raid.ids

Summary:
To save life time of journal device, we can config the device to
bypass journal writes for full stripe write. This is configured by:

echo "yes" > /sys/block/mdX/md/r5l_bypass_full_stripe

and

echo "no" > /sys/block/mdX/md/r5l_bypass_full_stripe

For file system integrity, full stripe with REQ_FUA will still
write to journal first.

This patch applies on top of Shaohua's most recent patches:

http://marc.info/?l=linux-raid&m=144122700510667

Signed-off-by: Song Liu <songliubraving@fb.com>
Reviewed-by: Shaohua Li <shli@fb.com>
---
 drivers/md/raid5-cache.c | 20 +++++++++++++++++
 drivers/md/raid5.c       | 56 ++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/md/raid5.h       |  2 ++
 3 files changed, 78 insertions(+)

diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index 410b85b..0c3ddc5 100644
--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -82,6 +82,8 @@ struct r5l_log {
 
 	struct list_head no_space_stripes; /* pending stripes, log has no space */
 	spinlock_t no_space_stripes_lock;
+
+	int bypass_full_stripe;
 };
 
 /*
@@ -438,6 +440,7 @@ int r5l_write_stripe(struct r5l_log *log, struct stripe_head *sh)
 	int meta_size;
 	int reserve;
 	int i;
+	int fua = 0;
 
 	if (!log)
 		return -EAGAIN;
@@ -453,6 +456,8 @@ int r5l_write_stripe(struct r5l_log *log, struct stripe_head *sh)
 		void *addr;
 		if (!test_bit(R5_Wantwrite, &sh->dev[i].flags))
 			continue;
+		if (test_bit(R5_WantFUA, &sh->dev[i].flags))
+			fua = 1;
 		write_disks++;
 		/* checksum is already calculated in last run */
 		if (test_bit(STRIPE_LOG_TRAPPED, &sh->state))
@@ -462,6 +467,10 @@ int r5l_write_stripe(struct r5l_log *log, struct stripe_head *sh)
 				addr, PAGE_SIZE);
 		kunmap_atomic(addr);
 	}
+
+	if (log->bypass_full_stripe && (write_disks == sh->disks) && (!fua))
+		return -EAGAIN;   /* bypass journal device */
+
 	parity_pages = 1 + !!(sh->qd_idx >= 0);
 	data_pages = write_disks - parity_pages;
 
@@ -520,6 +529,16 @@ int r5l_handle_flush_request(struct r5l_log *log, struct bio *bio)
 	return -EAGAIN;
 }
 
+int r5l_get_bypass_full_stripe(struct r5l_log *log)
+{
+	return log->bypass_full_stripe;
+}
+
+void r5l_set_bypass_full_stripe(struct r5l_log *log, int val)
+{
+	log->bypass_full_stripe = val;
+}
+
 /* This will run after log space is reclaimed */
 static void r5l_run_no_space_stripes(struct r5l_log *log)
 {
@@ -1105,6 +1124,7 @@ int r5l_init_log(struct r5conf *conf, struct md_rdev *rdev)
 	if (!log->io_kc)
 		goto io_kc;
 
+	log->bypass_full_stripe = 0;
 	log->reclaim_thread = md_register_thread(r5l_reclaim_thread,
 		log->rdev->mddev, "reclaim");
 	if (!log->reclaim_thread)
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 394cdf8..5781987 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -6223,6 +6223,61 @@ raid5_group_thread_cnt = __ATTR(group_thread_cnt, S_IRUGO | S_IWUSR,
 				raid5_show_group_thread_cnt,
 				raid5_store_group_thread_cnt);
 
+static ssize_t
+r5l_show_bypass_full_stripe(struct mddev *mddev, char *page)
+{
+	struct r5conf *conf;
+	int ret = 0;
+
+	spin_lock(&mddev->lock);
+	conf = mddev->private;
+	if (conf) {
+		if (conf->log)
+			ret = sprintf(page, "%s\n",
+				      r5l_get_bypass_full_stripe(conf->log) ? "yes" : "no");
+		else
+			ret = sprintf(page, "n/a\n");
+	}
+	spin_unlock(&mddev->lock);
+	return ret;
+}
+
+static ssize_t
+r5l_store_bypass_full_stripe(struct mddev *mddev, const char *page, size_t len)
+{
+	struct r5conf *conf;
+	int err = 0;
+	int val;
+
+	if (strncmp(page, "yes", 3) == 0 &&
+	    (page[3] == '\n' || page[3] == '\0'))
+		val = 1;
+	else if (strncmp(page, "no", 2) == 0 &&
+	    (page[2] == '\n' || page[2] == '\0'))
+		val = 0;
+	else
+		return -EINVAL;
+
+	mddev_suspend(mddev);
+	spin_lock(&mddev->lock);
+	conf = mddev->private;
+	if (conf) {
+		if (conf->log) {
+			r5l_set_bypass_full_stripe(conf->log, val);
+		} else
+			err = -EINVAL;
+	} else
+		err = -ENODEV;
+	spin_unlock(&mddev->lock);
+	mddev_resume(mddev);
+	return err ?: len;
+}
+
+static struct md_sysfs_entry
+r5l_bypass_full_stripe = __ATTR(r5l_bypass_full_stripe, S_IRUGO | S_IWUSR,
+				r5l_show_bypass_full_stripe,
+				r5l_store_bypass_full_stripe);
+
 static struct attribute *raid5_attrs[] =  {
 	&raid5_stripecache_size.attr,
 	&raid5_stripecache_active.attr,
@@ -6230,6 +6285,7 @@ static struct attribute *raid5_attrs[] =  {
 	&raid5_group_thread_cnt.attr,
 	&raid5_skip_copy.attr,
 	&raid5_rmw_level.attr,
+	&r5l_bypass_full_stripe.attr,
 	NULL,
 };
 static struct attribute_group raid5_attrs_group = {
diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
index e6b9a40..c1f6935 100644
--- a/drivers/md/raid5.h
+++ b/drivers/md/raid5.h
@@ -630,4 +630,6 @@ extern void r5l_write_stripe_run(struct r5l_log *log);
 extern void r5l_flush_stripe_to_raid(struct r5l_log *log);
 extern void r5l_stripe_write_finished(struct stripe_head *sh);
 extern int r5l_handle_flush_request(struct r5l_log *log, struct bio *bio);
+extern int r5l_get_bypass_full_stripe(struct r5l_log *log);
+extern void r5l_set_bypass_full_stripe(struct r5l_log *log, int val);
 #endif
-- 
1.8.1

