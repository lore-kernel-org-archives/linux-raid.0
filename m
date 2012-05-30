From: "majianpeng" <majianpeng@gmail.com>
Subject: [PATCH] md:Fix checkpatch issues.
Date: Wed, 30 May 2012 16:54:02 +0800
Message-ID: <201205301653568902535@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

WARNING: simple_strtoul is obsolete, use kstrtoul instead.
WARNING: simple_strtoull is obsolete, use kstrtoull instead.

Signed-off-by: majianpeng <majianpeng@gmail.com>
---
 drivers/md/md.c |  177 ++++++++++++++++++++++++++++++++----------------------
 1 files changed, 105 insertions(+), 72 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 1c2f904..142b028 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -2809,13 +2809,11 @@ errors_show(struct md_rdev *rdev, char *page)
 static ssize_t
 errors_store(struct md_rdev *rdev, const char *buf, size_t len)
 {
-	char *e;
-	unsigned long n = simple_strtoul(buf, &e, 10);
-	if (*buf && (*e == 0 || *e == '\n')) {
-		atomic_set(&rdev->corrected_errors, n);
-		return len;
-	}
-	return -EINVAL;
+	unsigned long n;
+	if (kstrtoul(buf, 10, &n))
+		return -EINVAL;
+	atomic_set(&rdev->corrected_errors, n);
+	return len;
 }
 static struct rdev_sysfs_entry rdev_errors =
 __ATTR(errors, S_IRUGO|S_IWUSR, errors_show, errors_store);
