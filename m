From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH md 002 of 7] Limit size of sb read/written to appropriate amount.
Date: Mon, 29 Aug 2005 17:33:39 +1000
Message-ID: <E1E9e9D-0003Wb-5G@notabene.cse.unsw.edu.au>
References: <20050829172936.12848.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


version-1 superblocks are not (normally) 4K long, and can be of
variable size.  Writing the full 4K can cause corruption (but only in
non-default configurations).

With this patch the super-block-flavour can choose a size to read, and
set a size to write based on what it finds.

Signed-off-by: Neil Brown <neilb@cse.unsw.edu.au>

### Diffstat output
 ./drivers/md/md.c           |   20 +++++++++++++++-----
 ./include/linux/raid/md_k.h |    1 +
 2 files changed, 16 insertions(+), 5 deletions(-)

diff ./drivers/md/md.c~current~ ./drivers/md/md.c
--- ./drivers/md/md.c~current~	2005-08-29 15:52:32.000000000 +1000
+++ ./drivers/md/md.c	2005-08-29 15:52:47.000000000 +1000
@@ -393,7 +393,7 @@ int sync_page_io(struct block_device *bd
 	return ret;
 }
 
-static int read_disk_sb(mdk_rdev_t * rdev)
+static int read_disk_sb(mdk_rdev_t * rdev, int size)
 {
 	char b[BDEVNAME_SIZE];
 	if (!rdev->sb_page) {
@@ -404,7 +404,7 @@ static int read_disk_sb(mdk_rdev_t * rde
 		return 0;
 
 
-	if (!sync_page_io(rdev->bdev, rdev->sb_offset<<1, MD_SB_BYTES, rdev->sb_page, READ))
+	if (!sync_page_io(rdev->bdev, rdev->sb_offset<<1, size, rdev->sb_page, READ))
 		goto fail;
 	rdev->sb_loaded = 1;
 	return 0;
@@ -531,7 +531,7 @@ static int super_90_load(mdk_rdev_t *rde
 	sb_offset = calc_dev_sboffset(rdev->bdev);
 	rdev->sb_offset = sb_offset;
 
-	ret = read_disk_sb(rdev);
+	ret = read_disk_sb(rdev, MD_SB_BYTES);
 	if (ret) return ret;
 
 	ret = -EINVAL;
@@ -564,6 +564,7 @@ static int super_90_load(mdk_rdev_t *rde
 
 	rdev->preferred_minor = sb->md_minor;
 	rdev->data_offset = 0;
+	rdev->sb_size = MD_SB_BYTES;
 
 	if (sb->level == LEVEL_MULTIPATH)
 		rdev->desc_nr = -1;
@@ -837,6 +838,7 @@ static int super_1_load(mdk_rdev_t *rdev
 	int ret;
 	sector_t sb_offset;
 	char b[BDEVNAME_SIZE], b2[BDEVNAME_SIZE];
+	int bmask;
 
 	/*
 	 * Calculate the position of the superblock.
@@ -865,7 +867,10 @@ static int super_1_load(mdk_rdev_t *rdev
 	}
 	rdev->sb_offset = sb_offset;
 
-	ret = read_disk_sb(rdev);
+	/* superblock is rarely larger than 1K, but it can be larger,
+	 * and it is safe to read 4k, so we do that
+	 */
+	ret = read_disk_sb(rdev, 4096);
 	if (ret) return ret;
 
 
@@ -891,6 +896,11 @@ static int super_1_load(mdk_rdev_t *rdev
 	rdev->preferred_minor = 0xffff;
 	rdev->data_offset = le64_to_cpu(sb->data_offset);
 
+	rdev->sb_size = le32_to_cpu(sb->max_dev) * 2 + 256;
+	bmask = block_size(rdev->bdev)-1;
+	if (rdev->sb_size & bmask)
+		rdev-> sb_size = (rdev->sb_size | bmask)+1;
+
 	if (refdev == 0)
 		return 1;
 	else {
@@ -1375,7 +1385,7 @@ repeat:
 		dprintk("%s ", bdevname(rdev->bdev,b));
 		if (!rdev->faulty) {
 			md_super_write(mddev,rdev,
-				       rdev->sb_offset<<1, MD_SB_BYTES,
+				       rdev->sb_offset<<1, rdev->sb_size,
 				       rdev->sb_page);
 			dprintk(KERN_INFO "(write) %s's sb offset: %llu\n",
 				bdevname(rdev->bdev,b),

diff ./include/linux/raid/md_k.h~current~ ./include/linux/raid/md_k.h
--- ./include/linux/raid/md_k.h~current~	2005-08-29 15:52:38.000000000 +1000
+++ ./include/linux/raid/md_k.h	2005-08-29 15:52:47.000000000 +1000
@@ -102,6 +102,7 @@ struct mdk_rdev_s
 	int		sb_loaded;
 	sector_t	data_offset;	/* start of data in array */
 	sector_t	sb_offset;
+	int		sb_size;	/* bytes in the superblock */
 	int		preferred_minor;	/* autorun support */
 
 	/* A device can be in one of three states based on two flags:
