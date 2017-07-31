From: Song Liu <songliubraving@fb.com>
Subject: [PATCH v2 1/2] md/r5cache: call mddev_lock/unlock() in r5c_journal_mode_set
Date: Mon, 31 Jul 2017 14:52:26 -0700
Message-ID: <20170731215227.2409587-1-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: shli@fb.com, neilb@suse.com, kernel-team@fb.com, dan.j.williams@intel.com, hch@infradead.org, jes.sorensen@gmail.com, Song Liu <songliubraving@fb.com>
List-Id: linux-raid.ids

In r5c_journal_mode_set(), it is necessary to call mddev_lock()
before accessing conf and conf->log. Otherwise, the conf->log
may change (and become NULL).

Signed-off-by: Song Liu <songliubraving@fb.com>
---
 drivers/md/raid5-cache.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index bfa1e90..98b5aa9 100644
--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -2540,16 +2540,20 @@ static ssize_t r5c_journal_mode_show(struct mddev *mddev, char *page)
  */
 int r5c_journal_mode_set(struct mddev *mddev, int mode)
 {
-	struct r5conf *conf = mddev->private;
-	struct r5l_log *log = conf->log;
-
-	if (!log)
-		return -ENODEV;
+	struct r5conf *conf;
+	int err;
 
 	if (mode < R5C_JOURNAL_MODE_WRITE_THROUGH ||
 	    mode > R5C_JOURNAL_MODE_WRITE_BACK)
 		return -EINVAL;
 
+	err = mddev_lock(mddev);
+	if (err)
+		return err;
+	conf = mddev->private;
+	if (!conf || !conf->log)
+		return -ENODEV;
+
 	if (raid5_calc_degraded(conf) > 0 &&
 	    mode == R5C_JOURNAL_MODE_WRITE_BACK)
 		return -EINVAL;
@@ -2557,6 +2561,7 @@ int r5c_journal_mode_set(struct mddev *mddev, int mode)
 	mddev_suspend(mddev);
 	conf->log->r5c_journal_mode = mode;
 	mddev_resume(mddev);
+	mddev_unlock(mddev);
 
 	pr_debug("md/raid:%s: setting r5c cache mode to %d: %s\n",
 		 mdname(mddev), mode, r5c_journal_mode_str[mode]);
-- 
2.9.3

