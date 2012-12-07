From: Sebastian Riemer <sebastian.riemer@profitbricks.com>
Subject: [PATCH] md: fix max_disks check in analyze_sbs
Date: Fri,  7 Dec 2012 13:30:40 +0100
Message-ID: <1354883440-22589-1-git-send-email-sebastian.riemer@profitbricks.com>
Reply-To: linux-raid <linux-raid@vger.kernel.org>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
Cc: Sebastian Riemer <sebastian.riemer@profitbricks.com>
List-Id: linux-raid.ids

The number of disks starts at zero and is directly compared to
greater than max_disks. The check has to start at one.

Furthermore, the number of disks is only updated if the level is
multipath. For all other levels max_disks is always compared
against zero.
So make the number of disks count right for all levels.

Signed-off-by: Sebastian Riemer <sebastian.riemer@profitbricks.com>
---
 drivers/md/md.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 6120071..f93fc79 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -3337,7 +3337,7 @@ static void analyze_sbs(struct mddev * mddev)
 	rdev_for_each_safe(rdev, tmp, mddev) {
 		if (mddev->max_disks &&
 		    (rdev->desc_nr >= mddev->max_disks ||
-		     i > mddev->max_disks)) {
+		     i+1 > mddev->max_disks)) {
 			printk(KERN_WARNING
 			       "md: %s: %s: only %d devices permitted\n",
 			       mdname(mddev), bdevname(rdev->bdev, b),
@@ -3355,13 +3355,14 @@ static void analyze_sbs(struct mddev * mddev)
 				continue;
 			}
 		if (mddev->level == LEVEL_MULTIPATH) {
-			rdev->desc_nr = i++;
+			rdev->desc_nr = i;
 			rdev->raid_disk = rdev->desc_nr;
 			set_bit(In_sync, &rdev->flags);
 		} else if (rdev->raid_disk >= (mddev->raid_disks - min(0, mddev->delta_disks))) {
 			rdev->raid_disk = -1;
 			clear_bit(In_sync, &rdev->flags);
 		}
+		i++;
 	}
 }
 
-- 
1.7.1

