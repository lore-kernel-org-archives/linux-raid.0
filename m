From: Song Liu <songliubraving@fb.com>
Subject: [PATCH v3 1/2] md/r5cache: move mddev_lock() out of r5c_journal_mode_set()
Date: Fri, 17 Nov 2017 17:23:11 -0800
Message-ID: <20171118012312.2562038-1-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: kernel-team@fb.com, shli@kernel.org, neilb@suse.com, artur.paszkiewicz@intel.com, Song Liu <songliubraving@fb.com>, "v4.13+" <stable@vger.kernel.org>
List-Id: linux-raid.ids

r5c_journal_mode_set() is called by r5c_journal_mode_store() and
raid_ctr() in dm-raid. We don't need mddev_lock() when calling from
raid_ctr(). This patch fixes this by moves the mddev_lock() to
r5c_journal_mode_store().

Cc: stable@vger.kernel.org (v4.13+)
Signed-off-by: Song Liu <songliubraving@fb.com>
---
 drivers/md/raid5-cache.c | 17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index f1c86d9..e01f229 100644
--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -2583,25 +2583,19 @@ int r5c_journal_mode_set(struct mddev *mddev, int mode)
 	    mode > R5C_JOURNAL_MODE_WRITE_BACK)
 		return -EINVAL;
 
-	err = mddev_lock(mddev);
 	if (err)
 		return err;
 	conf = mddev->private;
-	if (!conf || !conf->log) {
-		mddev_unlock(mddev);
+	if (!conf || !conf->log)
 		return -ENODEV;
-	}
 
 	if (raid5_calc_degraded(conf) > 0 &&
-	    mode == R5C_JOURNAL_MODE_WRITE_BACK) {
-		mddev_unlock(mddev);
+	    mode == R5C_JOURNAL_MODE_WRITE_BACK)
 		return -EINVAL;
-	}
 
 	mddev_suspend(mddev);
 	conf->log->r5c_journal_mode = mode;
 	mddev_resume(mddev);
-	mddev_unlock(mddev);
 
 	pr_debug("md/raid:%s: setting r5c cache mode to %d: %s\n",
 		 mdname(mddev), mode, r5c_journal_mode_str[mode]);
@@ -2614,6 +2608,7 @@ static ssize_t r5c_journal_mode_store(struct mddev *mddev,
 {
 	int mode = ARRAY_SIZE(r5c_journal_mode_str);
 	size_t len = length;
+	int ret;
 
 	if (len < 2)
 		return -EINVAL;
@@ -2625,8 +2620,10 @@ static ssize_t r5c_journal_mode_store(struct mddev *mddev,
 		if (strlen(r5c_journal_mode_str[mode]) == len &&
 		    !strncmp(page, r5c_journal_mode_str[mode], len))
 			break;
-
-	return r5c_journal_mode_set(mddev, mode) ?: length;
+	mddev_lock(mddev);
+	ret = r5c_journal_mode_set(mddev, mode);
+	mddev_unlock(mddev);
+	return ret ?: length;
 }
 
 struct md_sysfs_entry
-- 
2.9.5

