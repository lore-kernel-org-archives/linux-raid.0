From: =?UTF-8?q?Micha=C5=82=20Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>
Subject: [PATCH] md: allow changing set_name of running array
Date: Wed, 30 Aug 2017 00:02:45 +0200
Message-ID: <429c2b1c84c44b0c09ea7aa8dfa86846885441f7.1504044125.git.mirq-linux@rere.qmqm.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Allow changing active array's set_name. This is the only way to
safely update superblock on an array which carries a mounted fs.

Signed-off-by: Michał Mirosław <mirq-linux@rere.qmqm.pl>
---
 drivers/md/md.c | 79 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 79 insertions(+)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index caca5d689cdc..59aa10669bef 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -5051,6 +5051,84 @@ static struct md_sysfs_entry md_consistency_policy =
 __ATTR(consistency_policy, S_IRUGO | S_IWUSR, consistency_policy_show,
        consistency_policy_store);
 
+static ssize_t
+set_name_show(struct mddev *mddev, char *page)
+{
+	struct mdp_superblock_1 *sb;
+	struct md_rdev *rdev;
+	int err;
+
+	err = mddev_lock(mddev);
+	if (err)
+		return err;
+
+	/* only version-1 superblocks carry a MD set's name */
+	err = -ENXIO;
+	if (mddev->major_version != 1)
+		goto out_unlock;
+
+	err = -EINVAL;
+	rdev_for_each(rdev, mddev) {
+		if (WARN_ON(!rdev->sb_loaded))
+			continue;
+
+		sb = page_address(rdev->sb_page);
+		err = sprintf(page, "%.32s\n", sb->set_name);
+		break;
+	}
+
+out_unlock:
+	mddev_unlock(mddev);
+	return err;
+}
+
+static ssize_t
+set_name_store(struct mddev *mddev, const char *buf, size_t buflen)
+{
+	struct mdp_superblock_1 *sb;
+	struct md_rdev *rdev;
+	size_t len = buflen;
+	int err;
+
+	if (len && buf[len - 1] == '\n')
+		--len;
+
+	if (len > sizeof(sb->set_name))
+		return -ENOSPC;
+
+	err = mddev_lock(mddev);
+	if (err)
+		return err;
+
+	/* only version-1 superblocks carry a MD set's name */
+	err = -ENXIO;
+	if (mddev->major_version != 1)
+		goto out_unlock;
+
+	err = -EROFS;
+	if (mddev->ro)
+		goto out_unlock;
+
+	rdev_for_each(rdev, mddev) {
+		if (WARN_ON(!rdev->sb_loaded))
+			continue;
+
+		sb = page_address(rdev->sb_page);
+		memcpy(sb->set_name, buf, len);
+		memset(&sb->set_name[len], 0, sizeof(sb->set_name) - len);
+	}
+
+	md_update_sb(mddev, 1);
+	err = buflen;
+
+out_unlock:
+	mddev_unlock(mddev);
+	return err;
+}
+
+static struct md_sysfs_entry md_set_name =
+__ATTR(set_name, S_IRUGO | S_IWUSR, set_name_show, set_name_store);
+
 static struct attribute *md_default_attrs[] = {
 	&md_level.attr,
 	&md_layout.attr,
@@ -5067,6 +5145,7 @@ static struct attribute *md_default_attrs[] = {
 	&md_array_size.attr,
 	&max_corr_read_errors.attr,
 	&md_consistency_policy.attr,
+	&md_set_name.attr,
 	NULL,
 };
 
-- 
2.11.0

