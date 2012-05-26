From: "majianpeng" <majianpeng@gmail.com>
Subject: [PATCH 2/2] md/raid456:Add interface for contorling eject rdev when re-write failed.
Date: Sat, 26 May 2012 10:54:50 +0800
Message-ID: <201205261054481872245@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

When RAID-4/5/6 readed fail and if raid did not degrade,it will
compute,re-write and re-read.If re-read error,it will to eject the rdev.
If so, raid will recovery.
At present,disks are larger,so recovery will take a long time.
It will increasing the opportunity to become failed.
So add a interface using sysfs,to control the number of max re-write
errors.
The default value is zero,as the origin action which met re-write
error to eject the rdev.

Signed-off-by: majianpeng <majianpeng@gmail.com>
---
 drivers/md/md.c    |   35 +++++++++++++++++++++++++++++++++++
 drivers/md/md.h    |    2 ++
 drivers/md/raid5.c |   20 ++++++++++++--------
 3 files changed, 49 insertions(+), 8 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 1c2f904..cd399ec 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -81,6 +81,13 @@ static struct workqueue_struct *md_misc_wq;
  */
 #define MD_DEFAULT_MAX_CORRECTED_READ_ERRORS 20
 /*
+ * Current RAID-4,5,6 read failed and then try to compter and rewrite,
+ * reread,if raid did not degrad.But when reread failed,we'll set
+ * badsector before ejecting it from array.
+ * By default if reread failed, we'll eject the rdev.
+ */
+#define MD_DEFAULT_MAX_UNCORRECTED_READ_ERRORS 0
+/*
  * Current RAID-1,4,5 parallel reconstruction 'guaranteed speed limit'
  * is 1000 KB/sec, so the extra system load does not show up that much.
  * Increase it if you want to have more _guaranteed_ speed. Note that
@@ -3260,6 +3267,7 @@ int md_rdev_init(struct md_rdev *rdev)
 	atomic_set(&rdev->nr_pending, 0);
 	atomic_set(&rdev->read_errors, 0);
 	atomic_set(&rdev->corrected_errors, 0);
+	atomic_set(&rdev->uncorrected_errors, 0);
 
 	INIT_LIST_HEAD(&rdev->same_set);
 	init_waitqueue_head(&rdev->blocked_wait);
@@ -4051,6 +4059,30 @@ __ATTR(max_read_errors, S_IRUGO|S_IWUSR, max_corrected_read_errors_show,
 	max_corrected_read_errors_store);
 
 static ssize_t
+max_uncorrected_read_errors_show(struct mddev *mddev, char *page) {
+	return sprintf(page, "%d\n",
+		atomic_read(&mddev->max_uncorr_read_errors));
+}
+
+static ssize_t
+max_uncorrected_read_errors_store(struct mddev *mddev, const char *buf, size_t len)
+{
+	char *e;
+	unsigned long n = simple_strtoul(buf, &e, 10);
+
+	if (*buf && (*e == 0 || *e == '\n')) {
+		atomic_set(&mddev->max_uncorr_read_errors, n);
+		return len;
+	}
+	return -EINVAL;
+}
+
+static struct md_sysfs_entry max_uncorr_read_errors =
+__ATTR(max_uncorr_read_errors, S_IRUGO|S_IWUSR,
+	max_uncorrected_read_errors_show,
+	max_uncorrected_read_errors_store);
+
+static ssize_t
 null_show(struct mddev *mddev, char *page)
 {
 	return -EINVAL;
@@ -4744,6 +4776,7 @@ static struct attribute *md_redundancy_attrs[] = {
 	&md_suspend_hi.attr,
 	&md_bitmap.attr,
 	&md_degraded.attr,
+	&max_uncorr_read_errors.attr,
 	NULL,
 };
 static struct attribute_group md_redundancy_group = {
@@ -5166,6 +5199,8 @@ int md_run(struct mddev *mddev)
  	atomic_set(&mddev->writes_pending,0);
 	atomic_set(&mddev->max_corr_read_errors,
 		   MD_DEFAULT_MAX_CORRECTED_READ_ERRORS);
+	atomic_set(&mddev->max_uncorr_read_errors,
+		   MD_DEFAULT_MAX_UNCORRECTED_READ_ERRORS);
 	mddev->safemode = 0;
 	mddev->safemode_timer.function = md_safemode_timeout;
 	mddev->safemode_timer.data = (unsigned long) mddev;
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 7b4a3c3..4a9ee85 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -104,6 +104,7 @@ struct md_rdev {
 					   * for reporting to userspace and storing
 					   * in superblock.
 					   */
+	atomic_t	uncorrected_errors;
 	struct work_struct del_work;	/* used for delayed sysfs removal */
 
 	struct sysfs_dirent *sysfs_state; /* handle for 'state'
@@ -408,6 +409,7 @@ struct mddev {
 	} bitmap_info;
 
 	atomic_t 			max_corr_read_errors; /* max read retries */
+	atomic_t			max_uncorr_read_errors;
 	struct list_head		all_mddevs;
 
 	struct attribute_group		*to_remove;
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 89cfd73..6a5faad 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -1758,17 +1758,21 @@ static void raid5_end_read_request(struct bio * bi, int error)
 				mdname(conf->mddev),
 				(unsigned long long)s,
 				bdn);
-		}
-		else if (test_bit(R5_ReWrite, &sh->dev[i].flags))
-			/* Oh, no!!! */
-			printk_ratelimited(
-				KERN_WARNING
+		} else if (test_bit(R5_ReWrite, &sh->dev[i].flags)) {
+			 printk_ratelimited(KERN_WARNING
 				"md/raid:%s: read error NOT corrected!! "
 				"(sector %llu on %s).\n",
 				mdname(conf->mddev),
-				(unsigned long long)s,
-				bdn);
-		else if (atomic_read(&rdev->read_errors)
+				(unsigned long long)s, bdn);
+			if (atomic_inc_return(&rdev->uncorrected_errors)
+				 < atomic_read(&(conf->mddev->max_uncorr_read_errors)))
+				set_bad = 1;
+			else
+				printk(KERN_WARNING
+				"md/raid:%s: Too much read error not corrected, "
+				"failing device %s.\n",
+				mdname(conf->mddev), bdn);
+		} else if (atomic_read(&rdev->read_errors)
 			 > conf->max_nr_stripes)
 			printk(KERN_WARNING
 			       "md/raid:%s: Too many read errors, failing device %s.\n",
-- 
1.7.5.4

 				
--------------
majianpeng
2012-05-26

