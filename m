From: NeilBrown <neilb@suse.de>
Subject: [PATCH 004 of 29] md: linear: correct disk numbering error check
Date: Fri, 27 Jun 2008 16:49:43 +1000
Message-ID: <1080627064943.10337@suse.de>
References: <20080627164503.9671.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, Nikanth Karthikesan <knikanth@novell.com>, Nikanth Karthikesan <knikanth@suse.de>
List-Id: linux-raid.ids


From: "Nikanth Karthikesan" <knikanth@novell.com>

Correct disk numbering problem check.

Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>
Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/linear.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff .prev/drivers/md/linear.c ./drivers/md/linear.c
--- .prev/drivers/md/linear.c	2008-06-27 15:19:55.000000000 +1000
+++ ./drivers/md/linear.c	2008-06-27 15:31:20.000000000 +1000
@@ -126,7 +126,7 @@ static linear_conf_t *linear_conf(mddev_
 		int j = rdev->raid_disk;
 		dev_info_t *disk = conf->disks + j;
 
-		if (j < 0 || j > raid_disks || disk->rdev) {
+		if (j < 0 || j >= raid_disks || disk->rdev) {
 			printk("linear: disk numbering problem. Aborting!\n");
 			goto out;
 		}
