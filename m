From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 08/13] md-new-param-to-calc_dev_sboffset
Date: Wed, 12 Jan 2011 09:12:47 +1100
Message-ID: <20110111221246.12732.12190.stgit@notabene.brown>
References: <20110111221050.12732.31647.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110111221050.12732.31647.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Jonathan Brassow <jbrassow@redhat.com>
List-Id: linux-raid.ids

From: Jonathan Brassow <jbrassow@redhat.com>

When we allow for separate devices for data and metadata
in a later patch, we will need to be able to calculate
the superblock offset based on more than the bdev.

Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>
---

 drivers/md/md.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index a91dc59..0a0d7c2 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -705,9 +705,9 @@ static struct mdk_personality *find_pers(int level, char *clevel)
 }
 
 /* return the offset of the super block in 512byte sectors */
-static inline sector_t calc_dev_sboffset(struct block_device *bdev)
+static inline sector_t calc_dev_sboffset(mdk_rdev_t *rdev)
 {
-	sector_t num_sectors = i_size_read(bdev->bd_inode) / 512;
+	sector_t num_sectors = i_size_read(rdev->bdev->bd_inode) / 512;
 	return MD_NEW_SIZE_SECTORS(num_sectors);
 }
 
@@ -991,7 +991,7 @@ static int super_90_load(mdk_rdev_t *rdev, mdk_rdev_t *refdev, int minor_version
 	 *
 	 * It also happens to be a multiple of 4Kb.
 	 */
-	rdev->sb_start = calc_dev_sboffset(rdev->bdev);
+	rdev->sb_start = calc_dev_sboffset(rdev);
 
 	ret = read_disk_sb(rdev, MD_SB_BYTES);
 	if (ret) return ret;
@@ -1332,7 +1332,7 @@ super_90_rdev_size_change(mdk_rdev_t *rdev, sector_t num_sectors)
 		return 0; /* component must fit device */
 	if (rdev->mddev->bitmap_info.offset)
 		return 0; /* can't move bitmap */
-	rdev->sb_start = calc_dev_sboffset(rdev->bdev);
+	rdev->sb_start = calc_dev_sboffset(rdev);
 	if (!num_sectors || num_sectors > rdev->sb_start)
 		num_sectors = rdev->sb_start;
 	md_super_write(rdev->mddev, rdev, rdev->sb_start, rdev->sb_size,
@@ -5249,7 +5249,7 @@ static int add_new_disk(mddev_t * mddev, mdu_disk_info_t *info)
 			printk(KERN_INFO "md: nonpersistent superblock ...\n");
 			rdev->sb_start = i_size_read(rdev->bdev->bd_inode) / 512;
 		} else
-			rdev->sb_start = calc_dev_sboffset(rdev->bdev);
+			rdev->sb_start = calc_dev_sboffset(rdev);
 		rdev->sectors = rdev->sb_start;
 
 		err = bind_rdev_to_array(rdev, mddev);
@@ -5316,7 +5316,7 @@ static int hot_add_disk(mddev_t * mddev, dev_t dev)
 	}
 
 	if (mddev->persistent)
-		rdev->sb_start = calc_dev_sboffset(rdev->bdev);
+		rdev->sb_start = calc_dev_sboffset(rdev);
 	else
 		rdev->sb_start = i_size_read(rdev->bdev->bd_inode) / 512;
 


