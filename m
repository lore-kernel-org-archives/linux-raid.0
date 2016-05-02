From: Guoqing Jiang <gqjiang@suse.com>
Subject: [V2 PATCH 07/13] md-cluster: wakeup thread if activated a spare disk
Date: Mon,  2 May 2016 11:33:14 -0400
Message-ID: <1462203200-1375-8-git-send-email-gqjiang@suse.com>
References: <1462203200-1375-1-git-send-email-gqjiang@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1462203200-1375-1-git-send-email-gqjiang@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: shli@kernel.org
Cc: neilb@suse.de, linux-raid@vger.kernel.org, Guoqing Jiang <gqjiang@suse.com>
List-Id: linux-raid.ids

When a device is re-added, it will ultimately need
to be activated and that happens in md_check_recovery,
so we need to set MD_RECOVERY_NEEDED right after
remove_and_add_spares.

A specifical issue without the change is that when
one node perform fail/remove/readd on a disk, but
slave nodes could not add the disk back to array as
expected (added as missed instead of in sync). So
give slave nodes a chance to do resync.

Reviewed-by: NeilBrown <neilb@suse.com>
Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
---
 drivers/md/md.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 8cc4bbc..06f6e81 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -8694,6 +8694,11 @@ static void check_sb_changes(struct mddev *mddev, struct md_rdev *rdev)
 				ret = remove_and_add_spares(mddev, rdev2);
 				pr_info("Activated spare: %s\n",
 						bdevname(rdev2->bdev,b));
+				/* wakeup mddev->thread here, so array could
+				 * perform resync with the new activated disk */
+				set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
+				md_wakeup_thread(mddev->thread);
+
 			}
 			/* device faulty
 			 * We just want to do the minimum to mark the disk
-- 
2.6.6

