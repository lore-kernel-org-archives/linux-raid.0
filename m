From: Shaohua Li <shli@kernel.org>
Subject: [patch v3 4/5] raid5: sysfs entry to control worker thread number
Date: Tue, 27 Aug 2013 17:50:42 +0800
Message-ID: <20130827095506.354369166@kernel.org>
References: <20130827095038.303090029@kernel.org>
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline; filename=raid5-configure-wq.patch
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.de, tj@kernel.org, dan.j.williams@gmail.com
List-Id: linux-raid.ids

Add a sysfs entry to control running workqueue thread number. If
group_thread_cnt is set to 0, we will disable workqueue offload handling of
stripes.

Signed-off-by: Shaohua Li <shli@fusionio.com>
---
 drivers/md/raid5.c |   60 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 60 insertions(+)

Index: linux/drivers/md/raid5.c
===================================================================
--- linux.orig/drivers/md/raid5.c	2013-08-27 17:14:52.910179844 +0800
+++ linux/drivers/md/raid5.c	2013-08-27 17:14:52.906179906 +0800
@@ -5146,10 +5146,70 @@ stripe_cache_active_show(struct mddev *m
 static struct md_sysfs_entry
 raid5_stripecache_active = __ATTR_RO(stripe_cache_active);
 
+static ssize_t
+raid5_show_group_thread_cnt(struct mddev *mddev, char *page)
+{
+	struct r5conf *conf = mddev->private;
+	if (conf)
+		return sprintf(page, "%d\n", conf->worker_cnt_per_group);
+	else
+		return 0;
+}
+
+static int alloc_thread_groups(struct r5conf *conf, int cnt);
+static ssize_t
+raid5_store_group_thread_cnt(struct mddev *mddev, const char *page, size_t len)
+{
+	struct r5conf *conf = mddev->private;
+	unsigned long new;
+	int err;
+	struct r5worker_group *old_groups;
+	int old_group_cnt;
+
+	if (len >= PAGE_SIZE)
+		return -EINVAL;
+	if (!conf)
+		return -ENODEV;
+
+	if (kstrtoul(page, 10, &new))
+		return -EINVAL;
+
+	if (new == conf->worker_cnt_per_group)
+		return len;
+
+	mddev_suspend(mddev);
+
+	old_groups = conf->worker_groups;
+	old_group_cnt = conf->worker_cnt_per_group;
+
+	conf->worker_groups = NULL;
+	err = alloc_thread_groups(conf, new);
+	if (err) {
+		conf->worker_groups = old_groups;
+		conf->worker_cnt_per_group = old_group_cnt;
+	} else {
+		if (old_groups)
+			kfree(old_groups[0].workers);
+		kfree(old_groups);
+	}
+
+	mddev_resume(mddev);
+
+	if (err)
+		return err;
+	return len;
+}
+
+static struct md_sysfs_entry
+raid5_group_thread_cnt = __ATTR(group_thread_cnt, S_IRUGO | S_IWUSR,
+				raid5_show_group_thread_cnt,
+				raid5_store_group_thread_cnt);
+
 static struct attribute *raid5_attrs[] =  {
 	&raid5_stripecache_size.attr,
 	&raid5_stripecache_active.attr,
 	&raid5_preread_bypass_threshold.attr,
+	&raid5_group_thread_cnt.attr,
 	NULL,
 };
 static struct attribute_group raid5_attrs_group = {

