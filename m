From: Song Liu <songliubraving@fb.com>
Subject: [PATCH 1/2] md/r5cache: fix r5c_journal_mode_store
Date: Thu, 27 Jul 2017 16:35:55 -0700
Message-ID: <20170727233556.3802574-1-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: shli@fb.com, neilb@suse.com, kernel-team@fb.com, dan.j.williams@intel.com, hch@infradead.org, jes.sorensen@gmail.com, Song Liu <songliubraving@fb.com>
List-Id: linux-raid.ids

In r5c_journal_mode_store(), conf->log may change (and become NULL)
after mddev_suspend(). This patch check conf->log again after
mddev_suspend() to mitigate this risk.

Signed-off-by: Song Liu <songliubraving@fb.com>
---
 drivers/md/raid5-cache.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index bfa1e90..315cabf 100644
--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -2541,9 +2541,8 @@ static ssize_t r5c_journal_mode_show(struct mddev *mddev, char *page)
 int r5c_journal_mode_set(struct mddev *mddev, int mode)
 {
 	struct r5conf *conf = mddev->private;
-	struct r5l_log *log = conf->log;
 
-	if (!log)
+	if (!conf->log)
 		return -ENODEV;
 
 	if (mode < R5C_JOURNAL_MODE_WRITE_THROUGH ||
@@ -2555,6 +2554,10 @@ int r5c_journal_mode_set(struct mddev *mddev, int mode)
 		return -EINVAL;
 
 	mddev_suspend(mddev);
+	if (!conf || !conf->log) {
+		mddev_resume(mddev);
+		return -ENODEV;
+	}
 	conf->log->r5c_journal_mode = mode;
 	mddev_resume(mddev);
 
-- 
2.9.3

