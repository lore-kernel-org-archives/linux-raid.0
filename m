From: rgoldwyn@suse.de
Subject: [PATCH 6/6] md-cluster: Allow spare devices to be marked as faulty
Date: Thu,  5 Nov 2015 21:50:19 -0600
Message-ID: <1446781819-25571-6-git-send-email-rgoldwyn@suse.de>
References: <1446781819-25571-1-git-send-email-rgoldwyn@suse.de>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1446781819-25571-1-git-send-email-rgoldwyn@suse.de>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.com, linux-raid@vger.kernel.org
Cc: Goldwyn Rodrigues <rgoldwyn@suse.com>
List-Id: linux-raid.ids

From: Goldwyn Rodrigues <rgoldwyn@suse.com>

If a spare device was marked faulty, it would not be reflected
in receiving nodes because it would mark it as activated and continue.
Continue the operation, so it may be set as faulty.

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
---
 drivers/md/md.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 4222285..b98cf04 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -9013,7 +9013,6 @@ static void check_sb_changes(struct mddev *mddev, struct md_rdev *rdev)
 				ret = remove_and_add_spares(mddev, rdev2);
 				pr_info("Activated spare: %s\n",
 						bdevname(rdev2->bdev,b));
-				continue;
 			}
 			/* device faulty
 			 * We just want to do the minimum to mark the disk
-- 
1.8.5.6

