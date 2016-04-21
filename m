From: Guoqing Jiang <gqjiang@suse.com>
Subject: [PATCH 07/13] md-cluster: wakeup thread if activated a spare disk
Date: Thu, 21 Apr 2016 13:58:08 +0800
Message-ID: <1461218294-4960-8-git-send-email-gqjiang@suse.com>
References: <1461218294-4960-1-git-send-email-gqjiang@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1461218294-4960-1-git-send-email-gqjiang@suse.com>
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
index 1b26397..dbc7c83 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -8690,6 +8690,11 @@ static void check_sb_changes(struct mddev *mddev, struct md_rdev *rdev)
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

