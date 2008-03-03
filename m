From: NeilBrown <neilb@suse.de>
Subject: [PATCH 003 of 9] md: Guard against possible bad array geometry in v1 metadata.
Date: Mon, 3 Mar 2008 11:17:18 +1100
Message-ID: <1080303001718.23607@suse.de>
References: <20080303111240.23302.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids


Make sure the data doesn't start before the end of the superblock
when the superblock is at the start of the device.

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/md.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff .prev/drivers/md/md.c ./drivers/md/md.c
--- .prev/drivers/md/md.c	2008-02-22 15:46:10.000000000 +1100
+++ ./drivers/md/md.c	2008-02-22 15:46:10.000000000 +1100
@@ -1105,7 +1105,11 @@ static int super_1_load(mdk_rdev_t *rdev
 	rdev->sb_size = le32_to_cpu(sb->max_dev) * 2 + 256;
 	bmask = queue_hardsect_size(rdev->bdev->bd_disk->queue)-1;
 	if (rdev->sb_size & bmask)
-		rdev-> sb_size = (rdev->sb_size | bmask)+1;
+		rdev->sb_size = (rdev->sb_size | bmask) + 1;
+
+	if (minor_version
+	    && rdev->data_offset < sb_offset + (rdev->sb_size/512))
+		return -EINVAL;
 
 	if (sb->level == cpu_to_le32(LEVEL_MULTIPATH))
 		rdev->desc_nr = -1;
@@ -1137,7 +1141,7 @@ static int super_1_load(mdk_rdev_t *rdev
 		else
 			ret = 0;
 	}
-	if (minor_version) 
+	if (minor_version)
 		rdev->size = ((rdev->bdev->bd_inode->i_size>>9) - le64_to_cpu(sb->data_offset)) / 2;
 	else
 		rdev->size = rdev->sb_offset;
