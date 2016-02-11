From: Song Liu <songliubraving@fb.com>
Subject: [PATCH 2/2] enable bypass raid5 journal for full stripe writes
Date: Wed, 10 Feb 2016 16:53:15 -0800
Message-ID: <1455151995-240805-2-git-send-email-songliubraving@fb.com>
References: <1455151995-240805-1-git-send-email-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1455151995-240805-1-git-send-email-songliubraving@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: dan.j.williams@intel.com, shli@fb.com, hch@infradead.org, kernel-team@fb.com, Song Liu <songliubraving@fb.com>
List-Id: linux-raid.ids

Summary:

Resending the patch to see whether we can get another chance...

When testing current SATA SSDs as the journal device, we have
seen 2 challenges: throughput of long sequential writes, and
SSD life time.

To ease the burn on the SSD, we tested bypassing journal for
full stripe writes. We understand that bypassing journal will
re-introduce write hole to the md layer. However, with
well-designed application and file system, such write holes
should not result in any data loss.

Our test systems have 2 RAID-6 array per server and 15 HDDs
per array. These 2 arrays shared 1 SSD as the journal (2
partitions). Btrfs is created on both array.

For squential write benchmarks, we observe significant
performance gain (250MB/s per volume vs. 150M/s) from
bypassing journal for full stripes.

We all performed power cycle tests on these systems while
running a write workload. For more than 50 power cycles,
we have seen zero data loss.

To configure the bypass feature:

echo 1 > /sys/block/mdX/md/r5l_bypass_full_stripe

and

echo 0 > /sys/block/mdX/md/r5l_bypass_full_stripe

For file system integrity, the code does not bypass any write
with REQ_FUA.

Signed-off-by: Song Liu <songliubraving@fb.com>
Signed-off-by: Shaohua Li <shli@fb.com>
---
 drivers/md/raid5-cache.c | 75 +++++++++++++++++++++++++++++++++++++++++++++++-
 drivers/md/raid5.c       |  1 +
 drivers/md/raid5.h       |  2 ++
 3 files changed, 77 insertions(+), 1 deletion(-)

diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index 9531f5f..9ec0878 100644
--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -97,6 +97,8 @@ struct r5l_log {
 
 	bool need_cache_flush;
 	bool in_teardown;
+
+	int bypass_full_stripe;
 };
 
 /*
@@ -446,6 +448,7 @@ int r5l_write_stripe(struct r5l_log *log, struct stripe_head *sh)
 	int reserve;
 	int i;
 	int ret = 0;
+	int fua = 0;
 
 	if (!log)
 		return -EAGAIN;
@@ -462,6 +465,8 @@ int r5l_write_stripe(struct r5l_log *log, struct stripe_head *sh)
 
 		if (!test_bit(R5_Wantwrite, &sh->dev[i].flags))
 			continue;
+		if (test_bit(R5_WantFUA, &sh->dev[i].flags))
+			fua = 1;
 		write_disks++;
 		/* checksum is already calculated in last run */
 		if (test_bit(STRIPE_LOG_TRAPPED, &sh->state))
@@ -471,6 +476,10 @@ int r5l_write_stripe(struct r5l_log *log, struct stripe_head *sh)
 						    addr, PAGE_SIZE);
 		kunmap_atomic(addr);
 	}
+
+	if (log->bypass_full_stripe && (write_disks == sh->disks) && (!fua))
+		return -EAGAIN;   /* bypass journal device */
+
 	parity_pages = 1 + !!(sh->qd_idx >= 0);
 	data_pages = write_disks - parity_pages;
 
@@ -524,7 +533,7 @@ void r5l_write_stripe_run(struct r5l_log *log)
 
 int r5l_handle_flush_request(struct r5l_log *log, struct bio *bio)
 {
-	if (!log)
+	if (!log || log->bypass_full_stripe)
 		return -ENODEV;
 	/*
 	 * we flush log disk cache first, then write stripe data to raid disks.
@@ -1186,6 +1195,69 @@ ioerr:
 	return ret;
 }
 
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
+			ret = sprintf(page, "%d\n",
+				      conf->log->bypass_full_stripe);
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
+	unsigned int val;
+
+	if (len >= PAGE_SIZE)
+		return -EINVAL;
+	if (kstrtouint(page, 10, &val))
+		return -EINVAL;
+
+	if (val > 1)
+		val = 1;
+
+	err = mddev_lock(mddev);
+	if (err)
+		return err;
+	mddev_suspend(mddev);
+
+	/*
+	 * We do not flush when journal is on, add extra flush for previous writes
+	 */
+	if (val == 0)
+		md_flush_request(mddev, NULL);
+
+	conf = mddev->private;
+	if (conf) {
+		if (conf->log) {
+			conf->log->bypass_full_stripe = val;
+		} else
+			err = -EINVAL;
+	} else
+		err = -ENODEV;
+	mddev_resume(mddev);
+	mddev_unlock(mddev);
+	return err ?: len;
+}
+
+struct md_sysfs_entry
+r5l_bypass_full_stripe = __ATTR(r5l_bypass_full_stripe, S_IRUGO | S_IWUSR,
+				r5l_show_bypass_full_stripe,
+				r5l_store_bypass_full_stripe);
+
 int r5l_init_log(struct r5conf *conf, struct md_rdev *rdev)
 {
 	struct r5l_log *log;
@@ -1227,6 +1299,7 @@ int r5l_init_log(struct r5conf *conf, struct md_rdev *rdev)
 	if (!log->meta_pool)
 		goto out_mempool;
 
+	log->bypass_full_stripe = 0;
 	log->reclaim_thread = md_register_thread(r5l_reclaim_thread,
 						 log->rdev->mddev, "reclaim");
 	if (!log->reclaim_thread)
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index b4f02c9..bdf30b1 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -6216,6 +6216,7 @@ static struct attribute *raid5_attrs[] =  {
 	&raid5_group_thread_cnt.attr,
 	&raid5_skip_copy.attr,
 	&raid5_rmw_level.attr,
+	&r5l_bypass_full_stripe.attr,
 	NULL,
 };
 static struct attribute_group raid5_attrs_group = {
diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
index a415e1c..6b39a07 100644
--- a/drivers/md/raid5.h
+++ b/drivers/md/raid5.h
@@ -633,4 +633,6 @@ extern void r5l_stripe_write_finished(struct stripe_head *sh);
 extern int r5l_handle_flush_request(struct r5l_log *log, struct bio *bio);
 extern void r5l_quiesce(struct r5l_log *log, int state);
 extern bool r5l_log_disk_error(struct r5conf *conf);
+
+extern struct md_sysfs_entry r5l_bypass_full_stripe;
 #endif
-- 
2.4.6

