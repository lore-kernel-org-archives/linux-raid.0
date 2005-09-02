From: NeilBrown <neilb@suse.de>
Subject: [PATCH md 003 of 5] Use queue_hardsect_size instead of block_size for md superblock size calc.
Date: Fri, 02 Sep 2005 16:12:53 +1000
Message-ID: <E1EB4nF-0008ND-JB@notabene.cse.unsw.edu.au>
References: <20050902161106.32018.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Doh.  I want the physical hard-sector-size, not the current block size...

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/md.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff ./drivers/md/md.c~current~ ./drivers/md/md.c
--- ./drivers/md/md.c~current~	2005-09-02 15:59:39.000000000 +1000
+++ ./drivers/md/md.c	2005-09-02 15:59:46.000000000 +1000
@@ -898,7 +898,7 @@ static int super_1_load(mdk_rdev_t *rdev
 	rdev->data_offset = le64_to_cpu(sb->data_offset);
 
 	rdev->sb_size = le32_to_cpu(sb->max_dev) * 2 + 256;
-	bmask = block_size(rdev->bdev)-1;
+	bmask = queue_hardsect_size(rdev->bdev->bd_disk->queue)-1;
 	if (rdev->sb_size & bmask)
 		rdev-> sb_size = (rdev->sb_size | bmask)+1;
 
