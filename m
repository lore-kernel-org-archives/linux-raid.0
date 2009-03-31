From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 10/14] md: don't display meaningless values in sysfs files
	resync_start and sync_speed
Date: Tue, 31 Mar 2009 15:54:44 +1100
Message-ID: <20090331045443.2589.43869.stgit@notabene.brown>
References: <20090331044827.2589.95894.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090331044827.2589.95894.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: NeilBrown <neilb@suse.de>
List-Id: linux-raid.ids

When no resync if happening, both of these files currently have
meaningless values (is slightly different ways).
Change them to "none" in that case.

Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/md.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index c509313..2be574c 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -2888,6 +2888,8 @@ __ATTR(chunk_size, S_IRUGO|S_IWUSR, chunk_size_show, chunk_size_store);
 static ssize_t
 resync_start_show(mddev_t *mddev, char *page)
 {
+	if (mddev->recovery_cp == MaxSector)
+		return sprintf(page, "none\n");
 	return sprintf(page, "%llu\n", (unsigned long long)mddev->recovery_cp);
 }
 
@@ -3469,6 +3471,8 @@ static ssize_t
 sync_speed_show(mddev_t *mddev, char *page)
 {
 	unsigned long resync, dt, db;
+	if (mddev->curr_resync == 0)
+		return sprintf(page, "none\n");
 	resync = mddev->curr_mark_cnt - atomic_read(&mddev->recovery_active);
 	dt = (jiffies - mddev->resync_mark) / HZ;
 	if (!dt) dt++;


