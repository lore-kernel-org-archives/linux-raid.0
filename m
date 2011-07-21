From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 28/34] md: get rid of unnecessary casts on page_address()
Date: Thu, 21 Jul 2011 12:32:28 +1000
Message-ID: <20110721023227.6728.18390.stgit@notabene.brown>
References: <20110721022537.6728.90204.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110721022537.6728.90204.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Namhyung Kim <namhyung@gmail.com>
List-Id: linux-raid.ids

From: Namhyung Kim <namhyung@gmail.com>

page_address() returns void pointer, so the casts can be removed.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/md.c |   23 +++++++++++------------
 1 files changed, 11 insertions(+), 12 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index c7d9c6a..2a32050 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -1025,7 +1025,7 @@ static int super_90_load(mdk_rdev_t *rdev, mdk_rdev_t *refdev, int minor_version
 	ret = -EINVAL;
 
 	bdevname(rdev->bdev, b);
-	sb = (mdp_super_t*)page_address(rdev->sb_page);
+	sb = page_address(rdev->sb_page);
 
 	if (sb->md_magic != MD_SB_MAGIC) {
 		printk(KERN_ERR "md: invalid raid superblock magic on %s\n",
@@ -1064,7 +1064,7 @@ static int super_90_load(mdk_rdev_t *rdev, mdk_rdev_t *refdev, int minor_version
 		ret = 1;
 	} else {
 		__u64 ev1, ev2;
-		mdp_super_t *refsb = (mdp_super_t*)page_address(refdev->sb_page);
+		mdp_super_t *refsb = page_address(refdev->sb_page);
 		if (!uuid_equal(refsb, sb)) {
 			printk(KERN_WARNING "md: %s has different UUID to %s\n",
 				b, bdevname(refdev->bdev,b2));
@@ -1099,7 +1099,7 @@ static int super_90_load(mdk_rdev_t *rdev, mdk_rdev_t *refdev, int minor_version
 static int super_90_validate(mddev_t *mddev, mdk_rdev_t *rdev)
 {
 	mdp_disk_t *desc;
-	mdp_super_t *sb = (mdp_super_t *)page_address(rdev->sb_page);
+	mdp_super_t *sb = page_address(rdev->sb_page);
 	__u64 ev1 = md_event(sb);
 
 	rdev->raid_disk = -1;
@@ -1230,7 +1230,7 @@ static void super_90_sync(mddev_t *mddev, mdk_rdev_t *rdev)
 
 	rdev->sb_size = MD_SB_BYTES;
 
-	sb = (mdp_super_t*)page_address(rdev->sb_page);
+	sb = page_address(rdev->sb_page);
 
 	memset(sb, 0, sizeof(*sb));
 
@@ -1435,7 +1435,7 @@ static int super_1_load(mdk_rdev_t *rdev, mdk_rdev_t *refdev, int minor_version)
 	if (ret) return ret;
 
 
-	sb = (struct mdp_superblock_1*)page_address(rdev->sb_page);
+	sb = page_address(rdev->sb_page);
 
 	if (sb->magic != cpu_to_le32(MD_SB_MAGIC) ||
 	    sb->major_version != cpu_to_le32(1) ||
@@ -1477,8 +1477,7 @@ static int super_1_load(mdk_rdev_t *rdev, mdk_rdev_t *refdev, int minor_version)
 		ret = 1;
 	} else {
 		__u64 ev1, ev2;
-		struct mdp_superblock_1 *refsb = 
-			(struct mdp_superblock_1*)page_address(refdev->sb_page);
+		struct mdp_superblock_1 *refsb = page_address(refdev->sb_page);
 
 		if (memcmp(sb->set_uuid, refsb->set_uuid, 16) != 0 ||
 		    sb->level != refsb->level ||
@@ -1513,7 +1512,7 @@ static int super_1_load(mdk_rdev_t *rdev, mdk_rdev_t *refdev, int minor_version)
 
 static int super_1_validate(mddev_t *mddev, mdk_rdev_t *rdev)
 {
-	struct mdp_superblock_1 *sb = (struct mdp_superblock_1*)page_address(rdev->sb_page);
+	struct mdp_superblock_1 *sb = page_address(rdev->sb_page);
 	__u64 ev1 = le64_to_cpu(sb->events);
 
 	rdev->raid_disk = -1;
@@ -1619,7 +1618,7 @@ static void super_1_sync(mddev_t *mddev, mdk_rdev_t *rdev)
 	int max_dev, i;
 	/* make rdev->sb match mddev and rdev data. */
 
-	sb = (struct mdp_superblock_1*)page_address(rdev->sb_page);
+	sb = page_address(rdev->sb_page);
 
 	sb->feature_map = 0;
 	sb->pad0 = 0;
@@ -1724,7 +1723,7 @@ super_1_rdev_size_change(mdk_rdev_t *rdev, sector_t num_sectors)
 			num_sectors = max_sectors;
 		rdev->sb_start = sb_start;
 	}
-	sb = (struct mdp_superblock_1 *) page_address(rdev->sb_page);
+	sb = page_address(rdev->sb_page);
 	sb->data_size = cpu_to_le64(num_sectors);
 	sb->super_offset = rdev->sb_start;
 	sb->sb_csum = calc_sb_1_csum(sb);
@@ -2127,10 +2126,10 @@ static void print_rdev(mdk_rdev_t *rdev, int major_version)
 		printk(KERN_INFO "md: rdev superblock (MJ:%d):\n", major_version);
 		switch (major_version) {
 		case 0:
-			print_sb_90((mdp_super_t*)page_address(rdev->sb_page));
+			print_sb_90(page_address(rdev->sb_page));
 			break;
 		case 1:
-			print_sb_1((struct mdp_superblock_1 *)page_address(rdev->sb_page));
+			print_sb_1(page_address(rdev->sb_page));
 			break;
 		}
 	} else


