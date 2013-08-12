From: Shaohua Li <shli@kernel.org>
Subject: [patch 2/3 v2] raid5: sysfs entry to control worker thread number
Date: Mon, 12 Aug 2013 10:18:05 +0800
Message-ID: <20130812022003.581902627@kernel.org>
References: <20130812021803.325887805@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline; filename=raid5-configure-wq.patch
Sender: linux-kernel-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: neilb@suse.de, djbw@fb.com, tj@kernel.org
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
--- linux.orig/drivers/md/raid5.c	2013-08-12 09:14:06.628380246 +0800
+++ linux/drivers/md/raid5.c	2013-08-12 10:00:34.185337148 +0800
@@ -5141,10 +5141,70 @@ stripe_cache_active_show(struct mddev *m
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
