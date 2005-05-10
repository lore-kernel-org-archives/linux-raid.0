From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH md 003 of 4] Two small fixes for md verion-1 superblocks.
Date: Tue, 10 May 2005 15:04:02 +1000
Message-ID: <E1DVMuY-0000Q0-MQ@notabene.cse.unsw.edu.au>
References: <20050510145931.1553.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


1/ Must typecast int to (sector_t) before inverting or we
 might not invert enough bits.

2/ When "bitmap_offset" was added to mdp_superblock_1, we didn't increase
   the count of words-used (96 to 100).

Signed-off-by: Neil Brown <neilb@cse.unsw.edu.au>

### Diffstat output
 ./drivers/md/md.c           |    2 +-
 ./include/linux/raid/md_p.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff ./drivers/md/md.c~current~ ./drivers/md/md.c
--- ./drivers/md/md.c~current~	2005-05-10 14:32:54.000000000 +1000
+++ ./drivers/md/md.c	2005-05-10 14:33:18.000000000 +1000
@@ -847,7 +847,7 @@ static int super_1_load(mdk_rdev_t *rdev
 	case 0:
 		sb_offset = rdev->bdev->bd_inode->i_size >> 9;
 		sb_offset -= 8*2;
-		sb_offset &= ~(4*2-1);
+		sb_offset &= ~(sector_t)(4*2-1);
 		/* convert from sectors to K */
 		sb_offset /= 2;
 		break;

diff ./include/linux/raid/md_p.h~current~ ./include/linux/raid/md_p.h
--- ./include/linux/raid/md_p.h~current~	2005-05-10 14:32:49.000000000 +1000
+++ ./include/linux/raid/md_p.h	2005-05-10 14:33:33.000000000 +1000
@@ -202,7 +202,7 @@ struct mdp_superblock_1 {
 				 * NOTE: signed, so bitmap can be before superblock
 				 * only meaningful of feature_map[0] is set.
 				 */
-	__u8	pad1[128-96];	/* set to 0 when written */
+	__u8	pad1[128-100];	/* set to 0 when written */
 
 	/* constant this-device information - 64 bytes */
 	__u64	data_offset;	/* sector start of data, often 0 */
