From: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Subject: [PATCH v2 08/12] md: expose rdev->sb_start as sysfs attribute
Date: Mon,  5 Dec 2016 16:31:09 +0100
Message-ID: <20161205153113.7268-9-artur.paszkiewicz@intel.com>
References: <20161205153113.7268-1-artur.paszkiewicz@intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20161205153113.7268-1-artur.paszkiewicz@intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: shli@kernel.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is meant for external metadata arrays, to pass the location of the
superblock to the kernel.

Signed-off-by: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
---
 drivers/md/md.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 5a14f8e..7049833 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -3204,6 +3204,27 @@ static ssize_t ubb_store(struct md_rdev *rdev, const char *page, size_t len)
 static struct rdev_sysfs_entry rdev_unack_bad_blocks =
 __ATTR(unacknowledged_bad_blocks, S_IRUGO|S_IWUSR, ubb_show, ubb_store);
 
+static ssize_t
+sb_start_show(struct md_rdev *rdev, char *page)
+{
+	return sprintf(page, "%llu\n", (unsigned long long)rdev->sb_start);
+}
+
+static ssize_t
+sb_start_store(struct md_rdev *rdev, const char *buf, size_t len)
+{
+	unsigned long long sb_start;
+	if (kstrtoull(buf, 10, &sb_start) < 0)
+		return -EINVAL;
+	if (!rdev->mddev->external)
+		return -EBUSY;
+	rdev->sb_start = sb_start;
+	return len;
+}
+
+static struct rdev_sysfs_entry rdev_sb_start =
+__ATTR(sb_start, S_IRUGO|S_IWUSR, sb_start_show, sb_start_store);
+
 static struct attribute *rdev_default_attrs[] = {
 	&rdev_state.attr,
 	&rdev_errors.attr,
@@ -3214,6 +3235,7 @@ static struct attribute *rdev_default_attrs[] = {
 	&rdev_recovery_start.attr,
 	&rdev_bad_blocks.attr,
 	&rdev_unack_bad_blocks.attr,
+	&rdev_sb_start.attr,
 	NULL,
 };
 static ssize_t
-- 
2.10.1

