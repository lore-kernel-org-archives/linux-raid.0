From: "Nikanth Karthikesan" <knikanth@novell.com>
Subject: [PATCH] linear: correct disk numbering error check
Date: Fri, 13 Jun 2008 02:37:41 -0600
Message-ID: <48527F2D020000C500027A7E@victor.provo.novell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: mingo@redhat.com, neilb@suse.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Correct disk numbering problem check.

Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>

---
diff --git a/drivers/md/linear.c b/drivers/md/linear.c
index 1074824..ec921f5 100644
--- a/drivers/md/linear.c
+++ b/drivers/md/linear.c
@@ -126,7 +126,7 @@ static linear_conf_t *linear_conf(mddev_t *mddev, int raid_disks)
 		int j = rdev->raid_disk;
 		dev_info_t *disk = conf->disks + j;
 
-		if (j < 0 || j > raid_disks || disk->rdev) {
+		if (j < 0 || j >= raid_disks || disk->rdev) {
 			printk("linear: disk numbering problem. Aborting!\n");
 			goto out;
 		}


