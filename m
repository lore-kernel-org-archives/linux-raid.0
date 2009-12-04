From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 02/22] md: adjust resync_min usefully when resync aborts.
Date: Fri, 04 Dec 2009 17:48:02 +1100
Message-ID: <20091204064802.10264.93798.stgit@notabene.brown>
References: <20091204064559.10264.37619.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20091204064559.10264.37619.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

When a 'check' or 'repair' finished we should clear resync_min
so that a future check/repair will cover the whole array (by default).
However if it is interrupted, we should update resync_min to
where we got up to, so that when the check/repair continues it
just does the remainder of the array.

Signed-off-by: NeilBrown <neilb@suse.de>
---
 drivers/md/md.c |   10 +++++++---
 1 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 69af3b8..a43539e 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -6527,11 +6527,15 @@ void md_do_sync(mddev_t *mddev)
 	set_bit(MD_CHANGE_DEVS, &mddev->flags);
 
  skip:
+	if (!test_bit(MD_RECOVERY_INTR, &mddev->recovery)) {
+		/* We completed so min/max setting can be forgotten if used. */
+		if (test_bit(MD_RECOVERY_REQUESTED, &mddev->recovery))
+			mddev->resync_min = 0;
+		mddev->resync_max = MaxSector;
+	} else if (test_bit(MD_RECOVERY_REQUESTED, &mddev->recovery))
+		mddev->resync_min = mddev->curr_resync_completed;
 	mddev->curr_resync = 0;
 	mddev->curr_resync_completed = 0;
-	if (!test_bit(MD_RECOVERY_INTR, &mddev->recovery))
-		/* We completed so max setting can be forgotten. */
-		mddev->resync_max = MaxSector;
 	sysfs_notify(&mddev->kobj, NULL, "sync_completed");
 	wake_up(&resync_wait);
 	set_bit(MD_RECOVERY_DONE, &mddev->recovery);


