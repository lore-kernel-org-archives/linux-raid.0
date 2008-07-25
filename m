From: Andre Noll <maan@systemlinux.org>
Subject: [PATCH 5/6] md: linear.c: Make two local variables sector-based.
Date: Fri, 25 Jul 2008 17:27:51 +0200
Message-ID: <1216999672-4943-6-git-send-email-maan@systemlinux.org>
References: <1216999672-4943-1-git-send-email-maan@systemlinux.org>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1216999672-4943-1-git-send-email-maan@systemlinux.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Andre Noll <maan@systemlinux.org>
List-Id: linux-raid.ids

This is a preparation for representing also the remaining fields of struct
linear_private_data as sectors.

Signed-off-by: Andre Noll <maan@systemlinux.org>
---
 drivers/md/linear.c |   20 ++++++++++----------
 1 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/md/linear.c b/drivers/md/linear.c
index b33e433..441b7fa 100644
--- a/drivers/md/linear.c
+++ b/drivers/md/linear.c
@@ -110,7 +110,7 @@ static linear_conf_t *linear_conf(mddev_t *mddev, int raid_disks)
 	dev_info_t **table;
 	mdk_rdev_t *rdev;
 	int i, nb_zone, cnt;
-	sector_t min_spacing;
+	sector_t min_sectors;
 	sector_t curr_sector;
 	struct list_head *tmp;
 
@@ -153,23 +153,23 @@ static linear_conf_t *linear_conf(mddev_t *mddev, int raid_disks)
 		goto out;
 	}
 
-	min_spacing = conf->array_sectors / 2;
-	sector_div(min_spacing, PAGE_SIZE/sizeof(struct dev_info *));
+	min_sectors = conf->array_sectors;
+	sector_div(min_sectors, PAGE_SIZE/sizeof(struct dev_info *));
 
-	/* min_spacing is the minimum spacing that will fit the hash
+	/* min_sectors is the minimum spacing that will fit the hash
 	 * table in one PAGE.  This may be much smaller than needed.
 	 * We find the smallest non-terminal set of consecutive devices
-	 * that is larger than min_spacing and use the size of that as
+	 * that is larger than min_sectors and use the size of that as
 	 * the actual spacing
 	 */
 	conf->hash_spacing = conf->array_sectors / 2;
 	for (i=0; i < cnt-1 ; i++) {
-		sector_t sz = 0;
+		sector_t tmp = 0;
 		int j;
-		for (j = i; j < cnt - 1 && sz < min_spacing; j++)
-			sz += conf->disks[j].num_sectors / 2;
-		if (sz >= min_spacing && sz < conf->hash_spacing)
-			conf->hash_spacing = sz;
+		for (j = i; j < cnt - 1 && tmp < min_sectors; j++)
+			tmp += conf->disks[j].num_sectors;
+		if (tmp >= min_sectors && tmp < conf->hash_spacing * 2)
+			conf->hash_spacing = tmp / 2;
 	}
 
 	/* hash_spacing may be too large for sector_div to work with,
-- 
1.5.4.3

