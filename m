From: Song Liu <songliubraving@fb.com>
Subject: [PATCH] md/r5cache: call mddev_lock/unlock() in r5c_journal_mode_show
Date: Tue, 8 Aug 2017 15:54:28 -0700
Message-ID: <20170808225428.1267872-1-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, shli@kernel.org
Cc: Song Liu <songliubraving@fb.com>, shli@fb.com, neilb@suse.com, kernel-team@fb.com, dan.j.williams@intel.com, hch@infradead.org, jes.sorensen@gmail.com
List-Id: linux-raid.ids

In r5c_journal_mode_show(), it is necessary to call mddev_lock()
before accessing conf and conf->log. Otherwise, the conf->log
may change (and become NULL).

Signed-off-by: Song Liu <songliubraving@fb.com>
---
 drivers/md/raid5-cache.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index 2dcbafa..88d5432 100644
--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -2529,11 +2529,15 @@ static void r5l_write_super(struct r5l_log *log, sector_t cp)
 
 static ssize_t r5c_journal_mode_show(struct mddev *mddev, char *page)
 {
-	struct r5conf *conf = mddev->private;
+	struct r5conf *conf;
 	int ret;
 
-	if (!conf->log)
+	mddev_lock(mddev);
+	conf = mddev->private;
+	if (!conf || !conf->log) {
+		mddev_unlock(mddev);
 		return 0;
+	}
 
 	switch (conf->log->r5c_journal_mode) {
 	case R5C_JOURNAL_MODE_WRITE_THROUGH:
@@ -2551,6 +2555,7 @@ static ssize_t r5c_journal_mode_show(struct mddev *mddev, char *page)
 	default:
 		ret = 0;
 	}
+	mddev_unlock(mddev);
 	return ret;
 }
 
-- 
2.9.3

