From: NeilBrown <neilb@suse.de>
Subject: [PATCH 003 of 3] md: Make sure rdev->size gets set for version-1 superblocks.
Date: Thu, 2 Feb 2006 17:02:15 +1100
Message-ID: <1060202060215.15984@suse.de>
References: <20060202165638.15890.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids


Sometimes it doesn't so make the code more like the version-0 code
which works.

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/md.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff ./drivers/md/md.c~current~ ./drivers/md/md.c
--- ./drivers/md/md.c~current~	2006-02-02 16:51:46.000000000 +1100
+++ ./drivers/md/md.c	2006-02-02 16:56:12.000000000 +1100
@@ -1025,7 +1025,7 @@ static int super_1_load(mdk_rdev_t *rdev
 		rdev-> sb_size = (rdev->sb_size | bmask)+1;
 
 	if (refdev == 0)
-		return 1;
+		ret = 1;
 	else {
 		__u64 ev1, ev2;
 		struct mdp_superblock_1 *refsb = 
@@ -1045,7 +1045,9 @@ static int super_1_load(mdk_rdev_t *rdev
 		ev2 = le64_to_cpu(refsb->events);
 
 		if (ev1 > ev2)
-			return 1;
+			ret = 1;
+		else
+			ret = 0;
 	}
 	if (minor_version) 
 		rdev->size = ((rdev->bdev->bd_inode->i_size>>9) - le64_to_cpu(sb->data_offset)) / 2;
@@ -1059,7 +1061,7 @@ static int super_1_load(mdk_rdev_t *rdev
 
 	if (le32_to_cpu(sb->size) > rdev->size*2)
 		return -EINVAL;
-	return 0;
+	return ret;
 }
 
 static int super_1_validate(mddev_t *mddev, mdk_rdev_t *rdev)