@@ -2832,12 +2830,12 @@ slot_show(struct md_rdev *rdev, char *page)
 static ssize_t
 slot_store(struct md_rdev *rdev, const char *buf, size_t len)
 {
-	char *e;
 	int err;
-	int slot = simple_strtoul(buf, &e, 10);
+	unsigned long slot;
+
 	if (strncmp(buf, "none", 4)==0)
 		slot = -1;
-	else if (e==buf || (*e && *e!= '\n'))
+	else if (kstrtoul(buf, 10, &slot))
 		return -EINVAL;
 	if (rdev->mddev->pers && slot == -1) {
 		/* Setting 'slot' on an active array requires also
@@ -3699,10 +3697,9 @@ layout_show(struct mddev *mddev, char *page)
 static ssize_t
 layout_store(struct mddev *mddev, const char *buf, size_t len)
 {
-	char *e;
-	unsigned long n = simple_strtoul(buf, &e, 10);
+	unsigned long n;
 
-	if (!*buf || (*e && *e != '\n'))
+	if (kstrtoul(buf, 10, &n))
 		return -EINVAL;
 
 	if (mddev->pers) {
@@ -3743,11 +3740,10 @@ static int update_raid_disks(struct mddev *mddev, int raid_disks);
 static ssize_t
 raid_disks_store(struct mddev *mddev, const char *buf, size_t len)
 {
-	char *e;
 	int rv = 0;
-	unsigned long n = simple_strtoul(buf, &e, 10);
+	unsigned long n;
 
-	if (!*buf || (*e && *e != '\n'))
+	if (kstrtoul(buf, 10, &n))
 		return -EINVAL;
 
 	if (mddev->pers)
@@ -3788,10 +3784,9 @@ chunk_size_show(struct mddev *mddev, char *page)
 static ssize_t
 chunk_size_store(struct mddev *mddev, const char *buf, size_t len)
 {
-	char *e;
-	unsigned long n = simple_strtoul(buf, &e, 10);
+	unsigned long n;
 
-	if (!*buf || (*e && *e != '\n'))
+	if (kstrtoul(buf, 10, &n))
 		return -EINVAL;
 
 	if (mddev->pers) {
@@ -3825,14 +3820,13 @@ resync_start_show(struct mddev *mddev, char *page)
 static ssize_t
 resync_start_store(struct mddev *mddev, const char *buf, size_t len)
 {
-	char *e;
-	unsigned long long n = simple_strtoull(buf, &e, 10);
+	unsigned long long n;
 
 	if (mddev->pers && !test_bit(MD_RECOVERY_FROZEN, &mddev->recovery))
 		return -EBUSY;
 	if (cmd_match(buf, "none"))
 		n = MaxSector;
-	else if (!*buf || (*e && *e != '\n'))
+	else if (kstrtoull(buf, 10, &n))
 		return -EINVAL;
 
 	mddev->recovery_cp = n;
@@ -4036,14 +4030,12 @@ max_corrected_read_errors_show(struct mddev *mddev, char *page) {
 static ssize_t
 max_corrected_read_errors_store(struct mddev *mddev, const char *buf, size_t len)
 {
-	char *e;
-	unsigned long n = simple_strtoul(buf, &e, 10);
+	unsigned long n;
+	if (kstrtoul(buf, 10, &n))
+		return -EINVAL;
 
-	if (*buf && (*e == 0 || *e == '\n')) {
-		atomic_set(&mddev->max_corr_read_errors, n);
-		return len;
-	}
-	return -EINVAL;
+	atomic_set(&mddev->max_corr_read_errors, n);
+	return len;
 }
 
 static struct md_sysfs_entry max_corr_read_errors =
@@ -4066,18 +4058,29 @@ new_dev_store(struct mddev *mddev, const char *buf, size_t len)
 	 * Otherwise, only checking done is that in bind_rdev_to_array,
 	 * which mainly checks size.
 	 */
-	char *e;
-	int major = simple_strtoul(buf, &e, 10);
+	char *e, *p;
+	int major;
 	int minor;
 	dev_t dev;
 	struct md_rdev *rdev;
 	int err;
 
-	if (!*buf || *e != ':' || !e[1] || e[1] == '\n')
+	e = kstrdup(buf, GFP_KERNEL);
+	if (e == NULL)
+		return -ENOMEM;
+
+	p = strstr(e, ":");
+	if (p == NULL) {
+		kfree(e);
 		return -EINVAL;
-	minor = simple_strtoul(e+1, &e, 10);
-	if (*e && *e != '\n')
+	}
+	*p = '\0';
+	if (kstrtoint(e, 10, &major) || kstrtoint(p + 1, 10, &minor)) {
+		kfree(e);
 		return -EINVAL;
+	}
+	kfree(e);
+
 	dev = MKDEV(major, minor);
 	if (major != MAJOR(dev) ||
 	    minor != MINOR(dev))
@@ -4116,26 +4119,54 @@ __ATTR(new_dev, S_IWUSR, null_show, new_dev_store);
 static ssize_t
 bitmap_store(struct mddev *mddev, const char *buf, size_t len)
 {
-	char *end;
+	char *end, *tmp = NULL;
 	unsigned long chunk, end_chunk;
 
 	if (!mddev->bitmap)
 		goto out;
+	tmp = kstrdup(buf, GFP_KERNEL);
+	if (tmp == NULL)
+		goto out;
+	end = tmp;
+
 	/* buf should be <chunk> <chunk> ... or <chunk>-<chunk> ... (range) */
-	while (*buf) {
-		chunk = end_chunk = simple_strtoul(buf, &end, 0);
-		if (buf == end) break;
-		if (*end == '-') { /* range */
-			buf = end + 1;
-			end_chunk = simple_strtoul(buf, &end, 0);
-			if (buf == end) break;
+	while (*end) {
+		char *p = strstr(end, "-");
+		char *p1 = strstr(end, " ");
+		if (p == NULL && p1 == NULL) {
+			if (kstrtoul(end, 0, &chunk))
+				break;
+			end_chunk = chunk;
+			*end = '\0';
+		} else if (p != NULL && (p1 == NULL || p < p1)) { /*range */
+			*p = '\0';
+			if (kstrtoul(end, 0, &chunk))
+				break;
+
+			end = p + 1;
+			p = strstr(end, " ");
+			if (p != NULL)
+				*p = '\0';
+
+			if (kstrtoul(end, 0, &end_chunk))
+				break;
+			if (p)
+				end = p + 1;
+			else
+				*end = '\0';
+		} else if (p1 != NULL) {
+			*p1 = '\0';
+			if (kstrtoul(end, 0, &chunk))
+				break;
+			end_chunk = chunk;
+			end = p1 + 1;
 		}
-		if (*end && !isspace(*end)) break;
 		bitmap_dirty_bits(mddev->bitmap, chunk, end_chunk);
-		buf = skip_spaces(end);
+		end = skip_spaces(end);
 	}
 	bitmap_unplug(mddev->bitmap); /* flush the bits to disk */
 out:
+	kfree(tmp);
 	return len;
 }
 
@@ -4202,7 +4233,7 @@ static ssize_t
 metadata_store(struct mddev *mddev, const char *buf, size_t len)
 {
 	int major, minor;
-	char *e;
+	char *e, *tmp;
 	/* Changing the details of 'external' metadata is
 	 * always permitted.  Otherwise there must be
 	 * no devices attached to the array.
@@ -4233,13 +4264,22 @@ metadata_store(struct mddev *mddev, const char *buf, size_t len)
 		mddev->minor_version = 90;
 		return len;
 	}
-	major = simple_strtoul(buf, &e, 10);
-	if (e==buf || *e != '.')
+
+	tmp = kstrdup(buf, GFP_KERNEL);
+	if (tmp == NULL)
+		return -ENOMEM;
+	e = strstr(tmp, ".");
+	if (e == NULL) {
+		kfree(tmp);
 		return -EINVAL;
-	buf = e+1;
-	minor = simple_strtoul(buf, &e, 10);
-	if (e==buf || (*e && *e != '\n') )
+	}
+	*e = '\0';
+	if (kstrtoint(buf, 10, &major) || kstrtoint(e + 1, 10, &minor)) {
+		kfree(tmp);
 		return -EINVAL;
+	}
+	kfree(tmp);
+
 	if (major >= ARRAY_SIZE(super_types) || super_types[major].name == NULL)
 		return -ENOENT;
 	mddev->major_version = major;
@@ -4347,13 +4387,12 @@ static ssize_t
 sync_min_store(struct mddev *mddev, const char *buf, size_t len)
 {
 	int min;
-	char *e;
 	if (strncmp(buf, "system", 6)==0) {
 		mddev->sync_speed_min = 0;
 		return len;
 	}
-	min = simple_strtoul(buf, &e, 10);
-	if (buf == e || (*e && *e != '\n') || min <= 0)
+
+	if (kstrtoint(buf, 10, &min) || min <= 0)
 		return -EINVAL;
 	mddev->sync_speed_min = min;
 	return len;
@@ -4373,13 +4412,11 @@ static ssize_t
 sync_max_store(struct mddev *mddev, const char *buf, size_t len)
 {
 	int max;
-	char *e;
 	if (strncmp(buf, "system", 6)==0) {
 		mddev->sync_speed_max = 0;
 		return len;
 	}
-	max = simple_strtoul(buf, &e, 10);
-	if (buf == e || (*e && *e != '\n') || max <= 0)
+	if (kstrtoint(buf, 10, &max) || max <= 0)
 		return -EINVAL;
 	mddev->sync_speed_max = max;
 	return len;
@@ -4540,14 +4577,14 @@ suspend_lo_show(struct mddev *mddev, char *page)
 static ssize_t
 suspend_lo_store(struct mddev *mddev, const char *buf, size_t len)
 {
-	char *e;
-	unsigned long long new = simple_strtoull(buf, &e, 10);
+	unsigned long long new;
 	unsigned long long old = mddev->suspend_lo;
 
 	if (mddev->pers == NULL || 
 	    mddev->pers->quiesce == NULL)
 		return -EINVAL;
-	if (buf == e || (*e && *e != '\n'))
+
+	if (kstrtoull(buf, 10, &new))
 		return -EINVAL;
 
 	mddev->suspend_lo = new;
@@ -4574,14 +4611,13 @@ suspend_hi_show(struct mddev *mddev, char *page)
 static ssize_t
 suspend_hi_store(struct mddev *mddev, const char *buf, size_t len)
 {
-	char *e;
-	unsigned long long new = simple_strtoull(buf, &e, 10);
+	unsigned long long new;
 	unsigned long long old = mddev->suspend_hi;
 
 	if (mddev->pers == NULL ||
 	    mddev->pers->quiesce == NULL)
 		return -EINVAL;
-	if (buf == e || (*e && *e != '\n'))
+	if (kstrtoull(buf, 10, &new))
 		return -EINVAL;
 
 	mddev->suspend_hi = new;
@@ -4612,11 +4648,10 @@ static ssize_t
 reshape_position_store(struct mddev *mddev, const char *buf, size_t len)
 {
 	struct md_rdev *rdev;
-	char *e;
-	unsigned long long new = simple_strtoull(buf, &e, 10);
+	unsigned long long new;
 	if (mddev->pers)
 		return -EBUSY;
-	if (buf == e || (*e && *e != '\n'))
+	if (kstrtoull(buf, 10, &new))
 		return -EINVAL;
 	mddev->reshape_position = new;
 	mddev->delta_disks = 0;
@@ -8584,13 +8619,11 @@ static int get_ro(char *buffer, struct kernel_param *kp)
 }
 static int set_ro(const char *val, struct kernel_param *kp)
 {
-	char *e;
-	int num = simple_strtoul(val, &e, 10);
-	if (*val && (*e == '\0' || *e == '\n')) {
-		start_readonly = num;
-		return 0;
-	}
-	return -EINVAL;
+	int num;
+	if (kstrtoint(val, 10, &num))
+		return -EINVAL;
+	start_readonly = num;
+	return 0;
 }
 
 module_param_call(start_ro, set_ro, get_ro, NULL, S_IRUSR|S_IWUSR);
-- 
1.7.5.4

 				
--------------
majianpeng
2012-05-30

