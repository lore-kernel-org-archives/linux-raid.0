From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH] md: convert to kstrto*()
Date: Sat, 16 May 2015 14:02:38 +0300
Message-ID: <20150516110238.GA32480@p183.telecom.by>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Convert away from deprecated simple_strto*() functions.

Add "fit into sector_t" checks.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 drivers/md/md.c |  149 ++++++++++++++++++++++++++++++--------------------------
 1 file changed, 81 insertions(+), 68 deletions(-)

--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -2630,13 +2630,14 @@ errors_show(struct md_rdev *rdev, char *page)
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
+	unsigned int n;
+	int rv;
+
+	rv = kstrtouint(buf, 10, &n);
+	if (rv < 0)
+		return rv;
+	atomic_set(&rdev->corrected_errors, n);
+	return len;
 }
 static struct rdev_sysfs_entry rdev_errors =
 __ATTR(errors, S_IRUGO|S_IWUSR, errors_show, errors_store);
@@ -2653,13 +2654,16 @@ slot_show(struct md_rdev *rdev, char *page)
 static ssize_t
 slot_store(struct md_rdev *rdev, const char *buf, size_t len)
 {
-	char *e;
+	int slot;
 	int err;
-	int slot = simple_strtoul(buf, &e, 10);
+
 	if (strncmp(buf, "none", 4)==0)
 		slot = -1;
-	else if (e==buf || (*e && *e!= '\n'))
-		return -EINVAL;
+	else {
+		err = kstrtouint(buf, 10, (unsigned int *)&slot);
+		if (err < 0)
+			return err;
+	}
 	if (rdev->mddev->pers && slot == -1) {
 		/* Setting 'slot' on an active array requires also
 		 * updating the 'rd%d' link, and communicating
@@ -3544,12 +3548,12 @@ layout_show(struct mddev *mddev, char *page)
 static ssize_t
 layout_store(struct mddev *mddev, const char *buf, size_t len)
 {
-	char *e;
-	unsigned long n = simple_strtoul(buf, &e, 10);
+	unsigned int n;
 	int err;
 
-	if (!*buf || (*e && *e != '\n'))
-		return -EINVAL;
+	err = kstrtouint(buf, 10, &n);
+	if (err < 0)
+		return err;
 	err = mddev_lock(mddev);
 	if (err)
 		return err;
@@ -3593,12 +3597,12 @@ static int update_raid_disks(struct mddev *mddev, int raid_disks);
 static ssize_t
 raid_disks_store(struct mddev *mddev, const char *buf, size_t len)
 {
-	char *e;
+	unsigned int n;
 	int err;
-	unsigned long n = simple_strtoul(buf, &e, 10);
 
-	if (!*buf || (*e && *e != '\n'))
-		return -EINVAL;
+	err = kstrtouint(buf, 10, &n);
+	if (err < 0)
+		return err;
 
 	err = mddev_lock(mddev);
 	if (err)
@@ -3645,12 +3649,12 @@ chunk_size_show(struct mddev *mddev, char *page)
 static ssize_t
 chunk_size_store(struct mddev *mddev, const char *buf, size_t len)
 {
+	unsigned long n;
 	int err;
-	char *e;
-	unsigned long n = simple_strtoul(buf, &e, 10);
 
-	if (!*buf || (*e && *e != '\n'))
-		return -EINVAL;
+	err = kstrtoul(buf, 10, &n);
+	if (err < 0)
+		return err;
 
 	err = mddev_lock(mddev);
 	if (err)
@@ -3688,19 +3692,24 @@ resync_start_show(struct mddev *mddev, char *page)
 static ssize_t
 resync_start_store(struct mddev *mddev, const char *buf, size_t len)
 {
+	unsigned long long n;
 	int err;
-	char *e;
-	unsigned long long n = simple_strtoull(buf, &e, 10);
+
+	if (cmd_match(buf, "none"))
+		n = MaxSector;
+	else {
+		err = kstrtoull(buf, 10, &n);
+		if (err < 0)
+			return err;
+		if (n != (sector_t)n)
+			return -EINVAL;
+	}
 
 	err = mddev_lock(mddev);
 	if (err)
 		return err;
 	if (mddev->pers && !test_bit(MD_RECOVERY_FROZEN, &mddev->recovery))
 		err = -EBUSY;
-	else if (cmd_match(buf, "none"))
-		n = MaxSector;
-	else if (!*buf || (*e && *e != '\n'))
-		err = -EINVAL;
 
 	if (!err) {
 		mddev->recovery_cp = n;
@@ -3936,14 +3945,14 @@ max_corrected_read_errors_show(struct mddev *mddev, char *page) {
 static ssize_t
 max_corrected_read_errors_store(struct mddev *mddev, const char *buf, size_t len)
 {
-	char *e;
-	unsigned long n = simple_strtoul(buf, &e, 10);
+	unsigned int n;
+	int rv;
 
-	if (*buf && (*e == 0 || *e == '\n')) {
-		atomic_set(&mddev->max_corr_read_errors, n);
-		return len;
-	}
-	return -EINVAL;
+	rv = kstrtouint(buf, 10, &n);
+	if (rv < 0)
+		return rv;
+	atomic_set(&mddev->max_corr_read_errors, n);
+	return len;
 }
 
 static struct md_sysfs_entry max_corr_read_errors =
@@ -4297,15 +4306,18 @@ sync_min_show(struct mddev *mddev, char *page)
 static ssize_t
 sync_min_store(struct mddev *mddev, const char *buf, size_t len)
 {
-	int min;
-	char *e;
+	unsigned int min;
+	int rv;
+
 	if (strncmp(buf, "system", 6)==0) {
-		mddev->sync_speed_min = 0;
-		return len;
+		min = 0;
+	} else {
+		rv = kstrtouint(buf, 10, &min);
+		if (rv < 0)
+			return rv;
+		if (min == 0)
+			return -EINVAL;
 	}
-	min = simple_strtoul(buf, &e, 10);
-	if (buf == e || (*e && *e != '\n') || min <= 0)
-		return -EINVAL;
 	mddev->sync_speed_min = min;
 	return len;
 }
@@ -4323,15 +4335,18 @@ sync_max_show(struct mddev *mddev, char *page)
 static ssize_t
 sync_max_store(struct mddev *mddev, const char *buf, size_t len)
 {
-	int max;
-	char *e;
+	unsigned int max;
+	int rv;
+
 	if (strncmp(buf, "system", 6)==0) {
-		mddev->sync_speed_max = 0;
-		return len;
+		max = 0;
+	} else {
+		rv = kstrtouint(buf, 10, &max);
+		if (rv < 0)
+			return rv;
+		if (max == 0)
+			return -EINVAL;
 	}
-	max = simple_strtoul(buf, &e, 10);
-	if (buf == e || (*e && *e != '\n') || max <= 0)
-		return -EINVAL;
 	mddev->sync_speed_max = max;
 	return len;
 }
@@ -4514,12 +4529,13 @@ suspend_lo_show(struct mddev *mddev, char *page)
 static ssize_t
 suspend_lo_store(struct mddev *mddev, const char *buf, size_t len)
 {
-	char *e;
-	unsigned long long new = simple_strtoull(buf, &e, 10);
-	unsigned long long old;
+	unsigned long long old, new;
 	int err;
 
-	if (buf == e || (*e && *e != '\n'))
+	err = kstrtoull(buf, 10, &new);
+	if (err < 0)
+		return err;
+	if (new != (sector_t)new)
 		return -EINVAL;
 
 	err = mddev_lock(mddev);
@@ -4556,12 +4572,13 @@ suspend_hi_show(struct mddev *mddev, char *page)
 static ssize_t
 suspend_hi_store(struct mddev *mddev, const char *buf, size_t len)
 {
-	char *e;
-	unsigned long long new = simple_strtoull(buf, &e, 10);
-	unsigned long long old;
+	unsigned long long old, new;
 	int err;
 
-	if (buf == e || (*e && *e != '\n'))
+	err = kstrtoull(buf, 10, &new);
+	if (err < 0)
+		return err;
+	if (new != (sector_t)new)
 		return -EINVAL;
 
 	err = mddev_lock(mddev);
@@ -4603,11 +4620,13 @@ static ssize_t
 reshape_position_store(struct mddev *mddev, const char *buf, size_t len)
 {
 	struct md_rdev *rdev;
-	char *e;
+	unsigned long long new;
 	int err;
-	unsigned long long new = simple_strtoull(buf, &e, 10);
 
-	if (buf == e || (*e && *e != '\n'))
+	err = kstrtoull(buf, 10, &new);
+	if (err < 0)
+		return err;
+	if (new != (sector_t)new)
 		return -EINVAL;
 	err = mddev_lock(mddev);
 	if (err)
@@ -9009,13 +9028,7 @@ static int get_ro(char *buffer, struct kernel_param *kp)
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
+	return kstrtouint(val, 10, (unsigned int *)&start_readonly);
 }
 
 module_param_call(start_ro, set_ro, get_ro, NULL, S_IRUSR|S_IWUSR);
