From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 18/22] raid: improve MD/raid10 handling of correctable read
	errors.
Date: Fri, 04 Dec 2009 17:48:02 +1100
Message-ID: <20091204064802.10264.82487.stgit@notabene.brown>
References: <20091204064559.10264.37619.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20091204064559.10264.37619.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Robert Becker <Rob.Becker@riverbed.com>
List-Id: linux-raid.ids

From: Robert Becker <Rob.Becker@riverbed.com>

We've noticed severe lasting performance degradation of our raid
arrays when we have drives that yield large amounts of media errors.
The raid10 module will queue each failed read for retry, and also
will attempt call fix_read_error() to perform the read recovery.
Read recovery is performed while the array is frozen, so repeated
recovery attempts can degrade the performance of the array for
extended periods of time.

With this patch I propose adding a per md device max number of
corrected read attempts.  Each rdev will maintain a count of
read correction attempts in the rdev->read_errors field (not
used currently for raid10). When we enter fix_read_error()
we'll check to see when the last read error occurred, and
divide the read error count by 2 for every hour since the
last read error. If at that point our read error count
exceeds the read error threshold, we'll fail the raid device.

In addition in this patch I add sysfs nodes (get/set) for
the per md max_read_errors attribute, the rdev->read_errors
attribute, and added some printk's to indicate when
fix_read_error fails to repair an rdev.

For testing I used debugfs->fail_make_request to inject
IO errors to the rdev while doing IO to the raid array.

Signed-off-by: Robert Becker <Rob.Becker@riverbed.com>
Signed-off-by: NeilBrown <neilb@suse.de>
---
 drivers/md/md.c     |   34 +++++++++++++++++++++++
 drivers/md/md.h     |    4 +++
 drivers/md/raid10.c |   74 +++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 112 insertions(+), 0 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index fbff790..0ebd6b6 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -68,6 +68,12 @@ static DECLARE_WAIT_QUEUE_HEAD(resync_wait);
 #define MD_BUG(x...) { printk("md: bug in file %s, line %d\n", __FILE__, __LINE__); md_print_devices(); }
 
 /*
+ * Default number of read corrections we'll attempt on an rdev
+ * before ejecting it from the array. We divide the read error
+ * count by 2 for every hour elapsed between read errors.
+ */
+#define MD_DEFAULT_MAX_CORRECTED_READ_ERRORS 20
+/*
  * Current RAID-1,4,5 parallel reconstruction 'guaranteed speed limit'
  * is 1000 KB/sec, so the extra system load does not show up that much.
  * Increase it if you want to have more _guaranteed_ speed. Note that
@@ -2668,6 +2674,8 @@ static mdk_rdev_t *md_import_device(dev_t newdev, int super_format, int super_mi
 	rdev->flags = 0;
 	rdev->data_offset = 0;
 	rdev->sb_events = 0;
+	rdev->last_read_error.tv_sec  = 0;
+	rdev->last_read_error.tv_nsec = 0;
 	atomic_set(&rdev->nr_pending, 0);
 	atomic_set(&rdev->read_errors, 0);
 	atomic_set(&rdev->corrected_errors, 0);
@@ -3285,6 +3293,29 @@ static struct md_sysfs_entry md_array_state =
 __ATTR(array_state, S_IRUGO|S_IWUSR, array_state_show, array_state_store);
 
 static ssize_t
+max_corrected_read_errors_show(mddev_t *mddev, char *page) {
+	return sprintf(page, "%d\n",
+		       atomic_read(&mddev->max_corr_read_errors));
+}
+
+static ssize_t
+max_corrected_read_errors_store(mddev_t *mddev, const char *buf, size_t len)
+{
+	char *e;
+	unsigned long n = simple_strtoul(buf, &e, 10);
+
+	if (*buf && (*e == 0 || *e == '\n')) {
+		atomic_set(&mddev->max_corr_read_errors, n);
+		return len;
+	}
+	return -EINVAL;
+}
+
+static struct md_sysfs_entry max_corr_read_errors =
+__ATTR(max_read_errors, S_IRUGO|S_IWUSR, max_corrected_read_errors_show,
+	max_corrected_read_errors_store);
+
+static ssize_t
 null_show(mddev_t *mddev, char *page)
 {
 	return -EINVAL;
@@ -3909,6 +3940,7 @@ static struct attribute *md_default_attrs[] = {
 	&md_array_state.attr,
 	&md_reshape_position.attr,
 	&md_array_size.attr,
+	&max_corr_read_errors.attr,
 	NULL,
 };
 
@@ -4328,6 +4360,8 @@ static int do_md_run(mddev_t * mddev)
 		mddev->ro = 0;
 
  	atomic_set(&mddev->writes_pending,0);
+	atomic_set(&mddev->max_corr_read_errors,
+		   MD_DEFAULT_MAX_CORRECTED_READ_ERRORS);
 	mddev->safemode = 0;
 	mddev->safemode_timer.function = md_safemode_timeout;
 	mddev->safemode_timer.data = (unsigned long) mddev;
diff --git a/drivers/md/md.h b/drivers/md/md.h
index b74b05d..3e94232 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -97,6 +97,9 @@ struct mdk_rdev_s
 	atomic_t	read_errors;	/* number of consecutive read errors that
 					 * we have tried to ignore.
 					 */
+	struct timespec last_read_error;	/* monotonic time since our
+						 * last read error
+						 */
 	atomic_t	corrected_errors; /* number of corrected read errors,
 					   * for reporting to userspace and storing
 					   * in superblock.
@@ -297,6 +300,7 @@ struct mddev_s
 		unsigned long		max_write_behind; /* write-behind mode */
 		int			external;
 	} bitmap_info;
+	atomic_t 			max_corr_read_errors; /* max read retries */
 	struct list_head		all_mddevs;
 
 	/* Generic barrier handling.
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 670449f..5c71a46 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1432,6 +1432,43 @@ static void recovery_request_write(mddev_t *mddev, r10bio_t *r10_bio)
 
 
 /*
+ * Used by fix_read_error() to decay the per rdev read_errors.
+ * We halve the read error count for every hour that has elapsed
+ * since the last recorded read error.
+ *
+ */
+static void check_decay_read_errors(mddev_t *mddev, mdk_rdev_t *rdev)
+{
+	struct timespec cur_time_mon;
+	unsigned long hours_since_last;
+	unsigned int read_errors = atomic_read(&rdev->read_errors);
+
+	ktime_get_ts(&cur_time_mon);
+
+	if (rdev->last_read_error.tv_sec == 0 &&
+	    rdev->last_read_error.tv_nsec == 0) {
+		/* first time we've seen a read error */
+		rdev->last_read_error = cur_time_mon;
+		return;
+	}
+
+	hours_since_last = (cur_time_mon.tv_sec -
+			    rdev->last_read_error.tv_sec) / 3600;
+
+	rdev->last_read_error = cur_time_mon;
+
+	/*
+	 * if hours_since_last is > the number of bits in read_errors
+	 * just set read errors to 0. We do this to avoid
+	 * overflowing the shift of read_errors by hours_since_last.
+	 */
+	if (hours_since_last >= 8 * sizeof(read_errors))
+		atomic_set(&rdev->read_errors, 0);
+	else
+		atomic_set(&rdev->read_errors, read_errors >> hours_since_last);
+}
+
+/*
  * This is a kernel thread which:
  *
  *	1.	Retries failed read operations on working mirrors.
@@ -1444,6 +1481,43 @@ static void fix_read_error(conf_t *conf, mddev_t *mddev, r10bio_t *r10_bio)
 	int sect = 0; /* Offset from r10_bio->sector */
 	int sectors = r10_bio->sectors;
 	mdk_rdev_t*rdev;
+	int max_read_errors = atomic_read(&mddev->max_corr_read_errors);
+
+	rcu_read_lock();
+	{
+		int d = r10_bio->devs[r10_bio->read_slot].devnum;
+		char b[BDEVNAME_SIZE];
+		int cur_read_error_count = 0;
+
+		rdev = rcu_dereference(conf->mirrors[d].rdev);
+		bdevname(rdev->bdev, b);
+
+		if (test_bit(Faulty, &rdev->flags)) {
+			rcu_read_unlock();
+			/* drive has already been failed, just ignore any
+			   more fix_read_error() attempts */
+			return;
+		}
+
+		check_decay_read_errors(mddev, rdev);
+		atomic_inc(&rdev->read_errors);
+		cur_read_error_count = atomic_read(&rdev->read_errors);
+		if (cur_read_error_count > max_read_errors) {
+			rcu_read_unlock();
+			printk(KERN_NOTICE
+			       "raid10: %s: Raid device exceeded "
+			       "read_error threshold "
+			       "[cur %d:max %d]\n",
+			       b, cur_read_error_count, max_read_errors);
+			printk(KERN_NOTICE
+			       "raid10: %s: Failing raid "
+			       "device\n", b);
+			md_error(mddev, conf->mirrors[d].rdev);
+			return;
+		}
+	}
+	rcu_read_unlock();
+
 	while(sectors) {
 		int s = sectors;
 		int sl = r10_bio->read_slot;


