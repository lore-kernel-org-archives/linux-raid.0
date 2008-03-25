From: Andre Noll <maan@systemlinux.org>
Subject: [PATCH 4/8] sync_speed_show(): Trivial cleanups.
Date: Tue, 25 Mar 2008 23:24:09 +0100
Message-ID: <S1752430AbYGGIdx/20080707083353Z+311@vger.kernel.org>
References: <20080707075532.GA32617@skl-net.de>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20080707075532.GA32617@skl-net.de>
Sender: linux-raid-owner@vger.kernel.org
List-Id: linux-raid.ids

- Remove superfluous parentheses.
- Make format string match the type of the variable that is printed.

Signed-off-by: Andre Noll <maan@systemlinux.org>
---
 drivers/md/md.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 2384266..857af03 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -3049,11 +3049,11 @@ static ssize_t
 sync_speed_show(mddev_t *mddev, char *page)
 {
 	unsigned long resync, dt, db;
-	resync = (mddev->curr_mark_cnt - atomic_read(&mddev->recovery_active));
-	dt = ((jiffies - mddev->resync_mark) / HZ);
+	resync = mddev->curr_mark_cnt - atomic_read(&mddev->recovery_active);
+	dt = (jiffies - mddev->resync_mark) / HZ;
 	if (!dt) dt++;
-	db = resync - (mddev->resync_mark_cnt);
-	return sprintf(page, "%ld\n", db/dt/2); /* K/sec */
+	db = resync - mddev->resync_mark_cnt;
+	return sprintf(page, "%lu\n", db/dt/2); /* K/sec */
 }
 
 static struct md_sysfs_entry md_sync_speed = __ATTR_RO(sync_speed);
-- 
1.5.3.8

