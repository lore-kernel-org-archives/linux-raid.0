From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 03/22] md: don't reset curr_resync_completed after an
	interrupted resync
Date: Fri, 04 Dec 2009 17:48:02 +1100
Message-ID: <20091204064802.10264.88858.stgit@notabene.brown>
References: <20091204064559.10264.37619.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20091204064559.10264.37619.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

If a resync/recovery/check/repair is interrupted for some reason, it
can be useful to know exactly where it got up to.
So in that case, do clear curr_resync_completed.
Initialise it when starting a resync/recovery/... instead.

Signed-off-by: NeilBrown <neilb@suse.de>
---
 drivers/md/md.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index a43539e..20a3660 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -6383,7 +6383,9 @@ void md_do_sync(mddev_t *mddev)
 		       "md: resuming %s of %s from checkpoint.\n",
 		       desc, mdname(mddev));
 		mddev->curr_resync = j;
-	}
+		mddev->curr_resync_completed = j;
+	} else
+		mddev->curr_resync_completed = 0;
 
 	while (j < max_sectors) {
 		sector_t sectors;
@@ -6535,7 +6537,8 @@ void md_do_sync(mddev_t *mddev)
 	} else if (test_bit(MD_RECOVERY_REQUESTED, &mddev->recovery))
 		mddev->resync_min = mddev->curr_resync_completed;
 	mddev->curr_resync = 0;
-	mddev->curr_resync_completed = 0;
+	if (!test_bit(MD_RECOVERY_INTR, &mddev->recovery))
+		mddev->curr_resync_completed = 0;
 	sysfs_notify(&mddev->kobj, NULL, "sync_completed");
 	wake_up(&resync_wait);
 	set_bit(MD_RECOVERY_DONE, &mddev->recovery);


